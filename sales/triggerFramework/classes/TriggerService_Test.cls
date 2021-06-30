@IsTest
public class TriggerService_Test {

    @IsTest static void setHandlerExecutionDetailsTest() {
        // GIVEN
        TriggerServiceTestHandler newTriggerServiceImpl = new TriggerServiceTestHandler();
        TriggerHandler__mdt instanceTriggerHandler = [   SELECT Id
                                                            , DeveloperName
                                                            , isActive__c
                                                            , Sequence__c 
                                                        FROM TriggerHandler__mdt
                                                        WHERE ObjectApiName__c = 'TestContext'
                                                            ORDER BY Sequence__c ].get(0);
        // WHEN
        Test.startTest();
        newTriggerServiceImpl.setHandlerExecutionDetails(instanceTriggerHandler);
        Test.stopTest();

        // THEN
        System.assertEquals(instanceTriggerHandler.DeveloperName, newTriggerServiceImpl.getHandlerCall());
        System.assertEquals(instanceTriggerHandler.Sequence__c, newTriggerServiceImpl.getExecutionSequenceCall());
        System.assertEquals(instanceTriggerHandler.isActive__c, newTriggerServiceImpl.isHandlerActiveCall());
    }

    @IsTest static void setTriggerDataTest() {
        // GIVEN
        TriggerServiceTestHandler newTriggerService = new TriggerServiceTestHandler();

        // WHEN
        Test.startTest();
        newTriggerService.setTriggerData(new List<Account>(), new Map<Id, Account>(), new Map<Id, Account>());
        Test.stopTest();

        // THEN
        System.assert(newTriggerService.getNewList() != null);
        System.assert(newTriggerService.getNewMap() != null);
        System.assert(newTriggerService.getOldMap() != null);
    }

    @IsTest static void runTriggerMethodTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandler();
        TriggerHandler__mdt instanceTriggerHandler = [   SELECT Id
                                                            , DeveloperName
                                                            , isActive__c
                                                            , Sequence__c 
                                                        FROM TriggerHandler__mdt
                                                        WHERE ObjectApiName__c = 'TestContext'
                                                            ORDER BY Sequence__c ].get(0);

        // WHEN
        Test.startTest();
        newTriggerService.call('onBeforeInsert', null);
        newTriggerService.call('onBeforeUpdate', null);
        newTriggerService.call('onBeforeDelete', null);
        newTriggerService.call('onAfterInsert', null);
        newTriggerService.call('onAfterUpdate', null);
        newTriggerService.call('onAfterDelete', null);
        newTriggerService.call('onAfterUndelete', null);
        newTriggerService.call(null, null);
        Test.stopTest();

        // THEN
        System.assert(newTriggerService.onBeforeInsert);
        System.assert(newTriggerService.onBeforeUpdate);
        System.assert(newTriggerService.onBeforeDelete);
        System.assert(newTriggerService.onAfterInsert);
        System.assert(newTriggerService.onAfterUpdate);
        System.assert(newTriggerService.onAfterDelete);
        System.assert(newTriggerService.onAfterUndelete);
    }

    @IsTest static void onBeforeInsertNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onBeforeInsert', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    @IsTest static void onBeforeUpdateNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onBeforeUpdate', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    @IsTest static void onBeforeDeleteNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onBeforeDelete', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    @IsTest static void onAfterInsertNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onAfterInsert', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    @IsTest static void onAfterUpdateNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onAfterUpdate', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    @IsTest static void onAfterDeleteNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onAfterDelete', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    @IsTest static void onAfterUndeleteNoOverrideTest() {
        // GIVEN
        TriggerService newTriggerService = new TriggerServiceTestHandlerNoOverride();
        Exception expectedException;

        // WHEN
        Test.startTest();
        try {
            newTriggerService.call('onAfterUndelete', null);
        } catch (Exception serviceException) {
            expectedException = serviceException;
        }
        Test.stopTest();

        // THEN
        //System.assert(expectedException instanceof TriggerService.TriggerServiceException);
    }

    public class TriggerServiceTestHandler extends TriggerService {

        public String getHandlerCall() {
            return this.getHandler();
        } 

        public Boolean isHandlerActiveCall() {
            return this.isHandlerActive();
        }
        
        public Decimal getExecutionSequenceCall() {
            return this.getExecutionSequence();
        }

        public List<SObject> getNewList() {
            return this.listNewSObject;
        }

        public Map<Id, SObject> getNewMap() {
            return this.mapNewSObject;
        }

        public Map<Id, SObject> getOldMap() {
            return this.mapOldSObject;
        }

        public override void onBeforeInsert() {
            this.onBeforeInsert = true;
        }

        public override void onBeforeUpdate() {
            this.onBeforeUpdate = true;
        }

        public override void onBeforeDelete() {
            this.onBeforeDelete = true;
        }

        public override void onAfterInsert() {
            this.onAfterInsert = true;
        }

        public override void onAfterUpdate() {
            this.onAfterUpdate = true;
        }

        public override void onAfterDelete() {
            this.onAfterDelete = true;
        }

        public override void onAfterUndelete() {
            this.onAfterUndelete = true;
        }
    }

    public class TriggerServiceTestHandlerNoOverride extends TriggerService {}
}