{% set columns = ['NIGHTS_BOOKED','BOOKING_ID','BOOKING_AMOUNT'] %}

select {% for item in columns %}
{{item}}
{% if not loop.last %},{% endif%}
  
{% endfor %}
 from {{ ref('bronze_bookings') }}