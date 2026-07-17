include: "/views/_period_comparison.view.lkml"

view: nyc_taxi_trips {
  extends: [_period_comparison]
  sql_table_name:  `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_*` ;;

  # --- Abstract Event Mapping for Period Comparison ---
  dimension: event_raw {
    type: string
    hidden: yes
    sql: TIMESTAMP_ADD(${TABLE}.pickup_datetime, INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) ;;
  }

  dimension: event_date {
    type: string
    hidden: yes
    sql: CAST(TIMESTAMP_ADD(${TABLE}.pickup_datetime, INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) AS DATE) ;;
  }

  dimension: _TABLE_SUFFIX {
    type: string
    hidden: yes
    sql: ${TABLE}._TABLE_SUFFIX ;;
  }

  # --- Dimensions ---
  dimension: composite_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.vendor_id AS STRING), "_", CAST(${TABLE}.pickup_datetime AS STRING), "_", CAST(${TABLE}.dropoff_datetime AS STRING)) ;;
  }

  dimension_group: dropoff {
    hidden: yes
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: TIMESTAMP_ADD(${TABLE}.dropoff_datetime, INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) ;;
    label: "Trip Dropof"
    description: "The dynamically shifted date and time the taxi trip ended."
  }

  dimension_group: pickup {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
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
