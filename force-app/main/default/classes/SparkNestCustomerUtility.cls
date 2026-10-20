public class SparkNestCustomerUtility {
    public static void processCustomerData() {
        
        String utilityName = 'SparkNest Customer Utility';
        Integer enquiryCount = 5;
        Boolean isDataReady = true;

        System.debug('Utility: ' + utilityName);
        System.debug('Enquiry Count: ' + enquiryCount);
        System.debug('Data Ready: ' + isDataReady);

        
        List<String> customerNames = new List<String>{
            'Rahul Sharma',
            'Aman Verma',
            'Priya Singh',
            'Neha Kapoor',
            'Rahul Sharma'
        };
        System.debug('Customer List: ' + customerNames);

        for (String customerName : customerNames) {
            System.debug('Customer: ' + customerName);
        }

        
        Set<String> customerEmails = new Set<String>{
            'rahul@gmail.com',
            'aman@gmail.com',
            'priya@gmail.com',
            'rahul@gmail.com',
            'neha@gmail.com'
        };
        System.debug('Unique Emails: ' + customerEmails);

        
        Map<Integer, String> storeMap = new Map<Integer, String>{
            101 => 'Hyderabad',
            102 => 'Bengaluru',
            103 => 'Mumbai'
        };
        System.debug('Store 102 City: ' + storeMap.get(102));

        
        Map<String, Decimal> productPrices = new Map<String, Decimal>{
            'SparkNest Phone X1' => 45000,
            'SparkNest Smart Speaker' => 8000,
            'SparkNest Laptop Pro' => 75000
        };
        System.debug('SparkNest Laptop Pro Price: ' +
            productPrices.get('SparkNest Laptop Pro'));
    }

    
    public static Decimal calculateOrderValue(Integer quantity, Decimal unitPrice) {
        return quantity * unitPrice;
    }
}