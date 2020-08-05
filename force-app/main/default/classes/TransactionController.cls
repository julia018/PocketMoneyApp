public with sharing class TransactionController {
    @AuraEnabled(cacheable=true)
    public static List<Transaction__c> getTransactions(Id userId) {
        
        return [SELECT Id, amount__c, debit__c, created__c FROM Transaction__c WHERE OwnerId = :userId ORDER BY created__c DESC LIMIT 50];
    }
    
}
 