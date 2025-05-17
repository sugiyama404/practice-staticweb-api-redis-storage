# practice-staticweb-api-redis-storage

# Local Development Environment with Docker Compose

This project sets up a complete local development environment using Docker Compose with the following architecture:

- **Frontend**: Next.js React framework
- **Backend**: Flask API
- **Cache**: Redis
- **Storage**: Azurite (Azure Storage Emulator)

## Prerequisites

- Docker and Docker Compose installed on your machine
- Git (optional, for version control)

## Getting Started

1. Clone this repository (or download the files)
2. Run the application stack:

```bash
docker compose up
```

3. To run in the background:

```bash
docker compose up -d
```

4. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000
   - Azurite Blob Storage: http://localhost:10000

## Available Services

### Frontend (port 3000)
- Next.js React application
- Server-side rendering (SSR) support
- Proxies API requests to the backend using Next.js API routes

### Backend API (port 8000)
- Flask API with endpoints:
  - `/health` - Health check of all services
  - `/redis-test` - Test Redis connection
  - `/upload` - Upload files to Azure Blob Storage

### Redis (port 6379)
- In-memory data structure store
- Used for caching

### Azurite (port 10000)
- Local Azure Storage emulator
- Blob storage endpoint

## Environment Variables

Environment variables are loaded from a `.env` file. This serves as a local replacement for Azure Key Vault in a production environment.

## Development Workflow

1. Make changes to the frontend or backend code
2. The changes will be automatically picked up due to volume mounting
3. For npm package or Python dependency changes, you'll need to rebuild:

```bash
docker compose up --build
```

## Stopping the Services

```bash
docker compose down
```

To remove all data volumes as well:

```bash
docker compose down -v
```
