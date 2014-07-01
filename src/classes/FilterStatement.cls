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
 *	Class that holds a single Filter Statement (field operator value combination) that 
 *  later gets translated into a partial SOQL WHERE clause.
 *
 *  Instances of this class are genrated by the WhereClause Component used by the TableGrid component.
 */
public class FilterStatement {
	public String fieldName { get; set; }
	public Schema.DisplayType fieldType { get; set; }
	public String operator { get; set; }
	public SObject valueHolder { get; set; }
	// Custom hashcode for a FilterStatement based on the values of field, operator and value
	public String hashcode { get; private set; }
	
	
	/** 
	 * Constructs a FilterStatement based on Field Describe information
	 */
	public FilterStatement(Schema.DescribeFieldResult field, String operator, SObject valueHolder) {
		this.fieldName = field.getLocalName();
		this.fieldType = field.getType();
		this.operator = operator;
		this.valueHolder = valueHolder;
		this.hashcode = TableGridUtils.hash(fieldName+operator+valueHolder.get(fieldName));
	}
	
	
	/** 
	 * Constructs a FilterStatement based on Field information passed as Strings
	 */	
	public FilterStatement(String sobjectName, String fieldName, String operator, String valueAsString) {
		Schema.DescribeFieldResult field;
		try {
			field = SchemaCache.fieldDescribe(sobjectName, fieldName);
			
			this.fieldName = field.getLocalName();
			this.fieldType = field.getType();
			this.operator = operator;
			 
			this.valueHolder = SchemaCache.objectDescribe(sobjectName).getSObjectType().newSObject();
			TableGridUtils.putFromString(this.valueHolder, this.fieldName, this.fieldType, valueAsString); 
			 
			this.hashcode = TableGridUtils.hash(fieldName+operator+valueHolder.get(fieldName));
		}
		catch(Exception anyEx) {
			throw new InitilizationException(anyEx.getMessage());
		}
		
		// Also abort construction when field not accessible
		if(!field.isAccessible()) {
			throw new InitilizationException();
		}
	}
	
	
	/**
	 * Serializes a Filter Statement to be persisted in the Database
	 */
	public String asStringSetting() {
		return this.fieldName + ',' + this.operator + ',' + String.valueOf(this.valueHolder.get(this.fieldName));
	}
	
	
	/**
	 * Translates Filter Statement into a partial SOQL string
	 */
	public String toSoql() {
		String soql = operatorTemplates.get(operator);
		
		// Make value SOQL like		
		Object value = valueHolder.get(fieldName);
		String valueAsSoql;
		if(TableGridUtils.contains( QUOTE_TYPES, fieldType)) {
			valueAsSoql = '\'' + String.escapeSingleQuotes(String.valueOf(value)) + '\'';
		}
		else {
			if(value==null) {
				valueAsSoql = 'NULL';
			}
			else if(value instanceof Date) { 
				valueAsSoql = ((DateTime) value).format('yyyy-MM-dd');
			}
			else if(value instanceof DateTime) {  
				valueAsSoql = ((DateTime) value).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
			}
			else {
				valueAsSoql = String.valueOf(value);
			}
		}
		// Populate template
		soql = soql.replace('O1', String.escapeSingleQuotes(fieldName));
		soql = soql.replace('%O2%', '%' + String.escapeSingleQuotes(String.valueOf(value)) + '%') ;
		soql = soql.replace('O2', valueAsSoql) ;
		return soql;
	}
	
	
	/**
	 * Returns a picklist with operators valid for a given sobject and field
	 */
	public static List<SelectOption> getValidOperatorsFor(String sobjectName, String fieldName) {
		List<SelectOption> result = new List<SelectOption>();
		
		Schema.DisplayType fieldType = SchemaCache.fieldDescribe(sobjectName, fieldName).getType();
 
        for(String operator : operatorTemplates.keySet()) {
        	if(TableGridUtils.contains( validTypesFor.get(operator), fieldType)) {
            	result.add(new SelectOption(operator, operator));
        	}
        }
        return result;
    }

	
	// Constants defining field types
	private static final Map<String, List<Schema.DisplayType>> validTypesFor; 
	private static final List<Schema.DisplayType> STRING_TYPES      = new List<Schema.DisplayType>{
        Schema.DisplayType.base64
        ,Schema.DisplayType.MultiPicklist
        ,Schema.DisplayType.Phone
        ,Schema.DisplayType.Picklist
        ,Schema.DisplayType.String
        ,Schema.DisplayType.TextArea
        ,Schema.DisplayType.URL
    };
   	private static final List<Schema.DisplayType> NON_STRING_TYPES      = new List<Schema.DisplayType>{
        Schema.DisplayType.ID
        ,Schema.DisplayType.Reference
        ,Schema.DisplayType.Email
        ,Schema.DisplayType.Boolean
        ,Schema.DisplayType.Combobox
    };
    private static final List<Schema.DisplayType> NUMBER_TYPES     = new List<Schema.DisplayType>{
        Schema.DisplayType.Integer
        ,Schema.DisplayType.Currency
        ,Schema.DisplayType.Double
        ,Schema.DisplayType.Percent
        ,Schema.DisplayType.DateTime
        ,Schema.DisplayType.Date
    };
    private static final List<Schema.DisplayType> QUOTE_TYPES     = new List<Schema.DisplayType>{
    	 Schema.DisplayType.ID
    	 ,Schema.DisplayType.Reference
        ,Schema.DisplayType.base64
        ,Schema.DisplayType.Email
        ,Schema.DisplayType.MultiPicklist
        ,Schema.DisplayType.Phone
        ,Schema.DisplayType.Picklist
        ,Schema.DisplayType.String
        ,Schema.DisplayType.TextArea
        ,Schema.DisplayType.URL
        ,Schema.DisplayType.Combobox
    };
    
    // Custom exception
    public class InitilizationException extends Exception {}
    
    // Static assignment of field types and their valid operators
	private static final Map<String, String> operatorTemplates;
	
    static {
		operatorTemplates = new Map<String, String>();
		validTypesFor = new Map<String, List<Schema.DisplayType>>();
		
		List<Schema.DisplayType> ALL_TYPES = new List<Schema.DisplayType>();
		ALL_TYPES.addAll(FilterStatement.STRING_TYPES);
		ALL_TYPES.addAll(FilterStatement.NON_STRING_TYPES);
		ALL_TYPES.addAll(FilterStatement.NUMBER_TYPES);
		
		validTypesFor.put('equals', ALL_TYPES);
		operatorTemplates.put('equals', 'O1 = O2');
		
		validTypesFor.put('not equals', ALL_TYPES);
		operatorTemplates.put('not equals', 'O1 <> O2');
		
		validTypesFor.put('greater than', FilterStatement.NUMBER_TYPES);
		operatorTemplates.put('greater than', 'O1 > O2');
		
		validTypesFor.put('less than', FilterStatement.NUMBER_TYPES);
		operatorTemplates.put('less than', 'O1 < O2');
		
		validTypesFor.put('greater or equal', FilterStatement.NUMBER_TYPES);
		operatorTemplates.put('greater or equal', 'O1 >= O2');
		
		validTypesFor.put('less or equal', FilterStatement.NUMBER_TYPES);
		operatorTemplates.put('less or equal', 'O1 <= O2');
		
		validTypesFor.put('contains', FilterStatement.STRING_TYPES);
		operatorTemplates.put('contains', 'O1 LIKE \'%O2%\'');
		
		validTypesFor.put('not contains', FilterStatement.STRING_TYPES);
		operatorTemplates.put('not contains', '(NOT O1 LIKE \'%O2%\')');
	}
}