import { LightningElement, api } from 'lwc';

export default class TodoItem extends LightningElement {
    @api task;

    get taskCardClass() {
        return this.task.Is_Completed__c ? 'task-card completed' : 'task-card';
    }

    get taskTitleClass() {
        return this.task.Is_Completed__c ? 'task-title completed' : 'task-title';
    }

    get priorityBadgeClass() {
        const priorityClass = '';
        
        switch (this.task.Priority__c.toLowerCase()) {
            case 'high':
                priorityClass = 'high-priority'; 
                break;
            case 'medium':
                priorityClass = 'medium-priority';
                break;
            case 'low':
                priorityClass = 'low-priority';
                break;
        }   

        return priorityClass;
    }

    get formattedDueDate() {
        const date = new Date(this.task.Due_Date__c);

        if (!date) return '';

        return date.toLocaleDateString('en-US', { 
            year: 'numeric', 
            month: 'short', 
            day: 'numeric' 
        });
    }

    handleToggleComplete() {
        const isCompleted = event.target.checked;

        const toggleCompleteEvent = new CustomEvent('togglecomplete', {
            detail: {
                taskId: this.task.Id,
                isCompleted
            }
        });

        this.dispatchEvent(toggleCompleteEvent);
    }

    get handleDeleteTask() {
        const deleteTaskEvent = new CustomEvent('deletetask', {
            detail: {
                taskId: this.task.Id
            }
        });

        this.dispatchEvent(deleteTaskEvent);
    }

    get handleEditTask() {
        const editTaskEvent = new CustomEvent('edittask', {
            detail: {
                taskId: this.task.Id
            }
        });

        this.dispatchEvent(editTaskEvent);
    }
}