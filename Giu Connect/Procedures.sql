--1
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

--6
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

go

--4
CREATE PROCEDURE DeclareResearchInterest
    @academic_id int, 
    @area_id int
AS
BEGIN
    IF @academic_id IS NULL OR @area_id IS NULL
        PRINT 'Academic ID and Area ID cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM GIU_Academic 
    WHERE person_id = @academic_id)
        PRINT 'GIU academic does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Area 
    WHERE area_id = @area_id)
        PRINT 'Research area does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM GIU_Interest 
    WHERE academic_id = @academic_id AND area_id = @area_id)
        PRINT 'This research interest is already declared.';
    ELSE
    BEGIN TRY
        INSERT INTO GIU_Interest (academic_id, area_id) VALUES (@academic_id, @area_id);
        PRINT 'Research interest successfully declared.';
    END TRY
    BEGIN CATCH
        PRINT 'Error declaring research interest: ' + ERROR_MESSAGE();
    END CATCH
END;
go

CREATE PROCEDURE RemoveResearchInterest
    @academic_id int, 
    @area_id int
AS
BEGIN
    IF @academic_id IS NULL OR @area_id IS NULL
        PRINT 'Academic ID and Area ID cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM GIU_Interest 
    WHERE academic_id = @academic_id AND area_id = @area_id)
        PRINT 'This research interest was not found.';
    ELSE
    BEGIN TRY
        DELETE FROM GIU_Interest 
        WHERE academic_id = @academic_id AND area_id = @area_id;
        PRINT 'Research interest successfully removed.';
    END TRY
    BEGIN CATCH
        PRINT 'Error removing research interest: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION ViewSupervisedTopics (@supervisor_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        O.title AS Topic,
        PCo.full_name AS Co_Supervisor,
        O.capacity AS Capacity,
        (SELECT COUNT(*) 
        FROM Application A 
        WHERE A.opp_id = O.opp_id) AS Total_Applications,
        (SELECT COUNT(*) 
        FROM Application A 
        WHERE A.opp_id = O.opp_id AND A.status = 'Accepted') AS Accepted_Students
    FROM Opportunity O
    JOIN Thesis_Topic T 
    ON O.opp_id = T.opp_id
    LEFT JOIN Person PCo 
    ON T.co_supervisor_id = PCo.person_id
    WHERE T.supervisor_id = @supervisor_id
);

go

CREATE FUNCTION FindPartnerCollaborators (@academic_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        Pers.full_name AS Partner_Professor,
        U.name AS Partner_University,
        COUNT(P.area_id) AS Shared_Research_Areas
    FROM GIU_Interest G
    JOIN PP_Interest P 
    ON G.area_id = P.area_id
    JOIN Partner_Professor PP 
    ON P.partner_prof_id = PP.person_id
    JOIN Person Pers 
    ON PP.person_id = Pers.person_id
    JOIN Partner_Department PD 
    ON PP.pdept_id = PD.pdept_id
    JOIN University U 
    ON PD.uni_id = U.uni_id
    WHERE G.academic_id = @academic_id
    GROUP BY PP.person_id, Pers.full_name, U.name
);

go

CREATE FUNCTION FindCoSupervisors (@opp_id int)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (100) PERCENT
        Pers.full_name AS Partner_Professor,
        COUNT(P.area_id) AS Shared_Research_Areas
    FROM Thesis_Area T
    JOIN PP_Interest P 
    ON T.area_id = P.area_id
    JOIN Partner_Professor PP 
    ON P.partner_prof_id = PP.person_id
    JOIN Person Pers 
    ON PP.person_id = Pers.person_id
    WHERE T.opp_id = @opp_id
    GROUP BY PP.person_id, Pers.full_name
    ORDER BY Shared_Research_Areas DESC
);

go

CREATE FUNCTION ViewTopicApplicants (@opp_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        Pers.full_name AS Applicant,
        Prog.name AS Program,
        S.gpa AS GPA,
        S.language_level AS Language_Level,
        A.status AS Application_Status,
        (SELECT COUNT(*) 
         FROM Opp_Skill OS 
         JOIN Student_Skill SS 
         ON OS.skill_id = SS.skill_id 
         WHERE OS.opp_id = A.opp_id AND SS.student_id = S.person_id) AS Required_Skills_Met

    FROM Application A
    JOIN Student S 
    ON A.student_id = S.person_id
    JOIN Person Pers 
    ON S.person_id = Pers.person_id
    JOIN Program Prog 
    ON S.program_id = Prog.program_id
    WHERE A.opp_id = @opp_id
);

go

CREATE FUNCTION CheckEligibility (
    @student_id int,
    @opp_id int
)
RETURNS BIT
AS
BEGIN
    DECLARE @returnedValue BIT;
    DECLARE @req_courses int;
    DECLARE @done_courses int;
    DECLARE @req_skills int;
    DECLARE @done_skills int;

    SELECT @req_courses = COUNT(*)
    FROM Opp_Prereq_Course
    WHERE opp_id = @opp_id;

    SELECT @done_courses = COUNT(*)
    FROM Opp_Prereq_Course OPC
    JOIN Completed_Course CC 
    ON OPC.course_id = CC.course_id
    WHERE OPC.opp_id = @opp_id
      AND CC.student_id = @student_id;

    SELECT @req_skills = COUNT(*)
    FROM Opp_Skill
    WHERE opp_id = @opp_id;
    SELECT @done_skills = COUNT(*)
    FROM Opp_Skill OS
    JOIN Student_Skill SS 
    ON OS.skill_id = SS.skill_id
    WHERE OS.opp_id = @opp_id
      AND SS.student_id = @student_id;
    IF (
        EXISTS (
            SELECT 1
            FROM Student S
            JOIN Opp_Eligible_Program OEP 
            ON S.program_id = OEP.program_id
            WHERE S.person_id = @student_id
              AND OEP.opp_id = @opp_id
        )
        AND @req_courses = @done_courses
        AND @req_skills = @done_skills
    )
        SET @returnedValue = 1;
    ELSE
        SET @returnedValue = 0;

    RETURN @returnedValue;
END;

go

CREATE PROCEDURE EvaluateInterview
    @interview_id int,
    @outcome varchar(50),
    @notes varchar(500)
AS
BEGIN
    IF @interview_id IS NULL OR @outcome IS NULL
        PRINT 'Interview ID and outcome cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Interview 
    WHERE interview_id = @interview_id)
        PRINT 'Interview not found.';
    ELSE
    BEGIN TRY
        UPDATE Interview
        SET outcome = @outcome,
            notes = @notes
        WHERE interview_id = @interview_id;

        PRINT 'Interview evaluated successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error evaluating interview: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROCEDURE CreateResearchProject
    @title varchar(200),
    @description varchar(1000),
    @start_date date,
    @end_date date,
    @res_agreement_id int,
    @academic_id int
AS
BEGIN
    IF @title IS NULL OR @start_date IS NULL OR @end_date IS NULL OR @res_agreement_id IS NULL OR @academic_id IS NULL
        PRINT 'Title, start date, end date, research agreement ID, and academic ID cannot be null.';
    ELSE IF @end_date < @start_date
        PRINT 'End date cannot be earlier than start date.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Agreement 
    WHERE agreement_id = @res_agreement_id)
        PRINT 'Research agreement does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM GIU_Academic 
    WHERE person_id = @academic_id)
        PRINT 'GIU academic does not exist.';
    ELSE
    BEGIN TRY
        INSERT INTO Research_Project (title, description, status, start_date, end_date, res_agreement_id)
        VALUES (@title, @description, 'Active', @start_date, @end_date, @res_agreement_id);

        DECLARE @project_id int;
        SELECT @project_id = MAX(project_id)
        FROM Research_Project
        WHERE title = @title
          AND start_date = @start_date
          AND end_date = @end_date
          AND res_agreement_id = @res_agreement_id;

        INSERT INTO GIU_Participates (academic_id, project_id, role)
        VALUES (@academic_id, @project_id, 'Principal Investigator');

        PRINT 'Research project created successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error creating research project: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROCEDURE AddProjectArea
    @project_id int,
    @area_id int
AS
BEGIN
    IF @project_id IS NULL OR @area_id IS NULL
        PRINT 'Project ID and Area ID cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Project 
    WHERE project_id = @project_id)
        PRINT 'Research project does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Area 
    WHERE area_id = @area_id)
        PRINT 'Research area does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM Project_Area 
    WHERE project_id = @project_id AND area_id = @area_id)
        PRINT 'This research area is already assigned to the project.';
    ELSE
    BEGIN TRY
        INSERT INTO Project_Area (project_id, area_id)
        VALUES (@project_id, @area_id);

        PRINT 'Research area successfully added to the project.';
    END TRY
    BEGIN CATCH
        PRINT 'Error adding project area: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROCEDURE AddGIUParticipant
    @academic_id int,
    @project_id int,
    @role varchar(50)
AS
BEGIN
    IF @academic_id IS NULL OR @project_id IS NULL OR @role IS NULL
        PRINT 'Academic ID, Project ID, and Role cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM GIU_Academic 
    WHERE person_id = @academic_id)
        PRINT 'GIU academic does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Project 
    WHERE project_id = @project_id)
        PRINT 'Research project does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM GIU_Participates 
    WHERE academic_id = @academic_id AND project_id = @project_id)
        PRINT 'This GIU academic is already participating in the project.';
    ELSE
    BEGIN TRY
        INSERT INTO GIU_Participates (academic_id, project_id, role)
        VALUES (@academic_id, @project_id, @role);

        PRINT 'GIU academic successfully added to the research project.';
    END TRY
    BEGIN CATCH
        PRINT 'Error adding GIU participant: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROCEDURE AddProjectDeadline
    @project_id int,
    @deadline date
AS
BEGIN
    IF @project_id IS NULL OR @deadline IS NULL
        PRINT 'Project ID and Deadline cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Project 
    WHERE project_id = @project_id)
        PRINT 'Research project does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM Project_Deadline 
    WHERE project_id = @project_id AND deadline = @deadline)
        PRINT 'This deadline is already recorded for the project.';
    ELSE
    BEGIN TRY
        INSERT INTO Project_Deadline (project_id, deadline)
        VALUES (@project_id, @deadline);

        PRINT 'Project deadline successfully added.';
    END TRY
    BEGIN CATCH
        PRINT 'Error adding project deadline: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROCEDURE RecordResearchOutput
    @project_id int,
    @type varchar(30),
    @title varchar(200),
    @date date,
    @reference varchar(200),
    @status varchar(30)
AS
BEGIN
    IF @project_id IS NULL OR @type IS NULL OR @title IS NULL OR @date IS NULL OR @reference IS NULL OR @status IS NULL
        PRINT 'All inputs are required and cannot be null.';
    ELSE IF @type NOT IN ('Publication', 'Deliverable', 'Dataset', 'Report')
        PRINT 'Invalid output type. Must be publication, deliverable, dataset, or report.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Project 
    WHERE project_id = @project_id)
        PRINT 'Research project does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM Research_Output 
    WHERE project_id = @project_id AND title = @title AND type = @type)
        PRINT 'This research output is already recorded for the project.';
    ELSE
    BEGIN TRY
        INSERT INTO Research_Output (type, title, date, reference, status, project_id)
        VALUES (@type, @title, @date, @reference, @status, @project_id);

        PRINT 'Research output recorded successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error recording research output: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROCEDURE LinkProjectToFunding
    @project_id int,
    @fund_id int
AS
BEGIN
    IF @project_id IS NULL OR @fund_id IS NULL
        PRINT 'Project ID and Funding ID cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Project 
    WHERE project_id = @project_id)
        PRINT 'Research project does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Funding_Opportunity 
    WHERE fund_id = @fund_id)
        PRINT 'Funding opportunity does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM Project_Targets_Fund 
    WHERE project_id = @project_id AND fund_id = @fund_id)
        PRINT 'This research project is already linked to the funding opportunity.';
    ELSE
    BEGIN TRY
        INSERT INTO Project_Targets_Fund (project_id, fund_id)
        VALUES (@project_id, @fund_id);

        PRINT 'Research project successfully linked to the funding opportunity.';
    END TRY
    BEGIN CATCH
        PRINT 'Error linking project to funding: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION ViewProjectOutputs (@project_id int)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (100) PERCENT
        output_id AS Output_ID,
        type AS Output_Type,
        title AS Title,
        date AS Output_Date,
        reference AS Reference,
        status AS Status
    FROM Research_Output
    WHERE project_id = @project_id
    ORDER BY date
);

go

CREATE FUNCTION GetMyProjectDeadlines (
    @academic_id int,
    @days_ahead int
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        RP.title AS Project,
        PD.deadline AS Deadline,
        CAST(PD.deadline - CAST(CAST(CURRENT_TIMESTAMP AS DATE) AS DATETIME) AS INT) AS Days_Remaining
    FROM GIU_Participates GP
    JOIN Research_Project RP 
        ON GP.project_id = RP.project_id
    JOIN Project_Deadline PD 
        ON RP.project_id = PD.project_id
    WHERE GP.academic_id = @academic_id
      AND CAST(PD.deadline AS DATE) >= CAST(CURRENT_TIMESTAMP AS DATE)
      AND PD.deadline <= CURRENT_TIMESTAMP + @days_ahead
);

