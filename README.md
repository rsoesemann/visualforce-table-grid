# TableGrid for Visualforce #

Visualforce TableGrid is a free, open-source Force.com library, that provides a Visualforce UI that currently (Spring '13) 
does not exist in the Standard Uthat was open-sourced to  that provides advanced UI capabilities to simplify the development of mobile apps. The framework contains lightweight Visualforce UI components that generate cross-platform HTML5 output that runs well on smartphones and tablets. The apps can be deployed in the browser or embedded inside Container from the Salesforce Mobile SDK. 
Note: The library is still in heavy development and is missing certain features as well as complete documentation.
This document is intended to introduce you to the app's architecture and design and make it as easy as possible for you to jump in, run it, and start contributing.
CHANGE
- Features
- Installation
- Usage / Examples
- Known Issues
- Third-party Code
- FAQ
- Visualforce TableGrid License

## Features ##
- Highly customizable Visualforce component <c:tableGrid..>
- Native Salesforce.com Look And Feel
- Works as Standalone table grid or replacement for Related List
- Can replace Standard Lookup popups with <c:advancedLookup>
- Works for Standard + Custom SObjects
- Spreadsheet-like Cell-Editing
- Delete Muliple records
- Pagination with cutomizable page size
- Filter Builder UI to let users filter records
- Field Selection UI to let users customize columns 
- Each user's customizations can be auto-saved in a "database-cookie"
 

## Installation ##
1. Grab the source code: `git clone https://github.com/ForceDotCom/MobileComponents.git`
2. Deploy the Force.com metadata under TableGrid/src folder to your destination org. You can deploy that using [Force.com Migration Tool](http://wiki.developerforce.com/index.php/Force.com_Migration_Tool) #or by using [Force.com IDE](http://wiki.developerforce.com/index.php/Force.com_IDE)


## Usage / Examples ##
There are two ways to extend or override Mobile Web SDK’s client-side behavior: listen for and act upon events and/or extend standard Mobile Web SDK Javascript components.

### Events
Mobile Web SDK Javascript events provide hooks into key user-interaction and Mobile Web SDK’s lifecycle points. When an event is fired, an event listener may augment the firing component’s behavior by changing or adding to passed parameters. Event listeners may also perform functions based on user trigger actions, such as change styling when an List component item is selected. Additionally, event listener may act upon standard jQuery Mobile events such as page loading (see jQuery Mobile documentation).

For Example: When a List component’s item is selected, the following with open a dialog box:

        $(document).on('listitemselect', function(e, context) {
            alert('You selected id: ' + context.data.Id);
        });

### Extending Mobile Web SDK Javascript Components
For more extensive customizations, Mobile Web SDK’s Javascript components may be extended to override or provide additional functionality to standard component behavior or styling.  For example, the Visualforce.Mobile.ListComponent Javascript component provides a basic list item template for each row in a list.  To customize the template, create a new Javascript class by extending Visualforce.Mobile.ListComponent and re-implement the getTemplate method.  Lastly, register the new class with the List component’s compHandler attribute.  When the List component is instantiated, an instance of the custom ListComponent will be created and its Mobile Web SDK lifecycle methods invoked.  Class customizations may call the parent class’s implementation before or after additional functionality or replace the underlying implementations altogether.  Custom implementations must extend Visualforce.Mobile.Component to hook into Mobile Web SDK lifecycle.

For Example: To provide a custom list item template:

        MyListComponent = Visualforce.Mobile.ListComponent.extend({
            getTemplate: function() {
                return '<h3 class="my-heading">${' + this.config.labelField + '}</h3>');
            }
        }
        <c:List ... compHandler="MyListComponent"/>


## Known Issue / ToDo ##
- Improve Performace (loading, partial rerender, select rows,...)
  - Reduce Viewstate
  - Replace ActionSupport with Javascript Remoting
  - Reduce Markup-Size
- 

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
A: Yes

Q: How is this framework supported?  
A: This is unsupported software from the Force.com development community. We will make our best efforts to fix bugs and add enhancements. We also encourage the community to fork the code and make independent changes.

## Visualforce TableGrid License ##
Copyright (c) 2012, Up2Go International, LLC All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
- Neither the name of salesforce.com, inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
