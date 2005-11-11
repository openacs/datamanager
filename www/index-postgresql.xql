<?xml version="1.0"?>
<queryset>

<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="datamanager::select_folder_package_id">
<querytext>
    SELECT package_id 
    FROM dotlrn_community_applets 
    WHERE applet_id=(select applet_id from dotlrn_applets where applet_key='dotlrn_fs') and community_id=:community_id;
</querytext>
</fullquery>


</queryset>
