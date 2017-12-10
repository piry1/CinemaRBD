import { Component } from '@angular/core';
import { DbService } from './db.service';

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

    this._db.getData('seanseFilmu',1)
      .subscribe(album => {
        this.test = album;
        console.log(this.test);
      })
      
  }
}
