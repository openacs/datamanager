<?xml version="1.0"?>
<queryset>

<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="datamanager::select_pretty_name">
<querytext>
        select title as name,object_type,object_id
        from acs_objects
        where context_id in (select package_id from dotlrn_community_applets where applet_id in (select applet_id from dotlrn_applets where applet_key='dotlrn_faq') and community_id=:community_id);
 
</querytext>
</fullquery>

<fullquery name="datamanager::select_folder_package_id">
<querytext>
    select package_id 
    from dotlrn_community_applets 
    where applet_id=(select applet_id from dotlrn_applets where applet_key='dotlrn_fs') and community_id=:community_id;
</querytext>
</fullquery>

<fullquery name="datamanager::select_objects">
<querytext>
        select title as name,object_type,object_id
        from acs_objects
        where context_id in (select package_id from dotlrn_community_applets where applet_id = (select applet_id from dotlrn_applets where applet_key='dotlrn_faq') and community_id=:community_id) 
        UNION
        select title as name,object_type,object_id
        from acs_objects
        where context_id in (select package_id from dotlrn_community_applets where applet_id = (select applet_id from dotlrn_applets where applet_key='dotlrn_forums') and community_id=:community_id)
        UNION
        select ao.title,ao.object_type,ao.object_id from cr_news cn,acs_objects ao, cr_items it where it.live_revision=cn.news_id and cn.news_id=ao.object_id and cn.package_id=(select package_id from dotlrn_community_applets where community_id=:community_id and applet_id=(select applet_id from dotlrn_applets where applet_key='dotlrn_news'))
        UNION 
        select spc.pretty_name as name,object_type,object_id 
        from acs_objects ao, static_portal_content spc
        where object_id in (select content_id from static_portal_content where body <> '' and package_id=:community_id) and spc.content_id=ao.object_id
        UNION
        select title,object_type,object_id 
        from acs_objects 
        where object_id in 
            (             
             select coalesce(live_revision,latest_revision)
             from cr_items 
             where item_id in 
                (select item_id 
                from cr_revisions 
                where revision_id in 
                    (select object_id 
                      from acs_objects 
                      where package_id = 
                        (select package_id 
                         from dotlrn_community_applets 
                         where community_id=:community_id and applet_id = 
                            (select applet_id 
                            from dotlrn_applets 
                            where applet_key='dotlrn_assessment')) 
                     and object_type='as_assessments') group by item_id))
        UNION
        select
        cf.label,ao.object_type,cf.folder_id
        from cr_folders cf, cr_items ci1, cr_items ci2,acs_objects ao
        where
        ci1.tree_sortkey between ci2.tree_sortkey and
                   tree_right(ci2.tree_sortkey)
        and ci2.item_id=:root_folder_id
        and ci1.item_id=cf.folder_id
        and ao.object_id=cf.folder_id

       
</querytext>
</fullquery>
</queryset>
