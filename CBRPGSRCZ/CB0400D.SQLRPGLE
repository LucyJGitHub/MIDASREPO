     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055891
/*STD *  RPGSQLBND                                                    *                     MD055891
/*EXI *  TEXT('Midas CB COB Components maintenance')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Module                             *
      *                                                               *
      *  CB0400D - COB Components maintenance                         *
      *                                                               *
      *  Function:  This program allows users to enquire and/or       *
      *             maintaine the records on file.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055891           Date 01Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CCB008             Date 02Jan98               *
      *                 CCB003             Date 06MAR97               *
      *                 090416             Date 12JUL95               *
      *                 S01459             Date 22DEC94               *
      *                 S01417             Date 24AUG93               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055891 - Deliverable Data Split                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  CCB003 - CoB Task Split Enhancement                          *
      *           - Recompiled over changed CBCMPNPD.                 *
      *  090416 - Recompiled over changed display file.               *
      *  S01459 - Addition of headerbox and PSSR processing.          *
      *           Correcting the screen header.                       *
      *  S01417 - ADD 1A FUNCTION INPUT PARAMETER TO INDICATE         *
      *           SUCCESSFUL UPDATE MADE TO MASTER FILE               *
      *                                                               *
      *****************************************************************
     FCB0400D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas CB COB Components maintenance subfile
      *
     F*CBCMPNL1* IF   E           K DISK    USROPN                                          MD055891
     F**********                           INFDS(INFDS1)                                    MD055891
     F**********                           INFSR(*PSSR)                                     MD055891
      * RTV : Midas CB Components retrieval
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
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * B :  Successful Update Made
     D  P1SUPD                 1      1
     D CBCMPN        E DS                  EXTNAME(CBCMPJW0)                                MD055891
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1SUPD        PARM      P1SUPD        WP0001            1            Successful Upda
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
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    DHCOTT                         Component Name
     C                   KFLD                    DHCSEQ                         Component Seque
      * Setup key
     C                   MOVEL     #2COTT        DHCOTT                         Component Name
     C                   MOVEL     #2CSEQ        DHCSEQ                         Component Seque
                                                                                            MD055891
     C*****KPOS          SETLL     @DHREGH                                                  MD055891
     C**********         READ      @DHREGH                              8782    *82=EOF     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ declare ACursor insensitive scroll cursor for                                       MD055891
     C+ select * from CBCMPJW0                                                              MD055891
     C+ where DHCOTT >= :DHCOTT and DHCSEQ >= :DHCSEQ                                       MD055891
     C+ order by DHCOTT, DHCSEQ                                                             MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ close ACursor                                                                       MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ open ACursor                                                                        MD055891
     C/END-EXEC                                                                             MD055891
                                                                                            MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Setoff                                       82                    MD055891
     C                   If        SQLCODE = 100                                            MD055891
     C                   Seton                                        82                    MD055891
     C                   Endif                                                              MD055891
      * Save previous selector values
     C     *LIKE         DEFINE    #2CSTS        WZCSTS
     C                   MOVEL     #2CSTS        WZCSTS                         Component Statu
     C     *LIKE         DEFINE    #2CSHP        WZCSHP
     C                   MOVEL     #2CSHP        WZCSHP                         Scheduling Prio
     C     *LIKE         DEFINE    #2CEPY        WZCEPY
     C                   MOVEL     #2CEPY        WZCEPY                         Execution Prior
     C     *LIKE         DEFINE    #2CTSL        WZCTSL
     C                   MOVEL     #2CTSL        WZCTSL                         Timeslice
     C     *LIKE         DEFINE    #2CFOB        WZCFOB
     C                   MOVEL     #2CFOB        WZCFOB                         FCOOB Error Acc
     C     *LIKE         DEFINE    #2CTXT        WZCTXT
     C                   MOVEL     #2CTXT        WZCTXT                         Component Text
     C     *LIKE         DEFINE    #2CPRM        WZCPRM
     C                   MOVEL     #2CPRM        WZCPRM                         Execution Param
     C     *LIKE         DEFINE    #2CRQD        WZCRQD
     C                   MOVEL     #2CRQD        WZCRQD                         Sel for Today's
     C     *LIKE         DEFINE    #2CMOD        WZCMOD
     C                   MOVEL     #2CMOD        WZCMOD                         Module
     C     *LIKE         DEFINE    #2CEMI        WZCEMI
     C                   MOVEL     #2CEMI        WZCEMI                         Complex Module
     C     *LIKE         DEFINE    #2CRES        WZCRES
     C                   MOVEL     #2CRES        WZCRES                         Restart Flag
     C     *LIKE         DEFINE    #2CODP        WZCODP
     C                   MOVEL     #2CODP        WZCODP                         No.Outstndng De
     C     *LIKE         DEFINE    #2CMEF        WZCMEF
     C                   MOVEL     #2CMEF        WZCMEF                         Mut.Exclusive C
     C     *LIKE         DEFINE    #2CFRQ        WZCFRQ
     C                   MOVEL     #2CFRQ        WZCFRQ                         Run Conditions
     C     *LIKE         DEFINE    #2CSDE        WZCSDE
     C                   MOVEL     #2CSDE        WZCSDE                         Start Date
     C     *LIKE         DEFINE    #2CSTI        WZCSTI
     C                   MOVEL     #2CSTI        WZCSTI                         Start Time
     C     *LIKE         DEFINE    #2CEDE        WZCEDE
     C                   MOVEL     #2CEDE        WZCEDE                         End Date
     C     *LIKE         DEFINE    #2CETI        WZCETI
     C                   MOVEL     #2CETI        WZCETI                         End Time
     C     *LIKE         DEFINE    #2CHTB        WZCHTB
     C                   MOVEL     #2CHTB        WZCHTB                         Halt Before
     C     *LIKE         DEFINE    #2CHTA        WZCHTA
     C                   MOVEL     #2CHTA        WZCHTA                         Halt After
     C     *LIKE         DEFINE    #2CFAL        WZCFAL
     C                   MOVEL     #2CFAL        WZCFAL                         Component Faile
     C     *LIKE         DEFINE    #2COTT        WZCOTT
     C                   MOVEL     #2COTT        WZCOTT                         Component Name
     C     *LIKE         DEFINE    #2CSEQ        WZCSEQ
     C                   MOVEL     #2CSEQ        WZCSEQ                         Component Seque
      * Translate search mask for text field
     C                   MOVEL     'QSYST'       WQB10X           10
     C                   MOVE      'RNTBL'       WQB10X
     C     *LIKE         DEFINE    #2CTXT        WQCTXT                         Component Text
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      60            WQA5N             5 0
     C                   PARM      #2CTXT        WQCTXT                         Component Text
     C                   PARM                    WQB10X                         QSYSTRNTBL
     C                   PARM      'QSYS'        WQC10X           10
     C     *LIKE         DEFINE    #2CPRM        WQCPRM                         Execution Param
     C                   CALL      'QDCXLATE'
      * Length
     C                   PARM      100           WQA5N             5 0
     C                   PARM      #2CPRM        WQCPRM                         Execution Param
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
     C**N82*****         READP     @DHREGH                                90    *           MD055891
     C**N82*****         READ      @DHREGH                                90    *           MD055891
     C                   If        *IN82 = '0'                                              MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch prior from ACursor into :CBCMPN                                               MD055891
     C/END-EXEC                                                                             MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
     C                   Endif                                                              MD055891
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
     C******IN82         DOWEQ     '0'                                          DO          MD055891
     C*****##RROK        ANDLT     ##SFLN                                                   MD055891
     C*****##RRRD        ANDLT     W0SLM                                                    MD055891
     C                   DOW       SQLCODE = 0                                              MD055891
     C                             and ##RROK < ##SFLN                                      MD055891
     C                             and ##RRRD < W0SLM                                       MD055891
      * Check selection fields - if fail, read next record
     C     #2CSTS        IFNE      *BLANK                                       Component Statu
     C     DHCSTS        CABNE     #2CSTS        BB020                          Component Statu
     C                   END
     C     #2CSHP        IFNE      *ZERO                                        Scheduling Prio
     C     DHCSHP        CABNE     #2CSHP        BB020                          Scheduling Prio
     C                   END
     C     #2CEPY        IFNE      *ZERO                                        Execution Prior
     C     DHCEPY        CABNE     #2CEPY        BB020                          Execution Prior
     C                   END
     C     #2CTSL        IFNE      *ZERO                                        Timeslice
     C     DHCTSL        CABNE     #2CTSL        BB020                          Timeslice
     C                   END
     C     #2CFOB        IFNE      *BLANK                                       FCOOB Error Acc
     C     DHCFOB        CABNE     #2CFOB        BB020                          FCOOB Error Acc
     C                   END
     C     #2CTXT        IFNE      *BLANK                                       Component Text
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    DHCTXT                         Component Text
      * Length
     C                   PARM      60            WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQCTXT
      * Length
     C                   PARM      60            WQC3N             3 0
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
     C     #2CPRM        IFNE      *BLANK                                       Execution Param
      * Scan for search string
     C                   CALL      'QCLSCAN'
     C                   PARM                    DHCPRM                         Execution Param
      * Length
     C                   PARM      100           WQA3N             3 0
      * Start
     C                   PARM      1             WQB3N             3 0
      * Mask
     C                   PARM                    WQCPRM
      * Length
     C                   PARM      100           WQC3N             3 0
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
     C     #2CRQD        IFNE      *BLANK                                       Sel for Today's
     C     DHCRQD        CABNE     #2CRQD        BB020                          Sel for Today's
     C                   END
     C     #2CMOD        IFNE      *BLANK                                       Module
     C     DHCMOD        CABNE     #2CMOD        BB020                          Module
     C                   END
     C     #2CEMI        IFNE      *BLANK                                       Complex Module
     C     DHCEMI        CABNE     #2CEMI        BB020                          Complex Module
     C                   END
     C     #2CRES        IFNE      *BLANK                                       Restart Flag
     C     DHCRES        CABNE     #2CRES        BB020                          Restart Flag
     C                   END
     C     #2CODP        IFNE      *ZERO                                        No.Outstndng De
     C     DHCODP        CABNE     #2CODP        BB020                          No.Outstndng De
     C                   END
     C     #2CMEF        IFNE      *BLANK                                       Mut.Exclusive C
     C     DHCMEF        CABNE     #2CMEF        BB020                          Mut.Exclusive C
     C                   END
     C     #2CFRQ        IFNE      *BLANK                                       Run Conditions
     C     DHCFRQ        CABNE     #2CFRQ        BB020                          Run Conditions
     C                   END
     C     #2CSDE        IFNE      *ZERO                                        Start Date
     C     DHCSDE        CABNE     #2CSDE        BB020                          Start Date
     C                   END
     C     #2CSTI        IFNE      *ZERO                                        Start Time
     C     DHCSTI        CABNE     #2CSTI        BB020                          Start Time
     C                   END
     C     #2CEDE        IFNE      *ZERO                                        End Date
     C     DHCEDE        CABNE     #2CEDE        BB020                          End Date
     C                   END
     C     #2CETI        IFNE      *ZERO                                        End Time
     C     DHCETI        CABNE     #2CETI        BB020                          End Time
     C                   END
     C     #2CHTB        IFNE      *BLANK                                       Halt Before
     C     DHCHTB        CABNE     #2CHTB        BB020                          Halt Before
     C                   END
     C     #2CHTA        IFNE      *BLANK                                       Halt After
     C     DHCHTA        CABNE     #2CHTA        BB020                          Halt After
     C                   END
     C     #2CFAL        IFNE      *BLANK                                       Component Faile
     C     DHCFAL        CABNE     #2CFAL        BB020                          Component Faile
     C                   END
     C     #2COTT        IFEQ      *BLANK                                       Component Name
     C     #2CSEQ        IFNE      *BLANK                                       Component Seque
     C     DHCSEQ        CABNE     #2CSEQ        BB020                          Component Seque
     C                   END
     C                   END
      * Load SFL fields
     C                   EXSR      MBFL#1
     C                   MOVEL     'Y'           W0RSL             1
      * Allow for possible *Set Cursor processing
     C                   ADD       1             ##RR
      * USER: Initialize subfile record from DBF record
      * CASE: DB1.Component Name is cobbegin
     C     DHCOTT        IFEQ      'COBBEGIN'                                   *IF
     C                   MOVEL     'N'           W0RSL                          *Record selecte
     C                   END                                                    *FI
      **CASE:*DB1.Component*Name*is*Cobend*****************************                       CCB020
      ** CASE: DB1.Component Name is SCOBFINISH                                               CCB020
     C                   MOVEL     'SCOBFINI'    SCOBFI           10
     C                   MOVE      'SH'          SCOBFI
     C********** DHCOTT    IFEQ 'COBEND'                   *IF                                CCB020
     C     DHCOTT        IFEQ      SCOBFI
     C                   MOVEL     'N'           W0RSL                          *Record selecte
     C                   END                                                    *FI
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
     C**********         READ      @DHREGH                                82    *82=EOF     MD055891
     C/EXEC SQL                                                                             MD055891
     C+ fetch next from ACursor into :CBCMPN                                                MD055891
     C/END-EXEC                                                                             MD055891
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
      * Check Component Sequence Number is numeric
     C                   MOVEL     *IN90         XG90              1
     C                   TESTN                   #2CSEQ               90  90    *
     C   90              MOVE      #2CSEQ        XGX1              1
     C   90              TESTB     '0123'        XGX1                     90    *
      * All blank is OK
     C  N90#2CSEQ        COMP      *BLANKS                                90    *
      * '?' is OK
     C  N90              MOVEL     #2CSEQ        XGX1
     C  N90XGX1          COMP      '?'                                    90    *
     C     *IN90         IFEQ      '0'
      * Send message '*Field must be numeric'
     C                   MOVEL     'Y2U0010'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
     C                   END
     C                   MOVEL     XG90          *IN90
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      *................................................................
      * Change of position specified
     C     WZCOTT        CASNE     #2COTT        FBRQRL
     C     WZCSEQ        CASNE     #2CSEQ        FBRQRL
     C                   END
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
      * CASE: CTL.*CMD key is *Go to 'Add' mode
     C     *IN09         IFEQ      '1'                                          *IF
      * Edit Components - Components  *
     C                   CALL      'CB0400R'                            90      Edit Components
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #2COTT        WQ0001           10            Component Name
     C                   PARM      #2CSEQ        WQ0002            5            Component Seque
     C     P1SUPD        PARM      P1SUPD        WQ0003            1            Successful Upda
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0400R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        993132    *
     C                   END
     C                   MOVEL     'Y'           W0RSF                          *Reload subfile
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
     C                   MOVEA     WKIND0        *IN(33)
     C                   SETOFF                                       98        *
      * USER: Process subfile record (Pre-confirm)
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'                                          *IF
      * Edit Components - Components  *
     C                   CALL      'CB0400R'                            90      Edit Components
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1COTT        WQ0004           10            Component Name
     C                   PARM      #1CSEQ        WQ0005            5            Component Seque
     C     P1SUPD        PARM      P1SUPD        WQ0006            1            Successful Upda
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0400R'     W0CLPG
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
      * CASE: RCD.*SFLSEL is *Enquire
     C     #1SEL         IFEQ      'E'                                          *IF
      * display components rec - Components  *
     C                   CALL      'CB0400E'                            90      display compone
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM      #1COTT        WQ0007           10            Component Name
     C                   PARM      #1CSEQ        WQ0008            5            Component Seque
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'CB0400E'     W0CLPG
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
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @DHREGH fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   MOVEL     DHCSTS        #1CSTS                         Component Statu
     C                   Z-ADD     DHCSHP        #1CSHP                         Scheduling Prio
     C                   Z-ADD     DHCEPY        #1CEPY                         Execution Prior
     C                   Z-ADD     DHCTSL        #1CTSL                         Timeslice
     C                   MOVEL     DHCFOB        #1CFOB                         FCOOB Error Acc
     C                   MOVEL     DHCTXT        #1CTXT                         Component Text
     C                   MOVEL     DHCPRM        #1CPRM                         Execution Param
     C                   MOVEL     DHCRQD        #1CRQD                         Sel for Today's
     C                   MOVEL     DHCMOD        #1CMOD                         Module
     C                   MOVEL     DHCEMI        #1CEMI                         Complex Module
     C                   MOVEL     DHCRES        #1CRES                         Restart Flag
     C                   Z-ADD     DHCODP        #1CODP                         No.Outstndng De
     C                   MOVEL     DHCMEF        #1CMEF                         Mut.Exclusive C
     C                   MOVEL     DHCFRQ        #1CFRQ                         Run Conditions
     C                   Z-ADD     DHCSDE        #1CSDE                         Start Date
     C                   Z-ADD     DHCSTI        #1CSTI                         Start Time
     C                   Z-ADD     DHCEDE        #1CEDE                         End Date
     C                   Z-ADD     DHCETI        #1CETI                         End Time
     C                   MOVEL     DHCHTB        #1CHTB                         Halt Before
     C                   MOVEL     DHCHTA        #1CHTA                         Halt After
     C                   MOVEL     DHCFAL        #1CFAL                         Component Faile
     C                   Z-ADD     DHEODT        #1EODT                         End of Day Run
     C                   Z-ADD     DHEOMT        #1EOMT                         End of Month Ru
     C                   Z-ADD     DHBOMT        #1BOMT                         Begin of Month
     C                   Z-ADD     DHEOYT        #1EOYT                         End of Year Run
     C                   Z-ADD     DHEODC        #1EODC                         End of Day CPU
     C                   Z-ADD     DHEOMC        #1EOMC                         End of Month CP
     C                   Z-ADD     DHBOMC        #1BOMC                         Begin of Month
     C                   Z-ADD     DHEOYC        #1EOYC                         End of Year CPU
     C                   MOVEL     DHABIC        #1ABIC                         Allow Bypass in
     C                   MOVEL     DHCBSN        #1CBSN                         COB Stream Name
     C                   MOVEL     DHTASK        #1TASK                         Task Split Job
     C                   Z-ADD     DHTSNO        #1TSNO                         Number of Task
     C                   MOVEL     DHCOTT        #1COTT                         Component Name
     C                   MOVEL     DHCSEQ        #1CSEQ                         Component Seque
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2CSTS                         Component Statu
     C                   Z-ADD     *ZERO         #2CSHP                         Scheduling Prio
     C                   Z-ADD     *ZERO         #2CEPY                         Execution Prior
     C                   Z-ADD     *ZERO         #2CTSL                         Timeslice
     C                   MOVEL     *BLANK        #2CFOB                         FCOOB Error Acc
     C                   MOVEL     *BLANK        #2CTXT                         Component Text
     C                   MOVEL     *BLANK        #2CPRM                         Execution Param
     C                   MOVEL     *BLANK        #2CRQD                         Sel for Today's
     C                   MOVEL     *BLANK        #2CMOD                         Module
     C                   MOVEL     *BLANK        #2CEMI                         Complex Module
     C                   MOVEL     *BLANK        #2CRES                         Restart Flag
     C                   Z-ADD     *ZERO         #2CODP                         No.Outstndng De
     C                   MOVEL     *BLANK        #2CMEF                         Mut.Exclusive C
     C                   MOVEL     *BLANK        #2CFRQ                         Run Conditions
     C                   Z-ADD     *ZERO         #2CSDE                         Start Date
     C                   Z-ADD     *ZERO         #2CSTI                         Start Time
     C                   Z-ADD     *ZERO         #2CEDE                         End Date
     C                   Z-ADD     *ZERO         #2CETI                         End Time
     C                   MOVEL     *BLANK        #2CHTB                         Halt Before
     C                   MOVEL     *BLANK        #2CHTA                         Halt After
     C                   MOVEL     *BLANK        #2CFAL                         Component Faile
     C                   MOVEL     *BLANK        #2COTT                         Component Name
     C                   MOVEL     *BLANK        #2CSEQ                         Component Seque
      *================================================================
     CSR   MEEXIT        ENDSR
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
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   OPEN      CB0400D#
     C**********         OPEN      CBCMPNL1                                                 MD055891
     C                   MOVEL     'N'           W0PMT             1
     C                   Z-ADD     14            ##SFPG            3 0          SFLPAG
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
      * Start of S01459
      * Remove the last amend box and creation parameters functions
      * CB0400D precompiler - Components  *
      * Setup footer maint pgm - Components  *
     C*
     C                   MOVEL     'CBUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* A=Amend   E=Enquire   F3=Exit   F5=Refresh Screen
     C* F9=Go to 'Add' Mode
     C                   MOVEL     'CBM0199'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        WQ0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        WQ0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        WQ0288           80            Message Text
     C                   MOVEL     WUMTXT        ##ARNA
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
     C*
      * End of S01459
      * Copyright Statement - Standard functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##AANA            7
     C                   MOVE      MRDT          WUAANA
     C                   MOVE      RDNB          WUAKTX
     C                   MOVE      SUC           WUAUST
     C                   MOVE      DFF           WUE3ST
     C                   MOVE      MBIN          WUF1ST
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
     C/COPY WNCPYSRC,CB0400DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0400DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY CBCPYSRC,CBPSSRINS                                                              MD055891
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD055891
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,CB0400DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
