     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Watch list check engine')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SDWLENGN - Watch List Check Engine                           *
      *                                                               *
      *  Function:  This module will be made available to the input   *
      *             validation routines of the different Midas        *
      *             functions.  It will call the Fircosoft API in     *
      *             order to carry out the watch list check.  If the  *
      *             API reports possible match, then the function     *
      *             will query the API in order to obtain details of  *
      *             the match, including the field positions and      *
      *             details of the matching items.  Each time a       *
      *             violation is detected the function will create an *
      *             investigation case in the case management system. *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 228778             Date 25Apr19               *
      *  Prev Amend No. CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 221934             Date 08Oct03               *
      *                 CSD019             Date 02Jun03               *
      *                 CSD015  *CREATE    Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  228778 - CWLCHECK Fails receiver too small.                  *
      *  CSD101 - Password Encryption                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  221934 - Compliance Watch alpha site fix                     *
      *           CWLCHECK falls down if COMPWATCH job slow to start  *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRExtStr -  Subroutine to extract field names and field      *
      *              contents into arrays.                            *
      *  SRBuild  -  Subroutine to build the string to be passed to   *
      *              OFAC agent and to the Case Management as well as *
      *              the starting position of each field content in   *
      *              strings.                                         *
      *  SRHitList - Subroutine to Process hit                        *
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
 
      * Compliance Watch Hit List File
     FSDCWHTL3  UF A E           K DISK
 
      * Next Available Case Number File
     FSDWLCSPD  UF A E             DISK
                                                                                              CSD019
      ** Midas SD CW Case External Match Details File                                         CSD019
     FSDCWCSPD  UF A E             DISK                                                       CSD019
                                                                                              CSD019
      ** Midas SD CW Case Matched Name Synonyms Filee                                         CSD019
     FSDCWNMPD  UF A E             DISK                                                       CSD019
                                                                                              CSD019
      ** Midas SD CW Case Matched Address Synonyms File                                       CSD019
     FSDCWADPD  UF A E             DISK                                                       CSD019
                                                                                              CSD019
      ** Midas SD CW Case Matched City Synonyms Filee                                         CSD019
     FSDCWCTPD  UF A E             DISK                                                       CSD019
                                                                                              CSD019
      ** Midas SD CW Case Matched Country Synonyms File                                       CSD019
     FSDCWCOPD  UF A E             DISK                                                       CSD019
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D*LDA******     E DS           256    EXTNAME(LDA)                                       CSD019
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)                           CSD019
      *
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
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSD101
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
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
 
     D @Fldname        S             25    DIM(99)
      ** Field name array
 
     D @FldCont        S            210    DIM(99)
      ** Content of field names
 
     D @StrPosn        S              4  0 DIM(99)
      ** Start position of the contents in OFAC string
 
     D @FldLen         S              3  0 DIM(99)
      ** Length of the contents
 
     D OFACPos         S              5  0 DIM(99)
      ** Starting position of each field content in OFAC String
 
     D CAPos           S              5  0 DIM(99)
      ** Starting position of each field content in CAS String
 
     D hitstart        S             10I 0 DIM(4)
      ** Starting position of hit string
 
     D hitend          S             10I 0 DIM(4)
      ** End position of hit string
 
     D numsyn          S              5I 0 DIM(4)
      ** Number of synonyms
 
     D Namesyn         S            105    DIM(99)
      ** Details of Name synonym
 
     D Adrsyn          S             70    DIM(99)
      ** Details of Address synonym
 
     D Citysyn         S             35    DIM(99)
      ** Details of City synonym
 
     D CtrySyn         S             35    DIM(99)
      ** Details of Country synonym
 
     D WMtchStr        S             10  0 DIM(4)
      ** Match position - Start
 
     D WMtchEnd        S             10  0 DIM(4)
      ** Match position- End
 
     D P_Retcd         S              7
     D P_Optn          S              7
      ** Parameter for calling AOCWCDR0
                                                                                              CSD019
     D P_Sard          S              6                                                       CSD019
     D CSD019          S              1A                                                      CSD019
     D PDateIn         S              8A                                                      CSD019
     D PDayNOut        S              5P 0                                                    CSD019
 
     D TranDtls      E DS                  EXTNAME(SDWLTDPD)
      ** Transaction details of transaction - Input parameter
 
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)
      ** Short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Short data structure
                                                                                              CSD019
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD019
      ** Short data structure                                                                 CSD019
                                                                                              CSD019
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD019
      ** Midas SC Switchable features descriptions                                            CSD019
                                                                                              CSD019
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CSD019
      ** Midas SD Bank details ICD files                                                      CSD019
 
     D AmtString       DS            18
     D  WInteger               1     15
     D  WDecimal              16     18
                                                                                              CSD019
     D WDelD           DS            10                                                       CSD019
     D  WDYear                 1      4                                                       CSD019
     D  WDMnth                 6      7                                                       CSD019
     D  WDDay                  9     10                                                       CSD019
                                                                                              CSD019
     D WValD           DS            10                                                       CSD019
     D  WVYear                 1      4                                                       CSD019
     D  WVMnth                 6      7                                                       CSD019
     D  WVDay                  9     10                                                       CSD019
                                                                                              CSD019
     D WMatD           DS            10                                                       CSD019
     D  WMYear                 1      4                                                       CSD019
     D  WMMnth                 6      7                                                       CSD019
     D  WMDay                  9     10                                                       CSD019
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D WFUNC           S              8
     D WIDNT           S             40
     D WBRCA           S              3
 
     D WAlp10          S             10
 
     D WFldName        S             25
      ** Field name work variable
 
     D WFldCont        S            210
      ** Field name work variable
 
     D OFACString      S          30000
      ** Field content separated by 1 space
 
     D CAString        S           7640
      ** Field name + TAB + Field content + CRLF
 
     D CAStartPos      S              5  0
      ** Work Start Position of field content on CA String
 
     D OFACStartPos    S              5  0
      ** Work Start Position of field content on OFAC String
 
     D WDiff           S              5  0
      ** Difference between OFAC position and hit position
 
     D WAmtPs          S             18  3
      ** Work variable to move the negative amount to make it positive
 
     D S               S              5  0
      ** Postion of '>' marked-up before the field name
 
     D E               S              5  0
      ** Position of '<' marked-up after the field name
 
     D C               S              5  0
      ** Position of of '/' marked-up before the closing field name
 
     D D               S              5  0
      ** Position of of '</' + 1 marked-up before the closing field name
 
     D I               S              3  0
      ** Array index for field names and contents
 
     D***Q******         S              1  0                                           221934 228778
     D Q               S              2  0                                                    228778
      ** Counter for loop to keep trying to call FofExec                                      221934
                                                                                              221934
     D QCMD            S             80                                                       221934
      ** String to send to QCMDEXC                                                            221934
                                                                                              221934
     D QLEN            S             15  5                                                    221934
      ** Length of QCMD string                                                                221934
                                                                                              221934
     D X               S              3  0
      ** Array index for field names and contents
 
     D Y               S              2  0
      ** Array index for field names and contents
 
     D Z               S              3  0
      ** hit position
 
     D Ctr             S              3  0
      ** match position against ofac string
 
     D PRetCode        S              7A
     D PServ           S               *
     D SrchStrng       S          30000
      ** Entry Parameters
 
     D WMTCHCD         S             12
      ** Match code
 
     D @FldNAM         S             35
     D @endelm         S             38
 
     ** Message Variables
     D PReturnCode     S              7A
     D PMsg            S            132A
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgQ           S             10A
                                                                                              CSD101
     D Password        S            128                                                       CSD101
     D PAction         S              1A                                                      CSD101
     D PValidList      S             10A   INZ('SDINTFVL')                                    CSD101
     D PLibrary        S             10A                                                      CSD101
     D PIDName         S            100A                                                      CSD101
     D PPass1          S            128A                                                      CSD101
     D PDescr          S           1000A                                                      CSD101
 
      ** +--------------------------------------+
      ** ¦ Prototypes                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
      * Source Included from FOFAPI
 
     DFkCommTraceOn    PR            10I 0 EXTPROC('FkCommTraceOn')
     D path                            *   VALUE OPTIONS(*STRING)
     D name                            *   VALUE OPTIONS(*STRING)
 
     DFofExec          PR            10I 0 EXTPROC('FofExec')
     D Pserver                         *   VALUE
     D mode                          10I 0 VALUE
     D message                         *   VALUE OPTIONS(*STRING)
     D id                              *   VALUE OPTIONS(*STRING)
     D type                            *   VALUE OPTIONS(*STRING)
     D details                       10I 0 VALUE
 
     DFofRHn           PR            10I 0 EXTPROC('FofRHn')
     D Pserver                         *   VALUE
 
     DFofRStatus       PR            10I 0 EXTPROC('FofRStatus')
     D Pserver                         *   VALUE
 
     DFofRHresultI     PR            10I 0 EXTPROC('FofRHresultI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHtagI        PR              *   EXTPROC('FofRHtagI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHmatchI      PR             4F   EXTPROC('FofRHmatchI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHofacIdI     PR              *   EXTPROC('FofRHofacIdI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHnameI       PR              *   EXTPROC('FofRHnameI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHnSynNameI   PR            10I 0 EXTPROC('FofRHnSynNameI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynNameIJ   PR              *   EXTPROC('FofRHsynNameIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHposIJK      PR            10I 0 EXTPROC('FofRHposIJK')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
     D K                             10I 0 VALUE
 
     DFofLast          PR              *   EXTPROC('FofLast')
 
     DFofExecGetParms  PR            10I 0 EXTPROC('FofExecGetParams')
     D Pserver                         *   VALUE
 
     DFofRThreshold    PR             4F   EXTPROC('FofRThreshold')
     D Pserver                         *   VALUE
 
     DFofRSeverity     PR              *   EXTPROC('FofRSeverity')
     D Pserver                         *   VALUE
 
     DFofExecSetParms  PR            10I 0 EXTPROC('FofExecSetParms')
     D Pserver                         *   VALUE
 
     DFofShutdown      PR            10I 0 EXTPROC('FofShutdown')
     D Pserver                         *   VALUE
 
     DFofExecReloadDb  PR            10I 0 EXTPROC('FofExecReloadDb')
     D Pserver                         *   VALUE
 
      * End of Source copy from FOFAPI
 
     DCHKMPYITEM       PR                  EXTPGM('CHKMPYITEM')
     D Branch                         3
     D Unit                           6
     D Batch                          6  0
     D Currency                       3
     D Service                        6
     D Target_Branch                  3
     D Item_Number                    6  0
     D Dest_Acc_Name                 50
     D Dest_Name                     50
     D Dest_Addr1                    35
     D Dest_Addr2                    35
     D Dest_Addr3                    35
     D Dest_Addr4                    35
     D Dest_Addr5                    35
     D Dest_Country                   2
     D Txn_Text1                     20
     D Txn_Text2                     30
     D Addn_Text1                    35
     D Addn_Text2                    35
     D Addn_Text3                    35
     D Addn_Text4                    35
     D Addn_Text5                    35
     D Addn_Text6                    35
     D Result                         3
     D Action                         2
     D OFAC_Failed                    1
     D Return_OFACID                  5
     D Return_OFNAME                 40
     D Return_Start                  10  0
     D Return_End                    10  0
 
     D Result          S              3
     D Action          S              2
 
     D chkstr          S          31000
     D res             S             10I 0
     D hits            S             10I 0
     D ofacid          S              5
     D ofname          S            105
     D ofaddr          S             70
     D ofcity          S             35
     D ofcntry         S             35
     D oforigin        S             10
     D ofDesgn         S             15
     D ofusrdta1       S             32
     D ofusrdta2       S             32
     D ofsrchcde       S             36
     D Sequence        S              3P 0
     D tstdat          S               D   DATFMT(*ISO)
 
      * Why not included on set of definition for FOF
     DFofRHaddressI    PR              *   EXTPROC('FofRHaddressI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHcityI       PR              *   EXTPROC('FofRHcityI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHcountryI    PR              *   EXTPROC('FofRHcountryI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHoriginI     PR              *   EXTPROC('FofRHoriginI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHuser1I      PR              *   EXTPROC('FofRHuser1I')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHuser2I      PR              *   EXTPROC('FofRHuser2I')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsearchkI    PR              *   EXTPROC('FofRHsearchkI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHnSynCityI   PR            10I 0 EXTPROC('FofRHnSynCityI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynCityIJ   PR              *   EXTPROC('FofRHsynCityIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHnSynCtryI   PR            10I 0 EXTPROC('FofRHnSynCountryI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynCtryIJ   PR              *   EXTPROC('FofRHsynCountryIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHnSynAddrI   PR            10I 0 EXTPROC('FofRHnSynAddressI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
     DFofRHsynAddIJ    PR              *   EXTPROC('FofRHsynAddressIJ')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
     D J                             10I 0 VALUE
 
     DFofRHdesigI      PR              *   EXTPROC('FofRHdesignationI')
     D Pserver                         *   VALUE
     D I                             10I 0 VALUE
 
      * object used to store object returned by the case constructor
     D caseobject      S               O   CLASS(*JAVA:
     D                                     'com.misys.midas.casemgt.Case')
 
      * constructor with aguments,  returns object to be used by caseobject
     D createcase      PR              O   EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.Case':
     D                                     *CONSTRUCTOR)
     D                                     CLASS(*JAVA:
     D                                     'com.misys.midas.casemgt.Case')
     D  matchcode                      O   CLASS(*JAVA:'java.lang.String')
     D  itemTypeCode                   O   CLASS(*JAVA:'java.lang.String')
     D  identifier                     O   CLASS(*JAVA:'java.lang.String')
     D  branch                         O   CLASS(*JAVA:'java.lang.String')
     D  system                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Item Type Code
     D setitemtypecod  PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setItemTypeCode')
     D itemtypecode                    O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Identifier
     D setidentifier   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setIdentifier')
     D identifier                      O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Branch
     D setbranch       PR                  EXTPROC(*JAVA
     D                                     :'com.misys.midas.casemgt.Case'
     D                                     :'setBranch')
     D branch                          O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set System
     D setsystem       PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setSystem')
     D system                          O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Counter Party Number
     D setctrpartyn    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setCounterpartyNumber')
     D counterparty                    O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Counter Party Type
     D setctrpartyt    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setCounterpartyType')
     D counterparty                    O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Counter Party
     D setctrparty     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setCounterparty')
     D counterparty                    O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Deal Date
     D setdealdate     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setDealDate')
     D dealdate                        O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Value Date
     D setvaluedate    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setValueDate')
     D valuedate                       O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Maturity Date
     D setmaturedate   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMaturityDate')
     D maturedate                      O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Denomination Side 1
     D setdenoside1    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setDenominationSide1')
     D denomination1                   O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Denomination Side 2
     D setdenoside2    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setDenominationSide2')
     D denomination2                   O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Amount Side 1
     D setamount1      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setAmountSide1')
     D amount1                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Amount Side 2
     D setamount2      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setAmountSide2')
     D amount2                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Search Data
     D setsearchdata   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setSearchData')
     D searchdata                      O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Function Type
     D setfunction     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setFunctionType')
     D functiontype                    O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Match 1 Start
     D setmatch1s      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch1Start')
     D match1Start                   10I 0 VALUE
 
      * prototype for set Match 1 End
     D setmatch1e      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch1End')
     D match1end                     10I 0 VALUE
 
      * prototype for set Match 2 Start
     D setmatch2s      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch2Start')
     D match2Start                   10I 0 VALUE
 
      * prototype for set Match 2 End
     D setmatch2e      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch2End')
     D match2end                     10I 0 VALUE
 
      * prototype for set Match 3 Start
     D setmatch3s      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch3Start')
     D match3Start                   10I 0 VALUE
 
      * prototype for set Match 3 End
     D setmatch3e      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch3End')
     D match3end                     10I 0 VALUE
 
      * prototype for set Match 4 Start
     D setmatch4s      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch4Start')
     D match4Start                   10I 0 VALUE
 
      * prototype for set Match 4 End
     D setmatch4e      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setMatch4End')
     D match4end                     10I 0 VALUE
 
      * prototype for set Watch List Identifier
     D setwlidentify   PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setWatchListIdentifier')
     D wlidentifier                    O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Watch List Origin
     D setwlorigin     PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setWatchListOrigin')
     D wloroigin                       O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Type
     D settype         PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setType')
     D type                            O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Name
     D setentryname    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setEntryName')
     D names                           O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Address
     D setentryaddres  PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setEntryAddress')
     D address                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set City
     D setentrycity    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setEntryCity')
     D city                            O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Country
     D setcountry      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setEntryCountry')
     D country                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set Codes
     D setcodes        PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setCodes')
     D codes                           O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set User Data 1
     D setuserdata1    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setUserData1')
     D userdata1                       O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for set User Data 2
     D setuserdata2    PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'setUserData2')
     D userdata2                       O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for Add Name
     D addname         PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'addName')
     D name                            O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for Add Address
     D addaddress      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'addAddress')
     D address                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for Add City
     D addcity         PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'addCity')
     D city                            O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for Add Country
     D addcountry      PR                  EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     Case':
     D                                     'addCountry')
     D country                         O   CLASS(*JAVA:'java.lang.String')
 
      * prototype for Insert Case
     D insertcase      PR            10I 0 EXTPROC(*JAVA:
     D                                     'com.misys.midas.casemgt.+
     D                                     CaseManager':
     D                                     'insertCase')
     D                                     STATIC
     D caseobj                         O   CLASS(*JAVA:
     D                                     'com.misys.midas.casemgt.Case')
     D servername                      O   CLASS(*JAVA:'java.lang.String')
     D databasename                    O   CLASS(*JAVA:'java.lang.String')
     D username                        O   CLASS(*JAVA:'java.lang.String')
     D password                        O   CLASS(*JAVA:'java.lang.String')
 
      * prototype the string constructor
     D makestr         PR              O   EXTPROC(*JAVA:
     D                                             'java.lang.String':
     D                                             *CONSTRUCTOR)
     D                                     CLASS(*JAVA:'java.lang.String')
     D  bytes                      7640A   CONST VARYING
 
      * define fields to store String objects
     D rpg2javastring  S               O   CLASS(*JAVA:'java.lang.String')
 
      * temporary objects
     D itemTypeCode    S               O   CLASS(*JAVA:'java.lang.String')
     D identifier      S               O   CLASS(*JAVA:'java.lang.String')
     D branch          S               O   CLASS(*JAVA:'java.lang.String')
     D system          S               O   CLASS(*JAVA:'java.lang.String')
     D matchcode       S               O   CLASS(*JAVA:'java.lang.String')
     D string5         S               O   CLASS(*JAVA:'java.lang.String')
     D strsrvnam       S               O   CLASS(*JAVA:'java.lang.String')
     D strdbname       S               O   CLASS(*JAVA:'java.lang.String')
     D strusrnam       S               O   CLASS(*JAVA:'java.lang.String')
     D strpasswd       S               O   CLASS(*JAVA:'java.lang.String')
 
     D OkS             S             10I 0
     D float1          S              8F
     D packed1         S              8P 2
     D AmtStrNeg       S             20A
     D AmtStrPos       S             19A
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
 
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Do not process watch list checking if string to be checked is*BLANKS
 
     C                   IF        SrchStrng <> *Blanks
 
      ** Add End Tag to end of string
 
     C                   CAT       '<End>':0     SrchStrng
     C                   CAT       '</End>':0    SrchStrng
 
      ** Log the record temporarily as unconfirmed
 
     C                   EVAL      WFUNC = W4FUNT
     C                   EVAL      WIDNT = W4IDEN
     C                   EVAL      WBRCA = W4BRCH
 
     C     KWTCHL        CHAIN     SDCWHTL3
     C                   IF        NOT %FOUND(SDCWHTL3)
     C                   EVAL      W3FUNT = W4FUNT
     C                   EVAL      W3IDEN = W4IDEN
     C                   EVAL      W3BRCH = W4BRCH
     C                   EVAL      W3HSTS = *BLANKS
     C                   EVAL      W3UNCF = 'Y'
     C                   EVAL      W3TREL = *BLANK
     C                   EVAL      W3LWCD = *ZEROS
     C                   WRITE     SDCWHTD0
     C                   ELSE
 
     C                   EVAL      W3UNCF = 'Y'
     C                   EVAL      W3TREL = *BLANK
     C                   UPDATE    SDCWHTD0
     C                   ENDIF
 
      ** Extract the Field names and the Field contents into arrays
 
     C                   EXSR      SrExtStr
 
     ** Build the string to be passed to the OFAC-agent and to the Case
     ** Management together with the starting position of each field
 
     C                   EXSR      SRBuild
 
      ** Check OFAC-AGENT Server is initialise and ready to process requests
 
     C                   IF        PServ =  *NULL
     C                   EVAL      PRetCode = '*ERROR'
     C                   MOVE      res           result
     C                   GOTO      EndMain
     C                   ENDIF
 
     C                   EVAL      chkstr  = OFACString
 
      ** Scan data with parsing mode 'FOF_COMM_WHOLE'
 
     C                   MOVEL     'CK'          Action
     C                   EVAL      res=FofExec(PServ:1:chkstr:'TEST':'T':
     C                                            1)
 
      ***If*error*on*call*to*FofExec*return*to*calling*program******                          221934
      ** If error on call to FofExec keep trying for 60 seconds                               221934
 
     C     res           IFNE      *zero                                                      221934
      *                                                                                       221934
     C                   EVAL      Q = 0                                                      221934
     C                   EVAL      QCMD = 'DLYJOB +                                           221934
     C                                      DLY(10)'                                          221934
     C                   EVAL      QLEN = 80                                                  221934
      *                                                                                       221934
     C                   DOU       Q > 12 or                                                  221934
     C                             res = *zero                                                221934
      *                                                                                       221934
     C                   CALL      'QCMDEXC'                                                  221934
     C                   PARM                    QCMD                                         221934
     C                   PARM                    QLEN                                         221934
      *                                                                                       221934
     C                   EVAL      res=FofExec(PServ:1:chkstr:'TEST':'T':                     221934
     C                                            1)                                          221934
     C                   EVAL      Q = Q + 1                                                  221934
      *                                                                                       221934
     C                   ENDDO                                                                221934
      *                                                                                       221934
      ** If still problems calling FoFExec then return to calling program                     221934
     C     res           IFNE      *zero
     C                   EVAL      PRetCode = '*FOFEXE'
     C                   GOTO      EndMain
     C                   ENDIF
      *                                                                                       221934
     C                   ENDIF                                                                221934
 
      **  Get Status of data scan
 
     C                   MOVEL     'ST'          Action
     C                   EVAL      res=FofRStatus(PServ)
     C                   MOVE      res           result
 
     C                   SELECT
 
      ** No suspect detected
 
     C                   WHEN      res = *Zero
     C                   EVAL      WFUNC = W4FUNT
     C                   EVAL      WIDNT = W4IDEN
     C                   EVAL      WBRCA = W4BRCH
 
     C     KWTCHL        CHAIN     SDCWHTL3
     C                   IF        %FOUND(SDCWHTL3)
     C                   IF        W3HSTS = *BLANKS
     C                   DELETE    SDCWHTD0
     C                   ELSE
     C                   EVAL      W3UNCF = *BLANK
     C                   EVAL      W3TREL = *BLANKS
     C                   EVAL      W3LWCD = AGRDNB
     C                   UPDATE    SDCWHTD0
     C                   ENDIF
     C                   ENDIF
 
      ** Suspect detected
 
     C                   WHEN      res > *Zero
     C                   EXSR      SRHitlist
 
      ** Otherwise
 
     C                   ENDSL
 
     C                   ENDIF
 
     C     EndMain       TAG
     C                   RETURN
 
     C
     C
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRExtStr - Subroutine to Extract Field names and Field        *
      *            contents into arrays                               *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRExtStr      BEGSR
     C
     C                   EVAL      @FLDNAM = *BLANK
     C                   EVAL      @ENDELM = *BLANK
 
     C     '<'           SCAN      SrchStrng     S
     C     '>'           SCAN      SrchStrng     E
     C                   EVAL      @FLDNAM = %SUBST(SrchStrng:S+1:E-S-1)
     C                   EVAL      @ENDELM = '</' + %TRIMR(@FLDNAM) + '>'
     C                   EVAL      C = %SCAN(%TRIMR(@ENDELM):SrchStrng:E)
     C                   EVAL      I = 1
      *
     C                   DOW       @ENDELM <> '</End>' AND @ENDELM <> *BLANK
     C                             AND I <= 99
     C                   EVAL      @Fldname(I) = @FLDNAM
     C                   EVAL      @FldCont(I) = %SUBST(SrchStrng:E+1:C-E-1)
     C                   EVAL      I = I + 1
     C                   EVAL      D = C+1
     C     '<'           SCAN      SrchStrng:D   S
     C     '>'           SCAN      SrchStrng:S   E
     C                   EVAL      @FLDNAM = *BLANK
     C                   EVAL      @ENDELM = *BLANK
     C                   EVAL      @FLDNAM = %SUBST(SrchStrng:S+1:E-S-1)
     C                   EVAL      @ENDELM = '</' + %TRIMR(@FLDNAM) + '>'
     C                   EVAL      C = %SCAN(%TRIMR(@ENDELM):SrchStrng:E)
     C                   ENDDO
 
     C                   IF        I > 99
     C                   EVAL      PMsgId = 'USR9689'
     C                   EXSR      SrSndMsg
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Subroutine to Build the string to be passed to OFAC *
      *           agent and to the Case Management as well as the     *
      *           starting position of each field content in those    *
      *           strings.                                            *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
      *
      ** Initialise fields
     C
     C                   EVAL      OFACString = *Blanks
     C                   EVAL      CAString = *Blanks
     C                   Z-ADD     1             X
     C                   DOW       X <= 30
     C                   EVAL      OFACPos(X) = *ZEROS
     C                   EVAL      CAPos(X) = *ZEROS
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   EVAL      OFACStartPos = 1
     C                   EVAL      CAStartPos = 1
 
     C                   EVAL      X = 1
     C                   EVAL      I = I - 1
     C     1             DO        I
     C                   EVAL      WFldname = @Fldname(X)
     C                   EVAL      WFldCont = @FldCont(X)
     C                   EVAL      CAString = %TRIM(CAString)+
     C                             %TRIM(WFldname) + X'05'
     C                   EVAL      CAStartPos = CAStartPos +
     C                             %LEN(%TRIM(WFldname)) + 1
     C                   EVAL      CAPos(X) = CAStartPos
     C                   EVAL      OFACPos(X) = OFACStartPos
 
     C                   EVAL      CAString = %TRIM(CAString) +
     C                              %TRIM(WFldCont) + X'0D25'
     C                   EVAL      CAStartPos = CAStartPos +
     C                             (%LEN(%TRIM(WFldCont)) + 2)
     C                   IF        X = 1
     C                   EVAL      OFACString = %TRIM(WfldCont)
     C                   ELSE
     C                   EVAL      OFACString = %TRIM(OFACString) +  ' ' +
     C                             %TRIM(WFldCont)
     C                   ENDIF
     C                   EVAL      OFACStartPos = OFACStartPos +
     C                             %LEN(%TRIM(WFldCont)) + 1
     C                   EVAL      X = X + 1
     C                   ENDDO
      *
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRHitList - Subroutine to Process hit where the string passed *
      *             is one of the hit list.                           *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRHitList     BEGSR
 
      ** Check Compliance Alert Server Identifier, Alert Database Name,                       CSD019
      ** Alert User Name, Alert User Password when CSD019 is not installed                    CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'N'                                               CSD019
                                                                                              CSD019
     C                   IF        W1CASR = *BLANKS
     C                   EVAL      PretCode = '*SRVNAM'
     C                   GOTO      EndHitL
     C                   ENDIF
 
     C                   IF        W1CADB = *BLANKS
     C                   EVAL      PretCode = '*DBNAME'
     C                   GOTO      EndHitL
     C                   ENDIF
 
     C                   IF        W1CAUS = *BLANKS
     C                   EVAL      PretCode = '*USRNAM'
     C                   GOTO      EndHitL
     C                   ENDIF
 
     C**********         IF        W1CAPW = *BLANKS                                           CSD101
     C**********         EVAL      PretCode = '*PASSWD'                                       CSD101
     C**********         GOTO      EndHitL                                                    CSD101
     C**********         ENDIF                                                                CSD101
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
 
     C                   IF        W4SYSM = *BLANKS
     C                   EVAL      PretCode = '*SYSTEM'
     C                   GOTO      EndHitL
     C                   ENDIF
 
     C                   IF        W4ITEM = *BLANKS
     C                   EVAL      PretCode = '*ITEM'
     C                   GOTO      EndHitL
     C                   ENDIF
 
     C                   IF        W4IDEN = *BLANKS
     C                   EVAL      PretCode = '*IDENFR'
     C                   GOTO      EndHitL
     C                   ENDIF
 
     C                   IF        W4BRCH = *BLANKS
     C                   EVAL      PretCode = '*BRANCH'
     C                   GOTO      EndHitL
     C                   ENDIF
 
      ** Replace "'" with "`" on all strings to be checked:
 
     C     '''':'`'      XLATE     W4ITEM        W4ITEM
     C     '''':'`'      XLATE     W4IDEN        W4IDEN
     C     '''':'`'      XLATE     W4BRCH        W4BRCH
     C     '''':'`'      XLATE     W4SYSM        W4SYSM
     C     '''':'`'      XLATE     W4CNUM        W4CNUM
     C     '''':'`'      XLATE     W4CTYP        W4CTYP
     C     '''':'`'      XLATE     W4CUST        W4CUST
     C     '''':'`'      XLATE     W4DEN1        W4DEN1
     C     '''':'`'      XLATE     W4DEN2        W4DEN2
     C     '''':'`'      XLATE     W4FUNT        W4FUNT
 
     C                   IF        CSD019 = 'N'                                               CSD019
                                                                                              CSD019
      ** string are considered as objects in JAVA, use makestring method to create the
      ** object necessary to pass to other methods anticipating string objects
 
     C                   eval      itemTypeCode = makestr(%TRIM(W4ITEM))
     C                   eval      identifier = makestr(%TRIM(W4IDEN))
     C                   eval      branch = makestr(%TRIM(W4BRCH))
     C                   eval      system = makestr(%TRIM(W4SYSM))
 
      ** Define object for connection
 
     C                   eval      strsrvnam=makestr(%TRIM(W1CASR))
     C                   eval      strdbname=makestr(%TRIM(W1CADB))
     C                   eval      strusrnam=makestr(%TRIM(W1CAUS))
     C                   EVAL      Password = *Blanks                                         CSD101
                                                                                              CSD101
      ** Check if ID exists                                                                   CSD101
                                                                                              CSD101
     C                   IF        W1CAUS <> *BLANKS                                          CSD101
     C                   EVAL      PLibrary = LIBR + 'DMLIB'                                  CSD101
     C                   EVAL      PIDName = 'COMPLWATCH_' + W1CAUS                           CSD101
                                                                                              CSD101
     C                   CALL      'SD000404'                                                 CSD101
     C                   PARM      *Blanks       PReturnCode                                  CSD101
     C                   PARM      'F'           PAction                                      CSD101
     C                   PARM                    PValidList                                   CSD101
     C                   PARM                    PLibrary                                     CSD101
     C                   PARM                    PIDName                                      CSD101
     C                   PARM      *Blanks       PPass1                                       CSD101
     C                   PARM      *Blanks       PDescr                                       CSD101
                                                                                              CSD101
     C                   IF        PReturnCode = *Blanks                                      CSD101
     C                   EVAL      Password = PPass1                                          CSD101
     C                   ENDIF                                                                CSD101
     C                   ENDIF                                                                CSD101
     C**********         eval      strpasswd=makestr(%TRIM(W1CAPW))                           CSD101
     C                   eval      strpasswd=makestr(%TRIM(Password))                         CSD101
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   eval      hits=FofRHn(PServ)
     C                   eval      OkS=0
 
     C                   DO        hits          X
      *
      ** Retrieve next available case number
      *
     C                   MOVEL     *BLANKS       ofacid
     C                   MOVEL     *BLANKS       ofname
     C                   Z-ADD     *ZERO         hitstart
     C                   Z-ADD     *ZERO         hitend
     C                   ADD       1             Sequence
 
      ** get OFACID
 
     C                   EVAL      ofacid=%STR(FofRhofacIdI(PServ:X-1))
 
      ** get Name of Hit
 
     C                   EVAL      ofname=%STR(FofRHnameI(PServ:X-1))
     C     '''':'`'      XLATE     ofname        ofname
 
      ** get Start position of Hit in Input Text
 
     C                   EVAL      hitstart(1)=(FofRHposIJK(PServ:X-1:0:0)+1)
 
      ** get End position of Hit in Input Text
 
     C                   EVAL      hitend(1)=(FofRHposIJK(PServ:X-1:0:1)+1)
 
      ** get Address of Hit
 
     C                   EVAL      ofAddr=%STR(FofRHaddressI(PServ:X-1))
     C     '''':'`'      XLATE     ofAddr        ofAddr
 
      ** get Start position of Hit in Input Text
 
     C                   IF        ofAddr <> *BLANKS
     C                   EVAL      hitstart(2)=(FofRHposIJK(PServ:X-1:1:0)+1)
 
      ** get End position of Hit in Input Text
 
     C                   EVAL      hitEnd(2)=(FofRHposIJK(PServ:X-1:1:1)+1)
     C                   ENDIF
 
      ** get City
 
     C                   EVAL      ofcity=%STR(FofRHcityI(PServ:X-1))
     C     '''':'`'      XLATE     ofcity        ofcity
 
      ** get Start position of Hit in Input Text
 
     C                   IF        ofcity <> *BLANKS
     C                   EVAL      hitstart(3)=(FofRHposIJK(PServ:X-1:2:0)+1)
 
      ** get End position of Hit in Input Text
 
     C                   EVAL      hitend(3)=(FofRHposIJK(PServ:X-1:2:1)+1)
     C                   ENDIF
 
      ** get Country of Hit
 
     C                   EVAL      ofCntry=%STR(FofRHcountryI(PServ:X-1))
     C     '''':'`'      XLATE     ofCntry       ofCntry
 
      ** get Start position of Hit in Input Text
 
     C                   IF        ofCntry <> *BLANKS
     C                   EVAL      hitstart(4)=(FofRHposIJK(PServ:X-1:3:0)+1)
 
      ** get End position of Hit in Input Text
 
     C                   EVAL      hitend(4)=(FofRHposIJK(PServ:X-1:3:1)+1)
     C                   ENDIF
 
      ** get Origin
 
     C                   EVAL      oforigin=%STR(FofRHoriginI(PServ:X-1))
     C     '''':'`'      XLATE     oforigin      oforigin
 
      ** get Designation
 
     C                   EVAL      ofDesgn=%STR(FofRHdesigI(PServ:X-1))
     C     '''':'`'      XLATE     ofDesgn       ofDesgn
 
      ** get User Data 1
 
     C                   EVAL      ofusrdta1=%STR(FofRHuser1I(PServ:X-1))
     C     '''':'`'      XLATE     ofusrdta1     ofusrdta1
 
      ** get User Data 2
 
     C                   EVAL      ofusrdta2=%STR(FofRHuser2I(PServ:X-1))
     C     '''':'`'      XLATE     ofusrdta2     ofusrdta2
 
      ** get Search codes
 
     C                   EVAL      ofsrchcde=%STR(FofRHsearchkI(PServ:X-1))
     C     '''':'`'      XLATE     ofsrchcde     ofsrchcde
 
     C                   CLEAR                   numsyn
      ** get number of name synonyms
 
     C                   EVAL      numsyn(1)=(FofRHnSynnameI(PServ:X-1))
 
      ** for each name synonym, get the details
 
     C                   DO        numsyn(1)     Y
     C                   EVAL      NameSyn(Y)=%STR(FofRHsynNameIJ
     C                                        (PServ:X-1:Y-1))
     C     '''':'`'      XLATE     NameSyn(Y)    NameSyn(Y)
     C                   ENDDO
 
      ** get number of name address synonyms
 
     C                   EVAL      numsyn(2)=(FofRHnSynAddrI(PServ:X-1))
 
      ** for each address synonym, get the details
 
     C                   DO        numsyn(2)     Y
     C                   EVAL      AdrSyn(Y)=%STR(FofRHsynAddIJ(PServ:X-1:Y-1))
     C     '''':'`'      XLATE     AdrSyn(Y)     AdrSyn(Y)
     C                   ENDDO
 
      ** get number of city synonyms
 
     C                   EVAL      numsyn(3)=(FofRHnSynCityI(PServ:X-1))
 
      ** for each city synonym, get the details
 
     C                   DO        numsyn(3)     Y
     C                   EVAL      CitySyn(Y)=%STR(FofRHsynCityIJ
     C                                        (PServ:X-1:Y-1))
     C     '''':'`'      XLATE     CitySyn(Y)    CitySyn(Y)
     C                   ENDDO
 
      ** get number of country synonyms
 
     C                   EVAL      numsyn(4)=(FofRHnSynCtryI(PServ:X-1))
 
      ** for each city synonym, get the details
 
     C                   DO        numsyn(4)     Y
     C                   EVAL      CtrySyn(Y)=%STR(FofRHsynCtryIJ
     C                                        (PServ:X-1:Y-1))
     C     '''':'`'      XLATE     CtrySyn(Y)    CtrySyn(Y)
     C                   ENDDO
 
      ** retrieve last case match code number
 
     C     1             CHAIN     SDWLCSPD
     C                   IF        NOT %FOUND(SDWLCSPD)
     C                   EVAL      W5NXCN = 1
     C                   ENDIF
      *
     C                   EVAL      WMTCHCD = W4SYSM
     C                   MOVE      W5NXCN        WMTCHCD
     C                   eval      matchcode = makestr(%TRIM(WMTCHCD))
 
      ** constructing a case, this should always be the very first method to call
 
     C                   eval      caseobject = createcase(matchcode:
     C                                          itemTypeCode:identifier:
     C                                          branch:system)
      *
     C                   IF        W5NXCN < 9999999999
     C                   EVAL      W5NXCN = W5NXCN + 1
     C                   ELSE
     C                   EVAL      W5NXCN = 1
     C                   ENDIF
                                                                                              CSD019
      ** For each hit position, get the corresponding positions in the                        CSD019
      ** CAString.                                                                            CSD019
                                                                                              CSD019
     C                   DO        4             Y                                            CSD019
     C                   EVAL      WMtchStr(Y) = 0                                            CSD019
     C                   EVAL      WMtchEnd(Y) = 0                                            CSD019
      ** start position                                                                       CSD019
     C                   IF        hitstart(Y) > *ZEROS                                       CSD019
     C                   EVAL      Ctr = 1                                                    CSD019
     C                   DOW       hitstart(Y) >= OFACPos(Ctr)  AND                           CSD019
     C                             OFACPos(Ctr) <> *ZEROS                                     CSD019
     C                   EVAL      Ctr = Ctr + 1                                              CSD019
     C                   ENDDO                                                                CSD019
     C                   EVAL      Ctr = Ctr - 1                                              CSD019
     C                   EVAL      WDIFF = hitstart(Y) - OFACPos(Ctr)                         CSD019
     C                   EVAL      WMtchStr(Y) =  CAPos(Ctr) + WDIFF                          CSD019
     C                   ENDIF                                                                CSD019
      ** end position                                                                         CSD019
     C                   IF        hitend(Y) > *ZEROS                                         CSD019
     C                   EVAL      Ctr = 1                                                    CSD019
     C                   DOW       hitend(Y) >= OFACPos(Ctr)  AND                             CSD019
     C                             OFACPos(Ctr) <> *ZEROS                                     CSD019
     C                   EVAL      Ctr = Ctr + 1                                              CSD019
     C                   ENDDO                                                                CSD019
     C                   EVAL      Ctr = Ctr - 1                                              CSD019
     C                   EVAL      WDIFF = hitend(Y) - OFACPos(Ctr)                           CSD019
     C                   EVAL      WMtchEnd(Y) =  CAPos(Ctr) + WDIFF                          CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDDO                                                                CSD019
 
      ** Update Case number file
 
     C                   IF        %FOUND(SDWLCSPD)
     C                   UPDATE    SDWLCSD0
     C                   ELSE
     C                   WRITE     SDWLCSD0
     C                   ENDIF
                                                                                              CSD019
      ** The following codes have been moved to SRRemote                                      CSD019
                                                                                              CSD019
      ***-----------------*********************************************                       CSD019
      ***Enhancement data**********************************************                       CSD019
      ***-----------------*********************************************                       CSD019
      **********                                                                              CSD019
      ***set*counterparty*number***************************************                       CSD019
     C**********         IF        W4CNUM <> *BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(W4CNUM))                           CSD019
     C**********         callp     setctrpartyn(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*counterparty*type*****************************************                       CSD019
     C**********         IF        W4CTYP <> *BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(W4CTYP))                           CSD019
     C**********         callp     setctrpartyt(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*counterparty*name*****************************************                       CSD019
     C**********         IF        W4CUST <> *BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(W4CUST))                           CSD019
     C**********         callp     setctrparty(caseobject:string5)                            CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*deal*date*************************************************                       CSD019
     C**********         Move      W4DDAT        WAlp10                                       CSD019
     C**********         IF        WAlp10 <> '0001-01-01'                                     CSD019
     C**********         eval      string5 = makestr(WAlp10)                                  CSD019
     C**********         callp     setdealdate(caseobject:string5)                            CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*value*date************************************************                       CSD019
     C**********         Move      W4VDAT        WAlp10                                       CSD019
     C**********         IF        WAlp10 <> '0001-01-01'                                     CSD019
     C**********         eval      string5 = makestr(WAlp10)                                  CSD019
     C**********         callp     setvaluedate(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*maturity*date*********************************************                       CSD019
     C**********         Move      W4MDAT        WAlp10                                       CSD019
     C**********         IF        WAlp10 <> '0001-01-01'                                     CSD019
     C**********         eval      string5 = makestr(WAlp10)                                  CSD019
     C**********         callp     setmaturedate(caseobject:string5)                          CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*denomination*side*1***************************************                       CSD019
     C**********         IF        W4DEN1 <> *BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(W4DEN1))                           CSD019
     C**********         callp     setdenoside1(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*denomination*side*2***************************************                       CSD019
     C**********         IF        W4DEN2 <> *BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(W4DEN2))                           CSD019
     C**********         callp     setdenoside2(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*amount*1**************************************************                       CSD019
     C**********         IF        W4AMT1 <> *Zeros                                           CSD019
     C**********         IF        W4AMT1 < *Zeros                                            CSD019
     C**********         Z-SUB     W4AMT1        WAMTPS                                       CSD019
     C**********         MOVE      WAmtPs        AmtString                                    CSD019
     C**********         EVAL      AmtStrNeg = '-' + WInteger + '.' + WDecimal                CSD019
     C**********         eval      string5 = makestr(AmtStrNeg)                               CSD019
     C**********         ELSE                                                                 CSD019
     C**********         MOVE      W4AMT1        AmtString                                    CSD019
     C**********         EVAL      AmtStrPos = WInteger + '.' + WDecimal                      CSD019
     C**********         eval      string5 = makestr(AmtStrPos)                               CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
     C**********         callp     setamount1(caseobject:string5)                             CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*amount*2**************************************************                       CSD019
     C**********         IF        W4AMT2 <> *Zeros                                           CSD019
     C**********         IF        W4AMT2 < *Zeros                                            CSD019
     C**********         Z-SUB     W4AMT2        WAMTPS                                       CSD019
     C**********         MOVE      WAmtPs        AmtString                                    CSD019
     C**********         EVAL      AmtStrNeg = '-' + WInteger + '.' + WDecimal                CSD019
     C**********         eval      string5 = makestr(AmtStrNeg)                               CSD019
     C**********         ELSE                                                                 CSD019
     C**********         MOVEL     W4AMT2        AmtString                                    CSD019
     C**********         EVAL      AmtStrPos = WInteger + '.' + WDecimal                      CSD019
     C**********         eval      string5 = makestr(AmtStrPos)                               CSD019
     C**********         ENDIF                                                                CSD019
     C**********         callp     setamount2(caseobject:string5)                             CSD019
     C**********         ENDIF                                                                CSD019
      ***-----------***************************************************                       CSD019
      ***Search*data***************************************************                       CSD019
      ***-----------***************************************************                       CSD019
     C**********         IF        CAString <> *BLANKS                                        CSD019
     C*****'''':'`'      XLATE     CAString      CAString                                     CSD019
     C*****'?':' '       XLATE     CAString      CAString                                     CSD019
     C**********         eval      string5 = makestr(%TRIM(CAString))                         CSD019
     C**********         callp     setsearchdata(caseobject:string5)                          CSD019
     C**********         ENDIF                                                                CSD019
      ***------------**************************************************                       CSD019
      ***Control*data**************************************************                       CSD019
      ***------------**************************************************                       CSD019
      **********                                                                              CSD019
      ***set*function*type*********************************************                       CSD019
     C**********         IF        W4FUNT <> *BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(W4FUNT))                           CSD019
     C**********         callp     setfunction(caseobject:string5)                            CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      **********                                                                              CSD019
      ** For*each*hit*position,*get*the*corresponding*positions*in*the*                       CSD019
      ***CAString.*****************************************************                       CSD019
      **********                                                                              CSD019
     C**********         DO        4             Y                                            CSD019
     C**********         EVAL      WMtchStr(Y) = 0                                            CSD019
     C**********         EVAL      WMtchEnd(Y) = 0                                            CSD019
      ***start*position************************************************                       CSD019
     C**********         IF        hitstart(Y) > *ZEROS                                       CSD019
     C**********         EVAL      Ctr = 1                                                    CSD019
     C**********         DOW       hitstart(Y) >= OFACPos(Ctr)  AND                           CSD019
     C**********                   OFACPos(Ctr) <> *ZEROS                                     CSD019
     C**********         EVAL      Ctr = Ctr + 1                                              CSD019
     C**********         ENDDO                                                                CSD019
     C**********         EVAL      Ctr = Ctr - 1                                              CSD019
     C**********         EVAL      WDIFF = hitstart(Y) - OFACPos(Ctr)                         CSD019
     C**********         EVAL      WMtchStr(Y) =  CAPos(Ctr) + WDIFF                          CSD019
     C**********         ENDIF                                                                CSD019
      ***end*position**************************************************                       CSD019
     C**********         IF        hitend(Y) > *ZEROS                                         CSD019
     C**********         EVAL      Ctr = 1                                                    CSD019
     C**********         DOW       hitend(Y) >= OFACPos(Ctr)  AND                             CSD019
     C**********                   OFACPos(Ctr) <> *ZEROS                                     CSD019
     C**********         EVAL      Ctr = Ctr + 1                                              CSD019
     C**********         ENDDO                                                                CSD019
     C**********         EVAL      Ctr = Ctr - 1                                              CSD019
     C**********         EVAL      WDIFF = hitend(Y) - OFACPos(Ctr)                           CSD019
     C**********         EVAL      WMtchEnd(Y) =  CAPos(Ctr) + WDIFF                          CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
     C**********         ENDDO                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*1*start****************************************                       CSD019
     C**********         IF        WMtchStr(1) <> *ZEROS                                      CSD019
     C**********         callp     setmatch1s(caseobject:WMtchStr(1))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*1*end******************************************                       CSD019
     C**********         IF        WMtchEnd(1) <> *ZEROS                                      CSD019
     C**********         callp     setmatch1e(caseobject:WMtchEnd(1))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*2*start****************************************                       CSD019
     C**********         IF        WMtchStr(2) <> *ZEROS                                      CSD019
     C**********         callp     setmatch2s(caseobject:WMtchStr(2))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*2*end******************************************                       CSD019
     C**********         IF        WMtchEnd(2) <> *ZEROS                                      CSD019
     C**********         callp     setmatch2e(caseobject:WMtchEnd(2))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*3*start****************************************                       CSD019
     C**********         IF        WMtchStr(3) <> *ZEROS                                      CSD019
     C**********         callp     setmatch3s(caseobject:WMtchStr(3))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*3*end******************************************                       CSD019
     C**********         IF        WMtchEnd(3) <> *ZEROS                                      CSD019
     C**********         callp     setmatch3e(caseobject:WMtchEnd(3))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*4*start****************************************                       CSD019
     C**********         IF        WMtchStr(4) <> *ZEROS                                      CSD019
     C**********         callp     setmatch4s(caseobject:WMtchStr(4))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*name*match*4*end******************************************                       CSD019
     C**********         IF        WMtchEnd(4) <> *ZEROS                                      CSD019
     C**********         callp     setmatch4e(caseobject:WMtchEnd(4))                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      **********                                                                              CSD019
      ***set*watch*list*identifier*************************************                       CSD019
     C**********         IF        ofacid <>*BLANKS                                           CSD019
     C**********         eval      string5 = makestr(%TRIM(ofacid))                           CSD019
     C**********         callp     setwlidentify(caseobject:string5)                          CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*watch*list*origin*****************************************                       CSD019
     C**********         IF        oforigin <>*BLANKS                                         CSD019
     C**********         eval      string5 = makestr(%TRIM(oforigin))                         CSD019
     C**********         callp     setwlorigin(caseobject:string5)                            CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*entry*type************************************************                       CSD019
     C**********         IF        ofdesgn <>*BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(ofdesgn))                          CSD019
     C**********         callp     settype(caseobject:string5)                                CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*entry*name************************************************                       CSD019
     C**********         IF        ofname <>*BLANKS                                           CSD019
     C**********         eval      string5 = makestr(%TRIM(ofname))                           CSD019
     C**********         callp     setentryname(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***add*user*name*to*name*array***********************************                       CSD019
      **********                                                                              CSD019
     C**********         DO        numsyn(1)     Y                                            CSD019
     C**********         IF        NameSyn(Y) <>*BLANKS                                       CSD019
     C**********         eval      string5 = makestr(%TRIM(NameSyn(Y)))                       CSD019
     C**********         callp     addname(caseobject:string5)                                CSD019
     C**********         ENDIF                                                                CSD019
     C**********         ENDDO                                                                CSD019
      **********                                                                              CSD019
      ***set*entry*address*********************************************                       CSD019
     C**********         IF        ofaddr <>*BLANKS                                           CSD019
     C**********         eval      string5 = makestr(%TRIM(ofaddr))                           CSD019
     C**********         callp     setentryaddres(caseobject:string5)                         CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***add*alternative*address*to*address*array**********************                       CSD019
      **********                                                                              CSD019
     C**********         DO        numsyn(2)     Y                                            CSD019
     C**********         IF        AdrSyn(Y) <>*BLANKS                                        CSD019
     C**********         eval      string5 = makestr(%TRIM(AdrSyn(Y)))                        CSD019
     C**********         callp     addaddress(caseobject:string5)                             CSD019
     C**********         ENDIF                                                                CSD019
     C**********         ENDDO                                                                CSD019
      **********                                                                              CSD019
      ***set*entry*city************************************************                       CSD019
     C**********         IF        ofcity <>*BLANKS                                           CSD019
     C**********         eval      string5 = makestr(%TRIM(ofcity))                           CSD019
     C**********         callp     setentrycity(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***add*alternative*city*to*city*array****************************                       CSD019
      **********                                                                              CSD019
     C**********         DO        numsyn(3)     Y                                            CSD019
     C**********         IF        CitySyn(Y) <>*BLANKS                                       CSD019
     C**********         eval      string5 = makestr(%TRIM(CitySyn(Y)))                       CSD019
     C**********         callp     addcity(caseobject:string5)                                CSD019
     C**********         ENDIF                                                                CSD019
     C**********         ENDDO                                                                CSD019
      **********                                                                              CSD019
      ***set*entry*country*********************************************                       CSD019
     C**********         IF        ofCntry <>*BLANKS                                          CSD019
     C**********         eval      string5 = makestr(%TRIM(ofCntry))                          CSD019
     C**********         callp     setcountry(caseobject:string5)                             CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***add*alternative*country*to*country*array**********************                       CSD019
      **********                                                                              CSD019
     C**********         DO        numsyn(4)     Y                                            CSD019
     C**********         IF        CtrySyn(Y) <>*BLANKS                                       CSD019
     C**********         eval      string5 = makestr(%TRIM(CtrySyn(Y)))                       CSD019
     C**********         callp     addcountry(caseobject:string5)                             CSD019
     C**********         ENDIF                                                                CSD019
     C**********         ENDDO                                                                CSD019
      **********                                                                              CSD019
      ***set*Watch*list*codes******************************************                       CSD019
     C**********         IF        ofsrchcde <>*BLANKS                                        CSD019
     C**********         eval      string5 = makestr(%TRIM(ofsrchcde))                        CSD019
     C**********         callp     setcodes(caseobject:string5)                               CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*user*data*1***********************************************                       CSD019
     C**********         IF        ofusrdta1 <>*BLANKS                                        CSD019
     C**********         eval      string5 = makestr(%TRIM(ofusrdta1))                        CSD019
     C**********         callp     setuserdata1(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***set*user*data*2***********************************************                       CSD019
     C**********         IF        ofusrdta2 <>*BLANKS                                        CSD019
     C**********         eval      string5 = makestr(%TRIM(ofusrdta2))                        CSD019
     C**********         callp     setuserdata2(caseobject:string5)                           CSD019
     C**********         ENDIF                                                                CSD019
      **********                                                                              CSD019
      ***insert*case,*actually*writes*record*to*SQL*database***********                       CSD019
      **********                                                                              CSD019
     C**********         EVAL      OkS = insertcase(caseobject:strsrvnam:                     CSD019
     C**********                   strdbname:strusrnam:strpasswd)                             CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'N'                                               CSD019
                                                                                              CSD019
     C                   EXSR      SRRemote                                                   CSD019
 
      ** If errors encountered during insertion of record to SQL database, exit loop.
     C                   IF        Oks <> 0
     C                   LEAVE
     C                   ENDIF
                                                                                              CSD019
     C                   ELSE                                                                 CSD019
                                                                                              CSD019
     C                   EXSR      SRLocal                                                    CSD019
                                                                                              CSD019
      ** If errors encountered during insertion of record to SQL database, exit loop.         CSD019
                                                                                              CSD019
     C                   IF        Oks <> 0                                                   CSD019
     C                   LEAVE                                                                CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDIF                                                                CSD019
 
     C                   ENDDO
      *
      ** Log the status of the record
 
     C                   EVAL      WFUNC = W4FUNT
     C                   EVAL      WIDNT = W4IDEN
     C                   EVAL      WBRCA = W4BRCH
 
     C     KWTCHL        CHAIN     SDCWHTL3
     C                   IF        NOT %FOUND(SDCWHTL3)
     C                   EVAL      W3FUNT = W4FUNT
     C                   EVAL      W3IDEN = W4IDEN
     C                   EVAL      W3BRCH = W4BRCH
     C                   EVAL      W3HSTS = 'INVESTIGTN'
     C                   EVAL      W3UNCF = *BLANK
     C                   EVAL      W3TREL = *BLANK
     C                   EVAL      W3LWCD = AGRDNB
     C                   WRITE     SDCWHTD0
     C                   ELSE
 
     C                   IF        W3HSTS <> 'TRUEPOSITV'
     C                   EVAL      W3HSTS = 'INVESTIGTN'
     C                   ENDIF
     C                   EVAL      W3UNCF = *BLANK
     C                   EVAL      W3TREL = *BLANK
     C                   EVAL      W3LWCD = AGRDNB
     C                   UPDATE    SDCWHTD0
     C                   ENDIF
 
      * Close connection with server
 
     C     EndHitL       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndMsg - Send error message to MOPERQ                       *
      *                                                               *
      *****************************************************************
 
     C     SRSndMsg      BEGSR
 
     C                   CALLB     'ZAMSGTOMSQ'
     C                   PARM                    PReturnCode
     C                   PARM      'SDWLENGN'    PMsg
     C                   PARM                    PMsgId
     C                   PARM      'GBSDUSRMSG'  PMsgF
     C                   PARM      'MOPERQ    '  PMsgQ
 
     C                   ENDSR
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRRemote - Populate fields in Compliance Watch Case for      *                       CSD019
      *             Java processing                                   *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRRemote      BEGSR                                                                CSD019
                                                                                              CSD019
      *  -----------------                                                                    CSD019
      ** Enhancement data                                                                     CSD019
      *  -----------------                                                                    CSD019
                                                                                              CSD019
      ** set counterparty number                                                              CSD019
                                                                                              CSD019
     C                   IF        W4CNUM <> *BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(W4CNUM))                           CSD019
     C                   callp     setctrpartyn(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set counterparty type                                                                CSD019
                                                                                              CSD019
     C                   IF        W4CTYP <> *BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(W4CTYP))                           CSD019
     C                   callp     setctrpartyt(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set counterparty name                                                                CSD019
                                                                                              CSD019
     C                   IF        W4CUST <> *BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(W4CUST))                           CSD019
     C                   callp     setctrparty(caseobject:string5)                            CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set deal date                                                                        CSD019
                                                                                              CSD019
     C                   Move      W4DDAT        WAlp10                                       CSD019
     C                   IF        WAlp10 <> '0001-01-01'                                     CSD019
     C                   eval      string5 = makestr(WAlp10)                                  CSD019
     C                   callp     setdealdate(caseobject:string5)                            CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set value date                                                                       CSD019
                                                                                              CSD019
     C                   Move      W4VDAT        WAlp10                                       CSD019
     C                   IF        WAlp10 <> '0001-01-01'                                     CSD019
     C                   eval      string5 = makestr(WAlp10)                                  CSD019
     C                   callp     setvaluedate(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set maturity date                                                                    CSD019
                                                                                              CSD019
     C                   Move      W4MDAT        WAlp10                                       CSD019
     C                   IF        WAlp10 <> '0001-01-01'                                     CSD019
     C                   eval      string5 = makestr(WAlp10)                                  CSD019
     C                   callp     setmaturedate(caseobject:string5)                          CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set denomination side 1                                                              CSD019
                                                                                              CSD019
     C                   IF        W4DEN1 <> *BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(W4DEN1))                           CSD019
     C                   callp     setdenoside1(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set denomination side 2                                                              CSD019
                                                                                              CSD019
     C                   IF        W4DEN2 <> *BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(W4DEN2))                           CSD019
     C                   callp     setdenoside2(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set amount 1                                                                         CSD019
                                                                                              CSD019
     C                   IF        W4AMT1 <> *Zeros                                           CSD019
     C                   IF        W4AMT1 < *Zeros                                            CSD019
     C                   Z-SUB     W4AMT1        WAMTPS                                       CSD019
     C                   MOVE      WAmtPs        AmtString                                    CSD019
     C                   EVAL      AmtStrNeg = '-' + WInteger + '.' + WDecimal                CSD019
     C                   eval      string5 = makestr(AmtStrNeg)                               CSD019
     C                   ELSE                                                                 CSD019
     C                   MOVE      W4AMT1        AmtString                                    CSD019
     C                   EVAL      AmtStrPos = WInteger + '.' + WDecimal                      CSD019
     C                   eval      string5 = makestr(AmtStrPos)                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   callp     setamount1(caseobject:string5)                             CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set amount 2                                                                         CSD019
                                                                                              CSD019
     C                   IF        W4AMT2 <> *Zeros                                           CSD019
     C                   IF        W4AMT2 < *Zeros                                            CSD019
     C                   Z-SUB     W4AMT2        WAMTPS                                       CSD019
     C                   MOVE      WAmtPs        AmtString                                    CSD019
     C                   EVAL      AmtStrNeg = '-' + WInteger + '.' + WDecimal                CSD019
     C                   eval      string5 = makestr(AmtStrNeg)                               CSD019
     C                   ELSE                                                                 CSD019
     C                   MOVEL     W4AMT2        AmtString                                    CSD019
     C                   EVAL      AmtStrPos = WInteger + '.' + WDecimal                      CSD019
     C                   eval      string5 = makestr(AmtStrPos)                               CSD019
     C                   ENDIF                                                                CSD019
     C                   callp     setamount2(caseobject:string5)                             CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** -----------                                                                          CSD019
      ** Search data                                                                          CSD019
      ** -----------                                                                          CSD019
                                                                                              CSD019
     C                   IF        CAString <> *BLANKS                                        CSD019
     C     '''':'`'      XLATE     CAString      CAString                                     CSD019
     C     '?':' '       XLATE     CAString      CAString                                     CSD019
     C                   eval      string5 = makestr(%TRIM(CAString))                         CSD019
     C                   callp     setsearchdata(caseobject:string5)                          CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** ------------                                                                         CSD019
      ** Control data                                                                         CSD019
      ** ------------                                                                         CSD019
                                                                                              CSD019
      ** set function type                                                                    CSD019
                                                                                              CSD019
     C                   IF        W4FUNT <> *BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(W4FUNT))                           CSD019
     C                   callp     setfunction(caseobject:string5)                            CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 1 start                                                               CSD019
                                                                                              CSD019
     C                   IF        WMtchStr(1) <> *ZEROS                                      CSD019
     C                   callp     setmatch1s(caseobject:WMtchStr(1))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 1 end                                                                 CSD019
                                                                                              CSD019
     C                   IF        WMtchEnd(1) <> *ZEROS                                      CSD019
     C                   callp     setmatch1e(caseobject:WMtchEnd(1))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 2 start                                                               CSD019
                                                                                              CSD019
     C                   IF        WMtchStr(2) <> *ZEROS                                      CSD019
     C                   callp     setmatch2s(caseobject:WMtchStr(2))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 2 end                                                                 CSD019
                                                                                              CSD019
     C                   IF        WMtchEnd(2) <> *ZEROS                                      CSD019
     C                   callp     setmatch2e(caseobject:WMtchEnd(2))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 3 start                                                               CSD019
                                                                                              CSD019
     C                   IF        WMtchStr(3) <> *ZEROS                                      CSD019
     C                   callp     setmatch3s(caseobject:WMtchStr(3))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 3 end                                                                 CSD019
                                                                                              CSD019
     C                   IF        WMtchEnd(3) <> *ZEROS                                      CSD019
     C                   callp     setmatch3e(caseobject:WMtchEnd(3))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 4 start                                                               CSD019
                                                                                              CSD019
     C                   IF        WMtchStr(4) <> *ZEROS                                      CSD019
     C                   callp     setmatch4s(caseobject:WMtchStr(4))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set name match 4 end                                                                 CSD019
                                                                                              CSD019
     C                   IF        WMtchEnd(4) <> *ZEROS                                      CSD019
     C                   callp     setmatch4e(caseobject:WMtchEnd(4))                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set watch list identifier                                                            CSD019
                                                                                              CSD019
     C                   IF        ofacid <>*BLANKS                                           CSD019
     C                   eval      string5 = makestr(%TRIM(ofacid))                           CSD019
     C                   callp     setwlidentify(caseobject:string5)                          CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set watch list origin                                                                CSD019
                                                                                              CSD019
     C                   IF        oforigin <>*BLANKS                                         CSD019
     C                   eval      string5 = makestr(%TRIM(oforigin))                         CSD019
     C                   callp     setwlorigin(caseobject:string5)                            CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set entry type                                                                       CSD019
                                                                                              CSD019
     C                   IF        ofdesgn <>*BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(ofdesgn))                          CSD019
     C                   callp     settype(caseobject:string5)                                CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set entry name                                                                       CSD019
                                                                                              CSD019
     C                   IF        ofname <>*BLANKS                                           CSD019
     C                   eval      string5 = makestr(%TRIM(ofname))                           CSD019
     C                   callp     setentryname(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** add user name to name array                                                          CSD019
                                                                                              CSD019
     C                   DO        numsyn(1)     Y                                            CSD019
     C                   IF        NameSyn(Y) <>*BLANKS                                       CSD019
     C                   eval      string5 = makestr(%TRIM(NameSyn(Y)))                       CSD019
     C                   callp     addname(caseobject:string5)                                CSD019
     C                   ENDIF                                                                CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** set entry address                                                                    CSD019
                                                                                              CSD019
     C                   IF        ofaddr <>*BLANKS                                           CSD019
     C                   eval      string5 = makestr(%TRIM(ofaddr))                           CSD019
     C                   callp     setentryaddres(caseobject:string5)                         CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** add alternative address to address array                                             CSD019
                                                                                              CSD019
     C                   DO        numsyn(2)     Y                                            CSD019
     C                   IF        AdrSyn(Y) <>*BLANKS                                        CSD019
     C                   eval      string5 = makestr(%TRIM(AdrSyn(Y)))                        CSD019
     C                   callp     addaddress(caseobject:string5)                             CSD019
     C                   ENDIF                                                                CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** set entry city                                                                       CSD019
                                                                                              CSD019
     C                   IF        ofcity <>*BLANKS                                           CSD019
     C                   eval      string5 = makestr(%TRIM(ofcity))                           CSD019
     C                   callp     setentrycity(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** add alternative city to city array                                                   CSD019
                                                                                              CSD019
     C                   DO        numsyn(3)     Y                                            CSD019
     C                   IF        CitySyn(Y) <>*BLANKS                                       CSD019
     C                   eval      string5 = makestr(%TRIM(CitySyn(Y)))                       CSD019
     C                   callp     addcity(caseobject:string5)                                CSD019
     C                   ENDIF                                                                CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** set entry country                                                                    CSD019
                                                                                              CSD019
     C                   IF        ofCntry <>*BLANKS                                          CSD019
     C                   eval      string5 = makestr(%TRIM(ofCntry))                          CSD019
     C                   callp     setcountry(caseobject:string5)                             CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** add alternative country to country array                                             CSD019
                                                                                              CSD019
     C                   DO        numsyn(4)     Y                                            CSD019
     C                   IF        CtrySyn(Y) <>*BLANKS                                       CSD019
     C                   eval      string5 = makestr(%TRIM(CtrySyn(Y)))                       CSD019
     C                   callp     addcountry(caseobject:string5)                             CSD019
     C                   ENDIF                                                                CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** set Watch list codes                                                                 CSD019
                                                                                              CSD019
     C                   IF        ofsrchcde <>*BLANKS                                        CSD019
     C                   eval      string5 = makestr(%TRIM(ofsrchcde))                        CSD019
     C                   callp     setcodes(caseobject:string5)                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set user data 1                                                                      CSD019
                                                                                              CSD019
     C                   IF        ofusrdta1 <>*BLANKS                                        CSD019
     C                   eval      string5 = makestr(%TRIM(ofusrdta1))                        CSD019
     C                   callp     setuserdata1(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** set user data 2                                                                      CSD019
                                                                                              CSD019
     C                   IF        ofusrdta2 <>*BLANKS                                        CSD019
     C                   eval      string5 = makestr(%TRIM(ofusrdta2))                        CSD019
     C                   callp     setuserdata2(caseobject:string5)                           CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** insert case, actually writes record to SQL database                                  CSD019
                                                                                              CSD019
     C                   EVAL      OkS = insertcase(caseobject:strsrvnam:                     CSD019
     C                             strdbname:strusrnam:strpasswd)                             CSD019
     C                   ENDSR                                                                CSD019
                                                                                              CSD019
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SRLocal - Populate fields in Compliance Watch Case External  *                       CSD019
      *            Match Details File                                 *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SRLocal       BEGSR                                                                CSD019
                                                                                              CSD019
      ** Identification Data                                                                  CSD019
      ** -------------------                                                                  CSD019
                                                                                              CSD019
     C                   EVAL      W8MATC = WMTCHCD                                           CSD019
     C                   EVAL      W8ITEM = W4ITEM                                            CSD019
     C                   EVAL      W8IDEN = W4IDEN                                            CSD019
     C                   EVAL      W8BRCH = W4BRCH                                            CSD019
     C                   EVAL      W8SYSM = W4SYSM                                            CSD019
                                                                                              CSD019
      ** Enhancement Data                                                                     CSD019
      ** -----------------                                                                    CSD019
                                                                                              CSD019
     C                   EVAL      W8CNUM = W4CNUM                                            CSD019
     C                   EVAL      W8CTYP = W4CTYP                                            CSD019
     C                   EVAL      W8CUST = W4CUST                                            CSD019
                                                                                              CSD019
      ** set deal date                                                                        CSD019
                                                                                              CSD019
     C                   MOVE      W4DDAT        WDelD                                        CSD019
     C                   EVAL      PDateIn = WDYear + WDMnth + WDDay                          CSD019
     C                   CALLB     'ZDATE10'                                                  CSD019
     C                   PARM                    PDateIn                                      CSD019
     C                   PARM      *ZEROS        PDayNOut                                     CSD019
     C                   EVAL      W8DDAT = PDayNOut                                          CSD019
                                                                                              CSD019
      ** set value date                                                                       CSD019
                                                                                              CSD019
     C                   MOVE      W4VDAT        WValD                                        CSD019
     C                   EVAL      PDateIn = WVYear + WVMnth + WVDay                          CSD019
     C                   CALLB     'ZDATE10'                                                  CSD019
     C                   PARM                    PDateIn                                      CSD019
     C                   PARM      *ZEROS        PDayNOut                                     CSD019
     C                   EVAL      W8VDAT = PDayNOut                                          CSD019
                                                                                              CSD019
      ** set maturity date                                                                    CSD019
                                                                                              CSD019
     C                   MOVE      W4MDAT        WMatD                                        CSD019
     C                   EVAL      PDateIn = WMYear + WMMnth + WMDay                          CSD019
     C                   CALLB     'ZDATE10'                                                  CSD019
     C                   PARM                    PDateIn                                      CSD019
     C                   PARM      *ZEROS        PDayNOut                                     CSD019
     C                   EVAL      W8MDAT = PDayNOut                                          CSD019
                                                                                              CSD019
     C                   EVAL      W8DEN1 = W4DEN1                                            CSD019
     C                   EVAL      W8DEN2 = W4DEN2                                            CSD019
     C                   Z-ADD     W4AMT1        W8AMT1                                       CSD019
     C                   Z-ADD     W4AMT2        W8AMT2                                       CSD019
                                                                                              CSD019
      ** Search Data                                                                          CSD019
                                                                                              CSD019
     C                   IF        CAString <> *BLANKS                                        CSD019
     C     '''':'`'      XLATE     CAString      CAString                                     CSD019
     C     '?':' '       XLATE     CAString      CAString                                     CSD019
     C                   EVAL      W8DATA = CAString                                          CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Control Data                                                                         CSD019
                                                                                              CSD019
     C                   EVAL      W8FUNT = W4FUNT                                            CSD019
                                                                                              CSD019
      ** set name match 1 start                                                               CSD019
                                                                                              CSD019
     C                   EVAL      W8NAM1 = WMtchStr(1)                                       CSD019
                                                                                              CSD019
      ** set name match 1 end                                                                 CSD019
                                                                                              CSD019
     C                   EVAL      W8NAM2 = WMtchEnd(1)                                       CSD019
                                                                                              CSD019
      ** set name match 2 start                                                               CSD019
                                                                                              CSD019
     C                   EVAL      W8ADD1 = WMtchStr(1)                                       CSD019
                                                                                              CSD019
      ** set name match 2 end                                                                 CSD019
                                                                                              CSD019
     C                   EVAL      W8ADD2 = WMtchEnd(1)                                       CSD019
                                                                                              CSD019
      ** set name match 3 start                                                               CSD019
                                                                                              CSD019
     C                   EVAL      W8CTY1 = WMtchStr(1)                                       CSD019
                                                                                              CSD019
      ** set name match 3 end                                                                 CSD019
                                                                                              CSD019
     C                   EVAL      W8CTY2 = WMtchEnd(1)                                       CSD019
                                                                                              CSD019
      ** set name match 4 start                                                               CSD019
                                                                                              CSD019
     C                   EVAL      W8CTR1 = WMtchStr(1)                                       CSD019
                                                                                              CSD019
      ** set name match 4 end                                                                 CSD019
                                                                                              CSD019
     C                   EVAL      W8CTR2 = WMtchEnd(1)                                       CSD019
                                                                                              CSD019
      ** set watch list identifier                                                            CSD019
                                                                                              CSD019
     C                   EVAL      W8WLID = ofacid                                            CSD019
                                                                                              CSD019
      ** set watch list origin                                                                CSD019
                                                                                              CSD019
     C                   EVAL      W8EORG = oforigin                                          CSD019
                                                                                              CSD019
      ** set entry type                                                                       CSD019
                                                                                              CSD019
     C                   EVAL      W8ETYP = ofdesgn                                           CSD019
                                                                                              CSD019
      ** set entry name                                                                       CSD019
                                                                                              CSD019
     C                   EVAL      W8ENAM = ofname                                            CSD019
                                                                                              CSD019
      ** set entry address                                                                    CSD019
                                                                                              CSD019
     C                   EVAL      W8EADD = ofaddr                                            CSD019
                                                                                              CSD019
      ** set entry city                                                                       CSD019
                                                                                              CSD019
     C                   EVAL      W8ECTY = ofcity                                            CSD019
                                                                                              CSD019
      ** set entry country                                                                    CSD019
                                                                                              CSD019
     C                   EVAL      W8ECTR = ofCntry                                           CSD019
                                                                                              CSD019
      ** set user data 1                                                                      CSD019
                                                                                              CSD019
     C                   EVAL      W8DAT1 = ofusrdta1                                         CSD019
                                                                                              CSD019
      ** set user data 2                                                                      CSD019
                                                                                              CSD019
     C                   EVAL      W8DAT2 = ofusrdta2                                         CSD019
                                                                                              CSD019
      ** Write the record in the Compliance Watch Case External Match Details File            CSD019
                                                                                              CSD019
     C                   WRITE     SDCWCSD0                                                   CSD019
                                                                                              CSD019
     C                   CLEAR                   numsyn                                       CSD019
                                                                                              CSD019
      ** get number of name synonyms                                                          CSD019
                                                                                              CSD019
     C                   EVAL      numsyn(1)=(FofRHnSynnameI(PServ:X-1))                      CSD019
                                                                                              CSD019
     ** For each name synonym, write the details to the Compliance                            CSD019
     ** Watch Case Matched Name Synonyms File                                                 CSD019
                                                                                              CSD019
     C                   DO        numsyn(1)     Y                                            CSD019
     C                   EVAL      NameSyn(Y)=%STR(FofRHsynNameIJ                             CSD019
     C                                        (PServ:X-1:Y-1))                                CSD019
     C     '''':'`'      XLATE     NameSyn(Y)    NameSyn(Y)                                   CSD019
     C                   EVAL      W9MATC = WMTCHCD                                           CSD019
     C                   EVAL      W9ENAM = NameSyn(Y)                                        CSD019
     C                   WRITE     SDCWNMD0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** get number of name address synonyms                                                  CSD019
                                                                                              CSD019
     C                   EVAL      numsyn(2)=(FofRHnSynAddrI(PServ:X-1))                      CSD019
                                                                                              CSD019
     ** For each address synonym, write the details to the Compliance                         CSD019
     ** Watch Case Matched Address Synonyms File                                              CSD019
                                                                                              CSD019
     C                   DO        numsyn(2)     Y                                            CSD019
     C                   EVAL      AdrSyn(Y)=%STR(FofRHsynAddIJ(PServ:X-1:Y-1))               CSD019
     C     '''':'`'      XLATE     AdrSyn(Y)     AdrSyn(Y)                                    CSD019
     C                   EVAL      W9MATC = WMTCHCD                                           CSD019
     C                   EVAL      W9EADD = AdrSyn(Y)                                         CSD019
     C                   WRITE     SDCWADD0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** get number of city synonyms                                                          CSD019
                                                                                              CSD019
     C                   EVAL      numsyn(3)=(FofRHnSynCityI(PServ:X-1))                      CSD019
                                                                                              CSD019
     ** For each city synonym, write the details to the Compliance                            CSD019
     ** Watch Case Matched City Synonyms File                                                 CSD019
                                                                                              CSD019
     C                   DO        numsyn(3)     Y                                            CSD019
     C                   EVAL      CitySyn(Y)=%STR(FofRHsynCityIJ                             CSD019
     C                                        (PServ:X-1:Y-1))                                CSD019
     C                   EVAL      W9MATC = WMTCHCD                                           CSD019
     C                   EVAL      W9ECTY = CitySyn(Y)                                        CSD019
     C                   WRITE     SDCWCTD0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
      ** get number of country synonyms                                                       CSD019
                                                                                              CSD019
     C                   EVAL      numsyn(4)=(FofRHnSynCtryI(PServ:X-1))                      CSD019
                                                                                              CSD019
     ** For each country synonym, write the details to the Compliance                         CSD019
     ** Watch Case Matched Country Synonyms File                                              CSD019
                                                                                              CSD019
     C                   DO        numsyn(4)     Y                                            CSD019
     C                   EVAL      CtrySyn(Y)=%STR(FofRHsynCtryIJ                             CSD019
     C                                        (PServ:X-1:Y-1))                                CSD019
     C                   EVAL      W9MATC = WMTCHCD                                           CSD019
     C                   EVAL      W9ECTR = CtrySyn(Y)                                        CSD019
     C     '''':'`'      XLATE     CtrySyn(Y)    CtrySyn(Y)                                   CSD019
     C                   WRITE     SDCWCOD0                                                   CSD019
     C                   ENDDO                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
      **********************************************************************
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
 
     C     *entry        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PServ
     C                   PARM                    TranDtls
     C                   PARM                    SrchStrng
 
      ** Retrieve configuration data for linking both the OFAC-Agent and
      ** the Compliance Alert Software
 
     C                   CALLB     'AOCWCDR0'
     C                   PARM      *BLANKS       P_Retcd
     C                   PARM      '*FIRST '     P_Optn
     C     SDCWCD        PARM      SDCWCD        DSSDY
 
     C                   IF        P_Retcd <> *Blanks
     C                   EVAL      DBFILE = 'SDCWCDPD'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = P_Optn
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSD019
      ** Check if CSD019 is installed                                                         CSD019
                                                                                              CSD019
     C                   CALLB     'AOSARDR0'                                                 CSD019
     C                   PARM      *BLANKS       P_RetCd                                      CSD019
     C                   PARM      '*VERIFY'     P_Optn                                       CSD019
     C                   PARM      'CSD019'      P_Sard                                       CSD019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD019
                                                                                              CSD019
      ** Database error                                                                       CSD019
                                                                                              CSD019
     C                   IF        (P_RetCd <> *BLANKS) and                                   CSD019
     C                             (P_RetCd <> '*NRF   ')                                     CSD019
     C                   EVAL      DBKEY = 'CSD019'                                           CSD019
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD019
     C                   EVAL      DBASE = 002                                                CSD019
     C                   EXSR      *PSSR                                                      CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   IF        P_RetCd = *BLANKS                                          CSD019
     C                   EVAL      CSD019 = 'Y'                                               CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      CSD019 = 'N'                                               CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
      ** Access bank details.                                                                 CSD019
                                                                                              CSD019
     C                   CALLB     'AOBANKR0'                                                 CSD019
     C                   PARM      *BLANKS       P_RetCd                                      CSD019
     C                   PARM      '*FIRST '     P_Optn                                       CSD019
     C     SDBANK        PARM      SDBANK        DSFDY                                        CSD019
                                                                                              CSD019
      ** Database error                                                                       CSD019
                                                                                              CSD019
     C                   IF        P_RetCd <> *BLANK                                          CSD019
     C     *LOCK         IN        LDA                                                        CSD019
     C                   EVAL      DBFILE= 'SDBANKPD'                                         CSD019
     C                   EVAL      DBKEY = P_Optn                                             CSD019
     C                   EVAL      DBASE = 003                                                CSD019
     C                   OUT       LDA                                                        CSD019
     C                   EXSR      *PSSR                                                      CSD019
     C                   ENDIF                                                                CSD019
 
      ** Key list for hit list file
 
     C     KWTCHL        KLIST
     C                   KFLD                    WFUNC
     C                   KFLD                    WIDNT
     C                   KFLD                    WBRCA
 
      *
      * Uncomment line below to turn on the FircoSoft trace.
      * Replace 'LIB' with existing library name, i.e. 'NMXLIB'.
      * Replace 'FILE' with output trace file name. This does not
      * need to exist. The name must be 7 characters or less in length.
      * Note that the file created has 'LOG' appended to the name.
      * I.e. 'FILE' becomes 'FILELOG' in library 'LIB'.
      *
     C*                  EVAL      res=FkCommTraceOn('LIB':'FILE')
      *
     C                   IN        SDSTAT                                                     CSD101
                                                                                              CSD101
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
 
     C                   EVAL      PRetCode = '*ERROR'
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
