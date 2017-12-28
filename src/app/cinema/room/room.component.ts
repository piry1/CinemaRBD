import { Component, OnInit } from '@angular/core';
import { DbService } from '../../db.service';
import { Room } from '../../dbModel/room';

@Component({
  selector: 'app-room',
  templateUrl: './room.component.html',
  styleUrls: ['./room.component.css']
})
export class RoomComponent implements OnInit {

  constructor(private _db: DbService) { }

  private rooms: any[] = [];

  private newRoom: Room = new Room();
  private processing: boolean = false;
  private deleteProcessing: boolean = false;

  ngOnInit() {
    this.getRooms();
  }

  getRooms() {
    this._db.getRoom().subscribe(res => {
      console.log(res);
      this.rooms = res;
    });
  }

  addRoom() {
    this.processing = true;
    console.log(this.newRoom);
    if (this.newRoom.Miejsca != undefined && this.newRoom.Nazwa != undefined && this.newRoom.Rzedy != undefined)
      this._db.addRoom(this.newRoom).subscribe(res => {
        this.getRooms();
        this.processing = false;
      });

  }

  deleteRoom(id: number) {
    this.deleteProcessing = true;
    console.log(id);
    this._db.deleteRoom(id).subscribe(res => {
      this.getRooms();
      this.deleteProcessing = false;
    });
  }

}
