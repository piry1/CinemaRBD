import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { HomeComponent } from './home/home.component';
import { CinemaComponent } from './cinema/cinema.component';
import { TicketsComponent } from './cinema/tickets/tickets.component';
import { BuyticketComponent } from './cinema/buyticket/buyticket.component';
import { FilmsComponent } from './cinema/films/films.component';
import { RoomComponent } from './cinema/room/room.component';
import { SeanceComponent } from './cinema/seance/seance.component';
import { AuthGuard } from './auth.guard';
import { AdminGuard } from './admin.guard';

const routes: Routes = [
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: 'home', component: HomeComponent },
  {
    path: 'cinema', component: CinemaComponent, canActivate: [AuthGuard], children: [
      { path: '', redirectTo: 'tickets', pathMatch: 'full', canActivate: [AuthGuard] },
      { path: 'tickets', component: TicketsComponent, canActivate: [AuthGuard] },
      { path: 'buyticket', component: BuyticketComponent, canActivate: [AuthGuard] },
      { path: 'films', component: FilmsComponent, canActivate: [AuthGuard] },
      { path: 'room', component: RoomComponent, canActivate: [AuthGuard, AdminGuard] },
      { path: 'seance', component: SeanceComponent, canActivate: [AuthGuard] }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
