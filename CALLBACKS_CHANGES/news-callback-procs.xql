<?xml version="1.0"?>
<queryset>


<fullquery name="callback::datamanager::copy_new::impl::datamanager.get_news_data">
<querytext>
    SELECT  a.archive_date as archive_date_ansi,
            a.approval_user,
            a.approval_date,
            a.approval_ip,
            b.creation_user as user_id,
            b.creation_ip,
            b.creation_date
    FROM cr_news as a, acs_objects as b
    WHERE a.news_id=:present_object_id and b.object_id=:present_object_id
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_new::impl::datamanager.get_present_new_item">
<querytext>
SELECT context_id as new_item_id
FROM acs_objects
WHERE object_id=:news_id
</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_new::impl::datamanager.get_live_revision">
<querytext>
SELECT a.live_revision 
FROM cr_items as a,
     acs_objects as b 
WHERE b.object_id=:present_object_id and a.item_id=b.context_id
</querytext>
</fullquery>


<fullquery name="callback::datamanager::copy_new::impl::datamanager.get_news_revisions_data">
<querytext>
SELECT a.revision_id,
       a.publish_date,
       a.content as publish_body,
       a.mime_type,
       a.title as publish_title,
       a.description as revision_log
FROM cr_revisions as a,cr_revisions as b
WHERE b.revision_id=:object_id and b.item_id=a.item_id
ORDER BY a.revision_id

</querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_new::impl::datamanager.create_news_item">      
      <querytext>
    select news__new(
        null,               -- p_item_id
        null,               -- p_locale
        :publish_date_ansi, -- p_publish_date
        :publish_body,      -- p_text
        null,               -- p_nls_language
        :publish_title,     -- p_title
        :mime_type,         -- p_mime_type
        :package_id,        -- p_package_id
        :archive_date_ansi, -- p_archive_date
        :approval_user,     -- p_approval_user
        :approval_date,     -- p_approval_date
        :approval_ip,       -- p_approval_ip
        null,               -- p_relation_tag
        :creation_ip,       -- p_creation_ip
        :user_id,           -- p_creation_user
        :live_revision_p   -- p_is_live_p
    );
      </querytext>
</fullquery>

<fullquery name="callback::datamanager::copy_new::impl::datamanager.create_news_item_revision">      
      <querytext>

        select news__revision_new(
            :new_item_id,             -- p_item_id
            :publish_date_ansi,   -- p_publish_date
                :publish_body,        -- p_text
            :publish_title,       -- p_title
            :revision_log,        -- p_description
            :mime_type,           -- p_mime_type
            :package_id,          -- p_package_id
            :archive_date_ansi,   -- p_archive_date
            :approval_user,       -- p_approval_user
            :approval_date,       -- p_approval_date
            :approval_ip,         -- p_approval_ip
            current_timestamp,       -- p_creation_date
            :creation_ip,         -- p_creation_ip
            :user_id,             -- p_creation_user
            :active_revision_p    -- p_make_active_revision_p
        );
      </querytext>
</fullquery>

<fullquery name="callback::datamanager::export_new::impl::datamanager.get_live_revision">
<querytext>
                SELECT a.live_revision 
                FROM cr_items as a,
                        acs_objects as b 
                WHERE b.object_id=:object_id and a.item_id=b.context_id
</querytext>
</fullquery>


<fullquery name="callback::datamanager::export_new::impl::datamanager.get_news_revisions_data">
<querytext>
SELECT a.revision_id,
       a.publish_date,
       a.content as publish_body,
       a.mime_type,
       a.title as publish_title,
       a.description as revision_log
FROM cr_revisions a
WHERE a.revision_id=:object_id

</querytext>
</fullquery>

<fullquery name="callback::datamanager::export_new::impl::datamanager.get_news_data">
<querytext>
    SELECT  a.archive_date as archive_date_ansi,
            a.approval_user,
            a.approval_date,
            a.approval_ip,
            b.creation_user,
            b.creation_ip,
            b.creation_date
    FROM cr_news as a, acs_objects as b
    WHERE a.news_id=:object_id and b.object_id=:object_id
</querytext>
</fullquery>

<fullquery name="callback::datamanager::export_new::impl::datamanager.get_username">
<querytext>
    SELECT  username FROM acs_users_all
    WHERE user_id = :user_id
</querytext>
</fullquery>

</queryset>

