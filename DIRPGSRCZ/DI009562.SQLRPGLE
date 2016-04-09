     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Update Actual Amounts against Forecasts')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GL009562*-*Update*Actual*Amounts*against*Forecasts************                     MD029739
      *  DI009562 - Update Actual Amounts against Forecasts           *                     MD029739
      *                                                               *
      *  Function: This program performs a process that will include  *
      *            the update of Actual Amounts against Forecasts     *
      *  (I/C)     from the Accounting Rules process                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD029739 *RENAMED* Date 15Aug14               *
      *  Prev Amend No. MD031513           Date 27Jan15               *
      *                 MD030256           Date 27Oct14               *
      *                 MD027428           Date 09Jun14               *
      *                 MD027243           Date 29May14               *
      *                 MD025967           Date 24Apr14               *
      *                 MD026339           Date 24Apr14               *
      *                 MD024878B          Date 17Mar14               *
      *                 MD025310           Date 26Feb14               *
      *                 MD024878A          Date 24Feb14               *
      *                 MD024772           Date 03Feb14               *
      *                 MD024878           Date 20Feb14               *
      *                 MD024877           Date 20Feb14               *
      *                 MD024926           Date 14Feb14               *
      *                 MD024362B          Date 07Feb14               *
      *                 MD024513           Date 23Jan14               *
      *                 MD024362A          Date 24Jan14               *
      *                 MD024362           Date 14Jan14               *
      *                 MD023712 *Create   Date 30Oct13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD029739 - File renaming for integration layer.              *
      *  MD031513 - Serious midas error due to Cheque No. 00000000.   *
      *             Make Cheque No blank if equal to zeros.           *
      *  MD030256 - Correct printing when one sided accounting rule.  *
      *  MD027428 - Forecast update error. Actual amount of the Total *
      *             forecast should not update if there is an update  *
      *             in the individual forecast.                       *
      *  MD027243 - Printer Overflow Issue in GL009562P1.             *
      *  MD025967  - Produce a report of the Updates/Writes of the    *
      *              Forecasts from the Accounting Rules.             *
      *  MD026339  - Multiple Forecasts not created. Added validation *
      *              in Forecast Creation.                            *
      *  MD024878B - Additional validation for blank Source Customer. *
      *              Note that for some reasons, GL000703 (MOD/PGM)   *
      *              needs to be recompiled in order for the end to   *
      *              end test to work during PS UAT.                  *
      *  MD025310 - Nostro ccy/code and amount not synch on a created *
      *             multi-ccy Forecast                                *
      *  MD024878A - Use of dummy customer for blank Source Customer  *
      *            - Decimal data error due to wrong placement of     *
      *              Retail Account statement                         *
      *  MD024772 - Problems with Accounting Interface postings and   *
      *             enquiries. (Recompile)                            *
      *  MD024878 - Where Forecast ccy is different from Retail Acco. *
      *             currency one forecast is created                  *
      *             Master file becomes DIACIFTD and not any more     *
      *             GLACBDTD.                                         *
      *           - Validation of IFSADR and IFSACR changed. It will  *
      *             look on the Customer Account new field as well.   *
      *           - Zone field must be found as well from GLACBDTD    *
      *           - Process batch ID passed by driver program         *
      *  MD024877 - Multiple transactions reflected on Forecast       *
      *             Individual with only one item in the CSV file     *
      *             (fixed under ref. MD024878)                       *
      *  MD024926 - Forecast created via Accounting rules process is  *
      *             Debit instead of Credit to account and vice versa *
      *  MD024362B - Customer Source Account included to the unique   *
      *              keys                                             *
      *  MD024513 - Add Description field (30A) to the Accounting     *
      *             Rules. (Recompile)                                *
      *  MD024362A -  Subsidiaries Daily Sweeping Forecasts           *
      *               BDSACR and BDSADR cannot be blank if managed    *
      *  MD024362 -  Subsidiaries Daily Sweeping Forecasts            *
      *              Amendment of GLFORITD and GLFORTTD does not work *
      *              Missing coding records since last version        *
      *  MD023712 -  Subsidiaries Daily Sweeping Forecasts            *
      *              Update of Actual Amounts against Forecasts       *
      *              from the Accounting Rules Process                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas SD Nostro details retrieval
     FSDNOSTL4  IF   E           K DISK
      *
      ** Midas OF Update Actual Amounts against Forecast Report                             MD025967
     F***GL009562P1O E             PRINTER INFSR(*PSSR)                            MD025967 MD029739
     FDI009562P1O    E             PRINTER INFSR(*PSSR)                                     MD029737
     F                                     INFDS(SPOOL1)                                    MD025967
                                                                                            MD025967
      *****************************************************************
      ** Array containing Copyright statement
      *
     D/COPY ZSRSRC,ZALIGNZ1LE
     D/COPY ZSRSRC,ZFRPEDZ1LE
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)

      * Program data structure
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
      *
      ** Data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Data structure for Customer Details                                               MD024362A
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                               MD024362A
                                                                                           MD024362A
      ** Data Structure for Account Details file to check DR/CR indicator of the Retail Account
     D DsACCN        E DS                  EXTNAME(ACCNTAB)

     D SDCURR        E DS                  EXTNAME(SDCURRPD)

     **   Midas GL Accounting Rules Interface Batch Details file (before generation of batches)
     D*ACBDTD***     E DS                  EXTNAME(GLACBDTD)                                MD029739
     D ACBDTD        E DS                  EXTNAME(DIACBDTD)                                MD029739

     **   Midas GL Accounting Rules Interface Details file (before generation of batches)   MD024878
     D ACIFTD        E DS                  EXTNAME(DIACIFTD)                                MD024878
                                                                                            MD024878
     **   Midas OF Individual Forecast
     D FORIT         E DS                  EXTNAME(GLFORITD)
     D IFCCY1        E                     EXTFLD(IFCCY)                                    MD024878
     D IFNAR1        E                     EXTFLD(IFNARR)                                   MD024878

     **   Midas OF Total Forecast
     D FORTT         E DS                  EXTNAME(GLFORTTD)

      ** Data structure for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)
     D                                     PREFIX(#_)

      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second data structure for Access Programs, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ***File*Information*Data*Structure*for*GL009562P1.***************            MD025967 MD029739
      ** File Information Data Structure for DI009562P1.                                    MD029739
     D SPOOL1          DS                                                                   MD025967
     D   SFILE1               83     92                                                     MD025967
     D   SFNUM1              123    124B 0                                                  MD025967
     D   OFLLN1              188    189B 0                                                  MD025967
     D   PRTLN1              367    368B 0                                                  MD025967
                                                                                            MD025967
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      * Batch interface file DIACIFTD                                                       MD024878
      *   Work Fields                                                                       MD024878
     D WFBTID          S             60                                                     MD024878
     D WFEVTA          S             15                                                     MD024878
     D WCCY            S              3                                                     MD024878
     D WFSADR          S             24                                                     MD024878
     D WFSACR          S             24                                                     MD024878
     D WFSMT1          S             25                                                     MD024878
     D WFSMT2          S             25                                                     MD024878
     D WFSMT3          S             25                                                     MD024878
     D WFSMT4          S             25                                                     MD024878
     D WFSMT5          S             25                                                     MD024878
     D WFSMT6          S             25                                                     MD024878
     D WFSMT7          S             25                                                     MD024878
     D WFSMT8          S             25                                                     MD024878
     D WFSMT9          S             25                                                     MD024878
     D WFSMT10         S             25                                                     MD024878
     **  Forecast work fields
      *
     D WFSRCN          S              6
     D XFSRCN          S              6                                                     MD026339
     D WFCUST          S              6                                                     MD026339
     D WFFCRF          S             30
     D WFCSAI          S             34
     D WFCSAC          S             34                                                     MD024362
     D WFDATE          S              5  0 INZ(0)
     D WFOPTP          S             24
     D WFFACN          S             24
     D WFCUSA          S             24                                                     MD026339
     D WFACNO          S             10  0
     D WFNOSC          S              2
     D WFNOST          S              2                                                     MD026339
     D WFCCY           S              3
     D WFCURR          S              3                                                     MD026339
     D WFACTL          S             15  0
     D WForecastFlag   S              1                                                     MD024878

      * Parameters
      *
     D P_RtrnCode      S              7A                                        Return Code
     D P_Option        S              7A                                        Option
     D P_Action        S              1A                                        Action Code
     D P_Customer      S              6A                                        Customer
     D P_DummyCust     S              6A                                        ForecastDummyCust
     D P_CustSourAc    S             34A                                        Customer Source A/C
     D P_Operatype     S             20A                                        Operation Type
     D P_Date          S              5P 0                                      Event Date
     D P_FullGLAcc     S             24A                                        Full GL Account
     D P_Currency      S              3A                                        Currency
     D P_NostroCode    S              2A                                        Nostro Code
     D P_RetlAcNo      S             10S 0                                      Retail Account Nbr
     D P_Amount        S             15S 0                                      Forecast Amount
     D P_ActualAmnt    S             15S 0                                      Forecast Actual Amnt
     D P_Reference     S             30A                                        Forecast Reference
     D P_Narrative     S             30A                                        Forecast Narrative
     D P_FrontOffId    S             20A                                        Forecast FrontOffId
     D P_Zone          S             10A                                        Forecast Zone
     D P_ActualIsZero  S              1A                                        Forec.Actual is Zero
      *
     D WResult         S              1
     D Recursive       S              1
      *
      * Previous variables
      *
     D Prtcd           S              7A
     D Poptn           S              7A
     D PSard           S              6A

     D WRun            S              1A   INZ
     D ZADFMF          S             10

     D KAccount        DS
     D P@FACN                  1     24                                         Full GL Account
     D  DDBRCA                 1      3                                         Branch
     D  DDCNUM                 4      9                                         Customer number
     D  DDCUCD                10     12                                         Currency
     D  DDACOD                13     22  0                                      Account Code
     D  DDACSQ                23     24  0                                      Account Sequence

     D CGL135          S              1A
     D CGL145          S              1A

     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option

     D P@RETL          S             10A                                        Retail Account
     D P@CNUM          S                   LIKE(IFCUST)                         Customer
     D***P@CUCD*         S                   LIKE(IFCCY)                        Currency    MD024878
     D P@CUCD          S                   LIKE(CCY)                            Currency    MD024878
     D P@ACCD          S                   LIKE(ACOD)                           Account Code
     D P@ACSQ          S                   LIKE(ACSQ)                           Account Sequence
     D P@BRCA          S                   LIKE(BRCA)                           Branch

     D P@OP01          S             20A
     D P@VL01          S            200A
     D P@OP02          S             20A
     D P@VL02          S            200A
     D P@OP03          S             20A
     D P@VL03          S            200A
     D P@OP04          S             20A
     D P@VL04          S            200A
     D P@OP05          S             20A
     D P@VL05          S            200A
     D P@OP06          S             20A
     D P@VL06          S            200A
     D P@OP07          S             20A
     D P@VL07          S            200A
     D P@OP08          S             20A
     D P@VL08          S            200A
     D P@OP09          S             20A
     D P@VL09          S            200A
     D P@OP10          S             20A
     D P@VL10          S            200A
      *                                                                                     MD025310
     D TEMPCCY         S              3                                                     MD025310
      *                                                                                     MD025310
      ** Parameters for ZSFILE                                                              MD025967
     D PSeq            S              5                                                     MD025967
     D PLevel          S              1                                                     MD025967
     D SEnty           S              3                                                     MD025967
     D ZSnum           S              6  0                                                  MD025967
     D ZSnumU          S              6  0                                                  MD025967
     D ZSerr           S              1                                                     MD025967
                                                                                            MD025967
      ** Parameter for ZDATE2                                                               MD025967
     D ZDAYNO          S              5  0                                                  MD025967
     D ZDATE           S              6  0                                                  MD025967
     D ZADATE          S              7A                                                    MD025967
                                                                                            MD025967
      ** Parameter list fields                                                              MD025967
     D PMode           S              1                                                     MD025967
     D PLevl           S              1                                                     MD025967
     D PEnty           S              3                                                     MD025967
                                                                                            MD025967
      ** Other fields used                                                                  MD025967
     D WRecNo          S              7S 0 Inz                                              MD025967
     D RqdLn1          S              3  0                                                  MD025967
     D DifLn1          S              4  0                                                  MD025967
                                                                                            MD025967
     D WField          S             21A                                                    MD025967
     D PEdtCode        S              1A                                                    MD025967
     D PDecPlace       S              1  0                                                  MD025967
     D WAmount         S             15  0                                                  MD025967
                                                                                            MD025967
      *****************************************************************
      /EJECT
      *****************************************************************
      *                M A I N    P R O C E S S I N G
      *****************************************************************

     C*/exec SQL
     C*+ set option commit = *CHG
     C*/end-exec

     C                   EXSR      INIT

     C                   EXSR      MAIN

     C                   EVAL      *INLR = *ON

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *       Main  - Update Actual Amounts on Forecasts Individuals  *
      *                                                               *
      *****************************************************************

     C     MAIN          BEGSR

     C*******************move      'Y'           CGL135                                     MD024362
     C     CGL135        IFEQ      'Y'
     C     CGL145        ANDEQ     'Y'

      ****Read*File*Accounting*Rules*Batch*Det.*GLACBDTD*if*field*BDCMVF********            MD024878
      ****(Compare*vs*Forecast*Flag)*is*ticked*with*'Y'*and*BDFRST*(Forecast*Status)**      MD024878
      *** Read File Accounting Rules Interface Det. DIACIFTD if field BDCMVF from GLACBDTD  MD024878
      *** (Compare vs Forecast Flag) is ticked with 'Y' and IFFSTA (Forecast Status)        MD024878
      *** not equal to 'Y'
      *
      ***Access*Accounting*Rules*Batch*Det.*File*GLACBDTD************                       MD024878
      ** Access Accounting Rules Interface Det. File DIACIFTD                               MD024878
     C/Exec SQL
     C+ declare LIST cursor for
     C***+ select * from GLACBDTD                                                           MD024878
     C+ select * from DIACIFTD                                                              MD024878
     C+ where IFBTID = :PBTID                                                               MD024878
     C/End-Exec
      *
     C/Exec SQL
     C+ open LIST
     C/End-Exec
      *
      ** Handle SQL Error (if not %EOF)
      *
     C                   If        SQLCOD < 0

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/exec SQL
     C+ fetch next
     C+ from LIST
     C***+ into :ACBDTD                                                                     MD024878
     C+ into :ACIFTD                                                                        MD024878
     C/end-Exec
      *
      ***For*each*record*in*GLACBDTD*check$if*'Compare*Vs*Forecast*Flag'*is*Ticked*(BDCMVF) MD024878
      ***and*BDFRST*(Forecast*Status)*not*equal*to*'Y'***********                           MD024878
      ** For each record in DIACIFTD check if 'Compare Vs Forecast Flag' is Ticked (BDCMVF) MD024878
      ***from*GLACBDTD*and*IFFSTA*(Forecast*Status)*not*equal*to*'Y'***            MD024878 MD029739
      ** from DIACBDTD and IFFSTA (Forecast Status) not equal to 'Y'                        MD029739
      *
     C                   EXSR      RtvNosRet                                                MD026339
     C                   Eval      WFCUST = *BLANKS                                         MD026339
     C                   Eval      WFCSAI = *BLANKS                                         MD026339
     C                   Eval      WFCURR = *BLANKS                                         MD026339
     C                   Eval      WFNOST = *BLANKS                                         MD026339
     C                   Eval      WFDATE = *ZEROS                                          MD026339
     C                   Eval      WFOPTP = *BLANKS                                         MD026339
     C                   Eval      WFCUSA = *BLANKS                                         MD026339
     C                   Eval      WFSADR = *BLANKS                                         MD026339
     C                   Eval      WFSACR = *BLANKS                                         MD026339
     C                   Eval      WFFCRF = *BLANKS                                         MD026339
     C                   Eval      XFSRCN = *BLANKS                                         MD026339
                                                                                            MD026339
     C                   Eval      WForecastFlag = 'N'                                      MD024878
                                                                                            MD025967
     C                   Move      *BLANKS       Forecast         12                        MD025967
                                                                                            MD025967
      ** Print Report Header 1                                                              MD025967
                                                                                            MD025967
     C**********         WRITE     HEADER1                                         MD025967 MD027243
                                                                                            MD025967
      ** Print Report Header 2                                                              MD025967
                                                                                            MD025967
     C**********         WRITE     HEADER2                                         MD025967 MD027243
                                                                                            MD025967
     C                   Dow       SQLCODE <> 100
     C**********                   and WForecastFlag = 'N'                         MD024878 MD026339
                                                                                            MD024878
     C                   IF        (WFCUST <> WRCNUM OR                                     MD026339
     C                              WFCSAI <> IFCSAI OR                                     MD026339
     C                              WFCURR <> IFCCY OR                                      MD026339
     C                              WFNOST <> WFNOSC OR                                     MD026339
     C                              WFDATE <> IFEVTD OR                                     MD026339
     C                              WFOPTP <> IFOPTP OR                                     MD026339
     C                              WFCUSA <> IFCUSA OR                                     MD026339
     C                              WFFCRF <> IFFCRF) OR                                    MD026339
     C                             (WFCUST = WRCNUM AND                                     MD026339
     C                              WFCSAI = IFCSAI AND                                     MD026339
     C                              WFCURR = IFCCY AND                                      MD026339
     C                              WFNOST = WFNOSC AND                                     MD026339
     C                              WFDATE = IFEVTD AND                                     MD026339
     C                              WFOPTP = IFOPTP AND                                     MD026339
     C                              WFCUSA = IFCUSA AND                                     MD026339
     C                              WFFCRF = IFFCRF AND WForecastFlag = 'N')                MD026339
     C                                                                                      MD026339
     C                   EVAL      COCMVF = *BLANKS                                         MD026339
     C                   MOVE      ' '           NWRUP             1                        MD024878
                                                                                            MD024878
      ***Retrive*Compare*vs*Forecast*Flag*in*GLACBDTD******************            MD024878 MD029739
      ** Retrive Compare vs Forecast Flag in DIACBDTD                                       MD029739
      *                                                                                     MD024878
     C                   EXSR      SrRtvCMVF                                                MD024878
      *                                                                                    MD024362
      * If not record found skip to next                                                   MD030256
     C                   If        W#AcFd = 'N'                                            MD030256
     C                   GOTO      EndMainTag                                              MD030256
     C                   Endif                                                             MD030256
                                                                                           MD030256
      *   could be deleted if i-series is working very fast  - if not 10 seconds           MD024362
     C                   CALL      'ZACDELAY3'                                             MD024362
      *
      ** This check will coordinate the update of actual amounts on
      ** Forecast Individual and Total files via JMS JAVA Forecast API
      *
     C*****BDCMVF        IFEQ      'Y'                                                      MD024878
     C*****BDFRST        ANDNE     'Y'                                                      MD024878
     C     COCMVF        IFEQ      'Y'                                                      MD024878
     C     IFFSTA        ANDNE     'Y'                                                      MD024878
      *
     ** Find Forecast Individual and update actual amounts via JMS SAOP Java Forecast API
      *
     C                   Z-ADD     0             NFON              1 0
     C                   EVAL      XFSRCN = IFSRCN                                          MD026339
     C                   EVAL      WFCUSA = IFCUSA                                          MD026339
     C                   EVAL      WFACNO = *ZEROS                                          MD026339
      *
      *   forecast reference is not blank
     C                   EXSR      SRFORRC1
      *
     C     NFON          IFNE      0
     C                   Z-ADD     0             NFON
     C                   GOTO      FindForCast
     C                   ELSE
     C                   GOTO      EndMainTag
     C                   END
      *
     C     FindForCast   TAG
      *
     ***Find*Forecast*totals*and*update*actual*amounts*via*JMS*SAOP*Java*Forecast*API       MD024362
     ** Find Individu.Foreca. and update actual amounts via MQ Chan. Java Forecast API      MD024362
      *
      *   Operation type is not blank
     C                   EXSR      SRFOROC1
      *
     C     NFON          IFNE      0
     C                   Z-ADD     0             NFON
     C                   GOTO      FindForCast2
     C                   ELSE
     C                   GOTO      EndMainTag
     C                   END
      *
     C     FindForCast2  TAG

      ** Access Forecast Totals Index file GLFORTTD

     C                   EXSR      SRFORTT1

     C     NFON          IFNE      0
     C                   Z-ADD     0             NFON
     C                   GOTO      NoForeCast
     C                   ELSE
     C                   GOTO      EndMainTag
     C                   END

     C     NoForeCast    TAG

      ** Nothing found so add a new record in Forecast Individual

     C                   EXSR      FORADD

     C                   ENDIF

     C*/EXEC* SQL***************************************                                    MD024362
     C*+*UPDATE*GLACBDTD*SET*BDFRST*=*:WFFRST***********                                    MD024362
     C*+*WHERE*BDFRST*=*' '*****************************                                    MD024362
     C*/END-EXEC****************************************                                    MD024362
                                                                                            MD026339
      ** Reposition EndMainTag such that previous values will be saved and next read        MD026339
      ** will be executed                                                                   MD026339
     C                                                                                      MD026339
     C     EndMainTag    TAG                                                                MD026339
                                                                                            MD025967
      ** Print Details                                                                      MD025967
                                                                                            MD025967
      * If record found then try to report                                                  MD030256
     C                   If        W#AcFd <> 'N'                                            MD030256
     C                   EXSR      SRPrintDtl                                               MD025967
     C                   Endif                                                              MD030256
                                                                                            MD030256
     C                   Move      *BLANKS       Forecast                                   MD025967
                                                                                            MD025967
                                                                                            MD026339
     C                   EVAL      WFNOST = WFNOSC                                          MD026339
     C                   EVAL      WFCURR = IFCCY                                           MD026339
     C                   EVAL      WFCUST = WRCNUM                                          MD026339
                                                                                            MD026339
     C                   ENDIF                                                              MD026339
                                                                                            MD026339

     C/Exec SQL
     C+ Fetch next
     C+ from LIST
     C***+ into :ACBDTD                                                                     MD024878
     C+ into :ACIFTD                                                                        MD024878
     C/End-exec

     C                   Enddo

      ** Handle SQL Error (if not %EOF)

     C**********         If        SQLCode < 100                                            MD025310
     C                   If        SQLCode < 0                                              MD025310

     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   EndIf

     C/Exec SQL
     C+ Close LIST
     C/End-Exec

     C**********     EndMainTag    TAG                                                      MD026339

      ** Print Footer                                                                       MD025967
     C                   WRITE     FOOTER                                                   MD025967
                                                                                            MD025967
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    SRFORRC1 - Update Actual Amounts on Forecasts Individuals  *
      *               if found  (with forecast reference)             *
      *****************************************************************
     C     SRFORRC1      BEGSR

      * Move Primary Keys to a temporary field
      * Ccy, Nostro code and Retail number are converted from Settlement account D or C in next part

     C**********         Eval      WFSRCN = BDSRCN                                          MD024878
     C**********         Eval      WFCSAI = BDCSAI                                          MD024878
     C**********         Eval      WFOPTP = BDOPTP                                          MD024878
     C**********         Eval      WFFCRF = BDFCRF                                          MD024878
     C**********         Eval      WFDATE = BDEVTD                                          MD024878
     C                   Eval      WFSRCN = IFSRCN                                          MD024878
     C                   Eval      WFCSAI = IFCSAI                                          MD024878
     C                   Eval      WFOPTP = IFOPTP                                          MD024878
     C                   Eval      WFFCRF = IFFCRF                                          MD024878
     C                   Eval      WFDATE = IFEVTD                                          MD024878

      ***First*--->*Settlement*Account*Debit*to*create*or*update*an*individual*forecast*via*MD024878
      ***If*BDDCIP*is*'D'*use*BDSADR*and*convert*it*to*Nostro*Code*                         MD024362
      ***(Settlement*Account*Debit)*else*use*BDSACR*and*convert*it*to*Nostro*Code*          MD024362
      ***If*BDDCIP*is*'D'*use*BDSACR*and*convert*it*to*Settlement*Account         MD024362 MD024362A
      ***(Settlement*Account*Credit)*else*use*BDSADR*and*convert*it*to*Nostro CodeMD024362 MD024362A
      ***Else*DBDCIP*is*'C'*it's*the*other*way.************************           MD024362 MD024362A
                                                                                           MD024362A
      ***To*get*the*Nostro*Code*for*Forecast*searches,*take*either*the*******     MD024362A MD024878
      ***Settle*Account*Debit*if*D/C*indicator*is*'D'*or*Settle Account******     MD024362A MD024878
      ***Credit*if*D/C*indicatory*is*'C'*and*convert*it*to*Nostro*Code*******     MD024362A MD024878
                                                                                           MD024362A
      ***To*get*the*retail*account*for*Forecast*searches,*take*either*the****     MD024362A MD024878
      ***Settle*Account*debit*if*D/C*indicator*is*'C'*or*Settle Account******     MD024362A MD024878
      ***Credit*if*D/C*indicator*is*'D'*and*convert*it*to*GL*Account*ID******     MD024362A MD024878

      ** Retrieve now Nostro code and Retail Number for the rest of the processing          MD024878
                                                                                            MD024878
     C                   EXSR      RtvNosRet                                                MD024878
                                                                                            MD024878
     C*****BDDCIP        Ifeq      'D'                                                      MD024878
     C*******************Eval      P@FACN = BDSADR                                          MD024362
     C**********         Eval      P@FACN = BDSACR                                 MD024362 MD024878
      **********                                                                            MD024878
      ****Find*Retail*number*of*the*Settlement*Account****                                  MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *blanks                                         MD024362 MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                             MD024362 MD024878
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
      **********                                                                   MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
     C**********         END                                                       MD024362 MD024878
      **********                                                                            MD024878
      ***-*If*Retail*Account*number*is*zero*or*not*found**                                  MD024878
      **********                                                                            MD024878
     C*****ACNO          IFNE      0                                                        MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
     C*******************Eval      P@FACN = BDSACR                                          MD024362
     C**********         Eval      P@FACN = BDSADR                                 MD024362 MD024878
     C**********         Eval      P@FACN = IFSADR                                          MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account*                                       MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *BLANKS                                        MD024362A MD024878
      **********                                                                  MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      **********                                                                            MD024878
     C**** *IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Else                                                               MD024878
     C***********        Eval      P@FACN = BDSACR                                          MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account**                                      MD024878
      ***********                                                                           MD024878
     C*****BDSACR        IFNE      *BLANKS                                        MD024362A MD024878
      **********                                                                  MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      **********                                                                            MD024878
     C**** *IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      ***********                                                                           MD024878
     C*************      Eval      P@FACN = BDSADR                                          MD024878
      ***********                                                                           MD024878
      ****Find*Retail*number*of*the*Settlement*Account**                                    MD024878
      ***********                                                                           MD024878
     C*****BDSADR        IFNE      *blanks                                         MD024362 MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                             MD024362 MD024878
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
      **********                                                                   MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
     C**********         END                                                       MD024362 MD024878
      **********                                                                            MD024878
      ***-*If*Retail*Account*number*is*zero*or*not*found                                    MD024878
      **********                                                                            MD024878
     C*****ACNO********  IFNE      0                                                        MD024878
     C**********         MOVE      CCY           WFCCY                            MD024362A MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
                                                                                            MD024878
     C**********         END                                                                MD024878
      *
      ***Step*1A**********************************************                              MD024362
      ****Search*Forecast*for*a*Settlememnt*Account*Debit*****                              MD024362
      *  Step 1                                                                             MD024362
      *  Search Forecast for a Settlememnt Account                                          MD024362
      *
     C*****BDSADR        IFNE      *BLANKS                                                  MD024362
      *
     C*****BDFCRF        Ifne      *blanks                                                  MD024878
b1   C     NWRUP         Ifeq      *blanks                                                  MD024878
                                                                                            MD024878
b2   C     WFFCRF        Ifne      *blanks                                                  MD024878
      *
      ** Access Forecast Individual  - GLFORITD index is IFCUST, IFCSAC, IFCCY, IFNOSC, IFOPTY
      *********************************IFACNO,*IFREFN,*IFDATE**                             MD024878
      *                                IFACNO, IFFCRF, IFDATE                               MD024878

      *  from GLFORITD (Individual Forecast)
     C/Exec SQL
     C+       Select * into: FORIT from GLFORITD
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******IFCSAC*=*:WFCSAC*and***************************                              MD024362
     C+ where IFRECI = 'D'     and                                                          MD024362
     C+       IFCUST = :WFSRCN and                                                          MD024362
     C+       IFCSAC = :WFCSAI and                                                          MD024362
     C+       IFCCY  = :WFCCY  and
     C+       IFNOSC = :WFNOSC and
     C+       IFOPTY = :WFOPTP and
     C+       IFACNO = :WFACNO and
     C+       IFREFN = :WFFCRF and
     C+       IFDATE = :WFDATE
     C/End-EXEC
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process for Amend Individual Forecast
     C                   EXSR      PROCIF
     C                   EVAL      Forecast = 'Update'                                      MD025967
     C                   ELSE
     C                   Z-ADD     1             NFON                                       MD024878
e3   C                   END                                                                MD024878
x2   C                   ELSE                                                               MD024878
     C*****IFREFN        IFEQ      *BLANK                                                   MD024878
      *  from GLFORITD (Individual Forecast)
     C/Exec SQL
     C+       Select * into: FORIT from GLFORITD
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******IFCSAC*=*:WFCSAC*and***************************                              MD024362
     C+ where IFRECI = 'D'     and                                                          MD024362
     C+       IFCUST = :WFSRCN and                                                          MD024362
     C+       IFCSAC = :WFCSAI and                                                          MD024362
     C+       IFCCY  = :WFCCY  and
     C+       IFNOSC = :WFNOSC and
     C+       IFOPTY = :WFOPTP and
     C+       IFACNO = :WFACNO and
     C+       IFDATE = :WFDATE
     C/End-EXEC
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process for Amend Individual Forecast
     C                   EXSR      PROCIF
     C                   EVAL      Forecast = 'Update'                                      MD025967
     C                   ELSE
     C                   Z-ADD     1             NFON
     C                   END
     C                   END

e1   C                   END                                                                MD024878
     C**********         END                                                                MD024878
     C**********         END                                                                MD024878
     C*******************END                                                                MD024362
      ********************************************************                              MD024362
      ***Step*1B**********************************************                              MD024362
      ****Search*Forecast*for*a*Settlememnt*Account*Credit****                              MD024362
      **********                                                                            MD024362
     C*****BDSACR        IFNE      *BLANKS                                                  MD024362
      **********                                                                            MD024362
     C*****BDFCRF        Ifne      *blanks                                                  MD024362
      **********                                                                            MD024362
      ***Access*Forecast*Individual**-*GLFORITD*index*is*IFCUST,*IFCSAC,*IFCCY,*IFNOSC,*IFOPTY
      *********************************IFACNO,*IFREFN,*IFDATE*                              MD024362
      **********                                                                            MD024362
      ***from*GLFORITD*(Individual*Forecast)******************                              MD024362
     C*/Exec*SQL**********************************************                              MD024362
     C*+***Select***into:*FORIT*from*GLFORITD*****************                              MD024362
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******IFCSAC*=*:WFCSAC*and***************************                              MD024362
     C*+*******IFCCY**=*:WFCCY  and***************************                              MD024362
     C*+*******IFNOSC*=*:WFNOSC and***************************                              MD024362
     C*+*******IFOPTY*=*:WFOPTP and***************************                              MD024362
     C*+*******IFACNO*=*:WFACNO and***************************                              MD024362
     C*+*******IFREFN*=*:WFFCRF and***************************                              MD024362
     C*+*******IFDATE*=*:WFDATE*******************************                              MD024362
     C*/End-EXEC**********************************************                              MD024362
     C*******************If        SQLCOD = 0                                               MD024362
      ***If*Found,*then*process*for*Amend*Individual*Forecast*                              MD024362
     C*******************EXSR      PROCIF                                                   MD024362
     C*******************ELSE                                                               MD024362
     C*****IFREFN        IFEQ      *BLANK                                                   MD024362
     ****from*GLFORITD*(Individual Forecast)******************                              MD024362
     C*/Exec*SQL**********************************************                              MD024362
     C*+*******Select***into:*FORIT*from*GLFORITD*************                              MD024362
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******IFCSAC = :WFCSAC and***************************                              MD024362
     C*+*******IFCCY  = :WFCCY  and***************************                              MD024362
     C*+*******IFNOSC = :WFNOSC and***************************                              MD024362
     C*+*******IFOPTY = :WFOPTP and***************************                              MD024362
     C*+*******IFACNO = :WFACNO and***************************                              MD024362
     C*+*******IFDATE = :WFDATE***************************                                  MD024362
     C*/End-EXEC**********************************************                              MD024362
     C*******************If        SQLCOD = 0                                               MD024362
      ***If*Found,*then*process*for*Amend*Individual*Forecast*                              MD024362
     C*******************EXSR      PROCIF                                                   MD024362
     C*******************ELSE                                                               MD024362
     C*******************Z-ADD     1             NFON                                       MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362
      **********                                                                            MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362

      *================================================================
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROCIF - Prepare a Message to Update Actual Amount on Indi-  *
      *           vidual Forecast and automatically Total Actual      *
      *           Amount on Forecast Totals via JMS MQ                *
      *                                                               *
      *****************************************************************
     C     PROCIF        BEGSR
      *
      ** Forecast exists so update actual amount and create message to send to JMS
      *
     C                   EVAL      P_Action = 'A'
      *
     C**********         IF        BDEVTA <> *BLANKS                                        MD024878
     C                   IF        IFEVTA <> *BLANKS                                        MD024878
     C                   EVAL      ZFIELD = %SUBST(BDEVTA:1:15)
     C*******************EVAL      ZADEC  = A6NBDP                                          MD024362
     C*******************EVAL      ZADIG  = 15 - A6NBDP                                     MD024362
     C                   EVAL      ZADEC  = 0                                               MD024362
     C                   EVAL      ZADIG  = 15 - ZADEC                                      MD024362
     C                   EXSR      SRAlign
     C                   MOVE      ZAFLD         P_ActualAmnt
      *                                                                                     MD024362
     C*****BDDCIP        IFEQ      'C'                                                      MD024878
     C     IFDCIP        IFEQ      'C'                                                      MD024878
     C                   EVAL      P_ActualAmnt =  P_ActualAmnt * -1
     C                   ENDIF
      *                                                                                     MD024362
     C     P_ActualAmnt  Add       IFACTL        P_ActualAmnt                               MD024362
      *                                                                                     MD024362
     C                   ENDIF
      *
     C                   CALL      'GL000703'                           99
     C                   PARM      *Blanks       P_RtrnCode                     Return Code
     C                   PARM      *Blanks       P_Option                       Option
     C                   PARM                    P_Action                       Action Code
     C                   PARM      IFCUST        P_Customer                     Customer Number
     C                   PARM      IFCSAC        P_CustSourAc                   Customer Source AC/
     C                   PARM      IFOPTY        P_Operatype                    Operation Type
     C                   PARM      IFDATE        P_Date                         Event Date
     C                   PARM      IFFACN        P_FullGLAcc                    Full GL account
     C                   PARM      IFCCY         P_Currency                     Currency
     C                   PARM      IFNOSC        P_NostroCode                   Nostro Code
     C                   PARM      IFACNO        P_RetlAcNo                     Retail Account Nb
     C                   PARM      IFAMNT        P_Amount                       Forecast Amount
     C                   PARM                    P_ActualAmnt                   Forecast Actual Amnt
     C                   PARM      IFREFN        P_Reference                    Forecast Reference
     C                   PARM      IFNARR        P_Narrative                    Forecast Narrative
     C                   PARM      IFFRNT        P_FrontOffId                   Forecast Front OffId
     C                   PARM      IFZONE        P_Zone                         Forecast Zone
     C                   PARM      IFACZR        P_ActualIsZero                 Forec.Actual is zero
      *
     C     PRtcd         IFEQ      *BLANK                                                  MD024362A
     C                   MOVE      'Y'           WFFRST            1            Forecast Status
     C                   EVAL      WForecastFlag = 'Y'                                      MD024878
     C                   END                                                               MD024362A
      *
     C/EXEC SQL                                                                             MD024362
     C***+ UPDATE GLACBDTD SET BDFRST = :WFFRST                                    MD024362 MD024878
     C***+ WHERE BDFRST <>  'Y'                                                    MD024362 MD024878
     C+ UPDATE DIACIFTD SET IFFSTA = :WFFRST                                                MD024878
     C+ WHERE IFFSTA <>  'Y'                                                                MD024878
     C+ AND IFCSAI = :WFCSAI AND IFBTID = :PBTID                                            MD026339
     C+ AND IFCCY = :WFCCY AND IFEVTD = :WFDATE                                             MD026339
     C+ AND IFOPTP = :WFOPTP AND IFCUSA = :WFCUSA                                           MD026339
     C+ AND IFFCRF = :WFFCRF AND IFSADR = :WFSADR                                           MD026339
     C+ AND IFSACR = :WFSACR AND IFSRCN = :XFSRCN                                           MD026339
     C/END-EXEC                                                                             MD024362
      *                                                                                     MD024362
     C                   Z-ADD     0             NFON                                       MD027428
                                                                                            MD027428
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PROCUP - Update record in GLFORTTD                           *
      *                                                               *
      *****************************************************************
     C     PROCUP        BEGSR
      *
      ** Forecast Totals exists so update Actual amount directly on GLFORTTD
      *
     C**********         IF        BDEVTA <> *BLANKS                                        MD024878
     C                   IF        IFEVTA <> *BLANKS                                        MD024878
     C                   EVAL      ZFIELD = %SUBST(BDEVTA:1:15)
     C*******************EVAL      ZADEC  = A6NBDP                                          MD024362
     C*******************EVAL      ZADIG  = 15 - A6NBDP                                     MD024362
     C                   EVAL      ZADEC  = 0                                               MD024362
     C                   EVAL      ZADIG  = 15 - ZADEC                                      MD024362
     C                   EXSR      SRAlign
     C                   MOVE      ZAFLD         WFACTL
     C*****BDDCIP        IFEQ      'C'                                                      MD024878
     C     IFDCIP        IFEQ      'C'                                                      MD024878
     C                   EVAL      WFACTL = WFACTL * -1
     C                   ENDIF
     C                   EVAL      WFACTL = WFACTL + TFACTL                                 MD026339
     C                   MOVE      TFAMNT        WFAMNT           15 0                      MD025967
     C                   ENDIF
      *
     C/EXEC SQL
     C+ UPDATE GLFORTTD SET TFACTL = :WFACTL
     C+ where TFRECI = 'D'     and                                                          MD024362
     C+       TFCUST = :WFSRCN and                                                          MD024362
     C+       TFCSAC = :WFCSAI and                                                          MD024362
     C+       TFCCY  = :WFCCY  and                                                          MD024362
     C+       TFNOSC = :WFNOSC and                                                          MD024362
     C+       TFACNO = :WFACNO and                                                          MD024362
     C+       TFDATE = :WFDATE                                                              MD024362
     C/END-EXEC
      *
     C     PRtcd         IFEQ      *BLANK                                                  MD024362A
     C                   MOVE      'Y'           WFFRST                         Forecast St.MD024362
     C                   MOVE      'Y'           WForecastFlag                              MD026339
     C                   END                                                               MD024362A
      *                                                                                     MD024362
     C/EXEC SQL                                                                             MD024362
     C***+ UPDATE GLACBDTD SET BDFRST = :WFFRST                                    MD024362 MD024878
     C***+ WHERE BDFRST <>  'Y'                                                    MD024362 MD024878
     C+ UPDATE DIACIFTD SET IFFSTA = :WFFRST                                                MD024878
     C+ WHERE IFFSTA <>  'Y'                                                                MD024878
     C+ AND IFCSAI = :WFCSAI AND IFBTID = :PBTID                                            MD026339
     C+ AND IFCCY = :WFCCY AND IFEVTD = :WFDATE                                             MD026339
     C+ AND IFOPTP = :WFOPTP AND IFCUSA = :WFCUSA                                           MD026339
     C+ AND IFFCRF = :WFFCRF AND IFSADR = :WFSADR                                           MD026339
     C+ AND IFSACR = :WFSACR AND IFSRCN = :XFSRCN                                           MD026339
     C/END-EXEC                                                                             MD024362
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                     MD024362
      *  PROCUP2 - Update record in GLFORTTD                          *                     MD024362
      *****************************************************************                     MD024362
     C     PROCUP2       BEGSR                                                              MD024362
      *                                                                                     MD024362
      ** Forecast Totals exists so update Actual amount directly on GLFORTTD                MD024362
      *                                                                                     MD024362
     C**********         IF        BDEVTA <> *BLANKS                               MD024362 MD024878
     C                   IF        IFEVTA <> *BLANKS                                        MD024878
     C                   EVAL      ZFIELD = %SUBST(BDEVTA:1:15)                             MD024362
     C                   EVAL      ZADEC  = 0                                               MD024362
     C                   EVAL      ZADIG  = 15 - ZADEC                                      MD024362
     C                   EXSR      SRAlign                                                  MD024362
     C                   MOVE      ZAFLD         WFACTL                                     MD024362
     C*****BDDCIP        IFEQ      'C'                                             MD024362 MD024878
     C     IFDCIP        IFEQ      'C'                                                      MD024878
     C                   EVAL      WFACTL = WFACTL * -1                                     MD024362
     C                   ENDIF                                                              MD024362
     C                   EVAL      WFACTL = WFACTL + TFACTL                                 MD026339
     C                   MOVE      TFAMNT        WFAMNT                                     MD025967
     C                   ENDIF                                                              MD024362
      *                                                                                     MD024362
     C/EXEC SQL                                                                             MD024362
     C+ UPDATE GLFORTTD SET TFACTL = :WFACTL                                                MD024362
     C+ where TFRECI = 'D'     and                                                          MD024362
     C+       TFCUST = :WFSRCN and                                                          MD024362
     C+       TFCSAC = :WFCSAI and                                                         MD024362B
     C+       TFCCY  = :WFCCY  and                                                          MD024362
     C+       TFNOSC = :WFNOSC and                                                          MD024362
     C+       TFACNO = :WFACNO and                                                          MD024362
     C+       TFDATE = :WFDATE                                                              MD024362
     C/END-EXEC                                                                             MD024362
      *                                                                                     MD024362
     C                   MOVE      'Y'           WFFRST                         Forecast St.MD024362
     C                   MOVE      'Y'           WForecastFlag                              MD026339
      *                                                                                     MD024362
     C/EXEC SQL                                                                             MD024362
     C***+ UPDATE GLACBDTD SET BDFRST = :WFFRST                                    MD024362 MD024878
     C***+ WHERE BDFRST <>  'Y'                                                    MD024362 MD024878
     C+ UPDATE DIACIFTD SET IFFSTA = :WFFRST                                                MD024878
     C+ WHERE IFFSTA <>  'Y'                                                                MD024878
     C+ AND IFCSAI = :WFCSAI AND IFBTID = :PBTID                                            MD026339
     C+ AND IFCCY = :WFCCY AND IFEVTD = :WFDATE                                             MD026339
     C+ AND IFOPTP = :WFOPTP AND IFCUSA = :WFCUSA                                           MD026339
     C+ AND IFFCRF = :WFFCRF AND IFSADR = :WFSADR                                           MD026339
     C+ AND IFSACR = :WFSACR AND IFSRCN = :XFSRCN                                           MD026339
     C/END-EXEC                                                                             MD024362
      *                                                                                     MD024362
     C                   ENDSR                                                              MD024362
      *                                                                                     MD024362
      *****************************************************************                     MD024362
      /EJECT
      *****************************************************************
      *                                                               *
      *    SRFOROC1 - Update Actual Amounts on Forecasts Individuals  *
      *               if found  (with Operation Type)                 *
      *****************************************************************
     C     SRFOROC1      BEGSR

      * Move Primary Keys to a temporary field
      * Ccy, Nostro code and Retail number are converted from Settlement account D or C in next part

     C*****BDSRCN        IFNE       BLANK                                         MD024362A MD024878
     C     IFSRCN        IFNE      *BLANK                                                   MD024878
                                                                                         MD024362A
      ** If Non Equal *BLank it must be a correct customer number                        MD024362A
      ** else there is a DB error                                                        MD024362A
                                                                                         MD024362A
     C                   EXSR      SrRtvCust                                             MD024362A
     C**********         EVAL      WFSRCN = BDSRCN                                MD024362A MD024878
     C                   EVAL      WFSRCN = IFSRCN                                          MD024878
     C                   ELSE                                                            MD024362A
      **                                                                                   MD024878B
      ** Calling of RtvNosRet Subroutine was moved here to use the Customer Number         MD024878B
      ** retrieved from the Retail Account.                                                MD024878B
      **                                                                                   MD024878B
     C                   EXSR      RtvNosRet                                               MD024878B
      **                                                                                   MD024878B
      ** Use WRCNUM retrieved from RtvNosRet if not blanks                                 MD024878B
      **                                                                                   MD024878B
     C                   IF        WRCNUM <> *BLANKS                                       MD024878B
     C                   EVAL      WFSRCN = WRCNUM                                         MD024878B
     C                   EVAL      IFSRCN = WRCNUM                                         MD024878B
     C                   ELSE                                                              MD024878B
      **                                                                                   MD024878B
      ** Use Dummy Customer defined in the System Values instead                           MD024878B
      ** if no Customer retrieved from the Account                                         MD024878B
      **                                                                                   MD024878B
     C                   EVAL      WFSRCN = P_DummyCust                                  MD024362A
     C**********         EVAL      BDSRCN = P_DummyCust                           MD024362A MD024878
     C                   EVAL      IFSRCN = P_DummyCust                                     MD024878
     C                   ENDIF                                                             MD024878B
     C                   ENDIF                                                           MD024362A
                                                                                         MD024362A
     C**********         Eval      WFSRCN = BDSRCN                                       MD024362A
     C**********         Eval      WFCSAI = BDCSAI                                          MD024878
     C**********         Eval      WFOPTP = BDOPTP                                          MD024878
     C**********         Eval      WFFCRF = BDFCRF                                          MD024878
     C**********         Eval      WFDATE = BDEVTD                                          MD024878
     C                   Eval      WFCSAI = IFCSAI                                          MD024878
     C                   Eval      WFOPTP = IFOPTP                                          MD024878
     C                   Eval      WFFCRF = IFFCRF                                          MD024878
     C                   Eval      WFDATE = IFEVTD                                          MD024878

      *  First ---> Settlement Account Debit to create or update an individual forecast via JMS
      ***If*BDDCIP*is*'D'*use*BDSADR*and*convert*it*to*Nostro*Code***                       MD024362
      ***(Settlement*Account*Debit)*else*use*BDSACR*and*convert*it*to*Nostro*Code           MD024362
      ***If BDDCIP*is*'D'*use*BDSACR*and*convert*it*to*Settlement*Account***       MD024362 MD024878
      ***(Settlement*Account*Credit)*else*use*BDSADR*and*convert*it*to*Nostro*Code*MD024362 MD024878
      ***Else*DBDCIP*is*'C'*it's*the*other*way.******                              MD024362 MD024878
                                                                                            MD024878
      **Retrieve*now*Nostro*code*and*Retail*Number*for*the*rest*of*the*processing MD024878 MD024878B
      *                                                                                     MD024878
      ** This subroutine was moved above after checking if IFSCRN(Source Customer) = blank MD024878B
      **                                                                                   MD024878B
     C**********         EXSR      RtvNosRet                                      MD024878 MD024878B
                                                                                            MD024878
     C*****BDDCIP        IFEQ      'D'                                                      MD024878
      *
     C*******************Eval      P@FACN = BDSADR                                          MD024362
     C**********         Eval      P@FACN = BDSACR                                 MD024362 MD024878
      **********                                                                            MD024878
      ****Find*Retail*number*of*the*Settlement*Account**                                    MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *blanks                                         MD024362 MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
     C**********         END                                                       MD024362 MD024878
      **********                                                                            MD024878
      ***-*If*Retail*Account*number*is*zero*or*not*found*******                             MD024878
      **********                                                                            MD024878
     C*****ACNO          IFNE      0                                                        MD024878
     C**********         MOVE      CCY           WFCCY                            MD024362A MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
     C*******************Eval      P@FACN = BDSACR                                          MD024362
     C**********         Eval      P@FACN = BDSADR                                 MD024362 MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account********                                MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *blanks                                        MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      **********                                                                            MD024878
     C**** *IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Else                                                               MD024878
     C**********         Eval      P@FACN = BDSACR                                          MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account************                            MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *blanks                                        MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      ***********                                                                           MD024878
     C**** *IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Eval      P@FACN = BDSADR                                          MD024878
      **********                                                                            MD024878
      ****Find*Retail*number*of*the*Settlement*Account******                                MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *blanks                                                  MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
      **********                                                                   MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
     C**********         END                                                       MD024362 MD024878
      **********                                                                            MD024878
      ***-*If*Retail*Account*number*is*zero*or*not*found***                                 MD024878
      **********                                                                            MD024878
     C*****ACNO          IFNE      0                                                        MD024878
     C**********         MOVE      CCY           WFCCY                            MD024362A MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
     C**********         END                                                                MD024878
      *
      ***Step*2A**********************************************                              MD024362
      ***Search*Forecast*for*a*Settlememnt*Account*Debit******                              MD024362
      *  Step 2                                                                             MD024362
      *  Search Forecast for a Settlememnt Account                                          MD024362
      *
     C*****BDSADR        IFNE      *BLANKS                                                  MD024362
      *
 b1  C     NWRUP         Ifeq      *blanks                                                  MD024878
      *                                                                                     MD024878
     C*****BDOPTP        Ifne      *blanks                                                  MD024878
 b2  C     WFOPTP        Ifne      *blanks                                                  MD024878
      *
      ** Access Forecast Individual  - GLFORITD index is IFCUST, IFCSAC, IFCCY, IFNOSC, IFOPTY
      *                                IFACNO, IFDATE

      *  from GLFORITD (Individual Forecast)
     C/Exec SQL
     C+       Select * into: FORIT from GLFORITD
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******IFCSAC*=*:WFCSAC*and***************************                              MD024362
     C+ where IFRECI = 'D'     and                                                          MD024362
     C+       IFCUST = :WFSRCN and                                                          MD024362
     C+       IFCSAC = :WFCSAI and                                                          MD024362
     C+       IFCCY  = :WFCCY  and
     C+       IFNOSC = :WFNOSC and
     C+       IFOPTY = :WFOPTP and
     C+       IFACNO = :WFACNO and
     C+       IFDATE = :WFDATE
     C/End-EXEC
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process for Amend Individual Forecast
     C                   EXSR      PROCIF
     C                   EVAL      Forecast = 'Update'                                      MD025967
     C                   ELSE
     C                   Z-ADD     1             NFON                                       MD024878
e3   C                   END                                                                MD024878
x2   C                   ELSE                                                               MD024878
     C*****IFOPTY        IFEQ      *BLANK                                                   MD024878
      *  from GLFORITD (Individual Forecast)
     C/Exec SQL
     C+       Select * into: FORIT from GLFORITD
     C*+**where*IFCUST*=*:WFSRCN*and**************************                              MD024362
     C*+********IFCSAC*=*:WFCSAC*and**************************                              MD024362
     C+ where IFRECI = 'D'     and                                                          MD024362
     C+       IFCUST = :WFSRCN and                                                          MD024362
     C+       IFCSAC = :WFCSAI and                                                          MD024362
     C+       IFCCY  = :WFCCY  and
     C+       IFNOSC = :WFNOSC and
     C+       IFACNO = :WFACNO and
     C+       IFDATE = :WFDATE
     C/End-EXEC
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process for Amend Individual Forecast
     C                   EXSR      PROCIF
     C                   EVAL      Forecast = 'Update'                                      MD025967
     C                   ELSE
     C                   Z-ADD     1             NFON                                       MD024878
e3   C                   END                                                                MD024878
e2   C                   END                                                                MD024878
     C*****IFCSAC        IFEQ      *BLANK                                                   MD024878
b2   C     WFCSAI        IFEQ      *BLANK                                                   MD024878
      *  from GLFORITD (Individual Forecast)
     C/Exec SQL
     C+       Select * into: FORIT from GLFORITD
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C+ where IFRECI = 'D'     and                                                          MD024362
     C+       IFCUST = :WFSRCN and
     C*+***** IFCSAC = :WFCSAI and                                                MD024362B MD026339
     C+       IFOPTY = :WFOPTP and                                                          MD026339
     C+       IFCCY  = :WFCCY  and
     C+       IFNOSC = :WFNOSC and
     C+       IFACNO = :WFACNO and
     C+       IFDATE = :WFDATE
     C/End-EXEC
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process for Amend Individual Forecast
     C                   EXSR      PROCIF
     C                   EVAL      Forecast = 'Update'                                      MD025967
     C                   ELSE
     C                   Z-ADD     1             NFON
     C                   END
     C                   END
      *
     C                   END
     C**********         END                                                                MD024878
      *
     C**********         END                                                                MD024878
     C**********         END                                                                MD024878
     C**********         If        SQLCOD <> 0                                              MD024878
     C**********         Z-ADD     1             NFON                                       MD024878
     C**********         END                                                                MD024878
     C*******************END                                                                MD024362
      *
      ***Step 2B**********************************************                              MD024362
      ****Search*Forecast*for*a*Settlememnt*Account*Credit****                              MD024362
      **********                                                                            MD024362
     C*****BDSACR        IFNE      *BLANKS                                                  MD024362
      **********                                                                            MD024362
     C*****BDOPTP        Ifne      *blanks                                                  MD024362
      **********                                                                            MD024362
      ***Access*Forecast Individual**-*GLFORITD index is IFCUST, IFCSAC, IFCCY, IFNOSC, IFOPTY
      *********************************IFACNO, IFREFN, IFDATE                               MD024362
      **********                                                                            MD024362
      ***from GLFORITD (Individual Forecast)                                                MD024362
     C*/Exec*SQL**********************************************                              MD024362
     C*+*******Select***into:*FORIT*from*GLFORITD*************                              MD024362
     C*+where*IFCUST*=*:WFSRCN*and****************************                              MD024362
     C*+*******IFCSAC*=*:WFCSAC*and***************************                              MD024362
     C*+*******IFCCY**=*:WFCCY**and***************************                              MD024362
     C*+*******IFNOSC*=*:WFNOSC*and***************************                              MD024362
     C*+*******IFOPTY*=*:WFOPTP*and***************************                              MD024362
     C*+*******IFACNO*=*:WFACNO*and***************************                              MD024362
     C*+*******IFDATE*=*:WFDATE*******************************                              MD024362
     C*/End-EXEC**********************************************                              MD024362
     C*******************If        SQLCOD = 0                                               MD024362
      ***If*Found,*then*process*for*Amend*Individual*Forecast*                              MD024362
     C*******************EXSR      PROCIF                                                   MD024362
     C*******************ELSE                                                               MD024362
     C*****IFOPTY        IFEQ      *BLANK                                                   MD024362
      ***from*GLFORITD*(Individual*Forecast)*******************                             MD024362
     C*/Exec*SQL***********************************************                             MD024362
     C*+*******Select***into:*FORIT*from*GLFORITD**************                             MD024362
     C*+*where*IFCUST*=*:WFSRCN*and****************************                             MD024362
     C*+*******IFCSAC*=*:WFCSAC*and****************************                             MD024362
     C*+*******IFCCY**=*:WFCCY**and****************************                             MD024362
     C*+*******IFNOSC*=*:WFNOSC*and****************************                             MD024362
     C*+*******IFACNO*=*:WFACNO*and****************************                             MD024362
     C*+*******IFDATE*=*:WFDATE********************************                             MD024362
     C*/End-EXEC***********************************************                             MD024362
     C**********************If        SQLCOD = 0                                            MD024362
      ***If*Found,*then process*for*Amend*Individual*Forecast*                              MD024362
     C*******************EXSR      PROCIF                                                   MD024362
     C*******************ELSE                                                               MD024362
     C*****IFCSAC        IFEQ      *BLANK                                                   MD024362
      ***from*GLFORITD*(Individual*Forecast)******************                              MD024362
     C*/Exec*SQL**********************************************                              MD024362
     C*+*******Select***into:*FORIT*from*GLFORITD*************                              MD024362
     C*+*where*IFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******IFCCY**=*:WFCCY**and***************************                              MD024362
     C*+*******IFNOSC*=*:WFNOSC*and***************************                              MD024362
     C*+*******IFACNO*=*:WFACNO*and***************************                              MD024362
     C*+*******IFDATE*=*:WFDATE*******************************                              MD024362
     C*/End-EXEC**********************************************                              MD024362
     C**********************If        SQLCOD = 0                                            MD024362
      ***If*Found,*then*process*for*Amend*Individual*Forecast*                              MD024362
     C*******************EXSR      PROCIF                                                   MD024362
     C*******************ELSE                                                               MD024362
     C*******************Z-ADD     1             NFON                                       MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362
      ***********                                                                           MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362
      ***********                                                                           MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362
     C*******************If        SQLCOD <> 0                                              MD024362
     C*******************Z-ADD     1             NFON                                       MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362

      *================================================================
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    SRFORTT1 - Update Actual Amounts on Forecasts Totals       *
      *               with key Debit/credit Indicator, Settlement Ac- *
      *               count (credit or debit depending on DR/CR indi- *
      *               cator) , Source customer, customer source ac-   *
      *               count Id, Event date.                           *
      *****************************************************************
     C     SRFORTT1      BEGSR

      * Move Primary Keys to a temporary field
      * Ccy, Nostro code and Retail number are converted from Settlement account D or C in next part
                                                                                         MD024362A
     C*****BDSRCN        IFNE      *BLANK                                         MD024362A MD024878
     C     IFSRCN        IFNE      *BLANK                                                   MD024878
      *                                                                                  MD024362A
      ** If Non Equal *BLank it must be a correct customer number                        MD024362A
      ** else there is a DB error                                                        MD024362A
      *                                                                                  MD024362A
     C                   EXSR      SrRtvCust                                             MD024362A
     C**********         EVAL      WFSRCN = BDSRCN                                MD024362A MD024878
     C                   EVAL      WFSRCN = IFSRCN                                          MD024878
     C                   ELSE                                                            MD024362A
     C                   EVAL      WFSRCN = P_DummyCust                                  MD024362A
     C**********         EVAL      BDSRCN = P_DummyCust                           MD024362A MD024878
     C                   EVAL      IFSRCN = P_DummyCust                                     MD024878
     C                   ENDIF                                                           MD024362A

     C**********         Eval      WFSRCN = BDSRCN                                       MD024362A
     C**********         Eval      WFCSAI = BDCSAI                                          MD024878
     C**********         Eval      WFOPTP = BDOPTP                                          MD024878
     C**********         Eval      WFFCRF = BDFCRF                                          MD024878
     C**********         Eval      WFDATE = BDEVTD                                          MD024878
     C                   Eval      WFCSAI = IFCSAI                                          MD024878
     C                   Eval      WFOPTP = IFOPTP                                          MD024878
     C                   Eval      WFFCRF = IFFCRF                                          MD024878
     C                   Eval      WFDATE = IFEVTD                                          MD024878

      *  First ---> Settlement Account Debit to update directly on Totals Forecasts
      ***If*BDDCIP*is*'D'*use*BDSADR*and*convert*it*to*Nostro*Code                          MD024362
      ***(Settlement*Account*Debit)*else*use*BDSACR*and*convert*it*to*Nostro*Code           MD024362
      ***If*BDDCIP*is*'D'*use*BDSACR*and*convert*it*to*Settlement*Account***       MD024362 MD024878
      ***(Settlement*Account*Credit)*else*use*BDSADR*and*convert*it*to*Nostro*Code*MD024362 MD024878
      ***Else*DBDCIP*is*'C'*it*s*the*other*way.*****                               MD024362 MD024878
                                                                                            MD024878
      * Retrieve now Nostro code and Retail Number for the rest of the processing           MD024878
     C                   EXSR      RtvNosRet                                                MD024878

     C*****BDDCIP        Ifeq      'D'                                                      MD024878
      **********                                                                            MD024878
     C*******************Eval      P@FACN = BDSADR                                          MD024362
     C**********         Eval      P@FACN = BDSACR                                 MD024362 MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *blanks                                                  MD024878
      ****Find*Retail*number*of*the*Settlement*Account*************                         MD024878
      **********                                                                            MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
     C*********          ELSE                                                      MD024362 MD024878
     C*********          Z-ADD     0             ACNO                              MD024362 MD024878
     C*********          END                                                       MD024362 MD024878
      *********                                                                             MD024878
      ** - If Retail Account number is zero or not found                                    MD024878
      *********                                                                             MD024878
     C*****ACNO          IFNE      0                                                        MD024878
     C*********          MOVE      CCY           WFCCY                            MD024362A MD024878
     C*********          Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C*********          END                                                                MD024878
      *********                                                                             MD024878
     C*******************Eval      P@FACN = BDSACR                                          MD024362
     C**********         Eval      P@FACN = BDSADR                                 MD024362 MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account****                                    MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *BLANKS                                        MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C******WRKEY        CHAIN     SDNOSTL4                           10                    MD024878
      **********                                                                            MD024878
     C**** *IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Else                                                               MD024878
     C**********         Eval      P@FACN = BDSACR                                          MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account****                                    MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *BLANKS                                        MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      **********                                                                            MD024878
     C******IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Eval      P@FACN = BDSADR                                          MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *blanks                                         MD024362 MD024878
      ****Find*Retail*number*of*the*Settlement*Account**                                    MD024878
      **********                                                                            MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
     C**********         END                                                       MD024362 MD024878
      **********                                                                            MD024878
      ***-*If*Retail*Account*number*is*zero*or*not*found***                                 MD024878
      **********                                                                            MD024878
     C*****ACNO*         IFNE      0                                                        MD024878
     C**********         MOVE      CCY           WFCCY                            MD024362A MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
      ***Step*3A**********************************************                              MD024362
      ***Search*Forecast*for*a*Settlememnt*Account*Debit******                              MD024362
      *  Step 3                                                                             MD024362
      *  Search Forecast for a Settlememnt Account                                          MD024362
      *
     C*****BDSADR        IFNE      *BLANKS                                                  MD024362

b1   C     NWRUP         Ifeq      *blanks                                                  MD024878
      **
b2   C     WFCSAI        IFNE      *BLANK                                                   MD024878
                                                                                            MD024878
      ** Access Forecast Totals - GLFORTTD index is TFCUST, TFCSAC, TFCCY, TFNOSC, TFACNO and TFDATE
      **

     C/Exec SQL
     C+       Select * into: FORTT from GLFORTTD
     C*+*where*TFCUST*=*:WFSRCN*and***************************                             MD024362
     C+ where TFRECI = 'D'     and                                                          MD024362
     C+       TFCUST = :WFSRCN and                                                          MD024362
     C+       TFCSAC = :WFCSAI and
     C+       TFCCY  = :WFCCY  and
     C+       TFNOSC = :WFNOSC and
     C+       TFACNO = :WFACNO and
     C+       TFDATE = :WFDATE
     C/End-EXEC
      *
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process to Update Total Forecasts Directly
     C                   EXSR      PROCUP
     C                   EVAL      Forecast = 'Update Total'                                MD025967
     C                   ELSE
     C                   Z-ADD     1             NFON                                       MD024878
     C                   END                                                                MD024878
     C                   ELSE                                                               MD024878
     C*****TFCSAC        IFEQ      *BLANK                                                   MD024878
      *  from GLFORTTD (Total Forecast)
     C/Exec SQL
     C+       Select * into: FORTT from GLFORTTD
     C*+*where*TFCUST*=*:WFSRCN*and***************************                              MD024362
     C+ where TFRECI = 'D'     and                                                          MD024362
     C+       TFCUST = :WFSRCN and                                                          MD024362
     C*+****** TFCSAC = :WFCSAI and                                               MD024362B MD026339
     C+       TFCCY  = :WFCCY  and
     C+       TFNOSC = :WFNOSC and
     C+       TFACNO = :WFACNO and
     C+       TFDATE = :WFDATE
     C/End-EXEC
     C                   If        SQLCOD = 0
     C                             or SQLCOD = -000000811                                   MD026339
      ** If Found, then process to Update Total Forecasts Directly
     C*******************EXSR      PROCUP                                                   MD024362
     C                   EVAL      WFCSAI = TFCSAC                                          MD026339
     C                   EXSR      PROCUP2                                                  MD024362
     C                   EVAL      Forecast = 'Update Total'                                MD025967
     C                   EVAL      WFCSAI = *BLANKS                                         MD026339
     C                   ELSE
     C                   Z-ADD     1             NFON
     C                   END
      *
     C                   END
     C                   END                                                                MD024878
     C**********         END                                                                MD024878
     C*******************Else                                                               MD024362
     C*******************Z-ADD     1             NFON                                       MD024362
     C*******************END                                                                MD024362

      ***Step*3B**********************************************                              MD024362
      ****Search*Forecast*for*a*Settlememnt*Account*Credit****                              MD024362
      **********                                                                            MD024362
     C*****BDSACR        IFNE      *BLANKS                                                  MD024362
      **********                                                                            MD024362
      ***Access*Forecast*Totals*-*GLFORTTD*index*is*TFCUST,*TFCSAC,*TFCCY,*TFNOSC,*TFACNO*and*TFDATE
      **********                                                                            MD024362
      **********                                                                            MD024362
     C*/Exec*SQL**********************************************                              MD024362
     C*+*******Select***into:*FORTT*from*GLFORTTD*************                              MD024362
     C*+*where*TFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******TFCSAC*=*:WFCSAI*and***************************                              MD024362
     C*+*******TFCCY**=*:WFCCY**and***************************                              MD024362
     C*+*******TFNOSC*=*:WFNOSC*and***************************                              MD024362
     C*+*******TFACNO*=*:WFACNO*and***************************                              MD024362
     C*+*******TFDATE*=*:WFDATE*******************************                              MD024362
     C*/End-EXEC**********************************************                              MD024362
      **********                                                                            MD024362
     C**********************If        SQLCOD = 0                                            MD024362
      ****If*Found,*then*process*to*Update*Total*Forecasts*Directly                         MD024362
     C**********************EXSR      PROCUP                                                MD024362
     C**********************ELSE                                                            MD024362
     C********TFCSAC        IFEQ      *BLANK                                                MD024362
      ****from*GLFORTTD*(Total*Forecast)**********************                              MD024362
     C*/Exec*SQL**********************************************                              MD024362
     C*+*******Select***into:*FORTT*from*GLFORTTD*************                              MD024362
     C*+*where*TFCUST*=*:WFSRCN*and***************************                              MD024362
     C*+*******TFCCY**=*:WFCCY**and***************************                              MD024362
     C*+*******TFNOSC*=*:WFNOSC*and***************************                              MD024362
     C*+*******TFACNO*=*:WFACNO and***************************                              MD024362
     C*+*******TFDATE*=*:WFDATE*******************************                              MD024362
     C*/End-EXEC**********************************************                              MD024362
     C*******************If        SQLCOD = 0                                               MD024362
      ***If*Found,*then*process*to*update*Total*Forecasts*Directly                          MD024362
     C*******************EXSR      PROCUP                                                   MD024362
     C*******************ELSE                                                               MD024362
     C*******************Z-ADD     1             NFON                                       MD024362
     C*******************END                                                                MD024362
      *******************                                                                   MD024362
     C*******************END                                                                MD024362
     C*******************END                                                                MD024362
     C*******************Else                                                               MD024362
     C*******************Z-ADD     1             NFON                                       MD024362
     C*******************END                                                                MD024362
                                                                                            MD024362
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *    FORADD -   Add records with Actual Amount on Forecasts     *
      *               with key Debit/credit Indicator, Settlement Ac- *
      *               count (credit or debit depending on DR/CR indi- *
      *               cator) , Source customer, customer source ac-   *
      *               count Id, operation.                            *
      *****************************************************************
     C     FORADD        BEGSR

      * Move Primary Keys to a temporary field
      * Ccy, Nostro code and Retail number are converted from Settlement account D or C in next part

     C*****BDSRCN        IFNE      *BLANK                                                   MD024878
     C     IFSRCN        IFNE      *BLANK                                                   MD024878
      *                                                                                  MD024362A
      ** If Non Equal *BLank it must be a correct customer number                        MD024362A
      ** else there is a DB error                                                        MD024362A
      *                                                                                  MD024362A
     C                   EXSR      SrRtvCust                                             MD024362A
     C*************      Eval      WFSRCN = BDSRCN                                          MD024878
     C                   Eval      WFSRCN = IFSRCN                                          MD024878
     C                   Else
     C                   Eval      WFSRCN = P_DummyCust
     C**********         Eval      BDSRCN = P_DummyCust                                     MD024878
     C                   Eval      IFSRCN = P_DummyCust                                     MD024878
     C                   End
     C
     C**********         Eval      WFCSAI = BDCSAI                                          MD024878
     C**********         Eval      WFOPTP = BDOPTP                                          MD024878
     C**********         Eval      WFFCRF = BDFCRF                                          MD024878
     C**********         Eval      WFDATE = BDEVTD                                          MD024878
     C                   Eval      WFCSAI = IFCSAI                                          MD024878
     C                   Eval      WFOPTP = IFOPTP                                          MD024878
     C                   Eval      WFFCRF = IFFCRF                                          MD024878
     C                   Eval      WFDATE = IFEVTD                                          MD024878

     C                   EXSR      CURREN

      *  First ---> Settlement Account Debit to create or update an individual forecast via JMS
      ***If BDDCIP*is*'D**use*BDSADR*and*convert*it*to*Nostro*Code**                        MD024362
      ***(Settlement*Account*Debit)*else*use*BDSACR*and*convert*it*to*Nostro*Code**         MD024362
      ***If BDDCIP*is*'D'*use*BDSACR*and*convert*it*to*Settlement*Account***       MD024362 MD024878
      ***(Settlement*Account*Credit)*else*use*BDSADR*and*convert*it*to*Nostro*Code*MD024362 MD024878
      ***Else*DBDCIP*is*'C'*it's*the*other*way.******                              MD024362 MD024878

      ** Retrieve now Nostro code and Retail Number for the rest of the processing          MD024878
                                                                                            MD024878
     C                   EXSR      RtvNosRet                                                MD024878
                                                                                            MD024878
     C*****BDDCIP        Ifeq      'D'                                                      MD024878
      **********                                                                            MD024878
     C*******************Eval      P@FACN = BDSADR                                          MD024362
     C**********         Eval      P@FACN = BDSACR                                 MD024362 MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *blanks                                         MD024362 MD024878
      ****Find*Retail*number*of*the*Settlement*Account*****                                 MD024878
      **********                                                                            MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C*****DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
     C**********         END                                                       MD024362 MD024878
      **********                                                                            MD024878
      ***-*If*Retail*Account*number*is*zero*or*not*found*****                               MD024878
      **********                                                                            MD024878
     C*****ACNO*         IFNE      0                                                        MD024878
     C**********         MOVE      CCY           WFCCY                            MD024362A MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
     C*******************Eval      P@FACN = BDSACR                                          MD024362
     C**********         Eval      P@FACN = BDSADR                                 MD024362 MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account***                                     MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *BLANKS                                        MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      **********                                                                            MD024878
     C**** *IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Else                                                               MD024878
     C**********         Eval      P@FACN = BDSACR                                          MD024878
      **********                                                                            MD024878
      ****Find*Nostro*Code*of*the*Settlement*Account********                                MD024878
      **********                                                                            MD024878
     C*****BDSACR        IFNE      *BLANKS                                        MD024362A MD024878
     C**********         MOVE      DDCNUM        A7CUST                                     MD024878
     C**********         MOVE      DDCUCD        A7CYCD                                     MD024878
     C**********         MOVE      DDACOD        A7ACCD                                     MD024878
     C**********         MOVE      DDACSQ        A7ACSN                                     MD024878
     C**********         MOVE      DDBRCA        A7BRCD                                     MD024878
      **********                                                                            MD024878
     C*****WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      ***********                                                                           MD024878
     C******IN10         IFEQ      '0'                                                      MD024878
     C**********         MOVE      A7CYCD        WFCCY                                      MD024878
     C**********         MOVE      A7NONB        WFNOSC                                     MD024878
     C**********         END                                                                MD024878
     C**********         ENDIF                                                    MD024362A MD024878
      **********                                                                            MD024878
     C**********         Eval      P@FACN = BDSADR                                          MD024878
      **********                                                                            MD024878
     C*****BDSADR        IFNE      *blanks                                         MD024362 MD024878
      ****Find*Retail*number*of*the*Settlement*Account**                                    MD024878
      **********                                                                            MD024878
     C**********         CALL      'AOACCTR0'                                               MD024878
     C**********         PARM      *Blanks       PRtcd                                      MD024878
     C**********         PARM      '*KEY'        POptn                                      MD024878
     C**********         PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C**********         PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C**********         PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C**********         PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C**********         PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C**********         PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C*****DsACCN        PARM      *Blanks       DSSDY                                      MD024362
     C**** DsACCN        PARM      DsACCN        DSSDY                             MD024362 MD024878
     C**********         ELSE                                                      MD024362 MD024878
     C**********         Z-ADD     0             ACNO                              MD024362 MD024878
 e2  C**********         END                                                      MD024362  MD024878
      **********                                                                            MD024878
      *****If*Retail*Account*number*is*zero*or*not*found***                                 MD024878
      **********                                                                            MD024878
     C*****ACNO*         IFNE      0                                                        MD024878
     C**********         MOVE      CCY           WFCCY                            MD024362A MD024878
     C**********         Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C**********         END                                                                MD024878
      **********                                                                            MD024878
     C**********         END                                                                MD024878
      *                                                                                     MD024878
     C     NWRUP         Ifeq      *blanks                                                  MD024878
      *
      ****Search*Forecast*for*a*Settlememnt*Account*Debit                                   MD024362
      *   Search Forecast for a Settlememnt Account                                         MD024362
      *
     C*****BDSADR        IFNE      *BLANKS                                                  MD024362
      *
     C**********         IF        BDEVTA <> *BLANKS                                        MD024878
     C                   IF        IFEVTA <> *BLANKS                                        MD024878
     C                   EVAL      ZFIELD = %SUBST(BDEVTA:1:15)
     C*******************EVAL      ZADEC  = A6NBDP                                          MD024362
     C*******************EVAL      ZADIG  = 15 - A6NBDP                                     MD024362
     C                   EVAL      ZADEC  = 0                                               MD024362
     C                   EVAL      ZADIG  = 15 - ZADEC                                      MD024362
     C                   EXSR      SRAlign
     C                   MOVE      ZAFLD         P_ActualAmnt
     C*****BDDCIP        IFEQ      'C'                                             MD024362 MD024878
     C     IFDCIP        IFEQ      'C'                                                      MD024878
     C**********         EVAL      WFACTL = WFACTL * -1                            MD024362 MD024926
     C                   EVAL      P_ActualAmnt = P_ActualAmnt * -1                         MD024926
     C                   ENDIF                                                              MD024362
     C                   ENDIF
      *
     C                   EVAL      P_Action = 'I'

      *                                                                                     MD025310
     C                   MOVE      *BLANKS       TEMPCCY                                    MD025310
      *                                                                                     MD025310
     C                   IF        IFCCY <> *BLANKS                                         MD025310
     C                   EVAL      TEMPCCY = IFCCY                                          MD025310
     C                   ELSE                                                               MD025310
     C                   EVAL      TEMPCCY = WFCCY                                          MD025310
     C                   ENDIF                                                              MD025310
      *                                                                                     MD025310
     C                   CALL      'GL000703'                           99
     C                   PARM      *Blanks       P_RtrnCode                     Return Code
     C                   PARM      *Blanks       P_Option                       Option
     C                   PARM                    P_Action                       Action Code
     C**********         PARM      BDSRCN        P_Customer                     Customer    MD024878
     C**********         PARM      BDCSAI        P_CustSourAc                   Customer SouMD024878
     C**********         PARM      BDOPTP        P_Operatype                    Operation TyMD024878
     C**********         PARM      BDEVTD        P_Date                         Event Date  MD024878
     C                   PARM      IFSRCN        P_Customer                     Customer    MD024878
     C                   PARM      IFCSAI        P_CustSourAc                   Customer SouMD024878
     C                   PARM      IFOPTP        P_Operatype                    Operation TyMD024878
     C                   PARM      IFEVTD        P_Date                         Event Date  MD024878
     C                   PARM                    P_FullGLAcc                    Full GL account
     C**********         PARM      WFCCY         P_Currency                     Currency    MD025310
     C                   PARM      TEMPCCY       P_Currency                     Currency    MD025310
     C                   PARM      WFNOSC        P_NostroCode                   Nostro Code
     C                   PARM      WFACNO        P_RetlAcNo                     Retail Account Nb
     C                   PARM      *zeros        P_Amount                       Forecast Amount
     C                   PARM                    P_ActualAmnt                   Forecast Actual Amnt
     C**********         PARM      BDFCRF        P_Reference                    Forecast RefMD024878
     C**********         PARM      BDNARR        P_Narrative                    Forecast NarMD024878
     C**********         PARM      BDFOTR        P_FrontOffId                   Forecast FroMD024878
     C**********         PARM      BDZONE        P_Zone                         Forecast ZonMD024878
     C                   PARM      IFFCRF        P_Reference                    Forecast RefMD024878
     C                   PARM      IFNARR        P_Narrative                    Forecast NarMD024878
     C                   PARM      IFFRNT        P_FrontOffId                   Forecast FroMD024878
     C                   PARM      BDZONE        P_Zone                         Forecast ZonMD024878
     C                   PARM                    P_ActualIsZero                 Forec.Actual is Zero
      *
     C     PRtcd         IFEQ      *BLANK                                                  MD024362A
     C                   MOVE      'Y'           WFFRST                         Forecast Status
     C                   EVAL      WForecastFlag = 'Y'                                      MD024878
     C                   EVAL      Forecast = 'New'                                         MD025967
     C                   END                                                               MD024362A
      *
     C***                END                                                                MD024362
      *
     C/EXEC SQL                                                                             MD024362
     C***+ UPDATE GLACBDTD SET BDFRST = :WFFRST                                    MD024362 MD024878
     C***+ WHERE BDFRST <>  'Y'                                                    MD024362 MD024878
     C+ UPDATE DIACIFTD SET IFFSTA = :WFFRST                                                MD024878
     C+ WHERE IFFSTA <>  'Y'                                                                MD024878
     C+ AND IFCSAI = :WFCSAI AND IFBTID = :PBTID                                            MD026339
     C+ AND IFCCY = :WFCCY AND IFEVTD = :WFDATE                                             MD026339
     C+ AND IFOPTP = :WFOPTP AND IFCUSA = :WFCUSA                                           MD026339
     C+ AND IFFCRF = :WFFCRF AND IFSADR = :WFSADR                                           MD026339
     C+ AND IFSACR = :WFSACR AND IFSRCN = :XFSRCN                                           MD026339
     C/END-EXEC                                                                             MD024362
     C                   END                                                                MD024878
      *
      ****Search*Forecast*for*a*Settlememnt*Account*Credit****                              MD024362
      **********                                                                            MD024362
     C*****BDSACR        IFNE      *BLANKS                                                  MD024362
      **********                                                                            MD024362
     C*******************IF        BDEVTA <> *BLANKS                                        MD024362
     C*******************EVAL      ZFIELD = %SUBST(BDEVTA:1:15)                             MD024362
     C*******************EVAL      ZADEC  = A6NBDP                                          MD024362
     C*******************EVAL      ZADIG  = 15 - A6NBDP                                     MD024362
     C*******************EXSR      SRAlign                                                  MD024362
     C*******************MOVE      ZAFLD         P_ActualAmnt                               MD024362
     C*******************EVAL      P_ActualAmnt =  P_ActualAmnt * -1                        MD024362
     C*******************ENDIF                                                              MD024362
      **********                                                                            MD024362
     C*******************EVAL      P_Action = 'I'                                           MD024362
      **********                                                                            MD024362
     C*******************CALL      'GL000703'                           99                  MD024362
     C*******************PARM      *Blanks       P_RtrnCode            Return Code          MD024362
     C*******************PARM      *Blanks       P_Option              Option               MD024362
     C*******************PARM                    P_Action              Action Code          MD024362
     C*******************PARM      BDSRCN        P_Customer            Customer Number      MD024362
     C*******************PARM      BDCSAI        P_CustSourAc          Customer Source AC/  MD024362
     C*******************PARM      BDOPTP        P_Operatype           Operation Type       MD024362
     C*******************PARM      BDEVTD        P_Date                Event Date           MD024362
     C*******************PARM                    P_FullGLAcc           Full GL account      MD024362
     C*******************PARM      WFCCY         P_Currency            Currency             MD024362
     C*******************PARM      WFNOSC        P_NostroCode          Nostro Code          MD024362
     C*******************PARM      WFACNO        P_RetlAcNo            Retail Account Nb    MD024362
     C*******************PARM      *zeros        P_Amount               Forecast Amount     MD024362
     C*******************PARM                    P_ActualAmnt           Forecast Actual AmntMD024362
     C*******************PARM      BDFCRF        P_Reference            Forecast Reference  MD024362
     C*******************PARM      BDNARR        P_Narrative            Forecast Narrative  MD024362
     C*******************PARM      BDFOTR        P_FrontOffId           Forecast Front OffIdMD024362
     C*******************PARM      BDZONE        P_Zone                 Forecast Zone       MD024362
     C*******************PARM                    P_ActualIsZero         Forec.Actual is ZeroMD024362
      **********                                                                            MD024362
     C*******************MOVE      'Y'           WFFRST            1      Forecast Status   MD024362
      **********                                                                            MD024362
     C*******************END                                                                MD024362

     C                   ENDSR
      *****************************************************************                    MD024362A
      /EJECT                                                                               MD024362A
      *****************************************************************                    MD024362A
      *                                                               *                    MD024362A
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                    MD024362A
      *                                                               *                    MD024362A
      *****************************************************************                    MD024362A
     C     SrRtvCust     BEGSR                                                             MD024362A
                                                                                           MD024362A
      ** Call AOCUSTR0 to get Customer Details                                             MD024362A
                                                                                           MD024362A
     C                   CALL      'AOCUSTR0'                                              MD024362A
     C                   PARM      *BLANKS       PRtcd                                     MD024362A
     C                   PARM      '*KEY   '     POptn                                     MD024362A
     C**********         PARM      BDSRCN        @KEY10           10             MD024362A MD024878A
     C                   PARM      IFSRCN        @KEY10           10                       MD024878A
     C                   PARM      *BLANKS       @KEY7             7                       MD024362A
     C     SDCUST        PARM      SDCUST        DSSDY                                     MD024362A
                                                                                           MD024362A
      ** Database Error                                                                    MD024362A
                                                                                           MD024362A
     C     PRtcd         IFNE      *BLANKS                                                 MD024362A
     C                   MOVEL     'SDCUSTPD'    DBFILE                                    MD024362A
     C                   Z-ADD     1             DBASE                                     MD024362A
     C                   MOVEL     POptn         DBKEY                                     MD024362A
     C                   EXSR      *PSSR                                                   MD024362A
     C                   END                                                               MD024362A
                                                                                           MD024362A
     C                   ENDSR                                                             MD024362A
      *****************************************************************                    MD024362A
      /EJECT                                                                               MD024362A
      *****************************************************************                     MD024878
      *                                                               *                     MD024878
      *  SrRtvCMVF - Subroutine to Retrieve Batch interface details   *                     MD024878
      *                                                               *                     MD024878
      *****************************************************************                     MD024878
     C     SrRtvCMVF     BEGSR                                                              MD024878
      *                                                                                     MD024878
      ***Access*Batch*Interface*file*-*GLACBDTD*index*is*BDBTID,*BDEVTA,*BDCCY,*BD MD024878 MD029739
      ** Access Batch Interface file - DIACBDTD index is BDBTID, BDEVTA, BDCCY, BDSTM1,     MD029739
      *                                BDSMT2, BDSMT3, etc, etc ..                          MD024878
      *                                                                                     MD024878
      ** First need to align IFEVTA to compare with BDEVTA                                  MD024878
      *                                                                                     MD024878
     C                   IF        IFEVTA <> *BLANKS                                        MD024878
     C                   EVAL      ZFIELD = %SUBST(IFEVTA:1:15)                             MD024878
     C                   EVAL      ZADEC  = 0                                               MD024878
     C                   EVAL      ZADIG  = 15 - ZADEC                                      MD024878
     C                   EXSR      SRAlign                                                  MD024878
     C                   END                                                                MD024878
      *                                                                                     MD024878
      ** then suppress leading zeroes                                                       MD024878
      *                                                                                     MD024878
     C                   CALL      'ZEDIT'                                                  MD024878
     C                   PARM      ZAFLD         ZFIELD           16                        MD024878
     C                   PARM      ZADEC         ZADEC             1 0                      MD024878
     C                   MOVE      ZFIELD        IFEVTA                                     MD024878
      *                                                                                     MD024878
     C                   Eval      WFBTID = IFBTID                                          MD024878
     C                   Eval      WFEVTA = IFEVTA                                          MD024878
     C                   Eval      WCCY   = IFCCY                                           MD024878
     C                   EVAL      WFSADR = IFSADR                                          MD024878
     C                   EVAL      WFSACR = IFSACR                                          MD024878
     C                   Eval      WFSMT1 = IFSMTF1                                         MD024878
     C                   Eval      WFSMT2 = IFSMTF2                                         MD024878
     C                   Eval      WFSMT3 = IFSMTF3                                         MD024878
     C                   Eval      WFSMT4 = IFSMTF4                                         MD024878
     C                   Eval      WFSMT5 = IFSMTF5                                         MD024878
     C                   Eval      WFSMT6 = IFSMTF6                                         MD024878
     C                   Eval      WFSMT7 = IFSMTF7                                         MD024878
     C                   Eval      WFSMT8 = IFSMTF8                                         MD024878
     C                   Eval      WFSMT9 = IFSMTF9                                         MD024878
     C                   Eval      WFSMT10 = IFSMTF10                                       MD024878
                                                                                            MD024878
     C/Exec SQL                                                                             MD024878
     C*+SELECT** INTO :ACBDTD FROM GLACBDTD                                        MD024878 MD029739
     C+ SELECT * INTO :ACBDTD FROM DIACBDTD                                                 MD029739
     C+ where BDBTID = :WFBTID and                                                          MD024878
     C+       BDEVTA = :WFEVTA and                                                          MD024878
     C+       BDCCY  = :WCCY   and                                                          MD024878
     C+       BDSADR = :WFSADR and                                                          MD024878
     C+       BDSACR = :WFSACR and                                                          MD024878
     C+       BDSMT1 = :WFSMT1 and                                                          MD024878
     C+       BDSMT2 = :WFSMT2 and                                                          MD024878
     C+       BDSMT3 = :WFSMT3 and                                                          MD024878
     C+       BDSMT4 = :WFSMT4 and                                                          MD024878
     C+       BDSMT5 = :WFSMT5 and                                                          MD024878
     C+       BDSMT6 = :WFSMT6 and                                                          MD024878
     C+       BDSMT7 = :WFSMT7 and                                                          MD024878
     C+       BDSMT8 = :WFSMT8 and                                                          MD024878
     C+       BDSMT9 = :WFSMT9 and                                                          MD024878
     C+       BDSMT10 = :WFSMT10                                                            MD024878
     C/End-EXEC                                                                             MD024878
      *                                                                                     MD024878
     C                   If        SQLCOD = 0                                               MD024878
     C                             or SQLCOD = -000000811                                   MD026339
     C     BDCMVF        IFEQ      'Y'                                                      MD024878
     C                   MOVE      'Y'           COCMVF            1                        MD024878
     C                   END                                                                MD024878
     C                   END                                                                MD024878
     C                                                                                      MD024878
      * Note if record found                                                                MD030256
     C                   Clear                   W#AcFd            1                        MD030256
     C                   Select                                                             MD030256
     C                   When      SQLCOD = 100                                             MD030256
     C                   Eval      W#AcFd = 'N'                                             MD030256
     C                   When      SQLCOD = 0                                               MD030256
     C                   Eval      W#AcFd = 'Y'                                             MD030256
     C                   Other                                                              MD030256
     C                   Eval      W#AcFd = 'E'                                             MD030256
     C                   Endsl                                                              MD030256
     C                   ENDSR                                                              MD024878
      *****************************************************************                     MD024878
      /EJECT                                                                                MD024878
      *****************************************************************                     MD024878
      *                                                               *                     MD024878
      *  RtvNosRet - Subroutine to Retrieve Nostro Account Code/Ccy   *                     MD024878
      *              and / or Retail Account Number                   *                     MD024878
      *                                                               *                     MD024878
      *****************************************************************                     MD024878
     C     RtvNosRet     BEGSR                                                              MD024878
                                                                                            MD024878
      **N.B. to get the Nostro Code for forecast search, take the Settlement Account Debit  MD024878
      ** or Settlement Account Credit, check if either is a nostro and, if so, convert      MD024878
      ** to Nostro Code.                                                                    MD024878
                                                                                            MD024878
      **N.B. to get the Retail Account for forecast search, take the Customer Account field,MD024878
      ** if not blank, else take either the Settlement Account Debit, or Settlement Account MD024878
      ** Credit, check if it is both a retail account and not a nostro.  This will be a     MD024878
      ** GL account id.                                                                     MD024878
                                                                                            MD024878
      **If there is no nostro, and Customer Account field is not blank, if either           MD024878
      ** the Settlement Account Debit or Settlement Account Credit contain the same         MD024878
      ** account as in the Customer Account field, then there will be no attempt            MD024878
      ** to write/update a forecast.                                                        MD024878
                                                                                            MD024878
     C* Get nostro code - take Settlement Account Debit and try to convert to Nostro Code   MD024878
     C* and if not take Settlement Account Credit and try to convert to Nostro code         MD024878
      *                                                                                     MD024878
      **  Find Nostro Code from Settlement Account Debit                                    MD024878
      *                                                                                     MD024878
     C     IFSADR        IFNE      *BLANKS                                                  MD024878
                                                                                            MD024878
     C                   Eval      P@FACN = IFSADR                                          MD024878
      *                                                                                     MD024878
     C                   MOVE      DDCNUM        A7CUST                                     MD024878
     C                   MOVE      DDCUCD        A7CYCD                                     MD024878
     C                   MOVE      DDACOD        A7ACCD                                     MD024878
     C                   MOVE      DDACSQ        A7ACSN                                     MD024878
     C                   MOVE      DDBRCA        A7BRCD                                     MD024878
      *                                                                                     MD024878
     C     WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      *                                                                                     MD024878
     C     *IN10         IFEQ      '0'                                                      MD024878
     C                   MOVE      A7CYCD        WFCCY                                      MD024878
     C                   MOVE      A7NONB        WFNOSC                                     MD024878
     C                   END                                                                MD024878
e1   C                   ENDIF                                                              MD024878
      *                                                                                     MD024878
      **  Find Nostro Code from Settlement Account Credit                                   MD024878
      *                                                                                     MD024878
     C     IFSACR        IFNE      *BLANKS                                                  MD024878
                                                                                            MD024878
     C                   Eval      P@FACN = IFSACR                                          MD024878
      *                                                                                     MD024878
     C                   MOVE      DDCNUM        A7CUST                                     MD024878
     C                   MOVE      DDCUCD        A7CYCD                                     MD024878
     C                   MOVE      DDACOD        A7ACCD                                     MD024878
     C                   MOVE      DDACSQ        A7ACSN                                     MD024878
     C                   MOVE      DDBRCA        A7BRCD                                     MD024878
      *                                                                                     MD024878
     C     WRKKEY        CHAIN     SDNOSTL4                           10                    MD024878
      *                                                                                     MD024878
     C     *IN10         IFEQ      '0'                                                      MD024878
     C                   MOVE      A7CYCD        WFCCY                                      MD024878
     C                   MOVE      A7NONB        WFNOSC                                     MD024878
     C                   END                                                                MD024878
e1   C                   ENDIF                                                              MD024878
      *                                                                                     MD024878
      ** This field will be used incase Source Customer is blank                           MD024878B
     C                   MOVE      *BLANKS       WRCNUM            6                       MD024878B
      **                                                                                   MD024878B
      **  Find Now Retail number of the Settlement Account                                  MD024878
      *   First check Customer Account                                                      MD024878
      *                                                                                     MD024878
 b1  C     IFCUSA        IFNE      *BLANK                                                   MD024878
      *                                                                                     MD024878
     C                   Eval      P@FACN = IFCUSA                                          MD024878
      *                                                                                     MD024878
     C                   CALL      'AOACCTR0'                                               MD024878
     C                   PARM      *BLANKS       PRtcd                                      MD024878
     C                   PARM      '*KEY   '     POptn                                      MD024878
     C                   PARM      IFCUSA        P@RETL                                     MD024878
     C**********         PARM                    P@CNUM                            MD024878 MD026339
     C**********         PARM                    P@CUCD                            MD024878 MD026339
     C**********         PARM                    P@ACCD                            MD024878 MD026339
     C**********         PARM                    P@ACSQ                            MD024878 MD026339
     C**********         PARM                    P@BRCA                            MD024878 MD026339
     C                   PARM      *Blanks       P@CNUM                                     MD026339
     C                   PARM      *Blanks       P@CUCD                                     MD026339
     C                   PARM      *Zeros        P@ACCD                                     MD026339
     C                   PARM      *Zeros        P@ACSQ                                     MD026339
     C                   PARM      *Blanks       P@BRCA                                     MD026339
     C     DsACCN        PARM      DsACCN        DSSDY                                      MD024878
      *                                                                                     MD024878
      ** - If Retail Account number is not zero                                             MD024878
      *                                                                                     MD024878
     C*****ACNO*         IFNE      0                                              MD024878 MD024878A
     C**********         Z-ADD     ACNO          WFACNO                         ReMD024878 MD024878A
     C**********         END                                                      MD024878 MD024878A
      *                                                                                     MD024878
     C     PRtcd         IFEQ      *Blanks                                                  MD024878
                                                                                            MD024878
     C                   MOVE      BRCA          DDBRCA                                     MD024878
     C                   MOVE      CNUM          DDCNUM                                     MD024878
     C                   MOVE      CCY           DDCUCD                                     MD024878
     C                   MOVE      CCY           WFCCY                                      MD024878
     C                   Z-ADD     ACOD          DDACOD                                     MD024878
     C                   Z-ADD     ACSQ          DDACSQ                                     MD024878
     C                   MOVE      P@FACN        P_FullGLacc                                MD024878
                                                                                           MD024878A
     C     ACNO          IFNE      0                                                       MD024878A
     C                   Z-ADD     ACNO          WFACNO                                    MD024878A
      ** Get the Customer Number                                                           MD024878B
     C                   EVAL      WRCNUM = DDCNUM                                         MD024878B
     C                   END                                                               MD024878A
                                                                                            MD024878
     C                   GOTO      ENDRET                                                   MD024878
     C                   ELSE                                                               MD024878
     C                   CALL      'AOACCTR0'                                               MD024878
     C                   PARM      *Blanks       PRtcd                                      MD024878
     C                   PARM      '*KEY'        POptn                                      MD024878
     C                   PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C                   PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C                   PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C                   PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C                   PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C                   PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C     DsACCN        PARM      DsACCN        DSSDY                                      MD024878
      *                                                                                     MD024878
      ** - If Retail Account number is not zero                                             MD024878
      *                                                                                     MD024878
 b3  C*****ACNO*         IFNE      0                                              MD024878 MD024878A
     C**********         Z-ADD     ACNO          WFACNO                         ReMD024878 MD024878A
 e3  C**********         END                                                      MD024878 MD024878A
      *                                                                                     MD024878
 b3  C     PRtcd         IFEQ      *Blanks                                                  MD024878
     C                   MOVE      CCY           WFCCY                                      MD024878
 b3  C     ACNO          IFNE      0                                                       MD024878A
     C                   Z-ADD     ACNO          WFACNO                                    MD024878A
      ** Get the Customer Number                                                           MD024878B
     C                   EVAL      WRCNUM = DDCNUM                                         MD024878B
     C                   MOVE      P@FACN        P_FullGLacc                                MD025967
 e3  C                   END                                                               MD024878A
     C                   GOTO      ENDRET                                                   MD024878
 e3  C                   END                                                                MD024878
 e2  C                   END                                                                MD024878
      *                                                                                     MD024878
 x1  C                   else                                                               MD024878
                                                                                            MD024878
 b2  C     IFSADR        IFNE      *blanks                                                  MD024878
     C                   Eval      P@FACN = IFSADR                                          MD024878
                                                                                            MD024878
     C                   CALL      'AOACCTR0'                                               MD024878
     C                   PARM      *Blanks       PRtcd                                      MD024878
     C                   PARM      '*KEY'        POptn                                      MD024878
     C                   PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C                   PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C                   PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C                   PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C                   PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C                   PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C     DsACCN        PARM      DsACCN        DSSDY                                      MD024878
      *                                                                                     MD024878
      ** - If Retail Account number is not zero                                             MD024878
      *                                                                                     MD024878
 b3  C     ACNO          IFNE      0                                                        MD024878
     C                   Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C                   MOVE      P@FACN        P_FullGLacc                                MD024878
      ** Get the Customer Number                                                           MD024878B
     C                   EVAL      WRCNUM = DDCNUM                                         MD024878B
 e3  C                   END                                                                MD024878
      *                                                                                     MD024878
 b3  C     PRtcd         IFEQ      *Blanks                                                  MD024878
     C                   MOVE      CCY           WFCCY                                      MD024878
     C                   GOTO      ENDRET                                                   MD024878
 e3  C                   END                                                                MD024878
 e2  C                   END                                                                MD024878
      *                                                                                     MD024878
 b2  C     IFSACR        IFNE      *blanks                                                  MD024878
     C                   Eval      P@FACN = IFSACR                                          MD024878
                                                                                            MD024878
     C                   CALL      'AOACCTR0'                                               MD024878
     C                   PARM      *Blanks       PRtcd                                      MD024878
     C                   PARM      '*KEY'        POptn                                      MD024878
     C                   PARM      *Blanks       P@RETL                         Retail AccouMD024878
     C                   PARM      DDCNUM        P@CNUM                         Customer    MD024878
     C                   PARM      DDCUCD        P@CUCD                         Currency    MD024878
     C                   PARM      DDACOD        P@ACCD                         Account CodeMD024878
     C                   PARM      DDACSQ        P@ACSQ                         Account SequMD024878
     C                   PARM      DDBRCA        P@BRCA                         Branch      MD024878
     C     DsACCN        PARM      DsACCN        DSSDY                                      MD024878
      *                                                                                     MD024878
 b3  C     PRtcd         IFEQ      *Blanks                                                  MD024878
     C                   MOVE      CCY           WFCCY                                      MD024878
     C                   GOTO      ENDRET                                                   MD024878
 e3  C                   END                                                                MD024878
 e2  C                   END                                                                MD024878
      *                                                                                     MD024878
      ** - If Retail Account number is not zero                                             MD024878
      *                                                                                     MD024878
 b2  C     ACNO          IFNE      0                                                        MD024878
     C                   Z-ADD     ACNO          WFACNO                         Retail AccouMD024878
     C                   MOVE      P@FACN        P_FullGLacc                                MD024878
      ** Get the Customer Number                                                           MD024878B
     C                   EVAL      WRCNUM = DDCNUM                                         MD024878B
 e2  C                   END                                                                MD024878
 e1  C                   END                                                                MD024878
                                                                                            MD024878
     C     ENDRET        TAG                                                                MD024878
                                                                                            MD024878
     C                   IF        IFSRCN <> *BLANKS                                        MD026339
     C                   EVAL      WRCNUM = IFSRCN                                          MD026339
     C                   ENDIF                                                              MD026339
                                                                                            MD026339
      ** - If Nostro code is Blank and Customer Account field is not blank; if IFSADR       MD024878
      **   or IFSACR contains same account than Customer account field no attempt to        MD024878
      **   write/update a forecast                                                          MD024878
                                                                                            MD024878
 b1  C     WFNOSC        IFEQ      *Blanks                                                  MD024878
     C     IFCUSA        ANDNE     *Blanks                                                  MD024878
      *                                                                                     MD024878
 b2  C     P@FACN        IFEQ      IFSADR                                                   MD024878
     C     P@FACN        OREQ      IFSACR                                                   MD024878
                                                                                            MD024878
     C                   MOVE      'Y'           NWRUP                                      MD024878
 e2  C                   END                                                                MD024878
 e1  C                   END                                                                MD024878
      *                                                                                     MD024878
     C                   ENDSR                                                              MD024878
      *****************************************************************                     MD024878
      /EJECT                                                                                MD024878
      *****************************************************************
      *  CURREN - Currency decimal places                             *
      *                                                               *
      *****************************************************************
     C     CURREN        BEGSR

      ** Access currency details via access program

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      BDCYCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY

      ** Database error

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   END

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlign - Align Amount to the Decimal Position               *
      *                                                               *
      *****************************************************************
     C     SRAlign       BEGSR

     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16

     C                   ENDSR
      *****************************************************************
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *================================================================
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     MD025967
      *                                                               *                     MD025967
      *  SRPrintDtl - Print Detail Routine                            *                     MD025967
      *                                                               *                     MD025967
      *****************************************************************                     MD025967
     C     SRPrintDtl    BEGSR                                                              MD025967
                                                                                            MD025967
      ** Set up Details                                                                     MD025967
                                                                                            MD025967
     C                   CLEAR                   DETAIL                                     MD025967
     C                   CLEAR                   DET01                                      MD025967
                                                                                            MD025967
      ** Batch ID                                                                           MD025967
                                                                                            MD025967
     C                   EVAL      PEBTID = BDBTID                                          MD025967
                                                                                            MD025967
      ** Booking Branch                                                                     MD025967
                                                                                            MD025967
     C                   EVAL      PEBKBR = BDBKBR                                          MD025967
                                                                                            MD025967
      ** Department                                                                         MD025967
                                                                                            MD025967
     C                   EVAL      PEDPCD = BDDPCD                                          MD025967
                                                                                            MD025967
      ** Currency                                                                           MD025967
                                                                                            MD025967
     C                   EVAL      PECCY  = BDCCY                                           MD025967
                                                                                            MD025967
      ** Event Amount                                                                       MD025967
                                                                                            MD025967
     C                   EXSR      CURREN                                                   MD025967
     C                   EVAL      WField = *BLANKS                                         MD025967
     C                   EVAL      WAmount = *Zeros                                         MD025967
     C                   EVAL      PDecPlace = *Zeros                                       MD025967
     C                   MOVE      BDEVTA        WAmount                                    MD025967
     C                   EVAL      PDecPlace = A6NBDP                                       MD025967
     C                   EXSR      FormatAmount                                             MD025967
     C                   MOVE      WField        PEEVTA                                     MD025967
                                                                                            MD025967
      ** DR/CR                                                                              MD025967
                                                                                            MD025967
     C                   EVAL      PEDCIP = BDDCIP                                          MD025967
                                                                                            MD025967
      ** Posting Date                                                                       MD025967
                                                                                            MD025967
     C                   EVAL      ZDAYNO = BDPSTD                                          MD025967
                                                                                            MD025967
     C                   CALL      'ZDATE2'                                                 MD025967
     C                   PARM                    ZDAYNO                                     MD025967
     C                   PARM                    BJDFIN                                     MD025967
     C                   PARM      *ZERO         ZDATE                                      MD025967
     C                   PARM      *BLANK        ZADATE                                     MD025967
                                                                                            MD025967
     C                   MOVEL     ZDATE         PEPSTD                                     MD025967
                                                                                            MD025967
      ** Event Date                                                                         MD025967
                                                                                            MD025967
     C                   EVAL      ZDAYNO = BDEVTD                                          MD025967
                                                                                            MD025967
     C                   CALL      'ZDATE2'                                                 MD025967
     C                   PARM                    ZDAYNO                                     MD025967
     C                   PARM                    BJDFIN                                     MD025967
     C                   PARM      *ZERO         ZDATE                                      MD025967
     C                   PARM      *BLANK        ZADATE                                     MD025967
                                                                                            MD025967
     C                   MOVEL     ZDATE         PEEVTD                                     MD025967
                                                                                            MD025967
      ** Narrative                                                                          MD025967
                                                                                            MD025967
     C                   EVAL      PENARR = BDNARR                                          MD025967
     C                   EVAL      PENAR2 = BDNAR2                                          MD025967
     C                   EVAL      PENAR3 = BDNAR3                                          MD025967
     C                   EVAL      PENAR4 = BDNAR4                                          MD025967
     C                   EVAL      PENAR5 = BDNAR5                                          MD025967
     C                   EVAL      PENAR6 = BDNAR6                                          MD025967
     C                   EVAL      PENAR7 = BDNAR7                                          MD025967
                                                                                            MD025967
      ** Sett A/c DR                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESADR = BDSADR                                          MD025967
                                                                                            MD025967
      ** Sett A/c CR                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESACR = BDSACR                                          MD025967
                                                                                            MD025967
      ** Customers: Counterparty                                                            MD025967
                                                                                            MD025967
     C                   EVAL      PECTPY = BDCTPY                                          MD025967
                                                                                            MD025967
      ** Depot                                                                              MD025967
                                                                                            MD025967
     C                   EVAL      PEDPCN = BDDPCN                                          MD025967
                                                                                            MD025967
      ** Issuing                                                                            MD025967
                                                                                            MD025967
     C                   EVAL      PEISCN = BDISCN                                          MD025967
                                                                                            MD025967
      ** Associated                                                                         MD025967
                                                                                            MD025967
     C                   EVAL      PEASCN = BDASCN                                          MD025967
                                                                                            MD025967
      ** MatchField1                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT1 = BDSMT1                                          MD025967
                                                                                            MD025967
      ** MatchField2                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT2 = BDSMT2                                          MD025967
                                                                                            MD025967
      ** MatchField3                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT3 = BDSMT3                                          MD025967
                                                                                            MD025967
      ** MatchField4                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT4 = BDSMT4                                          MD025967
                                                                                            MD025967
      ** MatchField5                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT5 = BDSMT5                                          MD025967
                                                                                            MD025967
      ** MatchField6                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT6 = BDSMT6                                          MD025967
                                                                                            MD025967
      ** MatchField7                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT7 = BDSMT7                                          MD025967
                                                                                            MD025967
      ** MatchField8                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT8 = BDSMT8                                          MD025967
                                                                                            MD025967
      ** MatchField9                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PESMT9 = BDSMT9                                          MD025967
                                                                                            MD025967
      ** MatchField10                                                                       MD025967
                                                                                            MD025967
     C                   EVAL      PESMT10 = BDSMT10                                        MD025967
                                                                                            MD025967
      ** DR/CR                                                                              MD025967
                                                                                            MD025967
     C                   EVAL      PEDCRD = BDDCIP                                          MD025967
                                                                                            MD025967
      ** Profit Centre                                                                      MD025967
                                                                                            MD025967
     C                   EVAL      PEPFCT = BDPFCT                                          MD025967
                                                                                            MD025967
      ** SWIFT Ref                                                                          MD025967
                                                                                            MD025967
     C                   EVAL      PESWFR = BDSWFR                                          MD025967
                                                                                            MD025967
      ** Cheque No                                                                          MD025967
                                                                                            MD025967
     C                   IF        BDCHQN <> 0                                              MD031513
     C                   MOVE      BDCHQN        PECHQN                                     MD025967
     C                   ELSE                                                               MD031513
     C                   MOVE      *BLANKS       PECHQN                                     MD031513
     C                   ENDIF                                                              MD031513
                                                                                            MD025967
      ** Book Code                                                                          MD025967
                                                                                            MD025967
     C                   EVAL      PEBKCD = BDBKCD                                          MD025967
                                                                                            MD025967
      ** Source Customer                                                                    MD025967
                                                                                            MD025967
     C                   EVAL      PESRCN = BDSRCN                                          MD025967
                                                                                            MD025967
      ** Unique ID Identifier                                                               MD025967
                                                                                            MD025967
     C                   EVAL      PEUNID = BDUNID                                          MD025967
                                                                                            MD025967
      ** Description                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PEDESC = BDDESC                                          MD025967
                                                                                            MD025967
      ** Customer Account from Interface                                                    MD025967
                                                                                            MD025967
     C                   EVAL      PICUSA = BICUSA                                          MD025967
                                                                                            MD025967
      ** Transaction Sub Type from Interface                                                MD025967
                                                                                            MD025967
     C                   EVAL      PITSTY = BITSTY                                          MD025967
                                                                                            MD025967
      ** Reversal Ind                                                                       MD025967
                                                                                            MD025967
     C                   EVAL      PERVID = BDRVID                                          MD025967
                                                                                            MD025967
                                                                                            MD025967
     C                   IF        CGL145 = 'Y'                                             MD025967
     C                   EVAL      *IN80 = *ON                                              MD025967
                                                                                            MD025967
      ** Customer Source Account ID                                                         MD025967
                                                                                            MD025967
     C                   EVAL      PECSAI = BDCSAI                                          MD025967
                                                                                            MD025967
      ** Operation Type                                                                     MD025967
                                                                                            MD025967
     C                   EVAL      PEOPTP = BDOPTP                                          MD025967
                                                                                            MD025967
      ** Forecast Reference                                                                 MD025967
                                                                                            MD025967
     C                   EVAL      PEFCRF = BDFCRF                                          MD025967
                                                                                            MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
      ** Print Report Headers for every new page                                            MD025967
                                                                                            MD025967
     C**********         EVAL      RqdLn1 = 1                                      MD025967 MD027243
     C**********         EVAL      DifLn1 = OFLLN1 - PRTLN1                        MD025967 MD027243
                                                                                            MD025967
     C**********         IF        DifLn1 <= RqdLn1                                MD025967 MD027243
     C                   WRITE     HEADER1                                                  MD025967
     C                   WRITE     HEADER2                                                  MD025967
     C**********         ENDIF                                                     MD025967 MD027243
                                                                                            MD025967
     C                   WRITE     DETAIL                                                   MD025967
                                                                                            MD025967
      ** Forecast Details                                                                   MD025967
      ** =======                                                                            MD025967
                                                                                            MD025967
     C                   IF        Forecast = 'New'                                         MD025967
     C                   EVAL      PFORTL = '          NEW FORECAST:'                       MD025967
     C                   EVAL      PFORTLX = 'Forecast Amount'                              MD025967
     C                   ELSEIF    Forecast = 'Update'                                      MD025967
     C                   EVAL      PFORTL = '      UPDATED FORECAST:'                       MD025967
     C                   EVAL      PFORTLX = 'Forecast Amount'                              MD025967
     C                   ELSEIF    Forecast = 'Update Total'                                MD025967
     C                   EVAL      PFORTL = 'UPDATED FORECAST TOTAL:'                       MD025967
     C                   EVAL      PFORTLX = ' Total Forecast'                              MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
      ** Customer                                                                           MD025967
                                                                                            MD025967
     C                   EVAL      PFCUST = WRCNUM                                          MD025967
                                                                                            MD025967
      ** Customer Source A/C                                                                MD025967
                                                                                            MD025967
     C                   EVAL      PFCSAC = IFCSAI                                          MD025967
                                                                                            MD025967
      ** Currency                                                                           MD025967
                                                                                            MD025967
     C                   EVAL      PFCCY = IFCCY                                            MD025967
                                                                                            MD025967
      ** Nostro Code                                                                        MD025967
                                                                                            MD025967
     C                   EVAL      PFNOSC = WFNOSC                                          MD025967
                                                                                            MD025967
      ** Retail Account                                                                     MD025967
                                                                                            MD025967
     C                   EVAL      PFFACN = P_FullGLAcc                                     MD025967
                                                                                            MD025967
      ** Date                                                                               MD025967
                                                                                            MD025967
     C                   MOVEL     ZDATE         PFDATE                                     MD025967
                                                                                            MD025967
      ** Operation Type                                                                     MD025967
                                                                                            MD025967
     C                   IF        Forecast = 'New' or Forecast = 'Update'                  MD025967
     C                   EVAL      *IN91 = *ON                                              MD025967
     C                   EVAL      PFOPTP = IFOPTP                                          MD025967
     C                   ELSEIF    Forecast = 'Update Total'                                MD025967
     C                   EVAL      *IN91 = *OFF                                             MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
      ** Forecast Amount/Total Forecast                                                     MD025967
                                                                                            MD025967
     C                   EVAL      WAmount = *Zeros                                         MD025967
     C                   IF        Forecast = 'Update Total'                                MD025967
     C                   MOVE      WFAMNT        WAmount                                    MD025967
     C                   ELSEIF    Forecast = 'New' Or Forecast = 'Update'                  MD025967
     C                   MOVE      P_Amount      WAmount                                    MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
     C                   EXSR      CURREN                                                   MD025967
     C                   EVAL      WField = *BLANKS                                         MD025967
     C                   EVAL      PDecPlace = *Zeros                                       MD025967
     C                   EVAL      PDecPlace = A6NBDP                                       MD025967
     C                   EXSR      FormatAmount                                             MD025967
     C                   MOVE      WField        PFAMNT                                     MD025967
                                                                                            MD025967
      ** Actual Amount                                                                      MD025967
                                                                                            MD025967
     C                   EVAL      WAmount = *Zeros                                         MD025967
     C                   IF        Forecast = 'Update Total'                                MD025967
     C                   MOVE      WFACTL        WAmount                                    MD025967
     C                   ELSEIF    Forecast = 'New' Or Forecast = 'Update'                  MD025967
     C                   MOVE      P_ActualAmnt  WAmount                                    MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
     C                   EXSR      CURREN                                                   MD025967
     C                   EVAL      WField = *BLANKS                                         MD025967
     C                   EVAL      PDecPlace = *Zeros                                       MD025967
     C                   EVAL      PDecPlace = A6NBDP                                       MD025967
     C                   EXSR      FormatAmount                                             MD025967
     C                   MOVE      WField        PFACTL                                     MD025967
                                                                                            MD025967
     C                   WRITE     DET01                                                    MD025967
                                                                                            MD025967
                                                                                            MD025967
     C                   ENDSR                                                              MD025967
      *****************************************************************                     MD025967
      /EJECT                                                                                MD025967
      *****************************************************************                     MD025967
      *                                                               *                     MD025967
      *  FormatAmount - Format Amount Routine                         *                     MD025967
      *                                                               *                     MD025967
      *****************************************************************                     MD025967
     C     FormatAmount  BEGSR                                                              MD025967
                                                                                            MD025967
      ** If non-zero, format amount                                                         MD025967
     C                   IF        WAmount <> 0                                             MD025967
                                                                                            MD025967
     C                   CALL      'ZSEDIT'                                                 MD025967
     C                   PARM                    WAmount                                    MD025967
     C                   PARM                    PDecPlace                                  MD025967
     C                   PARM      'J'           PEdtCode                                   MD025967
     C                   PARM                    WField                                     MD025967
                                                                                            MD025967
     C                   ELSE                                                               MD025967
                                                                                            MD025967
      * If zero, check number of decimal places                                             MD025967
     C                   IF        PDecPlace = 0                                            MD025967
     C                   EVAL      WField = '                   0 '                         MD025967
     C                   ELSEIF    PDecPlace = 1                                            MD025967
     C                   EVAL      WField = '                 0.0 '                         MD025967
     C                   ELSEIF    PDecPlace = 2                                            MD025967
     C                   EVAL      WField = '                0.00 '                         MD025967
     C                   ELSEIF    PDecPlace = 3                                            MD025967
     C                   EVAL      WField = '               0.000 '                         MD025967
     C                   ELSEIF    PDecPlace = 4                                            MD025967
     C                   EVAL      WField = '              0.0000 '                         MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
     C                   ENDIF                                                              MD025967
                                                                                            MD025967
     C                   ENDSR                                                              MD025967
      *****************************************************************                     MD025967
      /EJECT                                                                                MD025967
      *****************************************************************
      * Initialise field
      *****************************************************************
     C     INIT          BEGSR

     C     *ENTRY        PLIST                                                              MD024878
     C                   PARM                    PBTID            60                        MD024878
     C                   PARM                    ReturnCode       10                        MD025967
     C                   PARM                    PMode                                      MD025967
     C                   PARM                    PSeq                                       MD025967
     C                   PARM                    PLevel                                     MD025967
     C                   PARM                    PEnty                                      MD025967
                                                                                            MD024878
      ** Access Bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE                                                               MD025967
     C                   EVAL      RRPTDS = BJURPT                                          MD025967
     C                   ENDIF

      ** Access Retail ICD
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Access Switchable Features CGL135 and CGL145

     C                   CALL      'AOSARDR0'
     C                   Parm      *Blanks       PRtCd
     C                   Parm      '*VERIFY'     POptn
     C                   Parm      'CGL135'      PSard
     C                   Parm                    DSFDY

     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CGL135'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      CGL135 = 'N'
     C                   ELSE
     C                   EVAL      CGL135 = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   CALL      'AOSARDR0'
     C                   Parm      *Blanks       PRtCd
     C                   Parm      '*VERIFY'     POptn
     C                   Parm      'CGL145'      PSARD
     C                   Parm                    DSFDY

     C                   IF        PRtCd <> *BLANKS AND
     C                             PRtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CGL145'
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      CGL145 = 'N'
     C                   ELSE
     C                   EVAL      CGL145 = 'Y'
     C                   ENDIF
     C                   ENDIF

      * no Write/Update indicator initialisation                                            MD024878
      *                                                                                     MD024878
     C                   MOVE      ' '           NWRUP             1                        MD024878
                                                                                            MD024878
      ** Retrieve details for Dummy Customer
      *
     C                   EVAL      P@OP01 = 'ForecastDummyCust'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM                    P@OP01
     C                   PARM      *Blanks       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *Blanks       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *Blanks       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *Blanks       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *Blanks       P@VL05
     C                   PARM      *Blanks       P@OP06
     C                   PARM      *Blanks       P@VL06
     C                   PARM      *Blanks       P@OP07
     C                   PARM      *Blanks       P@VL07
     C                   PARM      *Blanks       P@OP08
     C                   PARM      *Blanks       P@VL08
     C                   PARM      *Blanks       P@OP09
     C                   PARM      *Blanks       P@VL09
     C                   PARM      *Blanks       P@OP10
     C                   PARM      *Blanks       P@VL10
      *
     C     P@RTCD        IFEQ      *Blanks
      *
     C                   EVAL      P_DummyCust  = P@VL01
      *
     C                   ENDIF
      *
     C     WRKKEY        KLIST
     C                   KFLD                    A7CUST
     C                   KFLD                    A7CYCD
     C                   KFLD                    A7ACCD
     C                   KFLD                    A7ACSN
     C                   KFLD                    A7BRCD

      ** Set off program indicators                                                         MD025967
                                                                                            MD025967
     C                   EVAL      *INU7 = *OFF                                             MD025967
     C                   EVAL      *INU8 = *OFF                                             MD025967
                                                                                            MD025967
      ** Ensure Detail Spool File recorded by RCF.                                          MD025967
                                                                                            MD025967
     C                   EVAL      ZSnum = SFNUM1                                           MD025967
                                                                                            MD025967
     C                   CALL      'ZSFILE'                                                 MD025967
     C                   PARM                    PSeq                                       MD025967
     C                   PARM      *Blanks       SEnty                                      MD025967
     C                   PARM                    SFILE1                                     MD025967
     C                   PARM                    ZSnum                                      MD025967
     C                   PARM      *Blanks       ZSerr                                      MD025967
                                                                                            MD025967
     C                   IF        ZSErr = 'Y'                                              MD025967
     C                   EVAL      *INU7 = *On                                              MD025967
     C                   EVAL      *INU8 = *On                                              MD025967
     C                   EVAL      *INLR = *On                                              MD025967
     C                   RETURN                                                             MD025967
     C                   ENDIF                                                              MD025967

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
      *                                                               *
      *****************************************************************
