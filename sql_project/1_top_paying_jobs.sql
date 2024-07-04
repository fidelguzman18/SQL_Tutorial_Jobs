/*
Question: What are the top-paying data analyst jobs that allow you to work from anywhere?
-I'd like to analyze what are the top-paying jobs and since I'm from Argentina, I'm interested only in remote oportunities.
*/
SELECT 
    comp.name,
    job.job_title,
    job.job_location,
    job.job_schedule_type,
    job.salary_year_avg,
    job.job_posted_date
FROM job_postings_fact AS job
LEFT JOIN company_dim AS comp
    ON job.company_id = comp.company_id
WHERE 
    job.job_title_short = 'Data Analyst' AND
    job.job_location = 'Anywhere' AND
    job.salary_year_avg IS NOT NULL
ORDER BY job.salary_year_avg DESC
LIMIT 100;