class TraducirAPython{
    constructor(){
        this.numeroCasosSwitch = 0
        this.casoSwitch = "";
        this.contenidoPrint = "";
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
        return "if " + expresion + ": \n" + instrucciones 
 
    }

    sentenciaElse(instrucciones, caso){
        return caso + "\n" + instrucciones

    }

    sentenciaSwitch(){
        return `def switch(case,${this.casoSwitch}): + \n`

    }

    casesParaSwitch(numero,id, valor){
        this.numeroCasosSwitch = numero
        this.casoSwitch = id
        return ` ${numero}: ${id} = ${valor},`

    }

    defaultParaSwitch(instrucciones){
        return `${this.numeroCasosSwitch + 1}: ${instrucciones} `

    }

    sentenciaFor(variable, inicio, fin, instrucciones){
        return `for ${variable} in range (${inicio}, ${fin}): \n ${instrucciones}`

    } 

    sentenciaWhile(isDoWhile, expresionDentroWhile, instrucciones, asignacionVar){
        if(isDoWhile){
            return ` ${asignacionVar} + \n + while True: + \n + ${instrucciones} + \n + if(${expresionDentroWhile}): + \n break `

        }

        return `while ${expresionDentroWhile}: + \n + ${instrucciones} `

    }


    almacenarContenidoPrint(cadena){
        this.contenidoPrint += cadena
    }

    traducirPrint(cadena){
        this.almacenarContenidoPrint(cadena)
        return `print(${cadena})`

    }

    

    getContenidoPrint(){
        return this.contenidoPrint; 
    }
}
module.exports = TraducirAPython;