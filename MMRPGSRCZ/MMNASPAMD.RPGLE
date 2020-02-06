     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NA's Purchased Amend Checking     ')          *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMNASPAMD - Negotiable Assets Purchased Amend Checking       *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended deal against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CAP086             Date 08Jun05               *
      *                 211926             Date 09Dec02               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 03Jul03               *
      *                 222727             Date 05Nov03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  211926 - When checking whether the Funding Spread/Rate was   *
      *           changed on Amend, convert fields DDFSRP and @DDFSRP *
      *           to numeric first before comparing them.             *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API wrapper project                                 *
      *         - Use ZCMPAMTS to compare DDFSRP, DDINTR & DDAMNP.    *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CDE002 - Revenue Analysis                                    *
      *  CAP004 - API's Phase 3.                                      *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMMCDAFLL  IF   E             DISK    INFSR(*PSSR)
 
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMLVDMP0)
 
 
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
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array to contain input rate                                                          211926
     D AlpRate         S              1    DIM(12)                                            211926
      ** Array to integer part of rate                                                        211926
     D IntRate         S              1    DIM(4)                                             211926
      ** Array to decimal part of rate                                                        211926
     D DecRate         S              1    DIM(7)                                             211926
                                                                                              211926
      * New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(MMNASPPD)
 
      * (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(MMNASPPD)
     D                                     PREFIX(@)
 
      * (Current) Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(MMDENBPP)
 
 
     D RUNDAT          DS
     D  @MBIN                 13     13
      *
     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
      *
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDE002
      ** External DS for SAR details                                            CDE002
                                                                                CDE002
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for AlpRate                                                                    211926
     D @AR             S              2  0                                                    211926
      ** Index for IntRate                                                                    211926
     D @IR             S              1  0                                                    211926
      ** Index for DecRate                                                                    211926
     D @DR             S              1  0                                                    211926
                                                                                              211926
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDMtypOK                      1A
     D  DDStypOK                      1A
     D  DDFedFOK                      1A
     D  DDDlDtOK                      1A
     D  DDBrCAOK                      1A
     D  DDBkCdOK                      1A
     D  DDBrkgOK                      1A
     D  DDIsurOK                      1A
     D  DDCsnmOK                      1A
     D  DDVDatOK                      1A
     D  DDMDatOK                      1A
     D  DDAcSqOK                      1A
     D  DDCcyOK                       1A
     D  DDFvalOK                      1A
     D  DDAmnpOK                      1A
     D  DDBokCOK                      1A
     D  DDLnkNOK                      1A
     D  DDBdidOK                      1A
     D  DDINTROK                      1A
     D  DDICMtOK                      1A
     D  DDIPFqOK                      1A
     D  DDNDatOK                      1A
     D  DDSlidOK                      1A
     D  DDDCRTOK                      1A
     D  DDIPDMOK                      1A
     D  DDmttiOK                      1A
     D  DDBRatOK                      1A
     D  DDCDRfOK                      1A
     D  DDRDFCOK                      1A
     D  DDPcliOK                      1A
     D  DDPSzeOK                      1A
     D  DDOrBrOK                      1A
     D  DDPrfCOK                      1A
     D  DDFsrpOK                      1A
     D  DDFprcOK                      1A
     D  DDOylcOK                      1A                                                      CAS005
     D  DDLQPROK                      1A                                                      CAS005
     D  DDLQPSOK                      1A                                                      CAS005
     D  DDClasOK                      1A                                                      CDL038
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
 
 
      ** Deal Transaction Date in Midas Dayno. format
     D TransDate       S              5P 0
 
      ** Start/Last Interest Date in Midas Dayno. format
     D LstIntDate      S              5P 0
 
      ** Interest Accrual Date in Midas Dayno. format
     D IntAccDate      S              5P 0
 
      ** New Next Interest Date in Midas Dayno. format
     D NewNxInDte      S              5P 0
 
 
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
 
      **  Convert the dates on the current live deal
      **  from YYYYMMDD format to Midas day number format
     C                   EXSR      ConvDates
 
      **  Compare fields with amended values.
     C                   EXSR      CompFlds
 
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
 
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      *  If any errors were found and reset of fields in error required,
      *  do this
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      ResetFlds
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CompFlds  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *                                                               *
      *****************************************************************
 
     C     CompFlds      BEGSR
      *
      *-----------------------------------------*
      * Deal Type                               *
      *-----------------------------------------*
      *
      ** This field is NOT AMENDABLE.
      *
     C     DDMTYP        IFNE      @DDMTYP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0398'
     C                   EVAL      DDMTYPok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Deal SubType                            *
      *-----------------------------------------*
      *
      ** This field is amendable only if so defined on MMCDAFPP.
      ** and if CDL039 is ON                                                                  CDL039
      *
     C     DDSTYP        IFNE      @DDSTYP
     C     HHDLSA        ANDEQ     'N'
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0400'
     C                   EVAL      DDSTYPok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Federal Funds Indicator                 *
      *-----------------------------------------*
      *
      ** This field is NOT AMENDABLE.
      *
     C     DDFEDF        IFNE      @DDFEDF
     C     HLDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0396'
     C                   EVAL      DDFEDFok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Deal Date                               *
      *-----------------------------------------*
      *
      ** This field may only be amended if deal NOT Authorised.
      *
     C     DDDLDT        IFNE      @DDDLDT
     C     HLDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0382'
     C                   EVAL      DDDLDTok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Branch Code                             *
      *-----------------------------------------*
      *
      ** Booking branch code validation only when MULTI-BRANCHING
      ** indicator is on.
      ** This field is not amendable for R and A status deals,
      ** and is only amendable for status C if this is indicated on
      ** MMCDAFLL.
      *
     C     @MBIN         IFNE      'Y'
     C     DDBRCA        ANDNE     @DDBRCA
      *
     C     HLDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0381'
     C                   EVAL      DDBRCAok        = 'N'
     C                   ELSE
     C     HHBRCA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0380'
     C                   EVAL      DDBRCAok        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *-----------------------------------------*
      * Broker Code                             *
      *-----------------------------------------*
      *
      **  This field is not amendable for R and A status deals,
      **  and is only amendable for status C if this is indicated on
      **  MMCDAFLL.
      *
     C     DDBKCD        IFNE      @DDBKCD
      *
     C     HLDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0391'
     C                   EVAL      DDBKCDok        = 'N'
     C                   ELSE
     C     HHBKRA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0390'
     C                   EVAL      DDBKCDok        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *-----------------------------------------*
      * Brokerage                               *
      *-----------------------------------------*
      *
      **  This field is not amendable for R and A status deals,
      **  and is only amendable for status C if this is indicated on
      **  MMCDAFLL.
      *
     C     DDBRKG        IFNE      @DDBRKG
      *
     C     HLDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0395'
     C                   EVAL      DDBRKGok        = 'N'
     C                   ELSE
     C     HHBKGA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0394'
     C                   EVAL      DDBRKGok        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *-----------------------------------------*
      * Issued by Customer                      *
      *-----------------------------------------*
      *
      **  This field is not amendable for R and A status deals,
      **  and is only amendable for status C if this is indicated on
      **  MMCDAFLL.
      *
     C     DDISUR        IFNE      @DDISUR
     C     DDISUR        ANDNE     *BLANKS
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISUR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0497'
     C                   EVAL      DDISURok        = 'N'
     C                   ENDIF
      *
      *----------------------------------*
      * Validate Bought From Customer    *
      *----------------------------------*
      *
     C     DDCSNM        IFNE      @DDCSNM
      *
     C     HLDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0385'
     C                   EVAL      DDCSNMok        = 'N'
     C                   ELSE
     C     HHBKGA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSNM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0384'
     C                   EVAL      DDCSNMok        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *-----------------------------------------*
      * Value Date                              *
      *-----------------------------------------*
      *
      ** This field is NOT AMENDABLE.
      *
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0386'
     C                   EVAL      DDVDATok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Maturity Date                           *
      *-----------------------------------------*
      *
      **  The maturity date may NOT  be changed
      *
     C     DDMDAT        IFNE      @DDMDAT
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0388'
     C                   EVAL      DDMDATok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Account Sequence Number                 *
      *-----------------------------------------*
      *
      ** This field may only be amended if deal NOT Authorised.
      *
     C     DDACSQ        IFNE      @DDACSQ
     C     HLDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACSQ'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0490'
     C                   EVAL      DDACSQok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Currency                                *
      *-----------------------------------------*
      *
      ** This field is NOT AMENDABLE.
      *
     C     DDCCY         IFNE      @DDCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0370'
     C                   EVAL      DDCCYok        = 'N'
     C                   ENDIF
      *
      *------------*
      * Face Value *
      *------------*
      *
      ** This field is NOT AMENDABLE.
     C     DDFVAL        IFNE      @DDFVAL
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFVAL'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0372'
     C                   EVAL      DDFVALok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Purchase Price                          *
      *-----------------------------------------*
      ** This field is NOT AMENDABLE.
      *
     C*****DDAMNP********IFNE      @DDAMNP                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDAMNP        ZCMPAMT1         25            CAP084
     C                   PARM      @DDAMNP       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0494'
     C                   EVAL      DDAMNPok        = 'N'
     C                   ENDIF
     C*                                                                         CAP004
     C*-----------------------------------------*                               CAP004
     C* Book Code                               *                               CAP004
     C*-----------------------------------------*                               CAP004
     C** This field may only be amended if deal NOT Authorised.                 CAP004
     C*                                                                         CAP004
     C     DDBOKC        IFNE      @DDBOKC                                      CAP004
     C     HLDSTS        ANDNE     'C'                                          CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'                   CAP004
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2570'                  CAP004
     C                   EVAL      ddBOKCok        = 'N'                        CAP004
     C                   ENDIF                                                  CAP004
      *
      *-------------------------------*
      * Validate Interest Rate/Spread *
      *-------------------------------*
      ** This field is NOT AMENDABLE.
      *
     C*****DDINTR********IFNE      @DDINTR                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDINTR        ZCMPAMT1         25            CAP084
     C                   PARM      @DDINTR       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINTR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0499'
     C                   EVAL      DDINTRok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Interest Calculation Method             *
      *-----------------------------------------*
      *
      **  The calculation method is not amendable.
      *
     C     DDICMT        IFNE      @DDICMT
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDICMT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0485'
     C                   EVAL      DDICMTok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Interest Payment Frequency              *
      *-----------------------------------------*
      **  The payment frequency is not amendable.
      *
     C     DDIPFQ        IFNE      @DDIPFQ
     C     HHINTA        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0483'
     C                   EVAL      DDIPFQok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Next Interest Date                      *
      *-----------------------------------------*
      *
      **  The next interest date may only be amended if the deal status is
      **  authorised or requiring re-authorisation, and the run date is
      **  after the deal input date.
      *
     C     DDNDAT        IFNE      @DDNDAT
      *
     C     HLDSTS        IFEQ      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0481'
     C                   EVAL      DDNDAtok        = 'N'
     C                   ENDIF
      *
     C     HLDSTS        IFEQ      'A'
     C     BJRDNB        ANDLE     TransDate
     C     HLDSTS        OREQ      'R'
     C     BJRDNB        ANDLE     HLDVSD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0481'
     C                   EVAL      DDNDATok        = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If the date was not invalidly amended, carry out further
      **  validation.  (Only if the date was not blank.)
     C     NewNxInDte    IFNE      *ZEROS
      *
      **  The next interest date must be after
      **  the last interest date and the interest accrual control date.
      *
     C     NewNxInDte    IFLE      LstIntDate
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0442'
     C                   EVAL      DDNDATok        = 'N'
     C                   END
      *
     C     NewNxInDte    IFLE      IntAccDate
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0443'
     C                   EVAL      DDNDATok        = 'N'
     C                   END
      *
     C                   ENDIF
      *
      *-----------------------------------------*
      * Start/Last Interest Date                *
      *-----------------------------------------*
      **  The Start/Last Interest Date is not amendable.
      *
     C     DDSLID        IFNE      @DDSLID
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSLID'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0498'
     C                   EVAL      DDSLIDok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Yield Discount Rate                     *
      *-----------------------------------------*
      **  The Yield Discount Rate is not amendable.
      *
     C     DDDCRT        IFNE      @DDDCRT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDCRT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0495'
     C                   EVAL      DDDCRTok        = 'N'
     C                   ENDIF
 
      *-----------------------------------------*
      * Interest Frequency day in Month         *
      *-----------------------------------------*
      *
      **  This field is only amendable if the deal is
      **  complete, and the field is designated as amendable on the
      **  file MMCDAFLL.
      *
     C     HLDSTS        IFNE      'C'
     C     DDIPDM        ANDNE     @DDIPDM
     C     HHINTA        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPDM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0487'
     C                   EVAL      DDIPDMok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Total Interest Amount                   *
      *-----------------------------------------*
      *
      ** This field is NOT AMENDABLE.
      *
     C     DDMTTI        IFNE      @DDMTTI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTTI'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0492'
     C                   EVAL      DDMTTIok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Base Currency Rate                      *
      *-----------------------------------------*
      ** This field is NOT AMENDABLE.
      *
     C     DDBRAT        IFNE      @DDBRAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0392'
     C                   EVAL      DDBRATok        = 'N'
     C                   ENDIF
      *
      *-----------------------------------------*
      * Round Down Interest Indicator           *
      *-----------------------------------------*
      *
      ** This field is NOT AMENDABLE.
      *
     C     DDRDFC        IFNE      @DDRDFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRDFC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0609'
     C                   EVAL      DDRDFCok        = 'N'
     C                   ENDIF
      *
      *----------------------------------------*
      * Parcel Flag                            *
      *----------------------------------------*
      ** This field is NOT AMENDABLE.
      *
     C     DDPCLI        IFNE      @DDPCLI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPCLI'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2001'
     C                   EVAL      DDPCLIok        = 'N'
     C                   ENDIF
 
      *----------------------------------------*
      * Parcel Size                            *
      *----------------------------------------*
      ** This field is NOT AMENDABLE.
      *
      ** Use the %TRIM built-in function to remove any leading or trailing
      ** spaces
     C     DDPSZE        IFEQ      '    0'
     C     DDPSZE        OREQ      '0    '
     C                   MOVE      *BLANKS       DDPSZE
     C                   ENDIF
     C                   IF        %trim(DDPSZE) <> %trim(@DDPSZE)
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSZE'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2001'
     C                   EVAL      DDPSZEok        = 'N'
     C                   ENDIF
 
      *-----------------------------------------*
      * Profit Centre                           *
      *-----------------------------------------*
      *
      ** Only validate this field if Profit Centre ICD flag on.
      *
     C     BKPRCU        IFEQ      'Y'
      *
      ** This field is not amendable unless 'Profit Centre Amendable'
      ** ICD flag is on.
      *
     C     DDPRFC        IFNE      @DDPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      DDPRFCok        = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      *-----------------------------------------*
      * Funding Spread/Rate and Profit Centre   *
      *-----------------------------------------*
      *
      ** Only validate if Profit Centre Accounting is installed
      ** or Revenue Analysis is installed                                       CDE002
      *
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                          CDE002
      *
      ** These fields may only be amended if deal NOT Authorised.
      *
     C                   MOVE      DDFSRP        WRATE            12                          211926
     C                   EXSR      ConvRate                                                   211926
     C                   MOVE      CRATE         WFSRP1           11 7                        211926
     C                   MOVE      @DDFSRP       WRATE                                        211926
     C                   EXSR      ConvRate                                                   211926
     C                   MOVE      CRATE         WFSRP2           11 7                        211926
     C*****DDFSRP********IFNE      @DDFSRP                                      CAP084
     C*****HLDSTS********ANDNE     'C'                                          CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDFSRP        ZCMPAMT1         25            CAP084
     C                   PARM      @DDFSRP       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C     HLDSTS        ANDNE     'C'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSRP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0422'
     C                   EVAL      ddFSRPok        = 'N'
     C                   ENDIF
      *
     C     DDFPRC        IFNE      @DDFPRC
     C     HLDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFPRC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0424'
     C                   EVAL      ddFPRCok        = 'N'
     C                   ENDIF
      *
     C                   ENDIF
     C*-----------------------------------------*                                             CDL038
     C* Class                                   *                                             CDL038
     C*-----------------------------------------*                                             CDL038
     C** This field is amendable only if the deal is complete                                 CDL038
     C** and if CDL039 is ON                                                                  CDL039
     C*                                                                                       CDL038
     C     HLDSTS        IFNE      'C'                                                        CDL038
     C     DDCLAS        ANDNE     @DDCLAS                                                    CDL038
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                                 CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0258'                                CDL038
     C                   EVAL      ddCLASok        = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
      * Deal Type
     C     ddMTYPOK      IFEQ      'N'
     C                   MOVEL     @DDMTYP       DDMTYP
     C                   END
      *
      * Deal SubType
     C     ddSTYPOK      IFEQ      'N'
     C                   MOVEL     @DDSTYP       DDSTYP
     C                   END
      *
      * Federal Funds Indicator
     C     ddFEDFOK      IFEQ      'N'
     C                   MOVEL     @DDFEDF       DDFEDF
     C                   END
      * Deal Date
     C     ddDLDTOK      IFEQ      'N'
     C                   MOVEL     @DDDLDT       DDDLDT
     C                   END
      *
      * Branch Code
     C     ddBRCAOK      IFEQ      'N'
     C                   MOVEL     @DDBRCA       DDBRCA
     C                   END
      *
      * Broker Code
     C     ddBKCDOK      IFEQ      'N'
     C                   MOVEL     @DDBKCD       DDBKCD
     C                   END
      *
      * Brokerage
     C     ddBRKGOK      IFEQ      'N'
     C                   MOVEL     @DDBRKG       DDBRKG
     C                   END
      *
      * NAB ISSUER
     C     ddISUROK      IFEQ      'N'
     C                   MOVEL     @DDISUR       DDISUR
     C                   END
      *
      * BOUGHT FROM CUSTOMER
     C     ddCSNMOK      IFEQ      'N'
     C                   MOVEL     @DDCSNM       DDCSNM
     C                   END
      *
      * Value Date
     C     ddVDATOK      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
      *
      * Maturity Date
     C     ddMDATOK      IFEQ      'N'
     C                   MOVEL     @DDMDAT       DDMDAT
     C                   END
 
      * Account Sequence Number
     C     ddACSQOK      IFEQ      'N'
     C                   MOVEL     @DDACSQ       DDACSQ
     C                   END
 
      * Currency
     C     ddCCYOK       IFEQ      'N'
     C                   MOVEL     @DDCCY        DDCCY
     C                   END
 
      * FACE VALUE
     C     ddFVALOK      IFEQ      'N'
     C                   MOVEL     @DDFVAL       DDFVAL
     C                   END
 
      * PURCHASE PRICE
     C     ddAMNPOK      IFEQ      'N'
     C                   MOVEL     @DDAMNP       DDAMNP
     C                   END
      *                                                                         CAP004
      * Book code                                                               CAP004
     C     ddBOKCOK      IFEQ      'N'                                          CAP004
     C                   MOVEL     @DDBOKC       DDBOKC                         CAP004
     C                   END                                                    CAP004
 
      * INTEREST RATE
     C     ddINTROK      IFEQ      'N'
     C                   MOVEL     @DDINTR       DDINTR
     C                   END
 
      * Interest Calculation Method
     C     ddICMTOK      IFEQ      'N'
     C                   MOVEL     @DDICMT       DDICMT
     C                   END
 
      * Interest Payment Frequency
     C     ddIPFQOK      IFEQ      'N'
     C                   MOVEL     @DDIPFQ       DDIPFQ
     C                   END
 
      * Next Interest Date
     C     ddNDATOK      IFEQ      'N'
     C                   MOVEL     @DDNDAT       DDNDAT
     C                   END
 
      * START/LAST Interest Date
     C     ddSLIDOK      IFEQ      'N'
     C                   MOVEL     @DDSLID       DDSLID
     C                   END
 
      * DISCOUNT RATE
     C     ddDCRTOK      IFEQ      'N'
     C                   MOVEL     @DDDCRT       DDDCRT
     C                   END
 
      * Interest Frequency day in Month
     C     ddIPDMOK      IFEQ      'N'
     C                   MOVEL     @DDIPDM       DDIPDM
     C                   END
 
      * Total Interest Amount
     C     ddMTTIOK      IFEQ      'N'
     C                   MOVEL     @DDMTTI       DDMTTI
     C                   END
 
      * BASE CURRENCY RATE
     C     ddBRATOK      IFEQ      'N'
     C                   MOVEL     @DDBRAT       DDBRAT
     C                   END
 
      * Round Down Interest Indicator
     C     ddRDFCOK      IFEQ      'N'
     C                   MOVEL     @DDRDFC       DDRDFC
     C                   END
 
      * PARCEL FLAG
     C     ddPCLIOK      IFEQ      'N'
     C                   MOVEL     @DDPCLI       DDPCLI
     C                   END
 
      * PARCEL SIZE
     C     ddPSZEOK      IFEQ      'N'
     C                   MOVEL     @DDPSZE       DDPSZE
     C                   END
 
      * PROFIT CENTRE
     C     ddPRFCOK      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
 
      * Funding Spread/Rate
     C     ddFSRPOK      IFEQ      'N'
     C                   MOVEL     @DDFSRP       DDFSRP
     C                   END
 
      * Funding Profit Centre
     C     ddFPRCOK      IFEQ      'N'
     C                   MOVEL     @DDFPRC       DDFPRC
     C                   END
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C     ddCLASOK      IFEQ      'N'                                                        CDL038
     C                   MOVEL     @DDCLAS       DDCLAS                                       CDL038
     C                   END                                                                  CDL038
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * CONVDATES  - Convert date fields from MMDENBPP from DDMMYYYY  *
      *              to Midas Dayno (5,0) format for comparison       *
      *****************************************************************
     C     CONVDATES     BEGSR
      *
      ***********************************************
      **  Format the transaction date               *
      ***********************************************
      *
     C                   Z-ADD     HLDTYY        @@YY
     C                   Z-ADD     HLDTMM        @@MM
     C                   Z-ADD     HLDTDD        @@DD
      *
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        TransDate
     C                   END
      *
      ***********************************************
      **  Format the Start/Last Interest date.      *
      ***********************************************
      *
     C                   Z-ADD     HLLIYY        @@YY
     C                   Z-ADD     HLLIMM        @@MM
     C                   Z-ADD     HLLIDD        @@DD
      *
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             LstIntDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        LstIntDate
     C                   END
      *
      ***********************************************
      **  Format the Interest Accrual Control date. *
      ***********************************************
      *
     C                   Z-ADD     HLIAYY        @@YY
     C                   Z-ADD     HLIAMM        @@MM
     C                   Z-ADD     HLIADD        @@DD
      *
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             IntAccDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
     C                   MOVE      ZZMDNO        IntAccDate
     C                   END
      *
      ***********************************************
      *  Format the New Next Interest Payment date  *
      ***********************************************
      *
     C     DDNDAT        IFEQ      *BLANK
     C                   Z-ADD     0             NewNxInDte
     C                   ELSE
     C                   CALLB     'ZAVDATE'
     C                   PARM                    RetCodeOut
     C                   PARM                    DDNDAT
     C                   PARM                    BJDfin
     C                   PARM                    NewNxInDte
     C                   END
      *
     C                   ENDSR
 
      /EJECT                                                                                  211926
      *****************************************************************                       211926
      * ConvRate - Convert rate fields from characters to numeric     *                       211926
      *            first before comparing them.                       *                       211926
      *****************************************************************                       211926
     C     ConvRate      BEGSR                                                                211926
      *                                                                                       211926
      ** Initialise fields first                                                              211926
      *                                                                                       211926
     C                   MOVEA     *BLANKS       AlpRate                                      211926
     C                   MOVEA     *ZEROS        IntRate                                      211926
     C                   MOVEA     *ZEROS        DecRate                                      211926
     C                   Z-ADD     0             @AR                                          211926
     C                   Z-ADD     0             @IR                                          211926
     C                   Z-ADD     0             @DR                                          211926
     C                   Z-ADD     0             CRATE            11 7                        211926
     C                   Z-ADD     0             DEC               2 0                        211926
     C                   Z-ADD     0             NINT              4 0                        211926
     C                   Z-ADD     0             NDEC              7 0                        211926
     C                   MOVE      *BLANKS       CINT              4                          211926
     C                   MOVE      *BLANKS       CDEC              7                          211926
     C                   MOVE      'N'           NegRate           1                          211926
     C                   MOVE      '0'           *IN99                                        211926
     C                   MOVE      '0'           *IN98                                        211926
      *                                                                                       211926
      ** Move input to array.                                                                 211926
      ** Check for negative sign and decimal point.                                           211926
      *                                                                                       211926
     C                   MOVEA     WRATE         AlpRate                                      211926
     C                   Z-ADD     1             X                 2 0                        211926
     C     '-'           LOOKUP    AlpRate(X)                             99                  211926
     C     *IN99         IFEQ      '1'                                                        211926
     C                   MOVE      'Y'           NegRate                                      211926
     C                   ELSE                                                                 211926
     C                   Z-ADD     0             X                                            211926
     C                   ENDIF                                                                211926
     C                   Z-ADD     1             Y                 2 0                        211926
     C     '.'           LOOKUP    AlpRate(Y)                             98                  211926
     C     *IN98         IFEQ      '1'                                                        211926
     C     Y             SUB       1             @AR                                          211926
     C     Y             ADD       1             DEC                                          211926
     C                   ELSE                                                                 211926
     C                   Z-ADD     12            @AR                                          211926
     C                   Z-ADD     13            DEC                                          211926
     C                   ENDIF                                                                211926
      *                                                                                       211926
      ** Move integers to IntRate and Decimals to DecRate                                     211926
      *                                                                                       211926
     C                   Z-ADD     4             @IR                                          211926
     C     @AR           DOWGT     X                                                          211926
     C     @IR           ANDNE     0                                                          211926
     C     AlpRate(@AR)  IFNE      *BLANK                                                     211926
     C                   MOVE      AlpRate(@AR)  IntRate(@IR)                                 211926
     C                   SUB       1             @IR                                          211926
     C                   ENDIF                                                                211926
     C                   SUB       1             @AR                                          211926
     C                   ENDDO                                                                211926
     C                   Z-ADD     1             @DR                                          211926
     C     DEC           DOWLT     13                                                         211926
     C     @DR           ANDLE     7                                                          211926
     C     AlpRate(DEC)  IFNE      *BLANK                                                     211926
     C                   MOVE      AlpRate(DEC)  DecRate(@DR)                                 211926
     C                   ADD       1             @DR                                          211926
     C                   ENDIF                                                                211926
     C                   ADD       1             DEC                                          211926
     C                   ENDDO                                                                211926
      *                                                                                       211926
      ** Move IntRate and DecRate to output variable CRATE.                                   211926
      *                                                                                       211926
     C                   MOVEA     IntRate(1)    CINT                                         211926
     C                   MOVEA     DecRate(1)    CDEC                                         211926
     C                   MOVE      CINT          NINT                                         211926
     C                   MOVE      CDEC          NDEC                                         211926
     C     NDEC          DIV       10000000      CRATE                                        211926
     C                   ADD       NINT          CRATE                                        211926
     C     NegRate       IFEQ      'Y'                                                        211926
     C                   Z-SUB     CRATE         CRATE                                        211926
     C                   ENDIF                                                                211926
     C                   MOVE      *BLANKS       WRATE                                        211926
      *                                                                                       211926
     C                   ENDSR                                                                211926
      *****************************************************************                       211926
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * INPUTS...
      * Return Code
     C                   PARM                    RetCodeIn
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      * Current Deal in Screen Format
     C                   PARM                    DealScnFmt
      * Current Deal in file format
     C                   PARM                    DealFilFmt
      * OUTPUTS...
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'MMNASPAMD'   DBPGM
      *
      ** Key List for Deal Amendments file
     C     @DEAMK        KLIST
     C                   KFLD                    @DEAMN            6 0
     C                   KFLD                    @VDYY             4 0
     C                   KFLD                    @VDMM             2 0
     C                   KFLD                    @VDDD             2 0
     C                   KFLD                    @DEAMS            3 0
 
     C     *LIKE         DEFINE    HLDDND        ZZMDNO
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      **
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger details via access program
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS MIDAS MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '902'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      **  Read the first and only record on MMCDAFLL.
     C     1             CHAIN     MMCDAFLL                           60
      *
      **  If no valid record found then it is a data base error.
     C     *IN60         IFEQ      '1'
     C     HHDLTF        OREQ      '*'
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'MMCDAFLL'    DBFILE
     C                   MOVE      '903'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if CDE002 is switched on          CDE002
      *                                                                         CDE002
     C                   CallB     'AOSARDR0'                                   CDE002
     C                   Parm      *Blanks       PRTCD             7            CDE002
     C                   Parm      '*VERIFY'     POPTN             7            CDE002
     C                   Parm      'CDE002'      PSARD             6            CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
     C                   Move      'N'           CDE002            1            CDE002
     C                   If        PRTCD = *Blanks                              CDE002
     C                   Eval      CDE002 = 'Y'                                 CDE002
     C                   Endif                                                  CDE002
                                                                                CDE002
      *                                                                                       CDL039
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF CDL039 IS INSTALLED                          CDL039
      *                                                                                       CDL039
     C                   CALL      'AOSARDR0'                                                 CDL039
     C                   PARM      *BLANKS       @RTCD                                        CDL039
     C                   PARM      '*VERIFY'     @OPTN                                        CDL039
     C                   PARM      'CDL039'      @SARD             6                          CDL039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL039
      *                                                                                       CDL039
     C     @RTCD         IFEQ      *BLANK                                                     CDL039
     C                   MOVEL     'Y'           CDL039            1                          CDL039
     C                   ELSE                                                                 CDL039
     C                   MOVEL     'N'           CDL039                                       CDL039
     C                   END                                                                  CDL039
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
