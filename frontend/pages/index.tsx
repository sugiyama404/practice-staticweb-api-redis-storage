import * as React from 'react';
import { useState } from 'react';
import { apiClient, uploadFile } from '../src/utils/api';
import { HealthStatus, RedisTestResponse, UploadResponse } from '../src/types';
import styles from '../src/styles/Home.module.css';

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
        <div className={styles.container}>
            <div className={styles.card}>
                <h1 className={styles.title}>Flask Backend Interaction</h1>

                <div className={styles.section}>
                    <button onClick={checkHealth} className={`${styles.button} ${styles.blue}`}>
                        Check Health
                    </button>
                    {healthStatus && (
                        <p className={`${styles.status} ${styles.success}`}>
                            Status: {healthStatus.status}
                        </p>
                    )}
                </div>

                <div className={styles.section}>
                    <button onClick={checkRedis} className={`${styles.button} ${styles.green}`}>
                        Check Redis
                    </button>
                    {visitCount !== null && (
                        <p className={`${styles.status} ${styles.info}`}>
                            Visit Count: {visitCount}
                        </p>
                    )}
                </div>

                <div className={styles.section}>
                    <label className={styles.label}>Upload a file</label>
                    <input type="file" onChange={handleFileUpload} className={styles['file-input']} />
                    {uploadedFile && (
                        <div className={styles['upload-result']}>
                            <p>
                                <strong>Uploaded File:</strong>{' '}
                                <span className={styles.purple}>{uploadedFile.file_name}</span>
                            </p>
                            <p>
                                URL:{' '}
                                <a
                                    href={uploadedFile.blob_url}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                >
                                    {uploadedFile.blob_url}
                                </a>
                            </p>
                            <p>
                                Container:{' '}
                                <span className={styles.purple}>{uploadedFile.container}</span>
                            </p>
                        </div>
                    )}
                </div>

                {error && <p className={styles.error}>{error}</p>}
            </div>
        </div>
    );
}
