-- Destruindo todas as tabelas para realizar atualizações

DROP TABLE IF EXISTS usuario_obras_favoritas CASCADE;
DROP TABLE IF EXISTS cartao CASCADE;
DROP TABLE IF EXISTS comentario CASCADE;
DROP TABLE IF EXISTS lance CASCADE;
DROP TABLE IF EXISTS leilao CASCADE;
DROP TABLE IF EXISTS material CASCADE;
DROP TABLE IF EXISTS tecnica CASCADE;
DROP TABLE IF EXISTS objeto CASCADE;
DROP TABLE IF EXISTS pintura CASCADE;
DROP TABLE IF EXISTS obra_de_arte CASCADE;
DROP TABLE IF EXISTS comprador CASCADE;
DROP TABLE IF EXISTS artista CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;

-- CRIAÇÃO DAS TABELAS DE CLASSES E TABELAS DE RELAÇÕES ENTRE AS CLASSES

-- Criando a tabela abstrata "usuario"
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY, -- ID
    nome VARCHAR(100) NOT NULL, -- nome
    email VARCHAR(100) UNIQUE NOT NULL, -- email unico
    senha VARCHAR(100) NOT NULL, -- senha
    nacionalidade VARCHAR(50), -- nacionalidade
    biografia TEXT -- biografia
);

-- Criando a tabela "artista" que herda de "usuario"
CREATE TABLE artista (
    id INT PRIMARY KEY, -- id do artista
    conta_bancaria VARCHAR(100), -- conta do banco
    FOREIGN KEY (id) REFERENCES usuario(id) ON DELETE CASCADE -- id do usuário atrelada ao artista
);

-- Criando a tabela "comprador" que herda de "usuario"
CREATE TABLE comprador (
    id INT PRIMARY KEY, -- ID comprador
    FOREIGN KEY (id) REFERENCES usuario(id) ON DELETE CASCADE -- id do usuário atrelado ao comprador
);

-- Criando a tabela "cartao" para associar vários cartões ao "comprador"
CREATE TABLE cartao (
    id SERIAL PRIMARY KEY, -- id do cartão
    numero_cartao VARCHAR(16) NOT NULL, -- numero cartão
    validade DATE NOT NULL, -- data da validade
    cvv VARCHAR(4) NOT NULL, -- cvv
    comprador_id INT REFERENCES comprador(id) ON DELETE CASCADE -- id do comprador atrelado ao cartão
);

-- Criando a tabela "obra_de_arte"
CREATE TABLE obra_de_arte (
    id SERIAL PRIMARY KEY, -- id da obra de arte
    data_criacao DATE NOT NULL, -- data da criação
    estilo VARCHAR(100), -- estilo da obra
    titulo VARCHAR(200) NOT NULL, -- titulo da obra
    descricao TEXT, -- descrição da obra
    artista_id INT REFERENCES artista(id) ON DELETE CASCADE, -- id do artista atrelado a obra
    em_leilao BOOLEAN DEFAULT FALSE  -- Indica se a obra está ou não em leilão
);


-- Criando a tabela "tecnica" para associar várias técnicas a uma obra de arte
CREATE TABLE tecnica (
    id SERIAL PRIMARY KEY, -- id da tecnica
    nome VARCHAR(100) NOT NULL, -- nome da tecnica
    obra_de_arte_id INT REFERENCES obra_de_arte(id) ON DELETE CASCADE -- id da obra de arte referente a tecnica
);

-- Criando a tabela "objeto" que herda de "obra_de_arte"
CREATE TABLE objeto (
    id INT PRIMARY KEY, -- id do objeto
    FOREIGN KEY (id) REFERENCES obra_de_arte(id) ON DELETE CASCADE -- id fo objeto vai ser o mesmo que da obra de arte
);

-- Criando a tabela "material" para associar vários materiais a um objeto
CREATE TABLE material (
    id SERIAL PRIMARY KEY, -- id do material
    nome VARCHAR(100) NOT NULL, -- qual mateiral é
    objeto_id INT REFERENCES objeto(id) ON DELETE CASCADE -- id do objeto que usa esse material
);

-- Criando a tabela "pintura" que herda de "obra_de_arte"
CREATE TABLE pintura (
    id INT PRIMARY KEY, -- id pintura
    FOREIGN KEY (id) REFERENCES obra_de_arte(id) ON DELETE CASCADE -- id da pintura vai ser referente ao id obra de arte
);

-- Criando a tabela de relacionamento "usuario_obras_favoritas"
CREATE TABLE usuario_obras_favoritas (
    usuario_id INT REFERENCES usuario(id) ON DELETE CASCADE, -- ID do usuári0
    obra_de_arte_id INT REFERENCES obra_de_arte(id) ON DELETE CASCADE, -- ID da obra de arte favorita
    PRIMARY KEY (usuario_id, obra_de_arte_id)
);

