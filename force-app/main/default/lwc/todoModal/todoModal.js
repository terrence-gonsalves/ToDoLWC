import { LightningElement, api } from 'lwc';

export default class TodoModal extends LightningElement {
    @api isOpen = false;
    @api mode = 'create';
    @api taskData = null;

    title = '';
    description = '';
    dueDate = '';
    priority = '';
    category = '';

    isLoading = false;
    errorMessage = '';
    
    get modalTitle() {
        return this.mode === 'create' ? 'Create Task' : 'Edit Task';
    }

    get saveButonLabel() {
        if (this.isLoading) return 'Saving...';

        return this.mode === 'create' ? 'Create Task' : 'Save Changes';
    }

    get priorityOptions() {
        return [
            { label: 'Low', value: 'Low' },
            { label: 'Medium', value: 'Medium' },
            { label: 'High', value: 'High' }
        ];
    }

    get categoryOptions() {
        return [
            { label: 'Work', value: 'Work' },
            { label: 'Personal', value: 'Personal' },
            { label: 'Health and Wellness', value: 'Health and Wellness' },
            { label: 'Family', value: 'Family' },
            { label: 'Learning', value: 'Learning' },
            { label: 'Household', value: 'Household' },
            { label: 'Hobbies', value: 'Hobbies' },
            { label: 'Financial', value: 'Financial' },
            { label: 'Other', value: 'Other' }
        ];
    }

    @api populateForm(task) {
        if (task) {
            this.title = task.Name || '';
            this.description = task.Description__c || '';
            this.dueDate = task.DueDate__c || '';
            this.priority = task.Priority__c || 'Medium';
            this.category = task.Category__c || '';
        }
    }

    handleTitleChange(event) {
        this.title = event.target.value;
    }

    handleDescriptionChange(event) {
        this.description = event.target.value;
    }

    handleDueDateChange(event) {
        this.dueDate = event.target.value;
    }

    handlePriorityChange(event) {
        this.priority = event.detail.value;
    }

    handleCategoryChange(event) {
        this.category = event.detail.value;
    }

    validateForm() {
        this.errorMessage = '';
        
        if (!this.title || this.title.trim() === '') {
            this.errorMessage = 'Title is required';
            return false;
        }

        if (!this.dueDate) {
            this.errorMessage = 'Due Date is required';
            return false;
        }

        if (!this.priority) {
            this.errorMessage = 'Priority is required';
            return false;
        }
    }

    handleSave() {
        if (!this.validateForm()) {
            return;
        }
        
        this.dispatchEvent(new CustomEvent('save', {
            detail: {
                title: this.title.trim(),
                description: this.description.trim(),
                dueDate: this.dueDate,
                priority: this.priority,
                category: this.category
            }
        }));

        this.resetForm();
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
        this.resetForm();
    }

    resetForm() {
        this.title = '';
        this.description = '';
        this.dueDate = '';
        this.priority = 'Medium';
        this.category = '';
        this.errorMessage = '';
        this.isLoading = false;
    }
}