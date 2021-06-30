/**
 @author : Bhushan Sukumar (bhushan.sukumar@sage.com)
 @date : 25-08-2018

 @description : Interface class to make sure the trigger handlers will have consistent methods for processing
 various trigger events
 */

public interface TriggerHandlerInterface {
	void BeforeInsert(List<SObject> newItems);

	void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

	void BeforeDelete(Map<Id, SObject> oldItems);

	void AfterInsert(Map<Id, SObject> newItems);

	void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

	void AfterDelete(Map<Id, SObject> oldItems);

	void AfterUndelete(Map<Id, SObject> oldItems);
}