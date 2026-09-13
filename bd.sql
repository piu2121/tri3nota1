CREATE TABLE autores (
    id_autor INTEGER PRIMARY KEY,
    nome VARCHAR(120) NOT NULL
);

CREATE TABLE usuarios (
    id_usuario INTEGER PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20)
    data_cadastro DATE DEFAULT CURRENT_DATE
);

CREATE TABLE livros (
    id_livro INTEGER PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    disponivel BOOLEAN NOT NULL DEFAULT TRUE,
    id_autor INTEGER NOT NULL,
        FOREIGN KEY (id_autor)
        REFERENCES autores(id_autor)
  );

CREATE TABLE emprestimos (
    id_emprestimo INTEGER PRIMARY KEY,
    id_livro INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    data_emprestimo DATE NOT NULL  CURRENT_DATE,
    data_devolucao DATE NOT NULL,
        FOREIGN KEY (id_livro)
        REFERENCES livros(id_livro),
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
);
INSERT INTO autores (id_autor,nome,) VALUES
(11,'Machado de Assis',),
(22,'George Orwell',),
(33,'J. K. Rowling',),
(44,'Clarice Lispector',);

INSERT INTO livros ( id_livro,titulo, disponivel, id_autor) VALUES
(11,'Dom Casmurro', 1899, 'Companhia das Letras', TRUE, 11),
(22,'Memórias Póstumas de Brás Cubas', 1881, 'Penguin', TRUE, 11),
(33,'1984', 1949, 'Companhia das Letras', TRUE, 22),
(44,'A Revolução dos Bichos', 1945, 'Globo', TRUE, 22),
(55,'Harry Potter e a Pedra Filosofal', 1997, 'Rocco', TRUE, 33),
(66,'A Hora da Estrela', 1977, 'Rocco', TRUE, 44);

INSERT INTO usuarios (id_usuario,nome, telefone) VALUES
(111,'Ana Silva','11999990001'),
(222,'Bruno Souza','11999990002'),
(333,'Carla Mendes', '11999990003');

INSERT INTO emprestimos 
(id_livro, id_usuario, data_emprestimo,  data_devolucao) 
VALUES
(1, 1, '2025-03-01', '2025-03-15'),
(3, 2, '2025-03-05', '2025-03-19'),
(5, 1, '2025-03-10', '2025-03-24');


UPDATE livros SET disponivel = FALSE WHERE id_livro IN (1, 5);

-- Livro 3 foi devolvido
UPDATE livros SET disponivel = TRUE WHERE id_livro = 3;

SELECT * FROM livros;

SELECT l.titulo, a.nome AS autor
FROM livros l
JOIN autores a ON a.id_autor = l.id_autor
ORDER BY l.titulo;

SELECT l.titulo, a.nome AS autor
FROM livros l
JOIN autores a ON a.id_autor = l.id_autor
WHERE a.nome ILIKE '%Machado de Assis%';

SELECT id_livro, titulo
FROM livros
ORDER BY titulo ASC;
SELECT id_livro, titulo, disponivel
FROM livros
WHERE disponivel = TRUE
ORDER BY titulo;

UPDATE usuarios
SET nome = 'Ana Paula Silva'
WHERE id_usuario = 1;

UPDATE livros
SET disponivel = FALSE
WHERE id_livro = 2;

UPDATE emprestimos
SET data_devolucao = '2025-03-20'
WHERE id_emprestimo = 1;

UPDATE livros
SET disponivel = TRUE
WHERE id_livro = (
    SELECT id_livro
    FROM emprestimos
    WHERE id_emprestimo = 1
);

DELETE FROM usuarios
WHERE id_usuario = 3;-- Se o usuário tiver empréstimos, o DELETE direto vai falhar por causa da chave estrangeira. Nesse caso, exclua primeiro os empréstimos:

DELETE FROM emprestimos
WHERE id_usuario = 3;

DELETE FROM usuarios
WHERE id_usuario = 3;

DELETE FROM livros
WHERE id_livro = 6;

DELETE FROM emprestimos
WHERE id_livro = 6;

DELETE FROM livros
WHERE id_livro = 6;

SELECT u.nome AS usuario, l.titulo AS livro
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
ORDER BY u.nome, l.titulo;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_prevista_devolucao,
    e.data_devolucao
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
ORDER BY e.data_emprestimo;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_prevista_devolucao
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
WHERE e.data_devolucao IS NULL
ORDER BY e.data_emprestimo;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_prevista_devolucao
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
WHERE e.data_devolucao IS NULL
ORDER BY e.data_emprestimo;

SELECT 
    u.id_usuario,
    u.nome,
    COUNT(e.id_emprestimo) AS quantidade_emprestimos
FROM usuarios u
LEFT JOIN emprestimos e ON e.id_usuario = u.id_usuario
GROUP BY u.id_usuario, u.nome
ORDER BY quantidade_emprestimos DESC, u.nome;

SELECT l.id_livro, l.titulo
FROM livros l
LEFT JOIN emprestimos e ON e.id_livro = l.id_livro
WHERE e.id_emprestimo IS NULL
ORDER BY l.titulo;
