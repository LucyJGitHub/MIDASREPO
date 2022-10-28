     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas ME Display message routing table')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module
     F*                                                               *
     F*  ME1090 - Display Valid Msg Types   Display file              *
     F*                                                               *
     F*  Function:  This program displays the selected message        *
     F*                                                               *
     F*  Called By: SF0420 - SPF Menu                                 *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 069250             Date 03May94               *
      *                 S01435             Date 29Jul93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
     F*  069250 - Remove dummy OVRDBF command from creation parms.    *
     F*  S01435 - Incoming Message Management                         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*:*OVRDBF*(File*in*program)*(file*on*system)******************:**   069250
     F*****************************************************************
     F*DSPRCD: Cpysrc Templates Initialise Program F-Spec
     F/COPY WNCPYSRC,ME1090DFPG
     FME1090DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display Valid Msg Types   Display file
      *
     F*MEINMVL1* IF   E           K DISK    USROPN                                          MD058081
     F**********                           INFDS(INFDS1)                                    MD058081
     F**********                           INFSR(SRFILE)                                    MD058081
      * RTV : Incoming Valid Messages   Retrieval index
      *
     F*MEINMVL0* IF   E           K DISK    USROPN                                          MD058081
     F**********                           INFSR(SRFILE)                                    MD058081
      * UPD : Incoming Valid Messages   Update index
      *
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*  Array containing Copyright statement
     D***************** FIRST COMPILE TIME ARRAY *********************
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
     D*
     D*COPY*MECPYSRC,SRERRE                                                                 MD058081
     D/COPY MECPYSRC,SRERRELE                                                               MD058081
     D*
     D*  Copysource for error processing
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program E-Spec
     D/COPY WNCPYSRC,ME1090DEPG
      /EJECT
     D*DSPRCD: Cpysrc Templates Initialise Program I-Spec
     D/COPY WNCPYSRC,ME1090DIPG
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD058081
     D/COPY MECPYSRC,SRERRILE                                                               MD058081
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D*
     D* Data Structures used by Access Programs
     D*
     D MEINMV        E DS                  EXTNAME(MEIVMJW0)                                MD058081
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS           107
      * RCD: Incoming Valid Messages   Retrieval index
      * O : MAP Network
     D  P2NWRK                 1      6
      * O : MAP Message type
     D  P2MTPY                 7      9
      * O : MAP Sender (key)
     D  P2SNDK                10     29
      * O : MAP Record Identifier
     D  P2RECI                30     30
      * O : MAP Access Point
     D  P2ACPT                31     37
      * O : MAP Include/Exclude
     D  P2INEX                38     38
      * O : MAP Branch Code
     D  P2BRCA                39     41
      * O : MAP Payment Message Flag
     D  P2PMFG                42     42
      * O : MAP Narrative
     D  P2NARR                43     72
      * O : MAP Job name
     D  P2AJOB                73     82
      * O : MAP User name
     D  P2AUSR                83     92
      * O : MAP Action Time
     D  P2ATIM                93     96P 0
      * O : MAP Action Date
     D  P2ARDT                97    103
      * O : MAP Action Type
     D  P2AACT               104    104
      * O : MAP Run day number
     D  P2RDNB               105    107P 0
     D O2PARM          DS            29
      * KEY: Incoming Valid Messages   Retrieval index
      * I : MAP Network
     D  O2NWRK                 1      6
      * I : MAP Message type
     D  O2MTPY                 7      9
      * I : MAP Sender
     D  O2SNDR                10     29
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code'
      * *SFLSEL
     D  ZA0001                 1      1
      *
     D W0DATA          DS           256
      *
      *  Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MPART                 1      2P 0
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         RCD: Incoming V
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise & load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END                                                    OD W0RSF
     C                   END                                                    OD *HIVAL
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise and load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialise subfile control
      * DSPFIL: Init. Subfile Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile control
     C/COPY WNCPYSRC,ME1090DISC
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    MVNWRK                         Network
     C                   KFLD                    MVMTPY                         Message type
     C                   KFLD                    MVSNDK                         Sender (key)
      * Setup key
     C                   MOVEL     #2NWRK        MVNWRK                         Network
     C                   MOVEL     #2MTPY        MVMTPY                         Message type
     C                   MOVEL     #2SNDK        MVSNDK                         Sender (key)
     C*****KPOS*         SETLL     @INMVL1                                                  MD058081
     C**********         READ      @INMVL1                              8782    *82=EOF     MD058081
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor insensitive scroll cursor for                                       MD058081
     C+ select * from MEIVMJW0                                                              MD058081
     C+ where MVNWRK >= :MVNWRK and MVMTPY >= :MVMTPY and MVSNDK >= :MVSNDK                 MD058081
     C+   and MVRECI = 'D'                                                                  MD058081
     C+ order by MVNWRK, MVMTPY, MVSNDK                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEINMV                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C                   setoff                                       82                    MD058081
     C                   If        SQLCODE = 100                                            MD058081
     C                   seton                                        82                    MD058081
     C                   Endif                                                              MD058081
                                                                                            MD058081
      * Save previous selector values
     C     *LIKE         DEFINE    #2NWRK        WZNWRK
     C                   MOVEL     #2NWRK        WZNWRK                         Network
     C     *LIKE         DEFINE    #2MTPY        WZMTPY
     C                   MOVEL     #2MTPY        WZMTPY                         Message type
     C     *LIKE         DEFINE    #2SNDK        WZSNDK
     C                   MOVEL     #2SNDK        WZSNDK                         Sender (key)
     C     *LIKE         DEFINE    #2ACPT        WZACPT
     C                   MOVEL     #2ACPT        WZACPT                         Access Point
     C     *LIKE         DEFINE    #2INEX        WZINEX
     C                   MOVEL     #2INEX        WZINEX                         Include/Exclude
     C     *LIKE         DEFINE    #2BRCA        WZBRCA
     C                   MOVEL     #2BRCA        WZBRCA                         Branch Code
     C     *LIKE         DEFINE    #2PMFG        WZPMFG
     C                   MOVEL     #2PMFG        WZPMFG                         Payment Message
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2SNDK        WQSNDK                         Sender (key)
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      20            WQA5N             5 0
     C                   PARM      #2SNDK        WQSNDK                         Sender (key)
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
      * Load subfile page
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBLDSF        BEGSR
      *================================================================
      * Load subfile page
      *================================================================
      * Re-establish fields in read-ahead record
     C   27              DO
     C**N82*****         READP     @INMVL1                                90    *           MD058081
     C**N82*****         READ      @INMVL1                                90    *           MD058081
     C                   If        *IN82 = '0'                                              MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch prior from ACursor into :MEINMV                                               MD058081
     C/END-EXEC                                                                             MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEINMV                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   Endif                                                              MD058081
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(38)
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C******IN82         DOWEQ     '0'                                                      MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2NWRK        IFEQ      *BLANK                                       Network
     C     #2MTPY        IFNE      *BLANK                                       Message type
     C     MVMTPY        CABNE     #2MTPY        BB020                          Message type
     C                   END
     C                   END
     C     #2NWRK        IFEQ      *BLANK                                       Network
     C     #2MTPY        OREQ      *BLANK                                       Message type
     C     #2SNDK        IFNE      *BLANK                                       Sender (key)
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    MVSNDK                         Sender (key)
      * Length
     C                   PARM      20            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQSNDK
      * Length
     C                   PARM      20            WQC3N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG3N             3 0
     C     WQG3N         CABLT     1             BB020
     C                   END
     C                   END
     C     #2ACPT        IFNE      *BLANK                                       Access Point
     C     MVACPT        CABNE     #2ACPT        BB020                          Access Point
     C                   END
     C     #2INEX        IFNE      *BLANK                                       Include/Exclude
     C     MVINEX        CABNE     #2INEX        BB020                          Include/Exclude
     C                   END
     C     #2BRCA        IFNE      *BLANK                                       Branch Code
     C     MVBRCA        CABNE     #2BRCA        BB020                          Branch Code
     C                   END
     C     #2PMFG        IFNE      *BLANK                                       Payment Message
     C     MVPMFG        CABNE     #2PMFG        BB020                          Payment Message
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Initialise subfile record from DBF record
      * DSPFIL: Init. SF record - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile record
     C/COPY WNCPYSRC,ME1090DISR
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C**********         READ      @INMVL1                                82    *82=EOF     MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MEINMV                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI ##RR = *ZERO
      *
      *................................................................
      * Save highest SFL record load can continue at end point
     C     ##RR          IFGT      ##RRMX
     C     ##RRMX        ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
      * If scan limit reached, display error message
     C     ##RRRD        IFGE      W0SLM
      * Send message '*Scan limit reached'
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   END
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen
      *================================================================
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
      * Update screen time
     C                   TIME                    ##TME
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   SETOFF                                         8392    *
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * CALC: Subfile control function fields
      * DSPFIL: Cal. Control flds - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Calculate Control fields
     C/COPY WNCPYSRC,ME1090DSCF
      * Change of position specified
     C     WZNWRK        CASNE     #2NWRK        FBRQRL
     C     WZMTPY        CASNE     #2MTPY        FBRQRL
     C     WZSNDK        CASNE     #2SNDK        FBRQRL
     C     WZACPT        CASNE     #2ACPT        FBRQRL
     C     WZINEX        CASNE     #2INEX        FBRQRL
     C     WZBRCA        CASNE     #2BRCA        FBRQRL
     C     WZPMFG        CASNE     #2PMFG        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * DSPFIL: Process SF Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process subfile control
     C/COPY WNCPYSRC,ME1090DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * DSPFIL: Final Processing - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Final Processing
     C/COPY WNCPYSRC,ME1090DFPR
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *
      * CASE: CTL.*CMD key is CF09
      *
      * Call add processing
      *
     C     *IN09         IFEQ      '1'                                          *IF
      *
      * Check user has access to add
      *
     C                   MOVEL     'I'           #1SEL
     C                   EXSR      SRMBIN
      *
      * User does not have access
      *
     C     *IN99         IFEQ      '1'                                          *IF
     C                   GOTO      DAEXIT
     C                   END                                                    *FI
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       O2NWRK
     C                   MOVEL     *BLANKS       O2MTPY
     C                   MOVEL     *BLANKS       O2SNDR
      *
     C                   CALL      'ME1210'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      'I'           WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'MIN0019'     P0RTN
     C                   END                                                    *FI
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
      *
      * Send message 'F12 taken from previous screen'
      *
     C                   MOVEL     'MIN0001'     ZAMSID
     C                   EXSR      ZASNMS
     C                   GOTO      DAEXIT
      *
      *  F3 pressed - exit program
      *
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *  If error redisplay
      *
     C     P0RTN         WHENNE    *BLANKS                                      *IF
      *
      * Re-display screen
      *
     C                   MOVEL     'MIN0019'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DAEXIT
      *
      *  New selection - redisplay subfile
      *
     C     P0RTN         WHENEQ    *BLANKS                                      *IF
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DAEXIT
     C                   ENDSL                                                  *LS
     C                   ENDIF                                                  *FI
      * USER: Process command keys
      * DSPFIL: Process Cmd keys - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Command Keys
     C/COPY WNCPYSRC,ME1090DPCK
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Read first changed slf record
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process subfile record
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
      *================================================================
     C*                                                               *
     C* SRACTD - Check Action code                                    *
     C*                                                               *
     C*                                                               *
     C* Called by: DCPRSR                                             *
     C*                                                               *
      *================================================================
     CSR   SRACTD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
      *
      * Check all valid actions
      *
      *
      * CASE: RCD.*SFLSEL is not valid
      *
     C     #1SEL         IFEQ      ' '                                          *IF
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
     C     #1SEL         IFNE      'E'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     #1SEL         ANDNE     '1'                                          *IF
     C     #1SEL         ORNE      '1'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     P1ACTC        ANDEQ     'S'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     P1ACTC        ANDEQ     'E'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     P1ACTC        ANDEQ     'A'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Invalid Action code'
     C                   MOVEL     'MIN0008'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      EXACTD
     C                   END                                                    *FI
      *
      * Check multi-branch actions
      *
     C                   EXSR      SRMBIN
      *
      *  Unwind subroutine stack name
      *
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
     C*                                                               *
     C* SRMBIN - Check Multi-branch actions                           *
     C*                                                               *
     C*                                                               *
     C* Called by: SRACTD                                             *
     C*                                                               *
      *================================================================
     CSR   SRMBIN        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMBIN'      @STK(Q)
      *
      * Set up parameters
      *
     C                   CLEAR                   W0DATA
     C                   MOVEL     *BLANKS       B#BRCA
     C                   MOVEL     #1SEL         O#ACTD
     C                   MOVEL     ##PGM         O#CPGM
      *
      * Check all valid actions
      *
     C                   CALL      'ME1190'                             9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      '*ACTCODE'    W0ACT             8
     C                   PARM                    W0DATA
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'MIN0019'     P0RTN
     C                   SETON                                        9838      *
     C                   END                                                    *FI
      *
      * Invalid action
      *
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SETON                                        9838      *
     C                   ELSE                                                   *FI
     C                   SETON                                        99        *
     C                   END                                                    *FI
     C                   END                                                    *FI
      *
      *  Unwind subroutine stack name
      *
     C     EXMBIN        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
      *================================================================
     C*                                                               *
     C* SRRCHG - Record Changed                                       *
     C*                                                               *
     C*                                                               *
     C* Called by: DCPRSR                                             *
     C*                                                               *
      *================================================================
     CSR   SRRCHG        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRCHG'      @STK(Q)
      *
      * Set up key from subfile record and chain to record
      *
     C     KYMVL0        KLIST
     C                   KFLD                    #1NWRK                         Network
     C                   KFLD                    #1MTPY                         Message type
     C                   KFLD                    #1SNDK                         Sender (key)
      *
     C*****KYMVL0        CHAIN     @INMVL0                            90        *           MD058081
     C/EXEC SQL                                                                             MD058081
     C+ SELECT *                                                                            MD058081
     C+ into :MEINMV                                                                        MD058081
     C+ from MEIVMJW0                                                                       MD058081
     C+ where MVNWRK = :#1NWRK and MVMTPY = :#1MTPY and MVSNDK = :#1SNDK                    MD058081
     C/END-EXEC                                                                             MD058081
      *
      * Record not found - database error
      *
     C******IN90         IFEQ      '1'                                                      MD058081
     C     SQLCODE       IFEQ      100                                                      MD058081
     C                   MOVEL     'MEINMVL0'    W0FILE
     C                   MOVEL     #1NWRK        ##0009            9            Network
     C                   MOVE      #1MTPY        ##0009                         Message type
     C     ##0009        CAT(P)    #1SNDK        W0KEY                          Sender (key)
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI not equal to 'D'
      *
     C     #1SEL         IFNE      *BLANKS
     C     MVRECI        IFNE      'D'
      * Send message 'Invalid Action code - record deleted'
     C                   MOVEL     'MIN0216'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
     C                   END
     C                   GOTO      EXRCHG
     C                   END
      *
      *  Reload subfile record
      *
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
      *
      *  Unwind subroutine stack name
      *
     C     EXRCHG        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *================================================================
     CSR                 ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(38)
     C                   MOVEL     *BLANKS       P0RTN
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * DSPFIL: Process SF rec - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Subfile Record
     C/COPY WNCPYSRC,ME1090DPSR
      *
      * Check action code is valid, if invalid exit.
      *
     C                   EXSR      SRACTD
      *
      * Check record is active
      *
     C                   EXSR      SRRCHG
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
     C                   END                                                    *FI
      *
      * Call option
      *
     C                   SELECT
      *
      * Amend, Delete and Enquire
      *
     C     #1SEL         WHENEQ    'A'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'E'
      *
      * Set up parameters
      *
     C                   MOVEL     #1NWRK        O2NWRK
     C                   MOVEL     #1MTPY        O2MTPY
     C                   MOVEL     #1SNDK        O2SNDR
      *
     C                   CALL      'ME1210'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1SEL         WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *
      * If in error set up return code
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'MIN0019'     P0RTN
     C                   END
      *
      * Select
      *
     C     #1SEL         WHENEQ    '1'
     C                   MOVEL     MVNWRK        P2NWRK
     C                   MOVEL     MVMTPY        P2MTPY
     C                   MOVEL     MVSNDK        P2SNDK
     C                   MOVEL     MVRECI        P2RECI
     C                   MOVEL     MVACPT        P2ACPT
     C                   MOVEL     MVINEX        P2INEX
     C                   MOVEL     MVBRCA        P2BRCA
     C                   MOVEL     MVPMFG        P2PMFG
     C                   MOVEL     MVNARR        P2NARR
     C                   MOVEL     MVAJOB        P2AJOB
     C                   MOVEL     MVAUSR        P2AUSR
     C                   Z-ADD     MVATIM        P2ATIM
     C                   MOVEL     MVARDT        P2ARDT
     C                   MOVEL     MVAACT        P2AACT
     C                   MOVEL     MVRDNB        P2RDNB
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
     C                   EXSR      ZXEXPG
      *
     C                   ENDSL
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
      *
      * Send message 'F12 taken from previous screen'
      *
     C                   MOVEL     'MIN0015'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      *  F3 pressed - exit program
      *
     C     P0RTN         WHENEQ    'Y2U9999'                                    *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
      *
      *  If error redisplay
      *
     C     P0RTN         WHENNE    *BLANKS                                      *IF
      *
      * Re-display screen
      *
     C                   MOVEL     'MIN0019'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DCENDT                                       *QUIT
      *
      *  Function completed normally
      *
     C     P0RTN         WHENEQ    *BLANKS                                      *IF
     C                   ENDSL                                                  *LS
      *
     C     DCENDT        TAG
     C     *IN98         IFEQ      '1'
      * SFLRCD invalid
     C  N99              Z-ADD     ##RR          ##SFRC               99        *
      * SFLNXTCHG
     C                   SETON                                        84
     C                   ELSE
      * SFLRCD valid
      * SFLNXTCHG
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #1SEL
     C                   END                                                    FI *IN98
      *
      *  If option did not end in error, F12 or F3 then update record
      *  with changes
      *
     C     P0RTN         IFEQ      *BLANKS
     C     *IN98         ANDEQ     '0'
     C                   EXSR      SRRCHG
     C                   END
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @INMVL1 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     MVRECI        #1RECI                         Record Identifi
     C                   MOVEL     MVNARR        #1NARR                         Narrative
     C                   MOVEL     MVAJOB        #1AJOB                         Job name
     C                   MOVEL     MVAUSR        #1AUSR                         User name
     C                   Z-ADD     MVATIM        #1ATIM                         Action Time
     C                   MOVEL     MVARDT        #1ARDT                         Action Date
     C                   MOVEL     MVAACT        #1AACT                         Action Type
     C                   Z-ADD     MVRDNB        #1RDNB                         Run day number
     C                   MOVEL     MVNWRK        #1NWRK                         Network
     C                   MOVEL     MVMTPY        #1MTPY                         Message type
     C                   MOVEL     MVSNDK        #1SNDK                         Sender (key)
     C                   MOVEL     MVACPT        #1ACPT                         Access Point
      *
      * If deleted stop subfile selection and place deleted in
      * access point
      *
     C     #1RECI        IFEQ      '*'                                          Record Identifi
     C                   MOVEL     *BLANKS       #1ACPT
     C                   MOVEL     U#DELT        #1ACPT
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   GOTO      MBEXIT
     C                   END
      *
     C                   MOVEL     MVINEX        #1INEX                         Include/Exclude
     C                   MOVEL     MVBRCA        #1BRCA                         Branch Code
     C                   MOVEL     MVPMFG        #1PMFG                         Payment Message
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * DSPFIL: SF rec func flds - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Subfile Record function fields
     C/COPY WNCPYSRC,ME1090DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
      *
      * Initialise header and footer fields
      *
     C                   MOVEL     *BLANK        ##ONAM                         Option Name
     C                   MOVEL     *BLANK        ##CMD1                         CMD Line 1
     C                   MOVEL     *BLANK        ##CMD2                         CMD Line 2
      *
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #2NWRK                         Network
     C                   MOVEL     *BLANK        #2MTPY                         Message type
     C                   MOVEL     *BLANK        #2SNDK                         Sender (key)
     C                   MOVEL     *BLANK        #2ACPT                         Access Point
     C                   MOVEL     *BLANK        #2INEX                         Include/Exclude
     C                   MOVEL     *BLANK        #2BRCA                         Branch Code
     C                   MOVEL     *BLANK        #2PMFG                         Payment Message
      *
      * Fill Command lines and narrative text from messages
      *
     C                   SELECT
      *
      * Enquiry screen
      *
     C     P1ACTC        WHENEQ    'E'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0035'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0036'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0037'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Update screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0038'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0039'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0040'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Allow function key 9
      *
     C                   MOVEL     '1'           *IN77
      *
      * Selection screen
      *
     C     P1ACTC        WHENEQ    'S'
      *
      * Option Name
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0041'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0042'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0043'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      *
      * Allow function key 12
      *
     C                   MOVEL     '1'           *IN78
      *
     C                   ENDSL
      *
      * Get deleted text
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0214'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *LIKE         DEFINE    #1ACPT        U#DELT
     C                   MOVEL     #MSTX1        U#DELT
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
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
     CSR   ZAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      *
      * CASE: CTL.*CMD key is CF03
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   END                                                    *FI
      * CASE: CTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   END                                                    *FI
      *
      * DSPFIL: Exit Program Proc - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Exit Program Processing
     C/COPY WNCPYSRC,ME1090DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Copy any undisplayed messages back to caller
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
      *
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'MEMSG'       ZADFMF           10
     C                   Z-ADD     11            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
      * USER: Initialise program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C* Get Rundate - Rundate  *
     C*
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Set multi-branch indicator
      *
     C     WUMBIN        IFNE      'Y'                                          Multi Branched ?
     C                   MOVEL     '1'           *IN70
     C                   END
     C*
     C* Get modules information
     C*
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     MMODDS        PARM      *BLANKS       DSFDY                          O:Module Flg
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Open file MEINMVL1
      *
     C*****FIL001        IFEQ      *BLANKS                                                  MD058081
      **********                                                                            MD058081
      ***Override file MEINMVL1 to share(*NO)                                               MD058081
      **********                                                                            MD058081
     C**********         MOVEA     CMD@(1)       EDT                                        MD058081
     C**********         MOVEL     'MEINMVL1'    U#FILE           10                        MD058081
     C**********         MOVEA     U#FILE        EDT(17)                                    MD058081
     C**********         MOVEA     EDT           OVRDBF           80                        MD058081
     C**********         Z-ADD     80            CMDLEN           15 5                      MD058081
     C**********         CALL      'QCMDEXC'                              90    90          MD058081
     C**********         PARM                    OVRDBF                                     MD058081
     C**********         PARM                    CMDLEN                                     MD058081
      **********                                                                            MD058081
     C******IN90         IFEQ      '1'                                                      MD058081
     C**********         MOVEL     '*CALL  '     W0FILE                                     MD058081
     C**********         MOVEL     'QCMDEXC'     W0KEY                                      MD058081
     C**********         Z-ADD     3             W0ERNB                                     MD058081
     C**********         MOVEL     'MEM5003'     W0MSGD                                     MD058081
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD058081
     C**********         EXSR      SRERR                                                    MD058081
     C**********         END                                                                MD058081
      **********                                                                            MD058081
     C**********         OPEN      MEINMVL1                                                 MD058081
     C**********         MOVEL     'Y'           FIL001            1                        MD058081
     C**********         END                                                                MD058081
      **********                                                                            MD058081
      **Open*file MEINMVL0                                                                  MD058081
      **********                                                                            MD058081
     C*****FIL002        IFEQ      *BLANKS                                                  MD058081
      **********                                                                            MD058081
      ***Override file MEINMVL0 to share(*NO)                                               MD058081
      **********                                                                            MD058081
     C**********         MOVEA     CMD@(1)       EDT                                        MD058081
     C**********         MOVEL     'MEINMVL0'    U#FILE           10                        MD058081
     C**********         MOVEA     U#FILE        EDT(17)                                    MD058081
     C**********         MOVEA     EDT           OVRDBF           80                        MD058081
     C**********         Z-ADD     80            CMDLEN           15 5                      MD058081
     C**********         CALL      'QCMDEXC'                              90    90          MD058081
     C**********         PARM                    OVRDBF                                     MD058081
     C**********         PARM                    CMDLEN                                     MD058081
      **********                                                                            MD058081
     C******IN90         IFEQ      '1'                                                      MD058081
     C**********         MOVEL     '*CALL  '     W0FILE                                     MD058081
     C**********         MOVEL     'QCMDEXC'     W0KEY                                      MD058081
     C**********         Z-ADD     4             W0ERNB                                     MD058081
     C**********         MOVEL     'MEM5003'     W0MSGD                                     MD058081
     C**********         MOVEL     'MIDAS  '     W0MSGF                                     MD058081
     C**********         EXSR      SRERR                                                    MD058081
     C**********         END                                                                MD058081
      **********                                                                            MD058081
     C**********         OPEN      MEINMVL0                                                 MD058081
     C**********         MOVEL     'Y'           FIL002            1                        MD058081
     C**********         END                                                                MD058081
      * DSPFIL: Initialise Prog. - R10 Copy source templates  *
     C*DSPRCD: Cpysrc Templates Initialise Program C-Spec
     C/COPY WNCPYSRC,ME1090DCPG
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     C*
     C* File and Program Error Processing
     C*
     C*COPY*MECPYSRC,SRERRC                                                                 MD058081
     C/COPY MECPYSRC,SRERRCLE                                                               MD058081
     O*DSPRCD: Cpysrc Templates Initialise Program O-Spec
     O/COPY WNCPYSRC,ME1090DOPG
**  CPY@
(c) Finastra International Limited 2001
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
