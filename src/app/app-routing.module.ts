import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { CinemaComponent } from './cinema/cinema.component';
import { TicketsComponent } from './cinema/tickets/tickets.component';
import { BuyticketComponent } from './cinema/buyticket/buyticket.component';
import { FilmsComponent } from './cinema/films/films.component';
import { RoomComponent } from './cinema/room/room.component';
import { SeanceComponent } from './cinema/seance/seance.component';

const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  {
    path: 'cinema', component: CinemaComponent, children: [
      { path: '', redirectTo: 'tickets', pathMatch: 'full' },
      { path: 'tickets', component: TicketsComponent },
      { path: 'buyticket', component: BuyticketComponent },
      { path: 'films', component: FilmsComponent },
      { path: 'room', component: RoomComponent },
      { path: 'seance', component: SeanceComponent }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
