COLUMN User_ID FORMAT A07
COLUMN Admin_ID FORMAT A08
COLUMN LL_Log_ID FORMAT A09

-- File 5
-- Scenario
-- This query creates a view called View_User_Admin_Badge that displays which admins are assigned as the person in charge (PIC) for badges that are currently marked as active. In the platform, users receive badges for achievements or participation, and each badge is linked to an admin who manages its use. By filtering for badges with the status 'Active', this view helps highlight only the admins responsible for overseeing badges that are still valid and officially recognized. 

CREATE VIEW View_User_Admin_Badge AS
SELECT Users.User_ID, Admin.Admin_ID, Badge.Badge_ID 
FROM Users
JOIN Admin ON Users.User_ID = Admin.User_ID
JOIN Badge ON Users.User_ID = Badge.User_ID 
WHERE Badge.Badge_Active_Status = 'Active';
   
SELECT * FROM View_User_Admin_Badge;