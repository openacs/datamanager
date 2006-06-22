<?xml version="1.0"?>
<queryset>

<fullquery name="datamanager::get_object_type.get_object_type">
<querytext>
    SELECT object_type
        FROM acs_objects
        WHERE object_id= :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_child_object_id.get_child_object_type">
<querytext>
     select object_id as oid from acs_objects where context_id = :object_id and object_type = :object_type;
</querytext>
</fullquery>


<fullquery name="datamanager::get_object_data.get_data_forum">
<querytext>
    SELECT name as object_name
    FROM forums_forums 
    WHERE forum_id=:object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_faq">
<querytext>
    SELECT faq_name as object_name
        FROM faqs
        WHERE faq_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_news">
<querytext>
    SELECT ci.title as object_name
        FROM acs_objects ao, cr_newsi ci
        WHERE ao.object_id = :object_id and ao.object_id = ci.object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_static_portal">
<querytext>
    SELECT pretty_name as object_name
        FROM static_portal_content 
        WHERE content_id = :object_id;
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_assessment">
<querytext>
    SELECT title as object_name
        FROM acs_objects
        WHERE object_id = :object_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_object_data.get_data_folder">
<querytext>
    SELECT cf.label as object_name
        FROM acs_objects ao,
             cr_folders cf
        WHERE ao.object_id = :object_id and
              ao.object_id=cf.folder_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_object_data.get_data_album">
<querytext>
        SELECT ci.name as object_name 
        FROM    acs_objects ao, 
                        cr_items ci 
        WHERE   ao.object_id = :object_id and 
                        ao.context_id= ci.item_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_available_communities.get_list_of_dest_communities.ori">
<querytext>
    SELECT  community_id 
        FROM dotlrn_communities_all 
        WHERE community_id <> :comm_id 
          and community_type='dotlrn_club'
          and (parent_community_id <> community_id or parent_community_id is null) 
          and (community_id in (SELECT dca.community_id 
                                FROM dotlrn_community_applets dca,
                                     dotlrn_applets da
                                WHERE dca.applet_id = da.applet_id 
                                      and da.applet_key= :object_type))
</querytext>
</fullquery>
    

<fullquery name="datamanager::get_available_communities.get_list_of_dest_communities">
<querytext>
select distinct d.community_id
from 
       groups, 
       group_member_map gm, 
       dotlrn_communities_all d, 
       dotlrn_community_applets dca,
       dotlrn_applets da 
where 
       d.community_id <> :comm_id and
       groups.group_id = gm.group_id and 
       gm.member_id=:user_id and 
       d.community_id=groups.group_id and 
       d.community_type = 'dotlrn_club' and 
       dca.community_id = d.community_id and 
       dca.applet_id = da.applet_id and 
       da.applet_key= :object_type   
</querytext>
</fullquery>




<fullquery name="datamanager::get_available_communities.get_list_of_dest_classes.ori">
<querytext>
    SELECT  community_id 
        FROM dotlrn_communities_all dca,
         dotlrn_classes dc,
         dotlrn_departments dd
        WHERE dca.community_id <> :comm_id
          and dca.community_type = dc.class_key
          and dc.department_key=dd.department_key
          and dd.department_key=:department_key
          and (parent_community_id <> community_id or parent_community_id is null) 
          and (community_id in (SELECT dca.community_id 
                                FROM dotlrn_community_applets dca,
                                     dotlrn_applets da
                                WHERE dca.applet_id = da.applet_id 
                                      and da.applet_key=:object_type))
</querytext>
</fullquery>


<fullquery name="datamanager::get_available_communities.get_list_of_dest_classes">
<querytext>
select distinct d.community_id
from 
       groups, 
       group_member_map gm, 
       dotlrn_communities_all d, 
       dotlrn_community_applets dca,
       dotlrn_applets da,
       dotlrn_classes dc,
       dotlrn_departments dd       
where 
       d.community_id <> :comm_id and
       groups.group_id = gm.group_id and 
       gm.member_id=:user_id and 
       d.community_id=groups.group_id and 
       d.community_type <> 'dotlrn_club' and 
       dca.community_id = d.community_id and 
       dca.applet_id = da.applet_id and 
       da.applet_key= :object_type and 
       dca.community_type = dc.class_key and
       dc.department_key=dd.department_key and
       dd.department_key=:department_key
       
</querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_list_of_all_dest_classes.ori">
<querytext>
    SELECT  community_id 
        FROM dotlrn_communities_all dca
        WHERE dca.community_id <> :comm_id
          and dca.community_type <> 'dotlrn_club'
          and (parent_community_id <> community_id or parent_community_id is null) 
          and (community_id in (SELECT dca.community_id 
                                FROM dotlrn_community_applets dca,
                                     dotlrn_applets da
                                WHERE dca.applet_id = da.applet_id 
                                      and da.applet_key=:object_type))
</querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_list_of_all_dest_classes">
<querytext>
select distinct d.community_id
from 
       groups, 
       group_member_map gm, 
       dotlrn_communities_all d, 
       dotlrn_community_applets dca,
       dotlrn_applets da 
where 
       d.community_id <> :comm_id and
       groups.group_id = gm.group_id and 
       gm.member_id=:user_id and 
       d.community_id=groups.group_id and 
       d.community_type <> 'dotlrn_club' and 
       dca.community_id = d.community_id and 
       dca.applet_id = da.applet_id and 
       da.applet_key= :object_type   
