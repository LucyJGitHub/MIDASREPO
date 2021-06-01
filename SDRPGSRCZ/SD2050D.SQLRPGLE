     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056888
/*STD *  RPGSQLBND                                                    *                     MD056888
/*EXI *  TEXT('Midas SD SWIFT codewords display subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2050D - Midas SD SWIFT Codewords enquiry                    *
      *                                                               *
      *  Function:  This program allows the user to enquire from a    *
      *             list of SWIFT Codewords                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD056888           Date 20Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      *                 S01459             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSW096             Date 23MAY96               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD056888 - Deliverable Data Split for SDCODEPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *  CSW096 - New function for SWIFT96 Changes                    *
      *                                                               *
      *****************************************************************
     F*SWIFT Codewords Dsp File Initialise Program F-Spec
     F/COPY WNCPYSRC,SD2050DFPG
     FSD2050D#  CF   E             WORKSTN USROPN
     F                                     SFILE(#SFLRCD:##RR)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD SWIFT codewords display subfile
      *
     F*SDCODEL2* IF   E           K DISK    USROPN                                          MD056888
     F**********                           INFDS(INFDS1)                                    MD056888
     F**********                           INFSR(*PSSR)                                     MD056888
      * RSQ : Midas SD SWIFT codewords by cdewrd/'M'type/mod/cus
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*SWIFT Codewords Dsp File Initialise Program E-Spec
     D/COPY WNCPYSRC,SD2050DEPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*SWIFT Codewords Dsp File Initialise Program I-Spec
     D/COPY WNCPYSRC,SD2050DIPG
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
      * Outward parameters
     D PARC            DS            38
      * KEY : Midas SD SWIFT codewords retrieval
      * I : RST SWIFT Codeword
     D  PASWCD                 1     20
      * I : RST Seq Job Date
     D  PASEQ1                21     27  0
      * I : RST Seq Job Time
     D  PASEQ2                28     33  0
      * I : RST Seq Job Number
     D  PASEQ3                34     38  0
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
      * Message data for 'SWIFT Codewords Enquiry'
      * Message data for 'SWIFT Codewords Maint'
      * Message data for 'STD FTR:DSPFIL Enquiry/1'
      * Message data for 'STD FTR:DSPFIL Enquiry/2'
      * Message data for 'STD FTR:DSPFIL Maint/1'
      * Message data for 'STD FTR:DSPFIL Maint/2'
     D SDCODE        E DS                  EXTNAME(SDCODJW0)                                MD056888
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
      * 00/Copy Member SD2050DISC - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Initialise Subf Control
     C/COPY WNCPYSRC,SD2050DISC
      * Position DBF file
     C     KPOS          KLIST
     C                   KFLD                    FYSWCD                         SWIFT Codeword
     C                   KFLD                    FYSMTP                         SWIFT Message T
     C                   KFLD                    FYMMID                         Midas Module Id
     C                   KFLD                    FYDCUS                         Destination Cus
      * Setup key
     C                   MOVEL     #2SWCD        FYSWCD                         SWIFT Codeword
     C                   MOVEL     #2SMTP        FYSMTP                         SWIFT Message T
     C                   MOVEL     #2MMID        FYMMID                         Midas Module Id
     C                   MOVEL     #2DCUS        FYDCUS                         Destination Cus
     C*****KPOS*         SETLL     @CODEL2                                                  MD056888
     C**********         READ      @CODEL2                              8782    *82=EOF     MD056888
     C/EXEC SQL                                                                             MD056888
     C+ close ACursor                                                                       MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C/EXEC SQL                                                                             MD056888
     C+ declare ACursor insensitive scroll cursor for                                       MD056888
     C+ select * from SDCODJW0                                                              MD056888
     C+ where FYSWCD >= :FYSWCD and FYDCUS >= :FYDCUS and FYMMID >= :FYMMID                 MD056888
     C+ and   FYSMTP >= :FYSMTP and FYRECI = 'D'                                            MD056888
     C+ order by FYSWCD, FYSMTP, FYMMID, FYDCUS                                             MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C/EXEC SQL                                                                             MD056888
     C+ open ACursor                                                                        MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C/EXEC SQL                                                                             MD056888
     C+ fetch next from ACursor into :SDCODE                                                MD056888
     C/END-EXEC                                                                             MD056888
                                                                                            MD056888
     C                   setoff                                       82                    MD056888
     C                   If        SQLCODE = 100                                            MD056888
     C                   seton                                        82                    MD056888
     C                   Endif                                                              MD056888
                                                                                            MD056888
      * Save previous selector values
     C     *LIKE         DEFINE    #2SWCD        WZSWCD
     C                   MOVEL     #2SWCD        WZSWCD                         SWIFT Codeword
     C     *LIKE         DEFINE    #2SMTP        WZSMTP
     C                   MOVEL     #2SMTP        WZSMTP                         SWIFT Message T
     C     *LIKE         DEFINE    #2MMID        WZMMID
     C                   MOVEL     #2MMID        WZMMID                         Midas Module Id
     C     *LIKE         DEFINE    #2DCUS        WZDCUS
     C                   MOVEL     #2DCUS        WZDCUS                         Destination Cus
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
     C**N82*****         READP     @CODEL2                                90    *           MD056888
     C**N82*****         READ      @CODEL2                                90    *           MD056888
     C                   If        *IN82 = '0'                                              MD056888
     C/EXEC SQL                                                                             MD056888
     C+ fetch prior from ACursor into :SDCODE                                               MD056888
     C/END-EXEC                                                                             MD056888
     C/EXEC SQL                                                                             MD056888
     C+ fetch next from ACursor into :SDCODE                                                MD056888
     C/END-EXEC                                                                             MD056888
     C                   Endif                                                              MD056888
     C                   END
      *
      * Setof record error indicators
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(35)
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
     C******IN82         DOWEQ     '0'                                          DO          MD056888
     C*****##RROK        ANDLT     ##SFPG                                                   MD056888
     C*****##RRRD        ANDLT     W0SLM                                                    MD056888
     C                   DOW       SQLCODE = 0                                              MD056888
     C                             and ##RROK < ##SFPG                                      MD056888
     C                             and ##RRRD < W0SLM                                       MD056888
      * Check selection fields - if fail, read next record
     C     #2SWCD        IFEQ      *BLANK                                       SWIFT Codeword
     C     #2SMTP        IFNE      *BLANK                                       SWIFT Message T
     C     FYSMTP        CABNE     #2SMTP        BB020                          SWIFT Message T
     C                   END
     C                   END
     C     #2SWCD        IFEQ      *BLANK                                       SWIFT Codeword
     C     #2SMTP        OREQ      *BLANK                                       SWIFT Message T
     C     #2MMID        IFNE      *BLANK                                       Midas Module Id
     C     FYMMID        CABNE     #2MMID        BB020                          Midas Module Id
     C                   END
     C                   END
     C     #2SWCD        IFEQ      *BLANK                                       SWIFT Codeword
     C     #2SMTP        OREQ      *BLANK                                       SWIFT Message T
     C     #2MMID        OREQ      *BLANK                                       Midas Module Id
     C     #2DCUS        IFNE      *BLANK                                       Destination Cus
     C     FYDCUS        CABNE     #2DCUS        BB020                          Destination Cus
     C                   END
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
      * 00/Copy Member SD2050DISR - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Initialise Subfile Rcd
     C/COPY WNCPYSRC,SD2050DISR
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
     C**********         READ      @CODEL2                                82    *82=EOF     MD056888
     C/EXEC SQL                                                                             MD056888
     C+ fetch next from ACursor into :SDCODE                                                MD056888
     C/END-EXEC                                                                             MD056888
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
      * CALC: Subfile control function fields
      * 00/Copy Member SD2050DSCF - SWIFT Codewords  *
     C*
     C/COPY WNCPYSRC,SD2050DSCF
     C*
      * Change of position specified
     C     WZSWCD        CASNE     #2SWCD        FBRQRL
     C     WZSMTP        CASNE     #2SMTP        FBRQRL
     C     WZMMID        CASNE     #2MMID        FBRQRL
     C     WZDCUS        CASNE     #2DCUS        FBRQRL
     C                   END
      * USER: Process subfile control (Pre-confirm)
      * 00/Copy Member SD2050DPSC - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Process Subfile Control
     C/COPY WNCPYSRC,SD2050DPSC
      * Reload subfile requested
     C     W0RSF         CABEQ     'Y'           DAEXIT
     C     *IN81         IFEQ      '1'
      * Process subfile records
     C                   EXSR      DBPRSF
     C                   END
      * USER: Final processing (Pre-confirm)
      * 00/Copy Member SD2050DFPR - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Final Processing
     C/COPY WNCPYSRC,SD2050DFPR
      * If error, quit processing
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * USER: Process command keys
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'                                          *IF
      * CASE: CTL.*CMD key is *Add
     C     *IN09         IFEQ      '1'                                          *IF
      * WRK.Seq Job Date = JOB.*Job date
     C                   Z-ADD     ##JDT         WUSEQ1                         Seq Job Date
      * WRK.Seq Job Time = JOB.*Job time
     C                   Z-ADD     ##JTM         WUSEQ2                         Seq Job Time
     C                   Z-ADD     ##JNO         WUSEQ3                         Seq Job Number
      * SWIFT Codeword Maint - SWIFT Codewords  *
     C                   CLEAR                   PARC
     C                   MOVEL     #2SWCD        PASWCD                         SWIFT Codeword
     C                   Z-ADD     WUSEQ1        PASEQ1                         Seq Job Date
     C                   Z-ADD     WUSEQ2        PASEQ2                         Seq Job Time
     C                   Z-ADD     WUSEQ3        PASEQ3                         Seq Job Number
      *
     C                   CALL      'SD2051C'                            90      SWIFT Codeword
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: SWIFT Code
     C                   PARM      'I'           WQ0001            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD2051C'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9931      *
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
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD2050DPCK - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Process Command Keys
     C/COPY WNCPYSRC,SD2050DPCK
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
     C                   MOVEA     WKIND0        *IN(35)
     C                   SETOFF                                       98        *
     C                   EXSR      MC#1FN
      * USER: Process subfile record (Pre-confirm)
      * Enquire Entered
      * CASE: RCD.*SFLSEL is *Enquire
     C     #1SEL         IFEQ      'E'                                          *IF
      * SWIFT Codeword Maint - SWIFT Codewords  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1SWCD        PASWCD                         SWIFT Codeword
     C                   Z-ADD     #1SEQ1        PASEQ1                         Seq Job Date
     C                   Z-ADD     #1SEQ2        PASEQ2                         Seq Job Time
     C                   Z-ADD     #1SEQ3        PASEQ3                         Seq Job Number
      *
     C                   CALL      'SD2051C'                            90      SWIFT Codeword
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: SWIFT Code
     C                   PARM      'E'           WQ0002            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD2051C'     W0CLPG
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
      * Amend or Delete Entered
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'                                          *IF
      * Amend
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'                                          *IF
      * SWIFT Codeword Maint - SWIFT Codewords  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1SWCD        PASWCD                         SWIFT Codeword
     C                   Z-ADD     #1SEQ1        PASEQ1                         Seq Job Date
     C                   Z-ADD     #1SEQ2        PASEQ2                         Seq Job Time
     C                   Z-ADD     #1SEQ3        PASEQ3                         Seq Job Number
      *
     C                   CALL      'SD2051C'                            90      SWIFT Codeword
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: SWIFT Code
     C                   PARM      'A'           WQ0003            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD2051C'     W0CLPG
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
      * Delete
      * CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      'D'                                          *IF
      * SWIFT Codeword Maint - SWIFT Codewords  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1SWCD        PASWCD                         SWIFT Codeword
     C                   Z-ADD     #1SEQ1        PASEQ1                         Seq Job Date
     C                   Z-ADD     #1SEQ2        PASEQ2                         Seq Job Time
     C                   Z-ADD     #1SEQ3        PASEQ3                         Seq Job Number
      *
     C                   CALL      'SD2051C'                            90      SWIFT Codeword
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: SWIFT Code
     C                   PARM      'D'           WQ0004            1            Action Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD2051C'     W0CLPG
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
      * Amend entered in Enquiry mode
      * CASE: RCD.*SFLSEL is *Amend
     C     #1SEL         IFEQ      'A'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0001                         *SFLSEL
      * Send message 'value for field not valid'
     C                   MOVEL     'USR0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * Delete entered in Enquiry mode
      * CASE: RCD.*SFLSEL is *Delete
     C     #1SEL         IFEQ      'D'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1SEL         ZA0002                         *SFLSEL
      * Send message 'value for field not valid'
     C                   MOVEL     'USR0553'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9835      *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * F3 taken from EDTRCD program
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * 00/Copy Member SD2050DPSR - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Process Subfile Record
     C/COPY WNCPYSRC,SD2050DPSR
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
      * Move @CODEL2 fields to subfile
      *================================================================
     C                   MOVEL     *BLANK        #1SEL
     C                   Z-ADD     FYSEQ1        #1SEQ1                         Seq Job Date
     C                   Z-ADD     FYSEQ2        #1SEQ2                         Seq Job Time
     C                   Z-ADD     FYSEQ3        #1SEQ3                         Seq Job Number
     C                   MOVEL     FYRECI        #1RECI                         Record Id
     C                   MOVEL     FYCDES        #1CDES                         SWIFT Codeword
     C                   MOVEL     FYACJN        #1ACJN                         Action Job Name
     C                   MOVEL     FYACUN        #1ACUN                         Action User Nam
     C                   Z-ADD     FYACTM        #1ACTM                         Action Time
     C                   MOVEL     FYACDA        #1ACDA                         Action Run Date
     C                   Z-ADD     FYLCD         #1LCD                          Last Change Dat
     C                   MOVEL     FYTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     FYSWCD        #1SWCD                         SWIFT Codeword
     C                   MOVEL     FYSMTP        #1SMTP                         SWIFT Message T
     C                   MOVEL     FYMMID        #1MMID                         Midas Module Id
     C                   MOVEL     FYDCUS        #1DCUS                         Destination Cus
     C                   MOVEL     *BLANK        #1SEL                          *SFLSEL
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MC#1FN        BEGSR
      *================================================================
      * CALC: Subfile record function fields
      *================================================================
      * CALC: Subfile record function fields
      * 00/Copy Member SD2050DRFF - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Calculate Record Funcs
     C/COPY WNCPYSRC,SD2050DRFF
      *================================================================
     CSR   MCEXIT        ENDSR
      /EJECT
     CSR   MEIZ#2        BEGSR
      *================================================================
      * Initialise subfile control
      *================================================================
     C                   MOVEL     *BLANK        #2SWCD                         SWIFT Codeword
     C                   MOVEL     *BLANK        #2SMTP                         SWIFT Message T
     C                   MOVEL     *BLANK        #2MMID                         Midas Module Id
     C                   MOVEL     *BLANK        #2DCUS                         Destination Cus
      *================================================================
     CSR   MEEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Set up Display file Header Title
      *================================================================
      * CASE: PAR.Display file mode is Enquiry mode
     C     P1DFMD        IFEQ      'E'                                          *IF
      * Setup message data for message
      * Retrieve message SWIFT Codewords Enquiry
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2915'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     WUDFTL        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   ELSE
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'                                          *IF
      * Setup message data for message
      * Retrieve message SWIFT Codewords Maint
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2916'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     WUDFTL        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Move to Header Title - Standard Functions  *
     C                   MOVEL     WUDFTL        ##URPT
      *================================================================
     CSR   UAEXIT        ENDSR
      /EJECT
     CSR   UBSUBR        BEGSR
      *================================================================
      * Set up Display file Footers
      *================================================================
      * CASE: PAR.Display file mode is Enquiry mode
     C     P1DFMD        IFEQ      'E'                                          *IF
      * Setup message data for message
      * Retrieve message STD FTR:DSPFIL Enquiry/1
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2911'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     WUSFT1        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message STD FTR:DSPFIL Enquiry/2
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2912'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     WUSFT2        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   ELSE
      * CASE: PAR.Display file mode is Maintenance mode
     C     P1DFMD        IFEQ      'M'                                          *IF
      * Setup message data for message
      * Retrieve message STD FTR:DSPFIL Maint/1
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2913'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     WUSFT1        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
      * Setup message data for message
      * Retrieve message STD FTR:DSPFIL Maint/2
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   CALL      'Y2RVMGC'                            90      *
     C                   PARM      *BLANK        W0RTN             7            Return code
     C                   PARM      'USR2914'     ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C     WUSFT2        PARM                    W0MTX           132            Returned messag
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSGF
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Move to Double Footer - Standard Functions  *
     C                   MOVEL     WUSFT1        ##CTX1                                        S0122
     C                   MOVEL     WUSFT2        ##CTX2                                        S0122
      *================================================================
     CSR   UBEXIT        ENDSR
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
     C                   PARM      'SDACDFR'     W0HPMB           10            Help text sourc
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
      * 00/Copy Member SD2050DEPP - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Exit Program Processing
     C/COPY WNCPYSRC,SD2050DEPP
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
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
      * Initialise indicators for re-entry
     C                   MOVE      '0'           *IN
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
      * Define work field Seq Job Date
     C                   Z-ADD     *ZERO         WUSEQ1            7 0
      * Define work field Seq Job Time
     C                   Z-ADD     *ZERO         WUSEQ2            6 0
      * Define work field Seq Job Number
     C                   Z-ADD     *ZERO         WUSEQ3            5 0
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
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
      * Define work field Display File Title
     C                   MOVEL     *BLANK        WUDFTL           53
      * Define work field STD FTR 1
     C                   MOVEL     *BLANK        WUSFT1           78
      * Define work field STD FTR 2
     C                   MOVEL     *BLANK        WUSFT2           78
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
      * Open files first time only
     C     W0OPN         IFEQ      *BLANK
     C                   OPEN      SD2050D#
     C**********         OPEN      SDCODEL2                                                 MD056888
      * Signal that files are now open
     C                   MOVE      'Y'           W0OPN             1
     C                   END
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
      * SD2050D Precompiler - SWIFT Codewords  *
      * Copyright Statement 1996 - Standard Functions  * copyright
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Set up Display file Header Title
     C                   EXSR      UASUBR                                       Set up Display
      * Set up Display file Footers
     C                   EXSR      UBSUBR                                       Set up Display
     C                   Z-ADD     99999         W0SLM                          *Scan limit
      * 00/Copy Member SD2050DFPG - SWIFT Codewords  *
      * 00/Copy Member SD2050DEPG - SWIFT Codewords  *
      * 00/Copy Member SD2050DIPG - SWIFT Codewords  *
      * 00/Copy Member SD2050DCPG - SWIFT Codewords  *
     C*SWIFT Codewords Dsp File Initialise Program C-Spec
     C/COPY WNCPYSRC,SD2050DCPG
      * 00/Copy Member SD2050DOPG - SWIFT Codewords  *
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
     C/COPY WNCPYSRC,SD2050DPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD2050DPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056888
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056888
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD2050DPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O*SWIFT Codewords Dsp File Initialise Program O-Spec
     O/COPY WNCPYSRC,SD2050DOPG
**CTDATA CPY@
(c) Finastra International Limited 2001
