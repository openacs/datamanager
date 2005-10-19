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
                set object_url use-faq
                set object_type dotlrn_faq
            }
            "forums_forum" {
                db_1row get_data_forum {}
                set object_url use-forum
                set object_type dotlrn_forums  
            }
            "news" {

                db_1row get_data_news {}
                set object_url use-news
                set object_type dotlrn_news  
            }
            "static_portal_content" {
                #
                db_1row get_data_static_portal {}
                set object_url use-static-portlet
                set object_type dotlrn_static
            }
            "as_assessments" {
                #
                db_1row get_data_assessment {}
                set object_url use-assessment
                set object_type dotlrn_assessment
            }
            "content_folder" {
                #
                db_1row get_data_folder {}
                set object_url use-folder
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
        {-action_type "move"}
         } {
             Get the list of communities, subgroups or classes where an object can be moved
         } {



if {$action_type eq "move"} {
    set bulk_actions {}
    set elements {
                    selected {
                        label {[_ datamanager.Selected]}
                        display_template {
                        <input name="selected_community" value="@communities.community_id@" type="radio">
                        }
                    }
                    community_id {
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
    set bulk_actions {Copy do-it {Copy cheched objects}}
    set elements {
                    community_id {
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


 



             
#create the template_list
            template::list::create \
                -name available_communities \
                -multirow communities \
                -key community_id \
                -bulk_actions $bulk_actions \
                -elements $elements
                          
                set comm_id [dotlrn_community::get_community_id]

                set communities_list  [db_list get_list_of_dest_communities {}]
                set communities_list_p [list]
                
                foreach community $communities_list {
                    if { [dotlrn::user_can_admin_community_p -community_id $community] } {
                        lappend communities_list_p $community
                    }                     
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
            }

                return available_communities
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
