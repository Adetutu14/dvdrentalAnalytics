with customer_name as (
    SELECT first_name ||' '|| last_name AS full_name, 
    email, 
    address, 
    phone, 
    city, 
    country, 
    sum(amount) AS total_purchase
    FROM {{ source('dvdrental', 'customer') }} as cs
    JOIN {{ source('dvdrental', 'address') }} as ad
    ON cs.address_id = ad.address_id
    JOIN {{ source('dvdrental', 'city')}} as ct
    ON ad.city_id = ct.city_id
    JOIN {{ source('dvdrental', 'country') }} as cy
    ON ct.country_id = cy.country_id
    JOIN {{ source('dvdrental', 'payment')}} as pm
    ON cs.customer_id = pm.customer_id
    group by 1, 2, 3, 4, 5, 6
    order by total_purchase desc
),

final as (
    select *
from customer_name
)

select * from final
