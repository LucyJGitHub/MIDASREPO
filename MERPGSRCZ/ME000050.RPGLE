     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME MT94x Production on Request')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Messages Generation Module                           *
      *                                                               *
      *  ME000050 - MT94x Production on Request Maintenance           *
      *                                                               *
      *  Function:  This module enables the user to generate MT941    *
      *             and MT942 on manual request.                      *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD023017           Date 29Nov13               *
      *                 CGL146A            Date 10Jul13               *
      * Bank Fusion Midas 2.1 Base -----------------------------------*
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 25Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD023017 - Validation on Field 21.                           *
      *             Related Reference may not start with a slash and  *
      *             may not contain two consecutive slashes           *
      *  CGL146A - MT940/MT950 Production in Input Cycle              *
      *            Added hooks: CGL146_024, CGL146_098, CGL146_099    *
      *                         CGL146_100, CGL146_102, CGL146_110    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CAP204 - Teller Related APIs - Account Transfer (Recompile)  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         Screen 1 (subfile)                              *
      *    27         Screen 2 (details prompt)                       *
      *    28         Screen 3 (enable F8)                            *
      *    29         Header text (MT941/MT942)                       *
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
      *  QRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display screen                              *
      *  SRProcess     -  Process screen input                        *
      *  SRVAction     -  Validate action code                        *
      *  SRDetails     -  Set-up Details                              *
      *  SRRetrieve    -  Retrieve record details                     *
      *  SRInsert      -  Insert record                               *
      *  SRValidate    -  Validate details                            *
      *  SRVNetwork    -  Validate Network                            *
      *  SRVField21    -  Validate Related Reference                  *
      *  SRRefresh     -  Refresh subfile                             *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Move fields from file/screen to screen/file *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SRPrevious    -  Display previous screen                     *
      *  SREnd         -  End program                                 *
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

     FME000050DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(ME000050S0:#0RLRN)
      ** Midas ME MT94x Production on Request Maintenance Screen

     FGLNW94L5  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Network Accounts MT94x Details (Live Accounts)

     FGLNW94L3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D3)
      ** Midas GL Network Accounts MT94x Details (Live + Allow941)

     FGLNW94L4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLNW94D0:GLNW94D4)
      ** Midas GL Network Accounts MT94x Details (Live + Allow942)

     FGLMR94L0  UF A E           K DISK    INFSR(*PSSR)
     F*                                    COMMIT
      ** Midas GL MT941/942 Messages Requested (Update)

     FGLNWKAPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Network Activity Control File

     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
      ** Midas GL Account details

     FRSACMTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(RS_)
      ** Midas GL Account Movements file

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

     D GLM94XDA      E DS                  EXTNAME(GLM94XDA) DTAARA(GLM94XDA)
      ** Midas MT94x Background Job Data Area

     D/COPY OFCPYSRCZ,CGL146_098                                                             CGL146A

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** DS for selection fields
     D***WSelect         DS            48                                                     CGL029
     D WSelect         DS            54                                                       CGL029
     D   #0NETW                1      6
     D   #0BRCA                7      9
     D   #0CNUM               10     15
     D   #0CCY                16     18
     D***#0ACCD*              19     22                                                       CGL029
     D***#0ACSQ*              23     24                                                       CGL029
     D***#0REAC*              25     34                                                       CGL029
     D***#0MSGT*              35     37                                                       CGL029
     D***#0DEST*              38     48                                                       CGL029
     D   #0ACCD               19     28                                                       CGL029
     D   #0ACSQ               29     30                                                       CGL029
     D   #0REAC               31     40                                                       CGL029
     D   #0MSGT               41     43                                                       CGL029
     D   #0DEST               44     54                                                       CGL029

      ** DS for Account Number (position field)
     D #0POS2          DS
     D   WBranch1              1      3
     D   WCustomer1            4      9
     D   WCurrency1           10     12
     D***WAcctCode1           13     16                                                       CGL029
     D***WAcctSeqn1           17     18                                                       CGL029
     D   WAcctCode1           13     22                                                       CGL029
     D   WAcctSeqn1           23     24                                                       CGL029

      ** DS for Account Number (subfile field)
     D #0ACCT          DS
     D   WBranch2              1      3
     D   WCustomer2            4      9
     D   WCurrency2           10     12
     D***WAcctCode2           13     16                                                       CGL029
     D***WAcctSeqn2           17     18                                                       CGL029
     D   WAcctCode2           13     22                                                       CGL029
     D   WAcctSeqn2           23     24                                                       CGL029

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
     D*KCustomer       S              6  0                                                    CSD027
     D KCustomer       S              6A                                                      CSD027
     D KCurrency       S              3
     D***KAcctCode       S              4  0                                                  CGL029
     D KAcctCode       S             10  0                                                    CGL029
     D KAcctSeqn       S              2  0
     D KAcctType       S              1
     D KDestination    S             11

     D WkCNUM          S              6
     D***WkACCD*         S              4                                                     CGL029
     D WkACCD          S             10                                                       CGL029
     D WkACSQ          S              2
     D WkLAST          S              6
     D WOk941          S              1
     D WOk942          S              1
     D W941GNM         S              1
     D W942GNM         S              1
     D WRun            S              1
     D WReload         S              1
     D WLRCD           S              4  0
     D WError          S              1
     D WSLCTR          S              3  0
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D WSkipRec        S              1
     D WScreen         S              1
     D WFileToScrn     S              1
     D WValid          S              1
     D WLoop           S              1
     D WProcess        S              1
     D WZSELE          S             48
     D WZNWRK          S              6
     D***WZACCT*         S             18                                                     CGL029
     D WZACCT          S             24                                                       CGL029
     D WZDSTN          S             11
     D WKSTIM          S              6S 0

     D/COPY OFCPYSRCZ,CGL146_110                                                             CGL146A
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

     C/COPY OFCPYSRCZ,CGL146_099                                                             CGL146A

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

     C/COPY OFCPYSRCZ,CGL146_100                                                             CGL146A
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
     C                   WRITE     ME000050C0
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

     C     KGLNW94       SETLL     GLNW94D0                           82
     C                   READ      GLNW94D0                               82

      ** Save previous selector values

     C                   EVAL      WOk941 = 'N'
     C                   EVAL      WOk942 = 'N'
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
     C                   READP     GLNW94L5
     C                   READ      GLNW94L5
     C                   ENDIF

      ** Start at previous highest record in SFL

     C                   Z-ADD     WLRCD         #0RLRN
     C                   Z-ADD     1             WRCTR

      ** Load next subfile page

     C                   DOW       NOT %EOF(GLNW94L5)  AND  WRCTR <= WSFPG

      ** Clear subfile fields

     C                   EXSR      SRClrScrn

     C                   IF        WOk941 = 'N'
     C                   EVAL      WOk941 = 'Y'
     C                   IF        N4G941 = 'Y'  AND  N41AMR = 'Y'
     C                   EXSR      SRAddSflRec
     C                   ENDIF

     C                   ELSE
     C                   EVAL      WOk941 = 'N'
     C                   EVAL      WOk942 = 'Y'
     C                   IF        N4G942 = 'Y'  AND  N42AMR = 'Y'
     C                   EXSR      SRAddSflRec
     C                   ENDIF
     C                   ENDIF

     C                   IF        WOk942 = 'Y'
     C                   EVAL      WOk942 = 'N'
     C                   READ      GLNW94L5                               82
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
     C                   MOVE      N4CNUM        WkCNUM
     C                   MOVE      N4ACCD        WkACCD
     C                   MOVE      N4ACSQ        WkACSQ
     C                   EVAL      #0ACCT = N4BRCA + WkCNUM + N4CCY +
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

     C                   IF        (#0NETW <> *BLANKS  AND  #0NETW <> N4NWRK) OR
     C                             (#0BRCA <> *BLANKS  AND  #0BRCA <> N4BRCA) OR
     C                             (#0CNUM <> *BLANKS  AND  #0CNUM <> WkCNUM) OR
     C                             (#0CCY  <> *BLANKS  AND  #0CCY <> N4CCY)   OR
     C                             (#0ACCD <> *BLANKS  AND  #0ACCD <> WkACCD) OR
     C                             (#0ACSQ <> *BLANKS  AND  #0ACSQ <> WkACSQ) OR
     C                             (#0REAC <> *BLANKS  AND  #0REAC <> #0ACNO) OR
     C                             (#0MSGT <> *BLANKS  AND  #0MSGT <> #0MTPY) OR
     C                             (#0DEST <> *BLANKS  AND  #0DEST <> N4DSTN)
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF

     C                   IF        WSkipRec = 'N'

      ** Load subfile fields

     C                   EVAL      WFileToScrn = 'Y'
     C                   EXSR      SRMove

      ** Output to subfile

     C                   ADD       1             WRCTR

     C                   WRITE     ME000050S0

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

      ** Condition appropriate header and footer

     C                   SELECT
     C                   WHEN      WScreen = '1'
     C                   MOVEA     '100'         *IN(26)

     C                   WHEN      WScreen = '2'
     C                   MOVEA     '010'         *IN(26)

     C                   WHEN      WScreen = '3'
     C                   MOVEA     '001'         *IN(26)
     C                   ENDSL

      ** Display screen

     C                   TIME                    #0TIME
     C                   WRITE     ME000050F0
     C                   WRITE     ME000050F2
     C                   WRITE     ME000050C1

     C                   IF        WScreen = '1'
     C                   EXFMT     ME000050C0
     C                   ELSE
     C                   EXFMT     ME000050F1
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
     C                   EXSR      SRDetails
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

     C                   READC     ME000050S0                             86

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
     C                   UPDATE    ME000050S0
     C                   EVAL      *IN84 = *OFF

     C                   READC     ME000050S0                             86
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

     C                   READC     ME000050S0                             86

     C                   DOW       *IN86 = *OFF
     C                   EVAL      WScreen = '2'

     C                   IF        #0ACTN = 'X'

      ** Retrieve file details

     C                   EXSR      SRRetrieve

      ** Process submit request

     C                   EXSR      SRSubReq

     C                   EVAL      #0ACTN = *BLANK
     C                   UPDATE    ME000050S0
     C                   ENDIF

     C                   READC     ME000050S0                             86
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

     C                   IF        #0MTPY = '941'
     C     KGLNW94       CHAIN     GLNW94L3
     C                   IF        %FOUND(GLNW94L3)
     C                   EVAL      WFileToScrn = 'Y'
     C                   EXSR      SRMove
     C                   ENDIF
     C                   ENDIF

     C                   IF        #0MTPY = '942'
     C     KGLNW94       CHAIN     GLNW94L4
     C                   IF        %FOUND(GLNW94L4)
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

     C                   IN        GLM94XDA

     C                   IF        (#1MTPY = '941' AND MTM941 <> 'Y')
     C                                         OR
     C                             (#1MTPY = '942' AND MTM942 <> 'Y')
     C                   MOVEL     'ME00065'     PZMsgID
     C                   EXSR      SRZasnms

     C                   ELSE

      ** Add record

     C                   EVAL      WFileToScrn = 'N'
     C                   EXSR      SRMove
     C                   WRITE     GLMR94D0

      ** Activate MT941/MT942 generation if required
      ************
     C************       CALL      'GLC001410'
     C************       PARM      '*START'      POperation        6
     C************       PARM      *BLANKS       PMode             7
     C************       PARM      *BLANKS       PRtrnCode
      ************
     C*****PRtrnCode     IFNE      *BLANKS

      ** Send a 'C' to data queue GLM94XDQ

     C                   CALL      'QSNDDTAQ'
     C                   PARM                    PDataQueue
     C                   PARM                    PLibrary
     C                   PARM                    PDataLength
     C                   PARM                    PData

     C************       ENDIF

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
     C                   EXSR      SRVNetwork
     C                   EXSR      SRVField21
     C                   EXSR      SRVField86

     C                   IF        WValid = 'Y'

     C     KRSACMT       CHAIN     RSACMTL1

     C                   IF        NOT %FOUND(RSACMTL1)  AND
     C                             ((#1MTPY = '941' AND W941GNM = 'N') OR
     C                              (#1MTPY = '942' AND W942GNM = 'N'))
     C                   MOVEL     'ME00068'     PZMsgID
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVNetwork - Validate network                                *
      *                                                               *
      *****************************************************************

     C     SRVNetwork    BEGSR

      ** Network entry is mandatory.

     C                   IF        #1NETW = *BLANKS

     C                   EVAL      *IN41 = *ON
     C                   EVAL      WValid = 'N'
     C                   MOVEL     'ME00065'     PZMsgID
     C                   EXSR      SRZasnms

     C                   ELSE

      ** Network must be a live existing one.

     C                   EVAL      KNetwork = #1NETW

     C                   IF        #1MTPY = '941'
     C     KGLNW94       CHAIN     GLNW94L3
     C                   IF        NOT %FOUND(GLNW94L3)
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WValid = 'N'
     C                   MOVEL     'ME00066'     PZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      W941GNM = N41GNM
     C                   ENDIF
     C                   ENDIF

     C                   IF        #1MTPY = '942'
     C     KGLNW94       CHAIN     GLNW94L4
     C                   IF        NOT %FOUND(GLNW94L4)
     C                   EVAL      *IN41 = *ON
     C                   EVAL      WValid = 'N'
     C                   MOVEL     'ME00066'     PZMsgID
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      W942GNM = N42GNM
     C                   ENDIF
     C                   ENDIF

     C                   IF        WValid = 'Y'     AND #1MIO1 = *BLANKS AND
     C                             #1MIO2 = *BLANKS AND #1MIO3 = *BLANKS AND
     C                             #1MIO4 = *BLANKS AND #1MIO5 = *BLANKS AND
     C                             #1MIO6 = *BLANKS
     C                   IF        #1MTPY = '941'
     C                   EVAL      #1MIO1 = N41MI1
     C                   EVAL      #1MIO2 = N41MI2
     C                   EVAL      #1MIO3 = N41MI3
     C                   EVAL      #1MIO4 = N41MI4
     C                   EVAL      #1MIO5 = N41MI5
     C                   EVAL      #1MIO6 = N41MI6

     C                   ELSE
     C                   EVAL      #1MIO1 = N42MI1
     C                   EVAL      #1MIO2 = N42MI2
     C                   EVAL      #1MIO3 = N42MI3
     C                   EVAL      #1MIO4 = N42MI4
     C                   EVAL      #1MIO5 = N42MI5
     C                   EVAL      #1MIO6 = N42MI6
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

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
                                                                                            MD023017
     C                   ELSE                                                               MD023017
     C     1             SUBST     #1RREF        ##POS1            1                        MD023017
     C     ##POS1        IFEQ      '/'                                                      MD023017
     C                   EVAL      *IN42 = *ON                                              MD023017
     C                   EVAL      WValid = 'N'                                             MD023017
     C                   EVAL      PZMSGID = 'ME00277'                                      MD023017
     C                   EXSR      SRZasnms                                                 MD023017
     C                   ENDIF                                                              MD023017
                                                                                            MD023017
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
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
     C                   MOVE      *On           *IN43
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO1 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO1:1                               99
     C   99              MOVE      'ME00059'     PZMsgID
     C   99              MOVE      *On           *IN43
     C                   ENDIF
      *
      ** -- If an error was found
      *
     C                   IF        *IN43
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
     C                   MOVE      *On           *IN44
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO2 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO2:1                               99
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
      ** End Information to Account Owner 2

      ** Information to Account Owner 3
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        #1MIO3 = *Blanks AND
     C                             (#1MIO4 <> *Blanks OR #1MIO5 <> *Blanks OR
     C                              #1MIO6 <> *Blanks)
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN45
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO3 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO3:1                               99
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
      ** End Default Information to Account Owner 3

      ** Information to Account Owner 4
      *
      ** -- The field can't be blank if one the following is filled
      *
     C                   IF        #1MIO4 = *Blanks AND
     C                             (#1MIO5 <> *Blanks OR #1MIO6 <> *Blanks)
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN46
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO4 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO4:1                               99
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
      ** End Information to Account Owner 4

      ** Information to Account Owner 5
      *
      ** -- The field can't be blank if the following is filled
      *
     C                   IF        #1MIO5 = *Blanks AND #1MIO6 <> *Blanks
     C                   MOVE      'ME00058'     PZMsgID
     C                   MOVE      *On           *IN47
     C                   ENDIF
      *
      ** -- The field can only contain characters allowed by the X SWIFT
      **    character set
      *
     C                   IF        #1MIO5 <> *Blanks
     C     SWIFTchars    CHECK     #1MIO5:1                               99
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
     C   99              MOVE      *On           *IN48
     C   99              EVAL      WValid = 'N'
     C                   ENDIF
      *
      ** End Information to Account Owner 6

     C                   ENDSR

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
     C                   EVAL      #0NWRK = N4NWRK
     C                   MOVE      N4CNUM        WkCNUM
     C                   MOVE      N4ACCD        WkACCD
     C                   MOVE      N4ACSQ        WkACSQ
     C                   EVAL      #0ACCT = N4BRCA + WkCNUM + N4CCY +
     C                                      WkACCD + WkACSQ
     C                   EVAL      #0DSTN = N4DSTN
     C                   EVAL      #0NATY = N4NATY

     C                   ELSE

      ** Move file fields to details screen

     C                   IF        WFileToScrn = 'Y'
     C                   EVAL      #1NWRK = N4NWRK
     C                   MOVE      N4CNUM        WkCNUM
     C                   MOVE      N4ACCD        WkACCD
     C                   MOVE      N4ACSQ        WkACSQ
     C                   EVAL      #1ACCT = N4BRCA + ' ' + WkCNUM + ' ' +
     C                                      N4CCY  + ' ' + WkACCD + ' ' +
     C                                      WkACSQ
     C                   EVAL      #1ACNO = #0ACNO
     C                   EVAL      #1ANAM = #0ANAM
     C                   EVAL      #1NATY = #0NATY
     C                   EVAL      #1DSTN = N4DSTN
     C                   EVAL      #1NETW = N4NWRK
     C                   EVAL      #1RREF = *BLANKS

     C                   IF        #0MTPY = '941'
     C                   EVAL      #1MTPY = '941'
     C                   EVAL      #1MIO1 = N41MI1
     C                   EVAL      #1MIO2 = N41MI2
     C                   EVAL      #1MIO3 = N41MI3
     C                   EVAL      #1MIO4 = N41MI4
     C                   EVAL      #1MIO5 = N41MI5
     C                   EVAL      #1MIO6 = N41MI6
     C                   EVAL      W941GNM = N41GNM
     C                   EVAL      *IN29 = *ON
     C                   ENDIF

     C                   IF        #0MTPY = '942'
     C                   EVAL      #1MTPY = '942'
     C                   EVAL      #1MIO1 = N42MI1
     C                   EVAL      #1MIO2 = N42MI2
     C                   EVAL      #1MIO3 = N42MI3
     C                   EVAL      #1MIO4 = N42MI4
     C                   EVAL      #1MIO5 = N42MI5
     C                   EVAL      #1MIO6 = N42MI6
     C                   EVAL      W942GNM = N42GNM
     C                   EVAL      *IN29 = *OFF
     C                   ENDIF

      ** Move field values from screen to file.

     C                   ELSE

     C                   EVAL      MRNWRK = N4NWRK
     C                   EVAL      MRBRCA = N4BRCA
     C                   EVAL      MRCNUM = N4CNUM
     C                   EVAL      MRCCY  = N4CCY
     C                   EVAL      MRACCD = N4ACCD
     C                   EVAL      MRACSQ = N4ACSQ
     C                   EVAL      MRNATY = N4NATY
     C                   EVAL      MRDSTN = N4DSTN
     C                   EVAL      MRMTPY = #1MTPY
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
     C                   EVAL      MRRNWK = #1NETW
     C                   EVAL      MRMIO1 = #1MIO1
     C                   EVAL      MRMIO2 = #1MIO2
     C                   EVAL      MRMIO3 = #1MIO3
     C                   EVAL      MRMIO4 = #1MIO4
     C                   EVAL      MRMIO5 = #1MIO5
     C                   EVAL      MRMIO6 = #1MIO6
     C                   IF        #1MTPY = '942'
     C                   EVAL      MR2FLC = N42FLC
     C                   EVAL      MR2FLD = N42FLD
     C                   ELSE
     C                   EVAL      MR2FLC = *ZERO
     C                   EVAL      MR2FLD = *ZERO
     C                   ENDIF
     C                   EVAL      MRFL25 = *BLANKS

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

      ** Message type 941

     C                   IF        WOk941 = 'Y'

     C                   EVAL      #0MTPY = '941'

      ** Last statement date

     C                   IF        N41LSD <> 0
     C                   CALLB     'ZDATE2'
     C                   PARM      N41LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C     #0LASD        PARM      *BLANKS       PWorkDate
     C                   ENDIF

      ** Last statement time

     C                   IF        N41LST <> 0
     C                   MOVE      N41LST        WkLAST
     C                   EVAL      #0LAST = %SUBST(WkLAST:1:2) + ':' +
     C                                      %SUBST(WkLAST:3:2) + ':' +
     C                                      %SUBST(WkLAST:5:2)
     C                   ENDIF

      ** Last statement page

     C                   IF        N41LSP <> 0
     C                   MOVE      N41LSP        #0LASP
     C                   ENDIF

      ** Message type 942

     C                   ELSE

     C                   EVAL      #0MTPY = '942'

      ** Last statement date

     C                   IF        N42LSD <> 0
     C                   CALLB     'ZDATE2'
     C                   PARM      N42LSD        PMidasDayNo
     C                   PARM      *BLANK        PDateFmt
     C                   PARM      *ZERO         Pddmmyy
     C     #0LASD        PARM      *BLANKS       PWorkDate
     C                   ENDIF

      ** Last statement time

     C                   IF        N42LST <> 0
     C                   MOVE      N42LST        WkLAST
     C                   EVAL      #0LAST = %SUBST(WkLAST:1:2) + ':' +
     C                                      %SUBST(WkLAST:3:2) + ':' +
     C                                      %SUBST(WkLAST:5:2)
     C                   ENDIF

      ** Last statement page

     C                   IF        N42LSP <> 0
     C                   MOVE      N42LSP        #0LASP
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
     C/COPY OFCPYSRCZ,CGL146_101                                                             CGL146A

      ** Rollback any uncommitted DBF changes

     C*                  ROLBK

      ** Terminate program

     C                   EVAL      *INLR = *ON

      ** Exit program

     C                   RETURN

     C                   ENDSR
     C/COPY OFCPYSRCZ,CGL146_102                                                             CGL146A

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR
     C/COPY OFCPYSRCZ,CGL146_024                                                             CGL146A

     C                   EVAL      DBPGM = 'ME000050'

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

     C     KGLNW94       KLIST
     C                   KFLD                    KNetwork
     C                   KFLD                    KBranch
     C                   KFLD                    KCustomer
     C                   KFLD                    KCurrency
     C                   KFLD                    KAcctCode
     C                   KFLD                    KAcctSeqn
     C                   KFLD                    KAcctType
     C                   KFLD                    KDestination

     C     KACCNT        KLIST
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ
     C                   KFLD                    N4BRCA

     C     KRSACMT       KLIST
     C                   KFLD                    N4BRCA
     C                   KFLD                    N4CNUM
     C                   KFLD                    N4CCY
     C                   KFLD                    N4ACCD
     C                   KFLD                    N4ACSQ

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
