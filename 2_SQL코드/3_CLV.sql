use sql_practice;

select * from superstore_sales_240830 limit 5;

-- text 타입의 order date 컬럼 형태 바꾸기(새 컬럼 추가)
ALTER TABLE `superstore_sales_240830` 
  ADD COLUMN order_date_new DATE;

select str_to_date(`Order Date`, '%m/%d/%Y') from superstore_sales_240830 limit 5;

-- 0 = safe mode 풀기, 1 = safe mode
SET SQL_SAFE_UPDATES = 0;
UPDATE superstore_sales_240830 
  SET order_date_new = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

-- order date의 최초일과 마지막일 확인 : 2014-01-04~2017-12-30
select min(order_date_new), max(order_date_new) 
  from `superstore_sales_240830`; 

-- 연도/반기 별 고유 고객수 확인
select year(order_date_new) as year_info, 
  case when month(order_date_new) between 1 and 6 then 'H1' else 'H2' end as half_year,
  count(distinct `customer id`) as unique_customer_count
  from superstore_sales_240830
  group by year_info, half_year
  order by 1, 2;
 
-- 2014년 상반기 데이터만 추출 후, 새로운 테이블(subset_superstore_2014_h1) 만들기 
create table subset_superstore_2014_h1 as 
  select * from superstore_sales_240830
  where order_date_new < '20140801';
  
select * from subset_superstore_2014_h1 limit 10;

-- 2014년 상반기 - 각 고객 별 고유주문수 확인
select A.cnt, count(*)
from(select `customer id`, count(distinct `order id`) as cnt
  from subset_superstore_2014_h1
  group by `customer id`) A
  group by A.cnt;
  
-- 2014년 데이터만 추출해서 새로운 테이블(subset_superstore_2014) 만들기
create table subset_superstore_2014 as 
  select * from superstore_sales_240830
  where order_date_new < '20150101';
  
-- 고객의 첫 주문 일자를 알아보기 위한 새로운 테이블(customer_first_order) 만들기 
create table customer_first_order as
select `customer id`, min(order_date_new) as first_day_order from superstore_sales_240830
  group by `customer id`;
  
-- customer_first_order 테이블에 새로운 컬럼(one_year_after) 추가하기  
alter table customer_first_order
  add column one_year_after date;

-- sql safe model 해제
set sql_safe_updates = 0;

-- customer_first_order 테이블의 one_year_after 컬럼에 첫 주문일로부터 1년 뒤의 날짜 입력하기
update customer_first_order
  set one_year_after = date_add(first_day_order, interval 1 year)
  where first_day_order is not null;
  
select * from customer_first_order limit 5;

-- 원본 데이터(superstore_sales_240830)에 각 고객의 첫 주문 날짜와 첫 주문 날짜로부터 1년 뒤의 날짜 정보 추가하기
create table customer_one_year_order as
select A.* from superstore_sales_240830 A
 join customer_first_order B 
 on A.`customer id` = B.`customer id`
 where A.order_date_new >= B.first_day_order 
 and A.order_date_new < B.one_year_after;
 
-- customer_one_year_order 테이블에서 최초 주문일자와 가장 마지막 주문일자 확인하기
select min(order_date_new), max(order_date_new) from customer_one_year_order;

-- CLV = 고객가치 * 평균 고객 수명
-- 구매가치 = 평균 구매 가치 * 평균 구매 빈도
-- 평균 구매 가치 = 특정기간 내 고객이 주문한 총 매출액(각 고객) / 특정기간 내 총 구매 횟수(전체)

-- 특정기간 내 총 구매 횟수(전체) 계산 후, @purchase_count라고 저장하기
select count(distinct `order id`) into @purchase_count from customer_one_year_order;
select @purchase_count; -- 1789

-- 평균 구매 가치 구하기 : '특정기간 내 각 고객이 주문한 총 매출액'을 '특정기간 내 총 구매횟수(전체)'로 나누기
select `customer id`, sum(sales)/@purchase_count as purchase_value from customer_one_year_order
  group by `customer id`;
  

-- 각 고객 별로 계산한 평균 구매 가치 정보를 가지고 clv table 만들기
create table clv_table as
select `customer id`, sum(sales)/@purchase_count as purchase_value from customer_one_year_order
  group by `customer id`;


-- 평균 구매 빈도 = 특정기간 내 구매 횟수(각 고객) / 특정기간 내 총 고객수(전체)
select count(distinct `customer id`) from customer_one_year_order; -- 총 고객수 = 793명

select `customer id`, count(distinct `order id`)/793 as purchase_freq from customer_one_year_order 
  group by `customer id`;
  
-- 각 고객 별 주문 횟수 정보를 넣기 위한 컬럼(purchase_freq) clv_table에 추가하기
alter table clv_table
  add column purchase_freq decimal(10, 4);
  
