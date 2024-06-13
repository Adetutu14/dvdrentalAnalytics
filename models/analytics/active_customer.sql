with active_customers as (
    select * from {{ source('dvdrental', 'customer')}}
    where active = 1
),
final as (
    select customer_id,
    first_name, 
    last_name, 
    active
    from active_customers
)
select * from final