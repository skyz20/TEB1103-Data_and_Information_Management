SELECT
  M.Motorcycle_ID,
  SC.SC_Name,
  SA.SA_Appointment_ID,
  SR.S_Record_ID,
  ME.Merchandise_Name,
  LR.LR_Reward_ID,
  MP.M_Purchase_ID,
  EV.Event_Name
FROM
  Motorcycle M
JOIN Service_Center SC ON M.SC_ID = SC.SC_ID
JOIN Service_Appointment SA ON M.Motorcycle_ID = SA.Motorcycle_ID
JOIN Service_Record SR ON M.Motorcycle_ID = SR.Motorcycle_ID
JOIN Merchandise_Purchase MP ON M.Motorcycle_ID = M.Motorcycle_ID  -- Dummy join
JOIN Merchandise ME ON MP.Merchandise_ID = ME.Merchandise_ID
JOIN Event EV ON ME.Event_ID = EV.Event_ID
JOIN Loyalty_Reward LR ON LR.M_Purchase_ID = MP.M_Purchase_ID
WHERE
  SC.SC_Service_Type = 'Full'                    -- From Service_Center
  AND SA.SA_Status = 'Completed'                 -- From Service_Appointment (Updated)
  AND ME.Merchandise_Availability_Status = 'Available' -- From Merchandise
  AND EV.Event_Status = 'Upcoming'               -- From Event
ORDER BY
  EV.Event_Name DESC;