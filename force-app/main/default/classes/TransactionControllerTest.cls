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

    /* User hasn't got access to Transaction object. */
    @isTest  static void getTransactionsProfileObjectLevelAccessNegativeTest() {
        String uniqueUserName = 'testName' + DateTime.now().getTime() + '@testorg.com';
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Custom: Sales Profile'];
        User u = new User(Alias = 'test', Email = 'standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = prof.Id,
        TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
        Test.startTest();
        System.runAs(u) {
            Boolean check = false;
            
            try {
                List<Transaction__c> resultList = TransactionController.getTransactions(u.Id);
            } catch (System.QueryException e) {                
                check = true;
            }
            System.assertEquals(true, check);
        }
        Test.stopTest();

    }

    /* User has got access to Transaction object but hasn't to field custom field 'created'. */
    @isTest  static void getTransactionsProfileFieldLevelAccessNegativeTest() {
        String uniqueUserName = 'testName' + DateTime.now().getTime() + '@testorg.com';
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Custom: Marketing Profile'];
        User u = new User(Alias = 'test', Email = 'standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = prof.Id,
        TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
        Test.startTest();
        System.runAs(u) {
            Boolean check = false;
            
            try {
                List<Transaction__c> resultList = TransactionController.getTransactions(u.Id);
            } catch (System.QueryException e) {                
                check = true;
            }
            System.assertEquals(true, check);
        }
        Test.stopTest();
    } 

    /* User has got access to Transaction object and all object's fields. */
    @isTest  static void getTransactionsProfileObjectLevelAndFieldLevelAccessPositiveTest() {
        String uniqueUserName = 'testName' + DateTime.now().getTime() + '@testorg.com';
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'Custom: Support Profile'];
        User u = new User(Alias = 'testy', Email = 'standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = prof.Id,
        TimeZoneSidKey = 'America/Los_Angeles', UserName = uniqueUserName);
        Test.startTest();
        System.runAs(u) {
            Boolean check = false;            
            try {
                List<Transaction__c> resultList = TransactionController.getTransactions(u.Id);
            } catch (System.QueryException e) {                
                check = true;
            }
            System.assertEquals(false, check);
        }
        Test.stopTest();

    }


    private static void insertTwoTestUser() {

        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        // first
        User u = new user();
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'test1234444567@test.com';
        u.CommunityNickname = 'test123';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileID = prof.Id;
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
        y.ProfileID = prof.Id;
        y.LanguageLocaleKey = 'en_US';
        y.EmailEncodingKey = 'UTF-8';
        insert y;
    }
}
