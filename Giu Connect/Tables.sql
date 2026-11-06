create table Person (
person_id int identity primary key,
full_name varchar(255) not null,
email varchar(255),
phone int unique,
account_status varchar(255) not null
);

go

create table Student(
person_id int primary key,
student_no int unique not null,
current_semester int not null,
gpa decimal(3,2) check(gpa between 0.00 and 5.00),
language_level int not null,
cv varchar(255) not null,
program_id int,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade,
foreign key(program_id) references Program(program_id) on delete set null on update cascade
);

go

create table Student_Interest(
person_id int,
interest varchar(255),
primary key(person_id,interest),
foreign key(person_id) references Student(person_id) on delete set null on update cascade
);

go

create table GIU_Academic(
person_id int primary key,
academic_rank varchar(255) not null,
dept_id int,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade,
foreign key(dept_id) references Department(dept_id) on delete set null on update cascade,
);

go

create table Partner_Professor(
person_id int primary key,
title varchar(255) not null,
pdept_id int,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade,
foreign key(pdept_id) references Partner_Department(pdept_id) on delete set null on update cascade
);

go

create table Company_Rep(
person_id int primary key,
company_name varchar(255) not null,
sector varchar(255) not null,
position varchar(255) not null,
location varchar(255) not null,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade
);

go

create table Interviewer(
interviewer_id int identity primary key,
role varchar(255) not null,
person_id int,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade
);

go

create table Topic_Provider(
person_id int primary key,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade
);

go

create table Notification(
notif_id int identity primary key,
message varchar(255) not null,
timestamp datetime not null,
category varchar(255) not null,
urgency varchar(255) not null,
read_status varchar(255) not null,
recipient_id int,
foreign key(recipient_id) references Person(person_id) on delete cascade on update cascade
);
