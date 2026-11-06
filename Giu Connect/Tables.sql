
create table Department
(
dept_id int PRIMARY KEY IDENTITY,
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
GO

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
GO

create table Cooperation_Agreement (
	agreement_id INT PRIMARY KEY IDENTITY,
	title VARCHAR(255) ,
	scope VARCHAR(255),
	start_date DATE ,
	end_date DATE ,
	status VARCHAR(255),
	partner_uni_id INT FOREIGN KEY REFERENCES Partner_University(uni_id) on delete set null on update cascade,
	coordinator_id INT FOREIGN KEY REFERENCES GIU_Academic(person_id) on delete set null on update cascade 
);

go

create table Opportunity (
	opp_id int identity,
	title varchar(255),
	description varchar(1000),
	type varchar(255),
	status varchar(255),
	app_open_date date,
	app_close_date date,
	capacity int,
	location_mode varchar(255),
	agreement_id int,
	offered_by_rep_id int,
	primary key (opp_id),
	foreign key (agreement_id) references Cooperation_Agreement on delete set null on update cascade,
	foreign key (offered_by_rep_id) references Company_Rep on delete set null on update cascade
);
go

create table Opp_Language_Req(
	opp_id int,
	language_req varchar(255),
	primary key (opp_id, language_req),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade
);
go

create table Opp_Relevant_Date(
	opp_id int,
	relevant_date date,
	primary key (opp_id, relevant_date),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade
);
go

create table ThesisTopic(
	opp_id int,
	expected_outcome varchar(1000),
	funding_info varchar(1000),
	travel_info varchar(1000),
	accomodation_info varchar(1000),
	provider_id int,
	supervisor_id int,
	co_supervisor_id int,
	primary key (opp_id),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade,
	foreign key (provider_id) references Topic_Provider on delete set null on update cascade,
	foreign key (supervisor_id) references GIU_Academic on delete set null on update cascade,
	foreign key (co_supervisor_id) references Partner_Professor on delete set null on update cascade
);
go

create table Short_Program(
	opp_id int,
	duration time,
	location varchar(255),
	hosting_arrangments varchar(1000),
	host_uni_id int,
	primary key (opp_id),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade,
	foreign key (host_uni_id) references University on delete set null on update cascade
);
go

create table Mobility_Program(
	opp_id int,
	mobility_type varchar(255),
	duration time,
	sending_uni_id int,
	host_uni_id int,
	primary key (opp_id),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade,
	foreign key (sending_uni_id) references University on delete set null on update cascade,
	foreign key (host_uni_id) references University on delete set null on update cascade
);
go

create table Application(
	app_id int identity,
	app_date date,
	status varchar(255),
	decision_date date,
	info varchar(1000),
	student_id int,
	opp_id int,
	primary key (app_id),
	foreign key (student_id) references Student on delete set null on update cascade,
	foreign key (opp_id) references Opportunity on delete set null on update cascade
);
go

create table Application_Document(
	app_id int,
	doc_type varchar(255),
	file_ref varchar(255),
	upload_date date,
	primary key (app_id, doc_type),
	foreign key (app_id) references Application on delete set null on update cascade
);


go

create table Mobility_Agreement(
agreement_id INT,
PRIMARY KEY(agreement_id),
FOREIGN KEY(agreement_id) REFERENCES Cooperation_Agreement(agreement_id) on delete cascade on update cascade,
exchange_terms VARCHAR(255),
double_degree_terms VARCHAR(255),
seat_quota INT,
tuition_arrangement VARCHAR(255)

);

go

create table Mob_Agr_Semester(
agreement_id INT ,
semester VARCHAR(255) ,
PRIMARY KEY(agreement_id, semester),
FOREIGN KEY(agreement_id) REFERENCES Mobility_Agreement(agreement_id) on delete cascade on update cascade
);

go

create table Research_Agreement(
agreement_id INT ,
PRIMARY KEY(agreement_id),
FOREIGN KEY(agreement_id) REFERENCES Cooperation_Agreement(agreement_id) on delete cascade on update cascade,
ip_terms VARCHAR(255),
funding_framework VARCHAR(255)
);

go

create table General_MoU(
agreement_id INT,
PRIMARY KEY(agreement_id),
FOREIGN KEY(agreement_id) REFERENCES Cooperation_Agreement(agreement_id) on delete cascade on update cascade,
intent VARCHAR(255),
collab_scope VARCHAR(255),
renewal_terms VARCHAR(255)
);
go

create table Funding_Opportunity(
fund_id INT PRIMARY KEY IDENTITY,
name  VARCHAR(255),
agency VARCHAR(255),
type VARCHAR(255),
amount int,
deadline VARCHAR(255),
eligibility_conditions VARCHAR(255),
status VARCHAR(255),
);
go

create table Interview(
interview_id INT IDENTITY,
date DATE,
time TIME,
location_mode VARCHAR(255),
outcome VARCHAR(255),
notes VARCHAR(1000),
app_id INT,
PRIMARY KEY (interview_id),
FOREIGN KEY (app_id) REFERENCES Application(app_id) ON DELETE SET NULL ON UPDATE CASCADE
);
go 
create table Participation(
part_id INT IDENTITY,
status VARCHAR(255),
start_date DATE,
end_date DATE,
app_id INT,
PRIMARY KEY (part_id),
FOREIGN KEY (app_id) REFERENCES Application(app_id) ON DELETE SET NULL ON UPDATE CASCADE
);
go
create table Mobility(
part_id INT,
pre_travel_status VARCHAR(255),
during_status VARCHAR(255),
post_status VARCHAR(255),
final_outcome VARCHAR(255),
host_uni_id INT,
PRIMARY KEY (part_id),
FOREIGN KEY (part_id) REFERENCES Participation(part_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (host_uni_id) REFERENCES University(uni_id) ON DELETE SET NULL ON UPDATE CASCADE
);
go
create table Program_Participation(
part_id INT,
payment_status VARCHAR(255),
visa_status VARCHAR(255),
travel_status VARCHAR(255),
PRIMARY KEY (part_id),
FOREIGN KEY (part_id) REFERENCES Participation(part_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go
create table Course_Equivalency (
part_id INT,
host_course_title VARCHAR(255),
host_credits INT,
transferred_credits INT,
approval_status VARCHAR(255),
giu_course_id INT,
PRIMARY KEY (part_id, host_course_title),
FOREIGN KEY (part_id) REFERENCES Mobility(part_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (giu_course_id) REFERENCES Course(course_id) ON DELETE SET NULL ON UPDATE CASCADE	
);
go
create table Professor_Visit(
visit_id INT IDENTITY,
start_date DATE,
end_date DATE,
purpose VARCHAR(255),
travel_arr VARCHAR(255),
accommodation_arr VARCHAR(255),
status VARCHAR(255),
follow_up_report VARCHAR(1000),
partner_prof_id INT,
host_faculty_id INT,
coordinator_id INT,
agreement_id INT,
PRIMARY KEY (visit_id),
FOREIGN KEY (partner_prof_id) REFERENCES Partner_Professor(person_id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (host_faculty_id) REFERENCES Faculty(faculty_id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (coordinator_id) REFERENCES GIU_Academic(person_id) ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (agreement_id) REFERENCES Cooperation_Agreement(agreement_id) ON DELETE SET NULL ON UPDATE CASCADE
);
go
create table Visit_Outcome(
visit_id INT,
outcome VARCHAR(255),
PRIMARY KEY (visit_id, outcome),
FOREIGN KEY (visit_id) REFERENCES Professor_Visit(visit_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go
create table Agenda_Item (
visit_id INT,
seq_no INT,
activity_type VARCHAR(255),
title VARCHAR(255),
date_time DATETIME,
location VARCHAR(255),
audience VARCHAR(255),
PRIMARY KEY (visit_id, seq_no),
FOREIGN KEY (visit_id) REFERENCES Professor_Visit(visit_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go
create table Research_Project(
project_id INT IDENTITY,
title VARCHAR(255),
description VARCHAR(1000),
status VARCHAR(255),
start_date DATE,
end_date DATE,
res_agreement_id INT,
PRIMARY KEY (project_id),
FOREIGN KEY (res_agreement_id) REFERENCES Research_Agreement(agreement_id) ON DELETE SET NULL ON UPDATE CASCADE
);
go
create table Research_Output(
output_id INT,
type VARCHAR(255),
title VARCHAR(255),
date DATE,
reference VARCHAR(255),
status VARCHAR(255),
project_id INT,
PRIMARY KEY (output_id),
FOREIGN KEY (project_id) REFERENCES Research_Project(project_id) ON DELETE SET NULL ON UPDATE CASCADE
);
go
Create table Project_Deadline(
project_id INT,
deadline DATETIME,
PRIMARY KEY (project_id, deadline),
FOREIGN KEY (project_id) REFERENCES Research_Project(project_id) ON DELETE CASCADE ON UPDATE CASCADE
);