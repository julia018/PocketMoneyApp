public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static List<Transaction__c> getTransactions(Id userId) {
        
        return [SELECT Id, amount__c, debit__c FROM Transaction__c WHERE OwnerId = :userId LIMIT 50];
    }

    @AuraEnabled
    public static void deleteTransactions(list<Id> transList){
        try {
            list<Transaction__c> listTransToDelete = new list<Transaction__c>();
            System.debug('lsttransIds ====> ' + transList);
            for(Id idTrans : transList) {
                listTransToDelete.add(new Transaction__c(Id = idTrans));
            }
            if(!listTransToDelete.isEmpty()) {
                delete listTransToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}
 