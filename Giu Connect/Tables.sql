
create table Department
(
department_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
description VARCHAR(1000)
);
GO

create table Faculty
(
faculty_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
description VARCHAR(1000)
);
GO

create table Program
(
program_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
description VARCHAR(1000),
degree_level int,
total_credit_hours int,
dept_id int,
FOREIGN KEY(dept_id) REFERENCES Department ON DELETE SET NULL ON UPDATE CASCADE,
);
GO

create table Course
(course_id int PRIMARY KEY IDENTITY,
 code VARCHAR(255),
 title VARCHAR(255),
 credit_hours int,
 level int,
 program_id int,
 FOREIGN KEY(program_id) REFERENCES Program ON DELETE SET NULL ON UPDATE CASCADE,
);
GO

create table Field
(
field_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
description VARCHAR(1000)
);
GO

create table Research_Area
(
area_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
description VARCHAR(1000),
field_id int,
FOREIGN KEY(field_id) REFERENCES Field ON DELETE SET NULL ON UPDATE CASCADE,
);
GO

create table Skill
(
skill_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
category VARCHAR(255),
description VARCHAR(1000)
);
GO

create table University
(
uni_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
country VARCHAR(255),
city VARCHAR(255),
description VARCHAR(1000)
);
GO

create table GIU
(
uni_id int PRIMARY KEY,
FOREIGN KEY(uni_id) REFERENCES University ON DELETE CASCADE ON UPDATE CASCADE,
);
GO

create table Partner_University
(
uni_id int PRIMARY KEY,
partnership_status VARCHAR(255),
contact_info VARCHAR(255),
FOREIGN KEY(uni_id) REFERENCES University ON DELETE CASCADE ON UPDATE CASCADE,
);
GO

create table Partner_Department
(
pdept_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
description VARCHAR(1000),
uni_id int 
FOREIGN KEY(uni_id) REFERENCES Partner_University ON DELETE SET NULL ON UPDATE CASCADE,
);
GO 

create table Partner_Program
(
pprog_id int PRIMARY KEY IDENTITY,
name VARCHAR(255),
degree_level int,
description VARCHAR(1000),
pdept_id int,
FOREIGN KEY(pdept_id) REFERENCES Partner_Department ON DELETE SET NULL ON UPDATE CASCADE,
);

