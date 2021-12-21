--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Ubuntu 13.3-0ubuntu0.21.04.1)
-- Dumped by pg_dump version 13.3 (Ubuntu 13.3-0ubuntu0.21.04.1)

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
-- Name: challenge_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.challenge_type AS ENUM (
    'mcq',
    'code'
);


ALTER TYPE public.challenge_type OWNER TO postgres;

--
-- Name: difficulty_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.difficulty_type AS ENUM (
    'easy',
    'medium',
    'hard'
);


ALTER TYPE public.difficulty_type OWNER TO postgres;

--
-- Name: dual_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.dual_status AS ENUM (
    'pending',
    'accepted',
    'rejected',
    'half_completed',
    'full_completed',
    'archived'
);


ALTER TYPE public.dual_status OWNER TO postgres;

--
-- Name: language; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.language AS ENUM (
    'c++ 17',
    'python3'
);


ALTER TYPE public.language OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: challenge_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_results (
    id integer NOT NULL,
    challenge_id integer,
    user_id integer,
    "time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    score integer,
    exam_id integer,
    details character varying(511)
);


ALTER TABLE public.challenge_results OWNER TO postgres;

--
-- Name: COLUMN challenge_results.exam_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.challenge_results.exam_id IS 'Optionally contains the associated dual exam_id from invitation';


--
-- Name: challenge_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.challenge_results_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.challenge_results_id_seq OWNER TO postgres;

--
-- Name: challenge_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.challenge_results_id_seq OWNED BY public.challenge_results.id;


--
-- Name: challenge_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_reviews (
    user_id integer NOT NULL,
    challenge_id integer NOT NULL,
    rating integer,
    review character varying(255)
);


ALTER TABLE public.challenge_reviews OWNER TO postgres;

--
-- Name: challenge_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_topics (
    challenge_id integer NOT NULL,
    topic_id integer NOT NULL
);


ALTER TABLE public.challenge_topics OWNER TO postgres;

--
-- Name: challenges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenges (
    id integer NOT NULL,
    title character varying(255),
    content character varying(65535),
    category public.challenge_type,
    difficulty public.difficulty_type,
    score integer,
    "time" integer
);


ALTER TABLE public.challenges OWNER TO postgres;

--
-- Name: challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.challenges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.challenges_id_seq OWNER TO postgres;

--
-- Name: challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.challenges_id_seq OWNED BY public.challenges.id;


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;


ALTER TABLE public.invitations_id_seq OWNER TO postgres;

--
-- Name: invitations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.invitations (
    exam_id integer DEFAULT nextval('public.invitations_id_seq'::regclass) NOT NULL,
    challenger_id integer NOT NULL,
    challengee_id integer NOT NULL,
    topic_id integer NOT NULL,
    status public.dual_status DEFAULT 'pending'::public.dual_status NOT NULL,
    challenge_id integer NOT NULL,
    last_accessed timestamp with time zone NOT NULL
);


ALTER TABLE public.invitations OWNER TO postgres;

--
-- Name: TABLE invitations; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.invitations IS 'Table contains detaills of each dual exam invitation';


--
-- Name: session_store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_store (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session_store OWNER TO postgres;

--
-- Name: topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topics (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255)
);


ALTER TABLE public.topics OWNER TO postgres;

--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.topics_id_seq OWNER TO postgres;

--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.topics_id_seq OWNED BY public.topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    hash character varying(255),
    name character varying(255),
    affiliation character varying(255),
    is_premium boolean DEFAULT false NOT NULL,
    salt character varying NOT NULL,
    is_active boolean DEFAULT false,
    last_access timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: COLUMN users.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.is_active IS 'true if a user is active';


--
-- Name: COLUMN users.last_access; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.last_access IS 'stores last login time';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: challenge_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results ALTER COLUMN id SET DEFAULT nextval('public.challenge_results_id_seq'::regclass);


