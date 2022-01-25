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
