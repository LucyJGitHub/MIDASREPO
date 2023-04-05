     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD060008
/*STD *  RPGSQLBND                                                    *                     MD060008
/*EXI *  TEXT('Midas SD Message type maintenance subfile')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD2031R - Midas SD Edit Message Type 1rec                    *
      *                                                               *
      *  Function:  This program allows the user to maintain details  *
      *             on Message Types                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD060008           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD003             Date 01Jul99               *
      *                 S01459             Date 01Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD060008 - Deliverable Data Split for Standing Data 2        *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *                                                               *
      *****************************************************************
     F*00/Copy member           Initialise Program F-spec
     F/COPY WNCPYSRC,SD2031RFPG
     FSD2031R#  CF   E             WORKSTN
     F                                     INFDS(INFDS#)
      * DSP: Edit Message Type 1rec    Edit record(1 screen)
      *
     F*SDMTPYL1* IF   E           K DISK                                                    MD060008
     F**********                           INFDS(INFDS1)                                    MD060008
      * RTV: Message Type Descriptions Retrieval index
      *
     FSDMMODL1  IF   E           K DISK
      * RTV: MIDAS Modules             Retrieval index
      *
     F*SDMTPYL0* UF A E           K DISK    USROPN                                          MD060008
     F**********                           COMMIT                                           MD060008
      * UPD: Message Type Descriptions Update index
      *
     F*SDFCTLL0* UF   E           K DISK    USROPN                                          MD061007
     F**********                           COMMIT                                           MD061007
      * UPD: Standing Data Controls    Update index
      *
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D @CN             S             25    DIM(16) CTDATA PERRCD(1)             Long constants.
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*COPY*QWINDSRC,SD2030GDTA                                                             MD060008
     D/COPY QWINDSRC,SD2030GDTL                                                             MD060008
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
     D*@1DBRC***     E DS                  EXTNAME(SDMTPYL0)                                MD060008
     D @1DBRC        E DS                  EXTNAME(SDMTYJW0)                                MD060008
     D                                     PREFIX(X)                                        MD060008
     D SDMTPY        E DS                  EXTNAME(SDMTYJW0)                                MD060008
      * Current/previous master file format fields for change control.
      *
     D*#1DBRC***       DS            42                                                     MD060008
     D #1DBRC          DS            43                                                     MD060008
      * Stored master file format fields.
     D  #1DB1                  1      1
      *
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
     D P1PARM          DS            42
      * RCD: Message Type Descriptions Retrieval index
      * I:MAP Message Type
     D  P1MTPY                 1      3
     D P2PARM          DS
      * I:    Action Code
     D  P2ANCD                 1      1
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Question Mark Invalid'
      * Message Type
     D  ZA0001                 1      3
      * Message data for 'Key Field Invalid Value'
      * If value in key field
     D  ZA0002                 1      1
      * Message Type
     D  ZA0003                 2      4
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
     C                   PARM                    P1PARM                         RCD: Message Ty
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
     C     #1MTPY        IFEQ      *BLANK                                       Message Type
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
     C                   KFLD                    EEMTPY                         Message Type
      * Setup key.
     C                   MOVEL     #1MTPY        EEMTPY                         Message Type
     C*****KRTV*         CHAIN     @EEREJ2                            9091      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :SDMTPY                                                                        MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C                   SETOFF                                       9091                  MD060008
     C                   If        SQLCODE = 100                                            MD060008
     C                   SETON                                        90                    MD060008
     C                   ENDIF                                                              MD060008
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD060008
     C                   SETON                                        91                    MD060008
     C                   ENDIF                                                              MD060008
                                                                                            MD060008
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
      * Send message 'Message Type Descripti NF'
     C                   MOVEL     'USR1539'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   EXSR      MBFL#1
      * CALC: Detail screen function fields
      * 00/Copy Member SD2031RSFF - Message Type Descriptions  *
     C*00/Copy member           Calc Detail Function Flds
     C/COPY WNCPYSRC,SD2031RSFF
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
      * 00/Copy Member SD2031RISE - Message Type Descriptions  *
     C*00/Copy member           Initialise Dtl Exist Rcd
     C/COPY WNCPYSRC,SD2031RISE
     C                   END
      *
     C                   ELSE
      * If record already exists, error
     C     *IN90         IFEQ      '0'
     C                   SETON                                        9931      *
      * Send message 'Message Type Descripti EX'
     C                   MOVEL     'USR1540'     ZAMSID                         Message id.
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
      * 00/Copy Member SD2031RISN - Message Type Descriptions  *
     E* Y2V3114 - RPG source member  not found.
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
     C                   MOVEL     #1MTPY        WUTQKF                         Test ? in Key F
     C                   MOVEL     #1MTPY        WUIVKF                         If value in key
      * Ensure no invalid values
      *CASE:     WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      @CN(02)                                      *IF
      * Setup message data for message.
     C                   MOVEL     #1MTPY        ZA0001                         Message Type
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
     C                   MOVEL     #1MTPY        ZA0003                         Message Type
      * Send message 'Key Field Invalid Value'
     C                   MOVEL     'USR0849'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        9931      *
      *
     C                   GOTO      BFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Retrieve Message Type Des - Message Type Descriptions  *
     C                   EXSR      SARVGN
      * send error message if record already exists
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
      * 00/Copy Member SD2031RVKS - Message Type Descriptions  *
     C*00/Copy member           Validate Key Screen
     C/COPY WNCPYSRC,SD2031RVKS
      * Message Type required.
     C     #1MTPY        IFEQ      *BLANK                                       IF
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
      * 00/Copy Member SD2031RPKR - Message Type Descriptions  *
     C*00/Copy member           Process Key Screen Rqst
     C/COPY WNCPYSRC,SD2031RPKR
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
     C                   MOVEL     @CN(06)       P0RTN                          *Return code
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
     C     P2ANCD        IFEQ      @CN(07)                                      *IF
      * Send message 'F3/F10/F12 only valid opt'
     C                   MOVEL     'USR0536'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   GOTO      DCEXIT                                       *QUIT
     C                   END                                                    *FI
      * 00/Copy Member SD2031RVSF - Message Type Descriptions  *
     C*00/Copy member           Validate Detail Screen
     C/COPY WNCPYSRC,SD2031RVSF
      * CALC: Detail screen function fields
      * 00/Copy Member SD2031RSFF - Message Type Descriptions  *
     C*00/Copy member           Calc Detail Function Flds
     C/COPY WNCPYSRC,SD2031RSFF
      * USER: Validate detail screen relations
      * 00/Copy Member SD2031RVSR - Message Type Descriptions  *
     C*00/Copy member           Validate Screen Relns
     C/COPY WNCPYSRC,SD2031RVSR
      * Message Type Description required.
     C     #1MTPD        IFEQ      *BLANK                                       IF
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
      * 00/Copy Member SD2031RPCK - Message Type Descriptions  *
     C*00/Copy member           Process Command Keys
     C/COPY WNCPYSRC,SD2031RPCK
      *CASE:     DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(08)       P0RTN                          *Return code
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
      * Create Message Type - Message Type Descriptions  *
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
      * Delete Message Type - Message Type Descriptions  *
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
      * Change Message Type - Message Type Descriptions  *
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
     C     P1MTPY        IFEQ      *BLANK                                       Message Type
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
     C                   MOVEL     *BLANK        #1MTPD                         Message Type De
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   MBFL#1        BEGSR
      *================================================================
      * Move @EEREJ2 fields to screen.
      *================================================================
     C                   Z-ADD     EELCD         #1LCD                          Last Change Dat
     C                   MOVEL     EETYLC        #1TYLC                         Type of Last Ch
     C                   MOVEL     EEMTPY        #1MTPY                         Message Type
     C                   MOVEL     EEMTPD        #1MTPD                         Message Type De
      * Hold existing record image.
     C                   eval      @1DBRC = SDMTPY                                          MD060008
     C                   MOVEL     @1DBRC        #1DBRC
      *================================================================
     CSR   MBEXIT        ENDSR
      /EJECT
     CSR   MDIZ#K        BEGSR
      *================================================================
      * Initialise key screen.
      *================================================================
     C                   MOVEL     P1MTPY        #1MTPY                         Message Type
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
      * 00/Copy Member SD2031RIKS - Message Type Descriptions  *
     C*00/Copy member           Initialise Key Screen
     C/COPY WNCPYSRC,SD2031RIKS
      *================================================================
     CSR   MDEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Message Type Des - Message Type Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define Keylist.
     C     KRSSA         KLIST
     C                   KFLD                    EEMTPY                         Message Type
      * Move fields to key list.
     C                   MOVEL     #1MTPY        EEMTPY                         Message Type
     C*****KRSSA         CHAIN     @EEREJ2                            90        *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :SDMTPY                                                                        MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C                   SETOFF                                       90                    MD060008
     C                   If        SQLCODE = 100                                            MD060008
     C                   SETON                                        90                    MD060008
     C                   ENDIF                                                              MD060008
     C     *IN90         IFEQ      '1'
      * DBF Record not found.
     C                   MOVEL     'USR1539'     W0RTN             7
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
      * Create Message Type - Message Type Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @EEREJ1
     C                   MOVEL     #1MTPY        EEMTPY                         Message Type
     C                   MOVEL     #1MTPD        EEMTPD                         Message Type De
     C                   Z-ADD     WURDNB        EELCD                          Last Change Dat
     C                   MOVEL     @CN(01)       EETYLC                         Type of Last Ch
      *
      * USER: Processing before DBF update
      * Window processing
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(09)                                      *IF
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
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(11)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(06)                                      *IF
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SBEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD2031RCBU - Message Type Descriptions  *
     C*00/Copy member           Processing Before Create
     C/COPY WNCPYSRC,SD2031RCBU
     C                   END                                                    *FI
     C     KLCRSB        KLIST
     C                   KFLD                    EEMTPY                         Message Type
      * Check for duplicate primary key.
     C*****KLCRSB        SETLL     @EEREJ1                                90    *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :SDMTPY                                                                        MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C                   SETOFF                                       90                    MD060008
     C                   If        SQLCODE =  0                                             MD060008
     C                   SETON                                        90                    MD060008
     C                   ENDIF                                                              MD060008
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR1540'     W0RTN             7
      * Send message 'Message Type Descripti EX'
     C                   MOVEL     'USR1540'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      SBEXIT
     C                   END
      *
     C**********         WRITE     @EEREJ1                              91      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ insert into SDMTYBTD                                                                MD060008
     C+ (                                                                                   MD060008
     C+   EEMTPY                                                                            MD060008
     C+  ,EEMTPD                                                                            MD060008
     C+  ,EELCD                                                                             MD060008
     C+  ,EETYLC                                                                            MD060008
     C+  ,EEMODE                                                                            MD060008
     C+ )                                                                                   MD060008
     C+ Values                                                                              MD060008
     C+ (                                                                                   MD060008
     C+   :EEMTPY                                                                           MD060008
     C+  ,:EEMTPD                                                                           MD060008
     C+  ,:EELCD                                                                            MD060008
     C+  ,:EETYLC                                                                           MD060008
     C+  ,'B'                                                                               MD060008
     C+ )                                                                                   MD060008
     C/END-EXEC                                                                             MD060008
     C/EXEC SQL                                                                             MD060008
     C+ insert into SDMTYXTD                                                                MD060008
     C+ (                                                                                   MD060008
     C+   EEMTPY                                                                            MD060008
     C+  ,EEMTPD                                                                            MD060008
     C+  ,EELCD                                                                             MD060008
     C+  ,EETYLC                                                                            MD060008
     C+  ,EEMODE                                                                            MD060008
     C+ )                                                                                   MD060008
     C+ Values                                                                              MD060008
     C+ (                                                                                   MD060008
     C+   :EEMTPY                                                                           MD060008
     C+  ,:EEMTPD                                                                           MD060008
     C+  ,:EELCD                                                                            MD060008
     C+  ,:EETYLC                                                                           MD060008
     C+  ,'B'                                                                               MD060008
     C+ )                                                                                   MD060008
     C/END-EXEC                                                                             MD060008
      *
     C******IN91         IFEQ      '1'                                                      MD060008
     C     SQLCODE       IFNE      0                                                        MD060008
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
      * 00/Copy Member SD2031RCAU - Message Type Descriptions  *
     C*00/Copy member           Processing After Create
     C/COPY WNCPYSRC,SD2031RCAU
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
      * Delete Message Type - Message Type Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * USER: Processing before DBF update
      *CASE:     PAR.Action Code is Delete
     C     P2ANCD        IFEQ      @CN(07)                                      *IF
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(09)                                      *IF
      * WM call Window Manager - Window manager  *
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      @CN(07)       UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      *CASE:     PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(11)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(06)                                      *IF
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD2031RDBW - Message Type Descriptions  *
     C*00/Copy member           Proc Before Delete - WN
     C/COPY WNCPYSRC,SD2031RDBW
     C                   END                                                    *FI
     C                   ELSE
      *CASE:     *OTHERWISE
      * Send message 'Function key not allowed'
     C                   MOVEL     'USR0533'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(11)       W0RTN                          *Return code
     C                   GOTO      SDEXIT                                       *QUIT
     C                   END                                                    *FI
      * 00/Copy Member SD2031RDBU - Message Type Descriptions  *
     C*00/Copy member           Processing Before Delete
     C/COPY WNCPYSRC,SD2031RDBU
      * Move key fields to @EEREJ1
     C                   MOVEL     #1MTPY        EEMTPY                         Message Type
      *
     C     KLDLSD        KLIST
     C                   KFLD                    EEMTPY                         Message Type
     C*****KLDLSD        CHAIN     @EEREJ1                            9091      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :SDMTPY                                                                        MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C                   SETOFF                                       9091                  MD060008
     C                   If        SQLCODE = 100                                            MD060008
     C                   SETON                                        90                    MD060008
     C                   ENDIF                                                              MD060008
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD060008
     C                   SETON                                        91                    MD060008
     C                   ENDIF                                                              MD060008
                                                                                            MD060008
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
     C                   eval      @1DBRC = SDMTPY                                          MD060008
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C*****KLDLSD        SETLL     @EEREJ1                            9091      *           MD060008
     C                   GOTO      SDEXIT
     C                   END                                                    FI #1DBRC
      * Do not allow deletion of core record                                                MD060008
     C     EEMODE        IFEQ      'C'                                                      MD060008
     C                   MOVEL     'USR0552'     ZAMSID                                     MD060008
     C                   MOVEL     'USR0552'     W0RTN                                      MD060008
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                                     MD060008
     C                   EXSR      ZASNMS                                                   MD060008
     C                   GOTO      SDEXIT                                                   MD060008
     C                   ENDIF                                                              MD060008
                                                                                            MD060008
      *................................................................
     C**********         DELETE    @EEREJ1                              91      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ delete from SDMTYBTD                                                                MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C/EXEC SQL                                                                             MD060008
     C+ delete from SDMTYXTD                                                                MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C******IN91         IFEQ      '1'                                                      MD060008
     C     SQLCODE       IFNE      0                                                        MD060008
      * Delete error detected.
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
      * DBF Delete successful.
      * USER: Processing after DBF update
      * WUDELR Data Structure - SD Deleted Records File  *
     C                   MOVEL     @1DBRC        WUDELR
      * Write Deleted Record - SD Deleted Records File  *
     C                   CLEAR                   PARC
     C                   MOVEL     'SDMTPYPD'    PAFNME                         File name
     C                   MOVEL     #1MTPY        PALKEY                         Long Key
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
      * 00/Copy Member SD2031RDAU - Message Type Descriptions  *
     C*00/Copy member           Processing After Delete
     C/COPY WNCPYSRC,SD2031RDAU
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
      * Change Message Type - Message Type Descriptions  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move key fields to @EEREJ1
     C                   MOVEL     #1MTPY        EEMTPY                         Message Type
      *
     C     KLCHSF        KLIST
     C                   KFLD                    EEMTPY                         Message Type
     C*****KLCHSF        CHAIN     @EEREJ1                            9091      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ SELECT *                                                                            MD060008
     C+ into :SDMTPY                                                                        MD060008
     C+ from SDMTYJW0                                                                       MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C                   SETOFF                                       9091                  MD060008
     C                   If        SQLCODE = 100                                            MD060008
     C                   SETON                                        90                    MD060008
     C                   ENDIF                                                              MD060008
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD060008
     C                   SETON                                        91                    MD060008
     C                   ENDIF                                                              MD060008
                                                                                            MD060008
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
     C                   eval      @1DBRC = SDMTPY                                          MD060008
     C     #1DBRC        IFNE      @1DBRC                                       IF
     C                   MOVEL     'Y2U0007'     W0RTN             7
      * Send message '*Update not accepted'
     C                   MOVEL     'Y2U0007'     ZAMSID                         Message id.
     C                   MOVEL     'Y2USRMSG'    ZAMSGF                         Message file.
     C                   EXSR      ZASNMS                                       Send message
      * Use SETLL to release record lock.
     C*****KLCHSF        SETLL     @EEREJ1                            9091      *           MD060008
     C                   GOTO      SFEXIT
     C                   END                                                    FI #1DBRC
      * Move Non-key fields to @EEREJ1
     C                   MOVEL     #1MTPD        EEMTPD                         Message Type De
     C                   Z-ADD     WURDNB        EELCD                          Last Change Dat
     C                   MOVEL     @CN(13)       EETYLC                         Type of Last Ch
      *
      * USER: Processing before DBF update
      * Window Processing
      *CASE:     WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      @CN(09)                                      *IF
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
     C     W0RTN         IFEQ      @CN(08)                                      *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      *CASE:     PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      @CN(10)                                      *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      @CN(11)                                      *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   SETON                                        99        *
      *
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   ELSE
      *CASE:     PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      @CN(06)                                      *IF
     C                   MOVEL     @CN(09)       W0DCF                          *Defer confirm
     C                   GOTO      SFEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy Member SD2031RBUW - Message Type Descriptions  *
     C*00/Copy member           Before Update, Window on
     C/COPY WNCPYSRC,SD2031RBUW
     C                   END                                                    *FI
      * 00/Copy Member SD2031RBDU - Message Type Descriptions  *
     C*00/Copy member           Processing Before Update
     C/COPY WNCPYSRC,SD2031RBDU
     C**********         UPDATE    @EEREJ1                              91      *           MD060008
     C/EXEC SQL                                                                             MD060008
     C+ update SDMTYXTD set                                                                 MD060008
     C+   EEMTPD = :EEMTPD                                                                  MD060008
     C+  ,EELCD  = :EELCD                                                                   MD060008
     C+  ,EETYLC = :EETYLC                                                                  MD060008
     C+ where EEMTPY = :EEMTPY                                                              MD060008
     C/END-EXEC                                                                             MD060008
     C******IN91         IFEQ      '1'                                                      MD060008
     C                   If        SQLCODE <> 0                                             MD060008
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
      * 00/Copy member SD2031RADU - Message Type Descriptions  *
     C*00/Copy member           Processing After Update
     C/COPY WNCPYSRC,SD2031RADU
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
     C     BGWDPR        IFEQ      @CN(09)                                      *IF
     C                   MOVEL     @CN(09)       WUWDPR                         Window processi
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
     C                   MOVEL     #1MTPY        WK1X01            1            Message Type
     C     WK1X01        IFEQ      '?'                                          Message Type
     C                   CALL      'SD2030S'                            90      *
     C                   PARM                    W0RTN             7            Return code
     C     #1MTPY        PARM      #1MTPY        WQ0001            3            Message Type
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
      * 00/Copy Member SD2031REPP - Message Type Descriptions  *
     C*00/Copy member           Exit Program Processing
     C/COPY WNCPYSRC,SD2031REPP
      * Fast Exit Processing
      *CASE:     KEY.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     @CN(08)       P0RTN                          *Return code
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
     C**********         OPEN      SDMTPYL0                                                 MD060008
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
      * Last Amend Box SD2031R - Message Type Descriptions  *
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
      * Message Type Data DS - Message Type Descriptions  *
      * 00/Copy Member SD2031RFPG - Message Type Descriptions  *
      *================================================================
     CSR   ZZEXIT        ENDSR
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @CN
I
?
*
Y2U0005
Y2U0003
USR0790
D
Y2U9999
Y
USR0563
Y2U0004
SDMTPYPD
A
ADD
CHG
MMOD
