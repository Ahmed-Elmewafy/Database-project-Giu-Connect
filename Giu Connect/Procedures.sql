create function ViewPersonInfo(@person_id int)
returns table as
return(
select p.*,
case
when s.person_id is not null then 'Student'
when ga.person_id is not null then 'GIU Academic'
when pp.person_id is not null then 'Partner Professor'
when cr.person_id is not null then 'Company Representative'
else 'General Person'
end as role,
s.student_no, s.current_semester, s.gpa, s.language_level, s.cv, s.program_id, si.interest,
ga.academic_rank, ga.dept_id,
pp.title, pp.pdept_id,
cr.company_name, cr.sector, cr.position, cr.location
from Person as p
left join Student as s on p.person_id=s.person_id
left join GIU_Academic as ga on p.person_id=ga.person_id
left join Partner_Professor as pp on p.person_id=pp.person_id
left join Company_Rep as cr on p.person_id=cr.person_id
left join Student_Interest as si on s.person_id=si.person_id
where p.person_id=@person_id
);

go

create procedure AddStudent
@full_name varchar(150), @email varchar(150), @phone varchar(30),
@student_no varchar(20), @current_semester int, @gpa decimal(3,2), @language_level varchar(30), @cv varchar(300), @program_id int
as begin
set nocount on
begin transaction
begin try
insert into Person(full_name, email, phone, account_status)
values(@full_name, @email, @phone, 'Active');
declare @person_id int=scopeidentity();
insert into Student(person_id, student_no, current_semester, gpa, language_level, cv, program_id)
values(@person_id, @student_no, @current_semester, @gpa, @language_level, @cv, @program_id);
commit transaction
print 'Student added successfully';
end try
begin catch
rollback transaction
print 'Error, cannot add student: '+error_message();
end catch
end;

go

create procedure AddGIUAcademic
@full_name varchar(150), @email varchar(150), @phone varchar(30),
@academic_rank varchar(50), @dept_id int
as begin
set nocount on
begin transaction
begin try
insert into Person(full_name, email, phone, account_status)
values(@full_name, @email, @phone, 'Active');
declare @person_id int=scopeidentity();
insert into GIU_Academic(person_id, academic_rank, dept_id)
values(@person_id, @academic_rank, @dept_id);
commit transaction
print 'GIU Academic added successfully';
end try
begin catch
rollback transaction
print 'Error, cannot add GIU Academic: '+error_message();
end catch
end;

go

create procedure AddPartnerProfessor
@full_name varchar(150), @email varchar(150), @phone varchar(30),
@title varchar(50), @pdept_id int
as begin
set nocount on
begin transaction
begin try
insert into Person(full_name, email, phone, account_status)
values(@full_name, @email, @phone, 'Active');
declare @person_id int=scopeidentity();
insert into Partner_Professor(person_id, title, pdept_id)
values(@person_id, @title, @pdept_id);
commit transaction
print 'Partner Professor added successfully';
end try
begin catch
rollback transaction
print 'Error, cannot add Partner Professor: '+error_message();
end catch
end;

go

create procedure AddCompanyRep
@full_name varchar(150), @email varchar(150), @phone varchar(30),
@company_name varchar(150), @sector varchar(100), @position varchar(100), @location varchar(100)
as begin
set nocount on
begin transaction
begin try
insert into Person(full_name, email, phone, account_status)
values(@full_name, @email, @phone, 'Active');
declare @person_id int=scopeidentity();
insert into Company_Rep(person_id, company_name, sector, position, location)
values(@person_id, @company_name, @sector, @position, @location);
commit transaction
print 'Company Representative added successfully';
end try
begin catch
rollback transaction
print 'Error, cannot add Company Representative: '+error_message();
end catch
end;

go

create procedure UpdatePersonContact
@person_id int, @email varchar(150), @phone varchar(30)
as begin
set nocount on
begin try
update Person
set email=@email, phone=@phone
where person_id=@person_id;
print 'Contact Info updated successfully';
end try
begin catch
print 'Error, cannot update Contact Info: '+error_message();
end catch
end;

go

create procedure UpdateAccountStatus
@person_id int, @account_status varchar(20)
as begin
set nocount on
begin try
update Person
set account_status=@account_status
where person_id=@person_id
print 'Account Status updated successfully';
end try
begin catch
print 'Error, cannot update Account Status: '+error_message();
end catch
end;

go

