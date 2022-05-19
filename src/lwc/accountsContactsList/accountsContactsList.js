import {LightningElement} from 'lwc';
import getAllAccountsContacts from '@salesforce/apex/AccountsContactsController.getAllAccountsContacts';

export default class AccountsContactsList extends LightningElement {
    accounts;
    filteredAccounts;
    error;

    accountsCount = 0;
    recordsPerPage = 3;
    currentPage = 1;
    numberOfPages = 0;
    trimStart = 0;
    trimEnd = 0;
    paginationPages = [];

    connectedCallback() {
        this.loadAccountsContact();
    }

    loadAccountsContact() {
        getAllAccountsContacts()
            .then(result => {
                this.accounts = result;
                this.filteredAccounts = result;
                this.accountsCount = result.length;
                this.buildPagination(1);
            })
            .catch(error => {
                this.error = error;
            });
    }

    applyFilter(event) {
        this.filteredAccounts = this.accounts.filter(account => (account.Name.toLowerCase().includes(event.target.value)));
    }

    changePagination(event) {
        this.recordsPerPage = event.target.value;
        this.buildPagination(this.currentPage);
    }

    changePage(event) {
        this.currentPage = event.target.text;
        this.buildPagination(this.currentPage);
    }

    buildPagination(currentPage) {
        this.eraseValues();

        this.trimStart = (currentPage - 1) * parseInt(this.recordsPerPage);
        this.trimEnd = this.trimStart + parseInt(this.recordsPerPage);

        // this.filteredAccounts = this.accounts;
        this.filteredAccounts = this.accounts.slice(this.trimStart, this.trimEnd);

        this.numberOfPages = Math.ceil(this.accountsCount / this.recordsPerPage);
        for (let index = 1; index <= this.numberOfPages; index++) {
            this.paginationPages.push(index);
        }
    }

    eraseValues() {
        this.paginationPages = [];
        this.trimStart = 0;
        this.trimEnd = 0;
    }
}