-- CREATE TABLE: USERS (SUPERCLASS)
-- ===============================
CREATE TABLE Users (
	User_ID VARCHAR2(10) NOT NULL,
	User_Email VARCHAR2(100) NOT NULL,
	User_Full_Name VARCHAR2(100) NOT NULL,
	User_Phone_Number VARCHAR2(20) NOT NULL,
	User_Date_Registered DATE NOT NULL,
	User_Address CLOB NOT NULL,
	User_Date_Of_Birth DATE NOT NULL,
	User_Gender VARCHAR2(10) NOT NULL CHECK (User_Gender IN ('Male', 'Female', 'Other')),
	User_Nationality VARCHAR2(50) NOT NULL,
	User_Account_Status VARCHAR2(10) NOT NULL CHECK (User_Account_Status IN ('Active', 'Inactive', 'Suspended')),
	PRIMARY KEY (User_ID, User_Email),
	UNIQUE (User_ID)
);

-- CREATE TABLE: ADMIN
-- ===================
CREATE TABLE Admin (
	Admin_ID VARCHAR2(10) NOT NULL,
	Admin_Staff_Number VARCHAR2(20) NOT NULL,
	Admin_Role VARCHAR2(50) NOT NULL,
	Admin_Department VARCHAR2(50) NOT NULL,
	Admin_Access_Level VARCHAR2(10) NOT NULL CHECK(Admin_Access_Level IN ('Low', 'Medium', 'High')),
	Admin_Assigned_Region VARCHAR2(50) NOT NULL,
	Admin_Profile_Verifies VARCHAR2(5) DEFAULT 'No' NOT NULL CHECK (Admin_Profile_Verifies IN ('Yes', 'No')),
	Admin_Shift VARCHAR2(10) NOT NULL CHECK (Admin_Shift IN ('Morning', 'Evening', 'Night')),
	Admin_Login_Count INT DEFAULT 0 NOT NULL CHECK(Admin_Login_Count >= 0),
	Admin_Work_Hours DECIMAL(5,1) DEFAULT 0.00 NOT NULL CHECK (Admin_Work_Hours >= 0),
	User_ID VARCHAR2(10),
	PRIMARY KEY (Admin_ID, Admin_Staff_Number),
	UNIQUE (Admin_ID),
	FOREIGN KEY (User_ID) REFERENCES Users (User_ID)
);