go

CREATE FUNCTION ViewMyCoordinatedVisits (@coordinator_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        P.full_name AS Visiting_Professor,
        PV.start_date AS Start_Date,
        PV.end_date AS End_Date,
        PV.status AS Status,
        COUNT(AI.seq_no) AS Agenda_Items_Count
    FROM Professor_Visit PV
    JOIN Partner_Professor PP 
    ON PV.partner_prof_id = PP.person_id
    JOIN Person P 
    ON PP.person_id = P.person_id
    LEFT JOIN Agenda_Item AI 
    ON PV.visit_id = AI.visit_id
    WHERE PV.coordinator_id = @coordinator_id
    GROUP BY PV.visit_id, P.full_name, PV.start_date, PV.end_date, PV.status
);

go

--5
CREATE PROCEDURE DeclarePartnerInterest
    @partner_prof_id int,
    @area_id int
AS
BEGIN
    IF @partner_prof_id IS NULL OR @area_id IS NULL
        PRINT 'Partner Professor ID and Area ID cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Partner_Professor 
    WHERE person_id = @partner_prof_id)
        PRINT 'Partner professor does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Area 
    WHERE area_id = @area_id)
        PRINT 'Research area does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM PP_Interest 
    WHERE partner_prof_id = @partner_prof_id AND area_id = @area_id)
        PRINT 'This research area is already declared as an interest for this partner professor.';
    ELSE
    BEGIN TRY
        INSERT INTO PP_Interest (partner_prof_id, area_id)
        VALUES (@partner_prof_id, @area_id);

        PRINT 'Research interest declared successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error declaring partner research interest: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION FindGIUCollaborators (@partner_prof_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        P.full_name AS GIU_Academic,
        D.name AS Department,
        COUNT(GI.area_id) AS Shared_Research_Areas
    FROM PP_Interest PPI
    JOIN GIU_Interest GI 
    ON PPI.area_id = GI.area_id
    JOIN GIU_Academic GA 
    ON GI.academic_id = GA.person_id
    JOIN Person P 
    ON GA.person_id = P.person_id
    JOIN Department D 
    ON GA.dept_id = D.dept_id
    WHERE PPI.partner_prof_id = @partner_prof_id
    GROUP BY GA.person_id, P.full_name, D.name
);

go

CREATE PROCEDURE AcceptCoSupervision
    @opp_id int,
    @co_supervisor_id int
AS
BEGIN
    IF @opp_id IS NULL OR @co_supervisor_id IS NULL
        PRINT 'Opportunity ID and Co-Supervisor ID cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Thesis_Topic 
    WHERE opp_id = @opp_id)
        PRINT 'Thesis topic does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Partner_Professor 
    WHERE person_id = @co_supervisor_id)
        PRINT 'Partner professor does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM Thesis_Topic 
    WHERE opp_id = @opp_id AND co_supervisor_id IS NOT NULL)
        PRINT 'This thesis topic already has a co-supervisor assigned.';
    ELSE
    BEGIN TRY
        UPDATE Thesis_Topic
        SET co_supervisor_id = @co_supervisor_id
        WHERE opp_id = @opp_id;

        PRINT 'Co-supervision accepted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error accepting co-supervision: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION ViewCoSupervisedTopics (@co_supervisor_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        O.title AS Topic,
        PSup.full_name AS GIU_Supervisor,
        PStu.full_name AS Accepted_Student
    FROM Thesis_Topic TT
    JOIN Opportunity O 
    ON TT.opp_id = O.opp_id
    JOIN GIU_Academic GA 
    ON TT.supervisor_id = GA.person_id
    JOIN Person PSup 
    ON GA.person_id = PSup.person_id
    LEFT JOIN Application A 
    ON TT.opp_id = A.opp_id AND A.status = 'Accepted'
    LEFT JOIN Student S 
    ON A.student_id = S.person_id
    LEFT JOIN Person PStu 
    ON S.person_id = PStu.person_id
    WHERE TT.co_supervisor_id = @co_supervisor_id
);

go

CREATE PROCEDURE RequestVisit
    @partner_prof_id int,
    @agreement_id int,
    @host_faculty_id int,
    @start_date date,
    @end_date date,
    @purpose varchar(300)
AS
BEGIN
    IF @partner_prof_id IS NULL OR @agreement_id IS NULL OR @host_faculty_id IS NULL OR @start_date IS NULL OR @end_date IS NULL
        PRINT 'Partner Professor ID, Agreement ID, Host Faculty ID, start date, and end date cannot be null.';
    ELSE IF @end_date < @start_date
        PRINT 'End date cannot be earlier than start date.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Partner_Professor 
    WHERE person_id = @partner_prof_id)
        PRINT 'Partner professor does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Cooperation_Agreement 
    WHERE agreement_id = @agreement_id)
        PRINT 'Cooperation agreement does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Faculty 
    WHERE faculty_id = @host_faculty_id)
        PRINT 'Host faculty does not exist.';
    ELSE IF NOT EXISTS (
        SELECT 1
        FROM Partner_Professor PP
        JOIN Partner_Department PD 
        ON PP.pdept_id = PD.pdept_id
        JOIN Cooperation_Agreement CA 
        ON PD.uni_id = CA.partner_uni_id
        WHERE PP.person_id = @partner_prof_id
          AND CA.agreement_id = @agreement_id
    )
        PRINT 'Partner professor does not belong to the partner university of this agreement.';
    ELSE IF EXISTS (
        SELECT 1
        FROM Professor_Visit
        WHERE partner_prof_id = @partner_prof_id
          AND agreement_id = @agreement_id
          AND start_date = @start_date
          AND end_date = @end_date
    )
        PRINT 'A visit request for these dates under this agreement already exists.';
    ELSE
    BEGIN TRY
        DECLARE @coordinator_id int;
        SELECT @coordinator_id = coordinator_id
        FROM Cooperation_Agreement
        WHERE agreement_id = @agreement_id;

        INSERT INTO Professor_Visit (partner_prof_id, host_faculty_id, coordinator_id, agreement_id, start_date, end_date, purpose, status)
        VALUES (@partner_prof_id, @host_faculty_id, @coordinator_id, @agreement_id, @start_date, @end_date, @purpose, 'Requested');

        PRINT 'Visit requested successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error requesting visit: ' + ERROR_MESSAGE();
    END CATCH
END;
go

CREATE FUNCTION ViewVisitAgenda (@visit_id int)
RETURNS TABLE
AS
RETURN (
    SELECT TOP (100) PERCENT
        seq_no AS Sequence_Number,
        activity_type AS Activity_Type,
        title AS Title,
        date_time AS Date_Time,
        location AS Location,
        audience AS Audience
    FROM Agenda_Item
    WHERE visit_id = @visit_id
    ORDER BY seq_no ASC
);

go

CREATE PROCEDURE JoinResearchProject
    @partner_prof_id int,
    @project_id int,
    @role varchar(50)
AS
BEGIN
    IF @partner_prof_id IS NULL OR @project_id IS NULL OR @role IS NULL
        PRINT 'Partner Professor ID, Project ID, and Role cannot be null.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Partner_Professor 
    WHERE person_id = @partner_prof_id)
        PRINT 'Partner professor does not exist.';
    ELSE IF NOT EXISTS (SELECT 1 
    FROM Research_Project 
    WHERE project_id = @project_id)
        PRINT 'Research project does not exist.';
    ELSE IF EXISTS (SELECT 1 
    FROM PP_Participates 
    WHERE partner_prof_id = @partner_prof_id AND project_id = @project_id)
        PRINT 'This partner professor is already participating in the project.';
    ELSE
    BEGIN TRY
        INSERT INTO PP_Participates (partner_prof_id, project_id, role)
        VALUES (@partner_prof_id, @project_id, @role);

        PRINT 'Partner professor successfully joined the research project.';
    END TRY
    BEGIN CATCH
        PRINT 'Error joining research project: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION ViewMyResearchProjects (@partner_prof_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        RP.title AS Project,
        PPP.role AS My_Role,
        RP.status AS Status,
        RA.name AS Research_Area,
        COUNT(DISTINCT RO.output_id) AS Number_Of_Outputs
    FROM PP_Participates PPP
    JOIN Research_Project RP 
    ON PPP.project_id = RP.project_id
    LEFT JOIN Project_Area PA 
    ON RP.project_id = PA.project_id
    LEFT JOIN Research_Area RA 
    ON PA.area_id = RA.area_id
    LEFT JOIN Research_Output RO 
    ON RP.project_id = RO.project_id
    WHERE PPP.partner_prof_id = @partner_prof_id
    GROUP BY RP.project_id, RP.title, PPP.role, RP.status, RA.name
);

go
CREATE FUNCTION ViewMyUniversityPrograms (@partner_prof_id int)
RETURNS TABLE
AS
RETURN (
    SELECT 
        PD.name AS Department,
        PProg.name AS Program,
        PProg.degree_level AS Degree_Level,
        F.name AS Field
    FROM Partner_Professor PP
    JOIN Partner_Department PD_Prof 
    ON PP.pdept_id = PD_Prof.pdept_id
    JOIN Partner_Department PD 
    ON PD_Prof.uni_id = PD.uni_id
    JOIN Partner_Program PProg 
    ON PD.pdept_id = PProg.pdept_id
    LEFT JOIN Partner_Program_Field PPF 
    ON PProg.pprog_id = PPF.pprog_id
    LEFT JOIN Field F 
    ON PPF.field_id = F.field_id
    WHERE PP.person_id = @partner_prof_id
);

go

-- Part 7 (Topic Provider Procedures) Done by Ahmed

-- 7.1
create procedure SubmitThesisTopic
	@provider_id int, 
	@title varchar(200), 
	@description varchar(1000),
	@app_open_date date, 
	@app_close_date date, 
	@capacity int, 
	@location_mode varchar(30), 
	@agreement_id int, 
	@expected_outcomes varchar(500), 
	@funding_info varchar(300), 
	@travel_info varchar(300), 
	@accommodation_info varchar(300), 
	@supervisor_id int, 
	@co_supervisor_id int
	as
	begin
	if @app_open_date >= @app_close_date
		begin
			print 'Error: The application open date must be before the application close date.';
			return;
		end
	if @capacity <= 0
		begin
			print 'Error: Capacity must be greater than zero.';
			return;
		end
	if @capacity is null
		begin
			print 'Error: Capacity cannot be null.';
			return;
		end	
	if @title is null or @title = ''
		begin
			print 'Error: Invalid value for title.';	
			return;
		end
	if @description is null or @description = ''
		begin
			print 'Error: Invalid value for description.';
			return;
		end
	if @location_mode is null or @location_mode = '' or (@location_mode not in ('Germany', 'Egypt', 'Hybrid', 'Online'))
		begin 
			print 'Error: Invalid value for location mode.';
			return;
		end
	if @expected_outcomes is null or @expected_outcomes = ''
		begin
			print 'Error: Invalid value for expected outcomes.';
			return;
		end
	if @funding_info is null or @funding_info = ''
		begin
			print 'Error: Invalid value for funding information.';
			return;
		end
	if @travel_info is null or @travel_info = ''
		begin
			print 'Error: Invalid value for travel information.';
			return;
		end
	if @accommodation_info is null or @accommodation_info = ''
		begin
			print 'Error: Invalid value for accommodation information.';
			return;
		end
	if not exists (
		select 1
		from topic_provider
		where person_id = @provider_id
	)
	begin
		print 'Error: Provider not found or not registered as a topic provider.';
		return;
	end
	if not exists (
		select 1
		from giu_academic
		where person_id = @supervisor_id
	)
	begin
		print 'Error: GIU supervisor not found.';
		return;
	end
	if @co_supervisor_id is not null and not exists (
		select 1
		from partner_professor
		where person_id = @co_supervisor_id
	)
	begin
		print 'Error: Partner co-supervisor not found.';
		return;
	end
	if @app_open_date is null		
		begin
			print 'Error: Application open date cannot be null.';
			return;
		end
	if @app_close_date is null
		begin
			print 'Error: Application close date cannot be null.';	
			return;
		end
	if @agreement_id is not null and not exists (
		select 1 
		from Cooperation_Agreement 
		where agreement_id = @agreement_id)
		begin
			print 'Error: Cooperation agreement not found.';
			return;
		end
	if @agreement_id is not null and not exists (
		select 1 
		from Cooperation_Agreement 
		where agreement_id = @agreement_id and status = 'Active')
		begin
			print 'Error: The specified cooperation agreement is not active.';
			return;
		end
	
	begin try
	declare @RepID int = null;
    if exists (
	select 1
	from Company_Rep 
	where person_id = @provider_id
	)
    begin
        set @RepID = @provider_id;
    end

    begin transaction;
        insert into Opportunity values (@title, @description, 'Thesis Topic','Open', @app_open_date, @app_close_date, @capacity, @location_mode, @agreement_id, @RepID);
        declare @NewOppID int = scope_identity();
        insert into Thesis_Topic values (@NewOppID, @expected_outcomes, @funding_info, @travel_info, @accommodation_info, @provider_id, @supervisor_id, @co_supervisor_id);
    
	commit transaction;
	print 'Thesis topic submitted successfully.';
	end try

	begin catch
		if @@trancount > 0
		begin
			rollback transaction;
		end
		print 'Error occurred while submitting thesis topic.';
	end catch
	end;
