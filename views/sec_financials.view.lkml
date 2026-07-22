include: "/views/_period_comparison.view.lkml"

view: sec_financials {
  extends: [_period_comparison]
  sql_table_name: `bigquery-public-data.sec_quarterly_financials.quick_summary` ;;


  # --- Abstract Event Mapping for Period Comparison ---
  dimension_group: event {
    type: time
    datatype: timestamp
    timeframes: [
      raw,
      date,
      hour_of_day,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year,
      week,
      week_of_year,
      month,
      month_name,
      month_num,
      quarter,
      quarter_of_year,
      year]
    sql: TIMESTAMP( DATE_ADD(  PARSE_DATE('%Y%m%d', CAST(${TABLE}.period_end_date AS STRING)), INTERVAL (EXTRACT(YEAR FROM CURRENT_DATE()) - 2020) YEAR)) ;;
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
    ### only a record for the last day of every month. shifting by years to ensure the data stays recent.
    type: time
    timeframes: [raw, date, month, quarter, year]
    sql: TIMESTAMP( DATE_ADD(  PARSE_DATE('%Y%m%d', CAST(${TABLE}.period_end_date AS STRING)), INTERVAL (EXTRACT(YEAR FROM CURRENT_DATE()) - 2020) YEAR)) ;;
    label: "Financial Period End"
    description: "The dynamically shifted end date for the reported financial quarter/year."
  }

  dimension_group: period_end_original {
    hidden: yes
    type: time
    timeframes: [raw, date, month, quarter, year]
    sql: PARSE_TIMESTAMP('%Y%m%d', CAST(${TABLE}.period_end_date AS STRING))  ;;
    label: "Financial Period End Original"
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
