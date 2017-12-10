import { Injectable } from '@angular/core';
import { Http, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import { isDefined } from '@angular/compiler/src/util';
import { Film } from './dbModel/film';

@Injectable()
export class DbService {

  private apiUrl: string = 'http://93.175.96.60/cinemaapi.php/';
  private artistUrl: string;
  private albumsUrl: string;
  private albumUrl: string;

  constructor(private _http: Http) { }

  getData(str: String, id?: Number) {
    var url = this.apiUrl + str + (id ? id : "");
    return this._http.get(url)
      .map(res => res.json());
  }

  addFilm(film: Film) {
    let headers = new Headers();
    headers.append('Content-Type', 'text/plain');
    var url = this.apiUrl + 'film'
    return this._http.post(url, JSON.stringify(film), { headers: headers })
      .map(res => res.json);
  }

  
}
