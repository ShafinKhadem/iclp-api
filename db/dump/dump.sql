--
-- PostgreSQL database dump
--

-- Dumped from database version 13.3 (Ubuntu 13.3-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.3 (Ubuntu 13.3-1.pgdg20.04+1)

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
-- Name: challenge_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_results (
    id integer NOT NULL,
    challenge_id integer,
    user_id integer,
    "time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    mark integer
);


ALTER TABLE public.challenge_results OWNER TO postgres;

--
-- Name: Challenge_results_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Challenge_results_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Challenge_results_id_seq" OWNER TO postgres;

--
-- Name: Challenge_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Challenge_results_id_seq" OWNED BY public.challenge_results.id;


--
-- Name: Challenge_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Challenge_reviews" (
    user_id integer NOT NULL,
    challenge_id integer NOT NULL,
    rating integer,
    review character varying(255)
);


ALTER TABLE public."Challenge_reviews" OWNER TO postgres;

--
-- Name: challenges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenges (
    id integer NOT NULL,
    title character varying(255),
    content character varying(255),
    type character varying(255)
);


ALTER TABLE public.challenges OWNER TO postgres;

--
-- Name: Challenges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Challenges_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Challenges_id_seq" OWNER TO postgres;

--
-- Name: Challenges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Challenges_id_seq" OWNED BY public.challenges.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    title character varying(255),
    content character varying(255),
    is_paid boolean DEFAULT false NOT NULL
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: Courses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Courses_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Courses_id_seq" OWNER TO postgres;

--
-- Name: Courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Courses_id_seq" OWNED BY public.courses.id;


--
-- Name: discussion_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discussion_comments (
    id integer NOT NULL,
    parent_thread_id integer,
    parent_comment_id integer,
    user_id integer,
    content character varying(255)
);


ALTER TABLE public.discussion_comments OWNER TO postgres;

--
-- Name: Discussion_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Discussion_comments_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Discussion_comments_id_seq" OWNER TO postgres;

--
-- Name: Discussion_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Discussion_comments_id_seq" OWNED BY public.discussion_comments.id;


--
-- Name: discussion_threads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discussion_threads (
    id integer NOT NULL,
    user_id integer,
    course_id integer,
    title character varying(255),
    content character varying(255)
);


ALTER TABLE public.discussion_threads OWNER TO postgres;

--
-- Name: Discussion_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Discussion_threads_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Discussion_threads_id_seq" OWNER TO postgres;

--
-- Name: Discussion_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Discussion_threads_id_seq" OWNED BY public.discussion_threads.id;


--
-- Name: quiz_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quiz_submissions (
    id integer NOT NULL,
    quiz_id integer,
    user_id integer,
    "time" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    mark integer
);


ALTER TABLE public.quiz_submissions OWNER TO postgres;

--
-- Name: Quiz_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Quiz_submissions_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Quiz_submissions_id_seq" OWNER TO postgres;

--
-- Name: Quiz_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Quiz_submissions_id_seq" OWNED BY public.quiz_submissions.id;


--
-- Name: quizs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quizs (
    id integer NOT NULL,
    course_id integer,
    title character varying(255),
    content character varying(255)
);


ALTER TABLE public.quizs OWNER TO postgres;

--
-- Name: Quizs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Quizs_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Quizs_id_seq" OWNER TO postgres;

--
-- Name: Quizs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Quizs_id_seq" OWNED BY public.quizs.id;


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
-- Name: Topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Topics_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Topics_id_seq" OWNER TO postgres;

--
-- Name: Topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Topics_id_seq" OWNED BY public.topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    hash character varying(255),
    name character varying(255),
    affiliation character varying(255),
    ranking integer DEFAULT 0,
    is_premium boolean DEFAULT false NOT NULL,
    salt character varying NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Users_id_seq" OWNER TO postgres;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public.users.id;


--
-- Name: challenge_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challenge_topics (
    challenge_id integer NOT NULL,
    topic_id integer NOT NULL
);


ALTER TABLE public.challenge_topics OWNER TO postgres;

--
-- Name: comment_upvotes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment_upvotes (
    user_id integer NOT NULL,
    comment_id integer NOT NULL
);


