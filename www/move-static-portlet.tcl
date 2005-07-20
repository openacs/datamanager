ad_page_contract {
    Just call the callback implemented in static-portlet package
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-11
    
} -query {
     object_id:integer,notnull
     selected_community:integer,notnull
} -properties {
}

set context [list []]
set title "[_ datamanager.Confirmation]"    


callback -catch datamanager::move_static -object_id $object_id -selected_community $selected_community

ad_returnredirect "./"
