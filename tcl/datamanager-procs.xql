<?xml version="1.0"?>
<queryset>

<fullquery name="datamanager::get_object_type.get_object_type">
<querytext>
    select object_type
	from acs_objects
	where object_id= :object_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_object_data.get_data_forum">
<querytext>
    select name as object_name
   from forums_forums 
    where forum_id=:object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_faq">
<querytext>
        select faq_name as object_name
	from faqs
	where faq_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_news">
<querytext>
        select title as object_name
	from acs_objects
	where object_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_static_portal">
<querytext>
        select pretty_name as object_name
	from static_portal_content 
	where content_id = :object_id;
</querytext>
</fullquery>

<fullquery name="datamanager::get_object_data.get_data_assessment">
<querytext>
         select title as object_name
	from acs_objects
	where object_id = :object_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_object_data.get_data_folder">
<querytext>
         select title as object_name
	from acs_objects
	where object_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_list_of_dest_communities">
<querytext>
    select community_id 
	from dotlrn_communities_all 
	where community_id <> :comm_id and 
        (parent_community_id <> community_id or parent_community_id is null) and 
        (community_id in (select community_id
                      from dotlrn_community_applets applets 
                      where applet_id = (select applet_id 
                                         from dotlrn_applets 
                                         where applet_key=:object_type)))
</querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_data_communities">
<querytext>
        select community_id, community_type, pretty_name as name, parent_community_id 
	from dotlrn_communities_all 
	where community_id in ([join $communities_list_p ","]) 
    </querytext>
</fullquery>

<fullquery name="datamanager::get_available_communities.get_parent_community_id">
<querytext>
        select pretty_name 
	from dotlrn_communities_all 
	where community_id = :parent_community_id
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
