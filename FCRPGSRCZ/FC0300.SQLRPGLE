     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Report descriptions report')
     F********************************************************************
     F*                                                                  *
     F*  Midas - Report Control Facility Module
     F*                                                                  *
     F*      FC0300 - REPORT DESCRIPTIONS REPORT                         *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 184589             Date 28May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 186409             Date 29Dec00               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPB001             Date 02Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                     CPL002           DATE 08Mar99                *
     F*                     CTI001           DATE 22JUL97                *
     F*                     048078           DATE 09OCT95                *
     F*                     S01408           DATE 10APR95                *
     F*                     081700           DATE 15MAR95                *
     F*                     S01486           DATE 10JUN94                *
     F*                     S01522           DATE 02JUN94                *
     F*                     S01502           DATE 08JUL94                *
     F*                     S01493           DATE 02JUN94                *
     F*                     S01407           DATE 26JAN93                *
     F*                     S01393           DATE 06OCT92                *
     F*                     S10736           DATE 16OCT92                *
     F*                     S01310           DATE 29JUL91                *
     F*                     S01271           DATE 25JUN91                *
     F*                     RT0086           DATE 17MAY91                *
     F*                   . S01314           DATE 12MAR91                *
     F*                     LN0842           DATE 09OCT90                *
     F*                     LN0654           DATE 10SEP90                *
     F*                     LN0648           DATE 20AUG90                *
     F*                     LN0587           DATE 20AUG90                *
     F*                                                                  *
      ********************************************************************
      *                                                                  *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  184589 - Array index error is encountered if IC option RPTD  *
      *           is taken if report pgm has all 5 levels set to 'Y'  *
      *           in file FCREPTPD.  Need to redefine elements for    *
      *           arrays AVL and LEVL, partially applied fix 174870.  *
      *      186409 - Component FCC0304 failed due to printer file       *
      *               FC0300P1 overflow.  Change condition for checking  *
      *               overflow from line 57 to line 56 in SUBR/SUFFDT.   *
     F*      CPB001 - 'Private Banking' Module                           *
      *      CPL002 - Midas-Plato Interface
      *      CTI001 - Midas / Trade Innovation Interface Module          *
      *      048078 - PROGRAM CRASHES WITH DEC ERROR IN AUDIT MODE
     F*      S01408 - Core hook FC0300CCPG added                         *
     F*      081700 - Module id 'HF' (HAF) added                         *
      *      S01486 - ADD ACCOUNT OFFICER AND DEPARTMENT LEVELS FOR      *
      *               PRIVATE BANKING                                    *
      *      S01522 - USER DEFINED CORRESPONDANCE                        *
      *      S01502 - BLI TELEKURS PROCESSING. RECOMPILED DUE TO         *
      *               CHANGE OF LENGTH IN SESTAT, 133 LONG               *
      *      S01493 - MIDAS EUREKA INTERFACE MODULE                      *
      *      S01407 - SWITCHABILITY ENHANCEMENTS                         *
      *      S01393 - RISK MANAGEMENT MODULE ADDED                       *
      *      S10736 - MANAGEMENT ACCOUNTS
      *      S01310 - SWIFT RATIONALISATION
      *      S01271 - RECOMPILE FOR PAY/RECEIVE IN INPUT CYCLE           *
      *               PROCESSING                                         *
      *      RT0086 - RECOMPILE OVER CHANGED VERSION OF FC0300AU.
      *      S01314 - CHANGES FOR PTF INCORPORATION (APPLY FIX LN1114)   *
      *      LN0842 - MODULE ACCESS TO BE FROM SDMMODPD                  *LN0842
      *      LN0654 - REPORT FORMATS CHANGED TO ENSURE CORRECT VALUE OF  *
      *               MOVED COLLATION INDICATOR DISPLAYED (SEE LN0587)   *
      *      LN0648 - CHANGE FIELD NAME FROM BVATBI TO BVRTBI            *
      *               FIELD RENAMED IN FILE SDSTRDPD (LN0410)            *
      *      LN0587 - MOVE OF COLLATION FLAG - NOW ON FCRSFX INSTEAD     *
      *               OF FCREPT                                          *
     F*                                                                  *
      ********************************************************************
      * USE OF INDICATORS *
      *
      * 05   FLAG - AT LEAST ONE RECORD ON REPORT (AUDIT MODE)
      * 50   AUDIT MODE
      * 70   WORK INDICATOR FOR LOKUPS
      * 80   REPORT DESCRIPTIONS END OF FILE
      * 88   REPORT COMPONENTS END OF FILE
      * 89   REPORT SUFFIXES END OF FILE
      * 98   MMDDYY DATE FORMAT
      *
      * U1   AUDIT MODE
      * U8   FILE CONTROLS OUT OF BALANCE
      *
      ********************************************************************
     F***********FCREPTL1IF  E           K        DISK                    S01407
     F***********FCRCOML1IF  E           K        DISK                    S01407
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
     F*FCRCOMJ1* IF   E           K DISK                                         S01407     MD055265
     F*FCRSFXL1* IF   E           K DISK                                                    MD055265
     FFCRPDSL0  UF   E           K DISK
     FFC0300P1  O    E             PRINTER INFDS(SPOOL)
     FFC0300AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     EXTIND(*INU1)
      *
     D************        UMAR       64  2               MIDAS modules    S10736
     D**************      UMAR      114  2               MIDAS modulS10736S01522
     D**************      UMAR      128  2               MIDAS modulS01522CPB001
     D UMAR            S              2    DIM(129)                             MIDAS modules    CPB
     D********************TXT     1  11 11                                LN0654
     D***********         TXT     1  10 11                          LN0654S01486
     D TXT             S             11    DIM(12) CTDATA PERRCD(1)                              S01
      *COPY*ZSRSRC,ZDATE2Z1                                                                 MD055265
      /COPY ZSRSRC,ZDATE2Z1LE                                                               MD055265
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D TEMP            S              1    DIM(16)
     D***********         AVL         4 10                                184589
     D AVL             S             10    DIM(9)                                                184
     D***********         LEVL        4  7                                184589
     D LEVL            S              7    DIM(9)                                                184
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** 200 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS
      *
     D P@BANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Bank ICD Access Program record format data structure
      *
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
     D  WED          E                     EXTFLD(BGNZST)                       S01493
     D*                                                                   LN0842
     D DSSDY         E DS                  EXTNAME(DSSDY)                       LN0842
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                LN0842
     D*                                                                   LN0842
     D LDA             DS           256
     D*
     D** LOCAL DATA AREA FOR DATABASE ERROR REPORTING
     D*
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D PSDS           SDS
      *
      **  Program status data structure.
      *
     D  @NOPMS                37     39  0
     D  WSID                 244    253
     D  @USER                254    263
     D  @JOBNO               264    269  0
     D*
     D SPOOL           DS
     D*
     D** SPOOL INFORMATION DATA STRUCTURE FOR ZSFILE
     D*
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  LINE                 367    368B 0
     D*
     D SPOOLU          DS
     D*
     D** SPOOL INFORMATION DATA STRUCTURE
     D*
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D*                                                                   S01407
     D PRCMSQ          DS            15                                         S01407
     D*                                                                   S01407
     D** PREVIOUS REPORT COMPONENT/SEQUENCE COMBINATION                   S01407
     D*                                                                   S01407
     D  ##COTT                 1     10                                         S01407
     D  ##CSEQ                11     15                                         S01407
     D*                                                                   S01407
     D CUCMSQ          DS            15                                         S01407
     D*                                                                   S01407
     D** CURRENT REPORT COMPONENT/SEQUENCE COMBINATION                    S01407
     D*                                                                   S01407
     D**D3COTT***              1     10                                         S01407      MD055265
     D  X3COTT                 1     10                                         S01407      MD055265
     D**D3CSEQ***             11     15                                         S01407      MD055265
     D  X3CSEQ                11     15                                         S01407      MD055265
     D FCRCOM        E DS                  EXTNAME(FCRCOJW1)                                MD055265
     D  XSARD        E                     EXTFLD(SARD)                                     MD055265
     D NullInds        s              5i 0 dim(12)                                          MD055265
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D NullInds2       s              5i 0 dim(19)                                          MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
      /EJECT
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** PARAMETER PASSED FROM FCC0304
     C*
     C     *ENTRY        PLIST
     C                   PARM                    PSSEQ             5
     C                   PARM                    PLVL              1
     C                   PARM                    PETTY             3
      ********************************************************************
      * CONTROL SECTION
      ********************************************************************
     C                   EXSR      AINIT
     C                   EXSR      BMAIN
     C                   EXSR      CTERM
      ********************************************************************
      * AINIT - INITIALISATION
      ********************************************************************
     C*
     C     AINIT         BEGSR
     C*
     C   U1              SETON                                        50
     C*
     C** ACCESS LF/SDBANKL1 FOR USER REPORT TITLE AND RUN DATE
     C*
     C                   CALL      'AOBANKR0'                                     <BANK ICD>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7              I:Option
     C     P@BANK        PARM      P@BANK        DSFDY                            O:Rec.format
     C*
     C** IF NO RECORD FOUND THEN PERORM DATABASE ERROR PROCESSING
     C*
     C     P@RTC2        IFNE      *BLANK
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0300'      DBPGM
     C                   MOVEL     'SDBANKL0'    DBFILE
     C                   MOVEL     'BANK'        DBKEY                          *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   SETON                                        U7U8      *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
      ** SET UP REPORT HEADINGS FIELDS: TITLE AND RUN DATE
     C*
     C                   MOVEL     BJURPT        TITL
     C                   MOVEL     BJMRDT        RUNA
     C                   Z-ADD     BJRDNB        RUND              5 0                         04807
     C*
     C** SET DATE FORMAT INDICATOR
     C*
     C     BJDFIN        COMP      'M'                                    98
     C*
     C** CALL ZSFILE TO REGISTER SPOOL FILE ENTRY OF MAIN PRINTER FILE
     C*
     C                   CALL      'ZSFILE'
     C                   PARM                    PSSEQ
     C                   PARM                    PETTY
     C                   PARM                    SFILE
     C                   PARM      SFNUM         ZSFNO             6 0
     C                   PARM                    PERR              1
     C*
     C** IF ERROR CODE = 'Y' THEN TERMINATE THE PROGRAM
     C*
     C     PERR          IFEQ      'Y'
     C                   EXSR      CTERM
     C                   END
     C*
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
     C* CHECH FOR RISK MANAGEMENT                                         S01393
     C*                                                                   S01393
     C     BGRKMG        IFEQ      'Y'                                                         S0139
     C                   ADD       1             I                                             S0139
     C                   MOVEL     'RM'          UMAR(I)                                       S0139
     C                   END                                                                   S0139
     C*                                                                   S01393
     C*                                                                   S01493
     C* CHECK FOR 'ED' MODULE - MIDAS EUREKA INTERFACE                    S01493
     C*                                                                   S01493
     C     WED           IFEQ      'Y'                                                         S0149
     C                   ADD       1             I                                             S0149
     C                   MOVEL     'ED'          UMAR(I)                                       S0149
     C                   END                                                                   S0149
     C*                                                                   S01493
     C* CHECK FOR HISTORY AND AUDIT FACILITY                              081700
     C*                                                                   081700
     C     BGNUST        IFEQ      'Y'                                                         08170
     C                   ADD       1             I                                             08170
     C                   MOVEL     'HF'          UMAR(I)                                       08170
     C                   END                                                                   08170
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
     C**                                                                  S10736
     C*  User Defined Correspondance                                      S01522
     C     BGN1ST        IFEQ      'Y'                                                         S0152
     C                   ADD       1             I                                             S0152
     C                   MOVEL     'CG'          UMAR(I)                                       S0152
     C                   END                                                                   S0152
     C*                                                                   CPL002
     C** Midas-Plato Interface                                            CPL002
     C     BGN2ST        IFEQ      'Y'                                                         CPL00
     C                   ADD       1             I                                             CPL00
     C                   MOVEL     'PL'          UMAR(I)                                       CPL00
     C                   END                                                                   CPL00
     C**
     C     WSE           IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'SE'          UMAR(I)
     C**
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C********** SDSTRD    PARM SDSTRD    DSFDY                           S10736
     C     SDSTRD        PARM      SDSTRD        DSSDY                                         S1073
     C*
     C     BVEUCD        IFEQ      'Y'
     C                   ADD       1             I
     C                   MOVEL     'S2'          UMAR(I)
     C                   END
     C*
     C***********BVATBI    IFEQ 'Y'                                       LN0648
     C***********BVRTBI    IFEQ 'Y'                                 LN0648S01314
     C*********************ADD  1         I                               S01314
     C*********************MOVEL'S3'      UMAR,I                          S01314
     C*********************END                                            S01314
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
     C*
     C*  Access DTAARA/SESTAT to determine if Portfolio Processing and
     C*  Commercial Paper Processing (proccessing Type 9) are licensed
     C*
     C                   IN        SESTAT
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
     C*                                                                   S01408
     C* Check for Midas/Trade Innovation Interface                        CTI001
     C*                                                                   CTI001
     C     BGN3ST        IFEQ      'Y'                                                         CTI00
     C                   ADD       1             I                                             CTI00
     C                   MOVEL     'TI'          UMAR(I)                                       CTI00
     C                   ENDIF                                                                 CTI00
     C*                                                                   CTI001
     C* Check for Private Banking Module                                  CPB001
     C*                                                                   CPB001
     C     BGN4ST        IFEQ      'Y'                                                         CPB00
     C                   ADD       1             I                                             CPB00
     C                   MOVEL     'PB'          UMAR(I)                                       CPB00
     C                   ENDIF                                                                 CPB00
     C*                                                                   CPB001
     C/COPY WNCPYSRC,FC0300CCPG                                           S01408
     C*                                                                   S01408
     C*                                                                   S01407
     C** INITIALISE WORK FIELDS TO BLANK                                  S01407
     C*                                                                   S01407
     C                   MOVE      *BLANKS       ##RNAM           10                           S0140
     C                   MOVE      *BLANKS       PRCMSQ                                        S0140
     C*
     C                   ENDSR
      ********************************************************************
      * BMAIN - MAIN PROCESSING
      ********************************************************************
     C*
     C     BMAIN         BEGSR
      *
      ***READ*FILE*FCREPTL1*-*REPORT*DESCRIPTIONS*DETAILS*RETRIEVAL*INDEX S01407
      ** READ FILE FCREPTJ0 - JOIN REPORT NAME TO SAR RELATED REPORT      S01407
      ** NAME                                                             S01407
      *
     C***********          READ FCREPTL1                 80               S01407
     C**********         READ      FCREPTJ0                               80          S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare BCursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCREPJW1                                                              MD055265
     C+ order by DXRNAM                                                                     MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open BCursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from BCursor into :FCREPT :NullInds2                                     MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       80                    MD055265
     C                   IF        SQLCODE = 0                                              MD055265
     C                   SETON                                        80                    MD055265
     C                   ENDIF                                                              MD055265
      *
      ** WRITE DETAILS FOR RECORDS AVAILABLE
      *
     C     *IN80         IFEQ      '0'
     C                   EXSR      DETDES
     C                   END
      *
      ** IF NO RECORD FOUND THEN WRITE BLANK REPORT
      *
     C     *IN05         IFEQ      '0'
     C                   EXSR      NODETS
     C                   END
      *
     C** IF SWITCH 1 IS ON THEN WRITE AUDIT REPORT
      *
     C     *INU1         IFEQ      '1'
     C                   EXSR      PROAUD
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      * DETDES - WRITE DETAIL DESCRIPTIONS
      ********************************************************************
      *
     C     DETDES        BEGSR
     C*
     C** RESET FLAG
     C*
     C                   SETOFF                                           05
      *
      ** FOR EACH DETAIL RECORD FOUND
      *
     C     *IN80         DOWEQ     '0'
     C*                                                                   S01407
     C** ONLY PROCESS THIS RECORD IF IT IS FOR A DIFFERENT REPORT NAME    S01407
     C** TO THE PREVIOUS RECORD                                           S01407
     C*                                                                   S01407
     C     DXRNAM        IFNE      ##RNAM                                                      S0140
      *
      *
      **  LOOK UP MODULE ID IN ARRAY OF INSTALLED MODULES: PRINT ONLY
      **  DETAILS FOR MODULES WHICH ARE PRESENT
      *
     C     DXCMOD        LOOKUP    UMAR                                   70
      *
      ** CHECK LAST CHANGE DATE = RUN DATE IF AUDIT REPORT
      *
     C***U1*70***DXLCD*****COMP BJRDNB                   70               048078
     C   U1
     CAN 70DXLCD         COMP      RUND                                   70                   04807
      *
     C     *IN70         IFEQ      '1'
      *
      ** AT LEAST ONE RECORD ON REPORT WITH LAST CHANGE ON RUN DATE
      *
     C  N05              MOVE      '1'           *IN05
      *
      ** WRITE REPORT HEADINGS/REPORT DESCRIPTIONS MAIN DETAILS
      *
     C                   EXSR      HEADMN
     C*
     C***ACCESS*FCRCOML1*FOR*ALL*COMPONENTS*ASSOCIATED*WITH*THE*RECORD    S01407
     C** ACCESS FCRCOMJ1 FOR ALL COMPONENTS ASSOCIATED WITH THE RECORD    S01407
     C*
     C***********DXRNAM    SETLLFCRCOML1                                  S01407
     C***********DXRNAM    READEFCRCOML1                 88               S01407
     C*****DXRNAM        SETLL     FCRCOMJ1                                           S0140 MD055265
     C*****DXRNAM        READE     FCRCOMJ1                               88          S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare ACursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCRCOJW1                                                              MD055265
     C+ where D3RNAM = :DXRNAM                                                              MD055265
     C+ order by D3RNAM, D3COTT, D3CSEQ                                                     MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open ACursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRCOM :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       88                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        88                    MD055265
     C                   Endif                                                              MD055265
      *
      ** IF NO COMPONENTS RECORD FOUND THEN DATABASE ERROR
      *
     C     *IN88         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0300'      DBPGM
     C***********          MOVEL'FCRCOML1'DBFILE                          S01407
     C                   MOVEL     'FCRCOMJ1'    DBFILE                                        S0140
     C                   MOVEL     DXRNAM        DBKEY                          *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   SETON                                        U7U8      *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** WRITE THE DETAILS FOR REPORT COMPONENTS FOR THIS REPORT NAME
     C*
     C                   EXSR      COMPDT
     C*
     C** ACCESS FCRSFXL1 FOR REPORT SUFFIXES
     C*
     C*****DXRNAM        SETLL     FCRSFXL1                                                 MD055265
     C*****DXRNAM        READE     FCRSFXL1                               89                MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare CCursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCRSFJW0                                                              MD055265
     C+ where DYRNAM = :DXRNAM                                                              MD055265
     C+ order by DYRNAM, DYRSFX                                                             MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close CCursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open CCursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from CCursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
      *
      ** IF NO SUFFIXES RECORD FOUND THEN DATABASE ERROR
      *
     C******IN89         IFEQ      '1'                                                      MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0300'      DBPGM
     C                   MOVEL     'FCRSFXL1'    DBFILE
     C                   MOVEL     DXRNAM        DBKEY                          *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   SETON                                        U7U8      *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** WRITE THE DETAILS FOR REPORT SUFFIXES FOR THIS REPORT NAME
     C*
     C                   EXSR      SUFFDT
     C*
     C                   END
     C                   END                                                                   S0140
     C*                                                                   S01407
     C                   MOVE      DXRNAM        ##RNAM                                        S0140
     C                   MOVE      *BLANKS       PRCMSQ                                        S0140
     C*
     C** READ NEXT RECORD ON REPORT DESCRIPTIONS FILE
     C*
     C***********          READ FCREPTL1                 80               S01407
     C**********         READ      FCREPTJ0                               80          S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from BCursor into :FCREPT :NullInds2                                     MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       80                    MD055265
     C                   IF        SQLCODE = 0                                              MD055265
     C                   SETON                                        80                    MD055265
     C                   ENDIF                                                              MD055265
     C*
     C                   END
      *
      ** WRITE 'END OF REPORT' TEXT
      *
     C     *IN05         IFEQ      '1'
     C                   WRITE     FC0300F6
     C                   END
     C*
     C                   ENDSR
     C*
      ********************************************************************
      * HEADMN - MAIN REPORT HEADINGS/REPORT DESCRIPTION MAIN DETAILS
      ********************************************************************
      *
     C     HEADMN        BEGSR
      *
      ** WRITE PAGE HEADINGS
      *
     C                   WRITE     FC0300H0
      *
      ** SET UP REPORT DETAILS FOR MAIN REPORT DESCRIPTIONS RECORD
      *
      ** REPORT NAME/MODULE ID
      *
     C                   MOVEA     *BLANK        TEMP
     C                   MOVEA     DXRNAM        TEMP
     C                   Z-ADD     1             Y                 2 0
     C     ' '           LOOKUP    TEMP(Y)                                70
     C                   MOVE      '/'           TEMP(Y)
     C                   ADD       1             Y
     C                   MOVEA     DXCMOD        TEMP(Y)
     C                   MOVEA     TEMP          REPMOD
      *
      ** REPORT DESCRIPTION
      *
     C                   MOVEL     DXRDSC        RDESC
     C*
      ** SET UP ARRAYS OF LEVEL/AVAILABLITY
     C*
     C                   MOVEA     *BLANK        LEVL
     C                   MOVEA     *BLANK        AVL
     C                   Z-ADD     0             L                 1 0
     C                   Z-ADD     0             A                 1 0
      *
      ** CONVERT BRANCH LEVEL FIELD TO TEXT
      *
     C     DXBLVL        IFEQ      'Y'
     C                   ADD       1             L
     C                   MOVEL     TXT(1)        LEVL(L)
     C                   END
      *
      ** CONVERT COMPANY LEVEL FIELD TO TEXT
      *
     C     DXCLVL        IFEQ      'Y'
     C                   ADD       1             L
     C                   MOVEL     TXT(2)        LEVL(L)
     C                   END
      *
      ** CONVERT SYSTEM LEVEL FIELD TO TEXT
      *
     C     DXGLVL        IFEQ      'Y'
     C                   ADD       1             L
     C                   MOVEL     TXT(3)        LEVL(L)
     C                   END
     C*                                                                   S01486
     C** CONVERT ACCOUNT OFFICER LEVEL FIELD TO TEXT                      S01486
     C*                                                                   S01486
     C     DXALVL        IFEQ      'Y'                                                         S0148
     C                   ADD       1             L                                             S0148
     C                   MOVEL     TXT(11)       LEVL(L)                                       S0148
     C                   END                                                                   S0148
     C*                                                                   S01486
     C** CONVERT DEPARTMENT LEVEL FIELD TO TEXT                           S01486
     C*                                                                   S01486
     C     DXDLVL        IFEQ      'Y'                                                         S0148
     C                   ADD       1             L                                             S0148
     C                   MOVEL     TXT(12)       LEVL(L)                                       S0148
     C                   END                                                                   S0148
      *
      ** CONVERT 'AVAILABLE DURING INPUT CYCLE'
      *
     C     DXIPCY        IFEQ      'Y'
     C                   ADD       1             A
     C                   MOVEL     TXT(4)        AVL(A)
     C                   END
      *
      ** CONVERT 'AVAILABLE AT CLOSE OF BUSINESS'
      *
     C     DXCLBP        IFEQ      'Y'
     C                   ADD       1             A
     C                   MOVEL     TXT(5)        AVL(A)
     C                   END
      *
      ** CONVERT 'AVAILABLE PERIODICALLY'
      *
     C     DXPDFL        IFEQ      'Y'
     C                   ADD       1             A
     C                   MOVEL     TXT(6)        AVL(A)
     C                   END
      *
      ***CONVERT*'AVAILABLE*FOR*COLLATION'                                LN0654
      *********************                                               LN0654
     C***********DXCOLT****IFEQ 'Y'                                 LN0587LN0654
     C***********DYCOLT****IFEQ 'Y'                                 LN0587LN0654
     C*********************ADD  1         A                               LN0654
     C*********************MOVELTXT,7     AVL,A                           LN0654
     C*********************END                                            LN0654
      *
      ** NUMBER OF PRINTER FILES
      *
      *
      ** DEFAULT OUTPUT ID
      *
     C                   MOVEL     DXDFTO        OUTPID
      *
      ** LAST CHANGE DATE
      *
     C                   Z-ADD     DXLCD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        LDATE
      *
      ** CHANGE TYPE (INSERT/AMEND)
      *
     C     DXCHTP        IFEQ      'I'
     C                   MOVEL     'INSERT'      CHTYP
     C                   ELSE
     C                   MOVEL     'AMEND '      CHTYP
     C                   END
      *
      ** WRITE FORMAT OF REPORT DETAIL FIRST LINE
      *
     C                   MOVE      LEVL(1)       LEVEL
     C                   MOVE      AVL(1)        PROD
     C                   WRITE     FC0300F1
     C*
      ** PRINT FURTHER LEVELS/PRODUCTION AVAILABLITY
     C*
     C                   Z-ADD     1             X                 1 0
      *
     C     A             DOWGT     X
     C     L             ORGT      X
     C                   ADD       1             X
     C                   MOVE      AVL(X)        PROD
     C                   MOVE      LEVL(X)       LEVEL
     C                   WRITE     DETLCONT
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      * COMPDT - WRITE DETAILS FOR REPORT COMPONENTS
      ********************************************************************
      *
     C     COMPDT        BEGSR
      *
      ** WRITE COMPONENT LEVEL HEADINGS
      *
     C                   WRITE     FC0300H1
      *
      ** PROCESS ALL REPORT COMPONENTS FOR THIS REPORT NAME
      *
     C     *IN88         DOWEQ     '0'
     C*                                                                   S01407
     C** ONLY PROCESS THIS RECORD IF IT IS FOR THE SAME SAR NUMBER AS     S01407
     C** ON THE RECORD READ FROM FCREPTJ0                                 S01407
     C*                                                                   S01407
     C     AESARN        IFEQ      AHSARN                                                      S0140
     C*                                                                   S01407
     C** ONLY PROCESS THIS RECORD IF IT IS FOR A DIFFERENT COMPONENT      S01407
     C** NAME/SEQUENCE COMBINATION TO THE PREVIOUS RECORD                 S01407
     C*                                                                   S01407
     C                   eval      X3COTT = D3COTT                                          MD055265
     C                   eval      X3CSEQ = D3CSEQ                                          MD055265
     C     CUCMSQ        IFNE      PRCMSQ                                                      S0140
      *
      ** FORMAT COMPONENT NAME/SEQUENCE
      *
     C                   MOVEA     *BLANK        TEMP
     C                   MOVEA     D3COTT        TEMP
     C                   Z-ADD     1             Y                 2 0
     C     ' '           LOOKUP    TEMP(Y)                                70
     C                   MOVE      '/'           TEMP(Y)
     C                   ADD       1             Y
     C                   MOVEA     D3CSEQ        TEMP(Y)
     C                   MOVEA     TEMP          CPNSEQ
      *
      ** FORMAT ADDITIONAL TEXT
      *
     C                   MOVEL     D3ADTX        ADDTXT
      *
      ** CONVERT AVAILABILITY TO TEXT MANDATORY/ON REQUEST
      *
     C     D3MORQ        IFEQ      'M'
     C*********************MOVELTXT,8     AVAIL                           LN0654
     C                   MOVEL     TXT(7)        AVAIL                                         LN065
     C                   ELSE
     C*********************MOVELTXT,9     AVAIL                           LN0654
     C                   MOVEL     TXT(8)        AVAIL                                         LN065
     C                   END
      *
      ** CONVERT BRANCH TYPE TO TEXT ORIGINATING/BOOKING
      *
     C     D3BRTP        IFEQ      'O'
     C*********************MOVELTXT,11    BRTYPE                          LN0654
     C                   MOVEL     TXT(10)       BRTYPE                                        LN065
     C                   ELSE
     C*********************MOVELTXT,10    BRTYPE                          LN0654
     C                   MOVEL     TXT(9)        BRTYPE                                        LN065
     C                   END
      *
      ** PROMPT PROGRAM NAME
      *
     C                   MOVEL     D3PRPG        PRPTPG
      *
      ** CHECK IF OVERFLOW WILL OCCUR: IF SO, WRITE HEADINGS AGAIN
      *
     C     LINE          IFGE      56
     C                   WRITE     FC0300H0
     C                   WRITE     FC0300H1
     C                   END
      *
      ** WRITE DETAILS FOR COMPONENT
      *
     C                   WRITE     FC0300F2
      *
      ** IF PARAMETERS EXIST, PRINT PARAMETERS
      *
     C     D3CLPM        IFNE      *BLANKS
     C                   MOVEL     D3CLPM        PARMS
     C                   WRITE     FC0300F3
     C                   END
     C                   END                                                                   S0140
     C*                                                                   S01407
     C                   MOVE      CUCMSQ        PRCMSQ                                        S0140
     C                   END                                                                   S0140
      *
      ** ACCESS NEXT COMPONENT
      *
     C***********DXRNAM    READEFCRCOML1                 88               S01407
     C*****DXRNAM        READE     FCRCOMJ1                               88          S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRCOM :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       88                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        88                    MD055265
     C                   Endif                                                              MD055265
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      * SUFFDT - WRITE DETAILS FOR REPORT SUFFIX
      ********************************************************************
      *
     C     SUFFDT        BEGSR
      *
      ** PRINT HEADINGS IF NOT ENOUGH ROOM FOR NEXT FORMAT
      *
     C********   LINE      IFGE 57                                        186409
     C     LINE          IFGE      56                                                          18640
     C                   WRITE     FC0300H0
     C                   END
      *
      ** PRINT LEVEL HEADERS FOR SUFFIXES
      *
     C                   WRITE     FC0300H2
      *
      ** PROCESS SUFFIX RECORD
      *
     C******IN89         DOWEQ     '0'                                                      MD055265
     C                   DOW       SQLCODE = 0                                              MD055265
      *
      ** PRINT HEADINGS IF NOT ENOUGH ROOM FOR NEXT FORMAT
      *
     C********   LINE      IFGE 57                                        186409
     C     LINE          IFGE      56                                                          18640
     C                   WRITE     FC0300H0
     C                   WRITE     FC0300H2
     C                   END
      *
      ** PRINT DETAILS
      *
     C                   WRITE     FC0300F4
      *
      ** READ NEXT SUFFIX FOR THE REPORT
      *
     C*****DXRNAM        READE     FCRSFXL1                               89                MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from CCursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      * NODETS - WRITE BLANK REPORT
      ********************************************************************
      *
     C     NODETS        BEGSR
      *
      ** WRITE HEADINGS/NO DETAILS TO REPORT/END OF REPORT FORMATS
      *
     C                   WRITE     FC0300H0
     C                   WRITE     FC0300F5
     C                   WRITE     FC0300F6
      *
     C                   ENDSR
      ********************************************************************
      * PROAUD - WRITE AUDIT REPORT
      ********************************************************************
      *
     C     PROAUD        BEGSR
      *
     C                   READ      FCRPDSL0                               90
      *
      ** IF NO RECORD FOUND THEN DATABASE ERROR
      *
     C     *IN90         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0300'      DBPGM
     C                   MOVEL     'FCRPDSL0'    DBFILE
     C                   MOVEL     'AUDIT'       DBKEY                          *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   SETON                                        U7U8      *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** CALL ZSFILE TO REGISTER SPOOL FILE ENTRY OF MAIN PRINTER FILE
     C*
     C                   CALL      'ZSFILE'
     C                   PARM                    PSSEQ
     C                   PARM                    PETTY
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        ZSFNO             6 0
     C                   PARM                    PERR              1
     C*
     C** FORMAT NUMBER OF INSERTIONS FOR REPORT
     C*
     C                   Z-ADD     ADNOIN        INSF
     C*
     C** FORMAT NUMBER OF DELETIONS/AMENDMENTS FOR REPORT
     C*
     C                   Z-ADD     ADNOAM        AMDF
     C                   Z-ADD     ADNODL        DELF
     C*
     C** NUMBER OF RECORDS ON FILE
     C*
     C                   Z-ADD     ADNORC        RECFIL
     C*
     C** WRITE AUDIT REPORT
     C*
     C                   WRITE     AU0300H0
     C                   WRITE     AU0300F1
     C*
     C** RESET FILE CONTROLS AND UPDATE
     C*
     C                   Z-ADD     0             ADNOIN
     C                   Z-ADD     0             ADNOAM
     C                   Z-ADD     0             ADNODL
     C*
     C                   UPDATE    @ADREBB
     C*
     C                   ENDSR
      *****************************************************************
      * *PSSR - DATABASE ERROR HANDLING ROUTINE
      *****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   EXSR      CTERM
     C*
     C                   ENDSR
      *****************************************************************
      * CTERM - PROGRAM TERMINATION
      *****************************************************************
     C*
     C     CTERM         BEGSR
     C*
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close BCursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close CCursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C                   SETON                                        LR
     C                   RETURN
     C*
     C                   ENDSR
      *****************************************************************
      *COPY*ZSRSRC,ZDATE2Z2                                                                 MD055265
      /COPY ZSRSRC,ZDATE2Z2LE                                                               MD055265
**  PRINTER FILE TEXT
Branch
Company
System
I/p Cycle
C/Business
Periodic
Mandatory
On Request
Booking
Originating
A/c Ofr
Dept
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@
(c) Finastra International Limited 2001
