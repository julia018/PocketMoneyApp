public with sharing class UserController {
    @AuraEnabled(cacheable=true)
    public static User getUserById(String userId){
        User u = [SELECT Name, Address, MobilePhone, Email FROM User WHERE Id =:userId];
        return u;
    }
}

