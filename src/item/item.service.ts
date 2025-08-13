import { Injectable, Inject } from '@nestjs/common';
import { Pool } from 'pg';

@Injectable()
export class ItemService {
    constructor(@Inject('PG_CONNECTION') private pool: Pool) {}

    // Buscar todos os itens
    async findAll() {
        const sql = `
            SELECT i.*, p.nome as produto_nome, p.marca, p.preco_padrao
            FROM Item i
            JOIN Produto p ON i.produto_remetente = p.codigo
            ORDER BY i.codigo
        `;
        const result = await this.pool.query(sql);
        return result.rows;
    }

    // Buscar item por código
    async findOne(codigo: number) {
        const sql = `
            SELECT i.*, p.nome as produto_nome, p.marca, p.preco_padrao
            FROM Item i
            JOIN Produto p ON i.produto_remetente = p.codigo
            WHERE i.codigo = $1
        `;
        const result = await this.pool.query(sql, [codigo]);
        return result.rows[0];
    }

    // Criar item
    async create(preco: number, quantidade: number, data_validade: string | null, produto_remetente: number, marca: string | null) {
        const sql = 'INSERT INTO Item (preco, quantidade, data_validade, produto_remetente, marca) VALUES ($1, $2, $3, $4, $5) RETURNING *';
        const result = await this.pool.query(sql, [preco, quantidade, data_validade, produto_remetente, marca]);
        return result.rows[0];
    }

    // Atualizar item
    async update(codigo: number, quantidade: number, preco: number, data_validade: string | null, marca: string | null) {
        const sql = 'UPDATE Item SET preco = $1, quantidade = $2, data_validade = $3, marca = $4 WHERE codigo = $5 RETURNING *';
        const result = await this.pool.query(sql, [preco, quantidade, data_validade, marca, codigo]);
        return result.rows[0];
    }

    // Deletar item
    async delete(codigo: number) {
        await this.pool.query('DELETE FROM Item WHERE codigo = $1', [codigo]);
        return { deleted: true };
    }

    // Buscar itens por produto
    async findByProduto(produto_codigo: number) {
        const sql = `
            SELECT i.*, p.nome as produto_nome, p.marca, p.preco_padrao
            FROM Item i
            JOIN Produto p ON i.produto_remetente = p.codigo
            WHERE i.produto_remetente = $1
            ORDER BY i.codigo
        `;
        const result = await this.pool.query(sql, [produto_codigo]);
        return result.rows;
    }
}
