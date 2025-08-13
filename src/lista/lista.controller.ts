import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { ListaService } from './lista.service';

@Controller('listas')
export class ListaController {
  constructor(private readonly listaService: ListaService) {}

  @Get(':usuarioId')
  findAll(@Param('usuarioId') usuarioId: string) {
    return this.listaService.findAllLists(Number(usuarioId));
  }

  @Post()
  create(@Body() body: { nome: string, usuarioId: string }) {
    return this.listaService.createList(body.nome, Number(body.usuarioId));
  }

  @Put(':codigo')
  update(@Param('codigo') codigo: string, @Body() body: { nome: string }) {
    return this.listaService.updateList(Number(codigo), body.nome);
  }

  @Delete(':codigo')
  delete(@Param('codigo') codigo: string) {
    return this.listaService.deleteList(Number(codigo));
  }

  @Get(':codigo/produtos')
  getProdutos(@Param('codigo') codigo: string) {
    return this.listaService.getProdutosByLista(Number(codigo));
  }

  @Post(':codigo/itens')
  async addItemToLista(
    @Param('codigo') codigo_lista: string,
    @Body() body: { produto_codigo: number; quantidade: number; preco: number; data_validade?: string | null; marca?: string | null },
  ) {
    // Cria item vinculado a um produto existente
    const item = await this.listaService.createItem(body.preco, body.quantidade, body.data_validade ?? null, body.produto_codigo, body.marca ?? null);

    // Adiciona item à lista
    await this.listaService.addItemToLista(Number(codigo_lista), item.codigo);

    return { item };
  }

  @Delete(':codigo/produtos/:itemCodigo')
  removeProdutoFromLista(
    @Param('codigo') codigo_lista: string,
    @Param('itemCodigo') itemCodigo: string,
  ) {
    return this.listaService.removeItemFromLista(Number(codigo_lista), Number(itemCodigo));
  }
}