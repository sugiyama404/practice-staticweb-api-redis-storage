import formidable from 'formidable';
import fs from 'fs';
import axios from 'axios';
import { createReadStream } from 'fs';
import FormData from 'form-data';

// Disable body parsing for this route
export const config = {
    api: {
        bodyParser: false,
    },
};

export default async function handler(req, res) {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    try {
        // Parse form with formidable
        const form = new formidable.IncomingForm();
        const [fields, files] = await form.parse(req);

        const file = files.file?.[0];

        if (!file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }

        // Create form data for backend request
        const formData = new FormData();
        formData.append('file', createReadStream(file.filepath), {
            filename: file.originalFilename,
            contentType: file.mimetype,
        });

        // Send to backend
        const backendUrl = process.env.BACKEND_URL || 'http://backend:8000';
        const response = await axios.post(`${backendUrl}/upload`, formData, {
            headers: {
                ...formData.getHeaders(),
            },
        });

        // Clean up temporary file
        fs.unlinkSync(file.filepath);

        // Return response from backend
        return res.status(response.status).json(response.data);
    } catch (error) {
        console.error('Error uploading file to backend:', error.message);
        return res.status(error.response?.status || 500).json({
            error: error.message
        });
    }
}
