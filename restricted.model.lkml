#proposition: Models should be aligned specifically to a unique combination of CONNECTION and USER_ACCESS_TYPE
connection: "thelook_events_redshift"

include: "users_explore.lkml"
explore: users {
  group_label: "KM Models"
  label: "Users (Restricted)"
  extends: [users_base]
#   access_filter: {
#     field: first_name
#     user_attribute: first_name
#   }
  sql_always_where: ${users.first_name} ilike '{{_user_attributes['first_name']}}' ;;

}

# explore: order_items {
#   group_label: "KM Models"
#   label: "Users (Restricted)"
#   extends: [order_items_base]
# #   access_filter: {
# #     field: first_name
# #     user_attribute: first_name
# #   }
#   sql_always_where: ${users.first_name} ilike '{{_user_attributes['first_name']}}' ;;
# #   sql_always_where: 't' ;;
# }
