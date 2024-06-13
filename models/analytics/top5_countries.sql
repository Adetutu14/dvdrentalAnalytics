with customer_info as (
    select co.country_id,
    country,
    count(distinct customer_id) as customer_no, 
    sum (amount) total_amount
    from {{ source('dvdrental', 'country')}} co
    join {{ source('dvdrental', 'city')}} ci
    using (country_id)
    join {{ source('dvdrental', 'address')}} ad
    using (city_id)
    join {{ source('dvdrental', 'customer')}} cu
    using (address_id)
    join {{ source('dvdrental', 'payment')}} p
    using (customer_id)
    group by 1, 2
    order by total_amount desc
),

final as (
    select *
    from customer_info 
)

select * from final


    