     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Risk Weighted Asset Codes Maint.')
      *****************************************************************
      *                                                               *
      *  Midas - SE Securities Trading Module                         *
      *                                                               *
      *  SE001300  - Securities Risk Weighted Assets Codes            *
      *              Maintenance                                      *
      *                                                               *
      *  Function:  Maintains Securities Risk Weighted Asset Codes    *
      *             Assets Sets.                                      *
      *                                                               *
      *  Called By: SEC001300 - Securities Risk Weighted Asset Code   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG7029            Date 09Jun05               *
      *  Prev Amend No. CSC022             Date 24Feb04               *
      *                 CGL018  *CREATE    Date 07Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    95         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
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
      ** È F-specs                              È
      ** È =======                              È
      ** +--------------------------------------+
      *
      **  Securities Risk Weighted Asset Master File Retrieval Index
      *
     FSESRWAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
      *
      **  Securities Risk Weighted Asset Master File Update Index
      *
     FSESRWAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
     F                                     RENAME(SESRWAP0:RSESRWAD0)
     F                                     COMMIT
      *
      **  Risk Weighted Asset Master File Retrieval Index
      *
     FSDRWASL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(S1)
      *
      **  Risk Weighted Asset Codes Master File Retrieval Index
      *
     FSDRWACL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(C1)
      *
      **  Securities Risk Weighted Asset Code Maintenance Display
      *
     FSE001300DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SE001300S1:DDSFRN)
     F                                     INFDS(INFDS#)
     F                                     INDDS(DispInds)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** È D-specs                              È
      ** È =======                              È
      ** +--------------------------------------+
 
     D DispInds        DS
     D F03Key                  3      3N
     D F05Key                  5      5N
     D F09Key                  9      9N
     D F10Key                 10     10N
     D F12Key                 12     12N
     D DeleteFlag             21     21N   INZ(*OFF)
     D AmendFlag              22     22N   INZ(*OFF)
     D EnquiryFlag            23     23N   INZ(*OFF)
     D NewRecordFlag          24     24N   INZ(*OFF)
     D ActionCodeI            77     77N   INZ(*OFF)
     D InvalidRWASet          82     82N
     D InvalidRWACode         83     83N
     D MsgSflEnd              90     90N   INZ(*ON)
     D SflEnd                 91     91N   INZ(*ON)
     D InvalidOption          92     92N
     D SysDateF               95     95N
     D SflDisp                97     97N
     D AtLeastOneOpt          98     98N
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** First DS for Access Programs, Short Data Structure
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** ExternaL DS for Bank Details
      *
 
      *  External DS for Security Reasons - Default Branch DBRN
     D ZMUSER        E DS                  EXTNAME(ZMUSER)
     D                                     DTAARA(ZMUSER)
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
 
      ** +--------------------------------------+
      ** È Named constants                      È
      ** È ===============                      È
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** È Arrays and Data Structures           È
      ** È ==========================           È
      ** +--------------------------------------+
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
                                                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for SAR Detail record                                                             CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
 
      ** +--------------------------------------+
      ** È Declared variables                   È
      ** È ==================                   È
      ** +--------------------------------------+
 
     D @RUN            S              1
     D Action          S              1A
     D LastRecNo       S              4S 0
     D SflRecNo        S              4S 0
     D BuildSflFlag    S              1A
     D ValidationOk    S              1A
     D PrevDDSETN      S              1A
     D AuxDDSETN       S              1A
     D PrevDDCODE      S              2A
     D AuxDDCODE       S              2A
     D ActionCodePar   S              1A
     D UserRight       S              1N
     D ReturnCode      S              7A
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
      *===================================================================
      /EJECT
      ********************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** È                                                                È
      ** È Initial processing is performed automatically: the *INZSR is   È
      ** È executed at program activation.                                È
      ** È                                                                È
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
 
     C                   DOW       F03Key = *OFF
 
      *  Open Initial Screen
     C                   EXSR      MainScreenD
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
 
     C                   RETURN
      *===================================================================*
      /EJECT
      *********************************************************************
      *                                                                   *
      * *INZSR - Program Initialisation routine                           *
      *                                                                   *
      * Called by: Implicitly on program activation                       *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
      *
     C     *INZSR        BEGSR
     C
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    #1SECR
     C                   PARM                    Action
      *
      **  Set up action code indicator
     C                   eval      ActionCodeI = (Action <> 'E')
 
      **  Initialise LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   OUT       LDA
 
     C**********         IN        ZMUSER                                                    BUG7029
      **********                                                                             BUG7029
      **  Call AO for Bank Details - Title, Run Date and
      **  Run Day Number.
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     WRTCD             7
     C                   PARM      '*FIRST '     WOPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      **  Handle Database Error.
     C     WRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
 
      **  Check System Date Format, DDMMYY (*IN95 off)
      **                            MMDDYY (*IN95 on).
     C                   IF        AGDFF = 'M'
     C                   eval      SysDateF = *ON
     C                   ENDIF
 
      **  Access RUNDAT for multibranching indicator
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   IF        AGMBIN = 'M'
     C                   SETON                                        37
     C                   ENDIF
 
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
 
      **  Set Basic Display Variables
     C                   EVAL      DDUSER = PSUser
     C                   EVAL      DDWID = PSJobName
     C                   EVAL      DDPGMQ = PSProcName
 
      **  Clear Message Subfile
     C                   EXSR      ClearMsgSFL
 
     C                   eval      BuildSflFlag = *ON
 
      **  KEYS
     C     kSecurity     KLIST
     C                   KFLD                    #1SECR
 
     C     kSeCSet       KLIST
     C                   KFLD                    #1SECR
     C                   KFLD                    DDSETN
 
     C     kSeCSetCode   KLIST
     C                   KFLD                    #1SECR
     C                   KFLD                    DDSETN
     C                   KFLD                    DDCODE
 
     C     kRWACodeSet   KLIST
     C                   KFLD                    DDCODE
     C                   KFLD                    DDSETN
 
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD             7                          CSC022
     C                   Parm      '*VERIFY'     @OPTN             7                          CSC022
     C                   Parm      'CSC022'      @SARD             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 7                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  '(file)'
     C                   EVAL      DBKEY  =  '(key)'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  999
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  PSProcName
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
      **  Any Error, Do Rollback
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * MainScreenD - Displays the initial screen                       *
      *****************************************************************
 
     C     MainScreenD   BEGSR
 
     C                   DOW       F03Key = *OFF
     C                   EXSR      BuildSFL
     C                   WRITE     SE001300C2
 
      **  Show Subfile Screen
     C                   IF        SflRecNo > 0
     C                   WRITE     SE001300F1
     C                   EXFMT     SE001300C1
     C                   ELSE
 
      **  No Record Screen
     C                   EXFMT     SE001300N1
     C                   ENDIF
 
      **  Clear Message Subfile
     C                   EXSR      ClearMsgSFL
 
     C                   if        F03Key = *ON
     C                   goto      EMainScreenD
     C                   endif
 
     C                   IF        F05Key = *ON
     C                   eval      F05Key = *OFF
     C                   eval      InvalidOption = *OFF
     C                   eval      BuildSflFlag = *ON
     C                   iter
     C                   ENDIF
 
     C                   if        F09Key = *ON
     C                   eval      Action = 'I'
     C                   EXSR      CheckAut
     C                   if        UserRight = *ON
     C                   EXSR      NewRecord
     C                   else
 
      **  User is not authorised to this action code
     C                   MOVE      'CSF9006'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   MOVEL(P)  Action        ZAMSDA
     C                   EXSR      SendMessage
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10
     C                   endif
     C                   iter
     C                   endif
 
      **  Enter pressed
     C                   IF        SflRecNo > 0
 
      **  Check Subfile Option
     C                   if        ActionCodeI = *OFF
     C                   eval      F03Key = *ON
     C                   goto      EMainScreenD
     C                   endif
 
     C                   EXSR      ValSflOpt
     C                   if        InvalidOption = *ON
     C                   iter
     C                   endif
     C                   if        AtLeastOneOpt = *OFF
     C                   eval      F03Key = *ON
     C                   goto      EMainScreenD
     C                   endif
 
     C                   EXSR      ProcSflOpt
 
     C                   ELSE
     C                   eval      F03Key = *ON
     C                   goto      EMainScreenD
     C                   ENDIF
     C                   ENDDO
     C
     C     EMainScreenD  ENDSR
      /EJECT
      *****************************************************************
      * BuildSFL - Subfile building                                   *
      *****************************************************************
 
     C     BuildSFL      BEGSR
 
     C                   if        BuildSflFlag = *OFF
     C                   goto      EBuildSfl
     C                   endif
 
      **  Subfile Clearing
     C                   eval      SflDisp = *ON
     C                   WRITE     SE001300C1
     C                   eval      SflDisp = *OFF
     C                   eval      LastRecNo = DDSFRN
     C                   Z-ADD     0             DDSFRN
 
      **  Read the record from the file, write the record to the subfile
     C     kSecurity     SETLL     SESRWAL1
 
     C                   DOW       '1'
     C     kSecurity     READE     SESRWAL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   if        L1RWRECI <> *BLANK
     C                   iter
     C                   endif
 
     C                   MOVE      *BLANK        DDOPT
     C                   MOVE      L1RWSETN      DDSETN
     C                   MOVE      L1RWCODE      DDCODE
     C                   ADD       1             DDSFRN
     C                   WRITE     SE001300S1
     C
     C                   ENDDO
     C
     C                   eval      SflRecNo = DDSFRN
      **  Set on the first position
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
     C                   eval      BuildSflFlag = *OFF
     C     EBuildSfl     ENDSR
      /EJECT
      *****************************************************************
      * ValSFLOpt - Only checks entered subfile options               *
      *             and displays a message in case of an error        *
      *****************************************************************
 
     C     ValSFLOPt     BEGSR
 
      **  Set of indicators and variables
     C                   Z-ADD     1             DDSFRN
     C                   eval      InvalidOption = *OFF
     C                   eval      AtLeastOneOpt = *OFF
 
      **  Subfile read cycle
     C                   DOW       DDSFRN <= SflRecNo AND
     C                             InvalidOption = *OFF
     C     DDSFRN        CHAIN     SE001300S1
     C                   eval      InvalidOption = *OFF
     C                   if        not(%found)
     C                   eval      F03Key = *ON
     C                   leave
     C                   endif
 
     C                   select
     C                   when      DDOPT  = *BLANK
 
     C                   when      DDOPT = 'A' OR
     C                             DDOPT = 'D' OR
     C                             DDOPT = 'E'
     C                   eval      Action = DDOPT
     C                   eval      AtLeastOneOpt = *ON
     C                   EXSR      CheckAut
     C                   if        UserRight = *OFF
 
      **  User is not authorised to this action code
     C                   MOVE      'CSF9006'     ZAMSID
     C                   MOVEL(P)  DDOPT         ZAMSDA
     C                   EXSR      SendMessage
     C                   eval      InvalidOption = *ON
     C                   endif
 
     C                   other
      **  Invalid action code: must be A, D, or E
     C                   MOVE      'USR4330'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidOption = *ON
     C                   eval      AtLeastOneOpt = *ON
     C                   endsl
 
     C                   UPDATE    SE001300S1
     C                   add       1             DDSFRN
     C                   ENDDO
 
     C                   SUB       1             DDSFRN
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ProcSFLOpt - Process  entered subfile options                 *
      *             and displays a message in case of an error        *
      *****************************************************************
 
     C     ProcSFLOPt    BEGSR
 
      **  Set of indicators and variables
     C                   Z-ADD     1             DDSFRN
     C                   eval      DDOPT = *BLANK
 
      **  Subfile read cycle
     C                   DOW       DDSFRN <= SflRecNo AND
     C                             DDOPT = *BLANK
     C     DDSFRN        CHAIN     SE001300S1
     C                   if        not(%found)
     C                   leave
     C                   endif
 
     C                   add       1             DDSFRN
     C                   ENDDO
 
     C                   sub       1             DDSFRN
 
     C                   SELECT
     C                   WHEN      DDOPT = 'D'
     C                   EXSR      DeleteRec
     C                   WHEN      DDOPT = 'E'
     C                   EXSR      EnquiryRec
     C                   WHEN      DDOPT = 'A'
     C                   EXSR      AmendRec
     C                   ENDSL
     C                   ENDSR
      /EJECT
      *****************************************************************
      * NewRecord  - Adds new record                                  *
      *****************************************************************
      *
     C     NewRecord     BEGSR
 
     C                   eval      DDCODE         = *BLANK
     C                   eval      DDSETN         = *BLANK
     C                   eval      NewRecordFlag  = *ON
     C                   eval      EnquiryFlag    = *OFF
     C                   eval      AmendFlag      = *OFF
     C                   eval      DeleteFlag     = *OFF
     C                   eval      InvalidRWACode = *OFF
     C                   eval      InvalidRWASet  = *OFF
     C                   eval      F12Key = *OFF
 
      **  Adding record cycle
     C                   DOW       F03Key = *OFF
     C                   WRITE     SE001300C2
     C                   EXFMT     SE001300M1
 
     C                   EXSR      ClearMsgSFL
 
     C                   if        (F03Key = *ON)  OR
     C                             (F12Key = *ON)
     C                   goto      ENewRecord
     C                   endif
 
     C                   eval      InvalidRWACode = *OFF
     C                   eval      InvalidRWASet = *OFF
 
      **  Check  of the RWA code & RWA Set
     C                   IF        (%TRIM(DDCODE) = '?') OR
     C                             (%TRIM(DDSETN) = '?')
     C                   CALLB     'SD001243'
     C                   PARM      *BLANK        RTCD              1
     C                   PARM      *BLANK        P#CODE            2
     C                   PARM      *BLANK        P#SETN            1
 
     C                   IF        RTCD = *BLANK
     C                   MOVE      P#CODE        DDCODE
     C                   MOVE      P#SETN        DDSETN
     C                   ELSE
     C                   MOVE      'SDRWACL1'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ITER
     C                   ENDIF
 
      **  Check if the RWA Set exists
     C                   eval      *IN02 = *OFF
     C     DDSETN        SETLL     SDRWASL1
 
     C                   DOW       '1'
     C     DDSETN        READE     SDRWASL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   if        S1RWRECI = *BLANK
     C                   eval      *IN02 = *ON
     C                   leave
     C                   endif
     C                   ENDDO
 
     C                   IF        *IN02 = *OFF
      **  Invalid value, enter '?'
     C                   MOVE      'USR4331'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   iter
     C                   endif
 
      **  Check if the RWA Set is blank
     C                   IF        DDSETN = *BLANK
 
      **  Invalid value, enter '?'
     C                   MOVE      'USR4331'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   ITER
     C                   ENDIF
 
      **  Check if the combination RWA Set and RWA Code exists
     C                   eval      *IN02 = *OFF
     C     kRWACodeSet   SETLL     SDRWACL1
     C                   DOW       '1'
     C     kRWACodeSet   READE     SDRWACL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   if        S1RWRECI = *BLANK
     C                   eval      *IN02 = *ON
     C                   leave
     C                   endif
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
 
      **  Invalid value, enter '?'
     C                   MOVE      'USR4331'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   endif
 
      **  Check if the combination of Security and RWA Set does'nt exist
     C     kSecSet       CHAIN(E)  SESRWAL1
     C                   if        %FOUND
 
      ** The combination Security and RWA Set already exists
     C                   MOVE      'USR4332'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   endif
 
      **  All checks OK, write records
     C                   EXSR      WriteRec
     C                   leave
     C                   ENDDO
 
     C     ENewRecord    ENDSR
      /EJECT
      *****************************************************************
      * AmendRecord  - Amends selected record                         *
      *****************************************************************
      *
     C     AmendRec      BEGSR
 
     C                   eval      PrevDDCODE = DDCODE
     C                   eval      PrevDDSETN = DDSETN
     C                   eval      NewRecordFlag = *OFF
     C                   eval      EnquiryFlag   = *OFF
     C                   eval      AmendFlag     = *ON
     C                   eval      DeleteFlag    = *OFF
     C                   eval      InvalidRWACode = *OFF
     C                   eval      InvalidRWASet = *OFF
     C                   eval      F12Key = *OFF
 
      **  Amending record cycle
     C                   DOW       F03Key = *OFF
     C                   WRITE     SE001300C2
     C                   EXFMT     SE001300M1
     C
     C                   eval      InvalidRWACode = *OFF
     C                   eval      InvalidRWASet = *OFF
 
     C                   EXSR      ClearMsgSFL
     C                   if        (F03Key = *ON)  OR
     C                             (F12Key = *ON)
     C                   leave
     C                   endif
 
      **  No changes made
     C                   if        DDCODE = PrevDDCODE  AND
     C                             DDSETN = PrevDDSETN
     C                   leave
     C                   endif
 
      **  Check  of the RWA code & RWA Set
     C                   IF        (%TRIM(DDCODE) = '?') OR
     C                             (%TRIM(DDSETN) = '?')
     C                   CALLB     'SD001243'
     C                   PARM      *BLANK        RTCD
     C                   PARM      *BLANK        P#CODE
     C                   PARM      *BLANK        P#SETN
     C
     C                   IF        RTCD = *BLANK
     C                   MOVE      P#CODE        DDCODE
     C                   MOVE      P#SETN        DDSETN
     C                   ELSE
     C                   MOVE      'SDRWACL1'    DBFILE                         ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
     C                   ITER
     C                   ENDIF
 
      **  Check if the RWA Set exists
     C                   eval      *IN02 = *OFF
     C     DDSETN        SETLL     SDRWASL1
 
     C                   DOW       '1'
     C     DDSETN        READE     SDRWASL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   if        S1RWRECI = *BLANK
     C                   eval      *IN02 = *ON
     C                   leave
     C                   endif
     C                   ENDDO
 
     C                   IF        *IN02 = *OFF
      **  Invalid value, enter '?'
     C                   MOVE      'USR4331'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   iter
     C                   endif
 
      **  Check if the RWA Set is blank
     C                   IF        DDSETN = *BLANK
 
      **  Invalid value, enter '?'
     C                   MOVE      'USR4331'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   ITER
     C                   ENDIF
 
      **  Check if the combination RWA Set and RWA Code exists
     C                   eval      *IN02 = *OFF
     C     kRWACodeSet   SETLL     SDRWACL1
     C                   DOW       '1'
     C     kRWACodeSet   READE     SDRWACL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   if        S1RWRECI = *BLANK
     C                   eval      *IN02 = *ON
     C                   leave
     C                   endif
     C                   ENDDO
     C
     C                   IF        *IN02 = *OFF
 
      **  Invalid value, enter '?'
     C                   MOVE      'USR4331'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   endif
 
      **  Check if the combination Security and RWA Set does'nt exist
      **  Check only in case, the RWA Set has changed
 
     C                   MOVE      *OFF          *IN02
     C                   if        DDSETN <> PrevDDSETN
     C     kSecSet       CHAIN(E)  SESRWAL1
     C                   if        %FOUND
     C                   eval      *IN02 = *ON
     C                   endif
     C                   endif
 
     C                   IF        *IN02 = *ON
 
      ** The combination Security and RWA Set already exists
     C                   MOVE      'USR4332'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   ENDIF
 
      **  All checks OK, write records
     C                   EXSR      UpdateRec
     C                   leave
     C                   ENDDO
     C                   eval      BuildSflFlag = *ON
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * DeleteRec - Deletes a record                                  *
      *****************************************************************
 
     C     DeleteRec     BEGSR
     C
     C                   eval      NewRecordFlag = *OFF
     C                   eval      EnquiryFlag   = *OFF
     C                   eval      AmendFlag     = *OFF
     C                   eval      DeleteFlag    = *ON
 
      **  Delete record
 
     C                   EXSR      ClearMsgSFL
 
      **  Press F10 to confirm delete
     C                   MOVE      'ASM0028'     ZAMSID
     C                   MOVEL     'SDUSRMSG'    ZAMSGF           10
     C                   EXSR      SendMessage
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10
 
     C                   WRITE     SE001300C2
     C                   EXFMT     SE001300M1
 
     C                   EXSR      ClearMsgSFL
 
     C                   IF        F10Key = *ON
     C     kSecSetCode   SETLL     SESRWAL0
     C                   DOW       '1'
     C     kSecSetCode   READE     SESRWAL0
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   IF        L0RWSETN = DDSETN  AND
     C                             L0RWCODE = DDCODE
     C                   DELETE(E) RSESRWAD0
     C                   if        %ERROR
     C                   MOVE      'SESRWAL0'    DBFILE                         ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   endif
     C                   ELSE
     C                   leave
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C
     C                   eval      DeleteFlag = *OFF
     C                   eval      F10Key = *OFF
     C                   eval      F12Key = *OFF
     C                   eval      BuildSflFlag = *ON
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * EnquiryRec - Displays a record                                *
      *****************************************************************
 
     C     EnquiryRec    BEGSR
     C
     C                   eval      NewRecordFlag = *OFF
     C                   eval      EnquiryFlag   = *ON
     C                   eval      AmendFlag     = *OFF
     C                   eval      DeleteFlag    = *OFF
 
      **  Display record
     C                   EXSR      ClearMsgSFL
     C                   WRITE     SE001300C2
     C                   EXFMT     SE001300M1
 
     C                   EXSR      ClearMsgSFL
     C                   eval      EnquiryFlag = *OFF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WriteRec - Write a record                                     *
      *****************************************************************
 
     C     WriteRec      BEGSR
 
      **  SESRWAL0
     C                   MOVE      *BLANK        L0RWRECI
     C                   MOVE      #1SECR        L0RWSESN
     C                   MOVE      DDCODE        L0RWCODE
     C                   MOVE      DDSETN        L0RWSETN
     C                   MOVE      'I'           L0RWCHTP
     C                   Z-ADD     AGRDNB        L0RWLCD
     C                   WRITE(E)  RSESRWAD0
 
     C                   IF        %ERROR
     C                   MOVE      'SESRWAL0'    DBFILE                         ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
 
      **  All Is OK
     C                   eval      BuildSflFlag = *ON
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * UpdateRec - Updates a record                                  *
      *****************************************************************
 
     C     UpdateRec     BEGSR
 
     C                   MOVE      DDCODE        AuxDDCODE
     C                   MOVE      DDSETN        AuxDDSETN
     C                   MOVE      PrevDDCODE    DDCODE
     C                   MOVE      PrevDDSETN    DDSETN
 
     C     kSecSetCode   CHAIN(E)  SESRWAL0
     C                   if        %FOUND
 
     C                   MOVE      AuxDDCODE     L0RWCODE
     C                   MOVE      AuxDDSETN     L0RWSETN
     C                   MOVE      'A'           L0RWCHTP
     C                   Z-ADD     AGRDNB        L0RWLCD
 
     C                   UPDATE(E) RSESRWAD0
     C                   if        %ERROR
     C                   MOVE      'SESRWAL0'    DBFILE                         ***************
     C                   Z-ADD     6             DBASE                          * DB ERROR 06 *
     C                   EXSR      *PSSR                                        ***************
     C                   else
     C                   eval      BuildSflFlag = *ON
     C                   endif
     C                   endif
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SendMessage - Sends Message To The Program Message Queue      *
      *****************************************************************
 
     C     SendMessage   BEGSR
 
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     'SEUSRMSG'    ZAMSGF
     C                   ENDIF
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM      *BLANK        ZAMSTP
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * ClearMsgSFL - Clears Message Subfile                          *
      *****************************************************************
 
     C     ClearMsgSFL   BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      PSProcName    ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
     C
     C                   ENDSR
      *****************************************************************
      * CheckAut - Validate user rights for an option       *
      * Checks the user's authority for ActionCodePar                 *
      * Return:  *ON if user has the authority                        *
      *          *OFF else                                            *
      *****************************************************************
 
     C     CheckAut      BEGSR
 
      ** If Action Code <> 'I' only 'E' is allowed
     C                   if        (ActionCodeI = *OFF) AND
     C                             (Action <> 'E')
     C                   eval      UserRight = *OFF
     C                   goto      EndCheck
     C                   endif
 
     C                   IF        AGMBIN = 'N'
     C                   CALL      'ZVACTU'
     C                   PARM      Action        ActionCodePar
     C                   PARM                    Result            1 0
 
      **  In case of Multientity system, check if user is authorised
      **  for action in branch
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM      Action        ActionCodePar
     C                   PARM      DBRN          WZBR              3
     C                   PARM                    Result
     C                   ENDIF
 
     C                   eval      UserRight = (Result = 0)
 
     C     EndCheck      TAG
     C                   ENDSR
