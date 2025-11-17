import { LightningElement, api } from 'lwc';

export default class TodoFilters extends LightningElement {
    @api currentFilter = 'all';

    get allButtonClass() {
        return this.currentFilter === 'all' ? 'slds-is-active' : '';
    }

    get activeButtonClass() {
        return this.currentFilter === 'active' ? 'slds-is-active' : '';
    }

    get completedButtonClass() {
        return this.currentFilter === 'completed' ? 'slds-is-active' : '';
    }

    handleFilterChange(event) {
        const filter = event.target.dataset.filter;

        //this.currentFilter = filter;
        this.dispatchEvent(new CustomEvent('filterchange', { detail: filter }));
    }
}