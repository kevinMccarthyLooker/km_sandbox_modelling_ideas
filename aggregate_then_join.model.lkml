connection: "thelook_events_redshift"

include: "aggregate_then_join.view"

explore: aggregate_then_join {}

#20181121 datagroup dependency test
datagroup: dg_1 {
  sql_trigger: select current_date() ;;
}

view: dt_1 {
  derived_table: {
    sql: select current_time() as t ;;
    datagroup_trigger: dg_1
    distribution_style: all

  }
}

datagroup: dg_2 {
  sql_trigger: select max(t) from ${dt_1.SQL_TABLE_NAME} ;;
}

view: dt_2 {
  derived_table: {
    sql: select 1 as a_number ;;
    datagroup_trigger: dg_2
    distribution_style: all
  }
}

explore: dt_2 {}
