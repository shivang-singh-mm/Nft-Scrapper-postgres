CREATE DATABASE polygon;
CREATE DATABASE solana;
CREATE DATABASE ethereum;
CREATE DATABASE arbitrum;
CREATE DATABASE zksync;
CREATE DATABASE base;
CREATE DATABASE mantle;
CREATE DATABASE immutablex;
CREATE DATABASE tezos;
CREATE DATABASE flow;
CREATE DATABASE astarzkevm;
CREATE DATABASE rari;
CREATE DATABASE chiliz;
CREATE DATABASE lightlink;

\c postgres
    
CREATE TABLE blockchainList(
    uuid character varying(50) NOT NULL,
    status character varying(6),
    name character varying(100) NOT NULL
);  
INSERT INTO blockchainList values(gen_random_uuid(),'true','polygon');
INSERT INTO blockchainList values(gen_random_uuid(),'true','solana');
INSERT INTO blockchainList values(gen_random_uuid(),'true','ethereum');
INSERT INTO blockchainList values(gen_random_uuid(),'true','arbitrum');
INSERT INTO blockchainList values(gen_random_uuid(),'true','zksync');
INSERT INTO blockchainList values(gen_random_uuid(),'true','base');
INSERT INTO blockchainList values(gen_random_uuid(),'true','mantle');
INSERT INTO blockchainList values(gen_random_uuid(),'true','immutablex');
INSERT INTO blockchainList values(gen_random_uuid(),'true','tezos');
INSERT INTO blockchainList values(gen_random_uuid(),'true','flow');
INSERT INTO blockchainList values(gen_random_uuid(),'true','astarzkevm');
INSERT INTO blockchainList values(gen_random_uuid(),'true','rari');
INSERT INTO blockchainList values(gen_random_uuid(),'true','chiliz');
INSERT INTO blockchainList values(gen_random_uuid(),'true','lightlink');


\c polygon;
-- Dumped from database version 16.1 (Debian 16.1-1.pgdg120+1)
-- Dumped by pg_dump version 16.1

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--


CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


\c ethereum;

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);




\c flow

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;



--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);



\c tezos

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);



\c solana

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


\c immutablex

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);



\c  mantle

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


\c arbitrum

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);




\c chiliz

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);





\c lightlink

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);






\c zksync

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);




\c astarzkevm

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);




\c base

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);




\c rari

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
-- Name: assetStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."assetStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    asset_uuid character varying(32)
);


ALTER TABLE public."assetStatus" OWNER TO postgres;

--
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    uuid character varying(32) NOT NULL,
    blockchain character varying(20),
    asset_id character varying(200),
    token_id character varying(1000),
    name character varying(1000),
    image bytea,
    image_url character varying(1000),
    description character varying(10000),
    external_link character varying(1000),
    contract_address character varying(100),
    price character varying(20),
    is_priced character varying(20),
    collection_uuid character varying(32),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- Name: collectionStatus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."collectionStatus" (
    uuid character varying(32) NOT NULL,
    status character varying(6),
    collection_uuid character varying(32)
);


ALTER TABLE public."collectionStatus" OWNER TO postgres;

--
-- Name: collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.collections (
    uuid character varying(32) NOT NULL,
    collection_id character varying(100),
    blockchain character varying(20),
    type character varying(20),
    name character varying(1000),
    created_date timestamp without time zone,
    description character varying(10000),
    external_url character varying(1000),
    image_url character varying(1000),
    image bytea,
    contract_address character varying(100),
    "timestamp" timestamp without time zone
);


ALTER TABLE public.collections OWNER TO postgres;

--
-- Name: creators; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creators (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.creators OWNER TO postgres;

--
-- Name: owners; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.owners (
    uuid character varying(32) NOT NULL,
    wallet_address character varying(100),
    asset_uuid character varying(32)
);


ALTER TABLE public.owners OWNER TO postgres;

--
-- Name: traits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.traits (
    uuid character varying(32) NOT NULL,
    key character varying(100),
    value character varying(100),
    type character varying(100),
    format character varying(100),
    "timestamp" timestamp without time zone,
    asset_uuid character varying(32)
);


ALTER TABLE public.traits OWNER TO postgres;

--
-- Name: assetStatus assetStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (uuid);


--
-- Name: collectionStatus collectionStatus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_pkey" PRIMARY KEY (uuid);


--
-- Name: collections collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (uuid);


--
-- Name: creators creators_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_pkey PRIMARY KEY (uuid);


--
-- Name: owners owners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_pkey PRIMARY KEY (uuid);


--
-- Name: traits traits_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_pkey PRIMARY KEY (uuid);


--
-- Name: assetStatus assetStatus_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."assetStatus"
    ADD CONSTRAINT "assetStatus_asset_uuid_fkey" FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: assets assets_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_collection_uuid_fkey FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: collectionStatus collectionStatus_collection_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."collectionStatus"
    ADD CONSTRAINT "collectionStatus_collection_uuid_fkey" FOREIGN KEY (collection_uuid) REFERENCES public.collections(uuid);


--
-- Name: creators creators_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creators
    ADD CONSTRAINT creators_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: owners owners_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.owners
    ADD CONSTRAINT owners_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);


--
-- Name: traits traits_asset_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.traits
    ADD CONSTRAINT traits_asset_uuid_fkey FOREIGN KEY (asset_uuid) REFERENCES public.assets(uuid);