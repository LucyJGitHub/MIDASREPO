     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Transfer Ccy/Default Amt-Detai')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVTFCY01  - Validate Transfer CCy (Default transfer amount) *
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
      *                 MD030708A          Date 29Sep14               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15136           Date 25Oct07               *
      *                 BUG14947           Date 08Oct07               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CAP084             Date 16Jul03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 25Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030708A - A Serious Midas error occurred when entering     *
      *              an invalid character                             *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15136 - Applied BUG14947.                                 *
      *  BUG14947 - Same error message was displayed twice. Correct   *
      *             error message to display it distinctly.           *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CSW201 - SWIFT 2001 Standards Update (Recompiled)            *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
      *                                                               *
      *****************************************************************

      * CCT Detail file (keyed on CCTID)
     FFT102DL1  IF   E           K Disk    INFSR(*PSSR)
     F                                     PREFIX(D)                                          CGL014

      * CCT Header file (keyed on CCTID)
     FFT102HL3  IF   E           K Disk    INFSR(*PSSR) PREFIX(H)
                                                                                              CGL014
      ** RE Shadow balances file                                                              CGL014
     FMEMOSL2   IF   E           K DISK    INFSR(*PSSR)                                       CGL014

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

      ** Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)

      ** Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)

      ** External data structure for Currency standing data
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CGL014
      ** External data structure for Switchable features data                                 CGL014
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL014
     D  SLCD         E                     EXTFLD(LCD)                                        CGL014

      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** External data structure for Currency standing data
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for ICd
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      ** External Data structure to hold the outgoing record format
     D ACcnt         E DS                  EXTNAME(ACCNTAB)
     D   ACBRCA      E                     EXTFLD(BRCA)
     D   ACPRFC      E                     EXTFLD(PRFC)

      ** OK Flags for First screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)

      ** OK Flags for second screen
     D OKFlagDs2     E DS                  EXTNAME(FTE102S2PD)

      ** OK Flags for First screen - header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)

      ** OK Flags for second screen - header
     D OKFlagHs2     E DS                  EXTNAME(FTE102H2PD)

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

     D CalcXRate       S             13P 8 Import

      ** CFT004 switchable feature flag
     D CFT004          S              1A

      ** Numeric version of Transfer Amount
     D NumTRNAMT       S             15P 0

      ** Field to save Account Id of account entered in Ordering Cust.

      ** SUM Total of Transfer Amounts for all transactions in on CCtID.
     D SumTotal        S             15P 0

     D PType           S                   LIKE(Rtcd)

     D PAcct           S             35

     D RespMode        S              1

      ** Indicator for ft0010 if 0 has been entered in payment amount field
     D ZerInd          S              1

     D DDSName         S             10

      ** Work field for % rate discrepancy
     D WBtpcrd         S              5  2

     D WValid          S              1    INZ('Y')

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

      *
      ** Data Structure for P#INDC of FT0010
      *
     DIndc             DS
     DWindc1                   1      1
     DWindc2                   2      2
     DWindc3                   3      3
     DWindc4                   4      4
     DWindc5                   5      5
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D PRetCode        S              7                                                       CGL014
     D POption         S              7                                                       CGL014
     D PSard           S              6                                                       CGL014
     D W#Total         S             15  0                                                    CGL014
     D WAmount         S             15  0                                                    CGL014
     D WrkCLBLN        S             15  0                                                    CGL014
     D WTranAmt        S             15  0                                                    CGL014

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
     C                   EVAL      OKCtam     = 'Y'
     C                   EVAL      OKTCcy     = 'Y'
      *
      ** Reset work fields
      *
     C                   EVAL      ZALIGNok = 'Y'
     C                   EVAL      ZFIELD = *Blanks
     C                   EVAL      ZADEC = *Zero
     C                   EVAL      ZADIG = *Zero
      *
      ** Extract Fund Transfer Details
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     Rtcd              7
     C                   PARM      '*FIRST '     Optn              7
     C     SDFTFR        PARM      SDFTFR        Dsfdy
     C                   IF        Rtcd <> *BLANKS
     C                   Z-ADD     004           Dbase
     C                   MOVEL     'SDFTFRPD'    DBfile
     C                   MOVEL     'CFT006'      DbKey
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBtpcrd = Btpcrd / 100
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
      * Calls: AOCURRR0, SRalgn, FT0010                               *
      *                                                               *
      *****************************************************************
      *
     C     ValidateO     BEGSR
      *
      ** If entered, transfer currency must be valid on the system and
      ** must be in the same currency as total transfer currency
      *
     C                   IF        PCctCCy <> *Blanks
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PCctCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C*******************EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0147'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
     C                   MOVEL     A6NBDP        CCtAmtDP          1 0
      *
      ** If valid currency, ensure that outgoing transfer currency is
      ** in same currency total transfer currency
      *
     C                   IF        PcctCcy <> HPCCTCCY
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0282'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Transfer Ccy is blank then default it to the total transfer ccy
      *
     C                   EVAL      PCctCcy = HPCCTCCY
     C                   IF        PCctCcy = *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0282'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** When Defaulted transfer currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PCCTCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0282'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVEL     A6NBDP        CCTAmtDP          1 0
     C                   EXSR      Default
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Only validate/default Transfer Amount if Ccy is valid - to
      ** avoid database errors.
      *
     C                   IF        OKTCcy <> 'Y'
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0283'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
      *
      ** If transfer amount is not blank then validate else default it
      ** (need payment currency to default it)
      *
     C                   IF        PPayAmt <> *blanks AND OkPamt <> 'N'
     C                   IF        PcctAmt <> *blanks
      *
      *** Get number of DP for debit (payment currency)
      *
     C                   IF        PPayCcy  <> *Blanks
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PPayccy       CCY               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0285'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
     C                   ENDIF
      *
     C                   CLEAR                   P#0010
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      WAmt = PCCtAmt
     C                   EVAL      A6NBDP =  CCtAmtDP
     C                   EXSR      SRalgn
     C                   IF        OKCtam = 'Y'
     C                   MOVE      ZField        P#CrAm
      *
      ** If credit amount is equal to zero then default it from FT0010
     C                   IF        P#CrAm = *Zeros
     C                   EVAL      ZerInd = 'Y'
     C                   ELSE
     C                   EVAL      ZerInd = 'N'
     C                   ENDIF
     C                   EVAL      P#DbCY = PPayCcy
     C                   EVAL      P#CrCY = PCctCcy
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
     C                   WHEN      PCCyChg = 'OUR' OR
     C                             HPCCtChg = 'OUR'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C**********         EXSR      SRalgn                                                   BUG14947
     C                   EXSR      SRALGN2                                                  BUG14947
     C                   MOVE      ZField        P#DbAm
      *
     C                   WHEN      PCCyChg = 'SHA' OR
     C                             HPCCtChg = 'SHA'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C**********         EXSR      SRalgn                                                   BUG14947
     C                   EXSR      SRALGN2                                                  BUG14947
     C                   MOVE      ZField        P#DbAm
      *
     C                   WHEN      PCCyChg = 'BEN' OR
     C                             HPCCtChg = 'BEN'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C**********         EXSR      SRalgn                                                   BUG14947
     C                   EXSR      SRALGN2                                                  BUG14947
     C                   EVAL      Wfield1 = *Zeros
     C                   MOVE      ZField        Wfield1
     C**********         MOVE      PSndOcg       WAmt                                       BUG14947
     C                   EVAL      WAMT = *BLANKS                                           BUG14947
     C                   EVAL      WAMT = PSNDOCG                                           BUG14947
     C                   EXSR      SRalgn
     C                   EVAL      Wfield2 = *Zeros
     C                   MOVE      ZField        Wfield2
     C                   EVAL      Wfield3 = *Zeros
     C                   EVAL      Wfield3 = Wfield1 - Wfield2
     C                   EVAL      Wfield = *Blanks
     C                   MOVE      WField3       WField
     C                   MOVE      WField        P#DbAm
     C                   ENDSL
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   MOVEL     P#Indc        Indc
      *
      ** Credit (Transer amount) incorrect
      *
     C                   IF        P#Rtcd <> *blanks
     C                   Z-ADD     003           Dbase
     C                   MOVEL     'FT0010'      DBfile
     C                   MOVEL     'CFT006'      DbKey
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        Windc3 = '1'
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCctAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0284'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   IF        ZerInd = 'Y'
     C                   MOVE (P)  P#CrAm        TAmt
      ** If Amount is OK and not equal to blanks then
      ** format entry to aprropriate decimal places.
      *
     C                   IF        TAmt <> *Blanks
     C                   MOVE (P)  Tamt          Zfield
     C                   EVAL      A6NBDP = CCtAmtDP
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PCCtAmt
     C                   MOVE      ZFIELD        PCCtAmt
     C                   ENDIF
     C                   ELSE
      *
      ** Format amount field and ZADIG once amount has been validated
      *
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      WAmt = PCctAmt
     C                   EVAL      A6NBDP =  CCtAmtDP
     C                   EXSR      Sralgn
      *
      ** If no error in Amount, ensure it is greater than zero
      *
     C                   IF        OkCtam = 'Y'
     C                   MOVE      ZFIELD        NumTRNAMT
     C                   IF        NumTRNAMT <= 0
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCctAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0150'
     C                   ENDIF
      *
      ** If Amount is OK format entry to appropriate decimal places.
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PCctAmt
     C                   MOVE      ZFIELD        PCctAmt
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Transfer amount is blank then default it
      *
      *** Get number of DP for debit (payment currency)
      *
     C                   IF        PPayCcy  <> *Blanks
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PPayccy       CCY               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C*******************EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0285'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVEL     A6NBDP        PayAmtDP          1 0
     C                   ENDIF
      *
     C                   CLEAR                   P#0010
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      P#DbCY = PPayCcy
     C                   EVAL      P#CrCY = PCctCcy
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
     C                             HPcctChg = 'OUR'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C**********         EXSR      SRalgn                                                   BUG14947
     C                   EXSR      SRALGN2                                                  BUG14947
     C                   MOVE      ZField        P#DbAm
      *
     C                   WHEN      PccyChg = 'SHA' OR
     C                             HPcctChg = 'SHA'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C**********         EXSR      SRalgn                                                   BUG14947
     C                   EXSR      SRALGN2                                                  BUG14947
     C                   MOVE      ZField        P#DbAm
      *
     C                   WHEN      PCcyChg = 'BEN' OR
     C                             HPCctChg = 'BEN'
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PPayAmt
     C                   EVAL      A6NBDP =  PayAmtDP
     C**********         EXSR      SRalgn                                                   BUG14947
     C                   EXSR      SRALGN2                                                  BUG14947
     C                   EVAL      Wfield1 = *Zeros
     C                   MOVE      ZField        WField1
     C**********         MOVE      PSndOcg       WAmt                                       BUG14947
     C                   EVAL      WAMT = *BLANKS                                           BUG14947
     C                   EVAL      WAMT = PSNDOCG                                           BUG14947
     C                   EXSR      SRalgn
     C                   EVAL      Wfield2 = *Zeros
     C                   MOVE      ZField        WField2
     C                   EVAL      Wfield3 = *Zeros
     C                   EVAL      Wfield3 = Wfield1 - Wfield2
     C                   EVAL      Wfield = *Blanks
     C                   MOVE      WField3       WField
     C                   MOVE      WField        P#DbAm
     C                   ENDSL
      *
     C                   EVAL      P#CrAm = *Zeros
      *
     C                   CALLB     'FT0010'
     C                   PARM                    P#0010
      *
     C                   IF        P#Rtcd <> *Blanks
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCctAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0285'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   MOVE (P)  P#CrAm        TAmt
     C                   IF        TAmt <> *Blanks
     C                   MOVE (P)  Tamt          Zfield
      *
      ** If no error in Amount, ensure it is greater than zero
      *
     C                   MOVE      ZFIELD        NumTRNAMT
     C                   IF        NumTRNAMT <= 0
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCctAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0150'
     C                   ENDIF
      *
     C                   EVAL      A6NBDP =  CCtAmtDP
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PCCtAmt
     C                   MOVE      ZFIELD        PCCtAmt
      *
     C                   ELSE
      *
      ** If Transfer amount is still blank, then this is an error
      *
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCCtAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0287'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Payment amount is blank, then this is an error
      *
     C                   EVAL      OkCtAm = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCCtAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0285'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
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
      * Calls: AOCURRR0, sralgn, Sumtrn                               *
      *                                                               *
      *****************************************************************
      *
     C     ValidateI     BEGSR
      *
      ** If entered, Transfer currency must be valid on the system and
      ** must be in the same currency as total transfer currency
      *
     C                   IF        PCctCCy <> *Blanks
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PCctCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************** EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0147'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
      *
      ** If valid currency, ensure that outgoing transfer currency is
      ** in same currency total transfer currency
      *
     C                   IF        PcctCcy <> HPCctCcy
      *
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C*****************  EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0282'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Transfer Ccy is blank then default it to the total transfer ccy
      *
     C                   EVAL      PCctCcy = HPCctCcy
     C                   IF        PCctCcy = *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C*******************EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0282'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       Rtcd              7
     C                   PARM      '*KEY'        Optn              7
     C                   PARM      PCctCcy       Ccy               3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        Rtcd <> *Blanks
     C                   EVAL      OkTCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C****************   EVAL      FldNamXAr(Idx) = DDSName                     CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PCCTCCY'                   CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0147'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   EXSR      Default
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Only validate/default Transfer Amount if Ccy is valid - to
      ** avoid database errors.
      *
     C                   IF        OKTCcy <> 'Y'
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0283'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
      *
      ** Transfer amount is mandatory
      ** Must not include recivers charges but cannot be checked as payment
      ** amount minus recievers charges is defaulted from this amount
      *
     C                   IF        PCctAmt = *blanks
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0144'
     C                   EVAL      RetCodeIn = 'Error'
      *
     C                   ELSE
      *
      ** If not blank then ensure that it is in correct format
      *
     C                   EVAL      Wamt = *Blanks
     C                   EVAL      Wamt = PCctAmt
     C                   EXSR      Sralgn
     C                   IF        OKCtam = 'Y'
      *
      ** If no error in Amount, ensure it is greater than zero
      *
     C                   MOVE      ZFIELD        NumTRNAMT
     C                   IF        NumTRNAMT <= 0
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCctAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0150'
     C                   ELSE
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EXSR      SRAccount                                                  CGL014
     C                   IF        ATYP = 'R'  AND  COLF = 'Y'                                CGL014
                                                                                              CGL014
      ** Compute for the total transfer amount of all the credit details                      CGL014
      ** for this incoming credit transfer                                                    CGL014
                                                                                              CGL014
     C                   EVAL      W#Total = NumTRNAMT                                        CGL014
                                                                                              CGL014
     C     HPCCTID       SETLL     FT102DL1                                                   CGL014
     C     HPCCTID       READE     FT102DL1                                                   CGL014
                                                                                              CGL014
     C                   DOW       NOT %EOF(FT102DL1)                                         CGL014
                                                                                              CGL014
     C                   IF        DTRNSID <> PTRNSID                                         CGL014
     C                   IF        HPCCTCHG <> *BLANKS  OR  DCCYCHG <> *BLANKS                CGL014
                                                                                              CGL014
     C                   SELECT                                                               CGL014
     C                   WHEN      HPCCTCHG = 'OUR'  OR  DCCYCHG = 'OUR'                      CGL014
     C                   EVAL      W#Total = W#Total + DRCVCTF + DCCTAMT                      CGL014
                                                                                              CGL014
     C                   WHEN      HPCCTCHG = 'SHA'  OR  DCCYCHG = 'SHA'                      CGL014
     C                   EVAL      W#Total = W#Total + DCCTAMT                                CGL014
                                                                                              CGL014
     C                   WHEN      HPCCTCHG = 'BEN'  OR  DCCYCHG = 'BEN'                      CGL014
     C                   EVAL      W#Total = W#Total + DCCTAMT                                CGL014
     C                   ENDSL                                                                CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C     HPCCTID       READE     FT102DL1                                                   CGL014
     C                   ENDDO                                                                CGL014
                                                                                              CGL014
     C                   EVAL      WTranAmt = W#Total                                         CGL014
     C                   EXSR      SRValBlock                                                 CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
      *
      ** If Amount is OK format entry to aprropriate decimal places.
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      A6NBDP        ZADEC
      *
     C                   MOVE      *Blanks       PCctAmt
     C                   MOVE      ZFIELD        PCctAmt
     C                   ENDIF
      *
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
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRValBlock - Furthe validation for sufficient funds          *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     SRValBlock    BEGSR                                                                CGL014
                                                                                              CGL014
      ** Access MEMOS for the shadow cleared balance                                          CGL014
                                                                                              CGL014
     C     ACNO          CHAIN     MEMOSL2                                                    CGL014
                                                                                              CGL014
     C                   IF        %FOUND(MEMOSL2)                                            CGL014
     C                   Z-SUB     CLBLN         WrkCLBLN                                     CGL014
     C                   EVAL      WAmount = WrkCLBLN - WTranAmt                              CGL014
                                                                                              CGL014
      ** Error:  Available balance is not sufficient                                          CGL014
      ** to cover blocked amount                                                              CGL014
                                                                                              CGL014
     C                   IF        WAmount < BCOA                                             CGL014
     C                   EVAL      OKCTAM = 'N'                                               CGL014
     C                   ADD       1             Idx                                          CGL014
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CGL014
     C                   EVAL      MsgIdXAr(Idx) = 'FTA0140'                                  CGL014
     C                   ELSE                                                                 CGL014
                                                                                              CGL014
      ** Warning:  Balance is greater than blocked amount but less                            CGL014
      ** than minimum balance; minimum balance will be exceeded                               CGL014
                                                                                              CGL014
     C                   IF        WAmount < MINB                                             CGL014
     C                   EVAL      OKCTAM = 'W'                                               CGL014
     C                   ADD       1             WIx                                          CGL014
     C                   EVAL      WFldNmXAr(WIx) = DDSName                                   CGL014
     C                   EVAL      WMsgIdXAr(WIx) = 'FTA0141'                                 CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************
      *                                                               *
      *  SRAlgn   : To call ZALIGN                                    *
      *                                                               *
      *  CALLED BY: ValidateO, ValidateI                              *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRalgn        BEGSR
      *
      ** Format amount field and ZADIG
      *
     C                   MOVE (P)  WAmt          ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkCtam = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'PCCtAmt'
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0284'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************                     BUG14947
      /EJECT                                                                                BUG14947
      *****************************************************************                     BUG14947
      *                                                               *                     BUG14947
      *  SRALGN2  : To call ZALIGN                                    *                     BUG14947
      *                                                               *                     BUG14947
      *  CALLED BY: ValidateO                                         *                     BUG14947
      *                                                               *                     BUG14947
      *  CALLS    :        -                                          *                     BUG14947
      *                                                               *                     BUG14947
      *****************************************************************                     BUG14947
      *                                                                                     BUG14947
     C     SRALGN2       BEGSR                                                              BUG14947
      *                                                                                     BUG14947
      ** Format amount field and ZADIG                                                      BUG14947
      *                                                                                     BUG14947
     C                   MOVE (P)  WAmt          ZFIELD                                     BUG14947
     C                   EVAL      ZADIG = 15 - A6NBDP                                      BUG14947
      *                                                                                     BUG14947
     C                   CALLB     'ZALIGN'                                                 BUG14947
     C                   PARM      'Y'           ZALIGNOK                                   BUG14947
     C                   PARM                    ZFIELD                                     BUG14947
     C                   PARM      A6NBDP        ZADEC                                      BUG14947
     C                   PARM                    ZADIG                                      BUG14947
      *                                                                                     BUG14947
     C                   IF        ZALIGNOK = 'N'                                           BUG14947
     C                   IF        OKPAMT = 'Y'                                             BUG14947
     C                   EVAL      OKPAMT = 'N'                                             BUG14947
     C                   EVAL      IDX = IDX + 1                                            BUG14947
     C                   EVAL      FLDNAMXAR(IDX) = 'PPAYAMT'                               BUG14947
     C                   EVAL      MSGIDXAR(IDX) = 'RFV0154'                                BUG14947
     C                   EVAL      RETCODEIN = 'ERROR'                                      BUG14947
     C                   ENDIF                                                              BUG14947
     C                   ENDIF                                                              BUG14947
      *                                                                                     BUG14947
     C                   ENDSR                                                              BUG14947
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
     C                   IF        RetCodeIn <> *Blanks
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 5
     C                   EVAL      DBMod = 'FTVEXRT02'
     C                   EVAL      DBProc = 'Default'
     C**********         EXSR      *PSSR                                                  MD030708A
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRAccount - Get Account details                              *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     SRAccount     BEGSR                                                                CGL014
                                                                                              CGL014
     C                   EVAL      PAcct = *BLANKS                                            CGL014
                                                                                              CGL014
     C                   SELECT                                                               CGL014
     C                   WHEN      HPSINST <> *BLANKS  AND  OKSINST <> 'N'                    CGL014
     C                   EVAL      PAcct = HPSINST                                            CGL014
                                                                                              CGL014
     C                   WHEN      HPSNDCOR <> *BLANKS  AND  OKSNDCR <> 'N'                   CGL014
     C                   EVAL      PAcct = HPSNDCOR                                           CGL014
                                                                                              CGL014
     C                   WHEN      HPRCVCOR <> *BLANKS  AND  OKRCVCR <> 'N'                   CGL014
     C                   EVAL      PAcct = HPRCVCOR                                           CGL014
     C                   ENDSL                                                                CGL014
                                                                                              CGL014
      ** Get Account details                                                                  CGL014
                                                                                              CGL014
     C                   IF        PAcct <> *BLANKS                                           CGL014
     C                   CALLB     'AOACCTV1'                                                 CGL014
     C                   PARM      *BLANKS       PRetCode                                     CGL014
     C                   PARM      *BLANKS       PType                                        CGL014
     C                   PARM                    PAcct                                        CGL014
     C     ACCNT         PARM      ACCNT         DSSDY                                        CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
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
     C                   EVAL      Dbase  = 1
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRetCode                                     CGL014
     C                   PARM      '*VERIFY'     POption                                      CGL014
     C                   PARM      'CGL014'      PSard                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRetCode <> *BLANKS  AND                                   CGL014
     C                             PRetCode <> '*NRF   '                                      CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 2                                                 CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRetCode = *BLANKS                                         CGL014
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
     C                   EVAL      DBase = 5
     C                   EVAL      DBMod = 'FTVTFCY01'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
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
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
