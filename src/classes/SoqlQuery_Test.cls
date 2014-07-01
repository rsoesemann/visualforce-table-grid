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

@isTest
private class SoqlQuery_Test {
    final static String VALID_OBJECT = 'TableGridAccessible__c';
    public final static String INVALID_OBJECT = 'DoesNotExist';
    final static String INACCESSIBLE_OBJECT = 'TableGridInaccessible__c';
    
    final static String VALID_FIELDNAMES = 'Id,Name,num_IntegerField__c,txt_TextField__c';
    final static String INVALID_FIELDNAMES = 'Id,Name,Foo,Bar';
    final static String INACCESSIBLE_FIELDNAMES = 'Id,Name,txt_InaccessibleField__c';
    
    final static String VALID_FILTER = 'num_IntegerField__c <> 99';
    final static String INVALID_FILTER = 'txt_InaccessibleField__c == 34';
    
    static testMethod void testCreateWithAllParamsValid() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
            String expectedSoqlString = 'SELECT ' + VALID_FIELDNAMES + 
                                        ' FROM ' + VALID_OBJECT +
                                        ' WHERE ' + VALID_FILTER +
                                        ' ORDER BY num_IntegerField__c DESC';
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(VALID_OBJECT, VALID_FIELDNAMES).filter(VALID_FILTER).orderBy('num_IntegerField__c', true);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(false);
            }
            System.assertEquals(expectedSoqlString, soqlQuery.asString());
        }
    }
        
    static testMethod void testCreateMinimalWithAllParamsValid() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
            String expectedSoqlString = 'SELECT ' + VALID_FIELDNAMES + 
                                        ' FROM ' + VALID_OBJECT;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(VALID_OBJECT, VALID_FIELDNAMES);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(false);
            }
            System.assertEquals(expectedSoqlString, soqlQuery.asString());
        }
    }
    
    static testMethod void testCreateWithInvalidObject() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(INVALID_OBJECT, VALID_FIELDNAMES);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(true);
            }
        }
    }
    
    static testMethod void testCreateWithInaccessibleObject() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(INACCESSIBLE_OBJECT, VALID_FIELDNAMES);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(true);
            }
        }
    }
    
    static testMethod void testCreateWithInvalidFieldNames() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(VALID_OBJECT, INVALID_FIELDNAMES);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(true);
            }
        }
    }       
    
    
    static testMethod void testCreateWithInaccessibleFieldNames() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(VALID_OBJECT, INACCESSIBLE_FIELDNAMES);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(true);
            }
        }
    }       
    
    
    static testMethod void testCreateWithInvalidFilter() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(VALID_OBJECT, VALID_FIELDNAMES).filter(INVALID_FILTER);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(true);
            }
        }
    }       
    
    static testMethod void testCreateWithInvalidOrderBy() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery;
                                        
            // Exercise
            try {
                soqlQuery = new SoqlQuery(VALID_OBJECT, VALID_FIELDNAMES).orderBy('Foo', false);
            }
            catch(SoqlQuery.InvalidQueryException e) {
                // Verify
                System.assert(true);
            }
        }
    }   
    
    static testMethod void testChangeFieldNamesAfterwards() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            SoqlQuery soqlQuery = new SoqlQuery(VALID_OBJECT, 'Id,Name');
                                        
            // Exercise
            try {
                soqlQuery.selectFields('Id,Name,txt_TextField__c');
            }
            catch(SoqlQuery.InvalidQueryException e) {
                System.assert(false);
            }
            
            //Verify
            System.assertEquals(3, soqlQuery.fieldsList.size());
            System.assertEquals('txt_TextField__c', soqlQuery.fieldsList.get(2));
        }
    }
        
}