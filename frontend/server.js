require('dotenv').config();
const express = require('express');
const path = require('path');
const axios = require('axios');

const app = express();
const PORT = process.env.PORT || 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://backend:8000';

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));

// API proxy for backend
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
