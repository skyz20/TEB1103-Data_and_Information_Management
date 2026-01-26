SELECT
    u.User_ID, u.User_Full_Name,
    e.Event_ID, e.Event_Name,
    ep.EP_Participation_ID, ep.EP_Badge,
    f.Feedback_ID, f.Feedback_Type,
    ub.UB_ID, ub.UB_Date_Earned,
    b.Badge_ID, b.Badge_Level
FROM 
    Users u
JOIN 
    Rider r ON u.User_ID = r.User_ID
JOIN 
    Event_Participation ep ON r.Rider_ID = ep.Rider_ID
JOIN 
    Event e ON ep.Event_ID = e.Event_ID
JOIN 
    Feedback f ON u.User_ID = f.User_ID
JOIN 
    User_Badge ub ON u.User_ID = ub.User_ID
JOIN 
    Badge b ON ub.Badge_ID = b.Badge_ID
WHERE 
     e.Event_Status = 'Upcoming'
  AND f.Feedback_Response_Status = 'Responded'
  AND ub.UB_Admin_Granted = 'No';