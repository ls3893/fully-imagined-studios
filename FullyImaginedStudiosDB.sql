-- DROP TABLES [Jacob Lesher]

DROP TABLE "ORDER" CASCADE CONSTRAINTS;
DROP TABLE PAYMENT CASCADE CONSTRAINTS;
DROP TABLE PROOF CASCADE CONSTRAINTS;
DROP TABLE CONTRACT CASCADE CONSTRAINTS;
DROP TABLE EVENT CASCADE CONSTRAINTS;
DROP TABLE PORTRAIT CASCADE CONSTRAINTS;
DROP TABLE JOB_ASSIGNMENT CASCADE CONSTRAINTS;
DROP TABLE INQUIRY_PACKAGE CASCADE CONSTRAINTS;
DROP TABLE APPOINTMENT CASCADE CONSTRAINTS;
DROP TABLE INQUIRY CASCADE CONSTRAINTS;
DROP TABLE PHOTOGRAPHER CASCADE CONSTRAINTS;
DROP TABLE FREELANCE_PHOTOGRAPHER CASCADE CONSTRAINTS;
DROP TABLE JOB CASCADE CONSTRAINTS;
DROP TABLE PACKAGE CASCADE CONSTRAINTS;
DROP TABLE STAFF CASCADE CONSTRAINTS;
DROP TABLE CLIENT CASCADE CONSTRAINTS;


-- CREATE TABLES

-- Create the CLIENT table [Jacob Lesher]
CREATE TABLE CLIENT (
    ClientID            NUMBER(10) NOT NULL,
    CLIType             VARCHAR2(20) NOT NULL,
    CLIFirstName        VARCHAR2(50) NOT NULL,
    CLILastName         VARCHAR2(50) NOT NULL,
    CLICompanyName      VARCHAR2(100) NOT NULL,
    CLIPhoneNumber      VARCHAR2(20) NOT NULL,
    CLIEmailAddress     VARCHAR2(100) NOT NULL,
    CLIStreetAddress    VARCHAR2(100) NOT NULL,
    CLICity             VARCHAR2(50) NOT NULL,
    CLIState            VARCHAR2(2) NOT NULL,
    CLIZipCode          VARCHAR2(10) NOT NULL,
    
    CONSTRAINT client_pk PRIMARY KEY (ClientID),
    CONSTRAINT client_id_ck CHECK (ClientID > 0),
    CONSTRAINT client_type_ck CHECK (CLIType IN ('Individual', 'Corporate')),
    CONSTRAINT client_phone_ck CHECK (LENGTH(CLIPhoneNumber) = 12 AND CLIPhoneNumber LIKE '___-___-____'),
    CONSTRAINT client_email_ck CHECK (CLIEmailAddress LIKE '%_@_%._%'),
    CONSTRAINT client_state_ck CHECK (LENGTH(CLIState) = 2),
    CONSTRAINT client_zip_ck CHECK (LENGTH(CLIZipCode) = 5)
);

-- Create the STAFF table [Jacob Lesher]
CREATE TABLE STAFF (
    StaffID             NUMBER(10) NOT NULL,
    STAFirstName        VARCHAR2(50) NOT NULL,
    STALastName         VARCHAR2(50) NOT NULL,
    STAPhoneNumber      VARCHAR2(20) NOT NULL,
    STAEmailAddress     VARCHAR2(100) NOT NULL,
    STAType             VARCHAR2(30) NOT NULL,
    
    CONSTRAINT staff_pk PRIMARY KEY (StaffID),
    CONSTRAINT staff_id_ck CHECK (StaffID > 0),
    CONSTRAINT staff_type_ck CHECK (STAType IN ('Photographer', 'Freelance Photographer','Office Manager')),
    CONSTRAINT staff_email_ck CHECK (STAEmailAddress LIKE '%_@_%._%'),
    CONSTRAINT staff_phone_ck CHECK (LENGTH(STAPhoneNumber) = 12 AND STAPhoneNumber LIKE '___-___-____')
);

-- Create the PACKAGE table [Jacob Lesher]
CREATE TABLE PACKAGE (
    PackageID           NUMBER(10) NOT NULL,
    PACDescription      VARCHAR2(500) NOT NULL,
    
    CONSTRAINT package_pk PRIMARY KEY (PackageID),
    CONSTRAINT package_id_ck CHECK (PackageID > 0)
);

