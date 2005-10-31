ad_page_contract {
    Show the list of objects to move or copy
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-10-17
    
} -query {
    object_type
} -properties {
}

set community_id [dotlrn_community::get_community_id]
set query_name [join [list select $object_type] "_"]

if { $object_type eq "folder" } {
   set display_template {<div style="text-indent: @usable_objects.level_num@em;">@usable_objects.object_name@</div>}
   db_1row select_folder_package_id {}
   set root_folder_id [fs::get_root_folder -package_id $package_id]
} else { 
   set display_template {}
}

  template::list::create\
      -name usable_objects \
      -multirow usable_objects\
      -key object_id\
      -bulk_actions { Move one-object-move {Move Checked Items} Copy one-object-copy {Copy Checked Items} }\
      -elements {
        object_name {
            label "Name"
            display_template $display_template
        }
        creation_user {
            label "Creation user"
        }
        creation_date {
            label "Creation date"
        }
   }
    db_multirow -extend { item_url } usable_objects $query_name {} {
        set item_url [export_vars -base "item" { object_id }]
    }

