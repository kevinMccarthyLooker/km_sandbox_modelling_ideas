view: test_labels {

  dimension: basic_dynamically_Labelled_field_with_no_issues {
    label: "{% if basic_dynamically_Labelled_field_with_no_issues._is_selected %}Output Label{% else %}Field Picker Label{% endif %}"
    sql: 1 ;;
  }



################
  derived_table: {
    sql: select '1'::varchar as t;;
  }

  dimension: test_1 {
    label: "test_1__label"
    description: "test_1"
    sql:  ${TABLE}.t ;;
  }

  dimension: test_2 {
#     description: "{{ test_2._name }}" #doesn't work
    description: "test_2"
#     sql:  {{ test_1._name}} ;;#test_labels.test_1  AS "test_labels.test_2"
    sql:  ${test_1} -> {{ test_1._name}} ;;#test_labels.test_1  AS "test_labels.test_2" #name, not the fields label
  }


  dimension: test_3 {
    label: "test 2's sql:{{test_2._sql}}"
    sql: 1 ;;
  }


  dimension: test_4 {
    sql:
    {% assign t='now' | date: '%Y' %}
    {{t}}
    ;;
  }

  dimension: test_5 {
    label: "{{test_4._sql}}"#becomees the sql text of test_4
    sql: 1 ;;
  }

  dimension: test_6 {
    label: "{{_filters['test_1']}}"
    sql: 1 ;;
  }

  dimension: test_7 {
    label: "
    {% assign a=_filters['test_1'] %}
    aaa:{{test_7._name}}"
    sql: 1 ;;
#     {% if _filters['test_1']=='' %}{{_filters['test_1']}}{% else %}regular label{% endif %}"
  }

  dimension: test_8_label_builder {
    sql:
    {% assign varbles = '' %}
    Total Members (As of Date)


    ;;
  }

  dimension: Dynamically_Labelled_field_with_no_issues {
    label: "{% if _filters['test_1'] != '' %}output label from selection: {{_filters['test_1'] | replace: ''','' | strip }}{% else %}{{test_8_label_builder._sql | replace: ''','' | strip }}{% endif %}"
    sql: 1 ;;
  }

}
