connection: "thelook_events_redshift"
#
# view: functions {
#   measure: range {
#     hidden: yes
#     sql: CASE WHEN COUNT({{field_argument}}) = 0 THEN 'N/A' ELSE MIN({{field_argument}}) || ' - '  || MAX({{field_argument}}) end ;;
#   }
#   measure: safe_divide {
#     hidden: yes
#     type: number
#     sql: {{numerator}}*1.0/nullif({{denominator}},0) ;;
#   }
# }
#
#
# view: users_data {
#   extends: [functions]
#   sql_table_name: public.users ;;
#
#   dimension: age {
#     type: number
#     sql: ${TABLE}.age ;;
#   }
#
#   measure: age_range2 {
#     sql: {% assign field_argument = age._sql %} ${range} ;;
#   }
#
#   measure: count {}
#   measure: total_years_lived{
#     type: sum
#     sql: ${age} ;;
#   }
#   measure: average_age_calculated {
#     type: number
#     sql:{% assign numerator = count._sql %}{% assign denominator = total_years_lived._sql %}${safe_divide} ;;
#   }
# }
#
# explore: users_data {}
