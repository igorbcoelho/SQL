﻿-- SCRIPT PARA RESETAR A SENHA DO USUARIO MESTRE

UPDATE NS.USUARIOS
SET SENHA = '285343-343-285343-343-285343-343-285343-343-285343-343-285343-343-'
WHERE LOGIN = 'MESTRE';


/*
-- EXECUTAR SEMPRE QUE RESTAURAR UM BACKUP EM UMA INSTALAÇÃO NOVA DO POSTGRES

-- CRIAR ROLES DA NASAJON

CREATE ROLE group_nasajon
  NOSUPERUSER INHERIT NOCREATEDB CREATEROLE NOREPLICATION;

CREATE ROLE nsj_integratto_admin LOGIN
 ENCRYPTED PASSWORD 'md5c5455f79ca3605c4286e3285e7f688eb'
 NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
GRANT group_nasajon TO nsj_integratto_admin;

-- APLICAR PERMISSÕES DO POSTGRES AOS USUÁRIOS DO SISTEMA
SELECT NS.PROCESSOPOSRESTORE();
*/
