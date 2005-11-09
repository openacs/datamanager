<?xml version="1.0"?>
<queryset>

<fullquery name="select_new_enabled">
      <querytext>
     SELECT ao.title as object_name,
            ao.object_id,
            us1.username as creation_user,
            ao.creation_date
     FROM cr_news cn,
          acs_objects ao,
          cr_items it,
          users as us1,
          dotlrn_community_applets as dca,
          dotlrn_applets as da,
          news_items_approved as nia
     WHERE it.live_revision=cn.news_id 
           and cn.news_id=ao.object_id 
           and cn.package_id=dca.package_id
           and dca.applet_id=da.applet_id
           and us1.user_id=ao.creation_user
           and nia.item_id=it.item_id
           and nia.publish_date < current_timestamp 
           and nia.archive_date > current_timestamp
           and dca.community_id=:community_id
      </querytext>
</fullquery>

<fullquery name="select_new_archived">
      <querytext>
     SELECT ao.title as object_name,
            ao.object_id,
            us1.username as creation_user,
            ao.creation_date
     FROM cr_news cn,
          acs_objects ao,
          cr_items it,
          users as us1,
          dotlrn_community_applets as dca,
          dotlrn_applets as da,
          news_items_approved as nia
     WHERE it.live_revision=cn.news_id 
           and cn.news_id=ao.object_id 
           and cn.package_id=dca.package_id
           and dca.applet_id=da.applet_id
           and us1.user_id=ao.creation_user
           and nia.item_id=it.item_id
           and nia.publish_date < current_timestamp 
           and nia.archive_date < current_timestamp
           and dca.community_id=:community_id
      </querytext>
</fullquery>

</queryset>

    
