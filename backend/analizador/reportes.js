const tipo = require("./tipo");


class Reportes {

    constructor(){
        this.clearAll();
    }

    clearAll() {
        /**
         * lo usamos para instanciar y a la vez para limpiar
         *  */
        this.errores = [];
        this.reporte_simbolos = [];
    }

    getErrores_sintacticos(){
        return this.errores;
    }

    putError(body){
        
        this.errores.push(body)
    }


    getSimbolos(){
        return this.reporte_simbolos;
    }

    putSimbolo(body){
        this.reporte_simbolos.push(body)
    }


}


module.exports = Reportes;