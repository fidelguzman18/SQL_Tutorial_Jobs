/*
Question: What are the most demanded skills as a data analyst?
*/

SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM 
    job_postings_fact
JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home IS TRUE
GROUP BY 
    skills_dim.skills
ORDER BY 2 DESC
LIMIT 10;