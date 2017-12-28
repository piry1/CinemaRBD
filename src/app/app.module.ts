import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { HttpModule } from '@angular/http';
import { FormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';
import { CustomFormsModule } from 'ng2-validation'

import { AppComponent } from './app.component';
import { NavBarComponent } from './nav-bar/nav-bar.component';
import { FooterComponent } from './footer/footer.component';
import { HomeComponent } from './home/home.component';
import { CinemaComponent } from './cinema/cinema.component';
import { RegisterComponent } from './register/register.component';
import { TicketsComponent } from './cinema/tickets/tickets.component';
import { BuyticketComponent } from './cinema/buyticket/buyticket.component';
import { FilmsComponent } from './cinema/films/films.component';
import { SeanceComponent } from './cinema/seance/seance.component';
import { RoomComponent } from './cinema/room/room.component';


@NgModule({
  declarations: [
    AppComponent,
    NavBarComponent,
    FooterComponent,
    HomeComponent,
    CinemaComponent,
    RegisterComponent,
    TicketsComponent,
    BuyticketComponent,
    FilmsComponent,
    SeanceComponent,
    RoomComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpModule,
    FormsModule,
    CustomFormsModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
