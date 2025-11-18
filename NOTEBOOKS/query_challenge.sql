query_prints = """
with t0 as (select [user_id],[event_data_value_prop] from [Challenge].[dbo].[taps]
where [day] > '{{FECHA_INICIO}}'--2020-11-22
group by [user_id],[event_data_value_prop]
),

--t0 hace referencia a los taps de la ultima semana de noviembre

t1 as (select [user_id],[event_data_value_prop] from [Challenge].[dbo].[prints]
where [day] > '{{FECHA_INICIO}}' --2020-11-22
group by [user_id],[event_data_value_prop]
)


,

--t1 hace referencia a los prints de la ultima semana de noviembre 2020 asumiendo que inicia el 23-11-2020

t2 as (
select [user_id],[event_data_value_prop],COUNT(*) as conteo_print from [Challenge].[dbo].[prints]
where [day] < '{{FECHA_SEMANAS}}'--2020-11-23
group by [user_id],[event_data_value_prop]
--order by 1

)
,

--t2 hace referencia a la cantidad de veces que se vio un value_prop en las semanas previas al 23-11-2025

t3 as (
select [user_id],[event_data_value_prop],COUNT(*) as conteo_tap from [Challenge].[dbo].[taps]
where [day] < '{{FECHA_SEMANAS}}'--2020-11-23
group by [user_id],[event_data_value_prop]
--order by 1
),

--t3 hace referencia a la cantidad de veces que se le dio click a un value prop

t4 as (
select [user_id],[value_prop], count(*) as conteo_pay from [Challenge].[dbo].[pays]
where [pay_date] < '{{FECHA_SEMANAS}}'--2020-11-23
group by [user_id],[value_prop]
--order by 1
)
,

--t4 hace referencia a la cantidad de veces que se hizo un pago para un value_prop

t5 as (
select [user_id],[value_prop], sum(total) as total_pay from [Challenge].[dbo].[pays]
where [pay_date] < '{{FECHA_SEMANAS}}'--2020-11-23
group by [user_id],[value_prop]
--order by 1
)
--t5 hace referencia al importe acumulado de cada value prop previo al 23-11-2020

select t1.[user_id], t1.[event_data_value_prop],
case when t0.[event_data_value_prop] is null then 0 else 1 end click,
case when t2.conteo_print is null then 0 else t2.conteo_print end cantidad_impresiones,
case when t3.conteo_tap is null then 0 else t3.conteo_tap end cantidad_clicks,
case when t4.conteo_pay is null then 0 else t4.conteo_pay end cantidad_pagos, 
case when t5.total_pay is null then 0 else t5.total_pay end total_pago
from t1
left join t0 on t0.[user_id] = t1.[user_id] and t0.[event_data_value_prop]= t1.[event_data_value_prop]
left join t2 on t2.[user_id] = t1.[user_id] and t2.[event_data_value_prop]= t1.[event_data_value_prop]
left join t3 on t3.[user_id] = t1.[user_id] and t3.[event_data_value_prop]= t1.[event_data_value_prop]
left join t4 on t4.[user_id] = t1.[user_id] and t4.[value_prop]= t1.[event_data_value_prop]
left join t5 on t5.[user_id] = t1.[user_id] and t5.[value_prop]= t1.[event_data_value_prop]
"""