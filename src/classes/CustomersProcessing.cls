@RestResource(urlMapping='/customersProcessing/*')
global with sharing class CustomersProcessing {
    public static Id agentLooId = '0052p00000BtFL4AAN';
    public static Id agentMedId = '0052p00000BtFLEAA3';
    public static Id agentHijId = '0052p00000BtFLJAA3';

    @HttpPut
    global static void doPut() {
        CustomersParserJSON parsedJSON = CustomersParserJSON.parse(RestContext.request.requestBody.toString());

        List<Account> accountsToUpsert = new List<Account>();
        List<Contact> contactsToUpsert = new List<Contact>();
        for (CustomersParserJSON.AccountRecord accountRecord : parsedJSON.accounts) {
            Integer annualRevenue = accountRecord.annual_revenue;
            Id ownerId = System.UserInfo.getUserId();
            String priority = '';
            if (annualRevenue > 0 && annualRevenue <= 50000) {
                ownerId = agentLooId;
                priority = 'Low';
            } else if (annualRevenue > 50000 && annualRevenue <= 100000) {
                ownerId = agentMedId;
                priority = 'Medium';
            } else if (annualRevenue > 100000) {
                ownerId = agentHijId;
                priority = 'High';
            }
            System.debug('ownerId = ' + ownerId);
            System.debug('agentLooId = ' + agentLooId);
            accountsToUpsert.add(new Account(
                    Name = accountRecord.company_name,
                    AnnualRevenue = annualRevenue,
                    NumberOfEmployees = accountRecord.number_employees,
                    uuid__c = accountRecord.uuid,
                    OwnerId = ownerId,
                    Priority__c = priority
            ));

            List<CustomersParserJSON.ContactRecord> contacts = accountRecord.contacts;
            for (CustomersParserJSON.ContactRecord contactRecord : contacts) {
                contactsToUpsert.add(new Contact(
                        Account = new Account(uuid__c = accountRecord.uuid),
                        FirstName = contactRecord.first_name,
                        LastName = contactRecord.last_name,
                        Email = contactRecord.email,
                        OwnerId = ownerId
                ));
            }
        }

        System.debug('accountsToUpsert = ' + accountsToUpsert);

        if (!accountsToUpsert.isEmpty()) {
            try {
                upsert accountsToUpsert uuid__c;
            } catch (DmlException e) {
                System.debug('Exception : ' + e);
            }
        }

        System.debug('contactsToUpsert = ' + contactsToUpsert);

        if (!contactsToUpsert.isEmpty()) {
            try {
                upsert contactsToUpsert Email;
            } catch (DmlException e) {
                System.debug('Exception : ' + e);
            }
        }
    }
}

