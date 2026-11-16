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
            ON PD.partner_uni_id = PU.uni_id

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