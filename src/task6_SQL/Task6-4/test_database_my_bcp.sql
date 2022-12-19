--
-- PostgreSQL database dump
--

-- Dumped from database version 13.9 (Debian 13.9-1.pgdg110+1)
-- Dumped by pg_dump version 13.9 (Debian 13.9-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: orders_1; Type: TABLE; Schema: public; Owner: slava
--

CREATE TABLE public.orders_1 (
    id integer,
    title character varying(80),
    price integer
);


ALTER TABLE public.orders_1 OWNER TO slava;

--
-- Name: orders_2; Type: TABLE; Schema: public; Owner: slava
--

CREATE TABLE public.orders_2 (
    id integer,
    title character varying(80),
    price integer
);


ALTER TABLE public.orders_2 OWNER TO slava;

--
-- Data for Name: orders_1; Type: TABLE DATA; Schema: public; Owner: slava
--

COPY public.orders_1 (id, title, price) FROM stdin;
2	My little database	500
6	WAL never lies	900
8	Dbiezdmin	501
\.


--
-- Data for Name: orders_2; Type: TABLE DATA; Schema: public; Owner: slava
--

COPY public.orders_2 (id, title, price) FROM stdin;
1	War and peace	100
3	Adventure psql time	300
4	Server gravity falls	300
5	Log gossips	123
7	Me and my bash-pet	499
\.


--
-- PostgreSQL database dump complete
--

