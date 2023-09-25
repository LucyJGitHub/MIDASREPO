     H DEBUG
     F********************************************************************
/**** *  RPGBASE                                                      *                     MD058085
/*STD *  RPGSQLBND                                                    *                     MD058085
/*EXI *  TEXT('Midas SD CI Transaction Type Report')
     F********************************************************************
     F*                                                                  *
     F*  Midas - STANDING DATA MODULES                                   *
     F*                                                                  *
     F*   SD1220P - Cashier Interface Transaction Type Report            *
     F*                                                                  *
     F*  Function:  This program prints the records on the BAI           *
     F*             Configuration Details File.                          *
     F*                                                                  *
     F*  Called By:-                                                     *
     F*              FCC0202 Input Cycle On Request                      *
     F*              FCC0204 COB On Request                              *
     F*              SD0541X COB Audit                                   *
     F*                                                                  *
     F*     (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD061008           Date 31Dec21               *
      *  Prev Amend No. MD058085           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
     F*                    CRT003 *CREATE     DATE 22Jul96               *
     F*                    000000             DATE ddmmyy                *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD061008 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058085 - Deliverable Data Split for Standing Data          *
     F*  MD046248 - Finastra Rebranding                                  *
     F*  CRT003 - Cashier Interface                                      *
     F*                                                                  *
     F********************************************************************
     F*
     F/COPY WNCPYSRC,SD1220PFPG
     F*
     F*SDBAITL1* IF   E           K DISK                                                    MD058085
      * RTV: CI Configuration Details  Retrieval index
      *
     F*SDFCTLL1* IF   E           K DISK                                                    MD061008
      * RTV: Standing Data Controls    Retrieval index
      *
     FSDBANKL1  IF   E           K DISK
      * RTV: Bank Details              Retrieval index
      *
     F*SDFCTLL0* UF   E           K DISK                                                    MD061008
      * UPD: Standing Data Controls    Update index
      *
     FSD1220PM  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
     D/EJECT
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      *
      ** SAVE INDICATOR *IN 99
      *
     D/COPY WNCPYSRC,SD1220PEPG
     D @CN             S             25    DIM(11) CTDATA PERRCD(1)             Long constants.
     D/COPY WNCPYSRC,SD1220PIPG
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
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      /EJECT
      * Parameter declarations.
     D P1PARM          DS
      * I:    Audit/Request Status Ind
     D  P1ARSI                 1      1
     D*
     D P2PARM          DS
     D* I:    Sequence number
     D  P2RSQN                 1      5
     D*
     D P3PARM          DS
     D* I:    Entity
     D  P3ENTY                 1      3
     D*
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
     D SDBAIT        E DS                  EXTNAME(SDBATJW0)                                MD058085
     D QSDFC1          DS                                                                   MD061008
     D  AHFLNM                 1     10                                                     MD061008
     D  AHNORC                11     13P 0                                                  MD061008
     D  AHNOIN                14     16P 0                                                  MD061008
     D  AHNOAM                17     19P 0                                                  MD061008
     D  AHNODL                20     22P 0                                                  MD061008
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST                                                  Entry parameter
     C                   PARM                    P0RTN             7            Return code
     C     P1ARSI        PARM                    WP0001            1            Audit/Request S
     C     P2RSQN        PARM                    WP0002            5            Sequence number
     C                   PARM                    @@PARM            1            Dummy Parm
     C     P3ENTY        PARM                    WP0003            3            Entity
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Clear overflow indicator.
     C                   SETOFF                                       97
      * Establish starting position.
     C******LOVAL        SETLL     @BAITL1                                      *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ declare ACursor insensitive scroll cursor for                                       MD058085
     C+ select * from SDBATJW0                                                              MD058085
     C+ order by FXBAIT                                                                     MD058085
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
      *
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 03 /COPY QPPFNRP - Configuration Details  *
     C*
     C/COPY WNCPYSRC,SD1220PNRP
     C*
     C                   END                                                    *FI
     C                   WRITE     ZZENDRPT
     C                   ELSE
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
      * Initialise final totals.
     C                   MOVEL     *BLANK        ZTCON                          *CON (Screen co
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
     C                   Z-ADD     FXLCD         PSLCD                          Last Change Dat
     C                   MOVE      FXTYLC        PSTYLC                         Type of Last Ch
     C                   MOVE      FXBAIT        PSBAIT                         BAI
     C                   MOVEL     FXTXDS        PSTXDS                         BAI ce Descript
     C                   MOVE      FXTTFC        PSTTFC                         Brch of Locatio
     C                   MOVE      FXDQNM        PSDQNM                         Brch of Locatio
     C*
     C                   MOVEL     *BLANK        PSACDT                         alpha change da
     C                   MOVEL     *BLANK        PSALCH                         alpha of last c
     C                   MOVEL     *BLANK        PSWFFR                         Window Function
     C                   MOVEL     *BLANK        PSWF1R                         Window Function
     C                   MOVEL     *BLANK        PSWF2R                         Window Function
     C                   MOVEL     'Y'           W0PFM
     C*
     C/COPY WNCPYSRC,SD1220PCP1
     C*
      * USER: Process detail record
     C                   MOVEL     P1ARSI        WUARSI                         Audit/Request S
      * Process Detail Rec PRTFIL
     C                   ADD       1             WUWKNB                         work number
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      @CN(02)                                      *IF
      *CASE:     PAR.Last Change Date NE WRK.run day number
     C     PSLCD         IFNE      WURDNB                                       *IF
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
     C                   PARM      PSLCD         WQ0001            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0002            1            date format fla
     C     WUWCDT        PARM      *ZERO         WQ0003            6 0          Work Converted
     C     PSACDT        PARM      *BLANK        WQ0004            7            Work Alpha Date
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
     C                   PARM      PSTYLC        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     PSALCH        PARM                    W0CNNM           25            alpha of last c
      *
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 04 /COPY QPPFPDR - Configuration Details  *
     C*
     C/COPY WNCPYSRC,SD1220PPDR
     C*
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * Print column headings if required.
     C     BAPR          IFEQ      'Y'
     C                   WRITE     ZZDTLHDR
     C                   MOVEL     *BLANK        BAPR
     C                   END
      * Convert fields to external form.
     C                   MOVEL     '0'           *IN79
     C     PSWFFR        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN79
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN78
     C     PSWF1R        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN78
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN77
     C     PSWF2R        IFEQ      *BLANK                                       *IF
     C                   MOVEL     '1'           *IN77
     C                   END                                                    *FI
      * Print detail line.
     C                   WRITE     ZZDTLRCD
     C*
     C/COPY WNCPYSRC,SD1220PCP2
     C*
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
     C                   ADD       2             @$HDL
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
      * Audit printfile override - Standing Data Controls  *
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(07)       WQ0005           10            *PROGRAM
     C                   PARM      WUWFLG        WQ0006            1            work flag
     C                   PARM      WUNORI        WQ0007            5 0          No of Records I
     C                   PARM      WUNORA        WQ0008            5 0          No of Records A
     C                   PARM      WUNORD        WQ0009            5 0          No of records D
     C                   PARM      WUWKNB        WQ0010            5 0          work number
     C                   PARM      WUNORF        WQ0011            5 0          No of Records o
     C                   PARM      WUARTL        WQ0012           53            Audit/Request T
     C                   PARM      WUUNDL        WQ0013           53            Underline
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
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
      *
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 05 /COPY QPPFPER - Configuration Details  *
     C*
     C/COPY WNCPYSRC,SD1220PPER
     C*
     C                   END                                                    *FI
     C     W0PFM         IFEQ      'Y'
      * If there is not enough space on the
      * physical page for this format:-
     C     @$PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      3
      * Signal artificial overflow.
     C                   SETON                                        97
      * Print page headers.
     C                   WRITE     ZZPAGHDR
     C                   END
     C                   MOVEL     '0'           *IN76
     C     WUALZR        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     '1'           *IN76
     C                   END                                                    *FI
     C                   MOVEL     '0'           *IN75
     C     WUWFLG        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     '1'           *IN75
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
     C                   ADD       2             @$HDL
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
     C**********         READ      @BAITL1                                90    *           MD058085
     C/EXEC SQL                                                                             MD058085
     C+ fetch next from ACursor into :SDBAIT                                                MD058085
     C/END-EXEC                                                                             MD058085
                                                                                            MD058085
     C                   setoff                                       90                    MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   seton                                        90                    MD058085
     C                   Endif                                                              MD058085
                                                                                            MD058085
     C                   MOVEL     *IN90         W0EOF             1
      * Quit if no record read.
     C     W0EOF         CABEQ     '1'           GAEXIT
      * Select record unless user action states otherwise.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Record selection processing
      *
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 02 /COPY QPPFRSP - Configuration Details  *
     C*
     C/COPY WNCPYSRC,SD1220PRSP
     C*
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
     C*****KRSSA         CHAIN     @AHREAV                            90        *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       90                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
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
     C*****KLCHSB        CHAIN     @AHREAU                            9091      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM      0             AHNORC                                     MD061008
     C                   PARM      0             AHNOIN                                     MD061008
     C                   PARM      0             AHNOAM                                     MD061008
     C                   PARM      0             AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       9091                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        90                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
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
     C                   Z-ADD     WUNORF        AHNORC                         No. of Records
     C                   Z-ADD     *ZERO         AHNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         AHNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         AHNODL                         No. of Deletes
      *
     C**********         UPDATE    @AHREAU                              91      *           MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       91                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        91                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
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
      *
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      * Setup job date/time.
     C                   Z-ADD     UDATE         ##JDT                          Job date.
     C                   TIME                    ##JTM                          Job time.
     C                   TIME                    ##TME             6 0          Screen time.
      *
     C                   MOVEL     *BLANK        WUMFTS            1
      * Define work field Audit/Request Status Ind
     C                   MOVEL     *BLANK        WUARSI            1
      * Define work field work number
     C                   Z-ADD     *ZERO         WUWKNB            5 0
      * Define work field run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field date format flag
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
     C                   MOVEL     *BLANK        WUARTL           53
      * Define work field Underline
     C                   MOVEL     *BLANK        WUUNDL           53
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field midas rundate
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Define work field User Report Title
     C                   MOVEL     *BLANK        WUURPT           53
     C* Define work field ZSFILE error
     C                   MOVEL     *BLANK        WUZSER            1
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
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
      * Last Amend Hdr Box QPPF - Configuration Details  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
      * Get Title
      * Get Bank Title - Bank Details  *
     C                   EXSR      SCRVGN
      *
     C                   MOVE      WUURPT        ##URPT
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
     C                   MOVEA     @CN(11)       UAR(U)
     C*
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(U)                                 99
     C                   ADD       1             U
     C     UAR(U)        COMP      ' '                                    99
     C                   END
      *
     C*          P1LSST    IFEQ 'A'
     C     P1ARSI        IFEQ      'A'
     C                   MOVEL     UARRAY(1)     UTEMP            26
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       26            U
     C                   ELSE
      *
     C                   MOVEA     UARRAY(2)     UAR(U)                         * IF A THIRD
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
     C*                    MOVEAUAR       ##EYTX
     C                   MOVEA     UAR           ##ARTL           53
     C*                    MOVEAUAR       WUEYTX
     C                   MOVEA     UAR           WUARTL
     C*                    MOVEAULN       ##BJNA
     C                   MOVEA     ULN           ##UNDL           53
     C                   MOVEA     ULN           WUUNDL
      *
      *
      ** RESET INDICATOR *IN 99
      *
     C     UIND          IFEQ      1
     C                   SETON                                            99
     C                   ELSE
     C                   SETOFF                                           99
     C                   END
     C*
     C*
     C** Set up spool file number - Standard functions *
     C*
     C                   Z-ADD     @$FNB         WUSFNB            6 0
     C*
     C** ZSFILE - write report rqs - Standard functions *
     C*
     C                   CALL      'ZSFILE'                             90
     C                   PARM      P2RSQN        UURSQN            5            RCF seq no.
     C                   PARM      P3ENTY        UUENTY            3            Entity
     C                   PARM      @$FVN         UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file no.
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C** Call to program ended in error
     C*
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
     C*
     C** CASE: WRK.ZSFILE is error occurred
     C*
     C     WUZSER        IFEQ      'Y'
     C                   MOVEL     'Y2U0004'     P0RTN
     C                   EXSR      ZYEXPG
     C                   END
     C*
      *
     C                   MOVEL     @CN(01)       WUMFTS
      *
     C     WUMFTS        IFEQ      @CN(01)                                      *IF
      * 01 /COPY QPPFF,E,I,C,OPG - Configuration Details  *
     C/COPY WNCPYSRC,SD1220PCPG
     C                   END                                                    *FI
      *================================================================
     CSR   ZZEXIT        ENDSR
     O/COPY WNCPYSRC,SD1220POPG
**   ARRAY ENTRIES FOR REPORT TITLE
MAINTENANCE - AUDIT REPORT
LISTING
** @CN Long constants used in program.
Y
A
N
0
SDBAITPD
Y2U0005
SD1220AU
Y2U0021
BANK
SDBANKPD
CI TRANSACTION TYPES
