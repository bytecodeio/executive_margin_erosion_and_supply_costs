view: nyc_taxi_trips {
  derived_table: {
    sql:
      SELECT
        CAST(vendor_id AS STRING) AS vendor_id,
        pickup_datetime,
        dropoff_datetime,
        passenger_count,
        trip_distance,
        CAST(rate_code AS STRING) AS rate_code,
        CAST(payment_type AS STRING) AS payment_type,
        fare_amount,
        total_amount
      FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_*`
      WHERE _TABLE_SUFFIX BETWEEN '2008' AND '2021'
        AND fare_amount > 0
        AND fare_amount <= 500
        AND trip_distance > 0
        AND trip_distance <= 100
        AND passenger_count > 0
        AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, MINUTE) > 0
        AND TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, HOUR) < 24
    ;;
  }

  # --- Dimensions ---
  dimension: composite_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.vendor_id AS STRING), "_", CAST(${TABLE}.pickup_datetime AS STRING), "_", CAST(${TABLE}.dropoff_datetime AS STRING)) ;;
  }

  dimension_group: pickup {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    # Dynamically shifts timestamps forward based on the global manifest anchor
    sql: TIMESTAMP_ADD(${TABLE}.pickup_datetime, INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) ;;
    label: "Trip Pickup"
    description: "The dynamically shifted date and time the taxi trip started."
  }

  dimension: vendor_id {
    type: string
    sql: ${TABLE}.vendor_id ;;
    label: "Fleet Vendor ID"
    description: "The ID of the taxi fleet vendor."
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}.payment_type ;;
    label: "Payment Method"
    description: "Cash, Credit Card, etc."
  }

  dimension: rate_code {
    type: string
    sql: ${TABLE}.rate_code ;;
    label: "Rate Code"
    description: "Standard rate, JFK, Newark, etc."
  }

  dimension: passenger_count {
    type: number
    sql: ${TABLE}.passenger_count ;;
    label: "Passenger Count"
  }

  dimension: trip_distance {
    type: number
    hidden: yes
    sql: ${TABLE}.trip_distance ;;
  }

  dimension: fare_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.fare_amount ;;
  }

  dimension: total_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.total_amount ;;
  }

  # --- Measures ---
  measure: total_fleet_revenue {
    type: sum
    sql: ${total_amount} ;;
    value_format_name: usd_0
    label: "Total Fleet Revenue"
    description: "Total revenue collected from trips."
  }

  measure: average_fare {
    type: average
    sql: ${fare_amount} ;;
    value_format_name: usd
    label: "Average Fare Amount"
    description: "Average base fare per trip."
  }

  measure: total_trip_distance {
    type: sum
    sql: ${trip_distance} ;;
    value_format_name: decimal_0
    label: "Total Fleet Miles"
    description: "Total miles driven."
  }

  measure: total_passengers {
    type: sum
    sql: ${passenger_count} ;;
    label: "Total Passengers Moved"
  }
}
