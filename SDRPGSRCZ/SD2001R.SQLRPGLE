     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058830
/*STD *  RPGSQLBND                                                    *                     MD058830
/*EXI *  TEXT('Midas SD Network details maintenance')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2001R - Midas SD Edit Network details 1rec                 *
      *                                                               *
      *  Function:  This program allows the user to maintain          *
      *             network details                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD058830           Date 01Oct21               *
      *                 CMG008             Date 20Feb20               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      *                 S01459             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation                           *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *                                                               *
      *****************************************************************
     F*
     F/COPY WNCPYSRC,SD2001RFPG
     FSD2001R#  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Edit Network details 1rec Edit record(1 screen)
      *
     F*SDNWRKL1* IF   E           K DISK                                                    MD058830
     F**********                           INFDS(INFDS1)                                    MD058830
      * RTV: Message Network Details   Retrieval index
      *
     FSDMMODL1  IF   E           K DISK
      * RTV: MIDAS Modules             Retrieval index
      *
     F*SDNWRKL0* UF A E           K DISK    USROPN                                          MD058830
     F**********                           COMMIT                                           MD058830
      * UPD: Message Network Details   Update index
      *
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061007
     F**********                           COMMIT                                           MD061007
      * UPD: Standing Data Controls    Update index
      *
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D/COPY WNCPYSRC,SD2001REPG
     D @CN             S             25    DIM(16) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*COPY*QWINDSRC,SD2000GDTA                                                             MD058830
     D/COPY QWINDSRC,SD2000GDTN                                                             MD058830
     D/COPY WNCPYSRC,SD2001RIPG
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
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      * Display file data structure.
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure.
      *
     D*@1DBRC***     E DS                  EXTNAME(SDNWRKL0)                                MD058830
     D @1DBRC        E DS                  EXTNAME(SDNWKJW0)                                MD058830
     D                                     PREFIX(X)                                        MD058830
     D SDNWRK        E DS                  EXTNAME(SDNWKJW0)                                MD058830
      * Current/previous master file format fields for change control.
      *
     D***********#1DBRC      DS                             30            CGL013
     D #1DBRC          DS          1402                                         CGL013
      * Stored master file format fields.
     D  #1DB1                  1      1
      *
      *
     D WUDELR          DS
     D  WUDR01                 1    250
     D  WUDR02               251    500
     D  WUDR03               501    750
     D  WUDR04               751   1000
     D  WUDR05              1001   1250
     D  WUDR06              1251   1500
     D  WUDR07              1501   1750
     D  WUDR08              1751   2000
     D  WUDR09              2001   2250
     D  WUDR00              2251   2500
     D  WUDR11              2501   2750
     D  WUDR12              2751   3000
      * Outward parameters
     D PARC            DS          3064
      * RCD : Midas SD Deleted records file retrieval
      * I :  File name
     D  PAFNME                 1     10
      * I :  Long Key
     D  PALKEY                11     60
      * I :  Deleted Data Record Pt1
     D  PADR01                61    310
      * I :  Deleted Data Record Pt2
     D  PADR02               311    560
      * I :  Deleted Data Record Pt3
     D  PADR03               561    810
      * I :  Deleted Data Record Pt4
     D  PADR04               811   1060
      * I :  Deleted Data Record Pt5
     D  PADR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  PADR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  PADR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  PADR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  PADR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  PADR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  PADR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  PADR12              2811   3060
      * I :  Last Change Date
     D  PALCD               3061   3063P 0
      * I :  Type of Last Change
     D  PATYLC              3064   3064
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
     D P1PARM          DS            30
      * RCD: Message Network Details   Retrieval index
      * I:MAP Network
     D  P1NWRK                 1      6
     D P2PARM          DS
      * I:    Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Network
     D  ZA0001                 1      6
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Network
     D  ZA0003                 2      7
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
     C                   PARM                    P1PARM                         RCD: Message Ne
     C     P2ANCD        PARM                    WP0001            1            Action Code
      *****************************************************************
      * Initialise
     C                   EXSR      ZZINIT
      *
      * Check passed parameters.
     C                   EXSR      FACKPM
      * Perform once if all passed, else repeat.
     C     W0RPT         DOUEQ     'N'
      * Display and process key screen.
     C                   EXSR      BADSKY
     C                   END
      * Terminate program.
     C                   EXSR      ZXEXPG
      *****************************************************************
      /EJECT
     CSR   BADSKY        BEGSR
      *================================================================
      * Display and process key screen.
      *================================================================
      * Initialise key screen
     C                   EXSR      MDIZ#K
      * Bypass first display of key screen is possible.
     C                   MOVEL     'Y'           W0BYP             1
      * Signal start of transaction.
     C                   MOVEL     'Y'           W0TRN             1
     C     W0TRN         DOWEQ     'Y'
     C     W0TRN         OREQ      'R'
      * Ensure transaction continues (if reset).
     C                   MOVEL     'Y'           W0TRN             1
      * Initialise detail screen.
     C                   EXSR      MAIZ#1
      * Conduct screen conversation:
     C     W0TRN         DOWEQ     'Y'
      * Is bypass key screen still viable?
     C     W0BYP         IFEQ      'Y'
     C     #1NWRK        IFEQ      *BLANK                                       Network
      * One or more key field is blank.
     C                   MOVEL     'N'           W0BYP
     C                   END
     C                   END
      * Bypass key screen.
     C     W0BYP         IFNE      'Y'
      * Display key screen.
     C                   EXSR      BBEXFM
     C                   END
      * Cancel key screen bypass.
     C                   MOVEL     'N'           W0BYP
      * Process response to key screen:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * Switch between *ADD/*CHANGE modes.
     C   09              CAS                     BCCHMD
      * HOME: Reset screen fields.
     C   05              CAS                     BDHMKY
      * Process key screen input.
     C                   CAS                     BEPRKY
     C                   END
      *
     C                   END
     C                   END
      *================================================================
     CSR   BAEXIT        ENDSR
      /EJECT
     CSR   BBEXFM        BEGSR
      *================================================================
      * Display key screen and process HELP requests
      *================================================================
      * Set screen conditioning indicators.
     C                   EXSR      GADSAK
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                            86    *
     C     *IN89         IFNE      BBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         BBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDKEY
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator.
     C                   SETOFF                                           99    *
      *================================================================
     CSR   BBEXIT        ENDSR
      /EJECT
     CSR   BCCHMD        BEGSR
      *================================================================
      * Switch between ADD and CHANGE modes.
      *================================================================
     C     W0PMD         IFEQ      'ADD'
     C                   MOVEL     'CHG'         W0PMD             3
     C                   ELSE
     C                   MOVEL     'ADD'         W0PMD
     C                   END
      *================================================================
     CSR   BCEXIT        ENDSR
      /EJECT
     CSR   BDHMKY        BEGSR
      *================================================================
      * Process HOME key
      *================================================================
     C                   MOVEL     'N'           W0TRN
      *================================================================
     CSR   BDEXIT        ENDSR
      /EJECT
     CSR   BEPRKY        BEGSR
      *================================================================
      * Process key screen.
      *================================================================
      * Validate key fields.
     C                   EXSR      BFVLKY
     C     *IN99         CABEQ     '1'           BEEXIT
      * Check for existing record.
     C     KRTV          KLIST
     C                   KFLD                    EDNWRK                         Network
      * Setup key.
     C                   MOVEL     #1NWRK        EDNWRK                         Network
     C*****KRTV          CHAIN     @EDREJZ                            9091      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       9091                  MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   SETON                                        9931      *
     C                   GOTO      BEEXIT
     C                   END                                                    FI 91
      *
      * Verify record existance against program mode
     C     W0PMD         IFNE      'ADD'
      * If record does not exist, error
     C     *IN90         IFEQ      '1'
     C                   SETON                                        9931      *
      * Send message 'Message Network Detail NF'
     C                   MOVEL     'USR1537'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy member SD2001RSFF - Message Network Details  *
     C*00/Copy member           Calc Detail Function Flds
     C/COPY WNCPYSRC,SD2001RSFF
      * USER: Initialise detail screen (existing record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
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
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
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
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
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
     C*
      * 00/Copy Member SD2001RISE - Message Network Details  *
     C*00/Copy member           Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,SD2001RISE
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'Message Network Detail EX'
     C                   MOVEL     'USR1538'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      * USER: Initialise detail screen (new record)
      * Set-up DTL Screen Footer - Standard Functions  *
     C*
     C*  DETAIL LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C*  If Action Code is Delete :
     C*
     C     P2ANCD        IFEQ      'D'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F10=Delete   F12=Previous
     C                   MOVEL     'USR3350'     WUMSID            7            Message Identifier
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
     C*
     C*  If Action Code is Insert :
     C*
     C     P2ANCD        IFEQ      'I'                                                         S0122
     C* Setup footer text:
     C* F3=Exit   F12=Previous
     C                   MOVEL     'USR3351'     WUMSID                         Message Identifier
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
     C*
     C*  If Action Code is Amend :
     C*
     C     P2ANCD        IFEQ      'A'                                                         S0122
     C* Setup footer text:
     C* F3=Main Menu   F12=Previous
     C                   MOVEL     'USR3346'     WUMSID                         Message Identifier
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
     C*
      * 00/Copy Member SD2001RISN - Message Network Details  *
     C*00/Copy member           Initialise Dtl New Rcd
     C/COPY WNCPYSRC,SD2001RISN
     C                   END
     C                   END
      *.................................................
     C   99              GOTO      BEEXIT
      * No errors: Display and process details
     C                   EXSR      CADSDA
      *
      *================================================================
     CSR   BEEXIT        ENDSR
      /EJECT
     CSR   BFVLKY        BEGSR
      *================================================================
      * Validate key fields.
      *================================================================
     C     W0PMD         IFNE      'ADD'
      * Select existing record.
     C                   EXSR      VACKRL
     C                   END
      * USER: Validate key screen
      *CASE:     PAR.Action Code is Insert
     C     P2ANCD        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     #1NWRK        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1NWRK        WUIVKF                         If value in key
      * Ensure no invalid values
      *CASE:     WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      @CN(02)                                      *IF
      * Setup message data for message.
     C                   MOVEL     #1NWRK        ZA0001                         Network
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9931      *
      *
     C                   ELSE
      *CASE:     WRK.If value in key field is Asterisk
     C     WUIVKF        IFEQ      @CN(03)                                      *IF
      * Setup message data for message.
     C                   MOVEL     WUIVKF        ZA0002                         If value in key
     C                   MOVEL     #1NWRK        ZA0003                         Network
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9931      *
      *
     C                   GOTO      BFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Retrieve Network Details - Message Network Details  *
     C                   EXSR      SARVGN
      * Send error message if record already exists
      *CASE:     PGM.*Return code is *Record already exists
     C     W0RTN         IFEQ      @CN(05)                                      *IF
      * Send message '*Record already exists'
     C                   MOVEL     'Y2U0003'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD2001RVKS - Message Network Details  *
     C*00/Copy member           Validate Key Screen
     C/COPY WNCPYSRC,SD2001RVKS
      * Network required.
     C     #1NWRK        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      *================================================================
     CSR   BFEXIT        ENDSR
      /EJECT
     CSR   CADSDA        BEGSR
      *================================================================
      * Display and process details.
      *================================================================
      * Conduct detail screen conversation:
      * - repeat until screen control flag is reset:
     C     W0TRN         DOWEQ     'Y'
      * Display detail screen.
     C                   EXSR      CBEXFM
      * Process response to detail screen:
      * Cancel & exit program.
     C   03              CAS                     ZXEXPG
      * Redisplay previous screen
     C   12              CAS                     CCDSPV
      * Process detail screen input.
     C                   CAS                     CFPRSC
     C                   END
      *
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   CBEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests.
      *================================================================
      * Set screen conditioning indicators.
     C                   EXSR      GBDSAD
      * Update screen time.
     C                   TIME                    ##TME                          Screen time.
     C     W0HLP         DOUEQ     'N'
      * PUTOVR unless conditioned fields change.
     C                   SETON                                            86    *
     C     *IN89         IFNE      CBIN89
     C                   SETOFF                                           86    *
     C                   END
     C                   MOVE      *IN89         CBIN89            1
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT2
     C                   EXFMT     #RCDDTL1
     C                   MOVEL     'N'           W0HLP             1            Reset help requ
      * If help requested, display help text.
     C   25              EXSR      ZHHPKY                                       Display help te
     C                   END
      * Update job time.
     C                   TIME                    ##JTM                          Job time.
      * Clear messages from program message queue.
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag.
     C                   MOVEL     'Y'           ZAFSMS            1
      * Reset global error indicator.
     C                   SETOFF                                           99    *
      *================================================================
     CSR   CBEXIT        ENDSR
      /EJECT
     CSR   CCDSPV        BEGSR
      *================================================================
      * Redisplay previous screen.
      *================================================================
      * USER: Process key screen request
      * 00/Copy Member SD2001RPKR - Message Network Details  *
     C*00/Copy member           Process Key Screen Rqst
     C/COPY WNCPYSRC,SD2001RPKR
      *CASE:     PAR.Action Code is Insert
     C     P2ANCD        IFEQ      @CN(01)                                      *IF
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     'R'           W0TRN
      *================================================================
     CSR   CCEXIT        ENDSR
      /EJECT
     CSR   CFPRSC        BEGSR
      *================================================================
      * Validate record.
      *================================================================
      * Confirm/update is not defered.
     C                   MOVEL     'N'           W0DCF             1
      * If delete is not pending....
      * Validate details.
     C  N10              CAS                     DCVLDL
     C                   END
      * Quit if error:
     C   99              GOTO      CFEXIT
      * Defer confirm/update requested:
     C     W0DCF         CABEQ     'Y'           CFEXIT
      * No error: Update record:
     C                   EXSR      EBPR##
      *================================================================
     CSR   CFEXIT        ENDSR
      /EJECT
     CSR   DCVLDL        BEGSR
      *================================================================
      * Validate details.
      *================================================================
      * USER: Validate detail screen fields
      * Delete Mode Processing
      *CASE:     PAR.Action Code is Delete
     C     P2ANCD        IFEQ      @CN(06)                                      *IF
      * Send message 'F3/F10/F12 only valid opt'
     C                   MOVEL     'USR0536'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * 00/Copy member SD2001rvsf - Message Network Details  *
     C*00/Copy member           Validate Detail Screen
     C/COPY WNCPYSRC,SD2001RVSF
      * CALC: Detail screen function fields
      * 00/Copy member SD2001RSFF - Message Network Details  *
     C*00/Copy member           Calc Detail Function Flds
     C/COPY WNCPYSRC,SD2001RSFF
      * USER: Validate detail screen relations
      * 00/Copy member SD2001RVSR - Message Network Details  *
     C*00/Copy member           Validate Screen Relns
     C/COPY WNCPYSRC,SD2001RVSR
      * Network Description required.
     C     #1NETD        IFEQ      *BLANK                                       IF
     C                   SETON                                        9931      *
      * Send message '*Value required'
     C                   MOVEL     'Y2U0001'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END                                                    FI
      *================================================================
     CSR   DCEXIT        ENDSR
      /EJECT
     CSR   EBPR##        BEGSR
      *================================================================
      * Process record.
      *================================================================
      * Process delete request.
     C   10              CAS                     EDDLRQ
      * Process add request.
     C     W0PMD         CASEQ     'ADD'         ECADRQ
      * Process update request.
     C     W0PMD         CASNE     'ADD'         EECHRQ
     C                   END
     C     W0RTN         IFNE      *BLANK
      * Error: ROLLBACK any DBF changes.
     C                   ROLBK
     C                   GOTO      EBEXIT
     C                   ELSE
      * Otherwise COMMIT any DBF changes.
     C                   COMMIT
     C                   END
     C     W0RTN         IFEQ      *BLANK
      * USER: Process command keys
      * 00/Copy member SD2001RPCK - Message Network Details  *
     C*00/Copy member           Process Command Keys
     C/COPY WNCPYSRC,SD2001RPCK
      *CASE:     DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(07)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Restart program for next record.
     C                   MOVEL     'N'           W0TRN
     C                   END
      *================================================================
     CSR   EBEXIT        ENDSR
      /EJECT
     CSR   ECADRQ        BEGSR
      *================================================================
      * Process add request.
      *================================================================
      * USER: Create DBF record
      * Create Message Network - Message Network Details  *
     C                   EXSR      SBCRRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *================================================================
     CSR   ECEXIT        ENDSR
      /EJECT
     CSR   EDDLRQ        BEGSR
      *================================================================
      * Process delete request.
      *================================================================
      * USER: Delete DBF record
      * Delete Message Network - Message Network Details  *
     C                   EXSR      SDDLRC
     C     W0RTN         IFEQ      *BLANK
      * Send message '*Record deleted'
     C                   MOVEL     'Y2U0013'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *================================================================
     CSR   EDEXIT        ENDSR
      /EJECT
     CSR   EECHRQ        BEGSR
      *================================================================
      * Process update request.
      *================================================================
      * USER: Change DBF record
      * Change Message Network - Message Network Details  *
     C                   EXSR      SFCHRC
     C     W0RTN         IFNE      *BLANK
      * DBF Update error detected.
      * Reset screen fields if changed record.
     C     W0RTN         CASEQ     'Y2U0007'     MBFL#1
     C                   END
     C                   ELSE
      * Send message '*Record changed'
     C                   MOVEL     'Y2U0012'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   END
      *================================================================
     CSR   EEEXIT        ENDSR
      /EJECT
     CSR   FACKPM        BEGSR
      *================================================================
      * Check passed parameters.
      *================================================================
      * Is full key present?
     C     P1NWRK        IFEQ      *BLANK                                       Network
      * Not every key field passed - loop program.
     C                   MOVEL     'Y'           W0RPT             1
     C                   ELSE
      * Full key passed, so single shot program.
     C                   MOVEL     'N'           W0RPT
     C                   END
      *================================================================
     CSR   FAEXIT        ENDSR
      /EJECT
     CSR   GADSAK        BEGSR
      *================================================================
      * Set key screen conditioning indicators.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      *================================================================
     CSR   GAEXIT        ENDSR
      /EJECT
     CSR   GBDSAD        BEGSR
      *================================================================
      * Set detail screen conditioning indicators.
      *================================================================
     C     W0PMD         COMP      'ADD'                                  89    *
      * Protect key fields on detail screen.
     C                   SETON                                        88        *
      * Enable key screen.
     C                   SETON                                        87        *
      *================================================================
     CSR   GBEXIT        ENDSR
      /EJECT
     CSR   MAIZ#1        BEGSR
      *================================================================
      * Initialise record - except for key fields.
      *================================================================
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1NETD                         Network Descrip
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @EDREJZ fields to screen.
      *================================================================
     C                   Z-ADD     EDLCD         #1LCD                          Last Change Dat
     C                   MOVEL     EDTYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     EDNWRK        #1NWRK                         Network
     C                   MOVEL     EDNETD        #1NETD                         Network Descrip
      * Hold existing record image.
     C                   eval      @1DBRC = SDNWRK                                          MD058830
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen.
      *================================================================
     C                   MOVEL     P1NWRK        #1NWRK                         Network
      * USER: Initialise key screen
      * Set-up KEY Screen Footer - Standard Functions  *
     C*
     C* KEY LINE COMMAND KEY TEXT
     C*
     C                   MOVEL     'SDUSRMSG'    WUMSGF           10
     C                   MOVE      *BLANKS       WUMTXT           80
     C*
     C* Setup footer text:
     C* F3=Previous
     C                   MOVEL     'USR3345'     WUMSID            7            Message Identifier
     C                   CALL      'SDRTVTXT'                           90      Retrieve MSGF messag
     C     WUMSID        PARM      WUMSID        KE0286            7            Message Identifier
     C     WUMSGF        PARM      WUMSGF        KE0287           10            Message File Name
     C     WUMTXT        PARM      WUMTXT        KE0288           80            Message Text
     C                   MOVEL     WUMTXT        ##CTX1
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SDRTVTXT'    W0CLPG
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      * 00/Copy Member SD2001RIKS - Message Network Details  *
     C*00/Copy member           Initialise Key Screen
     C/COPY WNCPYSRC,SD2001RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Network Details - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    EDNWRK                         Network
      * Move fields to key list.
     C                   MOVEL     #1NWRK        EDNWRK                         Network
     C*****KRSSA         CHAIN     @EDREJZ                            90        *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR1537'     W0RTN             7
      * USER: Processing if DBF record not found
     C                   MOVEL     @CN(04)       W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
     C                   MOVEL     @CN(05)       W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBCRRC        BEGSR
      *================================================================
      * Create Message Network - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @EDREJY
     C                   MOVEL     #1NWRK        EDNWRK                         Network
     C                   MOVEL     #1NETD        EDNETD                         Network Descrip
     C                   Z-ADD     WURDNB        EDLCD                          Last Change Dat
     C                   MOVEL     @CN(01)       EDTYLC                         Type of Last Ch
      *
      * USER: Processing before DBF update
      * Window processing
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(08)                                      *IF
     C                   MOVEL     @CN(01)       WUWMAC                         WM action code
      * WM call Window Manager - Window manager  *
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      @CN(01)       UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      *CASE:     PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(07)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(09)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(11)                                      *IF
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD2001RCBW - Message Network Details  *
     C*00/Copy member           Proc Before Create - WN
     C/COPY WNCPYSRC,SD2001RCBW
     C                   END                                                    *FI
      * 00/Copy member SD2001RCBU - Message Network Details  *
     C*00/Copy member           Processing Before Create
     C/COPY WNCPYSRC,SD2001RCBU
     C     KLCRSB        KLIST
     C                   KFLD                    EDNWRK                         Network
      * Check for duplicate primary key.
     C*****KLCRSB        SETLL     @EDREJY                                90    *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE =  0                                             MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR1538'     W0RTN             7
      * Send message 'Message Network Detail EX'
     C                   MOVEL     'USR1538'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SBEXIT
     C                   END
      *
     C**********         WRITE     @EDREJY                              91      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ insert into SDNWKBTD                                                                MD058830
     C+ (                                                                                   MD058830
     C+   EDNWRK                                                                            MD058830
     C+  ,EDNETD                                                                            MD058830
     C+  ,EDLCD                                                                             MD058830
     C+  ,EDTYLC                                                                            MD058830
     C+  ,EDPROT                                                                            MD058830
     C+  ,EDM940                                                                            MD058830
     C+  ,EDM941                                                                            MD058830
     C+  ,EDM942                                                                            MD058830
     C+  ,EDM950                                                                            MD058830
     C+  ,EDAMDS                                                                            MD058830
     C+  ,EDENRA                                                                            MD058830
     C+  ,EDRPSR                                                                            MD058830
     C+  ,EDPASS                                                                            MD058830
     C+  ,EDPASN                                                                            MD058830
     C+  ,ED0MXL                                                                            MD058830
     C+  ,ED0DMS                                                                            MD058830
     C+  ,ED0MI1                                                                            MD058830
     C+  ,ED0MI2                                                                            MD058830
     C+  ,ED0MI3                                                                            MD058830
     C+  ,ED0MI4                                                                            MD058830
     C+  ,ED0MI5                                                                            MD058830
     C+  ,ED0MI6                                                                            MD058830
     C+  ,ED1AER                                                                            MD058830
     C+  ,ED1SER                                                                            MD058830
     C+  ,ED1AGS                                                                            MD058830
     C+  ,ED1SGS                                                                            MD058830
     C+  ,ED1AMR                                                                            MD058830
     C+  ,ED1SMR                                                                            MD058830
     C+  ,ED1MXL                                                                            MD058830
     C+  ,ED1GNM                                                                            MD058830
     C+  ,ED1RPL                                                                            MD058830
     C+  ,ED1RSP                                                                            MD058830
     C+  ,ED1MI1                                                                            MD058830
     C+  ,ED1MI2                                                                            MD058830
     C+  ,ED1MI3                                                                            MD058830
     C+  ,ED1MI4                                                                            MD058830
     C+  ,ED1MI5                                                                            MD058830
     C+  ,ED1MI6                                                                            MD058830
     C+  ,ED2AER                                                                            MD058830
     C+  ,ED2SER                                                                            MD058830
     C+  ,ED2AGS                                                                            MD058830
     C+  ,ED2SGS                                                                            MD058830
     C+  ,ED2AMR                                                                            MD058830
     C+  ,ED2SMR                                                                            MD058830
     C+  ,ED2MXL                                                                            MD058830
     C+  ,ED2GNM                                                                            MD058830
     C+  ,ED2FNI                                                                            MD058830
     C+  ,ED2NIM                                                                            MD058830
     C+  ,ED2RPL                                                                            MD058830
     C+  ,ED2RSP                                                                            MD058830
     C+  ,ED2MI1                                                                            MD058830
     C+  ,ED2MI2                                                                            MD058830
     C+  ,ED2MI3                                                                            MD058830
     C+  ,ED2MI4                                                                            MD058830
     C+  ,ED2MI5                                                                            MD058830
     C+  ,ED2MI6                                                                            MD058830
     C+  ,ED5MXL                                                                            MD058830
     C+  ,ED5DMS                                                                            MD058830
     C+  ,EDPFRQ                                                                            MD058830
     C+  ,EDRFNP                                                                            MD058830
     C+  ,EDRFSD                                                                            MD058830
     C+  ,EDRFST                                                                            MD058830
     C+  ,EDRFSS                                                                            MD058830
     C+  ,EDFEXU                                                                            MD058830
     C+  ,EDRPNM                                                                            MD058830
     C+  ,EDTSNM                                                                            MD058830
     C+  ,EDSUID                                                                            MD058830
     C+  ,EDSRVP                                                                            MD058830
     C+  ,EDEXTP                                                                            MD058830
     C+  ,EDTRTP                                                                            MD058830
     C+  ,EDACNF                                                                            MD058830
     C+  ,EDMCNW                                                                            MD058830
     C+  ,ED0F61                                                                            MD058830
     C+  ,ED2F61                                                                            MD058830
     C+  ,ED5F61                                                                            MD058830
     C+  ,EDF86F                                                                            MD058830
     C+  ,EDNOLN                                                                            MD058830
     C+  ,EDNCLN                                                                            MD058830
     C+  ,EDLSEP                                                                            MD058830
     C+  ,EDWTXT                                                                            MD058830
     C+  ,EDTRLN                                                                            MD058830
     C+  ,EDMGLN                                                                            MD058830
     C+  ,EDKLSP                                                                            MD058830
     C+  ,EDEXET                                                                            MD058830
     C+  ,EDEXFM                                                                            MD058830
     C+  ,EDGVCD                                                                            MD058830
     C+  ,EDGVCC                                                                            MD058830
     C+  ,EDFSEP                                                                            MD058830
     C+  ,EDFXTR                                                                            MD058830
     C+  ,EDCONV                                                                            MD058830
     C+  ,EDMODE                                                                            MD058830
     C+ )                                                                                   MD058830
     C+ Values                                                                              MD058830
     C+ (                                                                                   MD058830
     C+   :EDNWRK                                                                           MD058830
     C+  ,:EDNETD                                                                           MD058830
     C+  ,:EDLCD                                                                            MD058830
     C+  ,:EDTYLC                                                                           MD058830
     C+  ,:EDPROT                                                                           MD058830
     C+  ,:EDM940                                                                           MD058830
     C+  ,:EDM941                                                                           MD058830
     C+  ,:EDM942                                                                           MD058830
     C+  ,:EDM950                                                                           MD058830
     C+  ,:EDAMDS                                                                           MD058830
     C+  ,:EDENRA                                                                           MD058830
     C+  ,:EDRPSR                                                                           MD058830
     C+  ,:EDPASS                                                                           MD058830
     C+  ,:EDPASN                                                                           MD058830
     C+  ,:ED0MXL                                                                           MD058830
     C+  ,:ED0DMS                                                                           MD058830
     C+  ,:ED0MI1                                                                           MD058830
     C+  ,:ED0MI2                                                                           MD058830
     C+  ,:ED0MI3                                                                           MD058830
     C+  ,:ED0MI4                                                                           MD058830
     C+  ,:ED0MI5                                                                           MD058830
     C+  ,:ED0MI6                                                                           MD058830
     C+  ,:ED1AER                                                                           MD058830
     C+  ,:ED1SER                                                                           MD058830
     C+  ,:ED1AGS                                                                           MD058830
     C+  ,:ED1SGS                                                                           MD058830
     C+  ,:ED1AMR                                                                           MD058830
     C+  ,:ED1SMR                                                                           MD058830
     C+  ,:ED1MXL                                                                           MD058830
     C+  ,:ED1GNM                                                                           MD058830
     C+  ,:ED1RPL                                                                           MD058830
     C+  ,:ED1RSP                                                                           MD058830
     C+  ,:ED1MI1                                                                           MD058830
     C+  ,:ED1MI2                                                                           MD058830
     C+  ,:ED1MI3                                                                           MD058830
     C+  ,:ED1MI4                                                                           MD058830
     C+  ,:ED1MI5                                                                           MD058830
     C+  ,:ED1MI6                                                                           MD058830
     C+  ,:ED2AER                                                                           MD058830
     C+  ,:ED2SER                                                                           MD058830
     C+  ,:ED2AGS                                                                           MD058830
     C+  ,:ED2SGS                                                                           MD058830
     C+  ,:ED2AMR                                                                           MD058830
     C+  ,:ED2SMR                                                                           MD058830
     C+  ,:ED2MXL                                                                           MD058830
     C+  ,:ED2GNM                                                                           MD058830
     C+  ,:ED2FNI                                                                           MD058830
     C+  ,:ED2NIM                                                                           MD058830
     C+  ,:ED2RPL                                                                           MD058830
     C+  ,:ED2RSP                                                                           MD058830
     C+  ,:ED2MI1                                                                           MD058830
     C+  ,:ED2MI2                                                                           MD058830
     C+  ,:ED2MI3                                                                           MD058830
     C+  ,:ED2MI4                                                                           MD058830
     C+  ,:ED2MI5                                                                           MD058830
     C+  ,:ED2MI6                                                                           MD058830
     C+  ,:ED5MXL                                                                           MD058830
     C+  ,:ED5DMS                                                                           MD058830
     C+  ,:EDPFRQ                                                                           MD058830
     C+  ,:EDRFNP                                                                           MD058830
     C+  ,:EDRFSD                                                                           MD058830
     C+  ,:EDRFST                                                                           MD058830
     C+  ,:EDRFSS                                                                           MD058830
     C+  ,:EDFEXU                                                                           MD058830
     C+  ,:EDRPNM                                                                           MD058830
     C+  ,:EDTSNM                                                                           MD058830
     C+  ,:EDSUID                                                                           MD058830
     C+  ,:EDSRVP                                                                           MD058830
     C+  ,:EDEXTP                                                                           MD058830
     C+  ,:EDTRTP                                                                           MD058830
     C+  ,:EDACNF                                                                           MD058830
     C+  ,:EDMCNW                                                                           MD058830
     C+  ,:ED0F61                                                                           MD058830
     C+  ,:ED2F61                                                                           MD058830
     C+  ,:ED5F61                                                                           MD058830
     C+  ,:EDF86F                                                                           MD058830
     C+  ,:EDNOLN                                                                           MD058830
     C+  ,:EDNCLN                                                                           MD058830
     C+  ,:EDLSEP                                                                           MD058830
     C+  ,:EDWTXT                                                                           MD058830
     C+  ,:EDTRLN                                                                           MD058830
     C+  ,:EDMGLN                                                                           MD058830
     C+  ,:EDKLSP                                                                           MD058830
     C+  ,:EDEXET                                                                           MD058830
     C+  ,:EDEXFM                                                                           MD058830
     C+  ,:EDGVCD                                                                           MD058830
     C+  ,:EDGVCC                                                                           MD058830
     C+  ,:EDFSEP                                                                           MD058830
     C+  ,:EDFXTR                                                                           MD058830
     C+  ,:EDCONV                                                                           MD058830
     C+  ,'B'                                                                               MD058830
     C+ )                                                                                   MD058830
     C/END-EXEC                                                                             MD058830
     C/EXEC SQL                                                                             MD058830
     C+ insert into SDNWKXTD                                                                MD058830
     C+ (                                                                                   MD058830
     C+   EDNWRK                                                                            MD058830
     C+  ,EDNETD                                                                            MD058830
     C+  ,EDLCD                                                                             MD058830
     C+  ,EDTYLC                                                                            MD058830
     C+  ,EDPROT                                                                            MD058830
     C+  ,EDM940                                                                            MD058830
     C+  ,EDM941                                                                            MD058830
     C+  ,EDM942                                                                            MD058830
     C+  ,EDM950                                                                            MD058830
     C+  ,EDAMDS                                                                            MD058830
     C+  ,EDENRA                                                                            MD058830
     C+  ,EDRPSR                                                                            MD058830
     C+  ,EDPASS                                                                            MD058830
     C+  ,EDPASN                                                                            MD058830
     C+  ,ED0MXL                                                                            MD058830
     C+  ,ED0DMS                                                                            MD058830
     C+  ,ED0MI1                                                                            MD058830
     C+  ,ED0MI2                                                                            MD058830
     C+  ,ED0MI3                                                                            MD058830
     C+  ,ED0MI4                                                                            MD058830
     C+  ,ED0MI5                                                                            MD058830
     C+  ,ED0MI6                                                                            MD058830
     C+  ,ED1AER                                                                            MD058830
     C+  ,ED1SER                                                                            MD058830
     C+  ,ED1AGS                                                                            MD058830
     C+  ,ED1SGS                                                                            MD058830
     C+  ,ED1AMR                                                                            MD058830
     C+  ,ED1SMR                                                                            MD058830
     C+  ,ED1MXL                                                                            MD058830
     C+  ,ED1GNM                                                                            MD058830
     C+  ,ED1RPL                                                                            MD058830
     C+  ,ED1RSP                                                                            MD058830
     C+  ,ED1MI1                                                                            MD058830
     C+  ,ED1MI2                                                                            MD058830
     C+  ,ED1MI3                                                                            MD058830
     C+  ,ED1MI4                                                                            MD058830
     C+  ,ED1MI5                                                                            MD058830
     C+  ,ED1MI6                                                                            MD058830
     C+  ,ED2AER                                                                            MD058830
     C+  ,ED2SER                                                                            MD058830
     C+  ,ED2AGS                                                                            MD058830
     C+  ,ED2SGS                                                                            MD058830
     C+  ,ED2AMR                                                                            MD058830
     C+  ,ED2SMR                                                                            MD058830
     C+  ,ED2MXL                                                                            MD058830
     C+  ,ED2GNM                                                                            MD058830
     C+  ,ED2FNI                                                                            MD058830
     C+  ,ED2NIM                                                                            MD058830
     C+  ,ED2RPL                                                                            MD058830
     C+  ,ED2RSP                                                                            MD058830
     C+  ,ED2MI1                                                                            MD058830
     C+  ,ED2MI2                                                                            MD058830
     C+  ,ED2MI3                                                                            MD058830
     C+  ,ED2MI4                                                                            MD058830
     C+  ,ED2MI5                                                                            MD058830
     C+  ,ED2MI6                                                                            MD058830
     C+  ,ED5MXL                                                                            MD058830
     C+  ,ED5DMS                                                                            MD058830
     C+  ,EDPFRQ                                                                            MD058830
     C+  ,EDRFNP                                                                            MD058830
     C+  ,EDRFSD                                                                            MD058830
     C+  ,EDRFST                                                                            MD058830
     C+  ,EDRFSS                                                                            MD058830
     C+  ,EDFEXU                                                                            MD058830
     C+  ,EDRPNM                                                                            MD058830
     C+  ,EDTSNM                                                                            MD058830
     C+  ,EDSUID                                                                            MD058830
     C+  ,EDEXTP                                                                            MD058830
     C+  ,EDTRTP                                                                            MD058830
     C+  ,EDACNF                                                                            MD058830
     C+  ,EDMCNW                                                                            MD058830
     C+  ,ED0F61                                                                            MD058830
     C+  ,ED2F61                                                                            MD058830
     C+  ,ED5F61                                                                            MD058830
     C+  ,EDF86F                                                                            MD058830
     C+  ,EDNOLN                                                                            MD058830
     C+  ,EDNCLN                                                                            MD058830
     C+  ,EDLSEP                                                                            MD058830
     C+  ,EDWTXT                                                                            MD058830
     C+  ,EDTRLN                                                                            MD058830
     C+  ,EDMGLN                                                                            MD058830
     C+  ,EDKLSP                                                                            MD058830
     C+  ,EDEXET                                                                            MD058830
     C+  ,EDEXFM                                                                            MD058830
     C+  ,EDGVCD                                                                            MD058830
     C+  ,EDGVCC                                                                            MD058830
     C+  ,EDFSEP                                                                            MD058830
     C+  ,EDFXTR                                                                            MD058830
     C+  ,EDCONV                                                                            MD058830
     C+  ,EDMODE                                                                            MD058830
     C+ )                                                                                   MD058830
     C+ Values                                                                              MD058830
     C+ (                                                                                   MD058830
     C+   :EDNWRK                                                                           MD058830
     C+  ,:EDNETD                                                                           MD058830
     C+  ,:EDLCD                                                                            MD058830
     C+  ,:EDTYLC                                                                           MD058830
     C+  ,:EDPROT                                                                           MD058830
     C+  ,:EDM940                                                                           MD058830
     C+  ,:EDM941                                                                           MD058830
     C+  ,:EDM942                                                                           MD058830
     C+  ,:EDM950                                                                           MD058830
     C+  ,:EDAMDS                                                                           MD058830
     C+  ,:EDENRA                                                                           MD058830
     C+  ,:EDRPSR                                                                           MD058830
     C+  ,:EDPASS                                                                           MD058830
     C+  ,:EDPASN                                                                           MD058830
     C+  ,:ED0MXL                                                                           MD058830
     C+  ,:ED0DMS                                                                           MD058830
     C+  ,:ED0MI1                                                                           MD058830
     C+  ,:ED0MI2                                                                           MD058830
     C+  ,:ED0MI3                                                                           MD058830
     C+  ,:ED0MI4                                                                           MD058830
     C+  ,:ED0MI5                                                                           MD058830
     C+  ,:ED0MI6                                                                           MD058830
     C+  ,:ED1AER                                                                           MD058830
     C+  ,:ED1SER                                                                           MD058830
     C+  ,:ED1AGS                                                                           MD058830
     C+  ,:ED1SGS                                                                           MD058830
     C+  ,:ED1AMR                                                                           MD058830
     C+  ,:ED1SMR                                                                           MD058830
     C+  ,:ED1MXL                                                                           MD058830
     C+  ,:ED1GNM                                                                           MD058830
     C+  ,:ED1RPL                                                                           MD058830
     C+  ,:ED1RSP                                                                           MD058830
     C+  ,:ED1MI1                                                                           MD058830
     C+  ,:ED1MI2                                                                           MD058830
     C+  ,:ED1MI3                                                                           MD058830
     C+  ,:ED1MI4                                                                           MD058830
     C+  ,:ED1MI5                                                                           MD058830
     C+  ,:ED1MI6                                                                           MD058830
     C+  ,:ED2AER                                                                           MD058830
     C+  ,:ED2SER                                                                           MD058830
     C+  ,:ED2AGS                                                                           MD058830
     C+  ,:ED2SGS                                                                           MD058830
     C+  ,:ED2AMR                                                                           MD058830
     C+  ,:ED2SMR                                                                           MD058830
     C+  ,:ED2MXL                                                                           MD058830
     C+  ,:ED2GNM                                                                           MD058830
     C+  ,:ED2FNI                                                                           MD058830
     C+  ,:ED2NIM                                                                           MD058830
     C+  ,:ED2RPL                                                                           MD058830
     C+  ,:ED2RSP                                                                           MD058830
     C+  ,:ED2MI1                                                                           MD058830
     C+  ,:ED2MI2                                                                           MD058830
     C+  ,:ED2MI3                                                                           MD058830
     C+  ,:ED2MI4                                                                           MD058830
     C+  ,:ED2MI5                                                                           MD058830
     C+  ,:ED2MI6                                                                           MD058830
     C+  ,:ED5MXL                                                                           MD058830
     C+  ,:ED5DMS                                                                           MD058830
     C+  ,:EDPFRQ                                                                           MD058830
     C+  ,:EDRFNP                                                                           MD058830
     C+  ,:EDRFSD                                                                           MD058830
     C+  ,:EDRFST                                                                           MD058830
     C+  ,:EDRFSS                                                                           MD058830
     C+  ,:EDFEXU                                                                           MD058830
     C+  ,:EDRPNM                                                                           MD058830
     C+  ,:EDTSNM                                                                           MD058830
     C+  ,:EDSUID                                                                           MD058830
     C+  ,:EDEXTP                                                                           MD058830
     C+  ,:EDTRTP                                                                           MD058830
     C+  ,:EDACNF                                                                           MD058830
     C+  ,:EDMCNW                                                                           MD058830
     C+  ,:ED0F61                                                                           MD058830
     C+  ,:ED2F61                                                                           MD058830
     C+  ,:ED5F61                                                                           MD058830
     C+  ,:EDF86F                                                                           MD058830
     C+  ,:EDNOLN                                                                           MD058830
     C+  ,:EDNCLN                                                                           MD058830
     C+  ,:EDLSEP                                                                           MD058830
     C+  ,:EDWTXT                                                                           MD058830
     C+  ,:EDTRLN                                                                           MD058830
     C+  ,:EDMGLN                                                                           MD058830
     C+  ,:EDKLSP                                                                           MD058830
     C+  ,:EDEXET                                                                           MD058830
     C+  ,:EDEXFM                                                                           MD058830
     C+  ,:EDGVCD                                                                           MD058830
     C+  ,:EDGVCC                                                                           MD058830
     C+  ,:EDFSEP                                                                           MD058830
     C+  ,:EDFXTR                                                                           MD058830
     C+  ,:EDCONV                                                                           MD058830
     C+  ,'B'                                                                               MD058830
     C+ )                                                                                   MD058830
     C/END-EXEC                                                                             MD058830
      *
     C******IN91         IFEQ      '1'                                                      MD058830
     C     SQLCODE       IFNE      0                                                        MD058830
      *
      * Write error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Write successful.
      * USER: Processing after DBF update
     C                   Z-ADD     1             WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOIN                         No. of Inserts
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SCCHRC
      * 00/Copy member SD2001RCAU - Message Network Details  *
     C*00/Copy member           Processing After Create
     C/COPY WNCPYSRC,SD2001RCAU
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   SCCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(12)       AHFLNM                         Filename
      *
     C     KLCHSC        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSC        CHAIN     @AHREAU                            9091      *           MD061007
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
     C                   GOTO      SCEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SCEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
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
     CSR   SCEXIT        ENDSR
      /EJECT
     CSR   SDDLRC        BEGSR
      *================================================================
      * Delete Message Network - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before DBF update
      *CASE:     PAR.Action Code is Delete
     C     P2ANCD        IFEQ      @CN(06)                                      *IF
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(08)                                      *IF
      * WM call Window Manager - Window manager  *
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      @CN(06)       UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      *CASE:     PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(07)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(09)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(11)                                      *IF
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD2001RDBW - Message Network Details  *
     C*00/Copy member           Proc Before Delete - WN
     C/COPY WNCPYSRC,SD2001RDBW
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(10)       W0RTN                          *Return code
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
      * 00/Copy member SD2001RDBU - Message Network Details  *
     C*00/Copy member           Processing Before Delete
     C/COPY WNCPYSRC,SD2021RDBU
      * Move key fields to @EDREJY
     C                   MOVEL     #1NWRK        EDNWRK                         Network
      *
     C     KLDLSD        KLIST
     C                   KFLD                    EDNWRK                         Network
     C*****KLDLSD        CHAIN     @EDREJY                            9091      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
     C     *IN90         IFEQ      '1'
      * Record already deleted.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SDEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SDEXIT
     C                   END
      *
      * Check for changed record.
     C                   eval      @1DBRC = SDNWRK                                          MD058830
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C*****KLDLSD        SETLL     @EDREJY                            9091      *           MD058830
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Do no allow deletion of core Network                                                MD058830
     C     EDMODE        IFEQ      'C'                                                      MD058830
     C                   MOVEL     'USR0554'     ZAMSID                                     MD058830
     C                   MOVEL     'USR0554'     W0RTN                                      MD058830
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD058830
     C                   EXSR      ZASNMS                                                   MD058830
     C                   GOTO      SDEXIT                                                   MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
      *................................................................
     C**********         DELETE    @EDREJY                              91      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ delete from SDNWKBTD                                                                MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C/EXEC SQL                                                                             MD058830
     C+ delete from SDNWKXTD                                                                MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C******IN91         IFEQ      '1'                                                      MD058830
     C     SQLCODE       IFNE      0                                                        MD058830
      * Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Delete successful.
      * USER: Processing after DBF update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDNWRKPD'    PAFNME                         File name
     C                   MOVEL     #1NWRK        PALKEY                         Long Key
     C                   MOVEL     WUDR01        PADR01                         Deleted Data Re
     C                   MOVEL     WUDR02        PADR02                         Deleted Data Re
     C                   MOVEL     WUDR03        PADR03                         Deleted Data Re
     C                   MOVEL     WUDR04        PADR04                         Deleted Data Re
     C                   MOVEL     WUDR05        PADR05                         Deleted Data Re
     C                   MOVEL     WUDR06        PADR06                         Deleted Data Re
     C                   MOVEL     WUDR07        PADR07                         Deleted Data Re
     C                   MOVEL     WUDR08        PADR08                         Deleted Data Re
     C                   MOVEL     WUDR09        PADR09                         Deleted Data Re
     C                   MOVEL     WUDR00        PADR00                         Deleted Data Re
     C                   MOVEL     WUDR11        PADR11                         Deleted Data Re
     C                   MOVEL     WUDR12        PADR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        PALCD                          Last Change Dat
     C                   MOVEL     'D'           PATYLC                         Type of Last Ch
      *
     C                   CALL      'SD0520X'                            90      Write Deleted R
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           RCD: SD Deleted
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD0520X'     W0CLPG
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
     C                   Z-ADD     -1            WUNORC                         No. of Records
     C                   Z-ADD     1             WUNODL                         No. of Deletes
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SECHRC
      * 00/Copy member SD2001RDAU - Message Network Details  *
     C*00/Copy member           Processing After Delete
     C/COPY WNCPYSRC,SD2001RDAU
     C                   END
      *================================================================
     CSR   SDEXIT        ENDSR
      /EJECT
     CSR   SECHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(12)       AHFLNM                         Filename
      *
     C     KLCHSE        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSE        CHAIN     @AHREAU                            9091      *           MD061007
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
     C                   GOTO      SEEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SEEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
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
     CSR   SEEXIT        ENDSR
      /EJECT
     CSR   SFCHRC        BEGSR
      *================================================================
      * Change Message Network - Message Network Details  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @EDREJY
     C                   MOVEL     #1NWRK        EDNWRK                         Network
      *
     C     KLCHSF        KLIST
     C                   KFLD                    EDNWRK                         Network
     C*****KLCHSF        CHAIN     @EDREJY                            9091      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ SELECT *                                                                            MD058830
     C+ into :SDNWRK                                                                        MD058830
     C+ from SDNWKJW0                                                                       MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       90                    MD058830
     C                   If        SQLCODE = 100                                            MD058830
     C                   SETON                                        90                    MD058830
     C                   ENDIF                                                              MD058830
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
                                                                                            MD058830
      *
     C     *IN90         IFEQ      '1'
      * Record not found.
     C                   MOVEL     'Y2U0009'     W0RTN             7
      * Send message '*Record no longer on file'
     C                   MOVEL     'Y2U0009'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SFEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SFEXIT
     C                   END
      *
      * Check for changed record.
     C                   eval      @1DBRC = SDNWRK                                          MD058830
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C*****KLCHSF        SETLL     @EDREJY                            9091      *           MD058830
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      * Move Non-key fields to @EDREJY
     C                   MOVEL     #1NETD        EDNETD                         Network Descrip
     C                   Z-ADD     WURDNB        EDLCD                          Last Change Dat
     C                   MOVEL     @CN(13)       EDTYLC                         Type of Last Ch
      *
      * USER: Processing before DBF update
      * Window Processing
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(08)                                      *IF
      * WM call Window Manager - Window manager  *
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      @CN(13)       UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      *CASE:     PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(07)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(09)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(11)                                      *IF
     C                   MOVEL     @CN(08)       W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD2001RBUW - Message Network Details  *
     C*00/Copy member           Before Update, Window on
     C/COPY WNCPYSRC,SD2001RBUW
     C                   END                                                    *FI
      * 00/Copy member SD2001RBDU - Message Network Details  *
     C*00/Copy member           Processing Before Update
     C/COPY WNCPYSRC,SD2001RBDU
     C**********         UPDATE    @EDREJY                              91      *           MD058830
     C/EXEC SQL                                                                             MD058830
     C+ update SDNWKXTD set                                                                 MD058830
     C+   EDNETD = :EDNETD                                                                  MD058830
     C+  ,EDLCD  = :EDLCD                                                                   MD058830
     C+  ,EDTYLC = :EDTYLC                                                                  MD058830
     C+  ,EDPROT = :EDPROT                                                                  MD058830
     C+  ,EDM940 = :EDM940                                                                  MD058830
     C+  ,EDM941 = :EDM941                                                                  MD058830
     C+  ,EDM942 = :EDM942                                                                  MD058830
     C+  ,EDM950 = :EDM950                                                                  MD058830
     C+  ,EDAMDS = :EDAMDS                                                                  MD058830
     C+  ,EDENRA = :EDENRA                                                                  MD058830
     C+  ,EDRPSR = :EDRPSR                                                                  MD058830
     C+  ,EDPASS = :EDPASS                                                                  MD058830
     C+  ,EDPASN = :EDPASN                                                                  MD058830
     C+  ,ED0MXL = :ED0MXL                                                                  MD058830
     C+  ,ED0DMS = :ED0DMS                                                                  MD058830
     C+  ,ED0MI1 = :ED0MI1                                                                  MD058830
     C+  ,ED0MI2 = :ED0MI2                                                                  MD058830
     C+  ,ED0MI3 = :ED0MI3                                                                  MD058830
     C+  ,ED0MI4 = :ED0MI4                                                                  MD058830
     C+  ,ED0MI5 = :ED0MI5                                                                  MD058830
     C+  ,ED0MI6 = :ED0MI6                                                                  MD058830
     C+  ,ED1AER = :ED1AER                                                                  MD058830
     C+  ,ED1SER = :ED1SER                                                                  MD058830
     C+  ,ED1AGS = :ED1AGS                                                                  MD058830
     C+  ,ED1SGS = :ED1SGS                                                                  MD058830
     C+  ,ED1AMR = :ED1AMR                                                                  MD058830
     C+  ,ED1SMR = :ED1SMR                                                                  MD058830
     C+  ,ED1MXL = :ED1MXL                                                                  MD058830
     C+  ,ED1GNM = :ED1GNM                                                                  MD058830
     C+  ,ED1RPL = :ED1RPL                                                                  MD058830
     C+  ,ED1RSP = :ED1RSP                                                                  MD058830
     C+  ,ED1MI1 = :ED1MI1                                                                  MD058830
     C+  ,ED1MI2 = :ED1MI2                                                                  MD058830
     C+  ,ED1MI3 = :ED1MI3                                                                  MD058830
     C+  ,ED1MI4 = :ED1MI4                                                                  MD058830
     C+  ,ED1MI5 = :ED1MI5                                                                  MD058830
     C+  ,ED1MI6 = :ED1MI6                                                                  MD058830
     C+  ,ED2AER = :ED2AER                                                                  MD058830
     C+  ,ED2SER = :ED2SER                                                                  MD058830
     C+  ,ED2AGS = :ED2AGS                                                                  MD058830
     C+  ,ED2SGS = :ED2SGS                                                                  MD058830
     C+  ,ED2AMR = :ED2AMR                                                                  MD058830
     C+  ,ED2SMR = :ED2SMR                                                                  MD058830
     C+  ,ED2MXL = :ED2MXL                                                                  MD058830
     C+  ,ED2GNM = :ED2GNM                                                                  MD058830
     C+  ,ED2FNI = :ED2FNI                                                                  MD058830
     C+  ,ED2NIM = :ED2NIM                                                                  MD058830
     C+  ,ED2RPL = :ED2RPL                                                                  MD058830
     C+  ,ED2RSP = :ED2RSP                                                                  MD058830
     C+  ,ED2MI1 = :ED2MI1                                                                  MD058830
     C+  ,ED2MI2 = :ED2MI2                                                                  MD058830
     C+  ,ED2MI3 = :ED2MI3                                                                  MD058830
     C+  ,ED2MI4 = :ED2MI4                                                                  MD058830
     C+  ,ED2MI5 = :ED2MI5                                                                  MD058830
     C+  ,ED2MI6 = :ED2MI6                                                                  MD058830
     C+  ,ED5MXL = :ED5MXL                                                                  MD058830
     C+  ,ED5DMS = :ED5DMS                                                                  MD058830
     C+  ,EDPFRQ = :EDPFRQ                                                                  MD058830
     C+  ,EDRFNP = :EDRFNP                                                                  MD058830
     C+  ,EDRFSD = :EDRFSD                                                                  MD058830
     C+  ,EDRFST = :EDRFST                                                                  MD058830
     C+  ,EDRFSS = :EDRFSS                                                                  MD058830
     C+  ,EDFEXU = :EDFEXU                                                                  MD058830
     C+  ,EDRPNM = :EDRPNM                                                                  MD058830
     C+  ,EDTSNM = :EDTSNM                                                                  MD058830
     C+  ,EDSUID = :EDSUID                                                                  MD058830
     C+  ,EDEXTP = :EDEXTP                                                                  MD058830
     C+  ,EDTRTP = :EDTRTP                                                                  MD058830
     C+  ,EDACNF = :EDACNF                                                                  MD058830
     C+  ,EDMCNW = :EDMCNW                                                                  MD058830
     C+  ,ED0F61 = :ED0F61                                                                  MD058830
     C+  ,ED2F61 = :ED2F61                                                                  MD058830
     C+  ,ED5F61 = :ED5F61                                                                  MD058830
     C+  ,EDF86F = :EDF86F                                                                  MD058830
     C+  ,EDNOLN = :EDNOLN                                                                  MD058830
     C+  ,EDNCLN = :EDNCLN                                                                  MD058830
     C+  ,EDLSEP = :EDLSEP                                                                  MD058830
     C+  ,EDWTXT = :EDWTXT                                                                  MD058830
     C+  ,EDTRLN = :EDTRLN                                                                  MD058830
     C+  ,EDMGLN = :EDMGLN                                                                  MD058830
     C+  ,EDKLSP = :EDKLSP                                                                  MD058830
     C+  ,EDEXET = :EDEXET                                                                  MD058830
     C+  ,EDEXFM = :EDEXFM                                                                  MD058830
     C+  ,EDGVCD = :EDGVCD                                                                  MD058830
     C+  ,EDGVCC = :EDGVCC                                                                  MD058830
     C+  ,EDFSEP = :EDFSEP                                                                  MD058830
     C+  ,EDFXTR = :EDFXTR                                                                  MD058830
     C+  ,EDCONV = :EDCONV                                                                  MD058830
     C+ where EDNWRK = :EDNWRK                                                              MD058830
     C/END-EXEC                                                                             MD058830
     C                   SETOFF                                       91                    MD058830
     C                   If        SQLCODE <> 0                                             MD058830
     C                   SETON                                        91                    MD058830
     C                   ENDIF                                                              MD058830
     C     *IN91         IFEQ      '1'
      * Change error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Change successful.
      * Update saved record image.
     C                   MOVEL     @1DBRC        #1DBRC
      * USER: Processing after DBF update
     C                   Z-ADD     *ZERO         WUNORC                         No. of Records
     C                   Z-ADD     *ZERO         WUNOIN                         No. of Inserts
     C                   Z-ADD     *ZERO         WUNODL                         No. of Deletes
     C                   Z-ADD     1             WUNOAM                         No. of Amends
      * Change Standing Data Cont - Standing Data Controls  *
     C                   EXSR      SGCHRC
      * 00/Copy member SD2001RADU - Message Network Details  *
     C*00/Copy member           Processing After Update
     C/COPY WNCPYSRC,SD2001RADU
     C                   END
      *================================================================
     CSR   SFEXIT        ENDSR
      /EJECT
     CSR   SGCHRC        BEGSR
      *================================================================
      * Change Standing Data Cont - Standing Data Controls  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @AHREAU
     C                   MOVEL     @CN(12)       AHFLNM                         Filename
      *
     C     KLCHSG        KLIST
     C                   KFLD                    AHFLNM                         Filename
     C*****KLCHSG        CHAIN     @AHREAU                            9091      *           MD061007
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
     C                   GOTO      SGEXIT
     C                   END
      *
     C     *IN91         IFEQ      '1'
      * Record locked.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   GOTO      SGEXIT
     C                   END
      *
      * USER: Processing after DBF read
     C                   ADD       AHNORC        WUNORC                         No. of Records
     C                   ADD       AHNOIN        WUNOIN                         No. of Inserts
     C                   ADD       AHNOAM        WUNOAM                         No. of Amends
     C                   ADD       AHNODL        WUNODL                         No. of Deletes
      * Move Non-key fields to @AHREAU
     C                   Z-ADD     WUNORC        AHNORC                         No. of Records
     C                   Z-ADD     WUNOIN        AHNOIN                         No. of Inserts
     C                   Z-ADD     WUNOAM        AHNOAM                         No. of Amends
     C                   Z-ADD     WUNODL        AHNODL                         No. of Deletes
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
     CSR   SGEXIT        ENDSR
      /EJECT
     CSR   SHRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSH         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list.
     C                   MOVEL     @CN(16)       BGMODS                         Modules
     C     KRSSH         CHAIN     @BGREC8                            90        *
      * DBF Record not found.
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process DBF record
      *CASE:     DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      @CN(08)                                      *IF
     C                   MOVEL     @CN(08)       WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SHEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record.
      *================================================================
      * Name search required ?
     C                   MOVEL     #1NWRK        WK1X01            1            Network
     C     WK1X01        IFEQ      '?'                                          Network
     C                   CALL      'SD2000S'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C     #1NWRK        PARM      #1NWRK        WQ0001            6            Network
     C     *IN90         IFEQ      '1'
      * Call to program ended in error.
     C                   MOVEL     'Y2U0021'     W0RTN             7
     C                   END
     C                   MOVEL     'Y'           W0DCF             1            Defer confirm
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
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
     CSR   ZHHPKY        BEGSR
      *================================================================
      * Display HELP text.
      *================================================================
     C                   MOVEL     'Y'           W0HLP             1            Signal help req
     C                   CALL      'YDDSHPR'
     C                   PARM      ##PGM         W0HPMB           10            Member name.
     C                   PARM      *BLANK        YYHPFL           10            *DFT text file.
     C                   PARM      *BLANK        YYHPLB           10            Help text lib.
     C                   PARM                    W0RTN             7            Return Code.
      *================================================================
     CSR   ZHEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Cancel and exit from key screen.
      *================================================================
      * USER: Exit program processing
      * Window Processing
      * 00/Copy member SD2001REPP - Message Network Details  *
     C*00/Copy member           Exit Program Processing
     C/COPY WNCPYSRC,SD2001REPP
      * Fast Exit Processing
      *CASE:     KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(07)       P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct.
      *================================================================
      * ROLLBACK any uncommitted DBF changes.
     C                   ROLBK                                          90
      *
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
      * Obtain default message file.
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field If value in key field
     C                   MOVEL     *BLANK        WUIVKF            1
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Define work field WM action code
     C                   MOVEL     *BLANK        WUWMAC            1
      * Define work field No. of Records
     C                   Z-ADD     *ZERO         WUNORC            5 0
      * Define work field No. of Amends
     C                   Z-ADD     *ZERO         WUNOAM            5 0
      * Define work field No. of Deletes
     C                   Z-ADD     *ZERO         WUNODL            5 0
      * Define work field No. of Inserts
     C                   Z-ADD     *ZERO         WUNOIN            5 0
      * Define work field Deleted Data Record Pt1
     C                   MOVEL     *BLANK        WUDR01          250
      * Define work field Deleted Data Record Pt2
     C                   MOVEL     *BLANK        WUDR02          250
      * Define work field Deleted Data Record Pt3
     C                   MOVEL     *BLANK        WUDR03          250
      * Define work field Deleted Data Record Pt4
     C                   MOVEL     *BLANK        WUDR04          250
      * Define work field Deleted Data Record Pt5
     C                   MOVEL     *BLANK        WUDR05          250
      * Define work field Deleted Data Record Pt6
     C                   MOVEL     *BLANK        WUDR06          250
      * Define work field Deleted Data Record Pt7
     C                   MOVEL     *BLANK        WUDR07          250
      * Define work field Deleted Data Record Pt8
     C                   MOVEL     *BLANK        WUDR08          250
      * Define work field Deleted Data Record Pt9
     C                   MOVEL     *BLANK        WUDR09          250
      * Define work field Deleted Data Record Pt10
     C                   MOVEL     *BLANK        WUDR00          250
      * Define work field Deleted Data Record Pt11
     C                   MOVEL     *BLANK        WUDR11          250
      * Define work field Deleted Data Record Pt12
     C                   MOVEL     *BLANK        WUDR12          250
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Open files.
      * Begin commit control.
     C                   CALL      'Y2BGCMC'
     C                   PARM                    W0RTN             7
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'CPF8351'
     C                   EXSR      ZYEXPG
     C                   END
     C**********         OPEN      SDNWRKL0                                                 MD058830
     C**********         OPEN      SDFCTLL0                                                 MD061007
      * Select initial mode.
     C     @1NROP        IFEQ      *ZERO
     C                   MOVEL     'ADD'         W0PMD             3            Add mode
     C                   ELSE
     C                   MOVEL     'CHG'         W0PMD                          Change mode
     C                   END
      * USER: Initialise program
      * Standard RPG Creation PAR - Standard Functions  *
      * Copyright Statement - Standard Functions  *
      * Last Amend Box SD2001R - Message Network Details  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT                         RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Mode Processing
      *CASE:     PAR.Action Code is Insert
     C     P2ANCD        IFEQ      @CN(01)                                      *IF
     C                   MOVEL     @CN(14)       W0PMD                          *Program mode
     C                   ELSE
      *CASE:     *OTHERWISE
     C                   MOVEL     @CN(15)       W0PMD                          *Program mode
     C                   END                                                    *FI
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SHRVGN
      * Message Network Data DS - Message Network Details  *
      * 00/Copy Member SD2001RFPG - Message Network Details  *
     C/COPY WNCPYSRC,SD2001RCPG
      *================================================================
     CSR   ZZEXIT        ENDSR
     O/COPY WNCPYSRC,SD2001ROPG
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @CN
I
?
*
Y2U0005
Y2U0003
D
Y2U9999
Y
USR0563
Y2U0004
USR0790
SDNWRKPD
A
ADD
CHG
MMOD
