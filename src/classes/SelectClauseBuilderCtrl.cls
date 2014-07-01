/*
Copyright (c) 2013 Up2Go International LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products 
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 *	Controller of the SelectClauseBuilder UI components to choose fields and their order
 */
public with sharing class SelectClauseBuilderCtrl {
    // COMPONENT ATTRIBUTES
    public SoqlQuery soqlQuery { get; set; }
    
    // PROPERTIES
    public List<SelectOption> hiddenFields { get; set; }
    public List<SelectOption> displayedFields { get; set; }
    public String idToBlock { get; set; }
    
    // INITIALIZATION Joel Dietz style
    public void getInit() { 
	    hiddenFields = new List<SelectOption>();
	    displayedFields = new List<SelectOption>();
    	Set<String> displayFieldsAsSet = new Set<String>();
		
		// Create SelectOption list of all displayed fields
    	for(String fieldName : soqlQuery.fieldsList) { 
    		Schema.DescribeFieldResult field = SchemaCache.fieldDescribe(soqlQuery.objectName, fieldName);
            SelectOption option = new SelectOption(field.getName().toLowerCase() , field.getLabel());
            displayedFields.add(option);
            displayFieldsAsSet.add(field.getName());
        }
        
        // Create SelectOptionList for a accessible and not displayed fields
        for(Schema.DescribeFieldResult field : SchemaCache.fieldDescribes(soqlQuery.objectName).values()) {
        	if(!displayFieldsAsSet.contains(field.getName()) && field.isAccessible()) {
        		SelectOption option = new SelectOption(field.getName().toLowerCase() , field.getLabel());
            	hiddenFields.add(option);
        	}
        } 
        SelectOptionSorter.sort(hiddenFields, SelectOptionSorter.FieldToSort.Label);
    }
}