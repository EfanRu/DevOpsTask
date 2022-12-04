--
-- PostgreSQL database dump
--

-- Dumped from database version 12.13 (Debian 12.13-1.pgdg110+1)
-- Dumped by pg_dump version 12.13 (Debian 12.13-1.pgdg110+1)

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
-- Name: clients; Type: TABLE; Schema: public; Owner: test-admin-user
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    "фамилия" character varying(25) NOT NULL,
    "страна проживания" character varying(35),
    "заказ" integer
);


ALTER TABLE public.clients OWNER TO "test-admin-user";

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: test-admin-user
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO "test-admin-user";

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: test-admin-user
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: clients_заказ_seq; Type: SEQUENCE; Schema: public; Owner: test-admin-user
--

CREATE SEQUENCE public."clients_заказ_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."clients_заказ_seq" OWNER TO "test-admin-user";

--
-- Name: clients_заказ_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: test-admin-user
--

ALTER SEQUENCE public."clients_заказ_seq" OWNED BY public.clients."заказ";


--
-- Name: orders; Type: TABLE; Schema: public; Owner: test-admin-user
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    "наименование" character varying(50) NOT NULL,
    "цена" integer NOT NULL
);


ALTER TABLE public.orders OWNER TO "test-admin-user";

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: test-admin-user
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO "test-admin-user";

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: test-admin-user
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: test-admin-user
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: clients заказ; Type: DEFAULT; Schema: public; Owner: test-admin-user
--

ALTER TABLE ONLY public.clients ALTER COLUMN "заказ" SET DEFAULT nextval('public."clients_заказ_seq"'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: test-admin-user
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: test-admin-user
--

COPY public.clients (id, "фамилия", "страна проживания", "заказ") FROM stdin;
4	Ронни Джеймс Дио	Russia	\N
5	Ritchie Blackmore	Russia	\N
3	Иоганн Себастьян Бах	Japan	5
2	Петров Петр Петрович	Canada	4
1	Иванов Иван Иванович	USA	3
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: test-admin-user
--

COPY public.orders (id, "наименование", "цена") FROM stdin;
1	Шоколад	10
2	Принтер	3000
3	Книга	500
4	Монитор	7000
5	Гитара	4000
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test-admin-user
--

SELECT pg_catalog.setval('public.clients_id_seq', 1, false);


--
-- Name: clients_заказ_seq; Type: SEQUENCE SET; Schema: public; Owner: test-admin-user
--

SELECT pg_catalog.setval('public."clients_заказ_seq"', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: test-admin-user
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: test-admin-user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: test-admin-user
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: country_index; Type: INDEX; Schema: public; Owner: test-admin-user
--

CREATE INDEX country_index ON public.clients USING btree ("страна проживания");


--
-- Name: clients clients_заказ_fkey; Type: FK CONSTRAINT; Schema: public; Owner: test-admin-user
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES public.orders(id);


--
-- Name: TABLE clients; Type: ACL; Schema: public; Owner: test-admin-user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clients TO "test-simple-user";


--
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: test-admin-user
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.orders TO "test-simple-user";


--
-- PostgreSQL database dump complete
--

