ad_page_contract {
    Show the list of communities where an object can be moved 
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
    object_id:integer,notnull
} -properties {
}

set context [list [_ datamanager.Object_Move]]
set title "[_ datamanager.Choose_Destination]"    

#get object type
db_1row datamanager::get_object_type {}



switch $object_type {
    "faq" {
        #get faq data
        db_1row datamanager::get_data_faq {}
        set move_object_url move-faq
        set object_type dotlrn_faq
    }
    "forums_forum" {
        db_1row datamanager::get_data_forum {}
        set move_object_url move-forum
        set object_type dotlrn_forums  
    }
    "news" {
        #
        db_1row datamanager::get_data_news {}
        set move_object_url move-news
        set object_type dotlrn_news  
    }
    "static_portal_content" {
        #
        db_1row datamanager::get_data_static_portal {}
        set move_object_url move-static-portlet
        set object_type dotlrn_static
    }
    "as_assessments" {
        #
        db_1row datamanager::get_data_assessment {}
        set move_object_url move-assessment
        set object_type dotlrn_assessment
    }
    "content_folder" {
        #
        db_1row datamanager::get_data_folder {}
        set move_object_url move-folder
        set object_type dotlrn_fs
    }

    default {
        set object_name "[_ datamanager._Not]"
    }
}



template::list::create \
    -name available_communities \
    -multirow communities \
    -key community_id \
    -elements {
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
              
    set comm_id [dotlrn_community::get_community_id]
    
    db_multirow -extend { type } communities datamanager::get_data_communities {} {
    if {$community_type == "dotlrn_club"} {
        set type "[_ datamanager.Community]"
    } elseif {$community_type == "dotlrn_community"} {
        db_1row datamanager::get_parent_community_id {}
        set type "[_ datamanager.Subgroup_of]"
    	append type $pretty_name
    } else  {         
        set type "[_ datamanager.Class]"
    }
}
