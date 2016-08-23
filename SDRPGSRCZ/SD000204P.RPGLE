     H DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Withholding Tax Rate Code Report')            *   
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000204P - Withholding Tax Rate Code Report                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CGL165  *CREATE    Date 17Feb15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Withholding Tax Enhancement                         *
      *                                                               *
      *****************************************************************
     FSDWTRCL1  IF   E           K DISK
     F                                     RENAME(SDWTRCD0:SDWTRCD2)
      ** RTV: Withholding Tax Rate Codes        Retrieval index
      *
     FSDFCTLL1  IF   E           K DISK
      ** RTV: Standing Data Controls    Retrieval index
      *
     FSDBANKL1  IF   E           K DISK
      ** RTV: Bank Details              Retrieval index
      *
     FSDFCTLL0  UF   E           K DISK
      ** UPD: Standing Data Controls    Update index
      *
     FSD000204P1O    E             PRINTER OFLIND(*IN97)
     F                                     INFDS(INFDS$)
      ** PRT: Midas SD Withholding Tax Rate Codes Request
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      ** Save Indicator *IN 99
      *
     D @CN             S             40    DIM(12) CTDATA PERRCD(1)
      *
      ** Description     : Copyright notice for inclusion in all programs
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Data structures:-
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      ** Program data structure.
      *
     D JBDTTM          DS
      ** Job date/time.
      *
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS$        E DS                  EXTNAME(Y2I$DSP)
      ** Printer file information data structure.
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Printer file information data structure.
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long data structure for access program.
      *
     D A@CPY           DS
      ** Copyright array
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Parameter declarations.
      *
     D P1PARM          DS
      ** I:    Audit/Request Status Ind
      *
     D  P1ARSI                 1      1
     D P2PARM          DS
      ** I:    RCF sequence number
      *
     D  P2RSQN                 1      5
     D P3PARM          DS
      ** I:    Level
      *
     D  P3LEVL                 1      1
     D P4PARM          DS
      ** I:    Entity
      *
     D  P4ENTY                 1      3
     D                 DS
     D  ZAMSDA                 1    132
      ** Message data for 'Database Error (ICD)'
      ** Filename
      *
     D  ZA0001                 1     10
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ARSI        PARM                    WP0001            1
     C     P2RSQN        PARM                    WP0002            5
     C     P3LEVL        PARM                    WP0003            1
     C     P4ENTY        PARM                    WP0004            3
      *
      ** Initialise
      *
     C                   EXSR      ZZINIT
      *
      ** Clear overflow indicator.
      *
     C                   SETOFF                                       97
      *
      ** Establish starting position.
      *
     C     *LOVAL        SETLL     SDWTRCD2
      *
      ** Read first record with user selection.
      *
     C                   EXSR      GARDRC
      *
      ** Print null report headings.
      *
     C     W0EOF         IFEQ      '1'
     C                   WRITE     ZZPAGHDR
      *
      ** USER: Null report processing
      *
     C                   WRITE     ZZENDRPT
     C                   ELSE
      *
      ** Request all headings.
      *
     C                   MOVEL     'Y'           L0                1
      *
      ** Initialise final totals.
      *
     C                   MOVEL     *BLANK        ZTCON
     C                   Z-ADD     *ZERO         ZTNORF
     C                   Z-ADD     *ZERO         ZTNCRC
      *
      ** Print report body.
      *
     C     W0EOF         DOWEQ     '0'
      *
      ** Print headings.
      *
     C                   EXSR      BAPRHD
      *
      ** Print report detail line.
      *
     C                   EXSR      CAPRDT
      *
      ** Hold current values.
      ** Read next record with user selection.
      *
     C                   EXSR      GARDRC
      *
      ** Determine level changes.
      *
     C                   EXSR      DALVCH
      *
      ** Print totals.
      *
     C                   EXSR      EAPRTT
      *
      ** Process necessary heading requests
      *
     C                   EXSR      FASGHD
     C                   END
     C                   WRITE     ZZENDRPT
     C                   END
      *
      ** Exit program.
      *
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   BAPRHD        BEGSR
      *
      ** Print report Headers.
      ** Clear column headings control flag.
      *
     C                   MOVEL     *BLANK        BAPR              1
      *
     C     L0            IFEQ      'Y'
     C                   WRITE     ZZPAGHDR
     C                   MOVEL     'Y'           BAPR
     C                   END
      *
     CSR   BAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   CAPRDT        BEGSR
      *
      ** Print report detail line.
      ** Load detail line.
      *
     C                   MOVEL     WTRC          XRWTRC
     C                   Z-ADD     WTRT          XRWTRT
     C                   MOVEL     *BLANK        XRAMIT
     C                   MOVEL     CYCD          XRCYCD
     C                   MOVEL     DESC          XRDESC
     C                   MOVEL     RITAC         XRRITA
     C                   Z-ADD     LCD           XRLCD
     C                   MOVEL     TYPC          XRTYPC
     C                   MOVEL     *BLANK        XRACDT
     C                   MOVEL     *BLANK        XRALCH
     C                   MOVEL     'Y'           W0PFM
      *
      ** USER: Process detail record
      *
     C                   MOVEL     P1ARSI        WUARSI
      *
      ** Process Detail Rec PRTFIL
      *
     C                   ADD       1             WUWKNB
      *
      ** CASE:     PAR.Audit/Request Status Ind is Audit Mode
      *
     C     WUARSI        IFEQ      @CN(02)
      *
      ** CASE:     PAR.Last Change Date NE WRK.run day number
      *
     C     XRLCD         IFNE      WURDNB
     C                   MOVEL     @CN(03)       W0PFM
     C                   END
     C                   END
      *
      ** CASE:     PGM.*Print format is Print format
      *
     C     W0PFM         IFEQ      @CN(01)
     C                   ADD       1             ZTNCRC
      *
      ** CASE:     PAR.No of Calculated Recs is Equal 1
      *
     C     ZTNCRC        IFEQ      1
      *
      ** Change Print Control to Y - Standing Data Controls
      ** Set Print Control To Y To Enable Column Headers To Be
      ** Printed on First Record..
      *
     C                   MOVEL     'Y'           BAPR              1
     C                   END
     C                   END
      *
      ** Retrieve Decimal point
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Retrieve Minimim interest
      *
     C                   MOVE      *BLANKS       WUZASF           16
     C                   MOVE      MINT          WUZASF           16
      *
      ** ZEDIT Screen Field - Standard Functions
      *
     C                   CALL      'ZEDIT'                              90
     C     WUZASF        PARM      WUZASF        WQ0029           16
     C                   PARM      0             WQ0030            1 0
      *
     C     *IN90         IFEQ      '1'
      *
      ** Call to program ended in error
      *
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   ENDIF
     C                   MOVEL     WUZASF        XRAMIT
      *
      ** Check File Date - Rundate  *
      *
     C                   CALL      'ZDATE2'                             90
     C                   PARM      XRLCD         WQ0001            5 0
     C                   PARM      WUDFF         WQ0002            1
     C     WUWCDT        PARM      *ZERO         WQ0003            6 0
     C     XRACDT        PARM      *BLANK        WQ0004            7
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      ** PAR.alpha of last change = Condition name of PAR.Type of Last Change
      *
     C                   CALL      'Y2RVCNR'                            90
     C                   PARM                    W0RTN             7
     C                   PARM      1100584       Y2LSNO            7 0
     C                   PARM      XRTYPC        W0INVL           20
     C                   PARM      ' '           W0VLMP            1
     C     XRALCH        PARM                    W0CNNM           25
      *
     C     W0PFM         IFEQ      'Y'
      *
      ** Print column headings if required.
      *
     C     BAPR          IFEQ      'Y'
     C                   WRITE     ZZCOLHDG
     C                   MOVEL     *BLANK        BAPR
     C                   END
      *
      ** Print detail line.
      *
     C                   WRITE     ZZDTLRCD
     C                   END
      *
     CSR   CAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   DALVCH        BEGSR
      *
      ** Detect level changes.
      ** Clear all level breaks.
      *
     C                   MOVEL     *BLANK        L0
      *
      ** Clear heading length to print.
      *
     C                   Z-ADD     *ZERO         @$HDL
      *
      ** End of file - Signal all level breaks.
      *
     C     W0EOF         IFEQ      '1'
     C                   ELSE
      *
      ** Adjust for column headings.
      *
     C     @$HDL         IFGT      *ZERO
     C                   ADD       3             @$HDL
     C                   END
      *
     C                   END
      *
     CSR   DAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   EAPRTT        BEGSR
      *
      ** Print report Totals.
      ** Print level break totals as required
      ** End of file - Print final totals.
      *
     C     W0EOF         IFEQ      '1'
     C                   MOVEL     'Y'           W0PFM
      *
      ** USER: Process End of Report
      ** CASE:     CUR.No of Calculated Recs is Compare to Zero
      *
     C     ZTNCRC        IFEQ      *ZERO
     C                   MOVEL     @CN(04)       WUALZR
     C                   END
      *
      ** CASE:     PAR.Audit/Request Status Ind is Audit Mode
      *
     C     P1ARSI        IFEQ      @CN(02)
      *
      ** Audit/On-Req RTV on FCTL - Standing Data Controls
      *
     C                   EXSR      SARVGN
      *
      ** CASE:     WRK.work number NE WRK.No of Records on file
      *
     C     WUWKNB        IFNE      WUNORF
     C                   MOVEL     @CN(03)       WUWFLG
     C                   END
      *
      ** Audit printfile override - Standing Data Controls
      *
     C                   CALL      'SDC540P'                            90
     C                   PARM      @CN(07)       WQ0005           10
     C                   PARM      WUWFLG        WQ0006            1
     C                   PARM      WUNORI        WQ0007            5 0
     C                   PARM      WUNORA        WQ0008            5 0
     C                   PARM      WUNORD        WQ0009            5 0
     C                   PARM      WUWKNB        WQ0010            5 0
     C                   PARM      WUNORF        WQ0011            5 0
     C                   PARM      WUAURT        WQ0012           53
     C                   PARM      WUBJNA        WQ0013           53
      *
     C     *IN90         IFEQ      '1'
      *
      ** Call to program ended in error.
      *
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      ** CASE:     PGM.*Return code is *Record does not exist
      *
     C     W0RTN         IFEQ      @CN(06)
      *
      ** Database Error U7 U8 - Standing Data Controls
      ** Database error, set on switchedU7 and U8
      *
     C                   SETON                                        U7U8
      *
     C                   ELSE
      *
      ** CASE:     WRK.work flag is Incorrect
      *
     C     WUWFLG        IFEQ      @CN(03)
      *
      ** File Control Error U8 - Standing Data Controls
      ** File controls out of balance seton U8
      *
     C                   SETON                                            U8
      *
     C                   ELSE
      *
      ** CASE:     PGM.*Return code is *Field attribute types EX
      *
     C     W0RTN         IFEQ      @CN(08)
     C                   ELSE
      *
      ** CASE:     *OTHERWISE
      ** Change Standing Data Cont - Standing Data Controls
      *
     C                   EXSR      SBCHRC
     C                   END
     C                   END
     C                   END
     C                   END
     C     W0PFM         IFEQ      'Y'
      *
      ** If there is not enough space on the
      ** physical page for this format:-
      *
     C     @$PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      4
      *
      ** Signal artificial overflow.
      *
     C                   SETON                                        97
      *
      ** Print page headers.
      *
     C                   WRITE     ZZPAGHDR
     C                   END
     C                   MOVEL     '0'           *IN76
     C     WUALZR        IFEQ      @CN(04)
     C                   MOVEL     '1'           *IN76
     C                   END
      *
      ** Print format.
      *
     C                   WRITE     ZZFINTTL
     C                   END
     C                   END
      *
     CSR   EAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   FASGHD        BEGSR
      *
      ** Signal required header formats.
      ** Cascade skip to new page requests upwards.
      *
     C     *IN97         IFNE      '1'
     C     L0            ANDNE     'Y'
      *
      ** Signal overflow if requested headings would cause
      ** detail format to start past the overflow line.
      *
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   ELSE
      *
      ** Signal overflow if requested headings would cause
      ** detail format to be printed past end of page
      *
     C                   ADD       5             @$HDL
     C     W0PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL
     C                   SETON                                        97
     C                   END
     C                   END
     C                   END
      *
      ** Overflow detected.
      *
     C     *IN97         IFEQ      '1'
      *
      ** Request page headings.
      *
     C                   MOVEL     'Y'           L0
      *
      ** Request all formats which print on overflow.
      *
     C                   SETOFF                                       97
     C                   END
      *
     CSR   FAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   GARDRC        BEGSR
      *
      ** Read next record with user selection.
      *
     C     W0RSL         DOUEQ     'Y'
     C                   READ      SDWTRCD2                               90
     C                   MOVEL     *IN90         W0EOF             1
      *
      ** Quit if no record read.
      *
     C     W0EOF         CABEQ     '1'           GAEXIT
      *
      ** Select record unless user action states otherwise.
      *
     C                   MOVEL     'Y'           W0RSL             1
     C                   END
      *
     CSR   GAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   SARVGN        BEGSR
      *
      ** Audit/On-Req RTV on FCTL - Standing Data Controls
      *
     C                   MOVEL     *BLANK        W0RTN             7
      *
      ** Define Keylist.
      *
     C     KRSSA         KLIST
     C                   KFLD                    AHFLNM
      *
      ** Move fields to key list.
      *
     C                   MOVEL     @CN(05)       AHFLNM
     C     KRSSA         CHAIN     @AHREAV                            90
     C     *IN90         IFEQ      '1'
      *
      ** DBF Record not found.
      *
     C                   MOVEL     'USR0020'     W0RTN             7
      *
      ** USER: Processing if DBF record not found
      *
     C                   MOVEL     @CN(06)       W0RTN
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      *
      ** USER: Process DBF record
      ** PAR = DB1 By name
      *
     C                   Z-ADD     AHNORC        WUNORF
     C                   Z-ADD     AHNOIN        WUNORI
     C                   Z-ADD     AHNOAM        WUNORA
     C                   Z-ADD     AHNODL        WUNORD
     C                   END
      *
     CSR   SAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   SBCHRC        BEGSR
      *
      ** Change Standing Data Cont - Standing Data Controls
      *
     C                   MOVEL     *BLANK        W0RTN             7
      *
      ** Move key fields to @AHREAU
      *
     C                   MOVEL     @CN(05)       AHFLNM
      *
     C     KLCHSB        KLIST
     C                   KFLD                    AHFLNM
     C     KLCHSB        CHAIN     @AHREAU                            9091
      *
     C     *IN90         IFEQ      '1'
      *
      ** Record not found.
      *
     C                   MOVEL     'Y2U0009'     W0RTN             7
      *
      ** Send message '*Record no longer on file'
      *
     C                   MOVEL     'Y2U0009'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   GOTO      SBEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      *
      ** Record locked.
      *
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SBEXIT
     C                   END
      *
      ** USER: Processing after DBF read
      *
     C                   ADD       AHNORC        WUNORC
     C                   ADD       AHNOIN        WUNOIN
     C                   ADD       AHNOAM        WUNOAM
     C                   ADD       AHNODL        WUNODL
      *
      ** Move Non-key fields to @AHREAU
      *
     C                   Z-ADD     WUNORC        AHNORC
     C                   Z-ADD     *ZERO         AHNOIN
     C                   Z-ADD     *ZERO         AHNOAM
     C                   Z-ADD     *ZERO         AHNODL
      *
     C                   UPDATE    @AHREAU                              91
     C     *IN91         IFEQ      '1'
      *
      ** Change error detected.
      *
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      *
      ** DBF Change successful.
      *
     C                   END
      *
     CSR   SBEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   SCRVGN        BEGSR
      *
      ** Get Bank Title - Bank Details
      *
     C                   MOVEL     *BLANK        W0RTN             7
      *
      ** Define Keylist.
      *
     C     KRSSC         KLIST
     C                   KFLD                    BJBANK
      *
      ** Move fields to key list.
      *
     C                   MOVEL     @CN(09)       BJBANK
     C     KRSSC         CHAIN     @BJREEF                            90
     C     *IN90         IFEQ      '1'
      *
      ** DBF Record not found.
      *
     C                   MOVEL     'USR0197'     W0RTN             7
      *
      ** USER: Processing if DBF record not found
      *
     C                   MOVEL     @CN(06)       W0RTN
      *
      ** Setup message data for message.
      *
     C                   MOVEL     @CN(10)       ZA0001
      *
      ** Send message 'Database Error (ICD)'
      *
     C                   MOVEL     'USR0377'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99
      *
     C                   GOTO      SCEXIT
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      *
      ** USER: Process DBF record
      ** PAR = DB1 By name
      *
     C                   MOVEL     BJURPT        WUURPT
     C                   END
      *
     CSR   SCEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   ZASNMS        BEGSR
      *
      ** Send message to program's message queue.
      *
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   END
      *
      ** If no message file specified use default.
      *
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGM
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
      *
     CSR   ZAEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   ZXEXPG        BEGSR
      *
      ** Exit program
      *
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *
     CSR   ZXEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   ZYEXPG        BEGSR
      *
      ** Exit program: Direct.
      ** Terminate program.
      *
     C                   SETON                                        LR
      *
      ** Exit program.
      *
     C                   RETURN
      *
     CSR   ZYEXIT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     CSR   ZZINIT        BEGSR
      *
      ** Initialisation.
      *
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
      *
      ** Setup job date/time.
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
     C                   TIME                    ##TME             6 0
      *
      ** Define work field Audit/Request Status Ind
      *
     C                   MOVEL     *BLANK        WUARSI            1
      *
      ** Define work field work number
      *
     C                   Z-ADD     *ZERO         WUWKNB            5 0
      *
      ** Define work field Run day number
      *
     C                   Z-ADD     *ZERO         WURDNB            5 0
      *
      ** Define work field Date format flag
      *
     C                   MOVEL     *BLANK        WUDFF             1
      *
      ** Define work field Work Converted Date
      *
     C                   Z-ADD     *ZERO         WUWCDT            6 0
      *
      ** Define work field Alpha Zero
      *
     C                   MOVEL     *BLANK        WUALZR            1
      *
      ** Define work field No of Records on file
      *
     C                   Z-ADD     *ZERO         WUNORF            5 0
      *
      ** Define work field No of Records Inserted
      *
     C                   Z-ADD     *ZERO         WUNORI            5 0
      *
      ** Define work field No of Records Amended
      *
     C                   Z-ADD     *ZERO         WUNORA            5 0
      *
      ** Define work field No of records Deleted
      *
     C                   Z-ADD     *ZERO         WUNORD            5 0
      *
      ** Define work field work flag
      *
     C                   MOVEL     *BLANK        WUWFLG            1
      *
      ** Define work field Audit/Request Title
      *
     C                   MOVEL     *BLANK        WUAURT           53
      *
      ** Define work field Underline
      *
     C                   MOVEL     *BLANK        WUBJNA           53
      *
      ** Define work field No. of Records
      *
     C                   Z-ADD     *ZERO         WUNORC            5 0
      *
      ** Define work field No. of Inserts
      *
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      *
      ** Define work field No. of Amends
      *
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      *
      ** Define work field No. of Deletes
      *
     C                   Z-ADD     *ZERO         WUNODL            5 0
      *
      ** Define work field Midas Run Date
      *
     C                   MOVEL     *BLANK        WUMRDT            7
      *
      ** Define work field Set Up Complete
      *
     C                   MOVEL     *BLANK        WUSUC             1
      *
      ** Define work field Multi-branching Indicator
      *
     C                   MOVEL     *BLANK        WUMBIN            1
      *
      ** Define work field User Report Title
      *
     C                   MOVEL     *BLANK        WUURPT           53
      *
      ** Obtain default message file.
      *
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
      *
     C                   IN        ZADFMF
      *
      ** Define work field Spool file name
      *
     C                   MOVEL     *BLANK        WUSFNM           10
      *
      ** Define work field Spool file number
      *
     C                   Z-ADD     *ZERO         WUSFNB            6 0
      *
      ** Define work field ZSFILE error
      *
     C                   MOVEL     *BLANK        WUZSER            1
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @$WRK             4 0
     C                   Z-ADD     *ZERO         @$HDL             4 0
      *
      ** Adjust page length and overflow as necessary.
      *
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   END
      *
      ** USER: Initialise program
      ** Get Rundate - Rundate
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
      *
      ** Get Title
      ** Get Bank Title - Bank Details  *
      *
     C                   EXSR      SCRVGN
      *
      ** Move title to header - *Standard header/footer  *
      ** 7.10.89 Missing Source - Inserted During Incorporation
      ** Move User Report Title into Header Field in DDS for PRTF
      *
     C                   MOVE      WUURPT        ##URPT
      *
      ** Get Narrative Title - Narrative Codes
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      1             UIND              1 0
     C                   SETOFF                                           99
     C                   ELSE
     C                   MOVE      0             UIND
     C                   END
      *
      ** Calculate end of text point
      *
     C                   Z-ADD     1             U                 2 0
     C                   MOVEA     @CN(11)       UAR(U)
      *
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(U)                                 99
     C                   ADD       1             U
     C     UAR(U)        COMP      ' '                                    99
     C                   END
      *
     C     P1ARSI        IFEQ      'A'
     C                   MOVEL     UARRAY(1)     UTEMP            53
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       21            U
     C                   ELSE
      *
     C                   MOVEL     UARRAY(2)     UTEMP
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       7             U
     C                   END
      *
      ** Store  text in USTORE field
      *
     C                   MOVEA     UAR           USTORE           53
     C                   MOVE      *BLANKS       UAR
      *
     C     53            SUB       U             UB                2 0
     C     UB            DIV       2             UB
     C                   MVR                     UR                1 0
     C     UB            ADD       U             U
     C     U             SUB       1             U
      *
      ** Insert underline to array
      **
      *
     C                   MOVEA     *ALL'-'       ULN(UB)
     C                   MOVEA     *BLANKS       ULN(U)
      *
     C     UB            IFGT      0
     C                   MOVEA     USTORE        UAR(UB)
     C                   ELSE
     C                   MOVEA     USTORE        UAR
     C                   END
      *
      ** Move array values to screen text field
      *
     C                   MOVEA     UAR           ##AURT           53
     C                   MOVEA     UAR           WUAURT
     C                   MOVEA     ULN           ##BJNA           53
     C                   MOVEA     ULN           WUBJNA
      *
      ** Reset indicator *IN 99
      *
     C     UIND          IFEQ      1
     C                   SETON                                            99
     C                   ELSE
     C                   SETOFF                                           99
     C                   END
      *
      ** ZSFILE - log spool file - Standard Functions
      ** Set up spool file number - Standard Functions
      *
     C                   Z-ADD     @$FNB         WUSFNB
      *
      ** ZSFILE - write report rqs - Standard Functions
      *
     C                   CALL      'ZSFILE'                             90
     C                   PARM      P2RSQN        UURSQN            5
     C                   PARM      P4ENTY        UUENTY            3
     C                   PARM      @$FVN         UUSFNM           10
     C                   PARM      WUSFNB        UUSFNB            6 0
     C     WUZSER        PARM      *BLANK        UUZSER            1
      *
     C     *IN90         IFEQ      '1'
      *
      ** Call to program ended in error.
      *
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
      *
      ** CASE:     WRK.ZSFILE error is Error Occured
      *
     C     WUZSER        IFEQ      @CN(01)
     C                   MOVEL     @CN(12)       P0RTN
     C                   EXSR      ZYEXPG
     C                   END
      *
     CSR   ZZEXIT        ENDSR
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2015
**CTDATA UARRAY
MAINT. - AUDIT RPT
LISTING
**CTDATA @CN
Y
A
N
0
SDWTRCPD
Y2U0005
SD000204AU
Y2U0021
BANK
SDBANKPD
WITHHOLDING TAX RATE CODE
Y2U0004
