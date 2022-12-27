import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class AppService {

  _url = "http://127.0.0.1:9000";

  constructor(private http: HttpClient) { }

  compile(input: any) {
    return this.http.post<any>(this._url + '/Analizador', input);
  }

  getAST(input: any) {
    return this.http.post(this._url + '/AST_report', input, {
      responseType: 'blob',
    });
  }

}