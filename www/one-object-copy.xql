<?xml version="1.0"?>
<queryset>

<fullquery name="get_departments_list">
<querytext>
    SELECT dct.pretty_name, dd.department_key
    FROM dotlrn_departments dd, dotlrn_community_types dct
    WHERE dct.community_type=dd.department_key
</querytext>
</fullquery>


</queryset>
