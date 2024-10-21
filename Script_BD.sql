-- -----------------------------------------------------
-- Table "editora"
-- -----------------------------------------------------
CREATE TABLE "editora" (
  "nome" VARCHAR(50) NOT NULL,
  "numero" VARCHAR(20) NOT NULL,
  "endereco" VARCHAR(100) NOT NULL,
  PRIMARY KEY ("nome"));

-- -----------------------------------------------------
-- Table "livro"
-- -----------------------------------------------------
CREATE TABLE  "livro" (
  "idlivro" INT NOT NULL,
  "titulo" VARCHAR(100) NOT NULL,
  "isbn" VARCHAR(17) NOT NULL,
  "edicao" SMALLINT NOT NULL,
  "editora" VARCHAR(50) NOT NULL,
  PRIMARY KEY ("idlivro"),
  CONSTRAINT "fk_editora"
    FOREIGN KEY ("editora")
    REFERENCES "editora" ("nome")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "exemplar"
-- -----------------------------------------------------
CREATE TABLE  "exemplar" (
  "idExemplar" INT NOT NULL,
  "idlivro" INT NOT NULL,
  "quantidade" SMALLINT NOT NULL DEFAULT 5,
  "disponivel" SMALLINT NOT NULL DEFAULT 1,
  CONSTRAINT CHK_Disponibilidade CHECK ("disponivel" = 0 OR "disponivel"= 1),
  PRIMARY KEY ("idExemplar"),
  CONSTRAINT "fk_livroexemplar"
    FOREIGN KEY ("idlivro")
    REFERENCES "livro" ("idlivro")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "usuario"
-- -----------------------------------------------------
CREATE TABLE  "usuario" (
  "username" VARCHAR(45) NOT NULL,
  "nome" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255) NOT NULL,
  "password" VARCHAR(32) NOT NULL,
  "matricula" VARCHAR(12) NULL,
  "isAluno" SMALLINT NOT NULL DEFAULT 0,
  "isProfessor" SMALLINT NOT NULL DEFAULT 0,
  "isExterno" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT CHK_Aluno CHECK ("isAluno"=0 OR "isAluno"=1),
  CONSTRAINT CHK_Profe CHECK ("isProfessor"=0 OR "isProfessor"=1),
  CONSTRAINT CHK_Exter CHECK ("isExterno"=0 OR "isExterno"=1),
  PRIMARY KEY ("username"));


-- -----------------------------------------------------
-- Table "funcionario" categorias
-- -----------------------------------------------------
CREATE TABLE "funcionario" (
  "idFuncionario" INT NOT NULL,
  "nome" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255) NOT NULL,
  "senha" VARCHAR(32) NOT NULL,
  "cargo" VARCHAR(45) NOT NULL,
  "dataIngresso" DATE NOT NULL,
  "salario" DECIMAL(10) NOT NULL DEFAULT 1412.00,
  PRIMARY KEY ("idFuncionario"));


