import { Module } from '@nestjs/common';
import { ProdutoController } from './produto.controller';
import { ProdutoService } from './produto.service';
import { databaseProviders } from '../database/database.providers';

@Module({
  controllers: [ProdutoController],
  providers: [ProdutoService, ...databaseProviders],
  exports: [ProdutoService],
})
export class ProdutoModule {}