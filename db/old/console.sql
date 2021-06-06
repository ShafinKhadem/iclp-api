-- signup
insert into "Users" (email, password_encrypted, name, affiliation, is_premium) VALUES ('user@mail','password','user','affiliation', false);

-- signin
select * from "Users" where email='user@mail' and password_encrypted='password';

-- topic insert
insert into "Topics" (name, description) VALUES ('C','mother of all programming languages');

-- topics view
select * from "Topics";

-- instructor insert
insert into "Instructors" (user_id, course_id) VALUES (1,1);

-- course insert
insert into "Courses" (title, content, is_paid) VALUES ('Course 10','Course content 10', false);

-- course topic insert
insert into "Course_topics" (course_id, topic_id) VALUES (10,4);

-- courses view
select * from "Courses";

-- courses view by topic(s)
select * from "Courses" where id in (select course_id from "Course_topics" where topic_id=1);

-- Quiz insert
insert into "Quizs" (course_id, title, content) VALUES (1,'hello world','print hello world to console');

-- Quizs view by course
select * from "Quizs" where course_id=1;

-- enroll in a course
insert into "Enrollments" (user_id, course_id) VALUES (46,7);

-- Enrollments view by user
select * from "Enrollments" where user_id=1;

-- Course_review insert
insert into "Course_reviews" (user_id, course_id, rating, review) VALUES (3,1,4,'Reviewed by 3');

-- view reviews of a course
select * from "Course_reviews" where course_id=1;

-- view average rating and number of reviews of a course
select avg(rating), count(*) from "Course_reviews" where course_id=1;


-- Insert quiz submission
INSERT INTO "Quiz_submissions" (quiz_id, user_id, mark) VALUES (1,1,5);

-- View quiz result
SELECT "Quizs".title, "Quizs".content, "Quiz_submissions".mark
FROM "Quiz_submissions"
INNER JOIN "Quizs" ON "Quiz_submissions".quiz_id= "Quizs".id
WHERE quiz_id = 1 AND user_id=1
ORDER BY "Quiz_submissions".mark DESC
LIMIT 1;

-- Discussion_threads insert
INSERT INTO "Discussion_threads" (user_id, course_id, title, content) VALUES (3,1, 'This is thread2', 'This is thread2 content');

-- Comments insert
INSERT INTO "Comments" (parent_thread_id, parent_comment_id, user_id, content)  VALUES (1, NULL, 2, 'This is another comment.');

-- View discussion thread
SELECT "Discussion_threads".id,"Discussion_threads".title,"Discussion_threads".content,
       "Comments".id,"Comments".parent_comment_id,"Comments".content
FROM "Discussion_threads"
LEFT JOIN "Comments" ON "Discussion_threads".id= "Comments".parent_thread_id
WHERE "Discussion_threads".course_id = 1
ORDER BY "Comments".parent_thread_id;

-- Thread_upvotes
INSERT INTO "Thread_upvotes" (user_id, thread_id) VALUES (3, 1);

-- Show Thread_upvotes count
SELECT count(*)
FROM "Thread_upvotes"
WHERE thread_id = 1;

-- Comment_upvotes
INSERT INTO "Comment_upvotes" (user_id, comment_id) VALUES (2, 1);

-- Show Comment_upvotes count
SELECT count(*)
FROM "Comment_upvotes"
WHERE comment_id = 1;

-- recommended course
SELECT "Courses".title, avg(rating) as avg_rating
FROM "Courses"
INNER JOIN "Course_reviews" ON "Courses".id= "Course_reviews".course_id
GROUP BY id
ORDER BY avg_rating DESC;

-- topic based count
SELECT "Topics".name, count(*) as total_courses
FROM "Topics"
JOIN "Course_topics" ON "Topics".id = "Course_topics".topic_id
GROUP BY "Topics".id;

-- search
SELECT "Courses".title, "Topics".name, "Topics".description
FROM "Courses"
JOIN "Course_topics" ON course_id = "Courses".id
JOIN "Topics" ON topic_id = "Topics".id
WHERE "Courses".title ILIKE '%ing%' OR "Topics".name ILIKE '%ing%' OR "Topics".description ILIKE '%ing%';

-- number of quizzes
SELECT count(*)
FROM "Courses"
JOIN "Quizs" ON "Courses".id = "Quizs".course_id
WHERE "Courses".id = 1;

------------------------------------------------------------------------------------------------





-- ******************************** [ Challenge Module Queries ] ******************************** --

------------------------------------- page (6, 10) ->  of UI --------------------------------------
--After selecting a challenge category
--A solo/dual/coding challenge where you can choose your preferable topic and perform a quiz based on that topic.
-- show available topics associated with this particular type(in this case : solo) of challenge
select DISTINCT "Topics".name as TOPICS_AVAILABLE
    from "Topics"
        join "Challenge_topics" on "Topics".id = "Challenge_topics".topic_id
        join "Challenges" on "Challenge_topics".challenge_id = "Challenges".id
    where "Challenges".type = 'solo'
        ORDER BY "Topics".name;


