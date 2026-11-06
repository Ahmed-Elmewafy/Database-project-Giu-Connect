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