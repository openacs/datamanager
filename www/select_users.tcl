ad_page_contract {
} -query {
        {mode:optional ""}
        {all_users:optional}
        {several_users:optional}
        {one_user:optional}
        {object_id:multiple optional}
        
} -properties {
}


if {$mode eq "one_user"} {
        set ctrl [db_0or1row get_one_user "select user_id from users where username ='$one_user' "]     
        set object_id $user_id
        ad_returnredirect "one-object-export?object_id=$object_id"      
        
} elseif {$mode eq "several_users"} {
        set object_id [db_list get_user_list "select user_id from users where username like '$several_users%'"]
        set num [llength $object_id]
        ad_returnredirect "one-object-export?object_id=$object_id"
        
} elseif {$mode eq "all_users"} {
        set object_id [db_list get_all_user_list "select user_id from users"]
        ad_returnredirect "one-object-export?object_id=$object_id"
} else {
set mode "view"
}


