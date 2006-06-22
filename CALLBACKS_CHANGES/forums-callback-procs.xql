<?xml version="1.0"?>
<queryset>

    <fullquery name="callback::MergePackageUser::impl::forums.upd_poster">
        <querytext>     
        update forums_messages
        set last_poster = :to_user_id
        where last_poster = :from_user_id
        </querytext>
    </fullquery>

    <fullquery name="callback::MergePackageUser::impl::forums.upd_user_id">
        <querytext>     
        update forums_messages
        set user_id = :to_user_id
        where user_id = :from_user_id
        </querytext>
    </fullquery>

    <fullquery name="callback::MergeShowUserInfo::impl::forums.sel_user_id">
        <querytext>     
        select message_id, subject
        from forums_messages
        where user_id = :user_id
        </querytext>
    </fullquery>

    <fullquery name="callback::MergeShowUserInfo::impl::forums.sel_poster">
        <querytext>     
        select message_id, subject
        from forums_messages
        where last_poster = :user_id
        </querytext>
    </fullquery>
 
<fullquery name="callback::datamanager::move_forum::impl::datamanager.update_forums">
<querytext>
    update forums_forums
        set package_id = :new_package_id 
    where forum_id = :object_id
</querytext>
</fullquery>

<fullquery name="callback::datamanager::delete_forum::impl::datamanager.del_update_forums">
<querytext>
    update forums_forums
        set package_id = :trash_package_id
    where forum_id = :object_id
</querytext>
</fullquery>



<fullquery name="callback::datamanager::move_forum::impl::datamanager.update_forums_acs_objects">
<querytext>
    update acs_objects
    set package_id = :new_package_id,
        context_id = :new_package_id
    where object_id = :object_id
</querytext>
</fullquery>


<fullquery name="callback::datamanager::delete_forum::impl::datamanager.del_update_forums_acs_objects">
<querytext>
update acs_objects
set package_id = :trash_package_id,
    context_id = :trash_package_id
where object_id = :object_id
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_forum::impl::datamanager.get_forum_data">
<querytext>
    SELECT  name,charter,presentation_type,posting_policy
    FROM forums_forums
    WHERE forum_id=:object_id;
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_forums::impl::datamanager.get_forum_data">
<querytext>
    SELECT  name,charter,presentation_type,posting_policy
    FROM forums_forums
    WHERE forum_id=:object_id;
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_forum::impl::datamanager.get_first_messages_list">
<querytext>
    SELECT subject,
           content,
           user_id,
           format as formato,
           parent_id
    FROM forums_messages
    WHERE forum_id=:object_id and 
          parent_id IS NULL;
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_forum::impl::datamanager.get_all_messages_list">
<querytext>
    SELECT subject,
           content,
           user_id,
           format as formato,
           parent_id
    FROM forums_messages
    WHERE forum_id=:object_id and 
          parent_id IS NOT NULL;
</querytext>
</fullquery>


<fullquery name="callback::datamanager::export_forum::impl::datamanager.get_first_messages_list">
<querytext>
    SELECT subject,
           content,
           username,
           format,
           parent_id,
           message_id
    FROM forums_messages fm,
                 users u
    WHERE forum_id=:object_id and 
          parent_id IS NULL and
                  fm.user_id = u.user_id;
</querytext>
</fullquery>

<fullquery name="callback::datamanager::export_forum::impl::datamanager.get_all_messages_list">
<querytext>
    SELECT subject,
           content,
           user_id,
           format,
           parent_id,
           message_id
    FROM forums_messages
    WHERE forum_id=:object_id and 
          parent_id IS NOT NULL;
</querytext>
</fullquery>

<fullquery name="callback::datamanager::export_forum::impl::datamanager.get_hijos_messages_list">
<querytext>
    SELECT subject,
           content,
           username,
           format,
           parent_id,
           message_id
    FROM forums_messages fm,
             users u
    WHERE forum_id = :object_id and 
          parent_id = :message_id and
                  fm.user_id = u.user_id;
</querytext>
</fullquery>

<fullquery name="callback::datamanager::export_forum::impl::datamanager.select_forum">
  <querytext>
    SELECT fo.name as name,
           ao.object_id,
           us1.username as creation_user,
           to_char(ao.creation_date,'YYYY-MM-DD HH:MM:SS') as creation_date,
           fo.charter,
           fo.presentation_type,
           fo.posting_policy,
           fo.enabled_p,
           fo.thread_count,
           fo.approved_thread_count,
           fo.forums_forums,
           fo.last_post,
           fo.autosubscribe_p
    FROM  acs_objects as ao,
          users as us1,
          forums_forums as fo
    WHERE
          us1.user_id = ao.creation_user and
          ao.object_id = :object_id and
          fo.forum_id = ao.object_id
     ORDER BY name, ao.creation_date
   </querytext>
</fullquery>


<fullquery name="callback::datamanager::export_forums::impl::datamanager.select_forums">
  <querytext>
    SELECT 
                name, charter, presentation_type, posting_policy
    FROM  
            forums_forums
    WHERE
            forum_id = :object_id
   </querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_forums::impl::datamanager.get_all_messages">
  <querytext>
    SELECT message_id, parent_id, subject, content, user_id, posting_date, last_child_post, format
    FROM forums_messages fm
    WHERE forum_id = :object_id
        ORDER BY posting_date             
   </querytext>
</fullquery>


<fullquery name="callback::datamanager::export_forums::impl::datamanager.get_all_messages">
  <querytext>
    SELECT 
                message_id, parent_id, subject, content, username, posting_date, last_child_post, format
    FROM forums_messages fm,
             users u
    WHERE forum_id = :object_id and         
                  fm.user_id = u.user_id
    ORDER BY posting_date                 
   </querytext>
</fullquery>

</queryset>