--
-- Name: challenges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges ALTER COLUMN id SET DEFAULT nextval('public.challenges_id_seq'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public.topics_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: challenge_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_results (id, challenge_id, user_id, "time", score, exam_id, details) FROM stdin;
10	2	3	2021-06-28 02:49:42.666988	20	3	["K-Means",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Depth of Tree"]]
11	2	1	2021-06-28 02:50:04.879991	11	3	["K-Means",["In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration."],["Depth of Tree"]]
13	6	1	2021-06-28 18:26:29.973611	3	5	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"],"n = len(arr)",[],"s = s[::-1]"]
15	1	2	2021-06-28 18:38:09.09692	20	\N	congratulations!
17	2	1	2021-06-29 12:46:20.115865	15	6	["PCA",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Depth of Tree"]]
19	7	1	2021-06-29 12:58:33.325345	0	\N	wrong answer
21	7	1	2021-06-29 13:00:59.270588	5	\N	congratulations!
23	2	2	2021-06-30 14:30:31.89073	5	11	["K-Means",["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function."],["Number of Trees"]]
25	8	2	2021-06-30 14:50:10.997305	0	\N	time limit (1 second) exceeded
28	9	3	2021-06-30 15:37:17.563134	2	13	["sum = a + b","n = len(arr)",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"]]
31	2	2	2021-07-28 00:47:34.724334	0	14	["PCA",["In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration."],null]
1	1	1	2021-05-31 00:01:12.773866	5	\N	\N
2	1	1	2021-05-30 22:57:16.354623	10	\N	TLE/MLE/lost to opponent etc.?
3	1	4	2021-06-11 13:25:31.322649	3	\N	\N
4	2	1	2021-06-17 19:25:06.149994	11	\N	["K-Means",["In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration."],["Depth of Tree"]]
12	1	3	2021-06-28 09:08:10.648788	20	\N	congratulations!
14	6	4	2021-06-28 18:27:19.66563	9	5	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
16	2	4	2021-06-29 12:45:41.841877	20	6	["K-Means",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Depth of Tree"]]
18	7	1	2021-06-29 12:56:40.662738	0	\N	wrong answer
5	6	1	2021-06-28 02:43:10.202102	11	1	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
6	6	3	2021-06-28 02:43:44.695588	9	1	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
7	2	3	2021-06-28 02:46:50.100601	0	2	["PCA",["In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration."],["Depth of Tree","Learning Rate"]]
8	2	1	2021-06-28 02:47:45.068696	0	2	["PCA",["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function."],["Number of Trees"]]
9	2	1	2021-06-28 02:48:46.163915	9	\N	["None of the above",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Learning Rate"]]
20	1	1	2021-06-29 12:58:57.510394	20	\N	congratulations!
22	2	3	2021-06-30 14:29:50.561653	14	11	["K-Means",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Number of Trees"]]
24	6	1	2021-06-30 14:42:18.187572	8	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]"],"s == s[::-1]"]
26	10	1	2021-06-30 15:34:27.287311	0	\N	compilation error
27	10	1	2021-06-30 15:34:40.647769	5	\N	congratulations!
29	9	2	2021-06-30 15:37:56.528483	3	13	["sum = a + b","n = sizeof(arr)",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"]]
30	2	1	2021-07-28 00:46:42.508571	15	14	["None of the above",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Depth of Tree"]]
\.


--
-- Data for Name: challenge_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_reviews (user_id, challenge_id, rating, review) FROM stdin;
\.


--
-- Data for Name: challenge_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_topics (challenge_id, topic_id) FROM stdin;
1	1
2	1
3	2
4	2
5	4
6	2
7	1
8	1
9	2
10	1
\.


--
-- Data for Name: challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenges (id, title, content, category, difficulty, score, "time") FROM stdin;
4	conditionals	whatever	code	easy	5	\N
1	Multiplication	you will be given an integer n (1 < n < 100) as input. output n*5.	code	hard	20	\N
2	mcq sample	{"questions":[{"type":1,"points":5,"statement":"Which of the following is an example of a deterministic algorithm?","options":["PCA","K-Means","None of the above"],"answer":"K-Means"},{"type":2,"points":9,"statement":"Which of the following statement(s) is/are true for Gradient Decent(GD) and Stochastic Gradient Decent(SGD)?","options":["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function.","In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration.","In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],"answer":["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."]},{"type":2,"points":6,"statement":"Which of the following hyper parameter(s), when increased may cause random forest to over fit the data?","options":["Number of Trees","Depth of Tree","Learning Rate"],"answer":["Depth of Tree"]}]}	mcq	hard	20	120
5	Javascript Sample	{"questions":[{"type":1,"points":1,"statement":"Inside which HTML element do we put the JavaScript?","options":["<javascript>","<js>","<script>","<java>"],"answer":"<script>"},{"type":1,"points":1,"statement":"Which type of JavaScript language is ___","options":["Object-Oriented","Object-Based","Assembly-language"],"answer":"Object-Based"},{"type":1,"points":1,"statement":"When interpreter encounters an empty statements, what it will do?","options":["Shows a warning","Prompts to complete the statement","Ignores the statements"],"answer":"Ignores the statements"}]}	mcq	easy	3	30
3	Arrays	whatever	code	medium	10	120
6	python_dual	{"questions":[{"type":1,"points":"1","statement":"Select a Python3 program to add two numbers","options":["sum = a + b","sum = a - b","sum = b - a"],"answer":"sum = a + b"},{"type":2,"points":"2","statement":"Select correct option(s)","options":["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(c))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"],"answer":["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"]},{"type":1,"points":"2","statement":"How to find the length of an array","options":["n = len(arr)","n = length(arr)","n = sizeof(arr)"],"answer":"n = len(arr)"},{"type":2,"points":"3","statement":"What is the correct way to clone a list?","options":["copy_list = ori_list[:]","list_copy = [].extend(ori_list)","copy_list = ori_list"],"answer":["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"]},{"type":1,"points":"3","statement":"Check if a string is palindrome or not?","options":["s == s[::-1]","s = s[::-1]","s == s[::1]","s != s[::-1]"],"answer":"s == s[::-1]"}]}	mcq	easy	11	120
7	dummy	\n      you will be given an integer n (1 < n < 100) as input. output n*5.\n      	code	easy	5	\N
8	Dummy_2	\n      you will be given an integer n (1 < n < 100) as input. output n*5.\n      	code	medium	10	\N
9	Pythons are everywhere	{"questions":[{"type":1,"points":"2","statement":"Select a Python3 program to add two numbers","options":["sum = a + b","sum = a - b"],"answer":"sum = a + b"},{"type":1,"points":1,"statement":"How to find the length of an array","options":["n = len(arr)","n = sizeof(arr)"],"answer":"n = sizeof(arr)"},{"type":2,"points":1,"statement":"Select correct option(s)","options":["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(c))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"],"answer":["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"]}]}	mcq	easy	4	30
10	dummy_4	\n      you will be given an integer n (1 < n < 100) as input. output n*5.\n      	code	easy	5	\N
\.


--
-- Data for Name: invitations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invitations (exam_id, challenger_id, challengee_id, topic_id, status, challenge_id, last_accessed) FROM stdin;
1	3	1	2	full_completed	6	2021-06-28 02:43:55.752464+06
2	1	3	1	full_completed	2	2021-06-28 02:47:49.973137+06
3	1	3	1	full_completed	2	2021-06-28 02:50:11.149283+06
4	1	3	1	rejected	2	2021-06-28 09:02:41.356106+06
5	4	1	2	full_completed	6	2021-06-28 18:27:42.281804+06
6	1	4	1	full_completed	2	2021-06-29 12:46:27.931254+06
8	3	1	1	rejected	2	2021-06-30 00:48:51.083627+06
9	3	1	2	archived	6	2021-06-30 00:50:29.959881+06
10	3	2	2	rejected	6	2021-06-30 14:29:10.052391+06
11	2	3	1	full_completed	2	2021-06-30 14:30:38.282005+06
12	1	2	2	rejected	6	2021-06-30 15:36:21.594392+06
13	2	3	2	full_completed	6	2021-06-30 15:38:02.848219+06
14	2	1	1	full_completed	2	2021-07-28 00:49:34.960337+06
15	2	1	2	rejected	6	2021-07-28 00:52:26.581596+06
\.


--
-- Data for Name: session_store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_store (sid, sess, expire) FROM stdin;
mT6W4nygZwN_D2kXUPCeRjmK3a5TuU--	{"cookie":{"originalMaxAge":2591999988,"expires":"2021-08-26T18:53:45.378Z","httpOnly":true,"path":"/"},"passport":{}}	2021-08-27 00:53:46
wAKBjrXfCkAhh-hHFQQk6Gi91O2pzT_W	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-29T07:04:57.335Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-29 13:04:58
P_mM3LGDVGCXJK6puU44SjcPIuxIEJ5X	{"cookie":{"originalMaxAge":2591999998,"expires":"2021-08-26T18:54:42.303Z","httpOnly":true,"path":"/"},"passport":{}}	2021-08-27 00:54:43
UhGobmBeeHp6y9HuDgvpCMIHVbwI8E-f	{"cookie":{"originalMaxAge":2591999991,"expires":"2021-07-28T12:35:27.186Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-28 18:35:28
owEtU9PTKdJS9VUYDGER9uGjkadDCOsv	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-28T04:52:33.317Z","httpOnly":true,"path":"/"}}	2021-07-28 10:52:34
nqsijOLt1jkg9S7EOCEq2EPFNvOKxd1I	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-30T09:45:40.824Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-30 15:45:41
4hiAvlAJiM9ZKXMEcIorxuW6bgbV829V	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-30T09:45:52.753Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-30 15:45:53
ufK_zxib8qvMM31irAG1kvDk_jkKudOg	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-29T19:13:30.863Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-30 01:13:31
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topics (id, name, description) FROM stdin;
1	c++	c is the mother of all programming languages, c++ is object oriented extension of C.
2	python	A very easy yet powerful language, its sysntax is the most beginner-friendly.
3	java	A very powerful OOP language. The trick in java is, there are no tricks. It forces the code to be lengthy and structured.
4	javascript	language of internet
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hash, name, affiliation, is_premium, salt, is_active, last_access) FROM stdin;
4	1605042@ugrad.cse.buet.ac.bd	$2b$10$o1vd4Fy1XVVUgpsEUz8ktO48ZFwTh4hz.zAMcQmbF7wR9yiG1TZSe	nazrin shukti	\N	f	$2b$10$o1vd4Fy1XVVUgpsEUz8ktO	f	2021-06-29 12:44:15.118168+06
3	1605047@ugrad.cse.buet.ac.bd	$2b$10$lu7MUJqdV6qlzhNY9vu5jOp17Cnr3FIM8V0XD6eFVHVAasz9Tri8W	ahsanul ameen	\N	f	$2b$10$lu7MUJqdV6qlzhNY9vu5jO	f	2021-07-28 00:38:39.595083+06
2	1605045@ugrad.cse.buet.ac.bd	$2b$10$bsY7qyyKOcPSc4M3Kf3KzO6crrZ7OKNNLEw60gSN3IIcObwLKozkq	shafin khadem	\N	f	$2b$10$bsY7qyyKOcPSc4M3Kf3KzO	f	2021-07-28 00:45:13.993892+06
1	tomriddle@hogwarts.edu	$2b$10$6Xtxh8BfMaj4F/xyRL6dZeyq9VPgQF14rVnbktQyWgLT38AT3WetW	voldemort	admin	f	$2b$10$6Xtxh8BfMaj4F/xyRL6dZe	f	2021-07-28 00:44:40.357685+06
\.


--
-- Name: challenge_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challenge_results_id_seq', 31, true);


--
-- Name: challenges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challenges_id_seq', 10, true);


--
-- Name: invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invitations_id_seq', 15, true);


--
-- Name: topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.topics_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: challenge_results challenge_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT challenge_results_pkey PRIMARY KEY (id);


--
-- Name: challenge_reviews challenge_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_reviews
    ADD CONSTRAINT challenge_reviews_pkey PRIMARY KEY (user_id, challenge_id);


--
-- Name: challenge_topics challenge_topics_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_topics
    ADD CONSTRAINT challenge_topics_pk PRIMARY KEY (challenge_id, topic_id);


--
-- Name: challenges challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT challenges_pkey PRIMARY KEY (id);


--
-- Name: invitations invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (exam_id);


--
-- Name: session_store session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_store
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_session_expire" ON public.session_store USING btree (expire);


--
-- Name: users_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_uindex ON public.users USING btree (email);


--
-- Name: invitations challenge_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT challenge_id FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: challenge_results challenge_results_challenges_challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT challenge_results_challenges_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: challenge_results challenge_results_invitations_exam_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT challenge_results_invitations_exam_id_fk FOREIGN KEY (exam_id) REFERENCES public.invitations(exam_id);


--
-- Name: challenge_results challenge_results_users_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT challenge_results_users_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: challenge_reviews challenge_reviews_challenges_challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_reviews
    ADD CONSTRAINT challenge_reviews_challenges_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: challenge_reviews challenge_reviews_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_reviews
    ADD CONSTRAINT challenge_reviews_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: challenge_topics challenge_topics_challenges_challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_topics
    ADD CONSTRAINT challenge_topics_challenges_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: challenge_topics challenge_topics_topics_topic_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_topics
    ADD CONSTRAINT challenge_topics_topics_topic_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: invitations challengee_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT challengee_id FOREIGN KEY (challengee_id) REFERENCES public.users(id);


--
-- Name: invitations challenger_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT challenger_id FOREIGN KEY (challenger_id) REFERENCES public.users(id);


--
-- Name: invitations topic_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT topic_id FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- PostgreSQL database dump complete
--

