### for 'functions' or 'global variables'.  use no join (sql: ;;)
view: variables_and_templates {
#using sql replacement
measure: t {
  sql: {% assign field_argument = 't' %} ;;
}
#   measure: TEMPLATE_summary {
#     hidden: yes
#     type: string
#     sql:
#     'Values Range: '||
#     case
#       when coalesce(count(TEMPLATE_SQL_PLACEHOLDER),0)=0 then 'All NULLs'
#       when count(distinct TEMPLATE_SQL_PLACEHOLDER)=1 then min(TEMPLATE_SQL_PLACEHOLDER) ||'(only value)'
#       when count(distinct TEMPLATE_SQL_PLACEHOLDER)=2 then min(TEMPLATE_SQL_PLACEHOLDER) || ' and ' || max(TEMPLATE_SQL_PLACEHOLDER)
#       else min(TEMPLATE_SQL_PLACEHOLDER) ||' - '|| max(TEMPLATE_SQL_PLACEHOLDER)
#     end ||
#     '| Count Distinct:' || count(distinct TEMPLATE_SQL_PLACEHOLDER) || '| Count Null:'||count(*)-count(TEMPLATE_SQL_PLACEHOLDER) ;;
#   }

#   measure: TEMPLATE_summary {
#     hidden: yes
#     type: string
#     sql:
#     'Values Range: '||
#     case
#       when coalesce(count({{field_argument}}),0)=0 then 'All NULLs'
#       when count(distinct {{field_argument}})=1 then min({{field_argument}}) ||'(only value)'
#       when count(distinct {{field_argument}})=2 then min({{field_argument}}) || ' and ' || max({{field_argument}})
#       else min({{field_argument}}) ||' - '|| max({{field_argument}})
#     end ||
#     '| Count Distinct:' || count(distinct {{field_argument}}) || '| Count Null:'||count(*)-count({{field_argument}})
#     ;;
#   }
#simpler output example:
#   measure: TEMPLATE_summary {
#     sql: {% assign field_argument2 ='t' | replace: 't',field_argument %}CASE WHEN COUNT({{field_argument2}}) = 0 THEN 'N/A' ELSE MIN({{field_argument2}}) || ' - '  || MAX({{field_argument2}}) end ;;
#   }



}
