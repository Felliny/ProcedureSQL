create database academia

use academia

create table Aluno (
    codigo_aluno    int         not null identity (1, 1),
    nome            varchar(40) not null ,
    primary key (codigo_aluno)
)
go
create table Atividade (
    codigo          int           not null ,
    descricao       varchar(100)  not null ,
    imc             decimal(4, 2) not null ,
    primary key (codigo)
)
go
create table Atividades_Alunos (
    codigo_aluno        int             not null identity (1, 1),
    codigo_atividade    int             not null ,
    altura              decimal(4, 2)   not null ,
    peso                decimal(4, 2)   not null ,
    imc                 decimal(4, 2)   not null ,
    foreign key (codigo_aluno) references Aluno(codigo_aluno),
    foreign key (codigo_atividade) references Atividade(codigo)
)

insert into Atividade
values (1, 'Corrida + Step', 18.5),
       (2, 'Biceps + Costas + Pernas', 24.9),
       (3, 'Esteira + Biceps + Costas + Pernas', 29.9),
       (4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
       (5, 'Esteira + Bicicleta', 39.9)


drop table Atividades_Alunos

delete from Aluno

drop table Aluno


-- IMC = Peso (Kg) / Altura2 (M)
-- Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
-- Exemplo, se o IMC for igual a 27, deve-se fazer a atividade para IMC = 29.9
-- * Caso o IMC seja maior que 40, utilizar o código 5.

-- Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
-- - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um
-- novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas
-- regras estabelecidas acima.

-- - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se
-- verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e
-- as atividades pelas regras estabelecidas acima.

create procedure sp_alunoatividades(@id int, @nome varchar(40), @altura decimal(4, 2), @peso decimal(4, 2),
                                    @saida VARCHAR(100) OUTPUT)
as
    declare @imc decimal(4, 2)
    if (@id is null)
    begin
        if (@nome is not null and @altura is not null and @peso is not null)
        begin
            insert into Aluno
            values (@nome)

            set @imc = @peso / @altura

            if (@imc >= 35)
            begin
                insert into Atividades_Alunos
                values (5, @altura, @peso, @imc)
            end
            if (@imc <= 18.5)
            begin
                insert into Atividades_Alunos
                values (1, @altura, @peso, @imc)
            end
            if (@imc between 18.6 and 24.9)
            begin
                insert into Atividades_Alunos
                values (2, @altura, @peso, @imc)
            end
            if (@imc between 25 and 29.9)
            begin
                insert into Atividades_Alunos
                values (3, @altura, @peso, @imc)
            end
            if (@imc between 30 and 34.9)
            begin
                insert into Atividades_Alunos
                values (4, @altura, @peso, @imc)
            end

            set @saida = 'Aluno resgistrado com sucesso!'

        end
        else
        begin
            raiserror ('Somente o ID ou nome podem ser Nulos', 16, 1)
        end
    end
    else
    if (@nome is null)
    begin
        if (@id is not null and @altura is not null and @peso is not null)
        begin
            if exists(select 1 from Aluno where codigo_aluno = @id)
            begin
                set @imc = @peso / @altura

                if (@imc >= 35)
                    begin
                        update Atividades_Alunos
                        set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 5
                        where codigo_aluno = @id
                    end
                if (@imc <= 18.5)
                    begin
                        update Atividades_Alunos
                        set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 1
                        where codigo_aluno = @id
                    end
                if (@imc between 18.6 and 24.9)
                    begin
                        update Atividades_Alunos
                        set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 2
                        where codigo_aluno = @id
                    end
                if (@imc between 25 and 29.9)
                    begin
                        update Atividades_Alunos
                        set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 3
                        where codigo_aluno = @id
                    end
                if (@imc between 30 and 34.9)
                    begin
                        update Atividades_Alunos
                        set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 4
                        where codigo_aluno = @id
                    end
                set @saida = 'Aluno atualizado!'

            end
            else
            begin
                raiserror (N'Aluno não encontrado no sistema!', 16, 1)
            end
        end
        else
        begin
            raiserror ('Somente o ID ou nome podem ser Nulos', 16, 1)
        end
    end
    else
    begin
        if (@id is not null and @altura is not null and @peso is not null)
            begin

                if exists(select 1 from Aluno where codigo_aluno = @id)
                begin
                        set @imc = @peso / @altura

                        if (@imc >= 35)
                            begin
                                update Atividades_Alunos
                                set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 5
                                where codigo_aluno = @id

                                update Aluno
                                set nome = @nome
                                where codigo_aluno = @id

                            end
                        if (@imc <= 18.5)
                            begin
                                update Atividades_Alunos
                                set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 1
                                where codigo_aluno = @id

                                update Aluno
                                set nome = @nome
                                where codigo_aluno = @id
                            end
                        if (@imc between 18.6 and 24.9)
                            begin
                                update Atividades_Alunos
                                set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 2
                                where codigo_aluno = @id

                                update Aluno
                                set nome = @nome
                                where codigo_aluno = @id
                            end
                        if (@imc between 25 and 29.9)
                            begin
                                update Atividades_Alunos
                                set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 3
                                where codigo_aluno = @id

                                update Aluno
                                set nome = @nome
                                where codigo_aluno = @id
                            end
                        if (@imc between 30 and 34.9)
                            begin
                                update Atividades_Alunos
                                set peso = @peso, altura = @altura, imc = @imc, codigo_atividade = 4
                                where codigo_aluno = @id

                                update Aluno
                                set nome = @nome
                                where codigo_aluno = @id
                            end
                        set @saida = 'Aluno atualizado!'

                    end
                else
                    begin
                        raiserror (N'Aluno não encontrado no sistema!', 16, 1)
                    end
            end
        else
            begin
                raiserror ('Somente o ID ou nome podem ser Nulos', 16, 1)
            end
    end

declare @saida1 varchar(100)
exec sp_alunoatividades  null, 'Thiago', null, 70.00, @saida1 output
print @saida1

declare @saida1 varchar(100)
exec sp_alunoatividades  1, null, 1.6, 58, @saida1 output
print @saida1