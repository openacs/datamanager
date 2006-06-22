ad_page_contract {
} -query {
  {mode:optional ""}
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

set user_id [ad_conn user_id]
set is_admin [acs_user::site_wide_admin_p -user_id $user_id ]

set next_url "import2"
set return_url "index"

if {$is_admin == 1} {
        if {$mode eq "user"} {
                set next_url "admin/import-users"
                set return_url "admin/index"
        } elseif {$mode eq "comm"} {
                set next_url "admin/import-communities"
                set return_url "admin/index"
        } else {
                set return_url "admin/index"
        }
}



