import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { DbService } from '../db.service';
import { User } from '../dbModel/user';

@Component({
  selector: 'app-cinema',
  templateUrl: './cinema.component.html',
  styleUrls: ['./cinema.component.css']
})
export class CinemaComponent implements OnInit {

  constructor(private router: Router, private _bd: DbService) { }

  toogle: string = "toggled";
  user: User;


  side: { name: string, active: string, route: string, onlyAdmin: string }[] = [
    { "name": "Moje bilety", "active": "active", "route": "tickets", "onlyAdmin": "no" },
    { "name": "Kup bilet", "active": "", "route": "buyticket", "onlyAdmin": "no" },
    { "name": "Filmy", "active": "", "route": "films", "onlyAdmin": "no" },
    { "name": "Seanse", "active": "", "route": "seance", "onlyAdmin": "no" },
    { "name": "Sale", "active": "", "route": "room", "onlyAdmin": "yes" },
  ];

  ngOnInit() {
    this.checkUser();
    console.log(this.user);
  }

  checkUser() {
    this.user = User.getCurrentUser();
    if (this.user == null)
      this.router.navigateByUrl('/home');
  }

  toggleMenu() {
    if (this.toogle === "toggled")
      this.toogle = "";
    else
      this.toogle = "toggled";
  }

}
