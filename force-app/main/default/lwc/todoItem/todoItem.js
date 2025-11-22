import { LightningElement, api } from 'lwc';

export default class TodoItem extends LightningElement {
    @api task;
    isDescriptionExpanded = false;

    DESCRIPTION_LIMIT = 100;

    get taskCardClass() {
        return this.task.Is_Completed__c ? 'task-card completed' : 'task-card';
    }

    get taskTitleClass() {
        return this.task.Is_Completed__c ? 'task-title completed' : 'task-title';
    }

    get descriptionClass() {
        return this.isDescriptionExpanded ? 'description-expanded' : 'description-collapsed';
    }

    get priorityBadgeClass() {
        const priorityMap = {
            'High': 'slds-theme_error',
            'Medium': 'slds-theme_warning',
            'Low': 'slds-theme_success'
        };

        return priorityMap[this.task.Priority__c] || '';
    }

    get showReadMore() {
        if (!this.task.Description__c) return false;

        return this.task.Description__c.length > this.DESCRIPION_LIMIT;
    }

    get displayDescription() {
        if (!this.task.Description__c) return '';

        if (this.isDescriptionExpanded || !this.showReadMore) {
            return this.task.Description__c;
        }

        return this.task.Description__c.substring(0, this.DESCRIPTION_LIMIT) + '...';
    }

    get readMoreLabel() {
        return this.isDescriptionExpanded ? 'Read Less' : 'Read More';
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

    handleReadMore() {
        this.isDescriptionExpanded = !this.isDescriptionExpanded;
    }

    handleToggleComplete(event) {
        const isCompleted = event.target.checked;

        this.dispatchEvent(new CustomEvent('togglecomplete', {
            detail: {
                taskId: this.task.Id,
                isCompleted
            }
        }));
    }

    handleDeleteTask() {
        this.dispatchEvent(new CustomEvent('deletetask', {
            detail: {
                taskId: this.task.Id
            }
        }));
    }

    handleEditTask() {
        this.dispatchEvent(new CustomEvent('edittask', {
            detail: {
                taskId: this.task.Id
            }
        }));
    }
}