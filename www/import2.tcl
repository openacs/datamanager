ad_page_contract {
} {
    upload_file:notnull
    upload_file.tmpfile:tmpfile
    {sufix:optional ""}
} -validate {
}

set this_comm_id [dotlrn_community::get_community_id]
set portal_id [dotlrn_community::get_portal_id -community_id $this_comm_id]
set package_id $this_comm_id

set xml_filename ${upload_file.tmpfile}
set fd [open $xml_filename r] ; set xml [read $fd] ; close $fd
#set doc [dom parse $xml]
dom parse [::tDOM::xmlReadFile $xml_filename] doc        
set root [$doc documentElement]

# check variables
set conttotal 0
set contbien 0
set contmal 0 

if {[info exist sufix] eq 0} {
  set sufix ""
}
    
#################################
#         FAQS                  #
#################################
set faqNodes [$root selectNodes /items/faq]
set countfaqs [llength $faqNodes]
foreach faqNode $faqNodes {
  set faq_name          "[$faqNode selectNodes {string(name)}]$sufix"
  set faq_separate_p    [$faqNode selectNodes {string(separate_p)}]
  set faq_username              [$faqNode selectNodes {string(creation_user)}]
  set faq_creation_ip   [$faqNode selectNodes {string(creation_ip)}]
  set faq_disabled_p    [$faqNode selectNodes {string(disabled_p)}]
  set faq_context_id    [$faqNode selectNodes {string(context_id)}]
  
  # obtenemos el user_id del creation_user
  set faq_creation_user [db_string get_user_id "select user_id from users where username = :faq_username"]
  # Obtenemos el context_id según la conexión.
  # Para el caso de una comunidad habrá que psarle el community_id
  set faq_context_id [datamanager::get_faq_package_id -community_id $this_comm_id] 
  set new_faq_id [db_exec_plsql create_faq {
           select faq__new_faq (
                     null,
                     :faq_name,
                     :faq_separate_p,
                     'faq',
                     now(),
                     :faq_creation_user,
                     :faq_creation_ip,
                     :faq_context_id
                 );
      }]
  set faq_q_aNodes [$faqNode selectNodes faq_q_a]
  foreach faq_q_aNode $faq_q_aNodes {
    set question [$faq_q_aNode selectNodes {string(question)}]
    set answer   [$faq_q_aNode selectNodes {string(answer)}]
    set entry_id [db_nextval acs_object_id_seq]
    set sort_key $entry_id
    set q_and_a_id [db_exec_plsql create_q_and_a {
      select faq__new_q_and_a (
                     :entry_id,
                     :new_faq_id,
                     :question,
                     :answer,
                     :sort_key,
                     'faq_q_and_a',
                     now(),
                     :faq_creation_user,
                     :faq_creation_ip,
                     :new_faq_id
                 );
      }]
    }
}
lappend results [format "    Total faqs imported=%s" $countfaqs]

#################################
#         STATIC PORTLETS       #
#################################
set staticNodes [$root selectNodes /items/static]
set countstatics [llength $staticNodes]
foreach staticNode $staticNodes {
  set pretty_name       "[$staticNode selectNodes {string(pretty_name)}]$sufix"
  set body              [$staticNode selectNodes {string(body)}]
  set format            [$staticNode selectNodes {string(format)}]

  db_transaction {
    set item_id [static_portal_content::new \
                         -package_id $package_id  \
                         -content $body \
                         -pretty_name $pretty_name \
                         -format $format]                         
    set old_element_id [static_portal_content::add_to_portal \
                         -portal_id $portal_id \
                         -package_id $package_id \
                         -content_id $item_id]
  }
}
lappend results [format "    Total static portlets imported=%s" $countstatics]

#################################
#         FORUM                 #
#################################
set forumNodes [$root selectNodes /items/forum]
set countforums [llength $forumNodes]
set fpackage_id [datamanager::get_forum_package_id -community_id $this_comm_id]    

