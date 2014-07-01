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
 *	Models a SQOL query constructed by different parts of the UI
 */
public with sharing class SoqlQuery {
		
	// PROPERTIES
	
	// select
	public List<String> fieldsList { get; set; }
	public String fieldNames { get; set; }
	// from
	public String objectName { get; private set; }
	// where
	private String unchangeableFilter;
	public List<FilterStatement> filterStatements { get; set; }
	// order by
	public String sortFieldName { get; set; }
	public Boolean sortDescending { get; set; }
	
	public Boolean hasWhereClause { get; set; }
	public Boolean hasOrderByClause { get; set; }
	
	
	// CONSTRUCTOR 
	
	public SoqlQuery(String objectName, String fieldNames) {
		this.objectName = TableGridUtils.normalize(objectName);
		this.fieldsList = new List<String>();
		this.filterStatements = new List<FilterStatement>();
		this.sortDescending = false;
		this.hasWhereClause = false;
		this.hasOrderByClause = false;
		
		// Validate passed objectName 
		Schema.DescribeSObjectResult type = SchemaCache.objectDescribe(objectName);
		
		if(type == null) {
			throw new InvalidQueryException('SObject with name ' + objectName + ' does not exist.');
		}
		else if(!type.isAccessible()) {
			throw new InvalidQueryException('SObject with name ' + objectName + ' is not accessible for current user.');
		}
		selectFields(fieldNames);
	}
	
	public SoqlQuery selectFields(String fieldNames) {
		this.fieldNames = fieldNames;
		return selectFields(TableGridUtils.normalize(fieldNames).split(','));
	}
	
	public SoqlQuery selectFields(List<String> newFieldsList) {
		// Validate passed field names
		for(String fieldName : newFieldsList) {
			Schema.DescribeFieldResult field = SchemaCache.fieldDescribe(objectName, fieldName.trim());

			if(field == null) {
				throw new InvalidQueryException('Field with name ' + fieldName + ' does not exist in sobject ' + objectName);
			}
			else if(!field.isAccessible()) {
				throw new InvalidQueryException('Field with name ' + fieldName + ' is not accessible for current user');
			}
		}
		this.fieldsList.clear();
		this.fieldsList.addAll(newFieldsList);
		return this;
	}
	
	public SoqlQuery filter(String filter) {
		// Validate filter statement
		this.unchangeableFilter = filter.trim();
		
		if(unchangeableFilter.length() > 0) {
			String tmpSoql;
			try {
				tmpSoql = 'SELECT Id FROM ' + String.escapeSingleQuotes(objectName) + ' WHERE ' + unchangeableFilter;
				Database.query(tmpSoql);
			}
			catch(System.QueryException qe) {
				throw new InvalidQueryException('Illegal filter statement: ' + qe.getMessage() + ' SOQL: ' + tmpSoql);
			}
		}
		this.hasWhereClause = true;
		return this;
	}
	
	public SoqlQuery orderBy(String sortFieldName, Boolean sortDescending) {
		this.sortFieldName = sortFieldName;
		this.sortDescending = sortDescending;
			
		Schema.DescribeFieldResult field = SchemaCache.fieldDescribe(objectName, sortFieldName);
		if(field == null) {
			throw new InvalidQueryException('Sort field ' + sortFieldName + ' does not exist on object ' + objectName);
		}
		else if(!field.isSortable()) {
			throw new InvalidQueryException(sortFieldName + ' is not a sortable field.');
		}
		this.hasOrderByClause = true;
		return this;
	}


	// METHODS
	
	public String asString() {
		String result = 'SELECT ';
		
		for(String fieldName : fieldsList) {
			result += String.escapeSingleQuotes(fieldName) + ',';
		}
		result = result.substring(0, result.length()-1);
		
		// from		
		result += ' FROM ' + String.escapeSingleQuotes(objectName);
		
		// where
		Boolean hasUnchangeableFilter = (unchangeableFilter != null && unchangeableFilter != '') ;
		Boolean hasCustomFilters = !filterStatements.isEmpty();
			
		if(hasUnchangeableFilter || hasCustomFilters) {
			result += ' WHERE ';
			
			if(hasUnchangeableFilter) {
				result += unchangeableFilter;
			}	    	
			
			if(hasUnchangeableFilter && hasCustomFilters) {
				result += ' AND ';
			}
				    	
			if(hasCustomFilters) {
				for(FilterStatement statement : filterStatements) {
					result += statement.toSoql() + ' AND '; 
				}
				// Remove last AND
				result = result.substring(0, result.length()-5);
			}
		}
		
		// order by
		if(hasOrderByClause) {
			result += ' ORDER BY ';
			result += String.escapeSingleQuotes(sortFieldName);
			result += sortDescending ? ' DESC' : ' ASC';
		}
		return result;
	}
	
    public void updateFieldNames() {
    	this.fieldsList.clear();
    	
    	for(String fieldName : fieldNames.split(',')) {
    		this.fieldsList.add( fieldName );
    	}
    }
    
    public class InvalidQueryException extends Exception {}
}