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

    wiredTasksResult;

    @wire(getTodoItems)
    wiredTasks(result) {
        this.wiredTasksResult = result;

        if (result.data) {
            this.allTasks = result.data;
        } else if (result.error) {
            this.showToast('Error', 'Error fetching tasks', 'error');
        }
    }

    get filteredTasks() {
        if (!this.allTasks) return [];

        let tasks = [...this.allTasks];

        if (this.currentFilter === 'active') {
            tasks = tasks.filter(task => !task.Is_Completed__c);
        } else if (this.currentFilter === 'completed') {
            tasks = tasks.filter(task => task.Is_Completed__c);
        }

        if (this.currentSort === 'dueDate') {
            tasks.sort((a, b) => {
                const dateA = new Date(a.Due_Date__c);
                const dateB = new Date(b.Due_Date__c);
                return dateA - dateB;
            });
        } else if (this.currentSort === 'priority') {
            const priorityOrder = { 'High': 1, 'Medium': 2, 'Low': 3 };
            tasks.sort((a, b) => {
                return priorityOrder[a.Priority__c] - priorityOrder[b.Priority__c];
            });
        }
        
        return tasks;
    }

    handleFilterChange(event) {
        this.currentFilter = event.target.value;
    }

    handleSortChange(event) {
        this.currentSort = event.target.value;
    }

    handleCreate() {
        this.modalMode = 'create';
        this.isModalOpen = true;
    }

    handleEdit(event) {
        const taskId = event.detail.taskId;

        const task = this.allTasks.find(t => t.Id === taskId);

        if (task) {
            this.selectedTaskId = taskId;
            this.modalMode = 'edit';
            this.isModalOpen = true;

            setTimeout(() => {
                const modal = this.template.querySelector('c-todo-modal');

                if (modal) {
                    modal.populateForm(task);
                }
            }, 0);
        } else {
            this.showToast('Error', 'Task not found', 'error');
        }
    }

    async handleSave(event) {
        const formData = event.detail;

        try {
            if (this.modalMode === 'create') {
                await createTodoItem({
                    title: formData.title,
                    description: formData.description,
                    dueDate: formData.dueDate,
                    priority: formData.priority,
                    category: formData.category
                });

                this.showToast('Success', 'Task created successfully', 'success');
            } else { //edit mode
                await updateTodoItem({
                    todoItemId: this.selectedTaskId,
                    title: formData.title,
                    description: formData.description,
                    dueDate: formData.dueDate,
                    priority: formData.priority,
                    category: formData.category
                });
                
                this.showToast('Success', 'Task updated successfully', 'success');
            }

            await refreshApex(this.wiredTasksResult);
            this.isModalOpen = false;
        } catch (err) {
            this.showToast('Error', err.body?.message || 'Failed to save task', 'error');
        }
    }

    async handleDelete(event) {
        const taskId = event.detail.taskId;

        try {
            await deleteTodoItem({ todoItemId: taskId });
            await refreshApex(this.wiredTasksResult);

            this.showToast('Success', 'Task deleted successfully', 'success');
        } catch (err) {
            this.showToast('Error', err.body?.message || 'Failed to delete task', 'error');
        }
    }
    
    async handleToggleComplete(event) {
        const { taskId, isComplete } = event.detail;

        try {
            await updateCompletionStatus({ 
                todoItemId: taskId,
                isComplete: isComplete 
            });

            await refreshApex(this.wiredTasksResult);
        } catch (err) {
            this.showToast('Error', err.body?.message || 'Failed to update task completion status', 'error');
        }
    }

    handleCloseModal() {
        this.isModalOpen = false;
        this.selectedTaskId = null;
        this.modalMode = 'create';
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}