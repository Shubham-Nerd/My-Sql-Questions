--Here we find the highest in demand jobs along with highest salaries 

SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS Total_Jobs,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS Salary
FROM    
    job_postings_fact
INNER JOIN skills_job_dim ON
job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON
skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY 
    skills_dim.skill_id,
    skills
HAVING 
   COUNT(job_postings_fact.job_id) >10
ORDER BY
    Salary DESC;


