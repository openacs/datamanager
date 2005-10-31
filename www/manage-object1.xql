<?xml version="1.0"?>
<queryset>

<fullquery name="select_assessment">
      <querytext>
    SELECT ao1.title as object_name,
           ao1.object_id,
           us1.username as creation_user,
           ao1.creation_date
    FROM acs_objects as ao1,
         users as us1
    WHERE us1.user_id=ao1.creation_user and
          ao1.object_id in
                (SELECT coalesce(live_revision,latest_revision)
                 FROM cr_items 
                 WHERE item_id in 
                    (SELECT item_id 
                    FROM  cr_revisions 
                    WHERE revision_id in 
                       (SELECT ao.object_id
                        FROM dotlrn_community_applets as dca,
                             dotlrn_applets as da,
                             acs_objects as ao 
                        WHERE dca.applet_id=da.applet_id
                              and da.applet_key='dotlrn_assessment'
                              and ao.package_id=dca.package_id 
                              and ao.object_type='as_assessments'
                              and dca.community_id=:community_id)
                  group by item_id))     
      </querytext>
</fullquery>



<fullquery name="select_faq">
      <querytext>
        SELECT ao.title as object_name,
               ao.object_id,
               us1.username as creation_user,
               ao.creation_date
        FROM acs_objects as ao,
             users as us1
        WHERE us1.user_id=ao.creation_user and
              ao.context_id in (select package_id from dotlrn_community_applets where applet_id = (select applet_id from dotlrn_applets where applet_key='dotlrn_faq') and community_id=:community_id)      </querytext>
</fullquery>

<fullquery name="select_static-portlet">
      <querytext>
    SELECT spc.pretty_name as object_name,ao.object_id,ao.creation_date,'Unknown' as creation_user
    FROM acs_objects as ao,static_portal_content as spc
    WHERE ao.object_id in (select content_id from static_portal_content where body <> '' and package_id=:community_id) and spc.content_id=ao.object_id and not(spc.pretty_name like '#dotlrn-static%_info_%#')
      </querytext>
</fullquery>


<fullquery name="select_forum">
      <querytext>
      SELECT ao.title as object_name,
             ao.object_id,
             us1.username as creation_user,
             ao.creation_date,
             count(ao.object_id) as threads_number
      FROM  acs_objects as ao,
            users as us1,
            forums_messages as fm
      WHERE us1.user_id=ao.creation_user
            and fm.forum_id = ao.object_id
            and fm.parent_id IS NULL
            and context_id in (select package_id 
                               from dotlrn_community_applets as dca, dotlrn_applets as da  
                               where dca.applet_id=da.applet_id and da.applet_key='dotlrn_forums' and dca.community_id=:community_id)
       GROUP BY ao.title,ao.object_id,us1.username,ao.creation_date    
   </querytext>
</fullquery>

<fullquery name="select_folder">
      <querytext>
        SELECT cf.label as object_name,
               cf.folder_id as object_id,
               us1.username as creation_user,
               ao.creation_date,
               tree_level(ci1.tree_sortkey) as level_num
        FROM cr_folders cf,
             cr_items ci1,
             cr_items ci2,
             acs_objects ao,
             users us1
        WHERE ci1.tree_sortkey between ci2.tree_sortkey and tree_right(ci2.tree_sortkey)
              and ci2.item_id=:root_folder_id
              and ci1.item_id=cf.folder_id
              and ao.object_id=cf.folder_id
              and ao.creation_user=us1.user_id
        ORDER BY ci1.tree_sortkey
      </querytext>
</fullquery>

<fullquery name="select_folder_package_id">
<querytext>
    select package_id 
    from dotlrn_community_applets 
    where applet_id=(select applet_id from dotlrn_applets where applet_key='dotlrn_fs') and community_id=:community_id;
</querytext>
</fullquery>


</queryset>

    
