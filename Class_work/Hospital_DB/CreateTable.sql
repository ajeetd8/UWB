.open hospitalDatabase.db

begin;

drop table ASSISTS;
drop table DEPARTMENT;
drop table DOCTOR;
drop table IS_IN_CHARGE_OF;
drop table NURSE;
drop table PATIENT;
drop table ROOM;
drop table STAFF;
drop table SURGERY_INFO;
drop table WORKS_ON;

-- Assists table
create table ASSISTS
(
P_number       integer not null,
N_number       integer not null,
Surgery_number integer not null,
primary key (P_number, N_number, Surgery_number),
foreign key (P_number, Surgery_number) references SURGERY_INFO (P_number, Surgery_number)
  on update cascade
  on delete restrict ,
foreign key (N_number) references NURSE (Number)
  on update cascade
  on delete restrict
);

-- Assists populate
insert into ASSISTS values (0001, 0010, 0001);
insert into ASSISTS values (0001, 0001, 0001);
insert into ASSISTS values (0002, 0010, 0002);
insert into ASSISTS values (0003, 0001, 0003);
insert into ASSISTS values (0001, 0010, 0004);
insert into ASSISTS values (0004, 0006, 0005);
insert into ASSISTS values (0009, 0005, 0005);


-- Department
create table DEPARTMENT
(
Dept_number integer primary key autoincrement not null,
Dept_name   varchar(25)                       not null,
Dnumber     int                               not null,
Location    varchar(25)                       not null,
unique (Dept_name),
foreign key (Dnumber) references DOCTOR (Number)
  on update cascade
  on delete restrict -- I hope this reject deletion
);


-- Department Populate
insert into DEPARTMENT values (1001, 'Anesthesiology', 0001, 'Floor1');
insert into DEPARTMENT (Dept_name, Location, Dnumber) values ('Neurology', 'Floor2', 0006);
insert into DEPARTMENT (Dept_name, Location, Dnumber) values ('Cardiology', 'Floor3', 0003);
insert into DEPARTMENT (Dept_name, Location, Dnumber) values ('Hematology', 'Floor4', 0011);
insert into DEPARTMENT (Dept_name, Location, Dnumber) values ('Endocrinology', 'Floor5', 0018);


-- Doctor
create table DOCTOR
(
Number       integer primary key autoincrement not null check (Number between 0001 and 9999),
Ssn          varchar(9)                        not null check (length(Ssn) = 9),
Lname        varchar(25)                       not null,
Fname        varchar(25)                       not null,
DOB          date                              not null,
Position     varchar(25)                       not null check (Position in
                                                               ('Specialist', 'On call', 'Intern', 'Resident')),
Speciality                  default (null),
Salary       decimal(10, 2)                    not null,
Phone        varchar(10)                       not null check (length(Phone) = 10),
Address      varchar(255)                      not null,
Dept_number  int                               not null,
Chief_number int,
Work_hour    decimal(2, 1)                     not null check (Work_hour between 20 and 80),
unique (Ssn),
foreign key (Chief_number) references DOCTOR (Number)
  on update cascade
  on delete restrict,
foreign key (Dept_number) references DEPARTMENT (Dept_number)
  on update cascade
  on delete restrict
);

