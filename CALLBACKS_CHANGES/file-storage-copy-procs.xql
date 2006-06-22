<?xml version="1.0"?>
<queryset>

<fullquery name="fs_folder_copy.get_folder_data">
<querytext>
    SELECT fsf.name,
           fsf.key as pretty_name,
           fsf.parent_id,
           ao.creation_user,
           ao.creation_ip,
           crf.description 
    FROM  fs_folders as fsf,
          acs_objects as ao,
          cr_folders as crf
    WHERE ao.object_id=:old_folder_id and crf.folder_id=ao.object_id and fsf.folder_id=ao.object_id
</querytext>
</fullquery>

<fullquery name="fs_folder_copy.get_subfolders_list">
<querytext>
    SELECT folder_id as subfolders_list
    FROM fs_folders
    WHERE parent_id= :old_folder_id
</querytext>
</fullquery>


<fullquery name="fs_folder_copy.get_file_list">
<querytext>
    SELECT ao.object_id,
           ao.creation_user,
           ao.creation_ip 
    FROM acs_objects as ao, fs_files as fsf
    WHERE ao.context_id=:old_folder_id and fsf.file_id=ao.object_id
</querytext>
</fullquery>

<fullquery name="fs_folder_copy.file_copy">      
      <querytext>
                select file_storage__copy_file (
                :file_id,            -- file_id
                :new_folder_id,  -- taget_folder_id
                :creation_user,      -- creation_user
                :creation_ip,     -- creation_ip
                                :version                 -- nothing
                )
        </querytext>
</fullquery>

<fullquery name="fs_folder_copy.file_revision">      
      <querytext>
                select file_storage__new_version  (
                :file_name,          -- file_name
                :description,    -- file_description
                :mime_type,          -- file_mime_type
                :item_id,            -- item_id
                :creation_user,  -- creation_user
                :creation_ip     -- creation_ip
                )
        </querytext>
</fullquery>


<fullquery name="fs_folder_copy.content_revision">      
      <querytext>
                select content_revision__new  (
                        :file_name,        -- title
                        :description,     -- description
            now(),            -- publish_date
            :mime_type,       -- mime_type
            null,             -- nls_language
            :data,            -- data (default)
            :file_id,         -- item_id
            null,            -- revision_id
            now(),           -- creation_date
            :creation_user,   -- creation_user
            :creation_ip,      -- creation_ip
                        :content_length   --new__content_length
                )
        </querytext>
</fullquery>

<fullquery name="fs_folder_copy.content_data">      
      <querytext>
                select content_revision__get_content (
                        :revision_id      -- revision_id
                )
        </querytext>
</fullquery>

<fullquery name="fs_folder_copy.set_live_revision">      
      <querytext>
                select content_item__set_live_revision (
                        :revision_id      -- revision_id
                )
        </querytext>
</fullquery>

<fullquery name="fs_folder_copy.update_modified">      
      <querytext>
                select acs_object__update_last_modified (
                        :new_folder_or_revision_id,      -- new folder or revision_id
                        :creation_user,      -- creation_user
                        :creation_ip      -- creation_ip
                )
        </querytext>
</fullquery>

<fullquery name="fs_folder_copy.update_content_length">      
      <querytext>
                UPDATE cr_revisions SET content_length = :content_length where revision_id = :v_revision_id
        </querytext>
</fullquery>

</queryset>
