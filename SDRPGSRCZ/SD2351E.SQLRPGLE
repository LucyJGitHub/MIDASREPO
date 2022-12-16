     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058854
/*STD *  RPGSQLBND                                                    *                     MD058854
/*EXI *  TEXT('Midas Customer Group Enquiry')
/******: OVRDBF FILE(TABLE2) TOFILE(TABCGU) SHARE(*NO)                *                     MD058854
     F*****************************************************************
     F*                                                               *
     F*  Midas Standing Data Module
     F*                                                               *
     F*  SD2351E - CUSTOMER GROUP ENQUIRY                             *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058854           Date 21Oct21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAAA03             Date 15Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01Mar99               *
      *                                    Date                       *
     F*                 S01413 *CREATE     DATE 09FEB94               *
     F*                 xnnnnn             DATE nnxxxnn               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD058854 - Deliverable Data Split for TABLEV4                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAAA03 - Webfacing Changes (Recompile).                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
     F*  S01413 - Retail 3 Incorporation                              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     FSD2351E#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     FTABTBRE   IF   E             DISK    USROPN
     F*TABLE2**  IF   E           K DISK    COMMIT                                          MD058854
     F**********                           IGNORE(TABTB10F)                                 MD058854
     F**********  TABTE10F                          KIGNORE                          CGL029 MD058854
     F**********                           IGNORE(TABLETAF)                                 MD058854
     F**********                           IGNORE(TABLETXF)                                 MD055854
     F*SDARCGL1* IF   E           K DISK    USROPN                                          MD058854
     F**********                           INFSR(*PSSR)                                     MD058854
     F**********                           RENAME(TABLEV4F:SDARCGD0)                        MD058854
     F/EJECT
     F*****************************************************************
     F* ID F  C  H  L    FUNCTION OF INDICATORS                       *
     F*****************************************************************
     F*                                                               *
     F*      21          ERROR ON ACTION CODE (002)                   *
     F*      22          ERROR ON GROUP CODE (001)                    *
     F*                                                               *
     F*      23          ERROR ON MAX DEBIT BALANCE INDICATOR         *
     F*      24          ERROR ON MAX DEBIT BALANCE ACCT CODE         *
     F*      25          ERROR ON ACCOUNT INDICATOR                   *
     F*      26          ERROR ON ACCOUNT ACCT CODE                   *
     F*      27          ERROR ON DEBIT INTEREST INDICATOR            *
     F*      28          ERROR ON DEBIT INTEREST ACCT CODE            *
     F*      29          ERROR ON INACTIVE INDICATOR                  *
     F*      30          ERROR ON INACTIVE ACCT CODE                  *
     F*      31          ERROR ON MINIMUM BALANCE INDICATOR           *
     F*      32          ERROR ON MINIMUM BALANCE ACCT CODE           *
     F*      33          ERROR ON DAILY PAYMENTS INDICATOR            *
     F*      34          ERROR ON DAILY PAYMENTS ACCT CODE            *
     F*      35          ERROR ON FIXED INDICATOR                     *
     F*      36          ERROR ON FIXED ACCT CODE                     *
     F*                                                               *
     F*      40          SYSTEM SET-UP FLAG IS ON                     *
     F*      41          INVALID INITIAL SCREEN                       *
     F*      42          INVALID DETAIL SCREEN                        *
     F*      43          INVALID COMMISSION INDICATOR                 *
     F*      44          INVALID COMMISSION ACCOUNT                   *
     F*                                                               *
     F*      45          GRP CODE RECORD EXISTS                       *
     F*      46          UNSUCCESFUL UPDATE                           *
     F*                                                               *
     F*      51          ACTION CODE 'E'                              *
     F*                                                               *
     F*      53          GENERAL WORK INDICATOR                       *
     F*      54          GENERAL WORK INDICATOR                       *
     F*      59          GENERAL WORK INDICATOR                       *
     F*                                                               *
     F*                                                               *
     F*      80          PROTECT OUTPUT FIELDS - INITIAL SCREEN       *
     F*      81          NON-DISPLAY FIELDS - DETAIL SCREEN           *
     F*      82          PROTECT OUTPUT FIELDS - DETAIL SCREEN        *
     F*      83          NON-DISPLAY ERROR CODE LINE                  *
     F*      84          NON-DISPLAY ERROR MESSAGE LINE               *
     F*                                                               *
     F*      KC          F3, END OF PROGRAM REQUEST                   *
     F*      KL          F12, INITIAL SCREEN REQUEST                  *
     F*                                                               *
     F*      U7U8        DATABASE ERROR INDS.                         *
     F*                                                               *
     F*****************************************************************
     F/EJECT
     D ERMSG           S             47    DIM(8) CTDATA PERRCD(1)              ERROR MESSAGES
     D ERCD            S              4    DIM(21)                              ERROR CODE OUTPUT
     D COMI            S              1    DIM(7)                               COMM. INDICATORS
     D**********          COMA        7  4               COMM. ACCOUNTS                       CGL029
     D**********          COMP        7  4               COMM. ACCOUNTS                       CGL029
     D COMA            S             10    DIM(7)
     D COMP            S             10    DIM(7)
     D COMO            S              1    DIM(7)                               COMM. ACCOUNTS
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D*****************************************************************
     D/EJECT
     D*
     D*****************************************************************
     D*
     D**   DATA STRUCTURE FOR COMMMISION INDICATOR AND ACCOUNTS
     D*
     D                 DS
     D**MDBI****               1      1                                                     MD058854
     D**ACMI****               2      2                                                     MD058854
     D**DINI****               3      3                                                     MD058854
     D**INAI****               4      4                                                     MD058854
     D**MINI****               5      5                                                     MD058854
     D**DYSI****               6      6                                                     MD058854
     D**FIXI****               7      7                                                     MD058854
     D  MDBIX                  1      1                                                     MD058854
     D  ACMIX                  2      2                                                     MD058854
     D  DINIX                  3      3                                                     MD058854
     D  INAIX                  4      4                                                     MD058854
     D  MINIX                  5      5                                                     MD058854
     D  DYSIX                  6      6                                                     MD058854
     D  FIXIX                  7      7                                                     MD058854
     D  DSCOMI                 1      7
     D**********                              8  110MDBA                                      CGL029
     D**********                             12  150ACMA                                      CGL029
     D**********                             16  190DINA                                      CGL029
     D**********                             20  230INAA                                      CGL029
     D**********                             24  270MINA                                      CGL029
     D**********                             28  310DYSA                                      CGL029
     D**********                             32  350FIXA                                      CGL029
     D**********                              8  35 DSCOMA                                    CGL029
     D**MDBA****               8     17  0                                                  MD058854
     D**ACMA****              18     27  0                                                  MD058854
     D**DINA****              28     37  0                                                  MD058854
     D**INAA****              38     47  0                                                  MD058854
     D**MINA****              48     57  0                                                  MD058854
     D**DYSA****              58     67  0                                                  MD058854
     D**FIXA****              68     77  0                                                  MD058854
     D  MDBAX                  8     17  0                                                  MD058854
     D  ACMAX                 18     27  0                                                  MD058854
     D  DINAX                 28     37  0                                                  MD058854
     D  INAAX                 38     47  0                                                  MD058854
     D  MINAX                 48     57  0                                                  MD058854
     D  DYSAX                 58     67  0                                                  MD058854
     D  FIXAX                 68     77  0                                                  MD058854
     D  DSCOMA                 8     77
     D*
     D**   DATA STRUCTURE FOR COMMMISION INDICATOR AND ACCOUNTS
     D**        (DETAIL SCREEN FIELDS)
     D*
     D                 DS
     D  SMDBI                  1      1
     D  SACMI                  2      2
     D  SDINI                  3      3
     D  SINAI                  4      4
     D  SMINI                  5      5
     D  SDYSI                  6      6
     D  SFIXI                  7      7
     D  SSCOMI                 1      7
     D**********                              8  11 SMDBA                                     CGL029
     D**********                             12  15 SACMA                                     CGL029
     D**********                             16  19 SDINA                                     CGL029
     D**********                             20  23 SINAA                                     CGL029
     D**********                             24  27 SMINA                                     CGL029
     D**********                             28  31 SDYSA                                     CGL029
     D**********                             32  35 SFIXA                                     CGL029
     D**********                              8  35 SSCOMA                                    CGL029
     D  SMDBA                  8     17
     D  SACMA                 18     27
     D  SDINA                 28     37
     D  SINAA                 38     47
     D  SMINA                 48     57
     D  SDYSA                 58     67
     D  SFIXA                 68     77
     D  SSCOMA                 8     77
     D*
     D**   DATA STRUCTURE FOR LOTSCN ON COMMITMENT TEXT AREA
     D*
     D DSSCN         E DS                  EXTNAME(SD2351E#)
     D  DSSAC        E                     EXTFLD(ACTCD)
     D  DSSGC        E                     EXTFLD(SGRPC)
     D  DSSGN        E                     EXTFLD(SGRPN)
     D  DSSI1        E                     EXTFLD(SMDBI)
     D  DSSA1        E                     EXTFLD(SMDBA)
     D  DSSI2        E                     EXTFLD(SACMI)
     D  DSSA2        E                     EXTFLD(SACMA)
     D  DSSI3        E                     EXTFLD(SDINI)
     D  DSSA3        E                     EXTFLD(SDINA)
     D  DSSI4        E                     EXTFLD(SINAI)
     D  DSSA4        E                     EXTFLD(SINAA)
     D  DSSI5        E                     EXTFLD(SMINI)
     D  DSSA5        E                     EXTFLD(SMINA)
     D  DSSI6        E                     EXTFLD(SDYSI)
     D  DSSA6        E                     EXTFLD(SDYSA)
     D  DSSI7        E                     EXTFLD(SFIXI)
     D  DSSA7        E                     EXTFLD(SFIXA)
     D*
     D**   DATA STRUCTURE FOR LAST UPDATE DATA.
     D*
     D                 DS
     D**LCD*****               1      5  0                                                  MD058854
     D**CHTP****               6      6                                                     MD058854
     D**TNLU****               7     11  0                                                  MD058854
     D  LCDX                   1      5  0                                                  MD058854
     D  CHTPX                  6      6                                                     MD058854
     D  TNLUX                  7     11  0                                                  MD058854
     D  LSTC                   1     11
     D  LCDS                  12     16  0
     D  CHTPS                 17     17
     D  TNLUS                 18     22  0
     D  LSTCS                 12     22
     D*
     D**  DATA STRUCTURE TO RETRIEVE WSID
     D*
     D PSDS           SDS
     D  ##PGM                  1     10
     D  WSID                 244    253
     D  WSID2                245    249
     D  USRID                254    263
     D*
     D**  DATA STRUCTURE  TO UPDATE LAST TRANSACTION NUMBER DTAARA
     D*
     D DNATN           DS             5
     D  FNATN                  1      5  0
     D*
     D**  DATA STRUCTURE TO PROVIDE TEXT ON COMIT ENTRY IN JOURNAL
     D*
     D CMTTXT          DS           300
     D  NATN                   1      5  0
     D  MDID                   6      7
     D  PGMN                   8     15
     D  WSIDX                 16     18
     D  MTIME                 19     24  0
     D  ACTCD                 25     25
     D  USRIDX                26     35
     D  LOTSCN                51    300
     D*
     D** DATA STRUCTURE USED IN THE EVENT OF DATABASE ERRORS
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D** DATA STRUCTURE FOR DATABASE ERROR FIELDS
     D*
     D                 DS
     D  KEY14                  1     14
     D  KEY08                  1      8
     D  KEY06                  9     14
     D*
     D** DATA STRUCTURE FOR MANIPULATING KEY PRIOR TO CHAIN FUNCTION
     D*
     D                 DS
     D  ZKEY05                 1      5
     D  ZKEY04                 1      4
     D  ZKEY01                 5      5
     D*
     D** DATA AREA RUNDAT
     D*
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  AGMBIN                13     13
     D*
     D ZMUSER          DS            17
     D** DATA AREA OF MENU USER
     D  DFBM                  11     13
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D*
     D** Bank Details
     D  SFLG         E                     EXTFLD(BJSUC)
     D*
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D*
     D** Account Code
     D  ATYP         E                     EXTFLD(A5ACTY)
     D  TOIN         E                     EXTFLD(A5TOIN)
     D  ACSC         E                     EXTFLD(A5ACSC)
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
     D DSSARD        E DS                  EXTNAME(SCSARDPD)
      * Definition: Switchable Features Accessed Via Access Program.                          CSD031
      *                                                                                       CSD031
     D  LCDR         E                     EXTFLD(LCD)
     D TABV4         E DS                  EXTNAME(TABV4JW0)                                MD058854
     D ZONEX         E                     EXTFLD(ZONE)                                     MD058854
     D JBDTTM          DS
      * Job date/time                                                                         CSD031
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
     I********************************************************************
     I/EJECT
     C********************************************************************
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** DEFINE LDA
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *LIKE         DEFINE    DBFILE        WBFILE
     C     *LIKE         DEFINE    DBKEY         WBKEY
     C     *LIKE         DEFINE    DBASE         WBASE
     C     *LIKE         DEFINE    RUND          WRUND
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
     C*
     C*-------------------------------------------------------------------
     C*
     C**  CONTROL PROCESS
     C*   ~~~~~~~~~~~~~~~
     C*
     C                   EXSR      START
     C*
     C     *INKC         DOUEQ     '1'
     C                   EXSR      INITSC
     C  NKC              EXSR      DETLSC
     C                   END
     C*
     C                   SETON                                        LR
     C*
     C*-------------------------------------------------------------------
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C**  START PROCESS
     C*   ~~~~~~~~~~~~~
     C*
     C     START         BEGSR
     C*
     C**  ACCESS
     C*
     C                   OPEN      TABTBRE
     C     1             CHAIN     TABTBRE                            99
     C                   CLOSE     TABTBRE
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        WBKEY                          ***************
     C                   Z-ADD     91            WBASE                          * DB ERROR 91 *
     C                   MOVE      'TABTBRE'     WBFILE                         ***************
     C                   EXSR      *PSSR
     C                   END
     C* H/O NOT INSTAL
     C     CHOV          COMP      'Y'                                717178
     C   71              MOVE      'N'           COMO(1)
     C   71              MOVE      *BLANK        COMP(1)
     C   78              SETON                                        79
     C* TURNOVER NOT INSTAL
     C     CDTO          COMP      'Y'                                727278
     C   72              MOVE      'N'           COMO(2)
     C   72              MOVE      *BLANK        COMP(2)
     C   78              SETON                                        79
     C* FIXED NOT INSTAL
     C     FXAC          COMP      'Y'                                737378
     C   73              MOVE      'N'           COMO(7)
     C   73              MOVE      *BLANK        COMP(7)
     C   78              SETON                                        79
     C* DAILY STATEMENT NOT INSTAL
     C     CNDS          COMP      'Y'                                747478
     C   74              MOVE      'N'           COMO(6)
     C   74              MOVE      *BLANK        COMP(6)
     C   78              SETON                                        79
     C* DEBIT INTEREST  NOT INSTAL
     C     CDRI          COMP      'Y'                                757578
     C   75              MOVE      'N'           COMO(3)
     C   75              MOVE      *BLANK        COMP(3)
     C   78              SETON                                        79
     C* MINIMUM BALANCE NOT INSTAL
     C     CMBL          COMP      'Y'                                767678
     C   76              MOVE      'N'           COMO(5)
     C   76              MOVE      *BLANK        COMP(5)
     C   78              SETON                                        79
     C* INACTIVE        NOT INSTAL
     C     CINA          COMP      'Y'                                777778
     C   77              MOVE      'N'           COMO(4)
     C   77              MOVE      *BLANK        COMP(4)
     C* AT LEAST ONE COMMISSION INSTALED 79 ON
     C   78              SETON                                        79
     C                   SETOFF                                       78
     C*
     C**  CHAIN TO ICDR 1 FOR RUNDATE AND SYSTEM SET-UP FLAG
     C*
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    WBFILE                         ***************
     C                   MOVEL     @OPTN         WBKEY                          * DB ERROR 01 *
     C                   Z-ADD     1             WBASE                          ***************
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   MOVE      RUNA          SRUNA
     C                   MOVE      RUND          WRUND
      *                                                                                       CSD031
     C                   MOVE      'N'           CSD050            1
      *                                                                                       CSD031
      ** Access SAR details to see if CSD050 is switched on                                   CSD031
      *                                                                                       CSD031
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD050'      PSARD             6
     C     DSSARD        PARM      *BLANKS       DSFDY
      *                                                                                       CSD031
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSD050
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
     C                   MOVE      'N'           WF11
     C**********         OPEN      SDARCGL1                                                 MD055854
     C                   EXSR      MEIZ#2
     C                   ENDIF
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD031
     C*
     C**  CHECK WHETHER SYSTEM SET-UP FLAG IS ON
     C     SFLG          COMP      'Y'                                    40
     C*
     C**  SET INDICATORS PRIOR TO DISPLAY OF INITIAL SCREEN
     C                   EXSR      SETINI
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C**  INITIAL SCREEN PROCESS
     C*   ~~~~~~~~~~~~~~~~~~~~~~
     C*
     C     INITSC        BEGSR
     C*
     C**  RESET LAST UPDATE DATA FIELDS FOR NEW TRANSACTION.
     C*
     C                   Z-ADD     0             LCDS
     C                   MOVE      ' '           CHTPS
     C                   Z-ADD     0             TNLUS
     C*
     C**  DISPLAY INITIAL SREEN
     C*
     C                   EXSR      SCREEN
     C     CSD050        IFEQ      'Y'
      *                                                                                       CSD031
      ** Check if F11 was pressed                                                             CSD031
      *                                                                                       CSD031
     C     *INKK         IFEQ      *ON
     C                   EXSR      SRACCP
     C                   ENDIF
     C                   ENDIF
     C*
     C**  CHECK FOR CMD/3
     C   KC              GOTO      ENDINI                                       ** GO ENDINI **
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
      *                                                                                       CSD031
      ** Check if F12 was press in SRACCP routine                                             CSD031
      *                                                                                       CSD031
     C     *INKL         IFEQ      '1'
     C     WF11          ANDEQ     'N'
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
      *                                                                                       CSD031
      ** Blank out the screen fields and reset indicators                                     CSD031
      ** prior to display of initial screen                                                   CSD031
      *                                                                                       CSD031
     C                   EXSR      SETINI
     C                   GOTO      ENDINI
     C                   ENDIF
     C                   ENDIF
     C*
     C**  AT THIS STAGE ASSUME THE INITIAL SCREEN IS INVALID
     C                   SETON                                        41
     C*
     C**  DO THE FOLLOWING UNTIL A SCREEN IS VALID OR CMD/3 PRESSED
     C*
     C     *IN41         DOUEQ     '0'                                          ** BEGIN DO1**
     C     *INKC         OREQ      '1'
     C*
     C                   SETOFF                                       2122
     C*
     C**  VALIDATE GRP CODE (NUMERIC)
     C                   MOVEL     SGRPC         XGRPC             2 0
     C                   MOVEL     XGRPC         XGRPCA            1
     C     XGRPCA        COMP      SGRPC                              2222
     C*
     C**  CHECK NUMERIC RANGE OF GROUP CODE - (MUST BE 1-8)
     C  N22SGRPC         COMP      '1'                                  22
     C  N22SGRPC         COMP      '8'                                22
     C*
     C**  VALIDATE ACTION CODE (E)
     C*
     C                   MOVE      '0'           *IN(51)
     C     ACTCD         COMP      'E'                                212151
     C*
     C**    IGNORE THE FOLLOWING IF THE GROUP OR ACTION CODE IS INVALID
     C*
     C   21
     COR 22              GOTO      SKIP1                                        ** GO SKIP1 **
     C*
     C**  IF ACTION CODE IS VALID, CHECK IF USER IS AUTHORISED
     C**  IF SINGLE BRANCH SYSTEM, CHECK USER IS AUTHORISED TO ACTION CODE
     C                   SETOFF                                       10
     C     AGMBIN        IFEQ      'N'
     C                   CALL      'ZVACTU'
     C                   PARM      ACTCD         @ZACTN            1
     C                   PARM                    @ERR              1 0
     C*
     C     @ERR          IFNE      0
     C                   SETON                                        1021
     C                   GOTO      SKIP1
     C                   END
     C*
     C                   END
     C*
     C**  IF MULTIPLE BRANCH SYSTEM, USER MUST BE AUTHORISED TO ACTION
     C**  ON BRANCH
     C*
     C     AGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM      ACTCD         @ZACTN
     C                   PARM      DFBM          @ZBR              3
     C                   PARM                    @ERR
     C*
     C     @ERR          IFNE      0
     C                   SETON                                        1021
     C                   GOTO      SKIP1
     C                   END
     C*
     C                   END
     C*
     C**  CHAIN TO GROUP CODE TABLE
     C                   EXSR      CHNGCT
     C*
     C**  GROUP CODE RECORD EXISTS
     C     *IN59         COMP      '0'                                    45
     C*
     C**  SAVE LAST UPDATE DATA USING DATA STRUCTURE
     C   45              MOVE      LSTC          LSTCS
     C*
     C**  FOR ACTION 'E' LIVE REC MUST EXIST
     C*
     C     *IN51         IFEQ      '1'
     C  N45              SETON                                        22
     C   45RECI          IFNE      'D'
     C                   SETON                                        21
     C                   END
     C                   END
     C*
     C     SKIP1         TAG                                                    ** SKIP1 TAG **
     C*
     C**  REDISPLAY INITIAL SCREEN IF EITHER CODE IS INVALID
     C*
     C     *IN21         IFEQ      '1'                                          B002
     C     *IN22         OREQ      '1'
     C*
     C**    SET UP ERROR CODES, ERROR MESSAGES AND INDICATORS
     C*
     C                   MOVEA     *BLANKS       ERCD
     C                   Z-ADD     0             S                 3 0
     C   22              ADD       1             S
     C   22              MOVE      '001'         ERCD(S)
     C   21              ADD       1             S
     C   21              MOVE      '002'         ERCD(S)
     C*
     C     *IN10         IFEQ      '1'
     C     *IN21         ANDEQ     '1'
     C                   MOVE      '021'         ERCD(S)
     C                   END
     C*
     C                   MOVE      *BLANKS       SERCD
     C                   MOVEA     ERCD          SERCD
     C*
     C   21              MOVEL     ERMSG(1)      SERMSG
     C   22
     CANN21              MOVEL     ERMSG(2)      SERMSG
     C*
     C     *IN59         IFEQ      '1'
     C     SGRPC         ANDLE     '8'
     C     SGRPC         ANDGE     '1'
     C     *IN21         ANDEQ     '0'
     C                   MOVEL     ERMSG(8)      SERMSG
     C                   END
     C*
     C     *IN10         IFEQ      '1'
     C     *IN21         ANDEQ     '1'
     C                   MOVEL     ERMSG(5)      SERMSG
     C                   END
     C*
     C**      RESET INDICATORS PRIOR TO REDISPLAY OF INITIAL SCREEN
     C                   SETOFF                                       808384
     C                   SETON                                        8182
     C*
     C                   EXSR      SCREEN
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'N'           WF11
     C                   ENDIF
     C*
     C                   ELSE                                                   *002
     C*
     C**  CHECK FOR ERROR IN USER AUTHORISATION
     C     *IN10         IFEQ      '1'
     C                   SETON                                        41
     C                   EXSR      SCREEN
     C                   ELSE
     C*
     C**      INITIAL SCREEN IS VALID
     C                   SETOFF                                       41
     C                   END
     C                   END                                                    E002
     C*
     C                   END                                                    ** END DO1**
     C*
     C     ENDINI        ENDSR                                                  ** ENDINI **
     C*
     C*
     C*-------------------------------------------------------------------
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C**  DETAIL SCREEN PROCESS
     C*   ~~~~~~~~~~~~~~~~~~~~~
     C*
     C     DETLSC        BEGSR
     C*
     C**  SET UP DETAIL SCREEN INFO PRIOR TO DISPLAY
     C*
     C**  USE THE CURRENT GROUP CODE RECORD FIELDS
     C*
     C     *IN51         IFEQ      '1'                                          B001
     C*
     C     CSD050        IFEQ      'Y'
     C     WF11          ANDEQ     'Y'
     C                   MOVE      #1SEL         ACTCD
     C                   MOVE      GRPN          SGRPN
     C                   MOVE      ZZ010         SGRPC
     C                   MOVE      MDBI          SMDBI
     C                   MOVE      MDBA          SMDBA
     C                   MOVE      ACMI          SACMI
     C                   MOVE      ACMA          SACMA
     C                   MOVE      DINI          SDINI
     C                   MOVE      DINA          SDINA
     C                   MOVE      INAI          SINAI
     C                   MOVE      INAA          SINAA
     C                   MOVE      MINI          SMINI
     C                   MOVE      MINA          SMINA
     C                   MOVE      DYSI          SDYSI
     C                   MOVE      DYSA          SDYSA
     C                   MOVE      FIXI          SFIXI
     C                   MOVE      FIXA          SFIXA
     C                   MOVE      EACC          #2EACC
     C                   ELSE
      *
     C                   MOVE      GRPN          SGRPN
     C                   MOVEA     DSCOMI        COMI
     C                   MOVEA     DSCOMA        COMA
     C                   DO        7             X                 2 0          B002
     C     COMA(X)       COMP      *ALL'0'                                59
     C***59*****           MOVEA'    '    COMA,X                                              CGL029
     C   59              MOVEL     *BLANKS       COMA(X)
     C     COMO(X)       IFEQ      'N'
     C                   MOVE      COMO(X)       COMI(X)
     C                   MOVE      COMP(X)       COMA(X)
     C                   END                                                    E002
     C                   END                                                    E002
     C                   MOVEA     COMA          SSCOMA
     C                   MOVEA     COMI          SSCOMI
     C*
     C                   ENDIF
     C                   END                                                    E001
     C*
     C**    SET INDICATORS PRIOR TO DISPLAY OF DETAIL SCREEN
     C*
     C                   SETOFF                                       4344
     C                   SETOFF                                       2122
     C                   MOVEA     '0000000'     *IN(23)
     C                   MOVEA     '0000000'     *IN(30)
     C                   SETOFF                                       8182
     C                   SETON                                        808384
     C   51              SETON                                        82
     C*
     C                   EXSR      SCREEN
     C     CSD050        IFEQ      'Y'
     C     WF11          ANDEQ     'N'
     C                   MOVE      *ON           *IN52
     C                   ENDIF
     C*
     C**  CHECK FOR CMD/3
     C   KC              GOTO      ENDDTL                                       ** GO ENDDTL **
     C*
     C**  CHECK FOR CMD/12
     C     *INKL         IFEQ      '1'                                          B001
     C**       BLANK OUT THE SCREEN FIELDS AND
     C**       RESET INDICATORS PRIOR TO DISPLAY OF INITIAL SCREEN
     C**       FOR NEXT TRANSACTION
     C                   EXSR      SETINI
     C                   GOTO      ENDDTL                                       ** GO ENDDTL **
     C                   END                                                    E001
     C     SKIP          TAG
     C*
     C**  DO WHATEVER PROCESSING IS REQUIRED BY THE ACTION CODE
     C*
     C**    ENQUIRY
     C     *IN51         IFEQ      '1'                                          B001
     C*
     C**       BLANK OUT THE SCREEN FIELDS AND
     C**       RESET INDICATORS PRIOR TO DISPLAY OF INITIAL SCREEN
     C**       FOR NEXT TRANSACTION
     C                   EXSR      SETINI
     C                   GOTO      ENDDTL                                       ** GO ENDDTL **
     C                   END                                                    E001
     C*
     C*
     C     ENDDTL        ENDSR                                                  **  ENDDTL **
     C*
     C*
     C*-------------------------------------------------------------------
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C**  DATABASE ERROR PROCESS
     C*   ~~~~~~~~~~~~~~~~~~~~~~
     C*
     C*
     C     *PSSR         BEGSR
     C*
     C     *LOCK         IN        LDA
     C                   MOVEL     WBFILE        DBFILE
     C                   MOVEL     WBKEY         DBKEY
     C                   MOVEL     'SD2351E'     DBPGM
     C                   MOVE      WBASE         DBASE
     C                   OUT       LDA
     C                   DUMP
     C                   ROLBK
     C                   SETON                                        U7U8LR
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C*
     C**  SET INITIAL SCREEN INDICATORS
     C*   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C**  TO BLANK OUT THE APPROPRIATE FIELDS AND
     C**  RESET THE RELEVANT INDICATORS PRIOR TO DISPLAYING
     C**  THE INITIAL SCREEN, READY FOR THE NEXT TRANSACTION.
     C*
     C     SETINI        BEGSR
     C*
     C                   MOVE      *BLANKS       ACTCD
     C                   MOVE      *BLANKS       SGRPC
     C                   SETOFF                                       80
     C                   SETON                                        8182
     C                   SETON                                        8384
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C*
     C**  SCREEN READ/DISPLAY PROCESS / WITH HELP FACILITY
     C*   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C     SCREEN        BEGSR
     C*
     C                   EXFMT     SD2350F1
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C*
     C**  CHAIN TO GROUP CODE TABLE
     C*   ~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C     CHNGCT        BEGSR
     C*
     C                   MOVEL     '81      '    KEY
     C                   MOVE      '    '        KEY
     C**********         MOVE      SGRPC         KEY                                        MD058854
     C                   MOVE      SGRPC         KEY              12                        MD058854
     C*
     C*****KEY*          CHAIN     TABLE2                             59                    MD058854
     C/EXEC SQL                                                                             MD058854
     C+ select * into TABV4 from TABV4JW0                                                   MD058854
     C+ where ZZ010 = :SGRPC                                                                MD058854
     C/END-EXEC                                                                             MD058854
     C                   setoff                                       59                    MD058854
     C                   if        SQLCODE <> 0                                             MD058854
     C                   seton                                        59                    MD058854
     C                   endif                                                              MD058854
     C                   eval      MDBIX = MDBI                                             MD058854
     C                   eval      ACMIX = ACMI                                             MD058854
     C                   eval      DINIX = DINI                                             MD058854
     C                   eval      INAIX = INAI                                             MD058854
     C                   eval      MINIX = MINI                                             MD058854
     C                   eval      DYSIX = DYSI                                             MD058854
     C                   eval      FIXIX = FIXI                                             MD058854
     C                   eval      MDBAX = MDBA                                             MD058854
     C                   eval      ACMAX = ACMA                                             MD058854
     C                   eval      DINAX = DINA                                             MD058854
     C                   eval      INAAX = INAA                                             MD058854
     C                   eval      MINAX = MINA                                             MD058854
     C                   eval      DYSAX = DYSA                                             MD058854
     C                   eval      FIXAX = FIXA                                             MD058854
     C                   eval      LCDX  = LCD                                              MD058854
     C                   eval      CHTPX = CHTP                                             MD058854
     C                   eval      TNLUX = TNLU                                             MD058854
                                                                                            MD058854
     C*
     C                   ENDSR
      *****************************************************************                       CSD031
      * SRACCP - Acceptance List screen                                                       CSD031
      *****************************************************************                       CSD031
     C     SRACCP        BEGSR
     C                   MOVEL     'ACC'         WMODE             3
     C                   MOVE      'Y'           WF11              1
     C                   MOVE      *ON           *IN50
     C                   MOVE      *ON           *IN52
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
      *                                                                                       CSD031
      ** Maximum record number                                                                CSD031
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         ##RRMX
      *                                                                                       CSD031
      ** Scan limit                                                                           CSD031
      *                                                                                       CSD031
     C                   Z-ADD     500           W0SLM             5 0
      *                                                                                       CSD031
      ** Subfile pages                                                                        CSD031
      *                                                                                       CSD031
     C                   Z-ADD     1             W0SPG             3 0
      *                                                                                       CSD031
      ** Processed Subfile record                                                             CSD031
      *                                                                                       CSD031
     C                   Z-ADD     0             W0RR0             4 0
     C                   MOVEL     *BLANK        W0GRP             1
     C                   DO        *HIVAL
      *                                                                                       CSD031
      ** Initialise & load subfile page                                                       CSD031
      *                                                                                       CSD031
     C                   EXSR      BAIZSF
     C                   MOVEL     'N'           W0RSF             1
      *                                                                                       CSD031
      ** Display screen until reload requested                                                CSD031
      *                                                                                       CSD031
     C     W0RSF         DOWEQ     'N'
      *                                                                                       CSD031
      ** Display screen                                                                       CSD031
      *                                                                                       CSD031
     C                   EXSR      CAEXFM
      *                                                                                       CSD031
      ** Process response                                                                     CSD031
      ** Cancel & exit program                                                                CSD031
      *                                                                                       CSD031
     C   03              CAS                     ZXEXPG
     C                   ENDCS
     C     *INKL         IFEQ      *ON
     C                   MOVE      'N'           WF11
     C                   GOTO      SREXIT
     C                   ENDIF
      *                                                                                       CSD031
     C   27              CAS                     BBLDSF
      *                                                                                       CSD031
      ** Process screen input                                                                 CSD031
      *                                                                                       CSD031
     C                   CAS                     DBPRSF
     C                   ENDCS
      *                                                                                       CSD031
     C                   ENDDO
     C                   ENDDO
     C                   MOVEL     *BLANKS       WMODE
     C     SREXIT        ENDSR
      *****************************************************************                       CSD031
      * MEIZ#2 - Initialize subfile control                                                   CSD031
      *****************************************************************                       CSD031
     CSR   MEIZ#2        BEGSR
     C                   MOVE      *BLANK        #1GRPC
     C                   MOVE      *BLANKS       #1GRPN
     C                   MOVE      *BLANKS       #1EACC
     C                   MOVE      *BLANKS       #1CHTP
     CSR                 ENDSR
      *****************************************************************                       CSD031
      * CAEXFM - Display screen                                                               CSD031
      *****************************************************************                       CSD031
     CSR   CAEXFM        BEGSR
     C     W0HLP         DOUEQ     'N'
     C                   MOVEL     'N'           W0HLP             1
     C                   MOVE      *IN25         HELP25            1
     C                   MOVE      *ALL'0'       ##OFF            30
     C                   MOVEA     ##OFF         *IN(1)
     C                   MOVE      HELP25        *IN25
      *                                                                                       CSD031
      ** PUTOVR unless conditioned fields change                                              CSD031
      *                                                                                       CSD031
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   ENDIF
     C                   MOVE      *IN81         CAIN81            1
     C****                 MOVE *OFF      *IN86                                               CSD031
     C                   WRITE     #MSGTXT
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C     *INKL         IFEQ      *ON
     C                   MOVE      *ON           *IN52
     C                   MOVE      *OFF          *IN21
     C                   MOVE      *OFF          *IN22
     C                   MOVE      *OFF          *IN55
     C                   MOVE      'Y'           WACCP             1
     C                   GOTO      CAEXIT
     C                   ENDIF
     C                   MOVE      'N'           WACCP
     C                   ENDDO
      *                                                                                       CSD031
      ** Update job time                                                                      CSD031
      *                                                                                       CSD031
     C                   TIME                    ##JTM
      *                                                                                       CSD031
      ** Clear messages from program message queue                                            CSD031
      *                                                                                       CSD031
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
      *                                                                                       CSD031
      ** Reset first message only flag                                                        CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y'           ZAFSMS            1      99
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN92
     CSR   CAEXIT        ENDSR
      *****************************************************************                       CSD031
      * ZXEXPG - Cancel and exit program                                                      CSD031
      *****************************************************************                       CSD031
     CSR   ZXEXPG        BEGSR
     C                   SETON                                        LR
     C                   RETURN
     CSR   ZXEXIT        ENDSR
      *****************************************************************                       CSD031
      * BBLDSF - Load subfile page                                                            CSD031
      *****************************************************************                       CSD031
     CSR   BBLDSF        BEGSR
     C   27              DO
     C**N82*****         READP     SDARCGD0                               90                MD058854
     C**N82*****         READ      SDARCGD0                               90                MD058854
     C                   SETOFF                                           90                MD058854
     C                   ENDDO
      *                                                                                       CSD031
      ** Setof record error indicators                                                        CSD031
      *                                                                                       CSD031
     C                   MOVEL     *ALL'0'       WKIND0            1
     C                   MOVEA     WKIND0        *IN(33)
      *                                                                                       CSD031
      ** Start at previous highest record in SFL                                              CSD031
      *                                                                                       CSD031
     C                   Z-ADD     ##RRMX        ##RR              5 0
      *                                                                                       CSD031
      ** Reset count of DBF records read                                                      CSD031
      *                                                                                       CSD031
     C                   Z-ADD     0             ##RRRD            5 0
      *                                                                                       CSD031
      ** Set required pages based on *Set Cursor or *Subfile Pages                            CSD031
      *                                                                                       CSD031
     C     W0RR0         IFGT      0
     C     W0RR0         DIV       ##SFPG        ##SPG             3 0
     C                   MVR                     ##SLIN            3 0
     C     ##SLIN        IFGT      0
     C                   ADD       1             ##SPG
     C                   ENDIF
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   ENDIF
      *                                                                                       CSD031
      ** Compute lines required based on pages                                                CSD031
      *                                                                                       CSD031
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   ENDIF
      *                                                                                       CSD031
      ** Load next SFL page until SFL page full, or                                           CSD031
      ** Scan limit reached                                                                   CSD031
      *                                                                                       CSD031
     C     *IN82         DOWEQ     '0'                                          DO
     C     ##RROK        ANDLT     ##SFLN
     C     ##RRRD        ANDLT     W0SLM
      *                                                                                       CSD031
      ** Load SFL fields                                                                      CSD031
      *                                                                                       CSD031
     C                   EXSR      MBFL#1
      *                                                                                       CSD031
      ** Output to subfile                                                                    CSD031
      *                                                                                       CSD031
     C                   ADD       1             ##RR
     C                   ADD       1             ##RROK               81
      *                                                                                       CSD031
      ** If SFLRCD invalid, note that errors present                                          CSD031
      *                                                                                       CSD031
     C   98
     CANN99              SETON                                        99
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      *                                                                                       CSD031
      ** Increment scan check count                                                           CSD031
      *                                                                                       CSD031
     C                   ADD       1             ##RRRD
     C**********         READ      SDARCGD0                               82                MD058854
     C                   ENDDO
      *                                                                                       CSD031
     C     BB900         TAG
      *                                                                                       CSD031
      ** If no DBF records found, display error message                                       CSD031
      *                                                                                       CSD031
     C     ##RR          IFEQ      *ZERO
     C     *IN82         ANDEQ     '1'
      *                                                                                       CSD031
      ** Send message '*No data to display'                                                   CSD031
      *                                                                                       CSD031
     C                   MOVEL     'Y2U0008'     ZAMSID
     C                   MOVEL     'Y2USRMSG'    ZAMSGF
     C                   EXSR      ZASNMS
     C                   ENDIF
      *                                                                                       CSD031
      ** Save highest SFL record load can continue at end point                               CSD031
      *                                                                                       CSD031
     C     ##RR          IFGT      ##RRMX
      *                                                                                       CSD031
      ** Calculate top line                                                                   CSD031
      *                                                                                       CSD031
     C     ##RROK        DIV       ##SFPG        ##SPG
     C                   MVR                     ##SLIN
     C     ##SLIN        IFGT      0
     C     ##RR          SUB       ##SLIN        ##SFRC
     C                   ELSE
     C     ##RR          SUB       ##SFPG        ##SFRC
     C                   ENDIF
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   ENDIF
     C                   Z-ADD     0             ##RROK
      *================================================================                       CSD031
     CSR   BBEXIT        ENDSR
      *****************************************************************                       CSD031
      * MBFL#1 - Move fields to subfile                                                       CSD031
      *****************************************************************                       CSD031
     CSR   MBFL#1        BEGSR
     C                   MOVE      *BLANK        #1SEL
     C                   MOVE      *BLANKS       #1CHTP
     C                   MOVE      ZZ010         #1GRPC
     C                   MOVEL     GRPN          #1GRPN
     C                   SELECT
     C     CHTP          WHENEQ    'I'
     C                   MOVEL     'INSERT'      #1CHTP
     C     CHTP          WHENEQ    'A'
     C                   MOVEL     'AMEND '      #1CHTP
     C     CHTP          WHENEQ    'D'
     C                   MOVEL     'DELETE'      #1CHTP
     C                   ENDSL
      *                                                                                       CSD031
      *** Convert Effective Date to screen format                                             CSD031
      *                                                                                       CSD031
     C                   CALL      'ZDATE2'
     C                   PARM                    EACC
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
     C                   MOVEL     DATEB         #1EACC
     C                   MOVE      ZDATE         #2EACC
     CSR                 ENDSR
      *****************************************************************                       CSD031
      * DAPR## - Process screen input                                                         CSD031
      *****************************************************************                       CSD031
     CSR   DAPR##        BEGSR
      *                                                                                       CSD031
      ** Confirm/update is not deferred                                                       CSD031
      *                                                                                       CSD031
     C                   MOVEL     'N'           W0DCF             1
      *                                                                                       CSD031
      ** Reload subfile requested                                                             CSD031
      *                                                                                       CSD031
     C     W0RSF         CABEQ     'Y'           DAEXIT
      *                                                                                       CSD031
      ** If error, quit processing                                                            CSD031
      *                                                                                       CSD031
     C     *IN99         CABEQ     '1'           DAEXIT
      *                                                                                       CSD031
      ** Defer confirm/update requested                                                       CSD031
      *                                                                                       CSD031
     C     W0DCF         CABEQ     'Y'           DAEXIT
     CSR   DAEXIT        ENDSR
      *****************************************************************                       CSD031
      * BAIZSF - Initialise and load subfile page                                             CSD031
      *****************************************************************                       CSD031
     CSR   BAIZSF        BEGSR
      *                                                                                       CSD031
      ** Clear subfile                                                                        CSD031
      *                                                                                       CSD031
     C                   MOVE      *ON           *IN80
     C                   WRITE     #SFLCTL
     C                   MOVE      *OFF          *IN80
      *                                                                                       CSD031
      ** Reset no of records in subfile                                                       CSD031
      *                                                                                       CSD031
     C                   Z-ADD     *ZERO         ##RRMX            5 081
     C******LOVAL        SETLL     SDARCGD0                                                 MD058854
     C**********         READ      SDARCGD0                             8782    *82=EOF     MD058854
      *                                                                                       CSD031
      ** Load subfile page                                                                    CSD031
      *                                                                                       CSD031
     C                   Z-ADD     0             ##RROK            5 0
     C                   EXSR      BBLDSF
     CSR   BAEXIT        ENDSR
      *****************************************************************                       CSD031
      * ZASNMS - Send message to program message queue                                        CSD031
      *****************************************************************                       CSD031
     CSR   ZASNMS        BEGSR
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   ENDIF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *                                                                                       CSD031
      ** Clear all fields for default mechanism next time                                     CSD031
      *                                                                                       CSD031
     C                   MOVEL     *BLANK        ZAPGMQ
     C                   MOVEL     *BLANK        ZAPGRL
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAMSGF
     C                   MOVEL     *BLANK        ZAMSDA
     C                   MOVEL     *BLANK        ZAMSTP
     CSR   ZAEXIT        ENDSR
      *****************************************************************                       CSD031
      * DBPRSF - Process modified subfile record                                              CSD031
      *****************************************************************                       CSD031
     CSR   DBPRSF        BEGSR
     C                   READC     #SFLRCD                                60
     C     *IN60         DOWEQ     '0'
     C                   MOVE      *OFF          *IN52
      *                                                                                       CSD031
     C     #1SEL         IFNE      ' '
     C     #1SEL         ANDNE     'E'
     C                   MOVE      *ON           *IN55
     C                   MOVEL     ERMSG(1)      SERMSG
     C                   SETON                                        9984
     C                   UPDATE    #SFLRCD
     C                   GOTO      END1
     C                   ENDIF
     C     #1SEL         IFEQ      'E'
     C                   MOVE      *ON           *IN51
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *BLANKS       SERMSG
      *                                                                                       CSD031
     C                   MOVE      #1GRPC        WKEY             10
     C*****WKEY*         CHAIN     SDARCGD0                           90                    MD058854
     C     *IN90         IFEQ      *OFF
     C                   MOVE      *ON           *IN53
     C                   EXSR      DETLSC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      *OFF          *IN53
     C                   MOVE      *BLANK        #1SEL
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                60
     C                   ENDDO
     C     END1          ENDSR
     C*
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C*
     C*
     C*
**   ERRMSG - ERROR MESSAGES
INVALID ACTION CODE
INVALID GROUP CODE
INVALID COMMAND KEY
RECORD HAS BEEN UPDATED BY ANOTHER WORKSTATION
USER IS NOT AUTHORISED TO ACTION CODE
TITLE ONLY ACCOUNT IS INVALID
ACCOUNT CODE MUST BE INCOME OR EXPENSE
GROUP CODE NOT FOUND
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
