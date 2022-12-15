     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058755
/*STD *  RPGSQLBND                                                    *                     MD058755
/*EXI *  TEXT('Midas SD Retail transaction types selection')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0130D - Retail Transaction Types Selection Subfile.        *
      *                                                               *
      *  Function:  This program allows the user to selectively       *
      *             enquire, amend, insert and delete retail          *
      *             transaction types.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD058755           Date 01Sep21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR657098           Date 12Jun13               *
      *                 256648A            Date 25Nov08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 255435             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT001             Date 07MAR95               *
      *                 S01486             DATE 24JUN94               *
      *                 S01413             DATE 14APR94               *
      *                 S01459             DATE 14APR94               *
      *                 LN0168             DATE 26JUN90               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058755 - Deliverable Data Split for SDRETRPD and TABLETZ   *
      *  MD046248 - Finastra Rebranding                               *
      *  AR657098 - SD: Transaction Types Enquiry does not search by  *
      *             Name in English characters.                       *
      *             Move value of A1RTNM to OUT2 when #2RTNM is       *
      *             alphanumeric.                                     *
      *  256648A- Cyrillic narrative is not recognized by the system  *
      *  255435 - Recompiled due to changes in DSPF/SD0130D#.         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  CRT001 - Retail Teller System development:                   *
      *           Recompiled due to changed SDRETRPD.                 *
      *  S01486 - Recompiled due to changed SDRETRPD, added           *
      *           Fast Exit Processing and /Copys.                    *
      *  S01413 - Retail 3 incorporation:- Account Commissions        *
      *           Indicator available.                                *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *  LN0168 - Set scan limit to 99999.                            *
      *                                                               *
      *****************************************************************
     F*Retail Transactions mnt  Initialise Program F-Spec
     F/COPY WNCPYSRC,SD0130DFPG
     FSD0130D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Retail transaction types selection
      *
     F*SDRETRL1* IF   E           K DISK    USROPN                                          MD058755
     F**********                           INFDS(INFDS1)                                    MD058755
     F**********                           INFSR(*PSSR)                                     MD058755
      * RTV : Midas SD Retail transaction types retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*Retail Transactions mnt  Initialise Program E-Spec
     D/COPY WNCPYSRC,SD0130DEPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*Retail Transactions mnt  Initialise Program I-Spec
     D/COPY WNCPYSRC,SD0130DIPG
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
      * ABO DEFINE LARGE STRING FOR CL CMD
     D YARTCM          DS           512
     D  DUMMY1                 1      1
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file information data structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D SDRETR        E DS                  EXTNAME(SDRTRJW0)                                MD058755
      * Outward parameters
     D PARC            DS             5
      * KEY : Midas SD Retail transaction types retrieval
      * I : MAP Retail Transaction Type
     D  PARTTY                 1      5
      *
      * Outward parameters
     D PBRC            DS             5
      * KEY : Midas SD Retail transaction types retrieval
      * I : MAP Retail Transaction Type
     D  PBRTTY                 1      5
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
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D ID0001          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I :  Display file mode
     D  P1DFMD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0001                 1      1
      * Message data for 'value for field not valid'
      * *SFLSEL
     D  ZA0002                 1      1
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0003                 1     10
      ** Data area for QLGCNVCS API                                                          256648A
      *                                                                                      256648A
     D RBLOCK          DS                                                                          2
     D  REQTY                  1      4B 0 INZ(1)                                                  2
     D  CCSID                  5      8B 0 INZ(0)                                                  2
     D  CASET                  9     12B 0 INZ(0)                                                  2
     D  RSVED1                13     17    INZ(X'0000000000')                                      2
     D  RSVED2                18     22    INZ(X'0000000000')                                      2
     D OTHPAR          DS                                                                          2
     D  LENGTH                 1      4B 0 INZ(30)                                                 2
     D  ERRCOD                 5      8B 0 INZ(0)                                                  2
      *                                                                                      256648A
     D ALPHAN          C                   CONST('AaBbCcDdEeFfGgHhIiJj-                            2
     D                                     KkLlMmNnOoPpQqRrSsTt-                                   2
     D                                     UuVvWwXxYyZz 0123456-                                   2
     D                                     789')                                                   2
      *                                                                                      256648A
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1DFMD        PARM                    WP0001            1            Display file mo
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
      * 00/Copy member SD0130DISC - Retail Transaction Types  *
     C*Retail Transactions mnt  Initialise Subf Control
     C/COPY WNCPYSRC,SD0130DISC
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
      * Check for Valid Alphanumeric Characters, if invalid use QLGCNVCS                     256648A
      * to convert Narrative to upper-case.                                                  256648A
     C     ALPHAN        CHECK     #2RTNM                                 50
     C     *IN50         IFEQ      *OFF
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      30            WQA5N             5 0
     C                   PARM      #2RTNM        WQRTNM                         Retail Transact
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
     C                   ELSE
     C                   CALL      'QLGCNVCS'
     C                   PARM                    RBLOCK
     C                   PARM                    #2RTNM
     C                   PARM                    WQRTNM
     C                   PARM                    LENGTH
     C                   PARM                    ERRCOD
     C                   ENDIF
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
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(38)
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
     C******IN82         DOWEQ     '0'                                          DO          MD058755
     C     SQLCODE       DOWEQ     0                                                        MD058755
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      * Check selection fields - if fail, read next record
     C     #2LCD         IFNE      *ZERO                                        Last Change Dat
     C     A1LCD         CABNE     #2LCD         BB020                          Last Change Dat
     C                   END
     C     #2TYLC        IFNE      *BLANK                                       Type of Last Ch
     C     A1TYLC        CABNE     #2TYLC        BB020                          Type of Last Ch
     C                   END
     C     #2RTNM        IFNE      *BLANK                                       Retail Transact
      * Check for Valid Alphanumeric Characters, if invalid use QLGCNVCS                     256648A
      * to convert narrative field to upper-case                                             256648A
     C     *LIKE         DEFINE    A1RTNM        OUT2
     C     ALPHAN        CHECK     #2RTNM                                 50
     C     *IN50         IFEQ      *ON
     C                   CALL      'QLGCNVCS'
     C                   PARM                    RBLOCK
     C                   PARM                    A1RTNM
     C                   PARM                    OUT2
     C                   PARM                    LENGTH
     C                   PARM                    ERRCOD
     C                   ELSE
     C                   MOVEL     A1RTNM        OUT2
     C                   ENDIF
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C**********           PARM           A1RTNM           Retail Transact                   256648A
     C                   PARM                    OUT2                           Retail Transact
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
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
     C                   EXSR      MC#1FN
     C                   SUB       1             ##RR
     C                   MOVEL     'Y'           W0RSL             1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
      * USER: Initialize subfile record from DBF record
      * 00/Copy member SD0130DISR - Retail Transaction Types  *
     C*Retail Transactions mnt  Initialise Subfile Rcd
     C/COPY WNCPYSRC,SD0130DISR
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
     C**********         READ      @A1RECX                                82    *82=EOF     MD058755
     C/EXEC SQL                                                                             MD058755
     C+ fetch next from ACursor into :SDRETR                                                MD058755
     C/END-EXEC                                                                             MD058755
     C                   END                                                    OD 1 - ##SFPG
      *................................................................
     C     BB900         TAG
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
     C                   SETOFF                                         8392    *
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
      *
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
      *
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
      *
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
      *
      * Validate Account Commission Ind
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     #2ACOM        W0NSRQ            1            Account Commiss
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1170047       Y2LSNO            7 0
     C     #2ACOM        PARM      #2ACOM        W0EXVL           20            Account Commiss
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * CALC: Subfile control function fields
      * 00/Copy member SD0130DSFF - Retail Transaction Types  *
     C*Retail Transactions mnt  Calculate Control Fields
     C/COPY WNCPYSRC,SD0130DSFF
      * Change of position specified
     C     WZRTTY        CASNE     #2RTTY        FBRQRL
     C     WZRTNM        CASNE     #2RTNM        FBRQRL
     C     WZCOIN        CASNE     #2COIN        FBRQRL
     C     WZDCIN        CASNE     #2DCIN        FBRQRL
     C     WZRVIN        CASNE     #2RVIN        FBRQRL
     C     WZPADI        CASNE     #2PADI        FBRQRL
     C     WZACOM        CASNE     #2ACOM        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * 00/Copy member SD0130DPSC - Retail Transaction Types  *
     C*Retail Transactions mnt  Process Subfile Control
     C/COPY WNCPYSRC,SD0130DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * 00/Copy member SD0130DFPR - Retail Transaction Types  *
     C*Retail Transactions mnt  Final Processing
     C/COPY WNCPYSRC,SD0130DFPR
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
      * 00/Copy member SD0130DPCK - Retail Transaction Types  *
     C*Retail Transactions mnt  Process Command Keys
     C/COPY WNCPYSRC,SD0130DPCK
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'                                          *IF
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      * Edit Retail Trans Types - Retail Transaction Types  *
     C                   CLEAR                   PARC
     C                   MOVEL     *BLANK        PARTTY                         Retail Transact
      *
     C                   CALL      'SD0131R'                            90      Edit Retail Tra
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: Retail Tra
     C                   PARM      'I'           WQ0001            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        99        *
     C                   END
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   GOTO      DAEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBPRSF        BEGSR
      *================================================================
      * Process modified subfile record
      *================================================================
     C                   READC     #SFLRCD                                92    *
     C     *IN92         DOWEQ     '0'
      * Process subfile record
     C                   EXSR      DCPRSR
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
      * Setof error indicators and SFLNXTCHG
     C                   MOVEA     WKIND0        *IN(38)
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * CASE: RCD.*SFLSEL is *Enquire
     C     #1SEL         IFEQ      'E'                                          *IF
      * Blank the subfile select
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      * dsp. retail transaction - Retail Transaction Types  *
     C                   CLEAR                   PBRC
     C                   MOVEL     #1RTTY        PBRTTY                         Retail Transact
      *
     C                   CALL      'SD0131E'                            90      dsp. retail tra
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PBRC                           KEY: Retail Tra
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131E'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'                                          *IF
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'                                          *IF
      * Blank the subfile select
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      * Edit Retail Trans Types - Retail Transaction Types  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1RTTY        PARTTY                         Retail Transact
      *
     C                   CALL      'SD0131R'                            90      Edit Retail Tra
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: Retail Tra
     C                   PARM      'A'           WQ0002            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
      * CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      'D'                                          *IF
      * Blank the subfile select
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      * Edit Retail Transaction - Retail Transaction Types  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1RTTY        PARTTY                         Retail Transact
      *
     C                   CALL      'SD0131R'                            90      Edit Retail Tra
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: Retail Tra
     C                   PARM      'D'           WQ0003            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0131R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        98        *
     C                   END
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'value for field not valid'
     C                   MOVEL     'USR0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   ELSE
      * CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      'D'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0002                         *SFLSEL
      * Send message 'value for field not valid'
     C                   MOVEL     'USR0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9838      *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Start of S01486
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * 00/Copy member SD0130DPSR - Retail Transaction Types  *
     C*Retail Transactions mnt  Process Subfile Record
     C/COPY WNCPYSRC,SD0130DPSR
      * End of S01486
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
     CSR   GADSA1        BEGSR
      *================================================================
      * Set display attributes for Subfile record
      *================================================================
     C                   MOVEL     '0'           *IN78
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSA2        BEGSR
      *================================================================
      * Set display attributes for Subfile control
      *================================================================
     C                   MOVEL     '0'           *IN79
     C     WUACID        IFEQ      'N'                                          *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @A1RECX fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   Z-ADD     A1LCD         #1LCD                          Last Change Dat
     C                   MOVEL     A1TYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     A1CPTC        #1CPTC                         Change to P/fol
     C                   MOVEL     A1PFMC        #1PFMC                         Performance Eve
     C                   MOVEL     A1ATRA        #1ATRA                         Applies to Reta
     C                   MOVEL     A1ASGL        #1ASGL                         Associated GL N
     C                   MOVEL     A1PASB        #1PASB                         Passbook Transa
     C                   MOVEL     A1CIND        #1CIND                         Cash Indicator
     C                   MOVEL     A1CLIN        #1CLIN                         Clearing Indica
     C                   MOVEL     A1RTTY        #1RTTY                         Retail Transact
     C                   MOVEL     A1RTNM        #1RTNM                         Retail Transact
     C                   MOVEL     A1COIN        #1COIN                         Customer Origin
     C                   MOVEL     A1DCIN        #1DCIN                         Debit/Credit In
     C                   MOVEL     A1RVIN        #1RVIN                         Reversal Indica
     C                   MOVEL     A1PADI        #1PADI                         Print Advices I
     C                   MOVEL     A1ACOM        #1ACOM                         Account Commiss
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * 00/Copy member SD0130DRFF - Retail Transaction Types  *
     C*Retail Transactions mnt  Calculate Record Funcs
     C/COPY WNCPYSRC,SD0130DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
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
      * Get Retail 3/IOA indic - MIDAS Modules  *
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
      * Data record not found
     C                   MOVEL     'USR0096'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message
     C                   MOVEL     'SDMMODPD'    ZA0003                         Filename
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
      * USER: Process Data record
     C                   MOVEL     *BLANK        W0RTN                          *Return code
      * PAR = DB1 By name
     C                   MOVEL     BGNXST        WUNXST                         Retail 3
     C                   MOVEL     BGNYST        WUNYST                         Interest on Acc
     C                   READ      @BGREC8                                90    *
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   Y0SET         BEGSR
      *================================================================
      * Set cursor by *SET CURSOR data
      *================================================================
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
      * Cancel & exit program
      *================================================================
      * USER: Exit program processing
      * 00/Copy member SD0130DEPP - Retail Transaction Types  *
     C*Retail Transactions mnt  Exit Program Processing
     C/COPY WNCPYSRC,SD0130DEPP
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
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
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
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
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
      * Define work field Retail 3
     C                   MOVEL     *BLANK        WUNXST            1
      * Define work field Interest on Accounts 3
     C                   MOVEL     *BLANK        WUNYST            1
      * Define work field Commission on Debit Turn
     C                   MOVEL     *BLANK        WUCODT            1
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
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   OPEN      SD0130D#
     C**********         OPEN      SDRETRL1                                                 MD058755
     C                   OPEN      SDMMODL1
     C                   MOVEL     'N'           W0PMT             1
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      * Maximum record number
     C                   Z-ADD     *ZERO         ##RRMX
      * Scan limit
     C                   Z-ADD     500           W0SLM             5 0
      * Subfile pages
     C                   Z-ADD     1             W0SPG             3 0
      * Processed Subfile record
     C                   Z-ADD     0             W0RR0             4 0
      *................................................................
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * Start of change S01459.
      * SD0130D Precompiler - Retail Transaction Types  *
      * Remove Last Amend Box and Creation Parameters functions.
      * End of change S01459.
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement - Standard Functions  * copyright
      * Set-up Dsp. file footer - Standard Functions  *
     C* MOVE THE CORRECT TEXT INTO THE DISPLAY FILE'S FOOTER DEPENDING ON THE
     C* MODE
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C     P1DFMD        IFEQ      'E'
     C* Setup footer text:
     C* E=Enquire   F3=Main Menu   F5=Refresh
     C                   MOVEL     'USR3341'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C     P1DFMD        IFEQ      'M'
     C                   MOVE      WUMDEL        WUMDEL            1
     C     WUMDEL        IFNE      'N'
     C* Setup footer text:
     C* A=Amend  D=Delete  E=Enquire  F3=Main Menu  F5=Refresh
     C* F9=Go to 'Add'
     C                   MOVEL     'USR3334'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C     WUMDEL        IFEQ      'N'
     C* Setup footer text:
     C* A=Amend  E=Enquire  F3=Main Menu  F5=Refresh  F9=Go to 'Add' Mode
     C                   MOVEL     'USR3335'     WUMSID                         Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C* Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
     C                   END
     C                   END
     C*
      * start S01413
      * Get Retail 3/IOA indic - MIDAS Modules  *
     C                   EXSR      SARVGN
      * Get Comm on Debit Turnovr - Retail Details  *
     C                   CALL      'SD9342'                             90      Get Comm on Deb
     C     W0RTN         PARM      W0RTN         WQ0004            7            *Return code
     C     WUCODT        PARM      *BLANK        WQ0005            1            Commission on D
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD9342'      W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
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
      * 00/Copy member SD0130DFPG - Retail Transaction Types  *
      * 00/Copy member SD0130DEPG - Retail Transaction Types  *
      * 00/Copy member SD0130DIPG - Retail Transaction Types  *
      * 00/Copy member SD0130DCPG - Retail Transaction Types  *
     C*Retail Transactions mnt  Initialise Program C-Spec
     C/COPY WNCPYSRC,SD0130DCPG
      * 00/Copy member SD0130DOPG - Retail Transaction Types  *
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
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0130DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0130DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD058755
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD058755
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0130DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*Retail Transactions mnt  Initialise Program O-Spec
     O/COPY WNCPYSRC,SD0130DOPG
**CTDATA CPY@
(c) Finastra International Limited 2001
