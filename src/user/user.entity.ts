import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity({ name: 'usuario' })
export class User {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    email: string;

    @Column()
    nome: string;

    @Column()
    senha_hash: string;

    @Column()
    telefone: string;

    @Column()
    datanascimento: Date;
    
    @Column()
    sexo: string;

    @Column()
    tipo: number;
};