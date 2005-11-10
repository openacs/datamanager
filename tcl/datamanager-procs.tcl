ad_library {
    TCL library for the datamanager system

    @author Luis de la Fuente (lfuente@it.uc3m.es)
    @creation-date 14 June 2005
}
 
namespace eval datamanager {

# ejemplo de uso de ad_proc    
#    ad_proc -public add_self_to_page {
#	{-portal_id:required}
#	{-package_id:required}
#    } {
#	Adds a static PE to the given page
#    } {
#        ns_log notice "static_portlet::add_self_to_page - Don't call me. Use static_portal_content:: instead"
#        error
#    }

    ad_proc -public get_object_type {
        -object_id:required
    } {
        Get the selected object's type
    } { 
        db_1row get_object_type {}
        return $object_type
    }

    ad_proc -public get_object_data {
        -object_type:required
        -object_id:required
    } {
        Get data concerned about the object with which datamanager is working
    } {
        switch $object_type {
            "faq" {
                #get faq data
                db_1row get_data_faq {}
                set object_url use-dotlrn_faq
                set object_type dotlrn_faq
            }
            "forums_forum" {
                db_1row get_data_forum {}
                set object_url use-dotlrn_forums
                set object_type dotlrn_forums  
            }
            "news" {

                db_1row get_data_news {}
                set object_url use-dotlrn_news
                set object_type dotlrn_news  
            }
            "static_portal_content" {
                #
                db_1row get_data_static_portal {}
                set object_url use-dotlrn_static
                set object_type dotlrn_static
            }
            "as_assessments" {
                #
                db_1row get_data_assessment {}
                set object_url use-dotlrn_assessment
                set object_type dotlrn_assessment
            }
            "content_folder" {
                #
                db_1row get_data_folder {}
                set object_url use-dotlrn_fs
                set object_type dotlrn_fs
            }

            default {
                set object_name "[_ datamanager._Not]"
                set object_url ""
                set object_type ""                  
            }
        }
        set object_data [list $object_name $object_url $object_type]
        return $object_data
    }
    

    ad_proc -public get_available_communities {
        -object_type:required
        -bulk_action_export_vars
        -mode_list
        -communities_classes
        -department_key
        {-action_type "move"}
         } {
             Get the list of communities, subgroups or classes where an object can be moved
         } {

set copy_url [join [list use $object_type] "-"]

if {$action_type eq "move"} {
    set bulk_actions {}
    set bulk_action_export_vars {}
    set actions {}
    set elements {
                    selected {
                        label {[_ datamanager.Selected]}
                        display_template {
                        <input name="dest_community_id" value="@communities.dest_community_id@" type="radio">
                        }
                    }
                    dest_community_id {
                        hide_p 1
                    }
                    
                    community_type {
                        label {[_ datamanager.Type]}
                        display_col type
                    }
                    community_name {
                        label {[_ datamanager.Name]}
                        display_col name
                    }
                    }
} else {
    set bulk_actions [list Copy $copy_url {Copy chequed objects}]
    set actions $mode_list
    set elements {
                    dest_community_id {
                        hide_p 1
                    }
                    
                    community_type {
                        label {[_ datamanager.Type]}
                        display_col type
                    }
                    community_name {
                        label {[_ datamanager.Name]}
                        display_col name
                    }
                    }
}

set my_bulk_action_export_vars [list]
foreach element $bulk_action_export_vars {

    set [lindex $element 0] [lindex $element 1]

    lappend my_bulk_action_export_vars [lindex $element 0]
}
set action $action_type

ns_log Notice "my bulk action export vars : $my_bulk_action_export_vars"
ns_log Notice "action: $action"
                set available_name [join [list "available" $communities_classes] "_"]
#create the template_list
            template::list::create \
                -name $available_name \
                -multirow communities \
                -key dest_community_id \
                -actions $actions\
                -bulk_actions $bulk_actions \
                -bulk_action_export_vars [concat $my_bulk_action_export_vars action]\
                -elements $elements
                          
#                set comm_id [dotlrn_community::get_community_id]
#
#                set communities_list  [db_list get_list_of_dest_communities {}]
#                set communities_list_p [list]
#                
#                foreach community $communities_list {
#                    if { [dotlrn::user_can_admin_community_p -community_id $community] } {
#                        lappend communities_list_p $community
#                    }                     
#                }

set comm_id [dotlrn_community::get_community_id]

if {$communities_classes eq "communities"} {
 
        set communities_list  [db_list get_list_of_dest_communities {}]
        set communities_list_p [list]

        foreach community $communities_list {
            if { [dotlrn::user_can_admin_community_p -community_id $community] } {
                lappend communities_list_p $community
            }
        }
} elseif {$communities_classes eq "classes"} {
        if { $department_key eq "all" } {
             set communities_list  [db_list get_list_of_all_dest_classes {}]           
        } else {
            set communities_list  [db_list get_list_of_dest_classes {}]
        }
        set communities_list_p [list]

        foreach community $communities_list {
            if { [dotlrn::user_can_admin_community_p -community_id $community] } {
                lappend communities_list_p $community
            }
        }
}

if  {[llength $communities_list_p] eq 0 } {
    set communities_list_p [list 0] 
}
                db_multirow -extend { type } communities get_data_communities {} {

                if {$community_type == "dotlrn_club"} {
                    set type "[_ datamanager.Community]"
                } elseif {$community_type == "dotlrn_community"} {
                    db_1row get_parent_community_id {}
                    set type "[_ datamanager.Subgroup_of]"
                    append type $pretty_name
                } else  {         
                    set type "[_ datamanager.Class]"
                }
            } if_no_rows { }

                return [list $available_name ]
         }



    
    ad_proc -public get_trash_id {
    } {
        Get the trash identifier 
    } { 
        db_1row get_id {}
        return $trash_id
    }

    ad_proc -public get_trash_package_id {
        {-community_id}
    } {
        Get the trash packageidentifier 
    } { 

        if {[info exist community_id] == 0 } {
           set community_id [dotlrn_community::get_community_id]
        }         
        
        db_1row get_package_id {}
        return $trash_package_id
    }   
}
