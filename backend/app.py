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
    try:
        if os.getenv('REDIS_PASSWORD') is None:
            logger.info("Using HTTP mode for Redis connection")
            redis_host = os.getenv('REDIS_HOST', 'redis')
            redis_port = int(os.getenv('REDIS_PORT', 6379))
            logger.info(f"Connecting to Redis at {redis_host}:{redis_port}")
            return redis.Redis(
                host=redis_host,
                port=redis_port,
                decode_responses=True,
                socket_timeout=30,
                socket_connect_timeout=30
            )
        else:
            logger.info("Using HTTPS mode for Redis connection")
            redis_host = os.getenv('REDIS_HOST', 'redis')
            redis_port = int(os.getenv('REDIS_PORT', 6379))
            logger.info(f"Connecting to Redis at {redis_host}:{redis_port} with SSL")
            return redis.Redis(
                host=redis_host,
                port=redis_port,
                password=os.getenv('REDIS_PASSWORD'),
                ssl=True,
                decode_responses=True,
                socket_timeout=30,
                socket_connect_timeout=30
            )
    except Exception as e:
        logger.error(f"Error creating Redis client: {str(e)}")
        return None

try:
    redis_client = create_redis_client()
    if redis_client:
        redis_client.ping()
        logger.info("Redis connection established successfully")
    else:
        logger.warning("Failed to create Redis client")
except Exception as e:
    logger.error(f"Redis initialization error: {str(e)}")
    redis_client = None

try:
    connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
    if not connect_str:
        logger.warning("Azure storage connection string not found")
        blob_service_client = None
    else:
        blob_service_client = BlobServiceClient.from_connection_string(connect_str)
        container_name = os.getenv('BLOB_CONTAINER_NAME', 'uploads')
        logger.info(f"Azure Blob Storage initialized with container: {container_name}")
except Exception as e:
    logger.error(f"Azure Blob Storage initialization error: {str(e)}")
    blob_service_client = None
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
    if redis_client is None:
        logger.error("Redis client is not initialized")
        return jsonify({
            'message': 'Redis client is not initialized',
            'error': 'Connection not available'
        }), 500

    try:
        count = redis_client.incr('visit_count')
        logger.info(f"Redis visit count: {count}")
        return jsonify({
            'message': 'Redis connection successful',
            'visit_count': count
        })
    except redis.exceptions.ConnectionError as e:
        logger.error(f"Redis connection error: {str(e)}")
        return jsonify({
            'message': 'Redis connection failed',
            'error': str(e)
        }), 500
    except redis.exceptions.TimeoutError as e:
        logger.error(f"Redis timeout error: {str(e)}")
        return jsonify({
            'message': 'Redis connection timed out',
            'error': str(e)
        }), 500
    except Exception as e:
        logger.error(f"Unexpected Redis error: {str(e)}")
        return jsonify({
            'message': 'Redis operation failed',
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
            "url": blob_client.url,
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
