import { Component } from '@angular/core';
import { NavController, AlertController, LoadingController } from 'ionic-angular';
import {PrincipalPage} from '../principal/principal';
import {HttpClient} from '@angular/common/http';

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  email: string;
  senha: string;

  constructor(public navCtrl: NavController, public alertCtrl:AlertController, private _http: HttpClient,
  public loadctrl: LoadingController) {
      let loading = this.loadctrl.create({
        content: "Carregando"
      });
  }

  buscaemail(){
    let loading = this.loadctrl.create({
      content: "Carregando"
    });
    loading.present();
    this._http.post('http://localhost:8080/inspiration/buscalogon',[this.email,1])
    .subscribe(
      (retorno) => {
        var obj = (JSON.parse(JSON.stringify(retorno)).resp);
        if (JSON.parse(JSON.stringify(obj)).senha == this.senha){
          loading.dismiss();
          this.navCtrl.push(PrincipalPage, {"obj": JSON.parse(JSON.stringify(obj)).id})
        }
      },
      (error) => {
        let alert = this.alertCtrl.create({
          title : "Erro!",
          subTitle: "E-mail ou senha inválidos",
          buttons: ['Ok']
            });
          alert.present();
      }
    )
  }

  


}
