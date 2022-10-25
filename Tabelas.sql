/*
S01USUARIO
S02PERFIL
S03DEPARTAMENTO
S04MODULO
*/

-- DDL
CREATE TABLE S04MODULO (
ID_MODULO NUMBER(3) NOT NULL,
DESCRICAO_MODULO VARCHAR2(100) NOT NULL,
CONSTRAINT PK_ID_MODULO PRIMARY KEY (ID_MODULO));

CREATE TABLE S03DEPARTAMENTO (
ID_DEPTO NUMBER(3) NOT NULL,
DESCRICAO_DEPTO VARCHAR2(100) NOT NULL,
CONSTRAINT PK_ID_DEPTO PRIMARY KEY (ID_DEPTO));

CREATE TABLE S02PERFIL (
ID_PERFIL NUMBER(3) NOT NULL,
DESCRICAO_PERFIL VARCHAR2(100) NOT NULL,
ID_MODULO NUMBER(3) NOT NULL,
CONSTRAINT PK_ID_PERFIL PRIMARY KEY (ID_PERFIL),
CONSTRAINT FK_ID_MODULO FOREIGN KEY (ID_MODULO) REFERENCES S04MODULO(ID_MODULO));

ALTER TABLE S02PERFIL DROP CONSTRAINT FK_ID_MODULO;
ALTER TABLE S02PERFIL DROP COLUMN ID_MODULO;

CREATE TABLE S01USUARIO (
ID_USUARIO NUMBER(3) NOT NULL,
NOME_USER VARCHAR2(100) NOT NULL,
ID_DEPTO NUMBER(3) NOT NULL,
CONSTRAINT PK_ID_USUARIO PRIMARY KEY (ID_USUARIO),
CONSTRAINT FK_ID_DEPTO FOREIGN KEY (ID_DEPTO) REFERENCES S03DEPARTAMENTO(ID_DEPTO));

ALTER TABLE S01USUARIO ADD ID_PERFIL NUMBER(3);

ALTER TABLE S01USUARIO
ADD CONSTRAINT FK_ID_PERFIL
  FOREIGN KEY (ID_PERFIL)
  REFERENCES S02PERFIL(ID_PERFIL);
  
ALTER TABLE S01USUARIO ADD STATUS CHAR(1);
ALTER TABLE S01USUARIO ADD CPF NUMBER(11);
ALTER TABLE S01USUARIO ADD CONSTRAINT CK_STATUS CHECK (STATUS IN ('A','I'));


CREATE TABLE S05REL_PERFIL_MODULO (
ID_REL_PERF_MOD NUMBER(3) NOT NULL,
ID_PERFIL NUMBER(3) NOT NULL,
ID_DEPTO NUMBER(3) NOT NULL,
CONSTRAINT PK_ID_REL_PERF_MOD PRIMARY KEY (ID_REL_PERF_MOD),
CONSTRAINT FK2_ID_PERFIL FOREIGN KEY (ID_PERFIL) REFERENCES S02PERFIL(ID_PERFIL),
CONSTRAINT FK2_ID_DEPTO FOREIGN KEY (ID_DEPTO) REFERENCES S03DEPARTAMENTO(ID_DEPTO));

ALTER TABLE S05REL_PERFIL_MODULO DROP CONSTRAINT FK2_ID_DEPTO;
ALTER TABLE S05REL_PERFIL_MODULO DROP COLUMN ID_DEPTO;


ALTER TABLE S05REL_PERFIL_MODULO ADD ID_MODULO NUMBER(3);
ALTER TABLE S05REL_PERFIL_MODULO ADD CONSTRAINT FK2_ID_MODULO FOREIGN KEY (ID_MODULO) REFERENCES S04MODULO(ID_MODULO);

--DML

SELECT * FROM S04MODULO;
INSERT INTO S04MODULO VALUES (1, 'FINANCEIRO');
INSERT INTO S04MODULO VALUES (2, 'FATURAMENTO');
INSERT INTO S04MODULO VALUES (3, 'EXPEDICAO');

SELECT * FROM S03DEPARTAMENTO;
INSERT INTO S03DEPARTAMENTO VALUES (1, 'CONTAS_A_PAGAR');
INSERT INTO S03DEPARTAMENTO VALUES (2, 'CONTAS_A_RECEBER');
INSERT INTO S03DEPARTAMENTO VALUES (3, 'ATENDIMENTO');

SELECT * FROM S02PERFIL;
INSERT INTO S02PERFIL VALUES (1,'CONTROLADORIA');
INSERT INTO S02PERFIL VALUES (2,'TESOURARIA');

SELECT * FROM S01USUARIO;
INSERT INTO S01USUARIO VALUES (1, 'MARCELO', 1, 1,'');
UPDATE S01USUARIO SET STATUS = 'A' WHERE ID_USUARIO = 1;
UPDATE S01USUARIO SET CPF = 12345678900 WHERE ID_USUARIO = 1;

SELECT * FROM S05REL_PERFIL_MODULO;
INSERT INTO S05REL_PERFIL_MODULO VALUES(1,1,1);
INSERT INTO S05REL_PERFIL_AMODULO VALUES(2,1,2);
INSERT INTO S05REL_PERFIL_MODULO VALUES(3,2,1);

-- MODULOS DO USU�RIO
SELECT M.DESCRICAO_MODULO AS MODULO
  FROM S01USUARIO U,
       S02PERFIL P,
       S05REL_PERFIL_MODULO REL,
       S04MODULO M
 WHERE U.ID_PERFIL = P.ID_PERFIL
   AND P.ID_PERFIL = REL.ID_PERFIL
   AND REL.ID_MODULO = M.ID_MODULO
   AND U.NOME_USER = 'MARCELO';