-- CREATE TABLE: RIDER
-- ===================
CREATE TABLE Rider (
	Rider_ID VARCHAR2(10) NOT NULL,
	Rider_IC_Number CHAR(14) NOT NULL,
	Rider_License_Type VARCHAR2(10) NOT NULL CHECK (Rider_License_Type IN ('L', 'B2', 'B', 'B Full')),
	Rider_Events_Joined INT NOT NULL CHECK (Rider_Events_Joined >= 0),
	Rider_Emergency_Contact VARCHAR2(20) NOT NULL,
	Rider_Loyalty_Points INT NOT NULL CHECK (Rider_Loyalty_Points >= 0),
	Rider_Badges_Collected INT NOT NULL CHECK (Rider_Badges_Collected >= 0),
	Rider_Total_KM_Ridden DECIMAL(8,2) NOT NULL CHECK (Rider_Total_KM_Ridden >= 0),
	Rider_Date_Joined DATE NOT NULL,
	Rider_Feedback_Count INT NOT NULL CHECK (Rider_Feedback_Count >= 0),
	User_ID VARCHAR2(10),
	PRIMARY KEY (Rider_ID, Rider_IC_Number),
	UNIQUE (Rider_ID),
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- CREATE TABLE: SERVICE_CENTER
-- ============================
CREATE TABLE Service_Center (
	SC_ID VARCHAR2(8) NOT NULL,
	SC_Name VARCHAR2(50) NOT NULL,
	SC_Location VARCHAR2(255) NOT NULL,
	SC_Phone VARCHAR2(15) NOT NULL,
	SC_Email VARCHAR2(100) NOT NULL,
	SC_Capacity INT NOT NULL CHECK (SC_Capacity > 0),
	SC_Operating_Hours VARCHAR2(50) NOT NULL,
	SC_Rating DECIMAL(2,1) NOT NULL CHECK (SC_Rating BETWEEN 0 AND 5),
	SC_Service_Type VARCHAR2(30) NOT NULL CHECK (SC_Service_Type IN ('Full', 'Limited')),
	SC_Region VARCHAR2(30) NOT NULL,
	User_ID VARCHAR2(10),
	UNIQUE(SC_ID),
	PRIMARY KEY (SC_ID, SC_Name),
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- CREATE TABLE: MOTORCYCLE
-- ========================
CREATE TABLE Motorcycle (
	Motorcycle_ID VARCHAR2(10) NOT NULL,
	Motorcycle_Plate_Number VARCHAR2(15) NOT NULL,
	Motorcycle_Model VARCHAR2(50) NOT NULL,
	Motorcycle_Engine_CC INT NOT NULL CHECK (Motorcycle_Engine_CC > 0),
	Motorcycle_Frame_Number CHAR(17) NOT NULL,
	Motorcycle_Engine_Number VARCHAR2(30) NOT NULL,
	Motorcycle_Registration_Date DATE NOT NULL,
	Motorcycle_Insurance_Status VARCHAR2(10) NOT NULL CHECK (Motorcycle_Insurance_Status IN ('Active', 'Expired', 'Pending')),
	Motorcycle_Mileage DECIMAL(8,2) NOT NULL CHECK (Motorcycle_Mileage >= 0),
	Motorcycle_Condition VARCHAR2(20) NOT NULL CHECK (Motorcycle_Condition IN ('New', 'Used', 'Damaged')),
 	Rider_ID VARCHAR2(10),
	SC_ID VARCHAR2(8),
	PRIMARY KEY (Motorcycle_ID, Motorcycle_Plate_Number),
	UNIQUE (Motorcycle_ID),
	FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
	FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID)
);

-- CREATE TABLE: EVENT
-- ===================
CREATE TABLE Event (
  	Event_ID VARCHAR2(10) NOT NULL,
  	Event_Name VARCHAR2(100) NOT NULL,
  	Event_Location VARCHAR2(100) NOT NULL,
  	Event_Date DATE NOT NULL,
  	Event_Time DATE NOT NULL,
  	Event_Fee DECIMAL(6,2) NOT NULL CHECK (Event_Fee >= 0),
  	Event_Type VARCHAR2(20) NOT NULL,
  	Event_Capacity INT NOT NULL CHECK (Event_Capacity > 0),
  	Event_Participants_Count INT NOT NULL CHECK (Event_Participants_Count >= 0),
  	Event_Status VARCHAR2(20) NOT NULL CHECK (Event_Status IN ('Upcoming','Ongoing','Completed','Cancelled')),
  	User_ID VARCHAR2(10),
  	PRIMARY KEY (Event_ID, Event_Name),
  	UNIQUE(Event_ID),
  	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- CREATE TABLE: MERCHANDISE
-- =========================
CREATE TABLE Merchandise (
	Merchandise_ID VARCHAR2(10) NOT NULL,
	Merchandise_Name VARCHAR2(50) NOT NULL,
	Merchandise_Description CLOB NULL,
	Merchandise_Category VARCHAR2(50) NOT NULL, 
	Merchandise_Size VARCHAR2(10) NOT NULL,
	Merchandise_Color VARCHAR2(20) NULL,
	Merchandise_Price DECIMAL(6,2) NOT NULL CHECK(Merchandise_Price >= 0),
	Merchandise_Stock_Count INT NOT NULL CHECK(Merchandise_Stock_Count > 0),
	Merchandise_Availability_Status VARCHAR2(15) NOT NULL CHECK(Merchandise_Availability_Status IN ('Available','Out of Stock')),
	Merchandise_Image_Url VARCHAR2(255) NULL,
	Event_ID VARCHAR2(10),
	PRIMARY KEY (Merchandise_ID, Merchandise_Name),
	UNIQUE (Merchandise_ID),
	FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID)
);

-- CREATE TABLE: MERCHANDISE_PURCHASE
-- ==================================
CREATE TABLE Merchandise_Purchase (
	M_Purchase_ID VARCHAR2(10) NOT NULL,
	M_Purchase_Date DATE NOT NULL,
	M_Purchase_Tracking_No VARCHAR2(30) NOT NULL,
	M_Purchase_Quantity INT DEFAULT 1 NOT NULL CHECK(M_Purchase_Quantity > 0),
	M_Purchase_Status VARCHAR2(20) NOT NULL CHECK (M_Purchase_Status IN ('Processing','Shipped','Delivered','Cancelled','Returned')),
	M_Purchase_Method VARCHAR2(20) NOT NULL CHECK (M_Purchase_Method IN ('Credit Card','FPX','E-Wallet','Cash')),
	M_Purchase_Shipping_Address VARCHAR2(255) NOT NULL,
	M_Purchase_Total_Cost DECIMAL(7,2) DEFAULT 0.00 NOT NULL CHECK (M_Purchase_Total_Cost >= 0),
	M_Purchase_Platform VARCHAR2(30) NOT NULL CHECK (M_Purchase_Platform IN ('Mobile App','Webstore','Store')),
	M_Purchase_Discount DECIMAL(5,2) NOT NULL CHECK (M_Purchase_Discount >= 0),
	User_ID VARCHAR2(10),
	Merchandise_ID VARCHAR2(10),
	PRIMARY KEY (M_Purchase_ID, M_Purchase_Date),
	UNIQUE (M_Purchase_ID),
	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
	FOREIGN KEY (Merchandise_ID) REFERENCES Merchandise(Merchandise_ID)
);

-- CREATE TABLE: CLUB
-- ==================
CREATE TABLE Club (
	Club_ID VARCHAR2(10) NOT NULL,
	Club_Name VARCHAR2(100) NOT NULL,
	Club_Region VARCHAR2(30) NOT NULL,
	Club_Description CLOB NULL,
	Club_Founded_Date DATE NOT NULL,
	Club_Member_Limit INT NOT NULL CHECK (Club_Member_Limit >= 0),
	Club_Current_Members INT NOT NULL CHECK (Club_Current_Members >= 0),
	Club_Logo_URL VARCHAR2(255) NULL,
	Club_Rules CLOB NULL,
	Club_Status VARCHAR2(10) NOT NULL CHECK (Club_Status IN ('Active','Inactive','Disbanded')),
	User_ID VARCHAR2(10),
 	PRIMARY KEY (Club_ID, Club_Name),
	UNIQUE(Club_ID),
 	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- CREATE TABLE: CLUB_MEMBERSHIP
-- =============================
CREATE TABLE Club_Membership (
  	CM_Membership_ID VARCHAR2(12) NOT NULL,
  	CM_Join_Date DATE NOT NULL,
  	CM_Membership_Status VARCHAR2(20) NOT NULL CHECK (CM_Membership_Status IN ('Active','Inactive','Suspended')),
  	CM_Membership_Role VARCHAR2(20) NOT NULL CHECK (CM_Membership_Role IN ('President','Vice Leader','Member','Treasurer')),
  	CM_Activity_Attendance INT NOT NULL CHECK (CM_Activity_Attendance >= 0),
	CM_Renewal_Date DATE NULL,
	CM_Contribution_Score INT NOT NULL,
  	CM_Last_Activity DATE NULL,
  	CM_Membership_Level VARCHAR2(20) NOT NULL CHECK (CM_Membership_Level IN ('Bronze','Silver','Gold','Platinum')),
  	CM_Expiry_Date DATE NOT NULL,
  	Rider_ID VARCHAR2(10),
  	Club_ID VARCHAR2(10),
    	PRIMARY KEY (CM_Membership_ID, CM_Join_Date),
  	UNIQUE(CM_Membership_ID),
  	FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
  	FOREIGN KEY (Club_ID)  REFERENCES Club(Club_ID)
);

-- CREATE TABLE: BADGE
-- ===================
CREATE TABLE Badge (
    	Badge_ID VARCHAR2(10) NOT NULL,
    	Badge_Name VARCHAR2(50) NOT NULL,
    	Badge_Description CLOB,
    	Badge_Criteria VARCHAR2(100) NOT NULL,
    	Badge_Level VARCHAR2(20) NOT NULL,
    	Badge_Image_Url VARCHAR2(255),
    	Badge_Category VARCHAR2(30) NOT NULL,
    	Badge_Date_Created DATE NOT NULL,
    	Badge_Active_Status VARCHAR2(10) DEFAULT 'Active' NOT NULL,
    	CHECK (Badge_Active_Status IN ('Active', 'Inactive')),
    	Badge_Earned_Count NUMBER DEFAULT 0 NOT NULL CHECK (Badge_Earned_Count >= 0),
    	User_ID VARCHAR2(10),
    	UNIQUE(Badge_ID),
    	PRIMARY KEY (Badge_ID, Badge_Name),
    	FOREIGN KEY (User_ID) REFERENCES Users(User_ID)
);

-- CREATE TABLE: EVENT_PARTICIPATION
-- =================================
CREATE TABLE Event_Participation (
  	EP_Participation_ID VARCHAR2(10) NOT NULL,
  	EP_Join_Date DATE NOT NULL,
  	EP_Badge VARCHAR2(30) NULL,
  	EP_Award VARCHAR2(30) NULL,
  	EP_Attendance_Status VARCHAR2(10) NOT NULL CHECK (EP_Attendance_Status IN ('Attended','Absent')),
  	EP_Completion_Status VARCHAR2(20) NOT NULL CHECK (EP_Completion_Status IN ('Completed','Incomplete')),
  	EP_Points_Awarded INT NOT NULL CHECK (EP_Points_Awarded >= 0),
  	EP_Feedback_Score DECIMAL(2,1) NOT NULL CHECK (EP_Feedback_Score BETWEEN 0 AND 5),
  	EP_Photo_Upload_Url VARCHAR2(255) NULL,
  	EP_Remarks CLOB NULL,
  	Rider_ID VARCHAR2(10),
  	Event_ID VARCHAR2(10),
  	Badge_ID VARCHAR2(10),
  	PRIMARY KEY (EP_Participation_ID, EP_Join_Date),
  	UNIQUE (EP_Participation_ID),
  	FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
  	FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID),
  	FOREIGN KEY (Badge_ID) REFERENCES Badge(Badge_ID)
);

-- CREATE TABLE: REFERRAL
-- ======================
CREATE TABLE Referral (
    	Referral_ID VARCHAR2(12) NOT NULL,
    	Referral_Date_Used DATE NOT NULL,
    	Referral_Code VARCHAR2(20) UNIQUE,
    	Referral_Status VARCHAR2(15) NOT NULL CHECK (Referral_Status IN ('Active', 'Used', 'Expired')),
    	Referral_Is_One_Time VARCHAR2(5) NOT NULL CHECK (Referral_Is_One_Time IN ('Yes', 'No')),
    	Referral_Channel VARCHAR2(20) NOT NULL,
    	Referral_Max_Limit INT DEFAULT 1 NOT NULL CHECK (Referral_Max_Limit >= 1),
    	Referral_Reward_Claimed VARCHAR2(5) NOT NULL CHECK (Referral_Reward_Claimed IN ('Yes', 'No')),
    	Referral_Link_Device_Type VARCHAR2(20),
    	Referral_Date_Generated DATE NOT NULL,
    	Referral_Referrer_ID VARCHAR2(10) NOT NULL,
    	Referral_Referee_ID VARCHAR2(10) NOT NULL,
    	PRIMARY KEY (Referral_ID, Referral_Date_Used),
    	UNIQUE (Referral_ID),
    	FOREIGN KEY (Referral_Referrer_ID) REFERENCES Rider(Rider_ID),
    	FOREIGN KEY (Referral_Referee_ID) REFERENCES Rider(Rider_ID)
);

-- CREATE TABLE: LOYALTY_REWARD
-- ============================
CREATE TABLE Loyalty_Reward (
	LR_Reward_ID VARCHAR2(10) NOT NULL,
	LR_Reward_Name VARCHAR2(50) NOT NULL,
	LR_Description CLOB,
	LR_Points_Required INT DEFAULT 0 NOT NULL CHECK (LR_Points_Required >= 0),
	LR_Availability_Status VARCHAR2(11) NOT NULL CHECK (LR_Availability_Status IN ('Available', 'Unavailable')),
	LR_Start_Date DATE NOT NULL,
	LR_Expiry_Date DATE,
	LR_Stock_Count INT DEFAULT 0 NOT NULL CHECK (LR_Stock_Count >= 0),
	LR_Redeemed_Count INT NOT NULL CHECK (LR_Redeemed_Count >= 0),
	LR_Reward_Type VARCHAR2(30) NOT NULL,
	Rider_ID VARCHAR2(10),
	Merchandise_ID VARCHAR2(10),
	M_Purchase_ID VARCHAR2(10),
	Referral_ID VARCHAR2(12),
	EP_Participation_ID VARCHAR2(10),
	CM_Membership_ID VARCHAR2(12),
	PRIMARY KEY (LR_Reward_ID, LR_Reward_Name),
	UNIQUE(LR_Reward_ID),
	FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
	FOREIGN KEY (Merchandise_ID) REFERENCES Merchandise(Merchandise_ID),
	FOREIGN KEY (M_Purchase_ID) REFERENCES Merchandise_Purchase(M_Purchase_ID),
	FOREIGN KEY (Referral_ID) REFERENCES Referral(Referral_ID),
	FOREIGN KEY (EP_Participation_ID) REFERENCES Event_Participation(EP_Participation_ID),
	FOREIGN KEY (CM_Membership_ID) REFERENCES Club_Membership(CM_Membership_ID)
);

-- CREATE TABLE: CLUB_ACTIVITY
-- ===========================
CREATE TABLE Club_Activity (
  	Activity_ID VARCHAR2(10) NOT NULL,
  	Activity_Name VARCHAR2(100) NOT NULL,
  	Activity_Description CLOB NULL,
  	Activity_Date DATE NOT NULL,
  	Activity_Time DATE NOT NULL,
  	Activity_Location VARCHAR2(100) NOT NULL,
 	Activity_Participants_Count INT NOT NULL CHECK (Activity_Participants_Count >= 0),
 	Activity_Points_Awarded INT NOT NULL,
  	Activity_Status VARCHAR2(10) NOT NULL CHECK (Activity_Status IN ('Scheduled','Ongoing','Completed','Cancelled')),
  	Activity_Highlight_URL VARCHAR2(255) NULL,
  	Rider_ID VARCHAR2(10),
  	Club_ID VARCHAR2(10),
  	CM_Membership_ID VARCHAR2(12),
  	LR_Reward_ID VARCHAR2(10),
  	PRIMARY KEY (Activity_ID, Activity_Name),
  	UNIQUE (Activity_ID),
  	FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
  	FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID),
  	FOREIGN KEY (CM_Membership_ID) REFERENCES Club_Membership(CM_Membership_ID),
  	FOREIGN KEY (LR_Reward_ID) REFERENCES Loyalty_Reward(LR_Reward_ID)
);

