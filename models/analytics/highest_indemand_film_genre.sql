
WITH customer_info AS (
      SELECT c.name AS genre,
       count(cs.customer_id) AS total_rent_demand
        FROM {{ source('dvdrental', 'category')}} as c
           JOIN {{ source('dvdrental', 'film_category')}} as fc
           USING(category_id)
           JOIN {{ source('dvdrental', 'film')}} f
           USING(film_id)
           JOIN {{ source('dvdrental', 'inventory')}} i
           USING(film_id)
           JOIN {{ source('dvdrental', 'rental')}} r
           USING(inventory_id)
           JOIN {{ source('dvdrental', 'customer')}} cs
           USING(customer_id)
           GROUP BY 1
      ),

  customer_purchase AS (
      SELECT c.name AS genre, 
      SUM(p.amount) AS total_sales
          FROM {{ source('dvdrental', 'category')}} c
          JOIN {{ source('dvdrental', 'film_category')}} fc
          USING(category_id)
          JOIN {{ source('dvdrental', 'film')}} f
          USING(film_id)
          JOIN {{ source('dvdrental', 'inventory')}} i
          USING(film_id)
          JOIN {{ source('dvdrental', 'rental')}} r
          USING(inventory_id)
          JOIN {{ source('dvdrental', 'payment')}} p
          USING(rental_id)
          GROUP BY 1
      ),

  final as ( 
    SELECT customer_info.genre, 
    customer_info.total_rent_demand, 
    customer_purchase.total_sales 
    FROM customer_info
    JOIN customer_purchase
    ON customer_info.genre = customer_purchase.genre
    order by customer_info.total_rent_demand desc
    )

  select * from final