create procedure RegisterTopicProvider
@person_id int
as begin
set nocount on
begin try
if not exists(select 1 from Person where person_id=@person_id)
begin raiserror('Error: Person does not exist',16,1); return; end
if not exists(
select 1 from GIU_Academic where person_id=@person_id
union
select 1 from Partner_Professor where person_id=@person_id
union
select 1 from Company_Rep where person_id=@person_id)
begin raiserror('Error: Person not allowed to register',16,1); return; end
if exists (select 1 from Topic_Provider where person_id=@person_id)
begin raiserror('Error: Person already registered',16,1); return; end
insert into Topic_Provider(person_id)
values(@person_id);
print 'Topic Provider registered successfully';
end try
begin catch
print 'Error, cannot register Topic Provider: '+error_message();
end catch
end

go

create procedure RegisterInterviewer
@person_id int
as begin
set nocount on
begin try
if not exists(select 1 from Person where person_id=@person_id)
begin raiserror('Person does not exist',16,1); return; end
declare @role varchar(100);
select @role=case
when ga.person_id is not null then 'GIU Academic'
when pp.person_id is not null then 'Partner Professor'
when cr.person_id is not null then 'Company Representative'
else null end
from Person as p
left join GIU_Academic as ga on p.person_id=ga.person_id
left join Partner_Professor as pp on p.person_id=pp.person_id
left join Company_Rep as cr on p.person_id=cr.person_id
where p.person_id=@person_id;
if(@role is null)
begin raiserror('Person not allowed to register',16,1); return; end
if exists(select 1 from Interviewer where person_id=@person_id)
begin raiserror('Interviewer already registered',16,1); return; end
insert into Interviewer(person_id,role)
values(@person_id,@role);
print 'Interviewer registered successfully';
end try
begin catch
print 'Error, cannot register Interviewer: '+error_message();
end catch
end

go

create procedure AddFaculty
@name varchar(150), @description varchar(500)
as begin
set nocount on
begin try
insert into Faculty(name, description)
values(@name,@description);
print 'Faculty added successfully';
end try
begin catch
print 'Error, cannot add Faculty: '+error_message();
end catch
end

go

create procedure AddDepartment
@name varchar(150), @description varchar(500), @faculty_id int
as begin
set nocount on
begin try
if not exists(select 1 from Faculty where faculty_id=@faculty_id)
begin raiserror('Faculty does not exist',16,1); return; end
insert into Department(name,description,faculty_id)
values(@name,@description,@faculty_id);
print 'Department added successfully';
end try
begin catch
print 'Error, cannot add Department: '+error_message();
end catch
end

go

create procedure AddProgram
@name varchar(150), @degree_level varchar(30), @total_credit_hours int, @description varchar(500), @dept_id int
as begin
set nocount on
begin try
if not exists(select 1 from Department where dept_id=@dept_id)
begin raiserror('Department does not exist',16,1); return; end
insert into Program(name,degree_level,total_credit_hours,description,dept_id)
values(@name,@degree_level,@total_credit_hours,@description,@dept_id);
print 'Program added successfully';
end try
begin catch
print 'Error, cannot add Program: '+error_message();
end catch
end

go

create procedure ClassifyProgram
@program_id int, @field_id int
as begin
set nocount on
begin try
if not exists(select 1 from Program where program_id=@program_id)
begin raiserror('Program does not exist',16,1); return; end
if not exists(select 1 from Field where field_id=@field_id)
begin raiserror('Field does not exist',16,1); return; end
if exists(select 1 from Program_Field where program_id=@program_id and field_id=@field_id)
begin raiserror('Program already classified to this Field',16,1); return; end
insert into Program_Field(program_id,field_id)
values(@program_id,@field_id);
print 'Program classified successfully';
end try
begin catch
print 'Error, cannot classify Porgram: '+error_message();
end catch
end

go

create procedure AddCourse
@code varchar(20), @title varchar(150), @credit_hours int, @level int, @program_id int
as begin
set nocount on
begin try
if not exists(select 1 from Program where program_id=@program_id)
begin raiserror('Program does not exist',16,1); return; end
insert into Course(code,title,credit_hours,level,program_id)
values(@code,@title,@credit_hours,@level,@program_id);
print 'Course added successfully';
end try
begin catch
print 'Error, cannot add Course: '+error_message();
end catch
end

go

