     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Facilities Extract')                                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM038**-*GL*Facilities*Extract*******************************                       LUC109
      *  XX000038 - GL Facilities Extract                             *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Facilities Extract                                 *
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109CC1          Date 12Sep19               *
      *  Prev Amend No. LUC109             Date 20Sep16               *
      *                 MUI010             Date 10Mar04               *
      *                 LUC010             Date 22Aug01               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 10Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109CC1 - New York Amendments                              *
      *         - Use DLFS for facility start date.                   *
      *         - Exclude Closed Facilities.                          *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI010 - HOR Changes: add field C9821 (HO Facility Link).    *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Facilities Extract                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FFCLTYL9   IF   E           K DISK    INFSR(*PSSR)
     FSDACRCL9  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     FFCLTYY0   IF   E           K DISK    INFSR(*PSSR)
     FFECRL     O    E             DISK    INFSR(*PSSR)
     F***GLM038AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000038AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/FCLTYL9    File I/O                                 *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  88       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #PROC  - Main Processing                                     *
      *  #S200  - Detail Processing                                   *
      *  #ACKEY - Determine Account Codes                             *
      *  #BSPL  - Determine BSPL Details                              *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
     D SVALKK          C                   CONST('HOR_NY_Amendments')                      LUC109CC1
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @ERR            S             35    DIM(4) CTDATA PERRCD(1)
      *
      *
      ***File*information*for*printer*file*GLM037AU********************                       LUC109
      ** File information for printer file XX000037AU                                         LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** Header Record
      *
     D HEADER          DS
     D  FBKCD                  1      3
     D  FGPCD                  4      6
     D  FEXFL                  7     11
     D  FSYSD                 12     19
     D  FLACD                 20     27
     D  FLWDM                 28     35
     D  FNWKD                 36     43
     D  FILL01                44     78
      *
      ** Branch Header Record
      *
     D BRCHHD          DS
     D  FBRCD                  1      3
     D  FILL02                 4     78
      *
      ** Detail Record 1
      *
     D DET001          DS
     D  F1PROG                 1      3
     D  F1BKCD                 4      6
     D  F1BRCD                 7      9
     D  F1CUST                10     15  0
     D  F1FACT                16     18  0
     D  F1FACN                19     20  0
     D  @@REPK                10     20
     D  F1FCCI                21     21
     D  F1FCCY                22     24
     D  F1FAMT                25     43
     D  F1OVLN                44     51  5
     D  F1STDT                52     59
     D  F1EXDT                60     67
     D  F1RVCR                68     68
     D  F1MTCY                69     69
     D  F1MTCS                70     70
     D  F1CTRK                71     72
     D  F1STYI                73     73
     D  F1MTBR                74     74
     D  C9805                 75     75                                         LUC010
     D  C9806                 76     78                                         LUC010
     D************************************** 75  78 F1FILL                LUC010
      *
      ** Detail Record 2
      *
     D DET002          DS
     D  F2PROG                 1      3
     D  F2RVDT                 4     11
     D  F2ACOF                12     13
     D  F2PRCT                14     17
     D  F2ORBR                18     20
     D  F2NAR1                21     55
     D  C9809                 56     56                                         LUC010
     D  C9810                 57     64                                         LUC010
     D  F2FILL                65     78                                         LUC010
     D************************************** 56  78 F2FILL                LUC010
      *
      ** Detail Record 3
      *
     D DET003          DS
     D  F3PROG                 1      3
     D  F3NAR2                 4     38
     D  F3NAR3                39     73
     D  F3FILL                74     78
      *
      ** Detail Record 4
      *
     D DET004          DS
     D  F4PROG                 1      3
     D  F4NAR4                 4     38
     D  F4CRAT                39     42  0
     D  F4CCAT                43     46  0
     D  F4AMAM                47     65
     D  F4BSP1                66     69  0
     D  F4BSP2                70     73  0
     D  F4RKBR                74     76
     D  C9807                 77     77                                         LUC010
     D  C9808                 78     78                                         LUC010
     D************************************** 77  78 F4FILL                LUC010
      *                                                                   MUI010
      ** Detail Record 5                                                  MUI010
      *                                                                   MUI010
     D DET005          DS                                                       MUI010
     D  F5PROG                 1      3                                         MUI010
     D  F5LINK                 4     24                                         MUI010
     D  F5FILL                25     78                                         MUI010
      *
      ** Trailer Record
      *
     D TRAILR          DS
     D  FCONT                  1      6  0
     D  FILL04                 7     78
     D* DATESTAMP
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
     D* Account Key
     D @@ACK           DS
     D  @ACFL1                 1      3
     D  @ACFL2                 4      4
     D  @ACFIL                 5      7
     D  @ACFL3                 8      9
     D  @ACFL4                10     10
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
      **  Data Structure for AOSVALR0 string                                               LUC109CC1
     DSVAL1            DS           200                                                    LUC109CC1
     DSVAL11                   1      1                                                    LUC109CC1
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      #PROC                                        Main process
      *
     C                   EXSR      #TERM                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      ** Data definition
      *
      *
      *
      ** Initialise Database Error data structure
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     WLDA          DBERR
     C                   OUT       WLDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   Z-ADD     0             DBASE
      ** Key list/parameter list definition
      *
     C     @@KEY         KLIST
     C                   KFLD                    XXRSNO            1
     C                   KFLD                    XXACCD            4
     C                   KFLD                    XXDRCR            1
      ** Key list/parameter list definition for FCLTYY0
      *
     C     @@KEYA        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
     C                   CALL      'AOSVALR0'                                              LUC109CC1
     C                   PARM                    @RTCD             7                       LUC109CC1
     C                   PARM      SVALKK        SVALK1           20                       LUC109CC1
     C                   PARM      *BLANKS       SVAL1           200                       LUC109CC1
     C                   PARM                    SVALK2           20                       LUC109CC1
     C                   PARM                    SVAL2           200                       LUC109CC1
     C                   PARM                    SVALK3           20                       LUC109CC1
     C                   PARM                    SVAL3           200                       LUC109CC1
     C                   PARM                    SVALK4           20                       LUC109CC1
     C                   PARM                    SVAL4           200                       LUC109CC1
     C                   PARM                    SVALK5           20                       LUC109CC1
     C                   PARM                    SVAL5           200                       LUC109CC1
     C                   PARM                    SVALK6           20                       LUC109CC1
     C                   PARM                    SVAL6           200                       LUC109CC1
     C                   PARM                    SVALK7           20                       LUC109CC1
     C                   PARM                    SVAL7           200                       LUC109CC1
     C                   PARM                    SVALK8           20                       LUC109CC1
     C                   PARM                    SVAL8           200                       LUC109CC1
     C                   PARM                    SVALK9           20                       LUC109CC1
     C                   PARM                    SVAL9           200                       LUC109CC1
     C                   PARM                    SVALK0           20                       LUC109CC1
     C                   PARM                    SVAL10          200                       LUC109CC1
      *                                                                                    LUC109CC1
      ** If Set to use NY Amendments                                                       LUC109CC1
     C     SVAL11        IFEQ      'Y'                                                     LUC109CC1
     C                   MOVE      'Y'           NY_Amend          1                       LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   MOVE      'N'           NY_AMend                                  LUC109CC1
     C                   ENDIF                                                             LUC109CC1
                                                                                           LUC109CC1
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN98
     C                   MOVE      '9'           XXRSNO
      *
     C                   READ      SDBANKPD                               98    Bank details
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '001'         DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               98    Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '002'         DBASE                          ***************
     C                   MOVEL     'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      * Determine which Branch is used for bank/company code
     C     BJSLCD        CHAIN     SDINTFPD                           98        Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVEL     'SDINTFPD'    DBFILE                         * DB ERR  003 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      * Determine Bank/company code for header
     C     S9BRCH        CHAIN     SDBRCHL1                           98        Branch
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '004'         DBASE                          ***************
     C                   MOVEL     'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '006'         DBASE                          ***************
     C                   MOVEL     'SDGELRPD'    DBFILE                         * DB ERR  006 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C******************** MOVE *BLANKS   F1FILL                          LUC010
     C                   MOVE      *BLANKS       F2FILL
     C                   MOVE      *BLANKS       F3FILL
     C******************** MOVE *BLANKS   F4FILL                          LUC010
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         F1PROG
     C                   MOVE      '002'         F2PROG
     C                   MOVE      '003'         F3PROG
     C                   MOVE      '004'         F4PROG
     C                   MOVE      '005'         F5PROG                                        MUI01
     C                   MOVE      *BLANKS       @ACFIL
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FECRL'       FEXFL
      * System Date
     C                   MOVE      UDATE         @SYDT
     C     @@YYT         IFGT      50
     C                   MOVE      '19'          @@YY
     C                   ELSE
     C                   MOVE      '20'          @@YY
     C                   ENDIF
     C                   MOVE      DATST         FSYSD
      *
      * Last Accounting Date
     C                   MOVE      MLACT         FLACD
     C*                    CALL 'GLM053'
     C*                    PARM           BKAPDT
     C*                    PARM           FLACD
     C*                    PARM *ZERO     WFLACD  80
     C*                    MOVE WFLACD    FLACD
      * Last Working Day of Month
     C                   MOVE      MMDAT         FLWDM
      * Next Working Day
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD
     C*                    PARM           FNWKD
     C                   PARM      *ZERO         WFNWKD            8 0
     C                   MOVE      WFNWKD        FNWKD
      *
      *
      *  Write Header Record
     C                   MOVE      '00'          RECC
     C                   MOVE      HEADER        DATA
     C                   WRITE     FECRLF
     C                   Z-ADD     1             COUNT             6 0
      *
     C                   Z-ADD     *ZERO         ERRCNT            6 0
      * Write Error Report Header
     C                   WRITE     ERRHDR
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #PROC  -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S200                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      * Read all Branches
      *
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               20
      *
      *
     C     *IN20         DOWEQ     *OFF                                         Until eof
      * Branch Code
     C                   MOVE      A8BRCD        FBRCD
      *
      *  Write Branch Header Record
     C                   MOVE      '02'          RECC
     C                   MOVE      BRCHHD        DATA
     C                   WRITE     FECRLF
     C                   ADD       1             COUNT
      *
     C                   MOVE      A8CMCD        F1BKCD
     C                   MOVE      FBRCD         F1BRCD
     C                   MOVE      '05'          RECC
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FECRLF
     C                   ADD       1             COUNT
      *
      *
      *
      *  Read Next record
     C                   READ      SDBRCHL1                               20
      *
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S200  -  Generate Detail Records                            *
      *                                                               *
      *  Called By: #PROC                                             *
      *  Calls:     #S201 #S202 #S203 #S204                           *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all Guarantees for the branch
      *
     C     FBRCD         SETLL     FCLTYL9
     C     FBRCD         READE     FCLTYL9                                21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
     C     RECI          IFNE      'C'                                                     LUC109CC1
     C     NY_Amend      ANDEQ     'Y'                                                     LUC109CC1
     C     NY_Amend      ORNE      'Y'                                                     LUC109CC1
      *                                                                                    LUC109CC1
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        DATA
     C                   WRITE     FECRLF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S202
      *
      *  Write Detail Record 2
     C                   MOVE      DET002        DATA
     C                   WRITE     FECRLF
     C                   ADD       1             COUNT
      *
     C                   EXSR      #S203
      *
      *  Write Detail Record 3
     C                   MOVE      DET003        DATA
     C                   WRITE     FECRLF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S204
      *
      *  Write Detail Record 4
     C                   MOVE      DET004        DATA
     C                   WRITE     FECRLF
     C                   ADD       1             COUNT
      *                                                                   MUI010
      *                                                                   MUI010
     C                   MOVE      LLINK         F5LINK                                        MUI01
      *                                                                   MUI010
      *  Write Detail Record 5                                            MUI010
     C                   MOVE      DET005        DATA                                          MUI01
     C                   WRITE     FECRLF                                                      MUI01
     C                   ADD       1             COUNT                                         MUI01
      *
     C                   ENDIF                                                             LUC109CC1
      *
      *  Read Next record
     C     FBRCD         READE     FCLTYL9                                21
      *
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S201  -  Set up Detail records 1                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
     C     #S201         BEGSR
      *
      * Customer Number
     C                   Z-ADD     CNUM          F1CUST
      * Facility Type
     C                   Z-ADD     FACT          F1FACT
      * Facility Number
     C                   Z-ADD     FCNO          F1FACN
      * Facility Commitment Indicator
     C     FCTI          IFEQ      'C'
     C                   MOVE      '0'           F1FCCI
     C                   ELSE
     C                   MOVE      '1'           F1FCCI
     C                   ENDIF
      * Facility Currency
     C                   MOVE      FCCY          F1FCCY
      * Facility Amount
     C                   Z-ADD     FAMT          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F1FCCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F1FAMT
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     @@REPK        REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      FCCY          REPCCY
     C                   Z-ADD     FAMT          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F1FAMT
     C                   ENDIF
      * Overline
     C                   Z-ADD     OVPC          F1OVLN
      * Start Date
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C                   Z-ADD     DLFS          St_Date                                   LUC109CC1
     C                   ELSE                                                              LUC109CC1
     C                   Z-ADD     DTAP          St_Date                                   LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C**********         PARM                    DTAP                                      LUC109CC1
     C                   PARM                    St_Date           5 0                     LUC109CC1
     C*                    PARM           F1STDT
     C                   PARM      *ZERO         W1STDT            8 0
     C                   MOVE      W1STDT        F1STDT
      * Date Expires
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DTEX
     C*                    PARM           F1EXDT
     C                   PARM      *ZERO         W1EXDT            8 0
     C                   MOVE      W1EXDT        F1EXDT
      * Revolving Credit Indicator
     C                   MOVE      RVCR          F1RVCR
      * Multi-Currency Indicator
     C                   MOVE      MCCY          F1MTCY
      * Multi-Customer Indicator
     C                   MOVE      MCSI          F1MTCS
      * Country of Risk
     C                   MOVE      CRSK          F1CTRK
      * Security indicator
     C                   MOVE      SECI          F1STYI
      * Multi-branch Indicator
     C                   MOVE      MBFC          F1MTBR
      *                                                                   LUC010
      * Type of Facility and Maximum Tenor                                LUC010
     C     @@KEYA        CHAIN     FCLTYY0                            31                       LUC01
     C     *IN31         IFEQ      *OFF                                                        LUC01
     C                   MOVE      LFACT         C9805                                         LUC01
     C                   MOVE      LMAXT         C9806                                         LUC01
     C                   ELSE                                                                  LUC01
     C                   MOVE      *BLANKS       REPPRG                                        LUC01
     C                   MOVE      *BLANKS       REPMSG                                        LUC01
     C                   MOVE      *BLANKS       REPKEY                                        LUC01
     C                   MOVE      *BLANKS       REPDTA                                        LUC01
     C                   MOVE      *BLANKS       REPACN                                        LUC01
     C                   MOVEL     @@REPK        REPACN                                        LUC01
     C                   MOVEL     '#S201'       REPPRG                                        LUC01
     C                   MOVEL     @ERR(3)       REPMSG                                        LUC01
     C                   MOVEL     @@REPK        REPKEY                                        LUC01
     C                   EXSR      #ERR                                                        LUC01
     C                   MOVE      *BLANKS       C9805                                         LUC01
     C                   MOVE      *BLANKS       C9806                                         LUC01
     C                   ENDIF                                                                 LUC01
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S202  -  Set up Detail records 2                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S202         BEGSR
      *
      * Review Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    RVDT
     C*                    PARM           F2RVDT
     C                   PARM      *ZERO         W2RVDT            8 0
     C                   MOVE      W2RVDT        F2RVDT
      *
      * Account Officer
     C                   MOVE      ACOF          F2ACOF
      *
      * Profit Centre
     C                   MOVE      PRFC          F2PRCT
      *
      * Originating Branch
     C                   MOVE      ORBR          F2ORBR
      *
      * Narrative Line 1
     C                   MOVE      NAR1          F2NAR1
      *                                                                   LUC010
      * Proposal sent to Head Office and Maximum End Date of Risk         LUC010
     C     @@KEYA        CHAIN     FCLTYY0                            31                       LUC01
     C     *IN31         IFEQ      *OFF                                                        LUC01
     C                   MOVE      LPROP         C9809                                         LUC01
      *                                                                   LUC010
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    LMEDR                                         LUC01
     C                   PARM      *ZERO         WFNWKD            8 0                         LUC01
      *                                                                   LUC010
     C                   MOVE      WFNWKD        C9810                                         LUC01
      *                                                                   LUC010
     C                   ELSE                                                                  LUC01
     C                   MOVE      *BLANKS       REPPRG                                        LUC01
     C                   MOVE      *BLANKS       REPMSG                                        LUC01
     C                   MOVE      *BLANKS       REPKEY                                        LUC01
     C                   MOVE      *BLANKS       REPDTA                                        LUC01
     C                   MOVE      *BLANKS       REPACN                                        LUC01
     C                   MOVEL     @@REPK        REPACN                                        LUC01
     C                   MOVEL     '#S202'       REPPRG                                        LUC01
     C                   MOVEL     @ERR(3)       REPMSG                                        LUC01
     C                   MOVEL     @@REPK        REPKEY                                        LUC01
     C                   EXSR      #ERR                                                        LUC01
     C                   MOVE      *BLANKS       C9809                                         LUC01
     C                   MOVE      *BLANKS       C9810                                         LUC01
     C                   ENDIF                                                                 LUC01
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S203  -  Set up Detail records 3                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S203         BEGSR
      *
      * Narrative Line 2
     C                   MOVE      NAR2          F3NAR2
      *
      * Narrative Line 3
     C                   MOVE      NAR3          F3NAR3
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S204  -  Set up Detail records 4                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ACKEY                                            *
      *                                                               *
      *****************************************************************
      *
     C     #S204         BEGSR
      *
      * Narrative Line 4
     C                   MOVE      NAR4          F4NAR4
      *
      * Set up Standard part of account Key
     C                   MOVE      FACT          @ACFL1
     C                   MOVE      'A'           @ACFL2
     C                   MOVE      'F'           @ACFL4
      *
      * Account Type Code - Available Margin on credit lines
     C                   Z-ADD     *ZERO         F4CRAT
     C                   MOVE      '01'          @ACFL3
     C                   EXSR      #ACKEY
     C                   Z-ADD     @@ACC1        F4CRAT
      *
     C     F4CRAT        IFEQ      *ZERO
     C                   MOVE      '02'          @ACFL3
     C                   EXSR      #ACKEY
     C                   Z-ADD     @@ACC1        F4CRAT
     C                   ENDIF
      *
     C     F4CRAT        IFEQ      *ZERO
     C                   MOVE      '03'          @ACFL3
     C                   EXSR      #ACKEY
     C                   Z-ADD     @@ACC1        F4CRAT
     C                   ENDIF
      *
     C     F4CRAT        IFEQ      *ZERO
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     @@REPK        REPACN
     C                   MOVEL     '#204'        REPPRG
     C                   MOVEL     @ERR(4)       REPMSG
     C                   MOVEL     @@ACK         REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
      * Account Type Code - Available Margin on credit lines - contra
     C                   Z-ADD     *ZERO         F4CCAT
     C                   MOVE      '01'          @ACFL3
     C                   EXSR      #ACKEY
     C                   Z-ADD     @@ACC2        F4CCAT
      *
     C     F4CCAT        IFEQ      *ZERO
     C                   MOVE      '02'          @ACFL3
     C                   EXSR      #ACKEY
     C                   Z-ADD     @@ACC2        F4CCAT
     C                   ENDIF
      *
     C     F4CCAT        IFEQ      *ZERO
     C                   MOVE      '03'          @ACFL3
     C                   EXSR      #ACKEY
     C                   Z-ADD     @@ACC2        F4CCAT
     C                   ENDIF
      *
     C     F4CCAT        IFEQ      *ZERO
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     @@REPK        REPACN
     C                   MOVEL     '#204'        REPPRG
     C                   MOVEL     @ERR(4)       REPMSG
     C                   MOVEL     @@ACK         REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
      * Available Margin amount
     C*          FAMT      SUB  TOTD      @@AMT
     C     FAMT          SUB       OAM1          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F1FCCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F4AMAM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     @@REPK        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      FCCY          REPCCY
     C                   Z-ADD     @@AMT         REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4AMAM
     C                   ENDIF
      *
      * BSPL Code 1
     C                   Z-SUB     1             @@BAL            15 0
     C                   MOVE      F4CRAT        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP1
      *
      * BSPL Code 2
     C                   Z-ADD     1             @@BAL
     C                   MOVE      F4CCAT        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP2
      *
      * Risk or Italian Branch
     C     @@KEYA        CHAIN     FCLTYY0                            31
     C     *IN31         IFEQ      *OFF
     C                   MOVE      MRKBR         F4RKBR
      *                                                                   LUC010
      * Multiyear transaction and Blocked facility                        LUC010
     C                   MOVE      LMYTR         C9807                                         LUC01
     C                   MOVE      LBFAC         C9808                                         LUC01
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     @@REPK        REPACN
     C                   MOVEL     '#204'        REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     @@REPK        REPKEY
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F4RKBR
     C                   MOVE      *BLANKS       C9807                                         LUC01
     C                   MOVE      *BLANKS       C9808                                         LUC01
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #BSPL  -  Determine BSPL Details                             *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #BSPL         BEGSR
      *
      *
      * Balance < 0
      *
     C     @@BAL         IFLT      *ZERO
      *
     C                   MOVE      '0'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      ' '           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      * Account Reporting Details Not Found
     C     *IN22         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL             4 0
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Balance > 0
      *
     C     @@BAL         IFGT      *ZERO
      *
     C                   MOVE      '1'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      ' '           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      * Account Reporting Details Not Found
     C     *IN22         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Balance = 0
      *
     C     @@BAL         IFEQ      *ZERO
      *
     C                   MOVE      '0'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      '1'           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON                                          Not Found
      *
     C                   MOVE      ' '           XXDRCR
     C     @@KEY         CHAIN     SDACRCL9                           22        Account Reports
     C*
     C                   ENDIF
      * Account Reporting Details Not Found
     C     *IN22         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN22         IFEQ      *ON
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     @@REPK        REPACN
     C                   MOVEL     '#BSPL'       REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     XXRSNO        REPKEY
     C                   MOVE      XXACCD        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #ACKEY -  Determine Account Codes                            *
      *                                                               *
      *  Called By: #204                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #ACKEY        BEGSR
      *
     C                   Z-ADD     *ZERO         @@ACC1            4 0
     C                   Z-ADD     *ZERO         @@ACC2            4 0
      *
      * Access Account Key File
     C     @@ACK         CHAIN     ACKEY                              40
      *
     C     *IN40         IFEQ      *OFF
      *
     C     ACD3          IFNE      *ZERO
     C                   Z-ADD     ACD3          @@ACC1
     C                   ENDIF
      *
     C     ACD2          IFNE      *ZERO
     C                   Z-ADD     ACD2          @@ACC1
     C                   ENDIF
      *
     C     ACD1          IFNE      *ZERO
     C                   Z-ADD     ACD1          @@ACC1
     C                   ENDIF
      *
      *
     C     ACD6          IFNE      *ZERO
     C                   Z-ADD     ACD6          @@ACC2
     C                   ENDIF
      *
     C     ACD5          IFNE      *ZERO
     C                   Z-ADD     ACD5          @@ACC2
     C                   ENDIF
      *
     C     ACD4          IFNE      *ZERO
     C                   Z-ADD     ACD4          @@ACC2
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
      *
     C     *IN88         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
      *
     C                   WRITE     HEADAU                                       Report header
      *
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ELSE
      *
      *
      *  Write Trailer Record
     C                   ADD       1             COUNT
     C                   Z-ADD     COUNT         FCONT
     C                   MOVE      '99'          RECC
     C                   MOVE      TRAILR        DATA
     C                   WRITE     FECRLF
      *
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ELSE
     C                   WRITE     NODET
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL     'GLM038'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000038'    DBPGM                          Set program idLUC109
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN88                          Database error
     C                   MOVE      *ON           *INU7                                         15996
     C                   MOVE      *ON           *INU8                                         15996
     C                   DUMP                                                   Dump system var
      *
     C                   EXSR      #TERM                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *    #ERR      - Error Reporting                                *
      *                                                               *
      *    CALLED BY -                                                *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #ERR          BEGSR
      *
      *
      *
      ** Print audit report & stop run
      *
      *
     C     WWOFL1        SUB       WWPTL1        WWLINE            2 0
      *
     C     WWLINE        IFLT      5
     C                   WRITE     ERRHDR
     C                   ENDIF
      *
     C                   ADD       1             ERRCNT
     C                   WRITE     ERRDET                                       Report error
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      ***
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
**  @ERR
XX000041 UNABLE TO CONVERT AMOUNT
SDACRCL9 RECORD NOT FOUND
FCLTYY0 RECORD NOT FOUND
ACKEY RECORD NOT FOUND
