import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation'; // Import NavigationMixin
import getAllContacts from '@salesforce/apex/ContactController.getAllContacts';

export default class ContactGrid extends NavigationMixin(LightningElement) {
    @track contacts = [];
    @track filteredContacts = [];
    @track error;

    // Fetch Contacts from Apex
    @wire(getAllContacts)
    wiredContacts({ data, error }) {
        if (data) {
            this.contacts = data.map(contact => ({
                ...contact,
                url: `/lightning/r/Contact/${contact.Id}/view`,
            }));
            this.filteredContacts = this.contacts;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.contacts = [];
            this.filteredContacts = [];
        }
    }

    // Navigate to New Contact Page
    handleNewContact() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'new',
            },
        });
    }

    // Handle Refresh Button Click
    handleRefresh() {
        return refreshApex(this.wiredContacts);
    }

    // Handle Search Input
    handleSearch(event) {
        const searchTerm = event.target.value.toLowerCase();
        this.filteredContacts = this.contacts.filter(contact =>
            contact.Name.toLowerCase().includes(searchTerm)
        );
    }
}
