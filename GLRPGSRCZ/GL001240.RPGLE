     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account Risk Weighted Asset Codes Maint.')
      *****************************************************************
      *                                                               *
      *  Midas - GL General Ledger                                    *
      *                                                               *
      *  GL001240  - Account Risk Weighted Assets Codes Maintenance   *
      *                                                               *
      *  Function:  Maintains Account Risk Weighted Asset Codes       *
      *             Assets Sets.                                      *
      *                                                               *
      *  Called By: GLC001240 - Accounts Risk Weighted Asset Code CL  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BUG6979            Date 04May05               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL018  *CREATE    Date 28Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG6979 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      **  Accounts Risk Weighted Asset Master File Retrieval Index
      *
     FGLARWAL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L1)
      *
      **  Accounts Risk Weighted Asset Master File Update Index
      *
     FGLARWAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0)
     F                                     RENAME(GLARWAD0:RGLARWAD0)
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
      **  Account Risk Weighted Asset Code Maintenance Display
      *
     FGL001240DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(GL001240S1:DDSFRN)
     F                                     INFDS(INFDS#)
     F                                     INDDS(DispInds)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
                                                                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** External DS for SAR details                                                          CSC022
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D Action          S              1A
     D Currency        S              3A
     D*CustNumber      S              6S 0                                                    CSD027
     D CustNumber      S              6A                                                      CSD027
     D***AccountCode     S              4S 0                                                  CGL029
     D AccountCode     S             10S 0                                                    CGL029
     D AccountSeq      S              2S 0
     D LastRecNo       S              4S 0
     D SflRecNo        S              4S 0
     D BuildSflFlag    S              1A
     D ValidationOk    S              1A
     D PrevDDSETN      S                   Like(DDSETN)
     D PrevDDCODE      S              2A
     D ActionCodePar   S              1A
     D UserRight       S              1N
     D ReturnCode      S              7A
                                                                                              CSC022
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
     D PSARD           S                   LIKE(SARN)                                         CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
      *===================================================================
      /EJECT
      ********************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
                                                                                             BUG6979
      ** GET ZMUSER to access default details.                                               BUG6979
     C                   IN        ZMUSER                                                    BUG6979
                                                                                             BUG6979
      **  Set Basic Display Variables                                                        BUG6979
     C                   EVAL      DDUSER = PSUser                                           BUG6979
     C                   EVAL      DDWID = PSJobName                                         BUG6979
     C                   EVAL      DDPGMQ = PSProcName                                       BUG6979
 
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
     C                   PARM                    Action
     C                   PARM                    #1BRCA
     C                   PARM                    #1CUST
     C                   PARM                    Currency
     C                   PARM                    #1ACOD
     C                   PARM                    #1ACSQ
     C                   PARM                    #1RETL
     C                   if        #1RETL = '0000000000'
     C                   eval      #1RETL = *BLANK
     C                   endif
      *
      **  Set up action code indicator
     C                   eval      ActionCodeI = (Action = 'I')
 
      **  Because KEYS contains numeric fields
     C                   MOVE      #1CUST        CustNumber
     C                   MOVE      #1ACOD        AccountCode
     C                   MOVE      #1ACSQ        AccountSeq
 
      **  Initialise LDA field.
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBPGM
     C                   OUT       LDA
      **********                                                                             BUG6979
     C**********         IN        ZMUSER                                                    BUG6979
 
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
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       WRTCD                                        CSC022
     C                   PARM      '*VERIFY'     WOPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        WRTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        WRTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 7                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
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
 
     C                   MOVEL     'GLUSRMSG'    ZAMSGF           10
     C                   MOVEL     '*SAME'       ZAPGRL            5
     C                   MOVEL     *BLANK        ZAMSID            7
     C                   MOVEL     *BLANK        ZAMSDA          132
     C                   MOVEL     *BLANK        ZAMSTP            7
      **********                                                                             BUG6979
      ****Set*Basic*Display*Variables                                                        BUG6979
     C**********         EVAL      DDUSER = PSUser                                           BUG6979
     C**********         EVAL      DDWID = PSJobName                                         BUG6979
     C**********         EVAL      DDPGMQ = PSProcName                                       BUG6979
 
      **  Clear Message Subfile
     C                   EXSR      ClearMsgSFL
 
     C                   eval      BuildSflFlag = *ON
 
      **  KEYS
     C     kAccSetCode   KLIST
     C                   KFLD                    #1BRCA
     C                   KFLD                    CustNumber
     C                   KFLD                    Currency
     C                   KFLD                    AccountCode
     C                   KFLD                    AccountSeq
 
     C     kRWACodeSet   KLIST
     C                   KFLD                    DDCODE
     C                   KFLD                    DDSETN
 
     C     kWholeKey     KLIST
     C                   KFLD                    #1BRCA
     C                   KFLD                    CustNumber
     C                   KFLD                    Currency
     C                   KFLD                    AccountCode
     C                   KFLD                    AccountSeq
     C                   KFLD                    DDCODE
     C                   KFLD                    DDSETN
 
 
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
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
 
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
     C                   WRITE     GL001240C2
 
      **  Show Subfile Screen
     C                   IF        SflRecNo > 0
     C                   WRITE     GL001240F1
     C                   EXFMT     GL001240C1
     C                   ELSE
 
      **  No Record Screen
     C                   EXFMT     GL001240N1
     C                   ENDIF
 
      **  Clear Message Subfile
     C                   EXSR      ClearMsgSFL
 
     C                   if        F03Key = *ON
     C                   leave
     C                   endif
 
     C                   IF        F05Key = *ON
     C                   eval      F05Key = *OFF
     C                   eval      InvalidOption = *OFF
     C                   eval      BuildSflFlag = *ON
     C                   leave
     C                   ENDIF
 
     C                   if        F09Key = *ON
     C                   eval      Action = 'I'
     C                   EXSR      NewRecord
 
     C                   iter
     C                   endif
 
     C                   IF        SflRecNo > 0
 
      **  Check Subfile Option
     C                   if        ActionCodeI = *OFF
     C                   eval      F03Key = *ON
     C                   leave
     C                   endif
 
     C                   EXSR      ValSflOpt
     C                   if        InvalidOption = *ON
     C                   iter
     C                   endif
     C                   if        AtLeastOneOpt = *OFF
     C                   eval      F03Key = *ON
     C                   leave
     C                   endif
     C                   EXSR      ProcSflOpt
 
     C                   ELSE
     C                   eval      F03Key = *ON
     C                   leave
     C                   ENDIF
     C                   ENDDO
     C
     C                   ENDSR
      /EJECT
      *****************************************************************
      * BuildSFL - Subfile building                                   *
      *****************************************************************
 
     C     BuildSFL      BEGSR
 
     C                   if        BuildSflFlag = *OFF
     C                   goto      EndSub
     C                   endif
 
      **  Subfile Clearing
     C                   eval      SflDisp = *ON
     C                   WRITE     GL001240C1
     C                   eval      SflDisp = *OFF
     C                   eval      LastRecNo = DDSFRN
     C                   Z-ADD     0             DDSFRN
 
      **  Read the record from the file, write the record to the subfile
     C     kAccSetCode   SETLL     GLARWAL1
 
     C                   DOW       '1'
     C     kAccSetCode   READE     GLARWAL1
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
     C                   WRITE     GL001240S1
     C
     C                   ENDDO
     C
     C                   eval      SflRecNo = DDSFRN
      **  Set on the first position
     C                   IF        DDSFRN <> 0
     C                   Z-ADD     1             DDSFRN
     C                   ENDIF
     C                   eval      BuildSflFlag = *OFF
     C     EndSub        TAG
     C                   ENDSR
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
     C     DDSFRN        CHAIN     GL001240S1
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
 
     C                   other
      **  Invalid action code: must be A, D, or E
     C                   MOVE      'USR1001'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidOption = *ON
     C                   eval      AtLeastOneOpt = *ON
     C                   endsl
 
     C                   UPDATE    GL001240S1
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
     C     DDSFRN        CHAIN     GL001240S1
     C                   if        not(%found)
     C                   leave
     C                   endif
 
     C                   add       1             DDSFRN
     C                   ENDDO
 
     C                   Z-ADD     1             DDSFRN
 
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
 
      **  Addind record cycle
     C                   DOW       F03Key = *OFF
     C                   WRITE     GL001240C2
     C                   EXFMT     GL001240M1
 
     C                   EXSR      ClearMsgSFL
 
     C                   if        (F03Key = *ON)  OR
     C                             (F12Key = *ON)
     C                   leave
     C                   endif
 
     C                   eval      InvalidRWACode = *OFF
     C                   eval      InvalidRWASet = *OFF
 
      **  Check  of the RWA code & RWA Set
     C                   IF        (%TRIM(DDCODE) = '?') OR
     C                             DDSETN = '?'
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
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   iter
     C                   endif
 
      **  Check if the RWA Set is blank
     C                   IF        DDSETN = *BLANK
 
      **  Invalid value, enter '?'
     C                   MOVE      'USR1002'     ZAMSID
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
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   endif
 
      **  Check if the combination Account, RWA Set and RWA Code does'nt exist
     C                   MOVE      *OFF          *IN02
     C     kAccSetCode   SETLL     GLARWAL1
     C                   DOW       '1'
     C     kAccSetCode   READE     GLARWAL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   IF        L1RWCODE = DDCODE AND
     C                             L1RWSETN = DDSETN AND
     C                             L1RWRECI = *BLANK
     C                   eval      *IN02 = *ON
     C                   leave
     C                   endif
     C                   ENDDO
 
     C                   IF        *IN02 = *ON
 
      ** The combination Account, RWA Set and RWA Code already exists
     C                   MOVE      'USR1003'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   ENDIF
 
      **  All checks OK, write records
     C                   EXSR      WriteRec
     C                   leave
     C                   ENDDO
 
     C                   ENDSR
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
     C                   WRITE     GL001240C2
     C                   EXFMT     GL001240M1
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
     C                             DDSETN = '?'
     C                   CALLB     'SD001243'
     C                   PARM      *BLANK        RTCD              1
     C                   PARM      *BLANK        P#CODE            2
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
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   iter
     C                   endif
 
      **  Check if the RWA Set is blank
     C                   IF        DDSETN = *BLANK
 
      **  Invalid value, enter '?'
     C                   MOVE      'USR1002'     ZAMSID
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
     C                   MOVE      'USR1002'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   endif
 
      **  Check if the combination Account, RWA Set and RWA Code does'nt exist
     C                   MOVE      *OFF          *IN02
     C     kAccSetCode   SETLL     GLARWAL1
     C                   DOW       '1'
     C     kAccSetCode   READE     GLARWAL1
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   IF        L1RWCODE = DDCODE AND
     C                             L1RWSETN = DDSETN AND
     C                             L1RWRECI = *BLANK
     C                   eval      *IN02 = *ON
     C                   leave
     C                   endif
     C                   ENDDO
 
     C                   IF        *IN02 = *ON
 
      ** The combination Account, RWA Set and RWA Code already exists
     C                   MOVE      'USR1003'     ZAMSID
     C                   EXSR      SendMessage
     C                   eval      InvalidRWASet = *ON
     C                   eval      InvalidRWACode = *ON
     C                   iter
     C                   ENDIF
 
      **  All checks OK, write records
     C                   EXSR      UpdateRec
     C                   leave
     C                   ENDDO
 
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
     C                   MOVEL     'GLUSRMSG'    ZAMSGF           10
 
     C                   WRITE     GL001240C2
     C                   EXFMT     GL001240M1
 
     C                   EXSR      ClearMsgSFL
 
     C                   IF        F10Key = *ON
     C     kWholeKey     DELETE(E) RGLARWAD0
     C                   if        %ERROR
     C                   MOVE      'GLARWAL0'    DBFILE                         ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   else
     C
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   eval      BuildSflFlag = *ON
     C                   endif
     C                   ENDIF
     C
     C                   eval      DeleteFlag = *OFF
     C                   eval      F10Key = *OFF
     C                   eval      F12Key = *OFF
 
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
     C                   WRITE     GL001240C2
     C                   EXFMT     GL001240M1
 
     C                   EXSR      ClearMsgSFL
     C                   eval      EnquiryFlag = *OFF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * WriteRec - Write a record                                     *
      *****************************************************************
 
     C     WriteRec      BEGSR
 
      **  GLARWAL0
     C                   MOVE      *BLANK        L0RWRECI
     C                   MOVE      #1BRCA        L0RWBRCA
     C                   MOVE      #1CUST        L0RWCUST
     C                   MOVE      Currency      L0RWCCY
     C                   MOVE      #1ACOD        L0RWACOD
     C                   MOVE      #1ACSQ        L0RWACSQ
     C                   MOVE      #1RETL        L0RWACNO
     C                   MOVE      DDCODE        L0RWCODE
     C                   MOVE      DDSETN        L0RWSETN
     C                   MOVE      'I'           L0RWCHTP
     C                   Z-ADD     AGRDNB        L0RWLCD
     C                   WRITE(E)  RGLARWAD0
 
     C                   IF        %ERROR
     C                   MOVE      'GLARWAL0'    DBFILE                         ***************
     C                   Z-ADD     5             DBASE                          * DB ERROR 05 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
 
      **  All Is OK
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   eval      BuildSflFlag = *ON
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * UpdateRec - Updates a record                                  *
      *****************************************************************
 
     C     UpdateRec     BEGSR
 
     C     kAccSetCode   SETLL     GLARWAL0
     C                   DOW       '1'
     C     kAccSetCode   READE     GLARWAL0
     C                   if        %EOF
     C                   leave
     C                   endif
 
     C                   IF        L0RWSETN = PrevDDSETN  AND
     C                             L0RWCODE = PrevDDCODE  AND
     C                             L0RWRECI = *BLANK
     C                   eval      L0RWSETN = DDSETN
     C                   eval      L0RWCODE = DDCODE
     C                   ENDIF
 
     C                   UPDATE(E) RGLARWAD0
     C                   if        %ERROR
     C                   MOVE      'GLARWAL0'    DBFILE                         ***************
     C                   Z-ADD     6             DBASE                          * DB ERROR 06 *
     C                   EXSR      *PSSR                                        ***************
     C                   else
     C                   eval      BuildSflFlag = *ON
     C                   endif
     C                   ENDDO
      **  All Is OK
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SendMessage - Sends Message To The Program Message Queue      *
      *****************************************************************
 
     C     SendMessage   BEGSR
 
     C                   IF        ZAMSGF = *BLANKS
     C                   MOVEL     'GLUSRMSG'    ZAMSGF
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