-- CREATE TABLE: SERVICE_APPOINTMENT
-- =================================
CREATE TABLE Service_Appointment (
    	SA_Appointment_ID VARCHAR2(10) NOT NULL,
    	SA_Date DATE NOT NULL,
    	SA_Completion_Estimated_Time VARCHAR2(20) NOT NULL,
    	SA_Service_Type VARCHAR2(30) NOT NULL,
    	SA_Time DATE NOT NULL,
    	SA_Status VARCHAR2(20) NOT NULL CHECK (SA_Status IN ('Pending', 'In Progress', 'Completed', 'Scheduled', 'Cancelled')),
    	SA_Cost_Estimate DECIMAL(7,2) NOT NULL,
    	SA_Booking_Method VARCHAR2(20) NOT NULL,
    	SA_Queue INT NOT NULL CHECK (SA_Queue >= 0),
    	SA_Priority VARCHAR2(20) DEFAULT 'Normal' NOT NULL,
    	CHECK (SA_Priority IN ('Low', 'Normal', 'High', 'Urgent')),
    	User_ID VARCHAR2(10),
    	SC_ID VARCHAR2(8),
    	Motorcycle_ID VARCHAR2(10),
    	UNIQUE(SA_Appointment_ID),
    	PRIMARY KEY (SA_Appointment_ID, SA_Date),
    	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    	FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID),
    	FOREIGN KEY (Motorcycle_ID) REFERENCES  Motorcycle(Motorcycle_ID)
);

