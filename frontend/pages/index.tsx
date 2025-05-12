import * as React from 'react';
import { useState } from 'react';
import { apiClient, uploadFile } from '../src/utils/api';
import { HealthStatus, RedisTestResponse, UploadResponse } from '../src/types';

export default function Home() {
    const [healthStatus, setHealthStatus] = useState<HealthStatus | null>(null);
    const [visitCount, setVisitCount] = useState<number | null>(null);
    const [uploadedFile, setUploadedFile] = useState<UploadResponse | null>(null);
    const [error, setError] = useState<string | null>(null);

    const checkHealth = async () => {
        try {
            const response = await apiClient.get<HealthStatus>('/health');
            setHealthStatus(response.data);
            setError(null);
        } catch (err) {
            setError('Failed to check health');
            console.error(err);
        }
    };

    const checkRedis = async () => {
        try {
            const response = await apiClient.get<RedisTestResponse>('/redis-test');
            setVisitCount(response.data.visit_count);
            setError(null);
        } catch (err) {
            setError('Failed to check Redis');
            console.error(err);
        }
    };

    const handleFileUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
        const file = event.target.files?.[0];
        if (file) {
            try {
                const uploadResult = await uploadFile(file);
                setUploadedFile(uploadResult);
                setError(null);
            } catch (err) {
                setError('File upload failed');
                console.error(err);
            }
        }
    };

    return (
        <div className="container mx-auto p-4">
            <h1 className="text-2xl font-bold mb-4">Flask Backend Interaction</h1>

            <div className="mb-4">
                <button
                    onClick={checkHealth}
                    className="bg-blue-500 text-white px-4 py-2 rounded mr-2"
                >
                    Check Health
                </button>
                {healthStatus && (
                    <div>
                        <p>Status: {healthStatus.status}</p>
                        {healthStatus.services && typeof healthStatus.services === 'object' && !Array.isArray(healthStatus.services) ? (
                            <div>
                                {Object.entries(healthStatus.services).map(([service, status]) => (
                                    <React.Fragment key={service}>
                                        <p>{service}: {String(status)}</p>
                                    </React.Fragment>
                                ))}
                            </div>
                        ) : (
                            healthStatus.services && <p>Services: {healthStatus.services.join(', ')}</p>
                        )}
                    </div>
                )}
            </div>

            <div className="mb-4">
                <button
                    onClick={checkRedis}
                    className="bg-green-500 text-white px-4 py-2 rounded mr-2"
                >
                    Check Redis
                </button>
                {visitCount !== null && (
                    <p>Visit Count: {visitCount}</p>
                )}
            </div>

            <div>
                <input
                    type="file"
                    onChange={handleFileUpload}
                    className="mb-2"
                />
                {uploadedFile && (
                    <div>
                        <p>Uploaded File: {uploadedFile.file_name}</p>
                        <p>URL: {uploadedFile.blob_url}</p>
                        <p>Container: {uploadedFile.container}</p>
                    </div>
                )}
            </div>

            {error && (
                <div className="text-red-500 mt-4">
                    {error}
                </div>
            )}
        </div>
    );
}
