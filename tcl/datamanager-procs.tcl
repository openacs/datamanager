ad_library {
    TCL library for the datamanager system
    @author Luis de la Fuente (lfuente@it.uc3m.es)
    @creation-date 14 June 2005
}


namespace eval datamanager {


ad_proc randazAZchar {} {
} {
   return [format %c [expr {int(rand() * 26) + [expr {int(rand() * 10) > 5 ? 97 : 65}]}]]
}

ad_proc randazAZstring {length} {
} {
   set s {}
   for {set i $length} {$i > 0} {incr i -1} {append s [randazAZchar]}
   return $s
}

ad_proc -public tmpfn {} {
} {
   set prefix "/tmp/export"
   set seconds [clock seconds]
   set suffix [randazAZstring 5]
   set tmp [format "%s_%s_%s" $prefix $seconds $suffix]
   return $tmp
}



        # Get the data type
    ad_proc -public get_object_type {
        -object_id:required
    } {
        Get the selected object_s type
    } { 
        db_1row get_object_type {}
        return $object_type
    }
        
        # Get the child object_id
        ad_proc -public get_child_object_id {
        -object_id:required
                -object_type:required
    } {
        Get the selected object_s type
    } { 
        set its_ok [db_0or1row get_child_object_type { *SQL* }]
                if {$its_ok} {
                        return $oid
                } else {
                    return 0
                }
    }
        
        # Get the object_data
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
                db_1row get_data_static_portal {}
                set object_url use-dotlrn_static
                set object_type dotlrn_static
            }
            "as_assessments" {
                db_1row get_data_assessment {}
                set object_url use-dotlrn_assessment
                set object_type dotlrn_assessment
            }
            "content_folder" {
                db_1row get_data_folder {}
                set object_url use-dotlrn_fs
                set object_type dotlrn_fs
            }
                        "pa_album" {
                                db_1row get_data_album {}
                                set object_url use-dotlrn-photo-album
                                set object_type dotlrn_photo_album
                        }
                        
                        "dotlrn_club" {
                                db_1row get_data_dotlrn_club {}
                                set object_url use-dotlrn-club
                                set object_type dotlrn_club
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

        # get available communities
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
        set user_id  [ad_conn user_id]
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
            set bulk_actions [list Copy $copy_url {#datamanager.Copy_checked_items#}]
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

        set comm_id [dotlrn_community::get_community_id]
        if {$communities_classes eq "communities"} {
                set communities_list_p  [db_list get_list_of_dest_communities {}]

        } elseif {$communities_classes eq "classes"} {
                if { $department_key eq "all" } {
                     set communities_list_p  [db_list get_list_of_all_dest_classes {}]
                } else {
                    set communities_list_p  [db_list get_list_of_dest_classes {}]
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

        if {[info exists community_id] == 0 } {
           set community_id [dotlrn_community::get_community_id]
        }
        db_1row get_package_id {}
        return $trash_package_id
    }

ad_proc -public get_username_id {
        {-username}
    } {
        Get the user_id from username 
    } { 
        if {[db_0or1row get_username_id {}] == 0} {
                   return -300 
                } else {
                   return $user_id
                }                               
    }

ad_proc -public get_forum_package_id {
        {-community_id}
    } {
        Get forums package_id for the community_id
    } { 
        db_1row get_forum_package_id {}
        return $pid
    }

ad_proc -public get_new_package_id {
        {-community_id}
    } {
        Get new package_id for the community_id
    } { 
        db_1row get_new_package_id {}
        return $pid
    }
        
ad_proc -public get_faq_package_id {
        {-community_id}
    } {
        Get faq package_id for the community_id
    } { 
        if {[db_0or1row get_faq_package_id {}] == 0} {
                   return -300 
                } else {
                   return $pid
                }
    }
        
}
        

