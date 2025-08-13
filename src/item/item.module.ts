import { Module } from '@nestjs/common';
import { ItemController } from './item.controller';
import { ItemService } from './item.service';
import { databaseProviders } from '../database/database.providers';

@Module({
  controllers: [ItemController],
  providers: [ItemService, ...databaseProviders],
  exports: [ItemService],
})
export class ItemModule {}
