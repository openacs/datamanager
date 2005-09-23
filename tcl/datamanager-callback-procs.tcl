ad_library {
    Callback calls to another packages. Basically movement and copying calls
    @author Luis de la Fuente (lfuente@it.uc3m.es)
    @creation_date 2005-07-08
}

ad_proc -public -callback datamanager::move_faq {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_faq {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::move_forum {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_forum {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::move_new {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_new {
     -object_id:required
     -selected_community:required
} {
}


ad_proc -public -callback datamanager::move_static {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_static {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::move_assessment {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_assessment {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::move_folder {
     -object_id:required
     -selected_community:required
} {
}

ad_proc -public -callback datamanager::copy_folder {
     -object_id:required
     -selected_community:required
} {
}
