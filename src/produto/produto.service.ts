import { Injectable, Inject } from '@nestjs/common';
import { Pool } from 'pg';

@Injectable()
export class ProdutoService {
    constructor(@Inject('PG_CONNECTION') private pool: Pool) {}

    // Buscar todos os produtos
    async findAll() {
        const sql = 'SELECT * FROM Produto ORDER BY nome';
        const result = await this.pool.query(sql);
        return result.rows;
    }

    // Buscar produto por código
    async findOne(codigo: number) {
        const sql = 'SELECT * FROM Produto WHERE codigo = $1';
        const result = await this.pool.query(sql, [codigo]);
        return result.rows[0];
    }

    // Criar produto
    async create(nome: string, preco_padrao?: number, info_nutri?: number) {
        const sql = 'INSERT INTO Produto (nome, preco_padrao, info_nutri) VALUES ($1, $2, $3) RETURNING *';
        const result = await this.pool.query(sql, [nome, preco_padrao ?? null, info_nutri ?? null]);
        return result.rows[0];
    }

    // Atualizar produto
    async update(codigo: number, nome: string, preco_padrao?: number, info_nutri?: number) {
        const sql = 'UPDATE Produto SET nome = $1, marca = $2, preco_padrao = $3, info_nutri = $4 WHERE codigo = $5 RETURNING *';
        const result = await this.pool.query(sql, [nome, preco_padrao ?? null, info_nutri ?? null, codigo]);
        return result.rows[0];
    }

    // Deletar produto
    async delete(codigo: number) {
        await this.pool.query('DELETE FROM Produto WHERE codigo = $1', [codigo]);
        return { deleted: true };
    }

    // Buscar produtos por nome (para busca)
    async searchByName(nome: string) {
        const sql = 'SELECT * FROM Produto WHERE LOWER(nome) LIKE LOWER($1) ORDER BY nome';
        const result = await this.pool.query(sql, [`%${nome}%`]);
        return result.rows;
    }
}