-- Create the JOB table [Jacob Lesher]
CREATE TABLE JOB (
    JobID               NUMBER(10) NOT NULL,
    JobType             VARCHAR2(30) NOT NULL,
    JobEventDate        DATE NOT NULL,
    JobStartTime        VARCHAR2(8) NOT NULL,
    JobEndTime          VARCHAR2(8) NOT NULL,
    JobEventLocation    VARCHAR2(100) NOT NULL,
    
    CONSTRAINT job_pk PRIMARY KEY (JobID),
    CONSTRAINT job_id_ck CHECK (JobID > 0),
    CONSTRAINT job_type_ck CHECK (JobType IN ('Event', 'Portrait')),
    CONSTRAINT job_start_time_ck CHECK (JobStartTime LIKE '__:__'),
    CONSTRAINT job_end_time_ck CHECK (JobEndTime LIKE '__:__')
);

-- Create the INQUIRY table [Jacob Lesher]
CREATE TABLE INQUIRY (
    InquiryID                   NUMBER(10) NOT NULL,
    INQDate                     DATE DEFAULT SYSDATE NOT NULL,
    INQRequestedServiceType     VARCHAR2(50) NOT NULL,
    INQRequestedLocation        VARCHAR2(100) NOT NULL,
    INQRequestedDate            DATE NOT NULL,
    INQStartTime                VARCHAR2(8) NOT NULL,
    INQEndTime                  VARCHAR2(8) NOT NULL,
    INQEstimatedPrice           NUMBER(10,2),
    PackageID                   NUMBER(10) NOT NULL,
    ClientID                    NUMBER(10) NOT NULL,

    CONSTRAINT inquiry_pk PRIMARY KEY (InquiryID),
    CONSTRAINT inquiry_id_ck CHECK (InquiryID > 0),
    CONSTRAINT inquiry_service_ck CHECK (INQRequestedServiceType IN ('Event', 'Portrait')),
    CONSTRAINT inquiry_price_ck CHECK (INQEstimatedPrice > 0),
    CONSTRAINT inquiry_date_ck CHECK (INQRequestedDate > INQDate),
    CONSTRAINT inquiry_start_time_ck CHECK (INQStartTime LIKE '__:__'),
    CONSTRAINT inquiry_end_time_ck CHECK (INQEndTime LIKE '__:__'),
    CONSTRAINT inquiry_package_fk FOREIGN KEY (PackageID) REFERENCES PACKAGE(PackageID),
    CONSTRAINT inquiry_client_fk FOREIGN KEY (ClientID) REFERENCES CLIENT(ClientID)
);

-- Create the APPOINTMENT table [Jacob Lesher]
CREATE TABLE APPOINTMENT (
    AppointmentID       NUMBER(10) NOT NULL,
    APPDate             DATE NOT NULL,
    APPTime             VARCHAR2(8) NOT NULL,
    StaffID             NUMBER(10) NOT NULL,
    InquiryID           NUMBER(10) NOT NULL,

    CONSTRAINT appointment_pk PRIMARY KEY (AppointmentID),
    CONSTRAINT appointment_id_ck CHECK (AppointmentID > 0),
    CONSTRAINT appointment_staff_fk FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID),
    CONSTRAINT appointment_inquiry_fk FOREIGN KEY (InquiryID) REFERENCES INQUIRY(InquiryID)
);

-- Create the CONTRACT table [Jacob Lesher]
CREATE TABLE CONTRACT (
    ContractID              NUMBER(10) NOT NULL,
    CONDate                 DATE DEFAULT SYSDATE NOT NULL,
    CONDateMailed           DATE,
    CONDateSigned           DATE,
    CONAdditionalRequests   VARCHAR2(500),
    JobID                   NUMBER(10) NOT NULL,

    CONSTRAINT contract_pk PRIMARY KEY (ContractID),
    CONSTRAINT contract_id_ck CHECK (ContractID > 0),
    CONSTRAINT contract_mailed_ck CHECK (CONDateMailed IS NULL OR CONDateMailed >= CONDate),
    CONSTRAINT contract_signed_ck CHECK (CONDateSigned IS NULL OR (CONDateMailed IS NOT NULL AND CONDateSigned >= CONDateMailed)),
    CONSTRAINT contract_job_fk FOREIGN KEY (JobID) REFERENCES JOB(JobID)
);

