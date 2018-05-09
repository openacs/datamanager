ad_page_contract {
} -query {
} -properties {
}
set context [list]
set community_id [dotlrn_community::get_community_id]

#dotlrn::require_user_admin_community  -community_id $community_id

#only dotlrn administrator must be allowed to enter this page
dotlrn::require_admin


# prevent this page from being called when not in a community
# (i.e. the main dotlrn instance)
if {[empty_string_p $community_id]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set supported_types_list {Assessments Faqs Forums Folders News Static-Portlet}
set next_url "../manage-object"

