# Dr. Stone

Plugin de [Claude Code](https://claude.com/product/claude-code) que le recuerda a Claude, **en cada mensaje**, que responda corto.

Cavernícola en la forma, no en el contenido: menos palabras, misma sustancia técnica. El código, los nombres de API y los errores van literales.

## Por qué existe

La instrucción "sé breve" en `CLAUDE.md` funciona los primeros mensajes y después se diluye: queda arriba de todo el contexto, lejos de lo que Claude está por responder. A las dos horas te está contestando quince líneas para decirte "listo".

Este plugin la vuelve a poner **pegada a tu mensaje**, con un hook `UserPromptSubmit`, cada vez.

## Cuentas

| | tokens |
|---|---|
| recordatorio inyectado | ~25 por mensaje |
| lo que se ahorra de salida | 200-400 por respuesta |

Y los tokens de salida cuestan alrededor de 5× los de entrada. La cuenta cierra a favor desde el primer mensaje.

## Instalación

```
/plugin marketplace add Reikor-Arg/drstone
/plugin install drstone
```

Funciona en las tres superficies: **terminal**, **app de escritorio** y **Claude dentro de VS Code**. Los hooks no dependen de la interfaz.

No hay que escribir `/caveman` ni nada antes de cada mensaje — que es justo lo que hace gastar de más.

## Por qué no es una extensión de VS Code

Una extensión de VS Code no puede escribir en el contexto de Claude: pinta en el editor, y Claude no lee el editor. El único canal que llega a la conversación es un hook, y los hooks viven en los plugins.

## Qué no hace

- No usa Node ni ningún runtime: es un `echo`, milisegundos, nada queda corriendo.
- No manda nada afuera.
- No cambia el modelo ni la configuración.

## El nombre

Por [Dr. Stone](https://es.wikipedia.org/wiki/Dr._Stone), donde la humanidad vuelve a la edad de piedra y Senku sobrevive hablando como cavernícola pero razonando como científico. La idea es esa: forma primitiva, contenido intacto.

## Licencia

MIT
