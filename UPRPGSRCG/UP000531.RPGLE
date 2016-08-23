     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare job maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000531 - Compare Job Maintenance                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CUP034  *RENAME    Date 16Jan07               *
      *  Prev Amend No. CSM005  *REWRITE   Date 18Aug05               *
      *                 CUP028             Date 02Sep04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK009             Date 09Jun99               *
      *                 CUP001 *CREATE     Date 23Dec98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP034 - Renamed because UP000030 was overwritten by a new   *
      *           program for CMPDBA.                                 *
      *  CSM005 - Rewrite of UP0030 and moved to global layer.        *
      *  CUP028 - Change OWNER value to be passed in parameter and    *
      *           AUTL value to be always *USE.                       *
      *  CPK009 - Change of field, scan on subfile                    *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
      *****************************************************************
     FUP000030DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB Dependency relations maintenance
      *
     FUPJOBEL0  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(*PSSR)
      * RTV : Midas CB Dependency relations retrieval
      *
     FUPJOBEL1  UF   E           K DISK
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
     F                                     RENAME(UPJOBED0:UPJOBED1)
     FUP000030P1O    E             PRINTER OFLIND(*IN15)
     F                                     USROPN
     F                                     INFDS(SPOOLU)
      * UPD : Midas CB Components update
      *
     D AENA            S             78    DIM(1) CTDATA PERRCD(1)
     D CMD             S             70    DIM(4) CTDATA PERRCD(1)
      *
      *  DETAIL LINE COMMAND KEY TEXT
      *
     D********************************************************************
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
      * DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
     D SPOOLU          DS
      ***  File Information Data Structure for MMNNNNPY.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
      *
     D @1DBRC        E DS                  EXTNAME(UPJOBEL0)
      *
      * Current/previous master file format fields for change control
      *
     D QCBCM1        E DS                  EXTNAME(UPJOBEL1)
     D  WAJOB        E                     EXTFLD(JOB)
     D  WAUSER       E                     EXTFLD(USER)
     D  WANBR        E                     EXTFLD(NBR)
     D  WALIBA       E                     EXTFLD(LIBA)
     D  WAFILA       E                     EXTFLD(FILA)
     D  WAMBRA       E                     EXTFLD(MBRA)
     D  WALIBB       E                     EXTFLD(LIBB)
     D  WAFILB       E                     EXTFLD(FILB)
     D  WAMBRB       E                     EXTFLD(MBRB)
     D  WAINTG       E                     EXTFLD(INTG)
     D  WALIBC       E                     EXTFLD(LIBC)
      *
      * Current/previous master file format fields for change control
      *
     D YARDCS          DS           259
     D YBRDCS          DS           259
     D YCRDCS          DS            34
     D ID0001          DS           528
      * File information data structure
      *
     D ID0003          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * B :  Successful Update Made
     D  P1SUPD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Member Name
     D  ZA0001                 1     10
      * Message data for 'Compnt/depended on exists'
      * Component Depends-on Name
     D  ZA0002                 1     10
      * Compnt Depends-on Seq No
     D  ZA0003                11     15
      * Compnt Depended-on Name
     D  ZA0004                16     25
      * Compnt Depended-on Seq No
     D  ZA0005                26     30
     D                 DS
     D  CMD1                   1     55
     D  FILT1                 27     54
     D                 DS
     D  CMD2                   1     67
     D  QUAL1                 16     37
     D  MBR1                  47     56
     D                 DS
     D  CMD3                   1    108
     D  CMD31                  1     71
     D  QUAL2                 19     39
     D  QUAL3                 49     69
     D  CMD32                 72    108
     D  MBR31                 80     89
     D  MBR32                 98    107
     D CMD6            DS
     D  QUAL61                15     34
     D  MBR61                 42     51
     D  QUAL62                59     78
     D  MBR62                 86     95
     D  NBR6                 102    107
     D  S6                   112    112
     D  MRGLIB               113    122
      /EJECT
      *****************************************************************
     C*
     C     *ENTRY        PLIST
     C                   PARM                    WRKLIB           10
      * Initialize
     C                   EXSR      ZZINIT
      *
     C                   DO        *HIVAL
      * Initialise and load subfile page
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      * Display screen until reload requested
     C     W0RSF         DOWEQ     'N'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Request subfile reload
     C   05              CAS                     FBRQRL
      * HOME: Request subfile reload
     C   11              CAS                     PRINTR
      * Display next SFL page
     C   27              CAS                     BBLDSF
      * Process screen input
     C                   CAS                     DAPR##
     C                   END
      *
     C                   END
     C                   END
      *****************************************************************
      /EJECT
     CSR   BAIZSF        BEGSR
      *================================================================
      * Initialise & load subfile page
      *================================================================
      * Clear subfile
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
      * Reset no of records in subfile
     C                   Z-ADD     *ZERO         ##RRMX            5 081         SETOF 81
      * USER: Initialize subfile header
      * Footer for edit file - Dependency Relations  *
     C*
     C                   MOVEA     AENA(1)       ##CTX1
     C*
      *................................................................
      * If CHANGE mode, then position file:
     C     *LIKE         DEFINE    #2JOB         WZJOB
     C                   MOVEL     #2JOB         WZJOB
     C     *LIKE         DEFINE    #2USER        WZUSER
     C                   MOVEL     #2USER        WZUSER
     C     *LIKE         DEFINE    #2FILA        WZFILA
     C                   MOVEL     #2FILA        WZFILA
     C     KPOS          KLIST
     C                   KFLD                    JOB
      * Setup key
     C                   MOVEL     #2JOB         JOB
     C                   MOVEL     #2USER        USER
      * 82=EOF
     C     KPOS          SETLL     UPJOBEL0                           82        *
      * 82=EOF
     C  N82              READ      UPJOBEL0                             9182    *
      * Load subfile page
      * Translate search mask for User
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      10            WQA5N             5 0
     C                   PARM      #2USER        WQUSER
     C                   PARM                    WQB10X
     C                   PARM      'QSYS'        WQC10X           10
      * Translate search mask for Source File
     C                   MOVEL     'QSYST'       WQB11X           10
     C                   MOVE      'RNTBL'       WQB11X
     C     *LIKE         DEFINE    #2FILA        WQFILA
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      10            WQA6N             5 0
     C                   PARM      #2FILA        WQFILA
     C                   PARM                    WQB11X
     C                   PARM      'QSYS'        WQC11X           10
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
     C  N82              READP     UPJOBEL0                               90    *
     C  N82              READ      UPJOBEL0                               90    *
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C*                    MOVEAWKIND0    *IN,34
     C                   MOVE      *ALL'1'       WKIND1            5
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
     C                   Z-ADD     *ZERO         ##RROK            5 0
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
DJ   C                   MOVEA     WKIND0        *IN(33)
DJ   C                   SETOFF                                       87        *
      * Check selection field - if fail, read next record
     C     #2USER        IFNE      *BLANK
      *
      * Ensure no blanks at beginning of search field
     C                   Z-ADD     0             F1                2 0
     C                   MOVE      WQUSER        F2               10
     C     ' '           CHECK     F2:1          F1                       30
     C                   SUBST     WQUSER:F1     WQUSE1           10
     C                   MOVEL(P)  WQUSE1        WQUSER
      * Scan for user search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    USER
      * Length
     C                   PARM      10            WQA1N             3 0
      * Start
     C                   PARM      1             WQB1N             3 0
      * Mask
     C                   PARM                    WQUSER
      * Length
     C                   PARM      10            WQC1N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG1N             3 0
     C     WQG1N         CABLT     1             BB020
     C                   END
      * Check selection field - if fail, read next record
     C     #2FILA        IFNE      *BLANK
      *
      * Ensure no blanks at beginning of search field
     C                   Z-ADD     0             F1                2 0
     C                   MOVE      WQFILA        F4               10
     C     ' '           CHECK     F4:1          F1                       30
     C                   SUBST     WQFILA:F1     WQFIL1           10
     C                   MOVEL(P)  WQFIL1        WQFILA
      * Scan for M/S Code search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    FILA
      * Length
     C                   PARM      10            WQA2N             3 0
      * Start
     C                   PARM      1             WQB2N             3 0
      * Mask
     C                   PARM                    WQFILA
      * Length
     C                   PARM      10            WQC2N             3 0
      * Translate
     C                   PARM      '1'           WQD1              1
      * Trim
     C                   PARM      '1'           WQE1              1
      * Wild
     C                   PARM      '?'           WQF1              1
      * Result
     C                   PARM                    WQG2N             3 0
     C     WQG2N         CABLT     1             BB020
     C                   END
      * Clear subfile fields
     C                   EXSR      MAIZ#1
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C*Display Initialise Subfile Rcd
     C                   SUB       1             ##RR
      * DBF record not selected
     C     W0RSL         CABNE     'Y'           BB020
      * Output to subfile
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81        *
      * If SFLRCD invalid, note that errors present
     C   98
     CANN99              SETON                                        99        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C                   READ      UPJOBEL0                               82    *82=EOF
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         TAG
      *................................................................
      * If no records found, display error message
     C   82##RR          IFEQ      *ZERO                                        IF
      * Send message '*No data to display'
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'UTMSGF'      ZAMSGF
     C                   EXSR      ZASNMS
     C                   END
      *
      *================================================================
      *EJECT
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
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
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * PUTOVR unless conditioned fields change
     C                   SETON                                        86
     C     *IN89         IFNE      CAIN89
     C     *IN81         ORNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN89         CAIN89            1
     C                   MOVE      *IN81         CAIN81            1
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
      * Maintain subfile position where possible
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   END
      * Test cursor
     C                   EXSR      Y8TST
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
     C                   END
      * Update job time
     C                   TIME                    ##JTM
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPR##        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      *
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZJOB         CASNE     #2JOB         FBRQRL
     C     WZUSER        CASNE     #2USER        FBRQRL
     C     WZFILA        CASNE     #2FILA        FBRQRL
     C                   END
      * Quit if reload requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *
     C   81              DO
      * No data entered as yet
     C                   MOVEL     'N'           WKIPIN            1
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * Process subfile records
     C                   EXSR      DBPRSF
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * If data entered
     C     WKIPIN        IFEQ      'Y'
      * Update DBF from subfile
     C                   EXSR      EAPRSF
      * If error during update, exit:
     C     *IN99         CABEQ     '1'           DAEXIT
     C                   END                                                    WKIPIN
     C                   END
      * Switch between *ADD/*CHANGE modes
     C   09              EXSR      FACHMD
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
     C                   EXSR      DCPRSR
     C                   SETOFF                                       87        *
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DCPRSR        BEGSR
      *================================================================
      * Process subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(33)
      * No errors
     C                   SETOFF                                       98
      * No SFLNXTCHG
     C                   SETOFF                                       84
      * Data entered
     C                   MOVEL     'Y'           WKIPIN
      * SFLNXTCHG
     C                   SETON                                        84
      * If delete request, bypass validation
     C     #1SEL         IFEQ      '5'
     C                   MOVEL     CMD(1)        CMD1
     C                   MOVEL     '/'           SLASH             1
     C     #1NBR         CAT       SLASH:0       FILT1
     C     FILT1         CAT       #1USER:0      FILT1
     C     FILT1         CAT       SLASH:0       FILT1
     C     FILT1         CAT       #1JOB:0       FILT1
     C                   Z-ADD     55            MSGLEN           15 5
     C                   CALL      'QCMDEXC'                            9393
     C                   PARM                    CMD1
     C                   PARM                    MSGLEN
     C                   GOTO      DCEXIT
     C                   END
      * If delete request, bypass validation
     C     #1SEL         IFEQ      '1'
     C                   MOVEL     CMD(2)        CMD2
     C                   MOVEL     '/'           SLASH             1
     C     #1LIBA        CAT       SLASH:0       QUAL1
     C     QUAL1         CAT       #1FILA:0      QUAL1
     C                   MOVEL     #1MBRA        MBR1
     C                   Z-ADD     67            MSGLEN           15 5
     C                   CALL      'QCMDEXC'                            9393
     C                   PARM                    CMD2
     C                   PARM                    MSGLEN
     C                   GOTO      DCEXIT
     C                   END
      * If delete request, bypass validation
     C     #1SEL         IFEQ      '2'
     C                   MOVEL     CMD(2)        CMD2
     C                   MOVEL     '/'           SLASH             1
     C     #1LIBB        CAT       SLASH:0       QUAL1
     C     QUAL1         CAT       #1FILB:0      QUAL1
     C                   MOVEL     #1MBRB        MBR1
     C                   Z-ADD     67            MSGLEN           15 5
     C                   CALL      'QCMDEXC'                            9393
     C                   PARM                    CMD2
     C                   PARM                    MSGLEN
     C                   GOTO      DCEXIT
     C                   END
      * If delete request, bypass validation
     C     #1SEL         IFEQ      '3'
     C                   MOVEL     CMD(3)        CMD31
     C                   MOVEL     CMD(4)        CMD32
     C                   MOVEL     '/'           SLASH             1
     C     #1LIBA        CAT       SLASH:0       QUAL2
     C     QUAL2         CAT       #1FILA:0      QUAL2
     C                   MOVEL     #1MBRA        MBR31
     C     #1LIBB        CAT       SLASH:0       QUAL3
     C     QUAL3         CAT       #1FILB:0      QUAL3
     C                   MOVEL     #1MBRB        MBR32
     C                   Z-ADD     108           MSGLEN           15 5
     C                   CALL      'QCMDEXC'                            9393
     C                   PARM                    CMD3
     C                   PARM                    MSGLEN
     C                   GOTO      DCEXIT
     C                   END
     C     #1SEL         IFEQ      'D'
     C     KEY7          KLIST
     C                   KFLD                    #1JOB
     C                   KFLD                    #1USER
     C                   KFLD                    #1NBR
     C     KEY7          CHAIN     UPJOBED1                           90        *
     C     *IN90         IFEQ      '0'
     C                   DELETE    UPJOBED1
     C                   END
     C                   GOTO      DCEXIT
     C                   END
      * If delete request, bypass validation
     C     #1SEL         IFEQ      'E'
     C                   MOVE      #1LIBB        QUAL61
     C                   MOVEL     #1FILB        QUAL61
     C                   MOVEL     #1MBRB        MBR61
     C                   MOVE      #1LIBA        QUAL62
     C                   MOVEL     #1FILA        QUAL62
     C                   MOVEL     #1MBRA        MBR62
     C                   MOVEL     #1NBR         NBR6
     C                   MOVEL     *BLANKS       RTCMD
     C                   MOVEL     #1LIBC        MRGLIB
     C                   CALL      'UPC000501'                          9393
     C                   PARM                    QUAL61
     C                   PARM                    MBR61
     C                   PARM                    QUAL62
     C                   PARM                    MBR62
     C                   PARM                    NBR6
     C                   PARM                    S6
     C                   PARM                    RTCMD             1
     C                   PARM                    MRGLIB
     C                   PARM                    WRKLIB
     C     RTCMD         CABEQ     '3'           BYP01
     C     KEY6          KLIST
     C                   KFLD                    #1JOB
     C                   KFLD                    #1USER
     C                   KFLD                    NBR6
     C     KEY6          CHAIN     UPJOBED1                           90        *
     C     *IN90         IFEQ      '0'
     C                   MOVEL     S6            INTG
     C                   UPDATE    UPJOBED1
     C                   EXSR      FBRQRL
     C                   END
     C     BYP01         TAG
     C                   GOTO      DCEXIT
     C                   END
      * Validate subfile record
     C                   EXSR      DEV1RC
      * If SFLRCD invalid, note the fact
     C   98
     CANN99              Z-ADD     ##RR          ##SFRC               99        *
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   DDNLRC        BEGSR
      *================================================================
      * Check for null record
      *================================================================
     C                   MOVEL     'N'           W0NLR             1
     C     #1JOB         CABNE     *BLANK        DDEXIT
     C     #1USER        CABNE     *BLANK        DDEXIT
     C     #1FILA        CABNE     *BLANK        DDEXIT
     C                   MOVEL     'Y'           W0NLR
      *================================================================
     CSR   DDEXIT        ENDSR
      /EJECT
     CSR   DEV1RC        BEGSR
      *================================================================
      * Validate subfile record
      *================================================================
      * USER: Validate subfile record fields
      * Start of 090416
      * Component depends on name & Seq no / depended on name & seq
      * End of 090416
      * Validate subfile record relations
     C                   EXSR      DFV2RC
      * Component Depends-on Name required
     C     #1JOB         IFEQ      *BLANK                                       IF
     C                   SETON                                        9834      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'UTMSGF'      ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Compnt Depends-on Seq No required
     C     #1USER        IFEQ      *BLANK                                       IF
     C                   SETON                                        9835      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'UTMSGF '     ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      * Compnt Depended-on Name required
     C     #1FILA        IFEQ      *BLANK                                       IF
     C                   SETON                                        9836      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID
     C                   MOVEL     'UTMSGF '     ZAMSGF
     C                   EXSR      ZASNMS
     C                   END                                                    FI
      *================================================================
     CSR   DEEXIT        ENDSR
      /EJECT
     CSR   DFV2RC        BEGSR
      *================================================================
      * Validate subfile record relations
      *================================================================
      * Check reference to Components
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983435    *
     C                   END
      * Check reference to Components
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        983637    *
     C                   END
      *================================================================
     CSR   DFEXIT        ENDSR
      /EJECT
     CSR   EAPRSF        BEGSR
      *================================================================
      * Update DBF from subfile
      *================================================================
      * Initialise subfile reload flag
     C                   MOVEL     'N'           W0RSF
      * Process all modified subfile records
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process modified subfile record
     C                   EXSR      EBPRSR
     C                   MOVEL     *BLANK        #1SEL
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                92    *
     C                   END
      * If any errors, cancel reload
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           W0RSF             1
     C                   END
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   EBPRSR        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
      * Set off error indicators
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       98
      *
      * If error occurred on update, note the fact
     C     *IN98         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ##RR          ##SFRC               99        *
     C                   END
     C                   ELSE
      * USER: Extra processing after DBF update
     C                   END                                                    *FI
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request
      *================================================================
      * USER: Create DBF record
     C     W0RTN         IFNE      *BLANK
      * Write error detected
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
     C                   ELSE
      * DBF write successful
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request
      *================================================================
      * USER: Delete DBF record
     C     W0RTN         IFNE      *BLANK
      * Delete unsuccessful
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * If record altered, reset subfile record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF delete successful
      * Blank out record and protect from entry
     C                   EXSR      MAIZ#1
      * disable entry
     C                   SETON                                        87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
      * Reload subfile
     C                   MOVEL     'Y'           W0RSF             1
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request
      *================================================================
      * USER: Change DBF record
     C     W0RTN         IFNE      *BLANK
      * Data update error
      * Screen errors
     C                   MOVEA     WKIND1        *IN(33)
      * Format error
     C                   SETON                                        98        *
      * Enable entry
     C                   SETOFF                                       87        *
      * SFLNXTCHG
     C                   SETON                                        84        *
      * Reset subfile record if changed record
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1                         IF
     C                   END
     C                   ELSE
      * DBF update successful
      * Enable entry
     C                   SETOFF                                       87        *
      * No SFLNXTCHG
     C                   SETOFF                                       84        *
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACHMD        BEGSR
      *================================================================
      * Switch between *ADD/*CHANGE modes
      *================================================================
     C     W0PMD         IFNE      'ADD'
     C                   MOVEL     'ADD'         W0PMD
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD
     C                   END
     C                   EXSR      FBRQRL
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   FBRQRL        BEGSR
      *================================================================
      * Request subfile reload
      *================================================================
     C                   MOVEL     'Y'           W0RSF
      *================================================================
     CSR   FBEXIT        ENDSR
      /EJECT
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect keys if change mode or updated record
     C                   SETON                                        88        *
     C   89
     CANN87              SETOFF                                       88        *
     C                   MOVEL     *IN87         *IN78
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     *IN87         *IN77
     C     W0PMD         IFEQ      'CHG'                                        *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
     C                   MOVEL     '0'           *IN79
     C     W0PMD         IFEQ      'ADD'                                        *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise subfile record
      *================================================================
      * Previous values
     C                   MOVEL     *BLANK        #1DBRC
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
     C                   MOVEL     *BLANK        #1JOB
     C                   MOVEL     *BLANK        #1USER
     C                   MOVEL     *BLANK        #1NBR
     C                   MOVEL     *BLANK        #1LIBA
     C                   MOVEL     *BLANK        #1FILA
     C                   MOVEL     *BLANK        #1MBRA
     C                   MOVEL     *BLANK        #1LIBB
     C                   MOVEL     *BLANK        #1FILB
     C                   MOVEL     *BLANK        #1MBRB
     C                   MOVEL     *BLANK        #1INTG
     C                   MOVEL     *BLANK        #1LIBC
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DIREGK fields to subfile
      *================================================================
     C                   MOVEL     JOB           #1JOB
     C                   MOVEL     USER          #1USER
     C                   MOVEL     NBR           #1NBR
     C                   MOVEL     LIBA          #1LIBA
     C                   MOVEL     FILA          #1FILA
     C                   MOVEL     MBRA          #1MBRA
     C                   MOVEL     LIBB          #1LIBB
     C                   MOVEL     FILB          #1FILB
     C                   MOVEL     MBRB          #1MBRB
     C                   MOVEL     INTG          #1INTG
     C                   MOVEL     LIBC          #1LIBC
      * Hold current record image for change detection
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2JOB
     C                   MOVEL     *BLANK        #2USER
     C                   MOVEL     *BLANK        #2FILA
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   PRINTR        BEGSR
      *================================================================
      * Load subfile page (write empty page if add mode)
      *================================================================
      * Re-establish fields in read-ahead record
     C     KEY1          KLIST
     C                   KFLD                    WAJOB
     C                   KFLD                    WAUSER
     C                   KFLD                    WANBR
     C                   MOVEL     *BLANKS       WAJOB
     C                   MOVEL     *BLANKS       WAUSER
     C                   MOVEL     *BLANKS       WANBR
     C     KEY1          SETLL     UPJOBEL1                               90
     C                   READ      UPJOBEL1                               90
     C                   OPEN      UP000030P1
     C                   WRITE     HEADP1
      *................................................................
      * Load next subfile page
     C     *IN90         DOWLE     *OFF
     C     *IN15         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   MOVE      *OFF          *IN15
     C                   ENDIF
     C                   WRITE     DETAIL
     C                   READ      UPJOBEL1                               90
     C                   ENDDO
     C                   WRITE     TRAILP1
     C                   CLOSE     UP000030P1
      *================================================================
     CSR   PREXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Does record exist ? - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    JOB           WQSA01
     C     *LIKE         DEFINE    USER          WQSA02
     C     *LIKE         DEFINE    NBR           WQSA03
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    WQSA01
     C                   KFLD                    WQSA02
     C                   KFLD                    WQSA03
      * Move fields to key list
     C                   MOVEL     #1JOB         WQSA01
     C                   MOVEL     #1USER        WQSA02
     C                   MOVEL     #1NBR         WQSA03
     C     KRSSA         SETLL     UPJOBEL0                                     *
     C     KRSSA         READE     UPJOBEL0                               90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0499'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
     C                   MOVEL     '0'           Y0CX01            1
     C     #1JOB         IFEQ      JOB                                          *IF
     C     #1USER        IFEQ      USER                                         *IF
     C     #1NBR         IFEQ      NBR                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C     KRSSA         READE     UPJOBEL0                               90    *
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Does record exist ? - Dependency Relations  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Declare restrictor key work fields
     C     *LIKE         DEFINE    JOB           WQJOB
     C     *LIKE         DEFINE    USER          WQUSER
     C     *LIKE         DEFINE    NBR           WQNBR
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    WQJOB
     C                   KFLD                    WQUSER
     C                   KFLD                    WQNBR
      * Move fields to key list
     C                   MOVEL     #1JOB         WQJOB
     C                   MOVEL     #1USER        WQUSER
     C                   MOVEL     #1NBR         WQNBR
     C     KRSSB         SETLL     UPJOBEL0                                     *
     C     KRSSB         READE     UPJOBEL0                               90    *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR0499'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process Data record
      * CASE:
     C                   MOVEL     '0'           Y0CX01            1
     C     #1JOB         IFEQ      JOB                                          *IF
     C     #1USER        IFEQ      USER                                         *IF
     C     #1NBR         IFEQ      NBR                                          *IF
     C                   MOVEL     '1'           Y0CX01
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C     Y0CX01        IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
     C                   END                                                    *FI
     C     KRSSB         READE     UPJOBEL0                               90    *
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Clear all neither parameters
     C                   MOVEL     *BLANK        WN0001            1
     C                   Z-ADD     *ZERO         WN0002            1 0
     C                   Z-ADD     *ZERO         WN0003            2 0
     C                   Z-ADD     *ZERO         WN0004           11 0
     C                   MOVEL     *BLANK        WN0005            1
     C                   MOVEL     *BLANK        WN0006           60
     C                   MOVEL     *BLANK        WN0007          100
     C                   MOVEL     *BLANK        WN0008            1
     C                   MOVEL     *BLANK        WN0009            2
     C                   MOVEL     *BLANK        WN0010            1
     C                   MOVEL     *BLANK        WN0011            1
     C                   Z-ADD     *ZERO         WN0012            5 0
     C                   MOVEL     *BLANK        WN0013            1
     C                   MOVEL     *BLANK        WN0014            2
     C                   Z-ADD     *ZERO         WN0015            5 0
     C                   Z-ADD     *ZERO         WN0016            6 0
     C                   Z-ADD     *ZERO         WN0017            5 0
     C                   Z-ADD     *ZERO         WN0018            6 0
     C                   MOVEL     *BLANK        WN0019            1
     C                   MOVEL     *BLANK        WN0020            1
     C                   MOVEL     *BLANK        WN0021            1
     C                   Z-ADD     *ZERO         WN0022            6 0
     C                   Z-ADD     *ZERO         WN0023            6 0
     C                   Z-ADD     *ZERO         WN0024            6 0
     C                   Z-ADD     *ZERO         WN0025            6 0
     C                   Z-ADD     *ZERO         WN0026            6 0
     C                   Z-ADD     *ZERO         WN0027            6 0
     C                   Z-ADD     *ZERO         WN0028            6 0
     C                   Z-ADD     *ZERO         WN0029            6 0
     C                   MOVEL     *BLANK        WN0030            1
     C                   MOVEL     *BLANK        WN0031            8
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YARDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     #1JOB         WAJOB
     C                   MOVEL     #1USER        WAUSER
     C                   MOVEL     #1NBR         WANBR
      *
     C     KLCHSC        KLIST
     C                   KFLD                    WAJOB
     C                   KFLD                    WAUSER
     C                   KFLD                    WANBR
     C     KLCHSC        CHAIN     UPJOBED1                           9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'UTMSGF '     ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QCBCM1        YARDCS
      *
      * Set PGM.*Record Data Changed flag
     C     QCBCM1        IFNE      YARDCS
     C                   MOVE      'Y'           YARDC
     C                   END
      * If changed update record otherwise release record
     C     YARDC         IFEQ      'Y'
     C                   UPDATE    UPJOBED1                             91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    UPJOBEL1                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change for Dep-Relations - Components  *
      *================================================================
      * Clear all neither parameters
     C                   MOVEL     *BLANK        WN0032            1
     C                   Z-ADD     *ZERO         WN0033            1 0
     C                   Z-ADD     *ZERO         WN0034            2 0
     C                   Z-ADD     *ZERO         WN0035           11 0
     C                   MOVEL     *BLANK        WN0036            1
     C                   MOVEL     *BLANK        WN0037           60
     C                   MOVEL     *BLANK        WN0038          100
     C                   MOVEL     *BLANK        WN0039            1
     C                   MOVEL     *BLANK        WN0040            2
     C                   MOVEL     *BLANK        WN0041            1
     C                   MOVEL     *BLANK        WN0042            1
     C                   Z-ADD     *ZERO         WN0043            5 0
     C                   MOVEL     *BLANK        WN0044            1
     C                   MOVEL     *BLANK        WN0045            2
     C                   Z-ADD     *ZERO         WN0046            5 0
     C                   Z-ADD     *ZERO         WN0047            6 0
     C                   Z-ADD     *ZERO         WN0048            5 0
     C                   Z-ADD     *ZERO         WN0049            6 0
     C                   MOVEL     *BLANK        WN0050            1
     C                   MOVEL     *BLANK        WN0051            1
     C                   MOVEL     *BLANK        WN0052            1
     C                   Z-ADD     *ZERO         WN0053            6 0
     C                   Z-ADD     *ZERO         WN0054            6 0
     C                   Z-ADD     *ZERO         WN0055            6 0
     C                   Z-ADD     *ZERO         WN0056            6 0
     C                   Z-ADD     *ZERO         WN0057            6 0
     C                   Z-ADD     *ZERO         WN0058            6 0
     C                   Z-ADD     *ZERO         WN0059            6 0
     C                   Z-ADD     *ZERO         WN0060            6 0
     C                   MOVEL     *BLANK        WN0061            1
     C                   MOVEL     *BLANK        WN0062            8
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Set PGM.*Record Data Changed flag
     C                   MOVE      'N'           YBRDC             1
      *
      * Move key fields to @DHREGG
     C                   MOVEL     JOB           WAJOB
     C                   MOVEL     USER          WAUSER
     C                   MOVEL     NBR           WANBR
      *
     C     KLCHSF        KLIST
     C                   KFLD                    WAJOB
     C                   KFLD                    WAUSER
     C                   KFLD                    WANBR
     C     KLCHSF        CHAIN     UPJOBED0                           9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'UTMSGF '     ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Store record data for null update check
     C                   MOVE      QCBCM1        YBRDCS
      *
      * Set PGM.*Record Data Changed flag
     C     QCBCM1        IFNE      YBRDCS
     C                   MOVE      'Y'           YBRDC
     C                   END
      * If changed update record otherwise release record
     C     YBRDC         IFEQ      'Y'
     C                   UPDATE    UPJOBED1                             91      *
     C                   ELSE
      * Release record lock
     C                   UNLOCK    UPJOBEL1                             91      *
     C                   END
     C     *IN91         IFEQ      '1'
      * Change error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      * DBF change successful
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
     CSR   Y0EXIT        ENDSR
      /EJECT
     CSR   Y8TST         BEGSR
      *================================================================
      * Test cursor
      *================================================================
     C                   Z-ADD     @#RWCL        ZINPOS            5 0
     C     ZINPOS        DIV       256           W0CRW
     C                   MVR                     W0CCL
      *================================================================
     CSR   Y8EXIT        ENDSR
      /EJECT
     CSR   Y9CLR         BEGSR
      *================================================================
      * Clear *SET CURSOR data
      *================================================================
     CSR   Y9EXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue
      *================================================================
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
      * If no message file specified, use default
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
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text
      *================================================================
      * Signal help request
     C                   MOVEL     'Y'           W0HLP             1
      *
      * Extract cursor row and column
     C     @#RWCL        DIV       256           ZHCSRW            5 0          Row
     C                   MVR                     ZHCSCL            5 0          Column
      *
      * Save cursor position for redisplay
     C                   Z-ADD     ZHCSRW        ZZCSRW            3 0          Row
     C                   Z-ADD     ZHCSCL        ZZCSCL            3 0          Column
      *
      *
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Help text sourc
     C                   PARM      *BLANK        YYHPFL           10            Help text file
     C                   PARM      *BLANK        YYHPLB           10            Help text libra
     C                   PARM                    W0RTN             7
     C                   PARM      '*START'      YYHLVN           10            Help label
     C                   PARM      '*NORMAL'     YYUSOP           10            Options
     C                   PARM      ZHCSRW        YYRW              5 0          Row
     C                   PARM      ZHCSCL        YYCL              5 0          Column
     C                   PARM      *ZERO         YYLGCT            5 0          # of grps
     C                   PARM      *BLANK        YYLGVN           10            Label grps
      *
      * Clear set cursor DDS indicator
     C  N94              MOVEL     'OFF'         WCSRLC
     C  N94              SETON                                        94        *
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
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
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUJ8ST            1
      * Define work field Err Code
     C                   MOVEL     *BLANK        WUERCD            1
      * Define work field Comp depends on numeric
     C                   Z-ADD     *ZERO         WUWRUN            3 0
      * Define work field Comp Depends-on Unique No
     C                   MOVEL     *BLANK        WUDRUN            3
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUAANA            7
      * Define work field run day number
     C                   Z-ADD     *ZERO         WUAKTX            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUAUST            1
      * Define work field date format flag
     C                   MOVEL     *BLANK        WUE3ST            1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUF1ST            1
      * Flag no *SET CURSOR in the program
     C                   MOVE      'N'           YSETCS            1
     C                   MOVE      *BLANK        WCSRLC            3
      * Define *Synon program work fields
     C                   MOVEL     *BLANKS       W0CFL            10            *Cursor field
     C                   Z-ADD     *ZEROS        W0CRW             5 0          *Cursor row
     C                   Z-ADD     *ZEROS        W0CCL             5 0          *Cursor column
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   MOVEL     'N'           W0PMT             1
      *
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     10000         W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
      * Set to *CHANGE mode
     C                   MOVEL     'CHG'         W0PMD             3
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C                   SETON                                        U7U8
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA AENA
Press HELP for options       F3=Main Menu  F5=Refresh  F11=Print Report
**CTDATA CMD
DSPSPLF FILE(COMPARE) JOB(                            )
STRSEU SRCFILE(                      ) SRCMBR(          ) OPTION(2)
?CPYSRCF FROMFILE(                     ) TOFILE(                     )
FROMMBR(          ) TOMBR(          )
