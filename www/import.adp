<master>
<property name="title">#datamanager.pretty_name#: #datamanager.import#</property>
<property name="context">@context;noquote@</property>

<form enctype=multipart/form-data method=POST action="@next_url@">
  #datamanager.file_to_import#
  <input type="file" name="upload_file" size=40><br>      
  #datamanager.sufix#
  <input type="edit" name="sufix" size=10><br>        
  <input type="submit" name="#datamanager.submit_label#">
</form>

<HR>
<CENTER><A HREF="@return_url@">#datamanager.return_to_index#</A></CENTER>
