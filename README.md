# Banco-de-dados-Simulado-PostgreSQL
Simulação do banco de dados de um mercado feita em PostgreSQL

Os arquivos contidos em *dados* são os registros das "tabelas" (entidades) do banco que foram simulados utilizando o Excel.

Ao executar o comando ```COPY``` subentende-se que o *Postgre* não tem acesso as pastas do seu computador, portanto, para importar os dados para dentro do banco foi necessário que os arquivos estivessem em uma pasta pública, caso contrário um erro seria gerado e a transação, cancelada.

Se você utilizar o assistente do *pgAdmin* para executar essa ação isso provavelmente não vai acontecer.

No arquivo *Mercado.sql* está o código que cria as tabelas do banco, importa os registros citados e cria algumas views.
Lembrando que ele não cria o bando em si, apenas cria as tabelas. Você pode criar o banco diretamente pelo *pgAdmin* e depois executar no editor de Query.

Sobre as Views criadas
- *valor_das_vendas*: Agrupa os produtos de uma venda e retorna o valor total de cada uma;
- *resumo_vendas*: Essa view executa uma grande desnormalização do banco e retorna em uma só tabela as informações sobre as vendas registradas.

As views podem ser usadas para realizar consultas de forma mais intuitiva e facilitar os processos de *ETL* para a construção de relatórios, por exemplo.

Utilizar a view *resumo_vendas* talves não seja a melho ideia, pois essa estrutura de "tabalão" não é muito eficiente, mas é fácil de compreender.

Veja o Diagrama Entidade Relacionamento (**DER**) para compreender melhor a estrutura do banco e como as view foram desenvolvidas.

> Obs: como as tabelas foram criadas com chave primária (PK) serial, foi necessário alterar a posição das sequências que definem os próximos valores das PK's. Isso já é feito nos procedimentos de *Mercado.sql*