update clv_table A
left join (select `customer id`, count(distinct `order id`) / 793 as purchase_freq from customer_one_year_order 
  group by `customer id`) B 
  on A.`customer id` = B.`customer id`
  set A.purchase_freq = B.purchase_freq;
  
select * from clv_table limit 5;

-- 평균 고객 수명 = 고객이 지속적으로 구매한 기간(각 고객) / 총 고객수(전체) 
-- 각 고객 별 평균 고객 수명 계산하기
select `customer id`, datediff(max(order_date_new), min(order_date_new))/793 as lifespan from customer_one_year_order
  group by `customer id`;

-- 각 고객 별 평균 고객 수명 정보를 lifespan 이란 컬럼에 저장하기
alter table clv_table
  add column lifespan decimal(10, 4);
  
select * from clv_table limit 5;

update clv_table
 set lifespan = null;

update clv_table A
left join (select `customer id`, round(datediff(max(order_date_new), min(order_date_new))/793, 4) as lifespan 
           from customer_one_year_order
           group by `customer id`) B 
           on A.`customer id` = B.`customer id`
set A.lifespan = B.lifespan
where A.`customer id` is not null;

select * from clv_table limit 5;

-- 최종적으로 고객 별 clv 값 계산하기
alter table clv_table
  add column customer_clv decimal(10, 4);

select * from clv_table;  

-- 고객 별 clv의 최솟값과 최댓값 확인하기
select min(customer_clv), max(customer_clv) from clv_table; -- 0 ~ 0.019

-- 2014년 주문내역으로 구성된 테이블이 clv 정보 추가하기
select A.*, B.customer_clv from subset_superstore_2014 A
left join clv_table B 
on A.`customer id` = B.`customer id`;

-- 고객들의 첫 주문일과 두 번째 주문일 구하고, customer_order_info란 테이블 만들기
create table customer_order_info as
select * from(
select 
B.`customer id`
, row_number() over(partition by B.`customer id` order by B.order_date_new) as rnum
, B.order_date_new
, B.next_order_date
from(-- 그 다음 주문일 구하기
		select A.`customer id`
		  , A.order_date_new
		  , lead(A.order_date_new, 1) over (partition by A.`customer id` order by A.order_date_new) next_order_date
		from(SELECT DISTINCT `customer id`, order_date_new
		FROM subset_superstore_2014
		ORDER BY `customer id`, order_date_new) A) B) C
where C.rnum = 1;

select * from customer_order_info limit 10;

-- 첫 주문부터 두 번째 주문까지 경과일 구하기
select `customer id`, datediff(next_order_date, order_date_new) from customer_order_info;

select * from customer_order_info;

-- 첫 주문일과 두 번째 주문일에 결제한 금액 정보 추가하기
alter table customer_order_info
  add column first_order_sales decimal(10, 2),
  add column second_order_sales decimal(10,2);

-- 첫 주문일 결제 금액 정보 추가
UPDATE customer_order_info A
LEFT JOIN (
    SELECT `customer id`, `order_date_new`, SUM(sales) AS total_sales
    FROM superstore_sales_240830
    GROUP BY `customer id`, `order_date_new`
) B_agg
  ON A.`customer id` = B_agg.`customer id`
  AND A.`order_date_new` = B_agg.`order_date_new`
SET A.first_order_sales = B_agg.total_sales;

-- 두 번째 주문일 결제 금액 정보 추가
UPDATE customer_order_info A
LEFT JOIN (
    SELECT `customer id`, `order_date_new`, SUM(sales) AS total_sales
    FROM superstore_sales_240830
    GROUP BY `customer id`, `order_date_new`
) B_agg
  ON A.`customer id` = B_agg.`customer id`
  AND A.`next_order_date` = B_agg.`order_date_new`
SET A.second_order_sales = B_agg.total_sales;

-- clv_table에 첫 주문일, 두 번째 주문일, 첫 주문일 결제 금액, 두 번째 주문일 결제 금액 정보 추가하기
alter table clv_table 
  add column first_order_date date,
  add column second_order_date date,
  add column first_order_sales decimal(10, 2),
  add column second_order_sales decimal(10, 2);
  

select A.*
  , B.order_date_new as first_order_date
  , B.next_order_date as second_order_date
  , B.first_order_sales
  , B.second_order_sales 
  from clv_table A
 left join customer_order_info B
 on A.`customer id` = B.`customer id`;
 
UPDATE clv_table A
LEFT JOIN customer_order_info B
  ON A.`customer id` = B.`customer id`
SET A.first_order_date = B.order_date_new,
    A.second_order_date = B.next_order_date,
    A.first_order_sales = B.first_order_sales,
    A.second_order_sales = B.second_order_sales;

select * from clv_table; 

-- 2014년에 주문한 고객들의 clv 값 확인하기 
select * from clv_table A
  where A.`customer id` in (select `customer id` from subset_superstore_2014);
 