import { LightningElement, api } from 'lwc';

export default class TodoSort extends LightningElement {
    @api currentSort = 'dueDate';

    get sortOptions() {
        return [
            { label: 'Due Date', value: 'dueDate' },
            { label: 'Priority', value: 'priority' },
        ];
    }

    handleSortChange(event) {
        const selectedSort = event.detail.value;

        this.dispatchEvent(new CustomEvent('sortchange', {
            detail: { sortBy: selectedSort } 
        }));
    }
}