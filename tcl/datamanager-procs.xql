<?xml version="1.0"?>
<queryset>

<fullquery name="datamanager::get_object_type.get_object_type">
<querytext>
    SELECT object_type
	FROM acs_objects
	WHERE object_id= :object_id
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
    SELECT title as object_name
	FROM acs_objects
	WHERE object_id = :object_id
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
    SELECT title as object_name
	FROM acs_objects
	WHERE object_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_list_of_dest_communities">
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

<fullquery name="datamanager::get_available_communities.get_list_of_dest_classes">
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

<fullquery name="datamanager::get_available_communities.get_list_of_all_dest_classes">
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

</queryset>
