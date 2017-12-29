import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';
import { User } from '../../dbModel/user';
import { Film } from '../../dbModel/film';
import { runInContext } from 'vm';

@Component({
  selector: 'app-films',
  templateUrl: './films.component.html',
  styleUrls: ['./films.component.css']
})
export class FilmsComponent implements OnInit {

  user: User;
  films: Film[] = [];

  processing: boolean = false;
  deleteProcessing: boolean = false;
  submitError: boolean = false;
  newFilm: Film = new Film();

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

  addFilm() {
    this.processing = true;
    this.submitError = false;

    this._db.addFilm(this.newFilm)
      .finally(() => { this.processing = false; })
      .subscribe(res => { this.getFilms(); }, err => { this.submitError = true; })
  };

  deleteFilm(id: number){

    this.deleteProcessing = true;

    this._db.deleteFilm(id)
    .finally(() => this.deleteProcessing = false) 
    .subscribe(res => this.getFilms())

  }

}
