with rental_date_difference AS (
    SELECT inventory_id,
         DATEDIFF('day', return_date, rental_date) AS date_difference
    FROM  {{ source('dvdrental', 'rental') }}
    ),

rental_perfomance AS (
    SELECT f.film_id,
      CASE 
          WHEN rental_duration > date_difference THEN 'Returned early'
          WHEN rental_duration = date_difference THEN 'Returned on time'
          ELSE 'Returned late'
      END AS return_status
      FROM {{ source('dvdrental', 'film') }} as f
      JOIN {{ source('dvdrental', 'inventory') }}
      USING(film_id)
      JOIN rental_date_difference
      USING(inventory_id)
      ),

final as (
    select return_status,
     count(film_id) total_films
from rental_perfomance
group by 1
)

select * from final
