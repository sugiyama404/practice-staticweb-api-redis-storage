import { useState } from 'react';
import Head from 'next/head';

export default function Home() {
    const [response, setResponse] = useState('');
    const [uploadStatus, setUploadStatus] = useState('');

    const testRedis = async () => {
        try {
            const res = await fetch('/api/redis-test');
            const data = await res.json();
            setResponse(JSON.stringify(data, null, 2));
        } catch (error) {
            setResponse(`Error: ${error.message}`);
        }
    };

    const testHealth = async () => {
        try {
            const res = await fetch('/api/health');
            const data = await res.json();
            setResponse(JSON.stringify(data, null, 2));
        } catch (error) {
            setResponse(`Error: ${error.message}`);
        }
    };

    const handleFileUpload = async (e) => {
        e.preventDefault();
        const fileInput = document.getElementById('fileInput');
        const file = fileInput.files[0];

        if (!file) {
            setUploadStatus('Please select a file');
            return;
        }

        const formData = new FormData();
        formData.append('file', file);

        try {
            const res = await fetch('/api/upload', {
                method: 'POST',
                body: formData
            });
            const data = await res.json();
            setUploadStatus(JSON.stringify(data, null, 2));
        } catch (error) {
            setUploadStatus(`Error: ${error.message}`);
        }
    };

    return (
        <div className="container">
            <Head>
                <title>Docker Compose Demo</title>
                <meta name="description" content="Docker Compose Full Stack Demo" />
                <link rel="icon" href="/favicon.ico" />
            </Head>

            <main>
                <h1>Docker Compose Full Stack Demo</h1>

                <div className="card">
                    <h2>Backend API Test</h2>
                    <button onClick={testRedis}>Test Redis Connection</button>
                    <button onClick={testHealth}>Test Health Check</button>
                    <pre className="response">{response}</pre>
                </div>

                <div className="card">
                    <h2>Azure Blob Storage Test</h2>
                    <form className="file-form" onSubmit={handleFileUpload}>
                        <input type="file" id="fileInput" />
                        <button type="submit">Upload to Azure Storage</button>
                    </form>
                    <pre className="response">{uploadStatus}</pre>
                </div>
            </main>
        </div>
    );
}
