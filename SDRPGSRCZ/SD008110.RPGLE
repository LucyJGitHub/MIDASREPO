     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Accounts Stamp Tax details Sub File')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008110 - Stamp Tax Account Defaults                        *
      *                                                               *
      *  (c) Copyright Finastra International Limited 2010            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
     FSD008110DFCF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(SRFILE)
      ** DSP: Display Clearing Transaction code
 
     FSDSTPDL2  IF   E           K DISK    USROPN
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      ** RTV : Direct Debit mandates   By Retail Number
 
     FSDSTPDL0  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      ** UPD : Direct Debit mandates     Retrieval index
 
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
 
     D CMD@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array of QCMDEXC commands
 
     D EDT             S              1    DIM(80)
      ** Array of QCMDEXC command to edit
 
     D @STK            S             10    DIM(100)
     D @REC            S              3  0 DIM(100)
      ** Subroutine stack
 
     D DSPGM         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
     D ERDTA         E DS                  EXTNAME(CGERDTA)
      ** Send message data structure
 
     D M#DTA           DS           256
      **  Message Data - Action field
 
     D  #MSGTX                 1     80
 
     D  ##MSGD                81    256
 
      /EJECT
 
      ** Data structures:
     D JBDTTM          DS
      ** Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D ##DATE          DS
      ** DATE in DDMMYY format
     D  ##DD                   1      2
     D  ##MM                   3      4
     D  ##YY                   5      6
     D #DATE           DS
      ** DATE in MMCCYY format
     D  #MM                    1      2
     D  #CC                    3      4
     D  #YY                    5      6
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      ** Display file information data structure
 
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      ** File information data structure
 
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      ** Get Rundate - Rundate  *
 
     D MMODDS        E DS                  EXTNAME(SDMMODPD)
      ** Modules Data Structure *
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data Structures used by Access Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data Structures used by Access Programs
 
      /EJECT
      ** Parameter declarations
     D P1PARM          DS
      ** I : MAP Action Code
     D  P1ACTC                 1      1
     D P2PARM          DS           100
      ** KEY: Direct Debit mandates     Retrieval index
      ** I : MAP Structure Type
     D  P2KEY                  1     10
     D  P2BRCA                11     13
     D  P2CUST                14     19
     D  P2CTRY                20     21
     D  P2ACCD                22     31
     D  P2DTYP                32     33
     D  P2DSTP                34     35
     D  P2LTYP                36     37
     D  P2LSTP                38     39
     D  P2FTYP                40     42
     D  P2LFTP                43     44
     D O2PARM          DS           100
      ** KEY: Direct Debit mandates     Retrieval index
      ** I : MAP Structure Type
 
     D  O2KEY                  1     10
     D  O2BRCA                11     13
     D  O2CUST                14     19
     D  O2CTRY                20     21
     D  O2ACCD                22     31
     D  O2DTYP                32     33
     D  O2DSTP                34     35
     D  O2LTYP                36     37
     D  O2LSTP                38     39
     D  O2FTYP                40     42
     D  O2LFTP                43     44
     D                 DS
     D  ZAMSDA                 1    132
      ** Message data for 'Invalid Action code (FT1)'
      ** *SFLSEL
 
     D  ZA0001                 1      1
 
     D DSMTR           DS
      ** Define fields for message transalation
 
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
 
     D W0DATA          DS           256
      ** Define data structure used to pass parameters
 
     D  B#BRCA                 1      3
     D  O#ACTD                 4      4
     D  O#CPGM                 5     14
 
      /EJECT
      *****************************************************************
 
      ** Entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ACTC        PARM                    WP0001            1
 
      **  Set up primary reference
 
     C                   MOVEL     P2PARM        W0PREF
 
      ** Initialize
 
     C                   EXSR      ZZINIT
 
     C                   DO        *HIVAL
 
      ** Initialise & load subfile page
 
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Display screen
 
     C                   EXSR      CAEXFM
 
      ** Process response
      ** Cancel & exit program
 
     C   03              CAS                     ZXEXPG
     C   12              CAS                     ZXEXPG
 
      ** HOME: Request subfile reload
 
     C   05              CAS                     FBRQRL
 
      ** Display next SFL page
 
     C   27              CAS                     BBLDSF
 
      ** Process screen input
 
     C                   CAS                     DAPR##
     C                   ENDCS
 
     C                   ENDDO
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialise and load subfile page
      *****************************************************************
     C     BAIZSF        BEGSR
 
      ** Clear subfile
 
     C                   SETON                                        80
     C                   WRITE     #SFLCTL
     C                   SETOFF                                       80
 
      ** Reset no of records in subfile
 
     C                   Z-ADD     *ZERO         ##RRMX            5 081
 
      ** USER: Initialize subfile control
      ** Position DBF file
 
     C     KPOS          KLIST
     C                   KFLD                    A3KEY
     C                   KFLD                    A3ACCD
 
      ** Setup key
 
     C                   MOVEL(p)  'RETAIL'      A3KEY
     C                   MOVEL     #2ACCD        A3ACCD
     C     KPOS          SETLL     @STPDV2
     C                   READ      @STPDV2                              8782
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    #2ACCD        WZACCD
     C                   MOVEL     #2ACCD        WZACCD
     C     *LIKE         DEFINE    #2EDTE        WZEDTE
     C                   MOVEL     #2EDTE        WZEDTE
 
      ** Translate search mask for text field
 
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2EDTE        WQEDTE
     C                   CALL      'QDCXLATE'
 
      ** Length
 
     C                   PARM      6             WQA5N             5 0
     C                   PARM      #2EDTE        WQEDTE
     C                   PARM                    WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
      ** Load subfile page
 
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
 
     C     BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Load subfile page
      *****************************************************************
     C     BBLDSF        BEGSR
 
      ** Re-establish fields in read-ahead record
 
     C   27              DO
     C  N82              READP     @STPDV2                                90
     C  N82              READ      @STPDV2                                90
     C                   ENDDO
 
      ** Setof record error indicators
 
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(34)
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     ##RRMX        ##RR              5 0
 
      ** Reset count of DBF records read
 
     C                   Z-ADD     0             ##RRRD            5 0
 
      ** Set required pages based on *Set Cursor or *Subfile Pages
 
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   ENDIF
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
 
      ** Compute lines required based on pages
 
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   ENDIF
 
      ** Load next SFL page until SFL page full, or
      ** Scan limit reached
 
     C     *IN82         DOWEQ     '0'
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
 
      ** Check selection fields - if fail, read next record
 
     C     #2EDTE        IFNE      *BLANK
 
     C     A3EDTE        IfNE      *ZERO
     C                   CALL      'ZDATE2'
     C                   PARM      A3EDTE        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C                   MOVEL     #DATE         #1EDTE
     C                   ENDIF
 
     C     #2EDTE        CABNE     #1EDTE        BB020
     C
     C                   ENDIF
 
      ** Load SFL fields
 
     C                   EXSR      MBFL#1
 
      ** Allow for possible *Set Cursor processing
 
     C                   ADD       1             ##RR
     C                   EXSR      MC#1FN
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
 
      ** Allow for possible *Set Cursor processing
 
     C                   ADD       1             ##RR
 
      ** USER: Initialize subfile record from DBF record
 
     C                   SUB       1             ##RR
 
      ** DBF record not selected
 
     C     W0RSL         CABNE     'Y'           BB020
 
      ** Output to subfile
 
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81
 
      ** If SFLRCD invalid, note that errors present
 
     C   98
     CANN99              SETON                                        99
     C                   WRITE     #SFLRCD
     C     BB020         TAG
 
      ** Increment scan check count
 
     C                   ADD       1             ##RRRD
     C                   READ      @STPDV2                                82
     C                   ENDDO
 
     C     BB900         TAG
 
      ** If no DBF records found, display error message
 
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
 
      ** Send message '*No data to display'
 
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      ** Save highest SFL record load can continue at end point
 
     C     ##RR          IFGT      ##RRMX
 
      ** Calculate top line
 
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   ENDIF
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   ENDIF
 
      ** If scan limit reached, display error message
 
     C     ##RRRD        IFGE      W0SLM
 
      ** Send message '*Scan limit reached'
 
     C                   MOVEL     'Y2U0017'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   Z-ADD     0             ##RROK
     C                   ENDIF
 
     C     BBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Display screen
      *****************************************************************
     C     CAEXFM        BEGSR
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
 
      ** Reset Action taken
 
     C                   MOVEL     *BLANKS       #ENTER            1
 
      ** Update screen time
 
     C                   TIME                    ##TME
 
      ** PUTOVR unless conditioned fields change
 
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   ENDIF
     C                   MOVE      *IN81         CAIN81            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
 
      ** Maintain subfile position where possible
 
     C     @#SFRC        IFGT      *ZERO
     C                   Z-ADD     @#SFRC        ##SFRC
     C                   ENDIF
 
      ** Update job time
 
     C                   TIME                    ##JTM
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
      ** Reset first message only flag
 
     C                   MOVEL     'Y'           ZAFSMS            1      99
     C                   SETOFF                                         8392
     C     CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process screen input
      *****************************************************************
     C     DAPR##        BEGSR
 
      ** Confirm/update is not deferred
 
     C                   MOVEL     'N'           W0DCF             1
 
      ** CALC: Subfile control function fields
      ** Change of position specified
 
     C     WZACCD        CASNE     #2ACCD        FBRQRL
     C     WZEDTE        CASNE     #2EDTE        FBRQRL
     C                   ENDCS
 
      ** USER: Process subfile control (Pre-confirm)
      ** Reload subfile requested
 
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
 
      ** Process subfile records
 
     C                   EXSR      DBPRSF
     C                   ENDIF
 
      ** USER: Final processing (Pre-confirm)
      ** If error, quit processing
 
     C     *IN99         CABEQ     '1'           DAEXIT
 
      ** Defer confirm/update requested
 
     C     W0DCF         CABEQ     'Y'           DAEXIT
 
      ** CASE: CTL.*CMD key is CF09
      ** Call add processing
 
     C     *IN09         IFEQ      '1'
 
      ** Action taken
 
     C                   MOVEL     'Y'           #ENTER
 
      ** Check user has access to add
 
     C                   MOVEL     'I'           #1SEL
 
      ** User does not have access
 
     C     *IN99         IFEQ      '1'
     C                   GOTO      DAEXIT
     C                   ENDIF
 
      ** Set up parameters
 
     C                   CLEAR                   O2PARM
 
     C                   CALL      'SD008111'                           9090
     C                   PARM                    P0RTN             7
     C                   PARM      'I'           WACT01            1
     C                   PARM                    O2PARM
 
      ** Option ended in error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR9951'     P0RTN
     C                   ENDIF
 
      ** Depending on return code - exit or re-display screen
 
     C                   SELECT
 
      ** F12 pressed - redisplay subfile
 
     C     P0RTN         WHENEQ    'USR0790'
     C                   MOVEL     *BLANKS       P0RTN
     C                   MOVEL     'Y'           W0RSF
 
     C                   GOTO      DAEXIT
 
      ** F3 pressed - exit program
 
     C     P0RTN         WHENEQ    'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   EXSR      ZYEXPG
 
      ** If error redisplay
 
     C     P0RTN         WHENNE    *BLANKS
 
      ** Re-display screen
 
     C                   MOVEL     'USR9951'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DAEXIT
 
      ** New selection - redisplay subfile
 
     C     P0RTN         WHENEQ    *BLANKS
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DAEXIT
     C                   ENDSL
     C                   ENDIF
 
      ** USER: Process command keys
      ** If no Action taken and F12 and not select exit
 
     C     #ENTER        IFEQ      *BLANKS
     C     *IN78         ANDEQ     '1'
     C                   MOVEL     *BLANKS       P0RTN
     C                   EXSR      ZXEXPG
     C                   ENDIF
 
     C     DAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process modified subfile record
      *****************************************************************
     C     DBPRSF        BEGSR
 
      ** Read first changed slf record
 
     C                   READC     #SFLRCD                                92
     C     *IN92         DOWEQ     '0'
 
      ** Action taken
 
     C                   MOVEL     'Y'           #ENTER
 
      ** Process subfile record
 
     C                   EXSR      DCPRSR
     C                   UPDATE    #SFLRCD
 
      ** If F12 then redisplay screen with action code
      ** Or action did not complete
 
     C     P0RTN         IFNE      *BLANKS
     C                   MOVEL     *BLANKS       P0RTN
     C                   GOTO      DBEXIT
     C                   ENDIF
 
     C                   READC     #SFLRCD                                92
     C                   ENDDO
 
     C     DBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRACTD - Check Action code                                    *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *****************************************************************
     C     SRACTD        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRACTD'      @STK(Q)
 
      ** Check all valid actions
      ** CASE: RCD.*SFLSEL is not valid
 
     C     #1SEL         IFEQ      ' '
     C                   GOTO      EXACTD
     C                   ENDIF
 
     C                   IF        (P1ACTC = 'E' AND #1SEL <> 'E') OR
     C                             (P1ACTC = 'A' AND (#1SEL <> 'A' AND
     C                             #1SEL <> 'E')) OR
     C                             (#1SEL <> 'E' AND #1SEL <> 'A' AND
     C                             #1SEL <> '1')
 
      ** Setup message data for message
 
     C                   MOVEL     #1SEL         ZA0001
 
      ** Send message 'Invalid Action code'
 
     C                   MOVEL     'USR9952'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835
 
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      EXACTD
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C     EXACTD        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCHG - Record Changed                                       *
      *                                                               *
      * Called by: DCPRSR                                             *
      *                                                               *
      *****************************************************************
     C     SRRCHG        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SRRCHG'      @STK(Q)
 
      ** Set up key from subfile record and chain to record
 
     C     KYMFL0        KLIST
     C                   KFLD                    #1KEY
     C                   KFLD                    #1BRCA
     C                   KFLD                    #1CUST
     C                   KFLD                    #1CTRY
     C                   KFLD                    #1ACCD
     C                   KFLD                    #1DTYP
     C                   KFLD                    #1DSTP
     C                   KFLD                    #1LTYP
     C                   KFLD                    #1LSTP
     C                   KFLD                    #1FTYP
     C                   KFLD                    #1LFTP
 
      ** Chain for new information
 
     C     KYMFL0        CHAIN     @STPDV0                            90
 
      ** Record not found - database error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'SDSTPDL0'    W0FILE
     C                   MOVEL     #1KEY         W0KEY
     C                   Z-ADD     1             W0ERNB
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C     #1SEL         IFNE      *BLANKS
     C                   GOTO      EXRCHG
     C                   ENDIF
 
      ** Reload subfile record
 
     C                   EXSR      MBFL#1
     C                   EXSR      MC#1FN
 
      ** Unwind subroutine stack name
 
     C     EXRCHG        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Process subfile record
      *****************************************************************
     C     DCPRSR        BEGSR
 
      ** Setof error indicators and SFLNXTCHG
 
     C                   MOVEA     WKIND0        *IN(35)
     C                   SETOFF                                       98
     C                   EXSR      MC#1FN
 
      ** USER: Process subfile record (Pre-confirm)
      ** Check action code is valid, if invalid exit.
 
     C                   EXSR      SRACTD
 
      ** Check record is active
 
     C                   EXSR      SRRCHG
 
     C     *IN98         IFEQ      '1'
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCENDT
     C                   ENDIF
 
      ** Call option
 
     C                   SELECT
 
      ** Amend, Delete and Enquire
 
     C     #1SEL         WHENEQ    'A'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'E'
 
      ** Set up parameters
 
     C                   CLEAR                   O2PARM
     C                   MOVEL     #1KEY         O2KEY
     C                   MOVEL     #1BRCA        O2BRCA
     C                   MOVEL     #1CUST        O2CUST
     C                   MOVEL     #1CTRY        O2CTRY
     C                   MOVEL     #1ACCD        O2ACCD
     C                   MOVEL     #1DTYP        O2DTYP
     C                   MOVEL     #1DSTP        O2DSTP
     C                   MOVEL     #1LTYP        O2LTYP
     C                   MOVEL     #1LSTP        O2LSTP
     C                   MOVEL     #1FTYP        O2FTYP
     C                   MOVEL     #1LFTP        O2LFTP
 
     C                   CALL      'SD008111'                           9090
     C                   PARM                    P0RTN             7
     C                   PARM      #1SEL         WACT01            1
     C                   PARM                    O2PARM
 
      ** If in error set up return code
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR9951'     P0RTN
     C                   ENDIF
 
      ** Select
 
     C     #1SEL         WHENEQ    '1'
     C                   MOVEL     #1KEY         P2KEY
     C                   MOVEL     #1BRCA        P2BRCA
     C                   MOVEL     #1CUST        P2CUST
     C                   MOVEL     #1CTRY        P2CTRY
     C                   MOVEL     #1ACCD        P2ACCD
     C                   MOVEL     #1DTYP        P2DTYP
     C                   MOVEL     #1DSTP        P2DSTP
     C                   MOVEL     #1LTYP        P2LTYP
     C                   MOVEL     #1LSTP        P2LSTP
     C                   MOVEL     #1FTYP        P2FTYP
     C                   MOVEL     #1LFTP        P2LFTP
     C                   MOVEL     *BLANKS       P0RTN
     C                   EXSR      ZXEXPG
 
     C                   ENDSL
 
      ** Option ended in error
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR9951'     P0RTN
     C                   ENDIF
 
      ** Depending on return code - exit or re-display screen
 
     C                   SELECT
 
      ** F12 pressed - redisplay subfile
 
     C     P0RTN         WHENEQ    'USR0790'
 
      ** Send message 'F12 taken from previous screen'
 
     C                   MOVEL     'USR9967'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCENDT
 
      ** F3 pressed - exit program
 
     C     P0RTN         WHENEQ    'Y2U9999'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   EXSR      ZYEXPG
 
      ** If error redisplay
 
     C     P0RTN         WHENNE    *BLANKS
 
      ** Re-display screen
 
     C                   MOVEL     'USR9951'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835
     C                   MOVEL     'Y'           W0DCF
     C                   GOTO      DCENDT
 
      ** Function completed normally
 
     C     P0RTN         WHENEQ    *BLANKS
     C                   ENDSL
 
     C     DCENDT        TAG
     C     *IN98         IFEQ      '1'
 
     C  N99              Z-ADD     ##RR          ##SFRC               99
 
     C                   SETON                                        84
     C                   ELSE
 
     C                   SETOFF                                       84
     C                   MOVEL     *BLANK        #1SEL
     C                   ENDIF
 
      ** If option did not end in error, F12 or F3 then update record
      ** with changes
 
     C     P0RTN         IFEQ      *BLANKS
     C     *IN98         ANDEQ     '0'
     C                   EXSR      SRRCHG
     C                   ENDIF
 
     C     DCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Request subfile reload
      *****************************************************************
     C     FBRQRL        BEGSR
     C                   MOVEL     'Y'           W0RSF
     C                   IF        *IN05 = *ON
     C                   MOVEL     *BLANKS       #2ACCD
     C                   MOVEL     *BLANKS       #2EDTE
     C                   MOVEL     *BLANKS       #1SEL
     C                   MOVEL     *OFF          *IN35
     C                   ENDIF
     C     FBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Move @STPDV2 fields to subfile
      *****************************************************************
     C     MBFL#1        BEGSR
 
     C                   MOVEL     A3KEY         #1KEY
     C                   MOVEL     A3BRCA        #1BRCA
     C                   MOVEL     A3CUST        #1CUST
     C                   MOVEL     A3CTRY        #1CTRY
     C                   MOVEL     A3ACCD        #1ACCD
     C                   MOVEL     A3DTYP        #1DTYP
     C                   MOVEL     A3DSTP        #1DSTP
     C                   MOVEL     A3LTYP        #1LTYP
     C                   MOVEL     A3LSTP        #1LSTP
     C                   MOVEL     A3FTYP        #1FTYP
     C                   MOVEL     A3LFTP        #1LFTP
     C                   MOVEL     *BLANKS       #1EDTE
 
      ** Format start date
 
     C     A3EDTE        IFNE      *zero
     C                   CALL      'ZDATE2'
     C                   PARM      A3EDTE        ZDAYNO            5 0
     C                   PARM      WUDFF         ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVE      ZDATE         ##DATE
     C                   MOVE      ##MM          #MM
     C                   MOVE      '20'          #CC
     C                   MOVE      ##YY          #YY
     C                   MOVEL     #DATE         #1EDTE
     C                   Endif
 
     C     A3STRB        IFNE      *ZERO
 
      ** Format amount
 
     C                   MOVE      A3STRB        ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      6             ZADEC             1 0
 
     C                   MOVE      ZFIELD        #1STRB
     C                   ELSE
     C                   MOVEL     *BLANKS       #1STRB
     C                   ENDIF
 
     C     A3STRT        IFNE      *ZERO
 
     C                   MOVE      A3STRT        ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      6             ZADEC             1 0
 
     C                   MOVE      ZFIELD        #1STRT
     C                   ELSE
     C                   MOVEL     *BLANKS       #1STRT
     C                   ENDIF
 
     C     A3STCC        IFNE      *ZERO
 
     C                   MOVE      A3STCC        ZFIELD
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      6             ZADEC             1 0
 
     C                   MOVE      ZFIELD        #1STCC
     C                   ELSE
     C                   MOVEL     *BLANKS       #1STCC
     C                   ENDIF
 
     C                   MOVEL     *BLANKS       #1SEL
 
     C     MBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CALC: Subfile record function fields
      *****************************************************************
     C     MC#1FN        BEGSR
     C     MCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialise subfile control
      *****************************************************************
     C     MEIZ#2        BEGSR
     C                   MOVEL     P1ACTC        #PACTC
     C     P2PARM        IFNE      *BLANKS
     C                   MOVEL     P2ACCD        #2ACCD
     C                   ELSE
     C                   MOVEL     *BLANK        #2ACCD
     C                   MOVEL     *BLANK        #2EDTE
     C                   ENDIF
 
      ** Fill Command lines and narrative text from messages
 
     C                   SELECT
 
      ** Enquiry screen
 
     C     P1ACTC        WHENEQ    'E'
 
      ** Option Name
 
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9953'     #MSGID
     C                   PARM      'SDUSRMSG'    #MSGF
     C                   PARM      'View'        #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##ONAM
 
      ** Action codes
 
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9954'     #MSGID
     C                   PARM      'SDUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##CMD1
 
      ** Function keys
 
     C                   MOVEL     'USR9955'     #UFKEY
 
      ** Update screen
 
     C     P1ACTC        WHENEQ    'A'
 
      ** Option Name
 
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9953'     #MSGID
     C                   PARM      'SDUSRMSG'    #MSGF
     C                   PARM      'Amend'       #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##ONAM
 
      ** Action codes
 
     C                   CALL      'SDC008190'                          9090
     C                   PARM      'USR9957'     #MSGID
     C                   PARM      'SDUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##CMD1
 
      ** Function keys
 
     C     *IN78         IFEQ      '0'
     C                   MOVEL     'USR9959'     #UFKEY
     C                   ELSE
     C                   MOVEL     'USR9958'     #UFKEY
     C                   ENDIF
 
      ** Allow function key 9
 
     C                   MOVEL     '1'           *IN77
 
     C                   ENDSL
 
      ** Function keys
 
     C     *LIKE         DEFINE    #MSGID        #UFKEY
     C                   CALL      'SDC008190'                          9090
     C                   PARM      #UFKEY        #MSGID
     C                   PARM      'SDUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
 
     C                   MOVEL     #MSTX1        ##CMD2
     C     MEEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Send message to program's message queue
      *****************************************************************
     C     ZASNMS        BEGSR
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
 
      ** If no message file specified, use default
 
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   ENDIF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
 
      ** Clear all fields for default mechanism next time
 
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
 
     C     ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Cancel & exit program
      *****************************************************************
     C     ZXEXPG        BEGSR
 
      ** USER: Exit program processing
      ** CASE: CTL.*CMD key is CF03
 
     C     *IN03         IFEQ      '1'
     C                   MOVEL     'Y2U9999'     P0RTN
     C                   ENDIF
 
      ** CASE: CTL.*CMD key is CF12
 
     C     *IN12         IFEQ      '1'
     C                   MOVEL     'USR0790'     P0RTN
     C                   ENDIF
 
     C                   EXSR      ZYEXPG
     C     ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Exit program: Direct
      *****************************************************************
     C     ZYEXPG        BEGSR
 
      ** Copy any undisplayed messages back to caller
 
     C                   CALL      'Y2CPMSC'
     C                   PARM                    ##PGM
 
      ** Exit program
 
     C                   RETURN
 
     C     ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initialisation
      *****************************************************************
     C     ZZINIT        BEGSR
 
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   ENDIF
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
 
      ** Initialise indicators for re-entry
 
     C                   MOVE      '0'           *IN
 
      ** Setup job date/time
 
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
 
      ** Update screen time
 
     C                   TIME                    ##TME             6 0
 
      ** Obtain default message file
 
     C                   MOVEL     'SDUSRMSG'    ZADFMF           10
     C                   Z-ADD     10            ##SFPG            3 0
     C                   Z-ADD     1             ##SFRC
 
      ** Maximum record number
 
     C                   Z-ADD     *ZERO         ##RRMX
 
      ** Scan limit
 
     C                   Z-ADD     500           W0SLM             5 0
 
      ** Subfile pages
 
     C                   Z-ADD     1             W0SPG             3 0
 
      ** Processed Subfile record
 
     C                   Z-ADD     0             W0RR0             4 0
 
     C                   MOVEL     *BLANK        W0GRP             1
     C                   Z-ADD     0             Q                 5 0
     C                   MOVEA     '00'          *IN(77)
 
      ** USER: Initialize program
      ** Retrieve Midas Date - R10 Standard Functions  *
 
     C                   MOVEA     CPY@          ACT@             80
 
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7
     C                   MOVE      AGMRDT        WUMRDT            7
     C                   MOVE      AGRDNB        WURDNB            5 0
     C                   MOVE      AGSUC         WUSUC             1
     C                   MOVE      AGDFF         WUDFF             1
     C                   MOVE      AGMBIN        WUMBIN            1
 
      ** Get modules information
 
     C                   CALL      'AOMMODR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     MMODDS        PARM      *BLANKS       DSFDY
 
      ** If return with an error (LR seton in called program) then
      ** process for database error.
 
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOMMODR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY
     C                   Z-ADD     2             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Open file SDSTPDL2
 
     C     FIL001        IFEQ      *BLANKS
 
      ** Override file SDSTPDL2 to share(*NO)
 
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'SDSTPDL2'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     3             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   OPEN      SDSTPDL2
     C                   MOVEL     'Y'           FIL001            1
     C                   ENDIF
 
      ** Open file SDSTPDL0
 
     C     FIL002        IFEQ      *BLANKS
 
      ** Override file SDSTPDL0 to share(*NO)
 
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEL     'SDSTPDL0'    U#FILE           10
     C                   MOVEA     U#FILE        EDT(17)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     4             W0ERNB
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   OPEN      SDSTPDL0
     C                   MOVEL     'Y'           FIL002            1
     C                   ENDIF
 
      ** Allow function key 12 if lower case action
 
     C                   SELECT
     C     P1ACTC        WHENEQ    'e'
     C     P1ACTC        OREQ      'E'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'E'           P1ACTC
     C     P1ACTC        WHENEQ    'a'
     C     P1ACTC        OREQ      'A'
     C                   MOVEL     '1'           *IN78
     C                   MOVEL     'A'           P1ACTC
     C                   ENDSL
 
      ** Initialise subfile control
 
     C                   EXSR      MEIZ#2
 
     C     ZZEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PSSR Processing
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   ROLBK                                          90
 
      ** If second time through, halt:
 
     C     @@PSSR        IFNE      *BLANK
     C                   SETON                                        H1  LR
     C                   RETURN
     C                   ENDIF
 
      ** Flag routine as started; define action code:
 
     C                   MOVE      'Y'           @@PSSR            1
     C                   MOVE      W0ACT         W0ACT             8
 
      ** Any other mode or type of error.
      ** Set LDA values and format message for MOPERQ:
 
     C                   MOVE      ##PGM         ERPGM
     C                   MOVE      ##RTVN        ERFILE
     C     ##MSID        CAT(P)    ##SQNO        ERKEY
     C                   Z-ADD     998           ERERNB
     C                   MOVEL     ##MSWK        ERNARR
 
      ** Move data to the LDA data area:
 
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
      ** Provide a fuller report:
 
     C                   MOVEA     @STK          #@STK           100
 
     C                   SETON                                        U7U8LR
     C                   MOVE      '*ERROR*'     W0RTN             7
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFILE   : *PSSR routine for all files                       *
      *                                                               *
      *  CALLED BY: IBM controlled - invalid access to file           *
      *                                                               *
      *  CALLS    : CGZERROR                                          *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5002 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     C     SRFILE        BEGSR
 
      ** Dump program
 
     C                   DUMP
     C                   ROLBK                                          90
 
      ** If called again seton LR and return
 
     C     @@FILE        IFNE      *BLANKS
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   ENDIF
 
     C                   MOVEL     'Y'           @@FILE            1
 
      ** Send message to MOPERQ
 
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
 
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
 
     C                   MOVEL     ##ERST        ERKEY
     C                   Z-ADD     999           ERERNB
     C                   MOVEL     ##ERFL        ERFILE
     C                   MOVEL     W0PREF        ERPREF
 
      ** Get message for sending and place in msg field
 
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      'MEM5002'     #MSGID
     C                   PARM      'MIDAS   '    #MSGF
     C                   PARM      *BLANKS       #MSGTX
 
     C                   MOVEL     #MSGTX        ERNARR
 
      ** Send message
 
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV'        #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
 
      ** Fill LDA with error data
 
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
      ** Close down program
 
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
 
      ** Provide a fuller report:
 
     C                   MOVEA     @STK          #@STK           100
 
     C                   RETURN
 
     C     EXFILE        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: All subroutines                                   *
      *                                                               *
      *  CALLS    : CGZERROR                                          *
      *                                                               *
      * In the INIT sub-routine, the fields W0MSGD and W0MSGF should  *
      * be set to the default message I.D and message file that are   *
      * used for the module. If not, the defaults of MEM5001 and MIDAS*
      * will be used.                                                 *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
      ** Define work variables
 
     C     *LIKE         DEFINE    ERKEY         W0KEY
     C     *LIKE         DEFINE    ERERNB        W0ERNB
     C     *LIKE         DEFINE    ERFILE        W0FILE
     C     *LIKE         DEFINE    ERPREF        W0PREF
 
     C     *LIKE         DEFINE    #MSGID        W0MSGD
     C     *LIKE         DEFINE    #MSGF         W0MSGF
 
     C                   Z-ADD     Q             Q                 5 0
 
      ** Dump program
 
     C                   DUMP
     C                   ROLBK                                          90
 
      ** Set up the details of the message to be sent to MOPERQ
 
     C                   MOVEL     *BLANKS       ERDTA
     C                   MOVEL     ##PGM         ERPGM
 
     C     Q             IFGT      1
     C     Q             ANDLT     101
     C                   MOVEL     @STK(Q)       ERSTK
     C                   ELSE
     C                   MOVEL     '*Nostkin'    ERSTK
     C                   ENDIF
 
     C                   MOVEL     W0KEY         ERKEY
     C                   Z-ADD     W0ERNB        ERERNB
     C                   MOVEL     W0FILE        ERFILE
     C                   MOVEL     W0PREF        ERPREF
 
      ** Get message for message code. If the msg code or the msg file
      ** have not been set up then use the defaults.
 
     C     W0MSGD        IFEQ      *BLANKS
     C                   MOVEL     'MEM5001'     C#FMSG            7
     C                   ELSE
     C                   MOVEL     W0MSGD        C#FMSG
     C                   ENDIF
 
     C     W0MSGF        IFEQ      *BLANKS
     C                   MOVEL     'MIDAS   '    C#FMSF           10
     C                   ELSE
     C                   MOVEL     W0MSGF        C#FMSF
     C                   ENDIF
 
     C                   CALL      'SDRTVTXT'                           9090
     C                   PARM      C#FMSG        #MSGID
     C                   PARM      C#FMSF        #MSGF
     C                   PARM      *BLANKS       #MSGTX
 
     C                   MOVEL     #MSGTX        ERNARR
 
      ** Send message
 
     C                   CALL      'AOCREPT'                            9090
     C                   PARM      'MEM5000'     #MSGID            7
     C                   PARM      'MIDAS  '     #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM      ERDTA         #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MOPERQ '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
 
      ** Fill LDA with error data
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     W0KEY         DBKEY
     C                   Z-ADD     W0ERNB        DBASE
     C                   MOVEL     W0FILE        DBFILE
     C                   MOVEL     ##PGM         DBPGM
     C                   OUT       LDA
 
      ** Close down program
 
     C                   SETON                                        U7U8LR
     C                   MOVEL     '*ERROR*'     W0RTN             7
 
      ** Provide a fuller report:
 
     C                   MOVEA     @STK          #@STK           100
 
     C                   RETURN
 
     C     EXERR         ENDSR
      *****************************************************************
      * End of /COPY SRERRC                                           *
      *****************************************************************
**  CPY@
(c) COPYRIGHT Finastra International Limited 2010
** Command Array
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
