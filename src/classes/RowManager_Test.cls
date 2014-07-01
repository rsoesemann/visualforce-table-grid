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
 *	Tests for the RowManager class
 */
@isTest
private class RowManager_Test {
    static RowManager rowManager;
    static SoqlQuery soqlQuery;
    
    
    /** 
     * Before class loads create 100 random test objects to work with
     */
    static {
        SObject o = TableGridTestHelper.newTestSObject();
        o.put(TableGridTestHelper.TEXT_FIELD, 'value');
        
        List<SObject> toInsert = new List<Sobject>();
        for(Integer i=0; i<100; i++) {
            toInsert.add(o.clone());
        }
        o.put(TableGridTestHelper.TEXT_FIELD, 'otherValue');
        toInsert.add(o.clone());
        insert toInsert;
    } 
    
    
    static void beforeTest() {
        soqlQuery = new SoqlQuery('TableGridAccessible__c', 'Id,Name,num_IntegerField__c,txt_TextField__c')
                            .filter('num_IntegerField__c <> 99')
                            .orderBy('Name', true);
                            System.debug('#'+soqlQuery.asString());
        rowManager = new RowManager(soqlQuery, new TableGridState__c());
    }
    
    
    static testMethod void testDisplayWithDefaultPageSize() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            
            // Verify
            System.assertEquals(1, rowManager.pageNumber);
            System.assertEquals(101, rowManager.recordCount);
            System.assertEquals(11, rowManager.pageCount);
            System.assert(rowManager.previousSkipPageNumbers.isEmpty());
            System.assertEquals(new Integer[]{2,3,4}, rowManager.nextSkipPageNumbers);
        }
    }
    
    
    /**
     * Verifies, that changes of the page size are handled.
     */
    static testMethod void testChangePageSize() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            
            // Exercise
            rowManager.pageSize = 50;
            
            // Verify
            System.assertEquals(3, rowManager.pageCount);
        }
    }
    
    static testMethod void testDisplayWithCustomPageSize() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            
            // Exercise
            rowManager.pageSize = 33;
            
            // Verify
            System.assertEquals(4, rowManager.pageCount);
        }
    }
    
    static testMethod void testSkipToPage() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            
            // Exercise
            rowManager.pageNumber = 11; 
            rowManager.skipToPage();
            
            // Verify
            System.assertEquals(11, rowManager.pageNumber);
            System.assert(rowManager.nextSkipPageNumbers.isEmpty());
            System.assertEquals(new Integer[]{8,9,10}, rowManager.previousSkipPageNumbers);
        }
    }
    
    static testMethod void testNextPrev() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            Integer stepsForward = 0;
            Integer stepsBackward = 0;
            beforeTest();
            
            // Exercise
            while(rowManager.pageNumber < rowManager.pageCount) {
                rowManager.loadNextPage();
                stepsForward++;
            }
            while(rowManager.pageNumber > 1) {
                rowManager.loadPreviousPage();
                stepsBackward++;
            }
            
            // Verify
            System.assertEquals(10, stepsForward);
            System.assertEquals(10, stepsBackward);
        }
    }
    
    static testMethod void testLastFirst() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            
            // Exercise
            rowManager.loadLastPage();
            Integer pageWhenLast = rowManager.pageNumber;
            
            rowManager.loadFirstPage();
            Integer pageWhenFirst = rowManager.pageNumber;
            
            // Verify
            System.assertEquals(11, pageWhenLast);
            System.assertEquals(1, pageWhenFirst);
        }
    }
    
    static testMethod void testRefetchRowsOnFilterChange() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            Integer rowsBefore = rowManager.recordCount;
            
            // Exercise
            soqlQuery.filter('txt_TextField__c = \'otherValue\'');
            rowManager.fetchRows(soqlQuery);
            Integer rowsAfter = rowManager.recordCount;
            
            // Verify
            System.assertNotEquals(rowsBefore, rowsAfter);
        }
    }
        
    static testMethod void testRefetchRowsOnFieldsChange() {
        System.runAs(TableGridTestHelper.testUser()) { 
            // Setup
            beforeTest();
            rowManager.rows[0].delegate.get('txt_TextField__c');
            
            // Exercise
            soqlQuery.selectFields('Id, Name');
            soqlQuery.orderBy('Id',false); 
            rowManager.fetchRows(soqlQuery);
            Integer rowsAfter = rowManager.recordCount;
            
            // Verify
            try {
                rowManager.rows[0].delegate.get('txt_TextField__c');
                System.assert(false); // Line should not be reached
            }
            catch(Exception ignore) {}
        }
    }
}