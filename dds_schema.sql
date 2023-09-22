--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1 (Debian 14.1-1.pgdg110+1)
-- Dumped by pg_dump version 14.1 (Debian 14.1-1.pgdg110+1)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: downloads; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.downloads (
    download_id integer NOT NULL,
    download_uri character varying(255),
    request_id integer,
    storage_id integer,
    location_path character varying(255),
    size_bytes bigint,
    created_on timestamp without time zone NOT NULL
);


ALTER TABLE public.downloads OWNER TO dds;

--
-- Name: downloads_download_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.downloads_download_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.downloads_download_id_seq OWNER TO dds;

--
-- Name: downloads_download_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.downloads_download_id_seq OWNED BY public.downloads.download_id;


--
-- Name: requests; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.requests (
    request_id integer NOT NULL,
    status character varying(255) NOT NULL,
    priority integer,
    user_id uuid NOT NULL,
    worker_id integer,
    dataset character varying(255),
    product character varying(255),
    query json,
    estimate_size_bytes bigint,
    created_on timestamp without time zone NOT NULL,
    last_update timestamp without time zone,
    fail_reason character varying(1000)
);


ALTER TABLE public.requests OWNER TO dds;

--
-- Name: requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.requests_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.requests_request_id_seq OWNER TO dds;

--
-- Name: requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.requests_request_id_seq OWNED BY public.requests.request_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.roles (
    role_id integer NOT NULL,
    role_name character varying(255) NOT NULL
);


ALTER TABLE public.roles OWNER TO dds;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_role_id_seq OWNER TO dds;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: storages; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.storages (
    storage_id integer NOT NULL,
    name character varying(255),
    host character varying(20),
    protocol character varying(10),
    port integer
);


ALTER TABLE public.storages OWNER TO dds;

--
-- Name: storages_storage_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.storages_storage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.storages_storage_id_seq OWNER TO dds;

--
-- Name: storages_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.storages_storage_id_seq OWNED BY public.storages.storage_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.users (
    user_id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    api_key character varying(255) NOT NULL,
    contact_name character varying(255)
);


ALTER TABLE public.users OWNER TO dds;

--
-- Name: users_roles; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.users_roles (
    ur_id integer NOT NULL,
    user_id uuid NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.users_roles OWNER TO dds;

--
-- Name: users_roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.users_roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_roles_role_id_seq OWNER TO dds;

--
-- Name: users_roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.users_roles_role_id_seq OWNED BY public.users_roles.role_id;


--
-- Name: users_roles_ur_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.users_roles_ur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_roles_ur_id_seq OWNER TO dds;

--
-- Name: users_roles_ur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.users_roles_ur_id_seq OWNED BY public.users_roles.ur_id;


--
-- Name: workers; Type: TABLE; Schema: public; Owner: dds
--

CREATE TABLE public.workers (
    worker_id integer NOT NULL,
    status character varying(255) NOT NULL,
    host character varying(255),
    dask_scheduler_port integer,
    dask_dashboard_address character(10),
    created_on timestamp without time zone NOT NULL
);


ALTER TABLE public.workers OWNER TO dds;

--
-- Name: workers_worker_id_seq; Type: SEQUENCE; Schema: public; Owner: dds
--

CREATE SEQUENCE public.workers_worker_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.workers_worker_id_seq OWNER TO dds;

--
-- Name: workers_worker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dds
--

ALTER SEQUENCE public.workers_worker_id_seq OWNED BY public.workers.worker_id;


--
-- Name: downloads download_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.downloads ALTER COLUMN download_id SET DEFAULT nextval('public.downloads_download_id_seq'::regclass);


--
-- Name: requests request_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.requests ALTER COLUMN request_id SET DEFAULT nextval('public.requests_request_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: storages storage_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.storages ALTER COLUMN storage_id SET DEFAULT nextval('public.storages_storage_id_seq'::regclass);


--
-- Name: users_roles ur_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users_roles ALTER COLUMN ur_id SET DEFAULT nextval('public.users_roles_ur_id_seq'::regclass);


--
-- Name: users_roles role_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users_roles ALTER COLUMN role_id SET DEFAULT nextval('public.users_roles_role_id_seq'::regclass);


--
-- Name: workers worker_id; Type: DEFAULT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.workers ALTER COLUMN worker_id SET DEFAULT nextval('public.workers_worker_id_seq'::regclass);


--
-- Name: downloads downloads_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT downloads_pkey PRIMARY KEY (download_id);


--
-- Name: downloads downloads_request_id_key; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT downloads_request_id_key UNIQUE (request_id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (request_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: storages storages_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.storages
    ADD CONSTRAINT storages_pkey PRIMARY KEY (storage_id);


--
-- Name: users users_api_key_key; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_api_key_key UNIQUE (api_key);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users_roles users_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT users_roles_pkey PRIMARY KEY (ur_id);


--
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (worker_id);


--
-- Name: downloads fk_req; Type: FK CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT fk_req FOREIGN KEY (request_id) REFERENCES public.requests(request_id);


--
-- Name: users_roles fk_role; Type: FK CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


--
-- Name: users_roles fk_user; Type: FK CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.users_roles
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: requests fk_user; Type: FK CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: requests fk_worker; Type: FK CONSTRAINT; Schema: public; Owner: dds
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT fk_worker FOREIGN KEY (worker_id) REFERENCES public.workers(worker_id);


--
-- PostgreSQL database dump complete
--

