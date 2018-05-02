--Source https://sqlperformance.com/2015/10/extended-events/capture-plan-warnings?utm_source=ebook&utm_medium=pdf&utm_term=Michael&utm_content=5&utm_campaign=ebook

-- Define event session
CREATE EVENT SESSION [InterestingPlanEvents]
ON SERVER
ADD EVENT sqlserver.missing_column_statistics
(
  ACTION(sqlserver.database_id,sqlserver.plan_handle,sqlserver.sql_text)
  WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0))
    AND [sqlserver].[database_id]>(4))
),
ADD EVENT sqlserver.missing_join_predicate
(
  ACTION(sqlserver.database_id,sqlserver.plan_handle,sqlserver.sql_text)
  WHERE ([sqlserver].[is_system]=(0) AND [sqlserver].[database_id]>(4))
),
ADD EVENT sqlserver.plan_affecting_convert
(
  ACTION(sqlserver.database_id,sqlserver.plan_handle,sqlserver.sql_text)
  WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0))
    AND [sqlserver].[database_id]>(4))
),
ADD EVENT sqlserver.unmatched_filtered_indexes
(
  ACTION(sqlserver.plan_handle,sqlserver.sql_text)
  WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0))
    AND [sqlserver].[database_id]>(4))
)
ADD TARGET package0.event_file
(
  SET filename=N'C:\temp\InterestingPlanEvents.xel' /* change location if appropriate */
)
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,
MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,
TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO
 
-- Start the event session
ALTER EVENT SESSION [InterestingPlanEvents] ON SERVER STATE=START;
GO