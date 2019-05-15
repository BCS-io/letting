--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id integer NOT NULL,
    property_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: credits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE credits (
    id integer NOT NULL,
    account_id integer NOT NULL,
    charge_id integer NOT NULL,
    payment_id integer NOT NULL,
    at_time timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    amount numeric(8,2) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: debits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE debits (
    id integer NOT NULL,
    account_id integer NOT NULL,
    snapshot_id integer,
    charge_id integer NOT NULL,
    at_time timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone,
    period_first date NOT NULL,
    period_last date NOT NULL,
    amount numeric(8,2) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE properties (
    id integer NOT NULL,
    human_ref integer NOT NULL,
    client_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: account_details; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW account_details AS
 SELECT accounts.id AS account_id,
    accounts.property_id,
    properties.human_ref,
    credits.at_time,
    COALESCE((credits.amount * ('-1'::integer)::numeric), (0)::numeric) AS amount
   FROM ((accounts
     LEFT JOIN credits ON ((credits.account_id = accounts.id)))
     JOIN properties ON ((properties.id = accounts.property_id)))
UNION ALL
 SELECT accounts.id AS account_id,
    accounts.property_id,
    properties.human_ref,
    debits.at_time,
    COALESCE(debits.amount, (0)::numeric) AS amount
   FROM ((accounts
     LEFT JOIN debits ON ((debits.account_id = accounts.id)))
     JOIN properties ON ((properties.id = accounts.property_id)));


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    id integer NOT NULL,
    addressable_id integer NOT NULL,
    addressable_type character varying NOT NULL,
    flat_no character varying,
    house_name character varying,
    road_no character varying,
    road character varying NOT NULL,
    district character varying,
    town character varying,
    county character varying NOT NULL,
    postcode character varying,
    nation character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: agents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE agents (
    id integer NOT NULL,
    authorized boolean DEFAULT false NOT NULL,
    property_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: agents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE agents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE agents_id_seq OWNED BY agents.id;


--
-- Name: charges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE charges (
    id integer NOT NULL,
    charge_type character varying NOT NULL,
    account_id integer NOT NULL,
    cycle_id integer NOT NULL,
    payment_type integer NOT NULL,
    amount numeric(8,2) NOT NULL,
    activity integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: charges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE charges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: charges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE charges_id_seq OWNED BY charges.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE clients (
    id integer NOT NULL,
    human_ref integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE clients_id_seq OWNED BY clients.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    clarify character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: credits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credits_id_seq OWNED BY credits.id;


--
-- Name: cycles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cycles (
    id integer NOT NULL,
    name character varying NOT NULL,
    charged_in integer NOT NULL,
    "order" integer NOT NULL,
    cycle_type character varying NOT NULL,
    due_ons_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: cycles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cycles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cycles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cycles_id_seq OWNED BY cycles.id;


--
-- Name: debits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE debits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: debits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE debits_id_seq OWNED BY debits.id;


--
-- Name: due_ons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE due_ons (
    id integer NOT NULL,
    year integer,
    month integer NOT NULL,
    day integer NOT NULL,
    show_month integer,
    show_day integer,
    cycle_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: due_ons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE due_ons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: due_ons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE due_ons_id_seq OWNED BY due_ons.id;


--
-- Name: entities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE entities (
    id integer NOT NULL,
    entitieable_id integer NOT NULL,
    entitieable_type character varying NOT NULL,
    title character varying,
    initials character varying,
    name character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: entities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entities_id_seq OWNED BY entities.id;


--
-- Name: guides; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE guides (
    id integer NOT NULL,
    invoice_text_id integer NOT NULL,
    instruction text NOT NULL,
    fillin text NOT NULL,
    sample text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: guides_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE guides_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guides_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE guides_id_seq OWNED BY guides.id;


--
-- Name: invoice_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invoice_texts (
    id integer NOT NULL,
    description character varying NOT NULL,
    invoice_name character varying NOT NULL,
    phone character varying NOT NULL,
    vat character varying NOT NULL,
    heading1 character varying NOT NULL,
    heading2 character varying NOT NULL,
    advice1 text NOT NULL,
    advice2 text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invoice_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoice_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoice_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoice_texts_id_seq OWNED BY invoice_texts.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invoices (
    id integer NOT NULL,
    run_id integer NOT NULL,
    snapshot_id integer NOT NULL,
    color integer NOT NULL,
    deliver integer NOT NULL,
    invoice_date date NOT NULL,
    property_ref integer NOT NULL,
    occupiers text NOT NULL,
    property_address text NOT NULL,
    billing_address text NOT NULL,
    client_address text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoices_id_seq OWNED BY invoices.id;


--
-- Name: invoicings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE invoicings (
    id integer NOT NULL,
    property_range character varying NOT NULL,
    period_first date NOT NULL,
    period_last date NOT NULL,
    runs_count integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: invoicings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invoicings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoicings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invoicings_id_seq OWNED BY invoicings.id;


--
-- Name: letters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE letters (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    invoice_text_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: letters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE letters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE letters_id_seq OWNED BY letters.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE payments (
    id integer NOT NULL,
    account_id integer NOT NULL,
    booked_at timestamp without time zone NOT NULL,
    amount numeric(8,2) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payments_id_seq OWNED BY payments.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products (
    id integer NOT NULL,
    invoice_id integer NOT NULL,
    charge_type character varying NOT NULL,
    date_due date NOT NULL,
    payment_type integer NOT NULL,
    period_first date,
    period_last date,
    amount numeric(8,2) NOT NULL,
    balance numeric(8,2) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE properties_id_seq OWNED BY properties.id;


--
-- Name: runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE runs (
    id integer NOT NULL,
    invoicing_id integer,
    invoice_date date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE runs_id_seq OWNED BY runs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: search_suggestions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE search_suggestions (
    id integer NOT NULL,
    term character varying NOT NULL,
    popularity integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: search_suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE search_suggestions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: search_suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE search_suggestions_id_seq OWNED BY search_suggestions.id;


--
-- Name: settlements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE settlements (
    id integer NOT NULL,
    amount numeric(8,2) NOT NULL,
    credit_id integer NOT NULL,
    debit_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: settlements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settlements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settlements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settlements_id_seq OWNED BY settlements.id;


--
-- Name: snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE snapshots (
    id integer NOT NULL,
    account_id integer NOT NULL,
    period_first date NOT NULL,
    period_last date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: snapshots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE snapshots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: snapshots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE snapshots_id_seq OWNED BY snapshots.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    nickname character varying NOT NULL,
    email character varying NOT NULL,
    password_digest character varying NOT NULL,
    role integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: agents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY agents ALTER COLUMN id SET DEFAULT nextval('agents_id_seq'::regclass);


--
-- Name: charges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY charges ALTER COLUMN id SET DEFAULT nextval('charges_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: credits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits ALTER COLUMN id SET DEFAULT nextval('credits_id_seq'::regclass);


--
-- Name: cycles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cycles ALTER COLUMN id SET DEFAULT nextval('cycles_id_seq'::regclass);


--
-- Name: debits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY debits ALTER COLUMN id SET DEFAULT nextval('debits_id_seq'::regclass);


--
-- Name: due_ons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY due_ons ALTER COLUMN id SET DEFAULT nextval('due_ons_id_seq'::regclass);


--
-- Name: entities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entities ALTER COLUMN id SET DEFAULT nextval('entities_id_seq'::regclass);


--
-- Name: guides id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY guides ALTER COLUMN id SET DEFAULT nextval('guides_id_seq'::regclass);


--
-- Name: invoice_texts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_texts ALTER COLUMN id SET DEFAULT nextval('invoice_texts_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices ALTER COLUMN id SET DEFAULT nextval('invoices_id_seq'::regclass);


--
-- Name: invoicings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoicings ALTER COLUMN id SET DEFAULT nextval('invoicings_id_seq'::regclass);


--
-- Name: letters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters ALTER COLUMN id SET DEFAULT nextval('letters_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments ALTER COLUMN id SET DEFAULT nextval('payments_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: properties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY properties ALTER COLUMN id SET DEFAULT nextval('properties_id_seq'::regclass);


--
-- Name: runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY runs ALTER COLUMN id SET DEFAULT nextval('runs_id_seq'::regclass);


--
-- Name: search_suggestions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_suggestions ALTER COLUMN id SET DEFAULT nextval('search_suggestions_id_seq'::regclass);


--
-- Name: settlements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settlements ALTER COLUMN id SET DEFAULT nextval('settlements_id_seq'::regclass);


--
-- Name: snapshots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots ALTER COLUMN id SET DEFAULT nextval('snapshots_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: agents agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY agents
    ADD CONSTRAINT agents_pkey PRIMARY KEY (id);


--
-- Name: charges charges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY charges
    ADD CONSTRAINT charges_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: credits credits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credits
    ADD CONSTRAINT credits_pkey PRIMARY KEY (id);


--
-- Name: cycles cycles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cycles
    ADD CONSTRAINT cycles_pkey PRIMARY KEY (id);


--
-- Name: debits debits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY debits
    ADD CONSTRAINT debits_pkey PRIMARY KEY (id);


--
-- Name: due_ons due_ons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY due_ons
    ADD CONSTRAINT due_ons_pkey PRIMARY KEY (id);


--
-- Name: entities entities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entities
    ADD CONSTRAINT entities_pkey PRIMARY KEY (id);


--
-- Name: guides guides_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY guides
    ADD CONSTRAINT guides_pkey PRIMARY KEY (id);


--
-- Name: invoice_texts invoice_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoice_texts
    ADD CONSTRAINT invoice_texts_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: invoicings invoicings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY invoicings
    ADD CONSTRAINT invoicings_pkey PRIMARY KEY (id);


--
-- Name: letters letters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY letters
    ADD CONSTRAINT letters_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: runs runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY runs
    ADD CONSTRAINT runs_pkey PRIMARY KEY (id);


--
-- Name: search_suggestions search_suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY search_suggestions
    ADD CONSTRAINT search_suggestions_pkey PRIMARY KEY (id);


--
-- Name: settlements settlements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY settlements
    ADD CONSTRAINT settlements_pkey PRIMARY KEY (id);


--
-- Name: snapshots snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY snapshots
    ADD CONSTRAINT snapshots_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_accounts_on_property_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_accounts_on_property_id ON accounts USING btree (property_id);


--
-- Name: index_addresses_on_addressable_id_and_addressable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_addressable_id_and_addressable_type ON addresses USING btree (addressable_id, addressable_type);


--
-- Name: index_agents_on_property_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agents_on_property_id ON agents USING btree (property_id);


--
-- Name: index_charges_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charges_on_account_id ON charges USING btree (account_id);


--
-- Name: index_charges_on_cycle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_charges_on_cycle_id ON charges USING btree (cycle_id);


--
-- Name: index_comments_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_invoice_id ON comments USING btree (invoice_id);


--
-- Name: index_credits_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credits_on_account_id ON credits USING btree (account_id);


--
-- Name: index_credits_on_charge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credits_on_charge_id ON credits USING btree (charge_id);


--
-- Name: index_credits_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credits_on_payment_id ON credits USING btree (payment_id);


--
-- Name: index_debits_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_debits_on_account_id ON debits USING btree (account_id);


--
-- Name: index_debits_on_charge_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_debits_on_charge_id ON debits USING btree (charge_id);


--
-- Name: index_debits_on_charge_id_and_at_time; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_debits_on_charge_id_and_at_time ON debits USING btree (charge_id, at_time);


--
-- Name: index_debits_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_debits_on_snapshot_id ON debits USING btree (snapshot_id);


--
-- Name: index_due_ons_on_cycle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_due_ons_on_cycle_id ON due_ons USING btree (cycle_id);


--
-- Name: index_entities_on_entitieable_id_and_entitieable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entities_on_entitieable_id_and_entitieable_type ON entities USING btree (entitieable_id, entitieable_type);


--
-- Name: index_guides_on_invoice_text_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_guides_on_invoice_text_id ON guides USING btree (invoice_text_id);


--
-- Name: index_invoices_on_run_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_run_id ON invoices USING btree (run_id);


--
-- Name: index_invoices_on_snapshot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_snapshot_id ON invoices USING btree (snapshot_id);


--
-- Name: index_letters_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letters_on_invoice_id ON letters USING btree (invoice_id);


--
-- Name: index_letters_on_invoice_text_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_letters_on_invoice_text_id ON letters USING btree (invoice_text_id);


--
-- Name: index_payments_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_account_id ON payments USING btree (account_id);


--
-- Name: index_products_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_invoice_id ON products USING btree (invoice_id);


--
-- Name: index_properties_on_client_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_properties_on_client_id ON properties USING btree (client_id);


--
-- Name: index_runs_on_invoicing_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_runs_on_invoicing_id ON runs USING btree (invoicing_id);


--
-- Name: index_settlements_on_credit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_settlements_on_credit_id ON settlements USING btree (credit_id);


--
-- Name: index_settlements_on_debit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_settlements_on_debit_id ON settlements USING btree (debit_id);


--
-- Name: index_snapshots_on_account_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_snapshots_on_account_id ON snapshots USING btree (account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20130726152930');

INSERT INTO schema_migrations (version) VALUES ('20130726161337');

INSERT INTO schema_migrations (version) VALUES ('20130728120957');

INSERT INTO schema_migrations (version) VALUES ('20130729081107');

INSERT INTO schema_migrations (version) VALUES ('20130803143126');

INSERT INTO schema_migrations (version) VALUES ('20130805094933');

INSERT INTO schema_migrations (version) VALUES ('20130805110917');

INSERT INTO schema_migrations (version) VALUES ('20130809214432');

INSERT INTO schema_migrations (version) VALUES ('20130819155927');

INSERT INTO schema_migrations (version) VALUES ('20130916115516');

INSERT INTO schema_migrations (version) VALUES ('20130916115546');

INSERT INTO schema_migrations (version) VALUES ('20130916115888');

INSERT INTO schema_migrations (version) VALUES ('20131016112247');

INSERT INTO schema_migrations (version) VALUES ('20140107121253');

INSERT INTO schema_migrations (version) VALUES ('20140228105312');

INSERT INTO schema_migrations (version) VALUES ('20140806144305');

INSERT INTO schema_migrations (version) VALUES ('20140918173927');

INSERT INTO schema_migrations (version) VALUES ('20140919091254');

INSERT INTO schema_migrations (version) VALUES ('20140920193251');

INSERT INTO schema_migrations (version) VALUES ('20140930053829');

INSERT INTO schema_migrations (version) VALUES ('20141031015433');

INSERT INTO schema_migrations (version) VALUES ('20141031192953');

INSERT INTO schema_migrations (version) VALUES ('20141110181915');

INSERT INTO schema_migrations (version) VALUES ('20141129154746');

INSERT INTO schema_migrations (version) VALUES ('20150308230143');

