<?xml version="1.0"?>
<queryset>

<fullquery name="select_faq">
  <querytext>
    SELECT f.faq_name as object_name,
           ao.object_id,
           us1.username as creation_user,
           to_char(ao.creation_date, 'YYYY-MM-DD HH:MM:SS') as creation_date
    FROM acs_objects as ao,
         faqs as f,
         users as us1
    WHERE 
          us1.user_id = ao.creation_user and
          f.faq_id = ao.object_id and
          ao.context_id in (select package_id 
                            from dotlrn_community_applets 
                            where applet_id = (select applet_id 
                                               from dotlrn_applets 
                                               where applet_key='dotlrn_faq') and 
                                  community_id=:community_id)
  </querytext>
</fullquery>

<fullquery name="select_static-portlet">
  <querytext>
    SELECT spc.pretty_name as object_name,ao.object_id,
           to_char(ao.creation_date,'YYYY-MM-DD HH:MM:SS') as creation_date,
           'Unknown' as creation_user
    FROM acs_objects as ao,
         static_portal_content as spc
    WHERE 
         ao.object_id in (select content_id 
                           from static_portal_content 
                           where body <> '' and package_id=:community_id) and 
                                 spc.content_id=ao.object_id and 
                                 not (spc.pretty_name like '#dotlrn-static%_info_%#')
   </querytext>
</fullquery>

<fullquery name="select_forum">
  <querytext>  
    SELECT fo.name as object_name,
           ao.object_id,
           us1.username as creation_user,
           to_char(ao.creation_date,'YYYY-MM-DD HH:MM:SS') as creation_date,             
           fo.charter,
           fo.presentation_type,
           fo.posting_policy,
           fo.enabled_p,
           fo.thread_count,
           fo.approved_thread_count,
           fo.last_post,
           fo.autosubscribe_p
    FROM  acs_objects as ao,
          users as us1,
          forums_forums as fo    
    WHERE 
          us1.user_id = ao.creation_user
          and fo.forum_id = ao.object_id
          and ao.context_id in (select package_id 
                                from dotlrn_community_applets as dca, 
                                     dotlrn_applets as da  
                                where dca.applet_id=da.applet_id and 
                                      da.applet_key='dotlrn_forums' and 
                                      dca.community_id = :community_id)
     ORDER BY object_name, ao.creation_date
   </querytext>
</fullquery>

<fullquery name="select_new">
    <querytext>
    select
       item_id,
           news_id as object_id,
       content_item__get_best_revision(item_id) as revision_id,
       content_revision__get_number(news_id) as revision_no,
       publish_title as object_name,
       html_p,
           creation_date,
       to_char(publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi,
       to_char(archive_date, 'YYYY-MM-DD HH24:MI:SS') as archive_date_ansi,
           username as creation_user,
       item_creator,
       package_id,
       status
           from 
       news_items_live_or_submitted,
           users
        where 
                user_id = creation_user and
                package_id = (
                        select object_id as package_id from acs_objects o, apm_packages p where o.object_id = p.package_id and p.package_key = 'news' and o.context_id = (select package_id from dotlrn_communities_all where community_id = :community_id))
        order by item_id desc
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
    where applet_id=(select applet_id from dotlrn_applets where applet_key='dotlrn_fs') and community_id=:community_id
</querytext>
</fullquery>

<fullquery name="select_photo_album_package_id">
<querytext>
    select package_id 
    from dotlrn_community_applets 
    where applet_id=(select applet_id from dotlrn_applets where applet_key='dotlrn_photo_album') and community_id=:community_id
</querytext>
</fullquery>

<fullquery name="select_photo_folders">
<querytext>
SELECT folder_id as object_id from cr_folders where folder_id = :pa_root_folder UNION SELECT cf.folder_id as object_id FROM cr_folders cf, cr_items ci1, cr_items ci2, acs_objects ao, users us1 WHERE ci1.tree_sortkey between ci2.tree_sortkey and tree_right(ci2.tree_sortkey) and ci2.item_id= :pa_root_folder and ci1.item_id=cf.folder_id and ao.object_id=cf.folder_id and ao.creation_user=us1.user_id
</querytext>
</fullquery>


<fullquery name="select_pa_album">
<querytext>
select distinct 
        a.object_id as parent,
        b.object_id as object_id,
        i.name as object_name,
        a.creation_user,
        a.creation_date,
        tree_level(a.tree_sortkey) as level_num
from acs_objects a, acs_objects b, cr_items i 
where a.object_id = i.item_id and a.context_id in 
        (SELECT folder_id as object_id from cr_folders where folder_id = :pa_root_folder UNION SELECT cf.folder_id as object_id FROM cr_folders cf, cr_items ci1, cr_items ci2, acs_objects ao, users us1 WHERE ci1.tree_sortkey between ci2.tree_sortkey and tree_right(ci2.tree_sortkey) and ci2.item_id= :pa_root_folder and ci1.item_id=cf.folder_id and ao.object_id=cf.folder_id and ao.creation_user=us1.user_id) and 
        a.object_type = 'content_item' and 
        a.object_id = b.context_id and 
        b.object_type = 'pa_album'
</querytext>
</fullquery>



<fullquery name="select_photo_album_folders">
<querytext>
SELECT folder_id as object_id from cr_folders where folder_id = :pa_root_folder UNION SELECT cf.folder_id as object_id FROM cr_folders cf, cr_items ci1, cr_items ci2, acs_objects ao, users us1 WHERE ci1.tree_sortkey between ci2.tree_sortkey and tree_right(ci2.tree_sortkey) and ci2.item_id= :pa_root_folder and ci1.item_id=cf.folder_id and ao.object_id=cf.folder_id and ao.creation_user=us1.user_id  
</querytext>
</fullquery>



<fullquery name="select_dotlrn_club">
<querytext>
        SELECT  community_id as object_id,
                        pretty_name as object_name,
                        active_start_date as creation_date,
                        'root' as creation_user
        FROM    dotlrn_communities_all 
        WHERE   community_type = 'dotlrn_club'
        ORDER BY pretty_name
</querytext>
</fullquery>
  
</queryset>
