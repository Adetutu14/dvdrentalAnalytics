with loyal_customers as (
    select * 
    from {{ ref('loyal_customers') }}
),

final as (
    select *
    from loyal_customers
    where customer_id in (
        select customer_id 
        from {{ ref('active_customer') }}
    
    )
)

select * from final