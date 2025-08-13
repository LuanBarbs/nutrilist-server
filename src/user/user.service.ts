import { Injectable, Inject } from '@nestjs/common';
import { Pool } from 'pg';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    @Inject('PG_CONNECTION') private pool: Pool
  ) {}

  async getUsers() {
    const result = await this.pool.query('SELECT * FROM usuario');
    return result.rows;
  }

  async createUser(user: any) {
    const saltRounds = 10;
    const salt = await bcrypt.genSalt(saltRounds);
    const senhaHash = await bcrypt.hash(user.senha_hash, salt);

    const sql = `
      INSERT INTO usuario (email, nome, senha_hash, telefone, datanascimento, sexo, tipo)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
      RETURNING *;
    `;
    const values = [
      user.email,
      user.nome,
      senhaHash,
      user.telefone,
      user.datanascimento,
      user.sexo,
      user.tipo
    ];
    const result = await this.pool.query(sql, values);
    return result.rows[0];
  }

  async validateUser(email:string, senha: string) {
    // Busca usuário pelo email
    const result = await this.pool.query('SELECT * FROM usuario WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      throw new Error('Usuário não encontrado');
    }

    const user = result.rows[0];

    // Verifica hash
    const isMatch = await bcrypt.compare(senha, user.senha_hash);

    if (!isMatch) {
      throw new Error('Senha incorreta');
    }

    // Retorna os dados (sem senha)
    delete user.senha_hash;
    return user;
  }
}