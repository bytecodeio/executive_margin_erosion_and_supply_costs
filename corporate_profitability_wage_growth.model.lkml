connection: "bigquery_public_data"

# Include views and the dedicated dashboard
include: "/views/*.view.lkml"
include: "/dashboards/cfo_profitability_wage_growth.dashboard.lookml"

explore: corporate_profitability_wage_growth {
  label: "3. Corporate Profitability vs. Sector Wage Growth"
  description: "Bridges SEC corporate financials, NYC Taxi fleet revenue, and Census ACS state demographics as static benchmarks."

  # Base explore is SEC financials (extending Period Comparison template)
  from: sec_financials

  sql_always_where: ${corporate_profitability_wage_growth.period_end_original_raw} < (TIMESTAMP('2021-01-01 00:00:00', 'America/Los_Angeles'))
    AND ${corporate_profitability_wage_growth.measure_tag} IN ('OperatingExpenses', 'CostOfRevenue', 'CostsAndExpenses')
         AND (${corporate_profitability_wage_growth.number_of_quarters} = 0 OR ${corporate_profitability_wage_growth.number_of_quarters} IS NULL) ;;

  # Join ACS as a static state context table
  join: census_bureau_acs {
    type: left_outer
    relationship: many_to_many
    sql_on: 1=1 ;;
  }

  # Join NYC Taxi Trips on shifted year
  join: nyc_taxi_trips {
    type: left_outer
    relationship: many_to_many
    sql_on: ${corporate_profitability_wage_growth.period_end_month} = ${nyc_taxi_trips.pickup_month} ;;
    sql_where:
        ${nyc_taxi_trips.pickup_original_raw} <= ((TIMESTAMP('2022-11-30 00:00:00', 'America/Los_Angeles')))
        AND ${nyc_taxi_trips.fare_amount} > 0
        AND ${nyc_taxi_trips.fare_amount} <= 500
        AND ${nyc_taxi_trips.trip_distance} > 0
        AND ${nyc_taxi_trips.trip_distance} <= 100
        AND ${nyc_taxi_trips.passenger_count} > 0
        AND TIMESTAMP_DIFF(${nyc_taxi_trips.dropoff_raw}, ${nyc_taxi_trips.pickup_raw}, MINUTE) > 0
        AND TIMESTAMP_DIFF(${nyc_taxi_trips.dropoff_raw}, ${nyc_taxi_trips.pickup_raw}, HOUR) < 24
     ;;

  }
}
