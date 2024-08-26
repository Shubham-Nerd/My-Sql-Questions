SELECT 
    job_posted_date
FROM
    job_postings_fact
LIMIT
    10; 

SELECT
    '2004-05-22' :: Date ,
    '1203' :: Numeric,
    'FALSE' :: Boolean,
    '1.25'  :: Real;

SELECT
     EXTRACT(Year From job_posted_date) AS DATE
FROM 
    job_postings_fact

SELECT 
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'
FROM
    job_postings_fact

--we are now finding in which month how many joinings will be there listed
SELECT  
     COUNT(company_id) AS "Joining_ID's",
     job_title_short
FROM 
    job_postings_fact
GROUP BY 
     job_title_short;

SELECT  
    *
FROM 
    job_postings_fact
LIMIT
    10;

--Date function problem number 1.
SELECT 
    job_posted_date,
    job_schedule_type,
    AVG(Yearly_salary) AS Yearly_Avg,
    AVG(Hourly_salary) AS Hourly_Avg
FROM
    job_postings_fact
WHERE 
    job_posted_date > 2023-06-01
GROUP BY
    job_schedule_type
LIMIT 10;

-- Problem Number 2.
SELECT
    COUNT(job_id) AS No_Of_Jobs_Posting,
    job_title_short,
    EXTRACT(YEAR FROM job_posted_date) AS Year_Of_JOb_Posting,
    EXTRACT(MONTH From job_posted_date) AS Month_Of_Job_posting,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York'
From
    job_postings_fact
WHERE
    Year_Of_JOb_Posting = '2023'
GROUP BY
    Month_Of_Job_posting
ORDER BY
    No_Of_Jobs_Posting;

-- Correct solution of this problem as written bellow 
SELECT  
    TO_CHAR(job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_York', 'MM-YYYY') AS Month_wise_jobs,
    COUNT(job_id)
FROM
    job_postings_fact
WHERE
    job_posted_date >= '2023-01-01' AND job_posted_date < '2024-01-01'
GROUP BY
    Month_wise_jobs
ORDER BY
    Month_WISE_JOBS;

-- Problem No 3. (adding data from old table to new one )
SELECT
    name,
    EXTRACT(quarter from job_posted_date) AS Quarter
 FROM
    company_dim
JOIN
    job_postings_fact
ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_postings_fact.job_health_insurance = 'TRUE' AND 
    EXTRACT(Year FROM job_posted_date) = 2023 And 
    EXTRACT(Quarter FROM job_posted_date) = 2 
GROUP BY
    name,Quarter;
    
--Here we Add and insert data from a old table into our new column 
ALTER TABLE company_dim
ADD job_position TEXT;

UPDATE company_dim
SET job_position = job_postings_fact.job_title
FROM job_postings_fact
WHERE job_postings_fact.company_id = company_dim.company_id;

--Here we created a new table and entred same data from the old one 
CREATE TABLE
     Zoom_Zoom AS 
SELECT 
    *
FROM
     job_postings_fact
WHERE 
    EXTRACT(Month FROM job_posted_date) = 3;

--Case Expression 
SELECT 
    job_title_short,
    job_location,
    CASE
     WHEN job_location = 'Anywhere' THEN 'Remote Work' 
     WHEN job_location = 'London, UK' THEN 'Local'
     ELSE 'Onsite'
END AS Location_Category
From 
    job_postings_fact;
LIMIT 50;

--New Qery Solution 6.
SELECT 
     *
FROM 
    Feburaray_Data
LIMIT 100;

CREATE TABLE January_data AS 
SELECT * 
FROM job_postings_fact
WHERE EXTRACT(MONTH FROM job_posted_date)= 1;

CREATE TABLE Feburary_Data  AS
SELECT * 
FROM job_postings_fact 
WHERE EXTRACT(MONTH FROM job_posted_date)= 2;

CREATE TABLE March_Data AS 
SELECT *
FROM job_postings_fact
WHERE EXTRACT(Year FROM job_posted_date) = 2023;

SELECT
    *
FROM
    March_Data
LIMIT 100;

DROP TABLE March_Data

SELECT 
    *
FROM (
    SELECT *
    FROM job_postings_fact
    WHERE ExTRACT(MONTH FROM job_posted_date) = 1
) AS january
LIMIT 100;

--How to use subqueries and ctc's 

SELECT
    company_id,
    name AS Company_Name
FROM
    company_dim
WHERE 
company_id IN 
( 
SELECT 
    company_id
FROM 
    job_postings_fact
WHERE
    job_no_degree_mention = TRUE
ORDER BY 
    company_id
    );

WIth Comapany_total_jobs AS (
    SELECT 
        company_id,
        COUNT(*) 
    FROM
        job_postings_fact
    GROUP BY
        company_id
     )
SELECT * 
FROM Comapany_total_jobs

WITH Employees_Data AS (
    SELECT 
        company_id,
        COUNT(*) AS JOBS
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)
SELECT 
company_dim.name AS NEW,
Employees_Data.JOBS
FROM
    company_dim
LEFT JOIN 
    Employees_Data
    ON  Employees_Data.company_id =company_dim.company_id;

-- Common table expressions usage
WITH Employees_Data AS (
    SELECT 
        company_id,
        COUNT(*) AS JOBS
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)
SELECT 
    company_dim.name AS NEW,
    Employees_Data.JOBS
FROM
    company_dim
LEFT JOIN 
    Employees_Data
    ON Employees_Data.company_id = company_dim.company_id;

--Problem number 7.
WITH Remote_job_skill AS (
SELECT
    skills_job_dim.skill_id,
   COUNT(job_postings_fact.job_id) AS Job_Count
FROM 
    skills_job_dim
INNER JOIN
    job_postings_fact ON
    job_postings_fact.job_id = skills_job_dim.job_id
WHERE 
    job_work_from_home = TRUE
GROUP BY
    skills_job_dim.skill_id )  
/* For running the command of CTE we must have to write this below statement 
SELECT *
FROM Remote_job_skill
*/
SELECT 
    skills_dim.skill_id,
    skills_dim.skills AS skill_Name,
    Job_Count
FROM 
    Remote_job_skill
INNER JOIN 
    skills_dim ON 
    skills_dim.skill_id = Remote_job_skill.skill_id
ORDER BY
    job_count DESC
LIMIT 5;
--Next is Union Operators in SQL 
SELECT 
job_title_short,
company_id,
job_location
FROM January_data

UNION All

SELECT 
job_title_short,
company_id,
job_location
FROM Feburary_Data; 

--Practice Problem No 8.
SELECT 
    Quarter_1_jobs.job_title_short,
    Quarter_1_jobs.job_location,
    Quarter_1_jobs.job_health_insurance,
    Quarter_1_jobs.job_posted_date :: DATE
FROM (
    SELECT *
    FROM January_data
    UNION ALL 
    SELECT *
    FROM Feburary_Data
 ) AS Quarter_1_jobs
WHERE 
    Quarter_1_jobs.job_location = 'India' AND 
    Quarter_1_jobs.job_title_short = 'Data Analyst' AND 
     EXTRACT(Quarter From job_posted_date) = 1
ORDER BY
    job_posted_date DESC;
   


