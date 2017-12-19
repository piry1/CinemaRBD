import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.css']
})
export class NavBarComponent implements OnInit {

  showLoginInfo: boolean;

  constructor(private router: Router) {

    router.events.subscribe((val) => {
      if (val instanceof NavigationEnd) {
        this.showLoginInfo = (val["url"] === "/home" || val["urlAfterRedirects"] === "/home") ? true : false;
        console.log(val);
      }
    });
  }

  ngOnInit() {

  }

}
