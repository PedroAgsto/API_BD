--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2024-10-22 11:54:11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4948 (class 1262 OID 5)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 4948
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 17371)
-- Name: autores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.autores (
    "idAutor" integer NOT NULL,
    autor character varying(45) NOT NULL
);


ALTER TABLE public.autores OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17366)
-- Name: categorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias (
    "idCategoria" integer NOT NULL,
    categoria character varying(45) NOT NULL
);


ALTER TABLE public.categorias OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17346)
-- Name: compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compra (
    "codigoCmpr" integer NOT NULL,
    usuario character varying(45) NOT NULL,
    item integer NOT NULL,
    valor numeric(10,0) NOT NULL,
    "vendidoPor" integer NOT NULL
);


ALTER TABLE public.compra OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 17442)
-- Name: editora; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.editora (
    ideditora integer NOT NULL,
    nome character varying(50) NOT NULL,
    numero character varying(20) NOT NULL,
    endereco character varying(100) NOT NULL
);


ALTER TABLE public.editora OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 17507)
-- Name: emprestimo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emprestimo (
    "codigoEmpr" integer NOT NULL,
    usuario character varying(45) NOT NULL,
    item integer NOT NULL,
    "dataRetirada" date DEFAULT CURRENT_DATE NOT NULL,
    "prazoDevol" date DEFAULT (CURRENT_DATE + 7) NOT NULL,
    "autorizadoPor" integer NOT NULL
);


ALTER TABLE public.emprestimo OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17494)
-- Name: exemplar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exemplar (
    "idExemplar" integer NOT NULL,
    tituloexemplar character varying(100) NOT NULL,
    idlivro integer NOT NULL,
    quantidade smallint DEFAULT 5 NOT NULL,
    disponivel smallint DEFAULT 1 NOT NULL,
    CONSTRAINT chk_disponibilidade CHECK (((disponivel = 0) OR (disponivel = 1)))
);


ALTER TABLE public.exemplar OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17316)
-- Name: funcionario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funcionario (
    "idFuncionario" integer NOT NULL,
    nome character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    senha character varying(32) NOT NULL,
    cargo character varying(45) NOT NULL,
    "dataIngresso" date NOT NULL,
    salario numeric(10,0) DEFAULT 1412.00 NOT NULL
);


ALTER TABLE public.funcionario OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17272)
-- Name: livro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.livro (
    idlivro integer NOT NULL,
    titulo character varying(100) NOT NULL,
    isbn character varying(17) NOT NULL,
    edicao smallint NOT NULL,
    id_editora integer NOT NULL
);


ALTER TABLE public.livro OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 17470)
-- Name: livrosInfo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."livrosInfo" (
    "idInfo" integer NOT NULL,
    idlivro integer NOT NULL,
    "idCategoria" integer NOT NULL,
    "idAutor" integer NOT NULL
);


ALTER TABLE public."livrosInfo" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17469)
-- Name: livrosInfo_idInfo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."livrosInfo_idInfo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."livrosInfo_idInfo_seq" OWNER TO postgres;

--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 225
-- Name: livrosInfo_idInfo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."livrosInfo_idInfo_seq" OWNED BY public."livrosInfo"."idInfo";


--
-- TOC entry 229 (class 1259 OID 17529)
-- Name: multa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.multa (
    "idMulta" integer NOT NULL,
    "codigoEmpr" integer NOT NULL,
    valor numeric(10,0) DEFAULT 50 NOT NULL,
    "foiPaga" smallint DEFAULT 0 NOT NULL,
    CONSTRAINT chk_situacao CHECK ((("foiPaga" = 0) OR ("foiPaga" = 1)))
);


ALTER TABLE public.multa OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17409)
-- Name: recibo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recibo (
    "idRecibo" integer NOT NULL,
    "codigoCmpr" integer NOT NULL,
    "dataCmpr" date DEFAULT CURRENT_DATE NOT NULL,
    "nomeComprador" character varying(255) NOT NULL
);


ALTER TABLE public.recibo OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17303)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    username character varying(45) NOT NULL,
    nome character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(32) NOT NULL,
    matricula character varying(12),
    "isAluno" smallint DEFAULT 0 NOT NULL,
    "isProfessor" smallint DEFAULT 0 NOT NULL,
    "isExterno" smallint DEFAULT 0 NOT NULL,
    CONSTRAINT chk_aluno CHECK ((("isAluno" = 0) OR ("isAluno" = 1))),
    CONSTRAINT chk_exter CHECK ((("isExterno" = 0) OR ("isExterno" = 1))),
    CONSTRAINT chk_profe CHECK ((("isProfessor" = 0) OR ("isProfessor" = 1)))
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 4733 (class 2604 OID 17473)
-- Name: livrosInfo idInfo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."livrosInfo" ALTER COLUMN "idInfo" SET DEFAULT nextval('public."livrosInfo_idInfo_seq"'::regclass);


