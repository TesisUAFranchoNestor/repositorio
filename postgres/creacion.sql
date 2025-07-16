DROP TABLE IF EXISTS usuarios;
CREATE TABLE usuarios (
  id SERIAL NOT NULL,
  correo varchar(200) NOT NULL,
  nombre varchar(200) NOT NULL,
  uid varchar(500) DEFAULT NULL,
  fecha_ingreso timestamp DEFAULT NULL,
  ci varchar(20) DEFAULT NULL,
  usuario varchar(20) DEFAULT NULL,
  celular varchar(20) DEFAULT NULL, 
  fecha_ultimo_ingreso timestamp DEFAULT NULL,
  habilitado int DEFAULT NULL,
  role varchar(20) DEFAULT 'USER',
  PRIMARY KEY (id)
);

INSERT INTO usuarios VALUES (1,'clesmo@mbaretepadel.com',
'Admin Clesmo',
NULL,
'2021-09-01 00:00:00',
NULL,
NULL,
NULL,
NULL,
1,
'ADMIN');

DROP TABLE IF EXISTS locales;
CREATE TABLE locales (
  id_local SERIAL NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  direccion VARCHAR(600) NOT NULL,
  num_telefono VARCHAR(40),
  descripcion VARCHAR(2000),
  estado SMALLINT DEFAULT 1,
  fecha_mod TIMESTAMP,
  usuario_mod VARCHAR(200),
  PRIMARY KEY (id_local)
);

DROP TABLE IF EXISTS imagenes;
CREATE TABLE imagenes (
    id_imagen SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    tipo VARCHAR(255),
    imagenData BYTEA
);

DROP TABLE IF EXISTS canchas;
CREATE TABLE canchas (
  id_cancha SERIAL NOT NULL,
  id_local int NOT NULL,
  precio float NOT NULL,
  descripcion varchar(2000),
  id_imagen bigint NOT NULL,
  PRIMARY KEY (id_cancha),
  CONSTRAINT fk_locales_cancha
      FOREIGN KEY(id_local) 
        REFERENCES locales(id_local),
  CONSTRAINT fk_imagenes_cancha
      FOREIGN KEY(id_imagen) 
        REFERENCES imagenes(id_imagen)     
);



