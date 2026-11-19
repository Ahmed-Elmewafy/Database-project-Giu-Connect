create table Faculty
(
faculty_id int PRIMARY KEY IDENTITY,
name VARCHAR(150),
description VARCHAR(500),
);
GO

create table Department
(
dept_id int PRIMARY KEY IDENTITY,
name VARCHAR(150) not null,
description VARCHAR(500),
faculty_id int not null,
foreign key(faculty_id) references Faculty(faculty_id) on delete cascade on update cascade
);
GO

create table Program
(
program_id int PRIMARY KEY IDENTITY,
name VARCHAR(150) not null,
degree_level varchar(30) not null,
total_credit_hours int not null check (total_credit_hours > 0),
description varchar(500),
dept_id int not null
FOREIGN KEY(dept_id) REFERENCES Department ON UPDATE CASCADE,
);
GO

create table Course
(course_id int PRIMARY KEY IDENTITY,
 code VARCHAR(20) not null unique,
 title VARCHAR(150) not null,
 credit_hours int not null check (credit_hours > 0),
 level int not null,
 program_id int not null
 FOREIGN KEY(program_id) REFERENCES Program ON UPDATE CASCADE,
);
GO

create table Field
(
field_id int PRIMARY KEY IDENTITY,
name VARCHAR(100) not null,
description VARCHAR(500)
);
GO

create table Research_Area
(
area_id int PRIMARY KEY IDENTITY,
name VARCHAR(150) not null,
description VARCHAR(500),
field_id int not null
FOREIGN KEY(field_id) REFERENCES Field ON UPDATE CASCADE,
);
GO

create table Skill
(
skill_id int PRIMARY KEY IDENTITY,
name VARCHAR(100) NOT NULL,
category VARCHAR(50),
description VARCHAR(500)
);
GO

create table University
(
uni_id int PRIMARY KEY IDENTITY,
name VARCHAR(150) not null,
country VARCHAR(60) not null,
city VARCHAR(60) not null,
description VARCHAR(500)
);
GO

create table GIU
(
uni_id int PRIMARY KEY,
FOREIGN KEY(uni_id) REFERENCES University ON DELETE CASCADE ON UPDATE CASCADE
);
GO

create table Partner_University
(
uni_id int PRIMARY KEY,
partnership_status VARCHAR(30) not null,
contact_info VARCHAR(300) not null
FOREIGN KEY(uni_id) REFERENCES University ON DELETE CASCADE ON UPDATE CASCADE,
);
GO

create table Partner_Department
(
pdept_id int PRIMARY KEY IDENTITY,
name VARCHAR(150) not null,
description VARCHAR(500),
partner_uni_id int not null
FOREIGN KEY(partner_uni_id) REFERENCES Partner_University ON DELETE cascade ON UPDATE CASCADE,
);
GO 

create table Partner_Program
(
pprog_id int PRIMARY KEY IDENTITY,
name VARCHAR(150) not null,
degree_level varchar(30) not null,
description VARCHAR(500),
pdept_id int not null
FOREIGN KEY(pdept_id) REFERENCES Partner_Department ON DELETE cascade ON UPDATE CASCADE,
);
GO

create table Person (
person_id int identity primary key,
full_name varchar(150) not null,
email varchar(150) not null unique,
phone varchar(30) not null unique,
account_status varchar(20) not null default 'Active' check (account_status='Active' or account_status='Not Active' or account_status='Suspended')
);

go

create table Student(
person_id int primary key,
student_no varchar(20) unique not null,
current_semester int not null check(current_semester>0),
gpa decimal(3,2) check(gpa between 0.70 and 5.00),
language_level varchar(30) not null,
cv varchar(300),
program_id int not null,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade,
foreign key(program_id) references Program(program_id) on update cascade
);

go

create table Student_Interest(
person_id int,
interest varchar(100),
primary key(person_id,interest),
foreign key(person_id) references Student(person_id) on delete cascade on update cascade
);

go

create table GIU_Academic(
person_id int primary key,
academic_rank varchar(50) not null,
dept_id int not null,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade,
foreign key(dept_id) references Department(dept_id) on update cascade
);

go

