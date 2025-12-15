import { LightningElement, api } from 'lwc';

export default class TodoFilters extends LightningElement {
    @api currentFilter = 'all';

    get allButtonClass() {
        return this.currentFilter === 'all' 
            ? 'slds-button slds-button_neutral slds-is-active' 
            : 'slds-button slds-button_neutral';
    }

    get activeButtonClass() {
        return this.currentFilter === 'active' 
            ? 'slds-button slds-button_neutral slds-is-active' 
            : 'slds-button slds-button_neutral';
    }

    get completedButtonClass() {
        return this.currentFilter === 'completed' 
            ? 'slds-button slds-button_neutral slds-is-active' 
            : 'slds-button slds-button_neutral';
    }

    handleFilterChange(event) {
        const filter = event.target.dataset.filter;
        
        this.dispatchEvent(new CustomEvent('filterchange', { detail: { filter } }));
    }
}