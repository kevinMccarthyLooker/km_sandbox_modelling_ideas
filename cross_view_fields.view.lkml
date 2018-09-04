#define one dummy view per combination of views required for your calculations
view: order_items_and_users {
  #no sql_table_name is used for cross view fileds
  measure: order_items_per_user {
    type: number
    sql: ${order_items.count}*1.0/nullif(${users.count},0) ;; #use *1.0 to avoid truncating, and nullif(,0) to avoid divide by zero errors
  }
}
