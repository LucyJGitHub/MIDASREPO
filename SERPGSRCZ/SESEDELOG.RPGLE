     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Diary Events Support Log Setup Module')       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDELOG - Diary Events Support Log Setup Module            *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             SE Diary Events into screen format to be used     *
      *             in writing to the support system log file.        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. DUG502             Date 29Nov17               *
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
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary enhancements (Recompile)             *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Read MMODF                                      *
      *    02         Chain to SECTY                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *pssr - Error processing                                      *
      * *INZSR - Initialization                                       *
      *  SRPROC - Main Processing                                     *
      *  SRRETURN - Handles End of program processing                 *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      * Called by: SESEDEUPD - Midas Securty Diary Events Database    *
      *                        Update                                 *
      *                                                               *
      * Calls:     SESEDECVT - Midas Security Diary Convert file to   *
      *                        screen format                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Security Diary Events file
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(O)
 
      ** Midas module flag - details
     FMMODF     IF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      **--------------------------------------------------------------+
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
 
      ** SE Diary events details - file format
     D SEDEFilFmt    E DS                  EXTNAME(SEDEVD)
 
      ** SE Diary events details - screen format
     D SEDEScnFmt    E DS                  EXTNAME(SESEDEPD)
 
      ** Security Diary Events extra data
     D SEDEExtDta    E DS                  EXTNAME(SESDEXPD)
 
      ** Securities details
     D SECSFilFmt    E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(O)
 
      ** Investment Types
     D INVSTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(I)
 
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(S)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
 
      ** Define other work variables
     D BJDFIN          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A                                                      CAS006
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
 
      ** Define output parameter
     D TRANSDTL        S           5800A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Execute detail processing
     C                   EXSR      SRPROC
 
 
      ** End program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Detail processing                                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SESEDECVT                                             *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Initialise Transaction Detail and Extension data fields
     C                   CLEAR                   TRANSDTL
     C                   CLEAR                   SEDEExtDta
 
      ** Access Securities Details
     C     SDSN          CHAIN     SECTY                              02
 
      ** If Security does not exist in SECTYD file, perform
      ** DBerror processing.
     C                   IF        *IN02 = '1'
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SECTY'
     C                   EVAL      DBKEY = SDSN
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Access investment type details via access object
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    OSITP
     C                   PARM                    ONMCY
     C     INVSTPD       PARM      INVSTPD       DSFDY
 
      ** If investment type not found for the security, perform DBerror
      ** processing
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = OSITP + ONMCY
     C                   EVAL      DBFILE = 'INVTPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert Security Diary Events from file to screen format
 
     C                   CALLB     'SESEDECVT'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    SEDEFilFmt
     C                   PARM                    SECSFilFmt
 
      ** Processing Type
     C                   PARM                    IPROT
 
      ** Action Code
     C                   PARM                    CHTP
     C                   PARM                    BJDFIN
 
      ** Strategic Risk Mgmt indicator
     C                   PARM                    RMFL
     C                   PARM                    S01509
     C                   PARM                    S01510
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
     C                   PARM                    CGL031                                       CGL031
     C                   PARM                    SEDEScnFmt
 
 
      ** Set the value of TRANSDTL to be returned to SESEDEUPD module.
      ** This data structure will be used by APLOGTRAN in writing to
      ** the standard support log file.
     C                   IF        ReturnCode = *BLANKS
     C                   EVAL      TRANSDTL = SEDEScnFmt + SEDEExtDta
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly called on program activation            *
      *                                                               *
      * Calls: AOSARDR0 - Access Object for switchable features       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Input Parameters:
      ** =================
      ** SE Diary Events details - file format
      ** Date Format Indicator from SDBANK
      ** Enhancement S01509
 
      ** Output Parameter:
      ** =================
      ** Return Code
      ** Transaction Details in screen format
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    SEDEFilFmt
     C                   PARM                    BJDFIN
     C                   PARM                    S01509
     C                   PARM                    TRANSDTL
 
      ** Initialise field for error processing
     C                   EVAL      DBPgm = 'SESEDELOG'
 
      ** Check if S01510 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01510'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'S01510'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01510 = 'Y'
     C                   ELSE
     C                   EVAL      S01510 = 'N'
     C                   ENDIF
 
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
     C                   EVAL      DBase = 004                                                CAS006
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
     C                   EVAL      DBase = 005                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        PRtcd = *BLANKS                                            CSE065
     C                   MOVEL     'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVEL     'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
                                                                                              CGL031
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '901'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Access MMODF to determine if Strategic Risk Man. Ind is on
 
     C                   READ      MMODF                                  01
 
      **--------------------------------------------------------------+
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------+
 
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
**  CPY@
(c) Finastra International Limited 2001
