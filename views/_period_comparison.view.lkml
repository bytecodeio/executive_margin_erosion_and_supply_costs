view: _period_comparison {
  extension: required

  # =========================================================================
  # PARAMETERS & FILTERS
  # =========================================================================
  filter: date_filter {
    group_label: "Period Comparison"
    label: "Current Period Date Filter"
    description: "Use this date filter in combination with the period dimension to compare this period to previous periods. Filter. Date range."
    type: date
    datatype: datetime
    convert_tz: no
    sql: ${is_within_current_and_comparison_period} ;;
  }

  parameter: comparison_period {
    group_label: "Period Comparison"
    label: "Comparison Period"
    description: "Select the specific historical window to compare against the current period. Choice selection."
    type: unquoted
    default_value: "year"
    allowed_value: {
      label: "Previous Period"
      value: "previous"
    }
    allowed_value: {
      label: "Previous Week"
      value: "week"
    }
    allowed_value: {
      label: "Previous Month"
      value: "month"
    }
    allowed_value: {
      label: "Previous Quarter"
      value: "quarter"
    }
    allowed_value: {
      label: "Previous Year"
      value: "year"
    }
  }

  parameter: comparison_periods {
    group_label: "Period Comparison"
    label: "Number of Comparison Periods"
    description: "Choose the number of historical periods you would like to analyze. Integer count."
    type: unquoted
    allowed_value: {
      label: "1"
      value: "1"
    }
    allowed_value: {
      label: "2"
      value: "2"
    }
    allowed_value: {
      label: "3"
      value: "3"
    }
    allowed_value: {
      label: "4"
      value: "4"
    }
    default_value: "1"
  }

  # =========================================================================
  # DIMENSIONS
  # =========================================================================
  dimension: comparison_period_end_date {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: date
    datatype: datetime
    convert_tz: no
    sql: {% if comparison_period._parameter_value == "previous" %}
          ${filter_start_raw}
        {% else  %}
          date_add(${filter_end_raw}, INTERVAL -1 {% parameter comparison_period %} )
        {% endif %} ;;
  }

  dimension: comparison_period_start_date {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: date
    datatype: datetime
    convert_tz: no
    sql: {% if comparison_period._parameter_value == "previous" %}
          date_add(${filter_start_raw}, INTERVAL -${interval} day)
        {% else %}
          DATE_ADD( ${filter_start_raw}, INTERVAL - {% parameter comparison_periods %} {% parameter comparison_period %} )
        {% endif %} ;;
  }

  dimension_group: date_in_period {
    group_label: "Period Comparison Dates"
    label: "Current Period"
    description: "Use this as your grouping dimension when comparing periods. Aligns the comparison periods onto the current period axis."
    type: time
    datatype: datetime
    convert_tz: no
    sql: date_add(${filter_start_raw}, INTERVAL ${day_in_period}-1 day ) ;;
    timeframes: [
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
      year
    ]
  }

  dimension: day_in_period {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: number
    sql:
      {% if date_filter._is_filtered %}
          CASE
            WHEN ${is_current_period} = true
              THEN date_diff(safe_CAST(${event_date} as DATE), ${filter_start_date},  day) + 1
          WHEN ${is_comparison_period} = true
            THEN date_diff(safe_CAST(${event_date} as DATE),${comparison_period_start_date}, day) + 1
          END
      {% else %} NULL
      {% endif %}
    ;;
  }

  dimension_group: filter_end {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: time
    datatype: datetime
    timeframes: [raw, time, date]
    convert_tz: no
    sql: CASE WHEN {% date_end date_filter %} IS NULL THEN CURRENT_DATE ELSE CAST({% date_end date_filter %} as DATE) END;;
  }

  dimension_group: filter_start {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: time
    datatype: datetime
    timeframes: [raw, time, date]
    convert_tz: no
    sql: CASE WHEN {% date_start date_filter %} IS NULL THEN '1970-01-01' ELSE CAST({% date_start date_filter %} as DATE) END;;
  }

  dimension: interval {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: number
    sql: (DATE_DIFF( ${filter_end_raw}, ${filter_start_raw}, DAY )) * {% parameter comparison_periods %} ;;
  }

  dimension: is_comparison_period {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: yesno
    sql: safe_CAST(${event_raw} as DATE) >= ${comparison_period_start_date} AND safe_CAST(${event_raw} as DATE) < ${comparison_period_end_date} ;;
  }

  dimension: is_current_period {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: yesno
    sql: safe_CAST(${event_raw} as DATE) >= ${filter_start_raw} AND safe_CAST(${event_raw} as DATE) < ${filter_end_raw} ;;
  }

  dimension: is_within_current_and_comparison_period {
    group_label: "Previous Period Comparison"
    hidden: yes
    type: yesno
    sql: ${is_current_period} = true OR ${is_comparison_period} = true ;;
  }

  dimension: number_of_comparison_periods {
    group_label: "Period Comparison"
    type: number
    sql: {% parameter comparison_periods %} ;;
  }

  dimension: period {
    group_label: "Period Comparison"
    label: "Period Name"
    description: "Identifies whether the transaction belongs to the Current Period or Comparison Period."
    type: string
    suggestions: ["Current Period", "Comparison Period"]
    sql:
        {% if date_filter._is_filtered %}
            CASE
              WHEN ${is_current_period} = true THEN 'Current Period'
              WHEN ${is_comparison_period} = true THEN 'Comparison Period'
            END
        {% else %}
            NULL
        {% endif %}
        ;;
  }
}
