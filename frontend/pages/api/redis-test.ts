import type { NextApiRequest, NextApiResponse } from 'next';
import { apiClient } from '../utils/api';
import { RedisTestResponse } from '../types';

export default async function handler(
    req: NextApiRequest,
    res: NextApiResponse<RedisTestResponse>
) {
    try {
        const response = await apiClient.get<RedisTestResponse>('/redis-test');
        res.status(200).json(response.data);
    } catch (error) {
        res.status(500).json({ visit_count: -1 });
    }
}
