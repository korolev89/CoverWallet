public with sharing class AccountsContactsController {
    @AuraEnabled
    public static List<Account> getAllAccountsContacts() {
        return [
                SELECT Name,
                        AnnualRevenue,
                        NumberOfEmployees,
                        uuid__c,
                        Owner.Name,
                        Priority__c,
                (SELECT FirstName, LastName, Email, Owner.Name, Title FROM Contacts)
                FROM Account
        ];
    }
}