import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import getTodoItems from '@salesforce/apex/TodoItemController.getTodoItems';
import createTodoItem from '@salesforce/apex/TodoItemController.createTodoItem';
import updateTodoItem from '@salesforce/apex/TodoItemController.updateTodoItem';
import deleteTodoItem from '@salesforce/apex/TodoItemController.deleteTodoItem';
import updateCompletionStatus from '@salesforce/apex/TodoItemController.updateCompletionStatus';

export default class TodoApp extends LightningElement {
    allTasks = [];
    currentFilter = 'all';
    currentSort = 'dueDate';

    isModalOpen = false;
    modalMode = 'create';
    selectedTaskId = null;

    wiredTaskResult;

    @wire(getTodoItems)
    wiredTasks(result) {
        this.wiredTaskResult = result;

        if (result.data) {
            this.allTasks = result.data;
        } else if (error) {
            this.showToast('Error', 'Error fetching tasks', 'error');
        }
    }

    get filteredTasks() {}

    handleFilterChange(event) {
        this.currentFilter = event.target.value;
    }

    handleSortChange(event) {
        this.currentSort = event.target.value;
    }

    handleCreateTask() {
        this.modalMode = 'create';
        this.isModalOpen = true;
    }

    handleEditTask(event) {
        this.selectedTaskId = event.detail.taskId;
        this.modalMode = 'edit';
        this.isModalOpen = true;
    }

    handleSave(event) {
        const task = event.detail.task;

        if (this.selectedTaskId) {
            updateTodoItem({ id: this.selectedTaskId, task }).then(() => {
                this.isModalOpen = false;
            });
        } else {
            createTodoItem({ task }).then(() => {
                this.isModalOpen = false;
            });
        }
    }

    handleDeleteTask(event) {}

    handleCancel() {
        this.isModalOpen = false;
        this.selectedTaskId = null;
        this.modalMode = 'create';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }

    handleToggleComplete(event) {
        const taskId = event.detail.taskId;

        updateCompletionStatus({ id: taskId }).then(() => {
            this.showToast('Success', 'Task completed', 'success');
        });
    }
}