-- -----------------------------------------------------
-- Table "emprestimo"
-- -----------------------------------------------------
CREATE TABLE  "emprestimo" (
  "codigoEmpr" INT NOT NULL,
  "usuario" VARCHAR(45) NOT NULL,
  "item" INT NOT NULL,
  "dataRetirada" DATE NOT NULL DEFAULT CURRENT_DATE,
  "prazoDevol" DATE NOT NULL DEFAULT (CURRENT_DATE + 7),
  "autorizadoPor" INT NOT NULL,
  PRIMARY KEY ("codigoEmpr"),
  CONSTRAINT "fk_exemplaremprestimo"
    FOREIGN KEY ("item")
    REFERENCES "exemplar" ("idExemplar")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_estacom"
    FOREIGN KEY ("usuario")
    REFERENCES "usuario" ("username")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_Autorizado"
    FOREIGN KEY ("autorizadoPor")
    REFERENCES "funcionario" ("idFuncionario")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "compra"
-- -----------------------------------------------------
CREATE TABLE  "compra" (
  "codigoCmpr" INT NOT NULL,
  "usuario" VARCHAR(45) NOT NULL,
  "item" INT NOT NULL,
  "valor" DECIMAL(10) NOT NULL,
  "vendidoPor" INT NOT NULL,
  PRIMARY KEY ("codigoCmpr"),
  CONSTRAINT "fk_item"
    FOREIGN KEY ("item")
    REFERENCES "livro" ("idlivro")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_idUsuario"
    FOREIGN KEY ("usuario")
    REFERENCES "usuario" ("username")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_Vendedor"
    FOREIGN KEY ("vendidoPor")
    REFERENCES "funcionario" ("idFuncionario")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "categorias"
-- -----------------------------------------------------
CREATE TABLE  "categorias" (
  "idCategoria" INT NOT NULL,
  "categoria" VARCHAR(45) NOT NULL,
  PRIMARY KEY ("idCategoria"));


-- -----------------------------------------------------
-- Table "autores"
-- -----------------------------------------------------
CREATE TABLE "autores" (
  "idAutor" INT NOT NULL,
  "autor" VARCHAR(45) NOT NULL,
  PRIMARY KEY ("idAutor"));


-- -----------------------------------------------------
-- Table "livrosInfo"
-- -----------------------------------------------------
CREATE TABLE "livrosInfo" (
  "idInfo" INT NOT NULL,
  "idlivro" INT NOT NULL,
  "idCategoria" INT NOT NULL,
  "idAutor" INT NOT NULL,
  PRIMARY KEY ("idInfo"),
  CONSTRAINT "fk_livro"
    FOREIGN KEY ("idlivro")
    REFERENCES "livro" ("idlivro")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_categoria"
    FOREIGN KEY ("idCategoria")
    REFERENCES "categorias" ("idCategoria")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_autor"
    FOREIGN KEY ("idAutor")
    REFERENCES "autores" ("idAutor")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
-- (!) KEY_BLOCK_SIZE = 2;


-- -----------------------------------------------------
-- Table "multa"
-- -----------------------------------------------------
CREATE TABLE "multa" (
  "idMulta" INT NOT NULL,
  "codigoEmpr" INT NOT NULL,
  "valor" DECIMAL(10) NOT NULL DEFAULT 50,
  "foiPaga" SMALLINT NOT NULL DEFAULT 0,
  CONSTRAINT CHK_Situacao CHECK ("foiPaga" = 0 OR "foiPaga" = 1),
  PRIMARY KEY ("idMulta"),
  CONSTRAINT "fk_codigoEmpr"
    FOREIGN KEY ("codigoEmpr")
    REFERENCES "emprestimo" ("codigoEmpr")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "recibo"
-- -----------------------------------------------------
CREATE TABLE "recibo" (
  "idRecibo" INT NOT NULL,
  "codigoCmpr" INT NOT NULL,
  "dataCmpr" DATE NOT NULL DEFAULT CURRENT_DATE,
  "nomeComprador" VARCHAR(255) NOT NULL,
  PRIMARY KEY ("idRecibo"),
  CONSTRAINT "fk_CodigoCompr"
    FOREIGN KEY ("codigoCmpr")
    REFERENCES "compra" ("codigoCmpr")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER "emprestimo_AFTER_INSERT" AFTER INSERT ON "emprestimo" FOR EACH ROW
BEGIN
UPDATE exemplar 
    quantidade = quantidade - 1
WHERE
    idExemplar = NEW.exemplar_idExemplar;
IF (NEW.quantidade = 0) THEN;
            UPDATE exemplar SET disponivel = 0;
      ELSE
            UPDATE exemplar SET disponivel = 1;
      END IF;
END$$

CREATE DEFINER = CURRENT_USER TRIGGER "emprestimo_AFTER_DELETE" AFTER DELETE ON "emprestimo" FOR EACH ROW
BEGIN
UPDATE exemplar SET quantidade = quantidade + 1 WHERE idExemplar = NEW.exemplar_idExemplar;
IF (NEW.quantidade >=1) THEN;
            UPDATE exemplar SET disponivel = 1;
      END IF;
END$$

CREATE DEFINER = CURRENT_USER TRIGGER "Compra_AFTER_INSERT" AFTER INSERT ON "compra" FOR EACH ROW
BEGIN
    UPDATE recibo SET NEW.dataCmpr = CURRENT_DATE;
    UPDATE recibo SET NEW.nomeComprador = usuario_username;
END$$

CREATE DEFINER = CURRENT_USER TRIGGER "Multa_BEFORE_INSERT" BEFORE INSERT ON "multa" FOR EACH ROW
BEGIN
IF (CURRENT_DATE > mprestimo_prazoDevol) THEN;
            UPDATE multa SET NEW.valor = (50.00);;
            UPDATE multa SET NEW.foiPaga = (0);;
      END IF;
END$$

CREATE DEFINER = CURRENT_USER TRIGGER "Multa_AFTER_DELETE" AFTER DELETE ON "multa" FOR EACH ROW
BEGIN
UPDATE exemplar SET quantidade = quantidade + 1 WHERE idExemplar = NEW.exemplar_idExemplar;
IF (NEW.quantidade >=1) THEN;
            UPDATE exemplar SET disponivel = 1;
      END IF;
END$$

DELIMITER;


-- -----------------------------------------------------
-- Data for table "editora" 
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "editora" ("nome", "numero", "endereco") VALUES ('Vozes', '55 11 11111111', 'SP - São Paulo - Centro - 201');;
INSERT INTO "editora" ("nome", "numero", "endereco") VALUES ('Unicamp', '55 11 11111112', 'SP - São Paulo - Centro - 111');;
INSERT INTO "editora" ("nome", "numero", "endereco") VALUES ('Penguin', '55 11 11111113', 'SP - São Paulo - Centro - 221');;
INSERT INTO "editora" ("nome", "numero", "endereco") VALUES ('Minnesota', '55 11 11111114', 'SP - São Paulo - Centro - 320');;
INSERT INTO "editora" ("nome", "numero", "endereco") VALUES ('Edusp', '55 11 11111115', 'SP - São Paulo - Centro - 50');;
INSERT INTO "editora" ("nome", "numero", "endereco") VALUES ('SAGE Publications', '55 11 11111116', 'SP - São Paulo - Centro - 101');;

COMMIT;


-- -----------------------------------------------------
-- Data for table "livro"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "livro" ("idlivro", "titulo", "isbn", "edicao", "editora") VALUES (10001, 'A Fenomenologia do Espirito', '978–85–111–0001–1', 4, 'Vozes');;
INSERT INTO "livro" ("idlivro", "titulo", "isbn", "edicao", "editora") VALUES (10002, 'Ser e Tempo', '978–85–222–0002–2', 10, 'Unicamp');;
INSERT INTO "livro" ("idlivro", "titulo", "isbn", "edicao", "editora") VALUES (10003, 'Critica da Razao Pura', '978–85–333–0003–3', 6, 'Penguin');;
INSERT INTO "livro" ("idlivro", "titulo", "isbn", "edicao", "editora") VALUES (10004, 'On the Existence of Digital Objects', '978–0–81–111111–1', 1, 'Minnesota');;
INSERT INTO "livro" ("idlivro", "titulo", "isbn", "edicao", "editora") VALUES (10005, 'Tractatus Logico-Philosophicus', '978–85–444–0004–4', 3, 'Edusp');;
INSERT INTO "livro" ("idlivro", "titulo", "isbn", "edicao", "editora") VALUES (10005, 'Cyberbodies Cyberspace Cyberpunk', '978-0-76-195085-1', 3, 'SAGE Publications');;

COMMIT;


-- -----------------------------------------------------
-- Data for table "exemplar"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "exemplar" ("idExemplar", "idlivro", "quantidade", "disponivel") VALUES (100011, 10001, 5, 1);;
INSERT INTO "exemplar" ("idExemplar", "idlivro", "quantidade", "disponivel") VALUES (100021, 10002, 5, 1);;
INSERT INTO "exemplar" ("idExemplar", "idlivro", "quantidade", "disponivel") VALUES (100031, 10003, 5, 1);;
INSERT INTO "exemplar" ("idExemplar", "idlivro", "quantidade", "disponivel") VALUES (100041, 10004, 5, 1);;
INSERT INTO "exemplar" ("idExemplar", "idlivro", "quantidade", "disponivel") VALUES (100051, 10005, 5, 1);;

COMMIT;


-- -----------------------------------------------------
-- Data for table "usuario"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "usuario" ("username", "nome", "email", "password", "matricula", "isAluno", "isProfessor") VALUES ('Professor', 'Andre', 'DComp@ufs.com.br', 'professor', '12345678', 0, 1, 0);;

COMMIT;


-- -----------------------------------------------------
-- Data for table "funcionario"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "funcionario" ("idFuncionario", "nome", "email", "senha", "cargo", "dataIngresso", "salario") VALUES (202402, 'Paulo', 'Paulo@gmail.com', 'daseinlivros', 'caixa', '01/01/2024', 1500.00);;

COMMIT;


-- -----------------------------------------------------
-- Data for table "categorias"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1001, 'Dialética');;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1002, 'Existencialismo');;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1003, 'Metafísica');;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1004, 'Tecnologia');;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1005, 'Filosofia Analítica');;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1006, 'Sociedade');;
INSERT INTO "categorias" ("idCategoria", "categoria") VALUES (1007, 'Cultura');;

COMMIT;


-- -----------------------------------------------------
-- Data for table "autores"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2001, 'Hegel');;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2002, 'Heidegger');;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2003, 'Kant');;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2004, 'Yuk Hui');;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2005, 'Wittgenstein');;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2006, 'Mike Featherstone');;
INSERT INTO "autores" ("idAutor", "autor") VALUES (2007, 'Roger Burrows');;

COMMIT;


-- -----------------------------------------------------
-- Data for table "livrosInfo"
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO "livrosInfo" ("idInfo", "idlivro", "idCategoria", "idAutor") VALUES (11001, 10001, 1001, 2001);;
INSERT INTO "livrosInfo" ("idInfo", "idlivro", "idCategoria", "idAutor") VALUES (11002, 10002, 1002, 2002);;
INSERT INTO "livrosInfo" ("idInfo", "idlivro", "idCategoria", "idAutor") VALUES (11003, 10003, 1003, 2003);;
INSERT INTO "livrosInfo" ("idInfo", "idlivro", "idCategoria", "idAutor") VALUES (11004, 10004, 1004, 2004);;
INSERT INTO "livrosInfo" ("idInfo", "idlivro", "idCategoria", "idAutor") VALUES (11005, 10005, 1005, 2005);;

COMMIT;

