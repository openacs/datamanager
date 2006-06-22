<master>

<HR>
<H3>#datamanager.users_selection_to_export#</H3>

<FORM NAME="select_one_user" action="../one-object-export">
<label for="one_user">#datamanager.one_user#</label>
<input name="one_user" type="text" size="50">
<INPUT type="hidden" name="object_id" value="">
<INPUT type="hidden" name="mode" value="one_user">
<INPUT type="submit" value="#datamanager.export#" id="submit">
</FORM>

<FORM NAME="select_several_users" action="../one-object-export">
<label for="several_users">#datamanager.several_users#</label>
<input name="several_users" type="text" size="50">
<INPUT type="hidden" name="object_id" value="">
<INPUT type="hidden" name="mode" value="several_users">
<INPUT type="submit" value="#datamanager.export#" id="submit">
</FORM>

<FORM NAME="select_all_users" action="../one-object-export">
<label for="all_users">#datamanager.all_users#</label>
<INPUT type="hidden" name="mode" value="all_users">
<INPUT type="hidden" name="object_id" value="">
<INPUT type="submit" value="#datamanager.export#" id="submit">
<INPUT type="button" value="#datamanager.cancel#" onclick="location.href='index'">
</FORM>

<HR>
<CENTER><A HREF="index.tcl">#datamanager.return_to_index#</A></CENTER>
