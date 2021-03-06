

CREATE VIEW [acsa].[SWIFT_VIEW_SBO_ORDER_DETAIL]
AS
SELECT
  t.SAP_REFERENCE AS Doc_Entry,
  t.TXN_QTY AS Quantity,
  t.TXN_CODE_SKU AS Item_Code,
  so.Obj_Type AS Obj_Type,
  ISNULL(so.Line_Num, -1) AS Line_Num
FROM acsa.SWIFT_TXNS AS t
LEFT OUTER JOIN [$(CICDInterfacesBD)].acsa.ERP_ORDER_DETAIL AS so
  ON t.TXN_CODE_SKU  = so.Item_Code
  AND t.SAP_REFERENCE = so.Doc_Entry
WHERE (t.TXN_CATEGORY = 'PI')
AND (ISNULL(t.TXN_IS_POSTED_ERP, 0) = 0)











