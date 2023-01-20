     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058755
/*STD *  RPGSQLBND                                                    *                     MD058755
/*EXI *  TEXT('Midas SD Retail transaction enquiry subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0131D - Midas SD Retail Transact.                          *
      *                                                               *
      *  Function:  This program allows the user to enquire from a    *
      *             list of retail transactions                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058755           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      *                 S01459             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01413             DATE 05JUL93               *
      *                 LN0168             DATE 26JUN90               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  S01413 - RETAIL 3 INCORPORATION. ACCOUNT COMMISSIONS         *
      *           INDICATOR AVAILABLE.                                *
      *  LN0168 - SET SCAN LIMIT TO 99999.                            *
      *                                                               *
      *****************************************************************
     FSD0131D#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
      * DSP: Midas SD Display Retail Transact.
      *
     F*SDRETRL1* IF   E           K DISK                                                    MD058755
     F**********                           INFDS(INFDS1)                                    MD058755
      * RTV : Retail Transaction Types  Retrieval index
      *
     FSDMMODL1  IF   E           K DISK
      * RTV : MIDAS Modules             Retrieval index
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
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
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0002                 1     10
     D SDRETR        E DS                  EXTNAME(SDRTRJW0)                                MD058755
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
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
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    A1RTTY                         Retail Transact
      * Setup key
     C                   MOVEL     #2RTTY        A1RTTY                         Retail Transact
     C*****KPOS*         SETLL     @A1RECX                                                  MD058755
     C**********         READ      @A1RECX                              8782    *82=EOF     MD058755
     C/EXEC SQL                                                                             MD058755
     C+ close ACursor                                                                       MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C/EXEC SQL                                                                             MD058755
     C+ declare ACursor insensitive scroll cursor for                                       MD058755
     C+ select * from SDRTRJW0                                                              MD058755
     C+ where A1RTTY >= :A1RTTY                                                             MD058755
     C+ order by A1RTTY                                                                     MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C/EXEC SQL                                                                             MD058755
     C+ open ACursor                                                                        MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
     C                   setoff                                       82                    MD058755
     C                   If        SQLCODE = 100                                            MD058755
     C                   seton                                        82                    MD058755
     C                   Endif                                                              MD058755
                                                                                            MD058755
      * Save previous selector values
     C     *LIKE         DEFINE    #2LCD         WZLCD
     C                   MOVEL     #2LCD         WZLCD                          Last Change Dat
     C     *LIKE         DEFINE    #2TYLC        WZTYLC
     C                   MOVEL     #2TYLC        WZTYLC                         Type of Last Ch
     C     *LIKE         DEFINE    #2RTTY        WZRTTY
     C                   MOVEL     #2RTTY        WZRTTY                         Retail Transact
     C     *LIKE         DEFINE    #2RTNM        WZRTNM
     C                   MOVEL     #2RTNM        WZRTNM                         Retail Transact
     C     *LIKE         DEFINE    #2COIN        WZCOIN
     C                   MOVEL     #2COIN        WZCOIN                         Customer Origin
     C     *LIKE         DEFINE    #2DCIN        WZDCIN
     C                   MOVEL     #2DCIN        WZDCIN                         Debit/Credit In
     C     *LIKE         DEFINE    #2RVIN        WZRVIN
     C                   MOVEL     #2RVIN        WZRVIN                         Reversal Indica
     C     *LIKE         DEFINE    #2PADI        WZPADI
     C                   MOVEL     #2PADI        WZPADI                         Print Advices I
     C     *LIKE         DEFINE    #2ACOM        WZACOM
     C                   MOVEL     #2ACOM        WZACOM                         Account Commiss
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2RTNM        WQRTNM                         Retail Transact
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2RTNM        WQRTNM                         Retail Transact
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
     C**N82*****         READP     @A1RECX                                90    *           MD058755
     C**N82*****         READ      @A1RECX                                90    *           MD058755
     C                   If        *IN82 = '0'                                              MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch prior from ACursor into :SDRETR                                               MD058755
     C/END-EXEC                                                                             MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
     C                   Endif                                                              MD058755
     C                   END
      *
      * Start at previous highest record in SFL
     C                   Z-ADD     ##RRMX        ##RR              5 0
      * Reset count of DBF records read
     C                   Z-ADD     0             ##RRRD            5 0
      *................................................................
      * Load next SFL page until SFL page full, or
      * Scan limit reached
     C******IN82         DOWEQ     '0'                                          DO          MD058755
     C     SQLCODE       DOWEQ     0                                                        MD058755
     C     ##RROK        ANDLT     ##SFPG
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     A1LCD         CABNE     #2LCD         BB020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C     A1TYLC        CABNE     #2TYLC        BB020                          Type of Last Ch
     C                   END
     C     #2RTNM        IFNE      *BLANK                                       Retail Transact
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    A1RTNM                         Retail Transact
      * Length
     C                   PARM      30            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQRTNM
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
     C     #2COIN        IFNE      *BLANK                                       Customer Origin
     C     A1COIN        CABNE     #2COIN        BB020                          Customer Origin
     C                   END
     C     #2DCIN        IFNE      *BLANK                                       Debit/Credit In
     C     A1DCIN        CABNE     #2DCIN        BB020                          Debit/Credit In
     C                   END
     C     #2RVIN        IFNE      *BLANK                                       Reversal Indica
     C     A1RVIN        CABNE     #2RVIN        BB020                          Reversal Indica
     C                   END
     C     #2PADI        IFNE      *BLANK                                       Print Advices I
     C     A1PADI        CABNE     #2PADI        BB020                          Print Advices I
     C                   END
     C     #2ACOM        IFNE      *BLANK                                       Account Commiss
     C     A1ACOM        CABNE     #2ACOM        BB020                          Account Commiss
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
      * Output to subfile
     C                   ADD       1             ##RR                 81        *
     C                   ADD       1             ##RROK
      * Set screen conditioning indicators
     C                   EXSR      GADSA1
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      * Increment scan check count
     C                   ADD       1             ##RRRD
     C**********         READ      @A1RECX                                82    *82=EOF     MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
      * If no DBF records found, display error message
     C     ##RR          IFEQ      *ZERO
     C******IN82         ANDEQ     '1'                                                      MD058755
     C     SQLCODE       ANDEQ     100                                                      MD058755
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
      * Set screen conditioning indicators
     C                   EXSR      GBDSA2
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
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
      * Validate Customer Originated Ind.
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2COIN        W0NSRQ            1            Customer Origin
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1136213       Y2LSNO            7 0
     C     #2COIN        PARM      #2COIN        W0EXVL           20            Customer Origin
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Debit/Credit Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2DCIN        W0NSRQ            1            Debit/Credit In
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1100774       Y2LSNO            7 0
     C     #2DCIN        PARM      #2DCIN        W0EXVL           20            Debit/Credit In
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Reversal Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2RVIN        W0NSRQ            1            Reversal Indica
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1102174       Y2LSNO            7 0
     C     #2RVIN        PARM      #2RVIN        W0EXVL           20            Reversal Indica
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Print Advices Indicator
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2PADI        W0NSRQ            1            Print Advices I
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1136213       Y2LSNO            7 0
     C     #2PADI        PARM      #2PADI        W0EXVL           20            Print Advices I
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Validate Account Commission Ind
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2ACOM        W0NSRQ            1            Account Commiss
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1170044       Y2LSNO            7 0
     C     #2ACOM        PARM      #2ACOM        W0EXVL           20            Account Commiss
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Change of position specified
     C     WZRTTY        CASNE     #2RTTY        FBRQRL
     C     WZRTNM        CASNE     #2RTNM        FBRQRL
     C     WZCOIN        CASNE     #2COIN        FBRQRL
     C     WZDCIN        CASNE     #2DCIN        FBRQRL
     C     WZRVIN        CASNE     #2RVIN        FBRQRL
     C     WZPADI        CASNE     #2PADI        FBRQRL
     C     WZACOM        CASNE     #2ACOM        FBRQRL
     C                   END
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      *================================================================
     CSR   DAEXIT        ENDSR
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
     C                   MOVEL     '0'           *IN77
     C     WUCRIN        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN76
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C                   MOVEL     '0'           *IN79
     C     WUCRIN        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A1RECX fields to subfile
      *================================================================
     C                   Z-ADD     A1LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A1TYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     A1RTTY        #1RTTY                         Retail Transact
     C                   MOVEL     A1RTNM        #1RTNM                         Retail Transact
     C                   MOVEL     A1COIN        #1COIN                         Customer Origin
     C                   MOVEL     A1DCIN        #1DCIN                         Debit/Credit In
     C                   MOVEL     A1RVIN        #1RVIN                         Reversal Indica
     C                   MOVEL     A1PADI        #1PADI                         Print Advices I
     C                   MOVEL     A1ACOM        #1ACOM                         Account Commiss
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   Z-ADD     *ZERO         #2LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #2TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #2RTTY                         Retail Transact
     C                   MOVEL     *BLANK        #2RTNM                         Retail Transact
     C                   MOVEL     *BLANK        #2COIN                         Customer Origin
     C                   MOVEL     *BLANK        #2DCIN                         Debit/Credit In
     C                   MOVEL     *BLANK        #2RVIN                         Reversal Indica
     C                   MOVEL     *BLANK        #2PADI                         Print Advices I
     C                   MOVEL     *BLANK        #2ACOM                         Account Commiss
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Get Retail Indicator - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSA         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KPSSA         SETLL     @BGREC8                                      *
     C                   READ      @BGREC8                                90    *
     C     *IN90         IFEQ      '1'
      * DBF record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0001                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SAEXIT                                       *QUIT
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process DBF record
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BGRTBN        WUCRIN                         Retail Banking
     C                   READ      @BGREC8                                90    *
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Get Retail 3/IOA indic - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KPSSB         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KPSSB         SETLL     @BGREC8                                      *
     C                   READ      @BGREC8                                90    *
     C     *IN90         IFEQ      '1'
      * DBF record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0002                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      SBEXIT                                       *QUIT
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN90         DOWEQ     '0'
      * USER: Process DBF record
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BGNXST        WUNXST                         Retail 3
     C                   MOVEL     BGNYST        WUNYST                         Interest on Acc
     C                   READ      @BGREC8                                90    *
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
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
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel & exit program
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD058755
     C+ close ACursor                                                                       MD058755
     C/END-EXEC                                                                             MD058755
                                                                                            MD058755
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
      * Define work field Check Retail Indicator
     C                   MOVEL     *BLANK        WUCRIN            1
      * Define work field Account Comm. Ind.display
     C                   MOVEL     *BLANK        WUACID            1
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
      * Define work field Interest on Accounts 3
     C                   MOVEL     *BLANK        WUNYST            1
      * Define work field Commission on Debit Turn
     C                   MOVEL     *BLANK        WUCODT            1
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialise program
      * Last Amend Box SD0131D - Retail Transaction Types  *
      * Standard RPG Creation PAR - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement - Standard Functions  * copyright
      * Get Retail Indicator - MIDAS Modules  *
     C                   EXSR      SARVGN
      * start S01413
      * Get Retail 3/IOA indic - MIDAS Modules  *
     C                   EXSR      SBRVGN
      * Get Comm on Debit Turnovr - Retail Details  *
     C                   CALL      'SD9342'                             90      Get Comm on Deb
     C     W0RTN         PARM      W0RTN         WQ0001            7            *Return code
     C     WUCODT        PARM      *BLANK        WQ0002            1            Commission on D
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   MOVEL     'N'           WUACID                         Account Comm. I
      * CASE: WRK.Retail 3 is Yes
     C     WUNXST        IFEQ      'Y'                                          *IF
      * CASE: WRK.Commission on Debit Turn is Yes
     C     WUCODT        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUACID                         Account Comm. I
     C                   END                                                    *FI
     C                   END                                                    *FI
      * end S01413
      * Start of Fix LN0168
     C                   Z-ADD     99999         W0SLM                          *Scan limit
      * End of Fix LN0168
      * Initialise subfile control
     C                   EXSR      MEIZ#2
      *================================================================
     CSR   ZZEXIT        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