go

-- 7.2
create procedure AddThesisArea 
	@opp_id int, @area_id int
	as
	begin
		if exists (
			select 1 
			from Thesis_Area 
			where opp_id = @opp_id and area_id = @area_id)
			begin
				print 'Error: This research area is already associated with the thesis topic.';
			return;
			end
		if not exists (
			select 1 
			from Opportunity 
			where opp_id = @opp_id and type = 'Thesis Topic')
			begin
				print 'Error: The specified opportunity is not a thesis topic.';
			return;
			end
		if not exists (
			select 1 
			from Research_Area 
			where area_id = @area_id)
			begin
				print 'Error: The specified research area does not exist.';
			return;
			end
		
		begin try
		insert into Thesis_Area values (@opp_id, @area_id);
		print 'Research area added to thesis topic successfully.';
		end try
		
		begin catch
			print 'An error occured while adding the reasearch area to the thesis topic.'
		end catch
	end;
go

-- 7.3	
create procedure UpdateThesisTopic
	@opp_id int, @description varchar(1000), @capacity int, @app_close_date date
	as	
	begin
	if not exists (
			select 1 
			from Opportunity 
			where opp_id = @opp_id and type = 'Thesis Topic')
			begin
				print 'Error: The specified opportunity is not a thesis topic.';
			return;
			end
	if @capacity <= 0 
		begin
			print 'Error: Capacity must be greater than zero.';
			return;
		end
	if @app_close_date <= (
	select app_open_date 
	from Opportunity 
	where opp_id = @opp_id)
		begin
			print 'Error: Application close date must be after application open date.';
			return;
		end
	if @capacity is not null and @capacity < (
		select capacity - dbo.GetRemainingCapacity(@opp_id)
		from Opportunity
		where opp_id = @opp_id)
			begin
			print 'Error: New capacity cannot be less than the number of already accepted students.';
			return;
		end
	begin try
	update Opportunity 
		set 
		description = isnull(@description, description),
		capacity = isnull(@capacity, capacity),
		app_close_date = isnull(@app_close_date, app_close_date)
		where opp_id = @opp_id;
		print 'Thesis topic updated successfully.';
	end try
	
	begin catch
		print 'Error: An error occurred while updating the thesis topic.';
	end catch
	end;
go

-- 7.4 
create function ViewMySubmittedTopics(@provider_id int)
	returns table
	as
	return (
		select o.title as "Title", o.description as "Description", o.status as "Status", p1.full_name as "Supervised by", 
		case 
			when p2.full_name is null then 'No Co-Supervisor'
			else p2.full_name
		end 
		as "Co-Supervised by",
		(select count(*) 
		from Application a 
		where a.opp_id = o.opp_id)
		as "Number of Applications",
		(select count(*) 
		from Application a 
		where a.opp_id = o.opp_id and a.status = 'Accepted')
		as "Number of Accepted Applications"
		
		from Opportunity o
		inner join Thesis_Topic tt
		on o.opp_id = tt.opp_id
		inner join Person p1
		on tt.supervisor_id = p1.person_id
		left join Person p2
		on tt.co_supervisor_id = p2.person_id
		where tt.provider_id = @provider_id
	);
go

-- 7.5
create function ViewTopicsWithoutCoSupervisor()
	returns table
	as 
	return (
		select o.title as "Title", o.description as "Description", p1.full_name as "Topic Provider", p2.full_name as "Supervisor",
		(select string_agg(r.name, ', ') 
		from Thesis_Area t
		inner join Research_Area r
		on t.area_id = r.area_id 
		where t.opp_id = o.opp_id) 
		as "Research Areas"
		from Opportunity o
		inner join Thesis_Topic tt
		on o.opp_id = tt.opp_id
		inner join Person p1
		on tt.provider_id = p1.person_id
		inner join Person p2
		on tt.supervisor_id = p2.person_id
		where tt.co_supervisor_id is null and o.type = 'Thesis Topic'
	);
go

-- Part 8 (Student Procedures) Done by Ahmed	
-- 8.1
create function ViewMyProfile(@person_id int)
	returns Table
	as
	return
	(	
		select s.student_no as "Student Number" , pr.full_name as "Full Name", pr.email as "Email", pr.phone as "Phone Number", s.current_semester as "Current Semester", s.gpa as "GPA", s.language_level as "Language Level", s.cv as "CV", p.name as "Program Name", d.name as "Department Name",f.name as "Faculty Name"  
		from Person pr
		inner join Student s
		on pr.person_id = s.person_id
		inner join Program p
		on s.program_id = p.program_id
		inner join Department d
		on p.dept_id = d.dept_id
		inner join Faculty f
		on d.faculty_id = f.faculty_id
		where s.person_id = @person_id
	);
go

-- 8.2 
create function ViewMyFields(@person_id int)
	returns Table
	as
	return
	(
		select f.name as "Field Name", f.description as "Description"
		from Student s
		inner join Program_Field pf
		on s.program_id = pf.program_id
		inner join Field f
		on pf.field_id = f.field_id
		where s.person_id = @person_id
	);
go

-- 8.3
create procedure UpdateStudentProfile
	@person_id int, @current_semester int, @language_level varchar(30), @cv varchar(300)
	as
	begin
	if @current_semester <= 0 
		begin
			print 'Error: Current semester must be greater than zero.';
			return;
		end
	if not exists (
		select 1 
		from Student 
		where person_id = @person_id)
		begin
			print 'Error: Student profile not found.';
			return;
		end
	if @language_level = ''
		begin
			print 'Error: Language level cannot be empty.';
			return;
		end
	if @cv = ''
		begin
			print 'Error: CV cannot be empty.';
			return;
		end
	begin try
	update Student 
		set current_semester = isnull (@current_semester, current_semester), 
			language_level = isnull (@language_level, language_level), 
			cv = isnull (@cv, cv)
		where person_id = @person_id;
		print 'Student profile updated successfully.';
	end try

	begin catch
		print 'An error occurred while updating the student profile.';
	end catch
	end;
go

-- 8.4
create procedure AddInterest
	@person_id int, @interest varchar(100)
	as 
	begin
	if @interest is null or @interest = ''
		begin
			print 'Error: Invalid value for interest.';
			return;
		end
	if not exists (
			select 1 
		from Student 
		where person_id = @person_id)
		begin
			print 'Error: Student profile not found.';
			return;
		end
	if exists (
		select 1 
		from Student_Interest 
		where person_id = @person_id and interest = @interest)
		begin
			print 'This interest is already associated with the student.';
			return;
		end
	begin try
	insert into Student_Interest values (@person_id, @interest);
	print 'Interest added to student profile successfully.';
	
	end try
	begin catch
		print 'An error occurred while adding the interest to the student profile.';
	end catch
	end;
go

-- 8.5
create procedure AddCompletedCourse
	@student_id int, @course_id int
	as
	begin
	if not exists (
		select 1 
		from Student 
		where person_id = @student_id)
		begin
			print 'Student profile not found.';
			return;
		end
	if not exists (
		select 1 
		from Course 
		where course_id = @course_id)
		begin
			print 'Course not found.';
			return;
		end
	if exists ( 
		select 1
		from Completed_Course
		where student_id = @student_id and course_id = @course_id)
		begin
			print 'This course is already associated with the student.';
			return;
		end
	begin try
	insert into Completed_Course values (@student_id, @course_id);
	print 'Course added to student profile successfully.';
	end try
	
	begin catch
	print 'An error occurred while adding the course to the student profile.';
	end catch
	end;
go

-- 8.6
create procedure AddMySkill
	@student_id int, @skill_id int
	as 
	begin
	if not exists (
		select 1 
		from Skill 
		where skill_id = @skill_id)
		begin
			print 'Error: Skill not found.';
			return;
		end
	if not exists (
			select 1 
		from Student 
		where person_id = @student_id)
		begin
			print 'Error: Student profile not found.';
			return;
		end
	if exists (
		select 1 
		from Student_Skill 
		where student_id = @student_id and skill_id = @skill_id)
		begin
			print 'Error: This skill is already associated with the student.';
			return;
		end
	begin try
	insert into Student_Skill values (@student_id, @skill_id);
	print 'Skill added to student profile successfully.';
	end try
	
	begin catch
	print 'An error occurred while adding the skill to the student profile.';
	end catch
	end;
go

-- 8.7 
create function BrowseOpenOpportunities(@type varchar (30))
	returns table 
	as
	return(
			select o.title as "Title", o.description as "Description", o.location_mode as "Location Mode", o.app_close_date as "Closing Date", dbo.GetRemainingCapacity(o.opp_id) as "Remaining Seats"
			from Opportunity o
			where o.type = @type and o.status = 'Open'
	);
go

-- 8.8 
create function ViewOpportunityDetails(@opp_id int)
	returns table
	as
	return (
		select o.title as "Title", o.description as "Description", o.type,o.location_mode as "Location Mode", o.app_open_date as "Application Open Date", o.app_close_date as "Application Close Date", o.capacity as "Capacity",
		case o.type
    when 'Thesis Topic' then 
        'Outcomes: ' + tt.expected_outcomes + 
        'Funding: ' + tt.funding_info + 
        'Travel: ' + tt.travel_info + 
        'Accommodation: ' + tt.accommodation_info + 
        'Supervisor: ' + sup.full_name + 
        'Co-Supervisor: ' + isnull(cosup.full_name, 'None')
    when 'Short Program' then 
        'Duration: ' + sp.duration + 
        'Location: ' + sp.location + 
        'Hosting: ' + sp.hosting_arrangements + 
        'Host University: ' + sp_host.name
    when 'Mobility Program' then 
        'Mobility Type: ' + mp.mobility_type + 
        'Duration: ' + mp.duration + 
        'Sending University: ' + mp_send.name + 
        'Host University: ' + mp_host.name
	end as "Subtype Details",
		(select string_agg(f.name, ', ')
		from Opp_Field of1
		inner join Field f
		on of1.field_id = f.field_id
		where of1.opp_id = @opp_id)
		as "Related Fields",
		(select string_agg(p.name, ', ')
		from Opp_Eligible_Program op
		inner join Program p
		on op.program_id = p.program_id
		where op.opp_id = @opp_id)
		as "Related Programs",
		(select string_agg(c.title, ', ') 
		from Opp_Prereq_Course opc
		inner join Course c
		on opc.course_id = c.course_id
		where opc.opp_id = @opp_id) 
		as "Required Courses",
		(select string_agg(s.name, ', ') 
		from Opp_Skill os
		inner join Skill s
		on os.skill_id = s.skill_id
		where os.opp_id = @opp_id) 
		as "Required Skills",
		(select string_agg(language_req, ', ')
		from Opp_Language_Req
		where opp_id = @opp_id)
		as "Language Requirements"
		from Opportunity o
		left join Thesis_Topic tt 
		on o.opp_id = tt.opp_id
		left join Person sup 
		on tt.supervisor_id = sup.person_id
		left join Person cosup 
		on tt.co_supervisor_id = cosup.person_id
		left join Short_Program sp 
		on o.opp_id = sp.opp_id
		left join University sp_host on 
		sp.host_uni_id = sp_host.uni_id
		left join Mobility_Program mp on 
		o.opp_id = mp.opp_id
		left join University mp_send 
		on mp.sending_uni_id = mp_send.uni_id
		left join University mp_host 
		on mp.host_uni_id = mp_host.uni_id
		where o.opp_id = @opp_id
	);
go
-- 8.9 
create function ViewEligibleOpportunities(@student_id int)
	returns table
	as
	return (
		select o.title as "Title", o.description as "Description", o.location_mode as "Location Mode", o.app_close_date as "Closing Date"
		from Opportunity o
		where o.status = 'Open' and dbo.CheckEligibility(@student_id, o.opp_id) =1 
		
	);
go

-- 8.10
create function ViewMissingRequirements(@student_id int, @opp_id int)
	returns table
	as
	return (
		select 'Course' as "Requirement Type", c.title as "Requirement Name"
		from Course c
		where c.course_id in (
			select opc.course_id
			from Opp_Prereq_Course opc
			where opc.opp_id = @opp_id
			except
			select cc.course_id
			from Completed_Course cc
			where cc.student_id = @student_id
		)
		union 
		select 'Skill' as "Requirement Type", s.name as "Requirement Name"	
		from Skill s
		where s.skill_id in (
			select os.skill_id
			from Opp_Skill os
			where os.opp_id = @opp_id 
			except
			select ss.skill_id
			from Student_Skill ss
			where ss.student_id = @student_id
		)
	);
go

-- 8.11 
create function RecommendThesisTopics(@student_id int)
	returns table
	as 
	return (
	select top (100) percent o.title as "Topic Title", o.description as Description, tt.expected_outcomes as "Expected Outcomes",
	(select count(*) 
	from Opp_Field of1
	inner join  Program_Field pf1
	on pf1.field_id = of1.field_id
	inner join Program p
	on pf1.program_id = p.program_id
	inner join Student s1
	on s1.program_id = p.program_id
	where person_id = @student_id and of1.opp_id = o.opp_id )
	+
	(select count(*) 
	from Opp_Skill os1
	inner join Student_Skill ss1
	on os1.skill_id = ss1.skill_id
	inner join student s2
	on s2.person_id = ss1.student_id
	where person_id = @student_id and os1.opp_id = o.opp_id)
	as "Matched Requirements Count"
	
	from Opportunity o
	inner join Thesis_Topic tt
	on o.opp_id = tt.opp_id
	where o.status = 'Open'
	order by "Matched Requirements Count" Desc
	);
