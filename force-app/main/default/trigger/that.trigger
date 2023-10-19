
trigger AccountTrigger on Account (before insert, before update) {
    // Check for duplicate accounts
    Set<String> accountNames = new Set<String>();
    for (Account acc : Trigger.new) {
        accountNames.add(acc.Name.toLowerCase());
    }
    
    Map<String, Account> existingAccounts = new Map<String, Account>([
        SELECT Id, Name FROM Account WHERE Name IN :accountNames]);
    
    for (Account acc : Trigger.new) {
        if (existingAccounts.containsKey(acc.Name.toLowerCase())) {
            acc.addError('Duplicate account found.');
        }
    }
}