--
-- TOC entry 4935 (class 0 OID 17371)
-- Dependencies: 222
-- Data for Name: autores; Type: TABLE DATA; Schema: public; Owner: postgres
--

CREATE OR REPLACE FUNCTION atualizar_disponivel()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantidade = 0 THEN
        NEW.disponivel := 0;
    ELSE
        NEW.disponivel := 1;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualizar_disponivel
BEFORE INSERT OR UPDATE ON exemplar
FOR EACH ROW
EXECUTE FUNCTION atualizar_disponivel();

INSERT INTO public.autores VALUES (2001, 'Hegel');
INSERT INTO public.autores VALUES (2002, 'Heidegger');
INSERT INTO public.autores VALUES (2003, 'Kant');
INSERT INTO public.autores VALUES (2004, 'Yuk Hui');
INSERT INTO public.autores VALUES (2005, 'Wittgenstein');
INSERT INTO public.autores VALUES (2006, 'Mike Featherstone');
INSERT INTO public.autores VALUES (2007, 'Roger Burrows');


--
-- TOC entry 4934 (class 0 OID 17366)
-- Dependencies: 221
-- Data for Name: categorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.categorias VALUES (1001, 'Dialética');
INSERT INTO public.categorias VALUES (1002, 'Existencialismo');
INSERT INTO public.categorias VALUES (1003, 'Metafísica');
INSERT INTO public.categorias VALUES (1004, 'Tecnologia');
INSERT INTO public.categorias VALUES (1005, 'Filosofia Analítica');
INSERT INTO public.categorias VALUES (1006, 'Sociedade');
INSERT INTO public.categorias VALUES (1007, 'Cultura');


--
-- TOC entry 4933 (class 0 OID 17346)
-- Dependencies: 220
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4937 (class 0 OID 17442)
-- Dependencies: 224
-- Data for Name: editora; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.editora VALUES (22111, 'Vozes', '55 11 11111111', 'SP - São Paulo - Centro - 201');
INSERT INTO public.editora VALUES (22112, 'Unicamp', '55 11 11111112', 'SP - São Paulo - Centro - 111');
INSERT INTO public.editora VALUES (22113, 'Penguin', '55 11 11111113', 'SP - São Paulo - Centro - 221');
INSERT INTO public.editora VALUES (22114, 'Minnesota', '55 11 11111114', 'SP - São Paulo - Centro - 320');
INSERT INTO public.editora VALUES (22115, 'Edusp', '55 11 11111115', 'SP - São Paulo - Centro - 50');
INSERT INTO public.editora VALUES (22116, 'SAGE Publications', '55 11 11111116', 'SP - São Paulo - Centro - 101');


--
-- TOC entry 4941 (class 0 OID 17507)
-- Dependencies: 228
-- Data for Name: emprestimo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4940 (class 0 OID 17494)
-- Dependencies: 227
-- Data for Name: exemplar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.exemplar VALUES (100021, 'Ser e Tempo', 10002, 5, 1);
INSERT INTO public.exemplar VALUES (100031, 'Critica da Razao Pura', 10003, 5, 1);
INSERT INTO public.exemplar VALUES (100041, 'On the Existence of Digital Objects', 10004, 5, 1);
INSERT INTO public.exemplar VALUES (100061, 'Cyberbodies Cyberspace Cyberpunk', 10006, 5, 1);
INSERT INTO public.exemplar VALUES (100051, 'Tractatus Logico-Philosophicus', 10005, 5, 1);
INSERT INTO public.exemplar VALUES (100011, 'A Fenomenologia do Espirito', 10001, 5, 1);


--
-- TOC entry 4932 (class 0 OID 17316)
-- Dependencies: 219
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.funcionario VALUES (202402, 'Paulo', 'Paulo@gmail.com', 'daseinlivros', 'caixa', '2024-01-01', 1500);
INSERT INTO public.funcionario VALUES (202402, 'Pedro', 'Pedro@gmail.com', 'daseinpedro', 'limpeza', '2023-10-02', 1500);
INSERT INTO public.funcionario VALUES (202402, 'Rita', 'Rita@gmail.com', 'daseinrita', 'reestoque', '2021-07-12', 1600);

