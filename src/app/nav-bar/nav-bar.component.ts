import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { DbService } from '../db.service';
import { User } from '../dbModel/user';


@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.css']
})
export class NavBarComponent implements OnInit {

  showLoginInfo: boolean;
  user: User = new User();

  constructor(private router: Router, private _bd: DbService) {

    router.events.subscribe((val) => {
      if (val instanceof NavigationEnd) {
        this.showLoginInfo = (val["url"] === "/home" || val["urlAfterRedirects"] === "/home") ? true : false;
        //console.log(val);
      }
    });
  }

  ngOnInit() {

  }

  login() {
    var u = this.user;
    this._bd.checkUser(u).subscribe((res: User[]) => {
     // console.log(res);
      if (res != undefined && res.length > 0) {
        this.user = res[0];
        //console.log(this.user);
        User.setCurrentUser(this.user);
        this.router.navigateByUrl('/cinema');
      }else{
        console.log("Niepoprawny login lub hasło")
      }
    });


  }

  logout() {
    User.removeCurrentUser();
    this.router.navigateByUrl('/home');
  }

}
