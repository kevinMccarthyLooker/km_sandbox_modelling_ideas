
include: "users.view.lkml"
include: "order_items.view.lkml"
include: "cross_view_fields.view.lkml"
# include: "variables_and_templates.view.lkml"

#good idea to check distkeys like select schemaname,tablename, "column" from pg_table_def where distkey=true
# | schemaname  | tablename       | column
# public        | events          | session_id
# public        | inventory_items | product_id
# public        | order_items     | user_id
# public        | products        | id
# public        | users           | id

explore: users_base {
  view_name: users
  extension: required
  # fields: [ALL_FIELDS*,-artists.user_id]
  join: order_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${order_items.user_id};;
  }

#   join: variables_and_templates {
#     sql:  ;;
#     relationship: one_to_one
#   }

  join: order_items_and_users {
    sql:  ;;#cross view joins take an empty sql parameter
    relationship: one_to_one #cross view dummy joins are always on_to_one
  }

}


# include: "order_items.view"
# explore: order_items_base {
#   join: users {
#     sql_on: ${order_items.user_id}=${users.id} ;;
#     relationship: many_to_one
#   }
# }
