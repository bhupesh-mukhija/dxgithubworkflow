public abstract class TriggerService implements ITriggerService, Callable {
    // Trigger execution related data
    protected String handlerName { get; private set; }
    protected Boolean isHandlerActive { get; private set; }
    protected Decimal executionSeq { get; private set; }
    
	// Trigger record data
    protected List<SObject> listNewSObject { get; private set; }
    protected Map<Id, SObject> mapNewSObject { get; private set; }
    protected Map<Id, SObject> mapOldSObject { get; private set; }

    // Testing related variables
    @TestVisible public Boolean onBeforeInsert = false;
    @TestVisible public Boolean onBeforeUpdate = false;
    @TestVisible public Boolean onBeforeDelete = false;
    @TestVisible public Boolean onAfterInsert = false;
    @TestVisible public Boolean onAfterUpdate = false;
    @TestVisible public Boolean onAfterDelete = false;
    @TestVisible public Boolean onAfterUndelete = false;
    
    protected String getHandler() {
        return this.handlerName;
    }
    
    protected Boolean isHandlerActive() {
        return this.isHandlerActive;
    }
    
    protected Decimal getExecutionSequence() {
        return this.executionSeq;
    }
    
    public void setHandlerExecutionDetails(SObject iExecutionDetails) {
        handlerName = (String) iExecutionDetails.get('DeveloperName');
        isHandlerActive = (Boolean) iExecutionDetails.get('isActive__c');
        executionSeq = (Decimal) iExecutionDetails.get('Sequence__c');
    }
    
    public void setTriggerData(List<SObject> listNewSObject
                             , Map<Id, SObject> mapNewSObject
                             , Map<Id, SObject> mapOldSObject) {
        this.listNewSObject = listNewSObject;
        this.mapNewSObject = mapNewSObject;
        this.mapOldSObject = mapOldSObject;
    }
    
    public virtual void onBeforeInsert() {
        //this.throwNoContextServiceException();
    }
    public virtual void onBeforeUpdate() {
        //this.throwNoContextServiceException();
    }
    public virtual void onBeforeDelete() {
        //this.throwNoContextServiceException();
    }
    public virtual void onAfterInsert() {
        //this.throwNoContextServiceException();
    }
    public virtual void onAfterUpdate() {
        //this.throwNoContextServiceException();
    }
    public virtual void onAfterDelete() {
        //this.throwNoContextServiceException();
    }
    public virtual void onAfterUndelete() {
        //this.throwNoContextServiceException();
    }
    
    public Object call(String methodName, Map<String, Object> methodArguments) {
        switch on methodName {
            when 'onBeforeInsert' {
                this.onBeforeInsert();
                return true;
            }
            
            when 'onBeforeUpdate' {
                this.onBeforeUpdate();
                return true;
            }
            
            when 'onBeforeDelete' {
                this.onBeforeDelete();
                return true;
            }
            
            when 'onAfterInsert' {
                this.onAfterInsert();
                return true;
            }
            
            when 'onAfterUpdate' {
                this.onAfterUpdate();
                return true;
            }
            
            when 'onAfterDelete' {
                this.onAfterDelete();
                return true;
            }
            
            when 'onAfterUndelete' {
                this.onAfterUndelete();
                return true;
            }
            
            when else {
                return false;
            }
        }
    }

    // Service exception class
    public class TriggerServiceException extends Exception {}

    private TriggerServiceException throwNoContextServiceException() {
        throw new TriggerServiceException('Service cannot be called without a domain context');
    }
}