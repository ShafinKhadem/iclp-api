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
2	1	1	2021-05-31 00:01:12.773866	5	\N	\N
1	1	1	2021-05-30 22:57:16.354623	10	\N	TLE/MLE/lost to opponent etc.?
4	3	1	2021-06-07 07:02:41.8656	5	\N	\N
5	4	1	2021-06-07 07:02:41.8656	5	\N	\N
6	1	2	2021-06-10 06:05:53.115075	5	\N	\N
7	1	1	2021-06-10 06:31:44.485811	10	\N	\N
8	1	3	2021-06-11 13:19:39.429722	5	\N	\N
9	1	4	2021-06-11 13:25:31.322649	3	\N	\N
24	2	1	2021-06-17 19:25:06.149994	11	\N	["K-Means",["In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration."],["Depth of Tree"]]
25	2	1	2021-06-17 19:40:48.42397	5	\N	["K-Means",["In SGD, you have to run through all the samples in your training set for a single update of a parameter in each iteration."],["Number of Trees"]]
26	2	1	2021-06-17 19:41:26.245779	15	\N	["None of the above",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Depth of Tree"]]
27	5	1	2021-06-18 11:18:24.715821	2	\N	["<script>","Object-Oriented","Ignores the statements"]
28	2	1	2021-06-18 20:44:47.834637	0	\N	["PCA",["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function."],["Number of Trees"]]
29	2	1	2021-06-20 12:50:42.555463	14	\N	["K-Means",["In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Learning Rate"]]
30	2	3	2021-06-23 21:33:44.185688	5	\N	["K-Means",["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function."],["Number of Trees"]]
31	6	1	2021-06-24 13:14:23.479912	9	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
32	6	1	2021-06-24 13:58:12.495405	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
33	6	1	2021-06-24 14:21:05.723699	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
34	6	1	2021-06-24 14:24:38.721959	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
35	6	1	2021-06-24 14:25:08.213504	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
36	6	1	2021-06-24 14:28:40.419481	1	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(c))"],"n = sizeof(arr)",["copy_list = ori_list[:]"],"s == s[::1]"]
37	6	1	2021-06-24 14:30:02.125203	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
38	6	1	2021-06-24 14:33:26.677693	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
39	6	1	2021-06-24 14:34:32.277982	-1	\N	\N
40	6	1	2021-06-24 14:35:13.846687	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
41	6	1	2021-06-24 15:54:12.33454	6	\N	["sum = a + b",null,"n = len(arr)",["copy_list = ori_list[:]"],"s == s[::-1]"]
42	6	3	2021-06-24 15:57:33.6123	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
43	6	1	2021-06-24 15:58:33.497585	6	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(c))"],"n = len(arr)",["copy_list = ori_list[:]"],"s == s[::-1]"]
44	6	1	2021-06-24 18:08:01.120037	11	11	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
45	2	3	2021-06-24 18:25:00.432597	5	23	["K-Means",["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function."],["Depth of Tree","Learning Rate"]]
46	2	1	2021-06-24 18:46:17.124467	0	23	["PCA",["In GD and SGD, you update a set of parameters in an iterative manner to minimize the error function.","In GD, you either use the entire data or a subset of training data to update a parameter in each iteration."],["Number of Trees"]]
47	6	1	2021-06-24 18:52:44.36299	11	21	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
48	6	3	2021-06-24 18:53:46.385454	11	21	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
49	6	1	2021-06-24 21:37:10.929063	6	22	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))"],"n = len(arr)",["copy_list = ori_list[:]"],"s == s[::-1]"]
50	6	1	2021-06-24 21:41:00.757368	-1	22	\N
51	6	1	2021-06-24 21:41:22.623008	6	22	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]"],"s == s[::-1]"]
52	6	3	2021-06-24 21:42:10.03951	11	11	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
53	6	3	2021-06-24 21:45:08.583246	0	11	[null,null,null,null,null]
54	6	1	2021-06-24 21:59:26.109641	11	12	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
55	6	3	2021-06-24 22:00:10.521178	11	12	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
56	6	2	2021-06-24 22:17:26.345746	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
57	6	2	2021-06-24 22:20:46.927139	11	2	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
58	6	1	2021-06-24 22:23:25.730792	3	2	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["list_copy = [].extend(ori_list)"],"s = s[::-1]"]
59	6	1	2021-06-24 22:29:41.304405	11	\N	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
60	6	2	2021-06-24 22:38:42.769204	11	24	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord(\\"c\\"))","print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = len(arr)",["copy_list = ori_list[:]","list_copy = [].extend(ori_list)"],"s == s[::-1]"]
61	6	3	2021-06-24 22:39:11.118108	1	24	["sum = a + b",["print(\\"The ASCII value of '\\" + c + \\"' is\\", ord('c'))"],"n = length(arr)",null,"s == s[::1]"]
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
\.


