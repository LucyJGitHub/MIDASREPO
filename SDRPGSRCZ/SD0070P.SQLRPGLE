     H DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD Broker codes request')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0070P - Broker Codes Request                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
     F*****************************************************************
     F*                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 195963             Date 08May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 125375             Date 17Jun98               *
      *                 055016             Date 05Aug93               *
     F*                 BHF399             DATE 15AUG90               *
     F*                 LN0502             DATE 26JUL90               *
     F*                 S01212             DATE 26NOV89               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  195963 - Deleted broker codes not shown in SD0070P audit     *
     F*  125375 - Addition of Electronic Brokerage System field       *
     F*  055016 - Auto-Confs code should be printed on the report     *
     F*  BHF399 - PASS SD0070AU TO SDC540P INSTEAD OF PROGRAM NAME    *
     F*  LN0502 - Fields for the title were added to the              *
     F*           printer file                                        *
     F*  S01212 - Window processing being allowed. Add /Copy          *
     F*           statements to each user point.                      *
     F*                                                               *
     F*****************************************************************
     F*SDBROKL1* IF   E           K DISK                                                    MD058085
      * RTV: Broker Codes              Retrieval index
      *
     FSDFCTLL1  IF   E           K DISK
      * RTV: Standing Data Controls    Retrieval index
      *
     FSDBANKL1  IF   E           K DISK
      * RTV: Bank Details              Retrieval index
      *
     FSDFCTLL0  UF   E           K DISK
      * UPD: Standing Data Controls    Update index
      *
     FSDBRKDL0  IF   E           K DISK
      *                                                                                       195963
      ** RTV: Deleted Broker Codes                                                            195963
      *                                                                                       195963
     FSDBRKDPD  O  A E             DISK
      *                                                                                       195963
      ** OUT: Deleted Broker codes                                                            195963
      *                                                                                       195963
     FSDDELRL1  IF   E           K DISK
     FSD0070PM  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
      * PRT: Midas SD Broker Codes Request
      *
     F/COPY WNCPYSRC,SD0070PF01
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      *
      ** SAVE INDICATOR *IN 99
      *
     D @CN             S             25    DIM(12) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
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
     D INFDS$        E DS                  EXTNAME(Y2I$DSP)
      * Printer file information data structure.
      *
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     array
     D RUNDAT          DS
     D*********************                   1   7 AANA                  S01229
     D*********************               P   8  100AKTX                  S01229
     D*********************                  11  11 AUST                  S01229
     D*********************                  12  12 E3ST                  S01229
     D*********************                  13  13 F1ST                  S01229
     D  MRDT                   1      7                                         S01229
     D  RDNB                   8     10P 0                                      S01229
     D  SUC                   11     11                                         S01229
     D  DFF                   12     12                                         S01229
     D  MBIN                  13     13                                         S01229
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * I:    Audit/Request Status Ind
     D  P1ARSI                 1      1
     D P2PARM          DS
      * I:    RCF sequence number
     D  P2RSQN                 1      5
     D P3PARM          DS
      * I:    Level
     D  P3LEVL                 1      1
     D P4PARM          DS
      * I:    Entity
     D  P4ENTY                 1      3
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
      *                                                                                       195963
     D GEDELR          DS
     D  GFDR01                 1    250
     D  GFDR02               251    500
     D  GFDR03               501    750
     D  GFDR04               751   1000
     D  GFDR05              1001   1250
     D  GFDR06              1251   1500
     D*DELREC***     E DS                  EXTNAME(SDBROKL0)                                MD058085
     D DELREC        E DS                  EXTNAME(SDBRKJW0)                                MD058085
     D                                     PREFIX(X)                                        MD058085
     D SDBROK        E DS                  EXTNAME(SDBRKJW0)                                MD058085
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1ARSI        PARM                    WP0001            1            Audit/Request S
     C     P2RSQN        PARM                    WP0002            5            RCF sequence nu
     C     P3LEVL        PARM                    WP0003            1            Level
     C     P4ENTY        PARM                    WP0004            3            Entity
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Clear overflow indicator.
     C                   SETOFF                                       97
      * Establish starting position.
     C******LOVAL        SETLL     @A9REBC                                      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDBRKJW0                                                              MD058085
     C+ where                       A9BROK <> 'PHON' and A9BROK <> 'SWAP'                   MD058085
     C+ and   A9BROK <> 'MAIL' and A9BROK <> 'TELX'                                         MD058085
     C+ order by A9BROK                                                                     MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C/EXEC SQL                                                                             MD058085
     C+ open ACursor                                                                        MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
      * Read first record with user selection.
     C                   EXSR      GARDRC
      * Print null report headings.
     C     W0EOF         IFEQ      '1'
     C                   WRITE     ZZPAGHDR
      * USER: Null report processing
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 03 /COPY QTPFNRP - Broker Codes  *
     E* Y2V3114 - RPG source member  not found.
     C                   END                                                    *FI
     C                   WRITE     ZZENDRPT
     C                   ELSE
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
      * Initialise final totals.
     C                   MOVEL     *BLANK        ZTCON                          *CON (Screen co
     C                   Z-ADD     *ZERO         ZTNORF                         No of Records o
     C                   Z-ADD     *ZERO         ZTNCRC                         No of Calculate
      * Print report body.
     C     W0EOF         DOWEQ     '0'
      * Print headings.
     C                   EXSR      BAPRHD
      * Print report detail line.
     C                   EXSR      CAPRDT
      * Hold current values.
      * Read next record with user selection.
     C                   EXSR      GARDRC
      * Determine level changes.
     C                   EXSR      DALVCH
      * Print totals.
     C                   EXSR      EAPRTT
      * Process necessary heading requests
     C                   EXSR      FASGHD
     C                   END
     C                   WRITE     ZZENDRPT
     C                   END
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
      * Exit program.
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *****************************************************************
      /EJECT
     CSR   BAPRHD        BEGSR
      *================================================================
      * Print report Headers.
      *================================================================
      * Clear column headings control flag.
     C                   MOVEL     *BLANK        BAPR              1
      *
     C     L0            IFEQ      'Y'
     C                   WRITE     ZZPAGHDR
     C                   MOVEL     'Y'           BAPR
     C                   END
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   CAPRDT        BEGSR
      *================================================================
      * Print report detail line.
      *================================================================
      * Load detail line.
     C                   MOVEL     A9ACBC        XRACBC                         Auto-Confs - Br
     C                   Z-ADD     A9LCD         XRLCD                          Last Change Dat
     C                   MOVEL     A9TYLC        XRTYLC                         Type of Last Ch
     C                   MOVEL     A9BROK        XRBROK                         Broker Code
     C                   MOVEL     A9BRCY        XRBRCY                         Broker Currency
     C                   MOVEL     A9BKNM        XRBKNM                         Broker Name
     C                   MOVEL     A9BRTN        XRBRTN                         Broker Town
     C                   MOVEL     A9ACBC        XRAUBC                         Auto-Confs - Br05501
     C                   MOVEL     A9EBS         XREBS                          Electronic Brok12537
     C                   MOVEL     *BLANK        XRACDT                         alpha change da
     C                   MOVEL     *BLANK        XRALCH                         alpha of last c
     C                   MOVEL     *BLANK        XRWNFF                         Window Function
     C                   MOVEL     *BLANK        XRWNF1                         Window Function
     C                   MOVEL     *BLANK        XRWNF2                         Window Function
     C                   MOVEL     'Y'           W0PFM
      * USER: Process detail record
     C                   MOVEL     P1ARSI        WUARSI                         Audit/Request S
      * Process Detail Rec PRTFIL
     C     A9TYLC        IFNE      'D'
     C                   ADD       1             WUWKNB                         work number
     C                   ENDIF
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      @CN(02)                                      *IF
      *CASE:     PAR.Last Change Date NE WRK.run day number
     C     XRLCD         IFNE      WURDNB                                       *IF
     C                   MOVEL     @CN(03)       W0PFM                          *Print format
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     PGM.*Print format is Print format
     C     W0PFM         IFEQ      @CN(01)                                      *IF
     C                   ADD       1             ZTNCRC                         No of Calculate
      *CASE:     PAR.No of Calculated Recs is Equal 1
     C     ZTNCRC        IFEQ      1                                            *IF
      * Change Print Control to Y - Standing Data Controls  *
     C*
     C* Set Print Control To Y To Enable Column Headers To Be
     C*             Printed On First Record..
     C*
     C                   MOVEL     'Y'           BAPR              1
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      XRLCD         WQ0001            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0002            1            Date format fla
     C     WUWCDT        PARM      *ZERO         WQ0003            6 0          Work Converted
     C     XRACDT        PARM      *BLANK        WQ0004            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * PAR.alpha of last change = Condition name of PAR.Type of Last Change
     C                   CALL      'Y2RVCNR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100584       Y2LSNO            7 0          List number
     C                   PARM      XRTYLC        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     XRALCH        PARM                    W0CNNM           25            alpha of last c
      *
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 04 /COPY QTPFPDR - Broker Codes  *
     E* Y2V3114 - RPG source member  not found.
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * Print column headings if required.
     C     BAPR          IFEQ      'Y'
     C                   WRITE     ZZCOLHDG
     C                   MOVEL     *BLANK        BAPR
     C                   END
     C                   MOVEL     '0'           *IN79
     C     XRWNFF        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     XRWNF1        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     XRWNF2        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
      * Print detail line.
     C                   WRITE     ZZDTLRCD
     C/COPY WNCPYSRC,SD0070PC01
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DALVCH        BEGSR
      *================================================================
      * Detect level changes.
      *================================================================
      * Clear all level breaks.
     C                   MOVEL     *BLANK        L0                             Page headings
      * Clear heading length to print.
     C                   Z-ADD     *ZERO         @$HDL
      *
      * End of file - Signal all level breaks.
     C     W0EOF         IFEQ      '1'
     C                   ELSE
      * Adjust for column headings.
     C     @$HDL         IFGT      *ZERO
     C                   ADD       3             @$HDL
     C                   END
      *
     C                   END
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   EAPRTT        BEGSR
      *================================================================
      * Print report Totals.
      *================================================================
      * Print level break totals as required
      * End of file - Print final totals.
     C     W0EOF         IFEQ      '1'
     C                   MOVEL     'Y'           W0PFM
      * USER: Process End of Report
      *CASE:     CUR.No of Calculated Recs is Compare to Zero
     C     ZTNCRC        IFEQ      *ZERO                                        *IF
     C                   MOVEL     @CN(04)       WUALZR                         Alpha Zero
     C                   END                                                    *FI
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     P1ARSI        IFEQ      @CN(02)                                      *IF
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
     C                   EXSR      SARVGN
      *CASE:     WRK.work number NE WRK.No of Records on file
     C     WUWKNB        IFNE      WUNORF                                       *IF
     C                   MOVEL     @CN(03)       WUWFLG                         work flag
     C                   END                                                    *FI
      * Start of Fix BHF399
      * Audit printfile override - Standing Data Controls  *
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(07)       WQ0005           10            *PROGRAM
     C                   PARM      WUWFLG        WQ0006            1            work flag
     C                   PARM      WUNORI        WQ0007            5 0          No of Records I
     C                   PARM      WUNORA        WQ0008            5 0          No of Records A
     C                   PARM      WUNORD        WQ0009            5 0          No of records D
     C                   PARM      WUWKNB        WQ0010            5 0          work number
     C                   PARM      WUNORF        WQ0011            5 0          No of Records o
     C                   PARM      WUAURT        WQ0012           53            Audit/Request T
     C                   PARM      WUBJNA        WQ0013           53            Underline
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      * End of Fix BHF399
      *CASE:     PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      @CN(06)                                      *IF
      * Database Error U7 U8 - Standing Data Controls  *
     C*
     C** DATABASE ERROR, SET ON SWITHES U7 AND U8
     C*
     C                   SETON                                        U7U8
     C*
     C                   ELSE
      *CASE:     WRK.work flag is Incorrect
     C     WUWFLG        IFEQ      @CN(03)                                      *IF
      * File Control Error U8 - Standing Data Controls  *
     C*
     C** FILE CONTROLS OUT OF BALANCE SETON U8
     C*
     C                   SETON                                            U8
     C*
     C                   ELSE
      *CASE:     PGM.*Return code is *Field attribute types EX
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   ELSE
      *CASE:     *OTHERWISE
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 05 /COPY QTPFPER - Broker Codes  *
     E* Y2V3114 - RPG source member  not found.
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * If there is not enough space on the
      * physical page for this format:-
     C     @$PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      4
      * Signal artificial overflow.
     C                   SETON                                        97
      * Print page headers.
     C                   WRITE     ZZPAGHDR
     C                   END
     C                   MOVEL     '0'           *IN76
     C     WUALZR        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
      * Print format.
     C                   WRITE     ZZFINTTL
     C                   END
     C                   END
      *
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   FASGHD        BEGSR
      *================================================================
      * Signal required header formats.
      *================================================================
      * Cascade skip to new page requests upwards.
      *
     C     *IN97         IFNE      '1'
     C     L0            ANDNE     'Y'
      * Signal overflow if requested headings would cause
      * detail format to start past the overflow line.
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   ELSE
      * Signal overflow if requested headings would cause
      * detail format to be printed past end of page
     C                   ADD       5             @$HDL
     C     W0PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   END
     C                   END
     C                   END
      * Overflow detected.
     C     *IN97         IFEQ      '1'
      * Request page headings.
     C                   MOVEL     'Y'           L0
      * Request all formats which print on overflow.
     C                   SETOFF                                       97
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GARDRC        BEGSR
      *================================================================
      * Read next record with user selection.
      *================================================================
     C     W0RSL         DOUEQ     'Y'
     C**********         READ      @A9REBC                                90    *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDBROK                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        90                    MD058085
     C                   Endif                                                              MD058085
     C     *IN90         IFEQ      '1'
     C     P1ARSI        ANDEQ     'A'
     C                   READ      @DELREC                                89
     C                   MOVEL     *IN89         W0EOF
     C                   ELSE
     C                   MOVEL     *IN90         W0EOF             1
     C                   ENDIF
      * Quit if no record read.
     C     W0EOF         CABEQ     '1'           GAEXIT
      * Select record unless user action states otherwise.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Record selection processing
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 02 /COPY QTPFRSP - Broker Codes  *
     E* Y2V3114 - RPG source member  not found.
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    AHFLNM                         Filename
      * Move fields to key list.
     C                   MOVEL     @CN(05)       AHFLNM                         Filename
     C     KRSSA         CHAIN     @AHREAV                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0020'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(06)       W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   Z-ADD     AHNORC        WUNORF                         No. of Records
     C                   Z-ADD     AHNOIN        WUNORI                         No. of Inserts
     C                   Z-ADD     AHNOAM        WUNORA                         No. of Amends
     C                   Z-ADD     AHNODL        WUNORD                         No. of Deletes
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(05)       AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C     KLCHSB        CHAIN     @AHREAU                            9091      *
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     *ZERO         AHNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         AHNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         AHNODL                         No. of Deletes
      *
     C                   UPDATE    @AHREAU                              91      *
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get Bank Title - Bank Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSC         KLIST
     C                   KFLD                    BJBANK                         Bank
      * Move fields to key list.
     C                   MOVEL     @CN(09)       BJBANK                         Bank
     C     KRSSC         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(06)       W0RTN                          *Return code
      * Setup message data for message.
     C                   MOVEL     @CN(10)       ZA0001                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     BJURPT        WUURPT                         User Report Tit
     C                   END
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
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
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program
      *================================================================
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
     C/EXEC SQL                                                                             MD058085
     C+ close ACursor                                                                       MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
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
      * Define work field S01212
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Audit/Request Status Ind
     C                   MOVEL     *BLANK        WUARSI            1
      * Define work field work number
     C                   Z-ADD     *ZERO         WUWKNB            5 0
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Work Converted Date
     C                   Z-ADD     *ZERO         WUWCDT            6 0
      * Define work field Alpha Zero
     C                   MOVEL     *BLANK        WUALZR            1
      * Define work field No of Records on file
     C                   Z-ADD     *ZERO         WUNORF            5 0
      * Define work field No of Records Inserted
     C                   Z-ADD     *ZERO         WUNORI            5 0
      * Define work field No of Records Amended
     C                   Z-ADD     *ZERO         WUNORA            5 0
      * Define work field No of records Deleted
     C                   Z-ADD     *ZERO         WUNORD            5 0
      * Define work field work flag
     C                   MOVEL     *BLANK        WUWFLG            1
      * Define work field Audit/Request Title
     C                   MOVEL     *BLANK        WUAURT           53
      * Define work field Underline
     C                   MOVEL     *BLANK        WUBJNA           53
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field User Report Title
     C                   MOVEL     *BLANK        WUURPT           53
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Spool file name
     C                   MOVEL     *BLANK        WUSFNM           10
      * Define work field Spool file number
     C                   Z-ADD     *ZERO         WUSFNB            6 0
      * Define work field ZSFILE error
     C                   MOVEL     *BLANK        WUZSER            1
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @$WRK             4 0
     C                   Z-ADD     *ZERO         @$HDL             4 0
      * Adjust page length and overflow as necessary.
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   END
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Last Amend Box SD0070P - Broker Codes  *
      * Copyright Statement - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*********************MOVE AANA      ##AANA                          S01229
     C*********************MOVE AANA      #OAANA                          S01229
     C*********************MOVE AKTX      #OAKTX                          S01229
     C*********************MOVE AUST      #OAUST                          S01229
     C*********************MOVE E3ST      #OE3ST                          S01229
     C*********************MOVE F1ST      #OF1ST                          S01229
     C                   MOVE      MRDT          ##MRDT                         RUN DATE       S0122
     C                   MOVE      MRDT          WUMRDT                                        S0122
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.     S0122
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT  S0122
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG   S0122
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND  S0122
      * Get Title
      * Get Bank Title - Bank Details  *
     C                   EXSR      SCRVGN
      * Move title to header - *Standard header/footer  *
     C* 7.10.89 Missing Source - Inserted During Incorporation            S01216
     C* Move User Report Title into Header Field in DDS for PRTF          S01216
     C*                                                                   S01216
     C*********************MOVE #IURPT    ##AGNA                   S01216 S01229
     C                   MOVE      WUURPT        ##URPT                                 S01216 S0122
      * Get Narrative Title - Narrative Codes  *
     C     *IN99         IFEQ      '1'
     C                   MOVE      1             UIND              1 0
     C                   SETOFF                                           99
     C                   ELSE
     C                   MOVE      0             UIND
     C                   END
      *
      ** CALCULATE END OF TEXT POINT
     C                   Z-ADD     1             U                 2 0
     C*********************MOVEA#IBINA    UAR,U
     C                   MOVEA     @CN(11)       UAR(U)
     C*
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(U)                                 99
     C                   ADD       1             U
     C     UAR(U)        COMP      ' '                                    99
     C                   END
      *
     C**
     C*
     C*          P1LSST    IFEQ 'A'                                       S01216
     C***********P1NEST    IFEQ 'A'                                S01216 S01117
     C     P1ARSI        IFEQ      'A'                                                         S0111
     C*********************MOVELUARRAY,1  UTEMP  26                       LN0536
     C                   MOVEL     UARRAY(1)     UTEMP            53                           LN053
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       26            U
     C                   ELSE
      *
     C                   MOVEL     UARRAY(2)     UTEMP                                         LN053
     C*********************MOVEAUARRAY,2  UAR,U            * IF A THIRD   LN0536
     C                   MOVEA     UTEMP         UAR(U)                         * IF A THIRD   LN053
     C                   ADD       7             U                              OPTION TO ARRAY
     C                   END                                                    IS ADDED A
      *                                                    TEMP STORAGE
      *                                                    * IS REQUIRED.
      **  STORE  TEXT IN USTORE FIELD
      *
     C                   MOVEA     UAR           USTORE           53
     C                   MOVE      *BLANKS       UAR
      *
      *
      *
     C     53            SUB       U             UB                2 0
     C     UB            DIV       2             UB
     C                   MVR                     UR                1 0
     C     UB            ADD       U             U
     C     U             SUB       1             U
      *
      *
      **  INSERT UNDERLINE TO ARRAY
      **
     C                   MOVEA     *ALL'-'       ULN(UB)
     C                   MOVEA     *BLANKS       ULN(U)
      *
      *
     C     UB            IFGT      0
     C                   MOVEA     USTORE        UAR(UB)
     C                   ELSE
     C                   MOVEA     USTORE        UAR
     C                   END
      *
      **  MOVE ARRAY VALUE  TO SCREEN TEXT FIELD
      *
     C*                    MOVEAUAR       ##EYTX                          S01216
     C*********************MOVEAUAR       ##E8TX 53                 S01216S01117
     C                   MOVEA     UAR           ##AURT           53                     S01216S0111
     C*                    MOVEAUAR       WUEYTX
     C*********************MOVEAUAR       WUE8TX                          S01117
     C                   MOVEA     UAR           WUAURT                                        S0111
     C*                    MOVEAULN       ##BJNA                          S01216
     C                   MOVEA     ULN           ##BJNA           53                           S0121
     C                   MOVEA     ULN           WUBJNA
      *
      *
      ** RESET INDICATOR *IN 99
      *
     C     UIND          IFEQ      1
     C                   SETON                                            99
     C                   ELSE
     C                   SETOFF                                           99
     C                   END
      *
      * ZSFILE - log spool file - Standard Functions  *
     C*
     C* Set up spool file number - Standard Functions  *
     C                   Z-ADD     @$FNB         WUSFNB
     C*
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C                   PARM      P2RSQN        UURSQN            5            RCF sequence nu
     C                   PARM      P4ENTY        UUENTY            3            Entity
     C                   PARM      @$FVN         UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file numb
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C     *IN90         IFEQ      '1'
     C* Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
     C*
     C* CASE: WRK.ZSFILE is error occurred
     C*
     C*          #OZSER    IFEQ 'Y'
     C*                    MOVEL'Y2U0004' P0RTN
     C*                    EXSR ZYEXPG
     C*                    END
      *CASE:     WRK.ZSFILE error is Error Occured
     C     WUZSER        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(12)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     @CN(01)       WUMFTS                         S01212
      *CASE:     WRK.S01212 is Fix installed
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 01 /COPY QTPFF,E,I,C,OPG - Broker Codes  *
     C/COPY WNCPYSRC,SD0070PC02
     E* Y2V3114 - RPG source member  not found.
     C     P1ARSI        IFEQ      'A'
     C                   MOVEL     'SDBROKPD'    KEYF             10
     C     KEYF          SETLL     @DELRL1
     C     KEYF          READE     @DELRL1                                20
     C     *IN20         DOWEQ     '0'
     C     GFFNME        ANDEQ     KEYF
     C                   MOVEL     GEDELR        DELREC
     C                   Z-ADD     GFLCD         A9LCD
     C                   MOVE      GFTYLC        A9TYLC
     C                   WRITE     SDBROKD0
     C                   READ      @DELRL1                                20
     C                   ENDDO
     C                   ENDIF
     C                   END                                                    *FI
      *================================================================
     CSR   ZZEXIT        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA UARRAY
MAINTENANCE - AUDIT REPORT
LISTING
**CTDATA @CN
Y
A
N
0
SDBROKPD
Y2U0005
SD0070AU
Y2U0021
BANK
SDBANKPD
BROKER CODES
Y2U0004
