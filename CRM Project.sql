create database CRM_project;
use CRM_Project;
-- Opportunity
select * from oppertunity_table;
-- 1.Expected amount
SELECT sum(Expected_amount) as Total_Expected_Amount from oppertunity_table where expected_amount <>'';

-- 2.Open active opportunities
select count(`has open activity`) as Total_Open_Activity  from oppertunity_table where `has open activity`= "True";
select count(opportunity_id) from oppertunity_table;
select concat(round(((select count(`has open activity`) as Total_Open_Activity  from oppertunity_table where `has open activity`= "True")
 / count(opportunity_id))*100,2),"%")  as active_open_opportunities from oppertunity_table;
 
-- 3.conversion Rate
SELECT concat(round(((SELECT COUNT(stage) FROM oppertunity_table 
WHERE stage = 'closed won') / COUNT(opportunity_id))*100,2),"%") AS Conversion_rate
FROM oppertunity_table;

-- 4.won Rate
SELECT concat(round(((SELECT COUNT(stage) FROM oppertunity_table 
WHERE stage = 'closed won') / COUNT(opportunity_id))*100,2),"%") AS won_rate
FROM oppertunity_table;

-- 5.Loss Rate
SELECT concat(round(((SELECT COUNT(stage) FROM oppertunity_table 
WHERE stage = 'closed lost') / COUNT(opportunity_id))*100,2),"%") AS Loss_rate
FROM oppertunity_table;

-- 6.expected vs forecast
select * from oppertunity_table;
select fiscal_year,sum(expected_amount) from oppertunity_table group by fiscal_year;
SELECT 
   `created date` ,
    SUM(expected_amount) OVER (ORDER BY `created date`) AS running_expected_revenue,
    SUM(CASE WHEN `Forecast Q Commit` = 'true' THEN amount ELSE 0 END) 
        OVER (ORDER BY `created date`) AS running_forecast_commit,
    (SUM(expected_amount) OVER (ORDER BY `created date`) - 
     SUM(CASE WHEN `Forecast Q Commit` = 'true' THEN amount ELSE 0 END) 
        OVER (ORDER BY `created date`)) AS difference
FROM 
    oppertunity_table
ORDER BY 
    `created date`;
    
-- 7.Active vs total opportunities
select (select count(`has open activity`) as Total_Open_Activity  from oppertunity_table where `has open activity`= "True") as Active_Opportunities,
count(opportunity_id) as Total_opportunities from oppertunity_table;

-- 8.closed won vs total opportunities
select(select count(stage) from oppertunity_table where stage = "closed won") as Closed_Won_Opportunities,
count(opportunity_id) as Total_Opportunities from oppertunity_table;

-- 9.Closed won vs Total Closed
select(select count(stage) from oppertunity_table where stage = "closed won") as Closed_Won_Opportunities,
count(closed) as Closed_Opportunities from oppertunity_table where closed = "true";

-- 10.Expected amount by Opportunity type
select opportunity_type,sum(expected_amount) from oppertunity_table group by opportunity_type order by opportunity_type;

-- 11.opportunities by industry
select industry,count(opportunity_id) as oppertunities from oppertunity_table group by industry order by oppertunities desc;

-- Lead
select * from oppertunity_table;
select * from lead_table ;
select * from account;
select * from opportunity_product;
select * from user_table;

-- 1.Total lead
select sum(total_leads) from lead_table;

-- 2.expected amount from converted leads
select l.lead_id,l.converted,o.expected_amount from oppertunity_table as o join lead_table as l on o.record_type_id=l.record_type_id where l.converted = "true";

-- 3.conversion rate
select concat(round((select count(converted) from lead_table where converted = "true")/count(lead_id)*100,2),"%") as conversion_rate from lead_table;

-- 4.converted accounts
select count(converted_account_id) from lead_table where converted_account_id<>'' ;

-- 5.converted opportunity
select count(converted_opportunity_id) from lead_table where converted_opportunity_id<>'' ;

-- 6.lead by source
select lead_source as source,count(lead_source) as lead_by_source from lead_table group by lead_source order by lead_by_source desc;

-- 7.lead by industry
select industry,count(lead_id) as industry_lead from lead_table group by industry order by industry_lead desc;

-- 8.lead by stage
select status,count(status) from lead_table group by status;
 
