     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal amend checking')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Foriegn Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLAMD - FX Deal Amend Checking                           *
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
      *  Last Amend No. MD056102           Date 30Jun20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD047971           Date 17Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 BUG620             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 17Jul03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196952             Date 06May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 178695             Date 28Jun00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 CAP002  *CREATE    Date 22Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056102 - Split value date error during amend               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047971 - Do not allow amendment to settlement account if   *
      *             that side is already netted.                      *
      *  CDL099 - Split Value Date                                    *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG620 - Use ZCMPAMTS to compare Brokerage                   *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Use ZCMPAMTS to compare Nominal                     *
      *  196952 - Ensure Rate has 5 digits before decimal separator   *
      *           and 8 digits after. Use DDRAT1 instead of DDRATE.   *
      *           Recompiled due to changes in FXFXDLPD.              *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  178695 - Protect Amend of Portfolio Reference                *
      *  CDL008 - Continuous Linked Settlement (Recompile)            *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *           Recompiled due to changes in FXDEALPP               *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP004 - API's Phase 3.                                      *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFXCDAFLL  IF   E             DISK    INFSR(*PSSR)

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

      * New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(FXFXDLPD)

      * (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(FXFXDLPD)
     D                                     PREFIX(@)

      * (Current) Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(FXDEALPP)

     D RUNDAT          DS
     D  @MBIN                 13     13

     D                 DS
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
      **

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL039
      ** EXTERNAL DS FOR SAR DETAILS                                                          CDL039
                                                                                              CDL039
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D NwExtDlScnFmt E DS                  EXTNAME(FXDLEXPD)                                  CDL099
      ** New Extra Deal in Screen Format                                                      CDL099
                                                                                              CDL099
     D CrExtDlScnFmt E DS                  EXTNAME(FXDLEXPD)                                  CDL099
     D                                     PREFIX(@)                                          CDL099
      ** Current Extra Deal in Screen Format                                                  CDL099
                                                                                              CDL099
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDDltpOK                      1A
     D  DDDlstOK                      1A
     D  DDFedfOK                      1A
     D  DDDldtOK                      1A
     D  DDBrsnOK                      1A
     D  DDBrkrOK                      1A
     D  DDBkrgOK                      1A
     D  DDSdnoOK                      1A
     D  DDCustOK                      1A
     D  DDVdatOK                      1A
     D  DDOdatOK                      1A
     D  DDBokcOK                      1A
     D  DDLnknOK                      1A
     D  DDPtfrOK                      1A
     D  DDBccyOK                      1A
     D  DDBamtOK                      1A
     D  DDNbuyOK                      1A
     D  DDRateOK                      1A
     D  DDFpntOK                      1A
     D  DDSignOK                      1A
     D  DDMginOK                      1A
     D  DDMbsiOK                      1A
     D  DDSccyOK                      1A
     D  DDSamtOK                      1A
     D  DDPrfcOK                      1A
     D  DDNselOK                      1A
     D  DDBceOK                       1A
     D  DDOrbrOK                      1A
     D  DDDbsrOK                      1A
     D  DDBbfpOK                      1A
     D  DDBbfsOK                      1A
     D  DDSbfpOK                      1A
     D  DDSbfsOK                      1A
     D  DDMtchOK                      1A
     D  DDCLSSOK                      1A                                                      CDL038
     D  DDOylcOK                      1A                                                      CDL038
     D  DDTylcOK                      1A                                                      CDL038
     D  DDClasOK                      1A                                                      CDL038
     D  ddSDATOK                      1A                                                      CDL099

      ** Date out
     D DateOut         S              6P 0

      ** Deal Transaction Date in Midas Dayno. format
     D TransDate       S              5P 0

     D DDRONX          S             21A                                                    MD047971
     D DDPONX          S             21A                                                    MD047971
     D DDRonxOK        S              1A                                                    MD047971
     D DDPonxOK        S              1A                                                    MD047971
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Convert the dates on the current live deal
      **  from YYYYMMDD format to Midas day number format
      *
     C                   EXSR      CONVDATES
      *
      **  Compare fields with amended values.
      *
     C                   EXSR      COMPFLDS
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
     C*
     C*-----------------------------------------*
     C* Deal Type                               *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDDLTP        IFNE      @DDDLTP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLTP'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0398'
     C                   EVAL      ddDLTPok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal SubType                            *
     C*-----------------------------------------*
     C** This field is amendable only if so defined on FXCDAFPP.
     C** and if CDL039 is ON                                                                  CDL039
     C*
     C     FHDSTS        IFNE      'C'
     C     DDDLST        ANDNE     @DDDLST
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C     FHDSTS        OREQ      'C'
     C     DDDLST        ANDNE     @DDDLST
     C     FDDLSA        ANDEQ     'N'
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLST'
     C     FHDSTS        IFEQ      'C'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0400'
     C                   ELSE
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0401'
     C                   END
     C                   EVAL      ddDLSTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Federal Funds Indicator                 *
     C*-----------------------------------------*
     C** This field is not amendable.
     C*
     C     DDFEDF        IFNE      @DDFEDF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0122'
     C                   EVAL      ddFEDFok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Date                               *
     C*-----------------------------------------*
     C** This field may only be amended if deal NOT Authorised.
     C*
     C     DDDLDT        IFNE      @DDDLDT
     C     FHDSTS        ANDNE     'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0382'
     C                   EVAL      ddDLDTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Booking Branch Code                     *
     C*-----------------------------------------*
     C** Booking branch code validation only when MULTI-BRANCHING
     C** indicator is on.
     C** This field is not amendable for R and A status deals,
     C** and is only amendable for status C if this is indicated on
     C** FXCDAFLL.
     C*
     C     @MBIN         IFEQ      'Y'
     C     DDBRSN        ANDNE     @DDBRSN
     C*
     C     FHDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRSN'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0381'
     C                   EVAL      ddBRSNok        = 'N'
     C                   ELSE
     C     FDBRCA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRSN'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0380'
     C                   EVAL      ddBRSNok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Broker Code                             *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  FXCDAFLL.
     C*
     C     DDBRKR        IFNE      @DDBRKR
     C*
     C     FHDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKR'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0391'
     C                   EVAL      ddBRKRok        = 'N'
     C                   ELSE
     C     FDBKRA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKR'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0390'
     C                   EVAL      ddBRKRok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Brokerage                               *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  FXCDAFLL.
     C*
     C*****DDBKRG        IFNE      @DDBKRG                                                    BUG620
     C                   CALLB     'ZCMPAMTS'                                                 BUG620
     C                   PARM      DDBKRG        ZCMPAMT1         25                          BUG620
     C                   PARM      @DDBKRG       ZCMPAMT2         25                          BUG620
     C                   PARM      'N'           ZCMPAMTDif        1                          BUG620
                                                                                              BUG620
     C     ZCMPAMTDif    IFEQ      'Y'                                                        BUG620
     C*
     C     FHDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKRG'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0395'
     C                   EVAL      ddBKRGok        = 'N'
     C                   ELSE
     C     FDBKGA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKRG'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0394'
     C                   EVAL      ddBKRGok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Swap/Option Deal Number                 *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C     DDSDNO        IFNE      @DDSDNO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSDNO'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0402'
     C                   EVAL      ddSDNOok         = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Customer                                *
     C*-----------------------------------------*
     C**  This field is not amendable for R and A status deals,
     C**  and is only amendable for status C if this is indicated on
     C**  FXCDAFLL.
     C*
     C     DDCUST        IFNE      @DDCUST
     C*
     C     FHDSTS        IFNE      'C'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0385'
     C                   EVAL      ddCUSTok        = 'N'
     C                   ELSE
     C     FDCNMA        IFEQ      'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0384'
     C                   EVAL      ddCUSTok        = 'N'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Value Date                              *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0386'
     C                   EVAL      ddVDATok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Option To Date                          *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C     DDODAT        IFNE      @DDODAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDODAT'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0403'
     C                   EVAL      ddODATok        = 'N'
     C                   ENDIF
     C*                                                                         CAP004
     C*-----------------------------------------*                               CAP004
     C* Book Code                               *                               CAP004
     C*-----------------------------------------*                               CAP004
     C** This field may only be amended if deal NOT Authorised.                 CAP004
     C*                                                                         CAP004
     C     DDBOKC        IFNE      @DDBOKC                                      CAP004
     C     FHDSTS        ANDNE     'C'                                          CAP004
     C                   ADD       1             Idx                            CAP004
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'                   CAP004
     C                   EVAL      MsgIDArr(Idx)   = 'MMM2570'                  CAP004
     C                   EVAL      ddBOKCok        = 'N'                        CAP004
     C                   ENDIF                                                  CAP004
     C*
     C*-----------------------------------------*
     C* Portfolio Reference                     *
     C*-----------------------------------------*
     C** This field may not be amended if original entry date of deal
     C** is less than the run date
     C*
     C     BGPFMG        IFEQ      'Y'
     C     DDPTFR        ANDNE     @DDPTFR
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     DDPTFR        ANDNE     @DDPTFR                                      CPB001
      *
     C**** TransDate     IFLT      BJRDNB                                       178695
     C     FHDSTS        IFNE      'C'                                          178695
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx)   = 'PMM0005'
     C                   EVAL      ddPTFRok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Buy currency                            *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C     DDBCCY        IFNE      @DDBCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBCCY'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0370'
     C                   EVAL      ddBCCYok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Buy amount                              *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C*****DDBAMT        IFNE      @DDBAMT                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDBAMT        ZCMPAMT1         25            CAP084
     C                   PARM      @DDBAMT       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0372'
     C                   EVAL      ddBAMTok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Exchange Rate                           *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C*****DDRATE        IFNE      @DDRATE                                                    196952
     C*****DDRAT1        IFNE      @DDRAT1                                      196952 CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDRAT1        ZCMPAMT1         25            CAP084
     C                   PARM      @DDRAT1       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C**********         EVAL      FldNameArr(Idx) = 'DDRATE'                                 196952
     C                   EVAL      FldNameArr(Idx) = 'DDRAT1'                                 196952
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0374'
     C                   EVAL      ddRATEok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Forward Points                          *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C*****DDFPNT        IFNE      @DDFPNT                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDFPNT        ZCMPAMT1         25            CAP084
     C                   PARM      @DDFPNT       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFPNT'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0388'
     C                   EVAL      ddFPNTok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Forward Points sign                     *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C     DDSIGN        IFNE      @DDSIGN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSIGN'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0389'
     C                   EVAL      ddSIGNok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Margin Points                           *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C*****DDMGIN        IFNE      @DDMGIN                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDMGIN        ZCMPAMT1         25            CAP084
     C                   PARM      @DDMGIN       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMGIN'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM1046'
     C                   EVAL      ddMGINok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Margin Points Buy/sell Indicator        *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C     DDMBSI        IFNE      @DDMBSI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMBSI'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM1049'
     C                   EVAL      ddMBSIok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Sell currency                           *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C     DDSCCY        IFNE      @DDSCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSCCY'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0371'
     C                   EVAL      ddSCCYok        = 'N'
     C                   END
     C*
     C*-----------------------------------------*
     C* Sell amount                             *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C*****DDSAMT        IFNE      @DDSAMT                                      CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDSAMT        ZCMPAMT1         25            CAP084
     C                   PARM      @DDSAMT       ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0378'
     C                   EVAL      ddSAMTok        = 'N'
     C                   END
      *                                                                                       CDL099
      ** Split Value Date                                                                     CDL099
     C     CDL099        IFEQ      'Y'                                                        CDL099
     C*****DDSDAT        IFNE      @DDSDAT                                           CDL099 MD056102
     C     DDVDAT        IFNE      @DDSDAT                                                  MD056102
     C                   ADD       1             Idx                                          CDL099
     C                   EVAL      FldNameArr(Idx) = 'DDSDAT'                                 CDL099
     C                   EVAL      MsgIDArr(Idx)   = 'FXM7005'                                CDL099
     C                   EVAL      ddSDATok        = 'N'                                      CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C*
     C*-----------------------------------------*
     C* Profit Centre                           *
     C*-----------------------------------------*
     C** Only validate this field if Profit Centre ICD flag on.
     C*
     C     BKPRCU        IFEQ      'Y'
     C*
     C** This field is not amendable unless 'Profit Centre Amendable'
     C** ICD flag is on.
     C*
     C     DDPRFC        IFNE      @DDPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      ddPRFCok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Base Currency Equivalent                *
     C*-----------------------------------------*
     C** This field can't be amended
     C*
     C*****DDBCE         IFNE      @DDBCE                                       CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      DDBCE         ZCMPAMT1         25            CAP084
     C                   PARM      @DDBCE        ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBCE '
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0392'
     C                   EVAL      ddBCEok         = 'N'
     C                   END
     C*                                                                                       CDL038
     C*-----------------------------------------*                                             CDL038
     C* Class                                   *                                             CDL038
     C*-----------------------------------------*                                             CDL038
     C** This field is amendable only if the deal is complete                                 CDL038
     C** and if CDL039 is ON                                                                  CDL039
     C*                                                                                       CDL038
     C     FHDSTS        IFNE      'C'                                                        CDL038
     C     DDCLAS        ANDNE     @DDCLAS                                                    CDL038
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                                 CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'FXM0512'                                CDL038
     C                   EVAL      ddCLASok        = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
      *                                                                                     MD047971
      *-----------------------------------------*                                           MD047971
      * Receipt settlement account              *                                           MD047971
      *-----------------------------------------*                                           MD047971
      ** This field is non-amendable when buy side of deal is netted                        MD047971
      ** already.                                                                           MD047971
      *                                                                                     MD047971
     C     FHNBRF        IFNE      ' '                                                      MD047971
     C     DDRONX        ANDNE     FHRONS                                                   MD047971
     C                   ADD       1             Idx                                        MD047971
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                               MD047971
     C                   EVAL      MsgIDArr(Idx)   = 'FXM7006'                              MD047971
     C                   EVAL      ddRonxok        = 'N'                                    MD047971
     C                   ENDIF                                                              MD047971
      *                                                                                     MD047971
      *-----------------------------------------*                                           MD047971
      * Payment settlement account              *                                           MD047971
      *-----------------------------------------*                                           MD047971
      ** This field is non-amendable when sell side of deal is netted                       MD047971
      ** already.                                                                           MD047971
      *                                                                                     MD047971
     C     FHNSRF        IFNE      ' '                                                      MD047971
     C     DDPONX        ANDNE     FHPONS                                                   MD047971
     C                   ADD       1             Idx                                        MD047971
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                               MD047971
     C                   EVAL      MsgIDArr(Idx)   = 'FXM7007'                              MD047971
     C                   EVAL      ddPonxok        = 'N'                                    MD047971
     C                   ENDIF                                                              MD047971
     C*
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
     C     ddDLTPOK      IFEQ      'N'
     C                   MOVEL     @DDDLTP       DDDLTP
     C                   END
     C*
     C* Deal SubType
     C     ddDLSTOK      IFEQ      'N'
     C                   MOVEL     @DDDLST       DDDLST
     C                   END
     C*
     C* Federal Funds Indicator
     C     ddFEDFOK      IFEQ      'N'
     C                   MOVEL     @DDFEDF       DDFEDF
     C                   END
     C*
     C* Deal Date
     C     ddDLDTOK      IFEQ      'N'
     C                   MOVEL     @DDDLDT       DDDLDT
     C                   END
     C*
     C* Booking Branch Code
     C     ddBRSNOK      IFEQ      'N'
     C                   MOVEL     @DDBRSN       DDBRSN
     C                   END
     C*
     C* Broker Code
     C     ddBRKROK      IFEQ      'N'
     C                   MOVEL     @DDBRKR       DDBRKR
     C                   END
     C*
     C* Brokerage
     C     ddBKRGOK      IFEQ      'N'
     C                   MOVEL     @DDBKRG       DDBKRG
     C                   END
     C*
     C* Swap/Option Deal Number
     C     ddSDNOOK      IFEQ      'N'
     C                   MOVEL     @DDSDNO       DDSDNO
     C                   END
     C*
     C* Customer
     C     ddCUSTOK      IFEQ      'N'
     C                   MOVEL     @DDCUST       DDCUST
     C                   END
     C*
     C* Value Date
     C     ddVDATOK      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
     C*
     C* Option To Date
     C     ddODATOK      IFEQ      'N'
     C                   MOVEL     @DDODAT       DDODAT
     C                   END
      *                                                                         CAP004
      * Book code                                                               CAP004
     C     ddBOKCOK      IFEQ      'N'                                          CAP004
     C                   MOVEL     @DDBOKC       DDBOKC                         CAP004
     C                   END                                                    CAP004
     C*
     C* Portfolio Reference
     C     ddPTFROK      IFEQ      'N'
     C                   MOVEL     @DDPTFR       DDPTFR
     C                   END
     C*
     C* Buy currency
     C     ddBCCYOK      IFEQ      'N'
     C                   MOVEL     @DDBCCY       DDBCCY
     C                   END
     C*
     C* Buy amount
     C     ddBAMTOK      IFEQ      'N'
     C                   MOVEL     @DDBAMT       DDBAMT
     C                   END
     C*
     C* Exchange Rate
     C     ddRATEOK      IFEQ      'N'
     C**********         MOVEL     @DDRATE       DDRATE                                       196952
     C                   MOVEL     @DDRAT1       DDRAT1                                       196952
     C                   END
     C*
     C* Forward Points
     C     ddFPNTOK      IFEQ      'N'
     C                   MOVEL     @DDFPNT       DDFPNT
     C                   END
     C*
     C* Forward Points sign
     C     ddSIGNOK      IFEQ      'N'
     C                   MOVEL     @DDSIGN       DDSIGN
     C                   END
     C*
     C* Margin Points
     C     ddMGINOK      IFEQ      'N'
     C                   MOVEL     @DDMGIN       DDMGIN
     C                   END
     C*
     C* Margin Points Buy/sell Indicator
     C     ddMBSIOK      IFEQ      'N'
     C                   MOVEL     @DDMBSI       DDMBSI
     C                   END
     C*
     C* Sell currency
     C     ddSCCYOK      IFEQ      'N'
     C                   MOVEL     @DDSCCY       DDSCCY
     C                   END
     C*
     C* Sell amount
     C     ddSAMTOK      IFEQ      'N'
     C                   MOVEL     @DDSAMT       DDSAMT
     C                   END
     C*
     C* Profit Centre
     C     ddPRFCOK      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
     C*
     C* Base Currency Equivalent
     C     ddBCEOK       IFEQ      'N'
     C                   MOVEL     @DDBCE        DDBCE
     C                   END
     C*                                                                                       CDL038
     C* Class                                                                                 CDL038
     C     ddCLASOK      IFEQ      'N'                                                        CDL038
     C                   MOVEL     @DDCLAS       DDCLAS                                       CDL038
     C                   END                                                                  CDL038
      *                                                                                       CDL099
      ** Split Value Date                                                                     CDL099
     C     CDL099        IFEQ      'Y'                                                        CDL099
     C     ddSDATOK      IFEQ      'N'                                                        CDL099
     C                   MOVEL     @DDSDAT       DDSDAT                                       CDL099
     C                   ENDIF                                                                CDL099
     C                   ENDIF                                                                CDL099
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CONVDATES  - Convert date fields from FXDEALPP from DDMMYYYY  *
      *              to Midas Dayno (5,0) format for comparison       *
      *****************************************************************
     C     CONVDATES     BEGSR
     C*
     C***********************************************
     C**  Format the transaction date               *
     C***********************************************
     C*
     C                   Z-ADD     FHDTYY        @@YY
     C                   Z-ADD     FHDTMM        @@MM
     C                   Z-ADD     FHDTDD        @@DD
     C*
     C     DateIn        IFEQ      0
     C                   Z-ADD     0             TransDate
     C                   ELSE
     C                   CALLB     'ZDATE10'
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO            5 0
     C                   MOVE      ZZMDNO        TransDate
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    DealScnFmt
      *
      * Current Deal in file format
     C                   PARM                    DealFilFmt
      *                                                                                     MD047971
      ** Pay/rcv settlement account                                                         MD047971
      *                                                                                     MD047971
     C                   PARM                    DDRONX                                     MD047971
     C                   PARM                    DDPONX                                     MD047971
     C                   PARM                    DDRONXOK                                   MD047971
     C                   PARM                    DDPONXOK                                   MD047971
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
     C                   PARM                    NwExtDlScnFmt                                CDL099
     C                   PARM                    CrExtDlScnFmt                                CDL099
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXFXDLAMD'   DBPGM
     C*
     C**  GET RUNDAT to access MULTI-BRANCHING flag.
     C**
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
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
      ** PORTFOLIO MANAGEMENT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         *************
     C                   MOVEL     '903'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
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
      *                                                                                       CDL039
      ** Access SAR details file to determine if CDL099 is installed                          CDL099
     C                   CALL      'AOSARDR0'                                                 CDL099
     C                   PARM      *BLANKS       @RTCD                                        CDL099
     C                   PARM      '*VERIFY'     @OPTN                                        CDL099
     C                   PARM      'CDL099'      @SARD             6                          CDL099
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL099
      *                                                                                       CDL099
     C     @RTCD         IFEQ      *BLANK                                                     CDL099
     C                   MOVEL     'Y'           CDL099            1                          CDL099
     C                   ELSE                                                                 CDL099
     C                   MOVEL     'N'           CDL099                                       CDL099
     C                   ENDIF                                                                CDL099
      *
      ** Get FX complete deal amendable fields details
      *
     C     1             CHAIN     FXCDAFLL                           60
      *
      **  If no valid record found then it is a data base error.
      *
     C     *IN60         IFEQ      '1'
     C     FDDLTF        OREQ      '*'
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   MOVEL     'FXCDAFLL'    DBFILE                         * DBERROR 018 *
     C                   MOVE      '904'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
