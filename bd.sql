CREATE DATABASE    teste;
CREATE TABLE autores (
    id_autor INTEGER PRIMARY KEY,
    nome VARCHAR(120) NOT NULL
);

CREATE TABLE usuarios (
    id_usuario INTEGER PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    telefone VARCHAR(20),
    data_cadastro DATE 
);

CREATE TABLE livros (
    id_livro INTEGER PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    disponivel BOOLEAN NOT NULL,
    id_autor INTEGER NOT NULL,
        FOREIGN KEY (id_autor)
        REFERENCES autores(id_autor)
  );

CREATE TABLE emprestimos (
    id_emprestimo INTEGER PRIMARY KEY,
    id_livro INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    data_emprestimo DATE NOT NULL  ,
    data_devolucao DATE NOT NULL,
        FOREIGN KEY (id_livro)
        REFERENCES livros(id_livro),
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
);
INSERT INTO autores (id_autor,nome) VALUES
(11,'Machado de Assis'),
(22,'George Orwell'),
(33,'J. K. Rowling'),
(44,'Clarice Lispector');

INSERT INTO livros ( id_livro,titulo, disponivel, id_autor) VALUES
(11,'Dom Casmurro', TRUE, 11),
(22,'Memórias Póstumas de Brás Cubas', TRUE, 11),
(33,'1984',  TRUE, 22),
(44,'A Revolução dos Bichos',  TRUE, 22),
(55,'Harry Potter e a Pedra Filosofal', TRUE, 33),
(66,'A Hora da Estrela', TRUE, 44);

INSERT INTO usuarios (id_usuario,nome, telefone,data_cadastro) VALUES
(111,'Ana Silva','11999990001', '2025-03-15'),
(222,'Bruno Souza','11999990002', '2025-03-15'),
(333,'Carla Mendes', '11999990003', '2025-03-15');

INSERT INTO emprestimos 
(id_emprestimo,id_livro, id_usuario, data_emprestimo,  data_devolucao) 
VALUES
(1,11, 111, '2025-03-01', '2025-03-15'),
(2,33, 222, '2025-03-05', '2025-03-19'),
(3,55, 111, '2025-03-10', '2025-03-24');

SELECT * FROM livros;

SELECT titulo, nome 
FROM livros 
JOIN autores  ON autores.id_autor = livros.id_autor
ORDER BY livros.titulo;

SELECT livros.titulo, autores.nome 
FROM livros 
JOIN autores  ON autores.id_autor = livros.id_autor
WHERE autores.nome LIKE '%Machado de Assis%';

SELECT id_livro, titulo
FROM livros
ORDER BY titulo ASC;

SELECT id_livro, titulo, disponivel
FROM livros
WHERE disponivel = TRUE
ORDER BY titulo;
-- fim da 14)
 UPDATE livros SET disponivel = FALSE WHERE id_livro =22 ;

UPDATE livros SET disponivel = TRUE WHERE id_livro = 22;
UPDATE usuarios
SET nome = 'Ana Paula Silva'
WHERE id_usuario = 111;

UPDATE livros
SET disponivel = FALSE
WHERE id_livro = 22;

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
WHERE id_usuario = 333;
-- Se o usuário tiver empréstimos, o DELETE direto vai falhar por causa da chave estrangeira.Caso ele tenha vai dar um erro por isso,
--se deve excluit primeiro os empréstimos dele:

DELETE FROM emprestimos
WHERE id_usuario = 333;

DELETE FROM usuarios
WHERE id_usuario = 333;

DELETE FROM livros
WHERE id_livro = 66;
-- Se o livro tiver empréstimos, o DELETE direto vai falhar por causa da chave estrangeira.Caso ele tenha vai dar um erro por isso,
--se deve excluit primeiro os empréstimos dele:

DELETE FROM emprestimos
WHERE id_livro = 66;

DELETE FROM livros
WHERE id_livro = 66;
--fim 15)
-- o resto é a 16)
SELECT usuarios.nome  usuario, livros.titulo 
FROM emprestimos
JOIN usuarios ON usuarios.id_usuario = emprestimos.id_usuario
JOIN livros  ON livros.id_livro = emprestimos.id_livro
ORDER BY usuarios.nome, livros.titulo;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo,
    e.data_devolucao
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
ORDER BY e.data_emprestimo;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo
FROM emprestimos e
JOIN usuarios u ON u.id_usuario = e.id_usuario
JOIN livros l ON l.id_livro = e.id_livro
WHERE e.data_devolucao IS NULL
ORDER BY e.data_emprestimo;

SELECT 
    e.id_emprestimo,
    u.nome AS usuario,
    l.titulo AS livro,
    e.data_emprestimo
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
