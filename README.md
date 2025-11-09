# 🌐AOP 2 > Arquitetura de dados relacionais II 
## Neste semestre foi aprofundado a disciplina de arquitetura de dados relacionais, dada a ênfase nas consultas foi proposto a atividade avaliativa em questão: Escreva as sete consultas SQL que irão retornar os resultados descritos abaixo.
### ⚠️Observações:
Todo o banco de dados foi fornecido pelo próprio professor, pelo fato de anteriormente já ter sido proposto a construção do banco de dados dessa vez foi dada a ênfase nas consultas.
Para as consultas eu utilizei o 🐘Postgree e fiz algumas alterações no banco, só algumas nomenclaturas para que o banco rodasse no PostGree, mas nada mais que isso.

## 📜Consultas propóstas:
### 1.  Projeção
Escreva uma consulta à tabela account que retorne os IDs dos funcionários que abriram contas (com account.open_emp_id). Inclua uma única linha para cada funcionário específico.

### 2.   Seleção
Recupere o ID da conta (account.account_id), o ID do cliente (account.cust_id) e o saldo disponível de todas as contas (account.avail_balance) cujo status seja igual a ACTIVE e cujo saldo disponível seja superior a R$2.500.

### 3.  Agrupamento e Agregação
Retorne a data de posse do funcionário (employee.start_date) mais antigo para cada departamento (employee.department).

### 4.  Ordenação
Recupere o ID, o nome e o sobrenome de todos os funcionários (employee.emp_id, employee.fname, employee.lname). Ordene por primeiro nome e, depois, pelo sobrenome.

### 5. União
Escreva uma consulta que encontre nomes e sobrenomes de todos os clientes (individual.fname, individual.lname), juntamente com nomes e sobrenomes de todos os funcionários (employee.fname, employee.lname).

### 6. Intersecção
Escreva uma consulta composta que retorne os IDs dos funcionários (employee.emp_id), que são também superiores (employee.superior_emp_id).

### 7. Diferença
Escreva uma consulta composta que retorne as cidades de clientes. 
(customer.city) onde não há agência (branch.city).

## 📚Banco de dados:
<img width="826" height="756" alt="image" src="https://github.com/user-attachments/assets/0362b062-ed17-45c9-9db5-b79bb6014d16" />
