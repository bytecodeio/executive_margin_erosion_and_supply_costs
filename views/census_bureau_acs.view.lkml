view: census_bureau_acs {
  sql_table_name: `bigquery-public-data.census_bureau_acs.state_2020_5yr` ;;

  # --- Primary Key ---
  dimension: state_name {
    primary_key: yes
    type: string
    #sql: ${TABLE}.state_name ;;
    sql:
      CASE ${TABLE}.geo_id
          WHEN '01' THEN 'Alabama'
          WHEN '02' THEN 'Alaska'
          WHEN '04' THEN 'Arizona'
          WHEN '05' THEN 'Arkansas'
          WHEN '06' THEN 'California'
          WHEN '08' THEN 'Colorado'
          WHEN '09' THEN 'Connecticut'
          WHEN '10' THEN 'Delaware'
          WHEN '11' THEN 'District of Columbia'
          WHEN '12' THEN 'Florida'
          WHEN '13' THEN 'Georgia'
          WHEN '15' THEN 'Hawaii'
          WHEN '16' THEN 'Idaho'
          WHEN '17' THEN 'Illinois'
          WHEN '18' THEN 'Indiana'
          WHEN '19' THEN 'Iowa'
          WHEN '20' THEN 'Kansas'
          WHEN '21' THEN 'Kentucky'
          WHEN '22' THEN 'Louisiana'
          WHEN '23' THEN 'Maine'
          WHEN '24' THEN 'Maryland'
          WHEN '25' THEN 'Massachusetts'
          WHEN '26' THEN 'Michigan'
          WHEN '27' THEN 'Minnesota'
          WHEN '28' THEN 'Mississippi'
          WHEN '29' THEN 'Missouri'
          WHEN '30' THEN 'Montana'
          WHEN '31' THEN 'Nebraska'
          WHEN '32' THEN 'Nevada'
          WHEN '33' THEN 'New Hampshire'
          WHEN '34' THEN 'New Jersey'
          WHEN '35' THEN 'New Mexico'
          WHEN '36' THEN 'New York'
          WHEN '37' THEN 'North Carolina'
          WHEN '38' THEN 'North Dakota'
          WHEN '39' THEN 'Ohio'
          WHEN '40' THEN 'Oklahoma'
          WHEN '41' THEN 'Oregon'
          WHEN '42' THEN 'Pennsylvania'
          WHEN '44' THEN 'Rhode Island'
          WHEN '45' THEN 'South Carolina'
          WHEN '46' THEN 'South Dakota'
          WHEN '47' THEN 'Tennessee'
          WHEN '48' THEN 'Texas'
          WHEN '49' THEN 'Utah'
          WHEN '50' THEN 'Vermont'
          WHEN '51' THEN 'Virginia'
          WHEN '53' THEN 'Washington'
          WHEN '54' THEN 'West Virginia'
          WHEN '55' THEN 'Wisconsin'
          WHEN '56' THEN 'Wyoming'
          WHEN '72' THEN 'Puerto Rico'
          ELSE CONCAT('FIPS Code: ', geo_id)
        END
      ;;
    label: "US State Name"
    description: "The official name of the US State."
    synonyms: ["State", "Region", "Geography"]
  }

  # --- Core Dimensions ---
  dimension: total_population {
    type: number
    sql: ${TABLE}.total_pop ;;
    label: "Total State Population"
    description: "The total population count of the state."
    synonyms: ["Population", "Headcount", "Residents"]
  }

  dimension: median_age {
    type: number
    sql: ${TABLE}.median_age ;;
    label: "Labor Force Median Age"
    description: "The median age of the state's residents, indicating labor force maturity."
    synonyms: ["Demographic Age", "Median Age"]
  }

  dimension: gini_index {
    type: number
    sql: ${TABLE}.gini_index ;;
    label: "Gini Index (Inequality)"
    description: "Income inequality index (0 = perfect equality, 1 = perfect inequality)."
    synonyms: ["Income Distribution", "Inequality Index"]
  }

  dimension: households {
    type: number
    sql: ${TABLE}.households ;;
    label: "Total Households"
    description: "The total number of households in the state."
    synonyms: ["Household Count", "Homes"]
  }

  # --- Cost of Living Dimensions (Hidden; exposed via Measures) ---
  dimension: income_per_capita {
    type: number
    hidden: yes
    sql: ${TABLE}.income_per_capita ;;
  }

  dimension: median_rent {
    type: number
    hidden: yes
    sql: ${TABLE}.median_rent ;;
  }

  dimension: median_home_value {
    type: number
    hidden: yes
    sql: ${TABLE}.owner_occupied_housing_units_median_value ;;
  }

  dimension: median_income {
    type: number
    hidden: yes
    sql: ${TABLE}.median_income ;;
  }

  # --- Measures ---
  measure: average_median_income {
    type: average
    sql: ${median_income} ;;
    value_format_name: usd_0
    label: "Average Median Income"
    description: "The average of state-level median household incomes."
    synonyms: ["Average Household Wages", "Median Household Salary"]
  }

  measure: average_income_per_capita {
    type: average
    sql: ${income_per_capita} ;;
    value_format_name: usd_0
    label: "Average Income Per Capita"
    description: "The average income earned per individual in the state."
    synonyms: ["Per Capita Salary", "Individual Average Wage"]
  }

  measure: average_median_rent {
    type: average
    sql: ${median_rent} ;;
    value_format_name: usd_0
    label: "Average Median Monthly Rent"
    description: "The average monthly gross rent, representing a key cost of living driver."
    synonyms: ["Average Rent", "Housing Cost Pressure"]
  }

  measure: average_median_home_value {
    type: average
    sql: ${median_home_value} ;;
    value_format_name: usd_0
    label: "Average Median Home Value"
    description: "The average median value of owner-occupied housing units."
    synonyms: ["Average Property Value", "Real Estate Benchmark"]
  }

  measure: total_population_sum {
    type: sum
    sql: ${total_population} ;;
    value_format_name: decimal_0
    label: "Total US Population"
    description: "Cumulative population across selected states."
  }

  measure: total_household_sum {
    type: sum
    sql: ${households} ;;
    value_format_name: decimal_0
    label: "Total US Households"
    description: "Cumulative count of households across selected states."
  }

  measure: average_gini_index {
    type: average
    sql: ${gini_index} ;;
    value_format_name: decimal_3
    label: "Average Gini Index"
    description: "Average Gini Index across selected states."
  }

  measure: average_median_age {
    type: average
    sql: ${median_age} ;;
    value_format_name: decimal_1
    label: "Average Median Age"
    description: "Average median age of residents across selected states."
  }
}
