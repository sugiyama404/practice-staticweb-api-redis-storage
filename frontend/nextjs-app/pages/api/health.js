import axios from 'axios';

export default async function handler(req, res) {
    try {
        const backendUrl = process.env.BACKEND_URL || 'http://backend:8000';
        const response = await axios.get(`${backendUrl}/health`);
        res.status(response.status).json(response.data);
    } catch (error) {
        console.error('Error checking health:', error.message);
        res.status(error.response?.status || 500).json({
            error: error.message
        });
    }
}
