     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility details amend checking')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEFCIPAMD - Facility Amend Checking                          *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended facility against those currently on file. *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  BUG3723 - Recompile due to changes to LEFCSPPD, LEEFCISPD.   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      * New Facility in Screen Format
     D FcipNwPrim    E DS                  EXTNAME(LEFCPPPD)
     D FcipNwSeco    E DS                  EXTNAME(LEFCSPPD)
 
      * (Current) Facility in Screen Format - First screen
     D CurPriScn     E DS                  EXTNAME(LEFCPPPD)
     D                                     PREFIX(@)
      * (Current) Facility in Screen Format - Second screen
     D CurSecScn     E DS                  EXTNAME(LEFCSPPD)
     D                                     PREFIX(@)
 
      * Valid Facility FM layout
     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
     D                                     PREFIX(V_)
      * Valid Facility FN layout
     D ValidFacn     E DS                  EXTNAME(LEVFCINPD)
     D                                     PREFIX(V_)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
      *
      ** RUNDAT DATA AREA
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFcPrim      E DS                  EXTNAME(LEEFCIPPD)
     D OKFcSeco      E DS                  EXTNAME(LEEFCISPD)
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
      * COMPFLDS  - Compare certain fields on the current Facility    *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
      *
      **   Screen 1
      *
     C     SCREEN        IFEQ      '1'
     C     SCREEN        OREQ      ' '
     C*-----------------------------------------*
     C* Branch code    OK                       *
     C*-----------------------------------------*
     C*
     C     DDBRCA        IFNE      @DDBRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0400'
     C                   EVAL      DDBRCAOK        = 'N'
     C                   ENDIF
      *
     C*-----------------------------------------*
     C* Currency         OK                     *
     C*-----------------------------------------*
     C*
     C     DDFCCY        IFNE      @DDFCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCCY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0401'
     C                   EVAL      DDFCCYOK        = 'N'
     C                   ENDIF
      *
     C*--------------------------------------------------*
      **  Protect Facility Amount
      **  if CLE005 and CLE007 are installed
      **  or if Participant Facility ind equal to P or I *
     C*--------------------------------------------------*
      *
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C     V_FPPRTR      OREQ      'P'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     V_FPPRTR      OREQ      'I'
     C     CLE106        ANDNE     'Y'                                                        CLE106
 
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDFAMT        ZCMPAMT1         25
     C                   PARM      @DDFAMT       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
 
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0402'
     C                   EVAL      DDFAMTOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------*
     C* Start date   OK                         *
     C*-----------------------------------------*
     C*
     C     DDDTAP        IFNE      @DDDTAP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDTAP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0403'
     C                   EVAL      DDDTAPOK        = 'N'
     C                   ENDIF
      *
     C*-----------------------------------------*
     C* Revolving credit must be protected    OK*
      **  if CLE005 and CLE007 are installed
     C*-----------------------------------------*
     C*
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C     DDRVCR        IFNE      @DDRVCR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRVCR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0404'
     C                   EVAL      DDRVCROK        = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C*-----------------------------------------------*
     C* Multi currency   must be protected    OK      *
      **  if Participant Facility ind equal to P or I *
     C*-----------------------------------------------*
     C     CLE106        IFNE      'Y'                                                        CLE106
     C     V_FPPRTR      IFEQ      'P'
     C     V_FPPRTR      OREQ      'I'
     C     DDMCCY        IFNE      @DDMCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMCCY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0405'
     C                   EVAL      DDMCCYOK        = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CLE106
 
     C*---------------------------------------------*
     C* Expiry date must be protected               *
      * if Participant Facility ind equal to P or I *
      * or if the Facility has expired or is closed *
     C*---------------------------------------------*
     C*
     C     CLE106        IFNE      'Y'                                                        CLE106
     C     V_FPPRTR      IFEQ      'P'
     C     V_FPPRTR      OREQ      'I'
 
     C     DDDTEX        IFNE      @DDDTEX
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDTEX'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0406'
     C                   EVAL      DDDTEXOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                CLE106
     C*
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C     V_FPRECI      IFEQ      'C'
     C     V_FPDTEX      ORLT      BJRDNB
 
     C     DDDTEX        IFNE      @DDDTEX
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDTEX'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0406'
     C                   EVAL      DDDTEXOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
     C*-----------------------------------------------*
     C* Multi customer must be protected              *
      **  if Participant Facility ind equal to P or I *
     C*-----------------------------------------------*
     C*
     C     CLE106        IFNE      'Y'                                                        CLE106
     C     V_FPPRTR      IFEQ      'P'
     C     V_FPPRTR      OREQ      'I'
 
     C     DDMCSI        IFNE      @DDMCSI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMCSI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0407'
     C                   EVAL      DDMCSIOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                CLE106
      *
     C*-----------------------------------------------*
     C* Profit center must be protected               *
      **  if Profit center not used                   *
      **  or if Profit center not amendable           *
     C*-----------------------------------------------*
 
     C     BKPRCU        IFEQ      'N'
     C     BKPRCA        OREQ      'N'
 
     C     DDPRFC        IFNE      @DDPRFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0408'
     C                   EVAL      DDPRFCOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------------*
     C* Origin branch must be protected               *
      **  if not Multi branching                      *
     C*-----------------------------------------------*
 
     C     MBIN          IFEQ      'N'
 
     C     DDORBR        IFNE      @DDORBR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDORBR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0409'
     C                   EVAL      DDORBROK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------------*
     C* Tranche/Credit agreement must be protected    *
      **  if CLE005 not installed                     *
     C*-----------------------------------------------*
 
     C     CLE005        IFEQ      'N'
 
     C     DDTRCA        IFNE      @DDTRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0410'
     C                   EVAL      DDTRCAOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------------*
     C* Credit agreement customer must be protected   *
      **  if CLE005 not installed                     *
     C*-----------------------------------------------*
 
     C     CLE005        IFEQ      'N'
 
     C     DDCANM        IFNE      @DDCANM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCANM'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0411'
     C                   EVAL      DDCANMOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------------*
     C* Credit agreement type/no  must be protected   *
      **  if CLE005 not installed                     *
     C*-----------------------------------------------*
 
     C     CLE005        IFEQ      'N'
 
     C     DDCAFT        IFNE      @DDCAFT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCAFT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0412'
     C                   EVAL      DDCAFTOK        = 'N'
     C                   ENDIF
 
     C     DDCAFN        IFNE      @DDCAFN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCAFN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0412'
     C                   EVAL      DDCAFNOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------------*
     C* Account seq no must be protected              *
      **  if CLE005 not installed                     *
      ** or if CLE007 not installed                     *
     C*-----------------------------------------------*
 
     C     CLE005        IFEQ      'N'
     C     CLE007        OREQ      'N'
 
     C     DDACSQ        IFNE      @DDACSQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACSQ'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0413'
     C                   EVAL      DDACSQOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-----------------------------------------------*
     C* Multi  branch must be protected               *
      **  if not Multi branching                      *
     C*-----------------------------------------------*
 
     C     MBIN          IFEQ      'N'
 
     C     DDMBFC        IFNE      @DDMBFC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMBFC'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0414'
     C                   EVAL      DDMBFCOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
      *
      **   Screen 2
      *
     C     SCREEN        IFEQ      '2'
     C     SCREEN        OREQ      ' '
     C*---------------------------------------------*
     C* Syndication indicator must be protected       *
      **  if Participant Facility ind equal to P or I *
     C*---------------------------------------------*
     C*
     C     CLE106        IFNE      'Y'                                                        CLE106
     C     V_FPPRTR      IFEQ      'P'
     C     V_FPPRTR      OREQ      'I'
 
     C     DDSYIN        IFNE      @DDSYIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSYIN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0415'
     C                   EVAL      DDSYINOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                CLE106
      *
     C*---------------------------------------------*
     C* Syndication complete must be protected      *
      **  if Participant Facility ind equal to P or I *
     C*---------------------------------------------*
     C*
     C     CLE106        IFNE      'Y'                                                        CLE106
     C     V_FPPRTR      IFEQ      'P'
     C     V_FPPRTR      OREQ      'I'
 
     C     DDSYCP        IFNE      @DDSYCP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSYCP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0416'
     C                   EVAL      DDSYCPOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                CLE106
      *
     C*---------------------------------------------*
     C* Agent Customer must be protected            *
      **  if Participant Facility ind equal to P or I *
     C*---------------------------------------------*
     C*
     C     CLE106        IFNE      'Y'                                                        CLE106
     C     V_FPPRTR      IFEQ      'P'
     C     V_FPPRTR      OREQ      'I'
 
     C     DDANUM        IFNE      @DDANUM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDANUM'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0417'
     C                   EVAL      DDANUMOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                CLE106
      *
     C*-----------------------------------------------------*
     C* Loan Administrator Id must be protected             *
      **                                                    *
      **  if Participant Facility ind equal to P or I       *
      **  and CLE008 = 'N'                                  *
      **                                                    *
      **or if Participant Facility ind not equal to P and I *
      **  and CLE008 = 'N'                                  *
      **                                                    *
      **or if Participant Facility ind equal to P or I       *
      **                                                    *
      **or if Participant Facility ind not equal to P and I *
      **  and CLE008 = 'N'                                  *
     C*---------------------------------------------*
     C*
 
     C     V_FPPRTR      IFEQ      'P'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     V_FPPRTR      OREQ      'I'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     CLE008        OREQ      'N'
 
     C     DDLAID        IFNE      @DDLAID
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLAID'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0418'
     C                   EVAL      DDLAIDOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
     C*---------------------------------------------*
     C* Currency selection must be protected        *
      **  if Multi-currency is not 'Y'              *
     C*---------------------------------------------*
     C*
     C     DDMCCY        IFNE      'Y'
 
     C     DDCSEL        IFNE      @DDCSEL
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCSEL'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0419'
     C                   EVAL      DDCSELOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
     C*---------------------------------------------*
     C* Allowable currency must be protected        *
      **  if Multi-currency is not 'Y'              *
     C*---------------------------------------------*
     C*
     C     DDMCCY        IFNE      'Y'
 
     C     DDCY01        IFNE      @DDCY01
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY01'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY01OK        = 'N'
     C                   ENDIF
 
     C     DDCY02        IFNE      @DDCY02
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY02'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY02OK        = 'N'
     C                   ENDIF
 
     C     DDCY03        IFNE      @DDCY03
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY03'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY03OK        = 'N'
     C                   ENDIF
 
     C     DDCY04        IFNE      @DDCY04
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY04'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY04OK        = 'N'
     C                   ENDIF
 
     C     DDCY05        IFNE      @DDCY05
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY05'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY05OK        = 'N'
     C                   ENDIF
 
     C     DDCY06        IFNE      @DDCY06
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY06'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY06OK        = 'N'
     C                   ENDIF
 
     C     DDCY07        IFNE      @DDCY07
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY07'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY07OK        = 'N'
     C                   ENDIF
 
     C     DDCY08        IFNE      @DDCY08
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY08'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY08OK        = 'N'
     C                   ENDIF
 
     C     DDCY09        IFNE      @DDCY09
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY09'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY09OK        = 'N'
     C                   ENDIF
 
     C     DDCY10        IFNE      @DDCY10
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY10'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY10OK        = 'N'
     C                   ENDIF
 
     C     DDCY11        IFNE      @DDCY11
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY11'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY11OK        = 'N'
     C                   ENDIF
 
     C     DDCY12        IFNE      @DDCY12
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCY12'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0420'
     C                   EVAL      DDCY12OK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
      *
     C*---------------------------------*
     C* Closing date must be protected  *
      **  if CLE006 is 'N'              *
     C*---------------------------------*
     C*
     C     CLE006        IFEQ      'N'
 
     C     DDCDTE        IFNE      @DDCDTE
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCDTE'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0421'
     C                   EVAL      DDCDTEOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*-------------------------------------------------------------*
     C* Default Participation Loan type/sub type must be protected  *
      **  if CLE006 is 'N'              *                           *
      ** or if Participant Facility ind equal to P or I             *
     C*-------------------------------------------------------------*
     C*
     C     V_FPPRTR      IFEQ      'P'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     V_FPPRTR      OREQ      'I'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     CLE006        OREQ      'N'
 
     C     DDDFTP        IFNE      @DDDFTP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'
     C     CLE042        IFEQ      'Y'                                                        CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0600'                                CLE042
     C                   ELSE                                                                 CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0422'
     C                   ENDIF                                                                CLE042
     C                   EVAL      DDDFTPOK        = 'N'
     C                   ENDIF
 
     C     DDDFST        IFNE      @DDDFST
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFST'
     C     CLE042        IFEQ      'Y'                                                        CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0600'                                CLE042
     C                   ELSE                                                                 CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0422'
     C                   ENDIF                                                                CLE042
     C                   EVAL      DDDFSTOK        = 'N'
     C                   ENDIF
                                                                                              CLE042
     C     DDDFCL        IFNE      @DDDFCL                                                    CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   EVAL      FldNameArr(Idx) = 'DDDFCL'                                 CLE042
     C     CLE042        IFEQ      'Y'                                                        CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0600'                                CLE042
     C                   ELSE                                                                 CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0422'                                CLE042
     C                   ENDIF                                                                CLE042
     C                   EVAL      DDDFCLOK        = 'N'                                      CLE042
     C                   ENDIF                                                                CLE042
 
     C                   ENDIF
 
     C*-------------------------------------------------------------*
     C* Credit agreement exchange rate must be protected  *
      **  if CLE005 is 'N'              *                           *
     C*-------------------------------------------------------------*
     C*
     C     CLE005        IFEQ      'N'
 
     C     DDCAXR        IFNE      @DDCAXR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCAXR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0423'
     C                   EVAL      DDCAXROK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C*--------------------------------------------*
     C* Exchange rate indicator must be protected  *
      **  if CLE005 is 'N'                         *
     C*--------------------------------------------*
     C*
     C     CLE005        IFEQ      'N'
 
     C     DDCMDI        IFNE      @DDCMDI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCMDI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEF0424'
     C                   EVAL      DDCMDIOK        = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      * SCREEN 1
      *
      * Branch code
     C     DDBRCAOK      IFEQ      'N'
     C                   MOVEL     @DDBRCA       DDBRCA
     C                   END
     C*
     C* Currency
     C     DDFCCYOK      IFEQ      'N'
     C                   MOVEL     @DDFCCY       DDFCCY
     C                   END
     C*
      * Facility Amount
     C     DDFAMTOK      IFEQ      'N'
     C                   MOVEL     @DDFAMT       DDFAMT
     C                   END
     C*
      * Start date
     C     DDDTAPOK      IFEQ      'N'
     C                   MOVEL     @DDDTAP       DDDTAP
     C                   END
     C*
      * Revolving CR
     C     DDRVCROK      IFEQ      'N'
     C                   MOVEL     @DDRVCR       DDRVCR
     C                   END
     C*
      * Multi currency
     C     DDMCCYOK      IFEQ      'N'
     C                   MOVEL     @DDMCCY       DDMCCY
     C                   END
     C*
      * Expiry date
     C     DDDTEXOK      IFEQ      'N'
     C                   MOVEL     @DDDTEX       DDDTEX
     C                   END
     C*
      * Multi customer
     C     DDMCSIOK      IFEQ      'N'
     C                   MOVEL     @DDMCSI       DDMCSI
     C                   END
     C*
      * Profit center
     C     DDPRFCOK      IFEQ      'N'
     C                   MOVEL     @DDPRFC       DDPRFC
     C                   END
     C*
      * Origin Branch
     C     DDORBROK      IFEQ      'N'
     C                   MOVEL     @DDORBR       DDORBR
     C                   END
     C*
      * Tranche/CR agreement
     C     DDTRCAOK      IFEQ      'N'
     C                   MOVEL     @DDTRCA       DDTRCA
     C                   END
     C*
      * Credit agreement customer
     C     DDCANMOK      IFEQ      'N'
     C                   MOVEL     @DDCANM       DDCANM
     C                   END
     C*
      * Credit agreement type/No
     C     DDCAFTOK      IFEQ      'N'
     C                   MOVEL     @DDCAFT       DDCAFT
     C                   END
     C     DDCAFNOK      IFEQ      'N'
     C                   MOVEL     @DDCAFN       DDCAFN
     C                   END
     C*
      * Account seq.
     C     DDACSQOK      IFEQ      'N'
     C                   MOVEL     @DDACSQ       DDACSQ
     C                   END
     C*
      * Multi branch
     C     DDMBFCOK      IFEQ      'N'
     C                   MOVEL     @DDMBFC       DDMBFC
     C                   END
     C*
      * Syndication indicator
     C     DDSYINOK      IFEQ      'N'
     C                   MOVEL     @DDSYIN       DDSYIN
     C                   END
     C*
      * Syndication complete
     C     DDSYCPOK      IFEQ      'N'
     C                   MOVEL     @DDSYCP       DDSYCP
     C                   END
     C*
      * Agent customer
     C     DDANUMOK      IFEQ      'N'
     C                   MOVEL     @DDANUM       DDANUM
     C                   END
     C*
      * Loan administrator
     C     DDLAIDOK      IFEQ      'N'
     C                   MOVEL     @DDLAID       DDLAID
     C                   END
     C*
      * Currency selection
     C     DDCSELOK      IFEQ      'N'
     C                   MOVEL     @DDCSEL       DDCSEL
     C                   END
     C*
      * Allowable currency
     C     DDCY01OK      IFEQ      'N'
     C                   MOVEL     @DDCY01       DDCY01
     C                   END
     C*
     C     DDCY02OK      IFEQ      'N'
     C                   MOVEL     @DDCY02       DDCY02
     C                   END
     C*
     C     DDCY03OK      IFEQ      'N'
     C                   MOVEL     @DDCY03       DDCY03
     C                   END
     C*
     C     DDCY04OK      IFEQ      'N'
     C                   MOVEL     @DDCY04       DDCY04
     C                   END
     C*
     C     DDCY05OK      IFEQ      'N'
     C                   MOVEL     @DDCY05       DDCY05
     C                   END
     C*
     C     DDCY06OK      IFEQ      'N'
     C                   MOVEL     @DDCY06       DDCY06
     C                   END
     C*
     C     DDCY07OK      IFEQ      'N'
     C                   MOVEL     @DDCY07       DDCY07
     C                   END
     C*
     C     DDCY08OK      IFEQ      'N'
     C                   MOVEL     @DDCY08       DDCY08
     C                   END
     C*
     C     DDCY09OK      IFEQ      'N'
     C                   MOVEL     @DDCY09       DDCY09
     C                   END
     C*
     C     DDCY10OK      IFEQ      'N'
     C                   MOVEL     @DDCY10       DDCY10
     C                   END
     C*
     C     DDCY11OK      IFEQ      'N'
     C                   MOVEL     @DDCY11       DDCY11
     C                   END
     C*
     C     DDCY12OK      IFEQ      'N'
     C                   MOVEL     @DDCY12       DDCY12
     C                   END
     C*
      * Closing date
     C     DDCDTEOK      IFEQ      'N'
     C                   MOVEL     @DDCDTE       DDCDTE
     C                   END
     C*
      * Default Participation type/Sub type
     C     DDDFTPOK      IFEQ      'N'
     C                   MOVEL     @DDDFTP       DDDFTP
     C                   END
     C*
     C     DDDFSTOK      IFEQ      'N'
     C                   MOVEL     @DDDFST       DDDFST
     C                   END
     C*                                                                                       CLE042
     C     DDDFCLOK      IFEQ      'N'                                                        CLE042
     C                   MOVEL     @DDDFCL       DDDFCL                                       CLE042
     C                   END                                                                  CLE042
     C*
      * Credit agreement exchange rate
     C     DDCAXROK      IFEQ      'N'
     C                   MOVEL     @DDCAXR       DDCAXR
     C                   END
     C*
      * Exchange rate indicator
     C     DDCMDIOK      IFEQ      'N'
     C                   MOVEL     @DDCMDI       DDCMDI
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
      * New Facility in Screen Format
     C                   PARM                    FcipNwPrim
     C                   PARM                    FcipNwSeco
      *
      * Current Facility in Screen Format
     C                   PARM                    CurPriScn
     C                   PARM                    CurSecScn
      *
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      *
      * Switchable features
     C                   PARM                    CLE005            1
     C                   PARM                    CLE006            1
     C                   PARM                    CLE007            1
     C                   PARM                    CLE008            1
      *
      * Screen to vlidate
     C                   PARM                    SCREEN            1
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFcPrim
     C                   PARM                    OKFcSeco
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
      *
      ** Initialize program name
      *
     C                   MOVEL     'LEFCIPAMD'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
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
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
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
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
     C     *DTAARA       DEFINE                  RUNDAT
      *
      **  GET MBIN FROM DTAARA/RUNDAT
     C                   IN        RUNDAT
      *                                                                                       CLE106
      ** Access Switchable SAR details for the existence of CLE106                            CLE106
      *                                                                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANK        @RTCD             7                          CLE106
     C                   PARM      '*VERIFY'     @OPTN             7                          CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
      *                                                                                       CLE106
     C     @RTCD         IFEQ      *BLANKS                                                    CLE106
     C                   MOVE      'Y'           CLE106            1                          CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE042
      ** Access Switchable SAR details for the existence of CLE042                            CLE042
      *                                                                                       CLE042
     C                   CALLB     'AOSARDR0'                                                 CLE042
     C                   PARM      *BLANK        @RTCD             7                          CLE042
     C                   PARM      '*VERIFY'     @OPTN             7                          CLE042
     C                   PARM      'CLE042'      @SARD                                        CLE042
      *                                                                                       CLE042
     C     @RTCD         IFEQ      *BLANKS                                                    CLE042
     C                   MOVE      'Y'           CLE042            1                          CLE042
     C                   ELSE                                                                 CLE042
     C                   MOVE      'N'           CLE042                                       CLE042
     C                   ENDIF                                                                CLE042
 
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
(c) Misys International Banking Systems Ltd. 2002
