--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.2

-- Started on 2023-02-15 09:27:22

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

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

--CREATE SCHEMA public;


--ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3340 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

--COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 25325)
-- Name: cities; Type: TABLE; Schema: public; Owner: pg_student
--

CREATE TABLE public.cities (
    cities_id integer NOT NULL,
    countries_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.cities OWNER TO pg_student;

--
-- TOC entry 212 (class 1259 OID 25330)
-- Name: cities_cities_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_student
--

ALTER TABLE public.cities ALTER COLUMN cities_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cities_cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 213 (class 1259 OID 25331)
-- Name: continents; Type: TABLE; Schema: public; Owner: pg_student
--

CREATE TABLE public.continents (
    continents_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.continents OWNER TO pg_student;

--
-- TOC entry 214 (class 1259 OID 25336)
-- Name: continents_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_student
--

ALTER TABLE public.continents ALTER COLUMN continents_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.continents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 215 (class 1259 OID 25337)
-- Name: countries; Type: TABLE; Schema: public; Owner: pg_student
--

CREATE TABLE public.countries (
    countries_id integer NOT NULL,
    continents_id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.countries OWNER TO pg_student;

--
-- TOC entry 216 (class 1259 OID 25342)
-- Name: countries_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: pg_student
--

ALTER TABLE public.countries ALTER COLUMN countries_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3329 (class 0 OID 25325)
-- Dependencies: 211
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: pg_student
--

COPY public.cities (cities_id, countries_id, name) FROM stdin;
1	1	Петр Иванов
2	2	Василий Петров
3	2	Иван Григорьев
4	1	Глеб Сидоров
5	8	Федор У
6	3	Иван Тюриков
7	4	Егор Глухов
8	2	Аня Петрова
\.


--
-- TOC entry 3331 (class 0 OID 25331)
-- Dependencies: 213
-- Data for Name: continents; Type: TABLE DATA; Schema: public; Owner: pg_student
--

COPY public.continents (continents_id, name) FROM stdin;
1	Гимназия 17
2	Школа 9
3	Лицей 10
4	Лицей 1
5	Школа 5
\.


--
-- TOC entry 3333 (class 0 OID 25337)
-- Dependencies: 215
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: pg_student
--

COPY public.countries (countries_id, continents_id, name) FROM stdin;
1	1	9А
2	1	8Б
3	1	10А
5	5	5А
6	5	3В
7	4	5Г
8	2	9Б
4	3	1А
\.


--
-- TOC entry 3341 (class 0 OID 0)
-- Dependencies: 212
-- Name: cities_cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pg_student
--

SELECT pg_catalog.setval('public.cities_cities_id_seq', 8, true);


--
-- TOC entry 3342 (class 0 OID 0)
-- Dependencies: 214
-- Name: continents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pg_student
--

SELECT pg_catalog.setval('public.continents_id_seq', 5, true);


--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 216
-- Name: countries_countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pg_student
--

SELECT pg_catalog.setval('public.countries_countries_id_seq', 8, true);


--
-- TOC entry 3183 (class 2606 OID 25344)
-- Name: cities cities_pk; Type: CONSTRAINT; Schema: public; Owner: pg_student
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pk PRIMARY KEY (cities_id);


--
-- TOC entry 3185 (class 2606 OID 25346)
-- Name: continents continents_pk; Type: CONSTRAINT; Schema: public; Owner: pg_student
--

ALTER TABLE ONLY public.continents
    ADD CONSTRAINT continents_pk PRIMARY KEY (continents_id);


--
-- TOC entry 3187 (class 2606 OID 25348)
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: pg_student
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (countries_id);


--
-- TOC entry 3188 (class 2606 OID 25349)
-- Name: cities cities_fk; Type: FK CONSTRAINT; Schema: public; Owner: pg_student
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_fk FOREIGN KEY (countries_id) REFERENCES public.countries(countries_id);


--
-- TOC entry 3189 (class 2606 OID 25354)
-- Name: countries countries_fk; Type: FK CONSTRAINT; Schema: public; Owner: pg_student
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_fk FOREIGN KEY (continents_id) REFERENCES public.continents(continents_id);


-- Completed on 2023-02-15 09:27:24

--
-- PostgreSQL database dump complete
--

