     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid security diary events repair')        *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDERPR - Invalid Security Diary Events Repair             *
      *                                                               *
      *  Function: This module allows invalid security diary event    *
      *            details to be 'repaired' and applied to the Midas  *
      *            database.                                          *
      *                                                               *
      *  Component of: SESEDERPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 06Dec04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE072             Date 05Apr05               *
      *                 BUG2064            Date 29May04               *
      *                 BUG2604            Date 18May04               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 09Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
      *  BUG2064 - Initialization of CSC022.                          *
      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Use for LOOKUP command                          *
      *    99         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRScrnB - Browse invalid security diary events details       *
      *  SRRdnBrw - Read Next Browse Subfile Record                   *
      *  SRScrnD - Process Detail Screen                              *
      *  SRDefScnD - Default fields in detail screen                  *
      *  SRValD - Validate input to detail screen.                    *
      *  SRScrnW - Process Window Screen                              *
      *  SRScrnF - Process Confirmation Screen                        *
      *  SRUpdate - Update Files                                      *
      *  SRRtvSEDE - Retrieve security diary events details.          *
      *  SRCvtSEDE - Converts security diary events details from      *
      *              file to screen format.                           *
      *  SRDtaSubs - Data Substitution                                *
      *  SRSndMD - Send error message to detail screen                *
      *  SREndP - Set Program to End                                  *
      *  SRResetErr - Reset Error Fields                              *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL1IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas module flag - details
     FMMODF     IF   E             DISK    INFSR(*PSSR)
      *
      ** Invalid Security Diary Events by Timestamp and Fromt Office Id
      ** - for record retrieval
     FSEISEDEL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEISEDED0:SEISEDEX0)
      *
      ** Invalid Security Diary Events by Timestamp and Fromt Office Id
      ** - for record update
     FSEISEDEL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
                                                                                              CSC011
      ** API invalid log file                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEDER001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
                                                                                             BUG2604
     D WCmtJobArr      S             10A   DIM(10)                                           BUG2604
      ** Array for commitment job names                                                      BUG2604
      *
     D WEI             S              1    DIM(60)
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Backup arrays for error messages on 1st screen
     D FldNameAr1      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr1        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr1       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     D NwDe1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary events for file update - file format
     D NwDeFilFmt    E DS                  EXTNAME(SEVSEDEPD)
     D NwDeFilFmt1             1    231                                                       CSE065
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     D CrDe1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(O)
      *
      ** SE Diary events retrieved from file - file format
     D CrDeFilFmt    E DS                  EXTNAME(SEDEVD)
     D CrDeFilFmt1             1    231                                                       CSE065
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** SE Diary events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** SE Diary Events extra data
     D PExtData      E DS                  EXTNAME(SESDEXPD)
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Backup data structures for screen details
     D NwDe1ScnFmx   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(B)
      *
      ** Backup data structures for screen error indicators
     D SEESEDEx      E DS                  EXTNAME(SEESEDEPD)
     D                                     PREFIX(B)
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
      *
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                  BUG2604
     D  ComitJob               4    103                                                      BUG2604
      ** Midas SC Jobs handling commitment control data area                                 BUG2604
      *                                                                                      BUG2604
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Backup index for error messages on 1st screen
     D ID1             S              3P 0
      *
      ** Work index
     D Ex              S              3P 0
     D Fx              S              3P 0
     D WIx             S              3P 0
      *
      ** Mode of Operation
     D PMode           S              6A   INZ('*RPR  ')
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PResponse       S              1A   INZ('S')
      *
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested field)
     D PFormat         S             10A   INZ('SESEDEPD')
     D PField1         S             10A   INZ('DDACTN')
     D PFieldNo        S              5P 0
     D WFldOffset1     S              5P 0
      *
      ** Parameter fields
     D PFOTrID         S             20A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PRDNB           S              1A
     D PEdtFld         S              1A
     D PErrUp          S              1A
     D PErrMs          S              7A
     D POpSel          S              1A
     D PAcSel          S              1A
     D PSdsnSel        S             10A
     D PSdedSel        S              6A
     D PSdetSel        S              2A
     D PPayCcy         S              3A
     D PEvtDno         S              5P 0
     D PFOTranSel      S             20A
     D PTmeStpSel      S             26Z
     D PAmendOk        S              1A
     D PResetFld       S              1A
     D PReDsp          S              1A
     D PPROT           S              1A
      *
      ** Parameters for WN0010
     D PWPGM           S             10A   INZ('SESEDERPR')
     D PWKEY           S              2A
     D PWACTION        S              1A
     D PWRTN           S              7A
     D PWSPARE         S            256A
      *
      ** Incoming and Current data
     D PIncData        S           2000A
     D PCurData        S           2000A
      *
      ** Parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
      *
      ** Work variables
     D WProcOnce       S              1A
     D WScrn           S              1A
     D WDDSDSN         S             10A
     D WDDSDED         S              6A
     D WDDSDET         S              2A
     D WSUBSE1         S              1A
     D WRedisplay      S              1A
      *
      ** Output screen fields
     D DDCUCR          S             12A
     D DDSEXR          S             14A
      *
     D KABFIELDID      S                   LIKE(ABFIELDID)
      *
      ** Function keys
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** SAR fields
     D CSE010          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A                                                      CAS006
     D CSE031          S              1A                                                      CSE031
     D CSC011          S              1A                                                      CSC011
     D CSC022          S              1A                                                     BUG2064
     D CSE072          S              1A                                                      CSE072
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
                                                                                              CSC011
      ** Work field for Message type                                                          CSC011
     D WMTYP           S                   LIKE(APMTYP)                                       CSC011
                                                                                              CSC011
      ** Work field for Date to be passed to RTV module                                       CSC011
     D PDate           S                   LIKE(BJRDNB)                                       CSC011
      *
     DBUG2604          S              1A                                                     BUG2604
                                                                                             BUG2604
     D WCommitSkip     S              1A                                                     BUG2604
      ** Commitment Skip Field                                                               BUG2604
                                                                                             BUG2604
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY QWINDSRC,SESEDEDTA
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESEDER002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      /COPY WNCPYSRC,SESEDER003
      *
      ** Browse Invalid security diary events details.
      *
     C                   IF        WScrn = 'B'
     C                   EXSR      SRScrnB
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDER004
      *
      ** Read Next Browse Subfile record.
      *
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDER005
      *
      ** DO WHILE: Process 1st screen.
      *
     C                   DOW       WScrn = 'D'
     C                   EXSR      SRScrnD
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESEDER006
      *
      ** Process Window screen.
      *
     C                   IF        WScrn = 'W'
     C                   EXSR      SRScrnW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDER007
      *
      ** Process Confirmation screen.
      *
     C                   IF        WScrn = 'F'
     C                   EXSR      SRScrnF
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDER008
      *
      ** Update files.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDER009
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESEDER010
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnB - Browse invalid security diary events details       *
      *                                                               *
      *****************************************************************
     C     SRScrnB       BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
     C                   MOVE      *BLANK        PRDNB
      *
      ** Browse invalid security diary events details.
     C                   CALLB     'SESEDERPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      'Y'           PBdSfl
      *
      ** Read Subfile Record
     C                   PARM      *BLANK        PRdSfl
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PErrMs
      *
      ** Option Selected
     C                   PARM                    POpSel
      *
      ** Action Selected
     C                   PARM                    PAcSel
      *
      ** Security Shortname Selected
     C                   PARM                    PSdsnSel
      *
      ** Event Date Selected
     C                   PARM                    PSdedSel
      *
      ** Event Type Selected
     C                   PARM                    PSdetSel
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTranSel
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
      *
      ** Function Key Enabled - F3
     C                   PARM      '0'           PINKC
                                                                                              CSC011
      ** Enhancement CSC011                                                                   CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Reset Update Status of Previous Transaction flag.
      *
     C                   EVAL      PERRUP = *BLANK
      *
      ** If error occurred, set on external job switch U6.
      *
     C                   IF        PErrMs <> *BLANKS
     C                   MOVE      *ON           *INU6
     C                   ENDIF
      *
      ** Terminate program if F3 was taken in Browse screen or
      ** if error occurred.  Otherwise, read selected Browse
      ** Subfile record.
     C                   IF        PINKC = *ON OR
     C                             PErrMs <> *BLANKS
     C                   EXSR      SREndP
     C                   ELSE
     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdnBrw - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR
      *
      ** Read Next Browse Subfile record.
     C                   CALLB     'SESEDERPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      *BLANK        PBdSfl
      *
      ** Read Subfile Record
     C                   PARM      'Y'           PRdSfl
      *
      ** Error in update of previous transaction
     C                   PARM                    PErrUp
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PErrMs
      *
      ** Option Selected
     C                   PARM                    POpSel
      *
      ** Action Selected
     C                   PARM                    PAcSel
      *
      ** Security Shortname Selected
     C                   PARM                    PSdsnSel
      *
      ** Event Date Selected
     C                   PARM                    PSdedSel
      *
      ** Event Type Selected
     C                   PARM                    PSdetSel
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTranSel
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTmeStpSel
      *
      ** Function Key Enabled - F3
     C                   PARM      '0'           PINKC
                                                                                              CSC011
      ** Enhancement CSC011                                                                   CSC011
     C                   PARM                    CSC011                                       CSC011
      *
      ** Terminate program if F3 was taken within Invalid
      ** Transaction Deletion function.
     C                   IF        PINKC = *ON
     C                   EXSR      SREndP
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Display Browse screen if no invalid diary event read from subfile.
     C                   IF        POpSel = *BLANK
     C                   EVAL      WScrn = 'B'
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Clear security diary events details in screen format
      ** from incoming transaction.
      *
     C                   CLEAR                   NwDe1ScnFmt
      *
      ** Clear security diary events details in screen format
      ** retrieved from file.
      *
     C                   CLEAR                   CrDe1ScnFmt
      *
      ** Validate action code, security shortname, event date and
      ** event type and retrieve security diary events details.
      *
     C                   EVAL      DDACTN = PAcSel
     C                   EVAL      DDSDSN = PSdsnSel
     C                   EVAL      DDSDED = PSdedSel
     C                   EVAL      DDSDET = PSdetSel
     C                   EVAL      PFOTrID = PFOTranSel
      *
      ** If Insert, set Retrieve Mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, if not Insert and Midas security shortname, diary
      ** event date and diary event type is present, set Retrieve Mode to
      ** blank(Access using security shortname, event date and event type).
     C                   IF        DDACTN = 'I'
 
     C                   EVAL      PMode = '*FRONT'
 
     C                   ELSE
 
     C                   IF        DDSDSN = *BLANK AND
     C                             DDSDED = *BLANK AND
     C                             DDSDET = *BLANK
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EXSR      SRRtvSEDE
      *
      ** For the rest of the processing, set Mode of Operation
      ** to '*RPR  ' for the other modules to process the
      ** transaction as coming from the repair function.
     C                   EVAL      PMode = '*RPR  '
      *
      ** Move security diary events details retrieved from the master
      ** database file into the update file record.  If no record has
      ** been retrieved (like in Insert), fields contain intial values.
     C**********         EVAL      NwDeFilFmt = CrDeFilFmt                                    CSE065
     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     SDAL          S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** If original security diary events details were retrieved,
      ** convert security diary events details from file to screen
      ** format.
     C                   IF        DDACTN <> 'I' AND
     C                             RECI <> *BLANK
 
     C                   EXSR      SRCvtSEDE
      *
      ** Save security shortname, event date and event type retrieved from file
     C                   EVAL      WDDSDSN = DDSDSN
     C                   EVAL      WDDSDED = DDSDED
     C                   EVAL      WDDSDET = DDSDET
      *
     C                   ENDIF
      *
      ** Access invalid security diary events details file with Timestamp and
      ** Front Office Transaction Id.
     C     ZATRNKX0      CHAIN     SEISEDEL0                          99
      *
      ** If original security diary events details were retrieved,
      ** restore the security shortname, event date and event
      ** type retrieved from file.
      *
     C                   IF        DDACTN <> 'I' AND
     C                             RECI <> *BLANK
     C                   EVAL      DDSDSN = WDDSDSN
     C                   EVAL      DDSDED = WDDSDED
     C                   EVAL      DDSDET = WDDSDET
     C                   ENDIF
      *
      ** If Action is Enquire or Delete, overwrite details from
      ** invalid security diary events details file with the details
      ** retrieved from the master database file.
     C                   IF        DDACTN = 'E' AND RECI <> *BLANK OR
     C                             DDACTN = 'D' AND RECI <> *BLANK
     C                   MOVE      CrDe1ScnFmt   NwDe1ScnFmt
     C                   ENDIF
      *
      ** Action is amend and original security diary events details
      ** were retrieved.
      *
     C                   IF        DDACTN = 'A' AND RECI <> *BLANK
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
     C                   IF        GHSUBS <> *BLANK
 
     C     GHSUBS        SCAN      NwDE1ScnFmt                            99
     C                   IF        *IN99 = *ON
     C                   MOVE      'Y'           WSUBSE1
     C                   ELSE
     C                   MOVE      'N'           WSUBSE1
     C                   ENDIF
      *
      ** Substitution character is present in the incoming transaction.
     C                   IF        WSUBSE1 = 'Y'
      *
      ** Do data substitution.
     C                   EXSR      SRDtaSubs
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If errors exist for action code , security shortname, event date
      ** or event type, blank out Action Code so input cannot proceed.
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N'
     C                             OR OKSDED = 'N' OR OKSDET = 'N'
     C                   EVAL      DDACTN = *BLANK
     C                   ENDIF
      *
      ** Save screen details.
     C                   EVAL      NwDE1ScnFmx = NwDE1ScnFmt
      *
      ** Send the security diary events details validation error messages
      ** to detail screen.
     C                   EXSR      SRSndMD
      *
      ** Initialise work variable for defaulting.
      *
     C                   EVAL      WProcOnce = *BLANK
      *
      ** Display detail screen.
     C                   EVAL      WScrn = 'D'
 
     C     ERdNBrw       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnD - Process Detail Screen                              *
      *                                                               *
      *****************************************************************
     C     SRScrnD       BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on screen (all fields on detail screen
      ** except Initial screen fields: Action Code, Security Shortname,
      ** Event Date and Event Type).  Also, enable F5=Refresh.
     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
     C                             DDACTN = 'A' AND POpSel = 'U'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** If Action is Delete and Option selected is 'U',
      ** enable F10=Delete.
     C                   IF        DDACTN = 'D' AND POpSel = 'U'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
      *
      ** Process defaulting of detail screen details before going to detail screen.
      *
     C                   EXSR      SRDefScnD
      *
      ** Display detail screen.
     C                   CALLB     'SESEDE1DP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM                    PEINKJ
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** Security Diary Event 1st screen error indicators
     C                   PARM                    SEESEDE
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *
      ** Save Warning Message Ids array of detail screen.
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh detail screen.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwDE1ScnFmt  = NwDE1ScnFmx
     C                   EVAL      SEESEDE = SEESEDEx
     C                   EVAL      FldNameArr = FldNameAr1
     C                   EVAL      MsgIdArr = MsgIdAr1
     C                   EVAL      MsgDtaArr = MsgDtaAr1
     C                   EVAL      IDx = ID1
      *
      ** F10 - delete record.  Proceed to update of files.
     C                   WHEN      PINKJ = *ON
     C                   EVAL      WScrn = 'U'
      *
      ** F12 - cancel.  Read Next Subfile record or display
      ** Browse screen.
     C                   WHEN      PINKL = *ON
 
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
      *
      ** If Windows processing is on, clear any possible updates
      ** in Window function.
     C                   IF        BGWDPR = 'Y'
     C                   If        (CSC022 <> 'Y')                                           BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        (WCommitSkip <> 'Y')                                      BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
     C                   ENDIF
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to 1st screen.
     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
     C                             DDACTN = 'A' AND POpSel = 'U'
     C                   EXSR      SRValD
     C                   GOTO      EScrnD
     C                   ENDIF
      *
      ** If Windows processing is on and errors do not exist
      ** on detail screen, perform window processing.
      *
     C                   IF        BGWDPR = 'Y' AND
     C                             ID1 = 0
     C                   EVAL      WScrn = 'W'
     C                   GOTO      EScrnD
     C                   ENDIF
      *
      ** If errors exist on detail screen, read next subfile
      ** record or display browse screen instead.
      *
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSL
 
     C     EScrnD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScnD - Default fields in detail screen                  *
      *                                                               *
      *****************************************************************
     C     SRDefScnD     BEGSR
 
     C     WProcOnce     IFEQ      *BLANK
 
     C                   CALLB     'SESEDE1DT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF  - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Dividend payments
     C                   PARM                    S01510
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
      *                                                                                       CGL031
      ** Taxation of Savings Income                                                           CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
 
     C                   ENDIF
      *
      ** Set default variable to 'Y' to bypass defaulting the
      ** second time around.
      *
     C                   EVAL      WProcOnce = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValD - Validate input to detail screen.                    *
      *                                                               *
      *****************************************************************
     C     SRValD        BEGSR
      *
      ** Validate whether non-amendable fields have been amended.
      *
     C                   CALLB     'SESEDE1MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Reset of Fields in error required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** STANDING DATA
      ** =============
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** Validate entries made on the screen.
      *
     C                   CALLB     'SESEDE1VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transactions Enhancement
     C                   PARM                    CSE010
      *
      ** Value CCY to be CCY of Issuer Payment
     C                   PARM                    S01509
      *
      ** Dividend Payments Base on EX-Date
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE072
      ** Brazilian C Bonds                                                                    CSE072
     C                   PARM                    CSE072                                       CSE072
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
 
     C                   EVAL      WRedisplay = *BLANK
      *
      ** If no errors occurred during validation of fields on detail
      ** screen, check if there are warnings which have not been
      ** displayed yet.
     C                   IF        IDx = 0
      *
     C                   Z-ADD     1             WIx
      *
     C                   DOW       WiX <= WIDx AND WRedisplay = *BLANK
 
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WRedisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Redisplay detail screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> 0 OR WRedisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      EValD
     C                   ENDIF
      *
      ** If Windows processing is on, display Window screen.
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   EVAL      WScrn = 'F'
     C                   ENDIF
 
     C     EValD         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnW - Process Window Screen                              *
      *                                                               *
      *****************************************************************
     C     SRScrnW       BEGSR
      *
      ** Write out screen to remove error messages.
      *
     C                   CALLB     'SESEDE1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Enable Detail Fields Indicator
      ** Enable Key Fields Indicator
     C                   PARM                    PEDtFld
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KJ = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'Y'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *
      /COPY WNCPYSRC,SESEDEMV1
      *
      ** Call Window Manager.
     C                   CALL      'WN0010'
     C                   PARM      'SESEDERPR'   PWPGM
     C                   PARM      *BLANKS       PWKEY
     C                   PARM      DDACTN        PWACTION
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PWRTN
     C                   PARM                    PWSPARE
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PWRTN = 'Y2U9999'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display detail screen.
     C                   WHEN      PWRTN = 'USR0790'
     C                   EVAL      WScrn = 'D'
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Action is Amend or Insert - proceed to confirmation screen.
     C                   IF        DDACTN = 'I' AND POpSel = 'U' OR
     C                             DDACTN = 'A' AND POpSel = 'U'
     C                   EVAL      WScrn = 'F'
     C                   ELSE
      *
      ** Read next browse subfile record if pending option still exist.
      ** Otherwise, display browse screen
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnF - Process Confirmation Screen                        *
      *                                                               *
      *****************************************************************
     C     SRScrnF       BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
     C                   EXSR      SRResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
      *
     C                   EVAL      WFldNamArr(1) = '*ANY'
     C                   EVAL      WMsgIdArr(1) = 'SEA0302'
      *
      ** Display Confirmation screen.
     C                   CALLB     'SESEDE1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Enable Detail Fields Indicator
     C                   PARM      'N'           PEDtFld
      *
      ** Enable Function Keys
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System run date
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
      *
      ** Save warning message ids array of this screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display 1st screen.
     C                   WHEN      PINKL = *ON
     C                   EVAL      WScrn  = 'D'
      *
      ** Enter key was pressed.  Update files.
     C                   OTHER
     C                   EVAL      WScrn = 'U'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update Files                                      *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
      ** Action is delete - Update record id to 'C'.
      *
     C                   IF        DDACTN = 'D'
     C                   EVAL      S2RECI = 'C'
     C                   ENDIF
      *
      ** Action is insert.
     C                   IF        DDACTN = 'I'
     C                   EVAL      S2RECI = 'D'
     C                   EVAL      S2SDSN = DDSDSN
     C                   EVAL      S2SDED = PEvtDno
     C                   EVAL      S2SDET = DDSDET
     C                   EVAL      S2NMCY = D1NMCY
     C                   ENDIF
      *
      ** Setup last change type according to action done.
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR
     C                             DDACTN = 'D'
     C                   EVAL      S2CHTP = DDACTN
     C                   ENDIF
      *
      ** Front Office Id.
     C                   EVAL      S2FRNT = PFOTranSel
      *
      ** Update files.
     C                   CALLB     'SESEDEUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Midas Run Day Number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
      *
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        RetCodeOut = '*RECUPD'
     C                   If        (CSC022 <> 'Y')                                           BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        (WCommitSkip <> 'Y')                                      BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
     C                   ENDIF
     C     ZATRNKD0      CHAIN     SEISEDEL1                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SEISEDEL1
     C                   ENDIF
                                                                                              CSC011
      ** Also delete corresponding record in API standard log file                            CSC011
      ** if CSC011 is present and user is still in support system.                            CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      WMTYP = 'SESEDE'                                           CSC011
     C     KAPILOG       CHAIN     APILOGL0                           71                      CSC011
                                                                                              CSC011
      ** If record found                                                                      CSC011
     C     *IN71         IFEQ      '0'                                                        CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   If        (CSC022 <> 'Y')                                           BUG2604
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                  BUG2604
     C                   COMMIT
     C                   EndIf                                                               BUG2604
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
     C                   IF        RetCodeOut = '*RECUPD'
     C                   EVAL      PERRUP = 'Y'
     C                   ELSE
     C                   EVAL      PERRUP = 'N'
     C                   ENDIF
      *
      ** Read Next Subfile record or display Browse screen.
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvSEDE - Retrieve security diary events details.          *
      *                                                               *
      *****************************************************************
     C     SRRtvSEDE     BEGSR
 
                                                                                              CSC011
      ** Use Proc date in SC24X7 for RTV module if CSC011 is present                          CSC011
      ** and current system is support system.                                                CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      PDate = S1DATE                                             CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      PDate = BJRDNB                                             CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   CALLB     'SESEDERTV'
      *                             =========
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front office transaction interface)
      ** Mode = '      ' (Not front office transaction interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PResponse
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction Id
     C                   PARM                    PFOTrID
      *
      ** Security shortname
     C                   PARM                    DDSDSN
      *
      ** Event Date
     C                   PARM                    DDSDED
      *
      ** Event Type
     C                   PARM                    DDSDET
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ***SDBANK*- Run day number                                                              CSC011
     C**********         PARM                    BJRDNB                                       CSC011
      ** Processing Date                                                                      CSC011
     C                   PARM                    PDate                                        CSC011
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CSE065
      ** Cost Yield Amortisation on Mortgage Backed Assets                                    CSE065
     C                   PARM                    CSE065                                       CSE065
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      0             IdX
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** OK action code
     C                   PARM      'Y'           OKACTN
      *
      ** OK Security shortname
     C                   PARM      'Y'           OKSDSN
      *
      ** OK Event date
     C                   PARM      'Y'           OKSDED
      *
      ** OK Event type
     C                   PARM      'Y'           OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM      *BLANKS       PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM      *BLANKS       PPROT
      *
      ** Event date (Day number)
     C                   PARM      *ZEROS        PEvtDno
      *                                                                                       222373
      ** Redisplay screen                                                                     222373
     C                   PARM                    PReDsp                                       222373
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtSEDE - Converts security diary events details from      *
      *              file to screen format.                           *
      *                                                               *
      *****************************************************************
     C     SRCvtSEDE     BEGSR
 
     C                   CALLB     'SESEDECVT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution                                *
      *                                                               *
      *****************************************************************
     C     SRDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
     C                   IF        WSUBSE1 = 'Y'
 
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
 
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwDE1ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrDE1ScnFmt   PCurData
 
     C                   MOVEL     PIncData      NwDE1ScnFmt
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMD - Send error message to detail screen                *
      *                                                               *
      *****************************************************************
     C     SRSndMD       BEGSR
      *
      ** Reset array index.
     C                   EVAL      Ex = 0
      *
      ** If error occurred in updating last transaction,
      ** display error message on the screen (first message).
      *
     C                   IF        PERRUP = 'Y'
     C                   ADD       1             Ex
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     'APM1000'     MsgIdArr(Ex)
     C                   MOVE      'N'           PERRUP
     C                   ENDIF
      *
      ** If there are fundamental errors in this transaction, identify
      ** this fact.
     C                   IF        OKACTN = 'N' OR OKSDSN = 'N'
     C                             OR OKSDED = 'N' OR OKSDET = 'N'
     C                   EVAL      Ex = Ex + 1
     C                   MOVE      '*ANY'        FldNameArr(Ex)
     C                   MOVE      'APM0110'     MsgIdArr(Ex)
     C                   ENDIF
      *
      ** Initialise work array for error indicators.
     C                   MOVEA     SEESEDE       WEI
      *
      ** Read security diary event details validation error messages for
      ** 1st screen.
     C                   EVAL      KABFIELDID = 0
 
     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for 1st screen to array and set
      ** OK flag for field to 'N'.
     C                   DOW       *IN99 = *OFF AND
     C                             ABFIELDID > WFldOffSet1
 
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
     C                   IF        *IN98 <> *ON
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF
 
     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset1   Fx
 
     C                   IF        Fx < 1 OR Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF
 
     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
 
     C                   ENDDO
      *
      ** Update error indicators using work array.
     C                   MOVEA     WEI           SEESEDE
      *
      ** Save error indicators and messages on 1st screen.
     C                   MOVE      SEESEDE       SEESEDEx
     C                   MOVEA     FldNameArr    FldNameAr1
     C                   MOVEA     MsgIdArr      MsgIdAr1
     C                   MOVEA     MsgDtaArr     MsgDtaAr1
     C                   EVAL      ID1 = Ex
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - Set Program to End                                  *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
      *
      ** Rollback uncommitted file changes.
      *
     C                   If        (CSC022 <> 'Y')                                           BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        (WCommitSkip <> 'Y')                                      BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset Error Fields                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR
      *
      ** Reset error fields.
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx
      *
      ** Initialise screen fields error indicators.
      *
     C                   EVAL      SEESEDE = *ALL'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access securities trading ICD details.
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDSTRDPD'
     C                   EVAL      DBase = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   EVAL      DBase = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access API ICD details.
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBKey = POPTN
     C                   EVAL      DBFile = 'SDAPIPD'
     C                   EVAL      DBase = 004
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if "SE Transaction enhancement"
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE010'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSE010'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE010
     C                   ELSE
     C                   MOVEL     'N'           CSE010
     C                   ENDIF
      *
      ** Access SAR file to determine if "Value currency to be
      ** currency of the issuer payment" is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01509'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01509'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01509
     C                   ELSE
     C                   MOVEL     'N'           S01509
     C                   ENDIF
      *
      ** Access SAR file to determine if "Dividend Payments"
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01510'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01510'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 007
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01510
     C                   ELSE
     C                   MOVEL     'N'           S01510
     C                   ENDIF
                                                                                              CSC011
      ** Determine if CSC011 is installed                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 8                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   OPEN      APILOGL0                                                   CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSE031
      ** Access SAR file to determine if "Coupon Fixing for                                   CSE031
      ** Floating Rate Notes" is installed.                                                   CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM      *BLANKS       PRtcd                                        CSE031
     C                   PARM      '*VERIFY'     POptn                                        CSE031
     C                   PARM      'CSE031'      PSarD                                        CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** An NRF (No Record Found) return code is valid.                                       CSE031
      ** Issue database error only for error return codes.                                    CSE031
     C                   IF        PRtcd <> *BLANKS AND                                       CSE031
     C                             PRtcd <> '*NRF   '                                         CSE031
     C     *LOCK         IN        LDA                                                        CSE031
     C                   EVAL      DBKey = 'CSE031'                                           CSE031
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE031
     C                   EVAL      DBase = 9                                                  CSE031
     C                   OUT       LDA                                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        PRtcd = *BLANKS                                            CSE031
     C                   MOVEL     'Y'           CSE031                                       CSE031
     C                   ELSE                                                                 CSE031
     C                   MOVEL     'N'           CSE031                                       CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CAS006
      ** Access SAR file to determine if 'Hedge Accounting                                    CAS006
      ** Phase B(CAS006)' is installed.                                                       CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtcd                                        CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSarD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
      ** An NRF (No Record Found) return code is valid.                                       CAS006
      ** Issue database error only for error return codes.                                    CAS006
     C                   IF        PRtcd <> *BLANKS AND                                       CAS006
     C                             PRtcd <> '*NRF   '                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBKey = 'CAS006'                                           CAS006
     C                   EVAL      DBFile= 'SCSARDPD'                                         CAS006
     C                   EVAL      DBase = 010                                                CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRtcd = *BLANKS                                            CAS006
     C                   MOVEL     'Y'           CAS006                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'N'           CAS006                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSE065
      ** Access SAR file to determine if CSE065 is installed                                  CSE065
                                                                                              CSE065
     C                   CALL      'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRtcd                                        CSE065
     C                   PARM      '*VERIFY'     POptn                                        CSE065
     C                   PARM      'CSE065'      PSarD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
      ** An NRF (No Record Found) return code is valid.                                       CSE065
      ** Issue database error only for error return codes.                                    CSE065
                                                                                              CSE065
     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
     C                             PRtcd <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBKey = 'CSE065'                                           CSE065
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
     C                   EVAL      DBase = 012                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        PRtcd = *BLANKS                                            CSE065
     C                   MOVEL     'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVEL     'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE072
      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
      ** (CSE072)' is installed.                                                              CSE072
                                                                                              CSE072
     C                   CALLB     'AOSARDR0'                                                 CSE072
     C                   PARM      *BLANKS       PRtcd                                        CSE072
     C                   PARM      '*VERIFY'     POptn                                        CSE072
     C                   PARM      'CSE072'      PSarD                                        CSE072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
                                                                                              CSE072
      ** An NRF (No Record Found) return code is valid.                                       CSE072
      ** Issue database error only for error return codes.                                    CSE072
     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
     C                             PRtcd <> '*NRF   '                                         CSE027
     C     *LOCK         IN        LDA                                                        CSE072
     C                   EVAL      DBKey = 'CSE072'                                           CSE072
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE072
     C                   EVAL      DBase = 009                                                CSE072
     C                   OUT       LDA                                                        CSE072
     C                   EXSR      *PSSR                                                      CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CSE072
     C                   IF        PRtcd = *BLANKS                                            CSE072
     C                   MOVEL     'Y'           CSE072                                       CSE072
     C                   ELSE                                                                 CSE072
     C                   MOVEL     'N'           CSE072                                       CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CGL031
      ** Access SAR file to determine if 'Taxation on Savings                                 CGL031
      ** Income is installed.                                                                 CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSarD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
     C                             PRtcd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBFile= 'SCSARDPD'                                         CGL031
     C                   EVAL      DBase = 011                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access MMODF to determine if Strategic Risk Man. Ind is on
      *
     C                   READ      MMODF                                  01
      *
      ** Get the field number for the first field in 1st screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField1
     C                   PARM                    PFieldNo
 
     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset1 = PFieldNo - 1
      *
      ** If there was an error, default the offset to 13.
     C                   ELSE
     C                   EVAL      WFldOffset1 = 13
     C                   ENDIF
      *
      ** Define Key Lists.
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
 
     C     ZATRNKD1      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    KABFIELDID
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    PFOTranSel
                                                                                              CSC011
      ** Key List for access to API standard log file                                         CSC011
     C     KAPILOG       KLIST                                                                CSC011
     C                   KFLD                    WMTYP                                        CSC011
     C                   KFLD                    PFOTranSel                                   CSC011
     C                   KFLD                    PTmeStpSel                                   CSC011
                                                                                              CSC011
      *
      ** Initialise error fields.
     C                   EXSR      SRResetErr
      *
      ** Display Browse screen.
     C                   MOVE      'B'           WScrn
      *
      ** Access Switchable Features File, forBUG2604                                         BUG2604
      *                                                                                      BUG2604
     C                   Eval      CSC022 = 'N'                                              BUG2604
     C                   CallB     'AOSARDR0'                                                BUG2604
     C                   Parm      *BLANKS       PRTCD                                       BUG2604
     C                   Parm      '*VERIFY'     POPTN                                       BUG2604
     C                   Parm      'CSC022'      PSARD                                       BUG2604
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
      *                                                                                      BUG2604
     C                   If        PRTCD = *Blanks                                           BUG2604
     C                   Eval      CSC022 = 'Y'                                              BUG2604
     C                   Eval      WCommitSkip = 'N'                                         BUG2604
      *                                                                                      BUG2604
     C                   In        SCCMTJOB                                                  BUG2604
     C                   If        ComitNum > 0                                              BUG2604
     C                   MoveA     ComitJob      WCmtJobArr                                  BUG2604
      *                                                                                      BUG2604
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                 BUG2604
     C                   If        *IN87 = *ON                                               BUG2604
     C                   Eval      WCommitSkip = 'Y'                                         BUG2604
     C                   EndIf                                                               BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   Else                                                                BUG2604
      *                                                                                      BUG2604
      ** If return code <> *NRF, call program exception error routine                        BUG2604
      *                                                                                      BUG2604
     C                   If        PRTCD <> '*NRF'                                           BUG2604
     C     *LOCK         IN        LDA                                                       BUG2604
     C                   EVAL      DBKEY = 'CSC022'                                          BUG2604
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG2604
     C                   EVAL      DBASE = 11                                                BUG2604
     C                   OUT       LDA                                                       BUG2604
     C                   Exsr      *PSSR                                                     BUG2604
     C                   EndIf                                                               BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESEDER011
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
