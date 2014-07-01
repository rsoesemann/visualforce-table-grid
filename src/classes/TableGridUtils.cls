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
 *	Utils used by multiple classes 
 */
public class TableGridUtils {

    public static String normalize(String input) {
        if(input != null) {
            input = input.trim();
            input = input.replace(' ', '');
        }
        return input;
    }
    
    public static Boolean contains(List<Schema.DisplayType> aListActingAsSet, Schema.DisplayType typeToCheck){
        if(aListActingAsSet != null && aListActingAsSet.size() > 0){
            for(Schema.DisplayType aType : aListActingAsSet){
                if(aType == typeToCheck){
                    return true;
                }
            }
        } 
        return false;
    }
    
    public static void putFromString(SObject theObject, String field, Schema.DisplayType fieldType, String value) {
        if(contains(INTEGER_TYPES, fieldType))          theObject.put(field, Integer.valueOf(value));
        else if(contains(ID_TYPES, fieldType))          theObject.put(field, Id.valueOf(value));
        else if(contains(DOUBLE_TYPES, fieldType))      theObject.put(field, Double.valueOf(value));
        else if(contains(DATETIME_TYPES, fieldType))    theObject.put(field, DateTime.valueOf(value));
        else if(contains(DATE_TYPES, fieldType))        theObject.put(field, Date.valueOf(value));
        else if(contains(BOOLEAN_TYPES, fieldType))     theObject.put(field, Boolean.valueOf(value));
        else                                            theObject.put(field, value);
    }
    
    public static String hash(String input) {
        Blob inputAsBlob = Blob.valueOf(input);
        Blob hashedBlob = Crypto.generateDigest('SHA1', inputAsBlob);
        return EncodingUtil.convertToHex(hashedBlob);
    }
    
    // Type definitions taken from the free apex-lang library at
    // http://www.google.com/codesearch/p?hl=de#YxWoEAFMOlY/trunk/eclipse-project/src/classes/SObjectTableGridUtils.cls
    public static final List<Schema.DisplayType> STRING_TYPES      = new List<Schema.DisplayType>{
        Schema.DisplayType.base64
        ,Schema.DisplayType.Email
        ,Schema.DisplayType.MultiPicklist
        ,Schema.DisplayType.Phone
        ,Schema.DisplayType.Picklist
        ,Schema.DisplayType.String
        ,Schema.DisplayType.TextArea
        ,Schema.DisplayType.URL
    };
    public static final List<Schema.DisplayType> INTEGER_TYPES     = new List<Schema.DisplayType>{
        Schema.DisplayType.Integer
    };
    public static final List<Schema.DisplayType> ID_TYPES          = new List<Schema.DisplayType>{
        Schema.DisplayType.ID
        ,Schema.DisplayType.Reference
    };
    public static final List<Schema.DisplayType> DOUBLE_TYPES      = new List<Schema.DisplayType>{
        Schema.DisplayType.Currency
        ,Schema.DisplayType.Double
        ,Schema.DisplayType.Percent
    };
    public static final List<Schema.DisplayType> DATETIME_TYPES    = new List<Schema.DisplayType>{
        Schema.DisplayType.DateTime
    };
    public static final List<Schema.DisplayType> DATE_TYPES        = new List<Schema.DisplayType>{
        Schema.DisplayType.Date
    };
    public static final List<Schema.DisplayType> BOOLEAN_TYPES     = new List<Schema.DisplayType>{
        Schema.DisplayType.Boolean
        ,Schema.DisplayType.Combobox
    };  
}