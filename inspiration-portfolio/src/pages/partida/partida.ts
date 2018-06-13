import { Component } from '@angular/core';
import { IonicPage, NavController, NavParams, AlertController, LoadingController } from 'ionic-angular';
import { HttpClient } from '@angular/common/http';


@IonicPage()
@Component({
  selector: 'page-partida',
  templateUrl: 'partida.html',
})
export class PartidaPage {

fotos: any [] = []
usuario: string;
temas: any [] = [];
imagens: any[] = []
  constructor(public navCtrl: NavController, public navParams: NavParams, public _http: HttpClient,
  public alertCtrl: AlertController, public loadctrl: LoadingController) {
    this.usuario = navParams.get("obj");
    this.imagens = navParams.get("imagens");
    this.verificaTemas(this.imagens);
  }

  verificaNomeTema(id, i){
    var positivas = 0;
    var negativas = 0;
    this._http.get('http://localhost:8080/inspiration/buscatemaporid/'+id)
    .subscribe(
      (retorno) => {
        var obj = (JSON.parse(JSON.stringify(retorno)).resp);

        var link = JSON.parse(JSON.stringify(this.imagens[i])).link
        var dtPostagem = JSON.parse(JSON.stringify(this.imagens[i])).dtPostagem
        var tema = JSON.parse(JSON.stringify(obj)).nome
        var id = JSON.parse(JSON.stringify(this.imagens[i])).id
        this._http.post('http://localhost:8080/inspiration/buscacurtidaimagem', [id,1] )
        .subscribe(
          (retorno) => {
            var curtida = (JSON.parse(JSON.stringify(retorno)).resp);
            positivas = JSON.parse(JSON.stringify(curtida[0])).positivas
            negativas = JSON.parse(JSON.stringify(curtida[0])).negativas
            this.fotos.push([link,dtPostagem,tema,id, positivas, negativas])
          }
        )
        }
      )
  }
  verificaTemas(imagens){
    let loading = this.loadctrl.create({
      content: "Carregando"
    });
    loading.present();
    for (var i = 0; i<imagens.length; i++){
      this.verificaNomeTema((JSON.parse(JSON.stringify(imagens[i])).temaid), i)
      }
      loading.dismiss();
    }
    curtir (id){
      let loading = this.loadctrl.create({
        content: "Carregando"
      });
      loading.present();
      this._http.post('http://localhost:8080/inspiration/buscacurtidaimagem', [id,1])
    .subscribe(
      (retorno) => {
        var obj = (JSON.parse(JSON.stringify(retorno)).resp);
        var curtida = parseInt((JSON.parse(JSON.stringify(obj[0])).positivas));
        var id = parseInt((JSON.parse(JSON.stringify(obj[0])).id));
        var total = curtida+ 1;

        this._http.patch('http://localhost:8080/inspiration/curtirimagem/'+id, [total,1])
        .subscribe(
          (retorno) => {
            var obj = (JSON.parse(JSON.stringify(retorno)).resp);
          }
        )
        loading.dismiss();
        this.navCtrl.pop();
        this.navCtrl.push(PartidaPage, {"obj":this.usuario, "imagens": this.imagens})
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
    naoCurtir(id){
      let loading = this.loadctrl.create({
        content: "Carregando"
      });
      loading.present();
      this._http.post('http://localhost:8080/inspiration/buscacurtidaimagem', [id,1])
    .subscribe(
      (retorno) => {
        var obj = (JSON.parse(JSON.stringify(retorno)).resp);
        var curtida = parseInt((JSON.parse(JSON.stringify(obj[0])).negativas));
        var id = parseInt((JSON.parse(JSON.stringify(obj[0])).id));
        var total = curtida+ 1;

        this._http.patch('http://localhost:8080/inspiration/descurtirimagem/'+id, [total,1])
        .subscribe(
          (retorno) => {
            var obj = (JSON.parse(JSON.stringify(retorno)).resp);
          }
        )
        loading.dismiss();
        this.navCtrl.pop();
        this.navCtrl.push(PartidaPage, {"obj":this.usuario, "imagens": this.imagens})
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
  }
