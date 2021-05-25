     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Display Corr. Assoc. Display file')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG0080 - Display Corr. Association Display file              *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 115722             Date 12Feb98               *
      *                 S01522             Date 21Nov94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  115722 - Comment out references to CGUSRMSG/CGD1001          *
      *  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*DSPRCD: Cpysrc Templates Initialise Program F-Spec
     F/COPY WNCPYSRC,CG0080DFPG
     FCG0080DF  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      * DSP: Display Corr. Association Display file
      *
     FCGCASCL1  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Association Retrieval index
      *
     FCGCASCL0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      * UPD : Correspondent Association Update index
      *
     FCGCORRL1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Correspondent Details     Retrieval index
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
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)                                            CSC022
      **                                                                                      CSC022
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D*
     D*  Copysource for error processing
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program E-Spec
     D/COPY WNCPYSRC,CG0080DEPG
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
     D*
     D*  End of Program Error Processing copysource
     D*
     D*
     D*DSPRCD: Cpysrc Templates Initialise Program I-Spec
     D/COPY WNCPYSRC,CG0080DIPG
      /EJECT
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
     D*
     D* Modules Data Structure *
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     S01194
     D*                                                                                       S01194
     D* Data Structures used by Access Programs                                               S01194
     D*                                                                                       S01194
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS            20
      * KEY: Correspondent Association Retrieval index
      * I : RST From Correspondent
     D  P2FCOR                 1     10
      * I : MAP To Correspondent
     D  P2TCOR                11     20
     D O2PARM          DS            20
      * KEY: Correspondent Association Retrieval index
      * I : RST From Correspondent
     D  O2FCOR                 1     10
      * I : MAP To Correspondent
     D  O2TCOR                11     20
     D O3PARM          DS            10
      * KEY: Correspondent Details     Retrieval index
      * I : MAP Correspondent
     D  O3CORR                 1     10
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Invalid Action code (FT1)'
      * *SFLSEL
     D  ZA0001                 1      1
      /EJECT
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D W0DATA          DS           256
      *
      *  Define data structure used to pass parameters
      *
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
      *
      **                                                                                      CSC022
     D SCCMT           DS           256                                                       CSC022
     D  WCMTNO                 1      3  0                                                    CSC022
     D  WCJOBS                 4    103                                                       CSC022
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for Switchable Features details                                                   CSC022
      **                                                                                      CSC022
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1            Action Code
     C                   PARM                    P2PARM                         KEY: Correspond
      *
      *  Set up primary reference
      *
     C                   MOVEL     P2PARM        W0PREF
      *****************************************************************
      * Initialize
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
      * USER: Initialize subfile control
      * DSPFIL: Init. Subfile Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile control
     C/COPY WNCPYSRC,CG0080DISC
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    CAFCOR                         From Correspond
     C                   KFLD                    CATCOR                         To Corresponden
      * Setup key
     C                   MOVEL     #2FCOR        CAFCOR                         From Correspond
     C                   MOVEL     #2TCOR        CATCOR                         To Corresponden
     C     KPOS          SETLL     @CASCL1
     C     KRST          KLIST
     C                   KFLD                    CAFCOR                         From Correspond
      * Setup key
     C                   MOVEL     #2FCOR        CAFCOR                         From Correspond
     C     KRST          READE     @CASCL1                              8782    *82=EOF
      * Save previous selector values
     C     *LIKE         DEFINE    #2RECI        WZRECI
     C                   MOVEL     #2RECI        WZRECI                         Record Identifi
     C     *LIKE         DEFINE    #2AJOB        WZAJOB
     C                   MOVEL     #2AJOB        WZAJOB                         Job name
     C     *LIKE         DEFINE    #2AUSR        WZAUSR
     C                   MOVEL     #2AUSR        WZAUSR                         User name
     C     *LIKE         DEFINE    #2ATIM        WZATIM
     C                   MOVEL     #2ATIM        WZATIM                         Action Time
     C     *LIKE         DEFINE    #2ARDT        WZARDT
     C                   MOVEL     #2ARDT        WZARDT                         Action Date
     C     *LIKE         DEFINE    #2AACT        WZAACT
     C                   MOVEL     #2AACT        WZAACT                         Action Type
     C     *LIKE         DEFINE    #2RDNB        WZRDNB
     C                   MOVEL     #2RDNB        WZRDNB                         Run day number
     C     *LIKE         DEFINE    #2TCOR        WZTCOR
     C                   MOVEL     #2TCOR        WZTCOR                         To Corresponden
     C     *LIKE         DEFINE    #2DESC        WZDESC
     C                   MOVEL     #2DESC        WZDESC                         Description
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2DESC        WQDESC                         Description
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2DESC        WQDESC                         Description
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
     C  N82              READP     @CASCL1                                90    *
     C  N82              READ      @CASCL1                                90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(33)
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      * Set required pages based on *Set Cursor or *Subfile Pages
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      * Compute lines required based on pages
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
      *................................................................
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2RECI        IFNE      *BLANK                                       Record Identifi
     C     CARECI        CABNE     #2RECI        BB020                          Record Identifi
     C                   END
     C     #2AJOB        IFNE      *BLANK                                       Job name
     C     CAAJOB        CABNE     #2AJOB        BB020                          Job name
     C                   END
     C     #2AUSR        IFNE      *BLANK                                       User name
     C     CAAUSR        CABNE     #2AUSR        BB020                          User name
     C                   END
     C     #2ATIM        IFNE      *ZERO                                        Action Time
     C     CAATIM        CABNE     #2ATIM        BB020                          Action Time
     C                   END
     C     #2ARDT        IFNE      *BLANK                                       Action Date
     C     CAARDT        CABNE     #2ARDT        BB020                          Action Date
     C                   END
     C     #2AACT        IFNE      *BLANK                                       Action Type
     C     CAAACT        CABNE     #2AACT        BB020                          Action Type
     C                   END
     C     #2RDNB        IFNE      *ZERO                                        Run day number
     C     CARDNB        CABNE     #2RDNB        BB020                          Run day number
     C                   END
     C     #2DESC        IFNE      *BLANK                                       Description
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    CADESC                         Description
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQDESC
      * Length
     C                   PARM      30            WQC3N             3 0
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
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C                   EXSR      MC#1FN
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
      * USER: Initialize subfile record from DBF record
      * DSPFIL: Init. SF record - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Initialise subfile record
     C/COPY WNCPYSRC,CG0080DISR
     C                   SUB       1             ##RR
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C     KRST          READE     @CASCL1                                82    *82=EOF
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         TAG
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
      * Calculate top line
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   END
     C                   ADD       1             ##SFRC
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
      *
      * Reset Action taken
      *
     C                   MOVEL     *BLANKS       #ENTER            1
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
     C/COPY WNCPYSRC,CG0080DSCF
      * Change of position specified
     C     WZTCOR        CASNE     #2TCOR        FBRQRL
     C     WZDESC        CASNE     #2DESC        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * DSPFIL: Process SF Ctl - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process subfile control
     C/COPY WNCPYSRC,CG0080DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * DSPFIL: Final Processing - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Final Processing
     C/COPY WNCPYSRC,CG0080DFPR
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *
      * CASE: CTL.*CMD key is CF09
      *
      *
      * Call add processing
      *
     C     *IN09         IFEQ      '1'                                          *IF
      *
      * Action taken
      *
     C                   MOVEL     'Y'           #ENTER
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
     C                   MOVEL     *BLANKS       O2PARM
     C                   MOVEL     #2FCOR        O2FCOR
      *
     C                   CALL      'CG0070'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      'I'           WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: Incoming M
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
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
     C**Send*message*'F12*taken*from*previous*screen'*****************                        115722
     C*                                                                                       115722
     C*********************MOVEL'CGD1001' ZAMSID                                              115722
     C*********************EXSR ZASNMS                                                        115722
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
     C                   MOVEL     'CGD1000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
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
     C/COPY WNCPYSRC,CG0080DPCK
      *
      * If no Action taken and F12 and not select exit
      *
     C     #ENTER        IFEQ      *BLANKS
     C     *IN78         ANDEQ     '1'
     C     P1ACTC        ANDNE     'S'
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
     C                   EXSR      ZXEXPG
     C                   ENDIF
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
      *
      * Action taken
      *
     C                   MOVEL     'Y'           #ENTER
      * Process subfile record
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
      *
      * If F12 then redisplay screen with action code
      * Or action did not complete
      *
     C     P0RTN         IFNE      *BLANKS                                      *Return code
     C                   MOVEL     *BLANKS       P0RTN
     C                   GOTO      DBEXIT
     C                   END
      *
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
     C     #1SEL         ANDNE     'C'                                          *IF
     C     #1SEL         ANDNE     '1'                                          *IF
     C     #1SEL         ORNE      '1'                                          *IF
     C     #1SEL         ANDNE     'E'                                          *IF
     C     #1SEL         ANDNE     'C'                                          *IF
     C     P1ACTC        ANDEQ     'S'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     #1SEL         ANDNE     'C'                                          *IF
     C     P1ACTC        ANDEQ     'E'                                          *IF
     C     #1SEL         ORNE      'E'                                          *IF
     C     #1SEL         ANDNE     'A'                                          *IF
     C     #1SEL         ANDNE     'D'                                          *IF
     C     #1SEL         ANDNE     'C'                                          *IF
     C     P1ACTC        ANDEQ     'A'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'Invalid Action code'
     C                   MOVEL     'CGD1002'     ZAMSID
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
     C     #1SEL         IFEQ      '1'                                          *IF
     C                   MOVEL     'X'           O#ACTD
     C                   END                                                    *FI
      *
      * Check all valid actions
      *
     C                   CALL      'CG1020'                             9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      '*ACTCODE'    W0ACT             8
     C                   PARM                    W0DATA
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
     C                   SETON                                        9833      *
     C                   END                                                    *FI
      *
      * Invalid action
      *
     C     P0RTN         IFNE      *BLANKS                                      *IF
     C     #1SEL         IFNE      'I'
     C                   SETON                                        9833      *
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
     C     KYMFL0        KLIST
     C                   KFLD                    #1FCOR                         From Correspond
     C                   KFLD                    #1TCOR                         To Corresponden
      *
      * Only chain if record if live #1RECI is 'D'
      *
     C     #1RECI        IFEQ      'D'
     C     KYMFL0        CHAIN     @CASCL0                            90        *
      *
      * Record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGCASCL0'    W0FILE
     C     #1FCOR        CAT       #1TCOR        W0KEY                          Report Date E
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C                   ELSE
     C                   MOVEL     #1RECI        CARECI
     C                   END
      *
      *  If action code is not blank then send messge record has been
      *  deleted if RECI not equal to 'D'
      *
     C     #1SEL         IFNE      *BLANKS
     C     CARECI        IFNE      'D'
      * Send message 'Invalid Action code - record deleted'
     C                   MOVEL     'CGD1003'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
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
     C                   MOVEA     WKIND0        *IN(33)
     C                   MOVEL     *BLANKS       P0RTN
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * DSPFIL: Process SF rec - R10 Copy source templates  *
     C*DSPFIL: Cpysrc Templates Process Subfile Record
     C/COPY WNCPYSRC,CG0080DPSR
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
     C                   MOVEL     *BLANKS       O2PARM
     C                   MOVEL     #1FCOR        O2FCOR
     C                   MOVEL     #1TCOR        O2TCOR
      *
     C                   CALL      'CG0070'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1SEL         WP0001            1            Action Code
     C                   PARM                    O2PARM                         KEY: GRPS
      *
      * If in error set up return code
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END
      *
      * Enquire on report data element
      *
     C     #1SEL         WHENEQ    'C'
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       O3PARM
     C                   MOVEL     #1TCOR        O3CORR
      *
     C                   CALL      'CG0010'                             9090
     C                   PARM                    P0RTN             7
     C                   PARM      'E'           WP0001            1            Action Code
     C                   PARM                    O3PARM                         KEY: RDE
      *
      * If in error set up return code
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END
      *
      * Select
      *
     C     #1SEL         WHENEQ    '1'
     C                   MOVEL     #1FCOR        P2FCOR
     C                   MOVEL     #1TCOR        P2TCOR
     C                   MOVEL     *BLANKS       P0RTN                          *Return code
     C                   EXSR      ZXEXPG
      *
     C                   ENDSL
      *
      * Option ended in error
      *
     C     *IN90         IFEQ      '1'                                          *IF
     C                   MOVEL     'CGD1000'     P0RTN
     C                   END                                                    *FI
      *
      *  Depending on return code - exit or re-display screen
      *
     C                   SELECT                                                 *SL
      *
      *  F12 pressed - redisplay subfile
      *
     C     P0RTN         WHENEQ    'USR0790'                                    *IF
      *
     C**Send*message*'F12*taken*from*previous*screen'*****************                        115722
     C*                                                                                       115722
     C*********************MOVEL'CGD1001' ZAMSID                                              115722
     C*********************EXSR ZASNMS                                                        115722
     C                   SETON                                        9833      *
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
     C                   MOVEL     'CGD1000'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9833      *
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
      * Move @CASCL1 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     CAFCOR        #1FCOR                         From Correspond
     C                   MOVEL     CARECI        #1RECI                         Record Identifi
     C                   MOVEL     CAAJOB        #1AJOB                         Job name
     C                   MOVEL     CAAUSR        #1AUSR                         User name
     C                   Z-ADD     CAATIM        #1ATIM                         Action Time
     C                   MOVEL     CAARDT        #1ARDT                         Action Date
     C                   MOVEL     CAAACT        #1AACT                         Action Type
     C                   Z-ADD     CARDNB        #1RDNB                         Run day number
     C                   MOVEL     CATCOR        #1TCOR                         To Corresponden
     C                   MOVEL     CADESC        #1DESC                         Description
      *
      * If deleted stop subfile selection and place deleted in
      * access point
      *
     C     #1RECI        IFEQ      '*'                                          Record Identifi
     C                   MOVEL     *BLANKS       #1DESC                         Special Instruc
     C                   MOVEL     U#DELT        #1DESC
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   GOTO      MBEXIT
     C                   END
      *
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
     C/COPY WNCPYSRC,CG0080DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     P1ACTC        #PACTC                         Action Code
     C                   MOVEL     *BLANK        #2RECI                         Record Identifi
     C                   MOVEL     *BLANK        #2AJOB                         Job name
     C                   MOVEL     *BLANK        #2AUSR                         User name
     C                   Z-ADD     *ZERO         #2ATIM                         Action Time
     C                   MOVEL     *BLANK        #2ARDT                         Action Date
     C                   MOVEL     *BLANK        #2AACT                         Action Type
     C                   Z-ADD     *ZERO         #2RDNB                         Run day number
     C                   MOVEL     P2FCOR        #2FCOR                         From Correspond
     C                   MOVEL     P2TCOR        #2TCOR                         To Corresponden
     C                   MOVEL     *BLANK        #2DESC                         Description
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
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1158'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1169'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'CGD1028'     #UFKEY
     C                   ELSE
     C                   MOVEL     'CGD1021'     #UFKEY
     C                   END
      *
      * Update screen
      *
     C     P1ACTC        WHENEQ    'A'
      *
      * Option Name
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1159'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1170'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'CGD1031'     #UFKEY
     C                   ELSE
     C                   MOVEL     'CGD1052'     #UFKEY
     C                   END
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
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1160'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##ONAM
      *
      * Action codes
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1171'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD1
      *
      * Function keys
      *
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'CGD1028'     #UFKEY
     C                   ELSE
     C                   MOVEL     'CGD1021'     #UFKEY
     C                   END
      *
     C                   ENDSL
      *
      * Function keys
      *
     C     *LIKE         DEFINE    #MSGID        #UFKEY
     C                   CALL      'CGC1000'                            9090
     C                   PARM      #UFKEY        #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##CMD2
      * Check restriction within
     C                   EXSR      VACKRL
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Check restriction within
      *================================================================
      *
     C     KLVACD        KLIST
     C                   KFLD                    CDCORR                         Correspondent
      * Setup key
     C                   MOVEL     #2FCOR        CDCORR                         Correspondent
     C     KLVACD        CHAIN     @CORRL1                            9091      *
     C     *IN90         IFEQ      '0'
      * Record found - move back any virtuals
     C                   GOTO      VAEXIT
     C                   END
      * Restrictor relation not satisfied
      * Send message 'Correspondent Details  NF'
     C                   MOVEL     'CGD1157'     ZAMSID
     C                   MOVEL     '*PRV '       ZAPGRL                         Rel queue
     C                   EXSR      ZASNMS
     C                   MOVEL     'CGD1157'     P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   VAEXIT        ENDSR
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
     C/COPY WNCPYSRC,CG0080DEPP
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
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Obtain default message file
     C                   MOVEL     'CGUSRMSG'    ZADFMF           10
     C                   Z-ADD     11            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Retrieve Midas Date - R10 Standard Functions  *
     C*
     C*  Set up copyright parameter
     C*
     C                   MOVEA     CPY@          ACT@             80
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
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Open file CGCASCL1
      *
     C     FIL001        IFEQ      *BLANKS
      *
      *  Override file CGRDTAL1 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'CGCASCL1'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      CGCASCL1
     C                   MOVEL     'Y'           FIL001            1
     C                   END
      *
      * Open file CGCASCL0
      *
     C     FIL002        IFEQ      *BLANKS
      *
      *  Override file CGCASCL0 to share(*NO)
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'CGCASCL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   OPEN      CGCASCL0
     C                   MOVEL     'Y'           FIL002            1
     C                   END
      **                                                                                      CSC022
      ** Initialize CSC022 and Skip Commit/Rollback flags                                     CSC022
      **                                                                                      CSC022
     C                   MOVE      'N'           CSC022            1                          CSC022
     C                   MOVE      'N'           WCMTSK            1                          CSC022
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       P@RTCD                                       CSC022
     C                   PARM      '*VERIFY '    P@OPTN                                       CSC022
     C                   PARM      'CSC022'      P@SARD            6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
     C     P@RTCD        IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT                                        CSC022
     C                   IN        SCCMT                                                      CSC022
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0                                                          CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT                                         CSC022
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50                  CSC022
     C     *IN50         IFEQ      *ON                                                        CSC022
     C                   MOVE      'Y'           WCMTSK                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ELSE                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     P@RTCD        IFNE      '*NRF'                                                     CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   Z-ADD     5             W0ERNB                                       CSC022
     C                   EXSR      SRERR                                                      CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
      *
      * Allow function key 12 if lower case action
      *
     C                   SELECT
     C     P1ACTC        WHENEQ    's'
     C     P1ACTC        OREQ      'S'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'S'           P1ACTC
     C     P1ACTC        WHENEQ    'e'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'E'           P1ACTC
     C     P1ACTC        WHENEQ    'a'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'A'           P1ACTC
     C                   ENDSL
      *
      * Get deleted text
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1019'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *LIKE         DEFINE    #1DESC        U#DELT
     C                   MOVEL     #MSTX1        U#DELT
      * DSPFIL: Initialise Prog. - R10 Copy source templates  *
     C*DSPRCD: Cpysrc Templates Initialise Program C-Spec
     C/COPY WNCPYSRC,CG0080DCPG
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
     C*
     C* File and Program Error Processing
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
     O*DSPRCD: Cpysrc Templates Initialise Program O-Spec
     O/COPY WNCPYSRC,CG0080DOPG
**  CPY@
(c) Finastra International Limited 2001
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