create procedure AddPrerequisite
@course_id int, @prereq_course_id int
as begin
set nocount on
begin try
if not exists(select 1 from Course where course_id=@course_id)
begin raiserror('Course does not exist',16,1); return; end
if not exists(select 1 from Course where course_id=@prereq_course_id)
begin raiserror('Prerequisite Course does not exist',16,1); return; end
if exists(select 1 from Prerequisite where course_id=@course_id and prereq_course_id=@prereq_course_id)
begin raiserror('Prerequisite already exists for Course',16,1); return; end
insert into Prerequisite(course_id,prereq_course_id)
values(@course_id,@prereq_course_id);
print 'Prerequisite added successfully';
end try
begin catch
print 'Error, cannot add Prerequisite: '+error_message();
end catch
end

go

create procedure AddField
@name varchar(100), @description varchar(500)
as begin
set nocount on
begin try
insert into Field(name,description)
values(@name,@description);
print 'Field added successfully';
end try
begin catch
print 'Error, cannot add Field: '+error_message();
end catch
end

go

create procedure AddResearchArea
@name varchar(150), @description varchar(500), @field_id int
as begin
set nocount on
begin try
if not exists(select 1 from Field where field_id=@field_id)
begin raiserror('Field does not exist',16,1); return; end
insert into Research_Area(name,description,field_id)
values(@name,@description,@field_id);
print 'Research Area added successfully';
end try
begin catch
print 'Error, cannot add Research Area: '+error_message();
end catch
end

go

create procedure AddSkill
@name varchar(100), @category varchar(50), @description varchar(500)
as begin
set nocount on
begin try
insert into Skill(name,category,description)
values(@name,@category,@description);
print 'Skill added successfully';
end try
begin catch
print 'Error, cannot add Skill: '+error_message();
end catch
end

go

create procedure AddPartnerUniversity
@name varchar(150), @country varchar(60), @city varchar(60), @description varchar(500),
@partnership_status varchar(30), @contact_info varchar(300)
as begin
set nocount on
begin transaction
begin try
insert into University(name,country,city,description)
values(@name,@country,@city,@description);
declare @uni_id int=scopeidentity();
insert into Partner_University(uni_id,partnership_status,contact_info)
values(@uni_id,@partnership_status,@contact_info);
commit transaction
print 'Partner University added successfully';
end try
begin catch
rollback transaction
print 'Error, cannot add Partner University: '+error_message();
end catch
end

go

create procedure AddPartnerDepartment
@name varchar(150), @description varchar(500), @partner_uni_id int
as begin
set nocount on
begin try
if not exists(select 1 from Partner_University where uni_id=@partner_uni_id)
begin raiserror('Partner University does not exist',16,1); return; end
insert into Partner_Department(name,description,uni_id)
values(@name,@description,@partner_uni_id);
print 'Partner Department added successfully';
end try
begin catch
print 'Error, cannot add Partner Department: '+error_message();
end catch
end

go

create procedure AddPartnerProgram
@name varchar(150), @degree_level varchar(30), @description varchar(500),@pdept_id int, 
@field_id int
as begin
set nocount on
begin transaction
begin try
if not exists(select 1 from Partner_Department where pdept_id=@pdept_id)
begin raiserror('Partner Department does not exist',16,1); return; end
if not exists(select 1 from Field where field_id=@field_id)
begin raiserror('Field does not exist',16,1); return; end
insert into Partner_Program(name,degree_level,description,pdept_id)
values(@name,@degree_level,@description,@pdept_id);
declare @pprog_id int=scopeidentity();
insert into Program_Field(program_id,field_id)
values(@pprog_id,@field_id);
commit transaction
print 'Partner Porgram added and classified successfully';
end try
begin catch
rollback transaction
print 'Cannot add or classify Partner Program: '+error_message();
end catch
end

go

create function GetUserStatsByRole()
returns table as
return(
select roles.role, count(roles.person_id) as total_persons, sum(case when roles.account_status='Active' then 1 else 0 end) as total_active
from(
select p.person_id, p.account_status,
case
when s.person_id is not null then 'Student'
when ga.person_id is not null then 'GIU Academic'
when pp.person_id is not null then 'Partner Professor'
when cr.person_id is not null then 'Company Representative'
else 'General Person'
end as role
from Person as p
left join Student as s on p.person_id=s.person_id
left join GIU_Academic as ga on p.person_id=ga.person_id
left join Partner_Professor as pp on p.person_id=pp.person_id
left join Company_Rep as cr on p.person_id=cr.person_id
)as roles
group by roles.role
);

go

create procedure SendNotification
@recipient_id int, @message varchar(500), @category varchar(30), @urgency varchar(20)
as begin
set nocount on
begin try
if not exists(select 1 from Person where person_id=@recipient_id)
begin raiserror('Recipient does not exist',16,1); return; end
insert into Notification(message,category,urgency,recipient_id)
values(@message,@category,@urgency,@recipient_id);
print 'Notification sent successfully';
end try
begin catch
print 'Error, cannot send Notification: '+error_message();
end catch
end

