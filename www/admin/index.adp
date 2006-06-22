<master>
<link rel="stylesheet" href="../datamanager.css" type="text/css">
<property name="title">#datamanager.pretty_name#</property>
<property name="context">@context;noquote@</property>

<div id="main" class="w100">
<H3 class="black">#datamanager.site_admin#</H3>
<HR>
<!--<P>#datamanager.description#</p>-->

<div class="head"><h4>#datamanager.content_admin#</h4></div>
<div class="content">
        <p>#datamanager.content_admin_info#</p>
        <ul>
        <li class="float"><a href="@next_url@?object_type=faq">#datamanager.faqs#</a></li>
        <li class="float"><a href="@next_url@?object_type=static-portlet">#datamanager.static-portlets#</a></li>
        <li class="float"><a href="@next_url@?object_type=forum">#datamanager.forums#</a></li>
        <li class="float"><a href="@next_url@?object_type=new">#datamanager.news#</a></li>
        <li class="float"><a href="@next_url@?object_type=folder">#datamanager.folders#</a></li>
        <li class="float"><a href="@next_url@?object_type=pa_album">#datamanager.photo-album#</a></li>
        <li class="float"><a href="@next_url@?object_type=weblogger">#datamanager.weblogger#</a></li>
        </ul>
        <div class="spacer">&nbsp;</div>
</div>
<div class="big_spacer">&nbsp;</div>


<div class="head"><h4>#datamanager.users_administration#</h4></div>
<div class="content">
        <p>#datamanager.users_administration_info#</p>
        <ul><li class="float"><a href="select_users?object_type=users">#datamanager.users#</a></li></ul>
        <div class="spacer">&nbsp;</div>
</div>
<div class="big_spacer">&nbsp;</div>

<div class="head"><h4>#datamanager.communities_administration#</h4></div>
<div class="content">
        <p>#datamanager.communities_administration_info#</p>
        <ul><li class="float"><a href="@next_url@?object_type=dotlrn_club">#datamanager.communities#</a></li></ul>
        <div class="spacer">&nbsp;</div>
</div>
<div class="big_spacer">&nbsp;</div>



<div class="head"><h4>#datamanager.site_admin_content_import#</h4></div>
<div class="content">
        <p>#datamanager.site_admin_content_import_info#
                <ul>
                <li class="float"><a href="../import.tcl">#datamanager.import_content#</a></li>
                <li class="float"><a href="../import?mode=user">#datamanager.users#</a></li>
                <li class="float"><a href="../import?mode=comm">#datamanager.communities#</a></li>
                </ul>
                <div class="spacer">&nbsp;</div>
</div>
<div class="spacer">&nbsp;</div>

</div>
