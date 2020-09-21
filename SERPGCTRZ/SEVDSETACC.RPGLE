     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Charge Settlement Account')          *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDSETACC - Validate Charge Settlement Account.             *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Settlement Account Field                          *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  Component of: SE0070 - Depot Movement Maintenance            *
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
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10469           Date 15Mar06               *
      *                 CAP087             Date 08Sep05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003 *CREATE     Date 24Apr98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10469 - Fees functionality is missing from Bond           *
      *             Borrowing and Bond Lending input.                 *
      *  CAP087 - Depot Movement API - Java Wrapper in Midasplus.     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
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
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
     D DIGITS          C                   CONST('0123456789')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D  RECI2        E                     EXTFLD(RECI)
     D  CCY2         E                     EXTFLD(CCY)
     D  ORED2        E                     EXTFLD(ORED)
     D  LCD2         E                     EXTFLD(LCD)
     D  CHTP2        E                     EXTFLD(CHTP)
     D  TNLU2        E                     EXTFLD(TNLU)
     D  XXPTFR       E                     EXTFLD(PTFR)
     D  PRFC2        E                     EXTFLD(PRFC)
 
      ** Retail ICD
      ** External DS for Which Modules Installed
      ** DS for access Programs, Short DS
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDMOD         E DS                  EXTNAME(SDMMODPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen fields
     D DDDCCE          S              3A
     D DDDCSE          S              2A
     D***DDDCAT*         S             12A                                                    CGL029
     D DDDCAT          S             18A                                                      CGL029
     D DDDCAB          S              3A
     D DDDCHC          S              2A
     D DDDCHA          S             14A
 
      ** Depot Movement details
     D ACTNTP          S              2A
     D DPBA            S              3A
     D*DPBN*****       S              6S 0                                                    CSD027
     D DPBN            S              6A                                                      CSD027
     D DPDO            S              5P 0
     D DPMD            S              5P 0
     D DDDCSEOk        S              1A
     D DDDCABOk        S              1A
 
      ** System input
     D BVACOP          S              1A
     D S01445          S              1A
 
      ** Output
     D***DCAT***         S             12A                                                    CGL029
     D DCAT            S             18A                                                      CGL029
     D DDDCATOk        S              1A
 
      ** Working Variables
      ** -----------------
 
     D @CNUM           S              6A
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0
                                                                                              CGL029
     D @ACCD           S             10A                                                      CGL029
     D UHACCD          S             10A                                                      CGL029
     D UHACSQ          S              2A                                                      CGL029
     D UHEND           S              8A                                                      CGL029
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      ** Validate
      *
     C     DDDCSEOk      IFEQ      'Y'
     C     DDDCABOk      ANDEQ     'Y'
     C                   EXSR      DCATV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDCATOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DCATV - Validation routine for Settlement Account field.      *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     DCATV         BEGSR
      *
      ** If Autocharge is switched on, and SAR 01445 is ON, validate
      *
     C     BVACOP        IFEQ      'Y'
     C     S01445        ANDEQ     'Y'
      *                                                                                     BUG10469
      * Also validate for Bonds even if Autocharge and S01445 are OFF.                      BUG10469
     C     ACTNTP        OREQ      'BB'                                                     BUG10469
     C     ACTNTP        OREQ      'BL'                                                     BUG10469
      *
      ** If any charge values entered, go on to validate them
      *
     C     DDDCHC        IFNE      *BLANK
     C     DDDCCE        ORNE      *BLANK
     C     DDDCHA        ORNE      *BLANK
     C     DDDCSE        ORNE      *BLANK
     C     DDDCAT        ORNE      *BLANK
     C     DDDCAB        ORNE      *BLANK
      *
      ** If depot movement is type = Walk-In/Walk-Out, validate
      ** Otherwise, Error.
      ** Also validate for Bond Borrowing (BB) or Bond Lending (BL),                          CAP087
      ** Pledge Deposit (PD) and Pledge Loan (PL).                                            CAP087
      *
     C     ACTNTP        IFEQ      'WI'
     C     ACTNTP        OREQ      'WO'
     C     ACTNTP        OREQ      'BB'                                                       CAP087
     C     ACTNTP        OREQ      'BL'                                                       CAP087
     C     ACTNTP        OREQ      'PD'                                                       CAP087
     C     ACTNTP        OREQ      'PL'                                                       CAP087
      *
      ** Initialise database field
      *
     C                   MOVE      DDDCAT        DCAT
      *
      ** Charge Settlement method  = 00
      *
     C     DDDCSE        IFEQ      '00'
 
     C     DDDCAT        IFNE      *BLANKS
      *
      ** Error 251
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0372'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   END
 
     C                   END
      *
      ** Charge Settlement method  = 04
      *
     C     DDDCSE        IFEQ      '04'
 
     C     DDDCAT        IFNE      *BLANKS
      *
      ** Error 251
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0372'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
 
     C                   MOVEL     DPBN          @CNUM
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @RETL            10
     C                   PARM                    @CNUM
     C                   PARM      DDDCCE        @CUCD             3
     C**********         PARM      BMACCD        @ACCD             4                          CGL029
     C                   PARM      BMACCD        @ACCD                                        CGL029
     C                   PARM      '01'          @ACSQ             2
     C                   PARM      DPBA          @BRCA             3
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI2         ANDNE     'D'
      *
      ** Error 252
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0373'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
     C                   MOVE      BRCA          RBranch
     C                   END
 
     C                   END
     C                   END
      *
      ** Charge Settlement method  = 05
      *
     C     DDDCSE        IFEQ      '05'
     C     DIGITS        CHECK     DDDCAT                                 90
     C     *IN90         IFEQ      *ON
      *
      ** Error 253
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0379'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
 
     C     6             SUBST     DDDCAT:1      UHCNUM            6
     C*****4****         SUBST     DDDCAT:7      UHACCD            4                          CGL029
     C*****2****         SUBST     DDDCAT:11     UHACSQ            2                          CGL029
     C     10            SUBST     DDDCAT:7      UHACCD                                       CGL029
     C     2             SUBST     DDDCAT:17     UHACSQ                                       CGL029
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @RETL
     C                   PARM      UHCNUM        @CNUM
     C                   PARM      DDDCCE        @CUCD
     C                   PARM      UHACCD        @ACCD
     C                   PARM      UHACSQ        @ACSQ
     C                   PARM      DDDCAB        @BRCA
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C     @RTCD         IFNE      *BLANKS
 
     C     @RTCD         OREQ      *BLANKS
     C     RECI2         ANDNE     'D'
      *
      ** Error 254
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0374'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
     C                   MOVE      DDDCAT        DCAT
     C                   END
 
     C                   END
     C                   END
      *
      ** Charge Settlement method  = 14
      *
     C     DDDCSE        IFEQ      '14'
 
     C     10            SUBST     DDDCAT:1      UHRETL           10
     C*****2****         SUBST     DDDCAT:11     UHEND             2                          CGL029
     C     8             SUBST     DDDCAT:11     UHEND                                        CGL029
 
     C     UHEND         IFEQ      *BLANKS
     C     DIGITS        CHECK     UHRETL                                 90
     C                   END
 
     C     UHEND         IFNE      *BLANKS
     C     *IN90         OREQ      *ON
      *
      ** Error 255
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0375'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
 
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      UHRETL        @RETL
     C                   PARM      *BLANKS       @CNUM
     C                   PARM      *BLANKS       @CUCD
     C                   PARM      *BLANKS       @ACCD
     C                   PARM      *BLANKS       @ACSQ
     C                   PARM      *BLANKS       @BRCA
     C     ACCNT         PARM      ACCNT         DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         OREQ      *BLANKS
     C     RECI2         ANDNE     'D'
      *
      ** Error 255
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0375'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
      *
      **  Check currency of Account is correct
      *
     C     CCY2          IFNE      DDDCCE
      *
      ** Error 256
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0376'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   ELSE
      *
     C                   MOVE      DDDCAT        DCAT
     C                   MOVE      BRCA          RBranch
     C                   END
 
     C                   END
     C                   END
     C                   END
      *
      *
      ** If settlement method = 04, 05, or 14 then if
      ** date account opened is greater than movement date in OR
      ** account status is 'C' then error
      *
     C     DDDCATOk      IFNE      'N'
     C     DDDCSEOk      ANDNE     'N'
     C     DDDCSE        IFEQ      '04'
     C     DDDCSE        OREQ      '05'
     C     DDDCSE        OREQ      '14'
      *
      ** Get date for walk-in/walk-out
      *
     C     DPMD          IFNE      *ZERO
     C                   Z-ADD     DPMD          MVTDTE            6 0
     C                   ELSE
     C                   Z-ADD     DPDO          MVTDTE
     C                   END
      *
      ** If account opened date is greater than walk-in/out date,
      ** error or Account Status is 'C' (closed) then Error
      *
     C     DACO          IFGT      MVTDTE
     C     ACST          OREQ      'C'
      *
      ** Error 257
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0377'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   END
      *
      ** If 2nd bit is ON, Error - account is blocked for money leaving
      *
     C                   TESTB     '2'           RETB                 99
 
     C     *IN99         IFEQ      '0'
      *
      ** Error 258
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0378'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   END
 
     C                   END
     C                   END
 
     C                   ELSE
      *
     C     DDDCAT        IFNE      *BLANKS
      *
      ** Error 240
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDDCAT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0380'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDDCATOk
     C                   END
 
     C                   END
     C                   END
     C                   END
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      **--------------------------------------------------------------**
      **                                                              **
      ** This module should be called after the execution of the      **
      ** validation module for Charge Currency.  This module uses the **
      ** field OK indicator of the Charge Currency field which is set **
      ** on the said module.                                          **
      **                                                              **
      **--------------------------------------------------------------**
 
      ** Return Code Error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Screen fields
      ** Charge Code (2A)
      ** Charge Currency (3A)
      ** Charge Amount   (14A)
      ** Charge Settlement Method (2A)
      ** Charge Settlement Account (12A)
      ** Charge Settlement Branch (3A)
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
 
      ** Depot Movement details
      ** Depot Movement type (2A)
      ** Branch (3A)
      ** In Date (5P 0)
      ** Out Date (5P 0)
      ** Charge Settlement Method Ok Indicator (1A)
      ** Charge Settlement Branch Ok Indicator (1A)
     C                   PARM                    ACTNTP
     C                   PARM                    DPBA
     C                   PARM                    DPBN
     C                   PARM                    DPMD
     C                   PARM                    DPDO
     C                   PARM                    DDDCSEOk
     C                   PARM                    DDDCABOk
 
      ** System input
      ** AutoCharge Indicator (1A)
      ** S01445 Indicator (1A)
     C                   PARM                    BVACOP
     C                   PARM                    S01445
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     ** Account Code Ok Indicator(12A)
     ** Account Code (12A)
     ** Retail Account Branch
 
     C                   PARM                    RBranch           3
     C                   PARM                    DDDCATOk
     C                   PARM                    DCAT
      *
      **  Access Retail details if retail module is ON
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMOD         PARM      SDMOD         DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      *PSSR                                        ************
     C                   END
      *
     C     BGRTBN        IFEQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   END
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      *PSSR                                        ************
     C                   END
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
