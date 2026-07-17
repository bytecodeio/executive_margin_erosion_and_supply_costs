include: "/views/_period_comparison.view.lkml"

view: sec_financials {
  extends: [_period_comparison]
  sql_table_name: `bigquery-public-data.sec_quarterly_financials.quick_summary` ;;


  # --- Abstract Event Mapping for Period Comparison ---
  dimension: event_raw {
    type: string
    hidden: yes
    sql: TIMESTAMP_ADD(PARSE_TIMESTAMP('%Y%m%d', CAST(${TABLE}.period_end_date AS STRING)), INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) ;;
  }

  dimension: event_date {
    type: string
    hidden: yes
    sql: CAST(TIMESTAMP_ADD(PARSE_TIMESTAMP('%Y%m%d', CAST(${TABLE}.period_end_date AS STRING)), INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) AS DATE) ;;
  }

  # --- Core Dimensions ---
  dimension: submission_number {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.submission_number ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
    label: "Filing Company Name"
    description: "The SEC-registered name of the reporting enterprise."
  }

  dimension: measure_tag {
    type: string
    sql: ${TABLE}.measure_tag ;;
    hidden: yes
  }

  dimension: number_of_quarters {
    type: number
    sql: ${TABLE}.number_of_quarters ;;
    hidden: yes
  }

  dimension_group: period_end {
    type: time
    timeframes: [raw, date, month, quarter, year]
    sql: TIMESTAMP_ADD(PARSE_TIMESTAMP('%Y%m%d', CAST(${TABLE}.period_end_date AS STRING)), INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) ;;
    label: "Financial Period End"
    description: "The dynamically shifted end date for the reported financial quarter/year."
  }

  dimension: document_type {
    type: string
    sql: ${TABLE}.form ;;
    label: "SEC Form Type"
    description: "The type of SEC filing (e.g., 10-K, 10-Q)."
  }

  dimension: operating_expenses {
    type: number
    hidden: yes
    sql: ${TABLE}.value ;;
  }

  # --- Measures ---
  measure: total_operating_expenses {
    type: sum
    sql: ${operating_expenses} ;;
    value_format_name: usd_0
    label: "Reported Corporate OpEx"
    description: "Total operating expenses reported by the enterprise in their SEC filing."
  }

  measure: average_operating_expenses {
    type: average
    sql: ${operating_expenses} ;;
    value_format_name: usd_0
    label: "Average Corporate OpEx"
    description: "Average operating expenses across selected filings."
  }
}
