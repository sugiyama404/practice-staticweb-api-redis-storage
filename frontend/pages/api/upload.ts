import type { NextApiRequest, NextApiResponse } from 'next';
import formidable from 'formidable';
import fs from 'fs';
import { UploadResponse } from '../../src/types';
import axios from 'axios';

export const config = {
    api: {
        bodyParser: false,
    },
};

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse<UploadResponse | { error: string }>
) {
    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method not allowed' });
    }

    const form = new formidable.IncomingForm();

    form.parse(req, async (err, fields, files) => {
        if (err) {
            return res.status(500).json({ error: 'File upload failed' });
        }

        // formidableの型: files.file は File | File[] | undefined
        const fileField = files.file;
        const file = Array.isArray(fileField) ? fileField[0] : fileField;

        if (!file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }

        try {
            const backendUrl = process.env.BACKEND_URL || 'http://backend:8000';
            const formData = new FormData();
            const data = new (require('form-data'))();
            data.append('file', fs.createReadStream(file.filepath), file.originalFilename || 'uploaded_file');

            const response = await axios.post(`${backendUrl}/upload`, data, {
                headers: data.getHeaders(),
            });

            res.status(200).json(response.data);
        } catch (error) {
            console.error('Upload error:', error);
            res.status(500).json({ error: 'File upload to backend failed' });
        }
    });
}