-- CREATE TABLE: SERVICE_RECORD
-- ============================
CREATE TABLE Service_Record (
    	S_Record_ID VARCHAR2(10) NOT NULL,
    	S_Record_Service_Date DATE NOT NULL,
    	S_Record_Service_Type VARCHAR2(30) NOT NULL,
    	S_Record_Parts_Replaced VARCHAR2(150) NULL,
    	S_Record_Total_Cost DECIMAL(7,2) DEFAULT 0.00,
    	CHECK (S_Record_Total_Cost >= 0),
    	S_Record_Warranty_Claimed VARCHAR2(5) DEFAULT 'No' NOT NULL,
    	CHECK (S_Record_Warranty_Claimed IN ('Yes', 'No')),
    	S_Record_Notes CLOB,
    	S_Record_Fault_Code VARCHAR2(20),
    	S_Record_Completion_Time DATE,
    	S_Record_Follow_Up VARCHAR2(100),
    	User_ID VARCHAR2(10),
    	Motorcycle_ID VARCHAR2(10),
    	SA_Appointment_ID VARCHAR2(10),
    	SC_ID VARCHAR2(8),
    	UNIQUE(S_Record_ID),
    	PRIMARY KEY (S_Record_ID, S_Record_Service_Date),
    	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    	FOREIGN KEY (Motorcycle_ID) REFERENCES Motorcycle(Motorcycle_ID),
    	FOREIGN KEY (SA_Appointment_ID) REFERENCES Service_Appointment(SA_Appointment_ID),
    	FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID)
);

