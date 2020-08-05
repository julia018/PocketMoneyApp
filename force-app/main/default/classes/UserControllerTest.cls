@isTest
private class UserControllerTest {

    @testSetup static void setup() {
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
    }

    @isTest static void getUserByIdTest() {
        User testUser = [SELECT id FROM User WHERE Username = 'test1234444567@test.com'];
        Id userId = testUser.Id;
        User resUser = UserController.getUserById(userId);

        System.assertEquals('test@test.com', resUser.Email);
    }

}
