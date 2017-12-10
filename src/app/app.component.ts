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

  ngOnInit() {

    this._db.getFilm()
      .subscribe(test => {
        console.log(test);
      });

  }
}