-- CREATE TABLE: USER_BADGE
-- ========================
CREATE TABLE User_Badge (
    	UB_ID VARCHAR2(10) NOT NULL,
    	UB_Date_Earned DATE NOT NULL,
    	UB_Earned_Location VARCHAR2(100),
    	UB_Admin_Granted VARCHAR2(5) DEFAULT 'No' NOT NULL CHECK (UB_Admin_Granted IN ('Yes', 'No')),
    	UB_Revoked_Status VARCHAR2(10)  DEFAULT 'Active' NOT NULL CHECK (UB_Revoked_Status IN ('Active', 'Revoked')),
    	UB_Revoked_Reason CLOB,
    	UB_Notes CLOB,
    	UB_Earned_Method VARCHAR2(30) NOT NULL,
    	UB_Visibility_Status VARCHAR2(10) DEFAULT 'Visible' NOT NULL CHECK (UB_Visibility_Status IN ('Visible', 'Hidden')),
    	UB_Number_Of_Badges NUMBER DEFAULT 1 NOT NULL CHECK (UB_Number_Of_Badges > 0),
    	User_ID VARCHAR2(10) NOT NULL,
    	Badge_ID VARCHAR2(10) NOT NULL,
    	UNIQUE(UB_ID),
    	PRIMARY KEY (UB_ID, UB_Date_Earned),
    	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    	FOREIGN KEY (Badge_ID) REFERENCES Badge(Badge_ID)
);

