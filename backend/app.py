import os
import tempfile
from flask import Flask, jsonify, request
from flask_cors import CORS
from dotenv import load_dotenv
import redis
from azure.storage.blob import BlobServiceClient, ContentSettings

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# Redis connection
redis_client = redis.Redis(
    host=os.getenv('REDIS_HOST', 'redis'),
    port=int(os.getenv('REDIS_PORT', 6379)),
    decode_responses=True
)

# Azure Blob Storage client
connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
blob_service_client = BlobServiceClient.from_connection_string(connect_str)
container_name = os.getenv('BLOB_CONTAINER_NAME', 'uploads')

# Create container if it doesn't exist
try:
    container_client = blob_service_client.get_container_client(container_name)
    # Create if not exists
    if not container_client.exists():
        container_client = blob_service_client.create_container(container_name)
        print(f"Created container: {container_name}")
    else:
        print(f"Container already exists: {container_name}")
except Exception as e:
    print(f"Error with container: {str(e)}")

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({
        'status': 'ok',
        'services': {
            'backend': 'running',
            'redis': check_redis_connection(),
            'azurite': check_azure_connection()
        }
    })

@app.route('/redis-test', methods=['GET'])
def redis_test():
    try:
        # Increment a counter in Redis
        count = redis_client.incr('visit_count')
        return jsonify({
            'message': 'Redis connection successful',
            'visit_count': count
        })
    except Exception as e:
        return jsonify({
            'message': 'Redis connection failed',
            'error': str(e)
        }), 500

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        # Create a temporary file to store the upload
        with tempfile.NamedTemporaryFile(delete=False) as temp:
            file.save(temp.name)
            temp_path = temp.name

        # Upload to Azure Blob Storage
        blob_name = file.filename
        blob_client = blob_service_client.get_blob_client(
            container=container_name,
            blob=blob_name
        )

        # Upload the file with content settings based on file type
        content_type = file.content_type or 'application/octet-stream'
        with open(temp_path, "rb") as data:
            blob_client.upload_blob(
                data,
                overwrite=True,
                content_settings=ContentSettings(content_type=content_type)
            )

        # Clean up the temp file
        os.unlink(temp_path)

        # Store file reference in Redis
        redis_client.hset(
            f"file:{blob_name}",
            mapping={
                "name": blob_name,
                "url": f"http://azurite:10000/{container_name}/{blob_name}",
                "content_type": content_type,
                "upload_time": os.getenv('CURRENT_TIME', 'unknown')
            }
        )

        return jsonify({
            'message': 'File uploaded successfully',
            'file_name': blob_name,
            'blob_url': blob_client.url,
            'container': container_name
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500


def check_redis_connection():
    try:
        redis_client.ping()
        return 'connected'
    except Exception:
        return 'disconnected'


def check_azure_connection():
    try:
        # Just check if we can list containers
        list(blob_service_client.list_containers(max_results=1))
        return 'connected'
    except Exception:
        return 'disconnected'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
