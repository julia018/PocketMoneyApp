@isTest
private class TransactionTriggerTest {

    @isTest static void test() {
        Transaction__c tr = new Transaction__c();
        try {
            insert tr;
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }

}
