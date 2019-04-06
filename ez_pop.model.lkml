connection: "thelook_events_redshift"

include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

view: users_pop {
  sql_table_name: public.users ;;
  dimension: id {primary_key:yes}
  measure: count {type: count}
  dimension: age {type:number} #other dimensions can be used as usual
  dimension_group: created_at {
    type: time
    timeframes: [raw,day_of_week_index,day_of_month,day_of_year,week_of_year,month_num,year,date]
  }
  dimension_group: now {
    hidden: yes
    type: time
    timeframes: [raw,day_of_week_index,day_of_month,day_of_year,week_of_year,month_num,year,date]
    sql: getdate() ;;
  }

  dimension: years_ago {
    group_label: "Created At Date"
    type: number
    sql: ${now_year}-${created_at_year} ;;
  }
  dimension: months_ago {
    group_label: "Created At Date"
    type: number
    sql: ${now_year}*12+${now_month_num}-(${created_at_year}*12+${created_at_month_num}) ;;
  }
  dimension: weeks_ago {
    group_label: "Created At Date"
    type: number
    sql: ${now_year}*52+${now_week_of_year}-(${created_at_year}*52+${created_at_week_of_year}) ;;
  }

  parameter: previous_period_comparison_granularity {
    view_label: "Period Over Period"
    description: "Select the comparison period. E.g. choosing Month will compare the selected range against the same dates 30 days ago. "
    type: unquoted
    allowed_value: {
      label: "Week"
      value: "Week"
    }
    allowed_value: {
      label: "Month"
      value: "Month"
    }
    allowed_value: {
      label: "Year"
      value: "Year"
    }
    default_value: "Year"
  }

  dimension: periods_ago__number {
    view_label: "Period Over Period"
    type: number
    sql:
    {% if previous_period_comparison_granularity._parameter_value == 'Year' %}${years_ago}
    {% elsif previous_period_comparison_granularity._parameter_value == 'Month' %}${months_ago}
    {% elsif previous_period_comparison_granularity._parameter_value == 'Week' %}${weeks_ago}
    {% endif %}
    ;;
  }

  dimension: subsection_of_the_period__unpivot{
    view_label: "Period Over Period"
    label: "{% if _field._in_query %}{% if previous_period_comparison_granularity._parameter_value == 'Year' %}Month Number{% endif %}{% if previous_period_comparison_granularity._parameter_value == 'Month' %}Day of Month{% endif %}{% if previous_period_comparison_granularity._parameter_value == 'Week' %}Day of Week Index{% endif %}{% else %}POP Unpivot{% endif %}"
    type: number
    sql:
    {% if previous_period_comparison_granularity._parameter_value == 'Year' %}${created_at_month_num}
    {% elsif previous_period_comparison_granularity._parameter_value == 'Month' %}${created_at_day_of_month}
    {% elsif previous_period_comparison_granularity._parameter_value == 'Week' %}${created_at_day_of_week_index}
    {% endif %}
    ;;
  }

  dimension: periods_ago__pivot {
    view_label: "Period Over Period"
    label: "{% if _field._in_query %}{% parameter previous_period_comparison_granularity %}{% else %}POP Pivot{% endif%}"
    type: string
    sql: ${periods_ago__number}||' {% parameter previous_period_comparison_granularity %}s Ago' ;;
    order_by_field: periods_ago__number
  }

}

explore: users_pop {}