--
-- TOC entry 4930 (class 0 OID 17272)
-- Dependencies: 217
-- Data for Name: livro; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.livro VALUES (10003, 'Critica da Razao Pura', '978–85–333–0003–3', 6, 22113);
INSERT INTO public.livro VALUES (10004, 'On the Existence of Digital Objects', '978–0–81–111111–1', 1, 22114);
INSERT INTO public.livro VALUES (10005, 'Tractatus Logico-Philosophicus', '978–85–444–0004–4', 3, 22115);
INSERT INTO public.livro VALUES (10006, 'Cyberbodies Cyberspace Cyberpunk', '978-0-76-195085-1', 3, 22116);
INSERT INTO public.livro VALUES (10001, 'A Fenomenologia do Espirito', '978–85–111–0001–1', 4, 22111);
INSERT INTO public.livro VALUES (10002, 'Ser e Tempo', '978–85–222–0002–2', 10, 22112);


--
-- TOC entry 4939 (class 0 OID 17470)
-- Dependencies: 226
-- Data for Name: livrosInfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."livrosInfo" VALUES (1, 10001, 1001, 2001);
INSERT INTO public."livrosInfo" VALUES (2, 10001, 1003, 2001);
INSERT INTO public."livrosInfo" VALUES (3, 10002, 1002, 2002);
INSERT INTO public."livrosInfo" VALUES (4, 10002, 1002, 2001);
INSERT INTO public."livrosInfo" VALUES (5, 10002, 1003, 2001);
INSERT INTO public."livrosInfo" VALUES (6, 10003, 1003, 2003);
INSERT INTO public."livrosInfo" VALUES (7, 10003, 1006, 2003);
INSERT INTO public."livrosInfo" VALUES (8, 10004, 1004, 2004);
INSERT INTO public."livrosInfo" VALUES (9, 10004, 1006, 2004);
INSERT INTO public."livrosInfo" VALUES (10, 10004, 1007, 2004);
INSERT INTO public."livrosInfo" VALUES (11, 10005, 1005, 2005);
INSERT INTO public."livrosInfo" VALUES (12, 10005, 1003, 2005);
INSERT INTO public."livrosInfo" VALUES (13, 10002, 1004, 2006);
INSERT INTO public."livrosInfo" VALUES (14, 10002, 1006, 2006);
INSERT INTO public."livrosInfo" VALUES (15, 10002, 1007, 2006);
INSERT INTO public."livrosInfo" VALUES (16, 10002, 1004, 2007);
INSERT INTO public."livrosInfo" VALUES (17, 10002, 1006, 2007);
INSERT INTO public."livrosInfo" VALUES (18, 10002, 1007, 2007);


--
-- TOC entry 4942 (class 0 OID 17529)
-- Dependencies: 229
-- Data for Name: multa; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4936 (class 0 OID 17409)
-- Dependencies: 223
-- Data for Name: recibo; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4931 (class 0 OID 17303)
-- Dependencies: 218
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.usuario VALUES ('Professor', 'Andre', 'DComp@ufs.com.br', 'professor', '12345678', 0, 1, 0);
INSERT INTO public.usuario VALUES ('KateBush', 'Kate', 'Kate@umemail.com.br', 'senhakate', NULL, 0, 0, 1);
INSERT INTO public.usuario VALUES ('LauraPalmer', 'Laura', 'Laura@umemail.com.br', 'senhalaura', 20201234, 1, 0, 0);
INSERT INTO public.usuario VALUES ('Bowie', 'David', 'David@umemail.com.br', 'senhadavid', NULL, 0, 0, 1);
INSERT INTO public.usuario VALUES ('MNascimento', 'Milton', 'Milton@umemail.com.br', 'senhamilton', NULL, 0, 0, 1);
INSERT INTO public.usuario VALUES ('Beatriz', 'Beatriz', 'Beatriz@ufs.com.br', 'professor', '12348765', 0, 1, 0);

--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 225
-- Name: livrosInfo_idInfo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."livrosInfo_idInfo_seq"', 18, true);


--
-- TOC entry 4756 (class 2606 OID 17375)
-- Name: autores autores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.autores
    ADD CONSTRAINT autores_pkey PRIMARY KEY ("idAutor");


--
-- TOC entry 4754 (class 2606 OID 17370)
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY ("idCategoria");


--
-- TOC entry 4752 (class 2606 OID 17350)
-- Name: compra compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY ("codigoCmpr");


--
-- TOC entry 4760 (class 2606 OID 17446)
-- Name: editora editora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.editora
    ADD CONSTRAINT editora_pkey PRIMARY KEY (ideditora);


--
-- TOC entry 4768 (class 2606 OID 17513)
-- Name: emprestimo emprestimo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT emprestimo_pkey PRIMARY KEY ("codigoEmpr");


--
-- TOC entry 4766 (class 2606 OID 17501)
-- Name: exemplar exemplar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT exemplar_pkey PRIMARY KEY ("idExemplar");


--
-- TOC entry 4750 (class 2606 OID 17323)
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY ("idFuncionario");