go

-- 8.12 
create procedure SubmitApplication
	@student_id int, @opp_id int, @info varchar(500)
	as
	begin
	if not exists (
		select 1 
		from Student 
		where person_id = @student_id)
		begin
			print 'Error: Student profile not found.';
			return;
		end
	if not exists (
		select 1 
		from Opportunity 
		where opp_id = @opp_id and status = 'Open')
		begin
			print 'Error: Opportunity not found or is not open for applications.';
			return;
		end
						
	if dbo.CheckEligibility(@student_id, @opp_id) = 0
		begin
			print 'Error: Student is not eligible for this opportunity.';
			return;
		end
	if exists (
		select 1 
		from Opportunity
		where opp_id = @opp_id and cast(getdate()as date) > app_close_date)
		begin
			print 'Error: The application end date has been reached.'
			return;
		end
	if exists (
		select 1 
		from Opportunity
		where opp_id = @opp_id and cast(getdate()as date) < app_open_date)
		begin
			print 'Error: The application start date is not yet reached.'
			return;
		end
	
	if dbo.GetRemainingCapacity(@opp_id) <= 0
		begin
			print 'Error: Maximum capacity reached.'
			return;
		end
	if exists (
		select 1 
		from Application 
		where student_id = @student_id and opp_id = @opp_id)
		begin
			print 'Error: You have already submitted an application for this opportunity.';
			return;
		end
	if exists (
		select 1
		from Opportunity
		where opp_id = @opp_id and type = 'Thesis Topic')
		and dbo.HasAcceptedThesis(@student_id) = 1
		begin
			print 'Error: You have already one accepted Thesis topic.'
			return;
		end

	begin try
	insert into Application (app_date, info, student_id, opp_id) values (getdate(), @info, @student_id, @opp_id);
	print 'Application submitted successfully.';
	end try
	
	begin catch
	print 'An error occurred while submitting the application.';
	end catch
	end;
go

-- 8.13
create procedure UploadApplicationDocument
	@app_id int, @doc_type varchar(50), @file_ref varchar(300)
	as
	begin
	if not exists (
		select 1 
		from Application 
		where app_id = @app_id)
		begin
			print 'Error: Application not found.';
			return;
		end
	
	if exists (
		select 1 
		from Application_Document 
		where app_id = @app_id and doc_type = @doc_type)
		begin
			print 'Error: A document of this type has already been uploaded for this application.';
			return;
		end		 

	if @file_ref is null or @file_ref = ''
		begin
			print 'Error: Invalid file reference.';
			return;
		end
	
	if @doc_type is null
		begin
			print 'Error: Document type cannot be null.';
			return;
		end
	if exists (
		select 1
		from Application
		where status <> 'Pending' and app_id = @app_id)
		begin
			print 'Error: The application has already been accepted or rejected.'
			return;
		end
	if @doc_type not in ('CV', 'Transcript', 'Motivation Letter', 'Recommendation Letter')
		begin
			print 'Error: Invalid document type. Valid types are: CV, Transcript, Motivation Letter, Recommendation Letter.';
			return;
		end
	begin try
		insert into Application_Document values (@app_id, @doc_type, @file_ref, getdate());
		print 'Document uploaded successfully.';
	end try
	begin catch
		print 'An error occurred while uploading the document.';
	end catch
	
	end;
go

-- 8.14
create procedure WithdrawApplication
	@app_id int, @student_id int
	as
	begin
	if not exists (
		select 1 
		from Application 
		where app_id = @app_id and student_id = @student_id)
		begin
			print 'Error: Application not found or does not belong to the specified student.';
			return;
		end
	if exists (
		select 1 
		from Application 
		where app_id = @app_id and (status = 'Accepted' or status = 'Rejected'))
		begin
			print 'Error: Application cannot be updated as it is not in pending status.';
			return;
		end
	begin try
		delete 
		from Application 
		where app_id = @app_id and student_id = @student_id;
		print 'Application withdrawn successfully.'
	end try
	
	begin catch
		print 'An error occurred while withdrawing the application.';
	end catch
	end;
go

-- 8.15
create function ViewMyApplications(@student_id int)
	returns table
	as
	return (
		select o.title as "Opportunity Title", o.type as "Opportunity Type", a.app_date as "Application Date", a.status as "Application Status", a.decision_date as "Decision Date",
		case
		when a.status <> 'Pending' then 'Application closed.' 
		when i.interview_id is null then 'Interview not scheduled yet.' 
			else 
			cast (i.date as varchar (20)) 
		end as "Next Interview date"
		from Application a
		inner join Opportunity o
		on a.opp_id = o.opp_id
		left join Interview i
		on a.app_id = i.app_id and i.date >= cast ( getdate() as date)
		where a.student_id = @student_id 
);
go

-- 8.16
create function ViewMyInterviews(@student_id int)
	returns table
	as 
	return(
	select o.title as "Opportunity Title", i.date as "Interview Date", i.time as "Interview Time", i.location_mode as "Location Mode", i.outcome as "Interview Outcome"
	from opportunity o
	inner join Application a
	on a.opp_id = o.opp_id
	inner join Interview i
	on i.app_id = a.app_id
	where a.student_id = @student_id
	);
go

-- 8.17
create function HasAcceptedThesis (@student_id int)
	returns bit
	as 
	begin
	if exists (
	select 1
	from Thesis_Topic tt
	inner join Application a
	on tt.opp_id = a.opp_id
	where a.status = 'Accepted' and a.student_id = @student_id )
	return 1;
	return 0;
	end;
go

-- 8.18
create function ViewMyParticipations(@student_id int)
	returns table
	as 
	return (
	select o.title as "Opportunity Title", o.description as Description, o.type as Type, p.start_date as "Start Date", p.end_date as "End Date", p.status as Status
	from Student s
	inner join Application a
	on s.person_id = a.student_id
	inner join Opportunity o
	on a.opp_id = o.opp_id
	inner join Participation p
	on a.app_id = p.app_id
	where s.person_id = @student_id and o.type <> 'Thesis Topic'
	);

go
-- 8.19
create function ViewMyCourseEquivalencies (@student_id int)
	returns table
	as
	return (
	select ce.host_course_title as "Host Course Title", ce.host_credits as "Host Course Credits", c.title as "GIU Course Title", ce.transferred_credits as "Transferred Credits", ce.approval_status as "Approval Status"
	from student s
	inner join Application a
	on s.person_id = a.student_id
	inner join Participation p
	on a.app_id = p.app_id
	inner join Mobility m
	on p.part_id = m.part_id
	inner join Course_Equivalency ce
	on m.part_id = ce.part_id
	inner join Course c
	on ce.giu_course_id = c.course_id
	where s.person_id = @student_id
	);
go

-- 8.20
create function BrowseFunding (@type varchar(30))
	returns table
	as 
	return (
	select top(100) percent name as Name, agency as "Funding Agency", amount as Amount, deadline as Deadline, eligibility_conditions as "Eligibility Conditions"
	from Funding_Opportunity
	where type = @type and status = 'Open'
	order by deadline 
	);
go

-- 8.21
create procedure NotifyApplicationStatus
    @app_id int
as
begin
    if @app_id is null or not exists (
	select 1 from Application 
	where app_id = @app_id)
    begin
        print 'Error: Application not found.';
        return;
    end

    declare @student_id int;
    declare @status varchar(50);
    declare @opp_title varchar(255);
    declare @message varchar(500);

    select 
        @student_id = a.student_id,
        @status = a.status,
        @opp_title = o.title
    from Application a
    inner join Opportunity o
        on a.opp_id = o.opp_id
    where a.app_id = @app_id;

    if @status is null or @status = 'Pending'
    begin
        print 'No notification sent: Application status is still Pending.'
        return;
    end

    set @message = 'The status of your application for ' + @opp_title + ' has changed to: ' + @status + '.';

    exec dbo.SendNotification @student_id, @message, 'Status Change', 'High'

    print @message
end;
go

-- Start of Mahmoud's part --

--2.1--
CREATE PROC CreateMobilityAgreement
@title varchar(200),
@scope varchar(500),
@start_date date,
@end_date date,
@partner_uni_id int,
@coordinator_id int,
@exchange_terms varchar(500),
@double_degree_terms varchar(500), 
@seat_quota int, 
@tuition_arrangement varchar(300)
AS
BEGIN 

    BEGIN TRY

        IF @start_date IS NULL OR @end_date IS NULL
        OR @end_date <= @start_date
        BEGIN
	        PRINT 'Invalid dates';
	        RETURN;
        END

        IF @seat_quota IS NULL OR @seat_quota <= 0
        BEGIN
	        PRINT 'Invalid: seat quota must be greater than 0';
	        RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM Partner_University
        WHERE uni_id = @partner_uni_id
            )
        BEGIN
	        PRINT 'Partner university does not exist';
	        RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM GIU_Academic
        WHERE person_id = @coordinator_id
            )
        BEGIN
	        PRINT 'Academic Coordinator does not exist';
	        RETURN;
        END

        DECLARE @new_agreement_id INT;

        BEGIN TRANSACTION;

        INSERT INTO Cooperation_Agreement
            (title, scope, start_date, end_date, status,
             partner_uni_id, coordinator_id)
            VALUES
            (@title, @scope, @start_date, @end_date, 'Active',
             @partner_uni_id, @coordinator_id);


        SET @new_agreement_id = SCOPE_IDENTITY();

        INSERT INTO Mobility_Agreement
            (agreement_id, exchange_terms, double_degree_terms, seat_quota, tuition_arrangement)
            VALUES
            (@new_agreement_id, @exchange_terms, @double_degree_terms, @seat_quota, @tuition_arrangement);

        COMMIT TRANSACTION;

        PRINT 'Mobility Agreement created successfully';

        SELECT @new_agreement_id AS agreement_id;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        
        PRINT 'Error: ' + ERROR_MESSAGE();
            
    END CATCH

END;

--2.2--
GO 

CREATE PROC CreateResearchAgreement
@title varchar(200),
@scope varchar(500),
@start_date date,
@end_date date,
@partner_uni_id int,
@coordinator_id int,
@ip_terms varchar(500),
@funding_framework varchar(300)
AS
BEGIN 

    BEGIN TRY

        IF @start_date IS NULL OR @end_date IS NULL
         OR @end_date <= @start_date
        BEGIN
	        PRINT 'Invalid dates';
	        RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM Partner_University
        WHERE uni_id = @partner_uni_id
            )
        BEGIN
                PRINT 'Partner university does not exist';
                RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM GIU_Academic
        WHERE person_id = @coordinator_id
            )
        BEGIN
                PRINT 'Academic Coordinator does not exist';
                RETURN;
        END

        DECLARE @new_agreement_id INT;

        BEGIN TRANSACTION;

        INSERT INTO Cooperation_Agreement
            (title, scope, start_date, end_date, status,
             partner_uni_id, coordinator_id)
            VALUES
            (@title, @scope, @start_date, @end_date, 'Active',
             @partner_uni_id, @coordinator_id);


        SET @new_agreement_id = SCOPE_IDENTITY();

        INSERT INTO Research_Agreement
            (agreement_id, ip_terms, funding_framework)
            VALUES
            (@new_agreement_id, @ip_terms, @funding_framework);

        COMMIT TRANSACTION;

        PRINT 'Research Agreement created successfully';

        SELECT @new_agreement_id AS agreement_id;

        END TRY

        BEGIN CATCH
            IF @@TRANCOUNT > 0
            BEGIN
                ROLLBACK TRANSACTION;
            END
            
            PRINT 'Error: ' + ERROR_MESSAGE();
                
        END CATCH

 END;

--2.3--

GO

CREATE PROC CreateGeneralMoU
@title varchar(200),
@scope varchar(500),
@start_date date,
@end_date date,
@partner_uni_id int,
@coordinator_id int,
@intent varchar(500),
@collab_scope varchar(500),
@renewal_terms varchar(300)

AS
BEGIN

    BEGIN TRY

        IF @start_date IS NULL OR @end_date IS NULL
        OR @end_date <= @start_date
        BEGIN
            PRINT 'Invalid dates';
            RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM Partner_University
        WHERE uni_id = @partner_uni_id
            )
            BEGIN
                PRINT 'Partner university does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM GIU_Academic
        WHERE person_id = @coordinator_id
            )
            BEGIN
                PRINT 'Academic Coordinator does not exist';
                RETURN;
            END

        DECLARE @new_agreement_id INT;

        BEGIN TRANSACTION;

        INSERT INTO Cooperation_Agreement
            (title, scope, start_date, end_date, status,
             partner_uni_id, coordinator_id)
            VALUES
            (@title, @scope, @start_date, @end_date, 'Active',
             @partner_uni_id, @coordinator_id);

        SET @new_agreement_id = SCOPE_IDENTITY();

        INSERT INTO General_MoU
            (agreement_id, intent, collab_scope, renewal_terms)
            VALUES
            (@new_agreement_id, @intent, @collab_scope, @renewal_terms);

        COMMIT TRANSACTION;

        PRINT 'General MoU created successfully';

        SELECT @new_agreement_id AS agreement_id;

        END TRY

        BEGIN CATCH
            IF @@TRANCOUNT > 0
            BEGIN
                ROLLBACK TRANSACTION;
            END
            
            PRINT 'Error: ' + ERROR_MESSAGE();
                
        END CATCH