-- Create the PROOF table [Jacob Lesher]
CREATE TABLE PROOF (
    ProofID             NUMBER(10) NOT NULL,
    PROStatus           VARCHAR2(30) DEFAULT 'Created' NOT NULL,
    JobID               NUMBER(10) NOT NULL,

    CONSTRAINT proof_pk PRIMARY KEY (ProofID),
    CONSTRAINT proof_id_ck CHECK (ProofID > 0),
    CONSTRAINT proof_status_ck CHECK (PROStatus IN ('Created', 'Presented', 'Under Review', 'Approved', 'Rejected')),
    CONSTRAINT proof_job_fk FOREIGN KEY (JobID) REFERENCES JOB(JobID)
);

-- Create the PAYMENT table [Jacob Lesher]
CREATE TABLE PAYMENT (
    PaymentID           NUMBER(10) NOT NULL,
    PAYDate             DATE DEFAULT SYSDATE NOT NULL,
    PAYAmount           NUMBER(10,2) NOT NULL,
    PAYType             VARCHAR2(30) NOT NULL,
    JobID               NUMBER(10) NOT NULL,

    CONSTRAINT payment_pk PRIMARY KEY (PaymentID),
    CONSTRAINT payment_id_ck CHECK (PaymentID > 0),
    CONSTRAINT payment_amount_ck CHECK (PAYAmount > 0),
    CONSTRAINT payment_type_ck CHECK (PAYType IN ('Deposit', 'Sitting', 'Proof', 'Final')),
    CONSTRAINT payment_job_fk FOREIGN KEY (JobID) REFERENCES JOB(JobID)
);

-- Create the ORDER table [Jacob Lesher]
-- ORDER is a reserved SQL keyword so the table name is quoted.
CREATE TABLE "ORDER" (
    OrderID                 NUMBER(10) NOT NULL,
    ORDDate                 DATE DEFAULT SYSDATE NOT NULL,
    ORDSpecialInstructions  VARCHAR2(500),
    JobID                   NUMBER(10) NOT NULL,
    PackageID               NUMBER(10) NOT NULL,

    CONSTRAINT order_pk PRIMARY KEY (OrderID),
    CONSTRAINT order_id_ck CHECK (OrderID > 0),
    CONSTRAINT order_job_fk FOREIGN KEY (JobID) REFERENCES JOB(JobID),
    CONSTRAINT order_package_fk FOREIGN KEY (PackageID) REFERENCES PACKAGE(PackageID)
);

-- Create the EVENT table [Jacob Lesher]
CREATE TABLE EVENT (
    EJobID              NUMBER(10) NOT NULL,
    EVEType             VARCHAR2(50) NOT NULL,

    CONSTRAINT event_pk PRIMARY KEY (EJobID),
    CONSTRAINT event_id_ck CHECK (EJobID > 0),
    CONSTRAINT event_type_ck CHECK (EVEType IN ('Wedding', 'Graduation', 'Awards Ceremony','Conference', 'Reception', 'Other')),
    CONSTRAINT event_job_fk FOREIGN KEY (EJobID) REFERENCES JOB(JobID)
);

-- Create the PORTRAIT table [Jacob Lesher]
CREATE TABLE PORTRAIT (
    PJobID              NUMBER(10) NOT NULL,
    PORType             VARCHAR2(50) NOT NULL,

    CONSTRAINT portrait_pk PRIMARY KEY (PJobID),
    CONSTRAINT portrait_id_ck CHECK (PJobID > 0),
    CONSTRAINT portrait_type_ck CHECK (PORType IN ('Individual', 'Family', 'Group')),
    CONSTRAINT portrait_job_fk FOREIGN KEY (PJobID) REFERENCES JOB(JobID)
);

-- Create the PHOTOGRAPHER table [Jacob Lesher]
CREATE TABLE PHOTOGRAPHER (
    PStaffID            NUMBER(10) NOT NULL,

    CONSTRAINT photographer_pk PRIMARY KEY (PStaffID),
    CONSTRAINT photographer_id_ck CHECK (PStaffID > 0),
    CONSTRAINT photographer_staff_fk FOREIGN KEY (PStaffID) REFERENCES STAFF(StaffID)
);

-- Create the FREELANCE_PHOTOGRAPHER table [Jacob Lesher]
CREATE TABLE FREELANCE_PHOTOGRAPHER (
    FStaffID            NUMBER(10) NOT NULL,

    CONSTRAINT freelance_photographer_pk PRIMARY KEY (FStaffID),
    CONSTRAINT freelance_id_ck CHECK (FStaffID > 0),
    CONSTRAINT freelance_staff_fk FOREIGN KEY (FStaffID) REFERENCES STAFF(StaffID)
);