--
-- TOC entry 4746 (class 2606 OID 17276)
-- Name: livro livro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livro
    ADD CONSTRAINT livro_pkey PRIMARY KEY (idlivro);


--
-- TOC entry 4762 (class 2606 OID 17477)
-- Name: livrosInfo livrosInfo_idlivro_idCategoria_idAutor_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."livrosInfo"
    ADD CONSTRAINT "livrosInfo_idlivro_idCategoria_idAutor_key" UNIQUE (idlivro, "idCategoria", "idAutor");


--
-- TOC entry 4764 (class 2606 OID 17475)
-- Name: livrosInfo livrosInfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."livrosInfo"
    ADD CONSTRAINT "livrosInfo_pkey" PRIMARY KEY ("idInfo");


--
-- TOC entry 4770 (class 2606 OID 17536)
-- Name: multa multa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT multa_pkey PRIMARY KEY ("idMulta");


--
-- TOC entry 4758 (class 2606 OID 17414)
-- Name: recibo recibo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recibo
    ADD CONSTRAINT recibo_pkey PRIMARY KEY ("idRecibo");


--
-- TOC entry 4748 (class 2606 OID 17315)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (username);


--
-- TOC entry 4783 (class 2620 OID 17543)
-- Name: exemplar trg_atualizar_disponivel; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_atualizar_disponivel AFTER INSERT OR UPDATE ON public.exemplar FOR EACH ROW EXECUTE FUNCTION public.atualizar_disponivel();


--
-- TOC entry 4784 (class 2620 OID 17544)
-- Name: exemplar trigger_atualizar_disponivel; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_atualizar_disponivel BEFORE INSERT OR UPDATE ON public.exemplar FOR EACH ROW EXECUTE FUNCTION public.atualizar_disponivel();


--
-- TOC entry 4779 (class 2606 OID 17524)
-- Name: emprestimo fk_Autorizado; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT "fk_Autorizado" FOREIGN KEY ("autorizadoPor") REFERENCES public.funcionario("idFuncionario");


--
-- TOC entry 4774 (class 2606 OID 17415)
-- Name: recibo fk_CodigoCompr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recibo
    ADD CONSTRAINT "fk_CodigoCompr" FOREIGN KEY ("codigoCmpr") REFERENCES public.compra("codigoCmpr");


--
-- TOC entry 4771 (class 2606 OID 17361)
-- Name: compra fk_Vendedor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT "fk_Vendedor" FOREIGN KEY ("vendidoPor") REFERENCES public.funcionario("idFuncionario");


--
-- TOC entry 4775 (class 2606 OID 17488)
-- Name: livrosInfo fk_autor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."livrosInfo"
    ADD CONSTRAINT fk_autor FOREIGN KEY ("idAutor") REFERENCES public.autores("idAutor") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4776 (class 2606 OID 17483)
-- Name: livrosInfo fk_categoria; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."livrosInfo"
    ADD CONSTRAINT fk_categoria FOREIGN KEY ("idCategoria") REFERENCES public.categorias("idCategoria") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4782 (class 2606 OID 17537)
-- Name: multa fk_codigoEmpr; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.multa
    ADD CONSTRAINT "fk_codigoEmpr" FOREIGN KEY ("codigoEmpr") REFERENCES public.emprestimo("codigoEmpr");


--
-- TOC entry 4780 (class 2606 OID 17519)
-- Name: emprestimo fk_estacom; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT fk_estacom FOREIGN KEY (usuario) REFERENCES public.usuario(username);


--
-- TOC entry 4781 (class 2606 OID 17514)
-- Name: emprestimo fk_exemplaremprestimo; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emprestimo
    ADD CONSTRAINT fk_exemplaremprestimo FOREIGN KEY (item) REFERENCES public.exemplar("idExemplar");


--
-- TOC entry 4772 (class 2606 OID 17356)
-- Name: compra fk_idUsuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT "fk_idUsuario" FOREIGN KEY (usuario) REFERENCES public.usuario(username);


--
-- TOC entry 4773 (class 2606 OID 17351)
-- Name: compra fk_item; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_item FOREIGN KEY (item) REFERENCES public.livro(idlivro);


--
-- TOC entry 4777 (class 2606 OID 17478)
-- Name: livrosInfo fk_livro; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."livrosInfo"
    ADD CONSTRAINT fk_livro FOREIGN KEY (idlivro) REFERENCES public.livro(idlivro) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4778 (class 2606 OID 17502)
-- Name: exemplar fk_livroexemplar; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exemplar
    ADD CONSTRAINT fk_livroexemplar FOREIGN KEY (idlivro) REFERENCES public.livro(idlivro) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-10-22 11:54:12

--
-- PostgreSQL database dump complete
--
