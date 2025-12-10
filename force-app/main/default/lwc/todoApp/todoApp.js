import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import getTodoItems from '@salesforce/apex/TodoItemController.getTodoItems';
import createTodoItem from '@salesforce/apex/TodoItemController.createTodoItem';
import updateTodoItem from '@salesforce/apex/TodoItemController.updateTodoItem';
import deleteTodoItem from '@salesforce/apex/TodoItemController.deleteTodoItem';
import updateCompletionStatus from '@salesforce/apex/TodoItemController.updateCompletionStatus';

export default class TodoApp extends LightningElement {}