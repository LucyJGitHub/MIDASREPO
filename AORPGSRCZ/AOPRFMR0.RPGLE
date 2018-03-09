     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Profit centre default retrieval')             *
     F********************************************************************
     F*                                                                  *
     F*  Midas   ACCESS OBJECTS
     F*                                                                  *
     F*     AOPRFMR0 - PROFIT CENTRE DEFAULT RETRIEVAL                   *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. CLE051             Date 02Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240429             Date 07Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 200583             Date 22Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 194785             Date 20Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
      *                 120827             Date 06Jul97               *
     F*                 RT0067             Date 14May91               *
     F*                                                                  *
     F********************************************************************
      *                                                               *
      *  CLE051 - Defaulting of Profit Centre                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240429 - Use Call to access AOPRFCR0 instead of CALLB.       *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  200583 - Profit centre defaults to UNKN.  Redefine WCounter  *
      *           and WAvoidPr to 2,0.                                *
      *  194785 - Increase size of work field 'COUNT' to 2,0 in order *
      *           to cater for additional default profit centres      *
      *           introduced by CSD009                                *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*  120827 - Profit Centre Accounting defaulting                 *
     F*     RT0067 - SPECIFY THE RETURN CODES USED IN THIS PROGRAMME     *
     F********************************************************************
     F*                                                                  *
     F*       11      BOOK PRIORITY IS NEXT LOWEST                       *
     F*       12      TRANSACTION TYPE PRIORITY IS NEXT LOWEST           *
     F*       13      SUB TYPE PRIORITY IS NEXT LOWEST                   *
     F*       14      BRANCH PRIORITY IS NEXT LOWEST                     *
     F*       15      DEPARTMENT PRIORITY IS NEXT LOWEST                 *
     F*       16      USER PRIORITY IS NEXT LOWEST                       *
     F*       17      ACCOUNT OFFICER PRIORITY IS NEXT LOWEST            *
     F*       18      CUSTOMER NUMBER PRIORITY IS NEXT LOWEST            *
     F*       30      PROFIT CENTRE NOT FOUND IF ON                      *
     F*       55      CHAIN FAIL ON FILE SDPRFML1                        *
     F*                                                                  *
     F********************************************************************
     F*       RETURN CODES FROM THIS PROGRAMME                         ***
     F*
     F*       0       PROFIT CENTRE FOUND - NO ERROR
     F*       1       DEFAULT NOT FOUND FOR THIS COMBINATION-BLANK
     F*               PROFIT CENTRE IS RETUNED
     F*       2       PROFIT CENTRE FOUND BUT IS INVALID
     F*
     F********************************************************************
     F*
     FSDPRFML1  IF   E           K DISK
     FSDCMRKL1  IF   E           K DISK                                         CSD009
     FSDCTRYL1  IF   E           K DISK                                         CSD009
     F*
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              COPYRIGHT ARRAY
     D*
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D**  EXTERNAL DS FOR GENERAL LEDGER
     D*
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
     D**  EXTERNAL DS FOR PROFIT CENTRES
     D*                                                                          120827
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                     120827
     D**  EXTERNAL DS FOR MIDAS MODULE DETAILS                                   120827
     D*                                                                          120827
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)                     120827
     D**  EXTERNAL DS FOR PROFIT CENTRE ACCOUNTING ICD                           120827
     D*                                                                          120827
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                     120827
     D**  EXTERNAL DS FOR SWITCHABLE FEATURES                                    120827
      *                                                                         CSD009
     D True            C                   *On                                  CSD009
     D False           C                   *Off                                 CSD009
      ** True and False can be used for indicators being on or off.             CSD009
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CSD009
      ** External DS for Customer file                                          CSD009
     D Indicators      DS                  BASED(IndicatorP)                    CSD009
     D  RecNotFnd             30     30                                         CSD009
      ** Indicator Array                                                        CSD009
     D IndicatorP      S               *   INZ(%Addr(*IN))                      CSD009
      ** Pointer for the indicator Array                                        CSD009
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     I* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     I*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C**  Input Parameters
     C*
     C     *ENTRY        PLIST
     C                   PARM                    RTCD              1            Return Code
     C                   PARM                    BOOK              2            Book Code
     C                   PARM                    TRTP              5            Transaction Type
     C                   PARM                    SUTP              2            Sub Type
     C                   PARM                    BRAN              3            Branch Code
     C                   PARM                    DEPT              3            Department Code
     C                   PARM                    USER             10            User
     C                   PARM                    ACOF              2            Account Officer Code
     C                   PARM                    CNUM              6            Customer Number
     C                   PARM                    PRFC              4            Profit Centre Code
     C*
     C**  Input Parameters
     C*
     C     FLKEY         KLIST
     C                   KFLD                    BOOK
     C                   KFLD                    TRTP
     C                   KFLD                    SUTP
     C                   KFLD                    BRAN
     C                   KFLD                    DEPT
     C                   KFLD                    USER
     C                   KFLD                    ACOF
     C                   KFLD                    CNUM
      *                                                                         CSD009
      ** Key list used when CSD009 enhancement is installed.                    CSD009
      ** Additional key fields, for default matrix file.                        CSD009
     C     KFLKEY        KLIST                                                  CSD009
     C                   KFLD                    BOOK                           CSD009
     C                   KFLD                    TRTP                           CSD009
     C                   KFLD                    SUTP                           CSD009
     C                   KFLD                    BRAN                           CSD009
     C                   KFLD                    DEPT                           CSD009
     C                   KFLD                    USER                           CSD009
     C                   KFLD                    ACOF                           CSD009
     C                   KFLD                    CNUM                           CSD009
     C                   KFLD                    LICD              3            CSD009
     C                   KFLD                    BNBI              1            CSD009
     C                   KFLD                    CLOC              2            CSD009
     C                   KFLD                    RLOC              2            CSD009
     C                   KFLD                    CNCZ              2            CSD009
     C                   KFLD                    RNCZ              2            CSD009
     C                   KFLD                    CSTY              1            CSD009
     C                   KFLD                    GPC1              4            CSD009
     C                   KFLD                    GPC2              4            CSD009
     C                   KFLD                    GPC3              4            CSD009
     C                   KFLD                    GPC4              4            CSD009
     C                   KFLD                    GPC5              4            CSD009
      *                                                                         CSD009
     C*
     C                   MOVEL     '********'    STARS            10
     C                   MOVE      '**'          STARS
     C**********         Z-ADD     0             COUNT             1 0                        194785
     C                   Z-ADD     0             COUNT             2 0                        194785
     C                   MOVE      *BLANKS       RTCD
     C*
     C     BOOK          IFEQ      *BLANKS
     C                   MOVE      STARS         BOOK
     C                   END
     C*
     C     TRTP          IFEQ      *BLANKS
     C                   MOVE      STARS         TRTP
     C                   END
     C*
     C     SUTP          IFEQ      *BLANKS
     C                   MOVE      STARS         SUTP
     C                   END
     C*
     C     BRAN          IFEQ      *BLANKS
     C                   MOVE      STARS         BRAN
     C                   END
     C*
     C     DEPT          IFEQ      *BLANKS
     C                   MOVE      STARS         DEPT
     C                   END
     C*
     C     USER          IFEQ      *BLANKS
     C                   MOVE      STARS         USER
     C                   END
     C*
     C     ACOF          IFEQ      *BLANKS
     C                   MOVE      STARS         ACOF
     C                   END
     C*
     C     CNUM          IFEQ      *BLANKS
     C                   MOVE      STARS         CNUM
     C                   END
     C*
     C**  Check if Analytical Accounting is installed.                    120827
     C*                                                                   120827
     C                   CALL      'AOMMODR0'                                                120827
     C                   PARM      '*DBERR '     @RTCD                                       120827
     C                   PARM      '*FIRST '     @OPTN                                       120827
     C     SDMMOD        PARM      SDMMOD        DSFDY                                       120827
     C*                                                                   120827
     C** IF Analytical Accounting installed                               120827
     C** Access AOSARDR0 to check if CAC004 (Default Unallocated Prf Ctr) 120827
     C** is switched on.                                                  120827
     C*                                                                   120827
     C     BGN0ST        IFEQ      'Y'                                                       120827
     C                   CALL      'AOSARDR0'                                                120827
     C                   PARM      *BLANKS       @RTCD                                       120827
     C                   PARM      '*VERIFY'     @OPTN                                       120827
     C                   PARM      'CAC004'      @SARD             6                         120827
     C     SCSARD        PARM      SCSARD        DSFDY                                       120827
     C*                                                                                      120827
     C     @RTCD         IFEQ      *BLANKS                                                   120827
     C                   MOVE      'Y'           CAC004            1                         120827
     C                   ELSE                                                                120827
     C                   MOVE      'N'           CAC004                                      120827
     C                   ENDIF                                                               120827
     C*                                                                   120827
     C**  and obtain the 'Unallocated Profit Centre' from PF/SDPCACPD     120827
     C*                                                                   120827
     C                   CALL      'AOPCACR0'                                                120827
     C                   PARM      '*DBERR '     @RTCD                                       120827
     C                   PARM      '*FIRST '     @OPTN                                       120827
     C     SDPCAC        PARM      SDPCAC        DSFDY                                       120827
     C                   ENDIF                                                               120827
      *                                                                         CSD009
      ** Check if CSD009 - PCA Default Matrix Enhancement is installed          CSD009
      *                                                                         CSD009
     C                   CALL      'AOSARDR0'                                   CSD009
     C                   PARM      *BLANKS       @RTCD                          CSD009
     C                   PARM      '*VERIFY'     @OPTN                          CSD009
     C                   PARM      'CSD009'      @SARD                          CSD009
     C     SCSARD        PARM      SCSARD        DSFDY                          CSD009
      *                                                                         CSD009
     C                   IF        @RTCD = *BLANKS                              CSD009
     C                   MOVE      'Y'           CSD009            1            CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      'N'           CSD009                         CSD009
     C                   ENDIF                                                  CSD009
     C/COPY WNCPYSRC,AOPRFMR0C1
      *                                                                                       CLE051
      ** Check if CLE051 - Defaulting of Profit Centre is installed                           CLE051
      *                                                                                       CLE051
     C                   CALL      'AOSARDR0'                                                 CLE051
     C                   PARM      *BLANKS       @RTCD                                        CLE051
     C                   PARM      '*VERIFY'     @OPTN                                        CLE051
     C                   PARM      'CLE051'      @SARD                                        CLE051
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE051
      *                                                                                       CLE051
     C                   IF        @RTCD = *BLANKS                                            CLE051
     C                   MOVE      'Y'           CLE051            1                          CLE051
     C                   ELSE                                                                 CLE051
     C                   MOVE      'N'           CLE051                                       CLE051
     C                   ENDIF                                                                CLE051
      *                                                                         CSD009
      ** If CSD009 is installed and customer number of transaction is           CSD009
      ** not blanks, setup new parameters.                                      CSD009
      *                                                                         CSD009
     C                   IF        CSD009 = 'Y' AND CNUM <> *BLANKS             CSD009
     C                             AND CNUM <> '******'                         CSD009
      *                                                                         CSD009
      ** Access customer details for new default keys.                          CSD009
     C                   CALLB     'AOCUSTR0'                                   CSD009
     C                   PARM      *BLANKS       @RTCD                          CSD009
     C                   PARM      '*KEY   '     @OPTN                          CSD009
     C                   PARM      CNUM          @KEY1            10            CSD009
     C                   PARM                    @KYST             7            CSD009
     C     SDCUST        PARM      SDCUST        DSSDY                          CSD009
      *                                                                         CSD009
      ** If customer found, set additional default matrix field                 CSD009
      ** from customer details.                                                 CSD009
     C                   IF        @RTCD = *BLANKS                              CSD009
      *                                                                         CSD009
     C                   EVAL      LICD = BBLICD                                CSD009
     C                   EVAL      BNBI = BBBNBI                                CSD009
     C                   EVAL      CLOC = BBCOLC                                CSD009
     C                   EVAL      CNCZ = BBCNCZ                                CSD009
     C                   EVAL      CSTY = BBCSTY                                CSD009
      *                                                                         CSD009
      ** Access customer marketing group codes (new defaults)                   CSD009
     C     CNUM          CHAIN     SDCMRKL1                           56        CSD009
      *                                                                         CSD009
     C                   EVAL      GPC1 = D7GPC1                                CSD009
     C                   EVAL      GPC2 = D7GPC2                                CSD009
     C                   EVAL      GPC3 = D7GPC3                                CSD009
     C                   EVAL      GPC4 = D7GPC4                                CSD009
     C                   EVAL      GPC5 = D7GPC5                                CSD009
      *                                                                         CSD009
      ** Access region details (new defaults)                                   CSD009
     C                   IF        BBCOLC <> *BLANKS                            CSD009
     C     BBCOLC        CHAIN     SDCTRYL1                           56        CSD009
     C                   EVAL      RLOC = A4RGCD                                CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        BBCNCZ <> *BLANKS                            CSD009
     C     BBCNCZ        CHAIN     SDCTRYL1                           56        CSD009
     C                   EVAL      RNCZ = A4RGCD                                CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
     C                   EVAL      LICD = *BLANKS                               CSD009
     C                   EVAL      BNBI = *BLANKS                               CSD009
     C                   EVAL      CLOC = *BLANKS                               CSD009
     C                   EVAL      RLOC = *BLANKS                               CSD009
     C                   EVAL      CNCZ = *BLANKS                               CSD009
     C                   EVAL      RNCZ = *BLANKS                               CSD009
     C                   EVAL      CSTY = *BLANKS                               CSD009
     C                   EVAL      GPC1 = *BLANKS                               CSD009
     C                   EVAL      GPC2 = *BLANKS                               CSD009
     C                   EVAL      GPC3 = *BLANKS                               CSD009
     C                   EVAL      GPC4 = *BLANKS                               CSD009
     C                   EVAL      GPC5 = *BLANKS                               CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Else, CSD009 is not installed or customer number of                    CSD009
      ** transaction is blanks, reset new default keys to blanks.               CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
     C                   EVAL      LICD = *BLANKS                               CSD009
     C                   EVAL      BNBI = *BLANKS                               CSD009
     C                   EVAL      CLOC = *BLANKS                               CSD009
     C                   EVAL      RLOC = *BLANKS                               CSD009
     C                   EVAL      CNCZ = *BLANKS                               CSD009
     C                   EVAL      RNCZ = *BLANKS                               CSD009
     C                   EVAL      CSTY = *BLANKS                               CSD009
     C                   EVAL      GPC1 = *BLANKS                               CSD009
     C                   EVAL      GPC2 = *BLANKS                               CSD009
     C                   EVAL      GPC3 = *BLANKS                               CSD009
     C                   EVAL      GPC4 = *BLANKS                               CSD009
     C                   EVAL      GPC5 = *BLANKS                               CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** For each new parameter field, set to stars if blanks.                  CSD009
      *                                                                         CSD009
     C                   IF        LICD = *BLANKS                               CSD009
     C                   MOVE      STARS         LICD                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        BNBI = *BLANKS                               CSD009
     C                   MOVE      STARS         BNBI                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        CLOC = *BLANKS                               CSD009
     C                   MOVE      STARS         CLOC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        RLOC = *BLANKS                               CSD009
     C                   MOVE      STARS         RLOC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        CNCZ = *BLANKS                               CSD009
     C                   MOVE      STARS         CNCZ                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        RNCZ = *BLANKS                               CSD009
     C                   MOVE      STARS         RNCZ                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        CSTY = *BLANKS                               CSD009
     C                   MOVE      STARS         CSTY                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        GPC1 = *BLANKS                               CSD009
     C                   MOVE      STARS         GPC1                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        GPC2 = *BLANKS                               CSD009
     C                   MOVE      STARS         GPC2                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        GPC3 = *BLANKS                               CSD009
     C                   MOVE      STARS         GPC3                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        GPC4 = *BLANKS                               CSD009
     C                   MOVE      STARS         GPC4                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   IF        GPC5 = *BLANKS                               CSD009
     C                   MOVE      STARS         GPC5                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Set Counter and Avoid Priority field to zero.                          CSD009
     C**********         Z-ADD     0             WCounter          1 0                 CSD009 200583
     C**********         Z-ADD     0             WAvoidPr          1 0                 CSD009 200583
     C                   Z-ADD     0             WCounter          2 0                        200583
     C                   Z-ADD     0             WAvoidPr          2 0                        200583
     C*                                                                   120827
     C**  Obtain Profit Centre Default Matrix priorities from SDGELRPD
     C**  by accessing GENERAL LEDGER
     C*
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                         CSD009
      ** Remember priority number of each default field and save                CSD009
      ** it to a numeric field.                                                 CSD009
      *                                                                         CSD009
     C                   MOVE      BKPMBK        WKPMBK            1 0          CSD009
     C                   MOVE      BKPMTT        WKPMTT            1 0          CSD009
     C                   MOVE      BKPMST        WKPMST            1 0          CSD009
     C                   MOVE      BKPMBH        WKPMBH            1 0          CSD009
     C                   MOVE      BKPMDT        WKPMDT            1 0          CSD009
     C                   MOVE      BKPMUR        WKPMUR            1 0          CSD009
     C                   MOVE      BKPMAO        WKPMAO            1 0          CSD009
     C                   MOVE      BKPMCU        WKPMCU            1 0          CSD009
     C                   MOVE      BKLICD        WKLICD            1 0          CSD009
     C                   MOVE      BKBNBI        WKBNBI            1 0          CSD009
     C                   MOVE      BKCLOC        WKCLOC            1 0          CSD009
     C                   MOVE      BKRLOC        WKRLOC            1 0          CSD009
     C                   MOVE      BKCNCZ        WKCNCZ            1 0          CSD009
     C                   MOVE      BKRNCZ        WKRNCZ            1 0          CSD009
     C                   MOVE      BKCSTY        WKCSTY            1 0          CSD009
     C                   MOVE      BKGPC1        WKGPC1            1 0          CSD009
     C                   MOVE      BKGPC2        WKGPC2            1 0          CSD009
     C                   MOVE      BKGPC3        WKGPC3            1 0          CSD009
     C                   MOVE      BKGPC4        WKGPC4            1 0          CSD009
     C                   MOVE      BKGPC5        WKGPC5            1 0          CSD009
     C*
     C** If one of the priorities is zero,set the relevant key to
     C** asterisks, else add one to number of non-zero priorities.
     C*
     C     BKPMBK        IFEQ      '0'
     C                   MOVE      STARS         BOOK
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMTT        IFEQ      '0'
     C                   MOVE      STARS         TRTP
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMST        IFEQ      '0'
     C                   MOVE      STARS         SUTP
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMBH        IFEQ      '0'
     C                   MOVE      STARS         BRAN
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMDT        IFEQ      '0'
     C                   MOVE      STARS         DEPT
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMUR        IFEQ      '0'
     C                   MOVE      STARS         USER
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMAO        IFEQ      '0'
     C                   MOVE      STARS         ACOF
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
     C*
     C     BKPMCU        IFEQ      '0'
     C                   MOVE      STARS         CNUM
     C                   ELSE
     C                   ADD       1             COUNT
     C                   END
      *                                                                         CSD009
     C                   IF        CSD009 = 'Y'                                 CSD009
      *                                                                         CSD009
     C     BKLICD        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         LICD                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKBNBI        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         BNBI                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKCLOC        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         CLOC                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKRLOC        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         RLOC                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKCNCZ        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         CNCZ                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKRNCZ        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         RNCZ                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKCSTY        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         CSTY                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKGPC1        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         GPC1                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKGPC2        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         GPC2                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKGPC3        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         GPC3                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKGPC4        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         GPC4                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BKGPC5        IFEQ      '0'                                          CSD009
     C                   MOVE      STARS         GPC5                           CSD009
     C                   ELSE                                                   CSD009
     C                   ADD       1             COUNT                          CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** For each parameter, save original value to work variable               CSD009
      ** for parameters.                                                        CSD009
      *                                                                         CSD009
     C                   MOVEL     BOOK          WBOOK             2            CSD009
     C                   MOVEL     TRTP          WTRTP             5            CSD009
     C                   MOVEL     SUTP          WSUTP             2            CSD009
     C                   MOVEL     BRAN          WBRAN             3            CSD009
     C                   MOVEL     DEPT          WDEPT             3            CSD009
     C                   MOVEL     USER          WUSER            10            CSD009
     C                   MOVEL     ACOF          WACOF             2            CSD009
     C                   MOVEL     CNUM          WCNUM             6            CSD009
     C                   MOVEL     LICD          WLICD             3            CSD009
     C                   MOVEL     BNBI          WBNBI             1            CSD009
     C                   MOVEL     CLOC          WCLOC             2            CSD009
     C                   MOVEL     RLOC          WRLOC             2            CSD009
     C                   MOVEL     CNCZ          WCNCZ             2            CSD009
     C                   MOVEL     RNCZ          WRNCZ             2            CSD009
     C                   MOVEL     CSTY          WCSTY             1            CSD009
     C                   MOVEL     GPC1          WGPC1             4            CSD009
     C                   MOVEL     GPC2          WGPC2             4            CSD009
     C                   MOVEL     GPC3          WGPC3             4            CSD009
     C                   MOVEL     GPC4          WGPC4             4            CSD009
     C                   MOVEL     GPC5          WGPC5             4            CSD009
      *                                                                         CSD009
      ** Turn on indicator for record not found, and set work                   CSD009
      ** variable for counter to total number of priorities.                    CSD009
     C                   EVAL      RecNotFnd = True                             CSD009
     C                   EVAL      WCounter = Count                             CSD009
      *                                                                         CSD009
      ** Do while counter is greater than avoid priority counter                CSD009
      ** and profit centre not found.                                           CSD009
     C                   DOW       WCounter > WAvoidPr                          CSD009
     C                             AND RecNotFnd = True                         CSD009
      *                                                                         CSD009
      ** Chain to LF/SDPRFML1 for Profit Centre.                                CSD009
     C                   IF        CSD009 = 'Y'                                 CSD009
     C     KFLKEY        CHAIN     @DWREHF                            55        CSD009
     C                   ELSE                                                   CSD009
     C     FLKEY         CHAIN     @DWREHF                            55        CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** If record found, check if profit centre is valid.                      CSD009
     C     *IN55         IFEQ      '0'                                          CSD009
      *                                                                         CSD009
     C                   EVAL      RecNotFnd = False                            CSD009
      *                                                                         CSD009
     C**********         CALLB     'AOPRFCR0'                                          CSD009 240429
     C                   CALL      'AOPRFCR0'                                                 240429
     C                   PARM      '*MSG   '     @RTCD                          CSD009
     C                   PARM      '*VERIFY'     @OPTN                          CSD009
     C                   PARM      DWPCCD        @KEY              4            CSD009
     C     SDPRFC        PARM      SDPRFC        DSFDY                          CSD009
      *                                                                         CSD009
      ** Invalid Profit Centre, return to calling program with                  CSD009
      ** corresponding error code.                                              CSD009
     C                   IF        @RTCD <> *BLANKS                             CSD009
     C                   MOVE      '2'           RTCD                           CSD009
     C                   MOVEL     DWPCCD        PRFC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Otherwise, continue processing.                                        CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
      ** If working counter is greater than the avoid priority + 1              CSD009
      ** then reset default field that it is equal to the counter.              CSD009
     C                   IF        WCounter > WAvoidPr + 1                      CSD009
                                                                                CSD009
     C     WKPMBK        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         BOOK                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMTT        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         TRTP                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMST        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         SUTP                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMBH        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         BRAN                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMDT        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         DEPT                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMUR        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         USER                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMAO        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         ACOF                           CSD009
     C                   ENDIF                                                  CSD009
                                                                                CSD009
     C     WKPMCU        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         CNUM                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKLICD        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         LICD                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKBNBI        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         BNBI                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKCLOC        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         CLOC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKRLOC        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         RLOC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKCNCZ        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         CNCZ                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKRNCZ        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         RNCZ                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKCSTY        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         CSTY                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKGPC1        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         GPC1                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKGPC2        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         GPC2                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKGPC3        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         GPC3                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKGPC4        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         GPC4                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     WKGPC5        IFEQ      WCounter                                     CSD009
     C                   MOVE      STARS         GPC5                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Subtract 1 from working counter.                                       CSD009
     C                   EVAL      WCounter = WCounter - 1                      CSD009
      *                                                                         CSD009
      ** Else, if working counter is less than the avoid priority.              CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
      ** If enhancement CSD009 is not installed, setup return codes             CSD009
      ** and return to calling program.                                         CSD009
     C                   IF        CSD009 <> 'Y'                                CSD009
      *                                                                         CSD009
      ** If Analytical Accounting is installed, then set return                 CSD009
      ** code to '2' unless enhancement CAC004 is installed.                    CSD009
     C     BGN0ST        IFEQ      'Y'                                          CSD009
      *                                                                         CSD009
      ** force a return code of '2' and set profit centre field                 CSD009
      ** to blanks.                                                             CSD009
     C                   MOVE      '2'           RTCD                           CSD009
     C                   MOVEL     *BLANKS       PRFC                           CSD009
      *                                                                         CSD009
      ** If CAC004 is installed, then use the 'Unallocated Profit               CSD009
      ** Centre' defined on ICD and set the return code to '0'.                 CSD009
     C     CAC004        IFEQ      'Y'                                          CSD009
     C/COPY WNCPYSRC,AOPRFMR0C2
     C     CLE051        ANDEQ     'N'                                                        CLE051
     C                   MOVE      '0'           RTCD                           CSD009
     C                   MOVEL     FTUAPC        PRFC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Otherwise, if Analytical Accounting is not installed.                  CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
      ** Return to caller with error                                            CSD009
     C                   MOVE      '1'           RTCD                           CSD009
     C                   MOVEL     *BLANKS       PRFC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   Z-ADD     0             WCounter                       CSD009
      *                                                                         CSD009
      ** Else, continue processing using the 'Best Fit' methodology.            CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
      ** Increment avoid priority by 1.                                         CSD009
     C                   EVAL      WAvoidPr = WAvoidPr + 1                      CSD009
      *                                                                         CSD009
      ** If avoid priority is less than the number of total                     CSD009
      ** priorities, then continue computing for the default                    CSD009
      ** profit centre.                                                         CSD009
     C                   IF        WAvoidPr < Count                             CSD009
      *                                                                         CSD009
      ** For each work parameter, either reset value to original                CSD009
      ** value or set to asterisks.                                             CSD009
     C     BOOK          IFNE      *BLANKS                                      CSD009
     C     WKPMBK        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WBOOK         BOOK                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         BOOK                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     TRTP          IFNE      *BLANKS                                      CSD009
     C     WKPMTT        ANDGT     WAvoidPR                                     CSD009
     C                   MOVE      WTRTP         TRTP                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         TRTP                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     SUTP          IFNE      *BLANKS                                      CSD009
     C     WKPMST        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WSUTP         SUTP                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         SUTP                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BRAN          IFNE      *BLANKS                                      CSD009
     C     WKPMBH        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WBRAN         BRAN                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         BRAN                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     DEPT          IFNE      *BLANKS                                      CSD009
     C     WKPMDT        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WDEPT         DEPT                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         DEPT                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     USER          IFNE      *BLANKS                                      CSD009
     C     WKPMUR        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WUSER         USER                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         USER                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     ACOF          IFNE      *BLANKS                                      CSD009
     C     WKPMAO        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WACOF         ACOF                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         ACOF                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     CNUM          IFNE      *BLANKS                                      CSD009
     C     WKPMCU        ANDGT     WAVoidPr                                     CSD009
     C                   MOVE      WCNUM         CNUM                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         CNUM                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     LICD          IFNE      *BLANKS                                      CSD009
     C     WKLICD        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WLICD         LICD                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         LICD                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     BNBI          IFNE      *BLANKS                                      CSD009
     C     WKBNBI        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WBNBI         BNBI                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         BNBI                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     CLOC          IFNE      *BLANKS                                      CSD009
     C     WKCLOC        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WCLOC         CLOC                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         CLOC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     RLOC          IFNE      *BLANKS                                      CSD009
     C     WKRLOC        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WRLOC         RLOC                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         RLOC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     CNCZ          IFNE      *BLANKS                                      CSD009
     C     WKCNCZ        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WCNCZ         CNCZ                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         CNCZ                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     RNCZ          IFNE      *BLANKS                                      CSD009
     C     WKRNCZ        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WRNCZ         RNCZ                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         RNCZ                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     CSTY          IFNE      *BLANKS                                      CSD009
     C     WKCSTY        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WCSTY         CSTY                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         CSTY                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     GPC1          IFNE      *BLANKS                                      CSD009
     C     WKGPC1        ANDGT     WCounter                                     CSD009
     C                   MOVE      WGPC1         GPC1                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         GPC1                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     GPC2          IFNE      *BLANKS                                      CSD009
     C     WKGPC2        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WGPC2         GPC2                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         GPC2                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     GPC3          IFNE      *BLANKS                                      CSD009
     C     WKGPC3        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WGPC3         GPC3                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         GPC3                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     GPC4          IFNE      *BLANKS                                      CSD009
     C     WKGPC4        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WGPC4         GPC4                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         GPC4                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C     GPC5          IFNE      *BLANKS                                      CSD009
     C     WKGPC5        ANDGT     WAvoidPr                                     CSD009
     C                   MOVE      WGPC5         GPC5                           CSD009
     C                   ELSE                                                   CSD009
     C                   MOVE      STARS         GPC5                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Set working counter to total number of priorities                      CSD009
     C                   EVAL      WCounter = Count                             CSD009
      *                                                                         CSD009
      ** Otherwise, setup retrun code and return to calling program.            CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
      ** If Analytical Accounting is installed, then set return                 CSD009
      ** code to '2' unless enhancement CAC004 is installed.                    CSD009
     C     BGN0ST        IFEQ      'Y'                                          CSD009
      *                                                                         CSD009
      ** Set return code to '2' and profit centre field to blanks.              CSD009
     C                   MOVE      '2'           RTCD                           CSD009
     C                   MOVEL     *BLANKS       PRFC                           CSD009
      *                                                                         CSD009
      ** If CAC004 is installed, then use the 'Unallocated Profit               CSD009
      ** Centre' defined on ICD and set reutrn code to '0'.                     CSD009
     C     CAC004        IFEQ      'Y'                                          CSD009
     C/COPY WNCPYSRC,AOPRFMR0C3
     C     CLE051        ANDEQ     'N'                                                        CLE051
     C                   MOVE      '0'           RTCD                           CSD009
     C                   MOVEL     FTUAPC        PRFC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
      ** Else, setup return codes for no profit centre defaulted.               CSD009
     C                   ELSE                                                   CSD009
      *                                                                         CSD009
      ** Return to caller with error                                            CSD009
     C                   MOVE      '1'           RTCD                           CSD009
     C                   MOVEL     *BLANKS       PRFC                           CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ENDIF                                                  CSD009
      *                                                                         CSD009
     C                   ENDDO                                                  CSD009
      *                                                                         CSD009
     C*****************************************************************         CSD009
     C****While*number*of*non-zero*priorities*is*greater*than*zero*****         CSD009
     C****or*haven't*found*a*profit*centre*code*do*the*following*******         CSD009
     C*****************************************************************         CSD009
     C*****              SETON                                        30        CSD009
     C******IN30         DOWEQ     '1'                                          CSD009
     C*****COUNT         ANDGT     0                                            CSD009
     C*****************************************************************         CSD009
     C***Chain*to*LF/SDPRFML1*for*Profit*Centre************************         CSD009
     C*****FLKEY         CHAIN     @DWREHF                            55        CSD009
     C*****************************************************************         CSD009
     C***If*Profit*Centre*is*found,verify*it*in*SDPRFCPD***************         CSD009
     C******IN55         IFEQ      '0'                                          CSD009
     C*****              SETOFF                                       30        CSD009
     C*****              CALLB     'AOPRFCR0'                                   CSD009
     C*****              PARM      '*MSG   '     @RTCD                          CSD009
     C*****              PARM      '*VERIFY'     @OPTN                          CSD009
     C*****              PARM      DWPCCD        @KEY              4            CSD009
     C*****SDPRFC        PARM      SDPRFC        DSFDY                          CSD009
     C*****************************************************************         CSD009
     C***Invalid*Profit*Centre*****************************************         CSD009
     C*****@RTCD         IFNE      *BLANKS                                      CSD009
     C*****              MOVE      '2'           RTCD                           CSD009
     C*****              MOVEL     DWPCCD        PRFC                           CSD009
     C*****              END                                                    CSD009
     C*****************************************************************         CSD009
     C*****              ELSE                                                   CSD009
     C*****************************************************************         CSD009
     C***Field*with*next*lowest*priority*is*asterisked*****************         CSD009
     C*****              MOVE      COUNT         COUNTA            1            CSD009
     C*****BKPMBK        IFEQ      COUNTA                                       CSD009
     C******IN11         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         BOOK                           CSD009
     C*****              SETON                                        11        CSD009
     C*****              END                                                    CSD009
     C*****BKPMTT        IFEQ      COUNTA                                       CSD009
     C******IN12         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         TRTP                           CSD009
     C*****              SETON                                        12        CSD009
     C*****              END                                                    CSD009
     C*****BKPMST        IFEQ      COUNTA                                       CSD009
     C******IN13         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         SUTP                           CSD009
     C*****              SETON                                        13        CSD009
     C*****              END                                                    CSD009
     C*****BKPMBH        IFEQ      COUNTA                                       CSD009
     C******IN14         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         BRAN                           CSD009
     C*****              SETON                                        14        CSD009
     C*****              END                                                    CSD009
     C*****BKPMDT        IFEQ      COUNTA                                       CSD009
     C******IN15         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         DEPT                           CSD009
     C*****              SETON                                        15        CSD009
     C*****              END                                                    CSD009
     C*****BKPMUR        IFEQ      COUNTA                                       CSD009
     C******IN16         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         USER                           CSD009
     C*****              SETON                                        16        CSD009
     C*****              END                                                    CSD009
     C*****BKPMAO        IFEQ      COUNTA                                       CSD009
     C******IN17         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         ACOF                           CSD009
     C*****              SETON                                        17        CSD009
     C*****              END                                                    CSD009
     C*****BKPMCU        IFEQ      COUNTA                                       CSD009
     C******IN18         ANDEQ     '0'                                          CSD009
     C*****              MOVE      STARS         CNUM                           CSD009
     C*****              SETON                                        18        CSD009
     C*****              END                                                    CSD009
     C*****              SUB       1             COUNT                          CSD009
     C*****              END                                                    CSD009
     C*****              END                                                    CSD009
     C*****************************************************************         CSD009
     C*****END           TAG                                                    CSD009
     C*
     C** Valid Profit Centre found
     C*
     C     RTCD          IFEQ      *BLANKS
     C******IN30         IFEQ      '0'                                          CSD009
     C*****COUNT         ANDGT     0                                            CSD009
     C                   IF        RecNotFnd = False                            CSD009
     C                             AND COUNT > 0                                CSD009
     C                   MOVE      '0'           RTCD
     C                   MOVEL     DWPCCD        PRFC
     C                   ELSE
     C*                                                                   120827
     C** (Valid Profit Centre not found)                                  120827
     C** If Analytical Accounting is ON                                   120827
     C     BGN0ST        IFEQ      'Y'                                                       120827
     C*                                                                   120827
     C** force a return code of '2'                                       120827
     C                   MOVE      '2'           RTCD                                        120827
     C                   MOVEL     *BLANKS       PRFC                                        120827
     C*                                                                   120827
     C** If CAC004 is also ON, use the 'Unallocated Profit Centre'        120827
     C**                       and change the return code to '0'          120827
     C     CAC004        IFEQ      'Y'                                                       120827
     C/COPY WNCPYSRC,AOPRFMR0C4
     C     CLE051        ANDEQ     'N'                                                        CLE051
     C                   MOVE      '0'           RTCD                                        120827
     C                   MOVEL     FTUAPC        PRFC                                        120827
     C                   ENDIF                                                               120827
     C                   ELSE                                                                120827
     C*                                                                   120827
     C** (Analytical Accounting is OFF)                                   120827
     C                   MOVE      '1'           RTCD
     C                   MOVEL     *BLANKS       PRFC
     C                   ENDIF                                                               120827
     C                   END
     C                   END
      *                                                                         CSD009
      ** Seton indicator and exit program.                                      CSD009
     C                   SETON                                        LR
** CPY@
(c) Finastra International Limited 2001
