import { Injectable } from '@angular/core';
import { Http, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import { isDefined } from '@angular/compiler/src/util';
import { Film } from './dbModel/film';
import { Room } from './dbModel/room';
import { Seance } from './dbModel/seance';
import { Ticket } from './dbModel/ticket';
import { User } from './dbModel/user';
import { Response } from '@angular/http/src/static_response';
import 'rxjs/add/operator/finally';

@Injectable()
export class DbService {

  private apiUrl: string = 'http://90.156.81.49:81/cinemaapi.php/';
 // private apiUrl: string = 'http://localhost/cinemaapi.php/';
  private headers: Headers = new Headers();


  constructor(private _http: Http) {
    this.headers.append('Content-Type', 'text/plain');
  }

  private get(str: string, id?: string) {
    var url = this.apiUrl + str + '/' + (id ? id : "");
    return this._http.get(url)
      .map(res => res.json());
  }

  getData(str: string, id?: string) {
    return this.get(str, id);
  }

  checkUser(user: User) {
    return this.post('login', user);
  }

  getTickets(id?: string) {
    return this.getData('bilety', id);
  }

  getSeat(id?: string) {
    return this.getData('miejsca', id);
  }

  getFilm(id?: string) {
    return this.getData('filmy', id);
  }

  getReservation(id?: string) {
    return this.getData('rezerwacje', id);
  }

  getRoom(id?: string) {
    return this.getData('sale', id);
  }

  getSeance(id?: string) {
    return this.getData('seanse', id);
  }

  getTicket(id: string) {
    return this.getData('bilet', id);
  }

  getFilmSeance(filmId: string) {
    return this.getData('seansefilmu', filmId);
  }

  getFreeSeats(seanceId: string) {
    return this.getData('wolnemiejsca', seanceId);
  }

  getUsersTickets(id: string) {
    return this.getData('biletyusera', id);
  }


  // DODAWANIE

  private post(str: string, data: any) {
    var url = this.apiUrl + str;
    return this._http.post(url, JSON.stringify(data), { headers: this.headers })
      .map((res: Response) => res.json())
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
