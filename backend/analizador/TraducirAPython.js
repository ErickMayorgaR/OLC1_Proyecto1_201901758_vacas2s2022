class TraducirAPython{
    constructor(){
    }

    asignacionDeclaracion(id, igual, expresion){
        return id + " " + igual + " " + expresion
    }

    funcionYMetodo(id, parametros, instrucciones ){
        return "def "+ id + "(" + parametros + "): +\n " + instrucciones 
    }

    funcionYMetodoVacio(id, instrucciones){
        return "def "+ id + "(): +\n" + instrucciones

    }
    sentenciaIf(expresion, instrucciones){
        return "if " + expresion + ": +\n" + instrucciones 
 
    }

    sentenciaElse(instrucciones, caso){
        return caso + "\n" + instrucciones

    }

    sentenciaSwitch(){

    }

    casesParaSwitch(){

    }

    defaultParSwitch(instrucciones){
        return "default: \n"

    }

    sentenciaFor(){

    }

    sentenciaWhile(){

    }

    traducirPrint(){

    }

    almacenarContenidoPrint(){

    }
}
module.exports = TraducirAPython;