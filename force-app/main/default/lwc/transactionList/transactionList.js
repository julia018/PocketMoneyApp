import { LightningElement, wire, track, api } from 'lwc';
import Id from '@salesforce/user/Id';
import getTransactions from '@salesforce/apex/TransactionController.getTransactions';
import { updateRecord, deleteRecord, createRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    { label: 'debit', fieldName: 'debit__c', type: 'boolean', editable: true },
    { label: 'amount', fieldName: 'amount__c', type: 'number', typeAttributes: { maximumFractionDigits: 2 }, editable: true },
    { label: 'creation', fieldName: 'created__c', type: 'text' }
];

export default class RelatedContactsByForAccount extends LightningElement {
    @track columns = COLUMNS;
    @track draftValues = [];
    @api recordId;
    @track recordsCount = 0;
    selectedRecords = [];

    @wire(getTransactions, {userId: Id})
    transactions ({error, data}) {
        if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Permission denied.',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

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
            }
            else{              
                promises.add(updateRecord(recordInputs[i]));
            }
        }

        Promise.all(promises).then(records => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Transactions updated',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            return refreshApex(this.transactions);
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

    addTransaction(){
        let newTrans = {Id:"", debit__c:"", amount__c:""};
        this.transactions.data = [...this.transactions.data, newTrans];
    }

    deleteTransactions(){
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
                        message: 'Transactions deleted. Refresh the page for new balance value!',
                        variant: 'success'
                    })
                );                
                this.selectedRecords = [];
                this.isDeleteButtonDisabled = true;
                return refreshApex(this.transactions);
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