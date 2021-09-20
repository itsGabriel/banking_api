# :memo: Desafio para Backend Developer Stone
O desafio consiste em desenvolver uma API bancária, para transferencias e saques de crédito.
[https://gist.github.com/Isabelarrodrigues/15e62f07eebf4e076b93897a64d9c674](https://gist.github.com/Isabelarrodrigues/15e62f07eebf4e076b93897a64d9c674)

Obs: A forma monetaria utilizada na API é utilizando números inteiros, ou seja, toda moeda é salva em centavos(Ex: 1 real = 100 centavos, 2 reais = 200 centavos...)

Caso queira testar em "produção", o projeto também está disponivel no link 
[http://bankingchallenge.gigalixirapp.com/](http://bankingchallenge.gigalixirapp.com/)


# :computer: Como rodar o projeto?
Instale o docker em sua máquina, vá na raiz do projeto e digite o comando:

   * Crie um container do postgress com `docker-compose up -d`
  * Instale as dependencias com `mix deps.get`
  * Crie a DB with `mix ecto.setup`
  * Inicie o servidor Phoenix com `mix phx.server`

Disponibilizo aqui também uma collection do postman para facilitar os testes da API
https://www.getpostman.com/collections/9165cacb7a2c78d5f2e7

# :white_check_mark: Como rodar os testes?

Na raiz do projeto utiliza-se o comando `mix test`

# :interrobang: O que foi usado?
A aplicação foi desenvolvida em cima do framework Phoenix.

- Autenticação JWT com guardian
- bcrypt_elixr para encriptação de senhas
- Testes utilizando ExUnit
- Gigalixir para deploy

# :memo: Endpoints

## Cadastro
POST `/api/sign-up`

Campos:
```
email(string) - O email do usuário da conta
password(string) - A senha do usuário da conta
username(string) - O nome do usuário da conta
```
Exemplo de requisição
```json
{
"email":  "test@test.com",
"password":  "test",
"username":  "test"
}
```
## Autenticação
POST `/api/login`

Campos:
```
email(string) - O email do usuário da conta
password(string) - A senha do usuário da conta
```
Exemplo de requisição
```json
{
"email":  "test@test.com",
"password":  "test"
}
```
#
Obs: Os endpoints a seguir necessitam de autenticanção e deve ser passado via header de cada requisição. O token é obtido ao se cadastrar/logar.

Exemplo:
`Authorization: Bearer <token>`

## Transferências

POST `/api/transfer/:account_destination`

Campos:
```
account_origin(string) - Deve ser a sua conta de origem na qual se quer fazer a transferência
amount(integer) - A quantia a ser transferida
```
Exemplo de requisição
```json
{
"account_origin":  "648483",
"amount":  1999
} 
```
# Saque

POST `/api/withdraw`

Campos:
```
account(string) - Deve ser a sua conta de origem na qual se quer fazer o saque
amount(integer) - A quantia a ser sacada
```
Exemplo de requisição
```json
{
"account_origin":  "648483",
"amount":  1999
} 
```