-- Doctor Populate
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Work_hour) values
(123456789, 'Lee', 'James', '1982-05-16', 'Specialist', 'Anesthesiology', 230133.00, '4253456780',
  '3456 Roven St, Bothell,WA', 1001, 60.0);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(234456437, 'Gray', 'Marry', '1987-04-05', 'Specialist', 'Neurology', 283200.00, '2061234567',
            '678 Voss AVE W, Seattle,WA', 1002, 0006, 59.8);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(444547747, 'Smith', 'Kevin', '1965-01-09', 'On call', 'Cardiology', 190300.00, '2067894567',
            '3345 Casstle AVE,Seattle,WA', 1003, null, 70.0);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(785522212, 'Jabbat', 'Alicia', '1989-08-05', 'On call', 'Hematology', 202300.00, '4253459012',
            '134 Oak St, Everett,WA', 1004, 0011, 65.0);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(785523450, 'Borgg', 'James', '1969-04-30', 'Specialist', 'Endocrinology', 250900.00, '4253423456',
            '345 Ranch St, Lynnwood,WA', 1005, 0018, 55.0);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(783241678, 'Lu', 'Kelvin', '1979-10-16', 'Specialist', 'Neurology', 280200.00, '4753698632',
            '1001 New York St, Harrisburg, WA', 1002, null, 45.0);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(334437856, 'Brown', 'Johnny', '1994-12-21', 'Intern', NULL, 100450.00, '9056357845',
            '123 Main St, Beverly Hills, WA', 1005, 0018, 50.0);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(663562832, 'Jones', 'David', '1992-03-07', 'Resident', NULL, 123450.00, '2113257894', '2015 Bywood Dr, Kenmore, WA',
            1001, 0001, 55.6);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(232314567, 'Williams', 'Rocky', '1993-08-06', 'Intern', NULL, 100850.00, '2068547963',
            '3090 Firelight Rd, Raleight, WA', 1002, 0006, 32.3);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(987612453, 'Garcia', 'Rosa', '1991-08-07', 'Resident', NULL, 124450.00, '5026247985',
            '1711 WildCat Ln, Chapel Hill, WA', 1003, 0003, 72.5);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(333445555, 'Wong', 'Franklin', '1968-01-19', 'On call', 'Hematology', 220375.00, '2533291519',
            '15531 Greenwood Ave. N, Shoreline, WA', 1004, null, 66.3);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(999887777, 'Smith', 'Jennifer', '1962-09-15', 'Specialist', 'Endocrinology', 243570.00, '4054356061',
            '15530 Greenwood Ave. N, Shoreline, WA', 1005, 0018, 64.2);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(666884444, 'Narayan', 'Ramesh', '1992-07-31', 'Intern', NULL, 105248.00, '2538806061',
            '4004 228th Ave SE, Bothell,, WA', 1002, 0006, 68.2);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(888665555, 'English', 'Joyce', '1969-03-29', 'Specialist', 'Anesthesiology', 245789.00, '2532491519',
            '3611 I Street NE Unit #4, Auburn, WA', 1001, 0001, 69.3);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(453453453, 'Jabbar', 'Ahmad', '1987-11-10', 'Resident', NULL, 132456.00, '2068391242',
            '700 320th SW, Federal Way, WA', 1001, 0001, 71.2);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(987987987, 'Ronni', 'Alicia', '1990-01-09', 'Resident', NULL, '135462.00', '4252951528',
            '3611 I Street NE Unit #1, Auburn, WA', 1004, 0011, 67.2);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(987654321, 'Mareli', 'Brooks', '1965-12-08', 'On call', 'Cardiology', 239123.00, '2062589064',
            '3611 I Street NE Unit #2, Auburn, WA', 1003, 0003, 51.2);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(234561231, 'Taylor', 'Shea', '1989-01-19', 'Resident', 'Endocrinology', 248468.00, '2063077341',
            '3611 I Street NE Unit #5, Auburn, WA', 1005, null, 55.9);
