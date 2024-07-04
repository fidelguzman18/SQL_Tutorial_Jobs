/*
Question: What are the top skills based on salary?
-Look at the average salary associated with each skill.
-Focuses on remote data analyst jobs, with information about the salary.
*/
SELECT
    skills,
    ROUND(AVG(salary_year_avg),2)
FROM 
    job_postings_fact
JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE AND
    salary_year_avg IS NOT NULL
GROUP BY 
    skills_dim.skills
ORDER BY 2 DESC
LIMIT 20;