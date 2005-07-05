ad_library {
    TCL library for the datamanager system

    @author YYY ZZZ (YYY.ZZZ@xx.yy)
    @creation-date 14 June 2005
}
 
namespace eval datamanager {}

ad_proc -public datamanager::user_wasted_size {
    {-user_id ""}
} {
    Returns the global datamanager usage of user_id user
} {
   db_1row get_datamanager "select coalesce (sum(content_length),0) as wasted_size_datamanager from cr_revisions where item_id in (select item_id from cr_items where item_id in (select object_id from acs_objects where object_type = 'content_item' and (creation_user = :user_id or modifying_user = :user_id)))"
   return [expr $wasted_size_datamanager / 1024]
}

ad_proc -public datamanager::user_wasted_filenumber {
    {-user_id ""}
} {
    Returns the global file number usage of user_id user
} {
   db_1row get_num_files "select count(content_length) as wasted_filenumber_datamanager from cr_revisions where item_id in (select item_id from cr_items where item_id in (select object_id from acs_objects where object_type = 'content_item' and (creation_user = :user_id or modifying_user = :user_id)))"
   return $wasted_filenumber_datamanager
}

ad_proc -public datamanager::max_user_wasted_size {
} {
    Returns the parameter max global size datamanager usage for one user
} {
   return [expr 20971520 / 1024]
}

ad_proc -public datamanager::max_user_wasted_filenumber {
} {
    Returns the parameter max global file number usage for one user
} {
   return 1000
}

ad_proc -public datamanager::user_member_groups {
    {-user_id ""}
} {
    Returns the classes for user_id user
} {
  return [db_list select_member_classes {}]
}

