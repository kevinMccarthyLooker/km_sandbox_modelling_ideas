#proposition: Models should be aligned specifically to a unique combination of CONNECTION and USER_ACCESS_TYPE
connection: "thelook_events_redshift"

include: "users_explore.lkml"
explore: users {
  group_label: "KM Models"
  label: "Users (Basic)"
  fields: [ALL_FIELDS*,-users.id]
  extends: [users_base]
}
