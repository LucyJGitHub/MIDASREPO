     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate portfolio reference')                *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVPORTRF - Validate portfolio reference                     *
      *                                                               *
      *  Function:  This module checks the validity of the  portfolio *
      *             reference on an FF trade .                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10345           Date 06Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 06Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG10345 - PMC1140 DBASE ERROR 11, PM1142 ,PF/ SDPLCSPD      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CPB001 - 'Private Banking' Module                            *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Portfolio definition details
     FPMPORTPD  IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** Portfolio customer details accessed via access program
 
     D @DSFDY        E DS                  EXTNAME(DSFDY)
      ** First DS for access programs , short data structure
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
 
     D PMPORT        E DS                  EXTNAME(PMPORTPD) EXPORT
      ** PMPORTPD exported because account sequence field is
      ** needed in FFSETLVAL
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Portfolio reference
     D SPTFR           S              4A
 
      ** Portfolio management
     D BGPFMG          S              1A
 
      ** Customer code
     D*CUSC*****       S              6S 0                                                    CSD027
     D CUSC            S              6A                                                      CSD027
 
      ** Flag to indicate whether customer is a client portfolio and
      ** the portfolio exists in PMPORTPD (exported as a module a long
      ** way from here (FFSETLVAL) needs it)
     D WWPORT          S              1A   EXPORT
 
      ** Private Banking Module                                                 CPB001
     D BGN4ST          S              1A                                        CPB001
                                                                                CPB001
      ** Private Banking Customer Indicator                                     CPB001
     D BBPRBA          S              1A                                        CPB001
 
      ** Portfolio Customer Indicator                                                       BUG10345
     D WPLCS           S              1A                                                    BUG10345
                                                                                            BUG10345
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      * INITIALISE DEFAULT PORTFOLIO INDICATOR
     C                   MOVE      'N'           WW9997
     C                   MOVE      'N'           WWEXC             1            CPB001
     C                   MOVE      'N'           WPLCS                                      BUG10345
      * ONLY VALIDATE IF PORTFOLIO MANAGEMENT IS SWITCHED ON
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
 
      * VALIDATE THE CUSTOMER AS A PORTFOLIO CUSTOMER IF A REFERENCE IS
      * ENTERED
     C                   MOVEL     CUSC          WWCNUM            6
 
      * USE A WORKING FIELD TO INDICATE IF CUSTOMER IS A CLIENT PORTFOLIO S71062
      * AND IF THE PORTFOLIO EXISTS IN PMPORTPD
     C                   MOVE      'N'           WWPORT
 
     C                   MOVEL     WWCNUM        WWCLIN           10
     C                   CALLB     'AOPLCSR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      WWCLIN        WWKY10           10
     C     SDPLCS        PARM      SDPLCS        @DSFDY
     C     @RTCD         IFEQ      *BLANKS                                      CPB001
     C                   MOVE      'Y'           WWEXC                          CPB001
     C                   MOVE      'Y'           WPLCS                                      BUG10345
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
      * ONLY VALIDATE IF PRIVATE BANKING IS SWITCHED ON                         CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C                   MOVE      'Y'           WWEXC                          CPB001
     C                   ENDIF                                                  CPB001
      *                                                                         CPB001
      * IF NOT ON FILE  AND AN ENTRY HAS BEEN MADE
     C*****@RTCD******** IFNE      *BLANKS                                      CPB001
     C     WWEXC         IFEQ      'N'                                          CPB001
     C     SPTFR         ANDNE     *BLANKS
      * OR IF NOT A PORTFOLIO CUSTOMER
      * OR NOT A PRIVATE BANKING CUSTOMER                                       CPB001
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SPTFR'
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0720'                  CPB001
     C                   ELSE                                                   CPB001
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0336'
     C                   ENDIF                                                  CPB001
 
     C                   ELSE
      * IF NOT A PORTFOLIO CUSTOMER, BUT PORTFOLIO REFERENCE
      * IS BLANK, LEAVE ROUTINE
     C*****@RTCD******** IFNE      *BLANKS                                      CPB001
     C     WWEXC         IFEQ      'N'                                          CPB001
     C                   GOTO      VPFRED
     C                   END
      * VALIDATE PORTFOLIO REFERENCE - IF BLANK, DEFAULT TO REFERENCE
      * ON PM ICD
     C     SPTFR         IFEQ      *BLANKS
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVE      FCR997        SPTFR
      * SET ON INDICATOR TO SHOW THAT '9997' SHOULD GO TO FILE
     C                   MOVE      'Y'           WW9997            1
     C                   ELSE                                                   CPB001
                                                                                CPB001
     C                   MOVEL     CUSC          KPCNUM                         CPB001
     C                   MOVE      'N'           WWFOUND           1            CPB001
     C     KPCNUM        SETLL     PMPORTPD                                     CPB001
     C     KPCNUM        READE     PMPORTPD                               71    CPB001
                                                                                CPB001
     C     *IN71         DOWEQ     *OFF                                         CPB001
     C     WWFOUND       ANDEQ     'N'                                          CPB001
     C     PNRECI        IFEQ      'D'                                          CPB001
     C                   MOVE      'Y'           WWFOUND                        CPB001
     C                   MOVE      PNPTFR        SPTFR                          CPB001
     C                   ENDIF                                                  CPB001
     C     KPCNUM        READE     PMPORTPD                               71    CPB001
     C                   ENDDO                                                  CPB001
     C                   ENDIF                                                  CPB001
     C                   ELSE
      * REFERENCE ENTERED
     C                   MOVEL     SPTFR         WWPTFR
     C                   MOVEL     CUSC          KPCNUM
     C     PORTKY        CHAIN     PMPORTPD                           71
     C  N71PNRECI        COMP      'D'                                7171
      * REFERENCE NOT ON FILE OR NOT A LIVE RECORD, ACCESS PM ICD
      * TO SEE IF IT REFERS TO THE '9997' REFERENCE
     C     *IN71         IFEQ      '1'
      * VALIDATE '9997' PORTFOLIO REFERENCE
     C     SPTFR         IFNE      FCR997
     C     BGN4ST        OREQ      'Y'                                          CPB001
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SPTFR'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0337'
 
     C                   ELSE
      * SET ON INDICATOR TO SHOW THAT '9997' SHOULD GO TO FILE
     C                   MOVE      'Y'           WW9997
     C                   END
      * PORTFOLIO IS FOUND, BUT IS FLAGGED FOR CLOSURE
     C                   ELSE
     C     PNDPCL        IFGT      0
 
     C                   EVAL      WarnFound = 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'SPTFR'
     C                   EVAL      MsgIDWArr(WIdx) = 'MMA0335'
 
     C                   END
     C                   MOVE      'Y'           WWPORT
     C                   END
     C                   END
     C                   END
     C*****************  END                                                    CPB001
 
     C     VPFRED        TAG
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
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
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaWArr
     C                   PARM                    WPLCS                                      BUG10345
 
      ** Parameters received from caller
      ** -------------------------------
      ** Portfolio reference (4A)
     C                   PARM                    SPTFR
      ** Portfolio management module flag (1A, from SDMMODPD)
     C                   PARM                    BGPFMG
      ** Private Banking module flag (1A, from SDMMODPD)                        CPB001
     C                   PARM                    BGN4ST                         CPB001
      ** Private Banking customer flag (1A, from SDCUSTPD)                      CPB001
     C                   PARM                    BBPRBA                         CPB001
      ** Customer code (6,0S)
     C                   PARM                    CUSC
      ** Portfolio management ICD (DS, from SDPORTPD)
     C                   PARM                    SDPORT
 
      **   Key list for  PMPORTPD
     C     PORTKY        KLIST
     C**********         KFLD                    KPCNUM            6 0                        CSD027
     C                   KFLD                    KPCNUM            6                          CSD027
     C                   KFLD                    WWPTFR            4
 
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
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