-- CREATE TABLE: FEEDBACK
-- ======================
CREATE TABLE Feedback (
    	Feedback_ID VARCHAR2(10) NOT NULL,
    	Feedback_Submitted_On DATE NOT NULL,
    	Feedback_Context VARCHAR2(50) NOT NULL,
    	Feedback_Rating DECIMAL(2,1) NOT NULL CHECK (Feedback_Rating BETWEEN 0 AND 5),
    	Feedback_Comments CLOB,
    	Feedback_Type VARCHAR2(20) NOT NULL,
    	Feedback_Image_URL VARCHAR2(255),
    	Feedback_Response_Date DATE,
    	Feedback_Response_Status VARCHAR2(20) DEFAULT 'Pending' NOT NULL CHECK (Feedback_Response_Status IN ('Pending', 'Responded', 'Resolved')),
    	Feedback_Has_Responded VARCHAR2(5) DEFAULT 'No' NOT NULL CHECK (Feedback_Has_Responded IN ('Yes', 'No')),
    	User_ID VARCHAR2(10),
    	Club_ID VARCHAR2(10),
    	CM_Membership_ID VARCHAR2(12),
    	Activity_ID VARCHAR2(10),
    	Event_ID VARCHAR2(10),
    	EP_Participation_ID VARCHAR2(10),
    	Merchandise_ID VARCHAR2(10),
    	SC_ID VARCHAR2(8),
    	SA_Appointment_ID VARCHAR2(10),
    	LR_Reward_ID VARCHAR2(10),
    	PRIMARY KEY (Feedback_ID, Feedback_Submitted_On),
    	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    	FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID),
    	FOREIGN KEY (CM_Membership_ID) REFERENCES Club_Membership(CM_Membership_ID),
   	FOREIGN KEY (Activity_ID) REFERENCES Club_Activity(Activity_ID),
    	FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID),
    	FOREIGN KEY (EP_Participation_ID) REFERENCES Event_Participation(EP_Participation_ID),
    	FOREIGN KEY (Merchandise_ID) REFERENCES Merchandise(Merchandise_ID),
    	FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID),
    	FOREIGN KEY (SA_Appointment_ID) REFERENCES Service_Appointment(SA_Appointment_ID),
    	FOREIGN KEY (LR_Reward_ID) REFERENCES Loyalty_Reward(LR_Reward_ID)
);

