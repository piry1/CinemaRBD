import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { DbService } from '../../db.service';
import { User } from '../../dbModel/user';

@Component({
  selector: 'app-tickets',
  templateUrl: './tickets.component.html',
  styleUrls: ['./tickets.component.css']
})
export class TicketsComponent implements OnInit {

  user: User;

  constructor(private router: Router, private _bd: DbService) { }

  ngOnInit() {

  }

}
