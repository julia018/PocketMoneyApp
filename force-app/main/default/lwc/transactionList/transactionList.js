import { LightningElement, wire, track, api } from 'lwc';
import Id from '@salesforce/user/Id';
import getTransactions from '@salesforce/apex/TransactionController.getTransactions';
import { updateRecord, deleteRecord, createRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    { label: 'debit', fieldName: 'debit__c', type: 'boolean', editable: true },
    { label: 'amount', fieldName: 'amount__c', type: 'number', typeAttributes: { maximumFractionDigits: 2 }, editable: true }
];

export default class RelatedContactsByForAccount extends LightningElement {
    @track columns = COLUMNS;
    @track draftValues = [];
    @api recordId;
    @track recordsCount = 0;
    selectedRecords = [];

    @wire(getTransactions, {userId: Id})
    contacts;

    handleSave(event) {

        const recordInputs =  event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);            
            return { fields };
        });
        
        let promises = new Set();
        for(let i = 0; i < recordInputs.length; i++){
            if(JSON.stringify(recordInputs[i].fields.Id).includes('row-')){
                delete recordInputs[i].fields.Id;
                recordInputs[i].apiName = 'Transaction__c';
                recordInputs[i].fields.OwnerId = Id;
                promises.add(createRecord(recordInputs[i]))

                //change for apex create call
            }
            else{              
                promises.add(updateRecord(recordInputs[i]));

                //change for apex update call
            }
        }

        Promise.all(promises).then(records => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts updated',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            return refreshApex(this.contacts);
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating record',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });        
    }

    getSelectedRecords(event) {
        const selectedRows = event.detail.selectedRows;        
        this.recordsCount = event.detail.selectedRows.length;
        let conIds = new Set();

        for (let i = 0; i < selectedRows.length; i++) {
            conIds.add(selectedRows[i].Id);
        }
        this.selectedRecords = Array.from(conIds);
        if(this.recordsCount > 0){
            this.isDeleteButtonDisabled = false;
        }
        else{
            this.isDeleteButtonDisabled = true;
        }
    }

    addContact(){
        let newContact = {Id:"", debit__c:"", amount__c:""};
        this.contacts.data = [...this.contacts.data, newContact];
    }

    deleteContacts(){
        if(this.selectedRecords){
            let promises = new Set();
            for(let i = 0; i < this.selectedRecords.length; i++){
                promises.add(deleteRecord(this.selectedRecords[i])); 
                //change for apex call
            }
        
            Promise.all(promises).then(records =>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contact deleted',
                        variant: 'success'
                    })
                );                
                this.selectedRecords = [];
                this.isDeleteButtonDisabled = true;
                return refreshApex(this.contacts);
            }).catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            }); 
        }
    }
}