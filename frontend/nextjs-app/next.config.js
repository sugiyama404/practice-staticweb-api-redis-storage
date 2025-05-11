/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    swcMinify: true,
    env: {
        BACKEND_URL: process.env.BACKEND_URL || 'http://backend:8000',
    },
    async rewrites() {
        return [
            {
                source: '/api/:path*',
                destination: `${process.env.BACKEND_URL || 'http://backend:8000'}/:path*`,
            },
        ];
    },
}

module.exports = nextConfig;
