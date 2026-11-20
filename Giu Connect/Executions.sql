-- section 1

-- 1.1
SELECT * FROM dbo.ViewPersonInfo(8);

-- 1.2
EXEC dbo.AddStudent
    'Nadia Tarek', 'nadia.tarek@student.example', '+20-100-555-0206',
    'GIU2026-006', 3, 3.55, 'German B1, English C1', 'CV_Nadia_Tarek.pdf', 1;

-- 1.3
EXEC dbo.AddGIUAcademic
    'Dr. Sherif', 'sherif@giu.example', '+20-100-555-0108',
    'Assistant Professor', 1;

-- 1.4
EXEC dbo.AddPartnerProfessor
    'Prof. Jonas Klein', 'jonas.klein@partner.example', '+49-151-555-0306',
    'Professor', 1;

-- 1.5
EXEC dbo.AddCompanyRep
    'Tarek Mansour', 'tarek.mansour@company.example', '+20-100-555-0406',
    'Mercedes-Benz', 'Automotive', 'Campus Relations Lead', 'Stuttgart, Germany';

-- 1.6
EXEC dbo.UpdatePersonContact 7, 'mohamed.updated@giu.example', '+20-100-555-0199';

-- 1.7
EXEC dbo.UpdateAccountStatus 7, 'Suspended';

-- 1.8
EXEC dbo.RegisterTopicProvider 3;

-- 1.9
EXEC dbo.RegisterInterviewer 6, 'Department Interviewer';

-- 1.10
EXEC dbo.AddFaculty
    'Faculty of Biotechnology', 'Programs and research in biotechnology and life sciences.';

-- 1.11
EXEC dbo.AddDepartment
    'Software Engineering', 'Teaching and research in software architecture and testing.', 1;

-- 1.12
EXEC dbo.AddProgram
    'B.Sc. Software Engineering', 'Bachelor', 144, 'Undergraduate program in software engineering.', 1;

-- 1.13
EXEC dbo.ClassifyProgram 1, 3;

-- 1.14
EXEC dbo.AddCourse 'CS401', 'Machine Learning', 3, 4, 1;

-- 1.15
EXEC dbo.AddPrerequisite 3, 2;

-- 1.16
EXEC dbo.AddField 'Data Science', 'Statistical modeling, data mining and big data systems.';

-- 1.17
EXEC dbo.AddResearchArea 'Natural Language Processing', 'Computational linguistics and language models.', 1;

-- 1.18
EXEC dbo.AddSkill 'Docker', 'DevOps', 'Containerization and deployment of software applications.';

-- 1.19
EXEC dbo.AddPartnerUniversity
    'Karlsruhe Institute of Technology', 'Germany', 'Karlsruhe',
    'Partner institution strong in computer science and engineering.',
    'Active', 'International Office, partner-kit@example.edu';

-- 1.20
EXEC dbo.AddPartnerDepartment
    'Department of Data Science', 'Research and teaching in data science.', 2;

-- 1.21
EXEC dbo.AddPartnerProgram
    'M.Sc. Data Engineering', 'Master', 'Graduate program in data engineering and analytics.', 1, 1;

-- 1.22
SELECT * FROM dbo.GetUserStatsByRole();

-- 1.23
EXEC dbo.SendNotification 8, 'Your profile has been verified.', 'Approval', 'Normal';


-- section 2

-- 2.1
EXEC dbo.CreateMobilityAgreement
    'TUM Extended Mobility Agreement', 'Expanded semester exchange in computer science.',
    '2026-01-01', '2031-12-31', 2, 1,
    'One-semester exchange with credit transfer.', 'Double-degree pathway for top students.',
    12, 'Host tuition waived under agreement.';

-- 2.2
EXEC dbo.CreateResearchAgreement
    'Stuttgart AI & Robotics Research Agreement', 'Joint research in autonomous systems.',
    '2026-01-01', '2031-12-31', 3, 2,
    'Joint IP ownership on co-developed algorithms.', 'Co-funded research grant applications.';

