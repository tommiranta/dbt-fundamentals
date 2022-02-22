with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),

order_payments as (

    select
        {{ dbt_utils.surrogate_key(['orders.order_id', 'orders.customer_id']) }} as id,

        orders.order_id,
        orders.customer_id,
        orders.order_date,

        coalesce(payments.amount, 0) as amount

    from orders
    left join payments using (order_id)
)

select * from order_payments