-- Check count for each version
select version, count(*) from data_view
group by version
order by version desc

-- Check last update for each version
SELECT version, MAX(ETL_TIMESTAMP) as ETL_TIMESTAMP FROM adaptive_data_export
where version not in ('NULL', 'VERSION')
group by version
order by version desc

-- Check last update for each month of Actuals version
select distinct period, MAX(ETL_TIMESTAMP) as ETL_TIMESTAMP from adaptive_data_export
where version = 'Actuals'
group by period
order by right(period, 4) desc, left(period, 2) desc

-- Check total revenue for each month of a specific version
set version = 'Adaptive Actuals';

select da.year, da.period, sum(da.amount) from data_view da
left outer join account_view ac on da.account = ac.account_code
where da.version = $version
and ac.ACCOUNT_LEVEL_5_CODE = 'Net Revenue'
group by da.year, da.period
order by da.year desc, da.period desc

-- Check last update and count for each Dimension
select 'Account' as Dimension, ETL_TIMESTAMP, count(*) from account
where ETL_TIMESTAMP <> 'ETL_TIMESTAMP'
group by ETL_TIMESTAMP
union
select 'Company' as Dimension, ETL_TIMESTAMP, count(*) from company
where ETL_TIMESTAMP <> 'ETL_TIMESTAMP'
group by ETL_TIMESTAMP
union
select 'Cost Center' as Dimension, ETL_TIMESTAMP, count(*) from CostCenter
where ETL_TIMESTAMP <> 'ETL_TIMESTAMP'
group by ETL_TIMESTAMP
union
select 'Location' as Dimension, ETL_TIMESTAMP, count(*) from Location
where ETL_TIMESTAMP <> 'ETL_TIMESTAMP'
group by ETL_TIMESTAMP
union
select 'Geography' as Dimension, ETL_TIMESTAMP, count(*) from Geography
where ETL_TIMESTAMP <> 'ETL_TIMESTAMP'
group by ETL_TIMESTAMP
union
select 'SEC Grouping' as Dimension, ETL_TIMESTAMP, count(*) from SECGrouping
where ETL_TIMESTAMP <> 'ETL_TIMESTAMP'
group by ETL_TIMESTAMP
order by ETL_TIMESTAMP desc
