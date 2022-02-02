     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058079
/*STD *  RPGSQLBND                                                    *                     MD058079
/*EXI *  TEXT('Fontis Narrative Codes Table Print file')
      *****************************************************************
      *                                                               *
      *  Midas - Midas-Fontis Interface                               *
      *                                                               *
      *  GL2811P - Fontis Narrative Codes Table Print file            *
      *                                                               *
      *  Function - To print report of contents of the Fontis         *
      *             Narrative Codes Table file.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058079           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL004 *CREATE     Date 11MAR97               *
      *                                                               *
      ********************************************************************
      *                                                               *
      *  MD058079 - Deliverable Data Split for sundry files           *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL004 - Midas-Fontis Interface                              *
      *                                                               *
      ********************************************************************
     F*
     F*GLFNARL1* IF   E           K DISK                                                    MD058079
      * RTV:                           Retrieval index
      *
     FGL2811P1  O    E             PRINTER OFLIND(*IN97)
     F                                     USROPN
     F                                     INFDS(INFDS1)
      * PRT: Audit/Request Report      Print file
      *
     FGL2811AU  O    E             PRINTER
     F                                     INFDS(INFDSU)
      *
     FSDBANKL1  IF   E           K DISK
      * RTV: Bank Details              Retrieval index
      *
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N    O F    I N D I C A T O R S                *
     F*                                                               *
     F*  90 -  End of file/Error                                      *
     F*  97 -  Overflow indicator                                     *
     F*  99 -                                                         *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  S U B R O U T I N E    I N D E X                             *
     F*                                                               *
     F*  BAPRHD - Print Report Headers                                *
     F*  CAPRDT - Print Report Detail line                            *
     F*  DALVCH - Detect level changes                                *
     F*  EAPRTT - Print Report totals                                 *
     F*  FASGHD - Signal required header format                       *
     F*  SCRVGN - Obtain Bank Details                                 *
     F*  ZASNMS - Send Message to program queue                       *
     F*  ZXEXPG - Exit Program                                        *
     F*  ZZINIT - Initialisation                                      *
     F*  *PSSR  -                                                     *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     F*
     F*
     D UAR             S              1    DIM(53)
     D ULN             S              1    DIM(53)
     D UARRAY          S             26    DIM(2) CTDATA PERRCD(1)
      *
      ** SAVE INDICATOR *IN 99
      *
     D @CN             S             25    DIM(3) CTDATA PERRCD(1)              Long constants.
     D*
     D*
     D*
      /EJECT
      * Data structures:-
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure.
      *
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
      *
     D INFDS1        E DS                  EXTNAME(Y2I$DSP)
      * Printer file information data structure.
      *
     D INFDSU          DS
      * Printer file information data structure.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D GLFNAR        E DS                  EXTNAME(GLFNAJW0)                                MD058079
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
      * I:    RCF sequence number
     D  P2RSQN                 1      5
     D P3PARM          DS
      * I:    Level
     D  P3LEVL                 1      1
     D P4PARM          DS
      * I:    Entity
     D  P4ENTY                 1      3
     D                 DS
      * Message data for 'Database Error (ICD)'
      * Filename
     D  ZAMSDA                 1    132
     D  ZA0001                 1     10
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
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
      *
      * Establish starting position.
     C******LOVAL        SETLL     GLFNARD0                                     *           MD058079
      *
      * Read first record.
     C**********         READ      GLFNARD0                               90    *           MD058079
     C/EXEC SQL                                                                             MD058079
     C+ declare ACursor insensitive scroll cursor for                                       MD058079
     C+ select * from GLFNAJW0                                                              MD058079
     C+ order by F2PMTT, F2FTTR                                                             MD058079
     C/END-EXEC                                                                             MD058079
                                                                                            MD058079
     C/EXEC SQL                                                                             MD058079
     C+ open ACursor                                                                        MD058079
     C/END-EXEC                                                                             MD058079
                                                                                            MD058079
     C/EXEC SQL                                                                             MD058079
     C+ fetch next from ACursor into :GLFNAR                                                MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       90                    MD058079
     C                   IF        SQLCODE <> 0                                             MD058079
     C                   SETON                                        90                    MD058079
     C                   ENDIF                                                              MD058079
                                                                                            MD058079
     C                   MOVEL     *IN90         W0EOF             1
      *
      * Print null report headings.
     C     W0EOF         IFEQ      '1'                                          B001
     C                   WRITE     ZZPAGHDU
     C                   WRITE     ZZNODETL
     C*
     C* ZSFILE - log spool file - Standard Functions  *
     C*
     C                   Z-ADD     SFNUMU        WUSFNB
     C*
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C     UUSRSQ        PARM      P2RSQN        UURSQN            5            RCF sequence nu
     C                   PARM      P4ENTY        UUENTY            3            Entity
     C                   PARM      SFILEU        UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file numb
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C     *IN90         IFEQ      '1'                                          B002
     C* Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   ENDIF                                                  E002
      *
      *CASE:     WRK.ZSFILE error is Error Occured
     C     WUZSER        IFEQ      @CN(03)                                      B002
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ENDIF                                                  E002
     C*
     C                   ELSE                                                   X001
      * Request all headings.
     C                   MOVEL     'Y'           L0                1            Page headings
      * Initialise final totals.
     C                   MOVEL     *BLANK        ZTCON                          *CON (Screen co
     C*
      * Print report body.
     C     W0EOF         DOWEQ     '0'                                          B002
     C*
      * Print report detail line.
     C                   EXSR      CAPRDT
     C*
      * Hold current values.
      * Read next record.
     C**********         READ      GLFNARD0                               90    *           MD058079
     C/EXEC SQL                                                                             MD058079
     C+ fetch next from ACursor into :GLFNAR                                                MD058079
     C/END-EXEC                                                                             MD058079
     C                   SETOFF                                       90                    MD058079
     C                   IF        SQLCODE <> 0                                             MD058079
     C                   SETON                                        90                    MD058079
     C                   ENDIF                                                              MD058079
     C                   MOVEL     *IN90         W0EOF
     C*
      * Determine level changes.
     C                   EXSR      DALVCH
     C*
      * Print totals.
     C                   EXSR      EAPRTT
     C*
      * Process necessary heading requests
     C                   EXSR      FASGHD
     C                   ENDDO                                                  E002
     C*
     C     FILOPN        IFEQ      'Y'                                          B002
     C                   WRITE     ZZENDRPT
     C                   ENDIF                                                  E002
     C*
     C                   ENDIF                                                  E001
      * Exit program.
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *
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
     C                   ENDIF
      *
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   CAPRDT        BEGSR
      *================================================================
      * Print report detail line.
      *================================================================
      *
      * Load detail line.
     C                   Z-ADD     F2LCD         XRLCD                          Last Change Dat
     C                   MOVEL     F2TYLC        XRTYLC                         Type of Last Ch
     C                   MOVEL     F2PMTT        XRPMTT                         Transaction Typ
     C                   MOVEL     F2FTTR        XRFTTR                         Funds Transfer
     C                   MOVEL     F2LANC        XRLANC                         Language Code
     C                   MOVEL     F2NATV        XRNATV                         Narrative
     C                   MOVEL     F2STTI        XRSTTI                         SWIFT Trans. Ty
     C                   MOVEL     F2TRMD        XRTRMD                         Midas Module ID
     C                   MOVEL     *BLANK        XRACDT                         alpha change da
     C                   MOVEL     *BLANK        XRALCH                         alpha of last c
     C                   MOVEL     'Y'           W0PFM
      *
      * USER: Process detail record
     C                   MOVEL     P1ARSI        WUARSI                         Audit/Request S
      *
      * Process Detail Rec PRTFIL
     C                   ADD       1             WUWKNB                         work number
      *
      *CASE:     PAR.Audit/Request Status Ind is Audit Mode
     C     WUARSI        IFEQ      'A'                                          B001
      *
      *CASE:     PAR.Last Change Date NE WRK.run day number
     C     XRLCD         IFNE      WURDNB                                       B002
     C                   MOVEL     'N'           W0PFM                          *Print format
     C                   ENDIF                                                  E002
      *
     C                   ENDIF                                                  E001
      *
      *CASE:     PGM.*Print format is Print format
     C     W0PFM         IFEQ      'Y'                                          B001
     C                   ADD       1             ZTNCRC                         No of Calculate
      *
      *CASE:     PAR.No of Calculated Recs is Equal 1
     C     ZTNCRC        IFEQ      1                                            B002
      * Change Print Control to Y - Standing Data Controls  *
     C*
     C* Set Print Control To Y To Enable Column Headers To Be
     C*             Printed On First Record..
     C*
     C                   MOVEL     'Y'           BAPR              1
     C                   ENDIF                                                  E002
     C                   ENDIF                                                  E001
      *
      * Check File Date - Rundate  *
     C                   CALL      'ZDATE2'                             90      Check File Date
     C                   PARM      XRLCD         WQ0001            5 0          Work Midas Date
     C                   PARM      WUDFF         WQ0002            1            date format fla
     C     WUWCDT        PARM      *ZERO         WQ0003            6 0          Work Converted
     C     XRACDT        PARM      *BLANK        WQ0004            7            Work Alpha Date
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   ENDIF
      *
      * PAR.alpha of last change = Condition name of PAR.Type of Last Change
     C                   CALL      'Y2RVCNR'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C                   PARM      1100584       Y2LSNO            7 0          List number
     C                   PARM      XRTYLC        W0INVL           20            Type of Last Ch
     C                   PARM      ' '           W0VLMP            1            Value mapped?
     C     XRALCH        PARM                    W0CNNM           25            alpha of last c
      *
     C     W0PFM         IFEQ      'Y'                                          B001
     C* OPEN PRINTER FILE IF NOT ALREADY OPEN
     C     FILOPN        IFNE      'Y'                                          B002
     C                   OPEN      GL2811P1
     C                   Z-ADD     0             PAGE
     C                   MOVEL     'Y'           FILOPN            1
     C*
     C* ZSFILE - log spool file - Standard Functions  *
     C*
     C* Set up spool file number - Standard Functions  *
     C                   Z-ADD     @$FNB         WUSFNB
     C*
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C     UUSRSQ        PARM      P2RSQN        UURSQN            5            RCF sequence nu
     C                   PARM      P4ENTY        UUENTY            3            Entity
     C                   PARM      @$FVN         UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file numb
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C     *IN90         IFEQ      '1'                                          B003
     C* Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   ENDIF                                                  E003
      *
      *CASE:     WRK.ZSFILE error is Error Occured
     C     WUZSER        IFEQ      @CN(03)                                      B003
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ENDIF                                                  E003
     C                   ENDIF                                                  E002
      *
      * Print headings.
     C                   EXSR      BAPRHD
      *
      * Print column headings if required.
     C     BAPR          IFEQ      'Y'                                          B002
     C                   WRITE     ZZCOLHDG
     C                   MOVEL     *BLANK        BAPR
     C                   ENDIF                                                  E002
      *
      * Print detail line.
     C                   WRITE     ZZDTLRCD
     C                   ENDIF                                                  E001
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DALVCH        BEGSR
      *================================================================
      * Detect level changes.
      *================================================================
      *
      * Clear all level breaks.
     C                   MOVEL     *BLANK        L0                             Page headings
      *
      * Clear heading length to print.
     C                   Z-ADD     *ZERO         @$HDL
      *
      * End of file - Signal all level breaks.
     C     W0EOF         IFEQ      '1'                                          B001
     C                   ELSE                                                   X001
      * Adjust for column headings.
     C     @$HDL         IFGT      *ZERO                                        B002
     C                   ADD       5             @$HDL
     C                   ENDIF                                                  E002
      *
     C                   ENDIF                                                  E001
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   EAPRTT        BEGSR
      *================================================================
      * Print report Totals.
      *================================================================
      *
      * Print level break totals as required
      * End of file - Print final totals.
     C     W0EOF         IFEQ      '1'                                          B001
     C                   MOVEL     'Y'           W0PFM
      *
      * USER: Process End of Report
      *CASE:     CUR.No of Calculated Recs is Compare to Zero
     C     ZTNCRC        IFEQ      *ZERO                                        B002
     C                   MOVEL     '0'           WUALZR                         Alpha Zero
     C                   ENDIF                                                  E002
      *
     C     W0PFM         IFEQ      'Y'                                          B002
      * Print format.
     C                   WRITE     ZZPAGHDU
     C                   WRITE     ZZFINTTL
     C*
     C* ZSFILE - log spool file - Standard Functions  *
     C*
     C                   Z-ADD     SFNUMU        WUSFNB
      *
     C* ZSFILE - write report rqs - Standard Functions  *
     C                   CALL      'ZSFILE'                             90      ZSFILE - write
     C     UUSRSQ        PARM      P2RSQN        UURSQN            5            RCF sequence nu
     C                   PARM      P4ENTY        UUENTY            3            Entity
     C                   PARM      SFILEU        UUSFNM           10            Spool file name
     C                   PARM      WUSFNB        UUSFNB            6 0          Spool file numb
     C     WUZSER        PARM      *BLANK        UUZSER            1            ZSFILE error
     C*
     C     *IN90         IFEQ      '1'                                          B003
     C* Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   ENDIF                                                  E003
      *
      *CASE:     WRK.ZSFILE error is Error Occured
     C     WUZSER        IFEQ      @CN(03)                                      B003
     C                   MOVEL     'Y2U0004'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ENDIF                                                  E003
      *
     C                   ENDIF                                                  E002
     C                   ENDIF                                                  E001
      *
      *================================================================
     CSR   EAEXIT        ENDSR
      /EJECT
     CSR   FASGHD        BEGSR
      *================================================================
      * Signal required header formats.
      *================================================================
      *
      * Cascade skip to new page requests upwards.
      *
     C     *IN97         IFNE      '1'                                          B001
     C     L0            ANDNE     'Y'
      *
      * Signal overflow if requested headings would cause
      * detail format to start past the overflow line.
      *
     C     W0OFL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL                                        B002
     C                   SETON                                        97
     C                   ELSE                                                   X002
      *
      * Signal overflow if requested headings would cause
      * detail format to be printed past end of page
      *
     C                   ADD       2             @$HDL
     C     W0PGL         SUB       @$CLN         @$WRK
     C     @$WRK         IFLE      @$HDL                                        B003
     C                   SETON                                        97
     C                   ENDIF                                                  E003
     C                   ENDIF                                                  E002
     C                   ENDIF                                                  E001
      *
      * Overflow detected.
     C     *IN97         IFEQ      '1'
      * Request page headings.
     C                   MOVEL     'Y'           L0
      * Request all formats which print on overflow.
     C                   SETOFF                                       97
     C                   ENDIF
      *
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   SCRVGN        BEGSR
      *================================================================
      * Get Bank Title - Bank Details  *
      *================================================================
      *
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSC         KLIST
     C                   KFLD                    BJBANK                         Bank
      *
      * Move fields to key list.
     C                   MOVEL     'BANK'        BJBANK                         Bank
     C     KRSSC         CHAIN     @BJREEF                            90        *
      *
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR0197'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Setup message data for message.
     C                   MOVEL     'SDBANKPD'    ZA0001                         Filename
      * Send message 'Database Error (ICD)'
     C                   MOVEL     'USR0377'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      SCEXIT                                       *QUIT
     C                   GOTO      SCEXIT
     C                   ENDIF
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      * PAR = DB1 By name
     C                   MOVEL     BJURPT        WUURPT                         User Report Tit
     C                   ENDIF
      *================================================================
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   ZASNMS        BEGSR
      *================================================================
      * Send message to program's message queue.
      *================================================================
     C     ZAPGM         IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGM
     C                   ENDIF
      *
      * If no message file specified use default.
     C     ZAMSGF        IFEQ      *BLANK
     C                   MOVEL     ZADFMF        ZAMSGF
     C                   ENDIF
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
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
      * Define work field work flag
     C                   MOVEL     *BLANK        WUWFLG            1
      * Define work field Audit/Request Title
     C                   MOVEL     *BLANK        WUARTL           53
      * Define work field Underline
     C                   MOVEL     *BLANK        WUUNDL           53
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field midas rundate
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
      *
      * Define work field ZSFILE error
     C                   MOVE      *BLANKS       UUSRSQ            5
     C                   MOVEL     *BLANK        WUZSER            1
     C                   MOVEL     *BLANK        W0PFM             1
     C                   Z-ADD     *ZERO         @$WRK             4 0
     C                   Z-ADD     *ZERO         @$HDL             4 0
      *
      * Adjust page length and overflow as necessary.
     C     @$PGL         SUB       2             W0PGL             4 0
     C     @$OFL         IFGE      W0PGL
     C     W0PGL         SUB       2             W0OFL             4 0
     C                   ELSE
     C                   Z-ADD     @$OFL         W0OFL
     C                   ENDIF
      *
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
      *
      * Get Title
      * Get Bank Title - Bank Details  *
     C                   EXSR      SCRVGN
      *
      * Move title to header - *Standard header/footer  *
     C* Move User Report Title into Header Field in DDS for PRTF
     C*
     C                   MOVE      WUURPT        ##URPT
      * Get Narrative Title - Narrative Codes  *
     C     *IN99         IFEQ      '1'
     C                   MOVE      1             UIND              1 0
     C                   SETOFF                                           99
     C                   ELSE
     C                   MOVE      0             UIND
     C                   ENDIF
      *
      ** CALCULATE END OF TEXT POINT
     C                   Z-ADD     1             U                 2 0
     C                   MOVEA     @CN(02)       UAR(U)
     C*
     C     *IN99         DOWEQ     '0'
     C     ' '           LOOKUP    UAR(U)                                 99
     C                   ADD       1             U
     C     UAR(U)        COMP      ' '                                    99
     C                   ENDDO
      *
     C**
     C*
     C     P1ARSI        IFEQ      'A'
     C                   MOVEL     UARRAY(1)     UTEMP            26
     C                   MOVEA     UTEMP         UAR(U)
     C                   ADD       26            U
     C                   ELSE
      *
     C                   MOVEA     UARRAY(2)     UAR(U)                         * IF A THIRD
     C                   ADD       7             U                              OPTION TO ARRAY
     C                   ENDIF                                                  IS ADDED A
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
     C                   ENDIF
      *
      **  MOVE ARRAY VALUE  TO SCREEN TEXT FIELD
      *
     C*                    MOVEAUAR       ##EYTX
     C                   MOVEA     UAR           ##ARTL
     C*                    MOVEAUAR       WUEYTX
     C                   MOVEA     UAR           WUARTL
     C*                    MOVEAULN       ##BJNA
     C                   MOVEA     ULN           ##UNDL
     C                   MOVEA     ULN           WUUNDL
      *
      *
      ** RESET INDICATOR *IN 99
      *
     C     UIND          IFEQ      1
     C                   SETON                                            99
     C                   ELSE
     C                   SETOFF                                           99
     C                   ENDIF
      *
      *================================================================
     CSR   ZZEXIT        ENDSR
      *================================================================
     C*
     C     *PSSR         BEGSR
      *
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *================================================================
**CTDATA UARRAY
MAINTENANCE - AUDIT REPORT
LISTING
**CTDATA @CN
GL2811AU
NARRATIVE CODES
Y
**CTDATA CPY@
(c) Finastra International Limited 2001
