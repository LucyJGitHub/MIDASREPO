     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Init. program for Change Control 236137.')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCTTXINIT- Initialisation Program for Change Control 236137.*
      *                                                               *    S
      *  Function:  This module will initialize new fields that were  *
      *             added to SDCTTXPD Country of Tax Codes.           *
      *                                                               *
      *  Component of: SDCTTXINIT                                     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CGL157             Date 17Aug15               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137  *CREATE    Date 20Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control 1 for CGL031 & CGL032 - Part 4       *
      *           Changes to Premium and Discount Accrual Processing. *
      *           to initialize SDCTTXPD 6 new fields.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in file SDCTTXPD                          *
      *    02         End of File in SDCTTXPD                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRCTTX     - Process file SDCTTXPD                            *
      * SRAUDIT    - Write Audit Report                               *
      * *INZSR     - Initialise                                       *
      * *PSSR      - Error processing                                 *
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
 
      ** Midas SD Securities Clients
     FSDCTTXPD  UF   E             DISK    INFSR(*PSSR)
 
      ** Midas SD Initialisation Program printer file - Audit
     FSDCTTXIP1 O    E             PRINTER INFSR(*PSSR)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
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
     D  ErrorOnFile           01     01
     D  EndOfFile             02     02
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** Database error workfields
     D WRECORDS        S              7
 
      ** Whether or not *PSSR has been run previously
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Process all records in file SDCTTXPD
 
     C                   EXSR      SRCTTX
 
      ** Print Details
 
     C                   EXSR      SRAUDIT
 
      ** Return to calling program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCTTX - Process file SDSECSPD                               *
      *                                                               *
      *****************************************************************
 
     C     SRCTTX        BEGSR
 
      ** Read all records from SDCTTXPD
 
     C                   READ      SDCTTXPD                             0102
 
      ** Gandles database error.
 
     C                   IF        ErrorOnFile = True
 
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDCTTXPD'
     C                   EVAL      DBKEY  =  '*FIRST'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/SRCTTX'
     C                   OUT       LDA
     C                   EXSR      SRAUDIT
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   DOW       EndOfFile = False
 
     C                   ADD       1             RCOUNT
 
      ** Sets up default values for additional fields.
 
     C                   EVAL      EWDMAP = 'Y'
     C                   EVAL      EWTXCB = 'S'
     C                   EVAL      EWPADD = 'Y'
     C                   EVAL      EWTIST = 'N'
 
      ** Updates the record in file SDCTTXPD.
 
     C                   UPDATE    SDCTTXD0
 
     C                   READ      SDCTTXPD                             0102
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Write Audit Report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
     C                   OPEN      SDCTTXIP1
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
 
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** If there is a record read in SDCTTXPD, write audit control report.
 
     C                   IF        RCOUNT <> 0
 
     C                   WRITE     CONTROL
 
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
 
     C                   WRITE     NODTLS
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CLOSE     SDCTTXIP1
 
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
 
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
