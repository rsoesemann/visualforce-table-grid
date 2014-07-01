/*
Copyright (c) 2012 Up2Go International LLC
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
 *	Tests for the SelectClauseBuilderCtrl
 */
@isTest
private class SelectClauseBuilderCtrl_Test {
    static SelectClauseBuilderCtrl ctrl;
    static SoqlQuery soqlQuery;
     
    /**
     * Before each test method runs initialize controller and bind it to test page
     */
     static void beforeTest() {
        ctrl = new SelectClauseBuilderCtrl();
        soqlQuery = new SoqlQuery(TableGridTestHelper.ACCESSIBLE_SOBJECT, 'id,name');
        ctrl.soqlQuery = soqlQuery;
        ctrl.getInit();
    }

    /**
     * Verify that on add the selected options are moved from the left to the right list
     */
    static testMethod void testIfSelectedFieldsAreInRightList() {
        System.runAs(TableGridTestHelper.testUser()) {
            // Setup
            beforeTest();
             
            // Verify
            System.assertNotEquals(-1, TableGridTestHelper.indexOfIn('id', ctrl.displayedFields));
            System.assertNotEquals(-1, TableGridTestHelper.indexOfIn('name', ctrl.displayedFields));
        }
    }
}