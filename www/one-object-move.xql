<?xml version="1.0"?>
<queryset>
<fullquery name="datamanager::get_object_type">
<querytext>
    select object_type
	from acs_objects
	where object_id= :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_data_forum">
<querytext>
    select name as object_name
   from forums_forums 
    where forum_id=:object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_data_faq">
<querytext>
        select faq_name as object_name
	from faqs
	where faq_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_data_news">
<querytext>
        select title as object_name
	from acs_objects
	where object_id = :object_id
</querytext>
</fullquery>

<fullquery name="datamanager::get_data_static_portal">
<querytext>
        select pretty_name as object_name
	from static_portal_content 
	where content_id = :object_id;
</querytext>
</fullquery>

<fullquery name="datamanager::get_data_assessment">
<querytext>
         select title as object_name
	from acs_objects
	where object_id = :object_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_data_folder">
<querytext>
         select title as object_name
	from acs_objects
	where object_id = :object_id
</querytext>
</fullquery>


<fullquery name="datamanager::get_data_communities">
<querytext>
        select community_id, community_type, pretty_name as name, parent_community_id 
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

<fullquery name="datamanager::get_parent_community_id">
<querytext>
        select pretty_name 
	from dotlrn_communities_all 
	where community_id = :parent_community_id
</querytext>
</fullquery>

<fullquery name="get_tree_sortkey">
<querytext>
    select tree_sortkey,item_id,tree_level(tree_sortkey) as tree_level 
    from cr_items 
    where item_id in ([join $object_id ","])
    order by item_id
</querytext>
</fullquery>

<fullquery name="get_ancestors_p1">
<querytext>
select tree_ancestor_p(:c_item,:tree_sortkey)
</querytext>
</fullquery>

<fullquery name="get_ancestors_p2">
<querytext>
select tree_ancestor_p(:tree_sortkey,:c_item)
</querytext>
</fullquery>

<fullquery name="get_departments_list">
<querytext>
    SELECT dct.pretty_name, dd.department_key
    FROM dotlrn_departments dd, dotlrn_community_types dct
    WHERE dct.community_type=dd.department_key
</querytext>
</fullquery>


</queryset>
