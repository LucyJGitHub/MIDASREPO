     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF RE Extract Interest History')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE000003 - RE IIS Capitalisation Extract                     *
      *                                                               *
      *  Function:  This program will check if an Interim Interest    *
      *             Statement is required for today's COB for         *
      *             capitalisation.                                   *
      *                                                               *
      *  Called By: REC000002                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD032091           Date 27Jan15               *
      *  Prev Amend No. CRE101   *Create   Date 01Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032091 - New flag for back-valuations (Recompile)          *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Error Indicator                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  Main routine                                                 *
      *  *INZSR         - Initialise                                  *
      *  SrInit         - Initial processing                          *
      *  *PSSR          - Error handling subroutine                   *
      *  SrProcess      - Main processing                             *
      *  SrIntHistory   - Extract Interest history                    *
      *  SrCurPeriod    - Process Current period                      *
      *  SrClearSetUp   - Set-up output record                        *
      *  SrDrRateInfo   - Extract Debit rate                          *
      *  SrCrRateInfo   - Extract Credit rate                         *
      *  SrFormatWrite  - Format writes                               *
      *  SrAccrualRecs  - Accrual records processing                  *
      *  SrTieredRate   - Find Tiered rates                           *
      *  SrGetRate      - Extract rates                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FReHisl    IF   E           K Disk
     F                                     Prefix(Rh_)
 
     FReHPosRl  IF   E           K Disk
     F                                     Prefix(Rr_)
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger ICD details
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACCD1       E                     EXTFLD(QQACCD)
      ** External DS for Retail ICD details
 
     D O_IntHis      E DS                  ExtName(ReIntHTD)
 
     D C_IntHis      E DS                  ExtName(ReIntHTD)
     D                                     Prefix(Ct_)
 
     D S_IntHis      E DS                  ExtName(ReIntHTD)
     D                                     Prefix(Sv_)
 
     D/COPY ZACPYSRC,PSDS
      ** The Following /COPY Line Includes All The Defined Fields In
      ** The PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
 
      ** +--------------------------------------+
      ** ¦ Arrays AND Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D LIST1_DS        DS
     D  IIsCnum                1      6
     D  IIsCcy                 7      9
     D  IIsAcod               10     19  0
     D  IIsAcsq               20     21  0
     D  IIsBrca               22     24
     D  IIsAcno               25     34  0
     D  IRaGadi               35     41P 0
     D  IRaGaci               42     48P 0
     D  IRaDaic1              49     55P 0
     D  IRaMadi               56     62P 0
     D  IRaCaic1              63     69P 0
     D  IRaMaci               70     76P 0
 
     D I_Rate          DS            36
     D   I_Rate30              1     30
 
     D I_Balance       DS            48
     D   I_Balance40           1     40
 
     D T_Rate          DS
 
     D   T_Rate1Def            1     36
     D   T_Rate2Def           37     66
     D   T_RateDef             1     66
     D   T_Rat                             Like(Rh_DrIr)  Dim(11)
     D                                     Overlay(T_RateDef)
 
     D T_Balance       DS
     D   T_Balance1Df          1     48
     D   T_Balance2Df         49     88
     D   T_BalanceDef          1     88
     D   T_Bal                             Like(Rh_HisB) Dim(11)
     D                                     Overlay(T_BalanceDef)
 
     D R_RateDta       DS
     D   D_RateDef             1     66
     D   D_Rat                             Like(Rh_DrIr)  Dim(11)
     D                                     Overlay(D_RateDef)
     D   D_BalanceDef         67    154
     D   D_Bal                             Like(Rh_HisB) Dim(11)
     D                                     Overlay(D_BalanceDef)
     D   C_RateDef           155    220
     D   C_Rat                             Like(Rh_DrIr)  Dim(11)
     D                                     Overlay(C_RateDef)
     D   C_BalanceDef        221    306
     D   C_Bal                             Like(Rh_HisB) Dim(11)
     D                                     Overlay(D_BalanceDef)
 
     D LDA             DS           256
      ** Local data area for database error details
 
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBTXT                184    256
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Counter         S              6S 0
     D Dr_Rate         S                   Like(IhDrIr)
     D Dr_Intp         S                   Like(IhDiCt)
     D Dr_Inst         S                   Like(IhDcst)
     D Dr_Dric         S                   Like(IhDric)
     D Cr_Rate         S                   Like(IhCrIr)
     D Cr_Intp         S                   Like(IhDiCt)
     D Cr_Inst         S                   Like(IhDcst)
     D Cr_Cric         S                   Like(IhCric)
     D Posted_Cr       S                   Like(IhCrAc)
     D Posted_Dr       S                   Like(IhDrAc)
     D W_IhDrAc        S                   Like(IhDrAc)
     D W_IhCrAc        S                   Like(IhCrAc)
     D W_IhDrAB        S                   Like(IhDrAB)
     D W_IhCrAB        S                   Like(IhCrAB)
     D Sv_IIsCnum      S                   Like(IhCnum)
     D Sv_IIsAcod      S                   Like(IhAcod)
     D Sv_IIsAcsq      S                   Like(IhAcsq)
     D Sv_IIsBrca      S                   Like(IhBrca)
     D Sv_IIsCcy       S                   Like(IhCcy)
     D Dr_Aodr         S                   Like(IhAodr)
 
     D WRun            S              1
 
     IRehisppf      01
     IRehispsf      02
     IRehispmf      03
 
     IRehpos1f      04
     IRehpos2f      05
     IRehpos3f      06
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  MAIN - Processing                                            *
      *****************************************************************
 
      * Initialisation
     C                   Exsr      SrInit
 
      * Process request
     C                   Exsr      SrProcess
 
     C                   Movel     *On           *InLr
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInit - Initialisation routine                               *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr
 
      * Initial Clears
     C                   Clear                   O_IntHis
     C                   Clear                   C_IntHis
     C                   Clear                   S_IntHis
     C                   Clear                   Dr_Rate
     C                   Clear                   Cr_Rate
     C                   Clear                   W_IhDrAb
     C                   Clear                   W_IhCrAb
     C                   Clear                   Cr_Intp
     C                   Clear                   Cr_Inst
     C                   Clear                   Dr_Intp
     C                   Clear                   Dr_Inst
     C                   Clear                   Dr_Aodr
 
     C                   move      *Blanks       Sv_IIsCnum
     C                   move      *Blanks       Sv_IIsBrca
     C                   move      *Blanks       Sv_IIsCcy
     C                   z-add     0             Sv_IIsAcod
     C                   z-add     0             Sv_IIsAcsq
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrProcess - Main processing                                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrProcess     Begsr
 
      * Process only accounts in RESTMTTD with Extract Status = *blanks and
      * Statement Generation Date = Today
 
     C/Exec SQL
     C+ Declare LIST1 cursor for
     C+ Select ISCNUM, ISCCY, ISACOD, ISACSQ, ISBRCA, ISACNO,
     C+  b.gadi, b.gaci, b.daic1, b.madi, b.caic1, b.maci
     C+ From RESTMTTD
     C+ Inner Join REACRD b ON b.Brca = IsBrca and b.Cust = IsCnum and
     C+ b.ACCY = IsCcy and b.Acod = IsAcod AND b.Aseq = IsAcsq
     C+                          where ISSTAT = ' '
     C+                          and   ISSTMD <= :Bjrdnb
     C+ Order by
     C+       ISCNUM, ISCCY, ISACOD, ISACSQ, ISBRCA, ISACNO
     C/End-Exec
 
     C/Exec SQL
     C+ Open LIST1
     C/End-Exec
 
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   eval      DBASE = 3
     C                   eval      DBFILE = 'SQL STM'
     C                   eval      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   EndIf
 
     C/Exec SQL
     C+ fetch next
     C+   From LIST1
     C+   into :LIST1_DS
     C/End-Exec
 
     C                   Dow       SQLCode <> 100
 
     C                   If        Sv_IIsCnum <> IIsCnum or
     C                             Sv_IIsAcod <> IIsAcod or
     C                             Sv_IIsCcy <> IIsCcy or
     C                             Sv_IIsAcsq <> IIsAcsq or
     C                             Sv_IIsBrca <> IIsBrca
 
     C                   z-add     0             Rh_Hisd
     C                   z-add     0             Rr_Hisd
     C                   z-add     0             Rr_Drcr
     C                   Exsr      SrInit
 
      * Position on History
     C                   Exsr      SrIntHistory
 
     C                   Eval      Sv_IIsCnum = IIsCnum
     C                   Eval      Sv_IIsAcod = IIsAcod
     C                   Eval      Sv_IIsAcsq = IIsAcsq
     C                   Eval      Sv_IIsBrca = IIsBrca
     C                   Eval      Sv_IIsCcy = IIsCcy
 
     C                   Endif
 
     C/Exec SQL
     C+ Fetch next from LIST1
     C+   into :LIST1_DS
     C/End-Exec
      *
     C                   Enddo
 
      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCode < 100
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
      *
     C/Exec SQL
     C+ Close LIST1
     C/End-Exec
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrIntHistory -                                                *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrIntHistory  Begsr
 
      * Position on History
     C     KRehislP      Setll     Rehisl
     C                   Movea     '000'         *In(01)
     C     KRehislR      Reade     Rehisl                                 90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
 
     C                   Exsr      SrClearSetUp
 
      * Credit Extract Rate
     C                   If        Rh_CrCi <> *blanks
     C                   Exsr      SrCrRateInfo
     C                   Eval      IhCrIr = Cr_Rate
     C                   Eval      IhCict = Cr_Intp
     C                   Eval      IhCcst = Cr_Inst
     C                   Eval      IhCric = Cr_Cric
     C                   Else
     C                   If        Rh_Cict <> 0
     C                   Eval      Rr_DrCr = 1
     C                   Exsr      SrGetRate
     C                   Eval      IhCrIr = Cr_Rate
     C                   Eval      IhCict = Cr_Intp
     C                   Eval      IhCcst = Cr_Inst
     C                   Eval      IhCric = Cr_Cric
     C                   Endif
     C                   Endif
 
      * Debit Extract Rate
     C                   If        Rh_DrCi <> *blanks
     C                   Exsr      SrDrRateInfo
     C                   Eval      IhDrIr = Dr_Rate
     C                   Eval      IhDict = Dr_Intp
     C                   Eval      IhDcst = Dr_Inst
     C                   Eval      IhDric = Dr_Dric
     C                   Else
     C                   If        Rh_Dict <> 0
     C                   Eval      Rr_DrCr = 0
     C                   Exsr      SrGetRate
     C                   Eval      IhDrIr = Dr_Rate
     C                   Eval      IhDict = Dr_Intp
     C                   Eval      IhDcst = Dr_Inst
     C                   Eval      IhDric = Dr_Dric
     C                   Endif
     C                   Endif
 
      * O/D Rate
     C                   Eval      Dr_Aodr = Rh_Aodr
     C                   Eval      IhAodr = Dr_Aodr
 
     C                   Exsr      SrFormatWrite
 
     C                   Movea     '000'         *In(01)
     C     KRehislR      Reade     Rehisl                                 90
     C                   Enddo
 
      * Process current Period
     C                   Exsr      SrCurPeriod
 
     C                   Endif
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCurPeriod -                                                 *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCurPeriod   Begsr
 
 
      * Write last record as today
     C                   Exsr      SrClearSetUp
      * Carried forward history record
     C                   Eval      IhStrt = 'E'
     C                   Eval      IhMvnt = 'E'
      * Accrued Interest
     C                   Eval      IhDrIa = IRaGaDi
     C                   Eval      IhCrIa = IRaGaCi
     C                   Eval      IhDrAc = IRaDaIc1 + IRaMaDi
     C                   Eval      IhCrAc = IRaCaIc1 + IRaMaCi
 
      * Adjust for back valued adjustments
     C                   Eval      W_IhDrAb = W_IhDrAb - IRaGaDi
     C                   Eval      W_IhCrAb = W_IhCrAb - IRaGaCi
 
      * History date
 
      * If accrual profit date is before next working day and greater than today use
     C                   If        BkApDt > BjRdNb And
     C                             BkApDt < BjDNWD
     C                   Eval      IhHisd = BkApDt
     C                   Else
     C                   Eval      IhHisd = BjRdNb
     C                   Endif
 
      * Number of Days
 
      * If accrual profit date is before next working day and greater than today use
     C                   If        BMLDAI = 'Y'
     C                   Eval      IhAday = IhHisd - Sv_IhHisd
     C                   Else
     C                   Eval      IhAday = IhHisd - Sv_IhHisd + 1
     C                   Endif
 
      * Save data
     C                   Eval      C_IntHis = O_IntHis
      * Process Accruals
     C                   Exsr      SrAccrualRecs
      * Restore data
     C                   Eval      O_IntHis = C_IntHis
 
     C                   Eval      IhDrAb = W_IhDrAb
     C                   Eval      IhCrAb = W_IhCrAb
 
      * Write Final Record
     C                   Exsr      SrWrReIntH
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrClearSetUp -                                                *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrClearSetUp  Begsr
 
     C                   Clear                   O_IntHis
 
     C                   Eval      IhBrca = Rh_Brca
     C                   Eval      IhCnum = Rh_Cnum
     C                   Eval      IhCcy  = Rh_Ccy
     C                   Eval      IhAcod = Rh_Acod
     C                   Eval      IhAcsq = Rh_Acsq
     C                   Eval      IhHisd = Rh_Hisd
 
     C                   Eval      IhAcno = IIsAcno
 
      * History balance
     C                   Eval      IhHisb = Rh_Hisb
 
      * Set Rate
     C                   Eval      IhDrIr = Dr_Rate
     C                   Eval      IhDict = Dr_Intp
     C                   Eval      IhDcst = Dr_Inst
     C                   Eval      IhDric = Dr_Dric
     C                   Eval      IhCrIr = Cr_Rate
     C                   Eval      IhCict = Cr_Intp
     C                   Eval      IhCcst = Cr_Inst
     C                   Eval      IhCric = Cr_Cric
     C                   Eval      IhAodr = Dr_Aodr
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDrRateInfo -                                                *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrDrRateInfo  Begsr
 
      * Debit Rate
     C                   Eval      Dr_Rate = Rh_DrIr
     C                   Clear                   Dr_Intp
     C                   Clear                   Dr_Inst
     C                   Clear                   Dr_Dric
      * If Tier then find rate
     C                   If        Rh_Dict <> 0
     C                   Eval      Rr_DrCr = 0
     C                   Eval      Rr_HisD = Rh_DrCd
     C                   Exsr      SrTieredRate
     C                   Endif
 
     C                   Movel     Rh_DrCb       Dr_Dric
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCrRateInfo -                                                *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrCrRateInfo  Begsr
 
      * Credit Rate
     C                   Eval      Cr_Rate = Rh_CrIr
     C                   Clear                   Cr_Intp
     C                   Clear                   Cr_Inst
     C                   Clear                   Cr_Cric
     C                   If        Rh_Cict <> 0
     C                   Eval      Rr_DrCr = 1
     C                   Eval      Rr_HisD = Rh_CrCd
     C                   Exsr      SrTieredRate
     C                   Endif
 
     C                   Movel     Rh_CrCb       Cr_Cric
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFormatWrite -                                               *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrFormatWrite Begsr
 
      * History date
     C                   Eval      IhHisd = Rh_Hisd
      * Number of Days
     C                   Eval      IhAday = Rh_Hisd - Sv_IhHisd
 
     C                   Select
 
      * Retail History Movement Summary
      *** access REHISPD
 
     C                   When      *In01 = *On
 
      * Brought forward history record
     C                   If        Rh_Reci = 'B'
     C                   Eval      IhStrt = 'S'
     C                   Eval      IhAday = 0
     C                   Endif
 
      * Rate Change Information
     C                   Eval      IhDrCi = Rh_DrCi
     C                   Eval      IhCrCi = Rh_CrCi
 
     C                   Movel     Rh_DrCb       Dr_Dric
     C                   Movel     Rh_CrCb       Cr_Cric
      * Check for movements
     C                   Select
     C                   When      Rh_DMvt <> 0 Or Rh_CMvt <> 0
     C                   Eval      IhMvnt = 'M'
     C                   Eval      IhDMvt = Rh_DMvt
     C                   Eval      IhCMvt = Rh_CMvt
     C                   Other
     C                   Eval      IhMvnt = 'Y'
     C                   Endsl
 
      * Accrued Interest
     C                   Eval      IhDrAc = Rh_Daid + Rh_TMaDi - Rh_MaDi
     C                   Eval      IhCrAc = Rh_Caid + Rh_TMaCi - Rh_MaCi
 
      * Capitalisation
      *** access REHISPM
     C                   When      *In02 = *On
 
     C                   Eval      IhMvnt = 'C'
 
      * Accrued Interest
     C                   Eval      IhDrAc = Rh_Daid
     C                   Eval      IhCrAc = Rh_Caid
 
     C                   Movel     Rh_DrCb       Dr_Dric
     C                   Movel     Rh_CrCb       Cr_Cric
 
      * Debit Capitalisation
     C                   Eval      IhDrIa = Rh_SGaDi
     C                   Eval      IhDrIp = Rh_DrIp  + Rh_TmaDi
     C                   If        Rh_Reci = 'S' and Rh_SDiCi <> *blanks
     C                   Eval      IhDrCp = 'Y'
     C                   Endif
 
      * Credit Capitalisation
     C                   Eval      IhCrIa = Rh_SGaCi
     C                   Eval      IhCrIp = Rh_CrIp + Rh_TmaCi
     C                   If        Rh_Reci = 'S' and Rh_SCiCi <> *blanks
     C                   Eval      IhCrCp = 'Y'
     C                   Endif
 
      * Average Balance etc processing
      *** access REHISPS
     C                   When      *In03 = *On
 
     C                   Endsl
 
      * Save data
     C                   Eval      C_IntHis = O_IntHis
      * Process Accruals
     C                   Exsr      SrAccrualRecs
      * Restore data
     C                   Eval      O_IntHis = C_IntHis
 
     C                   Eval      IhDrAb = W_IhDrAb
     C                   Eval      IhCrAb = W_IhCrAb
 
     C                   Exsr      SrWrReIntH
 
      * Check for Manual Adjustment, Create record with these details
      *** access REHISPD
     C                   If        *In01 = *On
     C                   If        Rh_MaDi <> 0 Or Rh_MaCi <> 0
     C                   Eval      IhMvnt = 'J'
     C                   Eval      IhDMvt = 0
     C                   Eval      IhCMvt = 0
 
      * Accrued Interest
     C                   Eval      IhDrAc = Rh_MaDi
     C                   Eval      IhCrAc = Rh_MaCi
 
      * Total Interest
     C                   Eval      IhDrAb = Rh_Daid + Rh_TMaDi
     C                   Eval      IhCrAb = Rh_Caid + Rh_TMaCi
 
     C                   Eval      W_IhDrAb = Rh_Daid + Rh_TMaDi
     C                   Eval      W_IhCrAb = Rh_Caid + Rh_TMaCi
 
     C                   Exsr      SrWrReIntH
      * Reset Interest Accrual
     C                   Eval      IhDrAc = Rh_Daid + Rh_TMaDi
     C                   Eval      IhCrAc = Rh_Caid + Rh_TMaCi
 
     C                   Endif
     C                   Endif
 
      * Reset Accrued to date for capitalisations
      *** access REHISPM
     C                   If        *In02 = *On
     C                   If        IhDrCp = 'Y'
     C                   Eval      W_IhDrAb = W_IhDrAb - Ct_IhDrIp
     C                   Endif
     C                   If        IhCrCp = 'Y'
     C                   Eval      W_IhCrAb = W_IhCrAb - Ct_IhCrIp
     C                   Endif
     C                   Endif
 
      * Save data
     C                   Eval      S_IntHis = O_IntHis
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrAccrualRecs -                                               *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrAccrualRecs Begsr
 
      * Write last record as today
     C                   Exsr      SrClearSetUp
      * If Sv_IntHis used then process
     C                   If        Sv_IhBrca <> *blanks and
     C                             Ct_IhADay > 0
 
      * History balance and date
     C                   Eval      IhMvnt = 'A'
     C                   Eval      IhHisb = Sv_IhHisb
     C                   Eval      IhHisd = Sv_IhHisd
     C                   Eval      IhCrIr = Sv_IhCrIr
     C                   Eval      IhDrIr = Sv_IhDrIr
     C                   Eval      IhDric = Sv_IhDric
     C                   Eval      IhCric = Sv_IhCric
     C                   Eval      IhAodr = Sv_IhAodr
      * Posted Accrual
     C                   Clear                   Posted_Cr
     C                   Clear                   Posted_Dr
      * Posted Accrual
     C                   Select
      * Debit
     C                   When      Ct_IhDrCp = 'Y'
     C*1*                Eval      W_IhDrAc = Ct_IhDrIp - Sv_IhDrAc
     C                   Eval      W_IhDrAc = Ct_IhDrIp + Ct_IhDrIa - Sv_IhDrAc
     C                   Other
     C                   Eval      W_IhDrAc = Ct_IhDrAc - Sv_IhDrAc
     C                   Endsl
      * Credit
     C                   Select
     C                   When      Ct_IhCrCp = 'Y'
     C*1*                Eval      W_IhCrAc = Ct_IhCrIp - Sv_IhCrAc
     C                   Eval      W_IhCrAc = Ct_IhCrIp + Ct_IhCrIa - Sv_IhCrAc
     C                   Other
     C                   Eval      W_IhCrAc = Ct_IhCrAc - Sv_IhCrAc
     C                   Endsl
      * Do for Accrual Days
     C                   Do        Ct_IhADay     Counter
 
     C                   Eval(h)   IhDrAc = (W_IhDrAc / Ct_IhADay) * Counter
     C                   Eval      IhDrAc = IhDrAc - Posted_Dr
     C                   Eval      Posted_Dr = Posted_Dr + IhDrAc
     C                   Eval      W_IhDrAb = W_IhDrAb + IhDrAc
 
     C                   Eval(h)   IhCrAc = (W_IhCrAc / Ct_IhADay) * Counter
     C                   Eval      IhCrAc = IhCrAc - Posted_Cr
     C                   Eval      Posted_Cr = Posted_Cr + IhCrAc
     C                   Eval      W_IhCrAb = W_IhCrAb + IhCrAc
 
     C                   Eval      IhDrAb = W_IhDrAb
     C                   Eval      IhCrAb = W_IhCrAb
 
     C                   Exsr      SrWrReIntH
 
     C                   Eval      IhHisd = IhHisd + 1
 
     C                   Enddo
     C                   Endif
 
     C                   EndSr
 
      **********************************************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTieredRate -                                                *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrTieredRate  Begsr
 
     C                   Clear                   T_Rate
     C                   Clear                   T_Balance
      * Clear depending on rate selected
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      Dr_Rate = 0
     C                   When      Rr_DrCr = 1
     C                   Eval      Cr_Rate = 0
     C                   Endsl
     C                   Eval      Rr_Rseq = '1'
 
      * Load Tier Rate
     C     KRehposRlp    Setll     Rehposrl
     C                   Movea     '000'         *In(04)
     C     KRehposRlr    Reade     RehposRl                               91
     C                   If        *In91 = *Off
     C                   Dou       *In91 = *On
      *
      *** access REHPOSR2
     C                   If        *In05 = *On
     C                   Eval      I_Rate = Rr_Rat2
     C                   Eval      T_Rate1Def = I_Rate
     C                   Eval      I_Balance = Rr_Bal2
     C                   Eval      T_Balance1Df = I_Balance
     C                   Endif
 
      *** access REHPOSR3
     C                   If        *In06 = *On
     C                   Eval      I_Rate = Rr_Rat3
     C                   Eval      T_Rate2Def = I_Rate30
     C                   Eval      I_Balance = Rr_Bal3
     C                   Eval      T_Balance2Df = I_Balance40
     C                   Endif
 
     C                   Movea     '000'         *In(04)
     C     KRehposRlr    Reade     RehposRl                               91
     C                   Enddo
     C                   Endif
 
      *** Store tier rates
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      D_RateDef = T_RateDef
     C                   Eval      D_BalanceDef = T_BalanceDef
     C                   Movel     Rr_InTp       Dr_Intp
     C                   Movel     Rr_InSt       Dr_Inst
     C                   When      Rr_DrCr = 1
     C                   Eval      C_RateDef = T_RateDef
     C                   Eval      C_BalanceDef = T_BalanceDef
     C                   Movel     Rr_InTp       Cr_Intp
     C                   Movel     Rr_InSt       Cr_Inst
     C                   Endsl
 
      * Get rate applicable to balance
     C                   Select
     C                   When      Rr_InTh = 0 or
     C                             %Abs(IhHisb) > Rr_InTh
 
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      Dr_Rate = T_Rat(1)
     C                   When      Rr_DrCr = 1
     C                   Eval      Cr_Rate = T_Rat(1)
     C                   Endsl
 
     C     2             Do        10            Counter
 
     C                   If        %Abs(IhHisb) >= T_Bal(Counter)
     C                             And T_Bal(Counter) > 0
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      Dr_Rate = T_Rat(Counter)
     C                   When      Rr_DrCr = 1
     C                   Eval      Cr_Rate = T_Rat(Counter)
     C                   Endsl
     C                   Endif
 
     C                   Enddo
     C                   Endsl
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetRate -                                                   *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrGetRate     Begsr
 
      *** Restore tier rates
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      T_RateDef = D_RateDef
     C                   Eval      T_BalanceDef = D_BalanceDef
     C                   When      Rr_DrCr = 1
     C                   Eval      T_RateDef = C_RateDef
     C                   Eval      T_BalanceDef = C_BalanceDef
     C                   Endsl
 
     C                   Select
     C                   When      Rr_InTh = 0 or
     C                             %Abs(IhHisb) > Rr_InTh
 
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      Dr_Rate = T_Rat(1)
     C                   When      Rr_DrCr = 1
     C                   Eval      Cr_Rate = T_Rat(1)
     C                   Endsl
 
     C     2             Do        10            Counter
 
     C                   If        %Abs(IhHisb) >= T_Bal(Counter)
     C                             And T_Bal(Counter) > 0
     C                   Select
     C                   When      Rr_DrCr = 0
     C                   Eval      Dr_Rate = T_Rat(Counter)
     C                   When      Rr_DrCr = 1
     C                   Eval      Cr_Rate = T_Rat(Counter)
     C                   Endsl
     C                   Endif
 
     C                   Enddo
     C                   Endsl
 
     C                   EndSr
 
      *****************************************************************
      *                                                               *
      * SrWrREIntH - Write details to REINTHTD                        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWrReIntH    Begsr
 
     C/exec SQL
     C+ insert into REINTHTD
     C+ values(:O_IntHis)
     C/end-exec
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSr - Program Initialisation Routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *InzSr        Begsr
 
      ** Read in data area
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  = 'RE000003'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBTXT  = *BLANKS
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
 
      ** Access Bank details
 
     C/exec SQL
     C+ select *
     C+ into :SDBANK
     C+ from SDBANKPD
     C/end-exec
 
     C     SQLCOD        Ifne      *Zeros
     C     *LOCK         In        LDA
     C                   eval      DBKey = '*FIRST'
     C                   eval      DBFile = 'SDBANKPD'
     C                   eval      DBase = 1
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Access GL ICD details
 
     C/exec SQL
     C+ select *
     C+ into :SDGELR
     C+ from SDGELRPD
     C/end-exec
 
     C     SQLCOD        Ifne      *Zeros
     C     *LOCK         In        LDA
     C                   eval      DBKey = '*FIRST'
     C                   eval      DBFile = 'SDGELRPD'
     C                   eval      DBase = 2
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
      * Get Retail ICD details
     C/exec SQL
     C+ select *
     C+ into :SDRETL
     C+ from SDRETLPD
     C/end-exec
 
     C     SQLCOD        Ifne      *Zeros
     C     *LOCK         In        LDA
     C                   eval      DBKey = '*FIRST'
     C                   eval      DBFile = 'SDRETLPD'
     C                   eval      DBase = 3
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
 
     C     KReHisLP      Klist
     C                   KFld                    IIsBrca
     C                   KFld                    IIsCnum
     C                   KFld                    IIsCcy
     C                   KFld                    IIsAcod
     C                   KFld                    IIsAcsq
     C                   KFld                    Rh_Hisd
 
     C     KReHisLR      Klist
     C                   KFld                    IIsBrca
     C                   KFld                    IIsCnum
     C                   KFld                    IIsCcy
     C                   KFld                    IIsAcod
     C                   KFld                    IIsAcsq
 
     C     KReHPosRlp    Klist
     C                   KFld                    IIsBrca
     C                   KFld                    IIsCnum
     C                   KFld                    IIsCcy
     C                   KFld                    IIsAcod
     C                   KFld                    IIsAcsq
     C                   KFld                    Rr_HisD
     C                   KFld                    Rr_DrCr
     C                   KFld                    Rr_RSeq
 
     C     KReHPosRlr    Klist
     C                   KFld                    IIsBrca
     C                   KFld                    IIsCnum
     C                   KFld                    IIsCcy
     C                   KFld                    IIsAcod
     C                   KFld                    IIsAcsq
     C                   KFld                    Rr_HisD
     C                   KFld                    Rr_DrCr
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ROLBK
     C                   RETURN
 
     C                   ENDSR
 
