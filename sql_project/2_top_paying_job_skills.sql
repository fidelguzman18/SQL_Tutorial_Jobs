/*
Question: What skills are valued the most by companies?
-Now that I have a list of the best paid jobs, I'd like to know what skills do companies value the most.
*/
WITH top_paying_jobs AS
    (SELECT 
        job.job_id,
        comp.name,
        job.job_title,
        job.salary_year_avg
    FROM job_postings_fact AS job
    LEFT JOIN company_dim AS comp
        ON job.company_id = comp.company_id
    WHERE 
        job.job_title_short = 'Data Analyst' AND
        job.job_location = 'Anywhere' AND
        job.salary_year_avg IS NOT NULL
    ORDER BY job.salary_year_avg DESC
    LIMIT 100)

SELECT
    skills_dim.skills,
    COUNT(*)
FROM top_paying_jobs
JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills_dim.skills
ORDER BY count DESC;