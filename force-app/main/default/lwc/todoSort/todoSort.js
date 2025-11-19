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
        const sort = event.target.value;

        this.dispatchEvent(new CustomEvent('sortchange', { detail: { sort } }));
    }
}