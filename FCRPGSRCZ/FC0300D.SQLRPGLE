     H DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Maintain/enquire rpt descriptions')
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility                              *
      *                                                               *
      *  FC0300D - Maintain/Enquire Rpt Dsc  Display file             *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  - Displays the records from DBF as a subfile.                *
      *  - Loads the SFL from the SBF a page at a time.               *
      *  - The DBF record at which the SFL display starts may be      *
      *    controlled by positioning fields on the SFL header.        *
      *  - Any key fields on the SFL header will be used as           *
      *    positioning values.                                        *
      *  - Any non-key fields on the SFL header will be used as       *
      *    selection values: a maximum of W0SLM records will be       *
      *    read from the DBF before giving up.                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 02Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                     CGL008        Date 03Mar99                *
      *                     CTI001        DATE 22JUL97                *
      *                     087380        DATE 10MAY95                *
      *                     081700        DATE 15MAR95                *
      *                     083547        DATE 20FEB95                *
      *                     S01486        DATE 02JUN94                *
      *                     S01496        DATE 23AUG94                *
      *                     S01522        DATE 25NOV94                *
      *                     S01502        DATE 02DEC94                *
      *                     S01493        DATE 02JUN94                *
      *                     S01407        DATE 26JAN93                *
      *                     S01393        DATE 06OCT92                *
      *                     S10736        DATE 16OCT92                *
      *                     S01117        DATE 14APR92                *
      *                     S01322        DATE 19FEB92                *
      *                     S01310        DATE 29JUL91                *
      *                     S01269        DATE 25JUN91                *
      *                     S01271        DATE 25JUN91                *
      *                     LN1200        DATE 13MAY91                *
      *                     LN1190        DATE 29APR91                *
      *                     S01314        DATE 25APR91                *
      *                     LN1146        DATE 17APR91                *
      *                     LN1174        DATE 26FEB91                *
      *                     LN0911        DATE 07NOV90                *
      *                     LN0842        DATE 23OCT90                *
      *                     LN0828        DATE 05OCT90                *
      *                     LN0792        DATE 26SEP90                *
      *                     LN0677        DATE 30AUG90                *
      *                     LN0648        DATE 20AUG90                *
      *                     LN0587        DATE 01AUG90                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *      CPB001 - 'Private Banking' Module                        *
      *      CPL002 - Midas-Plato Interface                           *
      *      CGL008 - Security on Journal Entry. Recompile.           *
      *      CTI001 - Midas / Trade Innovation Interface Phase 1      *
      *      087380 - Enlarge parameter for AOUSERR0                  *
      *      081700 - Module id 'HF' (HAF) added                      *
      *      083547 - Recompile over MUSERDD                          *
      *      S01486 - PORTFOLIO MANAGEMENT AND PORTFOLIO LENDING      *
      *               MODULES ADDED                                   *
      *      S01496 - Jyske Enhancements - Change format parameter    *
      *               from DSFDY to DSSDY for AOSTRDR0                *
      *      S01522 - USER DEFINED CORRESPONDANCE                     *
      *      S01502 - BLI TELEKURS PROCESSING. RECOMPILE NEEDED DUE   *
      *               TO CHANGE IN LENGTH IN SESTAT,133 LONG          *
      *      S01493 - MIDAS EUREKA I/F MODULE ADDED                   *
      *      S01407 - SWITCHABILITY ENHANCEMENTS                      *
      *      S01393 - RISK MANAGEMENT MODULE ADDED                    *
      *      S10736 - MANAGEMENT ACCOUNTS                             *
      *      S01117 - Recompiled for FT change to MUSERDD.            *
      *      S01322 - REMOVAL OF RT BOND + ADD IN OTHER SE SUB-MODULES*
      *      S01310 - SWIFT RATIONALISATION                           *
      *      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO     *
      *               MUSERDD                                         *
      *      S01271 - RECOMPILE FOR PAY/RECEIVE IN INPUT CYCLE        *
      *               PROCESSING                                      *
      *      LN1200 - ALLOW PRINT COMMAND KEYS TO WORK                *
      *      LN1190 - REMOVE 'USR' MESSAGES AND REPLACE WITH 'RCF'    *
      *               MESSAGES.                                       *
      *      S01314 - CHANGES DUE TO PTF INCORPORATION -              *
      *               APPLY LN1114 - REMOVE REFERENCE TO RT BOND      *
      *               INTERFACE (BVRTBI)                              *
      *      LN1146 - ENABLE CF09 IN MAINTENANCE MODE ONLY            *
      *      LN1174 - REPLACE 'SUFFIX' IN OPTION DESCRIPTION WITH     *
      *               'FILE'                                          *
      *      LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.         *
      *      LN0842 - MODULE ACCESS TO BE FROM SDMMODPD               *
      *      LN0828 - SHOULD PRESS ENTER INSTEAD OF F12 TO GET PAST   *
      *               2ND AND 3RD SCREENS                             *
      *      LN0792 - SCAN LIMIT SIZE INCREASED FROM 500 TO 99999     *
      *      LN0677 - STANDARDISE SCREEN APPEARANCE                   *
      *      LN0648 - CHANGE FIELD NAME FROM BVATBI TO BVRTBI         *
      *               FIELD RENAMED IN FILE SDSTRDPD (LN0410)         *
      *      LN0587 - REMOVE COLLATION FLAG - NOW ON FCRSFX INSTEAD   *
      *                                                               *
      *****************************************************************
      *Maintain/Enquire Rpt Dsc Initialise Program F-Spec
     F/COPY WNCPYSRC,FC0300DFPG
     FFC0300D#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Maintain/Enquire Rpt Dsc  Display file
      *
     F***FCREPTL1IF  E           K        DISK                            S01407
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
     F**********                            INFDS(INFDS1)                                   MD055265
      **RTV:*Report*Descriptions*******Retrieval*index                    LN1200
      ********************                                                LN1200
     F*FCRCOML1IF*E*******    K        DISK                               LN1200
      **RTV:*Report*Components*********Retrieval*index                    LN1200
      ********************                                                LN1200
     F*FCRREQL0IF*E*******    K        DISK                      A        LN1200
      **UPD:*Report*Requests***********Update*index                       LN1200
      ********************                                                LN1200
     D**********          UUSB    1   2 80                                LN0911
     D**********          UUSB    1   3 80                         LN0911 LN1200
     D**********                                                          LN1200
     D***ARRAY*TO*CONTAIN*SBMJOB*COMMAND***                               LN1200
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D********************AEMQ    1   4 78                                LN0677
     D AEMQ            S             78    DIM(3) CTDATA PERRCD(1)                               LN0
      *
     D************        UMAR       64  2               MIDAS modules    S10736
     D************        UMAR      114  2               MIDAS moduLS10736S01522
     D************        UMAR      128  2               MIDAS modulS01522CPB001
     D UMAR            S              2    DIM(129)                             MIDAS modules    CPB
     D*Maintain/Enquire Rpt Dsc Initialise Program E-Spec
     D/COPY WNCPYSRC,FC0300DEPG
     D********************@CN     1  20 25               Long constants.  LN0828
     D @CN             S             25    DIM(21) CTDATA PERRCD(1)             Long constants.  LN0
     D*
     D*
     D*
     D*Maintain/Enquire Rpt Dsc Initialise Program I-Spec
     D/COPY WNCPYSRC,FC0300DIPG
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
     D JBDTTM          DS
      * Job date/time.
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
      * Outward parameters.
     D PARC            DS            10
      * KEY: Report Descriptions       Retrieval index
      * B:MAP Report name
     D  PARNAM                 1     10
      *
      * Outward parameters.
     D PBRC            DS            25
      * KEY: Report Components         Retrieval index
      * I:RST Report name
     D  PBRNAM                 1     10
      *
     D*REPSEQ*****DS***                                                   LN1200
     D***********                                                         LN1200
     D***REPORT*SEQUENCE*NUMBER*DATA*AREA***                              LN1200
     D***********                                                         LN1200
     D***********                             1   50UUSEQ                 LN1200
     D*UUCMD******DS***                                                   LN1200
     D***********                                                         LN1200
     D***DATA*STRUCTURE*FOR*SETTING*UP*SBMJOB*COMMAND***                  LN1200
     D***********                                                         LN1200
     D***********                             1  80 UU1                   LN1200
     D***********                            12  21 UURNAM                LN1200
     D***********                            46  55 UUCNAM                LN1200
     D***********                                                         LN1200
     D***PARAMETERS*IF*REQUIRED***                                        LN1200
     D***********                                                         LN1200
     D***********                            62 161 UU2                   LN1200
     D***********                                                         LN1200
     D***SEQUENCE/LEVEL/ENTITY***                                         LN1200
     D***********                                                         LN1200
     D***********                           162 241 UU3                   LN1200
     D***********                           163 167 UURQSQ                LN1200
     D***********                           171 171 UULVL                 LN1200
     D***********                           175 177 UUETTY                LN1200
     D***********                           179 278 UUPARM                LN1200
     D***********                           279 280 UUBRAK                LN1200
     D***********                           281 294 UU4            LN0911 LN1200
     D*
      * Outward parameters.
     D PCRC            DS            10
      * KEY: Report Descriptions       Retrieval index
      * I:RST Report name
     D  PCRNAM                 1     10
      *
     D UUFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* 200 BYTE DATA STRUCTURE FOR INCOMING DATA ROM ACCESS PGM
     D*
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D*
     D* USER DETAILS DATA STRUCTURE FOR ASSIGNING DATA FROM ACCESS PGM
     D*
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D**
     D**     Data structure for SESTAT
     D SESTAT        E DS
     D****MMOD        DS                            256                   LN0842
     D**********                              1   1 WSDGL                 LN0842
     D**********                              2   2 WDL                   LN0842
     D**********                              3   3 WRT                   LN0842
     D**********                              4   4 WCL                   LN0842
     D**********                              5   5 WST                   LN0842
     D**********                              6   6 WBC                   LN0842
     D**********                              7   7 WEM                   LN0842
     D**********                              8   8 WFM                   LN0842
     D**********                              9   9 WSR                   LN0842
     D**********                             10  10 WLE                   LN0842
     D**********                             11  11 WFD                   LN0842
     D**********                             12  12 WCM                   LN0842
     D**********                             13  13 WFX                   LN0842
     D**********                             14  14 WMM                   LN0842
     D**********                             15  15 WCN                   LN0842
     D**********                             16  16 WRE                   LN0842
     D**********                             18  18 WMS                   LN0842
     D**********                             19  19 WAB                   LN0842
     D**********                             21  21 WSE                   LN0842
     D**********                             22  22 WRC                   LN0842
     D**********                             23  23 WIA                   LN0842
     D**********                             26  26 WSW                   LN0842
     D**********                             50  50 WFF                   LN0842
     D**********                             51  51 WMT                   LN0842
     D**********                             54  54 WMF                   LN0842
     D**********                             56  56 WNM                   LN0842
     D**********                             57  57 WFT                   LN0842
     D**********                             85  85 WOD                   LN0842
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    LN0842
     D*                                                                   LN0842
     D  WMT          E                     EXTFLD(BGMTMI)                       LN0842
     D  WSDGL        E                     EXTFLD(BGSDGL)                       LN0842
     D  WFX          E                     EXTFLD(BGDLFX)                       LN0842
     D  WCL          E                     EXTFLD(BGSYLN)                       LN0842
     D  WEM          E                     EXTFLD(BGEXMG)                       LN0842
     D  WLE          E                     EXTFLD(BGCSLN)                       LN0842
     D  WRE          E                     EXTFLD(BGRTBN)                       LN0842
     D  WMS          E                     EXTFLD(BGMSDL)                       LN0842
     D  WSE          E                     EXTFLD(BGSECS)                       LN0842
     D  WRC          E                     EXTFLD(BGAURC)                       LN0842
     D  WCM          E                     EXTFLD(BGDRCM)                       LN0842
     D  WFD          E                     EXTFLD(BGDRSD)                       LN0842
     D  WFT          E                     EXTFLD(BGFDTR)                       LN0842
     D  WTK          E                     EXTFLD(BGTSKY)                       LN0842
     D  WAB          E                     EXTFLD(BGDRAR)                       LN0842
     D  WFF          E                     EXTFLD(BGFUOP)                       LN0842
     D  WNM          E                     EXTFLD(BGNWMI)                       LN0842
     D  WFI          E                     EXTFLD(BGFIIN)                       LN0842
     D  WMM          E                     EXTFLD(BGDLMM)                       LN0842
     D  WTM          E                     EXTFLD(BGTRMG)                       LN0842
     D  WMQ          E                     EXTFLD(BGMIDQ)                       LN0842
     D  WMF          E                     EXTFLD(BGMFIC)                       LN0842
     D  WIA          E                     EXTFLD(BGIOAC)                       LN0842
     D  WCH          E                     EXTFLD(BGCHIP)                       LN0842
     D  WOD          E                     EXTFLD(BGOPDK)                       LN0842
     D*                                                                   LN0842
     D DSSDY         E DS                  EXTNAME(DSSDY)                       LN0842
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                LN0842
     D*                                                                   LN0842
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D NullInds        s              5i 0 dim(19)                                          MD055265
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * I:    Program Mode of DSPFIL
     D  P1AKST                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Action/Branch not valid'
      * *SFLSEL
     D  ZA0001                 1      1
      * Message data for 'Action/Branch not valid'
      * *SFLSEL
     D  ZA0002                 1      1
      * Message data for 'Action/Branch not valid'
      * *SFLSEL
     D  ZA0003                 1      1
      * Message data for 'Action/Branch not valid'
      * *SFLSEL
     D  ZA0004                 1      1
      * Message data for 'Action/Branch not valid'
      * *SFLSEL
     D  ZA0005                 1      1
      * Message data for 'Action/Branch not valid'
      * *SFLSEL
     D  ZA0006                 1      1
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1AKST        PARM                    WP0001            1            Program Mode of
      *****************************************************************
      *                                                                   LN1146
     C* Enable CF09 only if Program Mode is 'Maintenance'                 LN1146
     C     P1AKST        IFEQ      @CN(04)                                                     LN114
     C                   SETON                                        21                       LN114
     C                   END                                                                   LN114
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
     C                   MOVE      *BLANK        ##RNAM           10                           S0140
      * Initialise & load subfile page.
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested:
     C     W0RSF         DOWEQ     'N'
      * Display screen.
     C                   EXSR      CAEXFM
      *   Process response:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload.
     C   05              CAS                     FBRQRL
      *   Display next SFL page.
     C   27              CAS                     BBLDSF
      *   Process screen input.
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & Load subfile page.
      *================================================================
      * Clear subfile.
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile.
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialise subfile control
      * 00/Copy Member XX0300DISC - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Initialise Subf Control
     C/COPY WNCPYSRC,FC0300DISC
      * Position DBF file:
     C     KPOS          KLIST
     C                   KFLD                    DXRNAM                         Report name
      * Setup key.
     C                   MOVEL     #2RNAM        DXRNAM                         Report name
     C***********KPOS      SETLL@DXREIK                                   S01407
     C***********          READ @DXREIK                8782*82=EOF        S01407
     C*****KPOS*         SETLL     FCREPTD0                                           S0140 MD055265
     C**********         READ      FCREPTD0                             8782    *82=EOS0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare ACursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCREPJW1                                                              MD055265
     C+ where DXRNAM >= :DXRNAM                                                             MD055265
     C+ order by DXRNAM                                                                     MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open ACursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCREPT :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
      * Save previous selector values.
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2CHTP        WZCHTP
     C                   MOVEL     #2CHTP        WZCHTP                         Type of Last Ch
     C     *LIKE         DEFINE    #2CMOD        WZCMOD
     C                   MOVEL     #2CMOD        WZCMOD                         Module
     C     *LIKE         DEFINE    #2GLVL        WZGLVL
     C                   MOVEL     #2GLVL        WZGLVL                         Bank-Level
     C     *LIKE         DEFINE    #2CLVL        WZCLVL
     C                   MOVEL     #2CLVL        WZCLVL                         Company-Level
     C     *LIKE         DEFINE    #2BLVL        WZBLVL
     C                   MOVEL     #2BLVL        WZBLVL                         Branch-level
     C     *LIKE         DEFINE    #2IPCY        WZIPCY
     C                   MOVEL     #2IPCY        WZIPCY                         Input Cycle
     C     *LIKE         DEFINE    #2CLBP        WZCLBP
     C                   MOVEL     #2CLBP        WZCLBP                         COB
     C     *LIKE         DEFINE    #2PDFL        WZPDFL
     C                   MOVEL     #2PDFL        WZPDFL                         Periodic
     C************LIKE     DEFN #2COLT    WZCOLT                          LN0587
     C*********************MOVEL#2COLT    WZCOLT           Collation      LN0587
     C     *LIKE         DEFINE    #2DFTO        WZDFTO
     C                   MOVEL     #2DFTO        WZDFTO                         Default Output
     C     *LIKE         DEFINE    #2RNAM        WZRNAM
     C                   MOVEL     #2RNAM        WZRNAM                         Report name
     C     *LIKE         DEFINE    #2RDSC        WZRDSC
     C                   MOVEL     #2RDSC        WZRDSC                         Report Descript
     C     *LIKE         DEFINE    #2MIDQ        WZMIDQ
     C                   MOVEL     #2MIDQ        WZMIDQ                         Midas/Q
      * Translate search mask for text field.
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2RDSC        WQRDSC                         Report Descript
     C                   CALL      'QDCXLATE'
     C                   PARM      50            WQA5N             5 0          Len
     C                   PARM      #2RDSC        WQRDSC                         Report Descript
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      * Load subfile page.
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page.
      *================================================================
      * Re-establish fields in read-ahead record.
     C   27              DO
     C**N82******          READP@DXREIK                  90*              S01407
     C**N82******          READ @DXREIK                  90*              S01407
     C**N82*****         READP     FCREPTD0                               90    *     S0140 MD055265
     C**N82*****         READ      FCREPTD0                               90    *     S0140 MD055265
     C                   If        *IN82 = '0'                                              MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch prior from ACursor into :FCREPT :NullInds                                     MD055265
     C/END-EXEC                                                                             MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCREPT :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   Endif                                                              MD055265
     C                   END
      *
      * Setof record error indicators.
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(34)
      * Start at previous highest record in SFL.
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read.
     C                   Z-ADD     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or :
      * scan limit reached.
     C******IN82         DOWEQ     '0'                                          DO          MD055265
     C*****##RROK        ANDLT     ##SFPG                                                   MD055265
     C*****##RRRD        ANDLT     W0SLM                                                    MD055265
     C                   DOW       SQLCODE = 0                                              MD055265
     C                             and ##RROK < ##SFPG                                      MD055265
     C                             and ##RRRD < W0SLM                                       MD055265
      * Check selection fields - if fail, read next record.
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     DXLCD         CABNE     #2LCD         BB020                          Last Change Dat
     C                   END
     C     #2CHTP        IFNE      *BLANK                                       Type of Last Ch
     C     DXCHTP        CABNE     #2CHTP        BB020                          Type of Last Ch
     C                   END
     C     #2CMOD        IFNE      *BLANK                                       Module
     C     DXCMOD        CABNE     #2CMOD        BB020                          Module
     C                   END
     C     #2GLVL        IFNE      *BLANK                                       Bank-Level
     C     DXGLVL        CABNE     #2GLVL        BB020                          Bank-Level
     C                   END
     C     #2CLVL        IFNE      *BLANK                                       Company-Level
     C     DXCLVL        CABNE     #2CLVL        BB020                          Company-Level
     C                   END
     C     #2BLVL        IFNE      *BLANK                                       Branch-level
     C     DXBLVL        CABNE     #2BLVL        BB020                          Branch-level
     C                   END
     C     #2IPCY        IFNE      *BLANK                                       Input Cycle
     C     DXIPCY        CABNE     #2IPCY        BB020                          Input Cycle
     C                   END
     C     #2CLBP        IFNE      *BLANK                                       COB
     C     DXCLBP        CABNE     #2CLBP        BB020                          COB
     C                   END
     C     #2PDFL        IFNE      *BLANK                                       Periodic
     C     DXPDFL        CABNE     #2PDFL        BB020                          Periodic
     C                   END
     C***********#2COLT    IFNE *BLANK                     Collation      LN0587
     C***********DXCOLT    CABNE#2COLT    BB020            Collation      LN0587
     C******************** END                                            LN0587
     C     #2DFTO        IFNE      *BLANK                                       Default Output
      * Scan for search string.
     C                   CALL      'QCLSCAN'
     C                   PARM                    DXDFTO                         Default Output
     C                   PARM      10            WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    #2DFTO                         Mask
     C                   PARM      10            WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
     C     #2RDSC        IFNE      *BLANK                                       Report Descript
      * Scan for search string.
     C                   CALL      'QCLSCAN'
     C                   PARM                    DXRDSC                         Report Descript
     C                   PARM      50            WQA3N             3 0          Length
     C                   PARM      1             WQB3N             3 0          Start
     C                   PARM                    WQRDSC                         Mask
     C                   PARM      50            WQC3N             3 0          Length
     C                   PARM      '1'           WQD1              1            Translate
     C                   PARM      '1'           WQE1              1            Trim
     C                   PARM      '?'           WQF1              1            Wild
     C                   PARM                    WQG3N             3 0          Result
     C     WQG3N         CABLT     1             BB020
     C                   END
     C     #2MIDQ        IFNE      *BLANK                                       Midas/Q
     C     DXMIDQ        CABNE     #2MIDQ        BB020                          Midas/Q
     C                   END
      * Load SFL fields.
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record from DBF record
      * check module is available - standard functions  *
      *
      ** SAVE INDICATOR
      *
     C                   MOVE      *IN99         U99               1
     C                   MOVE      *BLANK        WUAOST
      *                                                                   S01407
      **  SET WORK FLAG TO INCORRECT IF THIS RECORD IS FOR THE SAME       S01407
      **  REPORT NAME AS THE PREVIOUS RECORD READ FROM FCREPTJ0           S01407
      *                                                                   S01407
     C     DXRNAM        IFEQ      ##RNAM                                                      S0140
     C                   MOVE      'I'           WUAOST                                        S0140
     C                   ELSE                                                                  S0140
      *
      **  OTHERWISE,                                                      S01407
      **  LOOK UP MODULE ID IN ARRAY OF INSTALLED MODULES
      *
     C     DXCMOD        LOOKUP    UMAR                                   99
      *
      ** SET WORK FLAG TO INCORRECT IF MODULE NOT FOUND
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'I'           WUAOST
     C                   END
      *                                                                   S01407
     C                   END                                                                   S0140
      *
      ** RESTORE INDICATOR
      *
     C                   MOVE      U99           *IN99
      *CASE:     WRK.work flag is Incorrect
     C     WUAOST        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(02)       W0RSL                          *Record selecte
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     @CN(03)       W0RSL                          *Record selecte
     C                   END                                                    *FI
      * 00/Copy Member XX0300DISR - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Initialise Subfile Rcd
     C/COPY WNCPYSRC,FC0300DISR
      * DBF Record not selected.
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count.
     C                   ADD       1             ##RRRD
     C                   MOVE      DXRNAM        ##RNAM                                        S0140
     C***********          READ @DXREIK                  82*82=EOF        S01407
     C**********         READ      FCREPTD0                               82    *82=EOS0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCREPT :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
      * If no DBF records found, display error message.
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point.
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      * If scan limit reached, display error message.
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen.
      *================================================================
     C     W0HLP         DOUEQ     'N'
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
      * PUTOVR unless conditioned fields change.
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8388    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input.
      *================================================================
      * Maintain subfile position where possible.
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      *
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * Validate Midas/Q
      * Name search required ?
     C                   MOVEL     #2MIDQ        W0NSRQ            1            Midas/Q
     C     W0NSRQ        IFEQ      '?'                                          Search required
     C                   CALL      'FCVLLSR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100534       Y2LSNO            7 0          List number.
     C     #2MIDQ        PARM      #2MIDQ        W0EXVL           20            Midas/Q
     C                   MOVEL     'Y'           W0DCF             1            Defer confirm
     C                   END
      * CALC: Subfile control function fields
      * 00/Copy Member XX0300DSFF - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Calculate Control Fields
     C/COPY WNCPYSRC,FC0300DSFF
      * Change of position specified.
     C     WZRNAM        CASNE     #2RNAM        FBRQRL
     C     WZRDSC        CASNE     #2RDSC        FBRQRL
     C     WZMIDQ        CASNE     #2MIDQ        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * 00/Copy Member XX0300DPSC - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Process Subfile Control
     C/COPY WNCPYSRC,FC0300DPSC
      * Reload subfile requested:
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records.
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * 00/Copy Member XX0300DFPR - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Final Processing
     C/COPY WNCPYSRC,FC0300DFPR
      * If error, Quit processing:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
      *CASE:     CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(01)       WUJTST                         Action Code
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(03)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0001            1            Action Code
     C                   PARM      WUDBRN        WQ0002            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0003            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0004            1            Action Code
     C                   PARM      WUDBRN        WQ0005            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0006            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
     C                   MOVEL     *BLANK        WURNAM                         Report name
      * Edit Report Descriptions - Report Descriptions  *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     WURNAM        PARNAM                         Report name
      *
     C** ESTABLISH LOOP FOR CALLING SUITE OF PROGRAMS                     LN0828
     C*                                                                   LN0828
     C                   MOVE      'Y'           CONTLP            1                           LN082
     C                   MOVE      '1'           PGMCAL            1                           LN082
     C                   MOVE      'I'           WUJTST                                        LN082
     C*                                                                   LN0828
     C     CONTLP        DOUEQ     'N'                                                         LN082
     C*                                                                   LN0828
     C** CALL FIRST PROGRAM IN SUITE                                      LN0828
     C*                                                                   LN0828
     C     PGMCAL        IFEQ      '1'                                                         LN082
     C                   CALL      'FC0300R'                            90      Edit Report Des
     C                   PARM      *BLANK        W0RTN             7            Return code
     C     WUJTST        PARM      WUJTST        WQ0007            1            Action Code
     C                   PARM                    PARC                           KEY: Report Des
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     PARNAM        WURNAM                         Report name
      *
      * Error detected ?
     C***********W0RTN*****IFNE *BLANK                                    LN0828
     C*********************SETON                     99    *              LN0828
     C*********************END                                            LN0828
     C     W0RTN         IFEQ      @CN(21)                                                     LN082
     C                   SETON                                        99                       LN082
     C                   MOVE      'N'           CONTLP                                        LN082
     C                   ELSE                                                                  LN082
     C     W0RTN         IFEQ      *BLANK                                                      LN082
     C                   MOVE      '2'           PGMCAL                                        LN082
     C                   END                                                                   LN082
     C                   END                                                                   LN082
     C                   END                                                                   LN082
     C*                                                                   LN0828
      *CASE:*****PGM.*Return*code*is**Normal***                           LN0828
     C***********W0RTN*****IFEQ *BLANK                     *IF            LN0828
     C*                                                                   LN0828
     C** CALL SECOND PROGRAM IN SUITE                                     LN0828
     C*                                                                   LN0828
     C     PGMCAL        IFEQ      '2'                                                         LN082
     C*                                                                   LN0828
      * Edit Report Components - Report Components  *
     C                   MOVEL     *BLANK        PBRC
     C                   MOVEL     WURNAM        PBRNAM                         Report name
      *
     C                   CALL      'FC0302M'                            90      Edit Report Com
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PBRC                           KEY: Report Com
     C*********************PARM WUJTST    WQ0008  1        Action Code    LN0828
     C                   PARM      'I'           WQ0008            1                           LN082
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C***********W0RTN*****IFNE *BLANK                                    LN0828
     C*********************SETON                     99    *              LN0828
     C*********************END                                            LN0828
     C     W0RTN         IFEQ      @CN(21)                                                     LN082
     C                   MOVE      '1'           PGMCAL                                        LN082
     C                   MOVE      'A'           WUJTST                                        LN082
     C                   ELSE                                                                  LN082
     C     W0RTN         IFEQ      *BLANK                                                      LN082
     C                   MOVE      '3'           PGMCAL                                        LN082
     C                   END                                                                   LN082
     C                   END                                                                   LN082
     C                   END                                                    *FI            LN082
      *CASE:*****PGM.*Return*code*is**Normal***                           LN0828
     C***********W0RTN*****IFEQ *BLANK                     *IF            LN0828
     C*                                                                   LN0828
     C** CALL THIRD PROGRAM IN SUITE                                      LN0828
     C*                                                                   LN0828
     C     PGMCAL        IFEQ      '3'                                                         LN082
     C*                                                                   LN0828
      * Edit Report Suffix - Report Suffix  *
     C                   CALL      'FC0301M'                            90      Edit Report Suf
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      WURNAM        WQ0009           10            Report name
     C*********************PARM WUJTST    WQ0010  1        Action Code    LN0828
     C                   PARM      'I'           WQ0010            1                           LN082
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C***********W0RTN*****IFNE *BLANK                                    LN0828
     C*********************SETON                     99    *              LN0828
     C*********************END                                            LN0828
     C     W0RTN         IFEQ      @CN(21)                                                     LN082
     C                   MOVE      '2'           PGMCAL                                        LN082
     C                   ELSE                                                                  LN082
     C     W0RTN         IFEQ      *BLANK                                                      LN082
     C                   MOVE      'N'           CONTLP                                        LN082
     C                   SETON                                        99                       LN082
     C                   END                                                                   LN082
     C                   END                                                                   LN082
     C                   END                                                    *FI
     C*                                                                   LN0828
     C** HANDLE F3 PROCESSFING FOR LOOP                                   LN0828
     C*                                                                   LN0828
     C     W0RTN         IFEQ      @CN(08)                                                     LN082
     C                   EXSR      ZYEXPG                                                      LN082
     C                   END                                                                   LN082
     C*                                                                   LN0828
     C** END OF LOOP FOR CALLING SUITE OF PROGRAMS                        LN0828
     C*                                                                   LN0828
     C                   END                                                                   LN082
     C*                                                                   LN0828
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     WUSEL         ZA0001                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     @CN(03)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'F9 not allowed'
     C                   MOVEL     'RCF0010'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     CTL.*CMD key is Print details
     C     *IN11         IFEQ      '1'                                          *IF
      * Submit Report
      **Next*Report*Sequence*No.*-*standard*functions***                  LN1200
     C***********                                                         LN1200
      ***ACCESS*DATA*AREA*REPSEQ*FOR*NEXT*SEQUENCE*NUMBER,*AND*UPDATE     LN1200
     C***********                                                         LN1200
     C************NAMVAR   DEFN           REPSEQ                          LN1200
     C************LOCK     IN   REPSEQ                                    LN1200
     C***********          MOVE UUSEQ     WURQSQ                          LN1200
     C***********          ADD  1         UUSEQ                           LN1200
     C***********          OUT  REPSEQ                                    LN1200
      **Get*Default*Output*Id*-*Report*Descriptions***                    LN1200
     C***********          EXSR SARVGN                                    LN1200
      **Retrieve*parameters*-*Report*Components***                        LN1200
     C***********          EXSR SBRVGN                                    LN1200
      *CASE:*****PGM.*Return*code*is**Record*does*not*exist***            LN1200
     C***********W0RTN     IFEQ @CN,13                     *IF            LN1200
     C***********          MOVEL@CN,14    P0RTN            *Return code   LN1200
     C***********          EXSR ZYEXPG                                    LN1200
     C***********          END                             *FI            LN1200
     C***********          MOVELWUDFTO    WUSOID           Instruction IdeLN1200
      **Set*Up*Time*-*standard functions***                               LN1200
     C***********          MOVEL##JTM     WURQTM                          LN1200
     C***********          MOVEL##USR     WUUSRR           User ID For ReqLN1200
      *CASE:*****PAR.Multi-branching*Indicator*is*Multibranch*system      LN1200
     C***********WUMBIN    IFEQ @CN,03                     *IF            LN1200
     C***********          MOVEL@CN,15    WUAPOP           Access Option  LN1200
     C***********          MOVEL@CN,16    WUAPRC           Access Program LN1200
     C***********          MOVEL*BLANK    WUETTY           Entity         LN1200
     C***********          MOVEL@CN,12    WULVL            Level          LN1200
      **Call*access*pgm*for*MUSER*-*standard*functions***                 LN1200
     C***********                                                         LN1200
     C***ACCESS*MUSER*FOR*USER'S*DEFAULT*BRANCH***                        LN1200
     C***********                                                         LN1200
     C***********          CALL 'AOUSERR0'                                LN1200
     C***********          PARM           WUAPRC  7                       LN1200
     C***********          PARM           WUAPOP  7                       LN1200
     C***********          PARM           WUUSRR 10                       LN1200
     C***********D@USER    PARM D@USER    UUFDY                           LN1200
     C***********                                                         LN1200
     C***********          MOVE DBRN      WUDBRN                          LN1200
     C***********          MOVE DPPT      WUDEPT                          LN1200
     C***********                                                         LN1200
     C***********          ELSE                                           LN1200
      *CASE:******OTHERWISE***                                            LN1200
     C***********          MOVEL*BLANK    WULVL            Level          LN1200
     C***********          MOVEL*BLANK    WUETTY           Entity         LN1200
     C***********          MOVEL*BLANK    WUDBRN           User's Branch  LN1200
     C***********          END                             *FI            LN1200
      **Create*Report*Requests*-*Report*Requests***                       LN1200
     C***********          EXSR SCCRRC                                    LN1200
      **QCMDEXC*for*submit*report*-*standard*functions***                 LN1200
     C***********                                                         LN1200
     C***SUBMIT*REPORT*TO*BATCH***                                        LN1200
     C***********                                                         LN1200
     C***********          MOVE UUSB,1    UU1                             LN1200
     C***********          MOVELUUSB,2    UU3                             LN1200
     C***********          MOVELUUSB,3    UU4                      LN0911 LN1200
     C***********          MOVEL@CN,09    UURNAM                          LN1200
     C***********          MOVEL@CN,10    UUCNAM                          LN1200
     C***********          MOVELWUCLPM    UU2                             LN1200
     C***********          MOVEL*BLANK    UUPARM                          LN1200
     C***********          MOVELWURQSQ    UURQSQ                          LN1200
     C***********          MOVEL@CN,12    UULVL                           LN1200
     C***********          MOVEL*BLANK    UUETTY                          LN1200
     C***********          MOVE '))'      UUBRAK                          LN1200
     C***********          CALL 'QCMDEXC'                                 LN1200
     C***********          PARM           UUCMD                           LN1200
     C**********           PARM 280       UULEN  155                      LN0911
     C***********          PARM 294       UULEN  155               LN0911 LN1200
     C*                                                                   LN1200
     C                   MOVEL     @CN(11)       WUSEQ             5                           LN120
     C                   MOVEL     @CN(12)       WULVL                                         LN120
     C*                                                                   LN1200
      * Call FC0040X RCF Submit - Standard functions  *                   LN1200
     C                   CALL      'FC0040X'                            90                     LN120
     C     W0RTN         PARM      W0RTN         W10003            7                           LN120
     C                   PARM      @CN(09)       W10004           10                           LN120
     C                   PARM      @CN(10)       W10005           10                           LN120
     C                   PARM      WUSEQ         W10006            5                           LN120
     C                   PARM      *BLANKS       W10007          100                           LN120
     C                   PARM      WUMBIN        W10008            1                           LN120
     C                   PARM      WULVL         W10009            1                           LN120
     C                   PARM      *BLANKS       W10010            3                           LN120
      *                                                                   LN1200
     C     *IN90         IFEQ      '1'                                                         LN120
      * Call to program ended in error.                                   LN1200
     C                   MOVEL     'Y2U0021'     W0RTN             7                           LN120
     C                   END                                                                   LN120
     C*
      *CASE:     PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
      * Send message 'Report submitted'
     C                   MOVEL     'RCF0020'     ZAMSID                         Message id.
     C                   MOVEL     '*INFO  '     ZAMSTP                         Msg type.
     C                   EXSR      ZASNMS                                       Send message
      *
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member XX0300DPCK - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Process Command Keys
     C/COPY WNCPYSRC,FC0300DPCK
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile records.
      *================================================================
     C                   READC     #SFLRCD                                88    *
     C     *IN88         DOWEQ     '0'
      * Process SFL record.
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                88    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record.
      *================================================================
      * Setof error indicators and SFLNXTCHG.
     C                   MOVEA     WKIND0        *IN(34)
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      *CASE:     RCD.*SFLSEL is Enquire Request
     C     #1SEL         IFEQ      @CN(17)                                      *IF
     C                   MOVEL     @CN(17)       WUJTST                         Action Code
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(03)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0011            1            Action Code
     C                   PARM      WUDBRN        WQ0012            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0013            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0014            1            Action Code
     C                   PARM      WUDBRN        WQ0015            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0016            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
      * Display Report Descriptn - Report Descriptions  *
     C                   MOVEL     *BLANK        PCRC
     C                   MOVEL     #1RNAM        PCRNAM                         Report name
      *
     C                   CALL      'FC0300E'                            90      Display Report
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PCRC                           KEY: Report Des
     C     WUJTST        PARM      WUJTST        WQ0017            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(03)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0002                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     RCD.*SFLSEL is Amend Request
     C     #1SEL         IFEQ      @CN(18)                                      *IF
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(18)       WUJTST                         Action Code
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(03)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0018            1            Action Code
     C                   PARM      WUDBRN        WQ0019            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0020            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0021            1            Action Code
     C                   PARM      WUDBRN        WQ0022            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0023            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
      * Edit Report Descriptions - Report Descriptions  *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     #1RNAM        PARNAM                         Report name
      *
     C                   CALL      'FC0300R'                            90      Edit Report Des
     C                   PARM      *BLANK        W0RTN             7            Return code
     C     WUJTST        PARM      WUJTST        WQ0024            1            Action Code
     C                   PARM                    PARC                           KEY: Report Des
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     PARNAM        #1RNAM                         Report name
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(03)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0003                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'Amendment not allowed'
     C                   MOVEL     'RCF0011'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     RCD.*SFLSEL is Edit Components
     C     #1SEL         IFEQ      @CN(19)                                      *IF
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(18)       WUJTST                         Action Code
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(03)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0025            1            Action Code
     C                   PARM      WUDBRN        WQ0026            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0027            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0028            1            Action Code
     C                   PARM      WUDBRN        WQ0029            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0030            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
      * Edit Report Components - Report Components  *
     C                   MOVEL     *BLANK        PBRC
     C                   MOVEL     #1RNAM        PBRNAM                         Report name
      *
     C                   CALL      'FC0302M'                            90      Edit Report Com
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM                    PBRC                           KEY: Report Com
     C                   PARM      WUJTST        WQ0031            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(03)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0004                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'Amendment not allowed'
     C                   MOVEL     'RCF0011'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     RCD.*SFLSEL is Edit Report Suffixes
     C     #1SEL         IFEQ      @CN(12)                                      *IF
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(18)       WUJTST                         Action Code
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(03)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0032            1            Action Code
     C                   PARM      WUDBRN        WQ0033            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0034            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0035            1            Action Code
     C                   PARM      WUDBRN        WQ0036            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0037            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
      * Edit Report Suffix - Report Suffix  *
     C                   CALL      'FC0301M'                            90      Edit Report Suf
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      #1RNAM        WQ0038           10            Report name
     C                   PARM      WUJTST        WQ0039            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(03)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0005                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'Amendment not allowed'
     C                   MOVEL     'RCF0011'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     RCD.*SFLSEL is *Delete request
     C     #1SEL         IFEQ      @CN(20)                                      *IF
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(20)       WUJTST                         Action Code
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(03)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0040            1            Action Code
     C                   PARM      WUDBRN        WQ0041            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0042            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      WUJTST        WQ0043            1            Action Code
     C                   PARM      WUDBRN        WQ0044            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0045            1 0          Error Flag
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      *CASE:     WRK.Error Flag is zero
     C     WUAJNB        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is one
     C     WUAJNB        IFEQ      1                                            *IF
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
      *CASE:     WRK.Error Flag is two
     C     WUAJNB        IFEQ      2                                            *IF
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid Fl
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
      * Edit Report Descriptions - Report Descriptions  *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     #1RNAM        PARNAM                         Report name
      *
     C                   CALL      'FC0300R'                            90      Edit Report Des
     C                   PARM      *BLANK        W0RTN             7            Return code
     C     WUJTST        PARM      WUJTST        WQ0046            1            Action Code
     C                   PARM                    PARC                           KEY: Report Des
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
     C                   MOVEL     PARNAM        #1RNAM                         Report name
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     @CN(03)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0006                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9834      *
      *
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'Deletion not allowed'
     C                   MOVEL     'RCF0012'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member XX0300DPSR - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Process Subfile Record
     C/COPY WNCPYSRC,FC0300DPSR
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid.
     C  N99              Z-ADD     ##RR          ##SFRC               99        Invalid SFLRCD
     C                   SETON                                        84        SFLNXTCHG
     C                   ELSE
      * SFLRCD valid.
     C                   SETOFF                                       84        SFLNXTCHG
     C                   MOVEL     *BLANK        #1SEL
     C                   END                                                    FI *IN98
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload.
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      **Move*@DXREIK****fields*to*subfile.                                S01407
      * Move FCREPTD0   fields to subfile.                                S01407
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   Z-ADD     DXLCD         #1LCD                          Last Change Dat
     C                   MOVEL     DXCHTP        #1CHTP                         Type of Last Ch
     C                   MOVEL     DXCMOD        #1CMOD                         Module
     C                   MOVEL     DXGLVL        #1GLVL                         Bank-Level
     C                   MOVEL     DXCLVL        #1CLVL                         Company-Level
     C                   MOVEL     DXBLVL        #1BLVL                         Branch-level
     C                   MOVEL     DXIPCY        #1IPCY                         Input Cycle
     C                   MOVEL     DXCLBP        #1CLBP                         COB
     C                   MOVEL     DXPDFL        #1PDFL                         Periodic
     C******************** MOVELDXCOLT    #1COLT           Collation      LN0587
     C                   MOVEL     DXDFTO        #1DFTO                         Default Output
     C                   MOVEL     DXRNAM        #1RNAM                         Report name
     C                   MOVEL     DXRDSC        #1RDSC                         Report Descript
     C                   MOVEL     DXMIDQ        #1MIDQ                         Midas/Q
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * 00/Copy Member XX0300DRFF - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Calculate Record Funcs
     C/COPY WNCPYSRC,FC0300DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2CHTP                         Type of Last Ch
     C                   MOVEL     *BLANK        #2CMOD                         Module
     C                   MOVEL     *BLANK        #2GLVL                         Bank-Level
     C                   MOVEL     *BLANK        #2CLVL                         Company-Level
     C                   MOVEL     *BLANK        #2BLVL                         Branch-level
     C                   MOVEL     *BLANK        #2IPCY                         Input Cycle
     C                   MOVEL     *BLANK        #2CLBP                         COB
     C                   MOVEL     *BLANK        #2PDFL                         Periodic
     C******************** MOVEL*BLANK    #2COLT           Collation      LN0587
     C                   MOVEL     *BLANK        #2DFTO                         Default Output
     C                   MOVEL     *BLANK        #2RNAM                         Report name
     C                   MOVEL     *BLANK        #2RDSC                         Report Descript
     C                   MOVEL     *BLANK        #2MIDQ                         Midas/Q
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     C*SR********SARVGN****BEGSR                                          LN1200
      *================================================================   LN1200
      **Get*Default*Output*Id*-*Report*Descriptions***                    LN1200
      *================================================================   LN1200
     C***********          MOVEL*BLANK    W0RTN   7                       LN1200
      **Define*Keylist.                                                   LN1200
     C***********KRSSA     KLIST                                          LN1200
     C***********          KFLD           DXRNAM           Report name    LN1200
      **Move*fields*to*key*list.***                                       LN1200
     C***********          MOVEL@CN,09    DXRNAM           Report name    LN1200
     C***********KRSSA     CHAIN@DXREIK              90    *              LN1200
     C************IN90     IFEQ '1'                                       LN1200
      **DBF*Record*not*found.***                                          LN1200
     C**********           MOVEL'USR0712' W0RTN   7                       LN1190
     C***********          MOVEL'RCF0712' W0RTN   7                LN1190 LN1200
      **USER:*Processing*if*DBF*record*not*found***                       LN1200
     C***********          MOVEL@CN,13    W0RTN            *Return code   LN1200
     C***********          GOTO SAEXIT                                    LN1200
     C***********          END                                            LN1200
      ***********                                                         LN1200
     C************IN90     IFEQ '0'                                       LN1200
      **USER:*Process*DBF*record***                                       LN1200
      **PAR*=*DB1*By*name**                                               LN1200
     C***********          MOVELDXDFTO    WUDFTO           Default Output LN1200
     C***********          END                                            LN1200
      *================================================================   LN1200
     C*SR********SAEXIT    ENDSR                                          LN1200
      /EJECT
     C*SR*********SBRVGN    BEGSR                                         LN1200
      *================================================================   LN1200
      **Retrieve*parameters*-*Report*Components***                        LN1200
      *================================================================   LN1200
     C***********          MOVEL*BLANK    W0RTN   7                       LN1200
      **Define*Keylist.***                                                LN1200
     C***********KRSSB     KLIST                                          LN1200
     C***********          KFLD           D3RNAM           Report name    LN1200
     C***********          KFLD           D3COTT           Component Name LN1200
     C***********          KFLD           D3CSEQ           Component SequeLN1200
      **Move*fields*to*key*list.***                                       LN1200
     C***********          MOVEL@CN,09    D3RNAM           Report name    LN1200
     C***********          MOVEL@CN,10    D3COTT           Component Name LN1200
     C***********          MOVEL@CN,11    D3CSEQ           Component SequeLN1200
     C***********KRSSB     CHAIN@D3REI5              90    *              LN1200
     C************IN90     IFEQ '1'                                       LN1200
      **DBF*Record*not*found.***                                          LN1200
     C**********           MOVEL'USR0724' W0RTN   7                       LN1190
     C***********          MOVEL'RCF0724' W0RTN   7                LN1190 LN1200
      **USER:*Processing*if*DBF*record*not*found***                       LN1200
     C***********          MOVEL@CN,13    W0RTN            *Return code   LN1200
     C***********          GOTO SBEXIT                                    LN1200
     C***********          END                                            LN1200
      ***********                                                         LN1200
     C************IN90     IFEQ '0'                                       LN1200
      **USER:*Process*DBF*record***                                       LN1200
      **PAR*=*DB1*By*name***                                              LN1200
     C***********          MOVELD3CLPM    WUCLPM           Calling ParametLN1200
     C***********          END                                            LN1200
      *================================================================   LN1200
     C*SR********SBEXIT    ENDSR                                          LN1200
      /EJECT
     C*SR********SCCRRC    BEGSR                                          LN1200
      *================================================================   LN1200
      **Create*Report*Requests*-*Report*Requests***                       LN1200
      *================================================================   LN1200
     C***********          MOVEL*BLANK    W0RTN   7                       LN1200
      **Move*all*fields*to*@D5REI8***                                     LN1200
     C***********          MOVELWURQSQ    D5RQSQ           Sequence NumberLN1200
     C***********          MOVEL@CN,09    D5RNAM           Report name    LN1200
     C***********          MOVELWUSOID    D5SOID           Instruction IdeLN1200
     C***********          MOVELWULVL     D5LVL            Level          LN1200
     C***********          MOVELWUETTY    D5ETTY           Entity         LN1200
     C***********          MOVEL@CN,03    D5IPCY           Input Cycle    LN1200
     C***********          MOVEL@CN,02    D5PDFL           Periodic       LN1200
     C***********          MOVEL*BLANK    D5DLS1           Distribution LiLN1200
     C***********          MOVEL*BLANK    D5DLS2           Distribution LiLN1200
     C***********          MOVEL*BLANK    D5USRO           User ID For OutLN1200
     C***********          MOVEL@CN,02    D5ARMF           Archived On MicLN1200
     C***********          MOVEL@CN,02    D5AROD           Archived On OptLN1200
     C***********          MOVEL@CN,02    D5DRQD           Distribution ReLN1200
     C***********          MOVELWUUSRR    D5USRR           User ID For ReqLN1200
     C***********          MOVELWUDBRN    D5DBRN           User's Branch  LN1200
     C***********          Z-ADDWURQTM    D5RQTM           Request Time   LN1200
     C***********          MOVEL@CN,02    D5COBR           Close Of BusineLN1200
     C***********          MOVEL*BLANK    D5JBNM           Job Name       LN1200
     C***********          MOVEL*BLANK    D5JUSR           User Name      LN1200
     C***********          MOVEL*BLANK    D5JBNB           Job Number     LN1200
     C***********          MOVEL*BLANK    D5PSQR           Periodic SequenLN1200
     C***********          MOVEL@CN,10    D5COTT           Component Name LN1200
     C***********          MOVEL@CN,11    D5CSEQ           Component SequeLN1200
     C***********          Z-ADD*ZERO     D5TNLU           Transaction No.LN1200
      ***********                                                         LN1200
     C***********KLCRSC    KLIST                                          LN1200
     C***********          KFLD           D5RQSQ           Sequence NumberLN1200
      **Check*for*duplicate*primary*key.***                               LN1200
     C***********KLCRSC    SETLL@D5REI8                  90*              LN1200
     C************IN90     IFEQ '1'                                       LN1200
     C**********           MOVEL'USR0729' W0RTN   7                       LN1190
     C***********          MOVEL'RCF0729' W0RTN   7                LN1190 LN1200
      **Send*message*'Report*Requests********EX'***                       LN1200
     C**********           MOVEL'USR0729' ZAMSID           Message id.    LN1190
     C***********          MOVEL'RCF0729' ZAMSID           Message LN1190 LN1200
     C***********          EXSR ZASNMS                     Send message   LN1200
     C***********          GOTO SCEXIT                                    LN1200
     C***********          END                                            LN1200
      ***********                                                         LN1200
     C***********          WRITE@D5REI8                91  *              LN1200
      ***********                                                         LN1200
     C************IN91     IFEQ '1'                                       LN1200
      **Write*error*detected.***                                          LN1200
     C***********          MOVEL'Y2U0004' W0RTN   7                       LN1200
     C***********          ELSE                                           LN1200
      **DBF*Write*successful.***                                          LN1200
     C***********          END                                            LN1200
      *================================================================   LN1200
     C*SR********SCEXIT    ENDSR                                          LN1200
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
      * Send if first error message or not an error message.
     C     ZAMSTP        IFNE      *BLANK
     C     ZAFSMS        ORNE      'N'
     C     ZAMSTP        IFEQ      *BLANK
      * Signal first error message sent.
     C                   MOVEL     'N'           ZAFSMS
     C                   END
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
     C                   END
      * Clear all fields for default mechanism next time.
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSID                         Message Id.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file.
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
      *================================================================
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program.
      *================================================================
      * USER: Exit program processing
      * 00/Copy Member XX0300DEPP - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Exit Program Processing
     C/COPY WNCPYSRC,FC0300DEPP
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * Terminate program.
     C                   SETON                                        LR
      *
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
      * Exit program.
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation.
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      * Define work field work flag
     C                   MOVEL     *BLANK        WUAOST            1
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUJTST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field User's Branch
     C                   MOVEL     *BLANK        WUDBRN            3
      * Define work field Entity Valid Flag
     C                   MOVEL     *BLANK        WUAFST            1
      * Define work field Error Flag
     C                   Z-ADD     *ZERO         WUAJNB            1 0
      * Define work field Report name
     C                   MOVEL     *BLANK        WURNAM           10
      * Define work field *SFLSEL
     C                   MOVEL     *BLANK        WUSEL             1
      * Obtain default message file.
     C     *DTAARA       DEFINE    FCMGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Sequence Number
     C                   MOVEL     *BLANK        WURQSQ            5
      * Define work field Default Output Id
     C                   MOVEL     *BLANK        WUDFTO           10
      * Define work field Calling Parameters
     C                   MOVEL     *BLANK        WUCLPM          100
      * Define work field Instruction Identifier
     C                   MOVEL     *BLANK        WUSOID           10
      * Define work field Request Time
     C                   Z-ADD     *ZERO         WURQTM            4 0
      * Define work field User ID For Request
     C                   MOVEL     *BLANK        WUUSRR           10
      * Define work field Access Option
     C                   MOVEL     *BLANK        WUAPOP            7
      * Define work field Access Program Return Cde
     C                   MOVEL     *BLANK        WUAPRC            7
      * Define work field Entity
     C                   MOVEL     *BLANK        WUETTY            3
      * Define work field Level
     C                   MOVEL     *BLANK        WULVL             1
      * Define work field Department
     C                   MOVEL     *BLANK        WUDEPT            3
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURUND            5 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WURUNA            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSSF             1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUDATF            1
      * Signal first error message outstanding.
     C                   MOVEL     'Y'           ZAFSMS            1
     C*********************Z-ADD13        ##SFPG  30       SFLPAG         LN0677
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG         LN067
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
     C*********************Z-ADD500       W0SLM   50       SCAN LIMIT     LN0792
     C                   Z-ADD     99999         W0SLM             5 0          SCAN LIMIT     LN079
      *................................................................
      * USER: Initialise program
      * 200 Byte Access Program - standard functions  *
      *****************************************************************
      **
      ** DEFINE 200 BYTE DATA STRUCTURE
      ** LAST AMEND : 00                         DATE : 00/00/00
      **
      * User Data Structure - standard functions  *
      *****************************************************************
      **
      ** DEFINE USER DETAILS DATA STRUCTURE
      ** LAST AMEND : 00                         DATE : 00/00/00
      **
      * Last Amd Hdr Box fc0300d - Report Descriptions  *
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
      * set up maintenance footer - Report Descriptions  *
     C     P1AKST        IFEQ      'M'
     C                   MOVEA     AEMQ(1)       ##AENA
     C                   MOVEA     AEMQ(3)       ##AFNA
     C                   END
      *
     C     P1AKST        IFEQ      'E'
     C*********************MOVEAAEMQ,2    ##AENA                          LN0677
     C*********************MOVEAAEMQ,4    ##AFNA                          LN0677
     C                   MOVEA     AEMQ(2)       ##AFNA                                        LN067
     C                   END
      *
      * set up array of modules - standard functions  *
     C********** *NAMVAR   DEFN           MMOD                            LN0842
     C     *DTAARA       DEFINE                  SESTAT
     C*  Set up an array containing ID's of modules in system
     C                   Z-ADD     1             I                 3 0
     C**********           IN   MMOD                                      LN0842
     C                   CALL      'AOMMODR0'                                                  LN084
     C                   PARM      '*DBERR  '    @RTCD             7                           LN084
     C                   PARM      '*FIRST  '    @OPTN             7                           LN084
     C     SDMMOD        PARM      SDMMOD        DSSDY                                         LN084
     C*
     C     WSDGL         IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'SD'          UMAR(I)
     C                   ADD       1             I
     C                   MOVEL     'GL'          UMAR(I)
     C                   END
     C*
     C     WMF           IFEQ      'Y'
     C********** WOD       OREQ 'Y'                                       LN0842
     C                   ADD       1             I
     C                   MOVEL     'MA'          UMAR(I)
     C                   END
     C*
     C     WOD           IFEQ      'Y'                                                         LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'OD'          UMAR(I)                                       LN084
     C                   END                                                                   LN084
     C*                                                                   LN0842
     C     WFX           IFEQ      'Y'                                                         LN084
     C     WMM           ANDEQ     'Y'                                                         LN084
     C********** WDL       IFEQ 'Y'                                       LN0842
     C                   ADD       1             I
     C                   MOVEL     'DL'          UMAR(I)
     C                   END
     C*
     C     WCL           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'CL'          UMAR(I)
     C                   END
     C*
     C** Check if FRA/IRS is present                                      LN0842
     C*                                                                   LN0842
     C     WFI           IFEQ      'Y'                                                         LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'IR'          UMAR(I)                                       LN084
     C                   END                                                                   LN084
     C*                                                                   LN0842
     C** Check if Treasury Management is present                          LN0842
     C*                                                                   LN0842
     C     WTM           IFEQ      'Y'                                                         LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'TM'          UMAR(I)                                       LN084
     C                   END                                                                   LN084
     C*                                                                   LN0842
     C** Check if Testkey Interface is present                            LN0842
     C*                                                                   LN0842
     C     WTK           IFEQ      'Y'                                                         LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'TK'          UMAR(I)                                       LN084
     C                   END                                                                   LN084
      *                                                                   S01310
      ** If any Message Generation flag on, set MG                        S01310
     C     BGSWDL        IFEQ      'Y'                                                         S0131
     C     BGSWSM        OREQ      'Y'                                                         S0131
     C     BGSWSL        OREQ      'Y'                                                         S0131
     C     BGSWCL        OREQ      'Y'                                                         S0131
     C     BGSWST        OREQ      'Y'                                                         S0131
     C     BGSWFT        OREQ      'Y'                                                         S0131
     C                   ADD       1             I                                             S0131
     C                   MOVEL     'MG'          UMAR(I)                                       S0131
     C                   END                                                                   S0131
      *                                                                   S01310
      ** Check for Message Management                                     S01310
     C     WNM           IFEQ      'Y'                                                         S0131
     C                   ADD       1             I                                             S0131
     C                   MOVEL     'ME'          UMAR(I)                                       S0131
     C                   END                                                                   S0131
      *                                                                   S01310
      ** Check for Confirmation Matching                                  S01310
     C     BGCFMT        IFEQ      'Y'                                                         S0131
     C                   ADD       1             I                                             S0131
     C                   MOVEL     'CF'          UMAR(I)                                       S0131
     C                   END                                                                   S0131
     C*                                                                   LN0842
     C** Check if MIDAS Q is present                                      LN0842
     C*                                                                   LN0842
     C     WMQ           IFEQ      'Y'                                                         LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'MQ'          UMAR(I)                                       LN084
     C                   END                                                                   LN084
     C*                                                                   LN0842
     C** Check if Midas Chips is present                                  LN0842
     C*                                                                   LN0842
     C     WCH           IFEQ      'Y'                                                         LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'CH'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C2'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C3'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C4'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C5'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C6'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C7'          UMAR(I)                                       LN084
     C                   ADD       1             I                                             LN084
     C                   MOVEL     'C8'          UMAR(I)                                       LN084
     C                   END                                                                   LN084
     C*                                                                   LN0842
     C********** WBC       IFEQ 'Y'                                       LN0842
     C**********           ADD  1         I                               LN0842
     C**********           MOVEL'BC'      UMAR,I                          LN0842
     C**********           END                                            LN0842
     C*
     C********** WSR       IFEQ 'Y'                                       LN0842
     C**********           ADD  1         I                               LN0842
     C**********           MOVEL'SR'      UMAR,I                          LN0842
     C**********           END                                            LN0842
     C*
     C     WLE           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'LE'          UMAR(I)
     C                   END
     C*
     C     WFD           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'FD'          UMAR(I)
     C                   END
     C*
     C     WCM           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'CM'          UMAR(I)
     C                   END
     C*
     C     WFX           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'FX'          UMAR(I)
     C                   END
     C*
     C     WRE           IFEQ      'Y'
     C*
     C     WIA           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'RI'          UMAR(I)
     C                   ELSE
     C                   ADD       1             I
     C                   MOVEL     'RE'          UMAR(I)
     C                   ADD       1             I
     C                   MOVEL     'RI'          UMAR(I)
     C                   END
     C**********           ELSE                                           LN0842
     C********** WRT       IFEQ 'Y'                                       LN0842
     C**********           ADD  1         I                               LN0842
     C**********           MOVEL'RT'      UMAR,I                          LN0842
     C**********           END                                            LN0842
     C                   END
     C*
     C     WEM           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'EM'          UMAR(I)
     C                   END
     C*
     C********** WST       IFEQ 'Y'                                       LN0842
     C**********           ADD  1         I                               LN0842
     C**********           MOVEL'ST'      UMAR,I                          LN0842
     C**********           END                                            LN0842
     C*
     C********** WCN       IFEQ 'Y'                                       LN0842
     C**********           ADD  1         I                               LN0842
     C**********           MOVEL'CN'      UMAR,I                          LN0842
     C**********           END                                            LN0842
     C*
     C     WFF           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'FF'          UMAR(I)
     C                   END
     C*
     C     WRC           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'RC'          UMAR(I)
     C                   END
     C*
     C     WMS           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'MS'          UMAR(I)
     C*
     C**********           ELSE                                           LN0842
     C*
     C********** WSW       IFEQ 'Y'                                       LN0842
     C**********           ADD  1         I                               LN0842
     C**********           MOVEL'SW'      UMAR,I                          LN0842
     C**********           END                                            LN0842
     C*
     C                   END
     C*
     C     WFT           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'FT'          UMAR(I)
     C                   END
     C     WMT           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'MT'          UMAR(I)
     C                   END
     C*
     C     WNM           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'NM'          UMAR(I)
     C                   END
     C*
     C     WMM           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'MM'          UMAR(I)
     C                   END
     C*                                                                   S01393
     C* CHECK FOR RISK MANAGEMENT                                         S01393
     C*                                                                   S01393
     C     BGRKMG        IFEQ      'Y'                                                         S0139
     C                   ADD       1             I                                             S0139
     C                   MOVEL     'RM'          UMAR(I)                                       S0139
     C                   END                                                                   S0139
     C*                                                                   S01393
     C* CHECK FOR MIDAS EUREKA INTERFACE MODULE                           S01493
     C*                                                                   S01493
     C     BGNZST        IFEQ      'Y'                                                         S0149
     C                   ADD       1             I                                             S0149
     C                   MOVEL     'ED'          UMAR(I)                                       S0149
     C                   END                                                                   S0149
     C*                                                                   081700
     C* CHECK FOR HISTORY AND AUDIT FACILITY                              081700
     C*                                                                   081700
     C     BGNUST        IFEQ      'Y'                                                         08170
     C                   ADD       1             I                                             08170
     C                   MOVEL     'HF'          UMAR(I)                                       08170
     C                   END                                                                   08170
     C*                                                                   S01493
     C*
     C     WAB           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'AB'          UMAR(I)
     C                   END
     C* Management Accounts                                               S10736
     C*                                                                   S10736
     C     BGNVST        IFEQ      'Y'                                                         S1073
     C                   ADD       1             I                                             S1073
     C                   MOVEL     'MC'          UMAR(I)                                       S1073
     C                   END                                                                   S1073
     C* User defined Correspondance                                       S10736
     C*                                                                   S10736
     C     BGN1ST        IFEQ      'Y'                                                         S1073
     C                   ADD       1             I                                             S1073
     C                   MOVEL     'CG'          UMAR(I)                                       S1073
     C                   END                                                                   S1073
     C*                                                                   CPL002
     C* Midas-Plato Interface                                             CPL002
     C*                                                                   CPL002
     C     BGN2ST        IFEQ      'Y'                                                         CPL00
     C                   ADD       1             I                                             CPL00
     C                   MOVEL     'PL'          UMAR(I)                                       CPL00
     C                   END                                                                   CPL00
     C**                                                                  S10736
     C     WSE           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'SE'          UMAR(I)
     C**
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C***********SDSTRD    PARM SDSTRD    UUFDY                           S01496
     C     SDSTRD        PARM      SDSTRD        DSSDY                                         S0149
     C*
     C     BVEUCD        IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'S2'          UMAR(I)
     C                   END
     C*
     C***********BVATBI    IFEQ 'Y'                                       LN0648
     C***********BVRTBI    IFEQ 'Y'                               LN0648  S01314
     C***********          ADD  1         I                               S01314
     C***********          MOVEL'S3'      UMAR,I                          S01314
     C***********          END                                            S01314
     C*
     C     BVBIOP        IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'S4'          UMAR(I)
     C                   END
     C*
     C     BVACOP        IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'S5'          UMAR(I)
     C                   END
     C*
     C     BVEXOP        IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVE      'S6'          UMAR(I)
     C                   END
     C*                                                                   S01322
     C     BVAUTH        IFNE      '00'                                                        S0132
     C                   ADD       1             I                                             S0132
     C                   MOVE      'S9'          UMAR(I)                                       S0132
     C                   END                                                                   S0132
     C*
     C*  Access DTAARA/SESTAT to determine if Portfolio Processing and
     C*  Commercial Paper Processing (proccessing Type 9) are licensed
     C*
     C                   IN        SESTAT
     C*                                                                   S01322
     C     PT6L          IFEQ      'Y'                                                         S0132
     C                   ADD       1             I                                             S0132
     C                   MOVEL     'S1'          UMAR(I)                                       S0132
     C                   END                                                                   S0132
     C*                                                                   S01322
     C     PT4L          IFEQ      'Y'                                                         S0132
     C                   ADD       1             I                                             S0132
     C                   MOVEL     'S3'          UMAR(I)                                       S0132
     C                   END                                                                   S0132
     C*
     C     PFPL          IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'S7'          UMAR(I)
     C                   END
     C*
     C     PT9L          IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'S8'          UMAR(I)
     C                   END
     C*
     C                   END
     C*                                                                   S01486
     C** CHECK FOR PORTFOLIO MANAGEMENT                                   S01486
     C*                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                         S0148
     C                   ADD       1             I                                             S0148
     C                   MOVEL     'PM'          UMAR(I)                                       S0148
     C                   END                                                                   S0148
     C*                                                                   S01486
     C** CHECK FOR PORTFOLIO LENDING                                      S01486
     C*                                                                   S01486
     C     BGLMCR        IFEQ      'Y'                                                         S0148
     C                   ADD       1             I                                             S0148
     C                   MOVEL     'LB'          UMAR(I)                                       S0148
     C                   END                                                                   S0148
     C*                                                                   CTI001
     C** Check for Midas/Trade Innovation Interface                       CTI001
     C*                                                                   CTI001
     C     BGN3ST        IFEQ      'Y'                                                         CTI00
     C                   ADD       1             I                                             CTI00
     C                   MOVEL     'TI'          UMAR(I)                                       CTI00
     C                   ENDIF                                                                 CTI00
     C*                                                                   CTI001
     C** Check for Private Banking Module                                 CPB001
     C*                                                                   CPB001
     C     BGN4ST        IFEQ      'Y'                                                         CPB00
     C                   ADD       1             I                                             CPB00
     C                   MOVEL     'PB'          UMAR(I)                                       CPB00
     C                   ENDIF                                                                 CPB00
     C*                                                                   CPB001
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance
     C     P1AKST        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(16)       WUAPRC                         Access Program
     C                   MOVEL     @CN(15)       WUAPOP                         Access Option
      * Call access pgm for MUSER - standard functions  *
     C*
     C** ACCESS MUSER FOR USER'S DEFAULT BRANCH
     C*
     C                   CALL      'AOUSERR0'
     C                   PARM                    WUAPRC            7
     C                   PARM                    WUAPOP            7
     C                   PARM                    ##USR            10
     C***********D@USER    PARM D@USER    UUFDY                           087380
     C     D@USER        PARM      D@USER        DSSDY                                         08738
     C*
     C                   MOVE      DBRN          WUDBRN
     C                   MOVE      DPPT          WUDEPT
     C*
     C                   END                                                    *FI
      * 00/Copy Member XX0300DEPG - Report Descriptions  *
      * 00/Copy Member XX0300DIPG - Report Descriptions  *
      * 00/Copy Member XX0300DFPG - Report Descriptions  *
      * 00/Copy Member XX0300DCPG - Report Descriptions  *
     C*Maintain/Enquire Rpt Dsc Initialise Program C-Spec
     C/COPY WNCPYSRC,FC0300DCPG
      * 00/Copy Member XX0300DOPG - Report Descriptions  *
      * Initialise subfile control.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Maintain/Enquire Rpt Dsc Initialise Program O-Spec
     O/COPY WNCPYSRC,FC0300DOPG
     **  UUSB - SUBMIT REPORT TO BATCH                                    LN1200
     **SBMJOB JOB(XXXXXXXXXX) JOBD(MBATCH) CMD(CALL XXXXXXXXXX PARM(      LN1200
     **'     ' ' ' '   '                                                  LN1200
     **RTGDTA(*JOBD)                                                      LN1200
** CPY@
(c) Finastra International Limited 2001
** AEMQ                                                                 /LN1174/
A=Amend   C=Report Components   D=Delete   E=Enquire   S=Report Files
E=Enquire   F3=Main Menu   F5=Refresh   F11=Print Report
F3=Main Menu   F5=Refresh   F9=Go To 'Add' Mode   F11=Print Report
** @CN Long constants used in program.
I
N
Y
M
0
1
2
Y2U9999
FC0300
FCC0304
10001
S
Y2U0005
Y2U0004
*KEY
*DBERR
E
A
C
D
RCF0790
