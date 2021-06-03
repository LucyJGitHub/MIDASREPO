     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056567
/*STD *  RPGSQLBND                                                    *                     MD056567
/*EXI *  TEXT('Midas SD Key Screen for Cust Group Pmpt & val')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD1411V -  Midas SD Customer grouping codes retrieval        *
      *                                                               *
      *  Function:  This program prompts fields, allowing user changes*
      *             validates fields, if valid, performs an action    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056567           Date 20Sep20               *
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
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD056567 - Deliverable Data Split for Validation Lists       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  S01459 - Addition of Midas Headerbox.                        *
      *                                                               *
      *****************************************************************
     F*Y2VLLSL0* IF   E           K DISK                                                    MD056567
      * Values list details file
      *
     F/COPY WNCPYSRC,SD1411VFPG
     FSD1411V#  CF   E             WORKSTN USROPN
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      * DSP: Midas SD Key Screen for Cust Group Pmpt & val
      *
     FSDCGRPL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Customer grouping codes retrieval
      *
     FSDMMODL1  IF   E           K DISK    USROPN
     F                                     INFDS(ID0002)
     F                                     INFSR(*PSSR)
      * RTV : Midas SD Midas module flags retrieval
      *
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D/COPY WNCPYSRC,SD1411VEPG
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D*COPY*QWINDSRC,SD1410GDTA                                                             MD056567
     D/COPY QWINDSRC,SD1410GDTL                                                             MD056567
     D*00/Copy member SD1411V   Initialise Program I-Spec
     D/COPY WNCPYSRC,SD1411VIPG
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
      * Outward parameters
     D PARC            DS             5
      * KEY : Midas SD Customer grouping codes retrieval
      * I : MAP Set Number
     D  PASNBR                 1      1
      * I : MAP Group Code
     D  PAGPCD                 2      5
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
     D ID0001          DS           528
      * File information data structure
      *
     D ID0002          DS           528
      * File information data structure
      *
     D                 DS
     D  ZAMSDA                 1    132
      * Message data for 'Set Number not valid'
      * Work Set Number
     D  ZA0001                 1      1
      * Message data for 'Group Code blank'
      * Group Code
     D  ZA0002                 1      4
      * Message data for 'Question Mark Invalid'
      * Key Field
     D  ZA0003                 1     10
      * Message data for 'Asterisk invalid'
      * Region Name
     D  ZA0004                 1     30
      * Message data for 'Customer Grouping exists'
      * Set Number
     D  ZA0005                 1      1
      * Group Code
     D  ZA0006                 2      5
     D Y2VLLS        E DS                  EXTNAME(Y2VLLJW0)                                MD056567
     D  Y2LSNO       E                     EXTFLD(@@CND)                                    MD056567
     D  Y2CNTP       E                     EXTFLD(CNDTYP)                                   MD056567
     D  Y2EXVL       E                     EXTFLD(EXTVAL)                                   MD056567
     D  Y2INVL       E                     EXTFLD(INTVAL)                                   MD056567
     D  Y2CNTX       E                     EXTFLD(CNDTXT)                                   MD056567
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Conduct screen conversation
     C                   DO        *HIVAL
      * Start new transaction
     C                   MOVEL     'Y'           W0TRN             1
      * Process current transaction
     C     W0TRN         DOWEQ     'Y'
      * Display screen
     C                   EXSR      CAEXFM
      * Process response
      * Cancel & exit program
     C   03              CAS                     ZXEXPG
      * HOME: Reset screen fields
     C   05              CAS                     MALDSC
      * Process screen input
     C                   CAS                     DAPRSC
     C                   END
      *
     C                   END
      *
     C                   END
      *****************************************************************
      /EJECT
     CSR   CAEXFM        BEGSR
      *================================================================
      * Display screen and process HELP requests
      *================================================================
      * Update screen time
     C                   TIME                    ##TME
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      * Enable PUTOVR
     C                   SETON                                        86
      * Set cursor by *SET CURSOR data
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y0SET
     C                   END
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #RCDDTL1
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
     C     YSETCS        IFEQ      'Y'
     C                   EXSR      Y9CLR
     C                   END
      *================================================================
     CSR   CAEXIT        ENDSR
      /EJECT
     CSR   DAPRSC        BEGSR
      *================================================================
      * Process screen input
      *================================================================
      * Confirm/update is not deferred
     C                   MOVEL     'N'           W0DCF             1
      * USER: Process command keys
      * 00/Copy member SD1411VPCK - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Process Command Keys
     C/COPY WNCPYSRC,SD1411VPCK
      * CASE: DTL.*CMD key is CF12
     C     *IN12         IFEQ      '1'                                          *IF
     C                   MOVEL     'USR0790'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
      * Validate screen input
     C                   EXSR      DBVLSC
      * If error, exit
     C     *IN99         CABEQ     '1'           DAEXIT
      * Defer confirm/update requested
     C     W0DCF         CABEQ     'Y'           DAEXIT
      * Prompt for confirmation
     C                   EXSR      DHPMCF
      * Quit if not confirmed
     C     *IN99         CABEQ     '1'           DAEXIT
      * USER: User defined action
      * CASE: WRK.Window processing requir. is Yes
     C     WUWDPR        IFEQ      'Y'                                          *IF
      * WM call Window Manager - Window manager  *
     C/COPY WNCPYSRC,WN0481CCP1                                           S01408
     C***********          CALL 'WIND01'                                  S01212
     C                   CALL      'WN0010'                                                    S0121
     C*********************PARM           ##PGM            Program        S01212
     C                   PARM      ##PGM         UPGM             10            Program        S0121
     C*********************PARM *BLANK    FKEY    2        Function Key   S01212
     C                   PARM      *BLANK        UFKEY             2            Function Key   S0121
     C*********************PARM           WUMEST           Action  S01212 S01229
     C*********************PARM           WUWMAC           Action  S01212 S01229
     C                   PARM      'E'           UACTCD            1            Action  S01212 S0122
     C                   PARM                    DATA                           Trans Data     S0121
     C                   PARM      *BLANK        W0RTN                          Return Code    S0121
     C                   PARM                    SPARE           256            Spare Field    LN035
      * WM Check Return
      * CASE: PAR.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PAR.*Return code is WN Window Error
     C     W0RTN         IFEQ      'USR0563'                                    *IF
      * Send message 'WN Window Error'
     C                   MOVEL     'USR0563'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DAEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *DBF update error
     C     W0RTN         IFEQ      'Y2U0004'                                    *IF
      * Send message 'WN Database Error'
     C                   MOVEL     'USR0567'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DAEXIT                                       *QUIT
     C                   ELSE
      * CASE: PAR.*Return code is *Previous Screen
     C     W0RTN         IFEQ      'USR0790'                                    *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   GOTO      DAEXIT                                       *QUIT
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      * 00/Copy member SD1411VUDW - Customer Grouping Codes  *
     C*00/Copy member SD1411V   User Defined Action+Windw
     C/COPY WNCPYSRC,SD1411VUDW
     C                   END                                                    *FI
      * 00/Copy member SD1411VUDA - Customer Grouping Codes  *
     C*00/Copy member SD1411V   User Defined Action
     C/COPY WNCPYSRC,SD1411VUDA
      * Exit program
     C                   EXSR      ZXEXPG
      *================================================================
     CSR   DAEXIT        ENDSR
      /EJECT
     CSR   DBVLSC        BEGSR
      *================================================================
      * Validate screen input
      *================================================================
      * USER: Validate fields
      * Set Number Validation.
      * CASE: DTL.Work Set Number is Valid values (1 - 5)
     C     #DWSNB        IFEQ      '1'                                          *IF
     C     #DWSNB        OREQ      '2'
     C     #DWSNB        OREQ      '3'
     C     #DWSNB        OREQ      '4'
     C     #DWSNB        OREQ      '5'
     C                   MOVEL     #DWSNB        #1SNBR                         Set Number
     C                   ELSE
      * CASE: DTL.Work Set Number is Blank
     C     #DWSNB        IFEQ      *BLANK                                       *IF
      * If Set Number on screen left blank, move '*' into file field.
     C                   MOVEL     '*'           #1SNBR                         Set Number
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWSNB        ZA0001                         Work Set Number
      * Send message 'Set Number not valid'
     C                   MOVEL     'USR1475'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9931      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
      * Group Code Validation.
     C                   EXSR      UASUBR                                       Group Code Vali
      * 00/Copy member SD1411VVFI - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Validate Fields
     C/COPY WNCPYSRC,SD1411VVFI
      * Bypass ref file checks if error already detected
     C   99              GOTO      DBEXIT
      * Select existing record
     C                   EXSR      VACKRL
      * CALC: Screen function fields
      * 00/Copy member SD1411VSFI - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Calculate Function Flds
     C/COPY WNCPYSRC,SD1411VSFI
      * USER: Validate relations
      * Check existence of Customer Grouping.
     C                   EXSR      UBSUBR                                       Check existence
      * 00/Copy member SD1411VVRE - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Validate Screen Relations
     C/COPY WNCPYSRC,SD1411VVRE
      *================================================================
     CSR   DBEXIT        ENDSR
      /EJECT
     CSR   DHPMCF        BEGSR
      *================================================================
      * Prompt for confirmation
      *================================================================
      * Update screen time
     C                   TIME                    ##TME
      * Enable PUTOVR
     C                   SETON                                            86    *
      * Refresh screen
     C                   MOVEL     *BLANK        ##CFCD
     C                   MOVEL     'N'           ##CFCD
      * Save CMD keys
     C                   MOVEA     *IN           WN30             30
     C                   SETOFF                                       29        *
      * Generate internal/external key list
     C     KINEX         KLIST
     C                   KFLD                    Y2LSNO
     C                   KFLD                    Y2INVL
      * Convert *CONFIRM to external value
     C                   Z-ADD     1001713       Y2LSNO
     C                   MOVEL     *BLANK        Y2INVL
     C                   MOVEL     ##CFCD        Y2INVL                         *CONFIRM
     C*****KINEX         CHAIN     @Y2INEX                            90        *
     C/EXEC SQL                                                                             MD056567
     C+ SELECT *                                                                            MD056567
     C+ into :Y2VLLS                                                                        MD056567
     C+ from Y2VLLJW0                                                                       MD056567
     C+ where @@CND   = :Y2LSNO and VALMAP = 'Y' and CNDTYP = 'VAL'                         MD056567
     C+ and INTVAL = :Y2INVL                                                                MD056567
     C/END-EXEC                                                                             MD056567
     C                   setoff                                       90                    MD056567
     C                   If        SQLCODE = 100                                            MD056567
     C                   seton                                        90                    MD056567
     C                   Endif                                                              MD056567
     C  N90              MOVEL     Y2EXVL        V#CFCD                         *CONFIRM
      *
     C     W0HLP         DOUEQ     'N'
     C     *IN29         ANDEQ     '0'
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   WRITE     #RCDDTL1
     C                   EXFMT     #CONFIRM
      * Clear set cursor DDS indicator
     C     WCSRLC        IFEQ      'OFF'
     C                   SETOFF                                       94        *
     C                   END
     C                   MOVE      *BLANK        WCSRLC
      * If help requested, display help text
     C   25              EXSR      ZHHPKY
      * Validate *CONFIRM
     C                   MOVEL     *BLANK        W0RTN
     C                   MOVEL     V#CFCD        W0NSRQ            1            *CONFIRM
      * Name search required?
     C     W0NSRQ        IFEQ      '?'
     C                   CALL      'Y2VLLSR'                            90      *
     C                   PARM                    W0RTN             7
     C                   PARM      1001713       Y2LSNO            7 0
     C     V#CFCD        PARM      V#CFCD        W0EXVL           20            *CONFIRM
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      * Check external value of *CONFIRM
      * Generate internal/external key list
     C     KEXIN         KLIST
     C                   KFLD                    Y2LSNO
     C                   KFLD                    Y2EXVL
      * Convert *CONFIRM to internal value
     C                   Z-ADD     1001713       Y2LSNO
     C                   MOVEL     *BLANK        Y2EXVL
     C                   MOVEL     V#CFCD        Y2EXVL                         *CONFIRM
     C*****KEXIN         CHAIN     @Y2EXIN                            90        *           MD056567
     C/EXEC SQL                                                                             MD056567
     C+ SELECT *                                                                            MD056567
     C+ into :Y2VLLS                                                                        MD056567
     C+ from Y2VLLJW0                                                                       MD056567
     C+ where @@CND   = :Y2LSNO and EXTVAL >= :Y2EXVL and CNDTYP = 'VAL'                    MD056567
     C/END-EXEC                                                                             MD056567
     C                   setoff                                       90                    MD056567
     C                   If        SQLCODE = 100                                            MD056567
     C                   seton                                        90                    MD056567
     C                   Endif                                                              MD056567
     C     *IN90         IFEQ      '1'
     C                   MOVEL     *BLANK        ##CFCD
     C                   SETON                                        96        *
     C                   WRITE     #CONFIRM
     C                   SETOFF                                       96        *
     C                   ELSE
     C                   MOVEL     Y2INVL        ##CFCD                         *CONFIRM
     C                   END
      *
     C   90              SETON                                        29        *
     C  N90              SETOFF                                       29        *
     C                   END
      * Restore CMD keys
     C                   MOVEA     WN30          *IN
      * Update job time
     C                   TIME                    ##JTM
     C     ##CFCD        IFEQ      'Y'
      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      * Reset first message only flag
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   END
     C     ##CFCD        COMP      'Y'                                9999      *
      * Not confirmed
      *================================================================
     CSR   DHEXIT        ENDSR
      /EJECT
     CSR   MALDSC        BEGSR
      *================================================================
      * Load screen from passed parameters
      *================================================================
     C                   MOVEL     *BLANK        #1SNBR                         Set Number
     C                   Z-ADD     *ZERO         #1LCD                          Last Change Dat
     C                   MOVEL     *BLANK        #1TYLC                         Type of Last Ch
     C                   MOVEL     *BLANK        #1GPDS                         Group Descripti
     C                   MOVEL     *BLANK        #1NETG                         Net Group
     C                   MOVEL     *BLANK        #1NTCU                         Netting Settlmn
     C                   MOVEL     *BLANK        #1NTCP                         Net by Currency
     C                   Z-ADD     *ZERO         #1NTND                         Net Notice Days
     C                   MOVEL     *BLANK        #1NTMM                         Net Manual Matc
     C                   MOVEL     *BLANK        #DWSNB                         Work Set Number
     C                   MOVEL     *BLANK        #1GPCD                         Group Code
      * CALC: Screen function fields
      * 00/Copy member SD1411VSFI - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Calculate Function Flds
     C/COPY WNCPYSRC,SD1411VSFI
      * USER: Load screen
      * 00/Copy member SD1411VLSR - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Load Screen
     C/COPY WNCPYSRC,SD1411VLSR
      *================================================================
     CSR   MAEXIT        ENDSR
      /EJECT
     CSR   SARVGN        BEGSR
      *================================================================
      * Retrieve Customer Group - Customer Grouping Codes  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSA         KLIST
     C                   KFLD                    D6SNBR                         Set Number
     C                   KFLD                    D6GPCD                         Group Code
      * Move fields to key list
     C                   MOVEL     #1SNBR        D6SNBR                         Set Number
     C                   MOVEL     #1GPCD        D6GPCD                         Group Code
     C     KRSSA         CHAIN     @D6REI8                            90        *
     C     *IN90         IFEQ      '1'
      * Data record not found
     C                   MOVEL     'USR1462'     W0RTN             7
      * USER: Processing if Data record not found
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
     C                   GOTO      SAEXIT
     C                   END
      *
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
     C                   MOVEL     'Y2U0003'     W0RTN                          *Return code
      * PAR = DB1 By name
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   SBRVGN        BEGSR
      *================================================================
      * Get 'Window required' ind - MIDAS Modules  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Define keylist
     C     KRSSB         KLIST
     C                   KFLD                    BGMODS                         Modules
      * Move fields to key list
     C                   MOVE      *BLANK        BGMODS                         Modules
     C                   MOVEL     'MMOD'        BGMODS                         Modules
     C     KRSSB         CHAIN     @BGREC8                            90        *
      * Data record not found
     C   90              MOVEL     'USR0096'     W0RTN             7
     C     *IN90         IFEQ      '0'
      * USER: Process Data record
      * CASE: DB1.Window processing requir. is Yes
     C     BGWDPR        IFEQ      'Y'                                          *IF
     C                   MOVEL     'Y'           WUWDPR                         Window processi
     C                   END                                                    *FI
     C                   END
      *================================================================
     CSR   SBEXIT        ENDSR
      /EJECT
     CSR   UASUBR        BEGSR
      *================================================================
      * Group Code Validation.
      *================================================================
     C                   MOVEL     #1GPCD        WUTQKF                         Test ? in Key F
      * Group Code cannot be blank, or contain '?' or '*'.
      * CASE: DTL.Group Code is Blank
     C     #1GPCD        IFEQ      *BLANK                                       *IF
      * Setup message data for message
     C                   MOVEL     #1GPCD        ZA0002                         Group Code
      * Send message 'Group Code blank'
     C                   MOVEL     'USR1476'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.Test ? in Key Field is Question Mark
     C     WUTQKF        IFEQ      '?'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1GPCD        ZA0003                         Group Code
      * Send message 'Question Mark Invalid'
     C                   MOVEL     'USR0380'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   ELSE
      * CASE: WRK.Test ? in Key Field is Asterisk
     C     WUTQKF        IFEQ      '*'                                          *IF
      * Setup message data for message
     C                   MOVEL     #1GPCD        ZA0004                         Group Code
      * Send message 'Asterisk invalid'
     C                   MOVEL     'USR1164'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        9932      *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
      *================================================================
     CSR   UAEXIT        ENDSR
      /EJECT
     CSR   UBSUBR        BEGSR
      *================================================================
      * Check existence of Customer Grouping.
      *================================================================
      * Retrieve Customer Group - Customer Grouping Codes  *
     C                   EXSR      SARVGN
      * CASE: PGM.*Return code is *Record does not exist
     C     W0RTN         IFEQ      'Y2U0005'                                    *IF
      * Edit Cust Group Codes Rec - Customer Grouping Codes  *
     C                   CLEAR                   PARC
     C                   MOVEL     #1SNBR        PASNBR                         Set Number
     C                   MOVEL     #1GPCD        PAGPCD                         Group Code
      *
     C                   CALL      'SD1411R'                            90      Edit Cust Group
     C                   PARM      *BLANK        W0RTN             7
     C                   PARM                    PARC                           KEY: Customer G
     C                   PARM      'I'           WQ0003            1            Action Code
     C     WUWRTC        PARM      WUWRTC        WQ0004            5            Work Return cod
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD1411R'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C                   SETON                                        9932      *
     C                   END
      * Check Return Code.
      * CASE: PGM.*Return code is *User QUIT requested
     C     W0RTN         IFEQ      'Y2U9999'                                    *IF
     C                   MOVEL     W0RTN         P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   ELSE
      * CASE: PGM.*Return code is *Normal
     C     W0RTN         IFEQ      *BLANK                                       *IF
      * CASE: WRK.Work Return code is previous
     C     WUWRTC        IFEQ      'PREV'                                       *IF
     C                   MOVEL     'Y'           W0DCF                          *Defer confirm
     C                   ELSE
      * CASE: *OTHERWISE
     C                   MOVEL     *BLANK        #DWSNB                         Work Set Number
     C                   MOVEL     *BLANK        #1GPCD                         Group Code
      * Send message '*Record added'
     C                   MOVEL     'Y2U0011'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   SETON                                        99        *
      *
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   END                                                    *FI
     C                   ELSE
      * CASE: *OTHERWISE
      * Setup message data for message
     C                   MOVEL     #DWSNB        ZA0005                         Work Set Number
     C                   MOVEL     #1GPCD        ZA0006                         Group Code
      * Send message 'Customer Grouping exists'
     C                   MOVEL     'USR1477'     ZAMSID
     C                   EXSR      ZASNMS
     C                   SETON                                        993132    *
      *
     C                   END                                                    *FI
      *================================================================
     CSR   UBEXIT        ENDSR
      /EJECT
     CSR   VACKRL        BEGSR
      *================================================================
      * Select existing record
      *================================================================
      * Name search required?
     C                   MOVEL     #1SNBR        WK1X01            1
     C                   MOVEL     #1GPCD        WK1X02            1
     C     WK1X01        IFEQ      '?'                                          Set Number
     C     WK1X02        OREQ      '?'                                          Group Code
     C                   CALL      'SD1410S'                            90      Select Cust Gro
     C                   PARM      *BLANK        W0RTN             7
     C     #1SNBR        PARM      #1SNBR        WQ0001            1            Set Number
     C     #1GPCD        PARM      #1GPCD        WQ0002            4            Group Code
      *
     C     *IN90         IFEQ      '1'
      * Call to program ended in error
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG           10
     C                   MOVEL     'SD1410S'     W0CLPG
      * Send message '*Error occured on CALL...'
     C                   MOVEL     'Y2U0032'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   MOVEL     W0CLPG        ZAMSDA                         Message data
     C                   EXSR      ZASNMS
     C                   END
      *
      * Error detected?
     C     W0RTN         IFNE      *BLANK
     C     W0RTN         ANDNE     'Y2U0016'
     C                   SETON                                        9932      *
     C                   END
      * Defer confirm
     C                   MOVEL     'Y'           W0DCF             1
     C                   END
      *================================================================
     CSR   VAEXIT        ENDSR
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
      * 00/Copy member SD1411VEPP - Customer Grouping Codes  *
     C*00/Copy member SD1411V   Exit Program Processing
     C/COPY WNCPYSRC,SD1411VEPP
      * CASE: DTL.*CMD key is *Exit
     C     *IN03         IFEQ      '1'                                          *IF
     C                   MOVEL     'Y2U9999'     P0RTN                          *Return code
     C                   EXSR      ZYEXPG
     C                   END                                                    *FI
     C                   MOVEL     *BLANK        P0RTN
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
      * Define work field Window processing requir.
     C                   MOVEL     *BLANK        WUWDPR            1
      * Obtain default message file
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF           10
     C                   IN        ZADFMF
      * Define work field Test ? in Key Field
     C                   MOVEL     *BLANK        WUTQKF            1
      * Define work field Work Return code
     C                   MOVEL     *BLANK        WUWRTC            5
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
     C                   OPEN      SD1411V#
     C                   OPEN      SDCGRPL1
     C                   OPEN      SDMMODL1
     C                   MOVEL     'N'           W0PMT             1
     C                   MOVEL     *BLANK        W0GRP             1
      * USER: Initialize program
      * SD1411V PRECOMPILER - Customer Grouping Codes  *
      * Copyright Statement 1988 - Standard Functions  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Get 'Window required' ind - MIDAS Modules  *
     C                   EXSR      SBRVGN
      * Data Structure Cust Group - Customer Grouping Codes  *
      * 00/Copy member SD1411VIPG - Customer Grouping Codes  *
     C/COPY WNCPYSRC,SD1411VCPG
      * Load screen
     C                   EXSR      MALDSC
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
     C/COPY WNCPYSRC,SD1411VPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD1411VPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*SDCPYSRC,SDPSSRINT                                                              MD056567
     C/COPY SDCPYSRC,SDPSSRINTI                                                             MD056567
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD1411VPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
     O/COPY WNCPYSRC,SD1411VOPG
**CTDATA CPY@
(c) Finastra International Limited 2001
