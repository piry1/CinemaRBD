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

  refreshing: boolean = false;
  processing: boolean = false;
  deleteProcessing: boolean = false;
  submitError: boolean = false;
  newFilm: Film = new Film();
  editedFilm: Film = new Film();

  constructor(private _db: DbService) { }

  ngOnInit() {
    this.user = User.getCurrentUser();
    this.getFilms();
  }

  getFilms() {
    this.refreshing = true;
    this._db.getFilm()
      .finally(() => this.refreshing = false)
      .subscribe((res: Film[]) => {
        this.films = res;
      });
  }

  addFilm() {
    this.processing = true;
    this.submitError = false;

    this._db.addFilm(this.newFilm)
      .finally(() => { this.processing = false; })
      .subscribe(res => { this.getFilms(); }, err => { this.submitError = true; })
  };

  deleteFilm(id: number) {
    this.deleteProcessing = true;

    this._db.deleteFilm(id)
      .finally(() => this.deleteProcessing = false)
      .subscribe(res => this.getFilms())

  }

  setEditedFilm(index) {
    this.editedFilm = Object.assign({}, this.films[index]);
  }

  editFilm() {

    this._db.editFilm(this.editedFilm, this.editedFilm.Id)
      .subscribe(res => this.getFilms())
  }

}