-- CREATE TABLE: NOTIFICATION
-- ==========================
CREATE TABLE Notification (
    	Notification_ID VARCHAR2(10) NOT NULL,
    	Notification_Title VARCHAR2(100) NOT NULL,
    	Notification_Message CLOB,
    	Notification_Sent_Time DATE NOT NULL,
    	Notification_Read_Status VARCHAR2(10) DEFAULT 'Unread' NOT NULL CHECK (Notification_Read_Status IN ('Unread', 'Read')),
    	Notification_Type VARCHAR2(30) NOT NULL,
    	Notification_Seen_Status VARCHAR2(10) DEFAULT 'Unseen' NOT NULL CHECK (Notification_Seen_Status IN ('Seen', 'Unseen')),
    	Notification_Priority VARCHAR2(10) DEFAULT 'Medium' NOT NULL CHECK (Notification_Priority IN ('Low', 'Medium', 'High', 'Critical')),
    	Notification_Expiry_Time DATE,
    	Notification_Origin VARCHAR2(20),
    	Rider_ID VARCHAR2(10),
    	Activity_ID VARCHAR2(10),
    	Event_ID VARCHAR2(10),
    	EP_Participation_ID VARCHAR2(10),
    	SA_Appointment_ID VARCHAR2(10),
    	PRIMARY KEY (Notification_ID, Notification_Title),
    	FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
    	FOREIGN KEY (Activity_ID) REFERENCES Club_Activity(Activity_ID),
    	FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID),
    	FOREIGN KEY (EP_Participation_ID) REFERENCES Event_Participation(EP_Participation_ID),
    	FOREIGN KEY (SA_Appointment_ID) REFERENCES Service_Appointment(SA_Appointment_ID)
);

