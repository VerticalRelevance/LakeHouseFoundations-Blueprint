-- select * from information_schema.tables;
-- Press run and see the current database tables below

-- Creates sample hr data in a new postgresql database. Not intended to be production ready.

DROP TABLE IF EXISTS employees;

CREATE TABLE IF NOT EXISTS employees (
    id     serial,
    Name   varchar,
    Contact varchar,
    Phone  varchar,
    SS     varchar
);

INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Tamarind', '333432', '2234567891', '1234567891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Tarter', '323332', '3234567891', '1234547891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Cranz', '323432', '4234567891', '1234557891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Joker', '323432', '5234567891', '1234567891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Pollock', '326432', '6234567891', '1234567891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Freeman', '327432', '7234567891', '1234568891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Gorchana', '383432', '8234567891', '12345698891');
INSERT INTO EMPLOYEES (Name, Contact, Phone, SS) VALUES ('Jake Fannah', '323932', '9034567891', '1234567191');