create table Partner_Professor(
person_id int primary key,
title varchar(50) not null,
pdept_id int not null,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade,
foreign key(pdept_id) references Partner_Department(pdept_id) on update cascade
);

go

create table Company_Rep(
person_id int primary key,
company_name varchar(150) not null,
sector varchar(100) not null,
position varchar(100) not null,
location varchar(100) not null,
foreign key(person_id) references Person(person_id) on delete cascade on update cascade
);

go

create table Interviewer(
interviewer_id int identity primary key,
role varchar(100) not null,
person_id int unique not null,
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
message varchar(500) not null,
timestamp datetime not null default getdate(),
category varchar(30) not null check(category in('Deadline','Status Change','Offer','Approval','Visit Agenda')),
urgency varchar(20) not null default 'Low' check (urgency='Low' or urgency='Medium' or urgency='High'),
read_status bit not null default 0,
recipient_id int not null,
foreign key(recipient_id) references Person(person_id) on delete cascade on update cascade
);
GO

create table Cooperation_Agreement (
	agreement_id INT PRIMARY KEY IDENTITY,
	title VARCHAR(200) not null,
	scope VARCHAR(500) not null,
	start_date DATETIME not null,
	end_date DATETIME not null,
	status VARCHAR(30) not null default 'Active' check(status='Active' or status='Expired' or status='Terminated'),
	check (end_date >= start_date),
	partner_uni_id INT NOT NULL REFERENCES Partner_University(uni_id) on delete cascade on update cascade,
	coordinator_id INT NOT NULL REFERENCES GIU_Academic(person_id) 
);

go

create table Opportunity (
	opp_id int identity,
	title varchar(200) not null,
	description varchar(1000),
	type varchar(30) not null check (type='Short Program' or type='Mobility Program' or type='Thesis Topic'),
	status varchar(30) not null default 'Open' check(status='Open' or status='Closed'),
	app_open_date date not null,
	app_close_date date not null,
	capacity int not null,
	location_mode varchar(30) not null check (location_mode in ('Germany', 'Egypt', 'Hybrid', 'Online')),
	agreement_id int,
	offered_by_rep_id int,
	CHECK (app_close_date >= app_open_date),
	CHECK (capacity > 0),
	primary key (opp_id),
	foreign key (agreement_id) references Cooperation_Agreement,
	foreign key (offered_by_rep_id) references Company_Rep
);
go

