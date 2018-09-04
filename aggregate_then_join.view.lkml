view: aggregate_then_join {
  derived_table: {
    sql:
    /* dummy example data */
    with a as
      (
      select 1 as a_id, '2018-01-01' as example_date,1 as table_x_pk, 101 as table_y_pk, 1001 as revenue union all
      select 2 as a_id, '2018-01-02' as example_date,1 as table_x_pk, 101 as table_y_pk, 1002 as revenue union all
      select 3 as a_id, '2018-01-03' as example_date,2 as table_x_pk, 101 as table_y_pk, 1003 as revenue union all
      select 4 as a_id, '2018-01-03' as example_date,2 as table_x_pk, 102 as table_y_pk, 1004 as revenue
      ),
      b as
      (
      select 1 as b_id, '2018-01-01' as example_date,1 as table_x_pk, 101 as cost union all
      select 2 as b_id, '2018-01-01' as example_date,1 as table_x_pk, 102 as cost union all
      select 3 as b_id, '2018-01-02' as example_date,1 as table_x_pk, 103 as cost union all
      select 4 as b_id, '2018-01-02' as example_date,3 as table_x_pk, 104 as cost
      ),

{% assign fields_list = ''
%}{% if example_date._in_query %}{% assign fields_list = fields_list | append:'example_date,' %}{% endif
%}{% if table_x_pk._in_query %}{% assign fields_list = fields_list | append:'table_x_pk,' %}{% endif
%}{% assign string_length_to_keep = fields_list | size | plus: -1
%}{% assign final_fields_list = fields_list | slice: 0, string_length_to_keep
%}{% assign fields_array = final_fields_list | split: ','
%}      a_rollup as (
      select {{final_fields_list}},
      sum(revenue) as revenue
      from a
      group by {{final_fields_list}}
      ),

      b_rollup as(
      select {{final_fields_list}},
      sum(cost) as cost
      from b
      group by {{final_fields_list}}
      )

      select
      {% assign output_fields_list = ''
        %}{% for i in (0..10)
        %}{% if fields_array[i]
        %}{% assign output_fields_list = output_fields_list | append: 'coalesce(a_rollup.' | append: fields_array[i] | append: ',b_rollup.' | append:fields_array[i] | append:') as '| append: fields_array[i] | append:','
        %}{% endif
        %}{% endfor
        %}{% assign output_fields_list_string_length_to_keep = output_fields_list | size | plus: -1
        %}{% assign output_fields_final_fields_list = output_fields_list | slice: 0, output_fields_list_string_length_to_keep

        %}{{output_fields_final_fields_list}},
      sum(coalesce(revenue,0)) as revenue,
      sum(coalesce(cost,0)) as cost

      from a_rollup full outer join b_rollup on
      {% assign join_on_clause = ''
        %}{% for i in (0..10) %}{% if fields_array[i] %}{% assign join_on_clause = join_on_clause | append: 'a_rollup.' | append: fields_array[i] | append: '=b_rollup.' | append:fields_array[i] | append:' and ' %}{% endif %}{% endfor
        %}{% assign join_on_clause_length_to_keep = join_on_clause | size | plus: -4
        %}{% assign join_on_clause = join_on_clause | slice: 0, join_on_clause_length_to_keep %}
      {{join_on_clause}}
      group by
      {% assign group_by_string = ''
        %}{% for i in (0..10)
        %}{% if fields_array[i] %}
          {% assign group_by_field_number = i | plus:1
            %}{% assign group_by_string = group_by_string | append: group_by_field_number | append:','
            %}{% endif %}
      {% endfor
        %}{% assign group_by_string_length_to_keep = group_by_string | size | plus: -1
        %}{% assign output_fields_final_fields_list = group_by_string | slice: 0, group_by_string_length_to_keep
        %}{{output_fields_final_fields_list}};;
  }
  #a_rollup.example_date=b_rollup.example_date and a_rollup.table_x_pk=b_rollup.table_x_pk
#         coalesce(a_rollup.example_date,b_rollup.example_date) as example_date,
#       coalesce(a_rollup.table_x_pk,b_rollup.table_x_pk) as table_x_pk,

# case when example_date=null then null else null end
#       {% if example_date._in_query %}example_date,{% endif %}
#       {% if table_x_pk._in_query %}table_x_pk,{% endif %}

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: example_date {
    type: string
    sql: ${TABLE}.example_date ;;
  }

  dimension: table_x_pk {
    type: number
    sql: ${TABLE}.table_x_pk ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  set: detail {
    fields: [example_date, table_x_pk, revenue, cost]
  }
}
