import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';
import { Seance } from '../../dbModel/seance';
import { User } from '../../dbModel/user';

@Component({
  selector: 'app-seance',
  templateUrl: './seance.component.html',
  styleUrls: ['./seance.component.css']
})
export class SeanceComponent implements OnInit {

  private seances: any[] = [];

  user: User;

  processing: boolean = false;
  deleteProcessing: boolean = false;
  submitError: boolean = false;

  newSeance: Seance = new Seance();
  films;
  rooms;
  selectedFilm;
  selectedRoom;

  constructor(private _db: DbService) { }

  ngOnInit() {
    this.user = User.getCurrentUser();
    this.getSeances();
    this.getFilms();
    this.getRooms();
  }

  getSeances() {
    this._db.getSeance().subscribe(res => {
      this.seances = res;
      console.log(res);
    });
  }

  getFilms() {
    this._db.getFilm()
      .subscribe(res => this.films = res);
  }

  getRooms() {
    this._db.getRoom()
      .subscribe(res => this.rooms = res);
  }

  addSeance() {
    this.processing = true;
    this.submitError = false;

    this._db.addSeance(this.newSeance)
      .finally(() => this.processing = false)
      .subscribe(res => this.getSeances(), err => this.submitError = true);
  }

  deleteSeance(id: number) {

    this.deleteProcessing = true;

    this._db.deleteSeance(id)
      .finally(() => this.deleteProcessing = false)
      .subscribe(res => this.getSeances());
  }

}
