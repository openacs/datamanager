ad_page_contract {
} -query {
} -properties {
}
set context {}
set community_id [dotlrn_community::get_community_id]

set user_id [ad_conn user_id]
set is_admin [acs_user::site_wide_admin_p -user_id $user_id ]
if {$is_admin == 1} {
        ad_returnredirect "admin/index"
}

#only administrator or professor must be allowed to enter this page
dotlrn::require_user_admin_community  -community_id $community_id

# prevent this page from being called when not in a community
# (i.e. the main dotlrn instance
if {[empty_string_p $community_id]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set supported_types_list {Assessments Faqs Forums Folders News Static-Portlet}
set next_url manage-object

