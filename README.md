# Visualforce TableGrid #

<a href="https://githubsfdeploy.herokuapp.com?owner=Up2Go&repo=visualforce-table-grid">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/src/main/webapp/resources/img/deploy.png">
</a>

[[Usage](#usage-examples) | [Know Issues/Todos](#known-issuestodos) | [Third Party Code](#third-party-code) | [Licence](#visualforce-tablegrid-license)

TableGrid is a free, open-source Force.com library, that provides users and developers a *highly customizable, native-looking, sortable, filterable, editable* Grid Visualforce component. 
This component can be used as an advanced, highly configurable (by developer and user) replacement of <apex:pageBlockTable>s and Standard Related Lists.

> ![Two instances of Visualforce TableGrid, one read-only and one editable version.](https://raw.github.com/Up2Go/TableGrid/master/resources/grid.png)
 
 
## Features: ##
- Native Salesforce.com Look And Feel
- Works as Standalone table grid or as an embedded replacement for Related List
- Works as replacement for Standard Lookup popups with <c:advancedLookup>
- Works for Standard and Custom SObjects
- Spreadsheet-like Cell-Editing
- Delete Muliple records
- Pagination with cutomizable page size
- Filter Builder UI to let users filter records
- Field Selection UI to let users customize columns 
- Each user`s customizations can be auto-saved in a "database-cookie"


## Usage Examples ##
Please see `components/tableGrid.component` for a detailed description of all attributes. The following examples should give 
you enough information to get started.

### TableGrid in a standalone Visualforce page

> ![TableGrid in List mode with Customizations turned on](https://raw.github.com/Up2Go/TableGrid/master/resources/customizable.png)

This  snippet is taken from the sample page `pages/tableGridStandalone.page`.
 
        <apex:page showHeader="false" sidebar="false"> 
        	<apex:form >
        		...
			    <c:tableGrid type="Opportunity" 
		        			 title="Opportunities"
		                     fields="Name,StageName,Amount,CloseDate" 
		                     sortBy="Name" 
		                     image="/img/icon/hands24.png"
		                     sortDescending="true"
		                     mode="list"
		                     customizeFields="true"
		                     customizeFilter="true"
		                     pageSize="5" />   
		    	 ...
		   	</apex:form>
		</apex:page>
         

### TableGrid embedded into Standard Page Layouts

> ![Two TableGrid instanced replacing Standard Related Lists in a Standard Page Layout](https://raw.github.com/Up2Go/TableGrid/master/resources/tableGrid_embedded.png)

This  snippet is taken from the sample page `pages/tableGridRelatedList.page` and `pages/tableGridEmbedded.page`

		<apex:page standardController="Account"> 
		    <apex:form>
		        ...
		        
		        <!-- Advanced Related list -->
		        <c:tableGrid type="Contact" 
		                     fields="Id, Name, Email, Birthdate" 
		                     filter="AccountId = `{!Account.Id}`"
		                     title="Contacts" 
		                     gridPageId="readonly"
		                     pageSize="5"
		                     mode="list"/>
		             
		        <!-- Editable grid with customization turned on -->        
		        <c:tableGrid type="Opportunity" 
		                     fields="Name,StageName,Amount,CloseDate" 
		                     filter="AccountId = `{!Account.Id}`"
		                     sortBy="Name" 
		                     sortDescending="true"
		                     title="Opportunities" 
		                     gridPageId="editable"
		                     customizeFields="true"
		                     customizeFilter="true"
		                     pageSize="5"
		                     mode="edit"/>  
		                        
		    	 ...
		   	</apex:form>
		</apex:page>


### TableGrid as an Advanced Lookup Popup

> ![TableGrid as an Advanced Lookup Popup](https://raw.github.com/Up2Go/TableGrid/master/resources/advancedLookup.png)

This  snippet is taken from the sample page `pages/tableGridAdvancedLookup.page`.

	<apex:page standardController="Contact">    
	    <apex:form>
	    	...
		    <c:advancedLookup > 
		        <apex:inputField value="{!Contact.AccountId}" label="" />
		    </c:advancedLookup>
		    ...
		</apex:form>
	</apex:page>
    
 

## Known Issues/Todos ##
- *Performance* (loading, partial rerender, select rows,...)
  - Reduce Viewstate
  - Replace ActionSupport with Javascript Remoting
  - Reduce Markup-Size
- Allow for more than 10.000 result records: For pagination I am using the `StandardSetController`, which seems to have this restriction.
- Allow to filter also for read-only fields in FilterBuilder without loosing the context-sensitive input fields.
- Optionally replace pagination with Infinite Scroll.
- Fix Bugs:
  - FilterBuilder does not clear value field when switching field
  - Save/Delete selected buttons are not activated when checkbox is selected
  - ...


## Third-party Code ##

This library makes use of a number of third-party components:

- [jQuery](http://jquery.com), the javascript library to make it easy to write javascript.
- [jQuery UI](http://jqueryui.com), jQuery UI library
- [jQuery BlockUI Plugin](http://http://jquery.malsup.com/block/), the jQuery plugin blocking parts of the UI.
- [Apex-Select-Option-Sorting](https://github.com/abhinavguptas/Apex-Select-Option-Sorting), an Apex sort utility class for SelectOptions


## Visualforce TableGrid License ##

Copyright (C) 2013 UP2GO International LLC

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
