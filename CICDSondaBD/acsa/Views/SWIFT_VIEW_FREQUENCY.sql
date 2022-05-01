﻿


CREATE VIEW [acsa].[SWIFT_VIEW_FREQUENCY]
AS
SELECT
	F.ID_FREQUENCY
	,F.CODE_FREQUENCY
	,CASE F.SUNDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_SUNDAY
	,CASE F.MONDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_MONDAY 
	,CASE F.TUESDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_TUESDAY
	,CASE F.WEDNESDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_WEDNESDAY
	,CASE F.THURSDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_THURSDAY
	,CASE F.FRIDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_FRIDAY
	,CASE F.SATURDAY WHEN 0 THEN 'No' ELSE 'Si' END VISIT_SATURDAY
	,CASE CAST(F.FREQUENCY_WEEKS AS VARCHAR)
	     WHEN '1' THEN '1 Semana' 
		 WHEN '2' THEN '2 Semanas'
		 WHEN '3' THEN '3 Semanas'
		 ELSE CAST(F.FREQUENCY_WEEKS AS VARCHAR)
	 END VISIT_FREQUENCY_WEEKS
	,F.LAST_WEEK_VISITED
	,F.LAST_UPDATED
	,F.LAST_UPDATED_BY
	,F.CODE_ROUTE
	,CASE F.TYPE_TASK
		WHEN 'SALE' THEN 'Venta'
		WHEN 'PRESALE' THEN 'Pre Venta'
		WHEN 'DELIVERY' THEN 'Entrega'
		ELSE F.TYPE_TASK 
	END AS TYPE_TASK_DESCRIPTION
	, F.TYPE_TASK
	,R.NAME_ROUTE  
	,F.SUNDAY
	,F.MONDAY
	,F.TUESDAY
	,F.WEDNESDAY
	,F.THURSDAY
	,F.FRIDAY
	,F.SATURDAY
	,F.FREQUENCY_WEEKS
FROM acsa.SWIFT_FREQUENCY F
INNER JOIN acsa.SWIFT_VIEW_ALL_ROUTE R ON (F.CODE_ROUTE = R.CODE_ROUTE)



