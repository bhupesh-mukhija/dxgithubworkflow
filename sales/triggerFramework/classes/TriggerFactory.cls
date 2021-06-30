public class TriggerFactory {
    // Current object describe information
    private Schema.DescribeSObjectResult sObjectDescribe;
    
    // All trigger handlers of the object
    private List<TriggerService> listTriggerHandlers;

    // All trigger handlers of the object
    private Boolean isTriggerEnabled;
    
    // Constructor, not instantiable outside
    private TriggerFactory() {
        this.sObjectDescribe = Trigger.new != null 
            ? Trigger.new.getSObjectType().getDescribe() 
            : Trigger.old.getSObjectType().getDescribe();
        this.listTriggerHandlers = new List<TriggerService>();
        this.isTriggerEnabled = this.isExecutionEnabled();
    }

    // Constructor, not instantiable outside with custom setting execution control
    private TriggerFactory(SObject csExecutionControl) {
        this.sObjectDescribe = Trigger.new != null 
            ? Trigger.new.getSObjectType().getDescribe() 
            : Trigger.old.getSObjectType().getDescribe();
        this.listTriggerHandlers = new List<TriggerService>();
        this.isTriggerEnabled = Test.isRunningTest() ? true 
            : (csExecutionControl != null 
                && csExecutionControl.getSObjectType().getDescribe().fields.getMap().containsKey('RunTrigger__c')
                && (csExecutionControl.get('RunTrigger__c') != null 
                    ? (Boolean) csExecutionControl.get('RunTrigger__c') : false));
    }
    
    private void executeHandlers() {
        // Execute all handlers for an event
        switch on Trigger.operationType {
            when BEFORE_UPDATE {
                this.callHandlerMethods('onBeforeUpdate');
            }

            when BEFORE_INSERT {
                this.callHandlerMethods('onBeforeInsert');
            }

            when BEFORE_DELETE {
                this.callHandlerMethods('onBeforeDelete');
            }

            when AFTER_UPDATE {
                this.callHandlerMethods('onAfterUpdate');
            }

            when AFTER_INSERT {
                this.callHandlerMethods('onAfterInsert');
            }

            when AFTER_DELETE {
                this.callHandlerMethods('onAfterDelete');
            }

            when AFTER_UNDELETE {
                this.callHandlerMethods('onAfterUndelete');
            }
        }
    }
    
    private void callHandlerMethods(String methodName) {
        for (TriggerService eachService :this.listTriggerHandlers) {
            eachService.call(methodName, null);
        }
    }
    
    private Boolean isExecutionEnabled() {
        // Check if trigger execution is enabled for the object, default false.
        List<TriggerObject__mdt> listTrigger = [ SELECT Id
                                                	, RunTrigger__c 
                                                 FROM TriggerObject__mdt
                                                 WHERE ApiName__c = :this.sObjectDescribe.getName() ];
        if (!listTrigger.isEmpty()) {
            return listTrigger.get(0).RunTrigger__c;
        } else {
            return false;
        }
    }
    
    private List<TriggerHandler__mdt> getTriggerHandlers() {
        // Get all handlers for the object
        return [ SELECT Id
                	, DeveloperName
                	, isActive__c
                	, Sequence__c 
                 FROM TriggerHandler__mdt
                 WHERE ObjectApiName__c = :this.sObjectDescribe.getName()
               	    AND isActive__c = true
                 ORDER BY Sequence__c ];
    }

    private static void handleExecution(TriggerFactory newFactory) {
        TriggerService serviceHandler;
        // Get handlers
        for (TriggerHandler__mdt eachTriggerHandler :newFactory.getTriggerHandlers()) {
            serviceHandler = (TriggerService) Type.forName(eachTriggerHandler.DeveloperName).newInstance();
            serviceHandler.setHandlerExecutionDetails(eachTriggerHandler);
            serviceHandler.setTriggerData(Trigger.new, Trigger.newMap, Trigger.oldMap);
            newFactory.listTriggerHandlers.add(serviceHandler);
        }

        if (newFactory.listTriggerHandlers != null && !newFactory.listTriggerHandlers.isEmpty()) {
            // Looping twice but reducing cyclomatic complexity
            newFactory.executeHandlers();
        }
    }

    public static void executeTrigger() {
        TriggerFactory newFactory = new TriggerFactory();
        if (newFactory.isTriggerEnabled) {
            TriggerFactory.handleExecution(newFactory);
        }
    }

    public static void executeTrigger(SObject csExecutionControl) {
        TriggerFactory newFactory = new TriggerFactory(csExecutionControl);
        if (newFactory.isTriggerEnabled != null && newFactory.isTriggerEnabled) {
            TriggerFactory.handleExecution(newFactory);
        }
    }
}