import os
import tempfile
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
import redis
from azure.storage.blob import BlobServiceClient, ContentSettings
import datetime

load_dotenv()

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}})

import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
logger.info("Starting Flask app...")

def create_redis_client():
    if os.getenv('REDIS_PASSWORD') is None:
        logger.info("http mode")
        return redis.Redis(
            host=os.getenv('REDIS_HOST', 'redis'),
            port=int(os.getenv('REDIS_PORT', 6379)),
            decode_responses=True
        )
    else:
        logger.info("https mode")
        return redis.Redis(
            host=os.getenv('REDIS_HOST', 'redis'),
            port=int(os.getenv('REDIS_PORT', 6379)),
            password=os.getenv('REDIS_PASSWORD'),
            ssl=True,
            decode_responses=True
        )

redis_client = create_redis_client()

connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
blob_service_client = BlobServiceClient.from_connection_string(connect_str)
container_name = os.getenv('BLOB_CONTAINER_NAME', 'uploads')

@app.route('/health', methods=['GET'])
def health_check():
    logger.info("Health check endpoint called")
    return jsonify({
        'status': 'ok'
    })

@app.route('/redis-test', methods=['GET'])
def redis_test():
    logger.info("Redis test endpoint called")
    try:
        count = redis_client.incr('visit_count')
        logger.info(f"Redis visit count: {count}")
        return jsonify({
            'message': 'Redis connection successful',
            'visit_count': count
        })
    except Exception as e:
        logger.error(f"Redis connection error: {str(e)}")
        return jsonify({
            'message': 'Redis connection failed',
            'error': str(e)
        }), 500

@app.route('/upload', methods=['POST'])
def upload_file():
    logger.info("Upload endpoint called")
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        with tempfile.NamedTemporaryFile(delete=False) as temp:
            file.save(temp.name)
            temp_path = temp.name

        blob_name = file.filename
        blob_client = blob_service_client.get_blob_client(
            container=container_name,
            blob=blob_name
        )

        content_type = file.content_type or 'application/octet-stream'
        with open(temp_path, "rb") as data:
            blob_client.upload_blob(
                data,
                overwrite=True,
                content_settings=ContentSettings(content_type=content_type)
            )

        os.unlink(temp_path)

        current_time = datetime.datetime.now().isoformat()
        redis_client.hset(
            f"file:{blob_name}",
            mapping={
            "name": blob_name,
            "url": f"http://azurite:10000/{container_name}/{blob_name}",
            "content_type": content_type,
            "upload_time": current_time
            }
        )

        return jsonify({
            'message': 'File uploaded successfully',
            'file_name': blob_name,
            'blob_url': blob_client.url,
            'container': container_name
        })

    except Exception as e:
        logger.error(f"Upload error: {str(e)}")
        return jsonify({'error': str(e)}), 500



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
