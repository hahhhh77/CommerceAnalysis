use sql_practice;

-- 마지막 주문일에 +1한 날짜 구하기 -> 그 이후, max_date라고 설정
select date_add(max(order_date_new), interval 1 day) into @max_date from subset_superstore_2014_h1;
select @max_date;

-- rfm 데이터 마트 만들기
drop table if exists rfm_table_2014_h1;

create table rfm_table_2014_h1 as
   select `customer id`
   , datediff(@max_date, max(order_date_new)) as recency
   , count(`order id`) as frequency
   , sum(sales) as monetary
  from subset_superstore_2014_h1
  group by `customer id`;
  
-- column 추가하기
alter table rfm_table_2014_h1
  add column r_score int,
  add column f_score int,
  add column m_score int;


-- percentile 값 구하기
select * from rfm_table_2014_h1 limit 5;

  
update rfm_table_2014_h1 as r 
join (select `customer id`
      , percent_rank() over (order by recency desc) as r_percentile
      , percent_rank() over (order by frequency) as f_percentile
      , percent_rank() over (order by monetary) as m_percentile
      from rfm_table_2014_h1) as ranked_table
  on r.`customer id` = ranked_table.`customer id`
  
  set r.r_score = case
		when ranked_table.r_percentile <= 0.25 then 1
        when ranked_table.r_percentile <= 0.5 then 2
        when ranked_table.r_percentile <= 0.75 then 3
        else 4 end,
        
	r.f_score = case
		when ranked_table.f_percentile <= 0.25 then 1
        when ranked_table.f_percentile <= 0.5 then 2
        when ranked_table.f_percentile <= 0.75 then 3
        else 4 end,
        
	r.m_score = case
		when ranked_table.m_percentile <= 0.25 then 1
        when ranked_table.m_percentile <= 0.5 then 2
        when ranked_table.m_percentile <= 0.75 then 3
        else 4 end
 where r.`customer id` is not null;
 
select sum(monetary) into @sum_m from rfm_table_2014_h1;
select @sum_m;

-- rfm_effect를 계산한 테이블 만들기
create table rfm_effect_2014_h1 as 
select 
  'R' as effect_type
  , r_score as score_value
  , round(sum(monetary)/@sum_m * 100, 2) as effect
  from rfm_table_2014_h1
  group by r_score

union all

select
  'F' as effect_type
  , f_score as score_value
  , round(sum(monetary)/@sum_m * 100, 2) as effect
  from rfm_table_2014_h1
  group by f_score
  
union all

select
  'M' as effect_type
  , m_score as score_value
  , round(sum(monetary)/@sum_m * 100, 2) as effect
  from rfm_table_2014_h1
  group by m_score;
  
-- rfm_effect 살펴보기
select * from rfm_effect_2014_h1 limit 5;
select * from rfm_table_2014_h1 limit 5;

-- column 추가
alter table rfm_table_2014_h1
  add column r_effect decimal(10, 2),
  add column f_effect decimal(10, 2),
  add column m_effect decimal(10, 2);

-- update 하기
UPDATE rfm_table_2014_h1 r
JOIN 
(
  SELECT t.`customer id`,
         A.effect AS r_effect,
         B.effect AS f_effect,
         C.effect AS m_effect
  FROM rfm_table_2014_h1 t
  LEFT JOIN (SELECT * FROM rfm_effect_2014_h1 e WHERE e.effect_type = 'R') A ON t.r_score = A.score_value
  LEFT JOIN (SELECT * FROM rfm_effect_2014_h1 e WHERE e.effect_type = 'F') B ON t.f_score = B.score_value
  LEFT JOIN (SELECT * FROM rfm_effect_2014_h1 e WHERE e.effect_type = 'M') C ON t.m_score = C.score_value
) D
ON r.`customer id` = D.`customer id`
SET r.r_effect = D.r_effect,
    r.f_effect = D.f_effect,
    r.m_effect = D.m_effect
WHERE r.`customer id` IS NOT NULL;

-- column 추가
select * from rfm_table_2014_h1 limit 5;

alter table rfm_table_2014_h1
  add column r_weight decimal(10, 2),
  add column f_weight decimal(10, 2),
  add column m_weight decimal(10, 2);

-- weight 계산하기
update rfm_table_2014_h1 t
set t.r_weight = t.r_effect/(t.r_effect + t.f_effect + t.m_effect),
t.f_weight = t.f_effect/(t.r_effect + t.f_effect + t.m_effect),
t.m_weight = t.m_effect/(t.r_effect + t.f_effect + t.m_effect);

-- column 추가
alter table rfm_table_2014_h1
  add column rfm_score decimal(10, 2);

-- rfm_score 계산하기
update rfm_table_2014_h1 t
set t.rfm_score = r_score * r_weight + f_score * f_weight + m_score * m_weight;

-- 최종 데이터 확인하기
select * from rfm_table_2014_h1 limit 5;

-- customer clv 값 확인하기
select A.`customer id`, `customer_clv` from clv_table A
  where A.`customer id` in (select `customer id` from subset_superstore_2014)
  and A.second_order_date is not null;
  
-- rfm과 clv 값 합치기 
select A.*, B.customer_clv from rfm_table_2014_h1 A
  left join (select A.`customer id`, `customer_clv` from clv_table A
			where A.`customer id` in (select `customer id` from subset_superstore_2014)
			 and A.second_order_date is not null) B
  on A.`customer id` = B.`customer id`;
  