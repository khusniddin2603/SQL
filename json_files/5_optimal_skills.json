
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


-- Rewriting the query to get the same results

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