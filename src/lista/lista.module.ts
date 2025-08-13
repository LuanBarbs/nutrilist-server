import { Module } from '@nestjs/common';
import { ListaService } from './lista.service';
import { ListaController } from './lista.controller';
import { databaseProviders } from '../database/database.providers';
import { ProdutoModule } from '../produto/produto.module';
import { ItemModule } from '../item/item.module';

@Module({
  imports: [ProdutoModule, ItemModule],
  providers: [ListaService, ...databaseProviders],
  controllers: [ListaController],
})
export class ListaModule {}