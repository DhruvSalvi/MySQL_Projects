show databases;
use world;

-- 1. Check for Empty (NULL) Cells in Each Column
SELECT
  SUM(CASE WHEN `Person ID` IS NULL THEN 1 ELSE 0 END) AS `Person ID Nulls`,
  SUM(CASE WHEN `Gender` IS NULL THEN 1 ELSE 0 END) AS `Gender Nulls`,
  SUM(CASE WHEN `Age` IS NULL THEN 1 ELSE 0 END) AS `Age Nulls`,
  SUM(CASE WHEN `Occupation` IS NULL THEN 1 ELSE 0 END) AS `Occupation Nulls`,
  SUM(CASE WHEN `Sleep Duration` IS NULL THEN 1 ELSE 0 END) AS `Sleep Duration Nulls`,
  SUM(CASE WHEN `Quality of Sleep` IS NULL THEN 1 ELSE 0 END) AS `Quality of Sleep Nulls`,
  SUM(CASE WHEN `Physical Activity Level` IS NULL THEN 1 ELSE 0 END) AS `Physical Activity Level Nulls`,
  SUM(CASE WHEN `Stress Level` IS NULL THEN 1 ELSE 0 END) AS `Stress Level Nulls`,
  SUM(CASE WHEN `BMI Category` IS NULL THEN 1 ELSE 0 END) AS `BMI Category Nulls`,
  SUM(CASE WHEN `Blood Pressure` IS NULL THEN 1 ELSE 0 END) AS `Blood Pressure Nulls`,
  SUM(CASE WHEN `Heart Rate` IS NULL THEN 1 ELSE 0 END) AS `Heart Rate Nulls`,
  SUM(CASE WHEN `Daily Steps` IS NULL THEN 1 ELSE 0 END) AS `Daily Steps Nulls`,
  SUM(CASE WHEN `Sleep Disorder` IS NULL THEN 1 ELSE 0 END) AS `Sleep Disorder Nulls`
FROM Sleep_health_and_lifestyle_dataset;

-- 2. Fill NULLs Based on Data Type

-- 3. For Integer Columns (e.g., `Age`): Fill with Mean
SET SQL_SAFE_UPDATES = 0;

-- Then run your updates
UPDATE Sleep_health_and_lifestyle_dataset 
SET `Age` = (SELECT ROUND(AVG(`Age`)) 
             FROM (SELECT * FROM Sleep_health_and_lifestyle_dataset) AS t) 
WHERE `Person ID` IN (SELECT `Person ID` 
                     FROM (SELECT `Person ID` FROM Sleep_health_and_lifestyle_dataset 
                          WHERE `Age` IS NULL) AS subquery);

-- 4. For Integer Columns (e.g., `Quality of Sleep`): Fill with Mean
UPDATE Sleep_health_and_lifestyle_dataset
SET `Quality of Sleep` = (SELECT ROUND(AVG(`Quality of Sleep`)) FROM (SELECT * FROM Sleep_health_and_lifestyle_dataset) AS t)
WHERE `Quality of Sleep` IS NULL;

-- 5. For Integer Columns (e.g., `Physical Activity Level`): Fill with Mean
UPDATE Sleep_health_and_lifestyle_dataset
SET `Physical Activity Level` = (SELECT ROUND(AVG(`Physical Activity Level`)) FROM (SELECT * FROM Sleep_health_and_lifestyle_dataset) AS t)
WHERE `Physical Activity Level` IS NULL;

-- 6. For Integer Columns (e.g., `Stress Level`): Fill with Mean
UPDATE Sleep_health_and_lifestyle_dataset
SET `Stress Level` = (SELECT ROUND(AVG(`Stress Level`)) FROM (SELECT * FROM Sleep_health_and_lifestyle_dataset) AS t)
WHERE `Stress Level` IS NULL;

-- 7. For Integer Columns (e.g., `Heart Rate`): Fill with Mean
UPDATE Sleep_health_and_lifestyle_dataset
SET `Heart Rate` = (SELECT ROUND(AVG(`Heart Rate`)) FROM (SELECT * FROM Sleep_health_and_lifestyle_dataset) AS t)
WHERE `Heart Rate` IS NULL;

