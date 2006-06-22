ad_library {
}

ad_proc -public -callback navigation::package_admin -impl forums {} {
    return the admin actions for the forum package.
} {
    set actions {}

    # Check for admin on the package...
    if {[permission::permission_p -object_id $package_id -privilege admin -party_id $user_id]} {
        lappend actions [list LINK admin/ [_ acs-kernel.common_Administration] {} [_ forums.Admin_for_all]]

        lappend actions [list LINK \
                             [export_vars -base admin/permissions {{object_id $package_id}}] \
                             [_ acs-kernel.common_Permissions] {} [_ forums.Permissions_for_all]]
        lappend  actions [list LINK admin/forum-new [_ forums.Create_a_New_Forum] {} {}]
    }

    # check for admin on the individual forums.
    db_foreach forums {
        select forum_id, name, enabled_p
        from forums_forums
        where package_id = :package_id
        and exists (select 1 from acs_object_party_privilege_map pm
                    where pm.object_id = forum_id
                    and pm.party_id = :user_id
                    and pm.privilege = 'admin')
    } {
        lappend actions [list SECTION "Forum $name ([ad_decode $enabled_p t [_ forums.enabled] [_ forums.disabled]])" {}]

        lappend actions [list LINK [export_vars -base admin/forum-edit forum_id] \
                             [_ forums.Edit_forum_name] {} {}]
        lappend actions [list LINK [export_vars -base admin/permissions {{object_id $forum_id} return_url}] \
                             [_ forums.Permission_forum_name] {} {}]
    }
    return $actions
}


ad_proc -callback merge::MergeShowUserInfo -impl forums {
    -user_id:required
} {
    Merge the *forums* of two users.
    The from_user_id is the user_id of the user
    that will be deleted and all the *forums*
    of this user will be mapped to the to_user_id.
    
} {
    set msg "Forums items of $user_id"
    set result [list $msg]
    
    set last_poster [db_list_of_lists sel_poster {*SQL*} ]
    set msg "Last Poster of $last_poster"
    lappend result $msg

    set poster [db_list_of_lists sel_user_id {*SQL*} ]
    set msg "Poster of $poster"
    lappend result $msg

    return $result
}

ad_proc -callback merge::MergePackageUser -impl forums {
    -from_user_id:required
    -to_user_id:required
} {
    Merge the *forums* of two users.
    The from_user_id is the user_id of the user
    that will be deleted and all the *forums*
    of this user will be mapped to the to_user_id.
    
} {
    set msg "Merging forums" 
    set result [list $msg]
    
    db_dml upd_poster { *SQL* }
    db_dml upd_user_id { *SQL* }

    lappend result "Merge of forums is done"

    return $result
}

ad_proc -public -callback datamanager::move_forum -impl datamanager {
     -object_id:required
     -selected_community:required
} {
    Move a forum to another class or community
} {

  #get the new_package_id
  set new_package_id [datamanager::get_forum_package_id -community_id $selected_community]   

  #update forums_forums table
  db_dml update_forums {}
  #update acs_objects table (because data redundancy)
  db_dml update_forums_acs_objects {}
}

ad_proc -public -callback datamanager::delete_forum -impl datamanager {
     -object_id:required
} {
    Move a forum to the trash
} {

  #get trash_id
  set trash_package_id [datamanager::get_trash_package_id]    

  #update forums_forums table
  db_dml del_update_forums {}
  #update acs_objects table (because data redundancy)
  db_dml del_update_forums_acs_objects {}
}

ad_proc -public -callback datamanager::copy_forum -impl datamanager {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
    Copy a forum to another class or community
} {
  #get forum's data
  set forum_id [db_nextval acs_object_id_seq]   
  set package_id [datamanager::get_forum_package_id -community_id $selected_community]
  db_1row get_forum_data {}
    
  set newname "$name$sufix"  
  #create the new forums
  set forum_id [forum::new -forum_id $forum_id \
      -name $newname \
      -charter $charter \
      -presentation_type $presentation_type \
      -posting_policy $posting_policy \
      -package_id $package_id \
  ]

  set first_messages_list [db_list_of_lists get_first_messages_list {}]      
  set first_messages_number [llength $first_messages_list]  
  
  for {set i 0} {$i < $first_messages_number} {incr i} {
    set message_id  [db_nextval acs_object_id_seq]
    set subject [lindex [lindex $first_messages_list $i] 0]
    set content [lindex [lindex $first_messages_list $i] 1]
    set user_id [lindex [lindex $first_messages_list $i] 2]
    set formato [lindex [lindex $first_messages_list $i] 3]
    set parent_id [lindex [lindex $first_messages_list $i] 4]
  
    set message_id [forum::message::new \
        -forum_id $forum_id \
        -message_id $message_id \
        -parent_id $parent_id \
        -subject $subject \
        -content $content \
        -format $formato \
        -user_id $user_id \
    ]
    set all_messages_list [db_list_of_lists get_all_messages_list {}]      
    set all_messages_number [llength $all_messages_list]
    
    for {set i 0} {$i < $all_messages_number} {incr i} {        
      set message_id  [db_nextval acs_object_id_seq]
      set subject [lindex [lindex $all_messages_list $i] 0]
      set content [lindex [lindex $all_messages_list $i] 1]
      set user_id [lindex [lindex $all_messages_list $i] 2]
      set formato [lindex [lindex $all_messages_list $i] 3]
      set parent_id [lindex [lindex $all_messages_list $i] 4]
      set message_id [forum::message::new \
        -forum_id $forum_id \
        -message_id $message_id \
        -parent_id $parent_id \
        -subject $subject \
        -content $content \
        -format $formato \
        -user_id $user_id \
      ]
    }
  }
}

