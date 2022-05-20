@IsTest
private class AccountsContactsControllerTest {
    @TestSetup
    private static void prepareTestData() {
        Account newAccount = new Account(
                Name = 'Test1',
                uuid__c = '123'
        );
        insert newAccount;

        Contact newContact = new Contact(
                FirstName = 'FirstName',
                LastName = 'LastName',
                Email = 'email123@email.com',
                AccountId = newAccount.Id
        );
        insert newContact;
    }

    @IsTest
    private static void testSOQL() {
        List<Account> newAccountsList = AccountsContactsController.getAllAccountsContacts();
        System.assertEquals(1, newAccountsList.size());
        System.assertEquals(1, newAccountsList[0].Contacts.size());
    }
}