-- 2.3
EXEC dbo.CreateGeneralMoU
    'Ulm Academic Cooperation MoU', 'Broad academic and cultural exchange.',
    '2026-01-01', '2031-12-31', 4, 3,
    'Strengthen institutional ties.', 'Workshops, guest lectures and faculty visits.',
    'Renewable every five years by mutual consent.';

-- 2.4
EXEC dbo.AddAgreementProgram 1, 2;

-- 2.5
EXEC dbo.AddAgreementSemester 1, 'Spring';

-- 2.6
EXEC dbo.AddAgreementResearchArea 6, 2;

-- 2.7
EXEC dbo.UpdateAgreementStatus 15, 'Expired';

-- 2.8
SELECT * FROM dbo.GetExpiringAgreements(2000);

-- 2.9
SELECT * FROM dbo.ViewPartnerHistory(2);

-- 2.10
SELECT dbo.GetAgreementSeatUsage(1) AS Seat_Usage_Percentage;

-- 2.11
EXEC dbo.ScheduleProfessorVisit
    13, 1, 1, 11, '2027-03-01', '2027-03-05',
    'Joint curriculum review and AI seminar.',
    'Return flight booked via international office.', 'GIU guest house reserved.';

-- 2.12
EXEC dbo.AddAgendaItem
    1, 'Workshop', 'Hands-On Explainable AI Session', '2026-12-02T14:00:00',
    'GIU Computer Lab 2', 'Computer Science students and staff';

-- 2.13
EXEC dbo.NotifyVisitAgenda 1;

-- 2.14
EXEC dbo.UpdateVisitStatus 1, 'Active';

-- 2.15
EXEC dbo.CompleteProfessorVisit 2, 'Delivered robotics guest lectures and planned joint lab exchange.';

-- 2.16
EXEC dbo.AddVisitOutcome 2, 'Joint robotics summer workshop agreed.';

-- 2.17
SELECT * FROM dbo.ViewVisitsInPeriod('2026-10-01', '2027-03-31');

-- 2.18
SELECT * FROM dbo.GetFacultyDashboard(1);

-- 2.19
SELECT * FROM dbo.GetPartnerDashboard();

-- 2.20
SELECT * FROM dbo.GetTopPartners(3);

-- 2.21
SELECT * FROM dbo.RankPartnersByActivity();

-- 2.22
SELECT * FROM dbo.GetMobilityTrend();


-- section 3

-- 3.1
EXEC dbo.CreateShortProgram
    'GIU Spring AI Bootcamp', 'Intensive workshops on applied machine learning.',
    '2026-11-01', '2026-12-31', 20, 'Egypt', 11,
    'One week', 'New Administrative Capital, Egypt', 'GIU labs and seminar rooms.', 1;

-- 3.2
EXEC dbo.CreateMobilityProgram
    'TUM Summer Research Exchange', 'Short-term research mobility in Munich.',
    '2026-11-01', '2026-12-31', 8, 'Germany', 1,
    'Semester Exchange', 'One semester', 1, 2;

-- 3.3
EXEC dbo.AddOpportunityField 16, 1;

-- 3.4
EXEC dbo.AddEligibleProgram 16, 1;

-- 3.5
EXEC dbo.AddOpportunityPrerequisite 16, 1;

-- 3.6
EXEC dbo.AddRequiredSkill 16, 1;

-- 3.7
EXEC dbo.AddLanguageRequirement 6, 'German B1';

-- 3.8
EXEC dbo.AddRelevantDate 6, '2026-12-01';

-- 3.9
EXEC dbo.UpdateOpportunityStatus 9, 'Open';

-- 3.10
SELECT * FROM dbo.ViewOpportunityApplications(1);

-- 3.11
EXEC dbo.ScheduleInterview 3, '2026-12-05', '10:30:00', 'Online';

