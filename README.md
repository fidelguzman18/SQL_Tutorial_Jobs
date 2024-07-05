# Introduction
Take a look at the data job market. Focusing on data analytics roles that can be done from anywhere in the world, exploring the top-paying jobs, the most in demand skills and how they can relate.
Check the SQL queries here: [sql_project_folder](/sql_project/).

# Background
This project was inspired by an online SQL tutorial and the goal was to get a better understanding of the data job market while learning the basics of the language.

The data used came from this [source](https://lukebarousse.com/sql).

### The questions i wanted to answer through this SQL queries where:
1. What are the top-paying remote data analyst jobs?
2. What skills are required for this top-paying jobs?
3. What are the most demanded skills for a remote data analyst?
4. Which skills are associated with a higher salary?
5. What are the most optimal skills to learn?

# Tools used
In order of completing this analysis i used the following tools:

- PostgrSQL
- Visual Studio Code
- Git and Github

# The analysis

Each question in this project aimed at learning more about different aspects of the data analyst job market.
Here is how I formulated each query:

### 1. Top paying data analyst jobs.
To find this jobs I filtered the job postings table, filtering remote data analyst positions by yearly average salary.

```sql
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
```
Some insights gained from this query:
1. Looking at the salary column we can see there's a huge potential in the area.
2. We can also appreciate that most of the positions are full-time jobs.
3. There's a big diversity both in the specific roles and companies meaning you can find high paying jobs in an area that you're passionate about.


### 2. Skills in top-paying jobs.
To have a better understanding of what skills are demanded in the top-paying jobs I created a CTE with the top-paying jobs and then did a query grouping the results by skill.
```sql
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
```
We can see sql and python are on top of the list, with a visualization tool like tableau right next to them.

### 3. In-demand skills for data analysts.
To answer this question I wrote a simple query counting the jobs posted and grouping them by skills. 
```sql
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
```
Looking at the demand for al the remote data analyst positions, we can se that sql is still the most required attribute, with python and visualization tools coming close. We can also see excel appearing in the top, which is no surprise as it's a really powerfool tool for data analysis.

### 4. Skills based on salary.
With this query we investigated the average salary associated with each skill for remote data analyst positions.
```sql
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
```
Analyzing the results we see that Big data, ML and cloud computing skills are the most valued skills by companies in general.

### 5. Most optimal skills to learn
Combining the two previous queries we'll find what skills are both high paying and in high demand.
```sql
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
```
Sql, excel, python and visualization tools came on top on in the demanded aspect so it's clearly important to be proficient with this skills in order to have grater chances in this market.
On the other hand, cloud computing, big data and machine learning skills are the most rewardings skills in terms of salary, so learning about them can potentially increase your capability of landing a better paying job.

# Closing thoughts
This project gave a better understanding of how can sql be used in a more job-like situation, combining tables and queries in order to answer specific questions.
On the other hand, the particular data I worked with gave me a better understanding of the job market I'm interested in, confirming that the skills I have and I'm currently getting better at are highly valued and demanded by companies, and also made me realize of the huge oportunities available to work from wherever I want.