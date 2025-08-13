import { Module } from '@nestjs/common';
import { databaseProviders } from './database/database.providers';
import { UserModule } from './user/user.module';
import { ListaModule } from './lista/lista.module';
import { ProdutoModule } from './produto/produto.module';
import { ItemModule } from './item/item.module';

@Module({
  imports: [UserModule, ProdutoModule, ItemModule, ListaModule],
  providers: [...databaseProviders],
  exports: [...databaseProviders],
})
export class AppModule {}
