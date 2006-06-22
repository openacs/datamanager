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
set l_results [list]
lappend l_results {"COMUNIDAD" "ID" "NAME"} {"USERS" "NUM" "ADDED" "EXIST" "BAD" "LISTA"} {"STATIC" "NUM" "ADDES" "BAD"} {"NEWS" "NUM" "ADDES" "BAD"} {"FAQS" "NUM"} {"FORUMS" "NUM" "ADDED" "EXIST" "BAD"}     
        
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
#         COMMUNITIES                 #
#################################
set ClubNodes [$root selectNodes /items/club]
set countclub [llength $ClubNodes]
set join_policy closed
# Iteremos...
# set l_time [ns_localtime]
# set l_time2 [list [lindex $l_time 2] [lindex $l_time 1] [lindex $l_time 0]]
# set time [join $l_time2 ":"]

foreach ClubNode $ClubNodes {
        set name "[$ClubNode selectNodes {string(name)}]$sufix"
        set description "[$ClubNode selectNodes {string(description)}]$sufix"

        # Check if community already exists
        set ctrl [db_string get_n_comm "select count(*) from dotlrn_communities_all where pretty_name = :name"]
        if {$ctrl > 0} {
            set community_id [db_string get_comm "select min(community_id) from dotlrn_communities_all where pretty_name = :name"]
        } else {
                set community_id [dotlrn_club::new \
                                -description $description \
                                -pretty_name $name \
                                -join_policy $join_policy]
        }
        
        set l_comm [list]
        lappend l_comm $community_id $name
        
        #################
        #    USERS      #
        #################
        set num 1
        set users_added 0
        set users_exist 0
        set users_bad 0
        set l_baduser [list]
        
        set UserNodes [$ClubNodes selectNodes member]
        # recorremos los usuarios       
        foreach UserNode $UserNodes {
                # start importing users
                set username [$UserNode selectNodes {string(username)}]
                set auth [$UserNode selectNodes {string(auth)}]
                set rel_type [$UserNode selectNodes {string(rel_type)}]
                set num [expr $num + 1]
                set authority_id "0"
                #BUSCO LA AUTORIDAD LDAP
                if {[catch {db_1row lautoridad "select authority_id from auth_authorities where short_name = :auth"} results]} {
                } else {
                }               
                
                set user_id [db_string user_id "select user_id from users where username = :username and authority_id = :authority_id" -default "-300"] 
                if {$user_id ne -300} {
                        # Añadimos el usuario $user_id a la comunidad
                        #dotlrn_community::member_p comm user
                        if {![dotlrn_community::member_p $community_id $user_id]} {
                                dotlrn_community::add_user -rel_type $rel_type $community_id $user_id
                                incr users_added +1
                        } else {
                        incr users_exist +1
                        }
                } else {
                        # Contamos uno mal
                        lappend l_baduser $username
                        incr users_bad +1
                }
        # fin users
        }       
        
        ##########################
        #    STATIC PORTLET      #
        ##########################
        set static_num 0
        set static_added 0
        set static_exist 0
        set static_bad 0
        
        set StaticNodes [$ClubNodes selectNodes static] 

        set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
        
                
        # recorremos los static portlets        
        foreach StaticNode $StaticNodes {
                incr static_num
                # start importing users
                set pretty_name [$StaticNode selectNodes {string(pretty_name)}]
                set body [$StaticNode selectNodes {string(body)}]
                set format [$StaticNode selectNodes {string(format)}]
                
                set exists_static [db_string get_static "select 1 from static_portal_content where package_id = :community_id and pretty_name = :pretty_name" -default 0]
                # comprobamos que no existe
                if {$exists_static ne 1} {
        db_transaction {
       
        set item_id [static_portal_content::new \
                         -package_id $community_id  \
                         -content $body \
                         -pretty_name "$pretty_name$sufix" \
                                                 -format $format
        ]

        set old_element_id [static_portal_content::add_to_portal \
                               -portal_id $portal_id \
                               -package_id $community_id \
                               -content_id $item_id]
                incr static_added
    } on_error {
        incr static_bad
    }
        
    }
        }
        
        #################
        #    NEWS       #
        #################       
        set news_num 0
        set news_added 0
        set news_bad 0
        
        set NewsNodes [$ClubNodes selectNodes new]      


    set pid [datamanager::get_new_package_id -community_id $community_id]
        set live_revision_p "t"
        # HAY QUE TITARLO TRAS LAS PRUEBAS
        append publish_title $sufix
        
        # recorremos los static portlets        
        foreach NewsNode $NewsNodes {
                incr news_num
                # start importing users
                set publish_title [$NewsNode selectNodes {string(publish_title)}]       
                set publish_body [$NewsNode selectNodes {string(publish_body)}] 
                set publish_date [$NewsNode selectNodes {string(publish_date)}] 
                set mime_type [$NewsNode selectNodes {string(mime_type)}]       
                set archive_date_ansi [$NewsNode selectNodes {string(archive_date_ansi)}]       
                set approval_user [$NewsNode selectNodes {string(approval_user)}]       
                set approval_date [$NewsNode selectNodes {string(approval_date)}]       
                set approval_ip [$NewsNode selectNodes {string(approval_ip)}]   
                set creation_ip [$NewsNode selectNodes {string(creation_ip)}]   
                set creation_user [$NewsNode selectNodes {string(creation_user)}]       
        
        
        
                #USER DE DOT: necesito el id numerico del usuario. Roles en DOTLRN: student, professor, external, admin    
        set approval_user_id [db_string user_id "select user_id from users where username = :approval_user" -default "-300"]
        set creation_user_id [db_string user_id "select user_id from users where username = :creation_user" -default "-301"]

                #create the new
                set news_id [news_create_new -publish_body $publish_body \
                                 -publish_title $publish_title \
                                 -publish_date_ansi $publish_date \
                                 -mime_type $mime_type \
                                 -package_id $pid \
                                 -archive_date_ansi $archive_date_ansi \
                                 -approval_user $approval_user_id \
                                 -approval_date $approval_date \
                                 -approval_ip $approval_ip \
                                 -creation_ip $creation_ip \
                                 -user_id $creation_user_id \
                                 -live_revision_p $live_revision_p ]


                }
                
                if {$news_id > 0} {
                        incr news_added
                } else {
                        incr news_bad
                }
                
        #################
        #    FAQS       #
        #################       
        
        set faqNodes [$ClubNodes selectNodes faq]
        set countfaqs [llength $faqNodes]
        
        foreach faqNode $faqNodes {
        set faq_name          "[$faqNode selectNodes {string(name)}]$sufix"
        set faq_separate_p    [$faqNode selectNodes {string(separate_p)}]
        set faq_username                [$faqNode selectNodes {string(creation_user)}]
        set faq_creation_ip   [$faqNode selectNodes {string(creation_ip)}]
        set faq_disabled_p    [$faqNode selectNodes {string(disabled_p)}]
        set faq_context_id    [$faqNode selectNodes {string(context_id)}]
  
        # obtenemos el user_id del creation_user
        set faq_creation_user [db_string get_user_id "select user_id from users where username = :faq_username"]
        # Obtenemos el context_id según la conexión.
        # Para el caso de una comunidad habrá que psarle el community_id
        set faq_context_id [datamanager::get_faq_package_id -community_id $community_id] 
                if {$faq_context_id > 0} {
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
    }   
        # fi FAQ_IMPORT
        
        #################
        #    FORUMS     #
        #################
set forums_added 0
set forums_bad 0        
set forumNodes [$ClubNodes selectNodes forum]
set countforums [llength $forumNodes]
set forums_num $countforums
set fpackage_id [datamanager::get_forum_package_id -community_id $community_id]    

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
        incr forums_bad 
  } else {
    #NEW FORUM
    set forum_id [forum::new \
      -name $forum_name \
      -charter $forum_charter \
      -presentation_type $forum_presentation_type \
      -posting_policy $forum_posting_policy \
      -package_id $fpackage_id ]
  }
    
  set forum_msgs [$forumNode selectNodes forum_msg]
  set num_f [llength $forum_msgs]
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
         
                # fi ELSE control forum existe
        }
        }
          # fi FORUM
          
          
        ################
        #   INFO       #
        ################
        set l_comm [list]
        set l_users [list]
        set l_static [list]
        set l_news [list]
        set l_faqs [list]
        set l_forums [list]
        
        lappend l_comm "COMUNITY" $community_id $pretty_name
        lappend l_users "USERS" $num $users_added $users_exist $users_bad $l_baduser
        lappend l_static "STATIC" $static_num $static_added $static_bad
        lappend l_news "NEWS" $news_num $news_added $news_bad
        lappend l_faqs "FAQS" $countfaqs
        lappend l_forums "FORUMS" $forums_num $forums_added $forums_bad
        
        lappend l_results $l_comm $l_users $l_static $l_news $l_faqs $l_forums          


# fin community 
}

lappend web_results [format "$l_results"]