-- Create the INQUIRY_PACKAGE table [Leslie Sintes]
CREATE TABLE INQUIRY_PACKAGE (
    PackageID           NUMBER(10) NOT NULL,
    InquiryID           NUMBER(10) NOT NULL,

    CONSTRAINT inquiry_package_pk PRIMARY KEY (PackageID, InquiryID),
    CONSTRAINT inquiry_package_package_ck CHECK (PackageID > 0),
    CONSTRAINT inquiry_package_inquiry_ck CHECK (InquiryID > 0),
    CONSTRAINT inquiry_package_package_fk FOREIGN KEY (PackageID) REFERENCES PACKAGE(PackageID),
    CONSTRAINT inquiry_package_inquiry_fk FOREIGN KEY (InquiryID) REFERENCES INQUIRY(InquiryID)
);

-- Create the JOB_ASSIGNMENT table [Leslie Sintes]
CREATE TABLE JOB_ASSIGNMENT (
    JobID               NUMBER(10) NOT NULL,
    StaffID             NUMBER(10) NOT NULL,
    JASRole             VARCHAR2(30) NOT NULL,

    CONSTRAINT job_assignment_pk PRIMARY KEY (JobID, StaffID),
    CONSTRAINT job_assignment_job_ck CHECK (JobID > 0),
    CONSTRAINT job_assignment_staff_ck CHECK (StaffID > 0),
    CONSTRAINT job_assignment_role_ck CHECK (JASRole IN ('Primary', 'Assistant')),
    CONSTRAINT job_assignment_job_fk FOREIGN KEY (JobID) REFERENCES JOB(JobID),
    CONSTRAINT job_assignment_staff_fk FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID)
);


-- INSERT RECORDS
-- Main tables: 10 records each [Jacob Lesher]

-- Load the CLIENT table
INSERT INTO CLIENT VALUES (1,'Individual','Olivia','Bennett','N/A','610-555-0101','olivia.bennett@email.com','14 Main Street','Allentown','PA','18101');
INSERT INTO CLIENT VALUES (2,'Individual','Liam','Carter','N/A','610-555-0102','liam.carter@email.com','28 Walnut Street','Bethlehem','PA','18018');
INSERT INTO CLIENT VALUES (3,'Corporate','Emma','Collins','Northstar Events','610-555-0103','emma@northstarevents.com','100 Hamilton Street','Allentown','PA','18101');
INSERT INTO CLIENT VALUES (4,'Individual','Noah','Mitchell','N/A','610-555-0104','noah.mitchell@email.com','45 Broad Street','Easton','PA','18042');
INSERT INTO CLIENT VALUES (5,'Corporate','Ava','Robinson','Keystone Consulting','610-555-0105','ava@keystoneconsulting.com','220 Main Street','Bethlehem','PA','18018');
INSERT INTO CLIENT VALUES (6,'Individual','Ethan','Turner','N/A','610-555-0106','ethan.turner@email.com','9 Cedar Avenue','Nazareth','PA','18064');
INSERT INTO CLIENT VALUES (7,'Individual','Sophia','Parker','N/A','610-555-0107','sophia.parker@email.com','76 Ridge Road','Easton','PA','18042');
INSERT INTO CLIENT VALUES (8,'Corporate','Mason','Brooks','Summit Manufacturing','610-555-0108','mason@summitmanufacturing.com','500 Industrial Drive','Bethlehem','PA','18017');
INSERT INTO CLIENT VALUES (9,'Individual','Isabella','Reed','N/A','610-555-0109','isabella.reed@email.com','33 Oak Lane','Allentown','PA','18103');
INSERT INTO CLIENT VALUES (10,'Individual','Lucas','Hayes','N/A','610-555-0110','lucas.hayes@email.com','81 Pine Street','Easton','PA','18042');

-- Load the STAFF table
INSERT INTO STAFF VALUES (1,'Daniel','Morgan','610-555-0201','daniel.morgan@fullyimagined.com','Office Manager');
INSERT INTO STAFF VALUES (2,'Grace','Foster','610-555-0202','grace.foster@fullyimagined.com','Photographer');
INSERT INTO STAFF VALUES (3,'Henry','Brooks','610-555-0203','henry.brooks@fullyimagined.com','Photographer');
INSERT INTO STAFF VALUES (4,'Chloe','Price','610-555-0204','chloe.price@fullyimagined.com','Photographer');
INSERT INTO STAFF VALUES (5,'Jack','Bennett','610-555-0205','jack.bennett@fullyimagined.com','Photographer');
INSERT INTO STAFF VALUES (6,'Mia','Cooper','610-555-0206','mia.cooper@fullyimagined.com','Photographer');
INSERT INTO STAFF VALUES (7,'James','Ward','610-555-0207','james.ward@fullyimagined.com','Photographer');
INSERT INTO STAFF VALUES (8,'Amelia','Ross','610-555-0208','amelia.ross@freelance.com','Freelance Photographer');
INSERT INTO STAFF VALUES (9,'Benjamin','Gray','610-555-0209','benjamin.gray@freelance.com','Freelance Photographer');
INSERT INTO STAFF VALUES (10,'Harper','Kelly','610-555-0210','harper.kelly@freelance.com','Freelance Photographer');