-- 3.12
EXEC dbo.AssignInterviewer 1, 2;

-- 3.13
SELECT dbo.GetRemainingCapacity(1) AS Remaining_Capacity;

-- 3.14
EXEC dbo.DecideApplication 3, 'Accepted';

-- 3.15
EXEC dbo.CreateParticipation 11, '2027-01-10', '2027-06-10';

-- 3.16
EXEC dbo.UpdateMobilityStatus
    6, 'Documents approved', 'Arrived at host university', 'Transcripts received', 'Completed';

-- 3.17
EXEC dbo.UpdateProgramParticipation 3, 'Paid', 'Approved', 'Booked';

-- 3.18
EXEC dbo.RecordCourseEquivalency 6, 'Deep Learning', 5.0, 3.0, 4;

-- 3.19
EXEC dbo.DecideCourseEquivalency 7, 'Robotics and Automation', 'Approved';

-- 3.20
SELECT dbo.GetTransferredCredits(6) AS Transferred_Credits;

-- 3.21
EXEC dbo.LinkFundingToMobility 3, 6;

-- 3.22
SELECT * FROM dbo.GetOpportunityFillRates();

-- 3.23
SELECT * FROM dbo.GetApplicationStatsByType();

-- 3.24
EXEC dbo.NotifyUpcomingDeadlines 30;


-- section 4

-- 4.1
EXEC dbo.DeclareResearchInterest 1, 2;

-- 4.2
EXEC dbo.RemoveResearchInterest 1, 2;

-- 4.3
SELECT * FROM dbo.ViewSupervisedTopics(1);

-- 4.4
SELECT * FROM dbo.FindPartnerCollaborators(1);

-- 4.5
SELECT * FROM dbo.FindCoSupervisors(1);

-- 4.6
SELECT * FROM dbo.ViewTopicApplicants(1);

-- 4.7
SELECT dbo.CheckEligibility(8, 1) AS Is_Eligible;

-- 4.8
EXEC dbo.EvaluateInterview 3, 'Recommended', 'Strong technical foundation in IoT systems.';

-- 4.9
EXEC dbo.CreateResearchProject
    'Federated Learning for Smart Campuses',
    'Joint research on privacy-preserving machine learning across university systems.',
    '2026-11-01', '2028-06-30', 6, 1;

-- 4.10
EXEC dbo.AddProjectArea 1, 2;

-- 4.11
EXEC dbo.AddGIUParticipant 2, 1, 'Co-Investigator';

-- 4.12
EXEC dbo.AddProjectDeadline 1, '2027-06-30';

-- 4.13
EXEC dbo.RecordResearchOutput
    1, 'Report', 'Midterm Explainable AI Evaluation Report',
    '2026-11-15', 'GIU-RES-2026-006', 'Pending';

-- 4.14
EXEC dbo.LinkProjectToFunding 1, 4;

-- 4.15
SELECT * FROM dbo.ViewProjectOutputs(1);

-- 4.16
SELECT * FROM dbo.GetMyProjectDeadlines(1, 365);

-- 4.17
SELECT * FROM dbo.ViewMyCoordinatedVisits(1);


-- section 5

-- 5.1
EXEC dbo.DeclarePartnerInterest 13, 2;

-- 5.2
SELECT * FROM dbo.FindGIUCollaborators(13);

-- 5.3
EXEC dbo.AcceptCoSupervision 1, 14;

-- 5.4
SELECT * FROM dbo.ViewCoSupervisedTopics(13);

-- 5.5
EXEC dbo.RequestVisit
    13, 11, 1, '2027-04-01', '2027-04-05',
    'Joint AI seminar series and thesis co-supervision meetings.';

-- 5.6
SELECT * FROM dbo.ViewVisitAgenda(1);

-- 5.7
EXEC dbo.JoinResearchProject 14, 1, 'Advisor';

-- 5.8
SELECT * FROM dbo.ViewMyResearchProjects(13);

