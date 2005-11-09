<?xml version="1.0"?>
<queryset>


<fullquery name="get_list_of_dest_communities">
<querytext>
    SELECT  community_id 
	FROM dotlrn_communities_all 
	WHERE community_id <> :comm_id 
          and community_type='dotlrn_club'
          and (parent_community_id <> community_id or parent_community_id is null) 
          and (community_id in (select dca.community_id 
                                from dotlrn_community_applets dca,
                                     dotlrn_applets da
                                where dca.applet_id = da.applet_id 
                                      and da.applet_key=:object_type))
</querytext>
</fullquery>

<fullquery name="get_list_of_dest_classes">
<querytext>
    SELECT  community_id 
	FROM dotlrn_communities_all 
	WHERE community_id <> :comm_id
          and community_type <> 'dotlrn_club'
          and (parent_community_id <> community_id or parent_community_id is null) 
          and (community_id in (select dca.community_id 
                                from dotlrn_community_applets dca,
                                     dotlrn_applets da
                                where dca.applet_id = da.applet_id 
                                      and da.applet_key=:object_type))
</querytext>
</fullquery>


<fullquery name="get_data_communities">
<querytext>
        select community_id as dest_community_id, community_type, pretty_name as name, parent_community_id 
	from dotlrn_communities_all 
	where community_id in ([join $communities_list_p ","]) 
    </querytext>
</fullquery>

</queryset>
