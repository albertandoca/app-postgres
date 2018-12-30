/* CREAR BASE DE DATOS CON NOMBRE IGNUG Y ROL PRUEBA

CREATE ROLE prueba WITH
    SUPERUSER
    LOGIN
    UNENCRYPTED PASSWORD '12345678';


CREATE DATABASE "Prueba"
    WITH 
    OWNER = prueba
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_ES.UTF-8'
    LC_CTYPE = 'es_ES.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

*/

/* CREAR SESIONES */

CREATE SCHEMA IF NOT EXISTS sesion AUTHORIZATION prueba;
CREATE SCHEMA IF NOT EXISTS estudiante AUTHORIZATION prueba;
CREATE SCHEMA IF NOT EXISTS docente AUTHORIZATION prueba;
CREATE SCHEMA IF NOT EXISTS sistema AUTHORIZATION prueba;
CREATE SCHEMA IF NOT EXISTS auditoria AUTHORIZATION prueba;

SET search_path TO
pg_catalog,public,sesion,estudiante,docente, sistema, auditoria;

/*  ***********************************
                 TABLAS 
************************************** */
/* TABLAS SCHEMA SESION ************************************************************** */

/* Tabla TIPOIDENTIFIACION usuario admin sistema con acceso desde la app */
CREATE TABLE IF NOT EXISTS sesion.tipoIdentificaciones(
    _id serial NOT NULL,
    descripcion varchar NOT NULL,
    CONSTRAINT pk_tipiden PRIMARY KEY(_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE sesion.tipoIdentificaciones OWNER TO prueba;

/* Tabla ESTADOCONTRASEÑAS usuario sin acceso desde la app */ 
CREATE TABLE IF NOT EXISTS sistema.estadoRegistros(
    _id serial NOT NULL,
    descripcion varchar NOT NULL,
    CONSTRAINT pk_estreg PRIMARY KEY(_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE sistema.estadoRegistros OWNER TO prueba;

/* Tabla CREDENCIALES usuario para login de app */
CREATE TABLE IF NOT EXISTS sesion.credenciales(        
    _id bigserial NOT NULL,
    idTipoIdentificacion int NOT NULL, 
    identificacion varchar NOT NULL,
    primerNombre varchar NOT NULL,
    segundoNombre varchar NOT NULL,
    apellidoPaterno varchar NOT NULL,
    apellidoMaterno varchar NOT NULL,
    emailInstitucional varchar NOT NULL,
    contrasena varchar NOT NULL,
    fechaRegistro timestamp NOT NULL,
    fechaCaducidad timestamp NOT NULL,
    idEstadoRegistro int NOT NULL,
    CONSTRAINT pk_cred PRIMARY KEY(_id),
    CONSTRAINT fk_cred_tipiden FOREIGN KEY(idTipoIdentificacion)
               REFERENCES sesion.tipoIdentificaciones(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cred_estreg FOREIGN KEY(idEstadoRegistro)
               REFERENCES sistema.estadoRegistros(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_iden UNIQUE (identificacion),
    CONSTRAINT uq_emai UNIQUE (emailInstitucional),
    CONSTRAINT fechaCaducidad_valida CHECK (fechaCaducidad > fechaRegistro)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE sesion.credenciales OWNER TO prueba;


/* TABLAS SCHEMA DOCENTE ************************************************************** */





/* TABLAS SCHEMA ESTUDIANTE ************************************************************** */
CREATE TABLE IF NOT EXISTS estudiante.datos(
    _id bigserial NOT NULL,
    idCredencial bigint NOT NULL,
    emailPersonal varchar NOT NULL,
    idEstadoRegistro int NOT NULL DEFAULT 0,
    CONSTRAINT pk_dat PRIMARY KEY(_id),
    CONSTRAINT fk_dat_cred FOREIGN KEY(idCredencial)
               REFERENCES sesion.credenciales(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_dat_estreg FOREIGN KEY(idEstadoRegistro)
               REFERENCES sistema.estadoRegistros(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_emai UNIQUE (emailPersonal)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE estudiante.datos OWNER TO prueba;

CREATE TABLE IF NOT EXISTS estudiante.encabezadoDatos(
    _id serial NOT NULL,
    titulo varchar NOT NULL,
    objetivo text NOT NULL,
    instrucciones text NOT NULL,
    mensajeConfirmación text NOT NULL,
    mensajeSalida text NOT NULL,
    CONSTRAINT pk_encdat PRIMARY KEY(_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE estudiante.encabezadoDatos OWNER TO prueba;

CREATE TABLE IF NOT EXISTS estudiante.itemsFormulario(
    _id bigserial NOT NULL,
    idEncabezadoDatos int NOT NULL,
    etiqueta varchar NOT NULL,
    idTag int NOT NULL,
    htmlText text NOT NULL,
    requerido boolean NOT NULL DEFAULT true,
    orden int NOT NULL,
    CONSTRAINT pk_itemform PRIMARY KEY(_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE estudiante.itemsFormulario OWNER TO prueba;

CREATE TABLE IF NOT EXISTS estudiante.subItemsFormulario(
    _id bigserial NOT NULL,
    idEncabezadoDatos int NOT NULL,
    etiqueta varchar NOT NULL,
    idTag int NOT NULL,
    htmlText text NOT NULL,
    requerido boolean NOT NULL DEFAULT true,
    orden int NOT NULL,
    CONSTRAINT pk_subitmfor PRIMARY KEY(_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE estudiante.subItemsFormulario OWNER TO prueba;



/* TABLAS SCHEMA SISTEMA ************************************************************** */



/* Tabla ROLES usuario admin sistema con acceso desde la app */
CREATE TABLE IF NOT EXISTS sistema.roles(
    _id serial NOT NULL,
    descripcion varchar NOT NULL,
    CONSTRAINT pk_rol PRIMARY KEY(_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE sistema.roles OWNER TO prueba;

/* Tabla ROLES usuario administración / secretaría con acceso desde la app */
CREATE TABLE IF NOT EXISTS sistema.credencialRoles(
    _id serial NOT NULL,
    idCredencial bigint NOT NULL,
    idRol int NOT NULL DEFAULT 1,
    fechaRegistro timestamp NOT NULL,
    fechaCaducidad timestamp NOT NULL,
    idEstadoRegistro int NOT NULL,
    CONSTRAINT pk_crerol PRIMARY KEY(_id),
    CONSTRAINT fk_crerol_cre FOREIGN KEY(idCredencial) 
               REFERENCES sesion.credenciales(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_crerol_rol FOREIGN key(idRol) 
               REFERENCES sistema.roles(_id) MATCH FULL
               ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
    CONSTRAINT fk_crerol_estreg FOREIGN KEY(idEstadoRegistro) 
               REFERENCES sistema.estadoRegistros(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fechaCaducidad_valida CHECK (fechaCaducidad > fechaRegistro)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE sistema.roles OWNER TO prueba;







/* TABLAS SCHEMA AUDITORIA ************************************************************** */

/* Tabla INSERTAR usuario sistema solo lectura con acceso desde la app */
CREATE TABLE IF NOT EXISTS auditoria.insertar(
    _id bigserial NOT NULL,
    idCredencial bigint NOT NULL,
    tabla varchar NOT NULL,
    parametros text NOT NULL,
    ip varchar NOT NULL,
    macAddress varchar NOT NULL,
    fechaRegistro timestamp NOT NULL,
    CONSTRAINT pk_ins PRIMARY KEY(_id),
    CONSTRAINT fk_ins_cre FOREIGN KEY(idCredencial)
               REFERENCES sesion.credenciales(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE auditoria.insertar OWNER TO prueba;

/* Tabla MODIFICAR usuario sistema solo lectura con acceso desde la app */
CREATE TABLE IF NOT EXISTS auditoria.modificar(
    _id bigserial NOT NULL,
    idCredencial bigint NOT NULL,
    tabla varchar NOT NULL,
    parametrosModificados text NOT NULL,
    parametrosActuales text NOT NULL,
    ip varchar NOT NULL,
    macAddress varchar NOT NULL,
    fechaRegistro timestamp NOT NULL,
	CONSTRAINT pk_mod PRIMARY KEY(_id),
    CONSTRAINT fk_mod_cre FOREIGN KEY(idCredencial)
               REFERENCES sesion.credenciales(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE auditoria.modificar OWNER TO prueba;

/* Tabla ELIMINAR usuario sistema solo lectura con acceso desde la app */
CREATE TABLE IF NOT EXISTS auditoria.eliminar(
    _id bigserial NOT NULL,
    idCredencial bigint NOT NULL,
    tabla varchar NOT NULL,
    parametrosBorrados text NOT NULL,
    ip varchar NOT NULL,
    macAddress varchar NOT NULL,
    fechaRegistro timestamp NOT NULL,
	CONSTRAINT pk_elim PRIMARY KEY(_id),
    CONSTRAINT fk_elim_cre FOREIGN KEY(idCredencial)
               REFERENCES sesion.credenciales(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE auditoria.eliminar OWNER TO prueba;

/* Tabla LOGIN usuario sistema solo lectura con acceso desde la app */
CREATE TABLE IF NOT EXISTS auditoria.login(
    _id bigserial NOT NULL,
    idCredencial bigint NOT NULL,
    ip varchar NOT NULL,
    macAddress varchar NOT NULL,
    fechaRegistro timestamp NOT NULL,
    CONSTRAINT pk_log PRIMARY KEY(_id),
    CONSTRAINT fk_log_cre FOREIGN KEY(idCredencial)
               REFERENCES sesion.credenciales(_id) MATCH FULL
               ON DELETE RESTRICT ON UPDATE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE auditoria.login OWNER TO prueba;