END;

--2.4--
GO

CREATE PROC AddAgreementProgram
@agreement_id int,
@program_id int
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Mobility_Agreement
        WHERE agreement_id = @agreement_id
            )
            BEGIN
                PRINT 'Mobility Agreement does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM Program
        WHERE program_id = @program_id
            )
            BEGIN
                PRINT 'GIU Program does not exist';
                RETURN;
            END

        IF EXISTS (
        SELECT 1
        FROM Mob_Agr_Program
        WHERE agreement_id = @agreement_id 
            AND program_id = @program_id
            )
            BEGIN
                PRINT 'This program is already added to the agreement';
                RETURN;
            END

        INSERT INTO Mob_Agr_Program
        (agreement_id, program_id)
        VALUES
        (@agreement_id, @program_id);

        PRINT 'GIU Program added to Mobility Agreement successfully';

     END TRY

     BEGIN CATCH
       PRINT 'Error: ' + ERROR_MESSAGE();
     END CATCH
END;

--2.5--
GO

CREATE PROC AddAgreementSemester
@agreement_id int,
@semester varchar(30)
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Mobility_Agreement
        WHERE agreement_id = @agreement_id
            )
            BEGIN
                PRINT 'Mobility Agreement does not exist';
                RETURN;
            END

        IF EXISTS (
        SELECT 1
        FROM Mob_Agr_Semester
        WHERE agreement_id = @agreement_id AND semester = @semester
            )
            BEGIN
                PRINT 'This semester is already added to the agreement';
                RETURN;
            END

        INSERT INTO Mob_Agr_Semester
        (agreement_id, semester)
        VALUES
        (@agreement_id, @semester);

        PRINT 'Semester added to Mobility Agreement successfully';

        END TRY

        BEGIN CATCH
            PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH

END;

--2.6--
GO

CREATE PROC AddAgreementResearchArea
@agreement_id int,
@area_id int
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Research_Agreement
        WHERE agreement_id = @agreement_id
            )
            BEGIN
                PRINT 'Research Agreement does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM Research_Area
        WHERE area_id = @area_id
            )
            BEGIN
                PRINT 'Research Area does not exist';
                RETURN;
            END

        IF EXISTS (
        SELECT 1
        FROM Res_Agr_Area
        WHERE agreement_id = @agreement_id AND area_id = @area_id
            )
            BEGIN
                PRINT 'This research area is already added to the agreement';
                RETURN;
            END

        INSERT INTO Res_Agr_Area
        (agreement_id, area_id)
        VALUES
        (@agreement_id, @area_id);

        PRINT 'Research Area added to Research Agreement successfully';

        END TRY

        BEGIN CATCH
            PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH

END;

--2.7--
GO

CREATE PROC UpdateAgreementStatus
@agreement_id int,
@status varchar(30)
AS
BEGIN
   
   BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Cooperation_Agreement
        WHERE agreement_id = @agreement_id
            )
            BEGIN
                PRINT 'Cooperation Agreement does not exist';
                RETURN;
            END
    
        UPDATE Cooperation_Agreement
        SET status = @status
        WHERE agreement_id = @agreement_id;

        PRINT 'Agreement status updated successfully';

   END TRY

        BEGIN CATCH
            PRINT 'Error: ' + ERROR_MESSAGE();
        END CATCH
END;

--2.8--
GO

CREATE FUNCTION GetExpiringAgreements
(
    @days_ahead int
)
RETURNS TABLE
AS
RETURN
(
   SELECT
   CA.agreement_id,
   CA.title AS agreement,
   U.name AS partner_university,

   CASE 
    WHEN MA.agreement_id IS NOT NULL 
        THEN 'Mobility Agreement'
    WHEN RA.agreement_id IS NOT NULL 
        THEN 'Research Agreement'
    WHEN GM.agreement_id IS NOT NULL 
        THEN 'General MoU'
    ELSE 'Unknown'

    END AS agreement_type,

    CA.end_date,

    DATEDIFF(DAY, CAST(GETDATE() AS DATE), CA.end_date) AS days_remaining
    FROM Cooperation_Agreement CA

    INNER JOIN Partner_University PU 
        ON CA.partner_uni_id = PU.uni_id

    INNER JOIN University U
        ON PU.uni_id = U.uni_id

    LEFT JOIN Mobility_Agreement MA
        ON CA.agreement_id = MA.agreement_id

    LEFT JOIN Research_Agreement RA
        ON CA.agreement_id = RA.agreement_id

    LEFT JOIN General_MoU GM
        ON CA.agreement_id = GM.agreement_id
    
    WHERE CA.end_date >= CAST(GETDATE() AS DATE)
    AND CA.end_date <= DATEADD(DAY, @days_ahead, CAST(GETDATE() AS DATE))
    AND @days_ahead >= 0
);

--2.9--
GO

CREATE FUNCTION ViewPartnerHistory
(
@partner_uni_id int
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        CA.agreement_id,
        CASE 
            WHEN MA.agreement_id IS NOT NULL 
                THEN 'Mobility Agreement'
            WHEN RA.agreement_id IS NOT NULL 
                THEN 'Research Agreement'
            WHEN GM.agreement_id IS NOT NULL 
                THEN 'General MoU'
            ELSE 'Unknown'
        END AS record_type,

        CA.title,
        CA.start_date,
        CA.end_date,
        CA.status

    FROM Cooperation_Agreement CA

    LEFT JOIN Mobility_Agreement MA 
        ON CA.agreement_id = MA.agreement_id
    LEFT JOIN Research_Agreement RA 
        ON CA.agreement_id = RA.agreement_id
    LEFT JOIN General_MoU GM 
        ON CA.agreement_id = GM.agreement_id
        
    WHERE CA.partner_uni_id = @partner_uni_id

    UNION ALL

    SELECT 
        O.agreement_id,
        'Opportunity - ' + O.type AS record_type,
        O.title,
        O.app_open_date AS start_date,
        O.app_close_date AS end_date,
        O.status

        FROM Opportunity O

        INNER JOIN Cooperation_Agreement CA 
            ON O.agreement_id = CA.agreement_id

        WHERE CA.partner_uni_id = @partner_uni_id

    UNION ALL

    SELECT 
        PV.agreement_id,
        'Professor Visit' AS record_type,
        PV.purpose AS title,
        PV.start_date,
        PV.end_date,
        PV.status

        FROM Professor_Visit PV

        INNER JOIN Cooperation_Agreement CA 
            ON PV.agreement_id = CA.agreement_id

        WHERE CA.partner_uni_id = @partner_uni_id
        
    UNION ALL

    SELECT 
        RA.agreement_id,
        'Research Project' AS record_type,
        RP.title,
        RP.start_date,
        RP.end_date,
        RP.status

        FROM Research_Project RP

        INNER JOIN Research_Agreement RA 
            ON RP.res_agreement_id = RA.agreement_id

        INNER JOIN Cooperation_Agreement CA 
            ON RA.agreement_id = CA.agreement_id
            
        WHERE CA.partner_uni_id = @partner_uni_id
);

--2.10--
GO

CREATE FUNCTION GetAgreementSeatUsage
(
    @agreement_id int
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @seat_quota INT;
    DECLARE @accepted_students INT;
    DECLARE @percentage DECIMAL(5,2);

    SELECT @seat_quota = seat_quota
    FROM Mobility_Agreement
    WHERE agreement_id = @agreement_id;

    IF @seat_quota IS NULL OR @seat_quota <= 0
    BEGIN
        RETURN NULL; 
    END

    SELECT @accepted_students = COUNT(DISTINCT A.student_id)
    FROM Opportunity O

    INNER JOIN Mobility_Program MP 
        ON O.opp_id = MP.opp_id

    INNER JOIN Application A 
        ON O.opp_id = A.opp_id

    WHERE O.agreement_id = @agreement_id
    AND A.status = 'Accepted';

    SET @percentage = CAST((@accepted_students * 100.0) / @seat_quota AS DECIMAL(5,2));

    RETURN @percentage;

END;

--2.11--
GO

CREATE PROC ScheduleProfessorVisit
@partner_prof_id int,
@host_faculty_id int,
@coordinator_id int,
@agreement_id int,
@start_date date,
@end_date date,
@purpose varchar(300),
@travel_arr varchar(300),
@accommodation_arr varchar(300)
AS
BEGIN

    BEGIN TRY

        IF @start_date IS NULL OR @end_date IS NULL
        OR @end_date <= @start_date
        BEGIN
            PRINT 'Invalid dates';
            RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM Partner_Professor
        WHERE person_id = @partner_prof_id
            )
            BEGIN
                PRINT 'Partner Professor does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM Faculty
        WHERE faculty_id = @host_faculty_id
            )
            BEGIN
                PRINT 'GIU Faculty does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM GIU_Academic
        WHERE person_id = @coordinator_id
            )
            BEGIN
                PRINT 'GIU Academic Coordinator does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM Cooperation_Agreement
        WHERE agreement_id = @agreement_id
            )
            BEGIN
                PRINT 'Cooperation Agreement does not exist';
                RETURN;
            END

        DECLARE @new_visit_id int;


        INSERT INTO Professor_Visit
        (partner_prof_id, host_faculty_id, coordinator_id, agreement_id,
         start_date, end_date, purpose, travel_arr, accommodation_arr,status,
         follow_up_report)
        VALUES
        (@partner_prof_id, @host_faculty_id, @coordinator_id, @agreement_id,
         @start_date, @end_date, @purpose, @travel_arr, @accommodation_arr,'Active', NULL);

         SET @new_visit_id = SCOPE_IDENTITY();

         PRINT 'Professor Visit scheduled successfully';

         SELECT @new_visit_id AS visit_id;

         END TRY

         BEGIN CATCH
            PRINT 'Error: ' + ERROR_MESSAGE();
         END CATCH

END;

--2.12--
GO

CREATE PROC AddAgendaItem
@visit_id int,
@activity_type varchar(30),
@title varchar(200),
@date_time datetime,
@location varchar(100),
@audience varchar(100)
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Professor_Visit
        WHERE visit_id = @visit_id
            )
            BEGIN
                PRINT 'Professor Visit does not exist';
                RETURN;
            END

        DECLARE @new_seq_no int;

        BEGIN TRANSACTION;

        SELECT @new_seq_no = ISNULL(MAX(seq_no), 0) + 1
        FROM Agenda_Item WITH (UPDLOCK, HOLDLOCK)
        WHERE visit_id = @visit_id;

        INSERT INTO Agenda_Item
        (visit_id, seq_no, activity_type, title, date_time, location, audience)
        VALUES
        (@visit_id, @new_seq_no,activity_type, @title, @date_time, @location, @audience);

        COMMIT TRANSACTION;
        PRINT 'Agenda Item added successfully. New Sequence Number: '
        +CAST(@new_seq_no AS VARCHAR(10));

        SELECT @new_seq_no AS seq_no;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH
END;

--2.13--
GO

CREATE PROC NotifyVisitAgenda
@visit_id int
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Professor_Visit
        WHERE visit_id = @visit_id
            )
            BEGIN
                PRINT 'Professor Visit does not exist';
                RETURN;
            END

        IF NOT EXISTS (
        SELECT 1
        FROM Agenda_Item
        WHERE visit_id = @visit_id
            )
            BEGIN
                PRINT 'No agenda items found for this visit';
                RETURN;
            END

        DECLARE @coordinator_id int;
        DECLARE @partner_prof_id int;
        DECLARE @message varchar(500);

        SELECT 
        @coordinator_id = coordinator_id,
        @partner_prof_id = partner_prof_id

        FROM Professor_Visit
        WHERE visit_id = @visit_id;

        SET @message = 'Agenda for professor visit' 
                      + CAST(@visit_id AS VARCHAR(10)) 
                      + 'is now available.';

        INSERT INTO Notification 
        (message, [timestamp], category, urgency, read_status, recipient_id)
        VALUES
        (@message, GETDATE(), 'Visit Agenda', 'Normal', 0, @partner_prof_id),
        (@message, GETDATE(), 'Visit Agenda', 'Normal', 0, @coordinator_id);

        PRINT 'Notifications sent to Partner Professor and GIU Academic Coordinator successfully';

        SELECT @message AS notification_message;

    END TRY

    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH

END;

--2.14--
GO

CREATE PROC UpdateVisitStatus
@visit_id int,
@status varchar(30)
AS
BEGIN

    BEGIN TRY

        IF @status IS NULL OR @status = ''
        BEGIN
            PRINT 'Invalid visit status';
            RETURN;
        END

        IF NOT EXISTS (
        SELECT 1
        FROM Professor_Visit
        WHERE visit_id = @visit_id
            )
            BEGIN
                PRINT 'Professor Visit does not exist';
                RETURN;
            END

        UPDATE Professor_Visit
        SET status = @status
        WHERE visit_id = @visit_id;

        PRINT 'Professor Visit status updated successfully';

   END TRY

   BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
   END CATCH