if {$fpackage_id > 0} {

foreach forumNode $forumNodes {
  set forum_name              "[$forumNode selectNodes {string(name)}]$sufix"
  set forum_charter           [$forumNode selectNodes {string(charter)}]
  set forum_presentation_type [$forumNode selectNodes {string(presentation_type)}]
  set forum_posting_policy    [$forumNode selectNodes {string(posting_policy)}]  
  
  # modified to not creating lost of testing forums
  set forum_exist [db_string get_forum_num "select max(forum_id) from forums_forums where name=:forum_name and package_id=:fpackage_id" -default 0]
  
  if {$forum_exist > 0} {
        set forum_id $forum_exist
  } else {
    #NEW FORUM
        set forum_id [forum::new \
          -name $forum_name \
      -charter $forum_charter \
      -presentation_type $forum_presentation_type \
      -posting_policy $forum_posting_policy \
      -package_id $fpackage_id ]
  }
  #end modified  
    
  set forum_msgs [$forumNode selectNodes forum_msg]
  
  set l_msg [list]
  foreach forum_msg $forum_msgs {
  
    set message_id [$forum_msg selectNodes {string(message_id)}]
    set parent_id [$forum_msg selectNodes {string(parent_id)}]
    set subject "[$forum_msg selectNodes {string(subject)}]"
    set content "[$forum_msg selectNodes {string(content)}]"
        set username [$forum_msg selectNodes {string(username)}]
        set user_id [datamanager::get_username_id -username $username]
        set posting_date [$forum_msg selectNodes {string(posting_date)}]        
        set last_child_post [$forum_msg selectNodes {string(last_child_post)}]  
    set format  "[$forum_msg selectNodes {string(format)}]"
        set l_item [list]
        lappend l_item $message_id $parent_id $forum_id
        lappend l_item $subject $content $user_id 
        lappend l_item $posting_date $last_child_post $format
        lappend l_msg $l_item
        
        }
        
        ############################
        # UPDATE PROCESS --> message_id and parent_id
        set l_msg2 $l_msg       
        set c 0
        foreach msg $l_msg2 {
                set index  [lindex $msg 0]
                set parent [lindex $msg 1]
                #cogemos todos los datos y creamos el nuevo mensaje             
                set new_idx [forum::message::new \
        -forum_id [lindex [lindex $l_msg2 $c] 2] \
                -parent_id [lindex [lindex $l_msg2 $c] 1] \
        -subject [lindex [lindex $l_msg2 $c] 3] \
        -content [lindex [lindex $l_msg2 $c] 4] \
        -format [lindex [lindex $l_msg2 $c] 8] \
        -user_id [lindex [lindex $l_msg2 $c] 5]]
                
                # Update posting data and last_child_post
                set p_date [lindex [lindex $l_msg2 $c] 6]
                set lc_post [lindex [lindex $l_msg2 $c] 7]
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
    ###################

        lappend results [format "    Total forums imported=%s" $countforums]
  } 
} else {
  lappend results [format "    Total forums imported=%s -> 0: ERROR" $countforums]
}


#################################
#         NEWS                 #
#################################
#################################
set newsNodes [$root selectNodes /items/new]
set countnews [llength $newsNodes]

#set npackage_id [news_get_package_id -community_id $this_comm_id]    
set npackage_id [datamanager::get_new_package_id -community_id $this_comm_id]    

if {$fpackage_id > 0} {

foreach newsNode $newsNodes {
    set publish_title [$newsNode selectNodes {string(publish_title)}]
    set publish_body [$newsNode selectNodes {string(publish_body)}]
    set publish_date_ansi [$newsNode selectNodes {string(publish_date)}]
    set mime_type [$newsNode selectNodes {string(mime_type)}]   
    set archive_date_ansi [$newsNode selectNodes {string(archive_date_ansi)}]
        set approval_user [$newsNode selectNodes {string(approval_user)}]
        set approval_user_id [datamanager::get_username_id -username $approval_user]
        set approval_date [$newsNode selectNodes {string(approval_date)}]
        set approval_ip [$newsNode selectNodes {string(approval_ip)}]   
        set creation_ip [$newsNode selectNodes {string(creation_ip)}]   
        set creation_user [$newsNode selectNodes {string(creation_user)}]       
        #set live_revision_p [$newsNode selectNodes {string(live_revision_p)}]  
        set creation_user_id [datamanager::get_username_id -username $creation_user]

  
  
    set live_revision_p "t"
        append publish_title $sufix

#create the new
    set news_id [news_create_new -publish_body $publish_body \
                                 -publish_title $publish_title \
                                 -publish_date_ansi $publish_date_ansi \
                                 -mime_type $mime_type \
                                 -package_id $npackage_id \
                                 -archive_date_ansi $archive_date_ansi \
                                 -approval_user $approval_user_id \
                                 -approval_date $approval_date \
                                 -approval_ip $approval_ip \
                                 -creation_ip $creation_ip \
                                 -user_id $creation_user_id \
                                 -live_revision_p $live_revision_p ]
                                                                 
  
  }
lappend results [format "    Total news imported=%s" $countnews]
}