-- Load the PACKAGE table
INSERT INTO PACKAGE VALUES (1,'Basic Portrait Package - one-hour session and 10 edited digital images.');
INSERT INTO PACKAGE VALUES (2,'Family Portrait Package - one-hour session and 15 edited digital images.');
INSERT INTO PACKAGE VALUES (3,'Group Portrait Package - group session and 20 edited digital images.');
INSERT INTO PACKAGE VALUES (4,'Wedding Package - ceremony coverage and 300 edited digital images.');
INSERT INTO PACKAGE VALUES (5,'Graduation Package - two-hour event coverage and 75 edited digital images.');
INSERT INTO PACKAGE VALUES (6,'Corporate Event Package - three-hour coverage and 150 edited digital images.');
INSERT INTO PACKAGE VALUES (7,'Awards Package - event coverage and 100 edited digital images.');
INSERT INTO PACKAGE VALUES (8,'Conference Package - half-day coverage and 200 edited digital images.');
INSERT INTO PACKAGE VALUES (9,'Reception Package - four-hour coverage and 175 edited digital images.');
INSERT INTO PACKAGE VALUES (10,'Premium Portrait Package - two-hour session and 25 edited digital images.');

-- Load the JOB table
INSERT INTO JOB VALUES (1001,'Event',TO_DATE('2026-06-13','YYYY-MM-DD'),'09:00','17:00','Cedar Crest Wedding Venue, Allentown PA');
INSERT INTO JOB VALUES (1002,'Event',TO_DATE('2026-06-20','YYYY-MM-DD'),'10:00','14:00','DeSales University, Center Valley PA');
INSERT INTO JOB VALUES (1003,'Event',TO_DATE('2026-07-11','YYYY-MM-DD'),'17:00','21:00','Wind Creek Event Center, Bethlehem PA');
INSERT INTO JOB VALUES (1004,'Event',TO_DATE('2026-07-18','YYYY-MM-DD'),'08:00','16:00','Lehigh Conference Center, Bethlehem PA');
INSERT INTO JOB VALUES (1005,'Event',TO_DATE('2026-08-08','YYYY-MM-DD'),'16:00','22:00','The Club at Twin Lakes, Allentown PA');
INSERT INTO JOB VALUES (1006,'Portrait',TO_DATE('2026-06-15','YYYY-MM-DD'),'10:00','11:00','Fully Imagined Studio, Bethlehem PA');
INSERT INTO JOB VALUES (1007,'Portrait',TO_DATE('2026-06-22','YYYY-MM-DD'),'13:00','14:00','Monocacy Park, Bethlehem PA');
INSERT INTO JOB VALUES (1008,'Portrait',TO_DATE('2026-07-13','YYYY-MM-DD'),'09:00','10:00','Fully Imagined Studio, Bethlehem PA');
INSERT INTO JOB VALUES (1009,'Portrait',TO_DATE('2026-07-20','YYYY-MM-DD'),'15:00','16:00','Jacobsburg State Park, Nazareth PA');
INSERT INTO JOB VALUES (1010,'Portrait',TO_DATE('2026-08-10','YYYY-MM-DD'),'11:00','12:00','Fully Imagined Studio, Bethlehem PA');

