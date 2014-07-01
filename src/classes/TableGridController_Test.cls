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
 *	@author Robert Soesemann (robert.soesemann@up2go.com)
 */
@isTest
private class TableGridController_Test {
   
    static testMethod void happyPath() {
        // Setup
        List<TableGridAccessible__c> dummyObjects = new List<TableGridAccessible__c>();
        
        for(Integer i=0; i<2000; i++) {
            dummyObjects.add(new TableGridAccessible__c(txt_TextField__c='dfasd', num_IntegerField__c=243));
        }
        insert dummyObjects;
        
        Boolean exceptionNotThrown = true;
        
        // Exercise
        System.runAs(TableGridTestHelper.testUser()) {
            try {
                TableGridController ctlr = new TableGridController();
                ctlr.typeParam = 'TableGridAccessible__c';
                ctlr.fieldsParam = 'txt_TextField__c, num_IntegerField__c';
                ctlr.modeParam = 'edit';
                ctlr.sortDescending = true;
                
                // Exercise
                ctlr.getInit();
                ctlr.currentMode = 'view';
                ctlr.doChangeMode();
                
                ctlr.soqlQuery.sortFieldName = 'num_IntegerField__c';
                ctlr.doSort();
                
                ctlr.doEditNew();
                
                ctlr.rowManager.rows.get(4).isSelected = true;
                ctlr.rowManager.rows.get(5).isSelected = true;
                ctlr.doHandleSelection();
                ctlr.doSaveSelected();
                
                ctlr.rowManager.rows.get(1).isSelected = true;
                ctlr.doDeleteSelected();
            }
            catch(Exception e) {
                exceptionNotThrown = false;
                throw e;
            }
            System.assert(exceptionNotThrown);
        }
    }
}