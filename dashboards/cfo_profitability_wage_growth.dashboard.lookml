- dashboard: cfo_profitability_wage_growth
  title: "CFO Strategy: Corporate Profitability vs. Sector Wage Growth"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Advanced dynamic Period-over-Period analysis correlating corporate operating cost resilience against macro census labor wage inflation, housing cost pressures, and localized fleet metrics."

  # ==========================================
  # 10 INTERACTIVE STRATEGIC FILTERS
  # ==========================================
  filters:
  - name: Global Date Filter
    title: Global Date Filter
    type: date_filter
    default_value: "last 3 months"

  - name: Comparison Target Period
    title: Comparison Target Period
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: corporate_profitability_wage_growth.comparison_period
    default_value: "year"

  - name: Historical Comparison Count
    title: Historical Comparison Count
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: corporate_profitability_wage_growth.comparison_periods
    default_value: "1"

  - name: SEC Corporation Name
    title: SEC Corporation Name
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: corporate_profitability_wage_growth.company_name

  - name: SEC Document Filing
    title: SEC Document Filing
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: corporate_profitability_wage_growth.document_type

  - name: US State Context
    title: US State Context
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: census_bureau_acs.state_name

  - name: Fleet Vendor Identifier
    title: Fleet Vendor Identifier
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: nyc_taxi_trips.vendor_id

  - name: Passenger Density Range
    title: Passenger Density Range
    type: number_filter

  - name: Dynamic Fleet Rate Code
    title: Dynamic Fleet Rate Code
    type: field_filter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    field: nyc_taxi_trips.rate_code

  - name: Time Series Granularity
    title: Time Series Granularity
    type: string_filter
    default_value: "Month"

  # ==========================================
  # 30 HIGH-DENSITY VISUAL TILES (ENRICHED)
  # ==========================================
  elements:

  # --- SCORECARDS / STATS (Tiles 1-4) ---
  - name: tile_1_pop_opex
    title: "Reported Corporate OpEx (Shifted Period)"
    type: single_value
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    measures: [corporate_profitability_wage_growth.total_operating_expenses]
    pivots: [corporate_profitability_wage_growth.period]
    listen:
      "Global Date Filter": corporate_profitability_wage_growth.date_filter
      "Comparison Target Period": corporate_profitability_wage_growth.comparison_period
      "Historical Comparison Count": corporate_profitability_wage_growth.comparison_periods
      "SEC Corporation Name": corporate_profitability_wage_growth.company_name

  - name: tile_2_pop_wage
    title: "National Average Median Income (Static Benchmark)"
    type: single_value
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    measures: [census_bureau_acs.average_median_income]
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_3_pop_taxi
    title: "Shifted Local Fleet Revenue (NYC)"
    type: single_value
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    measures: [nyc_taxi_trips.total_fleet_revenue]
    pivots: [nyc_taxi_trips.period]
    listen:
      "Global Date Filter": nyc_taxi_trips.date_filter
      "Comparison Target Period": nyc_taxi_trips.comparison_period
      "Historical Comparison Count": nyc_taxi_trips.comparison_periods
      "Fleet Vendor Identifier": nyc_taxi_trips.vendor_id

  - name: tile_4_total_rent_benchmark
    title: "National Median Monthly Rent Benchmark"
    type: single_value
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    measures: [census_bureau_acs.average_median_rent]
    listen:
      "US State Context": census_bureau_acs.state_name

  # --- ADVANCED PERIOD OVER PERIOD COMPARISONS (Tiles 5-10) ---
  - name: tile_5_pop_trend_opex
    title: "Period-over-Period Corporate OpEx Curve"
    type: looker_line
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.date_in_period_month_name]
    pivots: [corporate_profitability_wage_growth.period]
    measures: [corporate_profitability_wage_growth.total_operating_expenses]
    listen:
      "Global Date Filter": corporate_profitability_wage_growth.date_filter
      "Comparison Target Period": corporate_profitability_wage_growth.comparison_period
      "Historical Comparison Count": corporate_profitability_wage_growth.comparison_periods
      "SEC Corporation Name": corporate_profitability_wage_growth.company_name

  - name: tile_6_pop_trend_wages_per_capita
    title: "National Income Per Capita (Static Benchmark)"
    type: single_value
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    measures: [census_bureau_acs.average_income_per_capita]
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_7_pop_trend_taxi_rev
    title: "Period-over-Period Shifted Fleet Revenues"
    type: looker_column
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.date_in_period_month_name]
    pivots: [nyc_taxi_trips.period]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    listen:
      "Global Date Filter": nyc_taxi_trips.date_filter
      "Comparison Target Period": nyc_taxi_trips.comparison_period
      "Historical Comparison Count": nyc_taxi_trips.comparison_periods
      "Fleet Vendor Identifier": nyc_taxi_trips.vendor_id

  - name: tile_8_pop_bar_state_wages
    title: "State Wages: Median Household Income"
    type: looker_bar
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_median_income]
    sorts: [census_bureau_acs.average_median_income desc]
    limit: 15
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_9_pop_trend_taxi_distance
    title: "PoP Fleet Symmetrical Transit Miles"
    type: looker_line
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.date_in_period_week]
    pivots: [nyc_taxi_trips.period]
    measures: [nyc_taxi_trips.total_trip_distance]
    listen:
      "Global Date Filter": nyc_taxi_trips.date_filter
      "Comparison Target Period": nyc_taxi_trips.comparison_period
      "Historical Comparison Count": nyc_taxi_trips.comparison_periods

  - name: tile_10_pop_grid_summary
    title: "Executive Cross-Explore Macro Summary Table"
    type: looker_grid
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.date_in_period_date]
    pivots: [corporate_profitability_wage_growth.period]
    measures: [corporate_profitability_wage_growth.total_operating_expenses, nyc_taxi_trips.total_fleet_revenue]
    limit: 25
    listen:
      "Global Date Filter": corporate_profitability_wage_growth.date_filter
      "Comparison Target Period": corporate_profitability_wage_growth.comparison_period
      "Historical Comparison Count": corporate_profitability_wage_growth.comparison_periods

  # --- CORPORATE SEC FINANCIAL PORTFOLIO (Tiles 11-16) ---
  - name: tile_11_opex_by_corp
    title: "Total OpEx Spend by Reporting Enterprise"
    type: looker_bar
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.company_name]
    measures: [corporate_profitability_wage_growth.total_operating_expenses]
    sorts: [corporate_profitability_wage_growth.total_operating_expenses desc]
    limit: 15
    listen:
      "SEC Corporation Name": corporate_profitability_wage_growth.company_name

  - name: tile_12_sec_distribution
    title: "Corporate OpEx Spend Concentration (Form Type)"
    type: looker_pie
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.document_type]
    measures: [corporate_profitability_wage_growth.total_operating_expenses]
    listen:
      "SEC Document Filing": corporate_profitability_wage_growth.document_type

  - name: tile_13_opex_trend
    title: "Historical Corporate Expense Growth Pattern"
    type: looker_area
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.period_end_quarter]
    measures: [corporate_profitability_wage_growth.total_operating_expenses]

  - name: tile_14_avg_opex_scatter
    title: "Corporate Cost Dispersion Matrix"
    type: looker_scatter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.company_name]
    measures: [corporate_profitability_wage_growth.average_operating_expenses, corporate_profitability_wage_growth.total_operating_expenses]
    limit: 20

  - name: tile_15_sec_annual_stack
    title: "Annual Aggregate Spend by Corporate Sector"
    type: looker_column
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.company_name]
    pivots: [corporate_profitability_wage_growth.period_end_year]
    measures: [corporate_profitability_wage_growth.total_operating_expenses]
    stacking: normal
    limit: 10

  - name: tile_16_sec_raw_table
    title: "SEC Financial Records Audit Log"
    type: table
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.company_name, corporate_profitability_wage_growth.document_type, corporate_profitability_wage_growth.period_end_date]
    measures: [corporate_profitability_wage_growth.total_operating_expenses]
    limit: 50

  # --- CENSUS BUREAU ACS DEMOGRAPHICS (Tiles 17-22) (ENRICHED) ---
  - name: tile_17_rent_vs_income_scatter
    title: "Housing Cost Pressure: Rent vs. Household Income"
    type: looker_scatter
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_median_rent, census_bureau_acs.average_median_income]
    limit: 30
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_18_income_heatmap
    title: "Top State Income Per Capita Rankings"
    type: table
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_income_per_capita, census_bureau_acs.average_median_income]
    sorts: [census_bureau_acs.average_income_per_capita desc]
    limit: 15
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_19_population_by_state
    title: "State Populations Census Distribution"
    type: looker_pie
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.total_population_sum]
    limit: 10
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_20_gini_index_ranking
    title: "Income Inequality: Gini Index ranking by State"
    type: looker_bar
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_gini_index]
    sorts: [census_bureau_acs.average_gini_index desc]
    limit: 20
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_21_home_values_pivoted
    title: "Property Wealth Index (Home Value vs Rent)"
    type: looker_column
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_median_home_value, census_bureau_acs.average_median_rent]
    limit: 10
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_22_raw_demographics_grid
    title: "Demographics Cost of Living Inventory Grid"
    type: looker_grid
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [
      census_bureau_acs.average_median_income,
      census_bureau_acs.average_income_per_capita,
      census_bureau_acs.average_median_rent,
      census_bureau_acs.average_median_home_value,
      census_bureau_acs.average_gini_index,
      census_bureau_acs.average_median_age,
      census_bureau_acs.total_household_sum
    ]
    limit: 50
    listen:
      "US State Context": census_bureau_acs.state_name

  # --- NEW YORK LOCALIZED FLEET ECONOMICS (Tiles 23-26) ---
  - name: tile_23_taxi_rev_payment
    title: "NYC Fleet Payment Option Mix"
    type: looker_pie
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.payment_type]
    measures: [nyc_taxi_trips.total_fleet_revenue]

  - name: tile_24_taxi_miles_over_time
    title: "NYC Fleet Symmetrical Monthly Miles Trend"
    type: looker_area
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.pickup_month]
    measures: [nyc_taxi_trips.total_trip_distance]

  - name: tile_25_taxi_pivoted_fare_vendor
    title: "NYC Fleet Revenue Composition by Vendor"
    type: looker_column
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.vendor_id]
    pivots: [nyc_taxi_trips.rate_code]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    limit: 10

  - name: tile_26_taxi_dispatches
    title: "Recent NYC Dispatch Logistics Table"
    type: table
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.pickup_date, nyc_taxi_trips.vendor_id, nyc_taxi_trips.payment_type]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    limit: 25

  # --- COMPLEX ADVANCED ANALYTICAL CALCULATIONS (Tiles 27-30) ---
  - name: tile_27_rent_to_income_ratio
    title: "State Rent-to-Income Cost Squeeze Percentage (Table Calc)"
    type: looker_column
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_median_rent, census_bureau_acs.average_median_income]
    dynamic_fields:
    - table_calculation: rent_to_income_ratio
      label: "Rent to Income Ratio"
      expression: "(${census_bureau_acs.average_median_rent} * 12) / ${census_bureau_acs.average_median_income}"
      value_format_name: percent_2
    sorts: [rent_to_income_ratio desc]
    limit: 15
    listen:
      "US State Context": census_bureau_acs.state_name

  - name: tile_28_opex_efficiency
    title: "Corporate OpEx Growth to Demographics Wage Ratio"
    type: table
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [corporate_profitability_wage_growth.period_end_year]
    measures: [corporate_profitability_wage_growth.total_operating_expenses, census_bureau_acs.average_median_income]
    dynamic_fields:
    - table_calculation: opex_to_wage_index
      label: "OpEx to Wage Index"
      expression: "${corporate_profitability_wage_growth.total_operating_expenses} / ${census_bureau_acs.average_median_income}"
      value_format_name: decimal_2

  - name: tile_29_fleet_revenue_per_mile
    title: "NYC Local Unit Economics: Revenue per Fleet Mile"
    type: table
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [nyc_taxi_trips.pickup_year]
    measures: [nyc_taxi_trips.total_fleet_revenue, nyc_taxi_trips.total_trip_distance]
    dynamic_fields:
    - table_calculation: revenue_per_mile
      label: "Revenue per Mile"
      expression: "${nyc_taxi_trips.total_fleet_revenue} / ${nyc_taxi_trips.total_trip_distance}"
      value_format_name: usd

  - name: tile_30_variance_from_mean
    title: "State Income Deviance from National Mean (Table Calc)"
    type: looker_bar
    model: corporate_profitability_wage_growth
    explore: corporate_profitability_wage_growth
    dimensions: [census_bureau_acs.state_name]
    measures: [census_bureau_acs.average_median_income]
    dynamic_fields:
    - table_calculation: state_variance_from_mean
      label: "State Variance from Mean"
      expression: "${census_bureau_acs.average_median_income} - mean(${census_bureau_acs.average_median_income})"
      value_format_name: usd_0
    limit: 15
    listen:
      "US State Context": census_bureau_acs.state_name
