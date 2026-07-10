connection: "bigquery_public_data"

# Include all views and dashboards
include: "/views/*.view.lkml"
include: "/dashboards/*.dashboard.lookml"

explore: nyc_taxi_trips {
  label: "1. Fleet Operational Costs (NYC Taxi)"
  description: "Explore raw supply costs, fleet distances, and base fares."
}

explore: sec_financials {
  label: "2. Corporate Margin Health (SEC)"
  description: "Explore corporate operating expenses and cost of revenue from public SEC filings."
}
