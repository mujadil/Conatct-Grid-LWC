public with sharing class ContactController {
    /**
     * @description Get all contacts with specific fields.
     * @return List of Contact records with default fields.
     */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getAllContacts() {
        // Check for read access on Contact
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Contact records.');
        }

        try {
            // Fetch contacts with specific fields
            return [
                SELECT Id, Name, AccountId, AssistantName, Email
                FROM Contact
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching contacts: ' + e.getMessage());
        }
    }

    /**
     * @description Get a single contact by ID with specific fields.
     * @param contactId The ID of the contact to fetch.
     * @return The Contact record with specified fields.
     */
    @AuraEnabled(cacheable=true)
    public static Contact getContactById(Id contactId) {
        // Check for read access on Contact
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Contact records.');
        }

        try {
            // Fetch the specific contact
            return [
                SELECT Id, Name, AccountId, AssistantName, Email
                FROM Contact
                WHERE Id = :contactId
                LIMIT 1
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching contact: ' + e.getMessage());
        }
    }
}
