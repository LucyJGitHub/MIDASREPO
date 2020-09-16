     H DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Maintain/enquire MOUT')
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility                              *
      *                                                               *
      *  FC0220D - Maintain/Enquire MOUT     Display file             *
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
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD055265           Date 10Feb20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CAAA03             Date 22Mar04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL008             Date 03Mar99               *
      *                 087380             Date 10May95               *
      *                 S01407             Date 26Jan93               *
      *                 S01269             DATE 25JUN91               *
      *                 LN1200             DATE 14MAY91               *
      *                 LN1190             DATE 29APR91               *
      *                 S01314             DATE 24APR91               *
      *                 LN0911             DATE 16NOV90               *
      *                 LN0880             DATE 22OCT90               *
      *                 LN0842             DATE 08OCT90               *
      *                 LN0792             DATE 26SEP90               *
      *                 LN0675             DATE 29AUG90               *
      *                 LN0182             DATE 17MAY90               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA03 - Webfacing Changes. Recompile over changes in DSPF.  *
      *  CGL008 - Security on Journal Entry. Recompile.               *
      *  087380 - Enlarge parameter for AOUSERR0                      *
      *  S01407 - SWITCHABILITY ENHANCEMENTS                          *
      *  S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO         *
      *           MUSERDD                                             *
      *  LN1200 - ALLOW PRINT COMMAND KEYS TO WORK                    *
      *  LN1190 - REMOVE 'USR' MESSAGES AND REPLACE WITH 'RCF'        *
      *           MESSAGES.                                           *
      *  S01314 - Changes made during PTF incorporation.              *
      *           Multilanguage subfile message tags changed          *
      *  LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.             *
      *  LN0880 - INSERT PROCESSING FOR ACTION CODE OF 'E' (ENQUIRE)  *
      *  LN0842 - MODULE ACCESS TO BE FROM SDMMODPD                   *
      *  LN0792 - SCAN LIMIT SIZE INCREASED FROM 500 TO 99999         *
      *  LN0675 - STANDARDISE SCREEN APPEARANCE                       *
      *  LN0182 - AMENDMENTS TO DISPLAY FILE , ARRAY @CN ELEMENT 9    *
      *           CHANGED FROM 'FC0220P' TO 'FC0220'                  *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,FC0220DFPG
     FFC0220D#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Maintain/Enquire MOUT     Display file
      *
     FFCMOUTL1  IF   E           K DISK
     F                                     INFDS(INFDS1)
      * RTV: Mandatory Output Insts    Retrieval index
      *
     F***********FCRCOML1IF  E           K        DISK                    S01407
     F*FCRCOMJ1* IF   E           K DISK                                         S01407     MD055265
      * RTV: Report Components         Retrieval index
      *
     F***********FCREPTL1IF  E           K        DISK                    S01407
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
      * RTV: Report Descriptions       Retrieval index
      *
     F*FCRREQL0IF*E*******    K        DISK                      A        LN1200
      **UPD:*Report*Requests***********Update*index                       LN1200
      ********************                                                LN1200
     D**********          UMAR       64  2               MIDAS modules    LN1200
     D**********          UUSB    1   2 80                                LN0911
     D**********          UUSB    1   3 80                         LN0911 LN1200
     D**********                                                          LN1200
     D***ARRAY*TO*CONTAIN*SBMJOB*COMMAND***                               LN1200
     D*
     D************        AEMQ    1   4 78                                LN0675
     D AEMQ            S             78    DIM(3) CTDATA PERRCD(1)                               LN0
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*Mandaroty Output Mtnce   Initialise Program E-Spec
     D/COPY WNCPYSRC,FC0220DEPG
     D********************@CN     1  23 25               Long constants.  LN0675
     D @CN             S             25    DIM(25) CTDATA PERRCD(1)             Long constants.  LN0
     D*                                                                   LN0675
     D** ARRAY TO CONTAIN SCREEN HEADING                                  LN0675
     D*                                                                   LN0675
     D UHDR            S             53    DIM(2) CTDATA PERRCD(1)                               LN0
     D*
     D*
     D*
     D*Mandaroty Output Mtnce   Initialise Program I-Spec
     D/COPY WNCPYSRC,FC0220DIPG
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
      * KEY: Mandatory Output Insts    Retrieval index
      * I:MAP Report name
     D  PARNAM                 1     10
      *
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
     D  WMF          E                     EXTFLD(BGMFIC)                       LN0842
     D  WOD          E                     EXTFLD(BGOPDK)                       LN0842
     D*                                                                   LN0842
     D DSSDY         E DS                  EXTNAME(DSSDY)                       LN0842
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                LN0842
     D*                                                                   LN0842
     D*REPSEQ*****DS******                                                LN1200
     D********************                                                LN1200
     D***REPORT*SEQUENCE*NUMBER*DATA*AREA***                              LN1200
     D********************                                                LN1200
     D********************                    1   50UUSEQ                 LN1200
     D*UUCMD******DS******                                                LN1200
     D********************                                                LN1200
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
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D UUFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* 200 BYTE DATA STRUCTURE FOR INCOMING DATA ROM ACCESS PGM
     D*
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D*
     D* USER DETAILS DATA STRUCTURE FOR ASSIGNING DATA FROM ACCESS PGM
     D*
     D UURCF         E DS                  EXTNAME(SDRCFPD)
     D*
      ** DATASTRUCTURE FOR RCF ICD
     D*
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
     D FCRCOM        E DS                  EXTNAME(FCRCOJW1)                                MD055265
     D**XSARD***     E                     EXTFLD(SARD)                            MD055265 MD055681
     D  XSARN        E                     EXTFLD(SARN)                                     MD055681
     D  XENABLD      E                     EXTFLD(ENABLD)                                   MD055681
     D*NullInds*       s              5i 0 dim(12)                                 MD055265 MD055681
     D NullInds        s              5i 0 dim(13)                                          MD055681
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D*NullInds2       s              5i 0 dim(19)                                 MD055265 MD055681
     D NullInds2       s              5i 0 dim(20)                                          MD055681
      /EJECT
     C********************************************************************S01314
      *                                                                   S01314
      ** Call SDRTVTXT pgm to access appropriate text                     S01314
      ** for a field used in a SFL                                        S01314
      *                                                                   S01314
     C                   MOVEL     'ZZGBMSGF'    MSGNM                                         S0131
     C                   MOVEL     'ZZM0361'     MSGDNB                                        S0131
     C                   CALL      'SDRTVTXT'                                                  S0131
     C                   PARM                    MSGDNB            7                           S0131
     C                   PARM                    MSGNM            10                           S0131
     C                   PARM                    MSGTXT           80                           S0131
     C                   MOVEL     MSGTXT        ZZM002                                        S0131
      *                                                                   S01314
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1AKST        PARM                    WP0001            1            Program Mode of
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
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
      * 01 /copy XX0220DISC - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Initialise Subf Control
     C/COPY WNCPYSRC,FC0220DISC
      * Position DBF file:
     C     KPOS          KLIST
     C                   KFLD                    D2RNAM                         Report name
      * Setup key.
     C                   MOVEL     #2RNAM        D2RNAM                         Report name
     C     KPOS          SETLL     @D2REI0
     C                   READ      @D2REI0                              8782    *82=EOF
      * Save previous selector values.
     C     *LIKE         DEFINE    #2ARMF        WZARMF
     C                   MOVEL     #2ARMF        WZARMF                         Archived On Mic
     C     *LIKE         DEFINE    #2AROD        WZAROD
     C                   MOVEL     #2AROD        WZAROD                         Archived On Opt
     C     *LIKE         DEFINE    #2DRQD        WZDRQD
     C                   MOVEL     #2DRQD        WZDRQD                         Distribution Re
     C     *LIKE         DEFINE    #2TNLU        WZTNLU
     C                   MOVEL     #2TNLU        WZTNLU                         Transaction No.
     C     *LIKE         DEFINE    #2RNAM        WZRNAM
     C                   MOVEL     #2RNAM        WZRNAM                         Report name
     C     *LIKE         DEFINE    #2DFTU        WZDFTU
     C                   MOVEL     #2DFTU        WZDFTU                         Default User ID
     C     *LIKE         DEFINE    #2DFTO        WZDFTO                                        LN018
     C                   MOVEL     #2DFTO        WZDFTO                         Default O/PT IDLN018
     C     *LIKE         DEFINE    #2USRO        WZUSRO
     C                   MOVEL     #2USRO        WZUSRO                         User ID For Out
     C     *LIKE         DEFINE    #2DLS1        WZDLS1
     C                   MOVEL     #2DLS1        WZDLS1                         Distribution Li
     C     *LIKE         DEFINE    #2DLS2        WZDLS2
     C                   MOVEL     #2DLS2        WZDLS2                         Distribution Li
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
     C  N82              READP     @D2REI0                                90    *
     C  N82              READ      @D2REI0                                90    *
     C                   END
      *
      * Setof record error indicators.
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(36)
      * Start at previous highest record in SFL.
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read.
     C                   Z-ADD     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or :
      * scan limit reached.
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record.
     C     #2ARMF        IFNE      *BLANK                                       Archived On Mic
     C     D2ARMF        CABNE     #2ARMF        BB020                          Archived On Mic
     C                   END
     C     #2AROD        IFNE      *BLANK                                       Archived On Opt
     C     D2AROD        CABNE     #2AROD        BB020                          Archived On Opt
     C                   END
     C     #2DRQD        IFNE      *BLANK                                       Distribution Re
     C     D2DRQD        CABNE     #2DRQD        BB020                          Distribution Re
     C                   END
     C     #2TNLU        IFNE      *ZERO                                        Transaction No.
     C     D2TNLU        CABNE     #2TNLU        BB020                          Transaction No.
     C                   END
     C     #2DFTU        IFNE      *BLANK                                       Default User ID
     C     D2DFTU        CABNE     #2DFTU        BB020                          Default User ID
     C                   END
     C     #2DFTO        IFNE      *BLANK                                       Default O/PT IDLN018
     C     D2DFTO        CABNE     #2DFTO        BB020                          Default O/PT IDLN018
     C                   END                                                                   LN018
     C     #2USRO        IFNE      *BLANK                                       User ID For Out
     C     D2USRO        CABNE     #2USRO        BB020                          User ID For Out
     C                   END
     C     #2DLS1        IFNE      *BLANK                                       Distribution Li
     C     D2DLS1        CABLT     #2DLS1        BB020                          Distribution Li
     C                   END
     C     #2DLS2        IFNE      *BLANK                                       Distribution Li
     C     D2DLS2        CABLT     #2DLS2        BB020                          Distribution Li
     C                   END
      * Load SFL fields.
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record from DBF record
     C                   MOVEL     @CN(01)       W0RSL                          *Record selecte
      * Check if mandatory report - Report Components  *
     C                   EXSR      SARVGN
      *CASE:     WRK.work flag is Incorrect
     C     WUAOST        IFEQ      @CN(02)                                      *IF
     C                   MOVEL     @CN(04)       W0RSL                          *Record selecte
     C                   END                                                    *FI
      * 02 /copy XX0220DISR - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Initialise Subfile Rcd
     C/COPY WNCPYSRC,FC0220DISR
      * DBF Record not selected.
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile.
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count.
     C                   ADD       1             ##RRRD
     C                   READ      @D2REI0                                82    *82=EOF
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
      * Set screen conditioning indicators.
     C                   EXSR      GBDSA2
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
      * CALC: Subfile control function fields
      * 03 /copy XX0220DSFF - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Calculate Control Fields
     C/COPY WNCPYSRC,FC0220DSFF
      * Change of position specified.
     C     WZRNAM        CASNE     #2RNAM        FBRQRL
     C     WZDRQD        CASNE     #2DRQD        FBRQRL                                        LN018
     C     WZARMF        CASNE     #2ARMF        FBRQRL                                        LN018
     C     WZAROD        CASNE     #2AROD        FBRQRL                                        LN018
     C     WZDFTU        CASNE     #2DFTU        FBRQRL
     C     WZDFTO        CASNE     #2DFTO        FBRQRL                                        LN018
     C     WZUSRO        CASNE     #2USRO        FBRQRL
     C     WZDLS1        CASNE     #2DLS1        FBRQRL
     C     WZDLS2        CASNE     #2DLS2        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * 03 /copy XX0220DPSC - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Process Subfile Control
     C/COPY WNCPYSRC,FC0220DPSC
      * Reload subfile requested:
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records.
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * 06 /copy XX0220DFPR - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Final Processing
     C/COPY WNCPYSRC,FC0220DFPR
      * If error, Quit processing:
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
     C                   MOVEL     WUDBRN        WUETTY                         Entity
      *CASE:     CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(01)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      @CN(02)       WQ0001            1            Action Code
     C                   PARM      WUETTY        WQ0002            3            Entity
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
      * Validate Input Action
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTU'                             90      Validate Action
     C                   PARM      @CN(02)       WQ0004            1            Action Code
     C     WUAJNB        PARM      *ZERO         WQ0005            1 0          Error Flag
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
     C                   MOVEL     @CN(02)       WUJTST                         Action Code
      * Call mandatory output mtn - Mandatory Output Insts  *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     *BLANK        PARNAM                         Report name
      *
     C                   CALL      'FC0220'                             90      Call mandatory
     C                   PARM                    PARC                           KEY: Mandatory
     C                   PARM      WUJTST        WQ0006            1            *SFLSEL
     C     W0RTN         PARM      *BLANK        WQ0007            7            *Return code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     @CN(01)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9936      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 07 /copy XX0220DPCK - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Process Command Keys
     C/COPY WNCPYSRC,FC0220DPCK
      *CASE:     CTL.*CMD key is Print details
     C     *IN11         IFEQ      '1'                                          *IF
      * Submit Report
      **Next*Report*Sequence*No.*-*standard*functions***                  LN1200
     C*************                                                       LN1200
      ***ACCESS*DATA*AREA*REPSEQ*FOR*NEXT*SEQUENCE*NUMBER,*AND*UPDATE     LN1200
     C***********                                                         LN1200
     C************NAMVAR   DEFN           REPSEQ                          LN1200
     C************LOCK     IN   REPSEQ                                    LN1200
     C***********          MOVE UUSEQ     WURQSQ                          LN1200
     C***********          ADD  1         UUSEQ                           LN1200
     C***********          OUT  REPSEQ                                    LN1200
      **Get*Default*Output*Id*-*Report*Descriptions***                    LN1200
     C***********          EXSR SBRVGN                                    LN1200
      **Retrieve*parameters*-*Report*Components***                        LN1200
     C***********          EXSR SCRVGN                                    LN1200
      *CASE:*****PGM.*Return*code*is**Record*does*not*exist***            LN1200
     C***********W0RTN     IFEQ @CN,13                     *IF            LN1200
     C***********          MOVEL@CN,14    P0RTN            *Return code   LN1200
     C***********          EXSR ZYEXPG                                    LN1200
     C***********          END                             *FI            LN1200
     C***********          MOVELWUDFTO    WUSOID           Instruction IdeLN1200
      **Set*Up*Time*-*standard functions***                               LN1200
     C***********          MOVEL##JTM     WURQTM                          LN1200
     C***********          MOVEL##USR     WUUSRR           User ID For ReqLN1200
      *CASE:*****PAR.Multi-branching*Indicator*is*Multibranch*system***   LN1200
     C***********WUMBIN    IFEQ @CN,01                     *IF            LN1200
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
     C***********          EXSR SDCRRC                                    LN1200
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
     C                   MOVEA     WKIND0        *IN(36)
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
     C                   MOVEL     WUDBRN        WUETTY                         Entity
      *CASE:     RCD.*SFLSEL is Enquire                                   LN0880
     C     #1SEL         IFEQ      @CN(19)                                      *IF            LN088
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
      *CASE:     PAR.Program Mode of DSPFIL is Maintenance                LN0880
     C     P1AKST        IFEQ      @CN(03)                                      *IF            LN088
      *CASE:     RCD.*SFLSEL is Enquire                                   LN0880
     C     #1SEL         IFEQ      @CN(19)                                      *IF            LN088
      *CASE:     WRK.Multi-branching Indicator is Multibranch system      LN0880
     C     WUMBIN        IFEQ      @CN(01)                                      *IF            LN088
      * Validate Input Action/Bch                                         LN0880
      * Validate Action Code - standard functions  *                      LN0880
     C                   CALL      'ZVACTBU'                            90      Validate ActionLN088
     C                   PARM      @CN(19)       WQ0018            1            Action Code    LN088
     C                   PARM      WUETTY        WQ0019            3            Entity         LN088
     C     WUAJNB        PARM      *ZERO         WQ0020            1 0          Error Flag     LN088
      *                                                                   LN0880
     C     *IN90         IFEQ      '1'                                                         LN088
      * Call to program ended in error.                                   LN0880
     C                   MOVEL     'Y2U0021'     W0RTN             7                           LN088
     C                   END                                                                   LN088
      *                                                                   LN0880
      *CASE:     WRK.Error Flag is zero                                   LN0880
     C     WUAJNB        IFEQ      *ZERO                                        *IF            LN088
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
      *CASE:     WRK.Error Flag is one                                    LN0880
     C     WUAJNB        IFEQ      1                                            *IF            LN088
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
      *CASE:     WRK.Error Flag is two                                    LN0880
     C     WUAJNB        IFEQ      2                                            *IF            LN088
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
     C                   ELSE                                                                  LN088
      *CASE:     *OTHERWISE                                               LN0880
      * Validate Input Action                                             LN0880
      * Validate Action Code - standard functions  *                      LN0880
     C                   CALL      'ZVACTU'                             90      Validate ActionLN088
     C                   PARM      @CN(19)       WQ0021            1            Action Code    LN088
     C     WUAJNB        PARM      *ZERO         WQ0022            1 0          Error Flag     LN088
      *                                                                   LN0880
     C     *IN90         IFEQ      '1'                                                         LN088
      * Call to program ended in error.                                   LN0880
     C                   MOVEL     'Y2U0021'     W0RTN             7                           LN088
     C                   END                                                                   LN088
      *                                                                   LN0880
      *CASE:     WRK.Error Flag is zero                                   LN0880
     C     WUAJNB        IFEQ      *ZERO                                        *IF            LN088
     C                   MOVEL     @CN(05)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
      *CASE:     WRK.Error Flag is one                                    LN0880
     C     WUAJNB        IFEQ      1                                            *IF            LN088
     C                   MOVEL     @CN(06)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
      *CASE:     WRK.Error Flag is two                                    LN0880
     C     WUAJNB        IFEQ      2                                            *IF            LN088
     C                   MOVEL     @CN(07)       WUAFST                         Entity Valid FlLN088
     C                   END                                                    *FI            LN088
     C                   END                                                    *FI            LN088
     C                   END                                                    *FI            LN088
      *CASE:*****PAR.Program*Mode*of*DSPFIL*is*Maintenance***             LN0880
     C********** P1AKST    IFEQ @CN,03                     *IF            LN0880
      *CASE:     RCD.*SFLSEL is Amend Request
     C     #1SEL         IFEQ      @CN(17)                                      *IF
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(01)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      @CN(17)       WQ0008            1            Action Code
     C                   PARM      WUETTY        WQ0009            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0010            1 0          Error Flag
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
      * Validate Input Action
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTU'                             90      Validate Action
     C                   PARM      @CN(17)       WQ0011            1            Action Code
     C     WUAJNB        PARM      *ZERO         WQ0012            1 0          Error Flag
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
      *CASE:     RCD.*SFLSEL is *Delete request
     C     #1SEL         IFEQ      @CN(18)                                      *IF
      *CASE:     WRK.Multi-branching Indicator is Multibranch system
     C     WUMBIN        IFEQ      @CN(01)                                      *IF
      * Validate Input Action/Bch
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTBU'                            90      Validate Action
     C                   PARM      @CN(18)       WQ0013            1            Action Code
     C                   PARM      WUETTY        WQ0014            3            Entity
     C     WUAJNB        PARM      *ZERO         WQ0015            1 0          Error Flag
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
      * Validate Input Action
      * Validate Action Code - standard functions  *
     C                   CALL      'ZVACTU'                             90      Validate Action
     C                   PARM      @CN(18)       WQ0016            1            Action Code
     C     WUAJNB        PARM      *ZERO         WQ0017            1 0          Error Flag
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
     C                   ELSE
      *CASE:     *OTHERWISE
      *CASE:     RCD.*SFLSEL is *Delete request
     C     #1SEL         IFEQ      @CN(18)                                      *IF
      * Send message 'Deletion not allowed'
     C                   MOVEL     'RCF0012'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
      *CASE:     RCD.*SFLSEL is Amend
     C     #1SEL         IFEQ      @CN(17)                                      *IF
      * Send message 'Amendment not allowed'
     C                   MOVEL     'RCF0011'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        98        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.Entity Valid Flag is No Error
     C     WUAFST        IFEQ      @CN(05)                                      *IF
      * Call mandatory output mtn - Mandatory Output Insts  *
     C                   MOVEL     *BLANK        PARC
     C                   MOVEL     #1RNAM        PARNAM                         Report name
      *
     C                   CALL      'FC0220'                             90      Call mandatory
     C                   PARM                    PARC                           KEY: Mandatory
     C                   PARM      #1SEL         WQ0023            1            *SFLSEL
     C     W0RTN         PARM      *BLANK        WQ0024            7            *Return code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected ?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9836      *
     C                   END
      *CASE:     PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     *BLANK        P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     @CN(01)       W0RSF                          *Reload subfile
     C                   ELSE
      *CASE:     *OTHERWISE
      * Setup message data for message.
     C                   MOVEL     #1SEL         ZA0002                         *SFLSEL
      * Send message 'Action/Branch not valid'
     C                   MOVEL     'RCF0037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9836      *
      *
     C                   END                                                    *FI
      * 05 /copy XX0220DPSR - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Process Subfile Record
     C/COPY WNCPYSRC,FC0220DPSR
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
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control.
      *================================================================
     C                   MOVEL     '0'           *IN79
     C     WUMFOD        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     WUOFCP        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN70                                         LN018
     C     WMF           IFEQ      'Y'                                          *IF            LN018
     C                   MOVEL     '1'           *IN70                                         LN018
     C                   END                                                    *FI            LN018
     C                   MOVEL     '0'           *IN71                                         LN018
     C     WOD           IFEQ      'Y'                                          *IF            LN018
     C                   MOVEL     '1'           *IN71                                         LN018
     C                   END                                                    *FI            LN018
     C                   MOVEL     '0'           *IN72                                         LN018
     C     MBIN          IFEQ      'Y'                                          *IF            LN018
     C                   MOVEL     '1'           *IN72                                         LN018
     C                   END                                                    *FI            LN018
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @D2REI0    fields to subfile.
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     D2DFTO        #1DFTO                         Default Output
     C                   MOVEL     D2ARMF        #1ARMF                         Archived On Mic
     C                   MOVEL     D2AROD        #1AROD                         Archived On Opt
     C                   MOVEL     D2DRQD        #1DRQD                         Distribution Re
     C                   Z-ADD     D2TNLU        #1TNLU                         Transaction No.
     C                   MOVEL     D2CHTP        #1CHTP                         Type of Last Ch
     C                   Z-ADD     D2LCD         #1LCD                          Last Change Dat
     C                   MOVEL     D2RNAM        #1RNAM                         Report name
     C                   MOVEL     D2DFTU        #1DFTU                         Default User ID
     C                   MOVEL     D2USRO        #1USRO                         User ID For Out
     C                   MOVEL     D2DLS1        #1DLS1                         Distribution Li
     C                   MOVEL     D2DLS2        #1DLS2                         Distribution Li
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #RBPTX                         Archived On
     C                   MOVEL     *BLANK        #RBPT2                         Archived On 2  LN067
     C                   MOVEL     *BLANK        #RAETX                         Screen report d
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
     C                   MOVEL     *BLANK        #RBPTX                         Archived On
     C                   MOVEL     *BLANK        #RBPT2                         Archived On 2  LN067
      * Archived On
      *CASE:     PAR.Archived On Optical Disk is Yes
     C     #1AROD        IFEQ      @CN(01)                                      *IF
      *CASE:     PAR.Archived On Microfiche is Yes
     C     #1ARMF        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(20)       #RBPTX                         Archived On
     C                   MOVEL     *BLANK        #RBPT2                         Archived On 2  LN067
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     @CN(21)       #RBPTX                         Archived On
     C                   MOVEL     @CN(24)       #RBPT2                         Archived On 2  LN067
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      *CASE:     PAR.Archived On Microfiche is Yes
     C     #1ARMF        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(22)       #RBPTX                         Archived On
     C                   MOVEL     @CN(25)       #RBPT2                         Archived On 2  LN067
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     *BLANK        #RBPTX                         Archived On
     C                   MOVEL     *BLANK        #RBPT2                         Archived On 2  LN067
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        #RAETX                         Screen report d
      * Screen report description
      * Get report description - Report Descriptions  *
     C                   EXSR      SERVGN
      * 04 /copy XX0220DRFF - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Calculate Record Funcs
     C/COPY WNCPYSRC,FC0220DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control.
      *================================================================
     C                   MOVEL     *BLANK        #2ARMF                         Archived On Mic
     C                   MOVEL     *BLANK        #2AROD                         Archived On Opt
     C                   MOVEL     *BLANK        #2DRQD                         Distribution Re
     C                   Z-ADD     *ZERO         #2TNLU                         Transaction No.
     C                   MOVEL     *BLANK        #2RNAM                         Report name
     C                   MOVEL     *BLANK        #2DFTU                         Default User ID
     C                   MOVEL     *BLANK        #2DFTO                         Default O/PT IDLN018
     C                   MOVEL     *BLANK        #2USRO                         User ID For Out
     C                   MOVEL     *BLANK        #2DLS1                         Distribution Li
     C                   MOVEL     *BLANK        #2DLS2                         Distribution Li
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Check if mandatory report - Report Components  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Initialise routine
     C                   MOVEL     @CN(02)       WUAOST                         work flag
      * Declare restrictor key work fields.
     C     *LIKE         DEFINE    D3RNAM        WQSA01                         Report name
      * Define Keylist.
     C     KPSSA         KLIST
     C                   KFLD                    WQSA01                         Report name
     C                   KFLD                    D3COTT                         Component Name
     C                   KFLD                    D3CSEQ                         Component Seque
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    WQSA01                         Report name
      * Move fields to key list.
     C                   MOVEL     #1RNAM        WQSA01                         Report name
     C                   MOVEL     *BLANK        D3COTT                         Component Name
     C                   MOVEL     *BLANK        D3CSEQ                         Component Seque
     C***********KPSSA     SETLL@D3REI5                    *              S01407
     C***********KRSSA     READE@D3REI5                  90*              S01407
     C*****KPSSA         SETLL     FCRCOMD0                                     *     S0140 MD055265
     C*****KRSSA         READE     FCRCOMD0                               90    *     S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare ACursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCRCOJW1                                                              MD055265
     C+ where D3RNAM = :WQSA01                                                              MD055265
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
     C                   SETOFF                                       90                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        90                    MD055265
     C                   Endif                                                              MD055265
      * DBF Record not found.
     C***90*****           MOVEL'USR0724' W0RTN   7                       LN1190
     C   90              MOVEL     'RCF0724'     W0RTN             7                           LN119
     C     *IN90         DOWEQ     '0'
      * USER: Process DBF record
      *CASE:     DB1.Mandatory/On Request is Mandatory
     C     D3MORQ        IFEQ      @CN(03)                                      *IF
     C                   MOVEL     *BLANK        WUAOST                         work flag
     C                   GOTO      SAEXIT                                       *QUIT
     C                   END                                                    *FI
     C***********KRSSA     READE@D3REI5                  90*              S01407
     C*****KRSSA         READE     FCRCOMD0                               90    *     S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRCOM :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       90                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        90                    MD055265
     C                   Endif                                                              MD055265
     C                   END
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     C*SR********SBRVGN****BEGSR                                          LN1200
      *================================================================   LN1200
      **Get*Default*Output*Id*-*Report*Descriptions***                    LN1200
      *================================================================   LN1200
     C***********          MOVEL*BLANK    W0RTN   7                       LN1200
      **Define*Keylist.***                                                LN1200
     C***********KRSSB     KLIST                                          LN1200
     C***********          KFLD           DXRNAM           Report name    LN1200
      **Move*fields*to*key*list.***                                       LN1200
     C***********          MOVEL@CN,09    DXRNAM           Report name    LN1200
     C***********KRSSB     CHAIN@DXREIK              90    *              LN1200
     C************IN90     IFEQ '1'                                       LN1200
      **DBF*Record*not found.***                                          LN1200
     C**********           MOVEL'USR0712' W0RTN   7                       LN1190
     C**********           MOVEL'RCF0712' W0RTN   7                LN1190 LN1200
      **USER:*Processing*if*DBF*record*not*found***                       LN1200
     C***********          MOVEL@CN,13    W0RTN            *Return code   LN1200
     C***********          GOTO SBEXIT                                    LN1200
     C***********          END                                            LN1200
      ***********                                                         LN1200
     C************IN90     IFEQ '0'                                       LN1200
      **USER:*Process*DBF*record***                                       LN1200
      **PAR*=*DB1*By*name***                                              LN1200
     C***********          MOVELDXDFTO    WUDFTO           Default Output LN1200
     C***********          END                                            LN1200
      *================================================================   LN1200
     C*SR********SBEXIT    ENDSR                                          LN1200
      /EJECT                                                              LN1200
     C*SR********SCRVGN    BEGSR                                          LN1200
      *================================================================   LN1200
      **Retrieve*parameters*-*Report*Components***                        LN1200
      *================================================================   LN1200
     C***********          MOVEL*BLANK    W0RTN   7                       LN1200
      **Define Keylist.***                                                LN1200
     C***********KRSSC     KLIST                                          LN1200
     C***********          KFLD           D3RNAM           Report name    LN1200
     C***********          KFLD           D3COTT           Component Name LN1200
     C***********          KFLD           D3CSEQ           Component SequeLN1200
      **Move*fields*to*key*list.***                                       LN1200
     C***********          MOVEL@CN,09    D3RNAM           Report name    LN1200
     C***********          MOVEL@CN,10    D3COTT           Component Name LN1200
     C***********          MOVEL@CN,11    D3CSEQ           Component SequeLN1200
     C***********KRSSC     CHAIN@D3REI5              90    *              LN1200
     C************IN90     IFEQ '1'                                       LN1200
      **DBF*Record*not*found.***                                          LN1200
     C**********           MOVEL'USR0724' W0RTN   7                       LN1190
     C***********          MOVEL'RCF0724' W0RTN   7                LN1190 LN1200
      **USER:*Processing*if*DBF*record*not*found***                       LN1200
     C***********          MOVEL@CN,13    W0RTN            *Return code   LN1200
     C***********          GOTO SCEXIT                                    LN1200
     C***********          END                                            LN1200
      ***********                                                         LN1200
     C************IN90     IFEQ '0'                                       LN1200
      **USER:*Process*DBF*record***                                       LN1200
      **PAR*=*DB1*By*name***                                              LN1200
     C***********          MOVELD3CLPM    WUCLPM           Calling ParametLN1200
     C***********          END                                            LN1200
      *================================================================   LN1200
     C*SR********SCEXIT    ENDSR                                          LN1200
      /EJECT                                                              LN1200
     C*SR********SDCRRC    BEGSR                                          LN1200
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
     C***********          MOVEL@CN,01    D5IPCY           Input Cycle    LN1200
     C***********          MOVEL@CN,04    D5PDFL           Periodic       LN1200
     C***********          MOVEL*BLANK    D5DLS1           Distribution LiLN1200
     C***********          MOVEL*BLANK    D5DLS2           Distribution LiLN1200
     C***********          MOVEL*BLANK    D5USRO           User ID For OutLN1200
     C***********          MOVEL@CN,04    D5ARMF           Archived On MicLN1200
     C***********          MOVEL@CN,04    D5AROD           Archived On OptLN1200
     C***********          MOVEL@CN,04    D5DRQD           Distribution ReLN1200
     C***********          MOVELWUUSRR    D5USRR           User ID For ReqLN1200
     C***********          MOVELWUDBRN    D5DBRN           User's Branch  LN1200
     C***********          Z-ADDWURQTM    D5RQTM           Request Time   LN1200
     C***********          MOVEL@CN,04    D5COBR           Close Of BusineLN1200
     C***********          MOVEL*BLANK    D5JBNM           Job Name       LN1200
     C***********          MOVEL*BLANK    D5JUSR           User Name      LN1200
     C***********          MOVEL*BLANK    D5JBNB           Job Number     LN1200
     C***********          MOVEL*BLANK    D5PSQR           Periodic SequenLN1200
     C***********          MOVEL@CN,10    D5COTT           Component Name LN1200
     C***********          MOVEL@CN,11    D5CSEQ           Component SequeLN1200
     C***********          Z-ADD*ZERO     D5TNLU           Transaction No.LN1200
      ***********                                                         LN1200
     C***********KLCRSD    KLIST                                          LN1200
     C***********          KFLD           D5RQSQ           Sequence NumberLN1200
      **Check*for*duplicate*primary*key.***                               LN1200
     C***********KLCRSD    SETLL@D5REI8                  90*              LN1200
     C************IN90     IFEQ '1'                                       LN1200
     C**********           MOVEL'USR0729' W0RTN   7                       LN1190
     C***********          MOVEL'RCF0729' W0RTN   7                LN1190 LN1200
      **Send*message*'Report*Requests********EX'***                       LN1200
     C**********           MOVEL'USR0729' ZAMSID           Message id.    LN1190
     C***********          MOVEL'RCF0729' ZAMSID           Message LN1190 LN1200
     C***********          EXSR ZASNMS                     Send message   LN1200
     C***********          GOTO SDEXIT                                    LN1200
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
     C*SR********SDEXIT    ENDSR                                          LN1200
      /EJECT
     CSR   SERVGN        BEGSR
      *================================================================
      * Get report description - Report Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSE         KLIST
     C                   KFLD                    DXRNAM                         Report name
      * Move fields to key list.
     C                   MOVEL     #1RNAM        DXRNAM                         Report name
     C***********KRSSE     CHAIN@DXREIK              90    *              S01407
     C*****KRSSE         CHAIN     FCREPTD0                           90        *     S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds2                                                             MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :#1RNAM                                                              MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       90                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        90                    MD055265
     C                   Endif                                                              MD055265
      * DBF Record not found.
     C***90*****           MOVEL'USR0712' W0RTN   7                       LN1190
     C   90              MOVEL     'RCF0712'     W0RTN             7                           LN119
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     DXRDSC        #RAETX                         Report Descript
     C                   END
      *================================================================
     CSR   SEEXIT        ENDSR
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
      * 08 /copy XX0220DEPP - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Exit Program Processing
     C/COPY WNCPYSRC,FC0220DEPP
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
      * Define work field Entity
     C                   MOVEL     *BLANK        WUETTY            3
      * Define work field User's Branch
     C                   MOVEL     *BLANK        WUDBRN            3
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field Entity Valid Flag
     C                   MOVEL     *BLANK        WUAFST            1
      * Define work field Error Flag
     C                   Z-ADD     *ZERO         WUAJNB            1 0
      * Define work field Action Code
     C                   MOVEL     *BLANK        WUJTST            1
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
      * Define work field Level
     C                   MOVEL     *BLANK        WULVL             1
      * Define work field Department
     C                   MOVEL     *BLANK        WUDEPT            3
      * Define work field archiving
     C                   MOVEL     *BLANK        WUMFOD            1
      * Define work field office present
     C                   MOVEL     *BLANK        WUOFCP            1
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURUND            5 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WURUNA            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSSF             1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUDATF            1
      * Define work field User Name
     C                   MOVEL     *BLANK        WUJUSR           10
      * Define work field Module
     C                   MOVEL     *BLANK        WUCMOD            2
      * Signal first error message outstanding.
     C                   MOVEL     'Y'           ZAFSMS            1
     C************         Z-ADD05        ##SFPG  30       SFLPAG         LN0675
     C                   Z-ADD     04            ##SFPG            3 0          SFLPAG         LN067
     C                   Z-ADD     1             ##SFRC
     C                   Z-ADD     *ZERO         ##RRMX                         MAX RECNO
     C*********************Z-ADD500       W0SLM   50       SCAN LIMIT     LN0792
     C                   Z-ADD     99999         W0SLM             5 0          SCAN LIMIT     LN079
      *................................................................
      * USER: Initialise program
      * last amd hdr box fc0220d - Mandatory Output Insts  *
     E* Y2V3114 - RPG source member  not found.
      * Initialise DSPFIL program
      * get rundate - rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RUNA          ##RUNA
     C                   MOVE      RUNA          WURUNA
     C                   MOVE      RUND          WURUND
     C                   MOVE      SSF           WUSSF
     C                   MOVE      DATF          WUDATF
     C                   MOVE      MBIN          WUMBIN
      * Set-up Display Screen - standard functions  *
     C     P1AKST        IFEQ      'M'
     C                   MOVEA     UHDR(1)       ##URPT                                        LN067
     C                   MOVEA     AEMQ(1)       ##AENA
     C                   MOVEA     AEMQ(3)       ##AFNA
     C                   END
      *
     C     P1AKST        IFEQ      'E'
     C                   MOVEA     UHDR(2)       ##URPT                                        LN067
     C*********************MOVEAAEMQ,2    ##AENA                          LN0675
     C*********************MOVEAAEMQ,4    ##AFNA                          LN0675
     C                   MOVEA     AEMQ(2)       ##AFNA                                        LN067
     C                   END
      *
      ********************************************************************
      * Copyright Statement - standard functions  *
     C                   MOVEA     CPY@          BIS@             80
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
     C                   MOVEL     ##USR         WUJUSR                         User Name
     C                   MOVEL     @CN(15)       WUAPOP                         Access Option
     C                   MOVEL     @CN(16)       WUAPRC                         Access Program
      * Call access pgm for MUSER - standard functions  *
     C*
     C** ACCESS MUSER FOR USER'S DEFAULT BRANCH
     C*
     C                   CALL      'AOUSERR0'
     C                   PARM                    WUAPRC            7
     C                   PARM                    WUAPOP            7
     C                   PARM                    WUJUSR           10
     C***********D@USER    PARM D@USER    UUFDY                           087380
     C     D@USER        PARM      D@USER        DSSDY                                         08738
     C*
     C                   MOVE      DBRN          WUDBRN
     C                   MOVE      DPPT          WUDEPT
     C*
      * access object for RCF ICD - standard functions  *
     C                   CALL      'AORCFR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*FIRST'      P@APOP            7              I:Option
     C     UURCF         PARM      UURCF         UUFDY                            O:Rec format
      *
     C                   MOVE      D0OFPR        WUOFCP
     C                   MOVEL     @CN(23)       WUCMOD                         Module
      * check module is available - standard functions  *
      *
      ** SAVE INDICATOR
      *
     C                   MOVE      *IN99         U99               1
     C                   MOVE      *BLANK        WUAOST
     C********** *NAMVAR   DEFN           MMOD                            LN0842
     C**********           IN   MMOD                                LN0182LN0842
     C                   CALL      'AOMMODR0'                                                  LN084
     C                   PARM      '*DBERR  '    @RTCD             7                           LN084
     C                   PARM      '*FIRST  '    @OPTN             7                           LN084
     C     SDMMOD        PARM      SDMMOD        DSSDY                                         LN084
     C*
     C     WMF           IFEQ      'N'
     C     WOD           ANDEQ     'N'
     C                   MOVEL     @CN(04)       WUMFOD                         archiving
     C                   END
     C*                                                                   LN0182
     C                   MOVEL     '0'           *IN79                                         LN018
     C     WUMFOD        IFEQ      @CN(04)                                      *IF            LN018
     C                   MOVEL     '1'           *IN79                                         LN018
     C                   END                                                    *FI            LN018
     C                   MOVEL     '0'           *IN78                                         LN018
     C     WUOFCP        IFEQ      @CN(04)                                      *IF            LN018
     C                   MOVEL     '1'           *IN78                                         LN018
     C                   END                                                    *FI            LN018
     C                   MOVEL     '0'           *IN70                                         LN018
     C     WMF           IFEQ      'Y'                                          *IF            LN018
     C                   MOVEL     '1'           *IN70                                         LN018
     C                   END                                                    *FI            LN018
     C                   MOVEL     '0'           *IN71                                         LN018
     C     WOD           IFEQ      'Y'                                          *IF            LN018
     C                   MOVEL     '1'           *IN71                                         LN018
     C                   END                                                    *FI            LN018
     C                   MOVEL     '0'           *IN72                                         LN018
     C     MBIN          IFEQ      'Y'                                          *IF            LN018
     C                   MOVEL     '1'           *IN72                                         LN018
     C                   END                                                    *FI            LN018
      * 00 /copy XX0220DFPG - Mandatory Output Insts  *
      * 00 /copy XX0220DEPG - Mandatory Output Insts  *
      * 00 /copy XX0220DIPG - Mandatory Output Insts  *
      * 00 /copy XX0220DCPG - Mandatory Output Insts  *
     C*Mandaroty Output Mtnce   Initialise Program C-Spec
     C/COPY WNCPYSRC,FC0220DCPG
      * 00 /copy XX0220DOPG - Mandatory Output Insts  *
      * Initialise subfile control.
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*Mandatory Output Mtnce   Initialise Program O-Spec
     O/COPY WNCPYSRC,FC0220DOPG
      **  UUSB - SUBMIT REPORT TO BATCH                                   LN1200
      **SBMJOB JOB(XXXXXXXXXX) JOBD(MBATCH) CMD(CALL XXXXXXXXXX PARM(     LN1200
      **'     ' ' ' '   '                                                 LN1200
      **RTGDTA(*JOBD)                                                     LN1200
      *                                                                   LN0182
      * ARRAY @CN CHANGED, ELEMENT 09 CHANGED FROM FC0310P TO FC0310      LN0182
      *                                                                   LN0182
**
A=Amend   D=Delete   E=Enquire
E=Enquire   F3=Main Menu   F5=Refresh   F11=Print Report
F3=Main Menu   F5=Refresh   F9=Go To 'Add' Mode   F11=Print Report
** CPY@
(c) Finastra International Limited 2001
** @CN Long constants used in program.
Y
I
M
N
0
1
2
Y2U9999
FC0220
FCC0310
10001
S
Y2U0005
Y2U0004
*KEY
*DBERR
A
D
E
Both
Optical
Micro-
MA
Disk
fiche
**  UHDR
      Mandatory Output Instructions Maintenance
        Mandatory Output Instructions Enquiry
