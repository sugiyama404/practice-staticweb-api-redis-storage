export interface HealthStatus {
    status: string;
}

export interface RedisTestResponse {
    visit_count: number;
}

export interface UploadResponse {
    file_name: string;
    blob_url: string;
    container: string;
}
