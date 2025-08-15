# Introduction

Diving deep into a Data Job market. This project examines and compares the difference between the salaries and the demand for the specific skill. At the end, this project summerizes the data and gives the final result containing the meet of demand and salary.

Want to check out all the queries?     [Click Here](/project_folder/)

# Background

After a long research and struggle through going back-and-forth various research papers, idea of creating the list of the most optimal skills using realiable dataset just came to my mind.

### The questions I wanted to answer are these:

1. What are the top-paying Data Jobs?
2. What skills are required for these jobs?
3. What skills are most in demand for these jobs?
4. Which skills are associated with the top-paying jobs?
5. What are the most optimal skills to learn?

# Tools I Used

To dive deep into the data, I used all the potential of the following tools:

- **SQL:** the backbone of the analysis. I used different queries to find insights out of the raw data.
- **PostreSQL:** Thought of the most optimal database system to use in this project.
- **Visual Studio Code:** The code writing tool that I used to manage my database and run queries.
- **Git & GitHub:** Chosen version control system and and the most optimal platform to share worldwide and manage project tracking.

# The Analysis

### Following query is used to extract the job postings that are for Data Analysts, for remote work and postings with yearly salaries given.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    company_dim.name AS company_name
FROM    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE   job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL 
ORDER BY salary_year_avg DESC
LIMIT 10
```

### Next query is used to identify which skills are needed for the most demanded jobs.

```sql
 WITH top_paying_jobs AS(
    SELECT 
        job_id,
        job_title,
        job_location,
        job_schedule_type,
        salary_year_avg,
        job_posted_date,
        company_dim.name AS company_name
    FROM    job_postings_fact

    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE   job_title_short = 'Data Analyst' AND 
            job_location = 'Anywhere' AND
            salary_year_avg IS NOT NULL 
    ORDER BY salary_year_avg DESC
    LIMIT 10
 )

 SELECT 
    top_paying_jobs.*,
    skills AS skills_required,
    type AS skill_type
 FROM top_paying_jobs
 INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
 INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
 ORDER BY salary_year_avg DESC

```
Queries like JOINs and CTEs are used to give the end result which contains the list most needed skills.

### 3rd query is used to get most demanded skills in the job market. 

```sql
SELECT 
    skills,
    COUNT(job_title) as count
FROM job_postings_fact
 INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
 INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
 WHERE job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere'
 GROUP BY skills
ORDER BY count DESC
LIMIT 5
```
### Top paying skills
```sql
SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
FROM job_postings_fact
 INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
 INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
 WHERE job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL
        -- job_location = 'Anywhere'
 GROUP BY skills
ORDER BY average_salary DESC
LIMIT 10
```

### At the end of the queries, combination of 2 CTEs used to get the list of most optimal skills using the queries I used above.

```sql
WITH skill_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(job_title) as count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND
            job_location = 'Anywhere' AND 
            salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id
), skill_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        --skills_job_dim.skills,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS average_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst' AND
            salary_year_avg IS NOT NULL
            -- job_location = 'Anywhere'
    GROUP BY skills_job_dim.skill_id
)

SELECT
    skill_demand.skill_id,
    skill_demand.skills,
    count,
    average_salary
FROM 
    skill_demand
INNER JOIN skill_salary on skill_demand.skill_id = skill_salary.skill_id
ORDER BY 
    count DESC,
    average_salary DESC
LIMIT 10
```

### Rewriting this query into a shorter from to boost the loading time and being as effiecient as possible

```sql
SELECT
    skills_dim.skill_id,
    skillS_dim.skills,
    COUNT(skills_job_dim.job_id) AS skill_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
GROUP BY skills_dim.skill_id
HAVING COUNT(skills_job_dim.skill_id)>10
ORDER BY 
    salary,
    skill_count
LIMIT 20;
```

# What I Learned

- Working with complex queries, this jouney took through my first sql world, actually looking at the data and thinking what should happen and what would happen next. 
- Wroking with databases: eventhough I messed up my local database several times, this project taught me how to deal with my database and how to create, work and optimzie one.
- Problem Solving skills: this trip took me through some serious thinking, especially when I am troubleshooting and debuggin my codes.
- Critical thinking: When I was working on the questions I listed above, I wasa forced to think deep and critical enough to find the best questions and ways to extract insights from the raw data.

# Counclusions

In a nutshell, this project made me realise that I am capabale of doing some serious research and run queries. I learned how to look at the problem from the 3rd dimension. Now, I can caonfidently work on SQL queries and databases to upgrade my skillset and land a job in the future. This project is the fundament of my data analytics career.