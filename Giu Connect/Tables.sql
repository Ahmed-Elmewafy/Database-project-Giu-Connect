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
FOREIGN KEY (partner_prof_id) REFERENCES Professor(prof_id) ON DELETE SET NULL ON UPDATE CASCADE,
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