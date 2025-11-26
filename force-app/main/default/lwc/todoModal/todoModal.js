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
        return this.mode === 'create' ? 'Create' : 'Save';
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
        this.title = task.Title || '';
        this.description = task.Description || '';
        this.dueDate = task.DueDate || '';
        this.priority = task.Priority || '';
        this.category = task.Category || '';
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
        this.priority = event.target.value;
    }

    handleCategoryChange(event) {
        this.category = event.target.value;
    }

    validateForm() {
        errorMessage = '';
        
        if (!this.title) {
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
        if (this.validateForm()) {
            this.isLoading = true;
            this.errorMessage = ''; 

            this.dispatchEvent(new CustomEvent('save', {
                detail: {
                    title: this.title,
                    description: this.description,
                    dueDate: this.dueDate,
                    priority: this.priority,
                    category: this.category
                }
            }));
        }
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    resetForm() {
        this.title = '';
        this.description = '';
        this.dueDate = '';
        this.priority = '';
        this.category = '';
        this.errorMessage = '';
        this.isLoading = false;
    }
}