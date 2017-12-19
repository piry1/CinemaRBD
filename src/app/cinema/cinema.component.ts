import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-cinema',
  templateUrl: './cinema.component.html',
  styleUrls: ['./cinema.component.css']
})
export class CinemaComponent implements OnInit {

  constructor() { }

  toogle: string = "toggled";

  ngOnInit() {
  }

  toggleMenu() {
    if (this.toogle === "toggled")
      this.toogle = "";
    else
      this.toogle = "toggled";
  }

}
