/**
 @author : Bhushan Sukumar (bhushan.sukumar@sage.com)
 @date : 28-07-2018

 @description : Dispatcher class that will be called from the trigger class. Will be used to route various triggers via
 this single dispatcher class.
 */

public without sharing class TriggerDispatcher {
	public static void Run(TriggerHandlerInterface handler) {
		if (Trigger.IsBefore) {
			if (Trigger.isUpdate) {
				handler.BeforeUpdate(Trigger.newMap, Trigger.oldMap);
			} else if (Trigger.isDelete) {
				handler.BeforeDelete(Trigger.oldMap);
			} else if (Trigger.isInsert) {
				handler.BeforeInsert(Trigger.new);
			}
		}

		if (Trigger.isAfter) {
			if (Trigger.isUpdate) {
				handler.AfterUpdate(Trigger.newMap, Trigger.oldMap);
			} else if (Trigger.isDelete) {
				handler.AfterDelete(Trigger.oldMap);
			} else if (Trigger.isInsert) {
				handler.AfterInsert(Trigger.newMap);
			} else if (Trigger.isUndelete) {
				handler.AfterUndelete(Trigger.oldMap);
			}
		}
	}
}