-- Criando a tabela "lance" para associar lances às obras de arte
CREATE TABLE lance (
    id SERIAL PRIMARY KEY, -- lance
    valor NUMERIC(10, 2) NOT NULL, -- valor do lance (decimal com no máximo 2 casas decimais)
    comprador_id INT REFERENCES comprador(id) ON DELETE SET NULL, -- id do comprador
    obra_de_arte_id INT REFERENCES obra_de_arte(id) ON DELETE CASCADE, -- id da obra de arte
    data_fim_leilao DATE NOT NULL -- data do fim deste leilão
);

-- Adicionando a coluna maior_lance_id à tabela obra_de_arte
-- Sendo criada depois para não interfirir na tabela lance
ALTER TABLE obra_de_arte
ADD COLUMN maior_lance_id INT REFERENCES lance(id) ON DELETE SET NULL;

-- Criando a tabela "comentario"
CREATE TABLE comentario (
    id SERIAL PRIMARY KEY, -- id do comentário
    obra_de_arte_id INT REFERENCES obra_de_arte(id) ON DELETE CASCADE, -- id da obra que teve o comentario
    data_hora TIMESTAMP NOT NULL, -- hora e data de quando foi comentado
    texto TEXT NOT NULL, -- texto do comentario
    usuario_id INT REFERENCES usuario(id) ON DELETE CASCADE -- id do usuário
);


-- Criando a tabela "leilao"
CREATE TABLE leilao (
    id SERIAL PRIMARY KEY, -- id do leilão
    obra_de_arte_id INT UNIQUE REFERENCES obra_de_arte(id) ON DELETE CASCADE -- obra de arte que está em leilão
);

-- INSERINDO OS VALORES NA TABELA E TESTANDO SE REALMENTE ESTÃO SENDO INSERIDOS

-- Inserindo 10 artistas
INSERT INTO usuario (nome, email, senha, nacionalidade, biografia)
VALUES 
('Artista 1', 'artista1@example.com', 'senha123', 'Brasil', 'Biografia do Artista 1'),
('Artista 2', 'artista2@example.com', 'senha123', 'Argentina', 'Biografia do Artista 2'),
('Artista 3', 'artista3@example.com', 'senha123', 'Chile', 'Biografia do Artista 3'),
('Artista 4', 'artista4@example.com', 'senha123', 'Peru', 'Biografia do Artista 4'),
('Artista 5', 'artista5@example.com', 'senha123', 'México', 'Biografia do Artista 5'),
('Artista 6', 'artista6@example.com', 'senha123', 'Colômbia', 'Biografia do Artista 6'),
('Artista 7', 'artista7@example.com', 'senha123', 'Uruguai', 'Biografia do Artista 7'),
('Artista 8', 'artista8@example.com', 'senha123', 'Paraguai', 'Biografia do Artista 8'),
('Artista 9', 'artista9@example.com', 'senha123', 'Bolívia', 'Biografia do Artista 9'),
('Artista 10', 'artista10@example.com', 'senha123', 'Venezuela', 'Biografia do Artista 10');

INSERT INTO artista (id, conta_bancaria)
VALUES 
(1, '12345-6'),
(2, '65432-1'),
(3, '11111-1'),
(4, '22222-2'),
(5, '33333-3'),
(6, '44444-4'),
(7, '55555-5'),
(8, '66666-6'),
(9, '77777-7'),
(10, '88888-8');

-- Inserindo 10 compradores
INSERT INTO usuario (nome, email, senha, nacionalidade, biografia)
VALUES 
('Comprador 1', 'comprador1@example.com', 'senha123', 'Brasil', 'Biografia do Comprador 1'),
('Comprador 2', 'comprador2@example.com', 'senha123', 'Argentina', 'Biografia do Comprador 2'),
('Comprador 3', 'comprador3@example.com', 'senha123', 'Chile', 'Biografia do Comprador 3'),
('Comprador 4', 'comprador4@example.com', 'senha123', 'Peru', 'Biografia do Comprador 4'),
('Comprador 5', 'comprador5@example.com', 'senha123', 'México', 'Biografia do Comprador 5'),
('Comprador 6', 'comprador6@example.com', 'senha123', 'Colômbia', 'Biografia do Comprador 6'),
('Comprador 7', 'comprador7@example.com', 'senha123', 'Uruguai', 'Biografia do Comprador 7'),
('Comprador 8', 'comprador8@example.com', 'senha123', 'Paraguai', 'Biografia do Comprador 8'),
('Comprador 9', 'comprador9@example.com', 'senha123', 'Bolívia', 'Biografia do Comprador 9'),
('Comprador 10', 'comprador10@example.com', 'senha123', 'Venezuela', 'Biografia do Comprador 10');

