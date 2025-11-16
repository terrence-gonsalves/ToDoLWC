import { LightningElement } from 'lwc';

export default class TodoFab extends LightningElement {
    handleCreateTask() {
        this.dispatchEvent(new CustomEvent('createtask'));
    }
}