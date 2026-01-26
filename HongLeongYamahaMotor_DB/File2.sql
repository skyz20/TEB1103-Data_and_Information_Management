SELECT 
    Club.Club_Region, 
    COUNT(*) AS Total_Activities_Joined
FROM 
    Rider
    JOIN Club_Membership ON Rider.Rider_ID = Club_Membership.Rider_ID
    JOIN Club ON Club.Club_ID = Club_Membership.Club_ID
    JOIN Club_Activity ON Club.Club_ID = Club_Activity.Club_ID
WHERE 
    Rider.Rider_License_Type = 'B'
    AND Club_Activity.Activity_Status = 'Completed'
GROUP BY 
    Club.Club_Region;
