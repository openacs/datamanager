ad_library {
} 

ad_proc -public -callback datamanager::move_faq {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_faq {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
}

ad_proc -public -callback datamanager::delete_faq {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_faq {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::move_forum {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_forum {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
}


ad_proc -public -callback datamanager::copy_forums {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
}

ad_proc -public -callback datamanager::delete_forum {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_forum {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_forums {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::move_new {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_new {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
}

ad_proc -public -callback datamanager::delete_new {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_new {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::move_static {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_static {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
}

ad_proc -public -callback datamanager::delete_static {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_static {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::move_assessment {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_assessment {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
}

ad_proc -public -callback datamanager::delete_assessment {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_assessment {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::move_folder {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_folder {
     -object_id:required
     -selected_community:required
     {-mode: "both"}
} {
}

ad_proc -public -callback datamanager::delete_folder {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_folder {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::move_album {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_album {
     -object_id:required
     -selected_community:required
     {-mode: "both"}
} {
}

ad_proc -public -callback datamanager::delete_album {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_album {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_dotlrn_club {
     -object_id:required
} {
}

ad_proc -public -callback datamanager::export_acs_user {
     -object_id:required
} {
}

##############################################
# EXPORTACIO D'USUARIS
##############################################
ad_proc -public -callback datamanager::export_acs_user -impl datamanager {
     -object_id:required
} {
        Export users
} {
        set user_id $object_id
        set lista [list []]
        if {![db_0or1row select_user_info {*SQL*}]} {
        } else {
        set bio ""
        set photo ""
        lappend lista "<user>"
        db_0or1row select_user_bio {*SQL*}

        lappend lista "<username><!\[CDATA\[$username\]\]></username>"  
        lappend lista "<email texttype=\"text/html\"><!\[CDATA\[$email\]\]></email>"
    lappend lista "<first_names texttype=\"text/html\"><!\[CDATA\[$first_names\]\]></first_names>"    
    lappend lista "<last_name><!\[CDATA\[$last_name\]\]></last_name>"    
    lappend lista "<password><!\[CDATA\[$password\]\]></password>"    
    lappend lista "<salt><!\[CDATA\[$salt\]\]></salt>"    
    lappend lista "<screen_name><!\[CDATA\[$screen_name\]\]></screen_name>"    
    lappend lista "<url><!\[CDATA\[$url\]\]></url>"    
    lappend lista "<auth><!\[CDATA\[$auth\]\]></auth>"    
    lappend lista "<usr_type><!\[CDATA\[$usr_type\]\]></usr_type>"    
    lappend lista "<bio><!\[CDATA\[$bio\]\]></bio>"    
        
        ####
        ## Getting the photo
        ####
        
        # get the live revision id of the user portrait
        if {![db_0or1row select_user_photo_revision {*SQL*}]} {
                set photo ""
                set mime_type ""                
        } else {
        
                # guardamos la foto en el directorio temporal con nobre username
                set file "/tmp/${username}_dec"
                # set file2 "/tmp/${username}_enc"
                #db_blob_get_file write_lob_content get_lob_id {*SQL*} -file $file
                db_blob_get_file write_lob_content  {*SQL*} -file $file
                
                # Recuperamos la foto
                set fd [open $file r] ; fconfigure $fd -encoding binary -translation lf; set photo_data [read $fd] ; close $fd
                set photo [base64::encode $photo_data]
                # Esto no hace falta. solo era para comprobar que se codifica bien.
                # set fd2 [open $file2 w] ; fconfigure $fd2 -encoding binary -translation lf; puts -nonewline $fd2 $photo; close $fd2
                set mime_type [db_string get_mime_type "select mime_type from cr_revisions where revision_id = :revision_id"]                   
                # aquí borramos la imagen temporal
                file delete $file
                
        }
                
    lappend lista "<photo><!\[CDATA\[$photo\]\]></photo>"
    lappend lista "<mime_type><!\[CDATA\[$mime_type\]\]></mime_type>"        


        lappend lista "</user>"
        return $lista
}
}




##############################################
# EXPORTACIÓ DE COMMUNITATS
##############################################
        ad_proc -public -callback datamanager::export_dotlrn_club -impl datamanager {   
     -object_id:required
        } {
                Export a community
        } {
        
  
  set lista [list []]
  db_1row select_dotlrn_club {}
  lappend lista "<club>"
  lappend lista "<name texttype=\"text/html\"><!\[CDATA\[$name\]\]></name>"
  lappend lista "<description texttype=\"text/html\"><!\[CDATA\[$description\]\]></description>"  
  set community_id $object_id
  
  # MEMBERS
  set l_members [db_list_of_lists get_id_members_list {*SQL*}]
  set n_members [llength $l_members] 
  
  for {set i 0} {$i < $n_members} {incr i} {
    set username [lindex [lindex $l_members $i] 1]
    set authority_id [lindex [lindex $l_members $i] 2]
        set auth [db_string get_auth "select short_name from auth_authorities where authority_id = :authority_id" -default "0"]
    set rel_type [lindex [lindex $l_members $i] 3]
        lappend lista "<member>"
        lappend lista "<username texttype=\"text/html\"><!\[CDATA\[$username\]\]></username>"
        lappend lista "<auth texttype=\"text/html\"><!\[CDATA\[$auth\]\]></auth>"
        lappend lista "<rel_type texttype=\"text/html\"><!\[CDATA\[$rel_type\]\]></rel_type>"
        lappend lista "</member>"
  }
  
  # STATIC PORTLETS
  set l_portlets [db_list get_portlets_id {*SQL*}]
  set n_portlets [llength $l_portlets] 
  set l_aux [list]
  for {set i 0} {$i < $n_portlets} {incr i} {
        set portlet_id [lindex $l_portlets $i]
        lappend lista [join [lindex [callback datamanager::export_static -object_id $portlet_id] 0] "\n"]
  }

   # NEWS
  set pid [datamanager::get_new_package_id -community_id $object_id]
  set l_news [db_list get_news_id {*SQL*}]      
  set n_news [llength $l_news] 
  set l_aux [list]
  for {set i 0} {$i < $n_news} {incr i} {
        set new_id [lindex $l_news $i]
        lappend lista [join [lindex [callback datamanager::export_new -object_id $new_id] 0] "\n"]
  }
        
        # FAQS
        set pid [datamanager::get_faq_package_id -community_id $object_id]
        set l_faqs [db_list get_faqs_id {*SQL*}]      
        set n_faqs [llength $l_faqs] 
        set l_aux [list]
        for {set i 0} {$i < $n_faqs} {incr i} {
                set faq_id [lindex $l_faqs $i]
                lappend lista [join [lindex [callback datamanager::export_faq -object_id $faq_id] 0] "\n"]
        }       
        
        # FORUMS
        set pid [datamanager::get_forum_package_id -community_id $object_id]
        set l_forums [db_list get_forums_id {*SQL*}]      
        set n_forums [llength $l_forums] 
        set l_aux [list]
        for {set i 0} {$i < $n_forums} {incr i} {
                set forum_id [lindex $l_forums $i]
                lappend lista [join [lindex [callback datamanager::export_forums -object_id $forum_id] 0] "\n"]
        }       
        
        
   lappend lista "</club>"
   return $lista
   }
   

