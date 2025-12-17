import { LightningElement, api } from 'lwc';

export default class TodoList extends LightningElement {
    @api tasks = [];
    @api isFiltered = false;

    get hasTasks() {
        return this.tasks && this.tasks.length > 0;
    }

    get showEmptyState() {
        return !this.hasTasks && !this.isFiltered;
    }

    handleToggleComplete(event) {
        this.dispatchEvent(new CustomEvent('togglecomplete', {
            detail: event.detail
        }));
    }

    handleEditTask(event) {
        this.dispatchEvent(new CustomEvent('edittask', {
            detail: event.detail
        }));
    }

    handleDeleteTask(event) {
        this.dispatchEvent(new CustomEvent('deletetask', {
            detail: event.detail
        }));
    }
}