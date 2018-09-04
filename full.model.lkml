connection: "thelook_events_redshift"

include: "users_explore.lkml"
explore: users {
  group_label: "KM Models"
  extends: [users_base]

}

#note: suggestions explore must be in the same model as the original view...
# include: "suggestions.view"
# explore: suggestions {}