ALTER TABLE public.comment_upvotes OWNER TO postgres;

--
-- Name: course_reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_reviews (
    user_id integer NOT NULL,
    course_id integer NOT NULL,
    rating integer,
    review character varying(255)
);


ALTER TABLE public.course_reviews OWNER TO postgres;

--
-- Name: course_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_topics (
    course_id integer NOT NULL,
    topic_id integer NOT NULL
);


ALTER TABLE public.course_topics OWNER TO postgres;

--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollments (
    user_id integer NOT NULL,
    course_id integer NOT NULL,
    start_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.enrollments OWNER TO postgres;

--
-- Name: instructors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructors (
    user_id integer NOT NULL,
    course_id integer NOT NULL
);


ALTER TABLE public.instructors OWNER TO postgres;

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
-- Name: thread_upvotes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.thread_upvotes (
    user_id integer NOT NULL,
    thread_id integer NOT NULL
);


ALTER TABLE public.thread_upvotes OWNER TO postgres;

--
-- Name: challenge_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results ALTER COLUMN id SET DEFAULT nextval('public."Challenge_results_id_seq"'::regclass);


--
-- Name: challenges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges ALTER COLUMN id SET DEFAULT nextval('public."Challenges_id_seq"'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public."Courses_id_seq"'::regclass);


--
-- Name: discussion_comments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_comments ALTER COLUMN id SET DEFAULT nextval('public."Discussion_comments_id_seq"'::regclass);


--
-- Name: discussion_threads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_threads ALTER COLUMN id SET DEFAULT nextval('public."Discussion_threads_id_seq"'::regclass);


--
-- Name: quiz_submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_submissions ALTER COLUMN id SET DEFAULT nextval('public."Quiz_submissions_id_seq"'::regclass);


--
-- Name: quizs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizs ALTER COLUMN id SET DEFAULT nextval('public."Quizs_id_seq"'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics ALTER COLUMN id SET DEFAULT nextval('public."Topics_id_seq"'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Data for Name: Challenge_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Challenge_reviews" (user_id, challenge_id, rating, review) FROM stdin;
\.


--
-- Data for Name: challenge_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_results (id, challenge_id, user_id, "time", mark) FROM stdin;
\.


--
-- Data for Name: challenge_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenge_topics (challenge_id, topic_id) FROM stdin;
\.


--
-- Data for Name: challenges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challenges (id, title, content, type) FROM stdin;
\.


--
-- Data for Name: comment_upvotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment_upvotes (user_id, comment_id) FROM stdin;
\.


--
-- Data for Name: course_reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_reviews (user_id, course_id, rating, review) FROM stdin;
\.


--
-- Data for Name: course_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_topics (course_id, topic_id) FROM stdin;
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, title, content, is_paid) FROM stdin;
\.


--
-- Data for Name: discussion_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussion_comments (id, parent_thread_id, parent_comment_id, user_id, content) FROM stdin;
\.


--
-- Data for Name: discussion_threads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discussion_threads (id, user_id, course_id, title, content) FROM stdin;
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (user_id, course_id, start_time) FROM stdin;
\.


--
-- Data for Name: instructors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructors (user_id, course_id) FROM stdin;
\.


--
-- Data for Name: quiz_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quiz_submissions (id, quiz_id, user_id, "time", mark) FROM stdin;
\.


--
-- Data for Name: quizs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quizs (id, course_id, title, content) FROM stdin;
\.


--
-- Data for Name: session_store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session_store (sid, sess, expire) FROM stdin;
yRnPrG5Xczd9a-LITwkRUZYy4BG4d-D0	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:27:17.763Z","httpOnly":true,"path":"/"}}	2021-06-21 20:27:18
mg4h2TAG6y_y7-lbrmotYYyQOU12dBUN	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:29:35.568Z","httpOnly":true,"path":"/"}}	2021-06-21 20:29:36
EUc81E_xWYw4yKKD18F0kfSCYPmGblfU	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:30:55.990Z","httpOnly":true,"path":"/"}}	2021-06-21 20:30:56
aCczbfb9G7k2ZAz4D6T_dcByy6j85_XZ	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:31:47.445Z","httpOnly":true,"path":"/"}}	2021-06-21 20:31:48
RgMMlwqdMT_zajydu3_Hb7pzxnwH6C90	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:31:51.189Z","httpOnly":true,"path":"/"}}	2021-06-21 20:31:52
Da6HfL9oQJ6E7hATnP_GsWZjyfWG5OqP	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:33:30.098Z","httpOnly":true,"path":"/"}}	2021-06-21 20:33:31
A5Ik7JaxYD8YbKl56sgM43sARcQFmXJ0	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:34:52.796Z","httpOnly":true,"path":"/"}}	2021-06-21 20:34:53
6iBJ-e2FGiY0zJeaYTykeOGfXuG7-e_W	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-22T08:57:14.812Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-22 14:57:15
9AgibQRqjhDDkPSLCP_QNZvLvrg-48yH	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:38:32.334Z","httpOnly":true,"path":"/"}}	2021-06-21 20:38:33
enmBw-iUuRuCxmhbpBVesxfnAZgONaQp	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:44:11.098Z","httpOnly":true,"path":"/"}}	2021-06-21 20:44:12
uAkbuZiIu9zaI8CSqqBK2K1q4nzYz4yH	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:51:35.305Z","httpOnly":true,"path":"/"}}	2021-06-21 20:51:36
pwha1Kl_wqlgGFX89gnN4Ps741xYCxNd	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:53:16.919Z","httpOnly":true,"path":"/"}}	2021-06-21 20:53:17
MD-d-k3D6TYXC_PdjQ3jK5xstknuiY7j	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T14:57:24.982Z","httpOnly":true,"path":"/"}}	2021-06-21 20:57:25
v2-MUSvVoqP9rUwKCYOykwe3_alNDkeK	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:02:14.958Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:02:15
LTG4pdD7cVqOesGEXyThruZC3tLKlpj0	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:02:37.502Z","httpOnly":true,"path":"/"}}	2021-06-21 21:02:38
MEyzyEtW_sUXorGq1nk1ysX-zGeM8E5p	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:04:28.785Z","httpOnly":true,"path":"/"}}	2021-06-21 21:04:29
LfEqRZZfYvKb-fKto2BJKFwnRgunYPst	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:04:47.216Z","httpOnly":true,"path":"/"}}	2021-06-21 21:04:48
1CHYbBczHzY7vBO88SiPcM_NbQwe0stZ	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:06:02.076Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:06:03
ULHk1PyBKk9iLTHS0f_08UcpJYvpopXy	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:09:13.156Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:09:14
Xxiai2RSv_D3jZLlsVUgDDfBRMpDzuFS	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:09:15.501Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:09:16
HB6GwhWqndIF_JQsZiWkdpnLbjU5CIyO	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:09:15.508Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:09:16
qmOa0wNm8mT3_uVCGGvw2uex4dklldoT	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:43:45.956Z","httpOnly":true,"path":"/"}}	2021-06-21 21:43:46
34Jph1ZemHCGgL1EvGV9tyN3TAX7PCu_	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:44:18.443Z","httpOnly":true,"path":"/"}}	2021-06-21 21:44:19
Yhn2HOEGrFh8HevSzm1RP5X_M9gyVQg8	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:44:41.616Z","httpOnly":true,"path":"/"}}	2021-06-21 21:44:42
irYASUVlNcPzkEO8ZP8LiLita7s5Sm8t	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-06-21T15:44:51.085Z","httpOnly":true,"path":"/"}}	2021-06-21 21:44:52
MXuutUVaOkcKZ6gyWFeCQce6cSM1l-HH	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:55:58.434Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:55:59
L7taP1yagzIDcME8FF-j5c_JeZHbdZqO	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T15:58:16.084Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 21:58:17
XIi8e6__4O4w0GH3Q6BFnsov3YamCIFw	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:08:35.910Z","httpOnly":true,"path":"/"}}	2021-06-21 22:08:36
9JESdINXU8_GS7JMMMWlfAm0oLpU53ln	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-06-21T16:08:57.399Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:08:58
AYW53wdnshEKyilNhsUUdTNGk6LYG70e	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:09:48.194Z","httpOnly":true,"path":"/"}}	2021-06-21 22:09:49
1nMihOFby2yNjFV-dK1kdOKpB3AB8Xzy	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:11:57.429Z","httpOnly":true,"path":"/"}}	2021-06-21 22:11:58
imk5kBjiIEvi8yeaweIlJBJuN0PIMwqA	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:12:14.397Z","httpOnly":true,"path":"/"}}	2021-06-21 22:12:15
ADM0iAkjnqBGn_y_fig3iJ9jcNPse54n	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:13:12.212Z","httpOnly":true,"path":"/"}}	2021-06-21 22:13:13
dD2K35WcQXPiPy-fszI9fiAiT3zGOY9Q	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:17:11.332Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:17:12
yAJCFJX5vf-RriY0tzvNhmsWMMzfyr8-	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:19:10.991Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:19:11
O0gym3jPDOHxI1QHCMd6oAt3ZXThceMg	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:21:23.485Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:21:24
Fwqpt9gMoy31A-w2W8ZJ1NpOKvwK2YEh	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:23:44.308Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:23:45
ZGHWMSFJKlha6d6PtSgXAIEKeyH06Pbk	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:25:54.958Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:25:55
LSDZe32s89ylR6Z3zpmN6wvDkJ07_ZoP	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:29:59.763Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:30:00
kIEWMcqtp89xBDzptnsoWdVMKDFRNkCG	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:34:25.071Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:34:26
W_8Ogly_eg4E3eL-GhoYEo7-0uA_ZM5R	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:35:16.888Z","httpOnly":true,"path":"/"}}	2021-06-21 22:35:17
sUj4ouIVuLLLvWDOYIrEt54D7CbH-k-_	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:35:29.077Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:35:30
M_xdPvxQjhg_cSscgIHqFv564fzvk8sH	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:36:22.930Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:36:23
Ys5MEK67eMG-mnZjIiWGxVjHyKmOWWc9	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:41:59.472Z","httpOnly":true,"path":"/"}}	2021-06-21 22:42:00
ljmduCeNJidOURRdy5bZNOQhhLpy9SDU	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:42:13.934Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:42:14
oqKPePuBQ-K8JwB22nBnssOzOQa7xBk8	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:45:15.610Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:45:16
4IaQHdx0bbTmB2cGmwWSu_era5oWXs8S	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:46:52.476Z","httpOnly":true,"path":"/"}}	2021-06-21 22:46:53
zTjtXTd8gFPr13c4Zb2iHn4BtiM8s3ZH	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:47:12.885Z","httpOnly":true,"path":"/"}}	2021-06-21 22:47:13
yOlZYXZvDs5zhtrL7uA4l40OIdQi6soK	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:47:44.515Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:47:45
7SwbvbbMcpm3gbzvEgoVNqYbSiCMeX02	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:48:14.413Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:48:15
VAu8AO_fWlXGahEqbqFW3C2YHAKes5zE	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:49:23.547Z","httpOnly":true,"path":"/"}}	2021-06-21 22:49:24
0lcrZUFROfMnQWq_IfPEOkHHwZrR72Dc	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:49:43.901Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:49:44
QZfddXeuNGCrOVwlP1HebAUM1_0r5QAn	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:51:20.589Z","httpOnly":true,"path":"/"}}	2021-06-21 22:51:21
eTIGkdj4YMlNkbmw3hytbJpqCknCOdvO	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:51:40.126Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:51:41
zKle3GPkxkavJ6zCZm17x3NGJ5OHNieU	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:53:29.808Z","httpOnly":true,"path":"/"}}	2021-06-21 22:53:30
9UUxUCn_ke8GffGGW_eNIO3e9N6XNOR4	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T16:53:50.300Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 22:53:51
avbLtZuB37VPe98uuCAuVzUp78UkpLkp	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T17:09:56.292Z","httpOnly":true,"path":"/"}}	2021-06-21 23:09:57
pxEfaVPKtclZLs0FJPYniF2dg4ZXI1sL	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T17:10:12.039Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 23:10:13
4pZKZfapcPDJtHMY5cxlWArt2IdlSCpa	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T17:18:07.259Z","httpOnly":true,"path":"/"}}	2021-06-21 23:18:08
5bTBikj5_gscemwMNEg-YxjMTP3wBpaO	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-21T17:18:24.548Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-21 23:18:25
4ORA0B9RvQF1RoEdWP6itx_ZJkUTR6zh	{"cookie":{"originalMaxAge":2592000000,"expires":"2021-06-22T08:53:30.871Z","httpOnly":true,"path":"/"},"passport":{"user":1}}	2021-06-22 14:53:31
FXmRJeenXj_xCoEJUJWlY4WkyRPmzE8J	{"cookie":{"originalMaxAge":2591999999,"expires":"2021-06-22T13:14:16.065Z","httpOnly":true,"path":"/"},"passport":{}}	2021-06-22 19:14:17
\.


--
-- Data for Name: thread_upvotes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.thread_upvotes (user_id, thread_id) FROM stdin;
\.


--
-- Data for Name: topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.topics (id, name, description) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hash, name, affiliation, ranking, is_premium, salt) FROM stdin;
1	tomriddle@hogwarts.edu	$2b$10$6Xtxh8BfMaj4F/xyRL6dZeyq9VPgQF14rVnbktQyWgLT38AT3WetW	voldemort	\N	0	f	$2b$10$6Xtxh8BfMaj4F/xyRL6dZe
2	1605045@ugrad.cse.buet.ac.bd	$2b$10$bsY7qyyKOcPSc4M3Kf3KzO6crrZ7OKNNLEw60gSN3IIcObwLKozkq	shafin khadem	\N	0	f	$2b$10$bsY7qyyKOcPSc4M3Kf3KzO
3	1605047@ugrad.cse.buet.ac.bd	$2b$10$lu7MUJqdV6qlzhNY9vu5jOp17Cnr3FIM8V0XD6eFVHVAasz9Tri8W	ahsanul ameen	\N	0	f	$2b$10$lu7MUJqdV6qlzhNY9vu5jO
4	1605042@ugrad.cse.buet.ac.bd	$2b$10$o1vd4Fy1XVVUgpsEUz8ktO48ZFwTh4hz.zAMcQmbF7wR9yiG1TZSe	nazrin shukti	\N	0	f	$2b$10$o1vd4Fy1XVVUgpsEUz8ktO
\.


--
-- Name: Challenge_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Challenge_results_id_seq"', 1, false);


--
-- Name: Challenges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Challenges_id_seq"', 1, false);


--
-- Name: Courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Courses_id_seq"', 1, false);


--
-- Name: Discussion_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Discussion_comments_id_seq"', 1, false);


--
-- Name: Discussion_threads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Discussion_threads_id_seq"', 1, false);


--
-- Name: Quiz_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Quiz_submissions_id_seq"', 1, false);


--
-- Name: Quizs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Quizs_id_seq"', 1, false);


--
-- Name: Topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Topics_id_seq"', 1, false);


--
-- Name: Users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Users_id_seq"', 4, true);


--
-- Name: challenge_results Challenge_results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT "Challenge_results_pkey" PRIMARY KEY (id);


--
-- Name: Challenge_reviews Challenge_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Challenge_reviews"
    ADD CONSTRAINT "Challenge_reviews_pkey" PRIMARY KEY (user_id, challenge_id);


--
-- Name: challenges Challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenges
    ADD CONSTRAINT "Challenges_pkey" PRIMARY KEY (id);


--
-- Name: comment_upvotes Comment_upvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_upvotes
    ADD CONSTRAINT "Comment_upvotes_pkey" PRIMARY KEY (user_id, comment_id);


--
-- Name: course_reviews Course_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT "Course_reviews_pkey" PRIMARY KEY (user_id, course_id);


--
-- Name: courses Courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT "Courses_pkey" PRIMARY KEY (id);


--
-- Name: discussion_comments Discussion_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_comments
    ADD CONSTRAINT "Discussion_comments_pkey" PRIMARY KEY (id);


--
-- Name: discussion_threads Discussion_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_threads
    ADD CONSTRAINT "Discussion_threads_pkey" PRIMARY KEY (id);


--
-- Name: enrollments Enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT "Enrollments_pkey" PRIMARY KEY (user_id, course_id);


--
-- Name: instructors Instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT "Instructors_pkey" PRIMARY KEY (user_id, course_id);


--
-- Name: quizs Quizs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizs
    ADD CONSTRAINT "Quizs_pkey" PRIMARY KEY (id);


--
-- Name: quiz_submissions Submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_submissions
    ADD CONSTRAINT "Submissions_pkey" PRIMARY KEY (id);


--
-- Name: thread_upvotes Thread_upvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thread_upvotes
    ADD CONSTRAINT "Thread_upvotes_pkey" PRIMARY KEY (user_id, thread_id);


--
-- Name: topics Topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topics
    ADD CONSTRAINT "Topics_pkey" PRIMARY KEY (id);


--
-- Name: users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: challenge_topics challenge_topics_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_topics
    ADD CONSTRAINT challenge_topics_pk PRIMARY KEY (challenge_id, topic_id);


--
-- Name: course_topics course_topics_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_topics
    ADD CONSTRAINT course_topics_pk PRIMARY KEY (course_id, topic_id);


--
-- Name: session_store session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_store
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_session_expire" ON public.session_store USING btree (expire);


--
-- Name: users_email_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_uindex ON public.users USING btree (email);


--
-- Name: challenge_results challenge_results_challenges_challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT challenge_results_challenges_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: challenge_results challenge_results_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challenge_results
    ADD CONSTRAINT challenge_results_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: Challenge_reviews challenge_reviews_challenges_challenge_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Challenge_reviews"
    ADD CONSTRAINT challenge_reviews_challenges_challenge_id_fk FOREIGN KEY (challenge_id) REFERENCES public.challenges(id);


--
-- Name: Challenge_reviews challenge_reviews_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Challenge_reviews"
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
-- Name: comment_upvotes comment_upvotes_discussion_comments_comment_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_upvotes
    ADD CONSTRAINT comment_upvotes_discussion_comments_comment_id_fk FOREIGN KEY (comment_id) REFERENCES public.discussion_comments(id);


--
-- Name: comment_upvotes comment_upvotes_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment_upvotes
    ADD CONSTRAINT comment_upvotes_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: course_reviews course_reviews_courses_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_courses_course_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: course_reviews course_reviews_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_reviews
    ADD CONSTRAINT course_reviews_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: course_topics course_topics_courses_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_topics
    ADD CONSTRAINT course_topics_courses_course_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: course_topics course_topics_topics_topic_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_topics
    ADD CONSTRAINT course_topics_topics_topic_id_fk FOREIGN KEY (topic_id) REFERENCES public.topics(id);


--
-- Name: discussion_comments discussion_comments_discussion_comments_parent_comment_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_comments
    ADD CONSTRAINT discussion_comments_discussion_comments_parent_comment_id_fk FOREIGN KEY (parent_comment_id) REFERENCES public.discussion_comments(id);


--
-- Name: discussion_comments discussion_comments_discussion_threads_parent_thread_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_comments
    ADD CONSTRAINT discussion_comments_discussion_threads_parent_thread_id_fk FOREIGN KEY (parent_thread_id) REFERENCES public.discussion_threads(id);


--
-- Name: discussion_threads discussion_threads_courses_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_threads
    ADD CONSTRAINT discussion_threads_courses_course_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: discussion_threads discussion_threads_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discussion_threads
    ADD CONSTRAINT discussion_threads_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: enrollments enrollments_courses_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_courses_course_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: enrollments enrollments_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: instructors instructors_courses_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_courses_course_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: instructors instructors_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructors
    ADD CONSTRAINT instructors_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: quiz_submissions quiz_submissions_quizs_quiz_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_submissions
    ADD CONSTRAINT quiz_submissions_quizs_quiz_id_fk FOREIGN KEY (quiz_id) REFERENCES public.quizs(id);


--
-- Name: quiz_submissions quiz_submissions_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quiz_submissions
    ADD CONSTRAINT quiz_submissions_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: quizs quizs_courses_course_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quizs
    ADD CONSTRAINT quizs_courses_course_id_fk FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: thread_upvotes thread_upvotes_discussion_threads_thread_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thread_upvotes
    ADD CONSTRAINT thread_upvotes_discussion_threads_thread_id_fk FOREIGN KEY (thread_id) REFERENCES public.discussion_threads(id);


--
-- Name: thread_upvotes thread_upvotes_users_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.thread_upvotes
    ADD CONSTRAINT thread_upvotes_users_user_id_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

