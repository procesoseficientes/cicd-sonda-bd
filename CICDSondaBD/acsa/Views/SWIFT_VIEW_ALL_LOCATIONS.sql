﻿


CREATE VIEW [acsa].[SWIFT_VIEW_ALL_LOCATIONS]
AS
SELECT
	acsa.SWIFT_LOCATIONS.LOCATION
	, acsa.SWIFT_LOCATIONS.CODE_LOCATION
	, acsa.SWIFT_CLASSIFICATION.NAME_CLASSIFICATION AS CLASSIFICATION_LOCATION
	, acsa.SWIFT_LOCATIONS.HALL_LOCATION
	, acsa.SWIFT_LOCATIONS.ALLOW_PICKING
	, acsa.SWIFT_WAREHOUSES.DESCRIPTION_WAREHOUSE
	, acsa.SWIFT_LOCATIONS.CODE_WAREHOUSE
	, [BARCODE_LOCATION]
	, acsa.SWIFT_LOCATIONS.[DESCRIPTION_LOCATION]
	, acsa.SWIFT_LOCATIONS.[RACK_LOCATION]
	, acsa.SWIFT_LOCATIONS.[COLUMN_LOCATION]
	, acsa.SWIFT_LOCATIONS.[LEVEL_LOCATION]
	, acsa.SWIFT_LOCATIONS.[SQUARE_METER_LOCATION]
	, acsa.SWIFT_LOCATIONS.[FLOOR_LOCATION]
	, acsa.SWIFT_LOCATIONS.[ALLOW_STORAGE]
	, acsa.SWIFT_LOCATIONS.[ALLOW_RELOCATION]
	, acsa.SWIFT_LOCATIONS.[STATUS_LOCATION]
	, acsa.SWIFT_CLASSIFICATION.CLASSIFICATION AS CLASSIFICATION_ID
FROM acsa.SWIFT_LOCATIONS 
	LEFT OUTER JOIN acsa.SWIFT_CLASSIFICATION ON acsa.SWIFT_LOCATIONS.CLASSIFICATION_LOCATION = acsa.SWIFT_CLASSIFICATION.CLASSIFICATION 
	LEFT OUTER JOIN acsa.SWIFT_WAREHOUSES ON acsa.SWIFT_LOCATIONS.CODE_WAREHOUSE = acsa.SWIFT_WAREHOUSES.CODE_WAREHOUSE









GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SWIFT_LOCATIONS (acsa)"
            Begin Extent = 
               Top = 75
               Left = 62
               Bottom = 239
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "SWIFT_WAREHOUSES (acsa)"
            Begin Extent = 
               Top = 5
               Left = 497
               Bottom = 125
               Right = 724
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SWIFT_CLASSIFICATION (acsa)"
            Begin Extent = 
               Top = 170
               Left = 473
               Bottom = 290
               Right = 713
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'acsa', @level1type = N'VIEW', @level1name = N'SWIFT_VIEW_ALL_LOCATIONS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'acsa', @level1type = N'VIEW', @level1name = N'SWIFT_VIEW_ALL_LOCATIONS';