-- CREATE TABLE: LOGIN_LOG
-- =======================
CREATE TABLE Login_Log (
    	LL_Log_ID VARCHAR2(12) NOT NULL,
    	LL_Log_IP_Address VARCHAR2(45) NOT NULL,
    	LL_Login_Time DATE NOT NULL,
    	LL_Device VARCHAR2(50),
    	LL_Browser_Info VARCHAR2(100),
    	LL_Location VARCHAR2(150),
   	LL_Logout_Time DATE,
   	LL_Duration INT,
    	LL_Status VARCHAR2(10) DEFAULT 'Success' NOT NULL CHECK (LL_Status IN ('Success', 'Failed')),
    	LL_Password_Change VARCHAR2(5) DEFAULT 'No' NOT NULL CHECK (LL_Password_Change IN ('Yes', 'No')),
    	User_ID VARCHAR2(10),
    	SC_ID VARCHAR2(8),
    	PRIMARY KEY (LL_Log_ID, LL_Log_IP_Address),
    	FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    	FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID)
);

-- CREATE TABLES: EXPLOSION TABLE
-- ==============================
CREATE TABLE Users_Club (
    User_ID VARCHAR2(10) NOT NULL,
    Club_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (User_ID, Club_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Club_ID) REFERENCES Club(Club_ID)
);

CREATE TABLE Users_Events (
    User_ID VARCHAR2(10) NOT NULL,
    Event_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (User_ID, Event_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (Event_ID) REFERENCES Event(Event_ID)
);

CREATE TABLE Rider_ClubActivity (
    Rider_ID VARCHAR2(10) NOT NULL,
    Activity_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (Rider_ID, Activity_ID),
    FOREIGN KEY (Rider_ID) REFERENCES Rider(Rider_ID),
    FOREIGN KEY (Activity_ID) REFERENCES Club_Activity(Activity_ID)
);

CREATE TABLE ClubMembership_ClubActivity (
    CM_Membership_ID VARCHAR2(12) NOT NULL,
    Activity_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (CM_Membership_ID, Activity_ID),
    FOREIGN KEY (CM_Membership_ID) REFERENCES Club_Membership(CM_Membership_ID),
    FOREIGN KEY (Activity_ID) REFERENCES Club_Activity(Activity_ID)
);

CREATE TABLE ClubActivity_LoyaltyReward (
    Activity_ID VARCHAR2(10) NOT NULL,
    LR_Reward_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (Activity_ID, LR_Reward_ID),
    FOREIGN KEY (Activity_ID) REFERENCES Club_Activity(Activity_ID),
    FOREIGN KEY (LR_Reward_ID) REFERENCES Loyalty_Reward(LR_Reward_ID)
);

CREATE TABLE ServiceRecord_Motorcycle (
    S_Record_ID VARCHAR2(10) NOT NULL,
    Motorcycle_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (S_Record_ID, Motorcycle_ID),
    FOREIGN KEY (S_Record_ID) REFERENCES Service_Record(S_Record_ID),
    FOREIGN KEY (Motorcycle_ID) REFERENCES Motorcycle(Motorcycle_ID)
);

CREATE TABLE Users_ServiceCenter (
    User_ID VARCHAR2(10) NOT NULL,
    SC_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (User_ID, SC_ID),
    FOREIGN KEY (User_ID) REFERENCES Users(User_ID),
    FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID)
);

CREATE TABLE Motorcycle_ServiceCenter (
    Motorcycle_ID VARCHAR2(10) NOT NULL,
    SC_ID VARCHAR2(10) NOT NULL,
    PRIMARY KEY (Motorcycle_ID, SC_ID),
    FOREIGN KEY (Motorcycle_ID) REFERENCES Motorcycle(Motorcycle_ID),
    FOREIGN KEY (SC_ID) REFERENCES Service_Center(SC_ID)
);
