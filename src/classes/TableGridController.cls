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
 *  Main Controller used by TableGrid Vf component
 */
public with sharing class TableGridController {
 
    // COMPONENT ATTRIBUTES 
    public String typeParam { get; set; }
    public String fieldsParam { get; set; }
    public String filterParam { get; set; }
    public Boolean sortDescending { get; set; }
    public Integer pageSizeParam  { get; set; } 
    public String modeParam { get; set; }
    public String sortByParam { get; set; }
    public Set<Object> selectListParam { get; set; }
    
    public String gridPageId { get; set; }
    public Boolean saveSettings { 
        get {
             return (this.saveSettings == null) ? false : this.saveSettings;
        }
        set; 
    }
    
    public String lookupFieldValue { get; set; }
     
     
    // MEMBER VARIABLES
    public SoqlQuery soqlQuery { get; set; }
    public RowManager rowManager { get; set; }
    public Boolean isInitialized  { get; private set; }
    public String previousSortField {get; set;}
    public String objectLabel  { get; private set; }
    public String objectLabelPlural  { get; private set; }
    public Boolean noneSelected { get; private set; }
    public Boolean allSelected { get; set; }
    public String parentFrameUrl { get; set; }
    public String currentMode { get; set; }
    public String currentPageUrl { 
        get {
            PageReference currentPage = ApexPages.currentPage();
            currentPage.getParameters().remove('AJAXREQUEST');
            return currentPage.getUrl();
        }
        private set;
    }
    public Boolean isPageLoaded { get; private set; }
    
    public List<ObjectListAction> customButtons { get; set; }
    public String actionName { get; set; }
    
    private TableGridState__c settings;
    
    
    // COMPONENT INIT JOEL DIETZ STYLE
    
    public void getInit() { 
        this.isPageLoaded = false;
        
        this.typeParam = TableGridUtils.normalize(this.typeParam);
        this.gridPageId = TableGridUtils.normalize(this.gridPageId);
        
        try { 
            // Try to load user's saved settings for this grid instance
            this.settings = getSettings();

            // Init from saved settings if it exists
            if(this.settings.Id != null) {
                String fieldNames = this.settings.txtl_FieldNames__c;
                this.soqlQuery = new SoqlQuery(this.typeParam, fieldNames);

                // Always use the components initial filter
                if(this.filterParam != null) {
                    this.soqlQuery.filter(filterParam);
                }
                // Recreate additional filter statements
                String filterStatements = this.settings.txtl_FilterStatements__c;
               
                if(filterStatements != null) {
                    for(String statement : filterStatements.split(';')) {
                        String[] fragments = statement.split(',');
                        
                        try {
                            FilterStatement newStatement = new FilterStatement(this.typeParam, fragments[0], fragments[1], fragments[2]) ;
                            this.soqlQuery.filterStatements.add( newStatement );
                        }
                        catch(Exception initException) {
                            //Just do not add Filter
                        }
                    }
                }
                // Order By
                if(this.settings.txt_SortBy__c != null) {
                    this.soqlQuery.orderBy(this.settings.txt_SortBy__c, this.settings.chk_SortDescending__c == null ? false : this.settings.chk_SortDescending__c);
                } 
                
                this.currentMode = this.settings.txt_Mode__c;
            }
            // Otherwise init from component attributes
            else {
                this.fieldsParam = TableGridUtils.normalize(fieldsParam);
                
                this.soqlQuery = new SoqlQuery(typeParam, fieldsParam);
                if(this.filterParam != null) {
                    this.soqlQuery.filter(this.filterParam);
                }
                if(this.sortByParam != null) {
                    this.soqlQuery.orderBy(this.sortByParam, this.sortDescending == null ? false : this.sortDescending);
                } 
                this.currentMode = this.modeParam;
            }
            this.objectLabel = SchemaCache.objectDescribe(this.typeParam).getLabel();
            this.objectLabelPlural = SchemaCache.objectDescribe(this.typeParam).getLabelPlural();
            this.noneSelected = true; 
            
            // Add lookup filter as editable statement
            if(this.currentMode == 'singleselect' && lookupFieldValue != null) {
                FilterStatement newStatement = new FilterStatement(this.typeParam, 'Name', 'contains', lookupFieldValue) ;

                // If Statement does not already exists 
                Boolean alreadyExists = false;
                for(FilterStatement fs : this.soqlQuery.filterStatements) {
                    if(fs.hashcode.equals(newStatement.hashcode)) {
                        alreadyExists = true;
                        break;
                    }
                }
                // Add it to SOQLQuery
                if(!alreadyExists) {
                    this.soqlQuery.filterStatements.add( newStatement );
                }
            }
        } 
        catch(Exception ex) {
            showMessage(ApexPages.Severity.FATAL, 'TableGrid Initialization Error: ' + ex.getMessage() + ' (Please contact your administrator)');
            return;
        }

        // Create RowManager from query
        this.rowManager = new RowManager(this.soqlQuery, this.settings); 
     
        this.previousSortField = this.soqlQuery.sortFieldName;
           
        // Mark initialisation as successful
        this.isInitialized = true;
        
        this.allSelected = false;
    }
   
   
    // ACTIONS
    
    public void doSort() {
        // Flip sort direction if sort field is unchanged
        if(soqlQuery.sortFieldName == this.previousSortField) {
            soqlQuery.sortDescending = !soqlQuery.sortDescending;
        }
        else {
            soqlQuery.sortDescending = true;
        }
        
        // Refetch rows
        rowManager.fetchRows(soqlQuery);
        previousSortField = soqlQuery.sortFieldName;
        
        // Save settings
        saveSettings();
    }
    
    public PageReference doEditNew() {
        String typePrefix = SchemaCache.objectDescribe(this.typeParam).getKeyPrefix();
        PageReference page = new PageReference('/' + typePrefix + '/e');
        
        page.getParameters().put('retURL', this.parentFrameUrl);
        page.getParameters().put('cancelURL', this.parentFrameUrl);
        page.getParameters().put('saveURL', this.parentFrameUrl);
        
        return page;
    }
    
    public void doSaveSelected() {
        try {
            List<SObject> toUpdate = new List<SObject>();
            
            for(SObjectRow row: rowManager.rows) {
                if(row.isSelected) {
                    toUpdate.add(row.delegate);
                }
            }
            if(!toUpdate.isEmpty()) {
                update toUpdate;
                showMessage(ApexPages.Severity.INFO, 'Successfully updated changed records');
            }
        } 
        catch(Exception ex){
            showMessage(ApexPages.Severity.ERROR, ex.getMessage());
        }
        
        doRefresh();
    }
    
    
    public void doDeleteSelected() {
        try {
            List<SObject> toDelete = new List<SObject>();
            
            for(SObjectRow row: rowManager.rows) {
                if(row.isSelected) {
                    toDelete.add(row.delegate);
                }
            }
            delete toDelete;
        } 
        catch(Exception ex){
            showMessage(ApexPages.Severity.ERROR, ex.getMessage());
        }
        
        doRefresh();
    }   
    
    public void doRefresh() {
        // Update field names and refetchs rows
        soqlQuery.updateFieldNames();
        rowManager.fetchRows(soqlQuery);
        
        // Save settings
        saveSettings();
    }

    public void doLoadDefaults() {
        if(settings.Id != null) {
            delete settings;
        }
        getInit();
    }  

    public void doChangeMode() {
        // Mode set already by apex:param that called this action
        
        // Save settings
        saveSettings();
    } 
    
    
    public void doHandleSelection() {
        this.noneSelected = true;
        
        for(SObjectRow row : this.rowManager.rows) {
            if(row.isSelected) {
                this.noneSelected = false;

                if(this.currentMode=='select') {
                    this.selectListParam.add('' + row.delegate.Id);
                }
            }
        }
    }
    
    
    /** 
     * Renders component only after the rest of the page is loaded
     */
    public PageReference renderOnLoad() {
        this.isPageLoaded = true;
        return null;
    }
    
    /** 
     * Selects the Object List Action with the currently selected actionName 
     * passes it the object next to it and executes it
     */
    public PageReference callButtonAction() {
        // Find relevant Action object
        ObjectListAction actionToCall;
        
        for(ObjectListAction ola: customButtons) {
            if(ola.getName() == this.actionName) {
                actionToCall = ola;
                break;
            }
        }
        
        // Execute action
        return actionToCall.execute();
    }
    
    
    /**
     * Save settings override into users custom settings
     */ 
    private void saveSettings() {
        // Quit when setting should not be saved
        if(this.saveSettings == false) {
            return;
        }
        
        // SELECT
        this.settings.txtl_FieldNames__c = soqlQuery.fieldNames;
        
        // WHERE
        String serializedStatements = '';
        Iterator<FilterStatement> iter = soqlQuery.filterStatements.iterator();
        while(iter.hasNext()) {
            serializedStatements += iter.next().asStringSetting();
            serializedStatements += iter.hasNext() ? ';' : '';
        }
        settings.txtl_FilterStatements__c = serializedStatements;
        
        // ORDER BY
        settings.txt_SortBy__c = this.previousSortField;
        settings.chk_SortDescending__c = soqlQuery.sortDescending;
        
        // PAGINATION
        settings.num_PageSize__c = this.rowManager.pageSize;
        settings.num_PageNumber__c = this.rowManager.pageNumber; 
        
        // MODE
        settings.txt_Mode__c = this.currentMode; 
        
        //See getSettings for explanation
        upsert settings;
    }
    
    /** 
     * Returns existing (in the db) or new Settings object for this tablegrid
     */
    private TableGridState__c getSettings() {
        TableGridState__c settings;
        String currentPage;
        String uniqueGridId;
                            
        // Set instance and page id dependant on calling context                                                       
        if(Test.isRunningTest()) {
            currentPage = 'calledWithoutPage';  
            uniqueGridId = 'uniqueGridId';                                      
        }
        else {
            String wholeUrl = ApexPages.currentPage().getUrl();
            Integer firstPos = wholeUrl.lastIndexOf('/');
            Integer lastPos = wholeUrl.indexOf('?', firstPos);
            if(lastPos == -1) {
                lastPos = wholeUrl.length();
            }
            currentPage = wholeUrl.substring(firstPos, lastPos);
            uniqueGridId = this.gridPageId;
        }
        
        settings = new TableGridState__c(lkp_User__c = UserInfo.getUserId(),
                                         txt_PageUrl__c = currentPage,
                                         txt_GridId__c = this.gridPageId,
                                         num_PageSize__c = this.pageSizeParam); 
        
        if(this.saveSettings) {
            // Check if settings are saved in the database
            List<TableGridState__c> fromDatabase = [SELECT txtl_FieldNames__c, txtl_FilterStatements__c, txt_SortBy__c, chk_SortDescending__c, num_PageSize__c, num_PageNumber__c, txt_Mode__c
                                                    FROM TableGridState__c
                                                    WHERE txt_GridId__c = :uniqueGridId
                                                    AND txt_PageUrl__c = :currentPage
                                                    AND lkp_User__c = :UserInfo.getUserId()
                                                    LIMIT 1];
            
            if(fromDatabase != null && !fromDatabase.isEmpty()) {
                 settings = fromDatabase[0]; 
            }
        }

        return settings;
     }
     
    

    private void showMessage(ApexPages.Severity severity, String messageText) {
        ApexPages.Message message = new ApexPages.Message(severity, messageText);
        ApexPages.addMessage(message);
    }
}