view: suggestions {
  derived_table: {sql:select 't'||first_name as first_name,'t'||last_name as last_name, age+1 as age from users;;}
  dimension: first_name {}
  dimension: last_name {}

  dimension: age {
  }
}
