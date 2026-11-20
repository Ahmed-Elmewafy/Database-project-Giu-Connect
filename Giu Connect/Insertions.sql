INSERT INTO Faculty (name, description) VALUES
    ('Faculty of Informatics and Computer Science', 'Programs and research in computing, software engineering, data and artificial intelligence.'),
    ('Faculty of Engineering', 'Engineering programs covering mechatronics, electronics and embedded systems.'),
    ('Faculty of Business Administration', 'Programs in business administration, analytics and business informatics.'),
    ('Faculty of Architecture and Design', 'Programs in architecture, urban design and sustainable built environments.'),
    ('Faculty of Applied Sciences', 'Interdisciplinary applied science and technology programs.');
   

    
    INSERT INTO Department (name, description, faculty_id) VALUES
    ('Computer Science', 'Teaching and research in software, algorithms, databases and intelligent systems.', 1),
    ('Mechatronics Engineering', 'Teaching and research in robotics, automation and control.', 2),
    ('Business Informatics', 'Teaching and research in information systems and business analytics.', 3),
    ('Architecture', 'Teaching and research in architectural design and sustainable buildings.', 4),
    ('Electrical Engineering', 'Teaching and research in electronics, communications and embedded systems.', 5);
    

    
    INSERT INTO Program (name, degree_level, total_credit_hours, description, dept_id) VALUES
    ('B.Sc. Computer Science', 'Bachelor', 144, 'Undergraduate program in computer science and software development.', 1),
    ('B.Sc. Mechatronics Engineering', 'Bachelor', 160, 'Undergraduate program combining mechanical, electrical and computing systems.', 2),
    ('B.Sc. Business Informatics', 'Bachelor', 144, 'Undergraduate program combining business processes and information technology.', 3),
    ('B.Sc. Architecture', 'Bachelor', 160, 'Undergraduate program in architectural design and the built environment.', 4),
    ('B.Sc. Electrical Engineering', 'Bachelor', 160, 'Undergraduate program in electrical and electronic engineering.', 5);
    

    
    INSERT INTO Course (code, title, credit_hours, level, program_id) VALUES
    ('CS101', 'Introduction to Programming', 3, 1, 1),
    ('CS102', 'Object-Oriented Programming', 3, 2, 1),
    ('CS201', 'Data Structures', 3, 2, 1),
    ('CS301', 'Algorithms', 3, 3, 1),
    ('CS302', 'Database Systems', 3, 3, 1),
    ('ME101', 'Introduction to Mechatronics', 3, 1, 2),
    ('ME102', 'Engineering Mathematics', 4, 1, 2),
    ('ME201', 'Sensors and Actuators', 3, 2, 2),
    ('ME301', 'Control Systems', 3, 3, 2),
    ('ME302', 'Robotics Fundamentals', 3, 3, 2),
    ('BI101', 'Introduction to Business Informatics', 3, 1, 3),
    ('BI102', 'Business Statistics', 3, 1, 3),
    ('BI201', 'Systems Analysis', 3, 2, 3),
    ('BI301', 'Data Analytics for Business', 3, 3, 3),
    ('BI302', 'Enterprise Information Systems', 3, 3, 3),
    ('AR101', 'Architectural Design I', 4, 1, 4),
    ('AR102', 'Building Materials', 3, 1, 4),
    ('AR201', 'Architectural Design II', 4, 2, 4),
    ('AR301', 'Sustainable Architecture', 3, 3, 4),
    ('AR302', 'Urban Design Principles', 3, 3, 4),
    ('EE101', 'Circuit Analysis I', 3, 1, 5),
    ('EE102', 'Programming for Engineers', 3, 1, 5),
    ('EE201', 'Digital Logic Design', 3, 2, 5),
    ('EE301', 'Microprocessors', 3, 3, 5),
    ('EE302', 'Embedded Systems', 3, 3, 5);


    INSERT INTO Field (name, description) VALUES
    ('Computer Science', 'Computing, software engineering, algorithms and intelligent systems.'),
    ('Mechatronics', 'The integration of mechanical engineering, electronics and computer control.'),
    ('Business Informatics', 'Information technology and digital systems applied to business.'),
    ('Architecture', 'Architectural design, planning and the built environment.'),
    ('Electrical Engineering', 'Electrical, electronic, communication and embedded technologies.');


    INSERT INTO Research_Area (name, description, field_id) VALUES
    ('Artificial Intelligence and Machine Learning', 'Learning algorithms and intelligent computational systems.', 1),
    ('Robotics and Autonomous Systems', 'Robot perception, motion planning and autonomous control.', 2),
    ('Business Data Analytics', 'Data-driven decision support and business intelligence.', 3),
    ('Sustainable Architecture', 'Energy-efficient buildings and sustainable urban design.', 4),
    ('Embedded Systems and IoT', 'Connected devices, embedded computing and sensor networks.', 5);


    INSERT INTO Skill (name, category, description) VALUES
    ('Python Programming', 'Programming', 'Ability to develop scripts and applications using Python.'),
    ('C++ Programming', 'Programming', 'Ability to implement algorithms and object-oriented applications in C++.'),
    ('SQL and Database Design', 'Database', 'Ability to query relational databases and design normalized schemas.'),
    ('CAD Modelling', 'Engineering', 'Ability to create and modify technical models using CAD tools.'),
    ('MATLAB', 'Engineering', 'Ability to perform numerical analysis and engineering simulations.');

    INSERT INTO University (name, country, city, description) VALUES
    ('German International University', 'Egypt', 'New Administrative Capital', 'The local institution operating the GIU Germany Connect portal.'),
    ('Technical University of Munich', 'Germany', 'Munich', 'Partner institution with programs in engineering, computing and technology.'),
    ('University of Stuttgart', 'Germany', 'Stuttgart', 'Partner institution with strengths in engineering and applied sciences.'),
    ('Ulm University', 'Germany', 'Ulm', 'Partner institution supporting academic exchange and research cooperation.'),
    ('Technische UniversitÃ¤t Berlin', 'Germany', 'Berlin', 'Partner institution offering programs in engineering and computer science.'),
    ('RWTH Aachen University', 'Germany', 'Aachen', 'Partner institution with engineering and technology programs.');

    INSERT INTO GIU (uni_id) VALUES (1);

    INSERT INTO Partner_University (uni_id, partnership_status, contact_info) VALUES
    (2, 'Active', 'International Office, partner-tum@example.edu'),
    (3, 'Active', 'International Office, partner-stuttgart@example.edu'),
    (4, 'Active', 'International Office, partner-ulm@example.edu'),
    (5, 'Active', 'International Office, partner-tu-berlin@example.edu'),
    (6, 'Active', 'International Office, partner-rwth@example.edu');

    INSERT INTO Partner_Department (name, description, partner_uni_id) VALUES
    ('Computer Science Department', 'Computing and software research unit at the partner university.', 2),
    ('Institute of Mechanical Engineering', 'Engineering unit focused on mechatronics and automation.', 3),
    ('Department of Business Informatics', 'Academic unit focused on digital business systems.', 4),
    ('Institute of Architecture', 'Academic unit focused on architecture and urban sustainability.', 5),
    ('Department of Electrical Engineering', 'Academic unit focused on electronics and embedded systems.', 6);

    INSERT INTO Partner_Program (name, degree_level, description, pdept_id) VALUES
    ('M.Sc. Computer Science', 'Master', 'Graduate program in computer science and intelligent systems.', 1),
    ('M.Sc. Mechatronics', 'Master', 'Graduate program in mechatronics, robotics and automation.', 2),
    ('M.Sc. Business Informatics', 'Master', 'Graduate program in business information systems.', 3),
    ('M.Sc. Architecture', 'Master', 'Graduate program in architecture and sustainable design.', 4),
    ('M.Sc. Electrical Engineering', 'Master', 'Graduate program in electrical and embedded systems engineering.', 5);

    INSERT INTO Person (full_name, email, phone, account_status) VALUES
    ('Dr. Slim', 'slim@giu.example', '+20-100-555-0101', 'Active'),
    ('Dr. Caroline', 'caroline@giu.example', '+20-100-555-0102', 'Active'),
    ('Dr. John', 'john@giu.example', '+20-100-555-0103', 'Active'),
    ('Dr. Karim', 'karim@giu.example', '+20-100-555-0104', 'Active'),
    ('Dr. Maggie', 'maggie@giu.example', '+20-100-555-0105', 'Active'),
    ('Dr. Amal', 'amal@giu.example', '+20-100-555-0106', 'Active'),
    ('Dr. Mohamed', 'mohamed@giu.example', '+20-100-555-0107', 'Active'),
    ('Mariam Hassan', 'mariam.hassan@student.example', '+20-100-555-0201', 'Active'),
    ('Omar Adel', 'omar.adel@student.example', '+20-100-555-0202', 'Active'),
    ('Youssef Nabil', 'youssef.nabil@student.example', '+20-100-555-0203', 'Active'),
    ('Laila Mahmoud', 'laila.mahmoud@student.example', '+20-100-555-0204', 'Active'),
    ('Adam Samir', 'adam.samir@student.example', '+20-100-555-0205', 'Active'),
    ('Prof. Anna Weber', 'anna.weber@partner.example', '+49-151-555-0301', 'Active'),
    ('Prof. Lukas Schneider', 'lukas.schneider@partner.example', '+49-151-555-0302', 'Active'),
    ('Prof. Emma Fischer', 'emma.fischer@partner.example', '+49-151-555-0303', 'Active'),
    ('Prof. Noah Wagner', 'noah.wagner@partner.example', '+49-151-555-0304', 'Active'),
    ('Prof. Mia Becker', 'mia.becker@partner.example', '+49-151-555-0305', 'Active'),
    ('Sara Ibrahim', 'sara.ibrahim@company.example', '+20-100-555-0401', 'Active'),
    ('Ahmed Farouk', 'ahmed.farouk@company.example', '+20-100-555-0402', 'Active'),
    ('Nour Hassan', 'nour.hassan@company.example', '+20-100-555-0403', 'Active'),
    ('Hany Mostafa', 'hany.mostafa@company.example', '+20-100-555-0404', 'Active'),
    ('Mona Khaled', 'mona.khaled@company.example', '+20-100-555-0405', 'Active');

    INSERT INTO Student (person_id, student_no, current_semester, gpa, language_level, cv, program_id) VALUES
    (8, 'GIU2026-001', 5, 3.65, 'German B2, English C1', 'CV_Mariam_Hassan.pdf', 1),
    (9, 'GIU2026-002', 6, 3.42, 'German B1, English B2', 'CV_Omar_Adel.pdf', 2),
    (10, 'GIU2026-003', 4, 3.78, 'German B2, English B2', 'CV_Youssef_Nabil.pdf', 3),
    (11, 'GIU2026-004', 7, 3.21, 'German C1, English C1', 'CV_Laila_Mahmoud.pdf', 4),
    (12, 'GIU2026-005', 5, 3.88, 'German B2, English C1', 'CV_Adam_Samir.pdf', 5);

    INSERT INTO Student_Interest (person_id, interest) VALUES
    (8, 'Artificial intelligence'),
    (9, 'Robotics'),
    (10, 'Business analytics'),
    (11, 'Sustainable architecture'),
    (12, 'Internet of Things');

    INSERT INTO GIU_Academic (person_id, academic_rank, dept_id) VALUES
    (1, 'Professor', 1),
    (2, 'Associate Professor', 1),
    (3, 'Assistant Professor', 2),
    (4, 'Associate Professor', 3),
    (5, 'Professor', 4),
    (6, 'Assistant Professor', 5),
    (7, 'Associate Professor', 1);

    INSERT INTO Partner_Professor (person_id, title, pdept_id) VALUES
    (13, 'Professor', 1),
    (14, 'Associate Professor', 2),
    (15, 'Professor', 3),
    (16, 'Assistant Professor', 4),
    (17, 'Professor', 5);

    INSERT INTO Company_Rep (person_id, company_name, sector, position, location) VALUES
    (18, 'Siemens', 'Industrial Technology', 'Research Liaison', 'Cairo, Egypt'),
    (19, 'Bosch', 'Engineering and Technology', 'University Relations Manager', 'Stuttgart, Germany'),
    (20, 'SAP', 'Enterprise Software', 'Early Careers Coordinator', 'Walldorf, Germany'),
    (21, 'BMW Group', 'Automotive', 'Industry Partnership Officer', 'Munich, Germany'),
    (22, 'Infineon Technologies', 'Semiconductors', 'Talent Acquisition Specialist', 'Munich, Germany');

    INSERT INTO Interviewer (role, person_id) VALUES
    ('Thesis Interview Panel Member', 1),
    ('Academic Interviewer', 2),
    ('Program Interviewer', 3),
    ('Research Interviewer', 4),
    ('Faculty Interviewer', 5);

    INSERT INTO Topic_Provider (person_id) VALUES
    (1),
    (13),
    (18),
    (2),
    (14);

    INSERT INTO Notification (message, [timestamp], category, urgency, read_status, recipient_id) VALUES
    ('Your application has been received and is awaiting review.', '2026-10-08T09:00:00', 'Status Change', 'Normal', 0, 8),
    ('The application deadline for the winter research program is approaching.', '2026-10-12T10:30:00', 'Deadline', 'High', 0, 9),
    ('Your application decision is now available.', '2026-10-18T14:15:00', 'Status Change', 'Normal', 1, 10),
    ('A new academic opportunity may match your program.', '2026-10-20T11:45:00', 'Offer', 'Low', 0, 11),
    ('A visit agenda has been added for the upcoming professor visit.', '2026-10-22T16:00:00', 'Visit Agenda', 'Normal', 1, 12);

    INSERT INTO Cooperation_Agreement (title, scope, start_date, end_date, status, partner_uni_id, coordinator_id) VALUES
    ('TUM Student Mobility Agreement', 'Student exchange and double-degree cooperation in computing and engineering.', '2025-01-01', '2030-12-31', 'Active', 2, 1),
    ('Stuttgart Mobility Agreement', 'Semester exchange and academic mobility in mechatronics and engineering.', '2025-02-01', '2030-12-31', 'Active', 3, 2),
    ('Ulm Mobility Agreement', 'Student mobility and credit recognition in business informatics and applied sciences.', '2025-03-01', '2030-12-31', 'Active', 4, 3),
    ('TU Berlin Mobility Agreement', 'Exchange and double-degree pathways in architecture and computing.', '2025-04-01', '2030-12-31', 'Active', 5, 4),
    ('RWTH Mobility Agreement', 'Academic exchange in electrical engineering and embedded systems.', '2025-05-01', '2030-12-31', 'Active', 6, 5),
    ('TUM Joint Research Agreement', 'Joint research in artificial intelligence and machine learning.', '2025-01-01', '2030-12-31', 'Active', 2, 1),
    ('Stuttgart Joint Research Agreement', 'Collaborative research in robotics and autonomous systems.', '2025-02-01', '2030-12-31', 'Active', 3, 2),
    ('Ulm Joint Research Agreement', 'Collaborative research in business analytics and information systems.', '2025-03-01', '2030-12-31', 'Active', 4, 3),
    ('TU Berlin Joint Research Agreement', 'Collaborative research in sustainable architecture and urban design.', '2025-04-01', '2030-12-31', 'Active', 5, 4),
    ('RWTH Joint Research Agreement', 'Collaborative research in embedded systems and Internet of Things.', '2025-05-01', '2030-12-31', 'Active', 6, 5),
    ('TUM General Memorandum of Understanding', 'General academic collaboration and knowledge exchange.', '2025-01-01', '2030-12-31', 'Active', 2, 1),
    ('Stuttgart General Memorandum of Understanding', 'General cooperation in teaching, workshops and academic visits.', '2025-02-01', '2030-12-31', 'Active', 3, 2),
    ('Ulm General Memorandum of Understanding', 'General academic cooperation and student development.', '2025-03-01', '2030-12-31', 'Active', 4, 3),
    ('TU Berlin General Memorandum of Understanding', 'General cooperation in design, architecture and research.', '2025-04-01', '2030-12-31', 'Active', 5, 4),
    ('RWTH General Memorandum of Understanding', 'General cooperation in engineering education and research.', '2025-05-01', '2030-12-31', 'Active', 6, 5);

    INSERT INTO Opportunity (title, description, type, status, app_open_date, app_close_date, capacity, location_mode, agreement_id, offered_by_rep_id) VALUES
    ('AI-Based Thesis Research', 'Bachelor thesis on explainable machine learning for academic applications.', 'Thesis Topic', 'Open', '2026-09-01', '2026-12-15', 5, 'Hybrid', 6, NULL),
    ('Robotics Control Thesis', 'Bachelor thesis on control algorithms for autonomous mobile robots.', 'Thesis Topic', 'Open', '2026-09-01', '2026-12-15', 5, 'Germany', 7, NULL),
    ('Industrial IoT Thesis Placement', 'Industry-linked thesis on sensor data and predictive maintenance.', 'Thesis Topic', 'Open', '2026-09-01', '2026-12-15', 4, 'Germany', 8, 18),
    ('Sustainable Campus Design Thesis', 'Bachelor thesis on energy-efficient university buildings.', 'Thesis Topic', 'Closed', '2026-08-01', '2026-10-15', 4, 'Egypt', 9, NULL),
    ('Business Analytics Thesis', 'Thesis topic on data-driven planning for international cooperation.', 'Thesis Topic', 'Cancelled', '2026-09-01', '2026-12-15', 3, 'Online', 10, NULL),
    ('GIU Winter Data Science School', 'Short academic program with workshops in data science and AI.', 'Short Program', 'Open', '2026-09-01', '2026-12-15', 20, 'Egypt', 11, NULL),
    ('Ulm Embedded Systems Workshop', 'Short program with practical sessions on embedded computing.', 'Short Program', 'Open', '2026-09-01', '2026-12-15', 15, 'Germany', 12, NULL),
    ('Berlin Sustainable Design Studio', 'Short program on sustainable architecture and urban design.', 'Short Program', 'Open', '2026-09-01', '2026-12-15', 15, 'Germany', 13, NULL),
    ('Business Informatics Summer School', 'Short program focused on digital transformation and business analytics.', 'Short Program', 'Open', '2026-09-01', '2026-12-15', 18, 'Hybrid', 14, NULL),
    ('Engineering Innovation Workshop', 'Short program on electronics, prototyping and engineering design.', 'Short Program', 'Closed', '2026-08-01', '2026-10-15', 12, 'Germany', 15, NULL),
    ('Computer Science Semester Exchange', 'One-semester mobility program between GIU and a German partner university.', 'Mobility Program', 'Open', '2026-09-01', '2026-12-15', 10, 'Germany', 1, NULL),
    ('Mechatronics Student Exchange', 'Semester mobility focused on automation and mechatronics.', 'Mobility Program', 'Open', '2026-09-01', '2026-12-15', 10, 'Germany', 2, NULL),
    ('Business Informatics Exchange', 'Student mobility with courses in information systems and analytics.', 'Mobility Program', 'Open', '2026-09-01', '2026-12-15', 10, 'Germany', 3, NULL),
    ('Architecture Exchange Semester', 'Mobility program with architecture and sustainability electives.', 'Mobility Program', 'Open', '2026-09-01', '2026-12-15', 10, 'Germany', 4, NULL),
    ('Electrical Engineering Exchange', 'Student mobility focused on embedded systems and electronics.', 'Mobility Program', 'Open', '2026-09-01', '2026-12-15', 10, 'Germany', 5, NULL);

    INSERT INTO Opp_Language_Req (opp_id, language_req) VALUES
    (1, 'English B2'),
    (2, 'German B1'),
    (3, 'English B2'),
    (6, 'English B2'),
    (11, 'German B2');

    INSERT INTO Opp_Relevant_Date (opp_id, relevant_date) VALUES
    (1, '2027-02-01'),
    (2, '2027-02-15'),
    (3, '2027-03-01'),
    (6, '2026-11-01'),
    (11, '2026-10-01');

    INSERT INTO Thesis_Topic (opp_id, expected_outcomes, funding_info, travel_info, accommodation_info, provider_id, supervisor_id, co_supervisor_id) VALUES
    (1, 'A tested explainable machine-learning model and a documented evaluation.', 'Research materials funded by the project.', 'Local travel to GIU when required.', 'No accommodation required for the hybrid project.', 1, 1, 13),
    (2, 'A simulation and evaluation of autonomous robot control methods.', 'No dedicated funding; standard thesis resources are available.', 'Travel to the German partner laboratory may be arranged.', 'Partner university guest accommodation subject to availability.', 13, 2, 14),
    (3, 'A prototype and report for predictive maintenance using industrial sensor data.', 'Possible company-supported equipment and materials.', 'Travel to the company site in Germany may be required.', 'Accommodation details coordinated after selection.', 18, 3, 15),
    (4, 'An energy-performance assessment and sustainable design proposal.', NULL, 'Local site visits in Egypt may be required.', NULL, 2, 4, 16),
    (5, 'A business analytics model and recommendations for cooperation planning.', 'Funding not currently available.', NULL, NULL, 14, 5, 17);

    INSERT INTO Short_Program (opp_id, duration, location, hosting_arrangements, host_uni_id) VALUES
    (6, 'Two weeks', 'New Administrative Capital, Egypt', 'GIU classrooms, computer laboratories and academic workshops.', 1),
    (7, 'One week', 'Stuttgart, Germany', 'Partner department laboratories and seminar rooms.', 3),
    (8, 'Two weeks', 'Ulm, Germany', 'Design studios and guided sustainable-building visits.', 4),
    (9, 'Ten days', 'Berlin, Germany', 'Partner university lecture rooms and business analytics labs.', 5),
    (10, 'Five days', 'Aachen, Germany', 'Engineering laboratories and supervised prototyping sessions.', 6);

    INSERT INTO Mobility_Program
    (opp_id, mobility_type, duration, sending_uni_id, host_uni_id) VALUES
    (11, 'Semester Exchange', 'One semester', 1, 2),
    (12, 'Double Degree', 'Two academic years', 1, 3),
    (13, 'Semester Exchange', 'One semester', 1, 4),
    (14, 'Double Degree', 'Two semesters', 1, 5),
    (15, 'Semester Exchange', 'One academic year', 1, 6);

    INSERT INTO Application (app_date, status, decision_date, info, student_id, opp_id) VALUES
    ('2026-10-05', 'Accepted', '2026-10-20', 'Interested in explainable AI and its application to academic services.', 8, 1),
    ('2026-10-06', 'Rejected', '2026-10-22', 'Interested in robotics control and autonomous systems.', 9, 2),
    ('2026-10-07', 'Pending', NULL, 'Interested in industrial IoT and predictive maintenance.', 12, 3),
    ('2026-10-08', 'Withdrawn', '2026-10-18', 'Application withdrawn by the student before a final selection.', 11, 4),
    ('2026-10-09', 'Rejected', '2026-10-23', 'Interested in business analytics and international cooperation.', 10, 5),
    ('2026-10-05', 'Accepted', '2026-10-19', 'Applying for the data science winter school.', 8, 6),
    ('2026-10-06', 'Accepted', '2026-10-20', 'Applying for practical embedded systems training.', 9, 7),
    ('2026-10-07', 'Accepted', '2026-10-21', 'Applying for the sustainable design studio.', 10, 8),
    ('2026-10-08', 'Accepted', '2026-10-22', 'Applying for business informatics and analytics workshops.', 11, 9),
    ('2026-10-09', 'Accepted', '2026-10-23', 'Applying for engineering prototyping workshops before the application period closed.', 12, 10),
    ('2026-10-05', 'Accepted', '2026-10-19', 'Applying for a computer science semester abroad.', 8, 11),
    ('2026-10-06', 'Accepted', '2026-10-20', 'Applying for a mechatronics semester abroad.', 9, 12),
    ('2026-10-07', 'Accepted', '2026-10-21', 'Applying for a business informatics semester abroad.', 10, 13),
    ('2026-10-08', 'Accepted', '2026-10-22', 'Applying for an architecture semester abroad.', 11, 14),
    ('2026-10-09', 'Accepted', '2026-10-23', 'Applying for an electrical engineering semester abroad.', 12, 15);

    INSERT INTO Application_Document (app_id, doc_type, file_ref, upload_date) VALUES
    (1, 'CV', 'uploads/app001/cv_mariam.pdf', '2026-10-05'),
    (2, 'Transcript', 'uploads/app002/transcript_omar.pdf', '2026-10-06'),
    (3, 'Motivation Letter', 'uploads/app003/motivation_adam.pdf', '2026-10-07'),
    (4, 'Language Certificate', 'uploads/app004/german_certificate_laila.pdf', '2026-10-08'),
    (5, 'CV', 'uploads/app005/cv_youssef.pdf', '2026-10-09');

    INSERT INTO Mobility_Agreement (agreement_id, exchange_terms, double_degree_terms, seat_quota, tuition_arrangement) VALUES
    (1, 'One-semester exchange with pre-approved course selection.', 'Eligible students may apply to the designated double-degree pathway.', 10, 'Students remain responsible for GIU tuition; host tuition is waived under the agreement.'),
    (2, 'One-semester exchange in mechatronics and engineering.', 'Double-degree progression subject to academic approval.', 10, 'Tuition remains payable to the home institution.'),
    (3, 'One-semester exchange in business informatics.', 'Double-degree pathway available after credit and curriculum review.', 8, 'Host tuition waived for nominated exchange students.'),
    (4, 'One-semester exchange in architecture and design.', 'Double-degree terms governed by the approved joint study plan.', 8, 'Home-institution tuition arrangement applies.'),
    (5, 'One-semester exchange in electrical engineering.', 'Double-degree option subject to department-level approval.', 8, 'Tuition and fees follow the mobility agreement.');

    INSERT INTO Mob_Agr_Semester (agreement_id, semester) VALUES
    (1, 'Fall'),
    (2, 'Spring'),
    (3, 'Fall'),
    (4, 'Spring'),
    (5, 'Fall');

    INSERT INTO Research_Agreement (agreement_id, ip_terms, funding_framework) VALUES
    (6, 'Background intellectual property remains with its owner; new IP is jointly reviewed.', 'Joint applications to AI and digital research grant programs.'),
    (7, 'Project-specific IP ownership is agreed by both institutions before publication.', 'Shared laboratory resources and eligible research grant applications.'),
    (8, 'Research data and software are shared under the approved collaboration terms.', 'Joint funding applications for business analytics research.'),
    (9, 'Design outputs and research findings are jointly reviewed before dissemination.', 'Partner-supported research and sustainability grant applications.'),
    (10, 'Embedded software and device IP are governed by a project-specific agreement.', 'Joint applications for electronics and mobility-related research funding.');

    INSERT INTO General_MoU (agreement_id, intent, collab_scope, renewal_terms) VALUES
    (11, 'Establish broad academic links between GIU and TUM.', 'Teaching collaboration, student exchange, research seminars and academic visits.', 'Review during the final six months and renew by mutual written agreement.'),
    (12, 'Support long-term academic cooperation with the University of Stuttgart.', 'Workshops, academic visits, research networking and student development.', 'Renewal subject to a joint review by both international offices.'),
    (13, 'Promote academic cooperation with Ulm University.', 'Short programs, guest lectures, research networking and student activities.', 'Renew for a further term after a positive annual review.'),
    (14, 'Develop academic and research links with TU Berlin.', 'Architecture and computing workshops, visits and collaborative activities.', 'Renewal requires written approval from both institutions.'),
    (15, 'Strengthen cooperation with RWTH Aachen University.', 'Engineering education, research exchange and specialist workshops.', 'Review before expiry and renew by mutual consent.');

    INSERT INTO Funding_Opportunity (name, agency, type, amount, deadline, eligibility_conditions, status) VALUES
    ('Joint AI Research Seed Grant', 'GIU Research Support Office', 'Research Grant', 25000.00, '2027-03-31', 'Joint GIU and German partner research team with an approved research plan.', 'Open'),
    ('German Mobility Support Fund', 'International Academic Mobility Fund', 'Mobility Fund', 8000.00, '2027-02-15', 'Nominated GIU students accepted to an eligible mobility program.', 'Open'),
    ('Academic Excellence Scholarship', 'GIU Student Support Office', 'Scholarship', 5000.00, '2027-01-31', 'Eligible student with satisfactory academic standing and a complete application.', 'Open'),
    ('Sustainable Engineering Research Grant', 'Partner University Research Council', 'Research Grant', 40000.00, '2026-10-31', 'Joint project in sustainable engineering with partner participation.', 'Closed'),
    ('Short Program Travel Fund', 'GIU International Office', 'Mobility Fund', 3000.00, '2027-04-30', 'Student accepted to an approved short academic program.', 'Open');

    INSERT INTO Interview ([date], [time], location_mode, outcome, notes, app_id) VALUES
    ('2026-10-14', '10:00:00', 'Online', 'Recommended', 'Strong understanding of machine-learning fundamentals.', 1),
    ('2026-10-15', '11:00:00', 'Online', 'Not Recommended', 'Candidate needs stronger preparation in control theory.', 2),
    ('2026-10-16', '12:00:00', 'GIU Campus', 'Pending', 'Technical discussion completed; final evaluation pending.', 3),
    ('2026-10-17', '13:00:00', 'Online', 'Recommended', 'Good motivation and relevant preparation for the business program.', 5),
    ('2026-10-18', '14:00:00', 'GIU Campus', 'Recommended', 'Suitable preparation for the short-program activities.', 6);

    INSERT INTO Participation (status, start_date, end_date, app_id)
    VALUES
    ('Completed', '2026-11-01', '2026-11-14', 6),
    ('Completed', '2026-11-05', '2026-11-12', 7),
    ('Active',    '2026-11-10', '2026-11-24', 8),
    ('Active',    '2026-11-12', '2026-11-22', 9),
    ('Completed', '2026-11-15', '2026-11-19', 10),
    ('Active', '2026-11-01', '2027-03-31', 11),
    ('Active', '2026-11-05', '2028-06-30', 12),
    ('Active', '2026-11-10', '2027-04-10', 13),
    ('Active', '2026-11-12', '2027-06-30', 14),
    ('Active', '2026-11-15', '2027-11-14', 15);

    INSERT INTO Mobility (part_id, pre_travel_status, during_status, post_status, final_outcome, host_uni_id) VALUES
    (6, 'Documents approved', 'Arrived at host university', 'Not yet completed', 'Mobility in progress', 2),
    (7, 'Visa approved', 'Attending host courses', 'Not yet completed', 'Mobility in progress', 3),
    (8, 'Travel confirmed', 'Registered at host university', 'Not yet completed', 'Mobility in progress', 4),
    (9, 'Pre-departure briefing completed', 'Attending design studio', 'Not yet completed', 'Mobility in progress', 5),
    (10, 'Travel documents verified', 'Attending engineering courses', 'Not yet completed', 'Mobility in progress', 6);

    INSERT INTO Program_Participation (part_id, payment_status, visa_status, travel_status) VALUES
    (1, 'Paid', 'Not Required', 'Arranged'),
    (2, 'Paid', 'Approved', 'Booked'),
    (3, 'Pending', 'Approved', 'Not Booked'),
    (4, 'Paid', 'Approved', 'Booked'),
    (5, 'Paid', 'Not Required', 'Arranged');

    INSERT INTO Course_Equivalency (part_id, host_course_title, host_credits, transferred_credits, approval_status, giu_course_id) VALUES
    (6, 'Introduction to Machine Learning', 5.0, 3.0, 'Approved', 5),
    (7, 'Robotics and Automation', 6.0, 3.0, 'Pending', 10),
    (8, 'Business Intelligence', 5.0, 3.0, 'Approved', 14),
    (9, 'Sustainable Building Design', 5.0, 3.0, 'Rejected', 19),
    (10, 'Embedded Computing Systems', 6.0, 3.0, 'Approved', 25);

    INSERT INTO Professor_Visit (start_date, end_date, purpose, travel_arr, accommodation_arr, status, follow_up_report, partner_prof_id, host_faculty_id, coordinator_id, agreement_id) VALUES
    ('2026-12-01', '2026-12-05', 'Research meetings on explainable artificial intelligence.', 'Return flight arranged by the visitor.', 'GIU guest accommodation requested.', 'Requested', NULL, 13, 1, 1, 11),
    ('2026-11-18', '2026-11-22', 'Guest lectures and robotics laboratory collaboration.', 'Travel itinerary shared with the coordinator.', 'Partner hotel reservation confirmed.', 'Active', NULL, 14, 2, 2, 12),
    ('2027-01-12', '2027-01-16', 'Workshop on business analytics and information systems.', 'Flight details confirmed.', 'University guest house reserved.', 'Requested', NULL, 15, 3, 3, 13),
    ('2026-10-20', '2026-10-24', 'Academic visit on sustainable architecture.', 'Travel completed.', 'Accommodation provided by GIU.', 'Completed', 'Delivered a lecture and agreed on a joint student workshop.', 16, 4, 4, 14),
    ('2027-02-02', '2027-02-06', 'Research discussions on embedded systems and IoT.', 'Travel booking pending approval.', 'Accommodation request submitted.', 'Requested', NULL, 17, 5, 5, 15);

    INSERT INTO Visit_Outcome (visit_id, outcome) VALUES
    (1, 'Research collaboration topics identified and follow-up meeting requested.'),
    (2, 'Guest lecture delivered and laboratory exchange planned.'),
    (3, 'Joint business analytics workshop proposed.'),
    (4, 'Lecture delivered and student workshop agreed.'),
    (5, 'Initial plan for embedded systems collaboration prepared.');

    INSERT INTO Agenda_Item (visit_id, seq_no, activity_type, title, date_time, location, audience) VALUES
    (1, 1, 'Meeting', 'AI Research Coordination Meeting', '2026-12-01T10:00:00', 'GIU Meeting Room 1', 'GIU academics and visiting professor'),
    (2, 1, 'Lecture', 'Robotics and Autonomous Systems Guest Lecture', '2026-11-19T11:00:00', 'Engineering Lecture Hall', 'Mechatronics students and faculty'),
    (3, 1, 'Workshop', 'Business Analytics Research Workshop', '2027-01-13T09:30:00', 'Business Informatics Lab', 'Students and academic staff'),
    (4, 1, 'Lecture', 'Sustainable Architecture Seminar', '2026-10-21T12:00:00', 'Architecture Studio', 'Architecture students and faculty'),
    (5, 1, 'Meeting', 'Embedded Systems Collaboration Planning', '2027-02-03T10:30:00', 'Electrical Engineering Meeting Room', 'Electrical engineering researchers');

    INSERT INTO Research_Project (title, description, status, start_date, end_date, res_agreement_id) VALUES
    ('Explainable AI for Academic Decision Support', 'Joint research project developing interpretable machine-learning methods for academic decision support.', 'Active', '2026-01-01', '2027-12-31', 6),
    ('Autonomous Robotics for Smart Laboratories', 'Joint research on sensing, control and autonomous navigation for laboratory robots.', 'Active', '2026-02-01', '2027-11-30', 7),
    ('Data Analytics for International Education', 'Research project studying data-driven methods for evaluating academic mobility and cooperation.', 'Active', '2026-03-01', '2027-10-31', 8),
    ('Energy-Efficient University Buildings', 'Joint evaluation of sustainable building strategies for university facilities.', 'Completed', '2025-09-01', '2026-09-30', 9),
    ('IoT Monitoring for Industrial Equipment', 'Research on embedded sensors and connected devices for equipment monitoring.', 'Active', '2026-04-01', '2027-12-15', 10);

    INSERT INTO Research_Output (type, title, [date], reference, status, project_id) VALUES
    ('Publication', 'Interpretable Models for Academic Decision Support', '2026-08-15', 'GIU-RES-2026-001', 'Published', 1),
    ('Deliverable', 'Autonomous Robot Navigation Prototype', '2026-09-20', 'GIU-RES-2026-002', 'Pending', 2),
    ('Dataset', 'Anonymized Academic Mobility Indicators Dataset', '2026-07-10', 'GIU-RES-2026-003', 'Published', 3),
    ('Report', 'Energy Performance Assessment of a University Building', '2026-09-25', 'GIU-RES-2026-004', 'Published', 4),
    ('Publication', 'Low-Power IoT Monitoring Architecture', '2026-10-05', 'GIU-RES-2026-005', 'Pending', 5);

    INSERT INTO Project_Deadline (project_id, deadline) VALUES
    (1, '2027-03-31'),
    (2, '2027-04-15'),
    (3, '2027-05-01'),
    (4, '2026-08-31'),
    (5, '2027-06-15');

    INSERT INTO Opp_Field (opp_id, field_id) VALUES
    (1, 1),
    (2, 2),
    (3, 5),
    (4, 4),
    (5, 3);

    INSERT INTO Opp_Eligible_Program (opp_id, program_id) VALUES
    (1, 1),
    (2, 2),
    (3, 5),
    (4, 4),
    (5, 3);

    INSERT INTO Opp_Prereq_Course (opp_id, course_id) VALUES
    (1, 1),
    (2, 6),
    (3, 21),
    (4, 16),
    (5, 11);

    INSERT INTO Opp_Skill (opp_id, skill_id) VALUES
    (1, 1),
    (2, 2),
    (3, 5),
    (4, 4),
    (5, 3);

    INSERT INTO Res_Agr_Area (agreement_id, area_id) VALUES
    (6, 1),
    (7, 2),
    (8, 3),
    (9, 4),
    (10, 5);

    INSERT INTO Thesis_Area (opp_id, area_id) VALUES
    (1, 1),
    (2, 2),
    (3, 5),
    (4, 4),
    (5, 3);

    INSERT INTO Conducts_Interview (interviewer_id, interview_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

    INSERT INTO Project_Area (project_id, area_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

    INSERT INTO GIU_Participates (academic_id, project_id, role) VALUES
    (1, 1, 'Principal Investigator'),
    (2, 2, 'Principal Investigator'),
    (3, 3, 'Principal Investigator'),
    (4, 4, 'Principal Investigator'),
    (5, 5, 'Principal Investigator');

    INSERT INTO PP_Participates (partner_prof_id, project_id, role) VALUES
    (13, 1, 'Co-Investigator'),
    (14, 2, 'Research Collaborator'),
    (15, 3, 'Research Collaborator'),
    (16, 4, 'Research Collaborator'),
    (17, 5, 'Co-Investigator');

    INSERT INTO Project_Targets_Fund (project_id, fund_id) VALUES
    (1, 1),
    (2, 4),
    (3, 1),
    (4, 4),
    (5, 5);

    INSERT INTO Fund_Supports_Mobility (fund_id, part_id) VALUES
    (2, 6),
    (3, 7),
    (5, 8),
    (2, 9),
    (5, 10);

    INSERT INTO GIU_Interest (academic_id, area_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

    INSERT INTO PP_Interest (partner_prof_id, area_id) VALUES
    (13, 1),
    (14, 2),
    (15, 3),
    (16, 4),
    (17, 5);

    INSERT INTO Partner_Program_Field (pprog_id, field_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

    INSERT INTO Mob_Agr_Program (agreement_id, program_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

    INSERT INTO Prerequisite (course_id, prereq_course_id) VALUES
    (2, 1),
    (7, 6),
    (12, 11),
    (17, 16),
    (22, 21);

    INSERT INTO Program_Field (program_id, field_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5);

    INSERT INTO Completed_Course (student_id, course_id) VALUES
    (8, 1),
    (9, 6),
    (10, 11),
    (11, 16),
    (12, 21);

    INSERT INTO Student_Skill (student_id, skill_id) VALUES
    (8, 1),
    (9, 2),
    (10, 3),
    (11, 4),
    (12, 5);