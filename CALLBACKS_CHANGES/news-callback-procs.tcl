ad_library {
    callback routines for faq package 
    @author Luis de la Fuente (lfuente@it.uc3m.es)
    @creation_date 2005-07-08
}


ad_proc -public -callback datamanager::copy_new -impl datamanager {
     -object_id:required
     -selected_community:required
         -sufix $sufix
} {
    Copy a new to another class or community
} {
#get environment data
    set package_id [news_get_package_id -community_id $selected_community]

#get the revision's data

    set news_revisions_list [db_list_of_lists get_news_revisions_data {}]
    set news_revisions_number [llength $news_revisions_list]    
#do the first revision    
    set present_object_id [lindex [lindex $news_revisions_list 0] 0]
    db_1row get_news_data {}    
    set publish_date_ansi  [lindex [lindex $news_revisions_list 0] 1]
    set publish_body  [lindex [lindex $news_revisions_list 0] 2]   
    set mime_type     [lindex [lindex $news_revisions_list 0] 3]  
    set publish_title [lindex [lindex $news_revisions_list 0] 4]     


    set live_revision_p "t"
        append publish_title "_" $sufix
#create the new
    set news_id [news_create_new -publish_body $publish_body \
                                 -publish_title $publish_title \
                                 -publish_date_ansi $publish_date_ansi \
                                 -mime_type $mime_type \
                                 -package_id $package_id \
                                 -archive_date_ansi $archive_date_ansi \
                                 -approval_user $approval_user \
                                 -approval_date $approval_date \
                                 -approval_ip $approval_ip \
                                 -creation_ip $creation_ip \
                                 -user_id $user_id \
                                 -live_revision_p $live_revision_p ]

                                                                 
                                                                 

#if there are revisions, they are included here   
    for {set i 1} {$i < $news_revisions_number} {incr i} {
 
        set present_object_id [lindex [lindex $news_revisions_list $i] 0]
        db_1row get_news_data {}       
        db_1row get_present_new_item {}       

        set publish_date_ansi  [lindex [lindex $news_revisions_list $i] 1]
        set publish_body  [lindex [lindex $news_revisions_list $i] 2]   
        set mime_type     [lindex [lindex $news_revisions_list $i] 3]  
        set publish_title [lindex [lindex $news_revisions_list $i] 4]         
                append publish_title "_" $sufix
        set revision_log [lindex [lindex $news_revisions_list $i] 5]        
#        db_1row get_live_revision {}           
#        if {$live_revision == $present_object_id} {
#            set active_revision_p "t"    
#        } else {
#            set active_revision_p "f"
#        }                       
set active_revision_p "t"    

     db_exec_plsql create_news_item_revision {}
    }  
#does the new includes images?


return $news_id    
}



ad_proc -public -callback datamanager::export_new -impl datamanager {
     -object_id:required
} {
    Export a new
} {

        
        
        #get environment data
    #set package_id [news_get_package_id -community_id $selected_community]

        #get the revision
        db_0or1row get_live_revision {* SQL *}
        if {$live_revision > 0} {
        
        set lista [list []]
        set object_id $live_revision    
        
        
        lappend lista "<new>"
    db_1row get_news_revisions_data {* SQL *}
    db_1row get_news_data {* SQL *}
        
        
        set user_id $approval_user
        set ctrl [db_0or1row get_username {* SQL *}]
        if {$ctrl ne 0} {
                set approval_user $username
        } else {
                set approval_user ""
        }
        
        set user_id $creation_user
        set ctrl [db_0or1row get_username {* SQL *}]
        if {$ctrl ne 0} {
                set creation_user $username
        } else {
                set creation_user ""
        }
        

        
        set live_revision_p "t"
        
    lappend lista "<publish_title texttype=\"text/html\"><!\[CDATA\[$publish_title\]\]></publish_title>"    
        lappend lista "<publish_body texttype=\"text/html\"><!\[CDATA\[$publish_body\]\]></publish_body>"
    lappend lista "<publish_date><!\[CDATA\[$publish_date\]\]></publish_date>"    
    lappend lista "<mime_type><!\[CDATA\[$mime_type\]\]></mime_type>"    
    lappend lista "<archive_date_ansi><!\[CDATA\[$archive_date_ansi\]\]></archive_date_ansi>"    
    lappend lista "<approval_user><!\[CDATA\[$approval_user\]\]></approval_user>"    
    lappend lista "<approval_date><!\[CDATA\[$approval_date\]\]></approval_date>"    
    lappend lista "<approval_ip><!\[CDATA\[$approval_ip\]\]></approval_ip>"    
    lappend lista "<creation_ip><!\[CDATA\[$creation_ip\]\]></creation_ip>"
    lappend lista "<creation_user><!\[CDATA\[$creation_user\]\]></creation_user>"
    lappend lista "<live_revision_p><!\[CDATA\[$live_revision_p\]\]></live_revision_p>"
        
  lappend lista "</new>"
  return $lista
  } 
}
