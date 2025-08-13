import { Controller, Get, Post, Body, BadRequestException } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  async findAll() {
    return this.userService.getUsers();
  }

  @Post()
  async create(@Body() body) {
    return this.userService.createUser(body);
  }

  @Post('login')
  async login(@Body() body) {
    try {
      const user = await this.userService.validateUser(body.email, body.senha);
      return { success: true, user };
    } catch (error) {
      throw new BadRequestException(error.message);
    }
  }
}