import { Pool } from 'pg';

export const databaseProviders = [
    {
        provide: 'PG_CONNECTION',
        useFactory: async () => {
            const pool = new Pool({
                user: 'postgres',
                host: 'localhost',
                database: 'nutrilist_db',
                password: 'Luan75200423*',
                port: '5432',
            });
            return pool;
        },
    },
];