     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Accounting Rules Batch Details - DIACIFTD')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000586 - Midas OF Accounting Rules Batch Details           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD031513           Date 27Jan15               *
      *  Prev Amend No. MD027197A          Date 03Jun14               *
      *                 MD027197           Date 29May14               *
      *                 MD027202           Date 26May14               *
      *                 MD027108           Date 21May14               *
      *                 MD025870           Date 04Apr14               *
      *                 MD025566A          Date 26Mar14               *
      *                 MD025566           Date 28Feb14               *
      *                 MD025601           Date 06Feb14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD025013           Date 13Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024511           Date 23Jan14               *
      *                 MD024399           Date 16Jan14               *
      *                 MD024348           Date 14Jan14               *
      *                 CRE098             Date 07Jan14               *
      *                 MD023629           Date 08Jan14               *
      *                 MD024092           Date 06Jan14               *
      *                 MD024114           Date 17Dec13               *
      *                 MD024113           Date 17Dec13               *
      *                 MD024112           Date 12Dec13               *
      *                 MD024064           Date 12Dec13               *
      *                 MD024063           Date 12Dec13               *
      *                 MD024030           Date 12Dec13               *
      *                 MD023743           Date 29Nov13               *
      *                 MD023988           Date 05Dec13               *
      *                 MD023837           Date 27Nov13               *
      *                 MD023767           Date 25Nov13               *
      *                 MD023744           Date 24Nov13               *
      *                 MD023760           Date 24Nov13               *
      *                 CGL135B  *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031513 - Serious midas error due to Cheque No. 00000000.   *
      *             Make Cheque No blank if equal to zeros.           *
      *  MD027197A - Convert special char (&) in Narrative and Swift  *
      *              Common Reference to blanks.                      *
      *  MD027197 - Convert special chars in Narrative fields and set *
      *             them to blanks. Reporting of dump.                *
      *  MD027202 - Change the call of ZEDIT to ZSEDIT                *
      *  MD027108 - Change Narrative for balancing entry.             *
      *  MD025870 - Postings for the batch details not created        *
      *             Front Office ID not setup correctly with letter   *
      *             in case of missing acc rules.                     *
      *  MD025566A - Error encountered when processing an Account     *
      *              with reversal.
      *  MD025566 - GL000587P1 is not generated for postings with     *
      *             reversal.
      *  MD025601 - Batch description for Accounting Rules            *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries.                                        *
      *  MD025013 - Setup changes for Missing Acc Rules (Acc Code,    *
      *             Narrative, Front Office Id setup)                 *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules.                                            *
      *  MD024511 - Process for Posting Reference 0 for CR not done   *
      *             correctly.                                        *
      *  MD024399 - Batch Header total amount not computed correctly. *
      *  MD024348 - Account Seq for Posting Reference 3 should        *
      *             match the Unreconcilled Acct Seq in Nostro record.*
      *  CRE098 - User-Defined Retail Transaction Types on Postings   *
      *  MD023629 - Accounting Rules Processing - Restart             *
      *  MD024092 - Different currency setup in Accounting Rules      *
      *             do not balance the amount.                        *
      *  MD024114 - Add check on RECI when checking for Accounting    *
      *             Rules - Take only if Active                       *
      *  MD024113 - Review Nostro retrieval and setup                 *
      *  MD024112 - Account Code to be set to '01' in case value is   *
      *             '  ' or '00'.                                     *
      *  MD024064 - Transaction Type and Cheque Number only if Retail *
      *  MD024063 - Narrative setup for Cross Ccy                     *
      *  MD024030 - Narrative code not considered                     *
      *  MD023743 - Matching Rules Check Changes to include DR/CR ind *
      *             Amend posting amounts format                      *
      *  MD023988 - Narrative code not considered                     *
      *  MD023837 - Triggers on tables GLACMNTD, GLACBHTD, GLACBDTD   *
      *             failed                                            *
      *  MD023767 - Various Errors during input of batch              *
      *  MD023744 - Right adjust amounts                              *
      *  MD023760 - Retrieve only the first record                    *
      *  CGL135B - Accounting Rules Process                           *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Midas GL Network Accounts - MT94x
     FGLNW94L2  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Network Accounts
     FGLNWACL4  IF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
     D $StackPtr       S              5S 0                                                  MD027197
     D $StackDs        Ds                                                                   MD027197
     D $Stack                        30    DIM(999)                                         MD027197
                                                                                            MD027197
     D POSTARR         S             19    DIM(999) DESCEND                                 MD024092
     D POSTAMT         S             35    DIM(999) DESCEND                                 MD024092
                                                                                            MD024092
      ** Imbalance Posting                                                                  MD024092
     D IMBLPOST        DS                                                                   MD024092
     D  IMCCY                  1      3                                                     MD024092
     D  IMIND                  4      4                                                     MD024092
     D  IMAMT                  5     19S 0                                                  MD024092
                                                                                            MD024092
      ** Total Imbalance Posting                                                            MD024092
     D TOTLPOST        DS                                                                   MD024092
     D  TOTCCY                 1      3                                                     MD024092
     D  TOTDRIND               4      4                                                     MD024092
     D  TOTDRAMT               5     19S 0                                                  MD024092
     D  TOTCRIND              20     20                                                     MD024092
     D  TOTCRAMT              21     35S 0                                                  MD024092
                                                                                            MD024092
     D  IDX            S              3S 0                                                  MD024092
     D  IDX2           S              3S 0                                                  MD024092
     D  CTR            S              3S 0                                                  MD024092
     D  TMPCCY         S              3                                                     MD024092
     D  WAMOUNT2       S             21                                                     MD024092
                                                                                            MD024092
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)
 
      ** Data structure for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD1       E                     EXTFLD(QQACCD)
 
      ** Data structure for Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
 
      ** Data structure for Account Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D QQACCD3       E                     EXTFLD(QQACCD)
 
      ** Data structure for GL ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD4       E                     EXTFLD(QQACCD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     ** File DS
     **   Midas GL Accounting Rules Interface File
     D DSACIFTD      E DS                  EXTNAME(DIACIFTD)
 
     ** File DS
     **   Midas GL Accounting Rules Monitor File
     D DSACMNTD      E DS                  EXTNAME(GLACMNTD)
 
     ** File DS
     **   Midas GL Accounting Rules Table
     D DSACRUTD      E DS                  EXTNAME(GLACRUTD)
 
     ** File DS
     **   Midas GL Accounting Rules Batch Header
     D DSACBHTD      E DS                  EXTNAME(GLACBHTD)
 
     ** File DS
     **   Midas GL Accounting Rules Batch Details
     D DSACBDTD      E DS                  EXTNAME(GLACBDTD)
 
     ** File DS
     **   Midas GL Nostro Extension File
     D NOST2D        E DS                  EXTNAME(SDNOST2D)
 
     ** File DS
     **   Midas GL Accounting Rules Sequence Holder
     D DSACSQTD      E DS                  EXTNAME(GLACSQTD)
 
     ** File DS
     **   Midas Account details
     D DSACCNT       E DS                  EXTNAME(ACCNTAB)
     D LCDD1         E                     EXTFLD(LCD)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for access object programs
     D @RTCD           S              7
     D @OPTN           S              7
     D PSARD           S              6
 
      ** Settlement Account DS
     D SETTACC         DS            24
     D  SBRCA                  1      3                                         Branch
     D  SCUST                  4      9                                         Customer
     D  SCCY                  10     12                                         CCY
     D  SACOD                 13     22                                         A/C Code
     D  SACSQ                 23     24                                         A/C Seq
 
      ** Settlement Account Nostro DS
     D SETACNO         DS             5
     D  SNCCY                  1      3                                         CCY
     D  SNOST                  4      5                                         Nostro
 
      ** Front Office Id DS (GLACBHTD)
     D WHFRNT          DS            20
     D  WHFRNAR                1      2                                         AR
     D  WHFRNDT                3      8                                         Date
     D  WHFRNSQ                9     15                                         Sequence
     D  WHFRNLT               16     16                                         Letter
     D  WHFRNFL               17     20                                         Filler
 
      ** Front Office Id DS (GLACBDTD)
     D WDFRNT          DS            20
     D  WDFRNAR                1      2                                         AR
     D  WDFRNDT                3      8                                         Date
     D  WDFRSQ1                9     15                                         Sequence 1
     D  WDFRNLT               16     16                                         Letter
     D  WDFRNFL               17     20                                         Filler
 
      ** Front Office Tran Id DS (GLACBDTD)
     D WDFOTR          DS            20
     D  WDFONAR                1      2                                         AR
     D  WDFONDT                3      8                                         Date
     D  WDFOSQ1                9     15                                         Sequence 1
     D  WDFOSLT               16     16                                         Letter
     D  WDFOSQ2               17     19                                         Sequence 2
     D  WDFONFL               20     20                                         Filler
 
      ** Front Office Id DS (GLACMNTD)
     D WMFRNT          DS            20
     D  WMFRNAR                1      2                                         AR
     D  WMFRNDT                3      8                                         Date
     D  WMFRNSQ                9     15                                         Sequence
     D**WMFRNFL               16     20                                         Filler      MD025013
     D  WMFRNLT               16     16                                         Letter      MD025013
     D  WMFRNFL               17     20                                         Filler      MD025013
                                                                                            MD024772
      ** Settlement Account DR/CR                                                           MD024772
     D SETACCOUNT      DS            24                                                     MD024772
     D  SETBRCA                1      3                                                     MD024772
     D  SETCUST                4      9                                                     MD024772
     D  SETCCY                10     12                                                     MD024772
     D  SETACODSQ             13     24                                                     MD027197
     D  SETACOD               13     22  0                                                  MD024772
     D  SETACSQ               23     24  0                                                  MD024772
                                                                                            MD024772
     D PostDateFlag    S              1                                                     MD024772
     D NewPostDate     S              6                                                     MD024772
                                                                                            MD025601
      ** Header Batch Description                                                           MD025601
     D BATHEAD         DS            30                                                     MD025601
     D  BATIM                  1     15                                                     MD025601
     D  BATSEP                16     16                                                     MD025601
     D  BATNOS                17     30                                                     MD025601
                                                                                            MD025601
      ** Header Batch Description                                                           MD025601
     D BATIDSP         DS            29                                                     MD025601
     D  BATIMSP                1     15                                                     MD025601
     D  BATNOSP               16     29                                                     MD025601
 
     D WRun            S              1
     D WSEQN           S              7  0
     D WBTCH           S              4
     D @BRCA           S              3A                                        Branch
     D @CNUM           S             10A                                        Customer
     D @CNST           S              7A                                        Customer Status
     D P@CUCD          S              3A                                        Currency
     D P@NONB          S              2A                                        Nostro Number
     D P@ACCD          S             10A                                        Account Code
     D P@ACSQ          S              2A                                        Account Sequence
     D P@CSSN          S             10A                                        Customer Shortname
     D P@PNOI          S              1A                                        Prime Nost Ind
     D WMFRN           S             20A                                        Front Office Id
     D WIMBPA          S             15  0                                      Item Amount
     D WIMBDR          S             15  0                                      Total Items DR
     D WIMBCR          S             15  0                                      Total Items CR
     D WDIFFA          S             15  0                                      Difference DR/CR
     D PACCD           S             10A                                        Suspense Acc Code
     D PACSUS          S             10A                                        Suspense Acc Code
     D WTOTBH          S             21  0                                      Total Amount Header
     D WSMAM           S             18  0                                      Total AmountMD023743
     D @CNUMN          S              6A                                        Customer    MD024113
 
      ** Parameter list fields
     D PBTID           S             60                                         Batch Id
     D PARST           S             30                                         AR Status
     D PSEQN           S              7                                         Sequence
     D PZONE           S             10                                         Zone
 
      ** Other fields used
     D WSMTF1          S             25                                         Match Field 1
     D WSMTF2          S             25
     D WSMTF3          S             25                                         Match Field 3
     D WSMTF4          S             25                                         Match Field 4
     D WSMTF5          S             25                                         Match Field 5
     D WSMTF6          S             25                                         Match Field 6
     D WSMTF7          S             25                                         Match Field 7
     D WSMTF8          S             25                                         Match Field 8
     D WSMTF9          S             25                                         Match Field 9
     D WSMTF10         S             25                                         Match Field 10
     D WDCIP           S              1                                         DR/CR ind
     D WNONB           S              2                                         Nostro
     D WCYCD           S              3                                         Ccy
     D PCRF            S              1                                         Post Ref CR
     D PDRF            S              1                                         Post Ref DR
     D POSRFF          S              1                                         Posting Ref
     D WHNITM          S              5  0                                      Number of Items
     D WHBTNB          S              3  0                                      Batch Number
     D WDBINB          S              3  0                                      Batch Item No
     D WESPAE          S             10                                         A6SPAE for IFCCY
     D WBSPAE          S             10                                         A6SPAE for BJCYCD
     D WREL            S              3
     D WMAXBI          S              4  0                                      Max No of Items
     D WTOTBI          S              4  0                                      Total of Items
     D WEXBI           S              3  0                                      Expected No Items
     D WNBDP           S              1  0                                      Number dec places
     D WHASH           S             15  0                                      Hash total
     D WDDCIN          S              1                                         REVERSAL
     D WARSTT          S             30                                         AR Status
     D WAMOUNT         S             21                                         Amount      MD023744
     D WLEN            S              5I 0                                      Length      MD023744
     D WNMATCH         S              6S 0                                      Nb No Match MD023837
     D WNMATCA         S              6A                                        Nb No Match MD023837
     D PACOD           S             10A                                        Account CodeMD024064
     D WRECI           S              1A                                        RECI = 'D'  MD024114
     D CRE098          S              1                                                       CRE098
 
      ** Hash normalisation data structures
      *
     D                 DS
     D  WINT15                 1     15  0
     D  WINT14                 1     14  0
     D  WINT13                 1     13  0
     D  WINT12                 1     12  0
     D  WINT01                15     15  1
     D  WINT02                14     15  2
     D  WINT03                13     15  3
      *
     D                 DS
     D  WDEC09                 1      9  3
     D  WDEC06                 1      6  0
     D  WDEC03                 7      9  0
 
      ** Key to access ACCNTAB
     D WACNUM          S              6
     D WACCY           S              3
     D WAACOD          S             10  0
     D WAACSQ          S              2  0
     D WABRCA          S              3
 
      ** Key to access GLNW94PD / GLNWACPD
     D WNNETW          S              6
     D WNWBRCA         S              3
     D WNWCUST         S              6
     D WNWCCY          S              3
     D WNWACOD         S             10  0
     D WNWACSQ         S              2  0
     D WNWNATY         S              1
     D WNWDSTN         S             11
 
      ** AR Status
     D*ArSTAT1****     C                   CONST('AR INITIATED')                            MD023629
     D*ArSTAT2****     C                   CONST('AR PROCESSING')                           MD023629
     D ArSTAT1         C                   CONST('AR Initiated')                            MD023629
     D ArSTAT2         C                   CONST('AR Processing')                           MD023629
 
      ** Header Description
     D*ArDESC***       C                   CONST('Accounting Rules Batch')                  MD024513
     D ArDESC1         C                   CONST('Accounting Rules Batch')                  MD024513
 
      ** System Values details
     D PSysVal1        C                   CONST('AcctRulesGenBalEntry')
     D PSysVal2        C                   CONST('CustomerNetwork')
     D PSysVal3        C                   CONST('AcctRulesDeptCode')
     D PSysVal4        C                   CONST('GLJRNECmpAssCust')                        MD024030
                                                                                            MD027108
     D NARR01          C                   CONST('SYSTEM GENERATED BAL ENTRY')              MD027108
                                                                                            MD027108
 
      ** Parameter variables for AOSVALR0 string
     DRTNCDE           S              7
     DSVALK1           S             20
     DSVAL1            S            200
     DSVALK2           S             20
     DSVAL2            S            200
     DSVALK3           S             20
     DSVAL3            S            200
     DSVALK4           S             20
     DSVAL4            S            200
     DSVALK5           S             20
     DSVAL5            S            200
     DSVALK6           S             20
     DSVAL6            S            200
     DSVALK7           S             20
     DSVAL7            S            200
     DSVALK8           S             20
     DSVAL8            S            200
     DSVALK9           S             20
     DSVAL9            S            200
     DSVALK0           S             20
     DSVAL10           S            200
 
     D LETR            S              1    DIM(26) CTDATA PERRCD(26)
                                                                                            MD027197
      ** Array for Narrative                                                                MD027197
     D NARRTV          S              1    DIM(30) CTDATA PERRCD(30)                        MD027197
                                                                                            MD027197
     D NARRTV1         S             30A                                                    MD027197
                                                                                            MD027202
     D ZFIELD          S             15  0                                                  MD027202
     D ZADEC           S              1  0                                                  MD027202
     D ZECODE          S              1                                                     MD027202
     D ZOUT21          S             21                                                     MD027202
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *InzSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
                                                                                            MD027197
      * Set Stack pointer to zero                                                           MD027197
     C                   Clear                   $StackPtr                                  MD027197
     C                   Clear                   $StackDs                                   MD027197
 
      * Init Processing
     C                   EXSR      INIT
 
      * Main Processing
     C                   EXSR      PROC
 
      * End Processing
     C                   EXSR      END
 
     C                   RETURN
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Initiation Subroutine to check if Batch ID already  *
      *           processed                                           *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'INIT                   '            MD027197
      *
      ** Check if Batch ID already processed
      *
      ** Then Delete record in GLACBHTD
     C/Exec SQL
     C+                  Delete from GLACBHTD
     C+                          where BHBTID = :PBTID
     C/End-Exec
      ** then Access GLACBDTD and delete all records
     C/Exec SQL
     C+                  Delete from GLACBDTD
     C+                          where BDBTID = :PBTID
     C/End-Exec
      *
     C                   CLEAR                   PostDateFlag                               MD024772
     C                   CLEAR                   NewPostDate                                MD024772
      *                                                                                     MD024772
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROC   - Process Interface File and Generate Postings        *
      *                                                               *
      *****************************************************************
     C     PROC          BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'PROC                   '            MD027197
      *
      ** Access Interface File DIACIFTD using the Batch Id
     C/Exec SQL
     C+ Declare ACIFDT scroll Cursor for
     C+                  Select * from DIACIFTD
     C+                          where IFBTID = :PBTID
     C/End-Exec
      *
     C/Exec SQL
     C+ Open ACIFDT
     C/End-Exec
      *
     C/Exec SQL
     C+ Fetch First
     C+   From ACIFDT
     C+   into :DSACIFTD
     C/End-Exec
     C                   Z-ADD     1             WHBTNB
     C                   Z-ADD     0             WDBINB
     C                   Z-ADD     0             WEXBI
     C                   Z-ADD     0             WMAXBI
     C                   Z-ADD     0             WTOTBI
     C                   Z-ADD     0             WNMATCH                                    MD023837
      *
     C                   Z-ADD     0             WINT15
     C                   Z-ADD     0             WDEC09
     C                   Z-ADD     0             WHASH
     C                   Z-ADD     0             WTOTBH
      *
     C                   MOVEL     *BLANKS       WREL
     C                   MOVE      PSEQN         WHFRNSQ
     C                   Z-ADD     1             X                 2 0
     C                   MOVEL     LETR(X)       WHFRNLT
      *
      ** For each record in DIACIFTD, check if Match with Accounting Rules Table
b1   C                   Dow       SQLSTT = '00000'
      *
      ** Right adjust amounts                                                               MD023744
      *                                                                                     MD023744
      **  Event Amount                                                                      MD023744
      *                                                                                     MD023744
     C                   EVAL      WAMOUNT = %TRIM(IFEVTA)                                  MD023744
     C                   EVAL      WLEN = %LEN(%TRIM(WAMOUNT))                              MD023744
     C                   IF        WLEN > *Zeros                                            MD023744
     C                   EVAL      IFEVTA = *BLANKS                                         MD023744
     C                   EVAL      %SUBST(IFEVTA:16-WLEN:WLEN) = %TRIM(WAMOUNT)             MD023744
     C                   ELSE                                                               MD023744
     C                   MOVE(P)   '0'           IFEVTA                                     MD023744
     C                   ENDIF                                                              MD023744
      *                                                                                     MD023744
      **  Base Currency Equivalent Amount                                                   MD023744
      *                                                                                     MD023744
     C                   EVAL      WAMOUNT = %TRIM(IFBCEQA)                                 MD023744
     C                   EVAL      WLEN = %LEN(%TRIM(WAMOUNT))                              MD023744
     C                   IF        WLEN > *Zeros                                            MD023744
     C                   EVAL      IFBCEQA = *BLANKS                                        MD023744
     C                   EVAL      %SUBST(IFBCEQA:22-WLEN:WLEN) = %TRIM(WAMOUNT)            MD023744
     C                   ELSE                                                               MD023744
     C                   MOVE(P)   '0'           IFBCEQA                                    MD023744
     C                   ENDIF                                                              MD023744
      *                                                                                     MD023744
      **  Reversal Indicator                                                                MD023767
      *                                                                                     MD023767
     C                   IF        IFRVID = '1'                                             MD023767
     C                   EVAL      IFRVID = 'Y'                                             MD023767
     C                   ELSE                                                               MD023767
     C                   EVAL      IFRVID = 'N'                                             MD023767
     C                   ENDIF                                                              MD023767
      *                                                                                     MD023767
      ** Access Accounting Rules GLACRUTD to check if Matched
     C****************** EXSR      CHKMAT
     C                   EXSR      CHKMA2
      *
     C/Exec SQL
     C+ Fetch next
     C+   From ACIFDT
     C+   into :DSACIFTD
     C/End-Exec
e1   C                   Enddo
      *
     C/Exec SQL
     C+ Close ACIFDT
     C/End-Exec
      *
     C                   SORTA     POSTARR                                                  MD024092
     C                   Z-ADD     0             WIMBDR                                     MD024092
     C                   Z-ADD     0             WIMBCR                                     MD024092
     C                   Z-ADD     0             CTR                                        MD024092
     C                   Z-ADD     0             IDX2                                       MD024092
     C                   Z-ADD     0             TOTDRAMT                                   MD024092
     C                   Z-ADD     0             TOTCRAMT                                   MD024092
     C                   CLEAR                   IMBLPOST                                   MD024092
     C                   MOVE      *BLANKS       TMPCCY                                     MD024092
      *                                                                                     MD024092
     C                   EVAL      TMPCCY = %SUBST(POSTARR(1):1:3)                          MD024092
      *                                                                                     MD024092
     C     1             DO        IDX           CTR                                        MD024092
      *                                                                                     MD024092
     C                   EVAL      IMBLPOST = POSTARR(CTR)                                  MD024092
      *                                                                                     MD024092
     C                   IF        IMCCY <> TMPCCY                                          MD024092
     C                   ADD       1             IDX2                                       MD024092
     C                   EVAL      POSTAMT(IDX2) = TOTLPOST                                 MD024092
     C                   EVAL      TMPCCY = IMCCY                                           MD024092
     C                   Z-ADD     0             TOTDRAMT                                   MD024092
     C                   Z-ADD     0             TOTCRAMT                                   MD024092
     C                   ENDIF                                                              MD024092
      *                                                                                     MD024092
     C                   EVAL      TOTCCY = IMCCY                                           MD024092
     C                   IF        IMIND = 'D'                                              MD024092
     C                   MOVE      IMIND         TOTDRIND                                   MD024092
     C                   ADD       IMAMT         TOTDRAMT                                   MD024092
     C                   ELSE                                                               MD024092
     C                   MOVE      IMIND         TOTCRIND                                   MD024092
     C                   ADD       IMAMT         TOTCRAMT                                   MD024092
     C                   ENDIF                                                              MD024092
      *                                                                                     MD024092
     C                   ENDDO                                                              MD024092
      *                                                                                     MD024092
     C                   IF        CTR > 1                                                  MD024092
     C                   ADD       1             IDX2                                       MD024092
     C                   EVAL      POSTAMT(IDX2) = TOTLPOST                                 MD024092
     C                   EVAL      TMPCCY = IMCCY                                           MD024092
     C                   ENDIF                                                              MD024092
      *                                                                                     MD024092
     C                   Z-ADD     0             CTR                                        MD024092
     C                   SORTA     POSTAMT                                                  MD024092
      *                                                                                     MD024092
     C     1             DO        IDX2          CTR                                        MD024092
     C                   EVAL      TOTLPOST = POSTAMT(CTR)                                  MD024092
     C                   EVAL      WIMBDR = TOTDRAMT                                        MD024092
     C                   EVAL      WIMBCR = TOTCRAMT                                        MD024092
      *                                                                                     MD024092
     C                   IF        WIMBDR <> WIMBCR And
     C                             WGBEF = 'Y'
     C                   EXSR      IMBPOS
     C                   ENDIF
     C                   ENDDO                                                              MD024092
      *
      ** Write to GLACBHTD
     C                   EXSR      WRITEBH
      *
      ** Update GLACMNTD
     C                   EXSR      UPDATMN
      *
     C                   EVAL      PARST = ArSTAT2
      *                                                                                     MD024772
     C                   IF        PostDateFlag = 'Y'                                       MD024772
      *                                                                                     MD024772
     C/EXEC SQL                                                                             MD024772
     C+ UPDATE GLACBDTD SET BDNPSDT = :NewPostDate                                          MD024772
     C+ WHERE BDBTID = :PBTID                                                               MD024772
     C/END-EXEC                                                                             MD024772
      *                                                                                     MD024772
     C                   ENDIF                                                              MD024772
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKMAT - Check if Match with Accounting Rules Table          *
      *                                                               *
      *****************************************************************
     C     CHKMAT        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CHKMAT                 '            MD027197
      *
     C                   EVAL      WSMTF1 = IFSMTF1
     C                   EVAL      WSMTF2 = IFSMTF2
     C                   EVAL      WSMTF3 = IFSMTF3
     C                   EVAL      WSMTF4 = IFSMTF4
     C                   EVAL      WSMTF5 = IFSMTF5
     C                   EVAL      WSMTF6 = IFSMTF6
     C                   EVAL      WSMTF7 = IFSMTF7
     C                   EVAL      WSMTF8 = IFSMTF8
     C                   EVAL      WSMTF9 = IFSMTF9
     C                   EVAL      WSMTF10 = IFSMTF10
     C                   EVAL      WDCIP = IFDCIP
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
b1   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x1   C                   Else
     C                   EVAL      WSMTF1 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b2   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x2   C                   Else
     C                   EVAL      WSMTF2 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b3   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x3   C                   Else
     C                   EVAL      WSMTF3 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b4   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x4   C                   Else
     C                   EVAL      WSMTF4 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b5   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x5   C                   Else
     C                   EVAL      WSMTF5 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b6   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x6   C                   Else
     C                   EVAL      WSMTF6 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b7   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x7   C                   Else
     C                   EVAL      WSMTF7 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b8   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x8   C                   Else
     C                   EVAL      WSMTF8 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          and   ARMATF9 = :WSMTF9
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b9   C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x9   C                   Else
     C                   EVAL      WSMTF9 = *BLANKS
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          and   ARMATF9 = :WSMTF9
     C+                          and   ARMATF10 = :WSMTF10
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b10  C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x10  C                   Else
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :IFSMTF1
     C+                          and   ARMATF2 = :IFSMTF2
     C+                          and   ARMATF3 = :IFSMTF3
     C+                          and   ARMATF4 = :IFSMTF4
     C+                          and   ARMATF5 = :IFSMTF5
     C+                          and   ARMATF6 = :IFSMTF6
     C+                          and   ARMATF7 = :IFSMTF7
     C+                          and   ARMATF8 = :IFSMTF8
     C+                          and   ARMATF9 = :IFSMTF9
     C+                          and   ARMATF10 = :IFSMTF10
     C+                          and   ARDCIP = :IFDCIP
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
b11  C                   If        SQLCOD = 0
      ** If Matching, then process for Postings
     C                   EXSR      MATCH
x11  C                   Else
      ** If No Matching, then process for Unmatched Postings
     C                   EXSR      NOMAT
e11  C                   Endif
e10  C                   Endif
e9   C                   Endif
e8   C                   Endif
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
e1   C                   Endif
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CHKMA2 - Check if Match with Accounting Rules Table          *
      *                                                               *
      *****************************************************************
     C     CHKMA2        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CHKMA2                 '            MD027197
      *
     C                   EVAL      WSMTF1 = IFSMTF1
     C                   EVAL      WSMTF2 = IFSMTF2
     C                   EVAL      WSMTF3 = IFSMTF3
     C                   EVAL      WSMTF4 = IFSMTF4
     C                   EVAL      WSMTF5 = IFSMTF5
     C                   EVAL      WSMTF6 = IFSMTF6
     C                   EVAL      WSMTF7 = IFSMTF7
     C                   EVAL      WSMTF8 = IFSMTF8
     C                   EVAL      WSMTF9 = IFSMTF9
     C                   EVAL      WSMTF10 = IFSMTF10
     C                   EVAL      WDCIP = IFDCIP
     C                   EVAL      WRECI = 'D'                                              MD024114
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
     C                   EXSR      CKMAT1
      *
     C                   EXSR      CKMAT2
      *
     C                   EXSR      CKMAT3
      *
     C                   EXSR      CKMAT4
      *
     C                   EXSR      CKMAT5
      *
     C                   EXSR      CKMAT6
      *
     C                   EXSR      CKMAT7
      *
     C                   EXSR      CKMAT8
      *
     C                   EXSR      CKMAT9
      *
     C                   EXSR      CKMAT10
      *
     C                   EXSR      CKMAT11
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT1 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT1        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CHKMAT1                '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF1 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT2 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT2        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT2                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF2 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT3 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT3        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT3                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF3 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT4 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT4        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT4                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF4 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT5 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT5        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT5                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF5 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT6 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT6        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT6                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF6 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT7 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT7        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT7                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF7 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT8 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT8        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT8                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF8 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          and   ARMATF9 = :WSMTF9
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT9 -                                                     *
      *                                                               *
      *****************************************************************
     C     CKMAT9        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT9                 '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF9 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          and   ARMATF9 = :WSMTF9
     C+                          and   ARMATF10 = :WSMTF10
     C+                          and   ARDCIP = :IFDCIP                                     MD023743
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT10 -                                                    *
      *                                                               *
      *****************************************************************
     C     CKMAT10       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT10                '            MD027197
      *
     C                   If        SQLCOD <> 0
     C                   Eval      WSMTF10 = *BLANKS
     C                   Endif
      *
     C/Exec SQL
     C+                  Select * into :DSACRUTD
     C+                           from GLACRUTD
     C+                          where ARMATF1 = :WSMTF1
     C+                          and   ARMATF2 = :WSMTF2
     C+                          and   ARMATF3 = :WSMTF3
     C+                          and   ARMATF4 = :WSMTF4
     C+                          and   ARMATF5 = :WSMTF5
     C+                          and   ARMATF6 = :WSMTF6
     C+                          and   ARMATF7 = :WSMTF7
     C+                          and   ARMATF8 = :WSMTF8
     C+                          and   ARMATF9 = :WSMTF9
     C+                          and   ARMATF10 = :WSMTF10
     C+                          and   ARDCIP = :IFDCIP
     C+                          and   ARRECI = :WRECI                                      MD024114
     C+                          fetch first 1 row only                                     MD023760
     C/End-Exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CKMAT11 -                                                    *
      *                                                               *
      *****************************************************************
     C     CKMAT11       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKMAT11                '            MD027197
      *
     C                   If        SQLCOD = 0
     C                   EXSR      MATCH
      *
     C                   Else
     C                   EXSR      NOMAT
     C                   Endif
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MATCH  - Generate Postings based on Accounting Rules         *
      *                                                               *
      *****************************************************************
     C     MATCH         BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'MATCH                  '            MD027197
      *
      ** Check Batch Item number to see if new Batch Header required
     C                   MOVE      'MAT'         WREL
     C                   EXSR      BATITN
      *
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
      *
      ** If Posting Reference Debit 1 not blank
b1   C                   If        ARPRFDR1 <> ' '
     C                   CLEAR                   DSACBDTD
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      WDDCIN = 'D'
     C                   EVAL      BDDCIN = 'D'
     C                   EVAL      PDRF = '1'
     C                   EVAL      PCRF = ' '
     C                   EVAL      POSRFF = ARPRFDR1
      *
     C                   IF        ARRNDR1 = 'N'                                            MD023988
      ** Narrative                                                                          MD023988
     C                   MOVEL     ARNADR1       BDNARR                                     MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR3 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR4 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR5 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR6 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR7 = *BLANKS                                         MD023988
      *                                                                                     MD023988
     C                   ELSE                                                               MD023988
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   ENDIF                                                              MD023988
      ** If Posting Reference Debit 1 = '0'
b2   C                   If        ARPRFDR1 = '0'
     C                   EXSR      POSRF0
x2   C                   Else
      ** If Posting Reference Debit 1 = '1'
b3   C                   If        ARPRFDR1 = '1'
     C                   EXSR      POSRF1
x3   C                   Else
      ** If Posting Reference Debit 1 = '2'
b4   C                   If        ARPRFDR1 = '2'
     C                   EXSR      POSRF2
     C******             EXSR      MLTBRIT                                      Interbranch MD023767
x4   C                   Else
      ** If Posting Reference Debit 1 = '3'
b5   C                   If        ARPRFDR1 = '3'
     C                   EXSR      POSRF3
x5   C                   Else
      ** If Posting Reference Debit 1 = '4'
b6   C                   If        ARPRFDR1 = '4'
     C                   EXSR      POSRF4
x6   C                   Else
      ** If Posting Reference Debit 1 = '5'
b7   C                   If        ARPRFDR1 = '5'
     C                   EXSR      POSRF5
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      *
      ** If Posting Reference Debit 2 not blank
b1   C                   If        ARPRFDR2 <> ' '
     C                   CLEAR                   DSACBDTD
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDDCIN = 'D'
     C                   EVAL      WDDCIN = 'D'
     C                   EVAL      PDRF = '2'
     C                   EVAL      PCRF = ' '
     C                   EVAL      POSRFF = ARPRFDR2
      *
     C                   IF        ARRNDR2 = 'N'                                            MD023988
      ** Narrative                                                                          MD023988
     C                   MOVEL     ARNADR2       BDNARR                                     MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR3 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR4 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR5 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR6 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR7 = *BLANKS                                         MD023988
      *                                                                                     MD023988
     C                   ELSE                                                               MD023988
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   ENDIF                                                              MD023988
      *                                                                                     MD023988
      ** If Posting Reference Debit 2 = '0'
b2   C                   If        ARPRFDR2 = '0'
     C                   EXSR      POSRF0
x2   C                   Else
      ** If Posting Reference Debit 2 = '1'
b3   C                   If        ARPRFDR2 = '1'
     C                   EXSR      POSRF1
x3   C                   Else
      ** If Posting Reference Debit 2 = '2'
b4   C                   If        ARPRFDR2 = '2'
     C                   EXSR      POSRF2
     C******             EXSR      MLTBRIT                                      Interbranch MD023767
x4   C                   Else
      ** If Posting Reference Debit 2 = '3'
b5   C                   If        ARPRFDR2 = '3'
     C                   EXSR      POSRF3
x5   C                   Else
      ** If Posting Reference Debit 2 = '4'
b6   C                   If        ARPRFDR2 = '4'
     C                   EXSR      POSRF4
x6   C                   Else
      ** If Posting Reference Debit 2 = '5'
b7   C                   If        ARPRFDR2 = '5'
     C                   EXSR      POSRF5
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      *
      ** If Posting Reference Debit 3 not blank
b1   C                   If        ARPRFDR3 <> ' '
     C                   CLEAR                   DSACBDTD
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDDCIN = 'D'
     C                   EVAL      WDDCIN = 'D'
     C                   EVAL      PDRF = '3'
     C                   EVAL      PCRF = ' '
     C                   EVAL      POSRFF = ARPRFDR3
      *
     C                   IF        ARRNDR3 = 'N'                                            MD023988
      ** Narrative                                                                          MD023988
     C                   MOVEL     ARNADR3       BDNARR                                     MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR3 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR4 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR5 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR6 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR7 = *BLANKS                                         MD023988
      *                                                                                     MD023988
     C                   ELSE                                                               MD023988
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   ENDIF                                                              MD023988
      *                                                                                     MD023988
      ** If Posting Reference Debit 3 = '0'
b2   C                   If        ARPRFDR3 = '0'
     C                   EXSR      POSRF0
     C                   Else
      ** If Posting Reference Debit 3 = '1'
b3   C                   If        ARPRFDR3 = '1'
     C                   EXSR      POSRF1
     C                   Else
      ** If Posting Reference Debit 3 = '2'
b4   C                   If        ARPRFDR3 = '2'
     C                   EXSR      POSRF2
     C******             EXSR      MLTBRIT                                      Interbranch MD023767
     C                   Else
      ** If Posting Reference Debit 3 = '3'
b5   C                   If        ARPRFDR3 = '3'
     C                   EXSR      POSRF3
     C                   Else
      ** If Posting Reference Debit 3 = '4'
b6   C                   If        ARPRFDR3 = '4'
     C                   EXSR      POSRF4
     C                   Else
      ** If Posting Reference Debit 3 = '5'
b7   C                   If        ARPRFDR3 = '5'
     C                   EXSR      POSRF5
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      *
      ** If Posting Reference Credit 1 not blank
b1   C                   If        ARPRFCR1 <> ' '
     C                   CLEAR                   DSACBDTD
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDDCIN = 'C'
     C                   EVAL      WDDCIN = 'C'
     C                   EVAL      PDRF = ' '
     C                   EVAL      PCRF = '1'
     C                   EVAL      POSRFF = ARPRFCR1
      *
     C                   IF        ARRNCR1 = 'N'                                            MD023988
      ** Narrative                                                                          MD023988
     C                   MOVEL     ARNACR1       BDNARR                                     MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR3 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR4 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR5 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR6 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR7 = *BLANKS                                         MD023988
      *                                                                                     MD023988
     C                   ELSE                                                               MD023988
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   ENDIF                                                              MD023988
      *                                                                                     MD023988
      ** If Posting Reference Credit 1 = '0'
b2   C                   If        ARPRFCR1 = '0'
     C                   EXSR      POSRF0
     C                   Else
      ** If Posting Reference Credit 1 = '1'
b3   C                   If        ARPRFCR1 = '1'
     C                   EXSR      POSRF1
     C                   Else
      ** If Posting Reference Credit 1 = '2'
b4   C                   If        ARPRFCR1 = '2'
     C                   EXSR      POSRF2
     C******             EXSR      MLTBRIT                                      Interbranch MD023767
     C                   Else
      ** If Posting Reference Credit 1 = '3'
b5   C                   If        ARPRFCR1 = '3'
     C                   EXSR      POSRF3
     C                   Else
      ** If Posting Reference Credit 1 = '4'
b6   C                   If        ARPRFCR1 = '4'
     C                   EXSR      POSRF4
     C                   Else
      ** If Posting Reference Credit 1 = '5'
b7   C                   If        ARPRFCR1 = '5'
     C                   EXSR      POSRF5
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      *
      ** If Posting Reference Credit 2 not blank
b1   C                   If        ARPRFCR2 <> ' '
     C                   CLEAR                   DSACBDTD
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDDCIN = 'C'
     C                   EVAL      WDDCIN = 'C'
     C                   EVAL      PDRF = ' '
     C                   EVAL      PCRF = '2'
     C                   EVAL      POSRFF = ARPRFCR2
      *
     C                   IF        ARRNCR2 = 'N'                                            MD023988
      ** Narrative                                                                          MD023988
     C                   MOVEL     ARNACR2       BDNARR                                     MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR3 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR4 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR5 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR6 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR7 = *BLANKS                                         MD023988
      *                                                                                     MD023988
     C                   ELSE                                                               MD023988
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   ENDIF                                                              MD023988
      *                                                                                     MD023988
      ** If Posting Reference Credit 2 = '0'
b2   C                   If        ARPRFCR2 = '0'
     C                   EXSR      POSRF0
     C                   Else
      ** If Posting Reference Credit 2 = '1'
b3   C                   If        ARPRFCR2 = '1'
     C                   EXSR      POSRF1
     C                   Else
      ** If Posting Reference Credit 2 = '2'
b4   C                   If        ARPRFCR2 = '2'
     C                   EXSR      POSRF2
     C******             EXSR      MLTBRIT                                      Interbranch MD023767
     C                   Else
      ** If Posting Reference Credit 2 = '3'
b5   C                   If        ARPRFCR2 = '3'
     C                   EXSR      POSRF3
     C                   Else
      ** If Posting Reference Credit 2 = '4'
b6   C                   If        ARPRFCR2 = '4'
     C                   EXSR      POSRF4
     C                   Else
      ** If Posting Reference Credit 2 = '5'
b7   C                   If        ARPRFCR2 = '5'
     C                   EXSR      POSRF5
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      *
      ** If Posting Reference Credit 3 not blank
b1   C                   If        ARPRFCR3 <> ' '
     C                   CLEAR                   DSACBDTD
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDDCIN = 'C'
     C                   EVAL      WDDCIN = 'C'
     C                   EVAL      PDRF = ' '
     C                   EVAL      PCRF = '3'
     C                   EVAL      POSRFF = ARPRFCR3
      *
     C                   IF        ARRNCR3 = 'N'                                            MD023988
      ** Narrative                                                                          MD023988
     C                   MOVEL     ARNACR3       BDNARR                                     MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR3 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR4 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR5 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR6 = *BLANKS                                         MD023988
     C                   EVAL      BDNAR7 = *BLANKS                                         MD023988
      *                                                                                     MD023988
     C                   ELSE                                                               MD023988
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   ENDIF                                                              MD023988
      *                                                                                     MD023988
      ** If Posting Reference Credit 3 = '0'
b2   C                   If        ARPRFCR3 = '0'
     C                   EXSR      POSRF0
     C                   Else
      ** If Posting Reference Credit 3 = '1'
b3   C                   If        ARPRFCR3 = '1'
     C                   EXSR      POSRF1
     C                   Else
      ** If Posting Reference Credit 3 = '2'
b4   C                   If        ARPRFCR3 = '2'
     C                   EXSR      POSRF2
     C******             EXSR      MLTBRIT                                      Interbranch MD023767
     C                   Else
      ** If Posting Reference Credit 3 = '3'
b5   C                   If        ARPRFCR3 = '3'
     C                   EXSR      POSRF3
     C                   Else
      ** If Posting Reference Credit 3 = '4'
b6   C                   If        ARPRFCR3 = '4'
     C                   EXSR      POSRF4
     C                   Else
      ** If Posting Reference Credit 3 = '5'
b7   C                   If        ARPRFCR3 = '5'
     C                   EXSR      POSRF5
e7   C                   Endif
e6   C                   Endif
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
      *
      ** If Cross Currency Flag = 'Y'
b1   C                   If        IFCXCYI = 'Y'
     C                   IF        WREL <> 'NMM'
     C                   EXSR      POSCXC
e1   C                   Endif
e1   C                   Endif
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOMAT  - Generate Postings as Non Matched                    *
      *                                                               *
      *****************************************************************
     C     NOMAT         BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'MOMAT                  '            MD027197
      *
      ** If Debit and Settlement Account Debit is not blank
b1   C     IFDCIP        IFEQ      'D'
     C     IFSADR        ANDNE     *BLANKS
      *
      ** OR If Credit and Settlement Account Credit is not blank
     C     IFDCIP        OREQ      'C'
     C     IFSACR        ANDNE     *BLANKS
      *
      ** Check Batch Item number to see if new Batch Header required
     C                   MOVE      'NMG'         WREL
     C                   EXSR      BATITN
      *
     C                   EXSR      NOMATG
      *
x1   C                   Else
      ** Check Batch Item number to see if new Batch Header required
     C                   MOVE      'NMM'         WREL
     C                   EXSR      BATITN
      *
     C                   EXSR      NOMATM
e1   C                   Endif
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSRF0 - Postings Details for Posting Ref 0                  *
      *                                                               *
      *****************************************************************
     C     POSRF0        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSRFO                 '            MD027197
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
      ** Setup Settlement Account Debit
     C                   EVAL      SCCY = IFCCY
b2   C                   If        PDRF = '1'
     C                   EVAL      SBRCA = ARBCDR1
     C                   EVAL      SCUST = ARCNDR1
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     ARACDR1       SACOD
     C                   MOVEL     ARASDR1       SACSQ
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR1       BDACCD
     C                   MOVEL     ARASDR1       BDACSN
     C                   EVAL      BDIBCA = ARBCDR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI1 = 'C'
     C                   ELSE
     C                   EVAL      BDLXDCI1 = 'D'
     C                   ENDIF
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      *
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = ARACDR1
     C                   EVAL      WAACSQ = ARASDR1
      *
x2   C                   Else
 
b3   C                   If        PDRF = '2'
     C                   EVAL      SBRCA = ARBCDR2
     C                   EVAL      SCUST = ARCNDR2
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     ARACDR2       SACOD
     C                   MOVEL     ARASDR2       SACSQ
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR2       BDACCD
     C                   MOVEL     ARASDR2       BDACSN
     C                   EVAL      BDIBCA = ARBCDR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI2 = 'C'
     C                   ELSE
     C                   EVAL      BDLXDCI2 = 'D'
     C                   ENDIF
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = ARACDR2
     C                   EVAL      WAACSQ = ARASDR2
      *
x3   C                   Else
 
b4   C                   If        PDRF = '3'
     C                   EVAL      SBRCA = ARBCDR3
     C                   EVAL      SCUST = ARCNDR3
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     ARACDR3       SACOD
     C                   MOVEL     ARASDR3       SACSQ
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR3       BDACCD
     C                   MOVEL     ARASDR3       BDACSN
     C                   EVAL      BDIBCA = ARBCDR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI3 = 'C'
     C                   ELSE
     C                   EVAL      BDLXDCI3 = 'D'
     C                   ENDIF
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = ARACDR3
     C                   EVAL      WAACSQ = ARASDR3
      *
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDSACR = SETTACC
     C                   EVAL      BDDCIN = 'C'
     C                   ELSE
     C                   EVAL      BDSADR = SETTACC
     C                   EVAL      BDDCIN = 'D'
     C                   ENDIF
 
x1   C                   Else
 
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
      ** Setup Settlement Account Credit
     C                   EVAL      SCCY = IFCCY
b3   C**********         If        PDRF = '1'                                               MD024511
b3   C                   If        PCRF = '1'                                               MD024511
     C                   EVAL      SBRCA = ARBCCR1
     C                   EVAL      SCUST = ARCNCR1
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     ARACCR1       SACOD
     C                   MOVEL     ARASCR1       SACSQ
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR1       BDACCD
     C                   MOVEL     ARASCR1       BDACSN
     C                   EVAL      BDIBCA = ARBCCR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI1 = 'D'
     C                   ELSE
     C                   EVAL      BDLXDCI1 = 'C'
     C                   ENDIF
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = ARACCR1
     C                   EVAL      WAACSQ = ARASCR1
      *
x3   C                   Else
 
b4   C**********         If        PDRF = '2'                                               MD024511
b4   C                   If        PCRF = '2'                                               MD024511
     C                   EVAL      SBRCA = ARBCCR2
     C                   EVAL      SCUST = ARCNCR2
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     ARACCR2       SACOD
     C                   MOVEL     ARASCR2       SACSQ
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR2       BDACCD
     C                   MOVEL     ARASCR2       BDACSN
     C                   EVAL      BDIBCA = ARBCCR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI2 = 'D'
     C                   ELSE
     C                   EVAL      BDLXDCI2 = 'C'
     C                   ENDIF
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = ARACCR2
     C                   EVAL      WAACSQ = ARASCR2
      *
x4   C                   Else
 
b5   C**********         If        PDRF = '3'                                               MD024511
b5   C                   If        PCRF = '3'                                               MD024511
     C                   EVAL      SBRCA = ARBCCR3
     C                   EVAL      SCUST = ARCNCR3
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     ARACCR3       SACOD
     C                   MOVEL     ARASCR3       SACSQ
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR3       BDACCD
     C                   MOVEL     ARASCR3       BDACSN
     C                   EVAL      BDIBCA = ARBCCR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI3 = 'D'
     C                   ELSE
     C                   EVAL      BDLXDCI3 = 'C'
     C                   ENDIF
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = ARACCR3
     C                   EVAL      WAACSQ = ARASCR3
      *
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
 
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDSADR = SETTACC
     C                   ELSE
     C                   EVAL      BDSACR = SETTACC
     C                   ENDIF
e2   C                   Endif
e1   C                   Endif
 
 
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSRF1 - Postings Details for Posting Ref 1                  *
      *                                                               *
      *****************************************************************
     C     POSRF1        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSRF1                 '            MD027197
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
      ** Setup Settlement Account Debit
     C                   EVAL      SCCY = IFCCY
     C                   EVAL      SBRCA = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
b2   C                   If        PDRF = '1'
     C                   MOVEL     ARACDR1       SACOD
b3   C                   If        ARASDR1 <> 0
     C                   MOVEL     ARASDR1       SACSQ
x3   C                   Else
     C                   EVAL      SACSQ = '01'
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR1       BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI1 = 'C'
     C                   ELSE
     C                   EVAL      BDLXDCI1 = 'D'
     C                   ENDIF
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
x2   C                   Else
b3   C                   If        PDRF = '2'
     C                   MOVEL     ARACDR2       SACOD
b4   C                   If        ARASDR2 <> 0
     C                   MOVEL     ARASDR2       SACSQ
x4   C                   Else
     C                   EVAL      SACSQ = '01'
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR2       BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI2 = 'C'
     C                   ELSE
     C                   EVAL      BDLXDCI2 = 'D'
     C                   ENDIF
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
x3   C                   Else
b4   C                   If        PDRF = '3'
     C                   MOVEL     ARACDR3       SACOD
b5   C                   If        ARASDR3 <> 0
     C                   MOVEL     ARASDR3       SACSQ
x5   C                   Else
     C                   EVAL      SACSQ = '01'
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR3       BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI3 = 'C'
     C                   ELSE
     C                   EVAL      BDLXDCI3 = 'D'
     C                   ENDIF
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDSACR = SETTACC
     C                   ELSE
     C                   EVAL      BDSADR = SETTACC
     C                   ENDIF
 
x1   C                   Else
 
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
      ** Setup Settlement Account Credit
     C                   EVAL      SCCY = IFCCY
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      SBRCA = ARBCCR1
b3   C                   If        PCRF = '1'
     C                   MOVEL     ARACCR1       SACOD
b4   C                   If        ARASCR1 <> 0
     C                   MOVEL     ARASCR1       SACSQ
x4   C                   Else
     C                   EVAL      SACSQ = '01'
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR1       BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = ARBCCR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI1 = 'D'
     C                   ELSE
     C                   EVAL      BDLXDCI1 = 'C'
     C                   ENDIF
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
x3   C                   Else
b4   C                   If        PCRF = '2'
     C                   EVAL      SBRCA = ARBCCR2
     C                   MOVEL     ARACCR2       SACOD
b5   C                   If        ARASCR2 <> 0
     C                   MOVEL     ARASCR2       SACSQ
x5   C                   Else
     C                   EVAL      SACSQ = '01'
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR2       BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = ARBCCR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI2 = 'D'
     C                   ELSE
     C                   EVAL      BDLXDCI2 = 'C'
     C                   ENDIF
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
x4   C                   Else
b5   C                   If        PCRF = '3'
     C                   MOVEL     ARACCR3       SACOD
b6   C                   If        ARASCR3 <> 0
     C                   MOVEL     ARASCR3       SACSQ
x6   C                   Else
     C                   EVAL      SACSQ = '01'
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR3       BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = ARBCCR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDLXDCI3 = 'D'
     C                   ELSE
     C                   EVAL      BDLXDCI3 = 'C'
     C                   ENDIF
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
 
     C                   IF        IFRVID = 'Y'
     C                   EVAL      BDSADR = SETTACC
     C                   ELSE
     C                   EVAL      BDSACR = SETTACC
     C                   ENDIF
e2   C                   Endif
e1   C                   Endif
 
 
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
b2   C                   If        PDRF = '1'
b2   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR1 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNDR1 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACDR1
b3   C                   If        ARASDR1 <> 0
     C                   EVAL      BDASDR1 = ARASDR1
x3   C                   Else
     C                   EVAL      BDASDR1 = 01
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACDR1
     C                   EVAL      WAACSQ = BDASDR1
      *
     C                   ELSE
     C                   EVAL      BDBCCR1 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNCR1 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACDR1
b3   C                   If        ARASDR1 <> 0
     C                   EVAL      BDASCR1 = ARASDR1
x3   C                   Else
     C                   EVAL      BDASCR1 = 01
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACDR1
     C                   EVAL      WAACSQ = BDASCR1
x2   C                   ENDIF
      *
x2   C                   Else
b3   C                   If        PDRF = '2'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR2 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNDR2 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACDR2
b4   C                   If        ARASDR2 <> 0
     C                   EVAL      BDASDR2 = ARASDR2
x4   C                   Else
     C                   EVAL      BDASDR2 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACDR2
     C                   EVAL      WAACSQ = BDASDR2
x3   C                   ELSE
     C                   EVAL      BDBCCR2 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNCR2 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACDR2
b4   C                   If        ARASDR2 <> 0
     C                   EVAL      BDASCR2 = ARASDR2
x4   C                   Else
     C                   EVAL      BDASCR2 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR2
     C                   EVAL      WAACSQ = BDASCR2
      *
x3   C                   ENDIF
x3   C                   Else
b4   C                   If        PDRF = '3'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR3 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNDR3 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACDR3
b5   C                   If        ARASDR3 <> 0
     C                   EVAL      BDASDR3 = ARASDR3
x5   C                   Else
     C                   EVAL      BDASDR3 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACDR3
     C                   EVAL      WAACSQ = BDASDR3
e4   C                   ELSE
     C                   EVAL      BDBCCR3 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNCR3 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACDR3
b5   C                   If        ARASDR3 <> 0
     C                   EVAL      BDASCR3 = ARASDR3
x5   C                   Else
     C                   EVAL      BDASCR3 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACDR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACDR3
     C                   EVAL      WAACSQ = BDASCR3
e4   C                   ENDIF
      *
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
x1   C                   Else
 
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
 
b3   C                   If        PCRF = '1'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR1 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNCR1 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACCR1
b4   C                   If        ARASCR1 <> 0
     C                   EVAL      BDASCR1 = ARASCR1
x4   C                   Else
     C                   EVAL      BDASCR1 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR1
     C                   EVAL      WAACSQ = BDASCR1
x3   C                   ELSE
     C                   EVAL      BDBCDR1 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNDR1 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACCR1
b4   C                   If        ARASCR1 <> 0
     C                   EVAL      BDASDR1 = ARASCR1
x4   C                   Else
     C                   EVAL      BDASDR1 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR1
     C                   EVAL      WAACSQ = BDASDR1
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PCRF = '2'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR2 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNCR2 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACCR2
b5   C                   If        ARASCR2 <> 0
     C                   EVAL      BDASCR2 = ARASCR2
x5   C                   Else
     C                   EVAL      BDASCR2 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR2
     C                   EVAL      WAACSQ = BDASCR2
x4   C                   ELSE
     C                   EVAL      BDBCDR2 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNDR2 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACCR2
b5   C                   If        ARASCR2 <> 0
     C                   EVAL      BDASDR2 = ARASCR2
x5   C                   Else
     C                   EVAL      BDASDR2 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR2
     C                   EVAL      WAACSQ = BDASDR2
x4   C                   ENDIF
      *
x4   C                   Else
b5   C                   If        PCRF = '3'
b5   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR3 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNCR3 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACCR3
b6   C                   If        ARASCR3 <> 0
     C                   EVAL      BDASCR3 = ARASCR3
x6   C                   Else
     C                   EVAL      BDASCR3 = 01
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR3
     C                   EVAL      WAACSQ = BDASCR3
e5   C                   ELSE
     C                   EVAL      BDBCDR3 = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      BDCNDR3 = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     A8BICN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACCR3
b6   C                   If        ARASCR3 <> 0
     C                   EVAL      BDASDR3 = ARASCR3
x6   C                   Else
     C                   EVAL      BDASDR3 = 01
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     ARACCR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDIBCA        WABRCA
     C                   EVAL      WAACOD = ARACCR3
     C                   EVAL      WAACSQ = BDASDR3
e5   C                   ENDIF
      *
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
e1   C                   Endif
 
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSRF2 - Postings Details for Posting Ref 2                  *
      *                                                               *
      *****************************************************************
     C     POSRF2        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSRF2                 '            MD027197
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
     C                   IF        BDSADR <> *BLANKS                                        MD025566
     C                   EVAL      SETTACC = BDSADR
     C                   ELSE                                                               MD025566
     C                   EVAL      SETTACC = BDSACR                                         MD025566
     C                   ENDIF                                                              MD025566
b2   C                   If        PDRF = '1'
     C                   IF        IFRVID = 'N'
     C                   EVAL      BDBCDR1 = SBRCA
     C                   EVAL      BDCNDR1 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACDR1
     C                   MOVEL     SACSQ         BDASDR1
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = BDBCDR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
x2   C                   ELSE
     C**********         EVAL      BDSACR = BDSADR                                          MD025566
     C                   EVAL      BDSACR = IFSADR                                          MD025566
     C                   EVAL      BDSADR = IFSACR                                          MD025566
     C                   EVAL      BDBCCR1 = SBRCA
     C                   EVAL      BDCNCR1 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACCR1
     C                   MOVEL     SACSQ         BDASCR1
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = BDBCCR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
x2   C                   ENDIF
      *
x2   C                   Else
b3   C                   If        PDRF = '2'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR2 = SBRCA
     C                   EVAL      BDCNDR2 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACDR2
     C                   MOVEL     SACSQ         BDASDR2
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = BDBCDR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
x3   C                   ELSE
     C**********         EVAL      BDSACR = BDSADR                                          MD025566
     C                   EVAL      BDSACR = IFSADR                                          MD025566
     C                   EVAL      BDSADR = IFSACR                                          MD025566
     C                   EVAL      BDBCCR2 = SBRCA
     C                   EVAL      BDCNCR2 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACCR2
     C                   MOVEL     SACSQ         BDASCR2
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = BDBCCR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PDRF = '3'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR3 = SBRCA
     C                   EVAL      BDCNDR3 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACDR3
     C                   MOVEL     SACSQ         BDASDR3
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = BDBCDR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
e4   C                   ELSE
     C**********         EVAL      BDSACR = BDSADR                                          MD025566
     C                   EVAL      BDSACR = IFSADR                                          MD025566
     C                   EVAL      BDSADR = IFSACR                                          MD025566
     C                   EVAL      BDBCCR3 = SBRCA
     C                   EVAL      BDCNCR3 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACCR3
     C                   MOVEL     SACSQ         BDASCR3
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = BDBCCR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
e4   C                   ENDIF
      *
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
x1   C                   Else
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
b2   C                   IF        BDSACR <> *BLANKS                                        MD025566
     C                   EVAL      SETTACC = BDSACR
     C                   ELSE                                                               MD025566
     C                   EVAL      SETTACC = BDSADR                                         MD025566
     C                   ENDIF                                                              MD025566
b3   C                   If        PCRF = '1'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR1 = SBRCA
     C                   EVAL      BDCNCR1 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACCR1
     C                   MOVEL     SACSQ         BDASCR1
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = BDBCCR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
x3   C                   ELSE
     C**********         EVAL      BDSADR = BDSACR                                          MD025566
     C                   EVAL      BDSADR = IFSACR                                          MD025566
     C                   EVAL      BDSACR = IFSADR                                          MD025566
     C                   EVAL      BDBCDR1 = SBRCA
     C                   EVAL      BDCNDR1 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACDR1
     C                   MOVEL     SACSQ         BDASDR1
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = BDBCDR1
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREDIT                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PCRF = '2'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR2 = SBRCA
     C                   EVAL      BDCNCR2 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACCR2
     C                   MOVEL     SACSQ         BDASCR2
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = BDBCCR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
x4   C                   ELSE
     C**********         EVAL      BDSADR = BDSACR                                          MD025566
     C                   EVAL      BDSADR = IFSACR                                          MD025566
     C                   EVAL      BDSACR = IFSADR                                          MD025566
     C                   EVAL      BDBCDR2 = SBRCA
     C                   EVAL      BDCNDR2 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACDR2
     C                   MOVEL     SACSQ         BDASDR2
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = BDBCDR2
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
x4   C                   ENDIF
      *
x4   C                   Else
b5   C                   If        PCRF = '3'
b5   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR3 = SBRCA
     C                   EVAL      BDCNCR3 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACCR3
     C                   MOVEL     SACSQ         BDASCR3
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = BDBCCR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
e5   C                   ELSE
     C**********         EVAL      BDSADR = BDSACR                                          MD025566
     C                   EVAL      BDSADR = IFSACR                                          MD025566
     C                   EVAL      BDSACR = IFSADR                                          MD025566
     C                   EVAL      BDBCDR3 = SBRCA
     C                   EVAL      BDCNDR3 = SCUST
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     SACOD         BDACDR3
     C                   MOVEL     SACSQ         BDASDR3
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = BDBCDR3
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     SCUST         WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     SBRCA         WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
e5   C                   ENDIF
      *
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSRF3 - Postings Details for Posting Ref 3                  *
      *                                                               *
      *****************************************************************
     C     POSRF3        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSR3                  '            MD027197
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
b2   C                   If        PDRF = '1'
b1   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR1 = IFBKBR
     C                   EVAL      BDCNDR1 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACDR1
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASDR1 = PSEQNUM                                        MD024348
b3   C**********         If        ARASDR1 <> 0                                             MD024348
     C**********         EVAL      BDASDR1 = ARASDR1                                        MD024348
x3   C**********         Else                                                               MD024348
     C**********         EVAL      BDASDR1 = 01                                             MD024348
e3   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR1       WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR1       SBRCA
     C                   MOVEL     BDCNDR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR1       SACOD
     C                   MOVEL     BDASDR1       SACSQ
     C                   EVAL      BDSADR = SETTACC
x2   C                   ELSE
     C                   EVAL      BDBCCR1 = IFBKBR
     C                   EVAL      BDCNCR1 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACDR1
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASCR1 = PSEQNUM                                        MD024348
b3   C**********         If        ARASDR1 <> 0                                             MD024348
     C**********         EVAL      BDASCR1 = ARASDR1                                        MD024348
x3   C**********         Else                                                               MD024348
     C**********         EVAL      BDASCR1 = 01                                             MD024348
e3   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR1       WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR1       SBRCA
     C                   MOVEL     BDCNCR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR1       SACOD
     C                   MOVEL     BDASCR1       SACSQ
     C                   EVAL      BDSACR = SETTACC
x2   C                   ENDIF
      *
x2   C                   Else
b3   C                   If        PDRF = '2'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR2 = IFBKBR
     C                   EVAL      BDCNDR2 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACDR2
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASDR2 = PSEQNUM                                        MD024348
b4   C**********         If        ARASDR2 <> 0                                             MD024348
     C**********         EVAL      BDASDR2 = ARASDR2                                        MD024348
x4   C**********         Else                                                               MD024348
     C**********         EVAL      BDASDR2 = 01                                             MD024348
e4   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR2       SBRCA
     C                   MOVEL     BDCNDR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR2       SACOD
     C                   MOVEL     BDASDR2       SACSQ
     C                   EVAL      BDSADR = SETTACC
x3   C                   ELSE
     C                   EVAL      BDBCCR2 = IFBKBR
     C                   EVAL      BDCNCR2 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACDR2
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASCR2 = PSEQNUM                                        MD024348
b4   C**********         If        ARASDR2 <> 0                                             MD024348
     C**********         EVAL      BDASCR2 = ARASDR2                                        MD024348
x4   C**********         Else                                                               MD024348
     C**********         EVAL      BDASCR2 = 01                                             MD024348
e4   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR2       SBRCA
     C                   MOVEL     BDCNCR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR2       SACOD
     C                   MOVEL     BDASCR2       SACSQ
     C                   EVAL      BDSACR = SETTACC
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PDRF = '3'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR3 = IFBKBR
     C                   EVAL      BDCNDR3 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACDR3
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASDR3 = PSEQNUM                                        MD024348
b5   C**********         If        ARASDR3 <> 0                                             MD024348
     C**********         EVAL      BDASDR3 = ARASDR3                                        MD024348
x5   C**********         Else                                                               MD024348
     C**********         EVAL      BDASDR3 = 01                                             MD024348
e5   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR3       WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR3       SBRCA
     C                   MOVEL     BDCNDR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR3       SACOD
     C                   MOVEL     BDASDR3       SACSQ
     C                   EVAL      BDSADR = SETTACC
e4   C                   ELSE
     C                   EVAL      BDBCCR3 = IFBKBR
     C                   EVAL      BDCNCR3 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACDR3
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASCR3 = PSEQNUM                                        MD024348
b5   C**********         If        ARASDR3 <> 0                                             MD024348
     C**********         EVAL      BDASCR3 = ARASDR3                                        MD024348
x5   C**********         Else                                                               MD024348
     C**********         EVAL      BDASCR3 = 01                                             MD024348
e5   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR3       SBRCA
     C                   MOVEL     BDCNCR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR3       SACOD
     C                   MOVEL     BDASCR3       SACSQ
     C                   EVAL      BDSACR = SETTACC
e4   C                   ENDIF
      *
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
x1   C                   Else
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
 
b3   C                   If        PCRF = '1'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR1 = IFBKBR
     C                   EVAL      BDCNCR1 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACCR1
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASCR1 = PSEQNUM                                        MD024348
b4   C**********         If        ARASCR1 <> 0                                             MD024348
     C**********         EVAL      BDASCR1 = ARASCR1                                        MD024348
x4   C**********         Else                                                               MD024348
     C**********         EVAL      BDASCR1 = 01                                             MD024348
e4   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR1       WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR1       SBRCA
     C                   MOVEL     BDCNCR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR1       SACOD
     C                   MOVEL     BDASCR1       SACSQ
     C                   EVAL      BDSACR = SETTACC
x3   C                   ELSE
     C                   EVAL      BDBCDR1 = IFBKBR
     C                   EVAL      BDCNDR1 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACCR1
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASDR1 = PSEQNUM                                        MD024348
b4   C**********         If        ARASCR1 <> 0                                             MD024348
     C**********         EVAL      BDASDR1 = ARASCR1                                        MD024348
x4   C**********         Else                                                               MD024348
     C**********         EVAL      BDASDR1 = 01                                             MD024348
e4   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR1       WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR1       SBRCA
     C                   MOVEL     BDCNDR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR1       SACOD
     C                   MOVEL     BDASDR1       SACSQ
     C                   EVAL      BDSADR = SETTACC
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PCRF = '2'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR2 = IFBKBR
     C                   EVAL      BDCNCR2 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACCR2
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASCR2 = PSEQNUM                                        MD024348
b5   C**********         If        ARASCR2 <> 0                                             MD024348
     C**********         EVAL      BDASCR2 = ARASCR2                                        MD024348
x5   C**********         Else                                                               MD024348
     C**********         EVAL      BDASCR2 = 01                                             MD024348
e5   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR2       WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR2       SBRCA
     C                   MOVEL     BDCNCR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR2       SACOD
     C                   MOVEL     BDASCR2       SACSQ
     C                   EVAL      BDSACR = SETTACC
x4   C                   ELSE
     C                   EVAL      BDBCDR2 = IFBKBR
     C                   EVAL      BDCNDR2 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACCR2
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASDR2 = PSEQNUM                                        MD024348
b5   C**********         If        ARASCR2 <> 0                                             MD024348
     C**********         EVAL      BDASDR2 = ARASCR2                                        MD024348
x5   C**********         Else                                                               MD024348
     C**********         EVAL      BDASDR2 = 01                                             MD024348
e5   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR2       SBRCA
     C                   MOVEL     BDCNDR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR2       SACOD
     C                   MOVEL     BDASDR2       SACSQ
     C                   EVAL      BDSADR = SETTACC
x4   C                   ENDIF
      *
x4   C                   Else
b5   C                   If        PCRF = '3'
b5   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR3 = IFBKBR
     C                   EVAL      BDCNCR3 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACCR3
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASCR3 = PSEQNUM                                        MD024348
b6   C**********         If        ARASCR3 <> 0                                             MD024348
     C**********         EVAL      BDASCR3 = ARASCR3                                        MD024348
x6   C**********         Else                                                               MD024348
     C**********         EVAL      BDASCR3 = 01                                             MD024348
e6   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR3       SBRCA
     C                   MOVEL     BDCNCR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR3       SACOD
     C                   MOVEL     BDASCR3       SACSQ
     C                   EVAL      BDSACR = SETTACC
e5   C                   ELSE
     C                   EVAL      BDBCDR3 = IFBKBR
     C                   EVAL      BDCNDR3 = IFCTPY
      ** Retrieve Customer details
     C                   MOVEL     IFCTPY        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACCR3
     C                   EXSR      POSSEQ                                                   MD024348
     C                   EVAL      BDASDR3 = PSEQNUM                                        MD024348
b6   C**********         If        ARASCR3 <> 0                                             MD024348
     C**********         EVAL      BDASDR3 = ARASCR3                                        MD024348
x6   C**********         Else                                                               MD024348
     C**********         EVAL      BDASDR3 = 01                                             MD024348
e6   C**********         Endif                                                              MD024348
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR3       SBRCA
     C                   MOVEL     BDCNDR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR3       SACOD
     C                   MOVEL     BDASDR3       SACSQ
     C                   EVAL      BDSADR = SETTACC
e5   C                   ENDIF
      *
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
 
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************                     MD024348
      /EJECT                                                                                MD024348
      *****************************************************************                     MD024348
      *                                                               *                     MD024348
      *  POSSEQ - Posting Reference 3, Account Sequence for           *                     MD024348
      *           Nostro and Non Nostro                               *                     MD024348
      *                                                               *                     MD024348
      *****************************************************************                     MD024348
     C     POSSEQ        BEGSR                                                              MD024348
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSSEQ                 '            MD027197
      *                                                                                     MD024348
     C                   Z-ADD     *ZERO         PSEQNUM           2 0                      MD024348
      *                                                                                     MD024348
      ** If Debit and Settlement Account Debit is not blank                                 MD024348
b1   C     IFDCIP        IFEQ      'D'                                                      MD024348
     C     IFSADR        ANDNE     *BLANKS                                                  MD024348
     C                   EVAL      SETTACC = IFSADR                                         MD024348
     C                   ELSE                                                               MD024348
      *                                                                                     MD024348
      ** OR If Credit and Settlement Account Credit is not blank                            MD024348
     C     IFDCIP        IFEQ      'C'                                                      MD024348
     C     IFSACR        ANDNE     *BLANKS                                                  MD024348
     C                   EVAL      SETTACC = IFSACR                                         MD024348
     C                   ENDIF                                                              MD024348
     C                   ENDIF                                                              MD024348
      *                                                                                     MD024348
      ** Access Nostro details                                                              MD024348
     C                   EXSR      NOSTRO                                                   MD024348
      *                                                                                     MD024348
      ** If found, access extension file SDNOST2D to check for Unreconciled A/C Code        MD024348
      ** for Unreconciled Account Code                                                      MD024348
     C/Exec SQL                                                                             MD024348
     C+                  Select * into :NOST2D                                              MD024348
     C+                           from SDNOST2D                                             MD024348
     C+                          where ERNONB = :WNONB                                      MD024348
     C+                          and   ERCYCD = :WCYCD                                      MD024348
     C/End-Exec                                                                             MD024348
      *                                                                                     MD024348
      ** If Nostro found in Extension file                                                  MD024348
     C                   If        SQLCOD = 0                                               MD024348
      *                                                                                     MD024348
      ** If Unreconciled Account Code exists                                                MD024348
     C                   If        ERACCD <> 0                                              MD024348
     C                   EVAL      PSEQNUM = ERACSN                                         MD024348
     C                   Else                                                               MD024348
      ** If Unreconciled Account Code does not exist                                        MD024348
      **                                                                                    MD024348
     C                   EVAL      PSEQNUM = 01                                             MD024348
     C                   Endif                                                              MD024348
      *                                                                                     MD024348
     C                   Else                                                               MD024348
      ** If Nostro not found in Extension file                                              MD024348
     C                   EVAL      PSEQNUM = 01                                             MD024348
     C                   Endif                                                              MD024348
      *                                                                                     MD024348
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR                                                              MD024348
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSRF4 - Postings Details for Posting Ref 4                  *
      *                                                               *
      *****************************************************************
     C     POSRF4        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSRF4                 '            MD027197
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
b2   C                   If        PDRF = '1'
b2   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR1 = IFBKBR
     C                   EVAL      BDCNDR1 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACDR1
b3   C                   If        ARASDR1 <> 0
     C                   EVAL      BDASDR1 = ARASDR1
x3   C                   Else
     C                   EVAL      BDASDR1 = 01
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR1       WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR1       SBRCA
     C                   MOVEL     BDCNDR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR1       SACOD
     C                   MOVEL     BDASDR1       SACSQ
     C                   EVAL      BDSADR = SETTACC
x2   C                   ELSE
     C                   EVAL      BDBCCR1 = IFBKBR
     C                   EVAL      BDCNCR1 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACDR1
b3   C                   If        ARASDR1 <> 0
     C                   EVAL      BDASCR1 = ARASDR1
x3   C                   Else
     C                   EVAL      BDASCR1 = 01
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR1       WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR1       SBRCA
     C                   MOVEL     BDCNCR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR1       SACOD
     C                   MOVEL     BDASCR1       SACSQ
     C                   EVAL      BDSACR = SETTACC
x2   C                   ENDIF
      *
x2   C                   Else
b3   C                   If        PDRF = '2'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR2 = IFBKBR
     C                   EVAL      BDCNDR2 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACDR2
b4   C                   If        ARASDR2 <> 0
     C                   EVAL      BDASDR2 = ARASDR2
x4   C                   Else
     C                   EVAL      BDASDR2 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR2       SBRCA
     C                   MOVEL     BDCNDR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR2       SACOD
     C                   MOVEL     BDASDR2       SACSQ
     C                   EVAL      BDSADR = SETTACC
x3   C                   ELSE
     C                   EVAL      BDBCCR2 = IFBKBR
     C                   EVAL      BDCNCR2 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACDR2
b4   C                   If        ARASDR2 <> 0
     C                   EVAL      BDASCR2 = ARASDR2
x4   C                   Else
     C                   EVAL      BDASCR2 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR2       WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR2       SBRCA
     C                   MOVEL     BDCNCR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR2       SACOD
     C                   MOVEL     BDASCR2       SACSQ
     C                   EVAL      BDSACR = SETTACC
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PDRF = '3'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR3 = IFBKBR
     C                   EVAL      BDCNDR3 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACDR3
b5   C                   If        ARASDR3 <> 0
     C                   EVAL      BDASDR3 = ARASDR3
x5   C                   Else
     C                   EVAL      BDASDR3 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR3       WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR3       SBRCA
     C                   MOVEL     BDCNDR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR3       SACOD
     C                   MOVEL     BDASDR3       SACSQ
     C                   EVAL      BDSADR = SETTACC
e4   C                   ELSE
     C                   EVAL      BDBCCR3 = IFBKBR
     C                   EVAL      BDCNCR3 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACDR3
b5   C                   If        ARASDR3 <> 0
     C                   EVAL      BDASCR3 = ARASDR3
x5   C                   Else
     C                   EVAL      BDASCR3 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR3       SBRCA
     C                   MOVEL     BDCNCR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR3       SACOD
     C                   MOVEL     BDASCR3       SACSQ
     C                   EVAL      BDSACR = SETTACC
e4   C                   ENDIF
      *
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
x1   C                   Else
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
 
b3   C                   If        PCRF = '1'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR1 = IFBKBR
     C                   EVAL      BDCNCR1 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACCR1
b4   C                   If        ARASCR1 <> 0
     C                   EVAL      BDASCR1 = ARASCR1
x4   C                   Else
     C                   EVAL      BDASCR1 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR1       WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR1       SBRCA
     C                   MOVEL     BDCNCR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR1       SACOD
     C                   MOVEL     BDASCR1       SACSQ
     C                   EVAL      BDSACR = SETTACC
x3   C                   ELSE
     C                   EVAL      BDBCDR1 = IFBKBR
     C                   EVAL      BDCNDR1 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACCR1
b4   C                   If        ARASCR1 <> 0
     C                   EVAL      BDASDR1 = ARASCR1
x4   C                   Else
     C                   EVAL      BDASDR1 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR1       WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR1       SBRCA
     C                   MOVEL     BDCNDR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR1       SACOD
     C                   MOVEL     BDASDR1       SACSQ
     C                   EVAL      BDSADR = SETTACC
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PCRF = '2'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR2 = IFBKBR
     C                   EVAL      BDCNCR2 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACCR1
b5   C                   If        ARASCR2 <> 0
     C                   EVAL      BDASCR2 = ARASCR2
x5   C                   Else
     C                   EVAL      BDASCR2 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR2       WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR2       SBRCA
     C                   MOVEL     BDCNCR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR2       SACOD
     C                   MOVEL     BDASCR2       SACSQ
     C                   EVAL      BDSACR = SETTACC
x4   C                   ELSE
     C                   EVAL      BDBCDR2 = IFBKBR
     C                   EVAL      BDCNDR2 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACCR1
b5   C                   If        ARASCR2 <> 0
     C                   EVAL      BDASDR2 = ARASCR2
x5   C                   Else
     C                   EVAL      BDASDR2 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR2       SBRCA
     C                   MOVEL     BDCNDR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR2       SACOD
     C                   MOVEL     BDASDR2       SACSQ
     C                   EVAL      BDSADR = SETTACC
x4   C                   ENDIF
      *
x4   C                   Else
b5   C                   If        PCRF = '3'
b5   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR3 = IFBKBR
     C                   EVAL      BDCNCR3 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACCR1
b6   C                   If        ARASCR3 <> 0
     C                   EVAL      BDASCR3 = ARASCR3
x6   C                   Else
     C                   EVAL      BDASCR3 = 01
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR3       SBRCA
     C                   MOVEL     BDCNCR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR3       SACOD
     C                   MOVEL     BDASCR3       SACSQ
     C                   EVAL      BDSACR = SETTACC
e5   C                   ELSE
     C                   EVAL      BDBCDR3 = IFBKBR
     C                   EVAL      BDCNDR3 = IFDPCN
      ** Retrieve Customer details
     C                   MOVEL     IFDPCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACCR1
b6   C                   If        ARASCR3 <> 0
     C                   EVAL      BDASDR3 = ARASCR3
x6   C                   Else
     C                   EVAL      BDASDR3 = 01
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR3       WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR3       SBRCA
     C                   MOVEL     BDCNDR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR3       SACOD
     C                   MOVEL     BDASDR3       SACSQ
     C                   EVAL      BDSADR = SETTACC
e5   C                   ENDIF
      *
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
 
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSRF5 - Postings Details for Posting Ref 5                  *
      *                                                               *
      *****************************************************************
     C     POSRF5        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSRF5                 '            MD027197
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
 
      ** IF DEBIT
b1   C                   If        WDDCIN = 'D'
b2   C                   If        PDRF = '1'
b2   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR1 = IFBKBR
     C                   EVAL      BDCNDR1 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACDR1
b3   C                   If        ARASDR1 <> 0
     C                   EVAL      BDASDR1 = ARASDR1
x3   C                   Else
     C                   EVAL      BDASDR1 = 01
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR1       WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR1       SBRCA
     C                   MOVEL     BDCNDR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR1       SACOD
     C                   MOVEL     BDASDR1       SACSQ
     C                   EVAL      BDSADR = SETTACC
x2   C                   ELSE
     C                   EVAL      BDBCCR1 = IFBKBR
     C                   EVAL      BDCNCR1 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACDR1
b3   C                   If        ARASDR1 <> 0
     C                   EVAL      BDASCR1 = ARASDR1
x3   C                   Else
     C                   EVAL      BDASCR1 = 01
e3   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR1       WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR1       SBRCA
     C                   MOVEL     BDCNCR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR1       SACOD
     C                   MOVEL     BDASCR1       SACSQ
     C                   EVAL      BDSACR = SETTACC
x2   C                   ENDIF
      *
x2   C                   Else
b3   C                   If        PDRF = '2'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR2 = IFBKBR
     C                   EVAL      BDCNDR2 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACDR2
b4   C                   If        ARASDR2 <> 0
     C                   EVAL      BDASDR2 = ARASDR2
x4   C                   Else
     C                   EVAL      BDASDR2 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR2       SBRCA
     C                   MOVEL     BDCNDR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR2       SACOD
     C                   MOVEL     BDASDR2       SACSQ
     C                   EVAL      BDSADR = SETTACC
x3   C                   ELSE
     C                   EVAL      BDBCCR2 = IFBKBR
     C                   EVAL      BDCNCR2 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACDR2
b4   C                   If        ARASDR2 <> 0
     C                   EVAL      BDASCR2 = ARASDR2
x4   C                   Else
     C                   EVAL      BDASCR2 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR2       WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR2       SBRCA
     C                   MOVEL     BDCNCR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR2       SACOD
     C                   MOVEL     BDASCR2       SACSQ
     C                   EVAL      BDSACR = SETTACC
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PDRF = '3'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCDR3 = IFBKBR
     C                   EVAL      BDCNDR3 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACDR3
b5   C                   If        ARASDR3 <> 0
     C                   EVAL      BDASDR3 = ARASDR3
x5   C                   Else
     C                   EVAL      BDASDR3 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR3       WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR3       SBRCA
     C                   MOVEL     BDCNDR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR3       SACOD
     C                   MOVEL     BDASDR3       SACSQ
     C                   EVAL      BDSADR = SETTACC
e4   C                   ELSE
     C                   EVAL      BDBCCR3 = IFBKBR
     C                   EVAL      BDCNCR3 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACDR3
b5   C                   If        ARASDR3 <> 0
     C                   EVAL      BDASCR3 = ARASDR3
x5   C                   Else
     C                   EVAL      BDASCR3 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR3       SBRCA
     C                   MOVEL     BDCNCR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR3       SACOD
     C                   MOVEL     BDASCR3       SACSQ
     C                   EVAL      BDSACR = SETTACC
e4   C                   ENDIF
      *
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
x1   C                   Else
      ** IF CREDIT
b2   C                   If        WDDCIN = 'C'
 
b3   C                   If        PCRF = '1'
b3   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR1 = IFBKBR
     C                   EVAL      BDCNCR1 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR1 = ARACCR1
b4   C                   If        ARASCR1 <> 0
     C                   EVAL      BDASCR1 = ARASCR1
x4   C                   Else
     C                   EVAL      BDASCR1 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR1       BDACCD
     C                   MOVEL     BDASCR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR1       WABRCA
     C                   EVAL      WAACOD = BDACCR1
     C                   EVAL      WAACSQ = BDASCR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR1       SBRCA
     C                   MOVEL     BDCNCR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR1       SACOD
     C                   MOVEL     BDASCR1       SACSQ
     C                   EVAL      BDSACR = SETTACC
x3   C                   ELSE
     C                   EVAL      BDBCDR1 = IFBKBR
     C                   EVAL      BDCNDR1 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR1 = ARACCR1
b4   C                   If        ARASCR1 <> 0
     C                   EVAL      BDASDR1 = ARASCR1
x4   C                   Else
     C                   EVAL      BDASDR1 = 01
e4   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR1       BDACCD
     C                   MOVEL     BDASDR1       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR1       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR1       WABRCA
     C                   EVAL      WAACOD = BDACDR1
     C                   EVAL      WAACSQ = BDASDR1
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR1       SBRCA
     C                   MOVEL     BDCNDR1       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR1       SACOD
     C                   MOVEL     BDASDR1       SACSQ
     C                   EVAL      BDSADR = SETTACC
x3   C                   ENDIF
      *
x3   C                   Else
b4   C                   If        PCRF = '2'
b4   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR2 = IFBKBR
     C                   EVAL      BDCNCR2 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR2 = ARACCR1
b5   C                   If        ARASCR2 <> 0
     C                   EVAL      BDASCR2 = ARASCR2
x5   C                   Else
     C                   EVAL      BDASCR2 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR2       BDACCD
     C                   MOVEL     BDASCR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'C'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR2       WABRCA
     C                   EVAL      WAACOD = BDACCR2
     C                   EVAL      WAACSQ = BDASCR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR2       SBRCA
     C                   MOVEL     BDCNCR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR2       SACOD
     C                   MOVEL     BDASCR2       SACSQ
     C                   EVAL      BDSACR = SETTACC
x4   C                   ELSE
     C                   EVAL      BDBCDR2 = IFBKBR
     C                   EVAL      BDCNDR2 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR2 = ARACCR1
b5   C                   If        ARASCR2 <> 0
     C                   EVAL      BDASDR2 = ARASCR2
x5   C                   Else
     C                   EVAL      BDASDR2 = 01
e5   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR2       BDACCD
     C                   MOVEL     BDASDR2       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA2                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA2                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA2                                   MD027202
     C                   EVAL      BDLXDCI2 = 'D'
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR2       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR2       WABRCA
     C                   EVAL      WAACOD = BDACDR2
     C                   EVAL      WAACSQ = BDASDR2
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR2       SBRCA
     C                   MOVEL     BDCNDR2       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR2       SACOD
     C                   MOVEL     BDASDR2       SACSQ
     C                   EVAL      BDSADR = SETTACC
x4   C                   ENDIF
      *
x4   C                   Else
b5   C                   If        PCRF = '3'
b5   C                   If        IFRVID = 'N'
     C                   EVAL      BDBCCR3 = IFBKBR
     C                   EVAL      BDCNCR3 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACCR3 = ARACCR1
b6   C                   If        ARASCR3 <> 0
     C                   EVAL      BDASCR3 = ARASCR3
x6   C                   Else
     C                   EVAL      BDASCR3 = 01
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACCR3       BDACCD
     C                   MOVEL     BDASCR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'C'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNCR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCCR3       WABRCA
     C                   EVAL      WAACOD = BDACCR3
     C                   EVAL      WAACSQ = BDASCR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCCR3       SBRCA
     C                   MOVEL     BDCNCR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACCR3       SACOD
     C                   MOVEL     BDASCR3       SACSQ
     C                   EVAL      BDSACR = SETTACC
e5   C                   ELSE
     C                   EVAL      BDBCDR3 = IFBKBR
     C                   EVAL      BDCNDR3 = IFISCN
      ** Retrieve Customer details
     C                   MOVEL     IFISCN        @CNUM
     C                   EXSR      CUSTDT
     C                   EVAL      BDACDR3 = ARACCR1
b6   C                   If        ARASCR3 <> 0
     C                   EVAL      BDASDR3 = ARASCR3
x6   C                   Else
     C                   EVAL      BDASDR3 = 01
e6   C                   Endif
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     BDACDR3       BDACCD
     C                   MOVEL     BDASDR3       BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = IFDCIP
     C                   EVAL      BDLXPTA1 = *BLANKS
     C                   EVAL      BDLXDCI1 = ' '
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C****************** MOVE      IFEVTA        BDLXPTA3                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA3                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA3                                   MD027202
     C                   EVAL      BDLXDCI3 = 'D'
      ** Setup Account details key to access ACCNTAB
     C                   MOVEL     BDCNDR3       WACNUM
     C                   MOVEL     IFCCY         WACCY
     C                   MOVEL     BDBCDR3       WABRCA
     C                   EVAL      WAACOD = BDACDR3
     C                   EVAL      WAACSQ = BDASDR3
      ** Setup Settlement Account
     C                   MOVEL     BDBCDR3       SBRCA
     C                   MOVEL     BDCNDR3       SCUST
     C                   MOVEL     IFCCY         SCCY
     C                   MOVEL     BDACDR3       SACOD
     C                   MOVEL     BDASDR3       SACSQ
     C                   EVAL      BDSADR = SETTACC
e5   C                   ENDIF
      *
e5   C                   Endif
e4   C                   Endif
e3   C                   Endif
e2   C                   Endif
 
e1   C                   Endif
 
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
 
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLACIF - Setup Details from DIACIFTD to GLACBDTD             *
      *                                                               *
      *****************************************************************
     C     GLACIF        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'GLACIF                 '            MD027197
      *
      ** Batch Id
     C                   EVAL      BDBTID = IFBTID
      ** Booking Branch
     C                   EVAL      BDBKBR = IFBKBR
      ** Department Code
     C                   If        IFDPCD <> *BLANKS
     C                   EVAL      BDDPCD = IFDPCD
     C                   Else
     C                   EVAL      BDDPCD = WGDEPC
     C                   Endif
      ** Currency Code
     C                   EVAL      BDCCY  = IFCCY
      ** Event Amount
     C                   MOVE      IFEVTA        BDEVTA
      ** DR/CR Indicator
     C                   EVAL      BDDCIP = IFDCIP
      ** Posting Date
     C                   EVAL      BDPSTD = IFPSTD
      ** Event Date
     C                   EVAL      BDEVTD = IFEVTD
      ** Narrative
     C**********         EVAL      BDNARR = IFNARR                                          MD023988
      ***Narrative2*to*Narrative7**************************************                     MD023988
     C**********         EVAL      BDNAR2 = IFNAR2                                          MD023988
     C**********         EVAL      BDNAR3 = IFNAR3                                          MD023988
     C**********         EVAL      BDNAR4 = IFNAR4                                          MD023988
     C**********         EVAL      BDNAR5 = IFNAR5                                          MD023988
     C**********         EVAL      BDNAR6 = IFNAR6                                          MD023988
     C**********         EVAL      BDNAR7 = IFNAR7                                          MD023988
      *
     C                   If        WREL <> 'NMG'
      ** Settlement Account Debit
     C                   EVAL      BDSADR = IFSADR
      ** Settlement Account Credit
     C                   EVAL      BDSACR = IFSACR
     C                   ENDIF
      *
      ** Counterparty Customer
     C                   EVAL      BDCTPY = IFCTPY
      ** Depot Customer
     C                   EVAL      BDDPCN = IFDPCN
      ** Issuing Customer
     C                   EVAL      BDISCN = IFISCN
      ** Source Match Field 1 to Source Match Field 10
     C                   EVAL      BDSMT1 = IFSMTF1
     C                   EVAL      BDSMT2 = IFSMTF2
     C                   EVAL      BDSMT3 = IFSMTF3
     C                   EVAL      BDSMT4 = IFSMTF4
     C                   EVAL      BDSMT5 = IFSMTF5
     C                   EVAL      BDSMT6 = IFSMTF6
     C                   EVAL      BDSMT7 = IFSMTF7
     C                   EVAL      BDSMT8 = IFSMTF8
     C                   EVAL      BDSMT9 = IFSMTF9
     C                   EVAL      BDSMT10 = IFSMTF10
      ** Profit Centre
     C                   EVAL      BDPFCT = IFPFCT
      ** SWIFT Reference
     C                   EVAL      BDSWFR = IFSWFR
      ** Cheque Number
     C                   EVAL      BDCHQN = IFCHQN
      ** Associated Customer
     C                   EVAL      BDASCN = IFASCN
      ** Book Code
     C                   EVAL      BDBKCD = IFBKCD
      ** Customer Source Account Id
     C                   EVAL      BDCSAI = IFCSAI
      ** Source Customer
     C                   EVAL      BDSRCN = IFSRCN
      ** Operation Type
     C                   EVAL      BDOPTP = IFOPTP
      ** Forecast Reference
     C                   EVAL      BDFCRF = IFFCRF
      ** Cross Currency Indicator
     C                   EVAL      BDCXCYI = IFCXCYI
      ** Base Currency Equivalent Amount
     C                   EVAL      BDBCEQA = IFBCEQA
      ** Reversal Indicator
     C                   EVAL      BDRVID = IFRVID
      ** Forecast Status
     C                   EVAL      BDFSTA = IFFSTA
      ** Customer Account from Interface                                                    MD024772
     C                   EVAL      BICUSA = IFCUSA                                          MD024772
      ** Transaction Sub Type from Interface                                                MD024772
     C                   EVAL      BITSTY = IFTSTY                                          MD024772
      ** Transaction Sub Type                                                               MD024772
     C                   EVAL      BDTSTY = IFTSTY                                          MD024772
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GLACRU - Setup Details from GLACRUTD to GLACBDTD             *
      *                                                               *
      *****************************************************************
     C     GLACRU        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'GLACRU                 '            MD027197
      *
      ** Unique Id
     C                   EVAL      BDUNID = ARUNID
      ** Description                                                                        MD024513
     C                   EVAL      BDDESC = ARDESC                                          MD024513
      ** Transaction Type Debit
     C                   EVAL      BDTTDR = ARTTDR
      ** Transaction Type Credit
     C                   EVAL      BDTTCR = ARTTCR
      *
      ** Output Debit 1 details if BDDCIN = 'D' and PDRF = '1'
b2   C                   If        WDDCIN = 'D' AND
b2   C                             PDRF = '1' AND
b2   C                             IFRVID = 'N'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'D'
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = ARBCDR1
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = ARCNDR1
      ** Account Code Debit 1
     C                   EVAL      BDACDR1 = ARACDR1
      ** Account Sequence Debit 1
     C                   EVAL      BDASDR1 = ARASDR1
      ** Narrative Code Debit 1
     C                   EVAL      BDNADR1 = ARNADR1
      ** Received Narrative Debit 1
     C                   EVAL      BDRNDR1 = ARRNDR1
      ** Posting Ref Debit 1
     C                   EVAL      BDPRFD1 = ARPRFDR1
     C                   Else
b2   C                   If        WDDCIN = 'D' AND
b2   C                             PDRF = '1' AND
b2   C                             IFRVID = 'Y'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'C'
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = ARBCDR1
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = ARCNDR1
      ** Account Code Credit 1
     C                   EVAL      BDACCR1 = ARACDR1
      ** Account Sequence Credit 1
     C                   EVAL      BDASCR1 = ARASDR1
      ** Narrative Code Credit 1
     C                   EVAL      BDNACR1 = ARNADR1
      ** Received Narrative Credit 1
     C                   EVAL      BDRNCR1 = ARRNDR1
      ** Posting Ref Credit 1
     C                   EVAL      BDPRFC1 = ARPRFDR1
     C                   ENDIF
     C                   ENDIF
      *
      ** Output Debit 2 details if BDDCIN = 'D' and PDRF = '2'
b2   C                   If        WDDCIN = 'D' AND
b2   C                             PDRF = '2' AND
b2   C                             IFRVID = 'N'
      *
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'D'
      ** Branch Debit 2
     C                   EVAL      BDBCDR2 = ARBCDR2
      ** Customer Debit 2
     C                   EVAL      BDCNDR2 = ARCNDR2
      ** Account Code Debit 2
     C                   EVAL      BDACDR2 = ARACDR2
      ** Account Sequence Debit 2
     C                   EVAL      BDASDR2 = ARASDR2
      ** Narrative Code Debit 2
     C                   EVAL      BDNADR2 = ARNADR2
      ** Received Narrative Debit 2
     C                   EVAL      BDRNDR2 = ARRNDR2
      ** Posting Ref Debit 2
     C                   EVAL      BDPRFD2 = ARPRFDR2
     C                   Else
b2   C                   If        WDDCIN = 'D' AND
b2   C                             PDRF = '2' AND
b2   C                             IFRVID = 'Y'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'C'
      ** Branch Credit 2
     C                   EVAL      BDBCCR2 = ARBCDR2
      ** Customer Credit 2
     C                   EVAL      BDCNCR2 = ARCNDR2
      ** Account Code Credit 2
     C                   EVAL      BDACCR2 = ARACDR2
      ** Account Sequence Credit 2
     C                   EVAL      BDASCR2 = ARASDR2
      ** Narrative Code Credit 2
     C                   EVAL      BDNACR2 = ARNADR2
      ** Received Narrative Credit 2
     C                   EVAL      BDRNCR2 = ARRNDR2
      ** Posting Ref Credit 2
     C                   EVAL      BDPRFC2 = ARPRFDR2
     C                   ENDIF
     C                   ENDIF
      *
      ** Output Debit 3 details if BDDCIN = 'D' and PDRF = '3'
b2   C                   If        WDDCIN = 'D' AND
b2   C                             PDRF = '3' AND
b2   C                             IFRVID = 'N'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'D'
      ** Branch Debit 3
     C                   EVAL      BDBCDR3 = ARBCDR3
      ** Customer Debit 3
     C                   EVAL      BDCNDR3 = ARCNDR3
      ** Account Code Debit 3
     C                   EVAL      BDACDR3 = ARACDR3
      ** Account Sequence Debit 3
     C                   EVAL      BDASDR3 = ARASDR3
      ** Narrative Code Debit 3
     C                   EVAL      BDNADR3 = ARNADR3
      ** Received Narrative Debit 3
     C                   EVAL      BDRNDR3 = ARRNDR3
      ** Posting Ref Debit 3
     C                   EVAL      BDPRFD3 = ARPRFDR3
     C                   Else
b2   C                   If        WDDCIN = 'D' AND
b2   C                             PDRF = '3' AND
b2   C                             IFRVID = 'Y'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'C'
      ** Branch Credit 3
     C                   EVAL      BDBCCR3 = ARBCDR3
      ** Customer Credit 3
     C                   EVAL      BDCNCR3 = ARCNDR3
      ** Account Code Credit 3
     C                   EVAL      BDACCR3 = ARACDR3
      ** Account Sequence Credit 3
     C                   EVAL      BDASCR3 = ARASDR3
      ** Narrative Code Credit 3
     C                   EVAL      BDNACR3 = ARNADR3
      ** Received Narrative Credit 3
     C                   EVAL      BDRNCR3 = ARRNDR3
      ** Posting Ref Credit 3
     C                   EVAL      BDPRFC3 = ARPRFDR3
     C                   ENDIF
     C                   ENDIF
      *
      ** Output Credit 1 details if BDDCIN = 'C' and PCRF = '1'
b2   C                   If        WDDCIN = 'C' AND
b2   C                             PCRF = '1' AND
b2   C                             IFRVID = 'N'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'C'
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = ARBCCR1
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = ARCNCR1
      ** Account Code Credit 1
     C                   EVAL      BDACCR1 = ARACCR1
      ** Account Sequence Credit 1
     C                   EVAL      BDASCR1 = ARASCR1
      ** Narrative Code Credit 1
     C                   EVAL      BDNACR1 = ARNACR1
      ** Received Narrative Credit 1
     C                   EVAL      BDRNCR1 = ARRNCR1
      ** Posting Ref Credit 1
     C                   EVAL      BDPRFC1 = ARPRFCR1
     C                   Else
b2   C                   If        WDDCIN = 'C' AND
b2   C                             PCRF = '1' AND
b2   C                             IFRVID = 'Y'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'D'
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = ARBCCR1
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = ARCNCR1
      ** Account Code Debit 1
     C                   EVAL      BDACDR1 = ARACCR1
      ** Account Sequence Debit 1
     C                   EVAL      BDASDR1 = ARASCR1
      ** Narrative Code Debit 1
     C                   EVAL      BDNADR1 = ARNACR1
      ** Received Narrative Debit 1
     C                   EVAL      BDRNDR1 = ARRNCR1
      ** Posting Ref Debit 1
     C                   EVAL      BDPRFD1 = ARPRFCR1
     C                   ENDIF
     C                   ENDIF
      *
      ** Output Credit 2 details if BDDCIN = 'C' and PCRF = '2'
b2   C                   If        WDDCIN = 'C' AND
b2   C                             PCRF = '2' AND
b2   C                             IFRVID = 'N'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'C'
      ** Branch Credit 2
     C                   EVAL      BDBCCR2 = ARBCCR2
      ** Customer Credit 2
     C                   EVAL      BDCNCR2 = ARCNCR2
      ** Account Code Credit 2
     C                   EVAL      BDACCR2 = ARACCR2
      ** Account Sequence Credit 2
     C                   EVAL      BDASCR2 = ARASCR2
      ** Narrative Code Credit 2
     C                   EVAL      BDNACR2 = ARNACR2
      ** Received Narrative Credit 2
     C                   EVAL      BDRNCR2 = ARRNCR2
      ** Posting Ref Credit 2
     C                   EVAL      BDPRFC2 = ARPRFCR2
     C                   Else
b2   C                   If        WDDCIN = 'C' AND
b2   C                             PCRF = '2' AND
b2   C                             IFRVID = 'Y'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'D'
      ** Branch Debit 2
     C                   EVAL      BDBCDR2 = ARBCCR2
      ** Customer Debit 2
     C                   EVAL      BDCNDR2 = ARCNCR2
      ** Account Code Debit 2
     C                   EVAL      BDACDR2 = ARACCR2
      ** Account Sequence Debit 2
     C                   EVAL      BDASDR2 = ARASCR2
      ** Narrative Code Debit 2
     C                   EVAL      BDNADR2 = ARNACR2
      ** Received Narrative Debit 2
     C                   EVAL      BDRNDR2 = ARRNCR2
      ** Posting Ref Debit 2
     C                   EVAL      BDPRFD2 = ARPRFCR2
     C                   ENDIF
     C                   ENDIF
      *
      ** Output Credit 3 details if BDDCIN = 'C' and PCRF = '3'
b2   C                   If        WDDCIN = 'C' AND
b2   C                             PCRF = '3' AND
b2   C                             IFRVID = 'N'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'C'
      ** Branch Credit 3
     C                   EVAL      BDBCCR3 = ARBCCR3
      ** Customer Credit 3
     C                   EVAL      BDCNCR3 = ARCNCR3
      ** Account Code Credit 3
     C                   EVAL      BDACCR3 = ARACCR3
      ** Account Sequence Credit 3
     C                   EVAL      BDASCR3 = ARASCR3
      ** Narrative Code Credit 3
     C                   EVAL      BDNACR3 = ARNACR3
      ** Received Narrative Credit 3
     C                   EVAL      BDRNCR3 = ARRNCR3
      ** Posting Ref Credit 3
     C                   EVAL      BDPRFC3 = ARPRFCR3
     C                   Else
b2   C                   If        WDDCIN = 'C' AND
b2   C                             PCRF = '3' AND
b2   C                             IFRVID = 'Y'
      ** DR/CR Indicator
     C                   EVAL      BDDCIN = 'D'
      ** Branch Debit 3
     C                   EVAL      BDBCDR3 = ARBCCR3
      ** Customer Debit 3
     C                   EVAL      BDCNDR3 = ARCNCR3
      ** Account Code Debit 3
     C                   EVAL      BDACDR3 = ARACCR3
      ** Account Sequence Debit 3
     C                   EVAL      BDASDR3 = ARASCR3
      ** Narrative Code Debit 3
     C                   EVAL      BDNADR3 = ARNACR3
      ** Received Narrative Debit 3
     C                   EVAL      BDRNDR3 = ARRNCR3
      ** Posting Ref Debit 3
     C                   EVAL      BDPRFD3 = ARPRFCR3
     C                   ENDIF
     C                   ENDIF
      ** Compare vs Forecast
     C                   EVAL      BDCMVF = ARCMVFC
      ** Status
     C                   EVAL      BDSTAT = ARSTAT
      ** Repair Location
     C                   EVAL      BDRPRL = ARREPA
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXTFLD - Setup Details for Extension Fields to GLACBDTD      *
      *                                                               *
      *****************************************************************
     C     EXTFLD        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'EXTFLD                 '            MD027197
      *
      ** FORMAT FOR APHEADPD TO GLACBDTD
      *
      ** Zone
     C                   EVAL      BDZONE = ARZONE
      ** Message Type
     C                   EVAL      BDTGTT = *BLANKS
      ** Target System
     C                   EVAL      BDTGTS = *BLANKS
      ** Original Message Type
     C                   EVAL      BDSRCT = *BLANKS
      ** Source System
     C                   EVAL      BDSRCS = *BLANKS
      ** User Id
     C                   EVAL      BDUSER = *BLANKS
      ** Password
     C                   EVAL      BDPASS = *BLANKS
      ** Message Format
     C                   EVAL      BDFORM = *BLANKS
      ** Message Version No.
     C                   EVAL      BDVERS = *BLANKS
      ** Reply Queue
     C                   EVAL      BDRPYQ = *BLANKS
      ** Respond Mode - Sync/Async
     C                   EVAL      BDRESP = *BLANKS
      ** Front Office Tran Id
     C                   EVAL      BDFOTR = *BLANKS
      ** Front Office Assoc Deal Id
     C                   EVAL      BDFOAS = *BLANKS
      ** Confirm Valid Transaction To
     C                   EVAL      BDCNFV = *BLANKS
      *
      *
      ** FORMAT FOR GLBITPPD TO GLACBDTD
      *
      ** Account Customer Shortname
     C                   EVAL      BDATSN = BBCSSN
      ** Account Customer Report Name
     C**********         EVAL      BDATNM = BBCRNM                                          MD027197
     C                   EVAL      BDATNM = *BLANKS                                         MD027197
      ** Account Customer Report Town
     C**********         EVAL      BDATRT = BBCRTN                                          MD027197
     C                   EVAL      BDATRT = *BLANKS                                         MD027197
      ** Account Customer Name
     C                   EVAL      BDATAN = *BLANKS
      ** Currency Code
     C                   EVAL      BDCYCD = IFCCY
      ** Posting Amount
     C*******************MOVE      BDEVTA        BDPTAM                         MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDPTAM                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDPTAM                                     MD027202
      ** Narrative
     C                   EVAL      BDINAR = BDNARR
      ** Transaction Type
      ** Retrieve Account Details
     C                   EXSR      ACCDT
      ** If DR/CR is Debit and Account is Retail
b1   C                   If        BDDCIN = 'D' AND
     C                             WATYP = 'R'
b2   C                   If        CRE098 = 'Y'                                               CRE098
b2   C                             AND IFTRTY <> *BLANKS                                      CRE098
     C                   MOVEL     IFTRTY        BDTRTY                                       CRE098
     C                   Else                                                                 CRE098
b2   C                   If        BDTTDR <> 0
     C                   MOVEL     BDTTDR        BDTRTY
x2   C                   Else
     C******             EVAL      BDTRTY = '9584'                                          MD023767
     C                   EVAL      BDTRTY = '94840'                                         MD023767
e2   C                   Endif
     C                   Endif                                                                CRE098
x1   C                   Else
      ** If DR/CR is Credit and Account is Retail
b2   C                   If        BDDCIN = 'C' AND
     C                             WATYP = 'R'
b2   C                   If        CRE098 = 'Y'                                               CRE098
b2   C                             AND IFTRTY <> *BLANKS                                      CRE098
     C                   MOVEL     IFTRTY        BDTRTY                                       CRE098
     C                   Else                                                                 CRE098
b3   C                   If        BDTTCR <> 0
     C                   MOVEL     BDTTCR        BDTRTY
x3   C                   Else
     C******             EVAL      BDTRTY = '9584'                                          MD023767
     C                   EVAL      BDTRTY = '94840'                                         MD023767
e3   C                   Endif
     C                   Endif                                                                CRE098
x2   C                   Else
      ** If Account is not Retail
     C                   EVAL      BDTRTY = *BLANKS
e2   C                   Endif
e1   C                   Endif
      ** Transaction Sub Type
     C**********         EVAL      BDTSTY = *BLANKS                                         MD024772
      ** Value Date
      ** Convert date to DDMMYY format
     C                   EVAL      DAYNO = IFEVTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDVLDT
      ** Cheque Number
     C                   IF        WATYP = 'R'                                              MD023767
     C                             AND IFCHQN <> 0                                          MD031513
     C                   MOVEL     IFCHQN        BDCQNB
     C                   ELSE                                                               MD023767
     C                   MOVEL     *Blanks       BDCQNB                                     MD023767
     C                   ENDIF                                                              MD023767
      ** SWIFT Common Reference
     C                   EVAL      BDSWCR = IFSWFR
      ** Profit Centre
     C                   EVAL      BDPRCN = IFPFCT
      ** Associated Customer
     C                   IF        WASCUS = 'Y'                                             MD024030
     C                             AND %SUBST(PBTID:1:2) = 'IM'                             MD024030
     C                             AND IFASCN = BDACID                                      MD024030
     C                   EVAL      BDACNB = *BLANKS                                         MD024030
     C                   ELSE                                                               MD024030
     C                   EVAL      BDACNB = IFASCN
     C                   ENDIF                                                              MD024030
      ** Book Code
     C                   EVAL      BDIBKC = IFBKCD
      ** Reverse / VOID Indicator
     C                   If        IFRVID = 'Y'
     C                   EVAL      BDRVDI = 'Y'
     C                   Else
     C******             EVAL      BDRVDI = 'N'                                             MD023767
     C                   EVAL      BDRVDI = *Blanks                                         MD023767
     C                   Endif
      ** No. of Items
     C                   EVAL      BDNITM = '00000'
      ** Retail Ind. Override
     C                   EVAL      BDRINO = 'N'
      ** Original CCY
     C                   EVAL      BDOCCY = IFCCY
      ** Original Amount
     C****************** MOVE      IFEVTA        BDOAMT                         MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDOAMT                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDOAMT                                     MD027202
      ** Batch Header Number
     C                   MOVEL     '   '         BDBTNB
      ** Batch Item Number
     C                   ADD       1             WDBINB
     C                   MOVEL     WDBINB        BDBINB
      ** Front Office Id
     C                   MOVEL     'AR'          WDFRNAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WDFRNDT
     C                   MOVE      WHFRNSQ       WDFRSQ1
     C                   MOVE      WHFRNLT       WDFRNLT
     C                   MOVEL     *BLANKS       WDFRNFL
     C                   MOVEL     WDFRNT        BDFRNT
      ** Front Office Tran Id
     C                   MOVEL     'AR'          WDFONAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WDFONDT
     C                   MOVE      WHFRNSQ       WDFOSQ1
     C                   MOVE      WHFRNLT       WDFOSLT
     C                   MOVE      WDBINB        WDFOSQ2
     C                   MOVEL     *BLANKS       WDFONFL
     C                   MOVEL     WDFOTR        BDFOTR
      ** Front Office Assoc Deal Id
     C                   MOVEL     BDFRNT        BDFOAS
      ** Delete Item Flag
     C                   EVAL      BDDLIT = 'N'
      ** Action Code
     C                   EVAL      BDACTN = 'I'
      *
      *
      ** FORMAT FOR GLBITPXPD TO GLACBDTD
      *
      ** Additional Information 1
     C**********         EVAL      BDADIF1 = IFNAR2                                         MD023988
     C                   EVAL      BDADIF1 = BDNAR2                                         MD023988
      ** Additional Information 2
     C**********         EVAL      BDADIF2 = IFNAR3                                         MD023988
     C                   EVAL      BDADIF2 = BDNAR3                                         MD023988
      ** Additional Information 3
     C**********         EVAL      BDADIF3 = IFNAR4                                         MD023988
     C                   EVAL      BDADIF3 = BDNAR4                                         MD023988
      ** Additional Information 4
     C**********         EVAL      BDADIF4 = IFNAR5                                         MD023988
     C                   EVAL      BDADIF4 = BDNAR5                                         MD023988
      ** Additional Information 5
     C**********         EVAL      BDADIF5 = IFNAR6                                         MD023988
     C                   EVAL      BDADIF5 = BDNAR6                                         MD023988
      ** Additional Information 6
     C**********         EVAL      BDADIF6 = IFNAR7                                         MD023988
     C                   EVAL      BDADIF6 = BDNAR7                                         MD023988
      *
      ** FORMAT FOR GLBPRXPD TO GLACBDTD
      *
      ** ERI Indicator
     C                   EVAL      BDAERI = *BLANKS
      ** IBLC Operation Code 1
     C                   EVAL      BDLXOPC1 = *BLANKS
      ** Country Code 1
     C                   EVAL      BDLXCOC1 = *BLANKS
      ** Identification Code 1
     C                   EVAL      BDLXIDC1 = *BLANKS
      ** Identification 1
     C                   EVAL      BDLXIDE1 = *BLANKS
      ** IBLC Operation Code 2
     C                   EVAL      BDLXOPC2 = *BLANKS
      ** Country Code 2
     C                   EVAL      BDLXCOC2 = *BLANKS
      ** Identification Code 2
     C                   EVAL      BDLXIDC2 = *BLANKS
      ** Identification 2
     C                   EVAL      BDLXIDE2 = *BLANKS
      ** IBLC Operation Code 3
     C                   EVAL      BDLXOPC3 = *BLANKS
      ** Country Code 3
     C                   EVAL      BDLXCOC3 = *BLANKS
      ** Identification Code 3
     C                   EVAL      BDLXIDC3 = *BLANKS
      ** Identification 3
     C                   EVAL      BDLXIDE3 = *BLANKS
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  STAFLD - Setup Details for Status Fields to GLACBDTD         *
      *                                                               *
      *****************************************************************
     C     STAFLD        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'STAFLD                 '            MD027197
      *
      ** Posting Date (new)
     C                   EXSR      POSTDN
      ** Narrative Text
     C                   EVAL      BDNARV = IFNARR
      ** Creation Status
     C                   EVAL      BDCRST = 'M'
      ** Item Status
     C                   EVAL      BDITST = 'O'
      ** Forecast Status
     C                   EVAL      BDFRST = 'N'
      ** Missing Reported
     C                   EVAL      BDMSRP = 'N'
      ** Generated Reported
     C                   EVAL      BDGERP = 'N'
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOMATG - Generate Items as Missing Accounting Rules -        *
      *             Nostro and Non Nostro                             *
      *                                                               *
      *****************************************************************
     C     NOMATG        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NOMATG                 '            MD027197
      *
      ** If Debit and Settlement Account Debit is not blank                     MD024113
b1   C     IFDCIP        IFEQ      'D'                                          MD024113
     C     IFSADR        ANDNE     *BLANKS                                      MD024113
     C                   EVAL      SETTACC = IFSADR                             MD024113
     C                   ELSE                                                   MD024113
      *                                                                         MD024113
      ** OR If Credit and Settlement Account Credit is not blank                MD024113
     C     IFDCIP        IFEQ      'C'                                          MD024113
     C     IFSACR        ANDNE     *BLANKS                                      MD024113
     C                   EVAL      SETTACC = IFSACR                             MD024113
     C                   ENDIF                                                  MD024113
     C                   ENDIF                                                  MD024113
      *
      ** Access Nostro details
     C                   EXSR      NOSTRO
      *
      ** If found, access extension file SDNOST2D to check for Unreconciled A/C Code
      ** for Unreconciled Account Code
     C/Exec SQL
     C+                  Select * into :NOST2D
     C+                           from SDNOST2D
     C+                          where ERNONB = :WNONB
     C+                          and   ERCYCD = :WCYCD
     C/End-Exec
      *
      ** If Nostro found in Extension file
     C                   If        SQLCOD = 0
      *
      ** If Unreconciled Account Code exists
     C                   If        ERACCD <> 0
     C                   EXSR      NOMAT2
     C                   Else
      ** If Unreconciled Account Code does not exist
      **
     C                   MOVE      'NMM'         WREL
     C                   EXSR      NOMATM
     C                   Endif
      *
     C                   Else
      ** If Nostro not found in Extension file
     C                   MOVE      'NMM'         WREL
     C                   EXSR      NOMATM
     C                   Endif
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOMAT2 - Generate Items as Nostro (Missing Acc. Rules)       *
      *                                                               *
      *****************************************************************
     C     NOMAT2        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NOMAT2                 '            MD027197
      *
      ** If DR/CR is Debit
     C                   IF        IFDCIP = 'D'
     C                   EXSR      NOMAT4
      *
     C                   Else
      ** If DR/CR is Credit
     C                   EXSR      NOMAT5
     C                   Endif
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOMATM - Generate Items as Missing Accounting Rules -        *
      *             No Postings Details                               *
      *                                                               *
      *****************************************************************
     C     NOMATM        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NOMATN                 '            MD027197
      *
      ** Write Item but only with details from DIACIFTD, rest if blank
     C                   CLEAR                   DSACBDTD
      *
     C                   EXSR      GLACIF
      *
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
      ** Posting Date (New)
     C                   EVAL      DAYNO = IFPSTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDNPSDT
      ** Creation Status
     C                   EVAL      BDCRST = 'I'
      ** Item Status
     C                   EVAL      BDITST = ' '
      ** Forecast Status
     C                   EVAL      BDFRST = 'N'
      ** Missing Reported
     C                   EVAL      BDMSRP = 'N'
      ** Generated Reported
     C                   EVAL      BDGERP = 'N'
      ** ZONE (Header and Details)
     C                   EVAL      BHZONE = BJZONE
     C                   EVAL      BDZONE = BJZONE
      *
      ** Front Office Tran Id                                                              MD023837
     C                   ADD       1             WNMATCH                                   MD023837
     C                   MOVEL     WNMATCH       WNMATCA                                   MD023837
     C                   EVAL      BDFOTR = 'ARNoMatch' +  WNMATCA                         MD023837
      *                                                                                    MD023837
      *
      ***Check*On*A/c*Sequence is '  '  or '00'                                 MD024112   MD024113
     C****************** EXSR      CKACSN                                       MD024112   MD024113
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount                      MD024113
     C****************** ADD       1             WHNITM                         MD024113
     C****************** MOVEL     IFCCY         @CYCD                          MD024113
     C****************** EXSR      HASFMT                                       MD024113
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOMAT4 - Generate Items if DR/CR is Debit (Missing Acc Rule) *
      *                                                               *
      *****************************************************************
     C     NOMAT4        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NOMAT4                 '            MD027197
      *
      ** WRITE 2 ITEMS TO GLACBDTD, 1 DR AND 1 CR
     C                   CLEAR                   DSACBDTD
      *
      ** Setup the DR Item as follows:
      ** If Reversal Indicator is 'N', write as DEBIT Item
     C                   If        IFRVID = 'N'
      ** Settlement Account Debit
     C                   EVAL      BDSADR = IFSADR
     C                   EVAL      SETTACC = IFSADR
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = SBRCA
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = SCUST
     C                   MOVEL     SCUST         @CNUM
      ** Account Code Debit 1
     C                   MOVEL     SACOD         BDACDR1
      ** Account Seq Debit 1
     C                   MOVEL     SACSQ         BDASDR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = IFCCY
      *
      ** If Reversal Indicator is 'Y', write as CREDIT Item
     C                   ELSE
      ** Settlement Account Credit
     C                   EVAL      BDSACR = IFSADR
     C                   EVAL      SETTACC = IFSADR
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = SBRCA
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = SCUST
     C                   MOVEL     SCUST         @CNUM
      ** Account Code Credit 1
     C                   MOVEL     SACOD         BDACCR1
      ** Account Seq Credit 1
     C                   MOVEL     SACSQ         BDASCR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = IFCCY
      *
     C                   ENDIF
     C                   MOVEL     BDACCD        WAACOD                         MD025013
      ** Setup rest of details for Non Matched Acc Rule
     C                   EXSR      DETNM
      *
      ** Setup the CR Item as follows:
     C                   CLEAR                   DSACBDTD
      ** Settlement Account Credit
      ** If Reversal Indicator is 'N', write as CREDIT Item
     C                   If        IFRVID = 'N'
     C                   EVAL      BDSACR = IFSACR
     C                   EVAL      SETTACC = IFSACR
      ** Settlement Account Credit Nostro
     C                   EXSR      NOSTRO
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = A7BRCD
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = A7CUST
     C                   MOVEL     A7CUST        @CNUM
      ** Account Code Credir 1
     C                   EVAL      BDACCR1 = ERACCD
      ** Account Seq Credit 1
     C                   EVAL      BDASCR1 = ERACSN
      ** Account Code
     C                   MOVEL     ERACCD        BDACCD
      ** Account Seq
     C                   MOVEL     ERACSN        BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = A7BRCD
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = IFCCY
      *
      ** If Reversal Indicator is 'Y', write as DEBIT Item
     C                   ELSE
     C                   EVAL      BDSADR = IFSACR
     C                   EVAL      SETTACC = IFSACR
      ** Settlement Account Debit Nostro
     C                   EXSR      NOSTRO
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = A7BRCD
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = A7CUST
     C                   MOVEL     A7CUST        @CNUM
      ** Account Code Debit 1
     C                   EVAL      BDACDR1 = ERACCD
      ** Account Seq Debit 1
     C                   EVAL      BDASDR1 = ERACSN
      ** Account Code
     C                   MOVEL     ERACCD        BDACCD
      ** Account Seq
     C                   MOVEL     ERACSN        BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = A7BRCD
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = IFCCY
      *
     C                   ENDIF
      *
     C                   MOVEL     BDACCD        WAACOD                         MD025013
      ** Setup rest of details for Non Matched Acc Rule
     C                   EXSR      DETNM
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOMAT5 - Generate Items if DR/CR is Credit (Missing Acc Rule)*
      *                                                               *
      *****************************************************************
     C     NOMAT5        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NOMAT5                 '            MD027197
      *
      ** WRITE 2 ITEMS TO GLACBDTD, 1 CR AND 1 DR
     C                   CLEAR                   DSACBDTD
      *
      ** Setup the CR Item as follows:
      ** If Reversal Indicator is 'N', write as CREDIT Item
     C                   If        IFRVID = 'N'
      *
      ** Settlement Account Debit
     C                   EVAL      BDSACR = IFSACR
     C                   EVAL      SETTACC = IFSACR
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = SBRCA
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = SCUST
     C                   MOVEL     SCUST         @CNUM
      ** Account Code Credit 1
     C                   MOVEL     SACOD         BDACCR1
      ** Account Seq Credit 1
     C                   MOVEL     SACSQ         BDASCR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = IFCCY
      *
      ** If Reversal Indicator is 'Y', write as DEBIT Item
     C                   ELSE
      ** Settlement Account Debit
     C                   EVAL      BDSADR = IFSACR
     C                   EVAL      SETTACC = IFSACR
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = SBRCA
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = SCUST
     C                   MOVEL     SCUST         @CNUM
      ** Account Code Debit 1
     C                   MOVEL     SACOD         BDACDR1
      ** Account Seq Debit 1
     C                   MOVEL     SACSQ         BDASDR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = IFCCY
      *
     C                   ENDIF
      *
     C                   MOVEL     BDACCD        WAACOD                         MD025013
      ** Setup rest of details for Non Matched Acc Rule
     C                   EXSR      DETNM
      *
     C                   CLEAR                   DSACBDTD
      ** Setup the DR Item as follows:
      ** If Reversal Indicator is 'N', write as DEBIT Item
     C                   If        IFRVID = 'N'
      *
     C                   EVAL      BDSADR = IFSADR
     C                   EVAL      SETTACC = IFSADR
      ** Settlement Account Debit Nostro
     C                   EXSR      NOSTRO
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = A7BRCD
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = A7CUST
     C                   MOVEL     A7CUST        @CNUM
      ** Account Code Debit 1
     C                   EVAL      BDACDR1 = ERACCD
      ** Account Seq Debit 1
     C                   EVAL      BDASDR1 = ERACSN
      ** Account Code
     C                   MOVEL     ERACCD        BDACCD
      ** Account Seq
     C                   MOVEL     ERACSN        BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = A7BRCD
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = IFCCY
      *
      ** If Reversal Indicator is 'Y', write as CREDIT Item
     C                   ELSE
     C                   EVAL      BDSACR = IFSADR
     C                   EVAL      SETTACC = IFSADR
      ** Settlement Account Credit Nostro
     C                   EXSR      NOSTRO
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = A7BRCD
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = A7CUST
     C                   MOVEL     A7CUST        @CNUM
      ** Account Code Credit 1
     C                   EVAL      BDACCR1 = ERACCD
      ** Account Seq Credit 1
     C                   EVAL      BDASCR1 = ERACSN
      ** Account Code
     C                   MOVEL     ERACCD        BDACCD
      ** Account Seq
     C                   MOVEL     ERACSN        BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = A7BRCD
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = IFCCY
      *
     C                   ENDIF
      *
     C                   MOVEL     BDACCD        WAACOD                         MD025013
      ** Setup rest of details for Non Matched Acc Rule
     C                   EXSR      DETNM
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETNM  - Setup Rest of Details for Non Matched Acc Rules     *
      *                                                               *
      *****************************************************************
     C     DETNM         BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'DETNM                  '            MD027197
      *
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
      *
      ** Narrative                                                                          MD023988
     C                   EVAL      BDNARR = IFNARR                                          MD023988
      ** Narrative2 to Narrative7                                                           MD023988
     C                   EVAL      BDNAR2 = IFNAR2                                          MD023988
     C                   EVAL      BDNAR3 = IFNAR3                                          MD023988
     C                   EVAL      BDNAR4 = IFNAR4                                          MD023988
     C                   EVAL      BDNAR5 = IFNAR5                                          MD023988
     C                   EVAL      BDNAR6 = IFNAR6                                          MD023988
     C                   EVAL      BDNAR7 = IFNAR7                                          MD023988
      *                                                                                     MD023988
     C                   IF        BDNARR = *BLANKS                                         MD025013
     C                   EVAL      BDNARR = 'TRANSIT'                                       MD025013
     C                   ENDIF                                                              MD025013
      *
      ** All fields from Accounting Rules Table will be set to *blanks
      ** except ones setup above
      *
      ** All fields from "Zone" to UserId" will be set to Blanks
      *
      ** Rest of fields will be set as follows:
      *
      ** FORMAT FOR GLBITPPD TO GLACBDTD
      ** Customer Details, access AOCUSTR0
     C                   EXSR      CUSTDT
      ** Account Customer Shortname
     C                   EVAL      BDATSN = BBCSSN
      ** Account Customer Report Name
     C**********         EVAL      BDATNM = BBCRNM                                          MD027197
     C                   EVAL      BDATNM = *BLANKS                                         MD027197
      ** Account Customer Report Town
     C**********         EVAL      BDATRT = BBCRTN                                          MD027197
     C                   EVAL      BDATRT = *BLANKS                                         MD027197
      ** Account Customer Name
     C                   EVAL      BDATAN = *BLANKS
      ** Currency Code
     C                   EVAL      BDCYCD = IFCCY
     *** Posting Amount
     C****************** MOVE      IFEVTA        BDPTAM                         MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDPTAM                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDPTAM                                     MD027202
      ** Debit/Credit Indicator
     C                   EVAL      BDDCIN = BDLXDCI1
      ** Narrative
     C                   EVAL      BDINAR = BDNARR
      ** Transaction Type
      ** Retrieve Account Details
     C                   EXSR      ACCDT
      ** If DR/CR is Debit and Account is Retail
b1   C                   If        BDDCIN = 'D' AND
     C                             WATYP = 'R'
b2   C                   If        CRE098 = 'Y'                                               CRE098
b2   C                             AND IFTRTY <> *BLANKS                                      CRE098
     C                   MOVEL     IFTRTY        BDTRTY                                       CRE098
     C                   Else                                                                 CRE098
b2   C                   If        BDTTDR <> 0
     C                   MOVEL     BDTTDR        BDTRTY
x2   C                   Else
     C******             EVAL      BDTRTY = '9584'                                          MD023767
     C                   EVAL      BDTRTY = '94840'                                         MD023767
e2   C                   Endif
     C                   Endif                                                                CRE098
x1   C                   Else
      ** If DR/CR is Credit and Account is Retail
b2   C                   If        BDDCIN = 'C' AND
     C                             WATYP = 'R'
b2   C                   If        CRE098 = 'Y'                                               CRE098
b2   C                             AND IFTRTY <> *BLANKS                                      CRE098
     C                   MOVEL     IFTRTY        BDTRTY                                       CRE098
     C                   Else                                                                 CRE098
b3   C                   If        BDTTCR <> 0
     C                   MOVEL     BDTTCR        BDTRTY
x3   C                   Else
     C******             EVAL      BDTRTY = '9584'                                          MD023767
     C                   EVAL      BDTRTY = '94840'                                         MD023767
e3   C                   Endif
     C                   Endif                                                                CRE098
x2   C                   Else
      ** If Account is not Retail
     C                   EVAL      BDTRTY = *BLANKS
e2   C                   Endif
e1   C                   Endif
      ** Transaction Sub Type
     C**********         EVAL      BDTSTY = *BLANKS                                         MD024772
      ** Value Date
      ** Convert date to DDMMYY format
     C                   EVAL      DAYNO = IFEVTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDVLDT
      ** Cheque Number
     C                   IF        WATYP = 'R'                                              MD023767
     C                             AND IFCHQN <> 0                                          MD031513
     C                   MOVEL     IFCHQN        BDCQNB
     C                   ELSE                                                               MD023767
     C                   MOVEL     *Blanks       BDCQNB                                     MD023767
     C                   ENDIF                                                              MD023767
      ** SWIFT Common Reference
     C                   EVAL      BDSWCR = IFSWFR
      ** Profit Centre
     C                   EVAL      BDPRCN = IFPFCT
      ** Associated Customer
     C                   IF        WASCUS = 'Y'                                             MD024030
     C                             AND %SUBST(PBTID:1:2) = 'IM'                             MD024030
     C                             AND IFASCN = BDACID                                      MD024030
     C                   EVAL      BDACNB = *BLANKS                                         MD024030
     C                   ELSE                                                               MD024030
     C                   EVAL      BDACNB = IFASCN
     C                   ENDIF                                                              MD024030
      ** Book Code
     C                   EVAL      BDIBKC = IFBKCD
      ** Reverse / VOID Indicator
     C                   If        IFRVID = 'Y'
     C                   EVAL      BDRVDI = 'Y'
     C                   Else
     C******             EVAL      BDRVDI = 'N'                                             MD023767
     C                   EVAL      BDRVDI = *Blanks                                         MD023767
     C                   Endif
      ** No. of Items
     C                   EVAL      BDNITM = '00000'
      ** Retail Ind. Override
     C                   EVAL      BDRINO = 'N'
      ** Original CCY
     C                   EVAL      BDOCCY = IFCCY
      ** Original Amount
     C****************** MOVE      IFEVTA        BDOAMT                         MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDOAMT                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDOAMT                                     MD027202
      ** Batch Header Number
     C                   MOVEL     '   '         BDBTNB
      ** Batch Item Number
     C                   ADD       1             WDBINB
     C                   MOVEL     WDBINB        BDBINB
      ** Front Office Id
     C                   MOVEL     'AR'          WDFRNAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WDFRNDT
     C                   MOVE      WHFRNSQ       WDFRSQ1
     C                   MOVE      WHFRNLT       WDFRNLT                                    MD025870
     C                   MOVEL     *BLANKS       WDFRNFL
     C                   MOVEL     WDFRNT        BDFRNT
      ** Front Office Tran Id
     C                   MOVEL     'AR'          WDFONAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WDFONDT
     C                   MOVE      WHFRNSQ       WDFOSQ1
     C                   MOVE      WHFRNLT       WDFOSLT                                    MD025870
     C                   MOVE      WDBINB        WDFOSQ2
     C                   MOVEL     *BLANKS       WDFONFL
     C                   MOVEL     WDFOTR        BDFOTR                                     MD023837
      ** Front Office Assoc Deal Id
     C                   MOVEL     BDFRNT        BDFOAS
      ** Delete Item Flag
     C                   EVAL      BDDLIT = 'N'
      ** Action Code
     C                   EVAL      BDACTN = 'I'
      *
      ** FORMAT FOR GLBITPXPD TO GLACBDTD
      ** Additional Information 1
     C**********         EVAL      BDADIF1 = IFNAR2                                         MD023988
     C                   EVAL      BDADIF1 = BDNAR2                                         MD023988
      ** Additional Information 2
     C**********         EVAL      BDADIF2 = IFNAR3                                         MD023988
     C                   EVAL      BDADIF2 = BDNAR3                                         MD023988
      ** Additional Information 3
     C**********         EVAL      BDADIF3 = IFNAR4                                         MD023988
     C                   EVAL      BDADIF3 = BDNAR4                                         MD023988
      ** Additional Information 4
     C**********         EVAL      BDADIF4 = IFNAR5                                         MD023988
     C                   EVAL      BDADIF4 = BDNAR5                                         MD023988
      ** Additional Information 5
     C**********         EVAL      BDADIF5 = IFNAR6                                         MD023988
     C                   EVAL      BDADIF5 = BDNAR6                                         MD023988
      ** Additional Information 6
     C**********         EVAL      BDADIF6 = IFNAR7                                         MD023988
     C                   EVAL      BDADIF6 = BDNAR7                                         MD023988
      *
      ** FORMAT FOR Status Fields TO GLACBDTD
      ** Posting Date (new)
     C                   EXSR      POSTDN
      ** Narrative Text
     C                   EVAL      BDNARV = IFNARR
      ** Creation Status
     C                   EVAL      BDCRST = 'U'
      ** Item Status
     C                   EVAL      BDITST = 'O'
      ** Forecast Status
     C                   EVAL      BDFRST = 'N'
      ** Missing Reported
     C                   EVAL      BDMSRP = 'N'
      ** Generated Reported
     C                   EVAL      BDGERP = 'N'
      *
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
      *
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSCXC - Cross Currency Items                                *
      *                                                               *
      *****************************************************************
     C     POSCXC        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSCXC                 '            MD027197
      *
      ** Retrieve Spot Trade Account Code Equivalent
      ******* For Event Ccy
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      CURRTV
     C                   MOVEL     A6SPAE        WESPAE
      ******* For Base Ccy
     C                   MOVEL     BJCYCD        @CYCD
     C                   EXSR      CURRTV
     C                   MOVEL     A6SPAE        WBSPAE
      *
      ** If SETTLEMENT ACCOUNT DEBIT EXISTS
     C                   If        IFSADR <> *BLANKS
     C                   IF        IFCCY <> BJCYCD OR
     C                             WBSPAE <> *BLANKS
      *
     C                   EXSR      CXCSDR
      *
     C                   Endif
     C                   Endif
 
      ** IF SETTLEMENT ACCOUNT CREDIT EXISTS
     C                   If        IFSACR <> *BLANKS
     C                   IF        IFCCY <> BJCYCD OR
     C                             A6SPAE <> *BLANKS
      *
     C                   EXSR      CXCSCR
      *
     C                   Endif
     C                   Endif
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CXCSDR - Cross Currency Item for Settlement A/C Debit        *
      *                                                               *
      *****************************************************************
     C     CXCSDR        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CXCSDR                 '            MD027197
 
     C                   CLEAR                   DSACBDTD
 
      ** WRITE CREDIT ITEM to Spot Trade Account
      *
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
      *
b4   C                   If        ARPRFDR1 = '2' Or                                        MD024063
b4   C                             ARPRFDR2 = '2' Or                                        MD024063
b4   C                             ARPRFDR3 = '2'                                           MD024063
b4   C                   If        ARPRFDR1 = '2'                                           MD024063
     C                   IF        ARRNDR1 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNADR1       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
      *                                                                                     MD024063
     C                   Else                                                               MD024063
b4   C                   If        ARPRFDR2 = '2'                                           MD024063
     C                   IF        ARRNDR2 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNADR2       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
b4   C                   IF        ARPRFDR3 = '2'                                           MD024063
     C                   IF        ARRNDR3 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNADR3       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
      ** Narrative                                                                 MD023988 MD024063
     C*******            EVAL      BDNARR = IFNARR                                 MD023988 MD024063
      ** Narrative2 to Narrative7                                                  MD023988 MD024063
     C*******            EVAL      BDNAR2 = IFNAR2                                 MD023988 MD024063
     C*******            EVAL      BDNAR3 = IFNAR3                                 MD023988 MD024063
     C*******            EVAL      BDNAR4 = IFNAR4                                 MD023988 MD024063
     C*******            EVAL      BDNAR5 = IFNAR5                                 MD023988 MD024063
     C*******            EVAL      BDNAR6 = IFNAR6                                 MD023988 MD024063
     C*******            EVAL      BDNAR7 = IFNAR7                                 MD023988 MD024063
      *                                                                            MD023988 MD024063
      ** Setup Settlement Account Credit
     C                   EVAL      SCCY = IFCCY
     C                   EVAL      SBRCA = IFBKBR
      ****** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ****** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
      ****** Retrieve Spot Trade Account Code from Trading ICD
     C                   MOVEL     BLSPTA        SACOD
     C                   EVAL      SACSQ = '01'
      ** If Reversal Indicator is 'N', write as CREDIT Item
     C                   If        IFRVID = 'N'
     C                   EVAL      BDSACR = SETTACC
      *
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = SBRCA
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = SCUST
      ** Account Code Credit 1
     C                   MOVEL     SACOD         BDACCR1
      ** Account Seq Credit 1
     C                   MOVEL     SACSQ         BDASCR1
      ** Account Code
     C                   MOVEL     SACOD         BDACCD
      ** Account Seq
     C                   MOVEL     SACSQ         BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = IFCCY
      *
      ** If Reversal Indicator is 'Y', write as DEBIT Item
     C                   ELSE
     C                   EVAL      BDSADR = SETTACC
      *
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = SBRCA
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = SCUST
      ** Account Code Debit 1
     C                   MOVEL     SACOD         BDACDR1
      ** Account Seq Debit 1
     C                   MOVEL     SACSQ         BDASDR1
      ** Account Code
     C                   MOVEL     SACOD         BDACCD
      ** Account Seq
     C                   MOVEL     SACSQ         BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACdR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = IFCCY
      *
     C                   ENDIF
      *
      ** Setup rest of details for Cross Currency Items
     C                   EXSR      DETMXC
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
     C                   CLEAR                   DSACBDTD
 
      ** WRITE DEBIT ITEM to Spot Trade Account Equivalent
      *
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
      *
b4   C                   If        ARPRFDR1 = '2' Or                                        MD024063
b4   C                             ARPRFDR2 = '2' Or                                        MD024063
b4   C                             ARPRFDR3 = '2'                                           MD024063
b4   C                   If        ARPRFDR1 = '2'                                           MD024063
     C                   IF        ARRNDR1 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNADR1       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
      *                                                                                     MD024063
     C                   Else                                                               MD024063
b4   C                   If        ARPRFDR2 = '2'                                           MD024063
     C                   IF        ARRNDR2 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNADR2       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
b4   C                   IF        ARPRFDR3 = '2'                                           MD024063
     C                   IF        ARRNDR3 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNADR3       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
      ** Setup Settlement Account Debit
     C                   EVAL      SCCY = BJCYCD
     C                   EVAL      SBRCA = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
      ** Retrieve Spot Trade Account Code Equivalent for Event Ccy
     C                   MOVEL     WESPAE        SACOD
     C                   EVAL      SACSQ = '01'
      *
      ** If Reversal Indicator is 'N', write as DEBIT Item
     C                   If        IFRVID = 'N'
     C                   EVAL      BDSADR = SETTACC
      *
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = SBRCA
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = SCUST
      ** Account Code Debit 1
     C                   MOVEL     SACOD         BDACDR1
      ** Account Seq Debit 1
     C                   MOVEL     SACSQ         BDASDR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFBCEQA       BDLXPTA1                       MD023743
     C                   MOVEL     BJCYCD        @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFBCEQA       ZFIELD                            MD023743 MD027202
     C                   MOVE      IFBCEQA       ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = BJCYCD
      *
      ** If Reversal Indicator is 'Y', write as CREDIT Item
     C                   ELSE
     C                   EVAL      BDSACR = SETTACC
      *
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = SBRCA
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = SCUST
      ** Account Code Credit 1
     C                   MOVEL     SACOD         BDACCR1
      ** Account Seq Credit 1
     C                   MOVEL     SACSQ         BDASCR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFBCEQA       BDLXPTA1                       MD023743
     C                   MOVEL     BJCYCD        @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFBCEQA       ZFIELD                            MD023743 MD027202
     C                   MOVE      IFBCEQA       ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = BJCYCD
     C                   ENDIF
 
      ** Setup rest of details for Cross Currency Items
     C                   EXSR      DETMXC
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     BJCYCD        @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CXCSCR - Cross Currency Item for Settlement A/C Credit       *
      *                                                               *
      *****************************************************************
     C     CXCSCR        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CXCSCR                 '            MD027197
 
     C                   CLEAR                   DSACBDTD
 
      ** WRITE DEBIT ITEM to Spot Trade Account
      *
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
      *
b4   C                   If        ARPRFCR1 = '2' Or                                        MD024063
b4   C                             ARPRFCR2 = '2' Or                                        MD024063
b4   C                             ARPRFCR3 = '2'                                           MD024063
b4   C                   If        ARPRFCR1 = '2'                                           MD024063
     C                   IF        ARRNCR1 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNACR1       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
      *                                                                                     MD024063
     C                   Else                                                               MD024063
b4   C                   If        ARPRFCR2 = '2'                                           MD024063
     C                   IF        ARRNCR2 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNACR2       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
b4   C                   IF        ARPRFCR3 = '2'                                           MD024063
     C                   IF        ARRNCR3 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNACR3       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
     C                   Endif                                                              MD024063
      *
      ** Setup Settlement Account Debit
     C                   EVAL      SCCY = IFCCY
     C                   EVAL      SBRCA = IFBKBR
      ****** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ****** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
      ****** Retrieve Spot Trade Account Code from Trading ICD
     C                   MOVEL     BLSPTA        SACOD
     C                   EVAL      SACSQ = '01'
      ** If Reversal Indicator is 'N', write as DEBIT Item
     C                   If        IFRVID = 'N'
     C                   EVAL      BDSADR = SETTACC
      *
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = SBRCA
      ** Customer Debit  1
     C                   EVAL      BDCNDR1 = SCUST
      ** Account Code Debit 1
     C                   MOVEL     SACOD         BDACDR1
      ** Account Seq Debit 1
     C                   MOVEL     SACSQ         BDASDR1
      ** Account Code
     C                   MOVEL     SACOD         BDACCD
      ** Account Seq
     C                   MOVEL     SACSQ         BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = IFCCY
      *
      ** If Reversal Indicator is 'Y', write as CREDIT Item
     C                   ELSE
     C                   EVAL      BDSACR = SETTACC
      *
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = SBRCA
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = SCUST
      ** Account Code Credit 1
     C                   MOVEL     SACOD         BDACCR1
      ** Account Seq Credit 1
     C                   MOVEL     SACSQ         BDASCR1
      ** Account Code
     C                   MOVEL     SACOD         BDACCD
      ** Account Seq
     C                   MOVEL     SACSQ         BDACSN
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFEVTA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = IFCCY
      *
     C                   ENDIF
      *
      ** Setup rest of details for Cross Currency Items
     C                   EXSR      DETMXC
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     IFCCY         @CYCD
     C                   EXSR      HASFMT
 
     C                   CLEAR                   DSACBDTD
 
      ** WRITE CREDIT ITEM to Spot Trade Account Equivalent
 
      ** Setup fields from Interface file to GLACBDTD
     C                   EXSR      GLACIF
 
      *
b4   C                   If        ARPRFCR1 = '2' Or                                        MD024063
b4   C                             ARPRFCR2 = '2' Or                                        MD024063
b4   C                             ARPRFCR3 = '2'                                           MD024063
b4   C                   If        ARPRFCR1 = '2'                                           MD024063
     C                   IF        ARRNCR1 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNACR1       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
      *                                                                                     MD024063
     C                   Else                                                               MD024063
b4   C                   If        ARPRFCR2 = '2'                                           MD024063
     C                   IF        ARRNCR2 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNACR2       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
b4   C                   IF        ARPRFCR3 = '2'                                           MD024063
     C                   IF        ARRNCR3 = 'N'                                            MD024063
      ** Narrative                                                                          MD024063
     C                   MOVEL     ARNACR3       BDNARR                                     MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR3 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR4 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR5 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR6 = *BLANKS                                         MD024063
     C                   EVAL      BDNAR7 = *BLANKS                                         MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
      *                                                                                     MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Endif                                                              MD024063
     C                   Else                                                               MD024063
      ** Narrative                                                                          MD024063
     C                   EVAL      BDNARR = IFNARR                                          MD024063
      ** Narrative2 to Narrative7                                                           MD024063
     C                   EVAL      BDNAR2 = IFNAR2                                          MD024063
     C                   EVAL      BDNAR3 = IFNAR3                                          MD024063
     C                   EVAL      BDNAR4 = IFNAR4                                          MD024063
     C                   EVAL      BDNAR5 = IFNAR5                                          MD024063
     C                   EVAL      BDNAR6 = IFNAR6                                          MD024063
     C                   EVAL      BDNAR7 = IFNAR7                                          MD024063
     C                   Endif                                                              MD024063
      ** Setup Settlement Account Credit
     C                   EVAL      SCCY = BJCYCD
     C                   EVAL      SBRCA = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
      ** Retrieve Spot Trade Account Code Equivalent for Event Ccy
     C                   MOVEL     WESPAE        SACOD
     C                   EVAL      SACSQ = '01'
      *
      ** If Reversal Indicator is 'N', write as CREDIT Item
     C                   If        IFRVID = 'N'
     C                   EVAL      BDSACR = SETTACC
      *
      ** Branch Credit 1
     C                   EVAL      BDBCCR1 = SBRCA
      ** Customer Credit 1
     C                   EVAL      BDCNCR1 = SCUST
      ** Account Code Credit 1
     C                   MOVEL     SACOD         BDACCR1
      ** Account Seq Credit 1
     C                   MOVEL     SACSQ         BDASCR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFBCEQA       BDLXPTA1
     C                   MOVEL     BJCYCD        @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFBCEQA       ZFIELD                            MD023743 MD027202
     C                   MOVE      IFBCEQA       ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'C'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCCR1
     C                   EVAL      WNWCUST = BDCNCR1
     C                   EVAL      WNWACOD = BDACCR1
     C                   EVAL      WNWACSQ = BDASCR1
     C                   EVAL      WNWCCY = BJCYCD
      *
      ** If Reversal Indicator is 'N', write as DEBIT Item
     C                   ELSE
     C                   EVAL      BDSADR = SETTACC
      *
      ** Branch Debit 1
     C                   EVAL      BDBCDR1 = SBRCA
      ** Customer Debit 1
     C                   EVAL      BDCNDR1 = SCUST
      ** Account Code Debit 1
     C                   MOVEL     SACOD         BDACDR1
      ** Account Seq Debit 1
     C                   MOVEL     SACSQ         BDASDR1
      ** Account Code
     C                   EVAL      BDACCD = SACOD
      ** Account Seq
     C                   EVAL      BDACSN = SACSQ
      ** Input Branch Code
     C                   EVAL      BDIBCA = SBRCA
      ** Posting Amount 1
     C****************** MOVE      IFBCEQA       BDLXPTA1                       MD023743
     C                   MOVEL     BJCYCD        @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFBCEQA       ZFIELD                            MD023743 MD027202
     C                   MOVE      IFBCEQA       ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
      ** Debit / Credit Indicator 1
     C                   EVAL      BDLXDCI1 = 'D'
      ** Setup fields to access GLNW94PD / GLNWACPD
     C                   EVAL      WNWBRCA = BDBCDR1
     C                   EVAL      WNWCUST = BDCNDR1
     C                   EVAL      WNWACOD = BDACDR1
     C                   EVAL      WNWACSQ = BDASDR1
     C                   EVAL      WNWCCY = BJCYCD
      *
     C                   ENDIF
      *
      ** Setup rest of details for Cross Currency Items
     C                   EXSR      DETMXC
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   MOVEL     BJCYCD        @CYCD
     C                   EXSR      HASFMT
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETMXC - Setup Rest of Details for Cross Currency Items      *
      *                                                               *
      *****************************************************************
     C     DETMXC        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'DETMXC                 '            MD027197
      *
      ** FORMAT FOR GLACRUTD TO GLACBDTD
      ** Unique Id
     C                   EVAL      BDUNID = ARUNID
      ** Description                                                                        MD024513
     C                   EVAL      BDDESC = ARDESC                                          MD024513
      ** Transaction Type Debit
     C                   EVAL      BDTTDR = ARTTDR
      ** Transaction Type Credit
     C                   EVAL      BDTTCR = ARTTCR
      ** Compare vs Forecast
     C                   EVAL      BDCMVF = ARCMVFC
      ** Status
     C                   EVAL      BDSTAT = ARSTAT
      ** Repair Location
     C                   EVAL      BDRPRL = ARREPA
      *
      ** FORMAT FOR APHEADPD TO GLACBDTD
      ** Zone
     C                   EVAL      BDZONE = ARZONE
      ** Message Type
     C                   EVAL      BDTGTT = *BLANKS
      ** Target System
     C                   EVAL      BDTGTS = *BLANKS
      ** Original Message Type
     C                   EVAL      BDSRCT = *BLANKS
      ** Source System
     C                   EVAL      BDSRCS = *BLANKS
      ** User Id
     C                   EVAL      BDUSER = *BLANKS
      ** Password
     C                   EVAL      BDPASS = *BLANKS
      ** Message Format
     C                   EVAL      BDFORM = *BLANKS
      ** Message Version No.
     C                   EVAL      BDVERS = *BLANKS
      ** Reply Queue
     C                   EVAL      BDRPYQ = *BLANKS
      ** Respond Mode - Sync/Async
     C                   EVAL      BDRESP = *BLANKS
      ** Front Office Tran Id
     C                   EVAL      BDFOTR = *BLANKS
      ** Front Office Assoc Deal Id
     C                   EVAL      BDFOAS = *BLANKS
      ** Confirm Valid Transaction To
     C                   EVAL      BDCNFV = *BLANKS
      *
      ** FORMAT FOR GLBITPPD TO GLACBDTD
      ** Account Customer Shortname
     C                   EVAL      BDATSN = BBCSSN
      ** Account Customer Report Name
     C**********         EVAL      BDATNM = BBCRNM                                          MD027197
     C                   EVAL      BDATNM = *BLANKS                                         MD027197
      ** Account Customer Report Town
     C**********         EVAL      BDATRT = BBCRTN                                          MD027197
     C                   EVAL      BDATRT = *BLANKS                                         MD027197
      ** Account Customer Name
     C                   EVAL      BDATAN = *BLANKS
      ** Currency Code
     C                   EVAL      BDCYCD = SCCY
      ** Posting Amount
     C                   MOVE      BDLXPTA1      BDPTAM
      ** Debit/Credit Indicator
     C                   EVAL      BDDCIN = BDLXDCI1
      ** Narrative
     C                   EVAL      BDINAR = BDNARR
      ** Transaction Type
      ** Retrieve Account Details
     C                   MOVE      SACOD         WAACOD                                     MD024064
     C                   EXSR      ACCDT
      ** If DR/CR is Debit and Account is Retail
b1   C                   If        BDDCIN = 'D' AND
     C                             WATYP = 'R'
b2   C                   If        CRE098 = 'Y'                                               CRE098
b2   C                             AND IFTRTY <> *BLANKS                                      CRE098
     C                   MOVEL     IFTRTY        BDTRTY                                       CRE098
     C                   Else                                                                 CRE098
b2   C                   If        BDTTDR <> 0
     C                   MOVEL     BDTTDR        BDTRTY
x2   C                   Else
     C******             EVAL      BDTRTY = '9584'                                          MD023767
     C                   EVAL      BDTRTY = '94840'                                         MD023767
e2   C                   Endif
     C                   Endif                                                                CRE098
x1   C                   Else
      ** If DR/CR is Credit and Account is Retail
b2   C                   If        BDDCIN = 'C' AND
     C                             WATYP = 'R'
b2   C                   If        CRE098 = 'Y'                                               CRE098
b2   C                             AND IFTRTY <> *BLANKS                                      CRE098
     C                   MOVEL     IFTRTY        BDTRTY                                       CRE098
     C                   Else                                                                 CRE098
b3   C                   If        BDTTCR <> 0
     C                   MOVEL     BDTTCR        BDTRTY
x3   C                   Else
     C******             EVAL      BDTRTY = '9584'                                          MD023767
     C                   EVAL      BDTRTY = '94840'                                         MD023767
e3   C                   Endif
     C                   Endif                                                                CRE098
x2   C                   Else
      ** If Account is not Retail
     C                   EVAL      BDTRTY = *BLANKS
e2   C                   Endif
e1   C                   Endif
      ** Transaction Sub Type
     C**********         EVAL      BDTSTY = *BLANKS                                         MD024772
      ** Value Date
      ** Convert date to DDMMYY format
     C                   EVAL      DAYNO = IFEVTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDVLDT
      ** Cheque Number
     C                   IF        WATYP = 'R'                                              MD023767
     C                             AND IFCHQN <> 0                                          MD031513
     C                   MOVEL     IFCHQN        BDCQNB
     C                   ELSE                                                               MD023767
     C                   MOVEL     *Blanks       BDCQNB                                     MD023767
     C                   ENDIF                                                              MD023767
      ** SWIFT Common Reference
     C                   EVAL      BDSWCR = IFSWFR
      ** Profit Centre
     C                   EVAL      BDPRCN = IFPFCT
      ** Associated Customer
     C                   IF        WASCUS = 'Y'                                             MD024030
     C                             AND %SUBST(PBTID:1:2) = 'IM'                             MD024030
     C                             AND IFASCN = BDACID                                      MD024030
     C                   EVAL      BDACNB = *BLANKS                                         MD024030
     C                   ELSE                                                               MD024030
     C                   EVAL      BDACNB = IFASCN
     C                   ENDIF                                                              MD024030
      ** Book Code
     C                   EVAL      BDIBKC = IFBKCD
      ** Reverse / VOID Indicator
     C                   If        IFRVID = 'Y'
     C                   EVAL      BDRVDI = 'Y'
     C                   Else
     C******             EVAL      BDRVDI = 'N'                                             MD023767
     C                   EVAL      BDRVDI = *Blanks                                         MD023767
     C                   Endif
      ** No. of Items
     C                   EVAL      BDNITM = '00000'
      ** Retail Ind. Override
     C                   EVAL      BDRINO = 'N'
      ** Original CCY
     C                   EVAL      BDOCCY = IFCCY
      ** Original Amount
     C****************** MOVE      IFEVTA        BDOAMT                         MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   IFEVTA        ZFIELD                            MD023743 MD027202
     C                   MOVE      IFEVTA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDOAMT                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDOAMT                                     MD027202
      ** Batch Header Number
     C                   MOVEL     '   '         BDBTNB
      ** Batch Item Number
     C                   ADD       1             WDBINB
     C                   MOVEL     WDBINB        BDBINB
      ** Front Office Id
     C                   MOVEL     'AR'          WDFRNAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WDFRNDT
     C                   MOVE      WHFRNSQ       WDFRSQ1
     C                   MOVE      WHFRNLT       WDFRNLT
     C                   MOVEL     *BLANKS       WDFRNFL
     C                   MOVEL     WDFRNT        BDFRNT
      ** Front Office Tran Id
     C                   MOVEL     'AR'          WDFONAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WDFONDT
     C                   MOVE      WHFRNSQ       WDFOSQ1
     C*******************MOVE      WHFRNLT       WDFRNLT                                    MD025870
     C                   MOVE      WHFRNLT       WDFOSLT                                    MD025870
     C                   MOVE      WDBINB        WDFOSQ2
     C                   MOVEL     *BLANKS       WDFONFL
     C                   MOVEL     WDFOTR        BDFOTR
      ** Front Office Assoc Deal Id
     C                   MOVEL     BDFRNT        BDFOAS
      ** Delete Item Flag
     C                   EVAL      BDDLIT = 'N'
      ** Action Code
     C                   EVAL      BDACTN = 'I'
      *
      ** FORMAT FOR GLBITPXPD TO GLACBDTD
      ** Additional Information 1
     C**********         EVAL      BDADIF1 = IFNAR2                                         MD023988
     C                   EVAL      BDADIF1 = BDNAR2                                         MD023988
      ** Additional Information 2
     C**********         EVAL      BDADIF2 = IFNAR3                                         MD023988
     C                   EVAL      BDADIF2 = BDNAR3                                         MD023988
      ** Additional Information 3
     C**********         EVAL      BDADIF3 = IFNAR4                                         MD023988
     C                   EVAL      BDADIF3 = BDNAR4                                         MD023988
      ** Additional Information 4
     C**********         EVAL      BDADIF4 = IFNAR5                                         MD023988
     C                   EVAL      BDADIF4 = BDNAR5                                         MD023988
      ** Additional Information 5
     C**********         EVAL      BDADIF5 = IFNAR6                                         MD023988
     C                   EVAL      BDADIF5 = BDNAR6                                         MD023988
      ** Additional Information 6
     C**********         EVAL      BDADIF6 = IFNAR7                                         MD023988
     C                   EVAL      BDADIF6 = BDNAR7                                         MD023988
      *
      ** FORMAT FOR Status Fields TO GLACBDTD
      ** Posting Date (new)
     C                   EXSR      POSTDN
      ** Narrative Text
     C                   EVAL      BDNARV = IFNARR
      ** Creation Status
     C                   EVAL      BDCRST = 'M'
      ** Item Status
     C                   EVAL      BDITST = 'O'
      ** Forecast Status
     C                   EVAL      BDFRST = 'N'
      ** Missing Reported
     C                   EVAL      BDMSRP = 'N'
      ** Generated Reported
     C                   EVAL      BDGERP = 'N'
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POSTDN - Setup Posting Date (New)                            *
      *                                                               *
      *****************************************************************
     C     POSTDN        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'POSTDN                 '            MD027197
      *
     C                   IF        PostDateFlag  = *BLANK                                   MD024772
      *                                                                                     MD024772
b1   C                   If        POSRFF = '1' Or
     C                             POSRFF = '3' Or
     C                             POSRFF = '4' Or
     C                             POSRFF = '5'
     C                   EVAL      DAYNO = IFPSTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDNPSDT
x1   C                   Else
b2   C                   If        POSRFF = '2' Or
     C                             POSRFF = '0'
      *                                                                                     MD024772
     C                   EVAL      WNNETW = SVAL2                                           MD024772
      *                                                                                     MD024772
     C                   CLEAR                   SETACCOUNT                                 MD024772
      *                                                                                     MD024772
     C                   SELECT                                                             MD024772
     C**********         WHEN      WDDCIN = 'C'                                    MD024772 MD025566
     C                   WHEN      IFDCIP = 'C'                                             MD025566
     C                   IF        BDSACR <> *BLANKS                                       MD025566A
     C                   EVAL      SETACCOUNT = BDSACR                                      MD024772
     C                   ELSE                                                              MD025566A
     C                   EVAL      SETACCOUNT = BDSADR                                     MD025566A
     C                   ENDIF                                                             MD025566A
      *                                                                                     MD024772
     C**********         WHEN      WDDCIN = 'D'                                    MD024772 MD025566
     C                   WHEN      IFDCIP = 'D'                                             MD025566
     C                   IF        BDSADR <> *BLANKS                                       MD025566A
     C                   EVAL      SETACCOUNT = BDSADR                                      MD024772
     C                   ELSE                                                              MD025566A
     C                   EVAL      SETACCOUNT = BDSACR                                     MD025566A
     C                   ENDIF                                                             MD025566A
     C                   ENDSL                                                              MD024772
                                                                                            MD027197
      * Test for invalid account code and sequence                                          MD027197
     C                   If        SETACODSQ = *Blanks                                      MD027197
     C                   CLEAR                   SETACOD                                    MD027197
     C                   CLEAR                   SETACSQ                                    MD027197
     C                   Endif                                                              MD027197
      *                                                                                     MD024772
     C                   EVAL      WNWBRCA  =   SETBRCA                                     MD024772
     C                   EVAL      WNWCUST  =   SETCUST                                     MD024772
     C                   EVAL      WNWCCY   =   SETCCY                                      MD024772
     C                   EVAL      WNWACOD  =   SETACOD                                     MD024772
     C                   EVAL      WNWACSQ  =   SETACSQ                                     MD024772
      *                                                                                     MD024772
     C                   EVAL      NA5LSD   =   0                                           MD024772
     C                   EVAL      N40LSD   =   0                                           MD024772
      *                                                                                     MD024772
      *** Retrieve last statement date for MT940/MT950
      *
      *** Access GLNWACPD and GLNW94PD using Cust Network and Sett. A/c
      *** Get last record
     C     KNETW         SETGT     GLNW94L2
     C     KNETW         READPE    GLNW94L2                               30
      *
     C     KNETW         SETGT     GLNWACL4
     C     KNETW         READPE    GLNWACL4                               31
      *
b3   C                   If        *IN30 = *OFF OR
     C                             *IN31 = *OFF
      *
      *** Compare Last Statement Date with IFPSTD
b4   C                   If        NA5LSD < N40LSD AND
     C                             IFPSTD <= N40LSD
      *** Set BDNPSDT to Next Working Date after N40LSD
     C                   EVAL      ZDAYNO = N40LSD
     C                   EXSR      SRNxtWDay
 
     C                   EVAL      DAYNO = ZDAYNO
     C                   EXSR      CVTDAT
     C**********         MOVEL     ZDATE         BDNPSDT                                    MD024772
     C                   MOVEL     ZDATE         NewPostDate                                MD024772
     C                   MOVE      'Y'           PostDateFlag                               MD024772
x4   C                   Else
      *
b5   C                   If        NA5LSD > N40LSD AND
     C                             IFPSTD <= NA5LSD
      *** Set BDNPSDT to Next Working Date after NA5LSD
     C                   EVAL      ZDAYNO = NA5LSD
     C                   EXSR      SRNxtWDay
 
     C                   EVAL      DAYNO = ZDAYNO
     C                   EXSR      CVTDAT
     C**********         MOVEL     ZDATE         BDNPSDT                                    MD024772
     C                   MOVEL     ZDATE         NewPostDate                                MD024772
     C                   MOVE      'Y'           PostDateFlag                               MD024772
x5   C                   Else
     C                   EVAL      DAYNO = IFPSTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDNPSDT
e5   C                   Endif
e4   C                   Endif
x3   C                   Else
     C                   EVAL      DAYNO = IFPSTD
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         BDNPSDT
e3   C                   Endif
x2   C                   Else                                                   MD024113
     C                   EVAL      DAYNO = IFPSTD                               MD024113
     C                   EXSR      CVTDAT                                       MD024113
     C                   MOVEL     ZDATE         BDNPSDT                        MD024113
e2   C                   Endif
      *
e1   C                   Endif
      *
     C                   ENDIF                                                              MD024772
      *                                                                                     MD024772
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNxtWDay - Get Next Working Day after Last Statement Date   *
      *                                                               *
      *****************************************************************
     C     SRNxtWDay     BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'SRNxtWDay              '            MD027197
 
     C                   CALL      'ZFRQB5'
     C                   PARM      'D'           ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      *ZERO         ZMDAY             2 0
     C                   PARM      IFCCY         ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM      'F'           ZDIREC            1
     C                   PARM      *BLANKS       ZRTRN             7
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BRCCUS - Retrieve Internal Customer for Booking Branch       *
      *                                                               *
      *****************************************************************
     C     BRCCUS        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'BRCCUS                 '            MD027197
      *
      ** Access SDBRCHPD using AOBRCHR1
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      IFBKBR        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CUSTDT - Retrieve Customer details                           *
      *                                                               *
      *****************************************************************
     C     CUSTDT        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CUSTDT                 '            MD027197
      *
      ** Access SDCUSTPD using AOCUSTR0
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CNUM
     C                   PARM      *BLANKS       @CNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Account Identifier
     C                   MOVEL     @CNUM         BDACID
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CURRTV - Retrieve Currency details                           *
      *                                                               *
      *****************************************************************
     C     CURRTV        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CURRTV                 '            MD027197
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ACCDT  - Retrieve Account details                            *
      *                                                               *
      *****************************************************************
     C     ACCDT         BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'ACCDT                  '            MD027197
      *
      ** Access ACCNTAB to retrieve details
     C******/Exec SQL                                                                       MD024064
     C******+                  Select * into :DSACCNT                                       MD024064
     C******+                           from ACCNTAB                                        MD024064
     C******+                          where CNUM = :WACNUM                                 MD024064
     C******+                          and   CCY =:WACCY                                    MD024064
     C******+                          and   ACOD =:WAACOD                                  MD024064
     C******+                          and   ACSQ =:WAACSQ                                  MD024064
     C******+                          and   BRCA =:WABRCA                                  MD024064
     C******/End-Exec                                                                       MD024064
b1   C******             IF        SQLCOD = 0                                               MD024064
     C******             MOVEL     ATYP          WATYP             1                        MD024064
     C******             ELSE                                                     MD023767  MD024064
     C******             MOVEL     *Blanks       WATYP                            MD023767  MD024064
     C******             Endif                                                              MD024064
      *                                                                                     MD024064
     C                   MOVE      WAACOD        PACOD                                      MD024064
     C                   CALL      'AOACODR0'                                               MD024064
      *                                                                                     MD024064
     C                   PARM      *BLANKS       @RTCD                                      MD024064
     C                   PARM      '*KEY'        @OPTN                                      MD024064
     C                   PARM                    PACOD                                      MD024064
     C     SDACOD        PARM                    DSFDY                                      MD024064
      *                                                                                     MD024064
      * Not Found                                                                           MD024064
     C     @RTCD         IFNE      *BLANKS                                                  MD024064
     C                   MOVEL     *Blanks       WATYP                                      MD024064
     C                   ELSE                                                               MD024064
     C                   MOVEL     A5ACTY        WATYP             1                        MD024064
     C                   ENDIF                                                              MD024064
      *                                                                                     MD024064
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CVTDAT - Convert Date from Midas Day No. to DDMMYY           *
      *                                                               *
      *****************************************************************
     C     CVTDAT        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CVTDAT                 '            MD027197
      *
     C                   CALL      'ZDATE2'
     C                   PARM                    DAYNO             5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM      *ZEROS        ZADATE            7
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NOSRRO - Retrieve Nostro details                             *
      *                                                               *
      *****************************************************************
     C     NOSTRO        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NOSTR0                 '            MD027197
      *
      ** Access SDNOSTPD using AONOSTR0
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C****************** PARM      IFCTPY        @CNUM                          MD024113
     C****************** PARM      IFCCY         P@CUCD                         MD024113
     C****************** PARM                    P@ACCD                         MD024113
     C****************** PARM      SACSQ         P@ACSQ                         MD024113
     C                   PARM      SCUST         @CNUMN                         MD024113
     C                   PARM      SCCY          P@CUCD                         MD024113
     C                   PARM      SACOD         P@ACCD                         MD024113
     C                   PARM      SACSQ         P@ACSQ                         MD024113
     C                   PARM      *BLANKS       P@NONB
     C****************** PARM      IFBKBR        @BRCA                          MD024113
     C                   PARM      SBRCA         @BRCA                          MD024113
     C                   PARM      *BLANKS       P@CSSN
     C                   PARM      *BLANKS       P@PNOI
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C                   IF        @RTCD = *Blanks
     C                   EVAL      WNONB = A7NONB
     C                   EVAL      WCYCD = A7CYCD
     C                   ELSE
     C                   EVAL      WNONB = *BLANKS
     C                   EVAL      WCYCD = *BLANKS
     C                   ENDIF
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  BATITN - Check Batch Item Number to see if new Batch Header  *
      *            required in case Item Number reaches 999           *
      *                                                               *
      *****************************************************************
     C     BATITN        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'BATITN                 '            MD027197
      *
     C                   MOVEL     *BLANKS       WBTCH
      *
      ** Check items number remaining for Matched Items
     C                   IF        WREL = 'MAT'
     C                   IF        ARPRFDR1 <> ' '
     C                   Add       1             WEXBI
     C                   ENDIF
     C                   IF        ARPRFDR2 <> ' '
     C                   Add       1             WEXBI
     C                   ENDIF
     C                   IF        ARPRFDR3 <> ' '
     C                   Add       1             WEXBI
     C                   ENDIF
     C                   IF        ARPRFCR1 <> ' '
     C                   Add       1             WEXBI
     C                   ENDIF
     C                   IF        ARPRFCR2 <> ' '
     C                   Add       1             WEXBI
     C                   ENDIF
     C                   IF        ARPRFCR3 <> ' '
     C                   Add       1             WEXBI
     C                   ENDIF
      *
     C                   IF        IFCXCYI = 'Y'
     C                   Add       2             WEXBI
     C                   ENDIF
      *
     C                   IF        WIMBDR <> WIMBCR AND
     C                             WGBEF = 'Y'
     C                   Add       1             WEXBI
     C                   ENDIF
      *
     C                   Z-add     999           WMAXBI
     C                   Z-add     WDBINB        WTOTBI
     C                   Add       WEXBI         WTOTBI
     C                   If        WTOTBI > WMAXBI
      *
     C                   IF        WIMBDR <> WIMBCR And
     C                             WGBEF = 'Y'
     C                   EXSR      IMBPOS
     C                   ENDIF
      *
     C                   MOVEL     'BATI'        WBTCH
     C                   EXSR      WRITEBH
     C                   MOVEL     *BLANKS       WBTCH
     C                   Z-ADD     1             WHBTNB
     C                   Z-ADD     0             WDBINB
     C                   Z-ADD     0             WHNITM
     C                   Z-ADD     0             WINT15
     C                   Z-ADD     0             WDEC09
     C                   Z-ADD     0             WHASH
      *
     C                   MOVEL     *BLANKS       WREL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check items number remaining for Non Matched Items but Items to generate
     C                   IF        WREL = 'NMG'
      *
     C                   Add       2             WEXBI
      *
     C                   Z-add     999           WMAXBI
     C                   Z-add     WDBINB        WTOTBI
     C                   Add       WEXBI         WTOTBI
     C                   If        WTOTBI > WMAXBI
     C                   MOVEL     'BATI'        WBTCH
     C                   EXSR      WRITEBH
     C                   MOVEL     *BLANKS       WBTCH
     C                   Z-ADD     1             WHBTNB
     C                   Z-ADD     0             WDBINB
     C                   Z-ADD     0             WHNITM
     C                   Z-ADD     0             WINT15
     C                   Z-ADD     0             WDEC09
     C                   Z-ADD     0             WHASH
     C                   Z-ADD     0             WTOTBH
     C                   MOVEL     *BLANKS       WREL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check items number remaining for Non Matched Items
     C                   IF        WREL = 'NMM'
      *
     C                   Add       1             WEXBI
      *
     C                   Z-add     999           WMAXBI
     C                   Z-add     WDBINB        WTOTBI
     C                   Add       WEXBI         WTOTBI
     C                   If        WTOTBI > WMAXBI
     C                   MOVEL     'BATI'        WBTCH
     C                   EXSR      WRITEBH
     C                   MOVEL     *BLANKS       WBTCH
     C                   Z-ADD     1             WHBTNB
     C                   Z-ADD     0             WDBINB
     C                   Z-ADD     0             WHNITM
     C                   Z-ADD     0             WINT15
     C                   Z-ADD     0             WDEC09
     C                   Z-ADD     0             WHASH
     C                   Z-ADD     0             WTOTBH
     C                   MOVEL     *BLANKS       WREL
     C                   ENDIF
      *
     C                   ENDIF
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEBD - Write record to GLACBDTD                           *
      *                                                               *
      *****************************************************************
     C     WRITEBD       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'WRITEBD                '            MD027197
      *                                                                                     MD027197
     C                   EXSR      NARRSET                                                  MD027197
      *
     C/exec SQL
     C+ insert into GLACBDTD
     C+ values(:DSACBDTD)
     C/end-exec
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SEQRTV - Retrieve Sequence for Front Office ID               *
      *                                                               *
      *****************************************************************
     C     SEQRTV        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'SEQRTV                 '            MD027197
      *
     C/Exec SQL
     C+ Declare ACSQDT scroll Cursor for
     C+                  Select * from GLACSQTD
     C+                          where SQZONE = :PZONE
     C/End-Exec
      *
     C/Exec SQL
     C+ Open ACSQDT
     C/End-Exec
      *
     C/Exec SQL
     C+ Fetch First
     C+   From ACSQDT
     C+   into :DSACSQTD
     C/End-Exec
b1   C                   If        SQLSTT = '00000'
     C                   MOVEL     SQSEQN        WSEQN
     C                   ADD       1             WSEQN
     C                   MOVEL     WSEQN         WDFRSQ1
     C                   MOVEL     WSEQN         WHFRNSQ
     C/EXEC SQL
     C+ UPDATE GLACSQTD SET SQSEQN = :WHFRNSQ
     C+ WHERE SQZONE = :BDZONE
     C/END-EXEC
     C                   Endif
      *
     C/Exec SQL
     C+ Close ACSQDT
     C/End-Exec
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SEQRTV2 - Retrieve Letter for Front Office Id                *
      *                                                               *
      *****************************************************************
     C     SEQRTV2       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'SEQRTV2                '            MD027197
      *
     C                   ADD       1             X
     C                   MOVEL     LETR(X)       WHFRNLT
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  HASFMT - Hash details setup                                  *
      *                                                               *
      *****************************************************************
     C     HASFMT        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'HASFMT                 '            MD027197
      *
      ** Get currency's no. of decimal places.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   Z-ADD     A6NBDP        WNBDP
     C                   ELSE
     C                   Z-ADD     *ZERO         WNBDP
     C                   ENDIF
      *
     C*******************MOVE      BDPTAM        WINT15                         MD023743
     C                   MOVE      BDPTAM        WPTAM            16            MD023743
     C                   IF        WPTAM <> BDOAMT                              MD023743
     C                   MOVE      IFBCEQA       WINT15                         MD023743
     C                   ELSE                                                   MD023743
     C                   MOVE      IFEVTA        WINT15                         MD023743
     C                   ENDIF                                                  MD023743
      *                                                                                    MD024092
     C                   IF        IDX2 > 0                                                MD024092
     C                   MOVE      *BLANKS       WINT15                                    MD024092
     C                   MOVE      BDEVTA        WINT15                                    MD024092
     C                   ENDIF                                                             MD024092
      *                                                                                    MD024092
     C                   MLLZO     '0'           WINT15
      *
     C                   SELECT
      *
     C     WNBDP         WHENEQ    *ZERO
     C                   ADD       WINT15        WHASH
      *
     C     WNBDP         WHENEQ    1
     C                   ADD       WINT14        WHASH
     C                   ADD       WINT01        WDEC09
      *
     C     WNBDP         WHENEQ    2
     C                   ADD       WINT13        WHASH
     C                   ADD       WINT02        WDEC09
      *
     C     WNBDP         WHENEQ    3
     C                   ADD       WINT12        WHASH
     C                   ADD       WINT03        WDEC09
     C                   ENDSL
      *
      ** Total DR/CR for later imbalance check
     C****************** MOVE      BDPTAM        WIMBPA                         MD023743
     C                   IF        WPTAM <> BDOAMT                              MD023743
     C                   MOVE      IFBCEQA       WIMBPA                         MD023743
     C                   ELSE                                                   MD023743
     C                   MOVE      IFEVTA        WIMBPA                         MD023743
     C                   ENDIF                                                  MD023743
      *
     C**********         IF        BDDCIN = 'D'                                             MD024092
     C**********         ADD       WIMBPA        WIMBDR                                     MD024092
     C**********         ELSE                                                               MD024092
     C**********         ADD       WIMBPA        WIMBCR                                     MD024092
     C**********         ENDIF                                                              MD024092
     C                   ADD       WIMBPA        WTOTBH
      *                                                                                     MD024092
     C                   CLEAR                   IMBLPOST                                   MD024092
     C                   IF        BDDCIN = 'D'                                             MD024092
     C                   EVAL      IMIND = BDDCIN                                           MD024092
     C                   ELSE                                                               MD024092
     C                   EVAL      IMIND = BDDCIN                                           MD024092
     C                   ENDIF                                                              MD024092
      *                                                                                     MD024092
     C                   EVAL      IMAMT = WIMBPA                                           MD024092
     C                   EVAL      IMCCY = BDCYCD                                           MD024092
      *                                                                                     MD024092
     C                   ADD       1             IDX                                        MD024092
     C                   EVAL      POSTARR(IDX) = IMBLPOST                                  MD024092
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WRITEBH - Write record to GLACBHTD                           *
      *                                                               *
      *****************************************************************
     C     WRITEBH       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'WRITEBH                '            MD027197
      *
      ** Batch Id
     C                   EVAL      BHBTID = PBTID
      ** Front Office Id
     C                   MOVEL     'AR'          WHFRNAR
     C                   EVAL      DAYNO = BJRDNB
     C                   EXSR      CVTDAT
     C                   MOVEL     ZDATE         WHFRNDT
      *
     C                   MOVEL     *BLANKS       WHFRNFL
     C                   MOVEL     WHFRNT        BHFRNT
      ** Batch Item Number
     C                   EVAL      BHBTNB = '   '
      ** Booking Branch
     C                   EVAL      BHBKBR = BDBKBR
      ** Department Code
     C                   If        IFDPCD <> *BLANKS
     C                   EVAL      BHPCD = IFDPCD
     C                   Else
     C                   EVAL      BHPCD = WGDEPC
     C                   Endif
      ** Multiple Branch Batch
     C                   EVAL      BHMBRB = *BLANKS
      ** Desciption
     C**********         MOVEL     ArDESC        BHDESC                                     MD024513
     C                   MOVEL     ArDESC1       BHDESC                                     MD024513
      *                                                                                     MD025601
     C                   MOVEL     IFBTID        BATIDSP                                    MD025601
     C                   MOVEL     BATIMSP       BATIM                                      MD025601
     C                   MOVEL     '-'           BATSEP                                     MD025601
     C                   MOVEL     BATNOSP       BATNOS                                     MD025601
     C                   MOVEL     BATHEAD       BHDESC                                     MD025601
      *
      ** Hash Integer Calculated
     C                   EVAL      BHHICC = 0
      *                                                                                     MD024399
     C                   Z-ADD     0             NUMVAL            9 0                      MD024399
     C                   EVAL      NUMVAL = %INT(WDEC09)                                    MD024399
     C                   IF        NUMVAL > 0                                               MD024399
     C                   ADD       NUMVAL        WHASH                                      MD024399
     C                   ENDIF                                                              MD024399
      *                                                                                     MD024399
     C                   Z-ADD     WHASH         BHHICC
      ** Hash Decimal Calculated
     C                   EVAL      BHHDCC = 0
     C                   Z-ADD     WDEC03        BHHDCC
      ** Hash Item No. Calculated
     C                   MOVE      WHNITM        BHHINC
      ** Hash Integer Input
     C                   EVAL      BHHIIN = 0
     C                   Z-ADD     WHASH         BHHIIN
      ** Hash Decimal Input
     C                   EVAL      BHHDIN = 0
     C                   Z-ADD     WDEC03        BHHDIN
      ** Hash Item No. Input
     C                   MOVE      WHNITM        BHHINI
      ** Total Amount
     C****************** MOVE      WTOTBH        BHSMAM                         MD023743
     C                   EVAL      WSMAM = (BHHIIN * 1000) + BHHDIN             MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   WSMAM         ZFIELD                            MD023743 MD027202
     C                   MOVE      WSMAM         ZFIELD                                     MD027202
     C                   Z-ADD     3             ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BHSMAM                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BHSMAM                                     MD027202
      *
      ** Number of Items
     C                   MOVE      WHNITM        BHNITM
      ** Batch Status Flag
     C                   EVAL      BHBTSF = 'H'
      ** Zone
     C                   EVAL      BHZONE = BDZONE
      *
     C/exec SQL
     C+ insert into GLACBHTD
     C+ values(:DSACBHTD)
     C/end-exec
      *
     C                   IF        WBTCH = 'BATI'
      ** Retrieve sequence for Front Id
     C                   EXSR      SEQRTV2
     C                   ENDIF
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  IMBPOS - Write record to GLACBDTD for Imbalance              *
      *                                                               *
      *****************************************************************
     C     IMBPOS        BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'IMBPPOS                '            MD027197
      *
     C                   EXSR      GLACIF
      *
      ** Narrative                                                                          MD023988
     C**********         EVAL      BDNARR = IFNARR                                 MD023988 MD027108
      ** Narrative2 to Narrative7                                                           MD023988
     C**********         EVAL      BDNAR2 = IFNAR2                                 MD023988 MD027108
     C**********         EVAL      BDNAR3 = IFNAR3                                 MD023988 MD027108
     C**********         EVAL      BDNAR4 = IFNAR4                                 MD023988 MD027108
     C**********         EVAL      BDNAR5 = IFNAR5                                 MD023988 MD027108
     C**********         EVAL      BDNAR6 = IFNAR6                                 MD023988 MD027108
     C**********         EVAL      BDNAR7 = IFNAR7                                 MD023988 MD027108
      *                                                                                     MD023988
      ** Narrative                                                                          MD027108
     C                   EVAL      BDNARR = NARR01                                          MD027108
      ** Narrative2 to Narrative7                                                           MD027108
     C                   EVAL      BDNAR2 = NARR01                                          MD027108
     C                   EVAL      BDNAR3 = *BLANKS                                         MD027108
     C                   EVAL      BDNAR4 = *BLANKS                                         MD027108
     C                   EVAL      BDNAR5 = *BLANKS                                         MD027108
     C                   EVAL      BDNAR6 = *BLANKS                                         MD027108
     C                   EVAL      BDNAR7 = *BLANKS                                         MD027108
      *                                                                                     MD027108
     C                   IF        WIMBDR > WIMBCR
      ** Setup Settlement Account Credit
     C                   EVAL      SCCY = IFCCY
     C                   EVAL      SBRCA = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     PACSUS        SACOD
     C                   EVAL      SACSQ = '01'
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     SACOD         BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = 'C'
     C                   Z-ADD     0             WDIFFA
     C     WIMBDR        SUB       WIMBCR        WDIFFA
     C                   MOVE      WDIFFA        BDEVTA
     C****************** MOVE      WDIFFA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   WDIFFA        ZFIELD                            MD023743 MD027202
     C                   MOVE      WDIFFA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'C'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
     C                   EVAL      BDSACR = SETTACC
      *
     C                   ELSE
      ** Setup Settlement Account Credit
     C                   EVAL      SCCY = IFCCY
     C                   EVAL      SBRCA = IFBKBR
      ** Retrieve Internal Customer of Booking Branch
     C                   EXSR      BRCCUS
     C                   EVAL      SCUST = A8BICN
      ** Retrieve Customer details
     C                   MOVEL     SCUST         @CNUM
     C                   EXSR      CUSTDT
     C                   MOVEL     PACSUS        SACOD
     C                   EVAL      SACSQ = '01'
      ** Setup fields for Extension Fields (EXTFLD)
     C                   MOVEL     SACOD         BDACCD
     C                   MOVEL     SACSQ         BDACSN
     C                   EVAL      BDIBCA = IFBKBR
     C                   EVAL      BDDCIP = 'D'
     C                   Z-ADD     0             WDIFFA
     C     WIMBCR        SUB       WIMBDR        WDIFFA
     C                   MOVE      WDIFFA        BDEVTA
     C****************** MOVE      WDIFFA        BDLXPTA1                       MD023743
     C                   MOVEL     IFCCY         @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   WDIFFA        ZFIELD                            MD023743 MD027202
     C                   MOVE      WDIFFA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDLXPTA1                          MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDLXPTA1                                   MD027202
     C                   EVAL      BDLXDCI1 = 'D'
     C                   EVAL      BDLXPTA2 = *BLANKS
     C                   EVAL      BDLXDCI2 = ' '
     C                   EVAL      BDLXPTA3 = *BLANKS
     C                   EVAL      BDLXDCI3 = ' '
     C                   EVAL      BDSADR = SETTACC
      *
     C                   ENDIF
     C                   MOVEL     SACOD         WAACOD                         MD024092
      *
      ** Setup fields from Accounting Rules to GLACBDTD
     C                   EXSR      GLACRU
      ** Setup fields for Extended fields from GLACBDTD
     C                   EXSR      EXTFLD
      ** Setup fields for Status fields from GLACBDTD
     C                   EXSR      STAFLD
 
     C                   Z-ADD     0             ZADEC                          MD024064
     C**********         MOVE      *BLANKS       ZFIELD                            MD024064 MD027202
     C**********         MOVE(P)   WDIFFA        ZFIELD                            MD024064 MD027202
     C                   MOVE      WDIFFA        ZFIELD                                     MD027202
     C**********         CALL      'ZEDIT'                                         MD024064 MD027202
     C**********         PARM                    ZFIELD           16               MD024064 MD027202
     C**********         PARM                    ZADEC             1 0             MD024064 MD027202
     C**********         MOVE      ZFIELD        BDEVTA                            MD024064 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDEVTA                                     MD027202
     C                   MOVE      BDLXPTA1      BDPTAM                         MD024064
     C                   EVAL      BDDCIN = BDLXDCI1
     C****************** MOVE      WDIFFA        BDOAMT                         MD023743
     C                   MOVEL     SCCY          @CYCD                          MD023743
     C                   EXSR      CURRTV                                       MD023743
     C**********         MOVE      *BLANKS       ZFIELD                            MD023743 MD027202
     C**********         MOVE(P)   WDIFFA        ZFIELD                            MD023743 MD027202
     C                   MOVE      WDIFFA        ZFIELD                                     MD027202
     C                   Z-ADD     A6NBDP        ZADEC                          MD023743
     C**********         CALL      'ZEDIT'                                         MD023743 MD027202
     C**********         PARM                    ZFIELD           16               MD023743 MD027202
     C**********         PARM                    ZADEC             1 0             MD023743 MD027202
     C**********         MOVE      ZFIELD        BDOAMT                            MD023743 MD027202
     C                   EXSR      SREdit                                                   MD027202
     C                   MOVE      ZOUT21        BDOAMT                                     MD027202
      ** Check On A/c Sequence is '  '  or '00'                                 MD024112
     C                   EXSR      CKACSN                                       MD024112
 
      ** Write record to GLACBDTD
     C                   EVAL      BDCCY  = TOTCCY                                          MD024092
     C                   EVAL      BDCYCD = TOTCCY                                          MD024092
     C                   EXSR      WRITEBD
 
      ** Update Header details No. of Items + Total Amount
     C                   ADD       1             WHNITM
     C                   Z-ADD     0             WIMBDR
     C                   Z-ADD     0             WIMBCR
     C                   MOVEL     IFCCY         @CYCD
      *                                                                                     MD024092
     C                   Z-ADD     0             IDX                                        MD024092
     C                   CLEAR                   POSTARR                                    MD024092
     C                   CLEAR                   IMBLPOST                                   MD024092
     C                   MOVE      *BLANKS       WAMOUNT2                                   MD024092
     C                   EVAL      WAMOUNT2 = %TRIM(BDEVTA)                                 MD024092
     C                   EVAL      WLEN = %LEN(%TRIM(WAMOUNT2))                             MD024092
     C                   IF        WLEN > *Zeros                                            MD024092
     C                   EVAL      BDEVTA = *BLANKS                                         MD024092
     C                   EVAL      %SUBST(BDEVTA:16-WLEN:WLEN) = %TRIM(WAMOUNT2)            MD024092
     C                   ELSE                                                               MD024092
     C                   MOVE(P)   '0'           BDEVTA                                     MD024092
     C                   ENDIF                                                              MD024092
      *                                                                                     MD024092
     C                   EXSR      HASFMT
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD027202
      *****************************************************************                     MD027202
      *                                                               *                     MD027202
      *  SREDIT  - Subroutine to format amount fields                 *                     MD027202
      *                                                               *                     MD027202
      *****************************************************************                     MD027202
     C     SREdit        BEGSR                                                              MD027202
                                                                                            MD027202
     C                   CALL      'ZSEDIT'                                                 MD027202
     C                   PARM                    ZFIELD                                     MD027202
     C                   PARM                    ZADEC                                      MD027202
     C                   PARM                    ZECODE                                     MD027202
     C                   PARM                    ZOUT21                                     MD027202
                                                                                            MD027202
     C                   ENDSR                                                              MD027202
      *****************************************************************                     MD027202
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATMN - Update record in GLACMNTD                          *
      *                                                               *
      *****************************************************************
     C     UPDATMN       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'UPDATMN                '            MD027197
      *
      ** AR Status
     C                   If        WREL = 'NMM'
     C                   EVAL      WARSTT = ArSTAT1
     C                   Else
     C                   EVAL      WARSTT = ArSTAT2
     C                   Endif
      *
     C                   EVAL      WMFRNAR = WHFRNAR
     C                   EVAL      WMFRNDT = WHFRNDT
     C                   EVAL      WMFRNSQ = WHFRNSQ
     C****************** EVAL      WMFRNFL = *BLANKS                            MD025013
     C                   EVAL      WMFRNLT = WHFRNLT                            MD025013
     C                   EVAL      WMFRNFL = *BLANKS                            MD025013
     C                   EVAL      WMFRN = WMFRNT
      *
     C/EXEC SQL
     C+ UPDATE GLACMNTD SET MNFRNT = :WMFRN, MNARST = :WARSTT, MNZONE =
     C+ :BHZONE WHERE MNBTID = :PBTID
     C/END-EXEC
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MLTBRIT - Subroutine to Generate InterBranch Items           *
      *                                                               *
      *****************************************************************
     C     MLTBRIT       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'MLTBRIT                '            MD027197
      *
      ** The Multi-Branch is managed by program GL0450.                                     MD023767
      *                                                                                     MD023767
     C******             IF        BDDCIN = 'D' And                                         MD023767
     C******                       BDSADR <> *BLANKS And                                    MD023767
     C******                       SBRCA <> IFBKBR                                          MD023767
      ******                                                                                MD023767
      ***Setup fields from Interface file to GLACBDTD                                       MD023767
     C******             EXSR      GLACIF                                                   MD023767
      ******                                                                                MD023767
      ***Setup fields from Accounting Rules to GLACBDTD                                     MD023767
     C******             EXSR      GLACRU                                                   MD023767
      ******                                                                                MD023767
     C******             EVAL      SETTACC = BDSADR                                         MD023767
     C******             EVAL      BDBCDR1 = SBRCA                                          MD023767
     C******             EVAL      BDCNDR1 = SCUST                                          MD023767
      ***Retrieve Customer details                                                          MD023767
     C******             MOVEL     SCUST         @CNUM                                      MD023767
     C******             EXSR      CUSTDT                                                   MD023767
     C******             MOVEL     SACOD         BDACDR1                                    MD023767
     C******             MOVEL     SACSQ         BDASDR1                                    MD023767
      ***Setup fields for Extension Fields (EXTFLD)                                         MD023767
     C******             MOVEL     BDACDR1       BDACCD                                     MD023767
     C******             MOVEL     BDASDR1       BDACSN                                     MD023767
     C******             EVAL      BDIBCA = BDBCDR1                                         MD023767
     C******             EVAL      BDDCIP = IFDCIP                                          MD023767
     C******             MOVE      IFEVTA        BDLXPTA1                                   MD023767
     C******             EVAL      BDLXDCI1 = 'D'                                           MD023767
     C******             EVAL      BDLXPTA2 = *BLANKS                                       MD023767
     C******             EVAL      BDLXDCI2 = ' '                                           MD023767
     C******             EVAL      BDLXPTA3 = *BLANKS                                       MD023767
     C******             EVAL      BDLXDCI3 = ' '                                           MD023767
      ***Setup Account details key to access ACCNTAB                                        MD023767
     C******             MOVEL     SCUST         WACNUM                                     MD023767
     C******             MOVEL     IFCCY         WACCY                                      MD023767
     C******             MOVEL     SBRCA         WABRCA                                     MD023767
     C******             EVAL      WAACOD = BDACDR1                                         MD023767
     C******             EVAL      WAACSQ = BDASDR1                                         MD023767
x2   C******             ENDIF                                                              MD023767
      ******                                                                                MD023767
      ***Setup fields for Extended fields from GLACBDTD                                     MD023767
     C******             EXSR      EXTFLD                                                   MD023767
      ***Setup fields for Status fields from GLACBDTD                                       MD023767
     C******             EXSR      STAFLD                                                   MD023767
      ******                                                                                MD023767
      ***Write record to GLACBDTD                                                           MD023767
     C******             EXSR      WRITEBD                                                  MD023767
      ******                                                                                MD023767
      ***Update Header details No. of Items + Total Amount                                  MD023767
     C******             ADD       1             WHNITM                                     MD023767
     C******             MOVEL     IFCCY         @CYCD                                      MD023767
     C******             EXSR      HASFMT                                                   MD023767
 
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VALACOD - Subroutine to Validate Account Code                *
      *                                                               *
      *****************************************************************
     C     VALACOD       BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'VALACOD                '            MD027197
      *
     C                   CALL      'AOACODR0'
      *
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    PACCD
     C     SDACOD        PARM                    DSFDY
      *
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************         MD024112
      *                                                               *         MD024112
      *  CKACSN - Subroutine to set A/C Code to 01 in case ' ' or '01'*         MD024112
      *                                                               *         MD024112
      *****************************************************************         MD024112
     C     CKACSN        BEGSR                                                  MD024112
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'CKACSN                 '            MD027197
      *                                                                         MD024112
     C                   IF        BDACSN = '  ' OR                             MD024112
     C                             BDACSN = '00'                                MD024112
     C                   EVAL      BDACSN = '01'                                MD024112
     C                   Endif                                                  MD024112
      *                                                                         MD024112
     C                   IF        BDDCIN = 'D' AND                             MD024112
     C                             BDSADR <> *BLANKS                            MD024112
     C                   EVAL      SETTACC = BDSADR                             MD024112
     C                   IF        SACSQ = '  ' OR                              MD024112
     C                             SACSQ = '00'                                 MD024112
     C                   EVAL      SACSQ = '01'                                 MD024112
     C                   EVAL      BDSADR = SETTACC                             MD024112
     C                   Endif                                                  MD024112
     C                   Endif                                                  MD024112
      *                                                                         MD024112
     C                   IF        BDDCIN = 'C' AND                             MD024112
     C                             BDSACR <> *BLANKS                            MD024112
     C                   EVAL      SETTACC = BDSACR                             MD024112
     C                   IF        SACSQ = '  ' OR                              MD024112
     C                             SACSQ = '00'                                 MD024112
     C                   EVAL      SACSQ = '01'                                 MD024112
     C                   EVAL      BDSACR = SETTACC                             MD024112
     C                   Endif                                                  MD024112
     C                   Endif                                                  MD024112
      *                                                                         MD024112
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR                                                  MD024112
      *                                                                         MD024112
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *InzSr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PBTID
     C                   PARM                    PARST
     C                   PARM                    PSEQN
     C                   PARM                    PZONE
 
      ** Set off program indicators
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Access Bank details
      **   Retrieve Run day number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access SDTRADPD using AOTRADR0
      **   Retrieve Spot Trade Account Code
 
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
 
     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBFile = 'SDTRADPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger ICD File
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDGELR        PARM                    DSSDY
      *
     C                   IF        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = @OPTN
     C                   EVAL      DBFile = 'SDGELRPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      **
     C                   IF        @RTCD = *Blanks
     C                   EVAL      PACCD = BKACCD
     C                   EXSR      VALACOD
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      PACSUS = PACCD
     C                   ELSE
     C                   EVAL      PACSUS = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      * Retrieve the system value
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    RTNCDE
     C                   PARM      PSysVal1      SVALK1
     C                   PARM                    SVAL1
     C                   PARM      PSysVal2      SVALK2
     C                   PARM                    SVAL2
     C                   PARM      PSysVal3      SVALK3
     C                   PARM                    SVAL3
     C**********         PARM                    SVALK4                                     MD024030
     C                   PARM      PSysVal4      SVALK4                                     MD024030
     C                   PARM                    SVAL4
     C                   PARM                    SVALK5
     C                   PARM                    SVAL5
     C                   PARM                    SVALK6
     C                   PARM                    SVAL6
     C                   PARM                    SVALK7
     C                   PARM                    SVAL7
     C                   PARM                    SVALK8
     C                   PARM                    SVAL8
     C                   PARM                    SVALK9
     C                   PARM                    SVAL9
     C                   PARM                    SVALK0
     C                   PARM                    SVAL10
 
      * If the system values are not found then issue a database error
 
     C     RTNCDE        IFNE      '       '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get the Generate Balance Entry Flag
     C                   MOVEL     ' '           WGBEF             1
     C                   EVAL      WGBEF = SVAL1
 
      * Get the Customer Network
     C                   MOVEL     *BLANKS       WCSNT             6
     C                   EVAL      WCSNT = SVAL2
 
      * Get the Department Code
     C                   MOVEL     ' '           WGDEPC            3
     C                   EVAL      WGDEPC = SVAL3
      *                                                                                     MD024030
      ** Get Compare Associated Customer with Customer                                      MD024030
      *                                                                                     MD024030
     C                   MOVEL     ' '           WASCUS            1                        MD024030
     C                   EVAL      WASCUS = SVAL4                                           MD024030
                                                                                              CRE098
      ** Check CRE098 feature                                                                 CRE098
                                                                                              CRE098
     C                   CALL      'AOSARDR0'                                                 CRE098
     C                   PARM      *Blanks       @RTCD                                        CRE098
     C                   PARM      '*VERIFY'     @OPTN                                        CRE098
     C                   PARM      'CRE098'      PSARD                                        CRE098
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE098
                                                                                              CRE098
     C                   IF        @RTCD <> *BLANKS AND                                       CRE098
     C                             @RTCD <> '*NRF'                                            CRE098
     C     *LOCK         IN        LDA                                                        CRE098
     C                   EVAL      DBFile = 'CRE098'                                          CRE098
     C                   EVAL      DBKey = @OPTN                                              CRE098
     C                   EVAL      DBase = 004                                                CRE098
     C                   OUT       LDA                                                        CRE098
     C                   EXSR      *PSSR                                                      CRE098
     C                   ELSE                                                                 CRE098
     C                   IF        @RTCD <> *BLANKS                                           CRE098
     C                   EVAL      CRE098 = 'N'                                               CRE098
     C                   ELSE                                                                 CRE098
     C                   EVAL      CRE098 = 'Y'                                               CRE098
     C                   ENDIF                                                                CRE098
     C                   ENDIF                                                                CRE098
 
      * KLIST to access GLNW94PD and GLNWACPD
     C     KNETW         KLIST
     C                   KFLD                    WNNETW
     C                   KFLD                    WNWBRCA
     C                   KFLD                    WNWCUST
     C                   KFLD                    WNWCCY
     C                   KFLD                    WNWACOD
     C                   KFLD                    WNWACSQ
 
     C                   Z-ADD     0             IDX                                        MD024092
     C                   CLEAR                   POSTARR                                    MD024092
     C                   CLEAR                   IMBLPOST                                   MD024092
                                                                                            MD024092
     C                   ENDSR
      *****************************************************************                     MD027197
      /EJECT                                                                                MD027197
      *****************************************************************                     MD027197
      *                                                               *                     MD027197
      *  NARRSET - CHECK NARRATIVES DETAILS FOR SPECIAL CHARS         *                     MD027197
      *                                                               *                     MD027197
      *  Called by:                                                   *                     MD027197
      *                                                               *                     MD027197
      *  Calls:          None                                         *                     MD027197
      *                                                               *                     MD027197
      *****************************************************************                     MD027197
     C     NARRSET       BEGSR                                                              MD027197
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'NARRSSET               '            MD027197
                                                                                           MD027197A
     C                   CLEAR                   NARRTV                                    MD027197A
     C                   CLEAR                   NARRTV1                                   MD027197A
                                                                                           MD027197A
     C                   Z-ADD     1             Y                 2 0                      MD027197
     C                   MOVEA     BDNARR        NARRTV                                     MD027197
     C                   DOU       Y = 30                                                   MD027197
     C                   IF        NARRTV(Y) = '&'                                          MD027197
     C                   MOVE      ' '           NARRTV(Y)                                  MD027197
     C                   ENDIF                                                              MD027197
     C                   ADD       1             Y                                          MD027197
     C                   ENDDO                                                              MD027197
     C                   MOVEA     NARRTV        NARRTV1                                    MD027197
     C                   MOVEL     NARRTV1       BDNARR                                     MD027197
                                                                                            MD027197
      *                                                                                    MD027197A
      ** Narrative Field                                                                   MD027197A
      *                                                                                    MD027197A
     C                   CLEAR                   NARRTV                                    MD027197A
     C                   CLEAR                   NARRTV1                                   MD027197A
                                                                                           MD027197A
     C                   Z-ADD     1             Y                                         MD027197A
     C                   MOVEA     BDINAR        NARRTV                                    MD027197A
     C                   DOU       Y = 30                                                  MD027197A
     C                   IF        NARRTV(Y) = '&'                                         MD027197A
     C                   MOVE      ' '           NARRTV(Y)                                 MD027197A
     C                   ENDIF                                                             MD027197A
     C                   ADD       1             Y                                         MD027197A
     C                   ENDDO                                                             MD027197A
     C                   MOVEA     NARRTV        NARRTV1                                   MD027197A
     C                   MOVEL     NARRTV1       BDINAR                                    MD027197A
      *                                                                                    MD027197A
      ** Swift Common Reference Field                                                      MD027197A
      *                                                                                    MD027197A
     C                   CLEAR                   NARRTV                                    MD027197A
     C                   CLEAR                   NARRTV1                                   MD027197A
                                                                                           MD027197A
     C                   Z-ADD     1             Y                                         MD027197A
     C                   MOVEA     BDSWCR        NARRTV                                    MD027197A
     C                   DOU       Y = 30                                                  MD027197A
     C                   IF        NARRTV(Y) = '&'                                         MD027197A
     C                   MOVE      ' '           NARRTV(Y)                                 MD027197A
     C                   ENDIF                                                             MD027197A
     C                   ADD       1             Y                                         MD027197A
     C                   ENDDO                                                             MD027197A
     C                   MOVEA     NARRTV        NARRTV1                                   MD027197A
     C                   MOVEL     NARRTV1       BDSWCR                                    MD027197A
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
     C                   ENDSR                                                              MD027197
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  END    - End program                                         *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     END           BEGSR
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $StackPtr = $StackPtr + 1                                MD027197
     C                   Eval      $Stack($StackPtr) = 'END                    '            MD027197
 
     C                   EVAL      *INLR = *On
                                                                                            MD027197
      * Set Stack for subroutine                                                            MD027197
     C                   Eval      $Stack($StackPtr) = *Blanks                              MD027197
     C                   Eval      $StackPtr = $StackPtr - 1                                MD027197
                                                                                            MD027197
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls:          None                                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blanks
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
** LETR
ABCDEFGHIJKLMNOPQRSTUVWXYZ
