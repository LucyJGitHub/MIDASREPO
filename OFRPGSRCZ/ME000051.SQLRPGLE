     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas OF MT940/950 Production on Request')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  ME000051 - MT94x Production on Request Maintenance           *
      *                                                               *
      *  Function:  This module enables the user to generate MT940    *
      *             and MT950 on manual request.                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD023480           Date 15Nov13               *
      *  Prev Amend No. CGL146B *CREATE    Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023480 - Validations regarding input of slash and          *
      *             consecutive slashes in field 21 Related ref       *
      *             is not working.                                   *
      *  CGL146B - MT940/950 Production in Input Cycle                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         Screen 1 (subfile)                              *
      *    27         Screen 2 (details prompt)                       *
      *    28         Screen 3 (enable F8)                            *
      *    29         Header text (MT940/MT950)                       *
      *    40         Invalid action code                             *
      *    41         Invalid network                                 *
      *    42         Invalid field 21: related reference             *
      *    43         Invalid Message Information to Account Owner 1  *
      *    44         Invalid Message Information to Account Owner 2  *
      *    45         Invalid Message Information to Account Owner 3  *
      *    46         Invalid Message Information to Account Owner 4  *
      *    47         Invalid Message Information to Account Owner 5  *
      *    48         Invalid Message Information to Account Owner 6  *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Rollup                                          *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    99         Multi Purpose Indicator                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display screen                              *
      *  SRProcess     -  Process screen input                        *
      *  SRVAction     -  Validate action code                        *
      *  SRDetails     -  Set-up Details                              *
      *  SRRetrieve    -  Retrieve record details                     *
      *  SRInsert      -  Insert record                               *
      *  SRValidate    -  Validate details                            *
      *  SRVField21    -  Validate Related Reference                  *
      *  SRVStmtDate   -  Validate Statement Date                     *
      *  SRVStmtDAte2  -  Validate Statement Date for no prompt       *
      *  SRRefresh     -  Refresh subfile                             *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Move fields from file/screen to screen/file *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SRPrevious    -  Display previous screen                     *
      *  SREnd         -  End program                                 *
      *  SRLoadNW9X    -  Load resultset to temporary file            *
      *  SROvrFil      -  Override with filters in data area          *
      *  SRSelectAll   -  Select all records                          *
      *  SRPrompt      -  Prompt each selecte account or not          *
      *  SRToggle      -  Toggle between screens                      *
      *                                                               *
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
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FME000051DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(ME000051S0:#0RLRN)
      ** Midas ME MT94x Production on Request Maintenance Screen
 
     FGLNW9XI5  UF A E           K DISK    INFSR(*PSSR)
      ** Midas OF Network Accounts MT94x Details (Live Accounts)
 
     FGLNW94L3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D3)
      ** Midas GL Network Accounts MT94x Details (Live + Allow941)
 
     FGLNW94L4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D4)
      ** Midas GL Network Accounts MT94x Details (Live + Allow942)
 
     FGLMR94L0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL MT940/950 Messages Requested (Update)
 
     FGLNWKAPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Network Activity Control File
 
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account details
 
     FGLMR941D  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLMR94D0:GLMR94X0)
     F                                     COMMIT
      ** Midas OF MT940/950 Messages Requested Extension (Update)
 
     FSDNWRKI0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas OF Message Network details extension
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D SWIFTchars      C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                     abcdefghijklmnopqrstuvwxyz-
     D                                     0123456789 /-?:().,''+'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D GLM9XXDA      E DS                  EXTNAME(GLM9XXDA) DTAARA(GLM9XXDA)
      *  Midas MT94x Temporary Normal Data Area
 
      ** External data structure for Bank Details
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for selection fields
     D WSelect         DS            54
     D   #0NETW                1      6
     D   #0BRCA                7      9
     D   #0CNUM               10     15
     D   #0CCY                16     18
     D   #0ACCD               19     28
     D   #0ACSQ               29     30
     D   #0REAC               31     40
     D   #0MSGT               41     43
     D   #0DEST               44     54
 
      ** DS for Account Number (position field)
     D #0POS2          DS
     D   WBranch1              1      3
     D   WCustomer1            4      9
     D   WCurrency1           10     12
     D   WAcctCode1           13     22
     D   WAcctSeqn1           23     24
 
      ** DS for Account Number (subfile field)
     D #0ACCT          DS
     D   WBranch2              1      3
     D   WCustomer2            4      9
     D   WCurrency2           10     12
     D   WAcctCode2           13     22
     D   WAcctSeqn2           23     24
 
     D wMsgData        DS
     D   wValidated            1      3
     D   wRequested            4      6
 
     D RecordSet     E DS                  EXTNAME(GLNW9XTD)
     D wkRecordSet   E DS                  EXTNAME(GLNW9XTD) PREFIX(wk)
 
     D PZErr           S              1
     D PRunDate        S              6  0
     D WSelectAll      S              1
     D wSkip           S              1
     D i               S              4  0
     D j               S              4  0
     d wStmtDate       S               D
     d wLastStDt       S               D
     d w941LastStDt    S               D
     d w942LastStDt    S               D
     d wRunDate        S               D
     d wTmpDate        S               D
     D wM1STMDT        S              5  0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtrnCode       S              7
     D POption         S              7
     D POperation      S              6
     D PMode           S              7
 
      ** Parameters for ZDATE2
     D PMidasDayNo     S              5  0
     D PDateFmt        S              1
     D PDDMMYY         S              6  0
     D PWorkDate       S              7
 
      ** Parameters for Y2SNMGC
     D PZPgmQ          S             10
     D PZRelQ          S              5
     D PZMsgID         S              7
     D PZMsgFile       S             10
     D PZMsgData       S            132
     D PZMsgType       S              7
 
      ** Parameters for QSNDDTAQ
     D PDataQueue      S             10
     D PLibrary        S             10
     D PDataLength     S              5  0
     D PData           S              1
 
     D KNetwork        S              6
     D KBranch         S              3
     D KCustomer       S              6A
     D KCurrency       S              3
     D KAcctCode       S             10  0
     D KAcctSeqn       S              2  0
     D KAcctType       S              1
     D KDestination    S             11
 
     D WkCNUM          S              6
     D WkACCD          S             10
     D WkACSQ          S              2
     D WkLAST          S              6
     D WOk940          S              1
     D WOk950          S              1
     D W940GNM         S              1
     D W950GNM         S              1
     D WRun            S              1
     D WReload         S              1
     D WLRCD           S              4  0
     D WError          S              1
     D WSLCTR          S              3  0
     D WRCTR           S              5  0
     D WSFPG           S              5  0
     D WSkipRec        S              1
     D WScreen         S              1
     D WFileToScrn     S              1
     D WValid          S              1
     D WLoop           S              1
     D WProcess        S              1
     D WZSELE          S             48
     D WZNWRK          S              6
     D WZACCT          S             24
     D WZDSTN          S             11
     D WKSTIM          S              6S 0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
      ** Override screen filter field with data area values
 
     C                   EXSR      SROvrFil
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      WReload = 'N'
 
      ** Display screen until reload requested
 
     C     WReload       DOWEQ     'N'
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN05         CASEQ     '1'           SRRefresh
 
     C     *IN06         CASEQ     '1'           SRSelectAll
 
     C     *IN11         CASEQ     '1'           SRToggle
 
     C     *IN31         CASEQ     '1'           SRLoad
 
     C     *IN81         CASEQ     '1'           SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBuild - Initialise and Load Subfile Page                   *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     ME000051C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *ON
     C                   EVAL      WScreen = '1'
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** Position file
 
     C                   MOVE      #0POS1        KNetwork
     C                   MOVE      WBranch1      KBranch
     C                   MOVE      WCustomer1    KCustomer
     C                   MOVE      WCurrency1    KCurrency
     C                   MOVE      WAcctCode1    KAcctCode
     C                   MOVE      WAcctSeqn1    KAcctSeqn
      ** N.B.: Once the network account type will no more be hidden,
      **       the following key field should by set up by the value of
      **       a new position field, which is to be added in the display file
     C* Future use **    MOVE      New_Pos_Fld   KAcctType
     C                   MOVE      'S'           KAcctType
     C                   MOVE      #0POS3        KDestination
 
      ** Setup key
 
     C     KGLNW9X       SETLL     GLNW9XD0                           82
     C                   READ      GLNW9XD0                               82
 
      ** Save previous selector values
 
     C                   EVAL      WOk940 = 'N'
     C                   EVAL      WOk950 = 'N'
     C                   EVAL      WZSELE = WSelect
     C                   EVAL      WZNWRK = #0POS1
     C                   EVAL      WZACCT = #0POS2
     C                   EVAL      WZDSTN = #0POS3
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, send 'No data to display'.
 
     C                   IF        *IN82 = *ON  AND  #0RLRN = 0
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      PZMsgID = 'ME00001'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
      ** Load subfile page
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        *IN31 = *ON  AND  *IN82 = *OFF
     C                   READP     GLNW9XI5
     C                   READ      GLNW9XI5
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         #0RLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       NOT %EOF(GLNW9XI5)  AND  WRCTR <= WSFPG
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** Check EDP940 and EDP950 from SDNWRKI0
 
     C     NXNWRK        CHAIN     SDNWRKI0
 
     C                   IF        WOk940 = 'N'
     C                   EVAL      WOk940 = 'Y'
     C                   IF        N4G940 = 'Y'  AND
     C                             (%FOUND(SDNWRKI0) AND EDP940 = 'Y')
     C                   EXSR      SRAddSflRec
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      WOk940 = 'N'
     C                   EVAL      WOk950 = 'Y'
     C                   IF        NAG950 = 'Y'  AND
     C                             (%FOUND(SDNWRKI0) AND EDP950 = 'Y')
     C                   EXSR      SRAddSflRec
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WOk950 = 'Y'
     C                   EVAL      WOk950 = 'N'
     C                   READ      GLNW9XI5                               82
     C                   ENDIF
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAddSflRec - Add record in subfile                          *
      *                                                               *
      *****************************************************************
 
     C     SRAddSflRec   BEGSR
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             #0RLRN
     C                   MOVE      NXCNUM        WkCNUM
     C                   MOVE      NXACOD        WkACCD
     C                   MOVE      NXACSQ        WkACSQ
     C                   EVAL      #0ACCT = NXBRCA + WkCNUM + NXCCY +
     C                                      WkACCD + WkACSQ
 
     C     KACCNT        CHAIN     ACCNTL0
     C                   IF        %FOUND(ACCNTL0)
     C                   MOVE      ACNO          #0ACNO
     C                   EVAL      #0ANAM = ANAM
     C                   ELSE
     C                   EVAL      #0ACNO = *BLANKS
     C                   EVAL      #0ANAM = *BLANKS
     C                   ENDIF
 
     C                   EXSR      SRMsgType
 
     C                   IF        (#0NETW <> *BLANKS  AND  #0NETW <> NXNWRK) OR
     C                             (#0BRCA <> *BLANKS  AND  #0BRCA <> NXBRCA) OR
     C                             (#0CNUM <> *BLANKS  AND  #0CNUM <> WkCNUM) OR
     C                             (#0CCY  <> *BLANKS  AND  #0CCY <> NXCCY)   OR
     C                             (#0ACCD <> *BLANKS  AND  #0ACCD <> WkACCD) OR
     C                             (#0ACSQ <> *BLANKS  AND  #0ACSQ <> WkACSQ) OR
     C                             (#0REAC <> *BLANKS  AND  #0REAC <> #0ACNO) OR
     C                             (#0MSGT <> *BLANKS  AND  #0MSGT <> #0MTPY) OR
     C                             (#0DEST <> *BLANKS  AND  #0DEST <> NXDSTN)
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Load subfile fields
 
     C                   EVAL      WFileToScrn = 'Y'
     C                   EXSR      SRMove
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR
 
     C                   IF        WSelectAll = 'Y'
     C                   EVAL      #0ACTN = 'X'
     C                   EVAL      *IN84 = *ON
     C                   ENDIF
     C                   WRITE     ME000051S0
 
     C                   ELSE
     C                   SUB       1             #0RLRN
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
     C                   EVAL      *IN30 = '0'
 
      ** Condition appropriate header and footer
 
     C                   SELECT
     C                   WHEN      WScreen = '1'
     C                   MOVEA     '100'         *IN(26)
 
     C                   WHEN      WScreen = '2'
     C                   MOVEA     '010'         *IN(26)
 
     C                   WHEN      WScreen = '3'
     C                   MOVEA     '001'         *IN(26)
     C                   ENDSL
 
     C                   IF        #WEACH = 'N'
     C                   EVAL      *IN30 = '1'
     C                   ENDIF
 
      ** Display screen
 
     C                   TIME                    #0TIME
     C                   WRITE     ME000051F0
     C                   WRITE     ME000051F2
     C                   WRITE     ME000051C1
 
     C                   IF        WScreen = '1'
     C                   EXFMT     ME000051C0
     C                   ELSE
     C                   IF        #WEACH = 'Y'
     C                   IF        #1MTPY = '950'
     C                   EVAL      *IN70 = *ON
     C                   ELSE
     C                   EVAL      *IN70 = *OFF
     C                   ENDIF
     C                   EXFMT     ME000051F1
     C                   ELSE
     C                   EXFMT     ME000051F3
     C                   ENDIF
     C                   ENDIF
 
      ** Reset error indicators
 
     C                   MOVEA     '000'         *IN(40)
     C                   MOVEA     '000000'      *IN(43)
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      #1PGMQ        PZPgmQ
     C                   PARM      '*SAME'       PZRelQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process Screen Input                             *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Selection field specified
 
     C                   IF        WZSELE <> WSelect
     C                   EVAL      WReload = 'Y'
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   EVAL      #0POS3 = *BLANKS
 
     C                   ELSE
 
      ** Change of position specified
 
     C                   IF        WZNWRK <> #0POS1  OR  WZACCT <> #0POS2  OR
     C                             WZDSTN <> #0POS3
     C                   EVAL      WReload = 'Y'
 
      ** Process subfile records if reload not requested
 
     C                   ELSE
 
     C                   EVAL      WError = 'N'
     C                   EVAL      WProcess = 'N'
     C                   EVAL      WSLCTR = 0
     C                   EXSR      SRVAction
 
      ** Process details according to action code.
 
     C                   IF        WError = 'N'  AND  WProcess = 'Y'
 
     C                   EXSR      SRPrompt
 
     C                   IF        *IN12 = *OFF
     C                   IF        #WEACH = 'Y'
     C                   EXSR      SRDetails
     C                   ELSE
     C                   EVAL      #3STDT = *ZEROS
     C                   EXSR      SRSubReq
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAction - Validate Action Codes                            *
      *                                                               *
      *****************************************************************
 
     C     SRVAction     BEGSR
 
      ** Process modified subfile record
 
     C                   READC     ME000051S0                             86
 
     C                   DOW       *IN86 = *OFF
 
     C                   EVAL      *IN40 = *OFF
 
      ** Action code must be 'X'
 
     C                   IF        #0ACTN <> 'X'  AND  #0ACTN <> *BLANK
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'ME00069'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** The network selected must be active
 
     C                   IF        #0ACTN = 'X'
     C     #0NWRK        CHAIN     GLNWKAPD
     C                   IF        NOT %FOUND(GLNWKAPD) OR MTSSTS <> 'A'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgID = 'ME00071'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Valid entry
 
     C                   EVAL      WProcess = 'Y'
     C                   ENDIF
 
     C                   EVAL      *IN84 = *ON
     C                   UPDATE    ME000051S0
     C                   EVAL      *IN84 = *OFF
 
     C                   READC     ME000051S0                             86
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetails - Process details                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDetails     BEGSR
 
      ** Process all modified subfile records
 
     C                   READC     ME000051S0                             86
 
     C                   DOW       *IN86 = *OFF
     C                   EVAL      WScreen = '2'
 
     C                   IF        #0ACTN = 'X'
 
      ** Retrieve file details
 
     C                   EXSR      SRRetrieve
 
      ** Process submit request
 
     C                   EXSR      SRSubReq
 
     C                   EVAL      #0ACTN = *BLANK
     C                   UPDATE    ME000051S0
     C                   ENDIF
 
     C                   READC     ME000051S0                             86
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetrieve - Retrieve record details                         *
      *                                                               *
      *****************************************************************
 
     C     SRRetrieve    BEGSR
 
      ** Set up key fields.
 
     C                   MOVE      #0NWRK        KNetwork
     C                   MOVE      WBranch2      KBranch
     C                   MOVE      WCustomer2    KCustomer
     C                   MOVE      WCurrency2    KCurrency
     C                   MOVE      WAcctCode2    KAcctCode
     C                   MOVE      WAcctSeqn2    KAcctSeqn
     C                   MOVE      #0NATY        KAcctType
     C                   MOVE      #0DSTN        KDestination
 
     C                   IF        #0MTPY = '940'
     C     KGLNW9X       CHAIN     GLNW9XI5
     C                   IF        %FOUND(GLNW9XI5)
     C                             AND N4G940 = 'Y'
     C                   EVAL      WFileToScrn = 'Y'
     C                   EXSR      SRMove
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0MTPY = '950'
     C     KGLNW9X       CHAIN     GLNW9XI5
     C                   IF        %FOUND(GLNW9XI5)
     C                             AND NAG950 = 'Y'
     C                   EVAL      WFileToScrn = 'Y'
     C                   EXSR      SRMove
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSubReq - Process submit request                            *
      *                                                               *
      *****************************************************************
 
     C     SRSubReq      BEGSR
 
     C                   EVAL      WScreen = '2'
     C                   EVAL      WLoop = 'Y'
     C                   EVAL      WReload = 'Y'
 
      ** Display details screen.
 
     C                   DOW       WScreen = '2'  OR  WScreen = '3'
 
     C                   EXSR      SRDisplay
 
      ** Process response.
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN08         CASEQ     '1'           SRWrite
 
     C     *IN12         CASEQ     '1'           SRPrevious
 
     C                   CAS                     SRValidate
     C                   ENDCS
 
      ** Create 'MANUAL' request record.
 
     C                   IF        *IN12 = *OFF  AND  WScreen = '2'  AND
     C                             WValid = 'Y'
     C                   EVAL      WScreen = '3'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite - Add 'MANUAL' request record in GLMR94PD            *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   IF        #WEACH = 'Y'
 
     C     NXNWRK        CHAIN     SDNWRKI0
 
     C                   IF        (NOT %FOUND(SDNWRKI0))
     C                                         OR
     C                             (#1MTPY = '940' AND EDP940 <> 'Y')
     C                                         OR
     C                             (#1MTPY = '950' AND EDP950 <> 'Y')
     C                   MOVEL     'ME00065'     PZMsgID
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Add record
 
     C                   EVAL      WFileToScrn = 'N'
     C                   EXSR      SRMove
     C                   WRITE     GLMR94D0
     C                   WRITE     GLMR94X0
     C                   COMMIT
 
      ** Send a 'C' to data queue GLM94XDQ
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    PDataQueue
     C                   PARM                    PLibrary
     C                   PARM                    PDataLength
     C                   PARM                    PData
 
     C                   EVAL      WScreen = '1'
     C                   ENDIF
 
     C                   ELSE
 
     C                   EXSR      SRWrite2
     C                   EVAL      WScreen = '1'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate details                                *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
     C                   IF        WScreen = '2'
 
     C                   EVAL      WValid = 'Y'
 
     C                   IF        #WEACH = 'Y'
     C                   EXSR      SRVStmtDate
     C                   EXSR      SRVField21
     C                   EXSR      SRVField86
     C                   ELSE
     C                   EXSR      SRVStmtDate2
     C                   ENDIF
 
     C                   IF        WValid = 'Y' and #WEACH = 'N'
     C                   EVAL      PZMsgID = 'ME00276'
     C                   MOVE      i             wRequested
     C                   MOVE      j             wValidated
     C                   EVAL      PZMsgData = wMsgData
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWrite2 - Add 'MANUAL' request record in GLMR94PD           *
      *                                                               *
      *****************************************************************
 
     C     SRWrite2      BEGSR
 
      ** Process all modified subfile records
 
     C                   READC     ME000051S0                             86
 
     C                   DOW       *IN86 = *OFF
 
     C                   IF        #0ACTN = 'X'
 
     C                   EVAL      wSkip = 'N'
      *
      ** Convert Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      #0LSDM        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      wLASD  = Pddmmyy
     C                   EVAL      wLastStDt = %DATE(wLASD:*DMY)
 
     C                   IF        #0ALLOW = 'Y'
     C                             And wStmtDate < wLastStDt
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
 
     C                   IF        #0ALLOW = 'N'
     C                             And wStmtDate <= wLastStDt
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
 
     C                   IF        #0MTPY = '940'
     C     KGLNW9X       CHAIN     GLNW94L3
     C                   IF        %FOUND(GLNW94L3)
      *
      ** Convert MT940 Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      N41LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      w941LastStDt  = %DATE(Pddmmyy:*DMY)
     C                   ENDIF
 
     C     KGLNW9X       CHAIN     GLNW94L4
     C                   IF        %FOUND(GLNW94L4)
      *
      ** Convert MT940 Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      N42LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      w942LastStDt  = %DATE(Pddmmyy:*DMY)
     C                   ENDIF
 
     C                   IF        wStmtDate < w941LastStDt
     C                             OR wStmtDate < w942LastStDt
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ENDSMN > 0 AND
     C                             wStmtDate <= (wRunDate - %DAYS(ENDSMN))
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
 
     C                   EVAL      *IN84 = *ON
 
     C                   IF        WSkip = 'N'
     C                   EVAL      WFileToScrn = 'N'
     C                   EXSR      SRMove
     C                   WRITE     GLMR94D0
     C                   WRITE     GLMR94X0
     C                   COMMIT
 
      ** Send a 'C' to data queue GLM94XDQ
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    PDataQueue
     C                   PARM                    PLibrary
     C                   PARM                    PDataLength
     C                   PARM                    PData
 
     C                   EVAL      #0ACTN = *BLANK
     C                   ENDIF
     C                   UPDATE    ME000051S0
 
     C                   ENDIF
 
     C                   READC     ME000051S0                             86
     C                   ENDDO
 
     C                   EVAL      WReload = 'N'
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVStmtDate - Validate Statement Date                        *
      *                                                               *
      *****************************************************************
 
     C     SRVStmtDate   BEGSR
 
      ** Statement date is mandatory and must be greater than
      ** last statement date and less than or equal to run day number
 
     C                   EVAL      PZMsgID = *BLANKS
 
     C                   IF        #1STDT = *BLANKS
 
     C                   EVAL      PZMsgID = 'ME00270'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    #1STDT
     C                   PARM      *ZEROS        PMidasDayNo
     C                   PARM      'D'           PDatefmt
     C                   PARM      *BLANKS       PZErr
 
     C                   IF        PZErr <> 'N'
 
     C                   EVAL      PZMsgID = 'MEM1015'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   EVAL      wM1STMDT = PMidasDayNo
 
     C                   MOVE      #1STDT        wSTDT             6 0
     C                   MOVE      #1LASD        wLASD             6 0
     C                   EVAL      wStmtDate = %DATE(wSTDT:*DMY)
     C                   EVAL      wLastStDt = %DATE(wLASD:*DMY)
     C                   EVAL      wRunDate  = %DATE(PRunDate:*DMY)
     C                   EVAL      wTmpDate = wRunDate - %DAYS(ENDSMN)
 
     C                   IF        #1ALLOW = 'Y'
     C                             And wStmtDate < wLastStDt
     C                   EVAL      PZMsgID = 'ME00271'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #1ALLOW = 'N'
     C                             And wStmtDate <= wLastStDt
     C                   EVAL      PZMsgID = 'ME00272'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        wStmtDate > wRunDate
     C                   EVAL      PZMsgID = 'ME00273'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        #1MTPY = '940'
     C     KGLNW9X       CHAIN     GLNW94L3
     C                   IF        %FOUND(GLNW94L3)
      *
      ** Convert MT940 Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      N41LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      w941LastStDt  = %DATE(Pddmmyy:*DMY)
     C                   ENDIF
 
     C     KGLNW9X       CHAIN     GLNW94L4
     C                   IF        %FOUND(GLNW94L4)
      *
      ** Convert MT940 Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      N42LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      w942LastStDt  = %DATE(Pddmmyy:*DMY)
     C                   ENDIF
 
     C                   IF        wStmtDate < w941LastStDt
     C                             OR wStmtDate < w942LastStDt
     C                   EVAL      PZMsgID = 'ME00274'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ENDSMN > 0 AND
     C                             wStmtDate <= (wRunDate - %DAYS(ENDSMN))
     C                   EVAL      PZMsgID = 'ME00275'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRVStmtDate2 - Validate Statement Date                       *
      *                                                               *
      *****************************************************************
 
     C     SRVStmtDate2  BEGSR
 
      ** Statement date is mandatory and must be
      ** greater than today's date
 
     C                   EVAL      PZMsgID = *BLANKS
 
     C                   IF        #3STDT = *BLANKS
 
     C                   EVAL      PZMsgID = 'ME00270'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    #3STDT
     C                   PARM      *ZEROS        PMidasDayNo
     C                   PARM      'D'           PDatefmt
     C                   PARM      *BLANKS       PZErr
 
     C                   IF        PZErr <> 'N'
 
     C                   EVAL      PZMsgID = 'MEM1015'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   EVAL      wM1STMDT = PMidasDayNo
 
     C                   MOVE      #3STDT        wSTDT             6 0
     C                   EVAL      wStmtDate = %DATE(wSTDT:*DMY)
     C                   EVAL      wRunDate  = %DATE(PRunDate:*DMY)
     C                   EVAL      wTmpDate = wRunDate - %DAYS(ENDSMN)
 
     C                   IF        wStmtDate > wRunDate
     C                   EVAL      PZMsgID = 'ME00273'
     C                   EVAL      *IN43 = *ON
     C                   EVAL      WValid = 'N'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   If        WValid <> 'N'
 
      * Start analyzing if the selected records if okay for message production,
      * but only if no error is encountered when entering the statement date.
 
     C                   EVAL      i = 0
     C                   EVAL      j = 0
 
     C                   READC     ME000051S0                             86
     C                   DOW       *IN86 = *OFF
     C                   IF        #0ACTN = 'X'
     C                   EVAL      i = i + 1
     C                   EVAL      WSkip = 'N'
      *
      ** Convert Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      #0LSDM        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      wLASD  = Pddmmyy
     C                   EVAL      wLastStDt = %DATE(wLASD:*DMY)
 
     C                   IF        #0ALLOW = 'Y'
     C                             And wStmtDate < wLastStDt
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
 
     C                   IF        #0ALLOW = 'N'
     C                             And wStmtDate <= wLastStDt
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
 
     C                   IF        #0MTPY = '940'
     C     KGLNW9X       CHAIN     GLNW94L3
     C                   IF        %FOUND(GLNW94L3)
      *
      ** Convert MT940 Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      N41LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      w941LastStDt  = %DATE(Pddmmyy:*DMY)
     C                   ENDIF
 
     C     KGLNW9X       CHAIN     GLNW94L4
     C                   IF        %FOUND(GLNW94L4)
      *
      ** Convert MT940 Last Statement Date to DDMMYY
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      N42LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   EVAL      w942LastStDt  = %DATE(Pddmmyy:*DMY)
     C                   ENDIF
 
     C                   IF        wStmtDate < w941LastStDt
     C                             OR wStmtDate < w942LastStDt
     C                   EVAL      wSkip = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ENDSMN > 0 AND
     C                             wStmtDate <= (wRunDate - %DAYS(ENDSMN))
     C                   EVAL      wSkip = 'Y'
 
     C                   ENDIF
 
     C                   EVAL      *IN84 = *ON
     C                   IF        wSkip = 'Y'
     C*                  EVAL      #0ACTN = *BLANK
     C                   ELSE
     C                   Eval      j = j + 1
     C                   ENDIF
     C                   UPDATE    ME000051S0
 
     C                   ENDIF
     C                   READC     ME000051S0                             86
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRPrompt - Produce Message with/wihtout individual prompt    *
      *                                                               *
      *****************************************************************
 
     C     SRPrompt      BEGSR
 
     C                   EVAL      #WEACH = ' '
     C                   EXFMT     ME000051W0
     C                   EVAL      WSelectAll = 'N'
     C                   EVAL      WSFPG = 5
 
     C                   ENDSR
 
      *****************************************************************
 
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVField21 - Validate Field 21: Related Reference            *
      *                                                               *
      *****************************************************************
 
     C     SRVField21    BEGSR
 
      ** The field can only contain characters allowed by the X SWIFT
      ** character set
 
     C                   IF        #1RREF <> *BLANKS
 
     C     SWIFTchars    CHECK     #1RREF                                 99
 
     C                   IF        *IN99 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgID = 'ME00067'
     C                   EXSR      SRZasnms
                                                                                            MD023480
     C                   ELSE                                                               MD023480
     C     1             SUBST     #1RREF        ##POS1            1                        MD023480
     C     ##POS1        IFEQ      '/'                                                      MD023480
     C                   EVAL      *IN42 = *ON                                              MD023480
     C                   EVAL      WValid = 'N'                                             MD023480
     C                   EVAL      PZMSGID = 'ME00277'                                      MD023480
     C                   EXSR      SRZasnms                                                 MD023480
     C                   ENDIF                                                              MD023480
                                                                                            MD023480
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRVField86 - Validate Field 86: Infos to the Account Owner   *
      *                                                               *
      *****************************************************************
 
     C     SRVField86    BEGSR
 
      ** Information to Account Owner 1
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        #1MIO1 = *Blanks AND
     C                             (#1MIO2 <> *Blanks OR #1MIO3 <> *Blanks OR
     C                              #1MIO4 <> *Blanks OR #1MIO5 <> *Blanks OR
     C                              #1MIO6 <> *Blanks)
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN44
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO1 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO1:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              MOVE      *On           *IN44
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN44
     C                   EXSR      SRZasnms
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Information to Account Owner 1
 
      ** Information to Account Owner 2
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        #1MIO2 = *Blanks AND
     C                             (#1MIO3 <> *Blanks OR #1MIO4 <> *Blanks OR
     C                              #1MIO5 <> *Blanks OR #1MIO6 <> *Blanks)
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN45
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO2 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO2:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              MOVE      *On           *IN45
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN45
     C                   EXSR      SRZasnms
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Information to Account Owner 2
 
      ** Information to Account Owner 3
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        #1MIO3 = *Blanks AND
     C                             (#1MIO4 <> *Blanks OR #1MIO5 <> *Blanks OR
     C                              #1MIO6 <> *Blanks)
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN46
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO3 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO3:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              MOVE      *On           *IN46
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN46
     C                   EXSR      SRZasnms
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Default Information to Account Owner 3
 
      ** Information to Account Owner 4
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        #1MIO4 = *Blanks AND
     C                             (#1MIO5 <> *Blanks OR #1MIO6 <> *Blanks)
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN47
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO4 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO4:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              MOVE      *On           *IN47
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN47
     C                   EXSR      SRZasnms
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Information to Account Owner 4
 
      ** Information to Account Owner 5
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        #1MIO5 = *Blanks AND #1MIO6 <> *Blanks
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN48
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO5 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO5:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              MOVE      *On           *IN48
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN48
     C                   EXSR      SRZasnms
     C                   EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Information to Account Owner 5
 
      ** Information to Account Owner 6
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO6 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO6:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              EXSR      SRZasnms
     C   99              MOVE      *On           *IN49
     C   99              EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Information to Account Owner 6
 
     C                   ENDSR
 
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefresh - Refresh subfile                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRefresh     BEGSR
 
     C                   EVAL      #0ACTN = *BLANK
     C                   EVAL      WSelect = *BLANKS
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   EVAL      #0POS3 = *BLANKS
     C                   EVAL      WReload = 'Y'
     C                   EVAL      WSelectAll = 'N'
     C                   EVAL      WSFPG = 5
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrScrn - Clear subfile fields                             *
      *                                                               *
      *****************************************************************
 
     C     SRClrScrn     BEGSR
 
      ** Clear subfile fields
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0NATY = *BLANK
     C                   EVAL      #0NWRK = *BLANKS
     C                   EVAL      #0ACCT = *BLANKS
     C                   EVAL      #0ACNO = *BLANKS
     C                   EVAL      #0ANAM = *BLANKS
     C                   EVAL      #0DSTN = *BLANKS
     C                   EVAL      #0MTPY = *BLANKS
     C                   EVAL      #0LASD = *BLANKS
     C                   EVAL      #0LAST = *BLANKS
     C                   EVAL      #0LASP = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMove - Move fields from file to screen and vice-versa      *
      *                                                               *
      *****************************************************************
 
     C     SRMove        BEGSR
 
      ** Move file fields to subfile
 
     C                   IF        WScreen = '1'
     C                   EVAL      #0NWRK = NXNWRK
     C                   MOVE      NXCNUM        WkCNUM
     C                   MOVE      NXACOD        WkACCD
     C                   MOVE      NXACSQ        WkACSQ
     C                   EVAL      #0ACCT = NXBRCA + WkCNUM + NXCCY +
     C                                      WkACCD + WkACSQ
     C                   EVAL      #0DSTN = NXDSTN
     C                   EVAL      #0NATY = NXNATY
 
     C                   ELSE
 
      ** Move file fields to details screen
 
     C                   IF        WFileToScrn = 'Y'
     C                   EVAL      #1NWRK = NXNWRK
     C                   MOVE      NXCNUM        WkCNUM
     C                   MOVE      NXACOD        WkACCD
     C                   MOVE      NXACSQ        WkACSQ
     C                   EVAL      #1ACCT = NXBRCA + ' ' + WkCNUM + ' ' +
     C                                      NXCCY  + ' ' + WkACCD + ' ' +
     C                                      WkACSQ
     C                   EVAL      #1ACNO = #0ACNO
     C                   EVAL      #1ANAM = #0ANAM
     C                   EVAL      #1NATY = #0NATY
     C                   EVAL      #1DSTN = NXDSTN
     C                   EVAL      #1STDT = *BLANKS
     C                   EVAL      #1RREF = *BLANKS
 
     C                   IF        #0MTPY = '940'
     C                   EVAL      #1MTPY = '940'
     C                   EVAL      #1ALLOW = #0ALLOW
     C                   CALLB     'ZDATE2'
     C                   PARM      N40LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   MOVE      Pddmmyy       #1LASD
     C                   EVAL      #1MSGT = 'MT940'
     C                   EVAL      *IN29 = *ON
     C                   EVAL      #1MIO1 = N40MI1
     C                   EVAL      #1MIO2 = N40MI2
     C                   EVAL      #1MIO3 = N40MI3
     C                   EVAL      #1MIO4 = N40MI4
     C                   EVAL      #1MIO5 = N40MI5
     C                   EVAL      #1MIO6 = N40MI6
     C                   ENDIF
 
     C                   IF        #0MTPY = '950'
     C                   EVAL      #1MTPY = '950'
     C                   EVAL      #1ALLOW = #0ALLOW
     C                   CALLB     'ZDATE2'
     C                   PARM      NA5LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   MOVE      Pddmmyy       #1LASD
     C                   EVAL      #1MSGT = 'MT950'
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      #1MIO1 = *BLANKS
     C                   EVAL      #1MIO2 = *BLANKS
     C                   EVAL      #1MIO3 = *BLANKS
     C                   EVAL      #1MIO4 = *BLANKS
     C                   EVAL      #1MIO5 = *BLANKS
     C                   EVAL      #1MIO6 = *BLANKS
     C                   ENDIF
 
      ** Move field values from screen to file.
 
     C                   ELSE
 
     C                   IF        #WEACH = 'Y'
 
     C                   EVAL      MRNWRK = NXNWRK
     C                   EVAL      MRBRCA = NXBRCA
     C                   EVAL      MRCNUM = NXCNUM
     C                   EVAL      MRCCY  = NXCCY
     C                   EVAL      MRACCD = NXACOD
     C                   EVAL      MRACSQ = NXACSQ
     C                   EVAL      MRNATY = NXNATY
     C                   EVAL      MRDSTN = NXDSTN
     C                   EVAL      MRMTPY = #1MTPY
     C                   IF        #1MTPY = '950'
     C                   EVAL      MRDSTN = *BLANKS
     C                   ENDIF
     C                   EVAL      MRSORQ = 'MANUAL'
     C                   EVAL      MRSDTE = BJRDNB
     C                   TIME                    WKSTIM
     C                   MOVEL     WKSTIM        MRSTIM
     C                   EVAL      MRRDTE = BJRDNB
     C                   EVAL      MRSRTIM = 'IMED'
     C                   EVAL      MRSTAT = 'WAITING'
     C                   EVAL      MRMGDT = *ZERO
     C                   EVAL      MRMGTM = *ZERO
     C                   EVAL      MRRREF = #1RREF
     C                   EVAL      MRMIO1 = #1MIO1
     C                   EVAL      MRMIO2 = #1MIO2
     C                   EVAL      MRMIO3 = #1MIO3
     C                   EVAL      MRMIO4 = #1MIO4
     C                   EVAL      MRMIO5 = #1MIO5
     C                   EVAL      MRMIO6 = #1MIO6
     C                   EVAL      MRRNWK = NXNWRK
 
     C                   ELSE
 
     C                   EVAL      MRNWRK = #0NWRK
     C                   EVAL      MRBRCA = %SUBST(#0ACCT:1:3)
     C                   EVAL      MRCNUM = %SUBST(#0ACCT:4:6)
     C                   EVAL      MRCCY  = %SUBST(#0ACCT:10:3)
     C                   EVAL      MRACCD = %DEC(%SUBST(#0ACCT:13:10):10:0)
     C                   EVAL      MRACSQ = %DEC(%SUBST(#0ACCT:23:2):2:0)
     C                   EVAL      MRNATY = #0NATY
     C                   EVAL      MRDSTN = #0DSTN
     C                   EVAL      MRMTPY = #0MTPY
     C                   IF        MRMTPY = '950'
     C                   EVAL      MRDSTN = *BLANKS
     C                   ENDIF
     C                   EVAL      MRSORQ = 'MANUAL'
     C                   EVAL      MRSDTE = BJRDNB
     C                   TIME                    WKSTIM
     C                   MOVEL     WKSTIM        MRSTIM
     C                   EVAL      MRRDTE = BJRDNB
     C                   EVAL      MRSRTIM = 'IMED'
     C                   EVAL      MRSTAT = 'WAITING'
     C                   EVAL      MRMGDT = *ZERO
     C                   EVAL      MRMGTM = *ZERO
     C                   EVAL      MRRREF = *BLANKS
     C                   EVAL      MRRNWK = #0NWRK
 
     C                   ENDIF
 
     C                   EVAL      M1NWRK = MRNWRK
     C                   EVAL      M1BRCA = MRBRCA
     C                   EVAL      M1CNUM = MRCNUM
     C                   EVAL      M1CCY  = MRCCY
     C                   EVAL      M1ACCD = MRACCD
     C                   EVAL      M1ACSQ = MRACSQ
     C                   EVAL      M1NATY = MRNATY
     C                   EVAL      M1DSTN = MRDSTN
     C                   EVAL      M1MTPY = MRMTPY
     C                   EVAL      M1SORQ = MRSORQ
     C                   EVAL      M1SDTE = MRSDTE
     C                   EVAL      M1STIM = MRSTIM
     C                   EVAL      M1RDTE = MRRDTE
     C                   EVAL      M1SRTIM = MRSRTIM
     C                   EVAL      M1STMDT = wM1STMDT
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgType - Set field values according to message type       *
      *                                                               *
      *****************************************************************
 
     C     SRMsgType     BEGSR
 
      ** Message type 940
 
     C                   IF        WOk940 = 'Y'
 
     C                   EVAL      #0MTPY = '940'
     C                   EVAL      #0ALLOW = EDA940
 
      ** Last statement date
 
     C                   EVAL      #0LSDM = N40LSD
 
     C                   IF        N40LSD <> 0
     C                   CALLB     'ZDATE2'
     C                   PARM      N40LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C     #0LASD        PARM      *BLANKS       PWorkDate
     C                   ENDIF
 
      ** Last statement time
 
     C                   IF        N40LST <> 0
     C                   MOVE      N40LST        WkLAST
     C                   EVAL      #0LAST = %SUBST(WkLAST:1:2) + ':' +
     C                                      %SUBST(WkLAST:3:2) + ':' +
     C                                      %SUBST(WkLAST:5:2)
     C                   ENDIF
 
      ** Last statement page
 
     C                   IF        N40LSN <> 0
     C                   MOVE      N40LSN        #0LASP
     C                   ENDIF
 
      ** Message type 950
 
     C                   ELSE
 
     C                   EVAL      #0MTPY = '950'
     C                   EVAL      #0ALLOW = EDA950
 
      ** Last statement date
 
     C                   EVAL      #0LSDM = NA5LSD
 
     C                   IF        NA5LSD <> 0
     C                   CALLB     'ZDATE2'
     C                   PARM      NA5LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C     #0LASD        PARM      *BLANKS       PWorkDate
     C                   ENDIF
 
      ** Last statement time
 
     C                   IF        NA5LST <> 0
     C                   MOVE      NA5LST        WkLAST
     C                   EVAL      #0LAST = %SUBST(WkLAST:1:2) + ':' +
     C                                      %SUBST(WkLAST:3:2) + ':' +
     C                                      %SUBST(WkLAST:5:2)
     C                   ENDIF
 
      ** Last statement page
 
     C                   IF        NA5LSN <> 0
     C                   MOVE      NA5LSN        #0LASP
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZasnms - Message Handling Subroutine                       *
      *                                                               *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
      ** Send message
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      #1PGMQ        PZPgmQ
     C                   PARM                    PZRelQ
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgData
     C                   PARM      *BLANKS       PZMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrevious - Display previous screen                          *
      *                                                               *
      *****************************************************************
 
     C     SRPrevious    BEGSR
 
     C                   IF        WScreen = '2'
     C                   EVAL      WScreen = '1'
     C                   EVAL      WLoop = 'N'
     C                   ENDIF
 
     C                   IF        WScreen = '3'
     C                   EVAL      WScreen = '2'
     C                   EVAL      WLoop = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREnd - End program                                          *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
     C     *LOCK         IN        GLM9XXDA
     C                   EVAL      MXPGMN = *BLANKS
     C                   EVAL      MXNETW = *BLANKS
     C                   EVAL      MXBRCA = *BLANKS
     C                   EVAL      MXCNUM = *BLANKS
     C                   EVAL      MXCCY  = *BLANKS
     C                   EVAL      MXACCD = *BLANKS
     C                   EVAL      MXACSQ = *BLANKS
     C                   EVAL      MXREAC = *BLANKS
     C                   EVAL      MXMSGT = *BLANKS
     C                   EVAL      MXDEST = *BLANKS
     C                   OUT       GLM9XXDA
 
      ** Rollback any uncommitted DBF changes
 
     C                   ROLBK
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRSelectAll - Select all, mark each subfile record with 'X'  *
      *                                                               *
      *****************************************************************
 
     C     SRSelectAll   BEGSR
 
      ** Evaluate WSelectAll with 'Y'
 
     C                   EVAL      WSelectAll = 'Y'
     C                   EVAL      WReload = 'Y'
     C                   EVAL      WSFPG = *HIVAL
     C                   EVAL      *IN06 = '0'
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SRToggle - Toggle                                            *
      *                                                               *
      *****************************************************************
 
     C     SRToggle      BEGSR
 
      ** Update GLM9XXDA data area
 
     C     *LOCK         IN        GLM9XXDA
     C                   EVAL      MXPGMN = 'ME000050  '
     C                   EVAL      MXNETW = #0NETW
     C                   EVAL      MXBRCA = #0BRCA
     C                   EVAL      MXCNUM = #0CNUM
     C                   EVAL      MXCCY  = #0CCY
     C                   EVAL      MXACCD = #0ACCD
     C                   EVAL      MXACSQ = #0ACSQ
     C                   EVAL      MXREAC = #0REAC
     C                   EVAL      MXMSGT = #0MSGT
     C                   EVAL      MXDEST = #0DEST
     C                   OUT       GLM9XXDA
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SROvrFil - Override with data area filter values             *
      *                                                               *
      *****************************************************************
 
     C     SROvrFil      BEGSR
 
      ** Retrieve data area values and default to screen control fields
 
     C                   IN        GLM9XXDA
     C                   If        MXPGMN <> *Blanks
     C                   EVAL      #0NETW = MXNETW
     C                   EVAL      #0BRCA = MXBRCA
     C                   EVAL      #0CNUM = MXCNUM
     C                   EVAL      #0CCY  = MXCCY
     C                   EVAL      #0ACCD = MXACCD
     C                   EVAL      #0ACSQ = MXACSQ
     C                   EVAL      #0REAC = MXREAC
     C                   EVAL      #0MSGT = MXMSGT
     C                   EVAL      #0DEST = MXDEST
     C                   EndIf
 
     C                   EVAL      WSelectAll = 'N'
     C                   EVAL      WSFPG = 5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoadNW9X - Load recordset to GLNW9XTD temporary table      *
      *                                                               *
      *****************************************************************
 
     C     SrLoadNW9X    BEGSR
 
     C/exec SQL
     C+ declare GLNW94RcdSet Scroll Cursor
     C+ for
     C+ select        N4NWRK as NXNWRK,
     C+               N4BRCA as NXBRCA,
     C+               N4CNUM as NXCNUM,
     C+               N4CCY  as NXCCY ,
     C+               N4ACCD as NXACOD,
     C+               N4ACSQ as NXACSQ,
     C+               N4NATY as NXNATY,
     C+               N4DSTN as NXDSTN,
     C+
     C+               N4G940 as N4G940,
     C+               N40SFR as N40SFR,
     C+               N40SDM as N40SDM,
     C+               N40NSD as N40NSD,
     C+               N40DSI as N40DSI,
     C+               N40MI1 as N40MI1,
     C+               N40MI2 as N40MI2,
     C+               N40MI3 as N40MI3,
     C+               N40MI4 as N40MI4,
     C+               N40MI5 as N40MI5,
     C+               N40MI6 as N40MI6,
     C+               N40LSD as N40LSD,
     C+               N40LST as N40LST,
     C+               N40LSN as N40LSN,
     C+               N40LCA as N40LCA,
     C+
     C+               ''     as NAG950,
     C+               ''     as NA5SFQ,
     C+               0      as NA5SDY,
     C+               0      as NA5NSD,
     C+               ''     as NA5DSI,
     C+               0      as NA5LCB,
     C+               0      as NA5LSD,
     C+               0      as NA5LST,
     C+               0      as NA5LSN
     C+
     C+  from glnw94pd
     C+  WHERE N4RECI = 'D'
     C+  order by
     C+    NXNWRK,
     C+    NXBRCA,
     C+    NXCNUM,
     C+    NXCCY ,
     C+    NXACOD,
     C+    NXACSQ,
     C+    NXNATY,
     C+    NXDSTN
     C/end-exec
 
     C/exec sql
     C+ open GLNW94RcdSet
     C/end-exec
 
     C
     C/exec SQL
     C+ fetch first
     C+ from GLNW94RcdSet
     C+ into :RecordSet
     C/end-exec
     C                   DOW       SQLCOD <> 100
     C                   Write     GLNW9XD0
     C/exec SQL
     C+ fetch next
     C+ from GLNW94RcdSet
     C+ into :RecordSet
     C/end-exec
     C                   Enddo
 
     C/exec sql
     C+ close GLNW94RcdSet
     C/end-exec
 
 
     C/exec SQL
     C+ declare GLNWACRcdSet Scroll Cursor
     C+ for
     C+ select        NANWRK as NXNWRK,
     C+               NABRCH as NXBRCA,
     C+               NACNUM as NXCNUM,
     C+               NACCY  as NXCCY ,
     C+               NAACOD as NXACOD,
     C+               NAACSQ as NXACSQ,
     C+               NANATY as NXNATY,
     C+               NACNUM as NXDSTN,
     C+
     C+               ''     as N4G940,
     C+               ''     as N40SFR,
     C+               0      as N40SDM,
     C+               0      as N40NSD,
     C+               ''     as N40DSI,
     C+               ''     as N40MI1,
     C+               ''     as N40MI2,
     C+               ''     as N40MI3,
     C+               ''     as N40MI4,
     C+               ''     as N40MI5,
     C+               ''     as N40MI6,
     C+               0      as N40LSD,
     C+               0      as N40LST,
     C+               0      as N40LSN,
     C+               0      as N40LCA,
     C+
     C+               NAG950 as NAG950,
     C+               NA5SFQ as NA5SFQ,
     C+               NA5SDY as NA5SDY,
     C+               NA5NSD as NA5NSD,
     C+               NA5DSI as NA5DSI,
     C+               NA5LCB as NA5LCB,
     C+               NA5LSD as NA5LSD,
     C+               NA5LST as NA5LST,
     C+               NA5LSN as NA5LSN
     C+
     C+  from glnwacpd
     C+  WHERE NARECI = 'D'
     C+  order by
     C+    NXNWRK,
     C+    NXBRCA,
     C+    NXCNUM,
     C+    NXCCY ,
     C+    NXACOD,
     C+    NXACSQ,
     C+    NXNATY,
     C+    NXDSTN
     C/end-exec
 
     C/exec sql
     C+ open GLNWACRcdSet
     C/end-exec
 
     C
     C/exec SQL
     C+ fetch first
     C+ from GLNWACRcdSet
     C+ into :RecordSet
     C/end-exec
     C                   DOW       SQLCOD <> 100
 
     C                   Eval      wkNAG950 = NAG950
     C                   Eval      wkNA5SFQ = NA5SFQ
     C                   Eval      wkNA5SDY = NA5SDY
     C                   Eval      wkNA5NSD = NA5NSD
     C                   Eval      wkNA5DSI = NA5DSI
     C                   Eval      wkNA5LCB = NA5LCB
     C                   Eval      wkNA5LSD = NA5LSD
     C                   Eval      wkNA5LST = NA5LST
     C                   Eval      wkNA5LSN = NA5LSN
 
     C                   Eval      KNetwork     = NXNWRK
     C                   Eval      KBranch      = NXBRCA
     C                   Eval      KCustomer    = NXCNUM
     C                   Eval      KCurrency    = NXCCY
     C                   Eval      KAcctCode    = NXACOD
     C                   Eval      KAcctSeqn    = NXACSQ
     C                   Eval      KAcctType    = NXNATY
     C                   Eval      KDestination = NXDSTN
 
     C     KGLNW9X       Chain     GLNW9XI5
 
     C                   If        %Found(GLNW9XI5)
 
     C                   Eval      NAG950 = wkNAG950
     C                   Eval      NA5SFQ = wkNA5SFQ
     C                   Eval      NA5SDY = wkNA5SDY
     C                   Eval      NA5NSD = wkNA5NSD
     C                   Eval      NA5DSI = wkNA5DSI
     C                   Eval      NA5LCB = wkNA5LCB
     C                   Eval      NA5LSD = wkNA5LSD
     C                   Eval      NA5LST = wkNA5LST
     C                   Eval      NA5LSN = wkNA5LSN
 
     C                   Update    GLNW9XD0
 
     C                   Else
 
     C                   Write     GLNW9XD0
 
     C                   EndIf
     C/exec SQL
     C+ fetch next
     C+ from GLNWACRcdSet
     C+ into :RecordSet
     C/end-exec
     C                   Enddo
 
     C/exec sql
     C+ close GLNWACRcdSet
     C/end-exec
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   EVAL      DBPGM = 'ME000051'
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert Run day number to Run Date
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C                   PARM      *BLANKS       PWorkDate
     C                   MOVE      Pddmmyy       PRunDate
      *
      ** Call Access Program for Message Management Details
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    PRtrnCode
     C                   PARM      '*FIRST  '    POption
     C     SDMGME        PARM      SDMGME        DSFDY
      *
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMGMEPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise subfile control
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #1PGMQ = PSProcName
 
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   EVAL      #0POS3 = *BLANKS
     C                   EVAL      WSFPG = 5
     C                   EVAL      PZMsgFile = 'MEMSG'
 
      ** Initialise QSNDDTAQ parameters
 
     C                   EVAL      PDataQueue = 'GLM94XDQ'
     C                   EVAL      PLibrary = '*LIBL'
     C                   EVAL      PDataLength = 1
     C                   EVAL      PData = 'C'
 
     C     KGLNW9X       KLIST
     C                   KFLD                    KNetwork
     C                   KFLD                    KBranch
     C                   KFLD                    KCustomer
     C                   KFLD                    KCurrency
     C                   KFLD                    KAcctCode
     C                   KFLD                    KAcctSeqn
     C                   KFLD                    KAcctType
     C                   KFLD                    KDestination
 
     C     KACCNT        KLIST
     C                   KFLD                    NXCNUM
     C                   KFLD                    NXCCY
     C                   KFLD                    NXACOD
     C                   KFLD                    NXACSQ
     C                   KFLD                    NXBRCA
 
     C                   Exsr      SRLoadNW9X
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
