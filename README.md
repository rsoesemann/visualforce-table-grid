# Visualforce TableGrid #

[Installation](#-installation) | [Usage](#-usage-examples) | [Know Issues/Todos](#room-for-improvement) | [Third Party Code](#third-party-code) | [FAQ](#faq) | [Licence](#visualforce-tablegrid-license) | 

TableGrid is a free, open-source Force.com library, that provides a users and developers with a *highly customizable, native-looking, sortable, filterable, editable* Visualforce Grid component. 
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


## <a id="installation"></a> Installation ##
1. Grab the source code: `git clone https://github.com/Up2Go/TableGrid.git`
2. Deploy the Force.com metadata under the src folder to your destination org. You can deploy that using [Force.com Migration Tool](http://wiki.developerforce.com/index.php/Force.com_Migration_Tool) #or by using [Force.com IDE](http://wiki.developerforce.com/index.php/Force.com_IDE)


## <a id="usage"></a> Usage Examples ##
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
    
 

## Room for Improvement ##
- *Performance* (loading, partial rerender, select rows,...)
  - Reduce Viewstate
  - Replace ActionSupport with Javascript Remoting
  - Reduce Markup-Size
- Allow for more than 10.000 result records: For pagination I am using the `StandardSetController`, which seems to have this restriction.
- Allow to filter also for read-only fields in FilterBuilder without loosing the context-sensitive input fields.
- Optionally replace pagination with Infinite Scroll.
- Solve Bugs:
  - FilterBuilder does not clear value field when switching field
  - Save/Delete selected buttons are not activated when checkbox is selected
  - ...


## Third-party Code ##

This library makes use of a number of third-party components:

- [jQuery](http://jquery.com), the javascript library to make it easy to write javascript.
- [jQuery UI](http://jqueryui.com), jQuery UI library
- [jQuery BlockUI Plugin](http://http://jquery.malsup.com/block/), the jQuery plugin blocking parts of the UI.
- [Apex-Select-Option-Sorting](https://github.com/abhinavguptas/Apex-Select-Option-Sorting), an Apex sort utility class for SelectOptions


## FAQ ##

Q: Why did we create this library?  
A: HTML5 developers need a robust set of components to build mobile apps. This library provides a way to share the lessons learned creating Contact Viewer and provide re-usable components that can be plugged into Visualforce. 

Q: Can I customize the components?  
A: Absolutely! Fork it, extend it, improve it. And please share your experience.

Q: Where should I provide feedback and bug reports?  
A: We’re going to use GitHub for all collaboration.

Q: Can I distribute this in my app?  
A: tbd

Q: How is this framework supported?  
A: This is unsupported software from the Force.com development community. We will make our best efforts to fix bugs and add enhancements. We also encourage the community to fork the code and make independent changes.


## Visualforce TableGrid License ##

Copyright (c) 2012, Up2Go International, LLC All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
- Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