</querytext>
</fullquery>


<fullquery name="datamanager::get_available_communities.get_data_communities">
<querytext>
    SELECT community_id as dest_community_id, community_type, pretty_name as name, parent_community_id 
        FROM dotlrn_communities_all 
        WHERE community_id in ([join $communities_list_p ","])
    </querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_parent_community_id">
<querytext>
    SELECT pretty_name 
        FROM dotlrn_communities_all 
        WHERE community_id = :parent_community_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_trash_id.get_id">
<querytext>
    SELECT object_id as trash_id
    FROM acs_objects
    WHERE object_type='trash' and title IS NULL and context_id IS NULL and package_id IS NULL;
</querytext>
</fullquery>

    <fullquery name="datamanager::get_trash_package_id.get_package_id">
    <querytext>
    SELECT b.object_id as trash_package_id 
    FROM acs_objects as a,acs_objects as b  
    WHERE a.context_id=:community_id and a.object_type='apm_package' and a.object_id=b.context_id and b.title='Datamanager';
    </querytext>
    </fullquery>
        
<fullquery name="datamanager::create_news_item">      
      <querytext>

    select news__new(
        null,               -- p_item_id
        null,               -- p_locale
        :publish_date_ansi, -- p_publish_date
        :publish_body,      -- p_text
        null,               -- p_nls_language
        :publish_title,     -- p_title
        :mime_type,         -- p_mime_type
        :package_id,        -- p_package_id
        :archive_date_ansi, -- p_archive_date
        :approval_user,     -- p_approval_user
        :approval_date,     -- p_approval_date
        :approval_ip,       -- p_approval_ip
        null,               -- p_relation_tag
        :creation_ip,       -- p_creation_ip
        :user_id,           -- p_creation_user
        :live_revision_p    -- p_is_live_p
    );

      </querytext>
</fullquery>    


<fullquery name="datamanager::export_dotlrn_club.select_dotlrn_club">
  <querytext>
    SELECT      pretty_name as name,
                        description
    FROM        dotlrn_communities_all
    WHERE       community_id = :object_id
   </querytext>
</fullquery>

<fullquery name="datamanager::export_dotlrn_club.get_members_list">
  <querytext>
    SELECT      u.email,
                        u.last_name, 
                        u.first_names, 
                        u.username, 
                        r.role,
                        u.user_id
    FROM        registered_users u,
                        dotlrn_member_rels_approved r
    WHERE       r.community_id = :community_id and 
                        r.user_id = u.user_id 
        order by last_name, first_names
        
   </querytext>
</fullquery>

<fullquery name="datamanager::export_acs_user.select_user_info">
  <querytext>

        select  u.username, u.password, u.salt, u.screen_name, 
                        p.first_names, p.last_name, 
                        pa.email, pa.url, 
                        a.short_name as auth, 
                        d.type as usr_type 
        from    users u, persons p, parties pa, auth_authorities a, dotlrn_users d 
        where   u.user_id = :user_id and u.user_id = p.person_id and 
                        u.user_id = d.user_id and p.person_id = pa.party_id and 
                        a.authority_id = u.authority_id
        
   </querytext>
</fullquery>

<fullquery name="datamanager::export_acs_user.select_user_bio">
  <querytext>
                select attr_value as bio 
                from acs_attribute_values 
                where object_id = :user_id and 
                attribute_id = (
                                select attribute_id 
                                from acs_attributes 
                                where   object_type = 'person'and 
                                                attribute_name = 'bio')
        
   </querytext>
</fullquery>


<fullquery name="datamanager::export_acs_user.select_user_photo">
  <querytext>
        
        select encode (data, 'base64') as photo
        from  lob_data 
        where lob_id = (
                select max(r.lob)
                from acs_rels a, cr_revisions r 
                where a.object_id_two = r.item_id and 
                                a.object_id_one = :user_id and 
                                a.rel_type = 'user_portrait_rel')
        
   </querytext>
</fullquery>


<fullquery name="datamanager::get_username_id.get_username_id">
  <querytext>
        select user_id from users where username = :username    
   </querytext>
</fullquery>

<fullquery name="datamanager::get_forum_package_id.get_forum_package_id">
  <querytext>
        select p.package_id as pid 
        from acs_objects o, apm_packages p 
        where   o.context_id = 
                        (select package_id 
                        from dotlrn_communities 
                        where community_id = :community_id) and 
                        o.object_id = p.package_id and 
                        p.package_key = 'forums'
        
   </querytext>
</fullquery>


<fullquery name="datamanager::get_new_package_id.get_new_package_id">
  <querytext>
        select  ao.object_id as pid 
        from    acs_objects ao, apm_packages ap, dotlrn_communities_all dc
        where   ao.object_type = 'apm_package' and 
                        ao.context_id = dc.package_id and 
                        dc.community_id = :community_id and 
                        ao.object_id = ap.package_id and 
                        ap.package_key = 'news'                 
   </querytext>
</fullquery>


<fullquery name="datamanager::get_faq_package_id.get_faq_package_id">
  <querytext>
    SELECT package_id as pid
    FROM dotlrn_community_applets
    WHERE       community_id = :community_id and 
                        applet_id = (
                                select applet_id 
                                from dotlrn_applets 
                                where applet_key = 'dotlrn_faq')
    </querytext>
</fullquery>                    

</queryset>
