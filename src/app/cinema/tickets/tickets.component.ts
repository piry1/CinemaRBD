import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { DbService } from '../../db.service';
import { User } from '../../dbModel/user';
import { Ticket } from '../../dbModel/ticket';

@Component({
  selector: 'app-tickets',
  templateUrl: './tickets.component.html',
  styleUrls: ['./tickets.component.css']
})
export class TicketsComponent implements OnInit {

  user: User;
  tickets: Ticket[];

  constructor(private router: Router, private _bd: DbService) { }

  ngOnInit() {
    this.checkUser();
    this.getTickets();
  }


  checkUser() {
    this.user = User.getCurrentUser();
    if (this.user == null)
      this.router.navigateByUrl('/home');
  }

  getTickets() {

    this._bd.getUsersTickets(this.user.Id).subscribe(res => {
      this.tickets = res;
     // console.log(res);
    });
  }

}
