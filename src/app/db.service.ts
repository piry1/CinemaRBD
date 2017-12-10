import { Injectable } from '@angular/core';
import { Http, Headers } from '@angular/http';
import 'rxjs/add/operator/map';
import { isDefined } from '@angular/compiler/src/util';

@Injectable()
export class DbService {

  private searchUrl: string = 'http://93.175.96.60/cinemaapi.php/';
  private artistUrl: string;
  private albumsUrl: string;
  private albumUrl: string;

  constructor(private _http: Http) { }

  getData(str: String, id?: Number) {
    this.searchUrl += 'filmy/' + (id ? id : "");
    return this._http.get(this.searchUrl)
      .map(res => res.json());
  }

}