--
-- Data for Name: invitations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.invitations (exam_id, challenger_id, challengee_id, topic_id, status, challenge_id, last_accessed) FROM stdin;
3	1	3	2	full_completed	1	2021-06-24 15:58:42.054869+06
23	1	3	1	full_completed	2	2021-06-24 18:46:29.457699+06
21	3	1	2	full_completed	6	2021-06-24 18:54:01.221733+06
22	3	1	2	full_completed	6	2021-06-24 21:41:44.86856+06
11	3	1	2	full_completed	6	2021-06-24 21:47:08.990107+06
12	3	1	2	full_completed	6	2021-06-24 22:00:24.433417+06
1	1	2	1	rejected	1	2021-06-24 22:18:37.688767+06
2	1	2	2	full_completed	1	2021-06-24 22:23:32.868273+06
5	2	3	1	rejected	1	2021-06-24 22:24:38.536546+06
24	3	2	2	full_completed	6	2021-06-24 22:39:21.028102+06
18	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
17	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
16	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
14	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
15	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
20	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
4	2	1	2	pending	1	2021-06-24 15:56:52.069028+06
13	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
19	3	1	2	pending	6	2021-06-24 15:56:52.069028+06
\.


--
-- Data for Name: session_store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_store (sid, sess, expire) FROM stdin;
ZKkWQPqy3R5L-y4Hfzk38qOswPl8k7qz	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-01T15:41:31.148Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-07-01 21:41:32
QtdXhr6w-Bqyit34yug8gI93rkbmgbQe	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T15:53:21.983Z","httpOnly":true,"path":"/"}}	2021-07-01 21:53:22
0lKY9E_AavggUf6ODfyxqn-7p1Au_lp2	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T15:54:49.428Z","httpOnly":true,"path":"/"}}	2021-07-01 21:54:50
M-to2p3PheU1CEnszDBCAjXkjrGmqcmS	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T15:59:44.422Z","httpOnly":true,"path":"/"}}	2021-07-01 21:59:45
BASaKJptAgVQcOkz-YMzlqalxNXjbtDl	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T16:02:04.042Z","httpOnly":true,"path":"/"}}	2021-07-01 22:02:05
DPuh2Xzbp6hh1pEdOt2MLIYF5rv09l_o	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T16:13:42.831Z","httpOnly":true,"path":"/"}}	2021-07-01 22:13:43
iOTloxpN9sXA3-lx0ZTdDsnGycPU-n4_	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T16:13:46.904Z","httpOnly":true,"path":"/"}}	2021-07-01 22:13:47
NQQj_goWO8zIHv1XPyYiMyR0omu1e9Uk	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T16:14:21.588Z","httpOnly":true,"path":"/"}}	2021-07-01 22:14:22
umki_wV1mtWVdagd5iDZlPgH0cOh0sSL	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-01T16:17:13.619Z","httpOnly":true,"path":"/"}}	2021-07-01 22:17:14
3xNLbfx7vQnl6LYFOXp7g535SuWS0CFl	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-16T16:48:44.732Z","httpOnly":true,"path":"/"}}	2021-07-16 22:48:45
SizFT91fNM63PiPDacfZDQt7E3RDhaqj	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-17T07:42:40.079Z","httpOnly":true,"path":"/"}}	2021-07-17 13:42:41
HHV9_hcfjirnlGWxpdEbSHboFgPC5CSA	{"cookie":{"originalMaxAge":2591999996,"expires":"2021-07-18T05:21:55.010Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-07-18 11:21:56
QKboqcfPSRXGjaoPcwXe_O2J9ttm0sPW	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-18T04:20:38.157Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-07-18 10:20:39
N99Zcc6BuAUwumWCes5NJnG-3WBP0oDi	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-19T16:14:46.167Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-19 22:14:47
js8awdRFjR9CCBpaPvbgGWGMB0J3_1hs	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-20T16:20:39.639Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-07-20 22:20:40
vp8C_8l4ITzxwcIcTxNZxI_-R_Dg3HRj	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-19T08:34:12.390Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-19 14:34:13
WNYKUFGuIdWVBoByLLBqF9f_cyGyjb5G	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-19T08:35:23.288Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-19 14:35:24
--WfQrIAXI2p_e3HOOEkLLwqrg2GsMTi	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-19T14:34:34.930Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-19 20:34:35
AOTZ-xqFtTXIrhUc5tYqI0HKbP4U1A_i	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-19T14:30:20.779Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-19 20:30:21
LWliL3cVDYcGNM8MGyKyRcdeWnW12s9i	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-18T19:26:04.094Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-07-19 01:26:05
KO-ZzIo6bePqPCLBTOXijbXYipNR6FhH	{"cookie":{"originalMaxAge":2591999998,"expires":"2021-07-19T14:55:48.994Z","httpOnly":true,"path":"/"}}	2021-07-19 20:55:49
WoBHVngtJjowhkj3Vo5vqGVEGc671701	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-20T07:22:02.332Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-20 13:22:03
mtQ8MSnxZW3U_jBcFDMl1RGnOoTRFfGy	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-24T16:40:06.107Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-24 22:40:07
f4NoCb0aj-J2tCj1EoSSbPXZWXES0iIZ	{"cookie":{"originalMaxAge":2591999995,"expires":"2021-07-24T16:40:10.432Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-24 22:40:11
owEtU9PTKdJS9VUYDGER9uGjkadDCOsv	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-20T16:12:53.225Z","httpOnly":true,"path":"/"}}	2021-07-20 22:12:54
WzbRfeu87C-itwYV8n090gLX_WU8bgdJ	{"cookie":{"originalMaxAge":2591999993,"expires":"2021-07-24T16:22:27.893Z","httpOnly":true,"path":"/"},"passport":{"user":2}}	2021-07-24 22:22:28
eXKEJtrFHmlfj69FAToqVMrBnJTMiR6u	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-07-21T20:07:18.943Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-22 02:07:19
w0zt6wgTJcBlB0iP8X-vJH3TQhhEAS-K	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-20T05:30:01.714Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-20 11:30:02
8dcK1xeR-_LiyuZkx1QWAbYszI3bDuuI	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-20T05:30:23.225Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-20 11:30:24
IvixjXHnrWLRwnMvZJ95Lu-I222eX9ey	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-19T16:15:29.499Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-19 22:15:30
t4Z9TFp27WNFiya5ME2mFZnYeahXmYoW	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-20T16:33:04.696Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-20 22:33:05
383Gww_gV-QM3fDDrV3felRFqkHIAtdO	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-07-20T03:56:03.089Z","httpOnly":true,"path":"/"},"passport":{}}	2021-07-20 09:56:04
UXMopNL6-GagWUy8NuW7_ObNpEUorDjA	{"cookie":{"originalMaxAge":2591999994,"expires":"2021-07-23T15:52:07.060Z","httpOnly":true,"path":"/"},"passport":{"user":3}}	2021-07-23 21:52:08
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
4	1605042@ugrad.cse.buet.ac.bd	$2b$10$o1vd4Fy1XVVUgpsEUz8ktO48ZFwTh4hz.zAMcQmbF7wR9yiG1TZSe	nazrin shukti	\N	f	$2b$10$o1vd4Fy1XVVUgpsEUz8ktO	f	\N
1	tomriddle@hogwarts.edu	$2b$10$6Xtxh8BfMaj4F/xyRL6dZeyq9VPgQF14rVnbktQyWgLT38AT3WetW	voldemort	admin	f	$2b$10$6Xtxh8BfMaj4F/xyRL6dZe	f	2021-06-24 22:22:53.046579+06
2	1605045@ugrad.cse.buet.ac.bd	$2b$10$bsY7qyyKOcPSc4M3Kf3KzO6crrZ7OKNNLEw60gSN3IIcObwLKozkq	shafin khadem	\N	f	$2b$10$bsY7qyyKOcPSc4M3Kf3KzO	f	2021-06-24 22:38:17.136216+06
3	1605047@ugrad.cse.buet.ac.bd	$2b$10$lu7MUJqdV6qlzhNY9vu5jOp17Cnr3FIM8V0XD6eFVHVAasz9Tri8W	ahsanul ameen	\N	f	$2b$10$lu7MUJqdV6qlzhNY9vu5jO	f	2021-06-24 22:11:14.262393+06
\.


--
-- Name: challenge_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challenge_results_id_seq', 61, true);


--
-- Name: challenges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challenges_id_seq', 6, true);


--
-- Name: invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.invitations_id_seq', 24, true);


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

