﻿
CREATE VIEW [acsa].[SWIFT_VIEW_SBO_ORDER_HEADER] as 
SELECT     TOP (1) 
so.DocEntry AS Doc_Entry, 
so.CardCode AS Card_Code, 
so.CardName AS Card_Name, 
'N' AS Hand_Written, 
ISNULL(t.TXN_CREATED_STAMP, GETDATE()) AS Doc_Date, 
so.Comments,
so.DocCur AS Doc_Cur, 
so.DocRate AS Doc_Rate, 
so.DiscPrcnt AS Disc_Prcnt, 
so.Address, so.Address2, 
so.Ship_To_Address_Type, 
so.Ship_To_Street, 
so.Ship_To_State, 
so.Ship_To_Country,
so.TrnspCode AS Trnsp_Code, 
so.DocDueDate AS Doc_Due_Date, 
so.SlpCode AS Sales_PersonCode, 
'01' AS Warehouse, 
CAST(NULL AS varchar) AS U_Estado2, 
CAST(NULL AS varchar) AS U_STATUS_DESPACHO, 
CAST(NULL AS varchar) AS U_usuario, 
CAST(NULL AS varchar) AS U_FacSerie, 
CAST(NULL AS varchar) AS U_FacNit, 
CAST(NULL AS varchar) AS U_FacNom, 
CAST(NULL AS varchar) AS U_Tienda, 
CAST(NULL AS varchar) AS U_SUCURSAL, 
CAST(NULL AS varchar) AS U_TIPO_DOCUMENTO, 
CAST(NULL AS varchar) AS U_Total_Flete, 
CAST(NULL AS varchar) AS U_Tipo_Pago, 
CAST(NULL AS varchar) AS U_Cuotas, 
CAST(NULL AS varchar) AS U_Total_Tarjeta
FROM acsa.SWIFT_TXNS AS t INNER JOIN
            (SELECT so.DocEntry, so.DocNum, so.DocType, so.CANCELED, so.Handwrtten, so.Printed, so.DocStatus, so.InvntSttus, so.Transfered, so.ObjType, so.DocDate, so.DocDueDate, so.CardCode, 
                    so.CardName, so.Address, so.NumAtCard, so.VatPercent, so.VatSum, so.VatSumFC, so.DiscPrcnt, so.DiscSum, so.DiscSumFC, so.DocCur, so.DocRate, so.DocTotal, so.DocTotalFC, 
                    so.PaidToDate, so.PaidFC, so.GrosProfit, so.GrosProfFC, so.Ref1, so.Ref2, so.Comments, so.JrnlMemo, so.TransId, so.ReceiptNum, so.GroupNum, so.DocTime, so.SlpCode, 
                    so.TrnspCode, so.PartSupply, so.Confirmed, so.GrossBase, so.ImportEnt, so.CreateTran, so.SummryType, so.UpdInvnt, so.UpdCardBal, so.Instance, so.Flags, so.InvntDirec, 
                    so.CntctCode, so.ShowSCN, so.FatherCard, so.SysRate, so.CurSource, so.VatSumSy, so.DiscSumSy, so.DocTotalSy, so.PaidSys, so.FatherType, so.GrosProfSy, so.UpdateDate, 
                    so.IsICT, so.CreateDate, so.Volume, so.VolUnit, so.Weight, so.WeightUnit, so.Series, so.TaxDate, so.Filler, so.DataSource, so.StampNum, so.isCrin, so.FinncPriod, so.UserSign, 
                    so.selfInv, so.VatPaid, so.VatPaidFC, so.VatPaidSys, so.UserSign2, so.WddStatus, so.draftKey, so.TotalExpns, so.TotalExpFC, so.TotalExpSC, so.DunnLevel, so.Address2, 
                    so.LogInstanc, so.Exported, so.StationID, so.Indicator, so.NetProc, so.AqcsTax, so.AqcsTaxFC, so.AqcsTaxSC, so.CashDiscPr, so.CashDiscnt, so.CashDiscFC, so.CashDiscSC, 
                    so.ShipToCode, so.LicTradNum, so.PaymentRef, so.WTSum, so.WTSumFC, so.WTSumSC, so.RoundDif, so.RoundDifFC, so.RoundDifSy, so.CheckDigit, so.Form1099, so.Box1099, 
                    so.submitted, so.PoPrss, so.Rounding, so.RevisionPo, so.Segment, so.ReqDate, so.CancelDate, so.PickStatus, so.Pick, so.BlockDunn, so.PeyMethod, so.PayBlock, so.PayBlckRef, 
                    so.MaxDscn, so.Reserve, so.Max1099, so.CntrlBnk, so.PickRmrk, so.ISRCodLine, so.ExpAppl, so.ExpApplFC, so.ExpApplSC, so.Project, so.DeferrTax, so.LetterNum, so.FromDate, 
                    so.ToDate, so.WTApplied, so.WTAppliedF, so.BoeReserev, so.AgentCode, so.WTAppliedS, so.EquVatSum, so.EquVatSumF, so.EquVatSumS, so.Installmnt, so.VATFirst, so.NnSbAmnt, 
                    so.NnSbAmntSC, so.NbSbAmntFC, so.ExepAmnt, so.ExepAmntSC, so.ExepAmntFC, so.VatDate, so.CorrExt, so.CorrInv, so.NCorrInv, so.CEECFlag, so.BaseAmnt, so.BaseAmntSC, 
                    so.BaseAmntFC, so.CtlAccount, so.BPLId, so.BPLName, so.VATRegNum, so.TxInvRptNo, so.TxInvRptDt, so.KVVATCode, so.WTDetails, so.SumAbsId, so.SumRptDate, so.PIndicator, 
                    so.ManualNum, so.UseShpdGd, so.BaseVtAt, so.BaseVtAtSC, so.BaseVtAtFC, so.NnSbVAt, so.NnSbVAtSC, so.NbSbVAtFC, so.ExptVAt, so.ExptVAtSC, so.ExptVAtFC, so.LYPmtAt, 
                    so.LYPmtAtSC, so.LYPmtAtFC, so.ExpAnSum, so.ExpAnSys, so.ExpAnFrgn, so.DocSubType, so.DpmStatus, so.DpmAmnt, so.DpmAmntSC, so.DpmAmntFC, so.DpmDrawn, so.DpmPrcnt, 
                    so.PaidSum, so.PaidSumFc, so.PaidSumSc, so.FolioPref, so.FolioNum, so.DpmAppl, so.DpmApplFc, so.DpmApplSc, so.LPgFolioN, so.Header, so.Footer, so.Posted, so.OwnerCode, 
                    so.BPChCode, so.BPChCntc, so.PayToCode, so.IsPaytoBnk, so.BnkCntry, so.BankCode, so.BnkAccount, so.BnkBranch, so.isIns, so.TrackNo, so.VersionNum, so.LangCode, 
                    so.BPNameOW, so.BillToOW, so.ShipToOW, so.RetInvoice, so.ClsDate, so.MInvNum, so.MInvDate, so.SeqCode, so.Serial, so.SeriesStr, so.SubStr, so.Model, so.TaxOnExp, 
                    so.TaxOnExpFc, so.TaxOnExpSc, so.TaxOnExAp, so.TaxOnExApF, so.TaxOnExApS, so.LastPmnTyp, so.LndCstNum, so.UseCorrVat, so.BlkCredMmo, so.OpenForLaC, so.Excised, 
                    so.ExcRefDate, so.ExcRmvTime, so.SrvGpPrcnt, so.DepositNum, so.CertNum, so.DutyStatus, so.AutoCrtFlw, so.FlwRefDate, so.FlwRefNum, so.VatJENum, so.DpmVat, so.DpmVatFc, 
                    so.DpmVatSc, so.DpmAppVat, so.DpmAppVatF, so.DpmAppVatS, so.InsurOp347, so.IgnRelDoc, so.BuildDesc, so.ResidenNum, so.Checker, so.Payee, so.CopyNumber, so.SSIExmpt, 
                    so.PQTGrpSer, so.PQTGrpNum, so.PQTGrpHW, so.ReopOriDoc, so.ReopManCls, so.DocManClsd, so.ClosingOpt, so.SpecDate, so.Ordered, so.NTSApprov, so.NTSWebSite, 
                    so.NTSeTaxNo, so.NTSApprNo, so.PayDuMonth, so.ExtraMonth, so.ExtraDays, so.CdcOffset, so.SignMsg, so.SignDigest, so.CertifNum, so.KeyVersion, so.EDocGenTyp, so.ESeries, 
                    so.EDocNum, so.EDocExpFrm, so.OnlineQuo, so.POSEqNum, so.POSManufSN, so.POSCashN, so.EDocStatus, so.EDocCntnt, so.EDocProces, so.EDocErrCod, so.EDocErrMsg, 
                    so.EDocCancel, so.EDocTest, so.EDocPrefix, so.CUP, so.CIG, so.DpmAsDscnt, so.Attachment, so.AtcEntry, so.SupplCode, so.GTSRlvnt, so.BaseDisc, so.BaseDiscSc, so.BaseDiscFc, 
                    so.BaseDiscPr, so.CreateTS, so.UpdateTS, so.SrvTaxRule, so.AnnInvDecR, so.Supplier, so.Releaser, so.Receiver, so.AgrNo, so.IsAlt, so.AltBaseTyp, so.AltBaseEnt, so.PaidDpm, 
                    so.PaidDpmF, so.PaidDpmS, so.U_Guatex, so.U_KM, so.Ship_To_Address_Type AS Ship_To_Address_Type, so.Ship_To_Street AS Ship_To_Street, so.Ship_To_State AS Ship_To_State, 
                    so.Ship_To_Country AS Ship_To_Country
			FROM [$(CICDInterfacesBD)].acsa.[ERP_ORDER_HEADER] so ) AS so ON so.DocEntry = t.SAP_REFERENCE
WHERE (so.DocStatus = 'O') AND (so.DocType = 'I') AND (t.TXN_CATEGORY = 'PI') AND (ISNULL(t.TXN_IS_POSTED_ERP, 0) = 0)









