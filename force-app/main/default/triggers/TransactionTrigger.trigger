trigger TransactionTrigger on Transaction__c (after insert, after update, after delete) {
    String userId = '';
    if(Trigger.isDelete) {
        userId = Trigger.old[0].OwnerId;
    } else {
        userId = Trigger.new[0].OwnerId;
    }
    
    List<Transaction__c> userTransList = TransactionController.getTransactions(userId);
    User currentUser = UserController.getUserById(userId);
    Decimal newBalance = 0;
    for(Transaction__c transn: userTransList) {
        if(transn.debit__c) { // -amount
            newBalance -= transn.amount__c;
        } else { // +amount
            newBalance += transn.amount__c;
        }
    }

    currentUser.balance__c = newBalance;

    update currentUser;

}