view: nyc_taxi_trips {
  # Utilizing the 2018 table specifically to guarantee overlap with the SEC 2016-2020 data
  sql_table_name: `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2018` ;;

  # --- Dimensions ---
  dimension: composite_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${TABLE}.vendor_id AS STRING), CAST(${TABLE}.pickup_datetime AS STRING), CAST(${TABLE}.dropoff_datetime AS STRING)) ;;
  }

  dimension_group: pickup {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.pickup_datetime ;;
    label: "Trip Pickup"
    description: "The date and time the taxi trip started."
  }

  dimension: vendor_id {
    type: string
    sql: CAST(${TABLE}.vendor_id AS STRING) ;;
    label: "Fleet Vendor ID"
    description: "The ID of the taxi fleet vendor."
  }

  dimension: payment_type {
    type: string
    sql: CAST(${TABLE}.payment_type AS STRING) ;;
    label: "Payment Method"
    description: "Cash, Credit Card, etc."
  }

  dimension: rate_code {
    type: string
    sql: CAST(${TABLE}.rate_code AS STRING) ;;
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
