----------------------------------------------------------------------
-- PROJETO: Análise de Churn em Telecomunicações
-- OBJETIVO: Identificar motivos de cancelamento e impacto financeiro
-- ANALISTA: Fábio
----------------------------------------------------------------------

-- 1. CRIANDO A TABELA
CREATE TABLE clientes_telecom (
    customerID VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(20),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges NUMERIC(10,2),
    TotalCharges VARCHAR(50), -- Importado como texto para limpeza
    Churn VARCHAR(5)
);
-----------------------------------------------------------------------------
-- 2. LIMPEZA E TRATAMENTO DE DADOS
-- Convertendo TotalCharges de texto para numérico e tratando espaços vazios
-----------------------------------------------------------------------------
UPDATE clientes_telecom 
SET totalcharges = NULL 
WHERE totalcharges = ' ';

ALTER TABLE clientes_telecom 
ALTER COLUMN totalcharges TYPE NUMERIC(10,2) 
USING totalcharges::NUMERIC(10,2);

----------------------------------------------------------
-- 3. ANÁLISE DO PERFIL DOS CLIENTES
----------------------------------------------------------

-- Distribuição por Gênero
SELECT 
    CASE 
        WHEN gender = 'Female' THEN 'Feminino'
        WHEN gender = 'Male' THEN 'Masculino'
    END AS "Gênero",
    COUNT(*) AS "Total",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes_telecom), 2) || '%' AS "Porcentagem"
FROM clientes_telecom
GROUP BY gender;

-- Distribuição por Faixa Etária (Idosos vs Jovens)
SELECT 
    CASE 
        WHEN seniorcitizen = 0 THEN 'Jovem'
        WHEN seniorcitizen = 1 THEN 'Idoso'
    END AS "Categoria",
    COUNT(*) AS "Total",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes_telecom), 2) || '%' AS "Porcentagem"
FROM clientes_telecom
GROUP BY "Categoria";

-- Análise de Dependentes
SELECT 
    CASE 
        WHEN dependents = 'Yes' THEN 'Possui Dependentes'
        WHEN dependents = 'No' THEN 'Não possui'
    END AS "Dependentes",
    COUNT(*) AS "Total",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes_telecom), 2) || '%' AS "Porcentagem"
FROM clientes_telecom
GROUP BY "Dependentes";


----------------------------------------------------------
-- 4. ANÁLISE DE CONSUMO E SERVIÇOS
----------------------------------------------------------

-- Preferência por Tipo de Contrato
SELECT 
    CASE 
        WHEN contract = 'Month-to-month' THEN 'Mensal'
        WHEN contract = 'One year' THEN 'Um ano'
        WHEN contract = 'Two year' THEN 'Dois anos'
    END AS "Contrato",
    COUNT(*) AS "Total",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes_telecom), 2) || '%' AS "Porcentagem"
FROM clientes_telecom
GROUP BY "Contrato"
ORDER BY "Total" DESC;

-- Serviços de Internet Contratados
SELECT 
    CASE 
        WHEN internetservice = 'Fiber optic' THEN 'Fibra óptica'
        WHEN internetservice = 'DSL' THEN 'Internet via linha telefônica (DSL)'
        WHEN internetservice = 'No' THEN 'Sem internet (Apenas telefone)'
    END AS "Plano de Internet",
    COUNT(*) AS "Total",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes_telecom), 2) || '%' AS "Porcentagem"
FROM clientes_telecom
GROUP BY "Plano de Internet"
ORDER BY "Total" DESC;

-- Análise Financeira (Ticket Médio por Serviço)
SELECT 
    internetservice AS "Serviço",
    COUNT(*) AS "Total Clientes",
    ROUND(AVG(MonthlyCharges), 2) AS "Média Mensal (R$)",
    ROUND(SUM(MonthlyCharges), 2) AS "Faturamento Mensal Total (R$)"
FROM clientes_telecom
GROUP BY internetservice
ORDER BY "Média Mensal (R$)" DESC;


----------------------------------------------------------
-- 5. ANÁLISE DE CHURN (CANCELAMENTOS)
----------------------------------------------------------

-- Taxa de Churn Geral (Saúde da Empresa)
SELECT 
    CASE 
        WHEN churn = 'Yes' THEN 'Cancelou (Churn)'
        WHEN churn = 'No' THEN 'Ativo'
    END AS "Status",
    COUNT(*) AS "Total",
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM clientes_telecom), 2) || '%' AS "Porcentagem"
FROM clientes_telecom
GROUP BY "Status";

-- Cruzamento: Tipo de Contrato vs Cancelamentos
-- Objetivo: Identificar o maior fator de risco
SELECT 
    contract AS "Tipo de Contrato",
    churn AS "Cancelou?",
    COUNT(*) AS "Total de Clientes"
FROM clientes_telecom
GROUP BY contract, churn
ORDER BY contract, churn;

-- Impacto Financeiro (Prejuízo Mensal em Receita)
SELECT 
    churn AS "Cancelou?",
    COUNT(*) AS "Total de Clientes",
    ROUND(SUM(monthlycharges), 2) AS "Receita Mensal Perdida (R$)"
FROM clientes_telecom
GROUP BY churn;