ad_proc -public -callback datamanager::copy_forums -impl datamanager {
     -object_id:required
     -selected_community:required
     -sufix:required
} {
    Copy a forum to another class or community
} {
  #get forum's data
  set package_id [datamanager::get_forum_package_id -community_id $selected_community]

  db_1row get_forum_data {}  
  # modified to not creating lost of testing forums
  set forum_exist [db_string get_forum_num "select forum_id from forums_forums where name=:name and package_id=:package_id limit 1" -default 0]
  
  if {$forum_exist > 0} {
        set new_forum_id $forum_exist
  } else {
          set new_forum_id [db_nextval acs_object_id_seq]   
          set newname "$name$sufix"  
          #create the new forums
          set new_forum_id [forum::new -forum_id $new_forum_id \
                -name $newname \
                -charter $charter \
                -presentation_type $presentation_type \
                -posting_policy $posting_policy \
                -package_id $package_id \
                ]
  }
        
  set l_msg [db_list_of_lists get_all_messages {}]
 
        ############################
        # UPDATE PROCESS --> message_id and parent_id
        set l_msg2 $l_msg       
        set c 0
               
        foreach msg $l_msg2 {
                set index  [lindex $msg 0]
                set parent [lindex $msg 1]
                #cogemos todos los datos y creamos el nuevo mensaje             
                set new_idx [forum::message::new \
        -forum_id $new_forum_id \
                -parent_id [lindex [lindex $l_msg2 $c] 1] \
        -subject [lindex [lindex $l_msg2 $c] 2] \
        -content [lindex [lindex $l_msg2 $c] 3] \
        -format [lindex [lindex $l_msg2 $c] 7] \
        -user_id [lindex [lindex $l_msg2 $c] 4]]
                
                # Update posting data and last_child_post
                set p_date [lindex [lindex $l_msg2 $c] 5]
                set lc_post [lindex [lindex $l_msg2 $c] 6]
                db_dml update_pdates "update forums_messages set posting_date = :p_date , last_child_post = :lc_post where message_id = :new_idx"
                
                set cont 0
                foreach orig $l_msg {
                        if {[lindex $orig 1] == $index} {
                                set aux [lreplace $orig 1 1 $new_idx]                           
                                set l_msg2 [lreplace $l_msg2 $cont $cont $aux]
                                
                        } 
                        incr cont +1
                }
                set kk [lindex $l_msg2 $c]
                set kk [lreplace $kk 0 0 $new_idx]
                set l_msg2 [lreplace $l_msg2 $c $c $kk]         

                incr c +1
        }
  }

ad_proc -public -callback datamanager::export_forum -impl datamanager {
     -object_id:required
} {
    Export a forum
} {
  set lista [list []]
  db_1row select_forum {}

  lappend lista "<forum>"
  lappend lista "<name><!\[CDATA\[$name\]\]></name>"
  lappend lista "<charter><!\[CDATA\[$charter\]\]></charter>"
  lappend lista "<presentation_type><!\[CDATA\[$presentation_type\]\]></presentation_type>"
  lappend lista "<posting_policy><!\[CDATA\[$posting_policy\]\]></posting_policy>"

  set forum_id $object_id
  set first_messages_list [db_list_of_lists get_first_messages_list {}]      
  set first_messages_number [llength $first_messages_list]  

  for {set i 0} {$i < $first_messages_number} {incr i} {
    lappend lista "<forum_msg_level1>"

    set subject    [lindex [lindex $first_messages_list $i] 0]
    set content    [lindex [lindex $first_messages_list $i] 1]
    set username    [lindex [lindex $first_messages_list $i] 2]
    set format     [lindex [lindex $first_messages_list $i] 3]
    set parent_id  [lindex [lindex $first_messages_list $i] 4]
    set message_id [lindex [lindex $first_messages_list $i] 5]
    lappend lista "<subject texttype=\"text/html\"><!\[CDATA\[$subject\]\]></subject>"
    lappend lista "<content texttype=\"text/html\"><!\[CDATA\[$content\]\]></content>"    
    lappend lista "<username><!\[CDATA\[$username\]\]></username>"    
    lappend lista "<format><!\[CDATA\[$format\]\]></format>"    
    
    set hijos_messages_list [db_list_of_lists get_hijos_messages_list {}]      
    set hijos_messages_number [llength $hijos_messages_list]    
    for {set j 0} {$j < $hijos_messages_number} {incr j} {        
      lappend lista "<forum_msg_level2>"      
      set subject [lindex [lindex $hijos_messages_list $j] 0]
      set content [lindex [lindex $hijos_messages_list $j] 1]
      set username [lindex [lindex $hijos_messages_list $j] 2]
      set format  [lindex [lindex $hijos_messages_list $j] 3]
      lappend lista "<subject texttype=\"text/html\"><!\[CDATA\[$subject\]\]></subject>"
      lappend lista "<content texttype=\"text/html\"><!\[CDATA\[$content\]\]></content>"    
      lappend lista "<username><!\[CDATA\[$username\]\]></username>"    
      lappend lista "<format><!\[CDATA\[$format\]\]></format>"        
      lappend lista "</forum_msg_level2>"       
    }
    
    lappend lista "</forum_msg_level1>"
  }
  lappend lista "</forum>"
  return $lista
}

