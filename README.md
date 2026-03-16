# Análise de Churn - Telecomunicações 📊

Este projeto apresenta uma análise profunda sobre a retenção de clientes em uma empresa de telecomunicações, utilizando **PostgreSQL**. O objetivo foi identificar os principais motivos de cancelamento (Churn) e o impacto financeiro gerado.

## 🚀 Principais Insights
* **Taxa de Churn:** 26,5% da base de clientes cancelou o serviço.
* **Impacto Financeiro:** Uma perda de **R$ 139.130,85** em receita mensal.
* **O Maior Vilão:** 89% dos cancelamentos estão concentrados em clientes com **contratos mensais** (Month-to-month).
* **Perfil de Risco:** Clientes sem dependentes e usuários de fibra óptica apresentam maior tendência ao cancelamento.

## 🛠️ Tecnologias e Técnicas Utilizadas
* **SQL (PostgreSQL):** Criação de tabelas, limpeza de dados (conversão de tipos e tratamento de nulos).
* **Queries Avançadas:** Uso de `CASE WHEN` para tradução de dados, agregações (`SUM`, `AVG`, `COUNT`) e cálculos de porcentagem.
* **Análise de Negócio:** Foco em métricas financeiras e comportamento do consumidor.

## 📂 Como visualizar o projeto
O script completo com as queries comentadas está disponível no arquivo: `projeto_churn_telecom.sql` neste repositório.
