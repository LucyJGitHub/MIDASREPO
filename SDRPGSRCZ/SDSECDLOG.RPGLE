     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities Clients Support Log Setup')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDLOG - Securities Clients Support Log Setup             *
      *                                                               *
      *  Function:  This module will write to the standard log file   *
      *             if the support system is active.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK024             Date 13Feb06               *
      *  Prev Amend No. BUG3122            Date 17Jul04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPK024 - Packaging of MPLUS 1.2.1. No need to rename QQACCD  *
      *           as it was already removed by 7453 from SEDECDPD.    *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** Customer record in file format
     D SECDFilFmt    E DS                  EXTNAME(SDSECSPD)
 
      ** Customer record in screen format
     D SECDScnFmt    E DS                  EXTNAME(SDSECDPD)
     D*QQACC1***     E                     EXTFLD(QQACCD)                              CGL029 CPK024
 
      ** SD Customer Security details Extra Data - File (D/B) format
     D SECDExtDta    E DS                  EXTNAME(SDSEEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
 
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
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRPROC
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *Blanks
 
     C                   CALLB     'SDSECDCVT'
     C                   PARM                    RetCodeOut
     C                   PARM                    SECDFilFmt
     C                   PARM                    SECDScnFmt
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
 
     C                   EVAL      DDACTN = BFTYLC
     C                   EVAL      DDCUSN = BFCUST
 
     C                   EVAL      TRANSDTL = SECDScnFmt + SECDExtDta
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    SECDFilFmt
     C                   PARM                    TRANSDTL
 
      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
