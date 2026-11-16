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