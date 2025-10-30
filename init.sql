-- ============================================
-- 🚀 Inicialização do Banco de Dados: Financeiro
-- ============================================

-- 1️⃣ Criar usuários
-- Usuário comum (acesso via SSH túnel)
CREATE ROLE usr1 LOGIN PASSWORD 'acessosarra' NOSUPERUSER;

-- 2️⃣ Garantir acesso ao banco principal
GRANT CONNECT ON DATABASE sarracena_db TO admin, usr1;

-- 3️⃣ Criar schema do módulo financeiro
CREATE SCHEMA IF NOT EXISTS financeiro AUTHORIZATION admin;

-- 4️⃣ Definir permissões do schema
GRANT USAGE ON SCHEMA financeiro TO usr1;

-- Permissões CRUD (SELECT, INSERT, UPDATE, DELETE)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA financeiro TO usr1;

-- Permissões automáticas para novas tabelas
ALTER DEFAULT PRIVILEGES IN SCHEMA financeiro GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO usr1;

-- ============================================
-- 5️⃣ TABELAS DO MÓDULO FINANCEIRO
-- ============================================

-- 🧾 Tabela: financeiro.faturas
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

ALTER TABLE financeiro.faturas OWNER TO admin;

-- 👤 Tabela: financeiro.users
CREATE TABLE IF NOT EXISTS financeiro.users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE financeiro.users OWNER TO admin;

-- Trigger para atualizar automaticamente o campo updated_at
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_trigger
        WHERE tgname = 'set_users_updated_at'
    ) THEN
        CREATE OR REPLACE FUNCTION financeiro.update_updated_at_column()
        RETURNS TRIGGER AS $$
        BEGIN
            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $$ language 'plpgsql';

        CREATE TRIGGER set_users_updated_at
        BEFORE UPDATE ON financeiro.users
        FOR EACH ROW
        EXECUTE FUNCTION financeiro.update_updated_at_column();
    END IF;
END$$;
