- dashboard: executive_margin_erosion
  title: "Executive Strategy: Margin Erosion & Supply Costs"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Evaluates macro corporate margin erosion against raw fleet unit economics."

  # ==========================================
  # 10 COMPLEX FILTERS
  # ==========================================
  filters:

  - name: Order Date Range
    title: Order Date Range
    type: date_filter
    default_value: "14 years"

  - name: Financial Period
    title: Financial Period
    type: date_filter
    default_value: "14 years"


  - name: Vendor ID (Fleet)
    title: Vendor ID (Fleet)
    type: field_filter
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    field: nyc_taxi_trips.vendor_id

  - name: SEC Company Name
    title: SEC Company Name
    type: field_filter
    model: executive_margin_erosion
    explore: sec_financials
    field: sec_financials.company_name

  - name: Payment Type
    title: Payment Type
    type: field_filter
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    field: nyc_taxi_trips.payment_type

  - name: Rate Code
    title: Rate Code
    type: field_filter
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    field: nyc_taxi_trips.rate_code

  - name: SEC Document Type
    title: SEC Document Type
    type: field_filter
    model: executive_margin_erosion
    explore: sec_financials
    field: sec_financials.document_type

  - name: Passenger Count
    title: Passenger Count
    type: number_filter
    # Removed invalid model/field parameters here

  - name: Min Fare Amount
    title: Min Fare Amount
    type: number_filter
    default_value: ">0"

  - name: Time Granularity
    title: Time Granularity
    type: string_filter
    default_value: "Quarter"

  # ==========================================
  # 30 DASHBOARD TILES
  # ==========================================
  elements:

  # --- SCORECARDS (Tiles 1-4) ---
  - name: tile_1_revenue
    title: "Total Fleet Revenue"
    type: single_value
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    measures: [nyc_taxi_trips.total_fleet_revenue]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date
      "Vendor ID (Fleet)": nyc_taxi_trips.vendor_id

  - name: tile_2_distance
    title: "Total Fleet Miles"
    type: single_value
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    measures: [nyc_taxi_trips.total_trip_distance]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_3_avg_fare
    title: "Average Base Fare"
    type: single_value
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    measures: [nyc_taxi_trips.average_fare]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date
      "Min Fare Amount": nyc_taxi_trips.fare_amount

  - name: tile_4_opex
    title: "Total Corporate OpEx (SEC)"
    type: single_value
    model: executive_margin_erosion
    explore: sec_financials
    measures: [sec_financials.total_operating_expenses]
    listen:
      "Financial Period": sec_financials.period_end_date
      "SEC Company Name": sec_financials.company_name

  # --- MERGED QUERIES (Tiles 5-6) ---
  - name: tile_5_merged_erosion
    title: "Margin Erosion Index (Fleet Revenue vs Corporate OpEx)"
    type: table
    merged_queries:
    - model: executive_margin_erosion
      explore: nyc_taxi_trips
      fields: [nyc_taxi_trips.vendor_id, nyc_taxi_trips.total_fleet_revenue]
    - model: executive_margin_erosion
      explore: sec_financials
      fields: [sec_financials.company_name, sec_financials.total_operating_expenses]
      join_fields:
      - field_name: sec_financials.company_name
        source_field_name: nyc_taxi_trips.vendor_id

  - name: tile_6_merged_efficiency
    title: "Corporate OpEx vs Fleet Miles Driven"
    type: looker_scatter
    merged_queries:
    - model: executive_margin_erosion
      explore: nyc_taxi_trips
      fields: [nyc_taxi_trips.vendor_id, nyc_taxi_trips.total_trip_distance]
    - model: executive_margin_erosion
      explore: sec_financials
      fields: [sec_financials.company_name, sec_financials.average_operating_expenses]
      join_fields:
      - field_name: sec_financials.company_name
        source_field_name: nyc_taxi_trips.vendor_id

  # --- SEC FINANCIALS (Tiles 7-12) ---
  - name: tile_7_opex_trend
    title: "Corporate Operating Expenses by Quarter"
    type: looker_area
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.period_end_quarter]
    measures: [sec_financials.total_operating_expenses]
    listen:
      "Financial Period": sec_financials.period_end_date

  - name: tile_8_top_spenders
    title: "Top Corporations by OpEx"
    type: looker_bar
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.company_name]
    measures: [sec_financials.total_operating_expenses]
    sorts: [sec_financials.total_operating_expenses desc]
    limit: 10
    listen:
      "Financial Period": sec_financials.period_end_date

  - name: tile_9_avg_opex_trend
    title: "Average OpEx Fluctuation"
    type: looker_line
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.period_end_month]
    measures: [sec_financials.average_operating_expenses]
    listen:
      "Financial Period": sec_financials.period_end_date

  - name: tile_10_doc_type_pie
    title: "Expenses by SEC Form Type"
    type: looker_pie
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.document_type]
    measures: [sec_financials.total_operating_expenses]
    listen:
      "SEC Document Type": sec_financials.document_type

  - name: tile_11_opex_pivot_year
    title: "OpEx Pivoted by Year"
    type: looker_column
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.company_name]
    pivots: [sec_financials.period_end_year]
    measures: [sec_financials.total_operating_expenses]
    limit: 10
    stacking: normal
    listen:
      "Financial Period": sec_financials.period_end_date

  - name: tile_12_sec_scatter
    title: "Company OpEx Distribution"
    type: looker_scatter
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.company_name]
    measures: [sec_financials.average_operating_expenses, sec_financials.total_operating_expenses]
    limit: 15
    listen:
      "Financial Period": sec_financials.period_end_date

  # --- TAXI FLEET OPERATIONS (Tiles 13-18) ---
  - name: tile_13_revenue_by_payment
    title: "Fleet Revenue by Payment Method (Pivot)"
    type: looker_column
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    pivots: [nyc_taxi_trips.payment_type]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    stacking: normal
    limit: 10
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date
      "Payment Type": nyc_taxi_trips.payment_type

  - name: tile_14_passenger_volume
    title: "Passenger Volume by Payment Method"
    type: looker_pie
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.payment_type]
    measures: [nyc_taxi_trips.total_passengers]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_15_revenue_trend
    title: "Fleet Revenue Trend Over Time"
    type: looker_line
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.pickup_month]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_16_distance_trend
    title: "Miles Driven Over Time"
    type: looker_area
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.pickup_month]
    measures: [nyc_taxi_trips.total_trip_distance]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_17_vendor_market_share
    title: "Vendor Market Share (Miles)"
    type: looker_pie
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.total_trip_distance]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_18_rate_code_revenue
    title: "Revenue by Rate Code"
    type: looker_bar
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.rate_code]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    sorts: [nyc_taxi_trips.total_fleet_revenue desc]
    limit: 10
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  # --- COST & EFFICIENCY METRICS (Tiles 19-24) ---
  - name: tile_19_avg_fare_by_vendor
    title: "Average Fare by Vendor"
    type: looker_bar
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.average_fare]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_20_fare_vs_distance
    title: "Average Fare vs Total Distance"
    type: looker_scatter
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.average_fare, nyc_taxi_trips.total_trip_distance]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_21_payment_pivot_distance
    title: "Distance Pivoted by Payment Type"
    type: table
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    pivots: [nyc_taxi_trips.payment_type]
    measures: [nyc_taxi_trips.total_trip_distance]
    limit: 10
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_22_passenger_distribution
    title: "Trips by Passenger Count"
    type: looker_pie
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.passenger_count]
    measures: [nyc_taxi_trips.total_passengers]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_23_top_trips
    title: "Top 10 Longest Trips"
    type: looker_grid
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.pickup_date, nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.total_trip_distance, nyc_taxi_trips.total_fleet_revenue]
    sorts: [nyc_taxi_trips.total_trip_distance desc]
    limit: 10
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_24_revenue_composition
    title: "Fleet Revenue Composition"
    type: looker_column
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.total_fleet_revenue, nyc_taxi_trips.total_trip_distance]
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  # --- CUSTOM FIELDS & TABLE CALCS (Tiles 25-28) ---
  - name: tile_25_unit_economics
    title: "Unit Economics (Revenue per Mile)"
    type: table
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.total_fleet_revenue, nyc_taxi_trips.total_trip_distance]
    dynamic_fields:
    - table_calculation: revenue_per_mile
      label: "Revenue per Mile"
      expression: "${nyc_taxi_trips.total_fleet_revenue} / ${nyc_taxi_trips.total_trip_distance}"
      value_format_name: usd
    sorts: [revenue_per_mile desc]
    limit: 10
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_26_yoy_growth
    title: "YoY Revenue Growth (Table Calc)"
    type: looker_column
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.pickup_year]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    dynamic_fields:
    - table_calculation: yoy_growth
      label: "YoY Growth"
      expression: "(${nyc_taxi_trips.total_fleet_revenue} / offset(${nyc_taxi_trips.total_fleet_revenue}, 1)) - 1"
      value_format_name: percent_2
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_27_opex_variance
    title: "OpEx Variance from Mean (SEC)"
    type: looker_bar
    model: executive_margin_erosion
    explore: sec_financials
    dimensions: [sec_financials.company_name]
    measures: [sec_financials.average_operating_expenses]
    dynamic_fields:
    - table_calculation: variance_from_mean
      label: "Variance from Average"
      expression: "${sec_financials.average_operating_expenses} - mean(${sec_financials.average_operating_expenses})"
      value_format_name: usd
    limit: 15
    listen:
      "Financial Period": sec_financials.period_end_date

  - name: tile_28_distance_share
    title: "% of Total Distance by Payment"
    type: table
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.payment_type]
    measures: [nyc_taxi_trips.total_trip_distance]
    dynamic_fields:
    - table_calculation: percent_of_total
      label: "% of Total Distance"
      expression: "${nyc_taxi_trips.total_trip_distance} / sum(${nyc_taxi_trips.total_trip_distance})"
      value_format_name: percent_2
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  # --- ADDITIONAL GRANULAR DEEP DIVES (Tiles 29-30) ---
  - name: tile_29_recent_trips
    title: "50 Most Recent Dispatches (Raw Data)"
    type: looker_grid
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.pickup_date, nyc_taxi_trips.vendor_id, nyc_taxi_trips.payment_type, nyc_taxi_trips.rate_code]
    measures: [nyc_taxi_trips.total_fleet_revenue]
    sorts: [nyc_taxi_trips.pickup_date desc]
    limit: 50
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date

  - name: tile_30_executive_summary
    title: "Executive Operations Summary"
    type: table
    model: executive_margin_erosion
    explore: nyc_taxi_trips
    dimensions: [nyc_taxi_trips.vendor_id]
    measures: [nyc_taxi_trips.total_fleet_revenue, nyc_taxi_trips.total_trip_distance, nyc_taxi_trips.average_fare]
    sorts: [nyc_taxi_trips.total_fleet_revenue desc]
    limit: 5
    listen:
      "Order Date Range": nyc_taxi_trips.pickup_date
      "Vendor ID (Fleet)": nyc_taxi_trips.vendor_id
