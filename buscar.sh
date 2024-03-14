#!/bin/bash

append() {
	[[ -z $1 ]] && echo "$2" || echo "$1$3$2"
}

help() {
	echo "Uso correcto: $0 [búsqueda] [criterios]"
	echo
	echo "Búsqueda:"
	echo " -t	Título"
	echo " -n	Nombre del autor"
	echo " -a	Apellido del autor"
	echo " -u	URL del documento"
	echo " -f	Formato del documento"
	echo
	echo "Criterios:"
	echo " -T	Título"
	echo " -N	Nombre del autor"
	echo " -A	Apellido del autor"
	echo " -U	URL del documento"
	echo " -F	Formato del documento"
	echo
	echo "Ejemplo:"
	echo "> $0 -t -A \"Cervantes\""
	echo "> Don Quijote de la Mancha"
	echo
}

while getopts ':tnaufT:N:A:U:F:h' OPT; do
	case "$OPT" in
		t|n|a|u|f)
			case "$OPT" in
				t)
					COLUMN="libros.titulo"
					;;
				n)
					COLUMN="autores.nombre"
					;;
				a)
					COLUMN="autores.apellido"
					;;
				u)
					COLUMN="metadatos.url"
					;;
				f)
					COLUMN="metadatos.formato"
					;;
			esac
			SELECTION=$(append "$SELECTION" "$COLUMN" ", ")
			;;
		T|N|A|U|F)
			case "$OPT" in
				T)
					TITULO=$OPTARG
					COLUMN="libros.titulo"
					;;
				N)
					NOMBRE=$OPTARG
					COLUMN="autores.nombre"
					;;
				A)
					APELLIDO=$OPTARG
					COLUMN="autores.apellido"
					;;
				U)
					URL=$OPTARG
					COLUMN="metadatos.url"
					;;
				F)
					FORMATO=$OPTARG
					COLUMN="metadatos.formato"
					;;
			esac
			CONDITIONS=$(append "$CONDITIONS" "$COLUMN LIKE '$OPTARG'" " AND ")
			;;
		h)
			help
			exit 0
			;;
		\?)
			echo "Opción inválida: -$OPTARG"
			help
			exit 1
			;;
		:)
			echo "La opción -$OPTARG requiere un argumento"
			help
			exit 1
			;;
	esac
done

TABLES="libros JOIN libros_autores ON libros.ROWID = libros_autores.id_libro JOIN autores ON autores.ROWID = libros_autores.id_autor JOIN metadatos ON libros.ROWID = metadatos.id_libro"

[[ -z $SELECTION ]] && echo "No hay búsqueda" && help && exit 1

QUERY="SELECT $SELECTION FROM $TABLES WHERE $CONDITIONS"

echo $(sqlite3 ./catalogo.db "$QUERY")
