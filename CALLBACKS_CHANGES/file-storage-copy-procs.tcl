ad_library {
    TCL library for the file-storage system (v.4)

    @author Luis de la Fuente (lfuente@it.uc3m.es)
    @creation-date 16 September 2005
}
 
ad_proc fs_folder_copy {
    {-old_folder_id:required}
    {-new_parent_id:required}
    {-also_subfolders_p "t"}
    {-also_files_p "t"}   
    {-mode: "both"}
} {
    Copy a folder and its subfolders and files, if selected.
} {

    switch $mode {
        "empty" { 
            set also_subfolders_p "f"
            set also_files_p "f"
        }
        "files" { 
            set also_subfolders_p "f"
            set also_files_p "t"
        }
        "subfolders" { 
            set also_subfolders_p "t"
            set also_files_p "f"
        }
        "both" { 
            set also_subfolders_p "t"
            set also_files_p "t"
        }
    }

        set item_id -1
        #get data
    db_1row get_folder_data {}
        
        # First of all we have to check that don't exists a folder with the same name and parent_id
        set exist_folder [db_0or1row get_folder "select folder_id from fs_folders where parent_id = :new_parent_id and name = :name"]
        
        if {$exist_folder == 0} {
        #If folder don't exists we create it    
                set new_folder_id [fs::new_folder -name $pretty_name\
    -pretty_name $name -parent_id $new_parent_id -creation_user $creation_user -creation_ip $creation_ip  -description $description]
        } else {
        # If folder exists we reuse it
        set new_folder_id $folder_id    
        }
        #copy containing files
    if {$also_files_p=="t"} {
        #get files list
        set file_list [db_list_of_lists get_file_list {}]
        set file_number [llength $file_list]

        #copy them
        for {set i 0} {$i < $file_number} {incr i} {
                
                # Question - do we copy revisions or not?
                # Current Answer - we copy the live revision only
            set file_id [lindex [lindex $file_list $i] 0]
            db_1row get_file_name "select name as file_name from fs_files where file_id = :file_id"
            set user_id [lindex [lindex $file_list $i] 1]
            set ip_address [lindex [lindex $file_list $i] 2]
                        

                # Now, we have to check that don't exist a file with the same name and parent_id
                #       set old_file_id $file_id
                #       set exist_file [db_0or1row get_file "select * from fs_files where parent_id = :new_folder_id and name = :file_name"]
                        
                ######### NEW VERSION
                        set creation_user [ad_conn user_id]
                        set creation_ip [ns_info address]
                        set version "datamanager"
                        db_transaction {
                                set rdo [db_exec_plsql file_copy {}]
                        }
                ######### FIN NEW VERSION
                }       
    }

#while there are more subfolders...
    if {$also_subfolders_p=="t"} {
        
        set subfolders_list [db_list get_subfolders_list {}]
        set subfolders_number [llength $subfolders_list]

        for {set i 0} {$i < $subfolders_number} {incr i} {

            set object_id [lindex $subfolders_list $i]

            fs_folder_copy -old_folder_id $object_id -new_parent_id $new_folder_id       
        }
        
    }
        
    return $new_folder_id
    }


#}
