with unioned as (

  select * from {{ref('fb_insights_age_actions_values')}}
  union all
  select * from {{ref('fb_insights_gender_actions_values')}}
  union all
  select * from {{ref('fb_insights_country_actions_values')}}
  union all
  select * from {{ref('fb_insights_placement_actions_values')}}
  union all
  select * from {{ref('fb_insights_device_actions_values')}}

), insights as (

  select * from {{ref('fb_insights_segmented_xf')}}

)

select
  md5(insights.id || '|' || unioned.id) as id,
  insights.id as segmented_insight_id,
  unioned.ad_id,
  unioned.date_day,
  unioned.action_destination,
  unioned.action_type,
  unioned.segment_type,
  unioned.segment,
  unioned.action_value
from unioned
  inner join insights
    on unioned.date_day = insights.date_day
    and unioned.ad_id = insights.ad_id
    and unioned.segment_type = insights.segment_type
    and unioned.segment = insights.segment
