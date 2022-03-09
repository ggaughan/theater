with 
    recursive prices(price) as (select 1.0 union select price + 0.01 from prices where price<=8),  -- range 1..8 in increments of 0.01
    vars(base_cost, per_attendee, base_attendance, base_price, attendance_per_dollar) as (select * from (values 
        (180,       0.04,         120,             5.00,       15*10)) as t),

    compute_attendees as (select base_attendance - (price - base_price) * attendance_per_dollar as attendees, * from vars cross join prices),
    compute_cost as (select base_cost+per_attendee * attendees as cost, * from compute_attendees),
    compute_profit as (select (attendees * price) - cost as profit, * from compute_cost)
select profit, price, rank() over (order by profit desc) as position
from compute_profit
order by position limit 1