INSERT INTO comprador (id)
VALUES 
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20);

-- Inserindo 10 cartões (um para cada comprador)
INSERT INTO cartao (numero_cartao, validade, cvv, comprador_id)
VALUES 
('1111222233334444', '2025-12-31', '123', 11),
('5555666677778888', '2026-11-30', '456', 12),
('9999000011112222', '2025-12-31', '789', 13),
('3333444455556666', '2026-11-30', '012', 14),
('7777888899990000', '2025-12-31', '345', 15),
('1234567890123456', '2026-11-30', '678', 16),
('9876543210987654', '2025-12-31', '901', 17),
('1111999933334444', '2026-11-30', '234', 18),
('5555777755558888', '2025-12-31', '567', 19),
('4444333322221111', '2026-11-30', '890', 20);

-- Inserindo 10 obras de arte como objetos
INSERT INTO obra_de_arte (data_criacao, estilo, titulo, descricao, artista_id, em_leilao)
VALUES 
('2023-03-01', 'Surrealismo', 'Objeto 1', 'Descrição do Objeto 1', 1, TRUE),
('2023-03-02', 'Futurismo', 'Objeto 2', 'Descrição do Objeto 2', 2, FALSE),
('2023-03-03', 'Realismo', 'Objeto 3', 'Descrição do Objeto 3', 3, TRUE),
('2023-03-04', 'Abstrato', 'Objeto 4', 'Descrição do Objeto 4', 4, FALSE),
('2023-03-05', 'Barroco', 'Objeto 5', 'Descrição do Objeto 5', 5, TRUE),
('2023-03-06', 'Rococó', 'Objeto 6', 'Descrição do Objeto 6', 6, FALSE),
('2023-03-07', 'Gótico', 'Objeto 7', 'Descrição do Objeto 7', 7, TRUE),
('2023-03-08', 'Neoclássico', 'Objeto 8', 'Descrição do Objeto 8', 8, FALSE),
('2023-03-09', 'Renascimento', 'Objeto 9', 'Descrição do Objeto 9', 9, TRUE),
('2023-03-10', 'Romantismo', 'Objeto 10', 'Descrição do Objeto 10', 10, FALSE);

INSERT INTO objeto (id)
VALUES 
(1), 
(2), 
(3), 
(4), 
(5), 
(6), 
(7), 
(8), 
(9), 
(10);

-- Inserindo 10 obras de arte como pinturas
INSERT INTO obra_de_arte (data_criacao, estilo, titulo, descricao, artista_id, em_leilao)
VALUES 
('2023-04-01', 'Impressionismo', 'Pintura 1', 'Descrição da Pintura 1', 1, TRUE),
('2023-04-02', 'Cubismo', 'Pintura 2', 'Descrição da Pintura 2', 2, FALSE),
('2023-04-03', 'Expressionismo', 'Pintura 3', 'Descrição da Pintura 3', 3, TRUE),
('2023-04-04', 'Minimalismo', 'Pintura 4', 'Descrição da Pintura 4', 4, FALSE),
('2023-04-05', 'Modernismo', 'Pintura 5', 'Descrição da Pintura 5', 5, TRUE),
('2023-04-06', 'Pós-Impressionismo', 'Pintura 6', 'Descrição da Pintura 6', 6, FALSE),
('2023-04-07', 'Realismo', 'Pintura 7', 'Descrição da Pintura 7', 7, TRUE),
('2023-04-08', 'Surrealismo', 'Pintura 8', 'Descrição da Pintura 8', 8, FALSE),
('2023-04-09', 'Abstrato', 'Pintura 9', 'Descrição da Pintura 9', 9, TRUE),
('2023-04-10', 'Pop Art', 'Pintura 10', 'Descrição da Pintura 10', 10, FALSE);

INSERT INTO pintura (id)
VALUES 
(11), 
(12), 
(13), 
(14), 
(15), 
(16), 
(17), 
(18), 
(19), 
(20);

-- Inserindo 10 técnicas associadas às obras de arte
INSERT INTO tecnica (nome, obra_de_arte_id)
VALUES 
('Técnica A', 1),
('Técnica B', 2),
('Técnica C', 3),
('Técnica D', 4),
('Técnica E', 5),
('Técnica F', 6),
('Técnica G', 7),
('Técnica H', 8),
('Técnica I', 9),
('Técnica J', 10);

-- Inserindo 10 materiais associados aos objetos
INSERT INTO material (nome, objeto_id)
VALUES 
('Material A', 1),
('Material B', 2),
('Material C', 3),
('Material D', 4),
('Material E', 5),
('Material F', 6),
('Material G', 7),
('Material H', 8),
('Material I', 9),
('Material J', 10);

