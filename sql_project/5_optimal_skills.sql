/*
Question: What are the most optimal skills to learn?
-High demand and high pay.
-Focus on remote positions with available data about the salary.
*/

WITH skills_demand AS(
    SELECT 
        skills_dim.skill_id,
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
        job_work_from_home IS TRUE AND
        salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
), avg_salary AS(
    SELECT
        skills_dim.skill_id,
        skills,
        ROUND(AVG(salary_year_avg),2) AS avg_salary
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
        skills_dim.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    skills_demand.demand_count,
    avg_salary.avg_salary
FROM skills_demand
JOIN avg_salary
    ON skills_demand.skill_id = avg_salary.skill_id
ORDER BY 
    demand_count DESC,
    avg_salary DESC
LIMIT 25