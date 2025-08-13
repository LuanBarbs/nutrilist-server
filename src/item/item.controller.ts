import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { ItemService } from './item.service';

@Controller('itens')
export class ItemController {
  constructor(private readonly itemService: ItemService) {}

  @Get()
  findAll() {
    return this.itemService.findAll();
  }

  @Get('produto/:produtoCodigo')
  findByProduto(@Param('produtoCodigo') produtoCodigo: string) {
    return this.itemService.findByProduto(Number(produtoCodigo));
  }

  @Get(':codigo')
  findOne(@Param('codigo') codigo: string) {
    return this.itemService.findOne(Number(codigo));
  }

  @Post()
  create(@Body() body: { preco: number; quantidade: number; data_validade?: string | null; produto_remetente: number; marca: string | null }) {
    return this.itemService.create(body.preco, body.quantidade, body.data_validade ?? null, body.produto_remetente, body.marca);
  }

  @Put(':codigo')
  update(
    @Param('codigo') codigo: string,
    @Body() body: { preco: number; quantidade: number; data_validade?: string | null; marca?: string | null }
  ) {
    return this.itemService.update(Number(codigo), body.preco, body.quantidade, body.data_validade ?? null, body.marca ?? null);
  }

  @Delete(':codigo')
  delete(@Param('codigo') codigo: string) {
    return this.itemService.delete(Number(codigo));
  }
}
