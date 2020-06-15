SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname IN ('integratto2_homologacao','contratos');

DROP DATABASE contratos;

CREATE DATABASE contratos WITH ENCODING 'UTF-8' TEMPLATE integratto2_homologacao;

ALTER DATABASE contratos SET client_encoding = 'WIN1252';