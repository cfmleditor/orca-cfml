<cfset greeter = new Greeter()>
<cfquery name="users" datasource="app">
    SELECT id, name FROM users WHERE active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
</cfquery>
<!--- a CFML comment --->
<style>.user { color: #ff0000; }</style>
<cfoutput query="users">
    <p class="user">#greeter.greet(users.name)#</p>
</cfoutput>
<script>console.log("loaded");</script>
