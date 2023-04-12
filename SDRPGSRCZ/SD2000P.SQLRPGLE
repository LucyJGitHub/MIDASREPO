     H DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058830
/*STD *  RPGSQLBND                                                    *                     MD058830
/*EXI *  TEXT('Midas SD Network Descrip Maint Rep')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2000P - Network Descrip Maint Rep Print file               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD061022           Date 07Feb23               *
      *                 MD058830           Date 01Oct21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 XNNNNN  *CREATE    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD061022 - Missing delivery of program for MD058830          *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *  nnnnnn - (fix details)                                       *
      *                                                               *
      *================================================================
     F* Maintenance   :
      *================================================================
     F*00/Copy Member SD2000P   Initialise Program F-Spec
     F/COPY WNCPYSRC,SD2000PFPG
     F*SDNWRKL1* IF   E           K DISK                                                    MD058830
      * RTV: Message Network Details   Retrieval index
      *
     F*SDFCTLL1* IF   E           K DISK                                                    MD061007
      * RTV: Standing Data Controls    Retrieval index
      *
     FSDBANKL1  IF   E           K DISK
      * RTV: Bank Details              Retrieval index
      *
     F*SDFCTLL0* UF   E           K DISK                                                    MD061007
      * UPD: Standing Data Controls    Update index
      *
     FSD2000PM  O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
      * PRT: Network Descrip Maint Rep Print file
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      *
      ** SAVE INDICATOR *IN 99
      *
     D*00/Copy Member SD2000P   Initialise Program E-Spec
     D/COPY WNCPYSRC,SD2000PEPG
     D @CN             S             25    DIM(13) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*00/Copy Member SD2000P   Initialise Program I-Spec
     D/COPY WNCPYSRC,SD2000PIPG
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
     D P2PARM          DS
      * I:MAP RCF sequence number
     D  P2RSQN                 1      5
     D P3PARM          DS
      * I:MAP Level
     D  P3LEVL                 1      1
     D P4PARM          DS
      * I:MAP Entity
     D  P4ENTY                 1      3
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZA0001                 1     10
     D SDNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
                                                                                            MD061007
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
     C******LOVAL        SETLL     @EDREJZ                                      *           MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ declare ACursor insensitive scroll cursor for                                       MD058830
     C+ select * from SDNWKJW0                                                              MD058830
     C+ order by EDNWRK                                                                     MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C/EXEC SQL                                                                             MD058830
     C+ open ACursor                                                                        MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
      * Read first record with user selection.
     C                   EXSR      GARDRC
      * Print null report headings.
     C     W0EOF         IFEQ      '1'
     C                   WRITE     ZZPAGHDR
      * USER: Null report processing
      * 00/Copy Member SD2000PNRP - Message Network Details  *
     C*00/Copy Member SD2000P   Null Report Processing
     C/COPY WNCPYSRC,SD2000PNRP
     C                   WRITE     ZZENDRPT
     C                   ELSE
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
      * Initialise final totals.
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
      * Exit program.
     C                   MOVEL     *BLANK        P0RTN
     C/EXEC SQL                                                                             MD058830
     C+ close ACursor                                                                       MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
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
     C                   Z-ADD     EDLCD         XRLCD                          Last Change Dat
     C                   MOVEL     EDTYLC        XRTYLC                         Type of Last Ch
     C                   MOVEL     EDNWRK        XRNWRK                         Network
     C                   MOVEL     EDNETD        XRNETD                         Network Descrip
     C                   MOVEL     *BLANK        XRACDT                         alpha change da
     C                   MOVEL     *BLANK        XRALCH                         alpha of last c
     C                   MOVEL     *BLANK        XRWNFF                         Window Function
     C                   MOVEL     *BLANK        XRWNF1                         Window Function
     C                   MOVEL     *BLANK        XRWNF2                         Window Function
     C                   MOVEL     'Y'           W0PFM
      * USER: Process detail record
     C                   MOVEL     *BLANK        WUARRT                         Audit/Request R
     C                   MOVEL     P1ARSI        WUARRT                         Audit/Request R
      * Process Detail Rec PRTFIL
      * Start of Fix BHF950
      * This change to the standard object was required because the
      * clients file has logically deleted records and these were
      * initially being counted as records on the file - thus if there
      * were any deleted clients on the system the file controls would
      * be out of balance. This fix will not affect any other report
      * programs since there will be no records with a last change type
      * of 'D'.
      *CASE:     PAR.Type of Last Change is Not Delete
     C     XRTYLC        IFEQ      @CN(01)                                      *IF
     C     XRTYLC        OREQ      @CN(02)
     C                   ADD       1             WUWKNB                         work number
     C                   END                                                    *FI
      * End of Fix BHF950
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      @CN(01)                                      *IF
      *CASE:     PAR.Last Change Date NE WRK.run day number
     C     XRLCD         IFNE      WURDNB                                       *IF
     C                   MOVEL     @CN(03)       W0PFM                          *Print format
     C                   END                                                    *FI
     C                   END                                                    *FI
      *CASE:     PGM.*Print format is Print format
     C     W0PFM         IFEQ      @CN(04)                                      *IF
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
      * 00/Copy Member SD2000PPDR - Message Network Details  *
     C*00/Copy Member SD2000P   Process Detail Record
     C/COPY WNCPYSRC,SD2000PPDR
     C     W0PFM         IFEQ      'Y'
      * Print column headings if required.
     C     BAPR          IFEQ      'Y'
     C                   WRITE     ZZCOLHDG
     C                   MOVEL     *BLANK        BAPR
     C                   END
      * Print detail line.
     C                   WRITE     ZZDTLRCD
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
     C                   ADD       4             @$HDL
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
     C                   MOVEL     @CN(05)       WUALZR                         Alpha Zero
     C                   END                                                    *FI
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     P1ARSI        IFEQ      @CN(01)                                      *IF
      * Audit/On-Req RTV on FCTL - Standing Data Controls  *
     C                   EXSR      SARVGN
      *CASE:     WRK.work number NE WRK.No of Records on file
     C     WUWKNB        IFNE      WUNORF                                       *IF
     C                   MOVEL     @CN(03)       WUWFLG                         work flag
     C                   END                                                    *FI
      * Audit printfile override - Standing Data Controls  *
     C                   CALL      'SDC540P'                            90      Audit printfile
     C                   PARM      @CN(08)       WQ0005           10            *PROGRAM
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
      *CASE:     PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      @CN(07)                                      *IF
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
     C     W0RTN         IFEQ      @CN(09)                                      *IF
     C                   ELSE
      *CASE:     *OTHERWISE
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SBCHRC
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD2000PPER - Message Network Details  *
     C*00/Copy Member SD2000P   Process End Of Report
     C/COPY WNCPYSRC,SD2000PPER
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
     C                   MOVEL     '0'           *IN79
     C     WUALZR        IFEQ      @CN(05)                                      *IF
     C                   MOVEL     '1'           *IN79
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
     C                   ADD       4             @$HDL
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
     C**********         READ      @EDREJZ                                90    *
     C/EXEC SQL                                                                             MD058830
     C+ fetch next from ACursor into :SDNWRK                                                MD058830
     C/END-EXEC                                                                             MD058830
                                                                                            MD058830
     C                   setoff                                       90                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   seton                                        90                    MD058830
     C                   Endif                                                              MD058830
     C                   MOVEL     *IN90         W0EOF             1
      * Quit if no record read.
     C     W0EOF         CABEQ     '1'           GAEXIT
      * Select record unless user action states otherwise.
     C                   MOVEL     'Y'           W0RSL             1
      * USER: Record selection processing
      * 00/Copy Member SD2000PRSP - Message Network Details  *
     C*00/Copy Member SD2000P   Record Selection Proc.
     C/COPY WNCPYSRC,SD2000PRSP
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
     C                   MOVEL     @CN(06)       AHFLNM                         Filename
     C*****KRSSA         CHAIN     @AHREAV                            90        *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       90                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0020'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(07)       W0RTN                          *Return code
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
     C                   MOVEL     @CN(06)       AHFLNM                         Filename
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSB        CHAIN     @AHREAU                            9091      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       9091                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        90                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
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
     C**********         UPDATE    @AHREAU                              91      *           MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       91                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        91                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
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
     C                   MOVEL     @CN(10)       BJBANK                         Bank
     C     KRSSC         CHAIN     @BJREEF                            90        *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(07)       W0RTN                          *Return code
      * Setup message data for message.
     C                   MOVEL     @CN(11)       ZA0001                         Filename
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
      * Define work field Audit/Request Rpt Title
     C                   MOVEL     *BLANK        WUARRT           21
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
      * Copyright Statement - Standard Functions  *
      * Last amend box SD2000P - Message Network Details  *
     E* Y2V3114 - RPG source member  not found.
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
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
     C                   MOVEA     @CN(12)       UAR(U)
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
     C                   MOVE      *BLANKS       UUSRSQ            5                           LN072
     C*
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C*********************PARM #IRSQN    UURSQN  5        RCF sequence nuLN0721
     C     UUSRSQ        PARM      P2RSQN        UURSQN            5            RCF sequence nuLN072
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
     C     WUZSER        IFEQ      @CN(04)                                      *IF
     C                   MOVEL     @CN(13)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * 00/Copy Member SD2000PFPG - Message Network Details  *
      * 00/Copy Member SD2000PEPG - Message Network Details  *
      * 00/Copy Member SD2000PIPG - Message Network Details  *
      * 00/Copy Member SD2000PCPG - Message Network Details  *
     C*00/Copy Member SD2000P   Initialise Program C-Spec
     C/COPY WNCPYSRC,SD2000PCPG
      * 00/Copy Member SD2000POPG - Message Network Details  *
      *================================================================
     CSR   ZZEXIT        ENDSR
     O*00/Copy Member SD2000P   Initialise Program O-Spec
     O/COPY WNCPYSRC,SD2000POPG
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA UARRAY
MAINTENANCE - AUDIT REPORT
LISTING
**CTDATA @CN
A
I
N
Y
0
SDNWRKPD
Y2U0005
SD2000AU
Y2U0021
BANK
SDBANKPD
NETWORK MAINT REPORT
Y2U0004
