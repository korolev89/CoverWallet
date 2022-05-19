public class CustomersParserJSON {
    public AccountRecord[] accounts;

    public class AccountRecord {
        public String uuid;    //123456-123456
        public String company_name;    //Acme Corp.
        public Integer annual_revenue;    //120000
        public Integer number_employees;    //8
        public ContactRecord[] contacts;
    }

    public class ContactRecord {
        public String first_name;    //John
        public String last_name;    //Smith
        public String email;    //john@acme.com
    }

    public static CustomersParserJSON parse(String json) {
        return (CustomersParserJSON) System.JSON.deserialize(json, CustomersParserJSON.class);
    }
}