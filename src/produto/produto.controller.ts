import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { ProdutoService } from './produto.service';

@Controller('produtos')
export class ProdutoController {
  constructor(private readonly produtoService: ProdutoService) {}

  @Get()
  findAll() {
    return this.produtoService.findAll();
  }

  @Get('search/:nome')
  searchByName(@Param('nome') nome: string) {
    return this.produtoService.searchByName(nome);
  }

  @Get(':codigo')
  findOne(@Param('codigo') codigo: string) {
    return this.produtoService.findOne(Number(codigo));
  }

  @Post()
  create(@Body() body: { nome: string; preco_padrao?: number; info_nutri?: number }) {
    return this.produtoService.create(body.nome, body.preco_padrao, body.info_nutri);
  }

  @Put(':codigo')
  update(
    @Param('codigo') codigo: string,
    @Body() body: { nome: string; preco_padrao?: number; info_nutri?: number }
  ) {
    return this.produtoService.update(Number(codigo), body.nome, body.preco_padrao, body.info_nutri);
  }

  @Delete(':codigo')
  delete(@Param('codigo') codigo: string) {
    return this.produtoService.delete(Number(codigo));
  }
}
