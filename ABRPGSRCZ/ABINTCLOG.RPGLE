     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Support Log Setup Module')           *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABINTCLOG - Internal Contract Support Log Setup Module       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 261962             Date 23Sep09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 13JAN06               *
      *                 CDL038             Date 10May05               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  261962 - Amended so that system can get the associated front *
      *           office ID from Java for INTC.                       *
      *  CSD027 - Recompiled due to PF changes.                       *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
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
 
      ** Deal in File Format
     D INTCFilFmt    E DS                  EXTNAME(ABDEALPP)
 
      ** Deal in Screen Format
     D INTCScnFmt    E DS                  EXTNAME(ABINTCPD)
 
      ** Internal Contract Extension data - File (D/B) format
     D INTCExtDta    E DS                  EXTNAME(ABICEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D TRANSDTL        S           5800A
     D SecLegExcRat    S             13A
     D SecLegBuyCur    S              3A
     D SecLegBuyAmt    S             16A
     D SecLegSelCur    S              3A
     D SecLegSelAmt    S             16A
     D LoanIntAmt      S             17A
     D DepoIntAmt      S             17A
     D DealStatus      S             24A
     D PAction         S              1A
     D DDFOID          S             20A                                                      261962
     D DDAFID          S             20A                                                      261962
 
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
     C
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: ABINTCCVT - Convert File to Screen Format              *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      TRANSDTL = *Blanks
     C                   EVAL      INTCScnFmt = *Blanks
     C                   EVAL      DDACTN = PAction
 
     C                   CALLB     'ABINTCCVT'
 
     C                   PARM                    RetCodeOut
     C                   PARM                    INTCFilFmt
     C                   PARM                    INTCScnFmt
     C                   PARM                    SecLegExcRat
     C                   PARM                    SecLegBuyCur
     C                   PARM                    SecLegBuyAmt
     C                   PARM                    SecLegSelCur
     C                   PARM                    SecLegSelAmt
     C                   PARM                    LoanIntAmt
     C                   PARM                    DepoIntAmt
     C                   PARM                    DealStatus
      *                                                                                       261962
      ** Front Office Transaction ID                                                          261962
      ** Associated Front Office Transaction ID                                               261962
      *                                                                                       261962
     C                   PARM                    DDFOID                                       261962
     C                   PARM                    DDAFID                                       261962
      *                                                                                       261962
 
     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
     C                   EVAL      DDL1DN = *Blanks
     C                   EVAL      DDL2DN = *Blanks
     C                   EVAL      TRANSDTL = INTCScnFmt
     C                                        + INTCExtDta
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
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PAction
     C                   PARM                    INTCFilFmt
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
