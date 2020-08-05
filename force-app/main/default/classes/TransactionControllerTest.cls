@isTest
private class TransactionControllerTest {
    
    @testSetup static void setup() {
        insertTwoTestUser();
        User firstTestUser = [SELECT Id FROM User WHERE Username = 'test1234444567@test.com'];
        Id testUserId = firstTestUser.Id;
        //insert 50 transactions
        List<Transaction__c> transList = new List<Transaction__c>();
        for(Integer i = 0; i < 50; i++) {
            Transaction__c tr = new Transaction__c(OwnerId = testUserId, Name = 'test '+ i);
            transList.add(tr);
        }
        insert transList;
    }

    @isTest static void getExistingTransactionsTest() {
        User testUser = [SELECT Id FROM User WHERE Username = 'test1234444567@test.com'];
        Id testUserId = testUser.Id;
        Test.startTest();
        List<Transaction__c> res = TransactionController.getTransactions(testUserId);
        Test.stopTest();
        System.assertEquals(50, res.size(), 'Selected truns count must be = 50!');
    }

    @isTest static void getTransactionsForNewExistingUserTest() {
        User secondTestUser = [SELECT Id FROM User WHERE Username = 'test12344445678@test.com'];
        Id testUserId = secondTestUser.Id;
        Test.startTest();
        List<Transaction__c> res = TransactionController.getTransactions(testUserId);
        Test.stopTest();
        System.assertEquals(0, res.size(), 'Selected truns count must be = 0!');

    }

    private static void insertTwoTestUser() {

        // first
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

        //second
        User y = new user();
        y.LastName = 'Test Brain';
        y.Email = 'test@test.com';
        y.Alias = 'Tcodes';
        y.Username = 'test12344445678@test.com';
        y.CommunityNickname = 'test124';
        y.LocaleSidKey = 'en_US';
        y.TimeZoneSidKey = 'GMT';
        y.ProfileID = '00e9D000000VUTGQA4';
        y.LanguageLocaleKey = 'en_US';
        y.EmailEncodingKey = 'UTF-8';
        insert y;
    }
}
