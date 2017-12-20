import { Component, OnInit } from '@angular/core';
import { User } from '../dbModel/user';
import { DbService } from '../db.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {

  constructor(private _db: DbService, private router: Router) { }

  user: User = new User();
  haslo: string;
  passValid: string;
  ngOnInit() {
  }

  register() {
    console.log(this.user);
    var user = this.user;

    if (user.Imie != undefined && user.Nazwisko != undefined && user.Haslo != undefined && user.Login != undefined)
      if (user.Imie != "" && user.Nazwisko != "" && user.Haslo != "" && user.Login != "") {
        this._db.addUser(user).subscribe(res => {
          if (res === 0) {
            console.log("Zarejestrowano");
          } else {
            console.log("ERROR: Nie zarejestrowano");
          }
        });
      }
  }

  valuechange($event) {
    if (this.user.Haslo.length <= this.haslo.length) {
      if (this.user.Haslo == this.haslo)
        this.passValid = "is-valid";
      else
        this.passValid = "is-invalid";
    }
    else
      this.passValid = "";
  }

}
