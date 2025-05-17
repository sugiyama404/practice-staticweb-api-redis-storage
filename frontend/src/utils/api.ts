import axios from 'axios';

const isServer = typeof window === 'undefined';
let BACKEND_URL = '';
if (isServer) {
    BACKEND_URL = process?.env?.BACKEND_URL || 'http://backend:8000';
} else {
    BACKEND_URL = '/api';
}

export const apiClient = axios.create({
    baseURL: BACKEND_URL,
    headers: {
        'Content-Type': 'application/json',
    },
});

export const uploadFile = async (file: File) => {
    const formData = new FormData();
    formData.append('file', file);

    try {
        const response = await apiClient.post('/upload', formData, {
            headers: {
                'Content-Type': 'multipart/form-data',
            },
        });
        return response.data;
    } catch (error) {
        console.error('File upload error:', error);
        throw error;
    }
};