----------------------------- page 6 bottom of UI-------------------------------------------
-- Show average performance of a user in various challenge types(solo/dual/coding)
-- based on User_Id/name and challenge_type
-- dual/coding average is pretty much similar
select U.name as UserName, (avg(Cr.mark)::float8) as Solo_Average_Performance
    from "Challenge_results" as Cr
        join "Challenges" C on C.id = Cr.challenge_id
        join "Users" U on Cr.user_id = U.id
    where U.id = 9 and C.type = 'solo'
        group by Cr.user_id, U.name;


---------------------- page 7, 11, 13, 19 of UI ----------------------------------------------
-- directed from previous pages(by selecting browse topics or something like this)
-- search topics and show available ones
-- topics will be shown based on typing
select name as FOUND_TOPICS, description as Topic_Details
from "Topics"
where "Topics".name ILIKE '%UML%' or
      "Topics".description ILIKE '%ing%';


--------------------------------------- page 8, 12, 14 of UI -------------------------------------
--quiz will be started on topic(id) selected on previous page
--and you have to submit your answer within the time limit.
SELECT "Topics".name as "Selected_Topic",
       floor(random() * (50-1+1) + 1)::int as "TOTAL_MARKS",
       floor(random() * (20-10+10) + 1)::int as "TIME(minute)"
from "Topics"
    where "Topics".id = 15;

-- upon clicking on the start quiz the quiz will be started
-- also new Challenge_reviews, Challenge_topics entry will be inserted
-- this is shown manually in this case, but it will be automatic in case of Integrated UI
INSERT INTO "Challenge_results"(ID, CHALLENGE_ID, USER_ID, time)
VALUES (12, 11, 22, current_timestamp)
on conflict (id) do nothing;

INSERT INTO "Challenge_reviews"(USER_ID, CHALLENGE_ID)
VALUES (22, 11)
on conflict (user_id, challenge_id) do nothing;
-- note : review, results, marks can be updated after the quiz
-- suitable challenge_id can be found by running a similar query like the next one
-- so we omitted this

---------------------------------- page 9, 15 and 22(?)of UI ----------------------------------------
-- see running quiz status and questions
-- user can see various challenges based on a particular topic(ML/..) and challenge type(solo/../..)
select round((random() * (10-10+10) + 1::float4)::numeric,4)  as "Timer",
       T.name as "Topic",
       floor(random() * (50-1+1) + 1)::int as "TOTAL_MARKS",
       floor(random() * (20-10+10) + 1)::int as "TIME",
       C.title as "Challenge_Title", C.content as "Content"
from "Challenges" as C
    join "Challenge_topics" Ct on C.id = Ct.challenge_id
    join "Topics" T on Ct.topic_id = T.id
where T.name ILIKE '%Machine Learning%' and C.type = 'solo'
    order by C.title
    limit 2;

-- after submit the results can be updated
-- we're doing it manually which can be done automatically within Integrated UI
UPDATE "Challenge_results"
    SET mark = floor(random() * (50-1+1) + 1)::int
    --set mark = null
where id = 12;

select * from "Challenge_results" where id = 12;

----------------------- page 16->17 of UI -------------------------------------
--view challenge results given a particular user id
--filter by current month
SELECT C.title, C.content, Cr.mark
    from "Challenge_results" as Cr, "Challenges" as C
    where Cr.user_id = 22 and
          Cr.challenge_id = C.id and
          Cr.time >= date_trunc('month', CURRENT_DATE);

----------------------- page 17->18 of UI --------------------------------------
-- submit review
UPDATE "Challenge_reviews"
    SET review = 'Excellent', rating = 5
    --SET review = null, rating = null
    WHERE user_id = 22 and challenge_id = 11;
-- before/after review
select * from "Challenge_reviews" where user_id = 22 and challenge_id = 11;

----------------------- page 20 of UI ----------------------------------------------
-- shows Selected topic and time based on topic id(chosen)
--coding challenge will be started on selected topic and you have to submit your answer within the time limit.
SELECT "Topics".name as "Selected_Topic",
      floor(random() * (20-10+10) + 1)::int as "TIME(mins)"
from "Topics"
    where "Topics".id = 12;

----------------------- page 21 of UI(almost same as page 9, 15)------------------------
--coding challenge started with time limit
SELECT round((random() * (10-10+10) + 1::float4)::numeric,4)  AS "Timer",
       T.name AS "Topic",
       floor(random() * (20-10+10) + 1)::int AS "Time",
       C.title as "Challenge_Title", C.content AS "Content"
    FROM "Challenges" AS C JOIN "Challenge_topics" Ct ON C.id = Ct.challenge_id
        JOIN "Topics" T ON Ct.topic_id = T.id