-- 8. For Integer Columns (e.g., `Daily Steps`): Fill with Mean
UPDATE Sleep_health_and_lifestyle_dataset
SET `Daily Steps` = (SELECT ROUND(AVG(`Daily Steps`)) FROM (SELECT * FROM Sleep_health_and_lifestyle_dataset) AS t)
WHERE `Daily Steps` IS NULL;

-- 9. Average Sleep Duration by Gender
SELECT 
    Gender,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Gender;

-- 10. Sleep Quality Distribution
SELECT 
    `Quality of Sleep`,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `Quality of Sleep`
ORDER BY `Quality of Sleep`;

-- 11. Sleep Disorders by BMI Category
SELECT 
    `BMI Category`,
    `Sleep Disorder`,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `BMI Category`, `Sleep Disorder`
ORDER BY `BMI Category`, Count DESC;

-- 12. Average Sleep Metrics by Occupation
SELECT 
    Occupation,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality,
    COUNT(*) as Employee_Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Occupation
ORDER BY Avg_Sleep_Quality DESC;

-- 13. Stress Level Distribution
SELECT 
    `Stress Level`,
    COUNT(*) as Count,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `Stress Level`
ORDER BY `Stress Level`;

-- 14. Physical Activity Level Impact
SELECT 
    CASE 
        WHEN `Physical Activity Level` < 30 THEN 'Low'
        WHEN `Physical Activity Level` < 60 THEN 'Medium'
        ELSE 'High'
    END as Activity_Level,
    COUNT(*) as Count,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Activity_Level
ORDER BY Avg_Sleep_Quality DESC;

-- 15. Blood Pressure Analysis
SELECT 
    `Blood Pressure`,
    COUNT(*) as Count,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `Blood Pressure`
ORDER BY Count DESC;

-- 16. Age Group Analysis
SELECT 
    CASE 
        WHEN Age < 30 THEN '20-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END as Age_Group,
    COUNT(*) as Count,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Age_Group
ORDER BY Age_Group;

-- 17. Daily Steps Impact
SELECT 
    CASE 
        WHEN `Daily Steps` < 5000 THEN 'Sedentary'
        WHEN `Daily Steps` < 7500 THEN 'Lightly Active'
        WHEN `Daily Steps` < 10000 THEN 'Moderately Active'
        ELSE 'Very Active'
    END as Activity_Level,
    COUNT(*) as Count,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Activity_Level
ORDER BY Avg_Sleep_Quality DESC;

-- 18. Heart Rate Analysis
SELECT 
    CASE 
        WHEN `Heart Rate` < 70 THEN 'Low'
        WHEN `Heart Rate` < 80 THEN 'Normal'
        WHEN `Heart Rate` < 90 THEN 'Elevated'
        ELSE 'High'
    END as Heart_Rate_Category,
    COUNT(*) as Count,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Heart_Rate_Category
ORDER BY Avg_Sleep_Quality DESC;

-- 19. For String Columns (e.g., `Sleep Disorder`): Fill with Mode
UPDATE Sleep_health_and_lifestyle_dataset
SET `Sleep Disorder` = (
  SELECT mode_value FROM (
    SELECT `Sleep Disorder` AS mode_value
    FROM Sleep_health_and_lifestyle_dataset
    WHERE `Sleep Disorder` IS NOT NULL
    GROUP BY `Sleep Disorder`
    ORDER BY COUNT(*) DESC
    LIMIT 1
  ) AS mode_subquery
)
WHERE `Sleep Disorder` IS NULL;

-- 20. Sleep Duration vs Quality of Sleep Correlation
-- Note: MySQL doesn't have a direct correlation function, but we can approximate it
SELECT 
    COUNT(*) * SUM(`Sleep Duration` * `Quality of Sleep`) - SUM(`Sleep Duration`) * SUM(`Quality of Sleep`)
    / 
    SQRT((COUNT(*) * SUM(`Sleep Duration` * `Sleep Duration`) - SUM(`Sleep Duration`) * SUM(`Sleep Duration`))
    * 
    (COUNT(*) * SUM(`Quality of Sleep` * `Quality of Sleep`) - SUM(`Quality of Sleep`) * SUM(`Quality of Sleep`))) 
    as correlation
FROM Sleep_health_and_lifestyle_dataset;

-- 21. Stress Level and Sleep Disorders

