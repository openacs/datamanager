ad_page_contract {
} -query {
     object_id:multiple,notnull
     action:notnull
     dest_community_id:multiple
} -properties {
}

dotlrn::require_user_admin_community  -community_id [dotlrn_community::get_community_id]
set context [list []]
set title "[_ datamanager.Confirmation]"    

set next_url "use-dotlrn_news2?"
regsub -all {\{} $object_id "" object_id
regsub -all {\}} $object_id "" object_id
foreach oid $object_id {
  append next_url "object_id=" 
  append next_url $oid 
  append next_url "&"
}
append next_url "action=" $action
append next_url "&"
regsub -all {\{} $dest_community_id "" dest_community_id
regsub -all {\}} $dest_community_id "" dest_community_id
foreach dci $dest_community_id {
  append next_url "dest_community_id=" 
  append next_url $dci 
  append next_url "&"
}

