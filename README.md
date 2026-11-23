# Biblioteca "Somos Uno"

Misión Bautista Reformada Ibarra "Somos Uno".

Sitio estático para una biblioteca de lectura de la iglesia Misión Bautista Reformada Ibarra "Somos Uno".

La intención es ofrecer acceso comunitario a libros y documentos bautistas reformados para leer en línea o descargar.

## Qué incluye

- Catálogo público con búsqueda, filtros por categoría y ordenamiento.
- Botón de descarga del PDF en cada libro y en el lector.
- Lector de PDFs basado en PDF.js: ajuste al ancho, zoom, teclado (← →), deslizar en móvil y recuerda la última página leída.
- Diseño claro minimalista con estilos compartidos en `docs/styles.css`.
- Estructura compatible con GitHub Pages desde la carpeta `docs/`.

## Importante sobre derechos de autor

Sube únicamente materiales que cumplan al menos una de estas condiciones:

- Están en dominio público.
- Tienen una licencia abierta que permita este uso.
- La iglesia tiene permiso escrito del autor, editorial o titular de derechos.
- Son documentos propios de la iglesia.

Como el sitio permite descargar los PDFs, cualquier visitante puede guardar y compartir los archivos.

## Despliegue en GitHub Pages

1. Crea un repositorio en GitHub.
2. Sube este proyecto.
3. En `Settings -> Pages`, selecciona la rama principal y la carpeta `/docs`.
4. GitHub publicará el sitio en `https://<usuario>.github.io/<repo>/`.

## Agregar libros

1. Copia el PDF a `docs/books/`.
2. Si tienes portada, copia la imagen a `docs/covers/`.
3. Añade una entrada en `docs/books.json`.

Ejemplo:

```json
{
  "id": "confesion-fe-1689",
  "title": "Confesión Bautista de Fe de 1689",
  "file": "books/confesion-fe-1689.pdf",
  "cover": "covers/confesion-fe-1689.jpg",
  "author": "Asamblea Bautista Particular",
  "year": 1689,
  "category": "Confesiones",
  "tags": ["confesión", "doctrina", "bautista reformado"],
  "description": "Documento confesional histórico para lectura y consulta."
}
```

Reglas prácticas:

- Usa un `id` único, corto y sin espacios.
- No uses rutas externas para `file`; los PDFs deben estar dentro del sitio.
- Evita nombres de archivo con espacios o caracteres especiales.
- Si no tienes portada, deja `"cover": ""`.

## Probar localmente

Desde la raíz del proyecto:

```bash
python3 -m http.server 8000 --directory docs
```

Luego abre `http://localhost:8000`.

## Próximos pasos posibles

- Añadir autenticación para miembros.
- Registrar permisos/licencias por libro.
- Crear una página de administración para editar `books.json`.
- Agregar soporte para EPUB o documentos HTML.
 
## Despliegue automático (script)

Incluimos `deploy.sh` en la raíz del proyecto para publicar la carpeta `docs/` en GitHub Pages.

Permisos y uso básico:

```bash
chmod +x deploy.sh
# Opción A: publicar a la rama gh-pages (recomendado)
./deploy.sh gh-pages

# Opción B: si GitHub Pages está configurado para usar la rama principal y la carpeta /docs
./deploy.sh docs

# Opción C: intentar subtree (script lo intentará en modo auto)
./deploy.sh
```

El script intenta `git subtree push --prefix docs origin gh-pages` y si falla usa un método de branch "orphan" que sobrescribe `gh-pages` en el remoto (push --force). Asegúrate de tener un remoto `origin` configurado y permisos para empujar.

Si prefieres CI (GitHub Actions) puedo añadir un workflow que despliegue automáticamente al hacer push a `main`.

