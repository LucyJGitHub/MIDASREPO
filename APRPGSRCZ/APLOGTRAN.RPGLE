     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AP Log transactions from support database')
      *****************************************************************
      *                                                               *
      *  Midas - Application Programming Interfaces Module            *
      *                                                               *
      *  APLOGTRAN - AP Log Transactions from the Support Databse     *
      *                                                               *
      *  Function:  This module will write to the log file and will   *
      *             be called from the different API functions.       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         Error on write command                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMainProc -  Main Processing                                *
      *  SRReturn   -  Return to Calling Program                      *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      ** API Valid Log File
     FAPVLOGPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid Log File
     FAPILOGPD  UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
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
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  WriteFail             03     03
 
      ** External DS for API Header
     D APIHeadDS     E DS                  EXTNAME(APHEADPD)
     D   MsgType               1      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter variables
 
     D PTransDtl       S           5800A
     D PTimeStmp       S             26A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** Timestamp
     D TimeStamp       S                   LIKE(APSTMS)
 
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
 
      ** Main Processing
 
     C                   EXSR      SRMainProc
 
      ** Return
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMainProc - Main Processing                                  *
      *                                                               *
      * Called by:  Main  Processing                                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRMainProc    BEGSR
 
      ** Set up APHEADPD
 
     C                   IF        APUSERID = *BLANK
     C                   EVAL      APUSERID = PSUser
     C                   ENDIF
 
     C                   IF        APMIDUSR = *BLANK
     C                   EVAL      APMIDUSR = PSUser
     c                   ENDIF
 
     C                   IF        APRESPMODE = *BLANK
     C                   EVAL      APRESPMODE = 'A'
     c                   ENDIF
 
     C                   IF        APRPRLOCN  = *BLANK
     C                   EVAL      APRPRLOCN = 'B'
     c                   ENDIF
 
     C                   IF        APFOTRANID = *BLANK
     C                   EVAL      APFOTRANID = 'MD' + PDealNo
 
     C                   IF        APFOASOCID = *BLANK
     C                             AND PADealNo <> *BLANKS
     C                   EVAL      APFOASOCID = 'MD' + PADealNo
     C                   ENDIF
     C                   ENDIF
 
      ** Write to log files
 
     C                   EVAL      APTRAN     = *BLANKS
     C                   EVAL      ReturnCode = *BLANKS
     C                   EVAL      APMTYP = APTGTTYPE
 
     C                   IF        MsgType = 'MMRPLD' or MsgType = 'MMRPDM' or
     C                             MsgType = 'MMRPTR'
     C                   EVAL      APSOFC = APFOASOCID
     C                   ELSE
     C                   EVAL      APSOFC = APFOTRANID
     C                   ENDIF
 
     C                   IF        PTimeStmp = *BLANKS
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      APSTMS = TimeStamp
 
     C     APIHeadDS     CAT       PTransDtl     APTRAN
     C                   WRITE     APVLOGD0                             03
 
     C                   ELSE
 
     C                   MOVE      PTimeStmp     APSTMS
     C     APIHeadDS     CAT       PTransDtl     APTRAN
     C                   WRITE     APILOGD0                             03
 
     C                   ENDIF
 
     C                   IF        WriteFail = True
     C                   EVAL      ReturnCode = '*ERROR    '
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReturn - Return to calling program                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR
 
     C                   EVAL      RetCodeOut = ReturnCode
     C                   Return
 
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
 
      ** Program parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
      ** API Header
      ** Transaction details
      ** Timestamp
      ** Deal Number
 
     C                   PARM                    RetCodeOut
     C                   PARM                    APIHeadDS
     C                   PARM                    PTransDtl
     C                   PARM                    PTimeStmp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      ********************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
