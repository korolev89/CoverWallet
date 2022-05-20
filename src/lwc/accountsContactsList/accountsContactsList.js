import {LightningElement, track} from 'lwc';
import getAllAccountsContacts from '@salesforce/apex/AccountsContactsController.getAllAccountsContacts';

export default class AccountsContactsList extends LightningElement {
    // track is using to update isVisible parameter and "refresh" records on the screen
    @track accounts = [];
    @track contacts = [];
    error = [];

    accountsTotalCount = 0;
    recordsPerPage = 3;
    currentPage = 1;
    totalPages = 1;
    trimStart = 0;
    trimEnd = 0;
    pagesArray = [];

    connectedCallback() {
        this.loadAccountsContact();
    }

    loadAccountsContact() {
        getAllAccountsContacts()
            .then(result => {
                console.log('result = ', result);
                this.accounts = result;
                const visibleContacts = [];
                this.accounts.forEach(function(account) {
                    console.log('account = ', account);
                    account.isVisible = true;
                    const contactsList = account.Contacts;
                    if (contactsList) {
                        console.log('contacts = ', contactsList);
                        contactsList.forEach(function(contact) {
                            contact.isVisible = true;
                            // error here
                            visibleContacts.push(contact);
                        })
                    }
                });
                this.contacts = visibleContacts;
                this.accountsTotalCount = result.length;
                this.buildPagination(1);
            })
            .catch(error => {
                this.error = error;
            });
    }

    applyFilter(event) {
        this.accounts.forEach(function(account) {
            if (account.Name.toLowerCase().includes(event.target.value.toLowerCase())) {
                account.isVisible = true;
            } else {
                account.isVisible = false;
            }
        });
    }

    changeRecordsPerPageCount(event) {
        this.recordsPerPage = event.target.value;
        if (this.recordsPerPage != 0) {
            this.buildPagination(this.currentPage);
        }
    }

    changePage(event) {
        this.currentPage = event.target.text;
        this.buildPagination(this.currentPage);
    }

    buildPagination(currentPage) {
        this.eraseValues();

        this.trimStart = (currentPage - 1) * parseInt(this.recordsPerPage);
        this.trimEnd = this.trimStart + parseInt(this.recordsPerPage);

        const tStart = this.trimStart;
        const tEnd = this.trimEnd;

        this.accounts.forEach(function(account, i) {
            if (i >= tStart && i < tEnd) {
                account.isVisible = true;
            } else {
                account.isVisible = false;
            }
        });

        this.totalPages = Math.ceil(this.accountsTotalCount / this.recordsPerPage);
        for (let index = 1; index <= this.totalPages; index++) {
            this.pagesArray.push(index);
        }
    }

    eraseValues() {
        this.pagesArray = [];
        this.trimStart = 0;
        this.trimEnd = 0;
        this.currentPage = 1;
    }

    displayContacts(event) {
        console.log(event.currentTarget.id);
        this.contacts.forEach(function (contact) {
            if (contact.AccountId == event.currentTarget.id.substring(0, 18)) {
                contact.isVisible = true;
            } else {
                contact.isVisible = false;
            }
        });
    }
}