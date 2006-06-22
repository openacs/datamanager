ad_page_contract {  
} -query {
    {mode:optional ""}
        {all_users:optional}
        {several_users:optional}
        {one_user:optional ""}
        {object_id:multiple,optional ""}        
} -properties {
}

set context [list [_ datamanager.Export_Objects]]
set comm_id [dotlrn_community::get_community_id]

#only administrator or professor must be allowed to enter this page
dotlrn::require_user_admin_community  -community_id $comm_id

set object_data [list]
set object_name [list]

if {[llength $object_id] == 1} {
   if {[llength [lindex $object_id 0]] > 1} {
        set object_id [lindex $object_id 0]
    }
}

# Recuperamos Object_ids para varios / todos los usuarios
if {$mode eq "one_user"} {
        set object_id [db_list get_user_list "select user_id from users where username = '$one_user'"]
        set num [llength $object_id]
}

if {$mode eq "several_users"} {
        set object_id [db_list get_user_list "select user_id from users where username like '$several_users%'"]
        set num [llength $object_id]
        
        
} elseif {$mode eq "all_users"} {
        set object_id [db_list get_all_user_list "select user_id from users"]
        
}




set action "export"
set n_exported 0
set fn_xml_output [datamanager::tmpfn]
set XML_OUTPUT [open $fn_xml_output w]
puts $XML_OUTPUT "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
puts $XML_OUTPUT "<items>"

set l_time [ns_localtime]
set l_time2 [list [lindex $l_time 2] [lindex $l_time 1] [lindex $l_time 0]]
set time [join $l_time2 ":"]
ns_log Notice "START TIME: $time"
 
############# BEGIN   
foreach object_id $object_id {

   set object_type [datamanager::get_object_type -object_id $object_id]

   ########### FAQ
   if {$object_type eq "faq"} {
     set lines [callback datamanager::export_faq -object_id $object_id]
     foreach line $lines {
       set line [join $line "\n"]
       puts -nonewline $XML_OUTPUT $line
     }
     incr n_exported
   ########### STATIC PORTLET  
   } elseif { $object_type eq "static_portal_content"} {
     set lines [callback datamanager::export_static -object_id $object_id]
     foreach line $lines {
       set line [join $line "\n"]
       puts -nonewline $XML_OUTPUT $line
     }
     incr n_exported     
   ########### FORUMS
   } elseif { $object_type eq "forums_forum"} {
     set lines [callback datamanager::export_forums -object_id $object_id]
     foreach line $lines {
       set line [join $line "\n"]
       puts -nonewline $XML_OUTPUT $line
     }
     incr n_exported
   ########### NEWS
   } elseif { $object_type eq "news"} {
     set lines [callback datamanager::export_new -object_id $object_id]
     foreach line $lines {
       set line [join $line "\n"]
       puts -nonewline $XML_OUTPUT $line
     }
     incr n_exported     
         
   ###########   COMMUNITY
   } elseif { $object_type eq "dotlrn_club"} {
                
     set lines [callback datamanager::export_dotlrn_club -object_id $object_id]
     foreach line $lines {
       set line [join $line "\n"]
       puts -nonewline $XML_OUTPUT $line
     }
     incr n_exported
   ###########   
   } elseif { $object_type eq "user"} { 

     #set lines [datamanager::export_acs_user -object_id $object_id]
     set lines [callback datamanager::export_acs_user -object_id $object_id]
     foreach line $lines {
       set line [join $line "\n"]
       puts -nonewline $XML_OUTPUT $line
     }
     incr n_exported
   ###########   
   } else {
   }

}

puts $XML_OUTPUT "\n</items>"
lappend results ""
lappend results [format "  <B>Total objects exported</B>=%s" $n_exported]
if {[catch {close $XML_OUTPUT} err]} {
  lappend results [format "Error closing xml file=%s" $err]
}

set l_time [ns_localtime]
set l_time2 [list [lindex $l_time 2] [lindex $l_time 1] [lindex $l_time 0]]
set time [join $l_time2 ":"]
ns_log Notice "END TIME: $time"
