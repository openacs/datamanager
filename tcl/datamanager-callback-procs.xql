<?xml version="1.0"?>
<queryset>



<fullquery name="callback::datamanager::export_acs_user::impl::datamanager.select_user_info">
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

<fullquery name="callback::datamanager::export_acs_user::impl::datamanager.select_user_bio">
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


<fullquery name="callback::datamanager::export_acs_user::impl::datamanager.select_user_photo">
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

<fullquery name="callback::datamanager::export_acs_user::impl::datamanager.select_user_photo_revision">
  <querytext>
        
        select revision_id
        from acs_rels a, cr_revisions r, cr_items i
        where   a.object_id_two = r.item_id and 
                        a.object_id_one = :user_id and 
                        a.rel_type = 'user_portrait_rel' and
                        r.revision_id = i.live_revision
        
   </querytext>
</fullquery>


<fullquery name="callback::datamanager::export_acs_user::impl::datamanager.write_lob_content">
  <querytext>
                select lob as content
                from cr_revisions
                where revision_id = :revision_id        
   </querytext>
</fullquery>


<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.select_dotlrn_club">
  <querytext>
    SELECT      pretty_name as name,
                        description
    FROM        dotlrn_communities_all
    WHERE       community_id = :object_id
   </querytext>
</fullquery>

<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_members_list">
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

<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_id_members_list">
  <querytext>
    SELECT      u.user_id, u.username, u.authority_id, r.rel_type
    FROM        registered_users u,
                        dotlrn_member_rels_approved r
    WHERE       r.community_id = :community_id and 
                        r.user_id = u.user_id 
        order by last_name, first_names
        
   </querytext>
</fullquery>


<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_portlets_id">
  <querytext>
    select content_id      
    from static_portal_content
    where package_id = :community_id and
              pretty_name <> '#dotlrn-static.community_info_portlet_pretty_name#';
        
   </querytext>
</fullquery>

<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_news_id">
  <querytext>
        select news_id
        from cr_news 
        where package_id = $pid;
   </querytext>
</fullquery>

<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_news_id">
  <querytext>
        select news_id
        from cr_news 
        where package_id = $pid;
   </querytext>
</fullquery>


<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_faqs_id">
  <querytext>
        select object_id 
        from acs_objects 
        where context_id = $pid and
                  object_type = 'faq'
   </querytext>
</fullquery>

<fullquery name="callback::datamanager::export_dotlrn_club::impl::datamanager.get_forums_id">
  <querytext>
        select forum_id 
        from forums_forums 
        where package_id = $pid
   </querytext>
</fullquery>


</queryset>