go

create procedure UpdateCompanyProfile
@person_id int, @company_name varchar(150), @sector varchar(100), @position varchar(100), @location varchar(100)
as begin
set nocount on
begin try
if not exists (select 1 from Person where person_id=@person_id)
begin raiserror('Person does not exist',16,1); return; end
if not exists (select 1 from Company_Rep where person_id=@person_id)
begin raiserror('Person is not Company Representative',16,1); return; end
update Company_Rep
set company_name=@company_name, sector=@sector, position=@position, location=@location where person_id=@person_id;
print 'Company Profile updated successfully';
end try
begin catch
print 'Error, cannot update Company Profile: '+error_message();
end catch
end

go

create procedure OfferPlacement
@opp_id int, @offered_by_rep_id int
as begin
set nocount on
begin try
if not exists(select 1 from Opportunity where opp_id=@opp_id)
begin raiserror('Opportunity does not exist',16,1); return; end
if not exists(select 1 from Company_Rep where person_id=@offered_by_rep_id)
begin raiserror('Company Representative does not exist',16,1); return; end
if exists(select 1 from Opportunity where opp_id=@opp_id and offered_by_rep_id=@offered_by_rep_id and status='Closed')
begin raiserror('Opportunity already closed',16,1); return; end
if exists(select 1 from Opportunity where opp_id=@opp_id and offered_by_rep_id=@offered_by_rep_id and status='Open')
begin raiserror('Opportunity already offered',16,1); return; end
if exists(select 1 from Opportunity where opp_id=@opp_id and offered_by_rep_id is not null and offered_by_rep_id<>@offered_by_rep_id)
begin raiserror('Opportunity offered by another Company Representative',16,1); return; end
update Opportunity
set offered_by_rep_id=@offered_by_rep_id where opp_id=@opp_id;
print 'Placement offered successfully';
end try
begin catch
print 'Error, cannot offer Placement: '+error_message();
end catch
end

go

create function ViewMyPlacements(@offered_by_rep_id int)
returns table as
return(
select o.opp_id, o.title, o.status, o.capacity, a.app_id, a.student_id
from Opportunity o
join Application a on o.opp_id=a.opp_id
where o.offered_by_rep_id=@offered_by_rep_id and a.status='Accepted'
);

go

create function ViewPlacementApplicants(@opp_id int, @offered_by_rep_id int)
returns table as
return(
select p.full_name, a.student_id, s.program_id, s.gpa, ss.skill_id, a.status
from Application a
join Person p on a.student_id=p.person_id
join Student s on a.student_id=s.person_id
left join Student_Skill ss on a.student_id=ss.student_id
join Opportunity o on a.opp_id=o.opp_id
where o.opp_id=@opp_id and o.offered_by_rep_id=@offered_by_rep_id
);

go

create function GetSkillMatch( @student_id int, @opp_id int)
returns decimal(5,2) as
begin
declare @required int;
declare @match int;
declare @percentage decimal(5,2);
select @required=count(*)
from Opp_Skill
where opp_id=@opp_id;
if @required=0
begin
return null;
end
select @match=count(*)
from Opp_Skill as os
join Student_Skill as ss on os.skill_id=ss.skill_id
where os.opp_id=@opp_id and ss.student_id=@student_id;
set @percentage=cast((@match*100.00)/@required as decimal(5,2));
return @percentage;
end

go

create procedure ClosePlacement
@opp_id int, @offered_by_rep_id int
as begin
set nocount on
begin try
if not exists(select 1 from Opportunity where opp_id=@opp_id)
begin raiserror('Opportunity does not exist',16,1); return; end
if not exists (select 1 from Company_Rep where person_id=@offered_by_rep_id)
begin raiserror('Company Representative does not exist',16,1); return; end
if not exists(select 1 from Opportunity where opp_id=@opp_id and offered_by_rep_id=@offered_by_rep_id)
begin raiserror('Opportunity not offered by Company Representative',16,1); return; end
if exists(select 1 from Opportunity where opp_id=@opp_id and offered_by_rep_id=@offered_by_rep_id and status='Closed')
begin raiserror('Opportunity already closed',16,1); return; end
update Opportunity
set status='Closed'
where opp_id=@opp_id and offered_by_rep_id=@offered_by_rep_id;
print 'Placement closed successfully';
end try
begin catch
print 'Error, cannot close Placement: '+error_message();
end catch
end