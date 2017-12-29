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

  refreshing: boolean = false;
  processing: boolean = false;
  deleteProcessing: boolean = false;
  submitError: boolean = false;


  editedSeance: Seance = new Seance();
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
    this.refreshing = true;
    this._db.getSeance()
      .finally(() => this.refreshing = false)
      .subscribe(res => {
        this.seances = res;
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

  setEditedSeance(index) {
    this.editedSeance = Object.assign({}, this.seances[index]);
    this.editedSeance.Data = this.seances[index].DataSeansu;
  }

  editSeance() {
    this._db.editSeance(this.editedSeance, this.editedSeance.Id)
      .subscribe(res => this.getSeances());
  }

}
