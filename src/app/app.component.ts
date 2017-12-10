import { Component } from '@angular/core';
import { DbService } from './db.service';
import { Film } from './dbModel/film';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  providers: [DbService]

})
export class AppComponent {

  constructor(private _db: DbService) { }

  title = 'app';
  test;

  ngOnInit() {
    /*
        this._db.getData('filmy')
          .subscribe(album => {
            this.test = album;
            console.log(this.test);
          });
          */

    var film: Film = new Film();
    film.dlugosc = "100";
    film.gatunek = "musical";
    film.rezyser = "mu";
    film.rok = "2200";
    film.tytul = "Edit Test";

    console.log(JSON.stringify(film));

    this._db.deleteFilm(17)
      .subscribe(a => {
        console.log(a);
      });

    /*
        this._db.deleteFilm()
        .subscribe(a => {
          console.log(a);
        });
    */

  }
}
