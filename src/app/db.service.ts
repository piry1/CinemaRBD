import { Injectable } from '@angular/core';
import { Http, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import { isDefined } from '@angular/compiler/src/util';
import { Film } from './dbModel/film';
import { Room } from './dbModel/room';
import { Seance } from './dbModel/seance';
import { Ticket } from './dbModel/ticket';
import { User } from './dbModel/user';


@Injectable()
export class DbService {

  private apiUrl: string = 'http://93.175.96.60/cinemaapi.php/';
  private headers: Headers = new Headers();


  constructor(private _http: Http) {
    this.headers.append('Content-Type', 'text/plain');
  }

  getData(str: String, id?: Number) {
    var url = this.apiUrl + str + '/' + (id ? id : "");
    return this._http.get(url)
      .map(res => res.json());
  }

  // DODAWANIE

  private post(str: string, data: any) {
    var url = this.apiUrl + str;
    return this._http.post(url, JSON.stringify(data), { headers: this.headers })
      .map(res => res.json);
  }

  addFilm(film: Film) {
    return this.post('film', film);
  }

  addSeance(seance: Seance) {
    return this.post('seans', seance);
  }

  addRoom(room: Room) {
    return this.post('sala', room);
  }

  addUser(user: User) {
    return this.post('uzytkownik', user);
  }

  addTicket(ticket: Ticket) {
    return this.post('bilet', ticket);
  }

  // MODYFIKOWANIE

  editFilm(film: Film, id: number) {
    return this.post('film/' + id, film);
  }

  editRoom(room: Room, id: number) {
    return this.post('sala/' + id, room);
  }

  editSeance(seance: Seance, id: number) {
    return this.post('seans/' + id, seance);
  }

  //USUWANIE

  deleteFilm(id: number) {
    return this.post('dfilm/' + id, null);
  }

  deleteRoom(id: number) {
    return this.post('dsala/' + id, null);
  }

  deleteSeance(id: number) {
    return this.post('dseans/' + id, null);
  }

  deleteReservation(id: number) {
    return this.post('drezerwacja/' + id, null);
  }

}