-- Inserindo 10 lances para as obras em leilão
INSERT INTO lance (valor, comprador_id, obra_de_arte_id, data_fim_leilao)
VALUES 
(1000.00, 11, 1, '2024-12-31'),
(1500.00, 12, 3, '2024-12-31'),
(2000.00, 13, 5, '2024-12-31'),
(2500.00, 14, 7, '2024-12-31'),
(3000.00, 15, 9, '2024-12-31'),
(1200.00, 16, 11, '2024-12-31'),
(1700.00, 17, 13, '2024-12-31'),
(2200.00, 18, 15, '2024-12-31'),
(2700.00, 19, 17,  '2024-12-31'),
(3200.00, 20, 19, '2024-12-31');

-- Inserindo 10 comentários associados às obras de arte
INSERT INTO comentario (obra_de_arte_id, data_hora, texto, usuario_id)
VALUES 
(1, '2024-08-18 10:00:00', 'Comentário 1', 11),
(2, '2024-08-18 11:00:00', 'Comentário 2', 12),
(3, '2024-08-18 12:00:00', 'Comentário 3', 13),
(4, '2024-08-18 13:00:00', 'Comentário 4', 14),
(5, '2024-08-18 14:00:00', 'Comentário 5', 15),
(6, '2024-08-18 15:00:00', 'Comentário 6', 16),
(7, '2024-08-18 16:00:00', 'Comentário 7', 17),
(8, '2024-08-18 17:00:00', 'Comentário 8', 18),
(9, '2024-08-18 18:00:00', 'Comentário 9', 19),
(10, '2024-08-18 19:00:00', 'Comentário 10', 20);

-- Inserindo 10 relações de obras favoritas
INSERT INTO usuario_obras_favoritas (usuario_id, obra_de_arte_id)
VALUES 
(11, 1),
(12, 2),
(13, 3),
(14, 4),
(15, 5),
(16, 6),
(17, 7),
(18, 8),
(19, 9),
(20, 10);

-- Atualizando as obras em leilão com os maiores lances
UPDATE obra_de_arte
SET maior_lance_id = (
    SELECT id FROM lance 
    WHERE lance.obra_de_arte_id = obra_de_arte.id 
    ORDER BY valor DESC -- organizando a ordem do maior ao menor
    LIMIT 1 -- primeiro valor ser pego
)
WHERE em_leilao = TRUE; -- se estiver no leilão

-- Inserir todas as obras de arte em leilão na tabela de leilão
INSERT INTO leilao (obra_de_arte_id)
SELECT id
FROM obra_de_arte
WHERE em_leilao = TRUE;

-- Verificando e existencia de tudo que foi inserido

-- Verificar os usuários
SELECT * FROM usuario;

-- Verificar os artistas
SELECT * FROM artista;

-- Verificar as obras de arte
SELECT * FROM obra_de_arte;

-- Verificar as técnicas
SELECT * FROM tecnica;

-- Verificar os objetos
SELECT * FROM objeto;

-- Verificar as pinturas
SELECT * FROM pintura;

-- Verificar os materiais
SELECT * FROM material;

-- Verificar os cartões
SELECT * FROM cartao;

-- Verificar os compradores
SELECT * FROM comprador;

-- Verificar os lances
SELECT * FROM lance;

-- Verificar os comentários
SELECT * FROM comentario;

-- Verificar as obras de arte em leilão
SELECT * FROM leilao;

-- Verificar as obras favoritas dos usuários
SELECT * FROM usuario_obras_favoritas;

-- Testando se a relação em cascata está funcionando

-- Deletando usuário
DELETE FROM usuario WHERE id = 1;

-- Se eu deletar um Artista todas as seguintes informações serão deletadas
-- Obra do artista
-- Lances relacionados a obra
-- Materiais
-- Tecnica
-- Comentário
-- Obras Favoritas
-- Pintura ou Objeto


-- Verificar os usuários
SELECT * FROM usuario;

-- Verificar os artistas
SELECT * FROM artista;

-- Verificar as obras de arte
SELECT * FROM obra_de_arte;

-- Verificar as técnicas
SELECT * FROM tecnica;

-- Verificar os objetos
SELECT * FROM objeto;

-- Verificar as pinturas
SELECT * FROM pintura;

-- Verificar os materiais
SELECT * FROM material;

-- Verificar os lances
SELECT * FROM lance;

-- Verificar os comentários
SELECT * FROM comentario;

-- Verificar as obras de arte em leilão
SELECT * FROM leilao;

-- Verificar as obras favoritas dos usuários
SELECT * FROM usuario_obras_favoritas;
