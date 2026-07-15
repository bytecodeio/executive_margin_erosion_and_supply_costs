connection: "bigquery_public_data"

# Include views and the dedicated dashboard
include: "/views/*.view.lkml"
include: "/dashboards/cfo_profitability_wage_growth.dashboard.lookml"

explore: corporate_profitability_wage_growth {
  label: "3. Corporate Profitability vs. Sector Wage Growth"
  description: "Bridges SEC corporate financials, NYC Taxi fleet revenue, and Census ACS state demographics as static benchmarks."

  # Base explore is SEC financials (extending Period Comparison template)
  from: sec_financials

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
    sql_on: ${corporate_profitability_wage_growth.period_end_year} = ${nyc_taxi_trips.pickup_year} ;;
  }
}
