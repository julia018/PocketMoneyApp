public class UserController {
    @AuraEnabled(cacheable=true)
    public static User getUserById(String userId){
        try {
            User u = [SELECT Name, Address, MobilePhone, Email, balance__c FROM User WHERE Id =:userId WITH SECURITY_ENFORCED];
            return u;
        } catch (System.QueryException e) {
            return null;
        }
        
    }
}