SELECT 
    `Stress Level`,
    SUM(CASE WHEN `Sleep Disorder` = 'Insomnia' THEN 1 ELSE 0 END) as Insomnia_Count,
    SUM(CASE WHEN `Sleep Disorder` = 'Sleep Apnea' THEN 1 ELSE 0 END) as Sleep_Apnea_Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `Stress Level`
ORDER BY `Stress Level`;

-- 22. BMI Category and Sleep Disorders

SELECT 
    `BMI Category`,
    SUM(CASE WHEN `Sleep Disorder` = 'Insomnia' THEN 1 ELSE 0 END) as Insomnia_Count,
    SUM(CASE WHEN `Sleep Disorder` = 'Sleep Apnea' THEN 1 ELSE 0 END) as Sleep_Apnea_Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `BMI Category`;

-- 23. Occupation and Sleep Patterns

SELECT 
    Occupation,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Occupation
ORDER BY Avg_Sleep_Quality DESC;

-- 24. Physical Activity Level and Sleep Quality Average

SELECT 
    `Physical Activity Level`,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `Physical Activity Level`
ORDER BY `Physical Activity Level`;

-- 25. Age Groups and Sleep Patterns

SELECT 
    CASE 
        WHEN Age < 30 THEN '20-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END as Age_Group,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Age_Group
ORDER BY Age_Group;

-- 26. Blood Pressure and Sleep Disorders
SELECT 
    `Blood Pressure`,
    SUM(CASE WHEN `Sleep Disorder` = 'Insomnia' THEN 1 ELSE 0 END) as Insomnia_Count,
    SUM(CASE WHEN `Sleep Disorder` = 'Sleep Apnea' THEN 1 ELSE 0 END) as Sleep_Apnea_Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY `Blood Pressure`
ORDER BY `Blood Pressure`;

-- 27. Gender Analysis

SELECT 
    Gender,
    ROUND(AVG(`Sleep Duration`), 2) as Avg_Sleep_Duration,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality,
    SUM(CASE WHEN `Sleep Disorder` = 'Insomnia' THEN 1 ELSE 0 END) as Insomnia_Count,
    SUM(CASE WHEN `Sleep Disorder` = 'Sleep Apnea' THEN 1 ELSE 0 END) as Sleep_Apnea_Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Gender;

-- 28. Heart Rate Ranges and Sleep Quality

SELECT 
    CASE 
        WHEN `Heart Rate` < 70 THEN 'Low (<70)'
        WHEN `Heart Rate` < 80 THEN 'Normal (70-79)'
        WHEN `Heart Rate` < 90 THEN 'Elevated (80-89)'
        ELSE 'High (90+)'
    END as Heart_Rate_Range,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Heart_Rate_Range
ORDER BY Heart_Rate_Range;

-- 29. Daily Steps Analysis

SELECT 
    CASE 
        WHEN `Daily Steps` < 5000 THEN 'Sedentary (<5000)'
        WHEN `Daily Steps` < 7500 THEN 'Low Active (5000-7499)'
        WHEN `Daily Steps` < 10000 THEN 'Somewhat Active (7500-9999)'
        ELSE 'Active (10000+)'
    END as Activity_Level,
    ROUND(AVG(`Quality of Sleep`), 2) as Avg_Sleep_Quality,
    COUNT(*) as Count
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Activity_Level
ORDER BY Avg_Sleep_Quality DESC;

-- 30. Additional Insight: Sleep Disorder Distribution by Occupation

SELECT 
    Occupation,
    COUNT(*) as Total_Employees,
    SUM(CASE WHEN `Sleep Disorder` = 'Insomnia' THEN 1 ELSE 0 END) as Insomnia_Count,
    SUM(CASE WHEN `Sleep Disorder` = 'Sleep Apnea' THEN 1 ELSE 0 END) as Sleep_Apnea_Count,
    ROUND(AVG(`Stress Level`), 2) as Avg_Stress_Level
FROM Sleep_health_and_lifestyle_dataset
GROUP BY Occupation
ORDER BY Total_Employees DESC;

-- 31. High Risk Group Analysis

SELECT COUNT(*) as High_Risk_Count
FROM Sleep_health_and_lifestyle_dataset
WHERE `Stress Level` >= 7 
AND `Quality of Sleep` <= 5
AND `Sleep Disorder` IS NOT NULL;