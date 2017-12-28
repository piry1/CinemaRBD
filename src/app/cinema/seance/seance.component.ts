import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';

@Component({
  selector: 'app-seance',
  templateUrl: './seance.component.html',
  styleUrls: ['./seance.component.css']
})
export class SeanceComponent implements OnInit {

  private seances: any[] = [];

  constructor(private _db: DbService) { }

  ngOnInit() {
    this.getSeances();
  }

  getSeances() {
    this._db.getSeance().subscribe(res => {
      this.seances = res;
      console.log(res);
    });
  }

}
