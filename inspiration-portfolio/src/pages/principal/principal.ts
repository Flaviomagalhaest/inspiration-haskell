import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, LoadingController, AlertController } from 'ionic-angular';

import { HttpClient, HttpParams } from '@angular/common/http';
import { PartidaPage } from '../partida/partida';

/**
 * Generated class for the PrincipalPage page.
 *
 * See https://ionicframework.com/docs/components/#navigation for more info on
 * Ionic pages and navigation.
 */

@IonicPage()
@Component({
  selector: 'page-principal',
  templateUrl: 'principal.html',
})
export class PrincipalPage {

  usuario: string;
  amigos: string [];
  temas: any [] = [];
  imagens: any[] = [];
  email: string;
  idusuario: string;
  tema_envio: string;
  link: string;
  tema:string;

  constructor(public navCtrl: NavController, public navParams: NavParams, public _http:HttpClient,
  public loadctrl: LoadingController, public alertCtrl: AlertController) {
    this.usuario = navParams.get("obj");
    this.carregatemas()
  }

  carregatemas(){
    let loading = this.loadctrl.create({
      content: "Carregando"
    });
    loading.present();
    this._http.get('http://localhost:8080/inspiration/buscatodostemas')
    .subscribe(
      (retorno) => {
        var obj = (JSON.parse(JSON.stringify(retorno)).resp);
        for (var i = 0; i<obj.length; i++){
          this.temas.push((JSON.parse(JSON.stringify(obj[i]))))
        }
        loading.dismiss();
      },
      (error) => {
        let alert = this.alertCtrl.create({
          title : "Erro!",
          subTitle: "Erro ao comunicar com o servidor",
          buttons: ['Ok']
            });
            loading.dismiss();
          alert.present();
          this.navCtrl.pop();
      }
    )
  }

  enviaImagem(){
    let loading = this.loadctrl.create({
      content: "Carregando"
    });
    loading.present();

    var imagemid = 0;
    var parametro = {
      "loginid": parseInt(this.usuario),
      "link": this.link,
      "dtPostagem": new Date().toDateString(),
      "temaid": parseInt(this.tema_envio)
    }
    this._http.post('http://localhost:8080/inspiration/criarimagem', parametro)
    .subscribe(
      (retorno) => {
        var obj = (JSON.parse(JSON.stringify(retorno)).resp);
        var parametro1 = {
          "temaid": parseInt(this.tema_envio),
          "imagemid": obj
        }   
        imagemid = obj;
        this._http.post('http://localhost:8080/inspiration/criartemaimagem', parametro1)
        .subscribe(
        (retorno) => {
          var resultado = (JSON.parse(JSON.stringify(retorno)).resp);
        
        var parametro2 = {
          "loginid" : this.usuario,
          "imagemid" : imagemid,
          "positivas": 0,
          "negativas": 0
        }

        this._http.post('http://localhost:8080/inspiration/criacurtida', parametro2)
        .subscribe(
          (retorno) =>{
          var obj = (JSON.parse(JSON.stringify(retorno)).resp);
        
        let alert = this.alertCtrl.create({
          title : "Sucesso!",
          subTitle: "Foto enviada com sucesso",
          buttons: ['Ok']
            });
            loading.dismiss();
          alert.present();
          this.navCtrl.pop();
          this.navCtrl.push(PrincipalPage, {"obj":this.usuario})
        }
      )
    })
      },
      (error) => {
        let alert = this.alertCtrl.create({
          title : "Erro!",
          subTitle: "Erro ao comunicar com o servidor",
          buttons: ['Ok']
            });
            loading.dismiss();
          alert.present();
          this.navCtrl.pop();
      }
     )
   }
 
   procuraImagens(){
     if (this.tema == null){
      let loading = this.loadctrl.create({
        content: "Carregando"
      });
      loading.present();
      this._http.get('http://localhost:8080/inspiration/buscatodasimagens')
      .subscribe(
        (retorno) => {
          var obj = (JSON.parse(JSON.stringify(retorno)).resp);
          for (var i = 0; i< obj.length; i++){
            this.imagens.push(obj[i])
          }
          loading.dismiss();
        },
        (error) =>{
          let alert = this.alertCtrl.create({
            title : "Erro!",
            subTitle: "Erro ao comunicar com o servidor",
            buttons: ['Ok']
          });
          loading.dismiss();
          alert.present();
        }
        
      )
  
      this.navCtrl.push(PartidaPage, {"obj":this.usuario, "imagens":this.imagens})
     }
     else {
        let loading = this.loadctrl.create({
          content: "Carregando"
        });
        loading.present();
        this._http.post('http://localhost:8080/inspiration/buscaimagemtema', [parseInt(this.tema),1])
        .subscribe(
          (retorno) => {
            var obj = (JSON.parse(JSON.stringify(retorno)).resp);
            for (var i = 0; i< obj.length; i++){
              this.imagens.push(obj[i])
            }
            loading.dismiss();
            console.log(this.imagens)
            this.navCtrl.push(PartidaPage, {"obj":this.usuario,"imagens":this.imagens})
          },
          (error) =>{
            let alert = this.alertCtrl.create({
              title : "Erro!",
              subTitle: "Erro ao comunicar com o servidor",
              buttons: ['Ok']
            });
            loading.dismiss();
            alert.present();
          }
          
        )
     }
   }
}
