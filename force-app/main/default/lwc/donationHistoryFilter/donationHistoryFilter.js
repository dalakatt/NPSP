import { LightningElement } from 'lwc';

export default class DonationHistoryFilter extends LightningElement {
    value = 'lifetime';
    
    get options() {
        return [{label : 'Lifetime', value : 'lifetime'}, 
                {label: '2020', value: '2020'}];

    }
}