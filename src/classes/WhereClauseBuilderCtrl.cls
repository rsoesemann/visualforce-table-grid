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
 *	Visualforce Controller for FilterBuilder component (builds WHERE part of underlying SOQL)
 */
public class WhereClauseBuilderCtrl {
	
	// COMPONENT ATTRIBUTES
	public SoqlQuery soqlQuery { get; set; }
	
	// COMPONENT ATTRIBUTES
	public List<SelectOption> filterableFields { get; private set; }
	public String selectedField { get; set; }
	public String selectedOperator { get; set; }
	public List<SelectOption> operatorOptions { 
		get {
			if(selectedField == null) {
				return new List<SelectOption>();
			}
			else {
				return FilterStatement.getValidOperatorsFor(soqlQuery.objectName, selectedField);
			}
		} 
		set; 
	}
	
	public SObject valueHolder { 
		get {
			if(valueHolder == null) {
				valueHolder = SchemaCache.object(soqlQuery.objectName).newSObject(null, true);
				
			}	
			if(selectedField == null) {
				selectedField = 'Name';
			}
			return valueHolder;
		}
		set; 
	}
	public String hashcodeToRemove { get; set; }
	
	
    public void getInit() {
    	
    	filterableFields = new List<SelectOption>();
    	Schema.DescribeFieldResult nonRequiredField;

    	for(Schema.DescribeFieldResult field : SchemaCache.fieldDescribes(soqlQuery.objectName).values()) {
            if(field.isFilterable() && field.isAccessible()) {
            	if(field.isNillable()) {
            		nonRequiredField = field;
            	}
            	filterableFields.add( new SelectOption(field.getName().toLowerCase(), field.getLabel()) );
            }
    	}
    	if(filterableFields.size() > 0) {
	    	SelectOptionSorter.sort(filterableFields, SelectOptionSorter.FieldToSort.Label);
	    	this.selectedField = nonRequiredField.getName().toLowerCase();
    	}
    }
    
    
    // ACTION METHODS 
    
    public void doAddStatement() { 
    	// Create and add new statement
    	FilterStatement newStatement = new FilterStatement(SchemaCache.fieldDescribe(soqlQuery.objectName, this.selectedField), selectedOperator, this.valueHolder);
    	soqlQuery.filterStatements.add(newStatement);
    }
    
    public void doRemoveStatement() {
    	// Find and remove statement
    	for(Integer i=0; i<soqlQuery.filterStatements.size(); i++) {
    		if(soqlQuery.filterStatements.get(i).hashcode == hashcodeToRemove) {
    			soqlQuery.filterStatements.remove(i); 
    		}
    	}
    }
}