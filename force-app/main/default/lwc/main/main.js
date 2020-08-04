import { LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getUserInfo from '@salesforce/apex/UserController.getUserById';

export default class Main extends LightningElement {
    userId = Id;

    @track user;
    @track error;
    @wire(getUserInfo, {
        userId: Id
    })
    wiredUser({
        error,
        data
    }) {
        if (data) {
            this.user = data;
 
        } else {
            console.log('no user');
            console.log(this.userId);
            if (error) {
                console.log(error);
            this.error = error;
        }
 
        }
    }
}