insert into DOCTOR (Ssn, Lname, Fname, DOB, Position, Speciality, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(112244335, 'Natasha', 'Mcdonald', '1994-01-19', 'Intern', NULL, 112456.00, '2068227150',
            '3611 I Street NE Unit #11, Auburn, WA', 1005, 0018, 56.4);
-- IS_IN_CHARGE_OF TABLE
create table IS_IN_CHARGE_OF
(
D_number int not null,
N_number int not null,
P_number int not null,
primary key (D_number, N_number, P_number),
foreign key (D_number) references DOCTOR (Number)
  on update cascade
  on delete restrict,
foreign key (N_number) references NURSE (Number)
  on update cascade
  on delete restrict,
foreign key (P_number) references PATIENT (Number)
  on update cascade
  on delete cascade
);


-- IS_IN_CHARGE_OF Populate
insert into IS_IN_CHARGE_OF values (0014, 0001, 0003);
insert into IS_IN_CHARGE_OF values (0001, 0010, 0001);
insert into IS_IN_CHARGE_OF values (0001, 0001, 0010);
insert into IS_IN_CHARGE_OF values (0014, 0010, 0006);
insert into IS_IN_CHARGE_OF values (0005,  0006, 0007);
insert into IS_IN_CHARGE_OF values (0014, 0001, 0008);
insert into IS_IN_CHARGE_OF values (0003, 0006, 0004);
insert into IS_IN_CHARGE_OF values (0011, 0007, 0005);
insert into IS_IN_CHARGE_OF values (0018, 0005, 0009);
insert into IS_IN_CHARGE_OF values (0001, 0010, 0002);



-- Nurse create
create table NURSE
(
Number       integer primary key autoincrement not null,
Ssn          varchar(9)                        not null check (length(Ssn) = 9),
Lname        varchar(25)                       not null,
Fname        varchar(25)                       not null,
DOB          date                              not null,
Position     varchar(25)                       not null check (Position in
                                                               ('Medical-Surgical Nurse', 'Critical Care Nurse', 'Pain Management Nurse', 'General Nurse')),
Salary       decimal(10, 2)                    not null,
Phone        varchar(10)                       not null check (length(Phone) = 10),
Address      varchar(255)                      not null,
Dept_number  integer                           not null,
Chief_number int,
Work_hour    decimal(2, 1)                     not null check (Work_hour between 20 and 80),
unique (Ssn),
foreign key (Chief_number) references NURSE (Number)
  on update cascade
  on delete restrict,
foreign key (Dept_number) references DEPARTMENT (Dept_number)
  on update cascade
  on delete restrict
);

-- Nurse Populate
insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Work_hour) values
(123861978, 'StanaLucia', 'Paul', '1989-08-05', 'Medical-Surgical Nurse', 98540.00, 2065396606,
 '7925 NE 203rd St, Kenmore, WA', 1001, 55.0);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Work_hour) values
(118325401, 'Macateer', 'Charlie', '1969-04-30', 'Critical Care Nurse', 86596.00, 4254638385,
 '7926 NE 203rd St, Kenmore, WA', 1002, 45.0);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Work_hour) values
(109860907, 'Kim', 'Johnny', '1979-10-16', 'Pain Management Nurse', 83789.00, 2068865941,
 '18115 Campus Way NE, Bothell, WA', 1003, 50.0);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Work_hour) values
(116861598, 'Kwon', 'Robert', '1994-12-21', 'General Nurse', 65756.00, 4255125482, '18116 Campus Way NE, Bothell, WA',
 1004, 55.6);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Work_hour) values
(352421257, 'Peng', 'Yang', '1992-03-07', 'Pain Management Nurse', 73742.00, 4253439244, '601 N 34th St, Seattle, WA',
 1005, 32.3);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(459136770, 'Choi', 'Julian', '1993-08-06', 'General Nurse', 68450.00, 2532674770,
  '3611 I Street NE Unit #4, Auburn, WA', 1005, 5, 72.5);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(431650430, 'Sheepherd', 'Nadia', '1991-08-07', 'General Nurse', 67123.00, 2063064744,
  '3611 I Street NE Unit #6, Auburn, WA', 1004, 4, 67.2);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(231118782, 'Park', 'John', '1968-01-19', 'Critical Care Nurse', 85714.00, 2066949122,
  '3611 I Street NE Unit #7, Auburn, WA', 1003, 3, 51.2);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(144701211, 'Yi', 'Tom', '1962-09-15', 'Critical Care Nurse', 105420.00, 2065572570,
  '3611 I Street NE Unit #8, Auburn, WA', 1002, 2, 55.9);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
values
(407487165, 'Chen', 'Jerry', '1994-01-19', 'General Nurse', 69478.00, 7062551249,
  '3611 I Street NE Unit #9, Auburn, WA', 1001, 1, 56.4);

insert into nurse (Ssn, Lname, Fname, DOB, Position, Salary, Phone, Address, Dept_number, Chief_number, Work_hour)
VALUES (965478134, 'Marie', 'Nancy', '1993-12-09',  'Medical-Surgical Nurse',  84563.00,  2064101204,  '3611 I Street NE Unit #10, Auburn, WA'  ,1001, 0002,  55.5);



