ad_page_contract {
    Show the list of datamanager supported objects
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
} -properties {
}
set context [list]
set community_id [dotlrn_community::get_community_id]


#only administrator or professor must be allowed to enter this page
dotlrn::require_user_admin_community  -community_id $community_id


# prevent this page from being called when not in a community
# (i.e. the main dotlrn instance
if {[empty_string_p $community_id]} {
    ad_returnredirect "[dotlrn::get_url]"
}

db_1row datamanager::select_folder_package_id {}
set root_folder_id [fs::get_root_folder -package_id $package_id]

set supported_types_list {Assessments Faqs Forums Folders News Static-Portlet}
set next_url select-objects

