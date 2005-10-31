ad_page_contract {
    Show the list of communities where an object can be moved
    @author Luis de la Fuente(lfuente@it.uc3m.es)
    @creation_date 2005-07-05
    
} -query {
    object_type
} -properties {
}
set context [list]

switch $object_type {
    new { 
        set object_url manage-object2
    }
   default {
        set object_url manage-object1
   }
}    

