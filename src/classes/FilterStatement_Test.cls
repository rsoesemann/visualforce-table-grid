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
 *	Tests for the FilterStatement class
 */
@isTest
private class FilterStatement_Test {
	// Cache Describe calls to not run into limits
    final static Schema.SObjectField stringField = TableGridTestHelper.textField();
    final static Schema.SObjectField integerField = TableGridTestHelper.integerField();
    final static SObject valueHolder = TableGridTestHelper.newTestSObject();
    
    
    /**
     * Verifies that equal combinations of field/operator/values have the same hash values
     */
    static testMethod void testSameHashForSameStatements() {
        // Setup
        valueHolder.put(TableGridTestHelper.TEXT_FIELD, 'value');
        
        // Exercise
        FilterStatement a = new FilterStatement(stringField.getDescribe(), 'equals', valueHolder);
        FilterStatement b = new FilterStatement(stringField.getDescribe(), 'equals', valueHolder);
        
        // Verify
        System.assertEquals(a.hashcode, b.hashcode);
    }   
    
    
    /**
     * Verifies that different combinations of field/operator/values have different hash values
     */    
    static testMethod void testDifferentHashForDifferentStatements() {
        // Setup
        valueHolder.put(TableGridTestHelper.TEXT_FIELD, 'value');
        valueHolder.put(TableGridTestHelper.INTEGER_FIELD, 99);
        
        // Exercise
        FilterStatement a = new FilterStatement(stringField.getDescribe(), 'equals', valueHolder);
        FilterStatement b = new FilterStatement(integerField.getDescribe(), 'equals', valueHolder);

        // Verify
        System.assertNotEquals(a.hashcode, b.hashcode);
    }
    
    
    /**
     * Verifies that statements for string types are correctly translated to SOQl
     */
    static testMethod void testToSoqlForStringType() {
        // Setup
        valueHolder.put(TableGridTestHelper.TEXT_FIELD, 'value');
        
        FilterStatement equals = new FilterStatement(stringField.getDescribe(), 'equals', valueHolder);
        FilterStatement notEquals = new FilterStatement(stringField.getDescribe(), 'not equals', valueHolder);
        FilterStatement contains = new FilterStatement(stringField.getDescribe(), 'contains', valueHolder);
        FilterStatement notContains = new FilterStatement(stringField.getDescribe(), 'not contains', valueHolder);
        
        // Exercise & Verify
        System.assertEquals(TableGridTestHelper.TEXT_FIELD + ' = \'value\'', equals.toSoql());
        System.assertEquals(TableGridTestHelper.TEXT_FIELD + ' <> \'value\'', notEquals.toSoql());
        System.assertEquals(TableGridTestHelper.TEXT_FIELD + ' LIKE \'%value%\'', contains.toSoql());
        System.assertEquals('(NOT ' + TableGridTestHelper.TEXT_FIELD + ' LIKE \'%value%\')', notContains.toSoql());
    }  
    
    
    /**
     * Verifies that statements for non-string types are correctly translated to SOQl
     */
    static testMethod void testToSoqlForNonStringType() {
        // Setup
        valueHolder.put(TableGridTestHelper.INTEGER_FIELD, 99);
        
        FilterStatement equals = new FilterStatement(integerField.getDescribe(), 'equals', valueHolder);
        FilterStatement notEquals = new FilterStatement(integerField.getDescribe(), 'not equals', valueHolder);
        FilterStatement lessThan = new FilterStatement(integerField.getDescribe(), 'less than', valueHolder);
        FilterStatement greaterThan = new FilterStatement(integerField.getDescribe(), 'greater than', valueHolder);
        FilterStatement lessOrEqual = new FilterStatement(integerField.getDescribe(), 'less or equal', valueHolder);
        FilterStatement greaterOrEqual = new FilterStatement(integerField.getDescribe(), 'greater or equal', valueHolder);
        
        // Exercise & Verify
        System.assertEquals(TableGridTestHelper.INTEGER_FIELD + ' = 99', equals.toSoql());
        System.assertEquals(TableGridTestHelper.INTEGER_FIELD + ' <> 99', notEquals.toSoql());
        System.assertEquals(TableGridTestHelper.INTEGER_FIELD + ' < 99', lessThan.toSoql());
        System.assertEquals(TableGridTestHelper.INTEGER_FIELD + ' > 99', greaterThan.toSoql());
        System.assertEquals(TableGridTestHelper.INTEGER_FIELD + ' <= 99', lessOrEqual.toSoql());
        System.assertEquals(TableGridTestHelper.INTEGER_FIELD + ' >= 99', greaterOrEqual.toSoql());
    }
}