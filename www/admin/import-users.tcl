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

set l_time [ns_localtime]
set l_time2 [list [lindex $l_time 2] [lindex $l_time 1] [lindex $l_time 0]]
set time [join $l_time2 ":"]
ns_log Notice "START TIME: $time"

#################################
#         USERS                 #
#################################
set userNodes [$root selectNodes /items/user]
set countusers [llength $userNodes]
ns_log Notice "Num USERS: $countusers -- $userNodes"
# Iteremos...
set aux 0
foreach userNode $userNodes {
         set aux [expr $aux + 1]
         
  set username "[$userNode selectNodes {string(username)}]$sufix"
  set email "[$userNode selectNodes {string(email)}]$sufix"
  set first_names [$userNode selectNodes {string(first_names)}]
  set last_name [$userNode selectNodes {string(last_name)}]
  set password [$userNode selectNodes {string(password)}]
  set salt [$userNode selectNodes {string(salt)}]
  set screen_name "[$userNode selectNodes {string(screen_name)}]$sufix"
  set url [$userNode selectNodes {string(url)}]
  set auth [$userNode selectNodes {string(auth)}]
  set tipouser [$userNode selectNodes {string(usr_type)}]
  set bio [$userNode selectNodes {string(bio)}]
  set photo [$userNode selectNodes {string(photo)}]
  set mime_type [$userNode selectNodes {string(mime_type)}]
  # Otras cosas que hacen falta
  #0 NO limitado, 1 SI limitado
  set limitado 0    
  set email_verified_p 0
  set read_private_data_p read_private_data
 
  #BUSCO LA AUTORIDAD LDAP
  if {[catch {db_1row lautoridad "select authority_id from auth_authorities where short_name = :auth"} results]} {
  } else {
  }
  
  # OPENACS USER
  set user_info(username) $username
  set user_info(email) $email
  set user_info(last_name) $last_name
  set user_info(first_names) $first_names
  set user_info(authority_id) $authority_id 
  set user_info(screen_name) $screen_name
  set user_info(url) $url
 
 # Check if the user already exists
  set user_id [db_string user_id "select user_id from users where username = :username and authority_id = :authority_id" -default "-300"]
  if {$user_id != -300} {
    #YA EXISTE EL USUARIO
    ns_log Notice [format "The user already exists: %s (user_id=%d)" $username $user_id]
    set contmal [expr $contmal + 1]        
  } else {
    array set xresult [auth::create_local_account -authority_id $authority_id -username $username -array user_info]
    switch $xresult(creation_status) {
      ok {
        #USER DE DOT: necesito el id numerico del usuario. Roles en DOTLRN: student, professor, external, admin    
        set user_id [db_string user_id "select user_id from users where username = :username and authority_id = :authority_id" -default "-300"]
        #AJUSTO LA PW
        #
                if {$auth ne "ldap"} {
                        db_dml update_pass "update users set password = :password, salt = :salt where user_id = :user_id"
                } else {
                        if {[string equal $password ""] != 1} {
                                ad_change_password $user_id $password        
                        }
                }
                
                
                
        acs_privacy::set_user_read_private_data -user_id $user_id -object_id [dotlrn::get_package_id] -value $read_private_data_p   
        if {$tipouser eq "student"} {
          if {$limitado == 0} {
            set result [dotlrn::user_add -type student -can_browse -user_id $user_id]
          } else {
              set result [dotlrn::user_add -type student -user_id $user_id]
          }
        } elseif {$tipouser eq "professor"} {
          if {$limitado == 0} {
            set result [dotlrn::user_add -type professor -can_browse -user_id $user_id]
          } else {
            set result [dotlrn::user_add -type professor -user_id $user_id]
          }
        } elseif {$tipouser eq "admin"} {
          if {$limitado == 0} {
            set result [dotlrn::user_add -type admin -can_browse -user_id $user_id]
          } else {
            set result [dotlrn::user_add -type admin -user_id $user_id]
          }
        } elseif {$tipouser eq "external"} {
          if {$limitado == 0} {
            set result [dotlrn::user_add -type external -can_browse -user_id $user_id]
          } else {
            set result [dotlrn::user_add -type external -user_id $user_id]
          }
        }         
                
        set guest_p "f"
        dotlrn_privacy::set_user_guest_p -user_id $user_id -value $guest_p
        ns_log Notice [format "OK dotlrn::user_add: %d, '%s' '%s' '%s' '%s' '%s'" $conttotal $username $email $last_name $first_names $limitado]
                
                # SUBIR LA FOTO
                if {[string length $photo] ne 0} {
                        set photo_decoded [base64::decode $photo]
                        set tmp_photo "/tmp/dm_$username"
                        set fd2 [open $tmp_photo w] ; fconfigure $fd2 -encoding binary -translation lf; puts -nonewline $fd2 $photo_decoded; close $fd2
                        
                
                ###############################################################3333
                
                        set n_bytes [file size $tmp_photo]
                        
                        if { ![db_0or1row get_item_id "select object_id_two as item_id from acs_rels where object_id_one = :user_id and rel_type = 'user_portrait_rel'"]} { 
                        # The user doesn't have a portrait relation yet
                                db_transaction {
                                        set var_list [list \
                                                [list content_type image] \
                                                [list name portrait-of-user-$user_id]]
                                        set item_id [package_instantiate_object -var_list $var_list content_item]

                                        # DRB: this is done via manual SQL because acs rel types are a bit messed
                                        # up on the PostgreSQL side, which should be fixed someday.
                                        db_exec_plsql create_rel {
                                                select acs_rel__new (
                                                                                null,
                                                                                'user_portrait_rel',
                                                                                :user_id,
                                                                                :item_id,
                                                                                null,
                                                                                null,
                                                                                null
                                                        )
                                        }
                                }
                        }
                        set revision_id [cr_import_content \
                    -image_only \
                    -item_id $item_id \
                    -storage_type lob \
                    -creation_user [ad_conn user_id] \
                    -creation_ip [ad_conn peeraddr] \
                    [ad_conn package_id] \
                    $tmp_photo \
                    $n_bytes \
                    $mime_type \
                    portrait-of-user-$user_id]

                        cr_set_imported_content_live $mime_type $revision_id
                
                #############################################
                        file delete $tmp_photo 
                }
                
                if {[string length $bio] > 0} {
                        set exist_bio [db_string get_bio "select attr_value as bio from acs_attribute_values where object_id = :user_id and attribute_id = (select attribute_id from acs_attributes where object_type = 'person'and attribute_name = 'bio') " -default 0]
                        if {!$exist_bio} {
                                db_dml insert_bio "insert into acs_attribute_values (object_id, attribute_id, attr_value)       values (:user_id, (select attribute_id from acs_attributes where object_type = 'person' and attribute_name = 'bio'), :bio)"
                        } else {
                                db_dml update_bio "update acs_attribute_values set attr_value = :bio where object_id = :user_id and attribute_id = (select attribute_id from acs_attributes where object_type = 'person'and attribute_name = 'bio')"
                        }
                }

                set contbien [expr $contbien + 1]
                } 
          default {
        ns_log Notice [format "ERROR dotlrn::user_add: %d, %s, %s, %s, %s. %s" $conttotal $username $email $limitado $xresult(creation_status) $xresult(creation_message)]
        set contmal [expr $contmal + 1]
        foreach { elm_name elm_error } $xresult(element_messages) {
          ns_log Notice $elm_name $elm_error 
        }
      }
    }  
  }    
  set conttotal [expr $conttotal + 1]
         
}
 #fin importación usuarios      

lappend results [format "    Total users =%s" $conttotal]
lappend results [format "    Total users imported =%s" $contbien]
lappend results [format "    Total users NOT imported =%s" $contmal]

set l_time [ns_localtime]
set l_time2 [list [lindex $l_time 2] [lindex $l_time 1] [lindex $l_time 0]]
set time [join $l_time2 ":"]
ns_log Notice "END TIME: $time"
