view: sec_financials {
  derived_table: {
    sql:
      SELECT
        submission_number AS submission_number,
        company_name AS company_name,
        -- Parses YYYYMMDD string/integer safely into a true TIMESTAMP
        PARSE_TIMESTAMP('%Y%m%d', CAST(period_end_date AS STRING)) AS period_end_date,
        form AS document_type,
        CAST(value AS FLOAT64) AS operating_expenses
      FROM `bigquery-public-data.sec_quarterly_financials.quick_summary`
      WHERE measure_tag IN ('OperatingExpenses', 'CostOfRevenue', 'CostsAndExpenses')
        AND (number_of_quarters = 0 OR number_of_quarters IS NULL)
    ;;
  }

  # --- Primary Key ---
  dimension: submission_number {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.submission_number ;;
  }

  # --- Dimensions ---
  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
    label: "Filing Company (Corp)"
    description: "The official SEC registered name of the company."
  }

  dimension_group: period_end {
    type: time
    timeframes: [raw, date, month, quarter, year]
    # Dynamically shifts the SEC period end dates forward using the same manifest anchor
    sql: TIMESTAMP_ADD(${TABLE}.period_end_date, INTERVAL DATE_DIFF(CURRENT_DATE(), DATE('@{historical_end_date}'), DAY) DAY) ;;
    label: "Financial Period End"
    description: "The dynamically shifted end date for the reported financial quarter/year."
  }

  dimension: document_type {
    type: string
    sql: ${TABLE}.document_type ;;
    label: "SEC Form Type"
    description: "The type of SEC filing (e.g., 10-K, 10-Q)."
  }

  dimension: operating_expenses {
    type: number
    hidden: yes
    sql: ${TABLE}.operating_expenses ;;
  }

  # --- Measures ---
  measure: total_operating_expenses {
    type: sum
    sql: ${operating_expenses} ;;
    value_format_name: usd_0
    label: "Reported Operating Expenses"
    description: "Total operating expenses reported by the corp in their SEC filing."
  }

  measure: average_operating_expenses {
    type: average
    sql: ${operating_expenses} ;;
    value_format_name: usd_0
    label: "Average Operating Expenses"
    description: "Average operating expenses for selected filings."
  }
}
