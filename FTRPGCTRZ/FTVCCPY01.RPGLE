     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate cct payment amount/ccy - detail')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCCPY01  - Validate Payment Amount/Currency                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD000091           Date 07May13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15291           Date 12Nov07               *
      *                 BUG15148           Date 26Oct07               *
      *                 BUG15128           Date 25Oct07               *
      *                 CSW207A            Date 08Jul07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 16Jul03               *
      *                 220004             Date 24Jul03               *
      *                 CRE008             Date 19Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 07Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15291 - The system does not accept (/) followed by        *
      *             a valid IBAN  as a valid account.                 *
      *  BUG15148 - IBAN Reference being truncated when passed to     *
      *             access object.                                    *
      *  BUG15128 - Error in Credit Transfer Amount and Payment       *
      *             Currency in CCTD Details Entry                    *
      *  CSW207A - Swift 2007 Changes                                 *
      *  CSW207 - Swift 2007 Changes                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CRE008 - Cash Management                                     *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+                                             CRE008
      ** ¦ F-specs                              ¦                                             CRE008
      ** ¦ =======                              ¦                                             CRE008
      ** +--------------------------------------+                                             CRE008
                                                                                              CRE008
      ** Midas FT Customer Credit Transfer details                                            CRE008
     FFT102DL1  IF   E           K DISK    INFSR(*PSSR)                                       CRE008
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Currency standing data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for ICd
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
                                                                                              CRE008
      ** Externally described DS for SAR details                                              CRE008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE008
     D   SLCD        E                     EXTFLD(LCD)                                        CRE008
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for access programs (Long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * OK Flags for First screen - detail
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for second screen - detail
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for First screen - header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      * OK Flags for second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)
 
      ** External Data structure to hold the outgoing record format
     D ACcnt         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)
 
      ** Define full account details                                                          CRE008
     D*WkORCDS**       DS            18                                                CRE008 CGL029
     D WkORCDS         DS                                                                     CGL029
     D   WkBRCA                1      3                                                       CRE008
     D***WkCNUM*               4      9  0                                             CRE008 CSD027
     D   WkCNUM                4      9                                                       CSD027
     D   WkCCY                10     12                                                       CRE008
     D***WkACOD*              13     16  0                                             CRE008 CGL029
     D***WkACSQ*              17     18  0                                             CRE008 CGL029
     D   WkACOD               13     22  0                                                    CGL029
     D   WkACSQ               23     24  0                                                    CGL029
                                                                                              CRE008
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
 
     D PType           S                   LIKE(PRtcd)
 
     D CalcXRate       S             13P 8 Import
 
     D CFT004          S              1    INZ('N')
 
     D PAcct           S             35
     D*Pacct1***       S             34                                                     BUG15148
     D Pacct1          S             35                                                     BUG15148
 
     D RespMode        S              1
 
      ** Indicator for ft0010 if 0 has been entered in payment amount field
     D ZerInd          S              1
 
     D DDSName         S             10
 
     D WValid          S              1    INZ('Y')
 
      ** Work field for % rate discrepancy
     D WBtpcrd         S              5  2
 
     D WAmt            S             15
     D TAmt            S             13
 
     D ZField          S             16A
     D WField          S             16A
     D WField1         S             16  0
     D WField2         S             16  0
     D WField3         S             16  0
 
     D DateIn          S              6A
     D DayNoOut        S              5P 0
     D ErrorFlag       S              1A
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D POPTN           S              7                                                       CGL014
     D PSARD           S              6                                                       CGL014
 
      *
      ** Data Structure for P#INDC of FT0010
      *
     DIndc             DS
     DWindc1                   1      1
     DWindc2                   2      2
     DWindc3                   3      3
     DWindc4                   4      4
     DWindc5                   5      5
 
      ** Parameters used for call to RE101901                                                 CRE008
     D PRetCode        S              7                                                       CRE008
     D PInBranch       S              3                                                       CRE008
     D*PInCust**       S              6  0                                             CRE008 CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3                                                       CRE008
     D*PInACode*       S              4  0                                             CRE008 CGL029
     D PInACode        S             10  0                                                    CGL029
     D PInASeqN        S              2  0                                                    CRE008
     D PDebAmnt        S             15  0                                                    CRE008
     D POutBranch      S              3                                                       CRE008
     D*POutCust*       S              6  0                                             CRE008 CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3                                                       CRE008
     D*POutACode       S              4  0                                             CRE008 CGL029
     D POutACode       S             10  0                                                    CGL029
     D POutASeqN       S              2  0                                                    CRE008
     D POutRetNo       S             10  0                                                    CRE008
                                                                                              CRE008
     D*WkACodeC*       S              4                                                CRE008 CGL029
     D WkACodeC        S             10                                                       CGL029
     D WkASeqNC        S              2                                                       CRE008
     D WkCustC         S              6                                                       CRE008
     D WkRetNoC        S             10                                                       CRE008
     D WAcctType       S              1                                                       CRE008
     D WDebAmnt        S             15  0                                                    CRE008
                                                                                              CRE008
     D CRE008          S              1                                                       CRE008
                                                                                              CRE008
      ** Swift 2007                                                                           CSW207
     D CSW207          S              1                                                       CSW207
     D RetCd           S              7                                                       CSW207
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                              CSW207
     D/COPY FTCPYSRC,FT0010D001
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialise fields
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      OKPAmt     = 'Y'
     C                   EVAL      OKPCcy     = 'Y'
     C                   EVAL      ZerInd     = 'N'
     C                   EVAL      PType      = *Blanks
      *
      ** Extract Fund Transfer Details
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     Rtcd              7
     C                   PARM      '*FIRST '     Optn              7
     C     SDFTFR        PARM      SDFTFR        Dsfdy
      *
     C                   IF        Rtcd <> *BLANKS
     C                   Z-ADD     001           Dbase
     C                   MOVEL     'SDFTFRPD'    DBfile
     C                   MOVEL     'CFT006'      DbKey
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBtPcRd = BtPcRd / 100
     C                   ENDIF
      *
      ** Validate both fields, depending on whether incoming or out going msg
      *
     C                   IF        HPCcttyp = 'BO'
     C                   EXSR      ValidateO
     C                   ENDIF
      *
     C                   IF        HPCcttyp = 'BI'
     C                   EXSR      ValidateI
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateO - Validate fields                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOCURRR0, Valccy                                       *
      *                                                               *
      *****************************************************************
      *
     C     ValidateO     BEGSR
      *
     C                   IF        PPayCCy <> *Blanks
      *
      ** If entered, Payment currency must be valid on the system and
      ** must be in the same currency as the ordering customers account
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PPayCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0152'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** If valid currency, ensure that outgoing payment currency is
      ** in same currency as ordering customer account
      *
     C                   ELSE
     C                   SELECT
     C                   WHEN      HPCustth = 'I' OR HPCUstth = 'G' OR
     C                             HPCustth = 'F' OR HPCUstth = 'R'
     C                   EVAL      PAcct = HPTocus1
     C                   EXSR      ValCcy
      *
     C                   WHEN      PCusttd = 'I' OR PCusttd = 'G' OR
     C                             PCusttd = 'F' OR PCusttd = 'R'
     C                   EVAL      PAcct = POrdCu1
     C                   EXSR      ValCcy
      *
     C                   WHEN      HPOrdItp = 'I' OR HPOrdItp = 'G' OR
     C                             HPOrdItp = 'F' OR HPOrdItp = 'R'
     C                   EVAL      PAcct = HPOinst3
     C                   EXSR      ValCcy
      *
     C                   WHEN      POrdItp = 'I' OR POrdItp = 'G' OR
     C                             POrdItp = 'F' OR POrdItp = 'R'
     C                   EVAL      PAcct = POrdi35
     C                   EXSR      ValCcy
      *
     C                   OTHER
      *
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0276'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ENDSL
     C                   ENDIF
      *
      ** If Payment currency is blank then default it to ordering cust valid
      ** account
      *
     C                   ELSE
     C                   SELECT
     C                   WHEN      HPCustth = 'I' OR HPCUstth = 'G' OR
     C                             HPCustth = 'F' OR HPCUstth = 'R'
     C                   EVAL      PAcct = HPTocus1
     C                   EXSR      ValCcy
     C                   EXSR      Default
      *
     C                   WHEN      PCusttd = 'I' OR PCusttd = 'G' OR
     C                             PCusttd = 'F' OR PCusttd = 'R'
     C                   EVAL      PAcct = POrdCu1
     C                   EXSR      ValCcy
     C                   EXSR      Default
      *
     C                   WHEN      HPOrdItp = 'I' OR HPOrdItp = 'G' OR
     C                             HPOrdItp = 'F' OR HPOrdItp = 'R'
     C                   EVAL      PAcct = HPOinst3
     C                   EXSR      ValCcy
     C                   EXSR      Default
      *
     C                   WHEN      POrdItp = 'I' OR POrdItp = 'G' OR
     C                             POrdItp = 'F' OR POrdItp = 'R'
     C                   EVAL      PAcct = POrdi35
     C                   EXSR      ValCcy
     C                   EXSR      Default
      *
     C                   OTHER
      *
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0276'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
     C                   ENDIF
      *
      ** Ensure that currency exists on the system
      *
     C                   IF        PPayCcy <> *Blanks
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PPayCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0152'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PPayAmt = *Blanks
     C                   EVAL      OkPamt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0275'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
      *
      ** N.B. Only validate Payment Amount if currency valid - to
      ** avoid database errors.
      *
     C                   IF        OKPCcy <> 'N'
      *
      ** Format amount field and ZADIG
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL(P)  PPayAmt       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
                                                                                              CRE008
     C                   MOVE(P)   ZFIELD        WDebAmnt                                     CRE008
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0154'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** If Amount is OK format entry to aprropriate decimal places.
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   EVAL      PPayAmt = *Blanks
     C                   MOVE      ZFIELD        PPayAmt
                                                                                              CGL014
      ** Check if account has sufficient funds to cover blocked amount                        CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'  AND  ATYP = 'R'  AND                         CGL014
     C                             COLF = 'Y'                                                 CGL014
                                                                                              CGL014
     C                   CALLB     'FTVCHKFD'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM                    HdrRcdIn                                     CGL014
     C                   PARM                    DtlRcdIn                                     CGL014
                                                                                              CGL014
      ** Error:  Available balance is not sufficient                                          CGL014
      ** to cover blocked amount                                                              CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*BLKERR'                                          CGL014
     C                   EVAL      OkPAmt = 'N'                                               CGL014
     C                   EVAL      Idx = Idx + 1                                              CGL014
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'                                 CGL014
     C                   EVAL      MsgIdXAr(Idx) = 'FTA0140'                                  CGL014
     C                   EVAL      RetCodeIn = 'Error'                                        CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Warning:  Balance is greater than blocked amount but less                            CGL014
      ** than minimum balance; minimum balance will be exceeded                               CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*WARN  '                                          CGL014
     C                   EVAL      OkPAmt = 'W'                                               CGL014
     C                   EVAL      WIx = WIx + 1                                              CGL014
     C                   EVAL      WFldNmXAr(WIx) = 'PPayAmt'                                 CGL014
     C                   EVAL      WMsgIdXAr(WIx) = 'FTA0141'                                 CGL014
     C                   EVAL      RetCodeIn = 'Warn'                                         CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
      *
      ** If CRE008 is on and account is retail, check the account's overdraft limit.          CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y'  AND  WAcctType = 'R'                         CRE008
                                                                                              CRE008
      ** If Ordering Customer is in "header", debit amount is                                 CRE008
      ** the sum of the details' payment amounts.                                             CRE008
                                                                                              CRE008
     C                   IF        HPTOCUS1 <> *BLANKS                                        CRE008
                                                                                              CRE008
      ** Compute total payment amount.                                                        CRE008
                                                                                              CRE008
     C                   EVAL      PDebAmnt = WDebAmnt                                        CRE008
                                                                                              CRE008
     C     PCCTID        SETLL     FT102DL1                                                   CRE008
     C     PCCTID        READE     FT102DL1                                                   CRE008
                                                                                              CRE008
     C                   DOW       NOT %EOF(FT102DL1)                                         CRE008
                                                                                              CRE008
     C                   IF        TRNSID <> PTRNSID                                          CRE008
     C                   EVAL      PDebAmnt = PDebAmnt + PAYAMT                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C     PCCTID        READE     FT102DL1                                                   CRE008
     C                   ENDDO                                                                CRE008
                                                                                              CRE008
     C                   EXSR      SRODLChk                                                   CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
      ** If Ordering Customer is in "detail", debit amount is the payment amount.             CRE008
                                                                                              CRE008
     C**********         IF        PORDCU1 <> *BLANKS  AND                             CRE008 CSW207
     C**********                   OKOCU1 = 'Y'  AND  OKOCU2 = 'Y'  AND                CRE008 CSW207
     C**********                   OKOCU3 = 'Y'  AND  OKOCU4 = 'Y'                     CRE008 CSW207
     C                   IF        (PORDCU1 <> *BLANKS  AND                                   CSW207
     C                             OKOCU1 = 'Y'  AND  OKOCU2 = 'Y'  AND                       CSW207
     C                             OKOCU3 = 'Y'  AND  OKOCU4 = 'Y')                           CSW207
     C                             OR (PORDCU1 <> *BLANKS AND                                 CSW207
     C                             OKOCU1 = 'Y' AND OKOCU2 = 'Y' AND                          CSW207
     C                             OKOCU3 = 'Y' AND OKOCU4 = 'Y' AND                          CSW207
     C                             OKOCU5 = 'Y' AND CSW207 = 'Y')                             CSW207
     C                   EVAL      PDebAmnt = WDebAmnt                                        CRE008
     C                   EXSR      SRODLChk                                                   CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateI - Validate incoming fields                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOCURRR0, Valccy                                       *
      *                                                               *
      *****************************************************************
      *
     C     ValidateI     BEGSR
      *
      ** Payment Amount is mandatory (but will be defaulted if not entered)
      *
     C                   IF        PPayCCy <> *Blanks
      *
      ** If entered, Payment currency must be valid on the system and
      ** must be in the same currency as the beneficiary's account
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PPayCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0152'
     C                   EVAL      RetCodeIn = 'Error'
      *
      ** If valid currency, ensure that outgoing payment currency is
      ** in same currency as beneficiary's account
      ** unless out going payment is set to 'Y' whereupon must be the same
      ** as transfer currency
      *
     C                   ELSE
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
      *
     C                   IF        PGopflg = 'Y'
     C                   IF        PcctCcy <> *blanks AND PPayCcy <> PCctccy
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0371'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ELSE
      *
     C                   SELECT
      *
     C                   WHEN      PBenttd = 'I' OR PBenttd = 'G' OR
     C                             PBenttd = 'F' OR PBenttd = 'R'
     C                   EVAL      PAcct = PBenf1
     C                   EXSR      ValCcy
      *
     C                   WHEN      PAwitp = 'I' OR PAwitp = 'G' OR
     C                             PAwitp = 'F' OR PAwitp = 'R'
     C                   EVAL      PAcct = PAcci35
     C                   EXSR      ValCcy
      *
     C                   OTHER
      *
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0278'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
      *
      ** If Payment currency is blank then default it to Beneficiary's valid
      ** account identifier unless generateoutgoing payment is set to 'Y'
      ** then it must be in the same currency as the transfer currency
      *
     C                   ELSE
      *
     C                   IF        PGopflg = 'Y'
     C                   IF        PcctCcy <> *blanks
     C                   EVAL      Ppayccy = PcctCcy
     C                   ENDIF
     C                   ELSE
      *
     C                   SELECT
      *
     C                   WHEN      PBenttd = 'I' OR PBenttd = 'G' OR
     C                             PBenttd = 'F' OR PBenttd = 'R'
     C                   EVAL      PAcct = PBenf1
     C                   EXSR      ValCcy
     C                   EXSR      Default
      *
     C                   WHEN      PAwitp = 'I' OR PAwitp = 'G' OR
     C                             PAwitp = 'F' OR PAwitp = 'R'
     C                   EVAL      PAcct = PAcci35
     C                   EXSR      ValCcy
     C                   EXSR      Default
      *
     C                   OTHER
      *
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0278'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDSL
     C                   ENDIF
      *
      ** When Defaulted Payment currency must be valid on the system
      *
     C                   IF        PPayCCy <> *Blanks
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PPayCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0278'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** N.B. Only validate Payment Amount if currency valid - to
      ** avoid database errors.
      *
     C                   IF        OKPCcy = 'Y'
     C                   IF        PPayAmt <> *Blanks
      *
      ** Only validate amounts with respect to transfer currency if charges
      ** have been entered.
      *
     C                   IF        PCctAmt <> *blanks AND OKCtam <> 'N'
      *
      *** Get number of DP for debit (transfer currency)
      *
     C                   IF        PcctCcy  <> *Blanks
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PCctccy       CCY               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0279'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVEL     A6NBDP        CCtAmtDP          1 0
     C                   ENDIF
      *
      ** Format amount field and ZADIG
      *
     C                   CLEAR                   P#0010
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C                   MOVE (P)  WAmt          ZFIELD
     C                   EXSR      SRalgn
     C                   IF        OKPAmt = 'Y'
     C                   MOVE      ZField        P#CrAm
      *
      ** If credit amount is equal to zero then default it from FT0010
     C                   IF        P#CrAm = *Zeros
     C                   EVAL      ZerInd = 'Y'
     C                   ELSE
     C                   EVAL      ZerInd = 'N'
     C                   ENDIF
     C                   EVAL      P#CrCY = PPayCcy
     C                   EVAL      P#DbCY = PCctCcy
     C                   EVAL      P#Ovrt = PXRateO
     C                   EVAL      P#Rate = CalcXRate
     C                   EVAL      P#RTDS = WBTPCRD
     C                   EVAL      P#Sdin = 'Y'
     C
     C                   IF        OKCvdt <> 'N' AND PCrDvDt <> *Blanks
     C                   CALLB     'ZDATE1'
     C                   PARM      PCRDVDT       DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   EVAL      P#Crdt = DayNoOut
     C                   ENDIF
     C                   IF        OKDbvDt <> 'N' AND HPDbtVdt <> *Blanks
     C                   CALLB     'ZDATE1'
     C                   PARM      HPDbtVdt      DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   EVAL      P#Dbdt = DayNoOut
     C                   ENDIF
      *
     C                   SELECT
      *
     C                   WHEN      PCcyChg = 'OUR' OR
     C                             HPCctChg = 'OUR' OR
     C                             PCcyChg = 'SHA' OR
     C                             HPCctChg = 'SHA' OR
     C                             PCcyChg = 'BEN' OR
     C                             HPCctChg = 'BEN'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PCctAmt
     C                   EVAL      A6NBDP =  CctAmtDP
     C                   MOVE (P)  WAmt          ZFIELD
     C                   EXSR      SRalgn
     C                   MOVE      ZField        P#DbAm
     C                   ENDSL
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   MOVEL     P#Indc        Indc
      *
      ** Credit (Payment amount) incorrect
      *
     C                   IF        P#Rtcd <> *blanks
     C                   Z-ADD     002           Dbase
     C                   MOVEL     'FT0010'      DBfile
     C                   MOVEL     'CFT006'      DbKey
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        Windc3 = '1'
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0281'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   IF        ZerInd = 'Y'
     C                   MOVE (P)  P#CrAm        TAmt
      ** If Amount is OK and not equal to blanks then
      ** format entry to aprropriate decimal places.
      *
     C                   IF        TAmt <> *Blanks
     C                   MOVE (P)  Tamt          Zfield
     C                   EVAL      A6NBDP = PayAmtDP
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PPayAmt
     C                   MOVE      ZFIELD        PPayAmt
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If transfer amount is blank, then this is an error
      *
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'PPayAmt'                                 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0279'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Format amount field and ZADIG once amount has been validated
      *
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      WAmt = PPayAmt
     C                   EVAL      A6NBDP = PayAmtDP
     C                   MOVE (P)  WAmt          ZFIELD
     C                   EXSR      Sralgn
      *
      ** If Amount is OK format entry to aprropriate decimal places.
      *
     C                   IF        OkPamt = 'Y'
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PPayAmt
     C                   MOVE      ZFIELD        PPayAmt
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Payment amount is blank then default it
      *
     C                   IF        PCctAmt <> *blanks AND OkCtam <> 'N'
     C                   IF        PPayCcy <> *Blanks
      *
      *** Get number of DP for debit (transfer currency)
      *
     C                   IF        PcctCcy  <> *Blanks
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PCctccy       CCY               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0279'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVEL     A6NBDP        CCtAmtDP          1 0
     C                   ENDIF
      *
     C                   CLEAR                   P#0010
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      P#CrCY = PPayCcy
     C                   EVAL      P#DbCY = PcctCcy
     C                   EVAL      P#Ovrt = PXRateO
     C                   EVAL      P#Rate = CalcXRate
     C                   EVAL      P#RTDS = WBTPCRD
     C                   EVAL      P#Sdin = 'Y'
      *
     C                   IF        OKCvdt <> 'N' AND PCrDvDt <> *Blanks
     C                   CALLB     'ZDATE1'
     C                   PARM      PCRDVDT       DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   EVAL      P#Crdt = DayNoOut
     C                   ENDIF
      *
     C                   IF        OKDbvDt <> 'N' AND HPDbtVdt <> *Blanks
     C                   CALLB     'ZDATE1'
     C                   PARM      HPDbtVdt      DateIn
     C                   PARM                    DayNoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   EVAL      P#Dbdt = DayNoOut
     C                   ENDIF
      *
     C                   SELECT
      *
     C                   WHEN      PccyChg = 'OUR' OR
     C                             HPcctChg = 'OUR'OR
     C                             PCcyChg = 'SHA' OR
     C                             HPCctChg = 'SHA' OR
     C                             PCcyChg = 'BEN' OR
     C                             HPCctChg = 'BEN'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PCctAmt
     C                   EVAL      A6NBDP =  CCtAmtDP
     C                   MOVE (P)  WAmt          ZFIELD
     C                   EXSR      SRalgn
     C                   MOVE      ZField        P#DbAm
     C                   ENDSL
      *
     C                   IF        OkPamt = 'Y'
      *
     C                   EVAL      P#CrAm = *Zeros
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   IF        P#Rtcd <> *Blanks
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0279'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVE (P)  P#CrAm        TAmt
      *
      ** If Amount is OK and not equal to blanks then
      ** format entry to aprropriate decimal places.
      *
     C                   IF        TAmt <> *Blanks
     C                   MOVE (P)  Tamt          Zfield
     C                   EVAL      A6NBDP = PayAmtDP
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PPayAmt
     C                   MOVE      ZFIELD        PPayAmt
     C                   ELSE
      *
      ** If Payment amount is still blank, then this is an error
      *
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0286'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If transfer amount is blank, then this is an error
      *
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0279'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRALGN   : To call ZALIGN                                    *
      *                                                               *
      *  CALLED BY: ValidateO, ValidateI                              *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
      *
     C     Sralgn        BEGSR
      *
      ** Format amount field and ZADIG
      *
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkPAmt = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PPayAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0154'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DEFAULT  : callb to exchange rate to defualt it              *
      *                                                               *
      *  CALLED BY: ValidateO, ValidateI                              *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
      *
     C     Default       BEGSR
      *
      ** Validate/default exchange rate
      *
     C                   CALLB     'FTVEXRT02'
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDs2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
      *
     C                   IF        RetCodeIN <> *Blanks
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 5
     C                   EVAL      DBMod = 'FTVEXRT02'
     C                   EVAL      DBProc = 'Default'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValCcy - Validate Currency is same as account identifier      *
      *                                                               *
      * Called by: Validate                                           *
      *                                                               *
      * Calls: ValAcct                                                *
      *                                                               *
      *****************************************************************
      *
     C     ValCCy        BEGSR
      *
      ** Test to see which type of account identifier has been entered
      *
     C                   EXSR      ValAcct
     C                   MOVE      *Blanks       Ccy               3
      *
      ** Determine the currncy depending on the account identifier
      *
     C                   SELECT
      *
     C                   WHEN      PType = '*LEDGER'
      *   Len                            Start
     C     3             SUBST     Dssdy:8       CCY
      *
     C                   WHEN      PType = '*NOSTRO'
     C     3             SUBST     DssDy:1       CCy
      *
     C                   WHEN      PType = '*RETAIL'
     C     3             SUBST     DssDy:8       CCy
      *
     C                   WHEN      PType = 'IBAN'
     C     3             SUBST     DssDy:8       CCy
      *
     C                   ENDSL
      *
      ** Check to see if ccy is the same as the ordering customers/
      ** institution ccy     OR
      ** Check to see if ccy is the same as the beneficiary/account with
      ** institution ccy
      *
     C                   IF        CCy <> PPayCcy
     C                   IF        PPayCcy <> *BLanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0277'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   EVAL      PPayCcy = Ccy
     C                   IF        PPayCcy = *BLanks
     C                   EVAL      OkPCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      RetCodeIn = 'Error'
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PPAYCCY'                                 CAP084
     C                   IF        HPCcttyp = 'BO'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0276'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0278'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValAcct  - Checks for valid account                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: AOIBANR2, AOACCTV1                                     *
      *                                                               *
      *****************************************************************
      *
     C     ValAcct       BEGSR
      *
     C                   EVAL      PType = *Blanks
     C                   EVAL      WValid = 'Y'
      *
     C                   IF        CFT004 = 'Y'
      *
      ** Validate Account
      *
     C                   IF        %SUBST(PAcct:1:1) = '/'                                  BUG15128
     C**********         MOVE      PACCT         PACCT1                             CSW207A BUG15291
     C                   EVAL      PACCT1 = %SUBST(PACCT:2)                                 BUG15291
     C                   ELSE                                                               BUG15128
     C                   EVAL      PAcct1 = PAcct                                           BUG15128
     C                   ENDIF                                                              BUG15128
                                                                                             CSW207A
     C                   CALLB     'AOIBANR2'
     C                   PARM      *Blanks       PRtcd
     C**********         PARM                    PAcct            35                         CSW207A
     C                   PARM                    PACCT1                                      CSW207A
     C     Accnt         PARM      Accnt         DSSDY
      *
     C                   IF        PRtcd = *Blanks
     C                   EVAL      PType = 'IBAN'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PType <> 'IBAN'
      *
      ** Validate Account
      *
     C                   CALLB     'AOACCTV1'
     C                   PARM      *Blanks       PRtcd             7            B:Return code
     C                   PARM                    PType             7            I:A/c ID
     C                   PARM                    PAcct            35            I:A/c Currency
     C**********         PARM      *Blanks       DSSDY                          I:A/c code    CGL014
     C     Accnt         PARM      Accnt         DSSDY                                        CGL014
     C                   ENDIF
      *
      ** Invalid Account
      *
     C                   IF        PType <> 'IBAN' AND
     C                             PType <> '*NOSTRO'  AND
     C                             PType <> '*RETAIL'  AND
     C                             PType <> '*LEDGER' OR
     C                             PRtcd <> *Blanks
     C                   EVAL      Wvalid = 'N'
     C                   ENDIF
      *
      ** If CRE008 is on and account is retail, set up full account details.                  CRE008
                                                                                              CRE008
     C                   EVAL      WkORCDS = *BLANKS                                          CRE008
     C                   EVAL      WAcctType = *BLANK                                         CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y'  AND                                          CRE008
     C                             (PType = '*RETAIL'  OR  PType = '*LEDGER')                 CRE008
     C     1             SUBST     DSSDY:26      WAcctType                                    CRE008
                                                                                              CRE008
      ** Set up full account details: BRCA, CNUM, CCY, ACOD, ACSQ.                            CRE008
                                                                                              CRE008
     C                   EVAL      WkORCDS = %SUBST(DSSDY:23:3) +                             CRE008
     C                                       %SUBST(DSSDY:2:6)  +                             CRE008
     C                                       %SUBST(DSSDY:8:3)  +                             CRE008
     C**********                             %SUBST(DSSDY:11:4) +                      CRE008 CGL029
     C                                       %SUBST(DSSDY:554:10) +                           CGL029
     C                                       %SUBST(DSSDY:15:2)                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR
      *
      *****************************************************************                       CRE008
     C/EJECT                                                                                  CRE008
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      *  SRODLChk - Overdraft Limit Check                             *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
                                                                                              CRE008
     C     SRODLChk      BEGSR                                                                CRE008
                                                                                              CRE008
     C                   EVAL      PInBranch = WkBRCA                                         CRE008
     C                   EVAL      PInCust   = WkCNUM                                         CRE008
     C                   EVAL      PInCurr   = WkCCY                                          CRE008
     C                   EVAL      PInACode  = WkACOD                                         CRE008
     C                   EVAL      PInASeqN  = WkACSQ                                         CRE008
                                                                                              CRE008
     C                   CALLB     'RE101901'                                                 CRE008
                                                                                              CRE008
      ** Return Code                                                                          CRE008
                                                                                              CRE008
     C                   PARM      *BLANKS       PRetCode                                     CRE008
                                                                                              CRE008
      ** Input parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch Code                                                                          CRE008
      ** Customer                                                                             CRE008
      ** Currency                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Debit Amount (Payment Amount)                                                        CRE008
                                                                                              CRE008
     C                   PARM                    PInBranch                                    CRE008
     C                   PARM                    PInCust                                      CRE008
     C                   PARM                    PInCurr                                      CRE008
     C                   PARM                    PInACode                                     CRE008
     C                   PARM                    PInASeqN                                     CRE008
     C                   PARM                    PDebAmnt                                     CRE008
                                                                                              CRE008
      ** Ouput parameters                                                                     CRE008
      ** ----------------                                                                     CRE008
                                                                                              CRE008
      ** Branch                                                                               CRE008
      ** Customer                                                                             CRE008
      ** Currency                                                                             CRE008
      ** Account Code                                                                         CRE008
      ** Account Sequence                                                                     CRE008
      ** Retail Account No. of account in error                                               CRE008
                                                                                              CRE008
     C                   PARM                    POutBranch                                   CRE008
     C                   PARM                    POutCust                                     CRE008
     C                   PARM                    POutCurr                                     CRE008
     C                   PARM                    POutACode                                    CRE008
     C                   PARM                    POutASeqN                                    CRE008
     C                   PARM                    POutRetNo                                    CRE008
                                                                                              CRE008
      ** If overdraft limit exceeded, send warning message.                                   CRE008
                                                                                              CRE008
     C                   IF        PRetCode = '*ODLMTX'                                       CRE008
     C                   EVAL      OKPAMT = 'W'                                               CRE008
     C                   EVAL      WIx = WIx + 1                                              CRE008
     C                   EVAL      WMsgIDXAr(WIx) = 'FTA0131'                                 CRE008
     C                   EVAL      WFldNmXAr(WIx) = 'PPAYAMT'                                 CRE008
     C                   MOVE      POutCust      WkCustC                                      CRE008
     C                   MOVE      POutACode     WkACodeC                                     CRE008
     C                   MOVE      POutASeqN     WkASeqNC                                     CRE008
     C                   MOVE      POutRetNo     WkRetNoC                                     CRE008
                                                                                              CRE008
     C                   IF        POutRetNo = 0                                              CRE008
     C**********         EVAL      WMsgDtXAr(WIx) = POutBranch + '-' +  WkCustC      CRE008 MD000091
     C**********                    + '-' + POutCurr + '-' + WkACodeC                CRE008 MD000091
     C**********                    + '-' + WkASeqNC                                 CRE008 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +  WkCustC                  MD000091
     C                              + '-' + POutCurr + '-' + WkACodeC                       MD000091
     C                              + '-' + WkASeqNC                                        MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ELSE                                                                 CRE008
     C**********         EVAL      WMsgDtXAr(WIx) = POutBranch + '-' +  WkCustC      CRE008 MD000091
     C**********                    + '-' + POutCurr + '-' + WkACodeC                CRE008 MD000091
     C**********                    + '-' + WkASeqNC + '/' + WkRetNoC                CRE008 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +  WkCustC                  MD000091
     C                              + '-' + POutCurr + '-' + WkACodeC                       MD000091
     C                              + '-' + WkASeqNC + '/' + WkRetNoC                       MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(MsgDtaTmp)                MD000091
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR                                                                CRE008
                                                                                              CRE008
      *****************************************************************                       CRE008
     C/EJECT                                                                                  CRE008
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDs2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
      *
      ** Access SAR file to see if CFT004 is present
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CFT004'      @SARD             6
     C                   PARM                    DSFDY
      *
     C                   IF        @RTCD = *Blank
     C                   EVAL      CFT004 = 'Y'
     C                   ELSE
      *
     C                   IF        @RTCD = '*NRF'
     C                   EVAL      CFT004 = 'N'
     C                   ELSE
      *
      ** Database Error
      *
     C                   EVAL      DBKey  =  CFT004
     C                   EVAL      DBFile = 'AOSARDR0'
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      Dbase  = 4
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CRE008
      ** Check if switchable feature CRE008 is on.                                            CRE008
                                                                                              CRE008
     C                   CALLB     'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       @RTCD                                        CRE008
     C                   PARM      '*VERIFY'     @OPTN                                        CRE008
     C                   PARM      'CRE008'      @SARD                                        CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
      ** Database error.                                                                      CRE008
                                                                                              CRE008
     C                   IF        @RTCD <> *BLANKS AND                                       CRE008
     C                             @RTCD <> '*NRF   '                                         CRE008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE008
     C                   EVAL      DBASE = 6                                                  CRE008
     C                   EVAL      DBKEY = 'CRE008'                                           CRE008
     C                   EXSR      *PSSR                                                      CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   IF        @RTCD = *BLANKS                                            CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
     C                   ELSE                                                                 CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 7                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM                    Rtcd
     C                   PARM      '*FIRST '     Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        RTCD <> *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 3
     C                   EVAL      DBMod = 'FTVCCPY01'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSW207
      ** Check Swift 2007 is installed                                                        CSW207
                                                                                              CSW207
     C                   Call      'SWIF2007'                                                 CSW207
     C                   PARM                    RetCd                                        CSW207
                                                                                              CSW207
     C                   IF        RetCd = 'CSW2007'                                          CSW207
     C                   EVAL      CSW207 = 'Y'                                               CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      CSW207 = 'N'                                               CSW207
     C                   ENDIF                                                                CSW207
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
