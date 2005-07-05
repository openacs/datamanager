<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="datamanager::user_member_groups.select_member_classes">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_full.role,
                   dotlrn_member_rels_full.rel_type,
                   dotlrn_member_rels_full.member_state
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

</queryset>
