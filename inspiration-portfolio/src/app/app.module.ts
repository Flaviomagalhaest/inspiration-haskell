import { BrowserModule } from '@angular/platform-browser';
import { ErrorHandler, NgModule } from '@angular/core';
import { IonicApp, IonicErrorHandler, IonicModule } from 'ionic-angular';
import { SplashScreen } from '@ionic-native/splash-screen';
import { StatusBar } from '@ionic-native/status-bar';
import { MyApp } from './app.component';
import { HomePage } from '../pages/home/home';

import {PrincipalPage} from '../pages/principal/principal';

import {IonRatingComponent} from '../components/ion-rating/ion-rating';
import {PartidaPage} from '../pages/partida/partida';

import { HttpClientModule } from '@angular/common/http';
import {YoutubePipe} from '../pipes/youtube/youtube';
import {PipesModule} from '../pipes/pipes.module';

@NgModule({
  declarations: [
    MyApp,
    IonRatingComponent,
    HomePage,
    PrincipalPage,
    PartidaPage,

    YoutubePipe,
  ],
  imports: [
    BrowserModule,
    IonicModule.forRoot(MyApp),
    HttpClientModule
  ],
  bootstrap: [IonicApp],
  entryComponents: [
    MyApp,
    HomePage,
    PrincipalPage,

    PartidaPage,

  ],
  providers: [
    StatusBar,
    SplashScreen,
    {provide: ErrorHandler, useClass: IonicErrorHandler}
  ]
})
export class AppModule {}
