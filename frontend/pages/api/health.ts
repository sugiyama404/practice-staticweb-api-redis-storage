import type { NextApiRequest, NextApiResponse } from 'next';
import { apiClient } from '../../src/utils/api';
import { HealthStatus } from '../../src/types';

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse<HealthStatus>
) {
    try {
        const response = await apiClient.get<HealthStatus>('/health');
        res.status(200).json(response.data);
    } catch (error) {
        res.status(500).json({ status: 'error' });
    }
}
