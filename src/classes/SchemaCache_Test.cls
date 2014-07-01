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
 *	Tests for the SchemaCache class
 */
@isTest
private class SchemaCache_Test {
    static final String EXISTING_SOBJECT = 'TableGridAccessible__c';
    static final String NOT_EXISTING_SOBJECT = 'FooBar123';
    static final String EXISTING_FIELD = 'txt_TextField__c';
    static final String NOT_EXISTING_FIELD = 'SchizzleABC';

    /**
     * Verify that Object describe from cache is the sames as from API
     */
    static testMethod void testObjectInfoForExistingObject() {
        // Setup
        Schema.SObjectType fromApex = Schema.getGlobalDescribe().get(EXISTING_SOBJECT);
        
        // Exercise
        Schema.SObjectType fromCache = SchemaCache.object(EXISTING_SOBJECT);
        
        // Verify
        System.assertEquals(fromApex, fromCache);
        
    }
    
    /**
     * Verify that null is returned for not existing object
     */
    static testMethod void testObjectInfoForNotExistingObject() {
        // Exercise
        Schema.SObjectType fromCache = SchemaCache.object(NOT_EXISTING_SOBJECT);
        
        // Verify
        System.assertEquals(null, fromCache);
    }
    
    /**
     * Verify that field describes from cache are the same as from API
     */
    static testMethod void testGetFieldsOfExistingObject() {
        // Setup
        Map<String, Schema.SObjectField> fromApex = Schema.getGlobalDescribe().get(EXISTING_SOBJECT).getDescribe().fields.getMap();
        
        // Exercise
        Map<String, Schema.SObjectField> fromCache = SchemaCache.fields(EXISTING_SOBJECT);
        
        // Verify
        System.assertEquals(fromApex.size(), fromCache.size());
        
        for(String fieldName : fromApex.keySet()) {
            System.assertEquals(fromApex.get(fieldName), fromCache.get(fieldName));
        }
    }
    
    /**
     * Verify that field describes are really cached and do not add to the governor limit
     */
    static testMethod void testFieldDescribesAreReallyCached() {
        // Setup
        Map<String, Schema.SObjectField> fromCache = SchemaCache.fields(EXISTING_SOBJECT);
        Integer describesBefore = Limits.getFieldsDescribes();
        
        // Exercise
        SchemaCache.field(EXISTING_SOBJECT, EXISTING_FIELD);
        SchemaCache.field(EXISTING_SOBJECT, EXISTING_FIELD);
        SchemaCache.field(EXISTING_SOBJECT, EXISTING_FIELD);
        
        // Verify
        Integer describesAfter = Limits.getFieldsDescribes();
        System.assertEquals(describesBefore, describesAfter);
    }
    
    /**
     * Verify that null is returned when field list contains non existing field
     */
     static testMethod void testGetFieldsOfNotExistingObject() {
        
        // Exercise
        Map<String, Schema.SObjectField> fromCache = SchemaCache.fields(NOT_EXISTING_SOBJECT);
        
        // Verify
        System.assertEquals(null, fromCache);
    }
    
    /**
     * Verify that field info and describe from cache equals the one requested from the API
     */
     static testMethod void testGetFieldInfoOfExistingField() {
        // Setup
        Schema.SObjectField infoFromApex = Schema.getGlobalDescribe().get(EXISTING_SOBJECT).getDescribe().fields.getMap().get(EXISTING_FIELD);
        Schema.DescribeFieldResult describeFromApex = Schema.getGlobalDescribe().get(EXISTING_SOBJECT).getDescribe().fields.getMap().get(EXISTING_FIELD).getDescribe();
        
        // Exercise
        Schema.SObjectField infoFromCache = SchemaCache.field(EXISTING_SOBJECT, EXISTING_FIELD);
        Schema.DescribeFieldResult describeFromCache = SchemaCache.fieldDescribe(EXISTING_SOBJECT, EXISTING_FIELD);
        
        // Verify
        System.assertEquals(infoFromApex, infoFromCache);
        System.assertEquals(describeFromApex, describeFromCache);
    }
    
    /**
     * Verify that null is returned for field info and describe when non existing field
     */
     static testMethod void testGetFieldInfoOfNotExistingField() {
        // Exercise
        Schema.SObjectField infoFromCache = SchemaCache.field(EXISTING_SOBJECT, NOT_EXISTING_FIELD);
        Schema.DescribeFieldResult describeFromCache = SchemaCache.fieldDescribe(EXISTING_SOBJECT, NOT_EXISTING_FIELD);
        
        // Verify
        System.assertEquals(null, infoFromCache);
        System.assertEquals(null, describeFromCache);
    }   
}