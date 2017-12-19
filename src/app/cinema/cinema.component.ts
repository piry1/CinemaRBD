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

  ngOnInit() {
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
