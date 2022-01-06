import { api, LightningElement, track } from 'lwc';
import getYearsWithDonation from '@salesforce/apex/DonationHistoryController.getYearsWithDonations'
export default class DonationHistoryFilter extends LightningElement {
    value = 'lifetime';
    
    @track
    options = [];

    @api
    contactId
    connectedCallback() {

        getYearsWithDonation({contactId : this.contactId})
        .then(
            result => {
                this.options = this.generateOptionsFromYearsList(this.generateYearList(result));
                console.info(this.options);
            }).catch(error => {
        
                console.info(error)}
                );
    }

    generateOptionsFromYearsList(yearList){

        let toReturn =[ {label: 'Lifetime', value: 'lifetime'}];
        yearList.forEach( year => {
            toReturn.push({label: '' + year, value: '' + year});
        });
        return toReturn;
    } 

    generateYearList(result){
        let toReturn =[];
        for (let i = result[0]; i >= result[result.length - 1]; i--) {
            toReturn.push(i);
        }
        return toReturn;

    }
    handleOnchange(e) {
        this.value = e.detail.value;
        this.dispatchEvent(new CustomEvent('filter', {detail: this.value}));
    }

}