-- 5.9
SELECT * FROM dbo.ViewMyUniversityPrograms(13);


-- section 6

-- 6.1
EXEC dbo.UpdateCompanyProfile
    18, 'Siemens Egypt', 'Industrial Technology', 'Senior Research Liaison', 'Cairo, Egypt';

-- 6.2
EXEC dbo.OfferPlacement 2, 19;

-- 6.3
SELECT * FROM dbo.ViewMyPlacements(18);

-- 6.4
SELECT * FROM dbo.ViewPlacementApplicants(3, 18);

-- 6.5
SELECT dbo.GetSkillMatch(8, 1) AS Skill_Match_Percentage;

-- 6.6
EXEC dbo.ClosePlacement 2, 19;


-- section 7

-- 7.1
EXEC dbo.SubmitThesisTopic
    1, 'Graph Neural Networks for Academic Networks',
    'Bachelor thesis exploring graph-based recommendation models.',
    '2026-11-01', '2026-12-31', 3, 'Hybrid', 6,
    'A working GNN prototype and benchmark report.',
    NULL, 'Local GIU meetings.', NULL, 1, NULL;

-- 7.2
EXEC dbo.AddThesisArea 1, 2;

-- 7.3
EXEC dbo.UpdateThesisTopic
    1, 'Updated bachelor thesis on explainable machine learning for academic services.',
    6, '2026-12-20';

-- 7.4
SELECT * FROM dbo.ViewMySubmittedTopics(1);

-- 7.5
SELECT * FROM dbo.ViewTopicsWithoutCoSupervisor();


-- section 8

-- 8.1
SELECT * FROM dbo.ViewMyProfile(8);

-- 8.2
SELECT * FROM dbo.ViewMyFields(8);

-- 8.3
EXEC dbo.UpdateStudentProfile 8, 6, 'German B2, English C1', 'CV_Mariam_Hassan_v2.pdf';

-- 8.4
EXEC dbo.AddInterest 8, 'Machine Learning';

-- 8.5
EXEC dbo.AddCompletedCourse 8, 2;

-- 8.6
EXEC dbo.AddMySkill 8, 3;

-- 8.7
SELECT * FROM dbo.BrowseOpenOpportunities('Thesis Topic');

-- 8.8
SELECT * FROM dbo.ViewOpportunityDetails(1);

-- 8.9
SELECT * FROM dbo.ViewEligibleOpportunities(8);

-- 8.10
SELECT * FROM dbo.ViewMissingRequirements(8, 2);

-- 8.11
SELECT * FROM dbo.RecommendThesisTopics(8);

-- 8.12
EXEC dbo.SubmitApplication 8, 16, 'Applying for the GIU Spring AI Bootcamp.';

-- 8.13
EXEC dbo.UploadApplicationDocument 16, 'CV', 'uploads/app016/cv_mariam.pdf';

-- 8.14
EXEC dbo.WithdrawApplication 16, 8;

-- 8.15
SELECT * FROM dbo.ViewMyApplications(8);

-- 8.16
SELECT * FROM dbo.ViewMyInterviews(8);

-- 8.17
SELECT dbo.HasAcceptedThesis(8) AS Has_Accepted_Thesis;

-- 8.18
SELECT * FROM dbo.ViewMyParticipations(8);

-- 8.19
SELECT * FROM dbo.ViewMyCourseEquivalencies(8);

-- 8.20
SELECT * FROM dbo.BrowseFunding('Research Grant');

-- 8.21
EXEC dbo.NotifyApplicationStatus 1;


-- section 9

-- 9.1
SELECT * FROM dbo.ViewMyNotifications(8, 1);

-- 9.2
SELECT dbo.GetUnreadCount(8) AS Unread_Count;

-- 9.3
EXEC dbo.MarkNotificationRead 1, 8;

-- 9.4
EXEC dbo.MarkAllNotificationsRead 9;