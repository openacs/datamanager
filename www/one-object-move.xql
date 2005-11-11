<?xml version="1.0"?>
<queryset>
<fullquery name="get_tree_sortkey">
<querytext>
    SELECT tree_sortkey,item_id,tree_level(tree_sortkey) as tree_level 
    FROM cr_items 
    WHERE item_id in ([join $object_id ","])
    ORDER BY item_id
</querytext>
</fullquery>

<fullquery name="get_ancestors_p1">
<querytext>
SELECT tree_ancestor_p(:c_item,:tree_sortkey)
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
