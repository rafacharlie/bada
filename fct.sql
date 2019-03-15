/*AUTOR: RAFAEL CARLOS INFANTE CARRILLO*/

/*CREACION DE USUARIO*/

-- USER SQL
CREATE USER fct IDENTIFIED BY "admin"  ;

-- QUOTAS

-- ROLES
GRANT "CONNECT" TO fct ;
GRANT "RESOURCE" TO fct ;

-- SYSTEM PRIVILEGES

/*1.- Partiendo del siguiente esquema relacional, crea las tablas correspondientes, teniendo encuenta la descripción y las restricciones siguientes: (1 punto).*/
/*Los campos que aparecen en negrita y subrayados forman la clave primaria de la tabla,restricción que debe considerarse al crear las tablas.*/

/*CREACION DE TABLAS*/

/*tabla alumno*/
create table alumnos(
dnialumno varchar2(10) primary key,
nombre varchar2(10) not null,
direccion varchar2(20) not null,
telefono varchar2(10),
constraint alu_telefono_ck check(
regexp_like(telefono,'^95'))
);

/*tabla empresas*/
create table empresas(
nifempresa varchar2(10) primary key,
nombre varchar2(20) not null,
direccion varchar2(10) not null,
responsablelegal varchar2(20),
sector varchar2(10)
);

/*tabla practicas*/
create table practicas(
dnialumno varchar2(10) not null,
nifempresa varchar2(10) not null,
fechainicio date,
numhoras number(4),
constraint pra_dnialumno_fk foreign key (dnialumno) references alumnos(dnialumno),
constraint pra_nifempresa_fk foreign key (nifempresa) references empresas(nifempresa)
);

/*2.- Insertar las siguientes filas. (0,5 puntos*/

/*insertar tabla alumnos*/
insert into alumnos values ('111-A','David','Sevilla Este','954025122');
insert into alumnos values ('222-B','Mariano','Los Remedios','954221541');
insert into alumnos values ('333-C','Raul','Triana','955124455');
insert into alumnos values ('444-D','Rocío','La Oliva','955236654');
insert into alumnos values ('555-E','Mariló','Triana','954085211');
insert into alumnos values ('666-F','Benjamín','Montequinto','955662512');
insert into alumnos values ('777-G','Carlos','Los Remedios','955662211');
insert into alumnos values ('888-H','Manolo','Montequinto','954725414');

/*insertar tabla empresas*/
insert into empresas values ('41001-A','Sandiel','Pab. Moldavia','Ramon','Informática');
insert into empresas values ('41002-B','Condelans','Pab. Chechenia','Juan','Informática');
insert into empresas values ('41003-C','Guadartes','Pab. La Algaba','Pepe','Informática');
insert into empresas values ('41004-D','Jindras','c/ Pi, 4','Mari','I+D');
insert into empresas values ('41005-E','SGI Tesnologi','c/ Cabañeros, 2','Carmela','I+D');
insert into empresas values ('41006-F','Nesus','c/ Sierpes, 12','Pepi','Electrónica');
insert into empresas values ('41007-G','Arbengoa','c/ Tajo, 2','Gabriel','Electrónica');

/*insertar tabla practicas*/
insert into practicas values ('111-A','41001-A','18/10/02',350);
insert into practicas values ('333-C','41003-C','19/11/02',300);
insert into practicas values ('111-A','41004-D','20/11/02',400);
insert into practicas values ('444-D','41005-E','19/11/02',400);
insert into practicas values ('111-A','41003-C','14/11/02',300);
insert into practicas values ('777-G','41006-F','19/11/02',400);
insert into practicas values ('888-H','41007-G','16/11/02',500);
insert into practicas values ('222-B','41003-C','15/11/02',400);
insert into practicas values ('555-E','41002-B','17/11/02',400);
insert into practicas values ('333-C','41001-A','20/11/02',400);
insert into practicas values ('333-C','41003-C','20/11/02',500);

/*3.- Añade las restricciones siguientes: (0,5 puntos). (probarlas mañana)*/

/*-Responsable Legal: Todo en mayúsculas.*/

/*-NIF Empresa: Empieza y termina por una letra.*/
alter table empresas add(
constraint emp_nifempresa_ck check(
regexp_like(nifempresa,'^[A-Z][0-9]{5}-[A-Z]')));
/*-NumHoras: No nulo.*/
alter table practicas modify( numhoras NOT NULL);

/*4.- Añade una columna a la tabla Empresas, llamada HorasdeColaboración, numérica de 8, nonula. Realiza los pasos para 
que pueda llevarse a cabo dicha operación con los cálculosnecesarios a partir de la tabla Prácticas. (1 punto).*/
ALTER TABLE empresas ADD horasdecolaboracion number(8) not null;

/*5.- Crea una vista con las empresas del sector de la Informática con las siguientes columnas:NIF Empresa, Nombre, Fecha
de inicio de las últimas prácticas y nombre del último alumno querecibió. (1 punto).*/

/*6.- Inserta un registro en la tabla Modifica el número de horas de las prácticas comenzadas eldía   19/11/01,   incrementándolo
en   un   25%.   No   olvides   actualizar   después   la   columnaHorasdeColaboración de la tabla Empresas. (1 punto).*/
insert into practicas(dnialumno,nifempresa,fechainicio,numhoras) values ('555-E','41002-B','17/11/02',400);

/*7.- Visualiza el número total de horas de prácticas realizadas por cada uno de los alumnos. (0,5puntos).*/
select nombre, numhoras from 
alumnos a, practicas p
where a.dnialumno=p.DNIALUMNO;

/*8.- Cuenta el número de empresas donde ha realizado prácticas el alumno Mariano y muestra elnúmero medio de horas de las mismas (0,5 puntos).*/
select count(nifempresa) from practicas where dnialumno in(
select dnialumno from alumnos where nombre='Mariano');

/*9.- Visualiza los datos de las empresas que hayan colaborado por un número de horas superior al millar en prácticas comenzadas durante
el mes de Noviembre. (0,5 puntos).*/
select * from empresas e, practicas p 
where e.nifempresa=p.NIFEMPRESA
and numhoras>400 and to_char(fechainicio,'MM') ='11';

/*10.- Borra los registros correspondientes a los alumnos que no hayan realizado prácticas en losúltimos tres meses. (0,5 puntos).*/
delete from alumnos where nifempresa in(select fechainicio from practicas where to_char(fechainicio,'MM') in (10,11,12));