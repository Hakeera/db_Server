-- ============================================
-- 🚀 Inicialização do Banco de Dados: Financeiro
-- ============================================

-- 1️⃣ Criar usuários
-- Usuário comum (acesso via SSH túnel)
CREATE ROLE usr1 LOGIN PASSWORD 'acessosarra' NOSUPERUSER;

-- 2️⃣ Garantir acesso ao banco principal
GRANT CONNECT ON DATABASE sarracena TO admin, usr1;

-- 3️⃣ Criar schema do módulo financeiro
CREATE SCHEMA IF NOT EXISTS financeiro AUTHORIZATION admin;

-- 4️⃣ Definir permissões do schema
-- Permitir que usr1 use o schema
GRANT USAGE ON SCHEMA financeiro TO usr1;

-- Dar permissões CRUD (SELECT, INSERT, UPDATE, DELETE)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA financeiro TO usr1;

-- Fazer com que novas tabelas criadas no schema também recebam essas permissões automaticamente
ALTER DEFAULT PRIVILEGES IN SCHEMA financeiro GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO usr1;

-- 5️⃣ Criar tabela: financeiro.faturas
CREATE TABLE IF NOT EXISTS financeiro.faturas (
    id SERIAL PRIMARY KEY,
    vencimento DATE NOT NULL,
    valor INTEGER NOT NULL,
    n_parcelas VARCHAR(10),
    parcela VARCHAR(10),
    destinatario VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    situacao VARCHAR(20) DEFAULT 'Pendente',
    tipo_transf VARCHAR(50),
    nota_fiscal VARCHAR(50),
    boleto VARCHAR(50),
    npedido VARCHAR(50),
    empresa VARCHAR(25)
);

-- 6️⃣ Confirmar proprietário da tabela
ALTER TABLE financeiro.faturas OWNER TO admin;