END;

--2.15--
GO

CREATE PROC CompleteProfessorVisit
@visit_id int,
@follow_up_report varchar(1000)
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Professor_Visit
        WHERE visit_id = @visit_id
            )
            BEGIN
                PRINT 'Professor Visit does not exist';
                RETURN;
            END

         IF @follow_up_report IS NULL OR @follow_up_report = ''
         BEGIN
             PRINT 'Follow-up report cannot be empty';
             RETURN;
         END

        UPDATE Professor_Visit
        SET status = 'Completed', follow_up_report = @follow_up_report
        WHERE visit_id = @visit_id;

        PRINT 'Professor Visit marked as completed successfully';

   END TRY

   BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
   END CATCH
END;

--2.16--
GO
CREATE PROC AddVisitOutcome
@visit_id int,
@outcome varchar(200)
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Professor_Visit
        WHERE visit_id = @visit_id
            )
            BEGIN
                PRINT 'Professor Visit does not exist';
                RETURN;
            END

        IF @outcome IS NULL OR @outcome = ''
        BEGIN
            PRINT 'Outcome cannot be empty';
            RETURN;
        END

        IF EXISTS (
        SELECT 1
        FROM Visit_Outcome
        WHERE visit_id = @visit_id
        AND outcome = @outcome
            )
            BEGIN
                PRINT 'Outcome for this visit already exists';
                RETURN;
            END

        INSERT INTO Visit_Outcome
        (visit_id, outcome)
        VALUES
        (@visit_id, @outcome);

        PRINT 'Visit Outcome added successfully';

    END TRY

    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH

END;

--2.17--
GO

CREATE FUNCTION ViewVisitsInPeriod
(
    @start_date date,
    @end_date date
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        PV.visit_id,
        P.full_name AS partner_professor,
        U.name AS university,
        F.name AS host_faculty,
        PV.start_date,
        PV.end_date,
        PV.status,
        COUNT(AI.seq_no) AS number_of_agenda_items

        FROM Professor_Visit PV

        INNER JOIN Partner_Professor PP
            ON PV.partner_prof_id = PP.person_id

        INNER JOIN Person P
            ON PP.person_id = P.person_id

        INNER JOIN Partner_Department PD
            ON PP.pdept_id = PD.pdept_id

        INNER JOIN Partner_University PU
            ON PD.uni_id = PU.uni_id

        INNER JOIN University U
            ON PU.uni_id = U.uni_id

        INNER JOIN Faculty F
            ON PV.host_faculty_id = F.faculty_id

        LEFT JOIN Agenda_Item AI
            ON PV.visit_id = AI.visit_id

        WHERE PV.start_date <= @end_date
        AND PV.end_date >= @start_date
        AND @start_date <= @end_date

        GROUP BY
        PV.visit_id,
        P.full_name,
        U.name,
        F.name,
        PV.start_date,
        PV.end_date,
        PV.status
);

--2.18--
GO 
CREATE FUNCTION GetFacultyDashboard
(
    @faculty_id int 
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        F.faculty_id,
        F.name AS faculty,

        (
            SELECT COUNT(*)
            FROM Student S

            INNER JOIN Program P
                ON S.program_id = P.program_id
            
            INNER JOIN Department D
                ON P.dept_id = D.dept_id
            
            WHERE D.faculty_id = @faculty_id
        )AS number_of_students,
        

        ( 
            SELECT COUNT(*)
            FROM Application A

            INNER JOIN Student S
                ON A.student_id = S.person_id

            INNER JOIN Program P
                ON S.program_id = P.program_id

            INNER JOIN Department D
                ON P.dept_id = D.dept_id

            WHERE D.faculty_id = F.faculty_id
        ) AS number_of_applications,


        ( 
            SELECT COUNT(*)
            FROM Application A

            INNER JOIN Student S
                ON A.student_id = S.person_id

            INNER JOIN Program P
                ON S.program_id = P.program_id

            INNER JOIN Department D
                ON P.dept_id = D.dept_id

            WHERE D.faculty_id = F.faculty_id
            AND A.status = 'Accepted'
        ) AS accepted_applications,


        (
            SELECT COUNT(*)
            FROM Participation PT

            INNER JOIN Application A
                ON PT.app_id = A.app_id

            INNER JOIN Student S
                ON A.student_id = S.person_id

            INNER JOIN Program P
                ON S.program_id = P.program_id

            INNER JOIN Department D
                ON P.dept_id = D.dept_id

            WHERE D.faculty_id = F.faculty_id
            AND PT.status = 'Active'
        )AS active_participations,


        (
            SELECT COUNT(*)
            FROM Professor_Visit PV
            WHERE PV.host_faculty_id = F.faculty_id
        ) AS professor_visits,


        (
           SELECT COUNT(DISTINCT RP.project_id)
           FROM Research_Project RP
           
           INNER JOIN GIU_Participates GP
                ON RP.project_id = GP.project_id

           INNER JOIN GIU_Academic GA
                ON GP.academic_id = GA.person_id

            INNER JOIN Department D
                ON GA.dept_id = D.dept_id

            WHERE D.faculty_id = F.faculty_id
        )AS research_projects

        FROM Faculty F
        WHERE F.faculty_id = @faculty_id
);

--2.19--
GO
CREATE FUNCTION GetPartnerDashboard()
RETURNS TABLE
AS
RETURN
(
    SELECT
        PU.uni_id,
        U.name AS partner_university,
        (
            SELECT COUNT(*)
            FROM Cooperation_Agreement CA
            WHERE CA.partner_uni_id = PU.uni_id
            AND CA.status = 'Active'
        ) AS active_agreements,


        (
            SELECT COUNT(*)
            FROM Opportunity O

            INNER JOIN Cooperation_Agreement CA
                ON O.agreement_id = CA.agreement_id

            WHERE CA.partner_uni_id = PU.uni_id
        )AS opportunities,


        (
            SELECT COUNT(DISTINCT A.student_id)
            FROM Application A

            INNER JOIN Opportunity O
                ON A.opp_id = O.opp_id

            INNER JOIN Cooperation_Agreement CA
                ON O.agreement_id = CA.agreement_id

            WHERE CA.partner_uni_id = PU.uni_id
            AND A.status = 'Accepted'
        ) AS accepted_students,


        (
            SELECT COUNT(*)
            FROM Professor_Visit PV

            INNER JOIN Cooperation_Agreement CA
                ON PV.agreement_id = CA.agreement_id

            WHERE CA.partner_uni_id = PU.uni_id
        ) AS professor_visits,


        (
            SELECT COUNT(DISTINCT RP.project_id)
            FROM Research_Project RP

            INNER JOIN Research_Agreement RA
                ON RP.res_agreement_id = RA.agreement_id

            INNER JOIN Cooperation_Agreement CA
                ON RA.agreement_id = CA.agreement_id

            WHERE CA.partner_uni_id = PU.uni_id
        ) AS research_projects

FROM Partner_University PU
    INNER JOIN University U
        ON PU.uni_id = U.uni_id
);

--2.20--
GO
CREATE FUNCTION GetTopPartners
(
    @top_n int
)
RETURNS TABLE
AS
RETURN 
(
    SELECT TOP (@top_n)
        PU.uni_id,
        U.name AS partner_university,
    
        (
            SELECT COUNT(DISTINCT A.student_id)
            FROM Application A

            INNER JOIN Opportunity O
                ON A.opp_id = O.opp_id

            INNER JOIN Cooperation_Agreement CA
                ON O.agreement_id = CA.agreement_id

            WHERE CA.partner_uni_id = PU.uni_id
            AND A.status = 'Accepted'
        ) AS accepted_students

        FROM Partner_University PU

        INNER JOIN University U
            ON PU.uni_id = U.uni_id

        WHERE @top_n > 0

        ORDER BY accepted_students DESC, U.name ASC
);

--2.21--
GO
CREATE FUNCTION RankPartnersByActivity()
RETURNS TABLE
AS
RETURN 
(
    SELECT
        PA.uni_id,
        PA.partner_university,
        PA.total_activities,

        RANK() OVER 
        (
        ORDER BY PA.total_activities DESC
        ) AS activity_rank

        FROM 
        (  
            SELECT 
                PU.uni_id,
                U.name AS partner_university,

                (   

                    (
                        SELECT COUNT(*)
                        FROM Cooperation_Agreement CA
                        WHERE CA.partner_uni_id = PU.uni_id
                    )

                    +

                    (
                        SELECT COUNT(*)
                        FROM Opportunity O

                        INNER JOIN Cooperation_Agreement CA
                            ON O.agreement_id = CA.agreement_id

                        WHERE CA.partner_uni_id = PU.uni_id
                    )

                    +

                    (
                        SELECT COUNT(*)
                        FROM Professor_Visit PV

                        INNER JOIN Cooperation_Agreement CA
                            ON PV.agreement_id = CA.agreement_id

                        WHERE CA.partner_uni_id = PU.uni_id
                    )

                    +

                    (
                        SELECT COUNT(*)
                        FROM Research_Project RP

                        INNER JOIN Research_Agreement RA
                            ON RP.res_agreement_id = RA.agreement_id

                        INNER JOIN Cooperation_Agreement CA
                            ON RA.agreement_id = CA.agreement_id

                        WHERE CA.partner_uni_id = PU.uni_id
                    )
            ) AS total_activities

            FROM Partner_University PU

            INNER JOIN University U
                ON PU.uni_id = U.uni_id

       ) AS PA
);

--2.22--
GO
CREATE FUNCTION GetMobilityTrend()
RETURNS TABLE
AS
RETURN
(
  SELECT 
    YM.mobility_year AS [year],
    YM.number_of_mobilities,

    YM.number_of_mobilities - LAG(YM.number_of_mobilities) 
    OVER 
    (
    ORDER BY YM.mobility_year
    ) AS change_from_previous_year

    FROM 
    (
        SELECT 
            YEAR(PT.start_date) AS mobility_year,
            COUNT(DISTINCT PT.part_id) AS number_of_mobilities
 
        FROM Participation PT

        INNER JOIN Mobility M
            ON PT.part_id = M.part_id

        INNER JOIN Application A
            ON PT.app_id = A.app_id

        INNER JOIN Opportunity O
            ON A.opp_id = O.opp_id

        INNER JOIN Mobility_Program MP
            ON O.opp_id = MP.opp_id

        INNER JOIN GIU G
            ON MP.sending_uni_id = G.uni_id

        WHERE PT.start_date IS NOT NULL
        AND A.status = 'Accepted'

        GROUP BY YEAR(PT.start_date)

   ) AS YM
);
--end of section 2--

--9.1--
GO
CREATE FUNCTION ViewMyNotifications
(
    @recipient_id int,
    @unread_only bit
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP(100) PERCENT
        N.notif_id,
        N.message,
        N.[timestamp],
        N.category,
        N.urgency,
        N.read_status,
        N.recipient_id

    FROM Notification N

    WHERE N.recipient_id = @recipient_id
    AND (
        @unread_only = 0 
        OR N.read_status = 0
        )

    ORDER BY N.[timestamp] ASC
);

--9.2--
GO
CREATE FUNCTION GetUnreadCount
(
    @recipient_id int
)
RETURNS int
AS
BEGIN

    DECLARE @unread_count int;

    SELECT @unread_count = COUNT(*)
    FROM Notification N
    WHERE N.recipient_id = @recipient_id
    AND N.read_status = 0;

    RETURN @unread_count
END;

--9.3--
GO
CREATE PROC MarkNotificationRead
@notif_id int,
@recipient_id int
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
        SELECT 1
        FROM Notification
        WHERE notif_id = @notif_id
        AND recipient_id = @recipient_id
            )
            BEGIN
                PRINT 'Notification does not exist for this recipient';
                RETURN;
            END

        UPDATE Notification
        SET read_status = 1
        WHERE notif_id = @notif_id
        AND recipient_id = @recipient_id;

        PRINT 'Notification marked as read successfully';

    END TRY

    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH

END;

--9.4--
GO
CREATE PROC MarkAllNotificationsRead
@recipient_id int
AS
BEGIN

    BEGIN TRY

        IF NOT EXISTS (
            SELECT 1
            FROM Person
            WHERE person_id = @recipient_id
        )
        BEGIN
            PRINT 'User doesnt exist';
            RETURN;
        END

        DECLARE @updated_count INT;

        UPDATE Notification
        SET read_status = 1
        WHERE recipient_id = @recipient_id
        AND read_status = 0;

        SET @updated_count = @@ROWCOUNT;

        PRINT 'All notifications marked as read successfully. '
              + CAST(@updated_count AS VARCHAR(10))
              + ' notifications updated.';

    END TRY

    BEGIN CATCH
        PRINT 'Error: ' + ERROR_MESSAGE();
    END CATCH

END;

--end of section 9--

