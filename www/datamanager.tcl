
ad_page_contract {
} -query {
}

# prevent this page from being called when not in a community
# (i.e. the main dotlrn instance
if {[empty_string_p [dotlrn_community::get_community_id]]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set context [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.Manage_Members]]
set community_id [dotlrn_community::get_community_id]
set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id [ad_get_user_id] -community_id $community_id]
set spam_p [dotlrn::user_can_spam_community_p -user_id [ad_get_user_id] -community_id $community_id]
set return_url "[ns_conn url]?[ns_conn query]"

# get the colors from the params
set table_border_color [parameter::get -parameter table_border_color]
set table_bgcolor [parameter::get -parameter table_bgcolor]
set table_other_bgcolor [parameter::get -parameter table_other_bgcolor]

set actions [list]

template::list::create \
    -name objects \
    -actions $actions \
    -no_data [_ objects.No_Objects] \
    -elements {
        name {
            label {\#datamanager.Object_Name\#}
            link_url_col forum_view_url
            display_template {@forums.name@ }
        }
        charter {
            label {\#forums.Charter\#}
	    display_template {@forums.charter;noquote@}
        }
        n_threads {
            label {\#forums.Threads\#}
            display_col n_threads_pretty
            html { align right }
        }
        last_post {
            label {\#forums.Last_Post\#}
            display_col last_modified_pretty
        }
	statistic {
	    label {\#forums.Statistics\#}
	    link_url_col forum_view_statistic
	    display_col statistic
	}
    }


