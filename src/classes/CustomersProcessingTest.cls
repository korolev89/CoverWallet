@isTest
private class CustomersProcessingTest {

    @isTest
    private static void testPUTmethod() {
        RestRequest req = new RestRequest();

        req.addHeader('httpMethod', 'PUT');
        req.requestUri = '/services/apexrest/customersProcessing/';
        String postData = '{"accounts":[{"uuid":"123456-123456","company_name":"Acme Corp.","annual_revenue":120000,"number_employees":8,"contacts":[{"first_name":"John","last_name":"Smith","email":"john@acme.com"},{"first_name":"Maria","last_name":"Doe","email":"maria@acme.com"}]},{"uuid":"111111-222222","company_name":"Hogwarts Corp.","annual_revenue":100000,"number_employees":3,"contacts":[{"first_name":"Harry","last_name":"Potter","email":"harry_potter@hogwarts.com"}]}]}';
        req.requestBody = Blob.valueof(postData);

        RestContext.request = req;

        Test.startTest();
        CustomersProcessing.doPut();
        Test.stopTest();

        List<Account> newAccounts = [
                SELECT Name, AnnualRevenue
                FROM Account
                ORDER BY Name ASC
        ];

        // verify accounts and contacts information, listed names & annual revenues for example
        System.assertEquals('Acme Corp.', newAccounts[0].Name);
        System.assertEquals(120000, newAccounts[0].AnnualRevenue);
        System.assertEquals('Hogwarts Corp.', newAccounts[1].Name);
        System.assertEquals(100000, newAccounts[1].AnnualRevenue);
    }
}