# created by fransola --> other algorithm to treat forums
ad_proc -public -callback datamanager::export_forums -impl datamanager {
     -object_id:required
} {
    Export a forum
} {
  set lista [list []]
  db_1row select_forums {}

  lappend lista "<forum>"
  lappend lista "<name><!\[CDATA\[$name\]\]></name>"
  lappend lista "<charter><!\[CDATA\[$charter\]\]></charter>"
  lappend lista "<presentation_type><!\[CDATA\[$presentation_type\]\]></presentation_type>"
  lappend lista "<posting_policy><!\[CDATA\[$posting_policy\]\]></posting_policy>"

  set forum_id $object_id
  set l_messages [db_list_of_lists get_all_messages {}]
  set l_messages_number [llength $l_messages]  

  for {set i 0} {$i < $l_messages_number} {incr i} {
    lappend lista "<forum_msg>"
        # message_id, parent_id, subject, content, username, posting_date, last_child_post, format
    set message_id   [lindex [lindex $l_messages $i] 0]    
    set parent_id    [lindex [lindex $l_messages $i] 1]
        set subject      [lindex [lindex $l_messages $i] 2]
    set content      [lindex [lindex $l_messages $i] 3]
    set username     [lindex [lindex $l_messages $i] 4]
        set posting_date [lindex [lindex $l_messages $i] 5]     
        set last_child_post [lindex [lindex $l_messages $i] 6]  
    set format       [lindex [lindex $l_messages $i] 7]
    
    
    lappend lista "<message_id texttype=\"text/html\"><!\[CDATA\[$message_id\]\]></message_id>"
    lappend lista "<parent_id texttype=\"text/html\"><!\[CDATA\[$parent_id\]\]></parent_id>"
    lappend lista "<subject texttype=\"text/html\"><!\[CDATA\[$subject\]\]></subject>"    
    lappend lista "<content texttype=\"text/html\"><!\[CDATA\[$content\]\]></content>"    
    lappend lista "<username><!\[CDATA\[$username\]\]></username>"    
    lappend lista "<posting_date><!\[CDATA\[$posting_date\]\]></posting_date>"    
    lappend lista "<last_child_post><!\[CDATA\[$last_child_post\]\]></last_child_post>"    
    lappend lista "<format><!\[CDATA\[$format\]\]></format>"    
    lappend lista "</forum_msg>"
  }
  lappend lista "</forum>"
  return $lista
}


#Callbacks for application-track 

ad_proc -callback application-track::getApplicationName -impl forums {} { 
        callback implementation 
    } {
        return "forums"
    }    
    
ad_proc -callback application-track::getGeneralInfo -impl forums {} { 
        callback implementation 
    } {
        db_1row my_query {
                select count(f.forum_id) as result
                FROM forums_forums f, dotlrn_communities_full com
                WHERE com.community_id=:comm_id
                and apm_package__parent_id(f.package_id) = com.package_id       
        }
        
        return "$result"
    }
    
ad_proc -callback application-track::getSpecificInfo -impl forums {} { 
        callback implementation 
    } {
        
        upvar $query_name my_query
        upvar $elements_name my_elements

        set my_query {
                SELECT  f.name as name,f.thread_count as threads,
                        f.last_post, 
                        to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
                FROM forums_forums f,dotlrn_communities_full com,acs_objects o
                WHERE com.community_id=:class_instance_id
                and f.forum_id = o.object_id
                and apm_package__parent_id(f.package_id) = com.package_id
 }
                
        set my_elements {
                name {
                    label "Name"
                    display_col name                            
                    html {align center}             
                                
                }
                threads {
                    label "Threads"
                    display_col threads                               
                    html {align center}                        
                }
                creation_date {
                    label "creation_date"
                    display_col creation_date                          
                    html {align center}                       
                }
                last_post  {
                    label "last_post"
                    display_col last_post                              
                    html {align center}                       
                }               
                
                
        }

        return "OK"
    }          
    