--end of Mahmoud's part--
go
--Eyads's part ,Program Coordinator(GIU Academic) story 3--
Create Proc CreateShortProgram
(
@title varchar(200),
@description varchar(1000),
@app_open_date date,
@app_close_date date,
@capacity int,
@location_mode varchar(30),
@agreement_id int,
@duration varchar(50),
@location varchar(100),
@hosting_arrangements varchar(300),
@host_uni_id int
)
AS
BEGIN
	
	IF @app_close_date < @app_open_date
    BEGIN
        PRINT 'Error: Application close date cannot be earlier than open date.';
        RETURN;
    END

	IF @capacity <= 0
    BEGIN
        PRINT 'Error: Capacity must be a positive integer.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM University WHERE uni_id = @host_uni_id)
BEGIN
    PRINT 'Error: Host university does not exist.';
    RETURN;
END

IF @agreement_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cooperation_Agreement WHERE agreement_id = @agreement_id)
BEGIN
    PRINT 'Error: Cooperation agreement does not exist.';
    RETURN;
END

BEGIN TRY
BEGIN TRANSACTION;
	Insert into Opportunity (title, description, type, app_open_date, app_close_date, capacity, location_mode, agreement_id, status)
	Values (@title, @description, 'Short Program', @app_open_date, @app_close_date, @capacity, @location_mode, @agreement_id, 'Open');

	Declare @opp_id int = SCOPE_IDENTITY();
	
	Insert into Short_Program (opp_id, duration, location, hosting_arrangements, host_uni_id)
	Values (@opp_id, @duration, @location, @hosting_arrangements, @host_uni_id);

	Print 'Short Program created successfully with Opportunity ID: ' + CAST(@opp_id AS varchar);
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	PRINT 'Error occurred while creating Short Program: ' + ERROR_MESSAGE();
END CATCH
	END;

go 

Create Proc CreateMobilityProgram
(
@title varchar(200),
@description varchar(1000),
@app_open_date date,
@app_close_date date,
@capacity int,
@location_mode varchar(30),
@agreement_id int,
@mobility_type varchar(50),
@duration varchar(50),
@sending_uni_id int,
@host_uni_id int
)
AS
BEGIN
	
	IF @app_close_date < @app_open_date
	BEGIN
		PRINT 'Error: Application close date cannot be earlier than open date.';
		RETURN;
	END

	IF @capacity <= 0
	BEGIN
		PRINT 'Error: Capacity must be a positive integer.';
		RETURN;
	END

    IF @sending_uni_id = @host_uni_id
BEGIN
    PRINT 'Error: Sending university and host university cannot be the same.';
    RETURN;
END

IF NOT EXISTS (SELECT 1 FROM University WHERE uni_id = @sending_uni_id)
   OR NOT EXISTS (SELECT 1 FROM University WHERE uni_id = @host_uni_id)
BEGIN
    PRINT 'Error: Sending or host university does not exist.';
    RETURN;
END

IF @agreement_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Cooperation_Agreement WHERE agreement_id = @agreement_id)
BEGIN
    PRINT 'Error: Cooperation agreement does not exist.';
    RETURN;
END

BEGIN TRY
BEGIN TRANSACTION;
	Insert into Opportunity (title, description, type , app_open_date, app_close_date, capacity, location_mode, agreement_id , status)
	Values (@title, @description, 'Mobility Program', @app_open_date, @app_close_date, @capacity, @location_mode, @agreement_id, 'Open');

	Declare @opp_id int = SCOPE_IDENTITY();
	
	Insert into Mobility_Program (opp_id, mobility_type, duration, sending_uni_id, host_uni_id)
	Values (@opp_id, @mobility_type, @duration, @sending_uni_id, @host_uni_id);

	Print 'Mobility Program created successfully with Opportunity ID: ' + CAST(@opp_id AS varchar);
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	PRINT 'Error occurred while creating Mobility Program: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc AddOpportunityField
(
@opp_id int,
@field_id int
)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
    BEGIN
        PRINT 'Error: Opportunity does not exist.';
        RETURN;
    END

	IF NOT EXISTS (SELECT 1 FROM Field WHERE field_id = @field_id)
    BEGIN
        PRINT 'Error: Field does not exist.';
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Opp_Field WHERE opp_id = @opp_id AND field_id = @field_id)
    BEGIN
        PRINT 'Error: This field is already linked to the opportunity.';
        RETURN;
    END
BEGIN TRY
	INSERT INTO Opp_Field (opp_id, field_id)
    VALUES (@opp_id, @field_id);

    PRINT 'Field added to opportunity successfully.';
END TRY
BEGIN CATCH
	PRINT 'Error occurred while adding field to opportunity: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc AddEligibleProgram
(
@opp_id int,
@program_id int
)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
    BEGIN
        PRINT 'Error: Opportunity does not exist.';
        RETURN;
    END

	IF NOT EXISTS (SELECT 1 FROM Program WHERE program_id = @program_id)
    BEGIN
        PRINT 'Error: Program does not exist.';
        RETURN;
    END

	IF EXISTS (SELECT 1 FROM Opp_Eligible_Program WHERE opp_id = @opp_id AND program_id = @program_id)
    BEGIN
        PRINT 'Error: This program is already linked to the opportunity.';
        RETURN;
    END

BEGIN TRY
	INSERT INTO Opp_Eligible_Program (opp_id, program_id)
    VALUES (@opp_id, @program_id);

    PRINT 'Program added to opportunity successfully.';
END TRY
BEGIN CATCH
	PRINT 'Error occurred while adding program to opportunity: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc AddOpportunityPrerequisite
(
@opp_id int,
@course_id int
)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
	BEGIN
		PRINT 'Error: Opportunity does not exist.';
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM Course WHERE course_id = @course_id)
	BEGIN
		PRINT 'Error: Course does not exist.';
		RETURN;
	END

	IF EXISTS (SELECT 1 FROM Opp_Prereq_Course WHERE opp_id = @opp_id AND course_id = @course_id)
	BEGIN
		PRINT 'Error: This course is already linked as a prerequisite to the opportunity.';
		RETURN;
	END
BEGIN TRY
	INSERT INTO Opp_Prereq_Course (opp_id, course_id)
	VALUES (@opp_id, @course_id);

	PRINT 'Prerequisite course added to opportunity successfully.';
END TRY
BEGIN CATCH
	PRINT 'Error occurred while adding prerequisite course to opportunity: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc AddRequiredSkill
(
@opp_id int,
@skill_id int
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
	BEGIN
		PRINT 'Error: Opportunity does not exist.';
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM Skill WHERE skill_id = @skill_id)
	BEGIN
		PRINT 'Error: Skill does not exist.';
		RETURN;
	END

	IF EXISTS (SELECT 1 FROM Opp_Skill WHERE opp_id = @opp_id AND skill_id = @skill_id)
	BEGIN
		PRINT 'Error: This skill is already linked as a requirement to the opportunity.';
		RETURN;
	END
BEGIN TRY
	INSERT INTO Opp_Skill (opp_id, skill_id)
	VALUES (@opp_id, @skill_id);

	PRINT 'Required skill added to opportunity successfully.';
END TRY
BEGIN CATCH
	PRINT 'Error occurred while adding required skill to opportunity: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc AddLanguageRequirement
(
@opp_id int,
@language_req varchar(50)
)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
	BEGIN
		PRINT 'Error: Opportunity does not exist.';
		RETURN;
	END

	IF EXISTS (SELECT 1 FROM Opp_Language_Req WHERE opp_id = @opp_id AND language_req = @language_req)
	BEGIN
		PRINT 'Error: This language requirement is already linked to the opportunity.';
		RETURN;
	END
BEGIN TRY
	INSERT INTO Opp_Language_Req (opp_id, language_req)
	VALUES (@opp_id, @language_req);

	PRINT 'Language requirement added to opportunity successfully.';
END TRY
BEGIN CATCH
	PRINT 'Error occurred while adding language requirement to opportunity: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc AddRelevantDate
(
@opp_id int,
@relevant_date date
)
AS
BEGIN

	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
	BEGIN
		PRINT 'Error: Opportunity does not exist.';
		RETURN;
	END

	IF EXISTS (SELECT 1 FROM Opp_Relevant_Date WHERE opp_id = @opp_id AND relevant_date = @relevant_date)
	BEGIN
		PRINT 'Error: This relevant date is already linked to the opportunity.';
		RETURN;
	END
BEGIN TRY
	INSERT INTO Opp_Relevant_Date (opp_id, relevant_date)
	VALUES (@opp_id, @relevant_date);
	
	PRINT 'Relevant date added to opportunity successfully.';
END TRY
BEGIN CATCH
	PRINT 'Error occurred while adding relevant date to opportunity: ' + ERROR_MESSAGE();
END CATCH
END;

go

Create Proc UpdateOpportunityStatus
(
@opp_id int,
@status varchar(30)
)
AS
BEGIN
	IF @status NOT IN ('Open', 'Closed', 'Cancelled')
	BEGIN
		PRINT 'Error: Invalid status. Status must be Open, Closed, or Cancelled.';
    RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id)
	BEGIN
		PRINT 'Error: Opportunity does not exist.';
		RETURN;
	END
BEGIN TRY
    UPDATE Opportunity
    SET status = @status
    WHERE opp_id = @opp_id;

    PRINT 'Opportunity status updated successfully.';
END TRY
BEGIN CATCH
    PRINT 'Error occurred while updating opportunity status: ' + ERROR_MESSAGE();
END CATCH
END;
go

Create Function ViewOpportunityApplications
(
@opp_id int
)
RETURNS TABLE
AS
RETURN
(
SELECT 
a.app_id,
p.full_name AS student_name,
pr.name AS program_name,
s.gpa,
a.app_date,
a.status,
COUNT(ad.doc_type) AS uploaded_documents
    FROM Application a
    JOIN Student s 
        ON a.student_id = s.person_id
    JOIN Person p 
        ON s.person_id = p.person_id
    JOIN Program pr 
        ON s.program_id = pr.program_id
    LEFT JOIN Application_Document ad 
        ON a.app_id = ad.app_id
    WHERE a.opp_id = @opp_id
GROUP BY 
a.app_id,
p.full_name,
pr.name,
s.gpa,
a.app_date,
a.status
);

go

