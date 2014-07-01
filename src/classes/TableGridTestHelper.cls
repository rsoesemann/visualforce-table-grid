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
 *	Test Helper used by multiple Test classes
 */
public class TableGridTestHelper {
    final static String TESTUSER_PROFILE = 'U2G_TestUserProfile';
    public final static String ACCESSIBLE_SOBJECT = 'TableGridAccessible__c';
    public final static String TEXT_FIELD = 'txt_TextField__c';
    public final static String INTEGER_FIELD = 'num_IntegerField__c';
    public final static String INACCESSIBLE_FIELD = 'txt_InaccessibleField__c';
    public final static String INACCESSIBLE_SOBJECT = 'TableGridInaccessible__c'; 
     
    public static Schema.SObjectField textField() {
        return SchemaCache.field(ACCESSIBLE_SOBJECT, TEXT_FIELD);
    }
    public static Schema.SObjectField integerField() {
        return SchemaCache.field(ACCESSIBLE_SOBJECT, INTEGER_FIELD);
    }
    
    public static User testUser() {
        return userOfType(TESTUSER_PROFILE);
    }
    
    public static SObject newTestSObject() {
        return SchemaCache.object(ACCESSIBLE_SOBJECT).newSObject();
    }   
     
    public static Integer indexOfIn(String value, List<SelectOption> optionList) {
        for(Integer index=0; index<optionList.size(); index++) {
            SelectOption o = optionList.get(index);
            
            if(o.getValue().equals(value)) {
                return index;
            }
        }
        return -1;
    }
    
    public static User userOfType(String pName) {
         Profile p = [select id from profile where name=:pName]; 
         String rndTxt = rndTxt();
         User u = new User(alias = rndTxt, email=rndTxt+'@testorg.com', 
              emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
              localesidkey='en_US', profileid = p.Id, 
              timezonesidkey='America/Los_Angeles', username=rndTxt+'@testorg.com');
        insert u;     
        return u;            
    }
    
    public static String rndTxt() {
        String result = '';
        for(Integer i=0; i<8; i++) {
            Integer pos = (Math.random() * 25).intValue();
            result += 'abcdefghijklmnopqrstuvwxyz'.substring(pos, pos+1);
        }
        return result;
     }
}