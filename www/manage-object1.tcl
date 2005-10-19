ad_page_contract {
    Show the list of objects to move or copy
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-10-17
    
} -query {
    object_type
} -properties {
}

set query_name [join [list select $object_type] "_"]
ns_log Notice "query_name: $query_name"


  template::list::create\
      -name usable_objects \
      -multirow usable_objects\
      -key object_id\
      -bulk_actions { Move one-object-move {Move Checked Items } Copy one-object-copy {Copy Checked Items} }\
      -elements {
        object_name {
            label "Name"
        }
        creation_user {
            label "Creation user"
        }
        creation_date {
            label "Creation date"
        }
   }
    db_multirow -extend { item_url } usable_objects select_assessment {
    SELECT ao1.title as object_name,
           ao1.object_id,
           us1.username as creation_user,
           ao1.creation_date
    FROM acs_objects as ao1,
         users as us1
    WHERE us1.user_id=ao1.creation_user and
          ao1.object_id in
                (SELECT coalesce(live_revision,latest_revision)
                 FROM cr_items 
                 WHERE item_id in 
                    (SELECT item_id 
                    FROM  cr_revisions 
                    WHERE revision_id in 
                       (SELECT ao.object_id
                        FROM dotlrn_community_applets as dca,
                             dotlrn_applets as da,
                             acs_objects as ao 
                        WHERE dca.applet_id=da.applet_id
                              and da.applet_key='dotlrn_assessment'
                              and ao.package_id=dca.package_id 
                              and ao.object_type='as_assessments')
                  group by item_id)) 
    } {
        set item_url [export_vars -base "item" { object_id }]
    }






#template::list::create -name usable_objects  -multirow usable_objects -elements {
#        name {
#            label {[_ datamanager.Name]]}
#        }
#        creation_date {
#            label "Creation date"            
#        }        
#    }
#
#
#db_multirow usable_objects select_assessment {
#    SELECT ao1.title,ao1.object_id,ao1.creation_date
#    FROM acs_objects as ao1,
#         users as us1
#    WHERE us1.user_id=ao1.creation_user and
#          ao1.object_id in 
#                (SELECT coalesce(live_revision,latest_revision)
#                 FROM cr_items 
#                 WHERE item_id in 
#                    (SELECT item_id 
#                    FROM  cr_revisions 
#                    WHERE revision_id in 
#                       (SELECT ao.object_id
#                        FROM dotlrn_community_applets as dca,
#                             dotlrn_applets as da,
#                             acs_objects as ao 
#                        WHERE dca.applet_id=da.applet_id
#                              and da.applet_key='dotlrn_assessment'
#                              and ao.package_id=dca.package_id 
#                              and ao.object_type='as_assessments')
##                  group by item_id)) } 
