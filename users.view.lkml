# include: "test_suggestions.*"
#design based on https://fabio-looker.github.io/look-at-me-sideways/rules.html
include: "variables_and_templates.view.lkml"


view: users {
extends: [variables_and_templates]
  sql_table_name: public.users ;;

#### Keys (may duplicate fields in order to clearly document primary keys, distribution keys, and sort keys
  dimension: id {
#     primary_key: yes
#     hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }
#
  dimension: 1pk_user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: 1dk_user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }



##########


  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
#     sql: ${age_base} ;;
    suggest_explore: basic.suggestions
    suggest_dimension: age
  }

#   measure: age_range {
#     sql: {% assign field_argument = age._sql %} ${TEMPLATE_summary} ;;
# #     html: {{ TEMPLATE_summary._rendered_value }} ;;
#   }



  dimension: city {
    type: string
    sql: ${TABLE}.city || ${age} ;;
  }
#   measure: city_range {
#     sql:{% assign field_to_summarize_sql = city._sql %}{{ TEMPLATE_summary._sql | replace: 'TEMPLATE_SQL_PLACEHOLDER', field_to_summarize_sql }};;
#   }


  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
    suggest_explore: users_suggestions
    suggest_dimension: first_name
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
    suggest_explore: users_suggestions
    suggest_dimension: last_name
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    #adding this filter will ensure that we don't incorrectly use count(*). For example, if this is the right side of a left outer...
    filters:{
      field: 1pk_user_id
      value: "not null"
    }
  }

  measure: min_created {
    convert_tz: no
    type: date
    sql: min(${created_date}) ;;

  }
  measure: max_created {
    convert_tz: no
    type: date
    sql: max(${created_date}) ;;
  }
}

#this would be the way to create a standalone suggestions, for fast lookup when no other filters or joins matter...
explore: users_suggestions {hidden:yes}
view: users_suggestions {
  derived_table: {sql:select 't'||first_name as first_name,'t'||last_name as last_name, age+1 as age from users;;}
  dimension: first_name {}
  dimension: last_name {}
  dimension: age {
  }
}
