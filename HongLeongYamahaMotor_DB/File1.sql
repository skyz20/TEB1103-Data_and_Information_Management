COLUMN User_Full_Name FORMAT A20
COLUMN Rider_Date_Joined FORMAT A17

-- File 1
-- Scenario
-- This query is to find the full name of users and the date they became riders. It shows which users have registered as riders and helps us know when they started using the platform as active riders.

SELECT Users.User_Full_Name, Rider.Rider_Date_Joined
FROM Users
JOIN Rider ON Users.User_ID = Rider.User_ID;
