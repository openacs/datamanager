ad_page_contract {
    Just call the callback implemented in faqs package
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
     object_id:integer,notnull
     action:notnull
     selected_community:integer,notnull
} -properties {
}

set context [list []]
set title "[_ datamanager.Confirmation]"    

switch $action {
    "move" {
        callback -catch datamanager::move_faq -object_id $object_id -selected_community $selected_community
    }
    "copy" {
        callback -catch datamanager::copy_faq -object_id $object_id -selected_community $selected_community
    }
    "delete" {
    }
    default {
    }
}
    



ad_returnredirect "./"