-- Load the INQUIRY table
INSERT INTO INQUIRY VALUES (2001,TO_DATE('2026-05-01','YYYY-MM-DD'),'Event','Cedar Crest Wedding Venue, Allentown PA',TO_DATE('2026-06-13','YYYY-MM-DD'),'09:00','17:00',4500,4,1);
INSERT INTO INQUIRY VALUES (2002,TO_DATE('2026-05-03','YYYY-MM-DD'),'Event','DeSales University, Center Valley PA',TO_DATE('2026-06-20','YYYY-MM-DD'),'10:00','14:00',1800,5,2);
INSERT INTO INQUIRY VALUES (2003,TO_DATE('2026-05-05','YYYY-MM-DD'),'Event','Wind Creek Event Center, Bethlehem PA',TO_DATE('2026-07-11','YYYY-MM-DD'),'17:00','21:00',2500,7,3);
INSERT INTO INQUIRY VALUES (2004,TO_DATE('2026-05-07','YYYY-MM-DD'),'Event','Lehigh Conference Center, Bethlehem PA',TO_DATE('2026-07-18','YYYY-MM-DD'),'08:00','16:00',3200,8,5);
INSERT INTO INQUIRY VALUES (2005,TO_DATE('2026-05-09','YYYY-MM-DD'),'Event','The Club at Twin Lakes, Allentown PA',TO_DATE('2026-08-08','YYYY-MM-DD'),'16:00','22:00',2900,9,8);
INSERT INTO INQUIRY VALUES (2006,TO_DATE('2026-05-02','YYYY-MM-DD'),'Portrait','Fully Imagined Studio, Bethlehem PA',TO_DATE('2026-06-15','YYYY-MM-DD'),'10:00','11:00',350,1,4);
INSERT INTO INQUIRY VALUES (2007,TO_DATE('2026-05-04','YYYY-MM-DD'),'Portrait','Monocacy Park, Bethlehem PA',TO_DATE('2026-06-22','YYYY-MM-DD'),'13:00','14:00',500,2,6);
INSERT INTO INQUIRY VALUES (2008,TO_DATE('2026-05-06','YYYY-MM-DD'),'Portrait','Fully Imagined Studio, Bethlehem PA',TO_DATE('2026-07-13','YYYY-MM-DD'),'09:00','10:00',400,10,7);
INSERT INTO INQUIRY VALUES (2009,TO_DATE('2026-05-08','YYYY-MM-DD'),'Portrait','Jacobsburg State Park, Nazareth PA',TO_DATE('2026-07-20','YYYY-MM-DD'),'15:00','16:00',450,3,9);
INSERT INTO INQUIRY VALUES (2010,TO_DATE('2026-05-10','YYYY-MM-DD'),'Portrait','Fully Imagined Studio, Bethlehem PA',TO_DATE('2026-08-10','YYYY-MM-DD'),'11:00','12:00',600,10,10);

-- Load the APPOINTMENT table
INSERT INTO APPOINTMENT VALUES (3001,TO_DATE('2026-05-02','YYYY-MM-DD'),'10:00',1,2001);
INSERT INTO APPOINTMENT VALUES (3002,TO_DATE('2026-05-04','YYYY-MM-DD'),'11:00',2,2002);
INSERT INTO APPOINTMENT VALUES (3003,TO_DATE('2026-05-06','YYYY-MM-DD'),'13:00',3,2003);
INSERT INTO APPOINTMENT VALUES (3004,TO_DATE('2026-05-08','YYYY-MM-DD'),'14:00',4,2004);
INSERT INTO APPOINTMENT VALUES (3005,TO_DATE('2026-05-10','YYYY-MM-DD'),'09:00',5,2005);
INSERT INTO APPOINTMENT VALUES (3006,TO_DATE('2026-05-03','YYYY-MM-DD'),'10:30',1,2006);
INSERT INTO APPOINTMENT VALUES (3007,TO_DATE('2026-05-05','YYYY-MM-DD'),'12:00',2,2007);
INSERT INTO APPOINTMENT VALUES (3008,TO_DATE('2026-05-07','YYYY-MM-DD'),'15:00',3,2008);
INSERT INTO APPOINTMENT VALUES (3009,TO_DATE('2026-05-09','YYYY-MM-DD'),'11:30',4,2009);
INSERT INTO APPOINTMENT VALUES (3010,TO_DATE('2026-05-11','YYYY-MM-DD'),'13:30',5,2010);

