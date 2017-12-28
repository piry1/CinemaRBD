import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';

@Component({
  selector: 'app-room',
  templateUrl: './room.component.html',
  styleUrls: ['./room.component.css']
})
export class RoomComponent implements OnInit {

  constructor(private _db: DbService) { }

  private rooms: any[] = [];

  ngOnInit() {
    this.getRooms();
  }

  getRooms() {
    this._db.getRoom().subscribe(res => {
      console.log(res);
      this.rooms = res;
    });
  }

}
