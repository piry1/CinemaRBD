import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';
import { User } from '../../dbModel/user';
import { Film } from '../../dbModel/film';

@Component({
  selector: 'app-films',
  templateUrl: './films.component.html',
  styleUrls: ['./films.component.css']
})
export class FilmsComponent implements OnInit {

  user: User;
  films: Film[] = [];

  constructor(private _db: DbService) { }

  ngOnInit() {
    this.user = User.getCurrentUser();
    this.getFilms();
  }

  getFilms() {
    this._db.getFilm().subscribe((res: Film[]) => {
      this.films = res;
      //console.log(res);
    });
  }

}
