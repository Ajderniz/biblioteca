CREATE TABLE IF NOT EXISTS libros (
	titulo TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS autores (
	nombre TEXT,
	apellido TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS metadatos (
	id_libro INTEGER,
	url TEXT NOT NULL,
	formato TEXT,
	FOREIGN KEY(id_libro) REFERENCES libros(ROWID) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS libros_autores (
	id_libro INTEGER,
	id_autor INTEGER,
	FOREIGN KEY(id_libro) REFERENCES libros(ROWID) ON DELETE SET NULL,
	FOREIGN KEY(id_autor) REFERENCES autores(ROWID) ON DELETE SET NULL
);
