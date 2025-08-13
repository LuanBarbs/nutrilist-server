import { Injectable, Inject } from '@nestjs/common';
import { Pool } from 'pg';
import { ProdutoService } from '../produto/produto.service';
import { ItemService } from '../item/item.service';

@Injectable()
export class ListaService {
    constructor(
        @Inject('PG_CONNECTION') private pool: Pool,
        private produtoService: ProdutoService,
        private itemService: ItemService
    ) {}

    // Listar todas listas
    async findAllLists(usuarioId: number) {
        const sql = 'SELECT * FROM ListaCompra WHERE user_id = $1 ORDER BY data_criacao DESC';
        const result = await this.pool.query(sql, [usuarioId]);
        return result.rows;
    }

    // Criar lista
    async createList(nome: string, usuarioId: number) {
        const date = new Date();
        const sql = 'INSERT INTO ListaCompra (nome, data_criacao, user_id) VALUES ($1, $2, $3) RETURNING *';
        const result = await this.pool.query(sql, [nome, date, usuarioId]);
        return result.rows[0];
    }

    // Atualizar lista
    async updateList(codigo: number, nome: string) {
        const sql = 'UPDATE ListaCompra SET nome=$1 WHERE codigo=$2 RETURNING *';
        const result = await this.pool.query(sql, [nome, codigo]);
        return result.rows[0];
    }

    // Excluir lista
    async deleteList(codigo: number) {
        await this.pool.query('DELETE FROM ListaItem WHERE codigo_lista=$1', [codigo]);
        await this.pool.query('DELETE FROM ListaCompra WHERE codigo=$1', [codigo]);
        return { deleted: true };
    }

    // Itens relacionados a lista
    async getProdutosByLista(codigo_lista: number) {
        const sql = `
            SELECT i.codigo, i.preco, i.data_validade, i.produto_remetente, i.quantidade, i.marca, p.nome AS produto_nome, p.preco_padrao
            FROM ListaItem li
            JOIN Item i ON li.codigo_item = i.codigo
            JOIN Produto p ON i.produto_remetente = p.codigo
            WHERE li.codigo_lista = $1
        `;
        const result = await this.pool.query(sql, [codigo_lista]);
        return result.rows;
    }

    // Criar produto usando o ProdutoService
    async createProduto(nome: string, preco_padrao?: number) {
        return await this.produtoService.create(nome, preco_padrao);
    }

    // Criar item usando o ItemService
    async createItem(preco: number, quantidade: number, data_validade: string | null, produto_remetente: number, marca: string | null) {
        return await this.itemService.create(preco, quantidade, data_validade, produto_remetente, marca);
    }

    // Adicionar item à lista
    async addItemToLista(codigo_lista: number, codigo_item: number) {
        const sql = 'INSERT INTO ListaItem (codigo_lista, codigo_item) VALUES ($1, $2)';
        await this.pool.query(sql, [codigo_lista, codigo_item]);
        return { added: true };
    }

    // Remover item da lista
    async removeItemFromLista(codigo_lista: number, codigo_item: number) {
        const sql = 'DELETE FROM ListaItem WHERE codigo_lista=$1 AND codigo_item=$2';
        await this.pool.query(sql, [codigo_lista, codigo_item]);
        return { removed: true };
    }
}