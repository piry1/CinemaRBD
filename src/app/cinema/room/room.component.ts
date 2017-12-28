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
  private submitError: boolean = false;

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
    this.submitError = false;

    this._db.addRoom(this.newRoom)
      .finally(() => this.processing = false)
      .subscribe(res => {
        this.getRooms();
      }, err => { this.submitError = true; });
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
