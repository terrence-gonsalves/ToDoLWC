import { LightningElement, api } from 'lwc';

export default class TodoList extends LightningElement {
    @api tasks = [];

    get hasTasks() {
        return this.tasks && this.tasks.length > 0;
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