WHERE C.type ILIKE '%Challenge%'
    ORDER BY T.name DESC
    LIMIT 1;

-- upon clicking on the submit button (we can update mark same as previously)
-- and show status to the user
select C.title as "Challenge_Title",
       Cr.mark as "Points",
       (array['Accepted', 'WA_on_Case 1', 'WA_on_Case 2', 'WA_on_Case 3', 'WA_on_Case 4'])[floor(random() * 5 + 1)] as "Answer"
from "Challenges" as C, "Challenge_results" as Cr
where C.id = Cr.challenge_id and
      C.type ILIKE '%Coding Challenge%';









-- ------------------------------------extra queries-----------------------------------------
-- -- note : this queries are not required for demonstration
--
-- -- Challenges insert + view by topic(s) sorted by review_star -- also see(extra_02)
--     insert into "Challenges"(id, title, content) VALUES(11, 'educational_round_404', 'contact with PikMike') ON CONFLICT (id) DO NOTHING;
--     delete from "Challenges" where id = 11;
--     --- see topics list(alphabetically sorted) associated with a particular challenge  (extra_02)
--     SELECT Ch.id as Challenge_ID, Ch.title as Challenge_Title, string_agg(Tp.name, ',') as Topic_List
--     from "Challenges" as Ch
--     INNER JOIN "Challenge_topics" Ct on Ch.id = Ct.challenge_id
--     INNER JOIN "Topics" as Tp on Ct.topic_id = Tp.id
--     GROUP BY Ch.id
--     ORDER BY (Topic_List);
--
--
--
-- -- Challenge_results insert + view by user
--     -- see extra_03, 04
--     -- Challenge_results insert (extra_03)
--     DO
--     $do$
--     BEGIN
--         DELETE  from "Challenge_results" where true;
--         FOR i IN 1..10 LOOP
--           Insert Into "Challenge_results"(id, challenge_id, user_id, time, mark)
--           values (i, mod(i, 10) + 1, floor(random() * (100-1+1) + 1)::int, NOW()::timestamp, floor(random() * (100-1+1) + 1)::int - 50);
--         END LOOP;
--     END
--     $do$;
--
--     -- Challenge_results view by user (extra_04)
--     select U.name as NAME, Cr.time as TIME, Cr.mark as MARK
--     from "Users" as U
--     join "Challenge_results" as Cr on U.id = Cr.user_id
--     ORDER BY Cr.time;
--
--
--
-- -- Challenge_reviews insert + view + view average and count
--     --see extra_05, 06
--
--     -- Challenge_reviews insert + view (extra_05)
--     delete from "Challenge_reviews" where true;
--
--     insert into "Challenge_reviews"(user_id, challenge_id)
--     select Cr.user_id, Cr.challenge_id from "Challenge_results" as Cr;
--
--     update "Challenge_reviews"
--         set rating = floor(random() * (5-1+1) + 1)::int,
--             review = (array['Excellent', 'Good', 'Acceptable', 'Moderate', 'Customary'])[floor(random() * 5 + 1)];
--
--     select U.name as User_Name, C.title, Cr.review as Review, Cr.rating as Rating
--     from "Users" as U, "Challenges" as C, "Challenge_reviews" as Cr
--     where U.id = Cr.user_id and Cr.challenge_id = C.id;
--
--
--     -- Challenge_reviews view average and count (extra_06) [!currently each challenge occurs only once]
--     select Ch.title as Challenge_Title, count(user_id) as No_of_Votes, avg(rating) as AVG_Rating
--     from "Challenges" as Ch, "Challenge_reviews"
--     where Ch.id = challenge_id
--     group by Ch.id
--     order by avg(rating) DESC;
--
-- -- Challenge_topics insert data + see (extra_01)
--     DO
--     $do$
--     BEGIN
--         DELETE  from "Challenge_topics" where true;
--        FOR i IN 1..30 LOOP
--           Insert Into "Challenge_topics"(challenge_id, topic_id)
--           values (mod(i, 10) + 1, floor(random() * (20-1+1) + 1)::int)
--           ON CONFLICT (challenge_id, topic_id) DO NOTHING;
--        END LOOP;
--     END
--     $do$;
--
--     SELECT "Topics".name as "Select Challenge Topic" FROM "Topics" ORDER BY "Topics".name;
--
--
--
-- -- no_of challenges taken(particular type) by a user and average marks on them
-- select U.name, count(*) NO_of_Challenge, avg(Cr.mark) as AVG_MARKS
-- from "Users" as U join "Challenge_results" Cr on U.id = Cr.user_id
--  join "Challenges" as C on Cr.challenge_id = C.id
-- group by U.id, U.name, C.type
-- order by U.name, C.type;