-- Load the CONTRACT table
INSERT INTO CONTRACT VALUES (4001,TO_DATE('2026-05-12','YYYY-MM-DD'),TO_DATE('2026-05-13','YYYY-MM-DD'),TO_DATE('2026-05-15','YYYY-MM-DD'),'Include a second photographer for the reception.',1001);
INSERT INTO CONTRACT VALUES (4002,TO_DATE('2026-05-13','YYYY-MM-DD'),TO_DATE('2026-05-14','YYYY-MM-DD'),TO_DATE('2026-05-16','YYYY-MM-DD'),'Capture candid graduation photographs.',1002);
INSERT INTO CONTRACT VALUES (4003,TO_DATE('2026-05-14','YYYY-MM-DD'),TO_DATE('2026-05-15','YYYY-MM-DD'),TO_DATE('2026-05-17','YYYY-MM-DD'),'Include photographs of each award recipient.',1003);
INSERT INTO CONTRACT VALUES (4004,TO_DATE('2026-05-15','YYYY-MM-DD'),TO_DATE('2026-05-16','YYYY-MM-DD'),TO_DATE('2026-05-18','YYYY-MM-DD'),'Provide images for the company website.',1004);
INSERT INTO CONTRACT VALUES (4005,TO_DATE('2026-05-16','YYYY-MM-DD'),TO_DATE('2026-05-17','YYYY-MM-DD'),TO_DATE('2026-05-19','YYYY-MM-DD'),'Focus on group and family photographs.',1005);
INSERT INTO CONTRACT VALUES (4006,TO_DATE('2026-05-17','YYYY-MM-DD'),TO_DATE('2026-05-18','YYYY-MM-DD'),TO_DATE('2026-05-20','YYYY-MM-DD'),'Neutral studio background requested.',1006);
INSERT INTO CONTRACT VALUES (4007,TO_DATE('2026-05-18','YYYY-MM-DD'),TO_DATE('2026-05-19','YYYY-MM-DD'),TO_DATE('2026-05-21','YYYY-MM-DD'),'Outdoor family photographs.',1007);
INSERT INTO CONTRACT VALUES (4008,TO_DATE('2026-05-19','YYYY-MM-DD'),TO_DATE('2026-05-20','YYYY-MM-DD'),TO_DATE('2026-05-22','YYYY-MM-DD'),'Professional headshot style.',1008);
INSERT INTO CONTRACT VALUES (4009,TO_DATE('2026-05-20','YYYY-MM-DD'),TO_DATE('2026-05-21','YYYY-MM-DD'),TO_DATE('2026-05-23','YYYY-MM-DD'),'Include individual and group poses.',1009);
INSERT INTO CONTRACT VALUES (4010,TO_DATE('2026-05-21','YYYY-MM-DD'),TO_DATE('2026-05-22','YYYY-MM-DD'),TO_DATE('2026-05-24','YYYY-MM-DD'),'Deliver high-resolution digital files.',1010);

-- Load the PROOF table
INSERT INTO PROOF VALUES (5001,'Approved',1001);
INSERT INTO PROOF VALUES (5002,'Presented',1002);
INSERT INTO PROOF VALUES (5003,'Under Review',1003);
INSERT INTO PROOF VALUES (5004,'Created',1004);
INSERT INTO PROOF VALUES (5005,'Approved',1005);
INSERT INTO PROOF VALUES (5006,'Presented',1006);
INSERT INTO PROOF VALUES (5007,'Approved',1007);
INSERT INTO PROOF VALUES (5008,'Under Review',1008);
INSERT INTO PROOF VALUES (5009,'Created',1009);
INSERT INTO PROOF VALUES (5010,'Approved',1010);

-- Load the PAYMENT table
INSERT INTO PAYMENT VALUES (6001,TO_DATE('2026-05-15','YYYY-MM-DD'),1500,'Deposit',1001);
INSERT INTO PAYMENT VALUES (6002,TO_DATE('2026-05-16','YYYY-MM-DD'),600,'Deposit',1002);
INSERT INTO PAYMENT VALUES (6003,TO_DATE('2026-05-17','YYYY-MM-DD'),800,'Deposit',1003);
INSERT INTO PAYMENT VALUES (6004,TO_DATE('2026-05-18','YYYY-MM-DD'),1000,'Deposit',1004);
INSERT INTO PAYMENT VALUES (6005,TO_DATE('2026-05-19','YYYY-MM-DD'),900,'Deposit',1005);
INSERT INTO PAYMENT VALUES (6006,TO_DATE('2026-05-20','YYYY-MM-DD'),175,'Sitting',1006);
INSERT INTO PAYMENT VALUES (6007,TO_DATE('2026-05-21','YYYY-MM-DD'),250,'Sitting',1007);
INSERT INTO PAYMENT VALUES (6008,TO_DATE('2026-05-22','YYYY-MM-DD'),200,'Sitting',1008);
INSERT INTO PAYMENT VALUES (6009,TO_DATE('2026-05-23','YYYY-MM-DD'),225,'Sitting',1009);
INSERT INTO PAYMENT VALUES (6010,TO_DATE('2026-05-24','YYYY-MM-DD'),300,'Sitting',1010);

