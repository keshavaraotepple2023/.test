
trigger InsuranceCoverageTrigger on Insurance_Member__c (before insert, before update) {
    // Get the product and master level boundary condition data
    Product_Boundary_Condition__c productBoundaryCondition = Product_Boundary_Condition__c.getInstance();

    for (Insurance_Member__c member : Trigger.new) {
        // Check if member's annual income is below 40K
        if (member.Annual_Income__c < productBoundaryCondition.Minimum_Income__c) {
            member.Is_Eligible__c = false;
            continue;
        }

        // Check if sum assured is within the allowed range
        if (!productBoundaryCondition.Allowed_Sum_Assured__c.contains(member.Sum_Assured__c)) {
            member.Is_Eligible__c = false;
            continue;
        }

        // Check if policy tenure is within the allowed range
        if (!productBoundaryCondition.Allowed_Policy_Tenure__c.contains(member.Policy_Tenure__c)) {
            member.Is_Eligible__c = false;
            continue;
        }

        // Check if OTP authentication is received
        if (!member.OTP_Authentication_Received__c) {
            member.Is_Eligible__c = false;
            continue;
        }

        // If member is not eligible, spouse also must not be covered
        if (!member.Is_Eligible__c) {
            member.Spouse_Covered__c = false;
        }
    }
}