create table Opp_Language_Req(
	opp_id int,
	language_req varchar(50),
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

create table Thesis_Topic(
	opp_id int,
	expected_outcomes varchar(500) not null,
	funding_info varchar(300) not null,
	travel_info varchar(300) not null,
	accommodation_info varchar(300) not null,
	provider_id int not null,
	supervisor_id int not null,
	co_supervisor_id int,
	primary key (opp_id),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade,
	foreign key (provider_id) references Topic_Provider,
	foreign key (supervisor_id) references GIU_Academic,
	foreign key (co_supervisor_id) references Partner_Professor
);
go

create table Short_Program(
	opp_id int,
	duration varchar(50) not null,
	location varchar(100) not null,
	hosting_arrangements varchar(300) not null,
	host_uni_id int not null,
	primary key (opp_id),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade,
	foreign key (host_uni_id) references University
);
go

create table Mobility_Program(
	opp_id int,
	mobility_type varchar(50) not null,
	duration varchar(50) not null,
	sending_uni_id int not null,
	host_uni_id int not null,
	check (sending_uni_id <> host_uni_id),
	primary key (opp_id),
	foreign key (opp_id) references Opportunity on delete cascade on update cascade,
	foreign key (sending_uni_id) references University,
	foreign key (host_uni_id) references University
);
go

create table Application(
	app_id int identity,
	app_date date not null default getdate(),
	status varchar(20) not null default 'Pending' check(status='Pending' or status='Accepted' or status='Rejected'),
	decision_date date default null check(decision_date = null or decision_date>=app_date),
	info varchar(500),
	student_id int not null,
	opp_id int not null,
	primary key (app_id),
	foreign key (student_id) references Student,
	foreign key (opp_id) references Opportunity
);
go

create table Application_Document(
	app_id int,
	doc_type varchar(50) check (doc_type in ('CV', 'Transcript', 'Motivation Letter' ,'Language Certificate')),
	file_ref varchar(300) not null,
	upload_date date not null,
	primary key (app_id, doc_type),
	foreign key (app_id) references Application on delete cascade on update cascade
);


go

create table Mobility_Agreement(
agreement_id INT,
PRIMARY KEY(agreement_id),
FOREIGN KEY(agreement_id) REFERENCES Cooperation_Agreement(agreement_id) on delete cascade on update cascade,
exchange_terms VARCHAR(500) not null,
double_degree_terms VARCHAR(500) not null,
seat_quota INT not null,
tuition_arrangement VARCHAR(300) not null,
CHECK (seat_quota > 0)
);

go

create table Mob_Agr_Semester(
agreement_id INT ,
semester VARCHAR(30) ,
PRIMARY KEY(agreement_id, semester),
FOREIGN KEY(agreement_id) REFERENCES Mobility_Agreement(agreement_id) on delete cascade on update cascade
);

go

create table Research_Agreement(
agreement_id INT ,
PRIMARY KEY(agreement_id),
FOREIGN KEY(agreement_id) REFERENCES Cooperation_Agreement(agreement_id) on delete cascade on update cascade,
ip_terms VARCHAR(500),
funding_framework VARCHAR(300)
);

go

create table General_MoU(
agreement_id INT,
PRIMARY KEY(agreement_id),
FOREIGN KEY(agreement_id) REFERENCES Cooperation_Agreement(agreement_id) on delete cascade on update cascade,
intent VARCHAR(500) not null,
collab_scope VARCHAR(500) not null,
renewal_terms VARCHAR(300)

);

go

create table Funding_Opportunity(
fund_id INT PRIMARY KEY IDENTITY,
name  VARCHAR(255) not null,
agency VARCHAR(255) not null,
type VARCHAR(30) not null check(type in('Research Grant','Mobility Fund','Scholarship')),
amount decimal(10,2) not null check(amount > 0),
deadline datetime not null,
eligibility_conditions VARCHAR(255) not null,
status VARCHAR(255) not null default 'Open' check(status='Open' or status='Closed'),

);
go

create table Interview(
interview_id INT IDENTITY,
date DATE NOT NULL,
time TIME NOT NULL,
location_mode VARCHAR(30) NOT NULL,
outcome VARCHAR(50),
notes VARCHAR(500),
app_id INT NOT NULL,
PRIMARY KEY (interview_id),
FOREIGN KEY (app_id) REFERENCES Application(app_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Participation(
part_id INT IDENTITY,
status VARCHAR(30) not null default'Active' check(status='Active' or status='Completed'),
start_date DATETIME NOT NULL,
end_date DATETIME NOT NULL,
app_id INT NOT NULL UNIQUE,
CHECK (end_date >= start_date),
PRIMARY KEY (part_id),
FOREIGN KEY (app_id) REFERENCES Application(app_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Mobility(
part_id INT,
pre_travel_status VARCHAR(50),
during_status VARCHAR(50),
post_status VARCHAR(50),
final_outcome VARCHAR(300),
host_uni_id INT NOT NULL,
PRIMARY KEY (part_id),
FOREIGN KEY (part_id) REFERENCES Participation(part_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (host_uni_id) REFERENCES University(uni_id)
);
go

create table Program_Participation(
part_id INT,
payment_status VARCHAR(30),
visa_status VARCHAR(30),
travel_status VARCHAR(30),
PRIMARY KEY (part_id),
FOREIGN KEY (part_id) REFERENCES Participation(part_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go

create table Course_Equivalency (
part_id INT,
host_course_title VARCHAR(150) not null,
host_credits decimal(4,1) not null check (host_credits > 0),
transferred_credits decimal(4,1) not null check (transferred_credits > 0),
approval_status VARCHAR(30) not null default 'Pending' check(approval_status in('Approved','Rejected','Pending')),
giu_course_id INT not null,
PRIMARY KEY (part_id, host_course_title),
FOREIGN KEY (part_id) REFERENCES Mobility(part_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (giu_course_id) REFERENCES Course(course_id)	
);
go

create table Professor_Visit(
visit_id INT IDENTITY,
start_date DATETIME NOT NULL,
end_date DATETIME NOT NULL,
purpose VARCHAR(300) NOT NULL,
travel_arr VARCHAR(300),
accommodation_arr VARCHAR(300),
status VARCHAR(30) not null default 'Requested' check(status in('Active','Requested','Completed')),
follow_up_report VARCHAR(1000),
partner_prof_id INT NOT NULL,
host_faculty_id INT NOT NULL,
coordinator_id INT NOT NULL,
agreement_id INT,
CHECK (end_date >= start_date),
PRIMARY KEY (visit_id),
FOREIGN KEY (partner_prof_id) REFERENCES Partner_Professor(person_id),
FOREIGN KEY (host_faculty_id) REFERENCES Faculty(faculty_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (coordinator_id) REFERENCES GIU_Academic(person_id),
FOREIGN KEY (agreement_id) REFERENCES Cooperation_Agreement(agreement_id)
);
go

create table Visit_Outcome(
visit_id INT,
outcome VARCHAR(200),
PRIMARY KEY (visit_id, outcome),
FOREIGN KEY (visit_id) REFERENCES Professor_Visit(visit_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go

create table Agenda_Item (
visit_id INT,
seq_no INT IDENTITY ,
activity_type VARCHAR(30) check(activity_type in('Lecture','Meeting','Workshop')),
title VARCHAR(200) not null,
date_time DATETIME,
location VARCHAR(100),
audience VARCHAR(100),
PRIMARY KEY (visit_id, seq_no),
FOREIGN KEY (visit_id) REFERENCES Professor_Visit(visit_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go

create table Research_Project(
project_id INT IDENTITY,
title VARCHAR(200), 
description VARCHAR(1000),
status VARCHAR(30) not null default 'Ongoing' check(status='Ongoing' or status='Completed'),
start_date DATETIME,
end_date DATETIME,
res_agreement_id INT,
CHECK (end_date >= start_date),
PRIMARY KEY (project_id),
FOREIGN KEY (res_agreement_id) REFERENCES Research_Agreement(agreement_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Research_Output(
output_id INT IDENTITY,
type VARCHAR(30) not null check(type in('Publication','Deliverable','Dataset','Report')),
title VARCHAR(200) not null,
date DATE,
reference VARCHAR(200),
status VARCHAR(30) not null default 'Pending' check(status='Pending' or status='Published'),
project_id INT not null,
PRIMARY KEY (output_id),
FOREIGN KEY (project_id) REFERENCES Research_Project(project_id) ON DELETE cascade ON UPDATE CASCADE
);
go

Create table Project_Deadline(
project_id INT,
deadline DATETIME,
PRIMARY KEY (project_id, deadline),
FOREIGN KEY (project_id) REFERENCES Research_Project(project_id) ON DELETE CASCADE ON UPDATE CASCADE
);
go

create table Opp_Field(
    opp_id int,
    field_id int,
    primary key (opp_id, field_id),
    foreign key (opp_id) references Opportunity on delete cascade on update cascade,
    foreign key (field_id) references Field on delete cascade on update cascade
);
go

create table Opp_Eligible_Program(
    opp_id int,
    program_id int,
    primary key (opp_id, program_id),
    foreign key (opp_id) references Opportunity on delete cascade on update cascade,
    foreign key (program_id) references Program on delete cascade on update cascade
); 
go

create table Opp_Prereq_Course(
    opp_id int,
    course_id int,
    primary key (opp_id, course_id),
    foreign key (opp_id) references Opportunity on delete cascade on update cascade,
    foreign key (course_id) references Course 
);
go

create table Opp_Skill(
    opp_id int,
    skill_id int,
    primary key (opp_id, skill_id),
    foreign key (opp_id) references Opportunity on delete cascade on update cascade,
    foreign key (skill_id) references Skill on delete cascade on update cascade
);
go
create table Res_Agr_Area(
agreement_id INT,
area_id INT,
PRIMARY KEY (agreement_id, area_id),
FOREIGN KEY (agreement_id) REFERENCES Research_Agreement(agreement_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (area_id) REFERENCES Research_Area(area_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Thesis_Area(
opp_id INT,
area_id INT,
PRIMARY KEY (opp_id, area_id),
FOREIGN KEY (opp_id) REFERENCES Thesis_Topic(opp_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (area_id) REFERENCES Research_Area(area_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Conducts_Interview(
interviewer_id INT,
interview_id INT,
PRIMARY KEY (interviewer_id, interview_id),
FOREIGN KEY (interview_id) REFERENCES Interview(interview_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (interviewer_id) REFERENCES Interviewer(interviewer_id)
);
go

create table Project_Area(
project_id INT,
area_id INT,
PRIMARY KEY (project_id, area_id),
FOREIGN KEY (project_id) REFERENCES Research_Project(project_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (area_id) REFERENCES Research_Area(area_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table GIU_Participates(
academic_id int,
project_id int,
role varchar(255),
primary key(academic_id,project_id),
foreign key(academic_id) references GIU_Academic(person_id) on delete cascade on update cascade,
foreign key(project_id) references Research_Project(project_id) on delete cascade on update cascade
);
go

create table PP_Participates(
partner_prof_id int,
project_id int,
role varchar(255),
primary key(partner_prof_id,project_id),
foreign key(partner_prof_id) references Partner_Professor(person_id) on delete cascade on update cascade,
foreign key(project_id) references Research_Project(project_id)
);
go

create table Project_Targets_Fund(
project_id int,
fund_id int,
primary key(project_id,fund_id),
foreign key(project_id) references Research_Project(project_id) on delete cascade on update cascade,
foreign key(fund_id) references Funding_Opportunity(fund_id) on delete cascade on update cascade
);
go

create table Fund_Supports_Mobility(
fund_id int,
part_id int,
primary key(fund_id,part_id),
foreign key(fund_id) references Funding_Opportunity(fund_id) on delete cascade on update cascade,
foreign key(part_id) references Mobility(part_id) on delete cascade on update cascade
);
go

create table GIU_Interest(
academic_id INT,
area_id INT,
PRIMARY KEY (academic_id, area_id),
foreign key (academic_id) references GIU_Academic(person_id) ON DELETE cascade ON UPDATE CASCADE,
foreign key (area_id) references Research_Area(area_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table PP_Interest(
partner_prof_id INT,
area_id INT,
PRIMARY KEY (partner_prof_id, area_id),
foreign key (partner_prof_id) references Partner_Professor(person_id) ON DELETE cascade ON UPDATE CASCADE,
foreign key (area_id) references Research_Area(area_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Partner_Program_Field(
pprog_id INT,
field_id INT,
PRIMARY KEY (pprog_id, field_id),
foreign key (pprog_id) references Partner_Program(pprog_id) ON DELETE cascade ON UPDATE CASCADE,
foreign key (field_id) references Field(field_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Mob_Agr_Program(
agreement_id INT,
program_id INT,
PRIMARY KEY (agreement_id, program_id),
foreign key (agreement_id) references Mobility_Agreement(agreement_id) ON DELETE cascade ON UPDATE CASCADE,
foreign key (program_id) references Program(program_id) ON DELETE cascade ON UPDATE CASCADE
);
go

create table Prerequisite
(
course_id int,
prereq_course_id int,
CHECK (course_id <> prereq_course_id),
PRIMARY KEY (course_id, prereq_course_id),
FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (prereq_course_id) REFERENCES Course(course_id)
);
GO

create table Program_Field
(
program_id int,
field_id int,
PRIMARY KEY(program_id, field_id),
FOREIGN KEY (program_id) REFERENCES Program(program_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (field_id) REFERENCES Field(field_id) ON DELETE cascade ON UPDATE CASCADE
);
GO

create table Completed_Course
(
student_id int,
course_id int,
PRIMARY KEY(student_id, course_id),
FOREIGN KEY (student_id) REFERENCES Student(person_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
GO

create table Student_Skill
(
student_id int,
skill_id int,
PRIMARY KEY (student_id, skill_id),
FOREIGN KEY (student_id) REFERENCES Student(person_id) ON DELETE cascade ON UPDATE CASCADE,
FOREIGN KEY (skill_id) REFERENCES Skill(skill_id) ON DELETE cascade ON UPDATE CASCADE
);