-- Patient definition
create table PATIENT
(
Number       integer primary key autoincrement not null,
Ssn          varchar(9)                        not null check (length(Ssn) = 9),
Lname        varchar(25)                       not null,
Fname        varchar(25)                       not null,
DOB          date                              not null,
Weight       float(5, 2) default (null),
Height       float(5, 2) default (null),
Disease      varchar(25) default (null),
Address      varchar(255)                      not null,
Phone        varchar(10)                       not null check (length(Phone) = 10),
Prescription varchar(25) default (null),
Room_number  int         default (null),
Dept_number  int                               not null,
Date_from    date,
Date_to      date check (Date_to > Date_from),
unique (Ssn),
foreign key (Dept_number) references DEPARTMENT (Dept_number)
  on update cascade
  on delete restrict, -- I hope this reject the deletion.
foreign key (Room_number) references ROOM (Room_number)
  on update cascade
  on delete restrict
);

-- Patient populate
insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values (449768350, 'Vega', 'Aaron', '1991-02-07', 142, 177, 'Cancer', '245 Oak St Unit #1 Bothell WA', 2064921523,
                 'carboplatin', 105, 1001, '2018-04-12', '2018-06-01');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values (289365205, 'Haralson', 'Denny', '2018-01-01', 15, 100, 'Bipolar Disorder', '2015 Bywood Dr, Kenmore, WA ',
                 7731230493, 'Lamictal', 210, 1001, '2018-05-12', '2018-05-30');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values
(503088335, 'Mcconnel', 'Lina', '1984-10-27', 135, 160, 'Seizures ', '3090 Firelight Rd, Raleight, WA', 4252935234,
            'Keppra', 215, 1001, '2018-05-12', '2018-05-31');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values
(555069510, 'Goza', 'Lewis', '1962-12-29', 120, 167, 'Schizophrenia', '1711 WildCat Ln, Chapel Hill, WA', 2538806069,
            ' Abilify', 145, 1003, '2018-05-15', '2018-05-31');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values
(457983188, 'Hinson', 'Sarah', '1974-11-11', 191, 180, 'Hepatitis B', '123 Main St, Beverly Hills, WA', 7730987432,
            'Engerix-B', 305, 1004, '2017-04-12', '2018-05-31');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values
(574333641, 'Luu', 'Alan', '1989-02-14', 154, 188, 'Diarrhea', '134 Oak St, Everett,WA', 2539291265, 'loperamide',
            105, 1001, '2017-04-12', '2018-05-31');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values (263699477, 'Mertz', 'Olivia', '1993-12-15', 138, 176, 'Eczema', '345 Ranch St, Lynnwood,WA', 2061249442,
                 'triamcinolone', 222, 1005, '2018-04-12', '2018-05-31');

insert into patient (Ssn, Lname, Fname, DOB, Weight, Height, Disease, Address, Phone, Prescription, Room_number, Dept_number, Date_from, Date_to)
values (318909634, 'Matthies', 'Ray', '1987-06-05', 243, 185, 'Depression', '200 Lake Washington Blvd, Seattle, WA',
                 4250984102, 'Cymbalta', 242, 1001, '2018-04-12', '2018-11-11');




-- Room
create table ROOM
(
Dept_number integer not null,
Room_number integer not null,
Capacity    int(2)  not null check (Capacity between 1 and 20),
primary key (Dept_number, Room_number),
foreign key (Room_number) references DEPARTMENT (Dept_number)
  on update cascade
  on delete cascade
);

-- ROOM Populate
insert into ROOM values (1001, 105, 6);
insert into ROOM values (1001, 132, 6);
insert into ROOM values (1001, 210, 6);
insert into ROOM values (1001, 215, 3);
insert into ROOM values (1001, 242, 3);
insert into ROOM values (1002, 122, 2);
insert into ROOM values (1002, 132, 2);
insert into ROOM values (1003, 145, 3);
insert into ROOM values (1004, 305, 2);
insert into ROOM values (1004, 310, 1);
insert into ROOM values (1005, 222, 4);
insert into ROOM values (1005, 225, 2);