-- Load the ORDER table
INSERT INTO "ORDER" VALUES (7001,TO_DATE('2026-06-01','YYYY-MM-DD'),'Print one large wedding album.',1001,4);
INSERT INTO "ORDER" VALUES (7002,TO_DATE('2026-06-02','YYYY-MM-DD'),'Provide digital files in a shared gallery.',1002,5);
INSERT INTO "ORDER" VALUES (7003,TO_DATE('2026-06-03','YYYY-MM-DD'),'Include framed award recipient photographs.',1003,7);
INSERT INTO "ORDER" VALUES (7004,TO_DATE('2026-06-04','YYYY-MM-DD'),'Sort conference photographs by session.',1004,8);
INSERT INTO "ORDER" VALUES (7005,TO_DATE('2026-06-05','YYYY-MM-DD'),'Create a reception highlight gallery.',1005,9);
INSERT INTO "ORDER" VALUES (7006,TO_DATE('2026-06-06','YYYY-MM-DD'),'Retouch selected headshots.',1006,1);
INSERT INTO "ORDER" VALUES (7007,TO_DATE('2026-06-07','YYYY-MM-DD'),'Print five family portraits.',1007,2);
INSERT INTO "ORDER" VALUES (7008,TO_DATE('2026-06-08','YYYY-MM-DD'),'Provide square and standard crops.',1008,10);
INSERT INTO "ORDER" VALUES (7009,TO_DATE('2026-06-09','YYYY-MM-DD'),'Include group photographs in the gallery.',1009,3);
INSERT INTO "ORDER" VALUES (7010,TO_DATE('2026-06-10','YYYY-MM-DD'),'Provide additional high-resolution copies.',1010,10);

-- Load the JOB_ASSIGNMENT table
INSERT INTO JOB_ASSIGNMENT VALUES (1001,2,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1001,3,'Assistant');
INSERT INTO JOB_ASSIGNMENT VALUES (1002,4,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1002,5,'Assistant');
INSERT INTO JOB_ASSIGNMENT VALUES (1003,6,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1003,7,'Assistant');
INSERT INTO JOB_ASSIGNMENT VALUES (1004,2,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1004,4,'Assistant');
INSERT INTO JOB_ASSIGNMENT VALUES (1005,3,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1005,5,'Assistant');
INSERT INTO JOB_ASSIGNMENT VALUES (1006,6,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1007,7,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1008,2,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1009,3,'Primary');
INSERT INTO JOB_ASSIGNMENT VALUES (1010,4,'Primary');

-- SUPPORTING TABLES: 5 RECORDS EACH [Leslie Sintes]

-- Load the EVENT table
INSERT INTO EVENT VALUES (1001,'Wedding');
INSERT INTO EVENT VALUES (1002,'Graduation');
INSERT INTO EVENT VALUES (1003,'Awards Ceremony');
INSERT INTO EVENT VALUES (1004,'Conference');
INSERT INTO EVENT VALUES (1005,'Reception');

-- Load the PORTRAIT table
INSERT INTO PORTRAIT VALUES (1006,'Individual');
INSERT INTO PORTRAIT VALUES (1007,'Family');
INSERT INTO PORTRAIT VALUES (1008,'Individual');
INSERT INTO PORTRAIT VALUES (1009,'Group');
INSERT INTO PORTRAIT VALUES (1010,'Family');

-- Load the PHOTOGRAPHER table
INSERT INTO PHOTOGRAPHER VALUES (2);
INSERT INTO PHOTOGRAPHER VALUES (3);
INSERT INTO PHOTOGRAPHER VALUES (4);
INSERT INTO PHOTOGRAPHER VALUES (5);
INSERT INTO PHOTOGRAPHER VALUES (6);
INSERT INTO PHOTOGRAPHER VALUES (7);

-- Load the FREELANCE_PHOTOGRAPHER table
INSERT INTO FREELANCE_PHOTOGRAPHER VALUES (8);
INSERT INTO FREELANCE_PHOTOGRAPHER VALUES (9);
INSERT INTO FREELANCE_PHOTOGRAPHER VALUES (10);

-- Load the INQUIRY_PACKAGE table
INSERT INTO INQUIRY_PACKAGE VALUES (4,2001);
INSERT INTO INQUIRY_PACKAGE VALUES (5,2002);
INSERT INTO INQUIRY_PACKAGE VALUES (7,2003);
INSERT INTO INQUIRY_PACKAGE VALUES (8,2004);
INSERT INTO INQUIRY_PACKAGE VALUES (9,2005);