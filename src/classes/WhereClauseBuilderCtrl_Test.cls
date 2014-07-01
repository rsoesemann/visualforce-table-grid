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
 *	Tests for class WhereClauseBuilderCtrl
 */
@isTest
private class WhereClauseBuilderCtrl_Test {
    static SoqlQuery soqlQuery;
    static WhereClauseBuilderCtrl ctrl;
    
    static void beforeTest() {
        ctrl = new WhereClauseBuilderCtrl();
        soqlQuery = new SoqlQuery(TableGridTestHelper.ACCESSIBLE_SOBJECT, 'Id,Name');
        soqlQuery.filter('num_IntegerField__c <> 3');
        ctrl.soqlQuery = soqlQuery;
        ctrl.getInit();
    } 

    static testMethod void testAddAndRemoveStatement() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            beforeTest(); 
            
           	for(SelectOption field : ctrl.filterableFields) {
           		if(field.getValue() == 'num_IntegerField__c') {
           			ctrl.selectedField = field.getValue();
           			ctrl.selectedOperator = ctrl.operatorOptions[0].getValue();
            		ctrl.valueHolder.put(ctrl.selectedField, 3.33);
           			break;
           		}
           	}
            
            // Exercise
            Integer statementsBeforeAdd = ctrl.soqlQuery.filterStatements.size();
            ctrl.doAddStatement();
            Integer statementsAfterAdd = ctrl.soqlQuery.filterStatements.size();
            ctrl.hashcodeToRemove = ctrl.soqlQuery.filterStatements.get(0).hashcode;
            ctrl.doRemoveStatement();
            Integer statementsAfterRemove = ctrl.soqlQuery.filterStatements.size();
            
            // Verify
            System.assertEquals(0, statementsBeforeAdd);
            System.assertEquals(1, statementsAfterAdd);
            System.assertEquals(0, statementsBeforeAdd);
            
            System.assertEquals(null, ctrl.valueHolder.get(ctrl.selectedField));
        }
    }
}