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

Funciona en las tres superficies — **terminal**, **app de escritorio** y **Claude dentro de VS Code** — porque los hooks no dependen de la interfaz. Lo que cambia es cómo se instala en cada una.

### A) Pegando el hook (sirve en todas, no necesita nada)

Abrí `~/.claude/settings.json` (en Windows: `C:\Users\TU_USUARIO\.claude\settings.json`) y agregá el bloque `hooks`. Si ya tenés uno, sumá la clave `UserPromptSubmit` adentro:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo DRSTONE ON: responde en 3 lineas o menos. Sin tablas, sin resumenes, sin recapitular lo hecho, sin listar pendientes que no te pidieron. Toda la sustancia tecnica intacta: codigo, nombres de API y errores van literales.",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

Guardá y reiniciá la sesión de Claude. Listo — no hace falta clonar este repo.

### B) Como plugin, desde el CLI de terminal

```
/plugin marketplace add Reikor-Arg/drstone
/plugin install drstone
```

**Ojo:** `/plugin` hoy solo existe en el CLI de terminal. En la app de escritorio y en la extensión de VS Code contesta `/plugin isn't available in this environment`. Ahí va la opción A, o la C.

### C) Como plugin, editando el settings a mano

Equivale a lo que hace `/plugin install` por dentro. En `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "drstone": { "source": { "source": "github", "repo": "Reikor-Arg/drstone" } }
  },
  "enabledPlugins": {
    "drstone@drstone": true
  }
}
```

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
