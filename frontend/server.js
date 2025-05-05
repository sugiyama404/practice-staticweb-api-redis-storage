require('dotenv').config();
const express = require('express');
const path = require('path');
const axios = require('axios');
const multer = require('multer');
const FormData = require('form-data');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend:8000';

// Temporary storage for uploaded files
const upload = multer({ dest: 'uploads/' });

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// Special handler for file uploads
app.post('/api/upload', upload.single('file'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }

        // Create form data
        const formData = new FormData();
        formData.append('file', fs.createReadStream(req.file.path));

        // Send file to backend
        const response = await axios.post(`${BACKEND_URL}/upload`, formData, {
            headers: {
                ...formData.getHeaders()
            }
        });

        // Clean up temporary file
        fs.unlinkSync(req.file.path);

        // Return response
        res.status(response.status).json(response.data);
    } catch (error) {
        console.error('Error uploading file to backend:', error.message);
        res.status(error.response?.status || 500).json({ error: error.message });
    }
});

// API proxy for other backend requests
app.use('/api', async (req, res) => {
    try {
        const response = await axios({
            method: req.method,
            url: `${BACKEND_URL}${req.url}`,
            data: req.body,
            headers: {
                'Content-Type': 'application/json',
            },
        });
        res.status(response.status).json(response.data);
    } catch (error) {
        console.error('Error proxying to backend:', error.message);
        res.status(error.response?.status || 500).json({ error: error.message });
    }
});

// Catch-all to serve the frontend for client-side routing
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Frontend server running on http://localhost:${PORT}`);
});
