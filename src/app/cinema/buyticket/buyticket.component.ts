import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';
import { User } from '../../dbModel/user';
import { Ticket } from '../../dbModel/ticket';
import { Seance } from '../../dbModel/seance';
import { tick } from '@angular/core/testing';


@Component({
  selector: 'app-buyticket',
  templateUrl: './buyticket.component.html',
  styleUrls: ['./buyticket.component.css']
})
export class BuyticketComponent implements OnInit {

  user: User;
  ticket: Ticket = new Ticket();
  seances;
  selectedFilm;
  seancesNames: string[] = [];
  availableSeances: Seance[] = [];

  processing: boolean = false;
  submitSuccess: boolean = false;
  submitError: boolean = false;

  seats: any[] = [];

  constructor(private _db: DbService) { }

  ngOnInit() {
    this.checkUser();
    this.getSeances();
  }

  buyTicket() {
    this.ticket.Klient = Number(this.user.Id);
    this.processing = true;
    this.submitError = false;
    this.submitSuccess = false;

    this._db.addTicket(this.ticket)
      .finally(() => {
        this.processing = false;

        var index = this.seats.findIndex(x => x.Id == this.ticket.Rezerwacja);
        if (index > -1)
          this.seats.splice(index, 1);

        this.ticket = new Ticket();
      })
      .subscribe(res => {
        this.submitSuccess = true;

      }, err => this.submitError = true);
  }

  getSeances() {
    this.seancesNames = [];
    this._db.getSeance()
      .subscribe(res => {
        this.seances = res;
        this.seances.forEach((seance) => {
          if (this.seancesNames.indexOf(seance.Tytul) == -1)
            this.seancesNames[this.seancesNames.length] = seance.Tytul;
        });
      });
  }

  onSelectedFilmChange() {
    var title = this.seancesNames[this.selectedFilm];
    this.availableSeances = [];

    this.seances.forEach(seance => {
      if (seance.Tytul == title)
        this.availableSeances[this.availableSeances.length] = seance;
    });
  }

  checkUser() {
    this.user = User.getCurrentUser();
  }

  onSeanceChange(id: string) {
    this.getFreeSeats(id);
  }

  getFreeSeats(id: string) {
    this._db.getFreeSeats(id).subscribe(res => {
      this.seats = res;
    });
  }

}