-- Staff table
create TABLE STAFF
(
Number       integer primary key autoincrement not null,
Ssn          varchar(9)                        not null check (length(Ssn) = 9),
Lname        varchar(25)                       not null,
Fname        varchar(25)                       not null,
DOB          date                              not null,
Job_title    varchar(25)                       not null check (Job_title in
                                                               ('clinical assistants', 'porters', 'patient services assistants', 'clinical assistants', 'ward clerks')),
Salary       decimal(10, 2)                    not null,
Phone        varchar(10)                       not null check (length(Phone) = 10),
Address      varchar(255)                      not null,
Dept_number  integer                           not null,
Chief_number int default null,
Work_hour    decimal(2, 1)                     not null check (Work_hour between 20 and 80),
unique (Ssn),
foreign key (Chief_number) references STAFF (Number)
  on update cascade
  on delete restrict,
foreign key (Dept_number) references DEPARTMENT (Dept_number)
  on update cascade
  on delete restrict
);

-- Populate Staff Table
insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Work_hour) values
(222361150, 'Santalucia', 'John', '1994-02-07', 'clinical assistants', 80000.00, 2533069277,
 '1024 SE 23rd St, Seattle, WA', 1002, 40.2);

insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Chief_number, Work_hour)
values
(109582112, 'Savage', 'Nirmala', '1989-01-01', 'porters', 78230.00, 7046613918, '701 5th Ave, Seattle, WA', 1005,
  0001, 45.3);

insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Work_hour) values
(163723486, 'Surilvan', 'David', '1994-01-27', 'patient services assistants', 69235.00, 2069928139,
 '506 2nd Ave, Seattle, WA', 1001, 41.2);

insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Chief_number, Work_hour)
values
(485627437, 'Lin', 'Heung', '1994-01-29', 'ward clerks', 68459.00, 2063077788, '115 Broadway E, Seattle, WA', 1001,
  0001, 48.2);

insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Chief_number, Work_hour)
values
(650302836, 'Chen', 'Ben', '1961-11-11', 'clinical assistants', 82014.00, 2067946653,
  '669 120th Ave NE, Bellevue, WA', 1005, 0003, 38.9);

insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Work_hour) values
(530022123, 'Know', 'Jonathan', '1961-10-04', 'ward clerks', 74562.00, 2063557230,
 '510 Bellevue Way NE, Bellevue, WA', 1003, 50.2);

insert into staff (Ssn, Lname, Fname, DOB, Job_title, Salary, Phone, address, Dept_number, Chief_number, Work_hour)
values
(256594594, 'Kim', 'Bora', '1967-12-15', 'porters', 79256.00, 7732750101, '24118 Lockwood Rd, Bothell, WA', 1005,
  0006, 44.2);





-- SURGERY_INFO Table
create table SURGERY_INFO
(
Surgery_number integer not null,
P_number       integer not null,
Date           date    not null,
primary key (Surgery_number, P_number),
foreign key (P_number) references PATIENT (Number)
  on update cascade
  on delete cascade
);

-- SURGERY_INFO Populate
insert into SURGERY_INFO values (0001, 0001, '2018-01-01');
insert into SURGERY_INFO values (0002, 0002, '2018-01-02');
insert into SURGERY_INFO values (0003, 0003, '2018-01-02');
insert into SURGERY_INFO values (0004, 0001, '2018-04-05');
insert into SURGERY_INFO values (0005, 0009, '2018-04-13');




-- WORKS_ON table
create table WORKS_ON
(
P_number       int not null,
D_number       int not null,
Surgery_number int not null,
primary key (P_number, D_number, Surgery_number),
foreign key (P_number) references SURGERY_INFO (P_number)
  on update cascade
  on delete restrict,
foreign key (D_number) references DOCTOR (Number)
  on update cascade
  on delete restrict,
foreign key (Surgery_number) references SURGERY_INFO (Surgery_number)
  on update cascade
  on delete restrict
);

-- WORKS_ON Populate
insert into WORKS_ON values (0001, 0014, 0001);
insert into WORKS_ON values (0002, 0001, 0002);
insert into WORKS_ON values (0002, 0014, 0002);
insert into WORKS_ON values (0003, 0001, 0003);
insert into WORKS_ON values (0001, 0003, 0004);
insert into WORKS_ON values (0009, 0011, 0005);


-- Saving database

commit;

