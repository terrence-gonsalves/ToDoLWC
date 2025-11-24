import { LightningElement, api } from 'lwc';

export default class TodoModal extends LightningElement {
    @api isOpen = false;
    @api mode = 'create';
    @api taskData = null;
    
    get modalTitle() {
        return this.mode === 'create' ? 'Create Task' : 'Edit Task';
    }
}