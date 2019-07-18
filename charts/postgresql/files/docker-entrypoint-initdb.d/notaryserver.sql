--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)

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
-- Name: notaryserver; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE notaryserver WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE notaryserver OWNER TO postgres;

\connect notaryserver

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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: change_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.change_category (
    category character varying(20) NOT NULL
);


ALTER TABLE public.change_category OWNER TO postgres;

--
-- Name: changefeed; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.changefeed (
    id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    gun character varying(255) NOT NULL,
    version integer NOT NULL,
    sha256 character(64) DEFAULT NULL::bpchar,
    category character varying(20) DEFAULT 'update'::character varying NOT NULL
);


ALTER TABLE public.changefeed OWNER TO postgres;

--
-- Name: changefeed_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.changefeed_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.changefeed_id_seq OWNER TO postgres;

--
-- Name: changefeed_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.changefeed_id_seq OWNED BY public.changefeed.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: tuf_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tuf_files (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    gun character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    version integer NOT NULL,
    data bytea NOT NULL,
    sha256 character(64) DEFAULT NULL::bpchar
);


ALTER TABLE public.tuf_files OWNER TO postgres;

--
-- Name: tuf_files_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tuf_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tuf_files_id_seq OWNER TO postgres;

--
-- Name: tuf_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tuf_files_id_seq OWNED BY public.tuf_files.id;


--
-- Name: changefeed id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.changefeed ALTER COLUMN id SET DEFAULT nextval('public.changefeed_id_seq'::regclass);


--
-- Name: tuf_files id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tuf_files ALTER COLUMN id SET DEFAULT nextval('public.tuf_files_id_seq'::regclass);


--
-- Data for Name: change_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.change_category VALUES ('update');
INSERT INTO public.change_category VALUES ('deletion');


--
-- Data for Name: changefeed; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations VALUES (2, false);


--
-- Data for Name: tuf_files; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: changefeed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.changefeed_id_seq', 1, false);


--
-- Name: tuf_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tuf_files_id_seq', 1, false);


--
-- Name: change_category change_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.change_category
    ADD CONSTRAINT change_category_pkey PRIMARY KEY (category);


--
-- Name: changefeed changefeed_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.changefeed
    ADD CONSTRAINT changefeed_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tuf_files tuf_files_gun_role_version_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tuf_files
    ADD CONSTRAINT tuf_files_gun_role_version_key UNIQUE (gun, role, version);


--
-- Name: tuf_files tuf_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tuf_files
    ADD CONSTRAINT tuf_files_pkey PRIMARY KEY (id);


--
-- Name: idx_changefeed_gun; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_changefeed_gun ON public.changefeed USING btree (gun);


--
-- Name: tuf_files_sha256_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tuf_files_sha256_idx ON public.tuf_files USING btree (sha256);


--
-- Name: changefeed changefeed_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.changefeed
    ADD CONSTRAINT changefeed_category_fkey FOREIGN KEY (category) REFERENCES public.change_category(category);


--
-- PostgreSQL database dump complete
--