Create Proc ScheduleInterview
(
@app_id int,
@date date,
@time time,
@location_mode varchar(30)
)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Application WHERE app_id = @app_id)
	BEGIN
		PRINT 'Error: Application does not exist.';
		RETURN;
	END

	IF NOT EXISTS (SELECT 1 FROM Application WHERE app_id = @app_id AND status = 'Pending')
    BEGIN
        PRINT 'Error: Can only schedule interviews for pending applications.';
        RETURN;
    END

	IF @date < CAST(GETDATE() AS DATE)
    BEGIN
        PRINT 'Error: Interview date cannot be in the past.';
        RETURN;
    END

	BEGIN TRY
        INSERT INTO Interview (app_id, date, time, location_mode, outcome, notes)
        VALUES (@app_id, @date, @time, @location_mode, NULL, NULL);

        DECLARE @interview_id INT = SCOPE_IDENTITY();

        PRINT 'Interview scheduled successfully with Interview ID: ' + CAST(@interview_id AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while scheduling interview: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROC AssignInterviewer
(
@interview_id INT,
@interviewer_id INT
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Interview WHERE interview_id = @interview_id)
    BEGIN
        PRINT 'Error: Interview does not exist.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Interviewer WHERE interviewer_id = @interviewer_id)
    BEGIN
        PRINT 'Error: Interviewer does not exist.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Conducts_Interview WHERE interviewer_id = @interviewer_id AND interview_id = @interview_id)
    BEGIN
        PRINT 'Error: This interviewer is already assigned to the interview.';
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Conducts_Interview (interviewer_id, interview_id)
        VALUES (@interviewer_id, @interview_id);

        PRINT 'Interviewer assigned to interview successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while assigning interviewer: ' + ERROR_MESSAGE();
    END CATCH
END;

go

Create FUNCTION GetRemainingCapacity
(
@opp_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @remaining INT;

    SELECT @remaining = o.capacity - (
        SELECT COUNT(*) 
        FROM Application a 
        WHERE a.opp_id = o.opp_id AND a.status = 'Accepted'
    )
    FROM Opportunity o
    WHERE o.opp_id = @opp_id;

    RETURN @remaining;
END;

go


Create Proc DecideApplication
(
@app_id int,
@status varchar(20)
)
AS
BEGIN
	IF @status NOT IN ('Accepted', 'Rejected')
    BEGIN
        PRINT 'Error: Invalid status. Status must be Accepted or Rejected.';
        RETURN;
    END

	DECLARE @opp_id INT, @student_id INT, @current_status VARCHAR(255);

    SELECT 
        @opp_id = opp_id,
        @student_id = student_id,
        @current_status = status
    FROM Application
    WHERE app_id = @app_id;

	IF @opp_id IS NULL
    BEGIN
        PRINT 'Error: Application does not exist.';
        RETURN;
    END

	IF @current_status != 'Pending'
    BEGIN
        PRINT 'Error: This application has already been ' + @current_status + '.';
        RETURN;
    END

	IF @status = 'Accepted'
    BEGIN

	IF EXISTS (SELECT 1 FROM Opportunity WHERE opp_id = @opp_id AND status = 'Cancelled')
        BEGIN
            PRINT 'Error: Cannot accept application because the opportunity has been cancelled.';
            RETURN;
        END

    IF ISNULL(dbo.GetRemainingCapacity(@opp_id), 0) <= 0
        BEGIN
            PRINT 'Error: Cannot accept application because the opportunity is full.';
            RETURN;
        END

    IF EXISTS (SELECT 1 FROM Thesis_Topic WHERE opp_id = @opp_id)
        BEGIN
            IF EXISTS (
                SELECT 1
                FROM Application a
                JOIN Thesis_Topic tt ON a.opp_id = tt.opp_id
                WHERE a.student_id = @student_id AND a.status = 'Accepted'
            )
            BEGIN
                PRINT 'Error: Student already holds an accepted thesis.';
                RETURN;
            END
        END
    END

    BEGIN TRY
        UPDATE Application
        SET status = @status,
            decision_date = CAST(GETDATE() AS DATE)
        WHERE app_id = @app_id;

        PRINT 'Application decision recorded successfully as ' + @status + '.';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while deciding application: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROC CreateParticipation
(
@app_id INT,
@start_date DATE,
@end_date DATE
)
AS
BEGIN
    DECLARE @app_status VARCHAR(255), @opp_id INT;

    SELECT 
        @app_status = status,
        @opp_id = opp_id
    FROM Application
    WHERE app_id = @app_id;

    IF @opp_id IS NULL
    BEGIN
        PRINT 'Error: Application does not exist.';
        RETURN;
    END

    IF @app_status != 'Accepted'
    BEGIN
        PRINT 'Error: Participation can only be created for Accepted applications.';
        RETURN;
    END


    IF NOT EXISTS (SELECT 1 FROM Mobility_Program WHERE opp_id = @opp_id)
       AND NOT EXISTS (SELECT 1 FROM Short_Program WHERE opp_id = @opp_id)
    BEGIN
        PRINT 'Error: Participation can only be created for Mobility Programs or Short Programs.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Participation WHERE app_id = @app_id)
    BEGIN
        PRINT 'Error: A participation record already exists for this application.';
        RETURN;
    END

    IF @end_date < @start_date
    BEGIN
        PRINT 'Error: End date cannot be earlier than start date.';
        RETURN;
    END

    BEGIN TRY
    BEGIN TRANSACTION;
        INSERT INTO Participation (status, start_date, end_date, app_id)
        VALUES ('Active', @start_date, @end_date, @app_id);

        DECLARE @part_id INT = SCOPE_IDENTITY();

        IF EXISTS (SELECT 1 FROM Mobility_Program WHERE opp_id = @opp_id)
        BEGIN
            DECLARE @host_uni_id INT;
            SELECT @host_uni_id = host_uni_id 
            FROM Mobility_Program 
            WHERE opp_id = @opp_id;

            INSERT INTO Mobility (part_id, host_uni_id)
            VALUES (@part_id, @host_uni_id);
        END
        ELSE IF EXISTS (SELECT 1 FROM Short_Program WHERE opp_id = @opp_id)
        BEGIN
            INSERT INTO Program_Participation (part_id)
            VALUES (@part_id);
        END

        PRINT 'Participation created successfully with Participation ID: ' + CAST(@part_id AS VARCHAR);
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
    IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        PRINT 'Error occurred while creating participation: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROC UpdateMobilityStatus
(
@part_id INT,
@pre_travel_status VARCHAR(50),
@during_status VARCHAR(50),
@post_status VARCHAR(50),
@final_outcome VARCHAR(300)
)
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Mobility WHERE part_id = @part_id)
    BEGIN
        PRINT 'Error: Mobility participation record does not exist.';
        RETURN;
    END

 
    BEGIN TRY
        BEGIN TRANSACTION;

            UPDATE Mobility
            SET 
                pre_travel_status = ISNULL(@pre_travel_status, pre_travel_status),
                during_status     = ISNULL(@during_status, during_status),
                post_status       = ISNULL(@post_status, post_status),
                final_outcome     = ISNULL(@final_outcome, final_outcome)
            WHERE part_id = @part_id;

            IF @final_outcome = 'Cancelled' 
               OR @pre_travel_status = 'Cancelled' 
               OR @during_status = 'Cancelled' 
               OR @post_status = 'Cancelled'
            BEGIN
                UPDATE Participation
                SET status = 'Cancelled'
                WHERE part_id = @part_id;
            END
            ELSE IF @final_outcome = 'Completed' 
                    OR @post_status = 'Completed'
            BEGIN
                UPDATE Participation
                SET status = 'Completed'
                WHERE part_id = @part_id;
            END

        COMMIT TRANSACTION;

        PRINT 'Mobility status updated successfully for Participation ID: ' + CAST(@part_id AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error occurred while updating mobility status: ' + ERROR_MESSAGE();
    END CATCH
END;

go 

CREATE PROC UpdateProgramParticipation
(
@part_id INT,
@payment_status VARCHAR(30),
@visa_status VARCHAR(30),
@travel_status VARCHAR(30)
)
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM Program_Participation WHERE part_id = @part_id)
    BEGIN
        PRINT 'Error: Program participation record does not exist.';
        RETURN;
    END

    
    BEGIN TRY
        BEGIN TRANSACTION;

            UPDATE Program_Participation
            SET 
                payment_status = ISNULL(@payment_status, payment_status),
                visa_status    = ISNULL(@visa_status, visa_status),
                travel_status  = ISNULL(@travel_status, travel_status)
            WHERE part_id = @part_id;

            
            IF @payment_status = 'Cancelled'
               OR @visa_status IN ('Cancelled', 'Rejected')
               OR @travel_status = 'Cancelled'
            BEGIN
                UPDATE Participation
                SET status = 'Cancelled'
                WHERE part_id = @part_id;
            END
            ELSE IF @travel_status = 'Completed'
            BEGIN
                UPDATE Participation
                SET status = 'Completed'
                WHERE part_id = @part_id;
            END

        COMMIT TRANSACTION;

        PRINT 'Program participation status updated successfully for Participation ID: ' + CAST(@part_id AS VARCHAR);
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Error occurred while updating program participation status: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROC RecordCourseEquivalency
(
@part_id INT,
@host_course_title VARCHAR(150),
@host_credits DECIMAL(4,1),
@transferred_credits DECIMAL(4,1),
@giu_course_id INT
)
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM Mobility WHERE part_id = @part_id)
    BEGIN
        PRINT 'Error: Mobility participation record does not exist.';
        RETURN;
    END
    
    IF NOT EXISTS (SELECT 1 FROM Course WHERE course_id = @giu_course_id)
    BEGIN
        PRINT 'Error: GIU course does not exist.';
        RETURN;
    END

    IF EXISTS ( SELECT 1 FROM Course_Equivalency WHERE part_id = @part_id AND host_course_title = @host_course_title)
    BEGIN
        PRINT 'Error: This host course has already been recorded for this mobility.';
        RETURN;
    END


    IF @transferred_credits > @host_credits
    BEGIN
        PRINT 'Error: Transferred credits cannot exceed host credits.';
        RETURN;
    END

    IF @host_credits <= 0 OR @transferred_credits < 0
    BEGIN
        PRINT 'Error: Credit values must be valid non-negative numbers.';
        RETURN;
    END

    
    BEGIN TRY
        INSERT INTO Course_Equivalency (part_id, host_course_title, host_credits, transferred_credits, approval_status, giu_course_id)
        VALUES (@part_id, @host_course_title, @host_credits, @transferred_credits, 'Pending', @giu_course_id);

        PRINT 'Course equivalency recorded successfully for Participation ID: ' + CAST(@part_id AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while recording course equivalency: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE PROC DecideCourseEquivalency
(
@part_id INT,
@host_course_title VARCHAR(150),
@approval_status VARCHAR(30)
)
AS
BEGIN
    
    IF @approval_status NOT IN ('Approved', 'Rejected')
    BEGIN
        PRINT 'Error: Approval status must be either Approved or Rejected.';
        RETURN;
    END

   
    IF NOT EXISTS (SELECT 1 FROM Course_Equivalency WHERE part_id = @part_id AND host_course_title = @host_course_title)
    BEGIN
        PRINT 'Error: Course equivalency record does not exist.';
        RETURN;
    END

    
    BEGIN TRY
        UPDATE Course_Equivalency
        SET approval_status = @approval_status
        WHERE part_id = @part_id AND host_course_title = @host_course_title;

        PRINT 'Course equivalency status updated to ' + @approval_status + ' for Participation ID: ' + CAST(@part_id AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while updating course equivalency status: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION GetTransferredCredits
(
@part_id INT
)
RETURNS DECIMAL(5,1)
AS
BEGIN

    DECLARE @total_credits DECIMAL(5,1);

    SELECT @total_credits = ISNULL(SUM(transferred_credits), 0)
    FROM Course_Equivalency
    WHERE part_id = @part_id AND approval_status = 'Approved';

    RETURN @total_credits;
END;

go

CREATE PROC LinkFundingToMobility
(
@fund_id INT,
@part_id INT
)
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM Funding_Opportunity WHERE fund_id = @fund_id)
    BEGIN
        PRINT 'Error: Funding opportunity does not exist.';
        RETURN;
    END
  
    IF NOT EXISTS (SELECT 1 FROM Mobility WHERE part_id = @part_id)
    BEGIN
        PRINT 'Error: Mobility participation record does not exist.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Participation WHERE part_id = @part_id AND status = 'Cancelled')
    BEGIN
        PRINT 'Error: Cannot link funding to a cancelled participation.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Fund_Supports_Mobility WHERE fund_id = @fund_id AND part_id = @part_id)
    BEGIN
        PRINT 'Error: This funding opportunity is already linked to this mobility.';
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Fund_Supports_Mobility (fund_id, part_id)
        VALUES (@fund_id, @part_id);

        PRINT 'Funding ID ' + CAST(@fund_id AS VARCHAR) + ' linked successfully to Mobility ID ' + CAST(@part_id AS VARCHAR) + '.';
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while linking funding to mobility: ' + ERROR_MESSAGE();
    END CATCH
END;

go

CREATE FUNCTION GetOpportunityFillRates()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        O.title AS opportunity,
        O.type,
        O.capacity,
        COUNT(A.app_id) AS accepted_applications,
        CAST(
            CASE 
                WHEN O.capacity > 0 THEN (COUNT(A.app_id) * 100.0) / O.capacity 
                ELSE 0 
            END 
        AS DECIMAL(5,2)) AS fill_percentage
    FROM Opportunity O
    LEFT JOIN Application A 
        ON O.opp_id = A.opp_id 
       AND A.status = 'Accepted'
    WHERE O.status = 'Open'
    GROUP BY O.opp_id, O.title, O.type, O.capacity
);

go

CREATE FUNCTION GetApplicationStatsByType()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        O.type AS opportunity_type,
        SUM(CASE WHEN A.status = 'Pending'  THEN 1 ELSE 0 END) AS pending_applications,
        SUM(CASE WHEN A.status = 'Accepted' THEN 1 ELSE 0 END) AS accepted_applications,
        SUM(CASE WHEN A.status = 'Rejected' THEN 1 ELSE 0 END) AS rejected_applications
    FROM Opportunity O
    LEFT JOIN Application A 
        ON O.opp_id = A.opp_id
    GROUP BY O.type
);

go

CREATE PROC NotifyUpcomingDeadlines
(
@days_ahead INT
)
AS
BEGIN
    
    IF @days_ahead < 0
    BEGIN
        PRINT 'Error: @days_ahead must be a non-negative integer.';
        RETURN;
    END

    BEGIN TRY
        INSERT INTO Notification (recipient_id, message, category, urgency, timestamp, read_status)
        SELECT DISTINCT
            S.person_id,
            'Reminder: The opportunity "' + O.title + '" closes on ' + CONVERT(VARCHAR(10), O.app_close_date, 120) + '.',
            'Deadline',
            'High',
            GETDATE(),
            0
        FROM Opportunity O
        INNER JOIN Opp_Eligible_Program EP 
            ON O.opp_id = EP.opp_id
        INNER JOIN Student S 
            ON EP.program_id = S.program_id
        WHERE O.status = 'Open'
          AND O.app_close_date >= CAST(GETDATE() AS DATE)
          AND DATEDIFF(DAY, CAST(GETDATE() AS DATE), O.app_close_date) <= @days_ahead
          AND dbo.CheckEligibility(S.person_id, O.opp_id) = 1
          AND NOT EXISTS (
              SELECT 1 
              FROM Application A 
              WHERE A.student_id = S.person_id 
                AND A.opp_id = O.opp_id
          ) AND NOT EXISTS (
              SELECT 1
              FROM Notification N
              WHERE N.recipient_id = S.person_id
                AND N.category = 'Deadline'
                AND N.message = 'Reminder: The opportunity "' + O.title + '" closes on ' + CONVERT(VARCHAR(10), O.app_close_date, 120) + '.'
          );

        DECLARE @sent_count INT = @@ROWCOUNT;

        PRINT 'Deadline reminders sent successfully. Total notifications sent: ' + CAST(@sent_count AS VARCHAR);
    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while sending deadline notifications: ' + ERROR_MESSAGE();
    END CATCH
END;

go
--Eyad’s part Ended ,Program Coordinator(GIU Academic) story--
