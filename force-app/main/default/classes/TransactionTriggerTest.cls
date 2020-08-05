@isTest
private class TransactionTriggerTest {

    @isTest static void triggerAfterInsertTest() {
        Id testUserId = insertTestUser();
        User userStart = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal startUserBalance = userStart.balance__c;

        Transaction__c tr = new Transaction__c(debit__c = false, amount__c = 20.4, OwnerId = testUserId);
        insert tr;

        User userUpdated = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal newUserBalance = userUpdated.balance__c;

        System.assertEquals(20.4, newUserBalance - startUserBalance);
    }

    @isTest static void triggerAfterUpdateTest() {
        Id testUserId = insertTestUser();
        User userStart = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal startUserBalance = userStart.balance__c;

        Transaction__c tr = new Transaction__c(debit__c = true, amount__c = 10, OwnerId = testUserId);
        insert tr;

        User userMinus = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal minusBalance = userMinus.balance__c;
        System.assertEquals(-10, minusBalance);

        tr.debit__c = false;
        update tr;
        User userPlus = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal plusBalance = userPlus.balance__c;
        System.assertEquals(10, plusBalance);

    }

    @isTest static void triggerAfterDeleteTest() {
        Id testUserId = insertTestUser();
        User userStart = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal startUserBalance = userStart.balance__c;

        Transaction__c tr = new Transaction__c(debit__c = true, amount__c = 10, OwnerId = testUserId);
        insert tr;

        delete tr;
        User userUpdated = [SELECT balance__c FROM User WHERE Id = :testUserId];
        Decimal userBalanceAfterDeleteTr = userUpdated.balance__c;
        System.assertEquals(startUserBalance, userBalanceAfterDeleteTr);
    }



    private static Id insertTestUser() {
        User u = new user();
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test1234444567@test.com';
        u.CommunityNickname = 'test123';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = '00e9D000000VUTGQA4';
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;
        return u.Id;

    }   

}
