     H DEBUG
      *****************************************************************
/*OVR *  OVRDBF FILE(GZSDBANK) TOFILE(GZSDBANKL2)                     *                       CSD031
/**** *  RPGBASE                                                      *                     MD058854
/*STD *  RPGSQLBND                                                    *                     MD058854
/*EXI *  TEXT('Midas Customer Group Maintenance')
/******: OVRDBF FILE(TABLE2) TOFILE(TABCGU) SHARE(*NO)                *
/*OVRF*: OVRDBF FILE(TABLE3) TOFILE(TABCGU) SHARE(*NO)                *
     F*****************************************************************
     F*                                                               *
     F*  Midas Standing Data Module
     F*                                                               *
     F*  SD2351R - CUSTOMER GROUP MAINTENANCE                         *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD058854           Date 21Oct21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244285             Date 08Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAAA03             Date 15Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD005             Date 01Mar99               *
      *                 CTI002             Date 23Aug98               *
     F*                 062530             DATE 18NOV93               *
     F*                 062531             DATE 17NOV93               *
     F*                 S01413 *CREATE     DATE 13APR93               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD058854 - Deliverable Data Split for TABLEV4                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC043 - MidasPlus IASP Enablement                           *
      *  244285 - Remove action code 'I' from the maintenance.        *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAAA03 - Webfacing Changes (Recompile).                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
     F*  062530 - Customer group maintenance gives wrong error        *
     F*           if no delivered data in TABLEV4 .                   *
     F*  062531 - Customer group maintenance allows title only        *
     F*           accounts to be entered. Also, it should check that  *
     F*           only Income or Expense account codes are defined.   *
     F*  S01413 - Retail 3 Incorporation                              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
     FSD2351R#  CF   E             WORKSTN
     F                                     SFILE(#SFLRCD:##RR)
     FTABTBRE   IF   E             DISK    USROPN
     F***TABLE2  UF  E           K        DISK         KCOMIT       A                         CSD031
     F*TABLE2*** UF A E           K DISK    COMMIT                                          MD058854
     F**********                           USROPN                                           MD058854
     F**********                           IGNORE(TABTB10F)                                 MD058854
     F**********  TABTE10F                          KIGNORE                                   CGL029
     F**********                           IGNORE(TABLETAF)                                 MD058854
     F**********                           IGNORE(TABLETXF)                                 MD058854
     F***TABLE3  UF  E           K        DISK         KCOMIT                                 CSD031
     FTABLE3    UF   E           K DISK    COMMIT
     F                                     USROPN
     F                                     IGNORE(TABTB10F)
     F**********  TABTE10F                          KIGNORE                                   CGL029
     F                                     IGNORE(TABLEV4F)
     F/EJECT
     F*GPRECGL0* UF A E           K DISK    USROPN                                          MD058854
     F**********                           RENAME(TABLEV4F:TABLEVG)                         MD058854
     F**********                           COMMIT                                           MD058854
     F**********                           INFSR(*PSSR)                                     MD058854
     F*SDARCGL0* UF   E           K DISK    USROPN                                          MD058854
     F**********                           RENAME(TABLEV4F:SDARCGR0)                        MD058854
     F**********                           COMMIT                                           MD058854
     F**********                           INFSR(*PSSR)                                     MD058854
     F*SDARCGL1* IF   E           K DISK    USROPN                                          MD058854
     F**********                           RENAME(TABLEV4F:SDARCGR1)                        MD058854
     F**********                           COMMIT                                           MD058854
     F**********                           INFSR(*PSSR)                                     MD058854
     FGPZONEL0  IF   E           K DISK
      *                                                                                       CSD031
      ** Zone                                                                                 CSD031
      *                                                                                       CSD031
     FGZSDBANK  IF   E           K DISK    USROPN
     F                                     INFSR(*PSSR)
      *                                                                                       CSD031
      ** Bank ICD's keyed on date of next working day                                         CSD031
      *                                                                                       CSD031
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
     F*      48          ACTION CODE 'I'                              *
     F*      49          ACTION CODE 'A'                              *
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
     D*********           ERMSG   1   5 47               ERROR MESSAGES   062531
     D*********           ERMSG   1   7 47               ERROR MES 062531 062530
     D ERMSG           S             47    DIM(8) CTDATA PERRCD(1)              ERROR MESSAGES   062
     D ERCD            S              4    DIM(21)                              ERROR CODE OUTPUT
     D COMI            S              1    DIM(7)                               COMM. INDICATORS
     D**********          COMA        7  4               COMM. ACCOUNTS                       CGL029
     D**********          COMP        7  4               COMM. ACCOUNTS                       CGL029
     D COMA            S             10    DIM(7)
     D COMP            S             10    DIM(7)
     D COMO            S              1    DIM(7)                               COMM. ACCOUNTS
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CMDT            S             54    DIM(1) CTDATA PERRCD(1)
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
     D PDQMSG          DS          4040
      *                                                                                       CSD031
     D                 DS
     D  ZAMSDA                 1    132
      *                                                                                       CSD031
     D WDTQ            DS
     D  WPFNAM                 1     10
     D  WKEYS                 11     11
     D  WDATA                 41    251
      *                                                                                       CSD031
     D**   DATA STRUCTURE FOR LOTSCN ON COMMITMENT TEXT AREA
     D*
     D DSSCN         E DS                  EXTNAME(SD2351R#)
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
     D  DSSZN        E                     EXTFLD(#1AACC)
     D  DSSDT        E                     EXTFLD(#2EACC)
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
     D**********                              1   5 ZKEY05                                    CGL029
     D**********                              1   4 ZKEY04                                    CGL029
     D**********                              5   5 ZKEY01                                    CGL029
     D  ZKEY05                 1     11
     D  ZKEY04                 1     10
     D  ZKEY01                11     11
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
     D TABV4         E DS                  EXTNAME(TABV4JW0)                                MD058854
     D ZONEX         E                     EXTFLD(ZONE)                                     MD058854
     D*@1DBRC***     E DS                  EXTNAME(GPRECGL0)                                MD058854
     D @1DBRC        E DS                  EXTNAME(TABV4JW0)                                MD058854
     D                                     PREFIX(G)                                        MD058854
     D**GRECI***     E                     EXTFLD(RECI)                                     MD058854
     D**GRECT***     E                     EXTFLD(RECT)                                     MD058854
     D**GZZ010**     E                     EXTFLD(ZZ010)                                    MD058854
     D**GGRPN***     E                     EXTFLD(GRPN)                                     MD058854
     D**GMDBI***     E                     EXTFLD(MDBI)                                     MD058854
     D**GACMI***     E                     EXTFLD(ACMI)                                     MD058854
     D**GDINI***     E                     EXTFLD(DINI)                                     MD058854
     D**GINAI***     E                     EXTFLD(INAI)                                     MD058854
     D**GMINI***     E                     EXTFLD(MINI)                                     MD058854
     D**GDYSI***     E                     EXTFLD(DYSI)                                     MD058854
     D**GFIXI***     E                     EXTFLD(FIXI)                                     MD058854
     D**GTIMV***     E                     EXTFLD(TIMV)                                     MD058854
     D**GLCD ***     E                     EXTFLD(LCD)                                      MD058854
     D**GCHTP***     E                     EXTFLD(CHTP)                                     MD058854
     D**GTNLU***     E                     EXTFLD(TNLU)                                     MD058854
     D**GMDBA***     E                     EXTFLD(MDBA)                                     MD058854
     D**GACMA***     E                     EXTFLD(ACMA)                                     MD058854
     D**GDINA***     E                     EXTFLD(DINA)                                     MD058854
     D**GINAA***     E                     EXTFLD(INAA)                                     MD058854
     D**GMINA***     E                     EXTFLD(MINA)                                     MD058854
     D**GDYSA***     E                     EXTFLD(DYSA)                                     MD058854
     D**GFIXA***     E                     EXTFLD(FIXA)                                     MD058854
     D**GZONE***     E                     EXTFLD(ZONE)                                     MD058854
     D**GAACC***     E                     EXTFLD(AACC)                                     MD058854
     D**GEACC***     E                     EXTFLD(EACC)                                     MD058854
     D**GGPDT***     E                     EXTFLD(GPDT)                                     MD058554
      *                                                                                       CSD031
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
     D  TOIN         E                     EXTFLD(A5TOIN)                       062531
     D  ACSC         E                     EXTFLD(A5ACSC)                       062531
     D*
     D GPACOD        E DS                  EXTNAME(GPACODL0)
     D*                                                                                       CSD031
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
      *                                                                                       CSD031
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
      *                                                                                       CSD031
     D TXT1            C                   CONST('Accept to Zone:')
     D TXT2            C                   CONST('Central Data:  ')
     D**********    'XLIB/SDCSNDDTQ'      C         PGMB                               CSD031 CSC043
     D PGMB            C                   CONST('XPLIB/SDCSNDDTQ')
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
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'N'           W0DTL
     C                   ENDIF
      *                                                                                       CSD031
     C                   END
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
     C     *INU1         IFEQ      *OFF
     C**********         CLOSE     SDARCGL0                                                 MD058854
     C**********         CLOSE     SDARCGL1                                                 MD058854
     C**********         CLOSE     TABLE2                                                   MD058854
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** Called from Central layer                                                            CSD031
      *                                                                                       CSD031
     C**********         CLOSE     GZSDBANK                                                 MD058854
     C**********         CLOSE     GPRECGL0                                                 MD058854
     C                   ENDIF
     C                   ENDIF
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
      *                                                                                       CSD031
     C                   MOVE      'N'           CSD050            1
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *ON           *IN63
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
     C                   MOVE      'N'           WF11
     C                   MOVE      *ON           *IN57
     C                   ELSE
     C                   MOVE      *OFF          *IN57
     C                   ENDIF
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'N'           W0DTL
     C                   MOVE      'CHG'         WMODE
     C     *INU1         IFEQ      *ON
     C                   OPEN      GZSDBANK
     C**********         OPEN      GPRECGL0                                                 MD058854
     C                   READ      GZSDBANK                               47
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD050        IFEQ      'N'
     C     CSD050        OREQ      'Y'
     C     *INU1         ANDEQ     *OFF
      *                                                                                       CSD031
     C**********         OPEN      SDARCGL0                                                 MD058854
     C**********         OPEN      SDARCGL1                                                 MD058854
     C**********         OPEN      TABLE2                                                   MD058854
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
     C                   MOVE      *INU1         *IN89
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
      ** ACCESS GZBANKL2                                                                      CSD031
      *                                                                                       CSD031
     C                   MOVE      *ZEROS        WDNWD             5 0
     C     *HIVAL        SETLL     GZSDBANK
     C                   READ      GZSDBANK                               90
     C     *IN90         IFEQ      '0'
     C                   MOVE      BJDFIN        ZDATFM
     C                   MOVE      BJMRDT        SRUNA
     C                   MOVE      BJDNWD        WRUND
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
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
     C                   ENDIF
     C                   ENDIF
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
     C                   MOVE      'N'           W0DTL             1
     C*
     C**  DISPLAY INITIAL SREEN
     C*
     C                   EXSR      SCREEN
     C*
     C                   MOVE      'Y'           W0DTL             1
      *                                                                                       CSD031
     C**  CHECK FOR CMD/3
     C   KC              GOTO      ENDINI                                       ** GO ENDINI **
     C*
     C**  AT THIS STAGE ASSUME THE INITIAL SCREEN IS INVALID
     C                   SETON                                        41
     C*
     C**  DO THE FOLLOWING UNTIL A SCREEN IS VALID OR CMD/3 PRESSED
     C*
     C     *IN41         DOUEQ     '0'                                          ** BEGIN DO1**
     C     *INKC         OREQ      '1'
     C*
      ** If CSD050 is on initialise screen indicators                                         CSD031
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
      *                                                                                       CSD031
     C                   EXSR      SETIND
      *                                                                                       CSD031
      ** Check if F11 was pressed, acceptance mode                                            CSD031
      *                                                                                       CSD031
     C     *INKK         IFEQ      *ON
     C                   MOVE      *BLANKS       SGRPC
     C                   MOVE      *BLANKS       SGRPN
     C                   EXSR      SRACCP
     C                   MOVE      'N'           W0DTL
     C                   MOVE      'CHG'         WMODE
     C                   ENDIF
      *                                                                                       CSD031
     C     *INU1         IFEQ      *OFF
      *                                                                                       CSD031
     C     WF03          IFEQ      'Y'
     C                   MOVE      *ON           *INKC
     C                   ENDIF
      *                                                                                       CSD031
      ** Check if F12 was press in SRACCP routine                                             CSD031
      *                                                                                       CSD031
     C     WF12          IFEQ      'Y'
     C                   MOVE      'N'           WF12
      *                                                                                       CSD031
      ** Blank out the screen fields and reset indicators                                     CSD031
      ** prior to display of initial screen                                                   CSD031
      *                                                                                       CSD031
     C                   EXSR      SETINI
     C                   GOTO      RELOAD
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C     SKIP2         TAG
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
     C**  VALIDATE ACTION CODE (I, A, OR E)
     C*
     C                   MOVEA     '0000'        *IN(48)
     C********** ACTCD     COMP 'I'                      48                                   244285
     C     ACTCD         COMP      'A'                                    49
     C  N48
     CANN49ACTCD         COMP      'E'                                212151
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
     C     CSD050        IFEQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C                   CALL      'ZVACTU'
     C                   PARM      ACTCD         @ZACTN            1
     C                   PARM                    @ERR              1 0
     C*
     C     @ERR          IFNE      0
     C                   SETON                                        1021
     C                   GOTO      SKIP1
     C                   END
     C*
     C                   ENDIF
     C                   END
     C*
     C**  IF MULTIPLE BRANCH SYSTEM, USER MUST BE AUTHORISED TO ACTION
     C**  ON BRANCH
     C*
     C     AGMBIN        IFEQ      'Y'
     C     CSD050        IFEQ      'Y'
     C     *INU1         IFEQ      *OFF
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
     C                   ENDIF
     C                   ENDIF
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
     C**  FOR ACTION 'I' LIVE REC MUST NOT EXIST
     C*
     C     *IN48         IFEQ      '1'
     C   45RECI          IFEQ      'D'
     C                   SETON                                        21
     C                   END
     C                   END
     C*
     C**  FOR ACTIONS 'A' OR 'E' LIVE REC MUST EXIST
     C*
     C     *IN49         IFEQ      '1'
     C     *IN51         OREQ      '1'
     C**N45*******         SETON                     21                   062530
     C  N45              SETON                                        22                       06253
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
     C                   MOVE      *BLANKS       SERMSG
     C*
     C   21              MOVEL     ERMSG(1)      SERMSG
     C   22
     CANN21              MOVEL     ERMSG(2)      SERMSG
     C*
     C     *IN59         IFEQ      '1'                                                         06253
     C     SGRPC         ANDLE     '8'                                                         06253
     C     SGRPC         ANDGE     '1'                                                         06253
     C     *IN21         ANDEQ     '0'                                                         06253
     C                   MOVEL     ERMSG(8)      SERMSG                                        06253
     C                   END                                                                   06253
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
     C     RELOAD        TAG
     C                   MOVE      'N'           W0DTL
     C                   EXSR      SCREEN
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
     C**  IF ACTION = 'I' THEN BLANK ALL SCREEN DETAILS
     C**  OTHERWISE USE THE CURRENT GROUP CODE RECORD FIELDS
     C*
     C     *IN48         IFEQ      '1'                                          B001
     C                   MOVE      *BLANKS       SGRPN
     C                   MOVE      'NNNNNNN'     SSCOMI
     C                   MOVE      *BLANKS       SSCOMA
     C                   MOVE      *BLANKS       #1AACC
     C                   MOVE      *BLANKS       #2EACC
     C*
     C                   ELSE                                                   *001
     C*
     C     CSD050        IFEQ      'Y'
     C                   MOVE      *ON           *IN64
     C     SGRPC         IFEQ      *BLANKS
     C     SGRPN         ANDEQ     *BLANKS
      *                                                                                       CSD031
     C                   EXSR      SETINI
     C                   GOTO      SKIP
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   MOVE      GRPN          SGRPN
     C                   MOVEA     DSCOMI        COMI
     C                   MOVEA     DSCOMA        COMA
     C                   DO        7             X                              B002
     C     COMA(X)       COMP      *ALL'0'                                59
     C   59              MOVEL     *BLANKS       COMA(X)
     C     COMO(X)       IFEQ      'N'
     C                   MOVE      COMO(X)       COMI(X)
     C                   MOVE      COMP(X)       COMA(X)
     C                   END                                                    E002
     C                   END                                                    E002
     C                   MOVEA     COMA          SSCOMA
     C                   MOVEA     COMI          SSCOMI
      *                                                                                       CSD031
     C     WF11          IFEQ      'N'
     C                   MOVE      *OFF          *IN85
     C     GPDT          IFNE      *BLANK
     C                   MOVE      GPDT          #1AACC
     C                   ELSE
     C                   MOVE      *BLANK        #1AACC
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN85
     C                   ENDIF
      *                                                                                       CSD031
     C     *INU1         IFEQ      *ON
     C                   MOVE      *ON           *IN65
     C                   MOVE      AACC          #1AACC
     C                   ENDIF
      *                                                                                       CSD031
     C     EACC          IFEQ      *ZERO
     C                   MOVE      *BLANKS       #2EACC
     C                   ELSE
     C                   MOVE      *BLANKS       #2EACC
     C                   CALL      'ZDATE2'
     C                   PARM                    EACC
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    DATEB
     C                   MOVE      ZDATE         #2EACC
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   MOVE      GRPN          SGRPN
     C                   MOVEA     DSCOMI        COMI
     C                   MOVEA     DSCOMA        COMA
     C                   DO        7             X                              B002
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
     C**  RELEASE CUSTOMER GROUP TABLE REC
     C     CSD050        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C***45*****         UPDATE    TABLEVG                                                  MD058854
     C                   ELSE
     C***45*****         UPDATE    TABLEV4F                                                 MD058854
     C                   ENDIF
     C   45              COMMIT
     C*
     C**    SET INDICATORS PRIOR TO DISPLAY OF DETAIL SCREEN
     C*
     C     SKIP          TAG
     C                   SETOFF                                       4344
     C                   SETOFF                                       2122
     C                   MOVEA     '0000000'     *IN(23)
     C                   MOVEA     '0000000'     *IN(30)
     C                   SETOFF                                       8182
     C                   SETON                                        808384
     C   51              SETON                                        82
      *
      **  If CSD050 is on, set Screen flag to Y and initialised
      *
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'Y'           W0DTL
     C                   EXSR      SETIND
     C                   ENDIF
     C*
     C                   EXSR      SCREEN
     C*
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'N'           W0DTL
     C                   ENDIF
      *                                                                                       CSD031
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
     C*
     C**  DO WHATEVER PROCESSING IS REQUIRED BY THE ACTION CODE
     C*
     C**    INPUT
     C     *IN48         IFEQ      '1'
     C                   EXSR      INPAMD                                       INPUT/AMEND
     C                   GOTO      ENDDTL                                       ** GO ENDDTL **
     C                   END
     C*
     C**    AMEND
     C     *IN49         IFEQ      '1'
     C                   EXSR      INPAMD                                       INPUT/AMEND
     C                   GOTO      ENDDTL                                       ** GO ENDDTL **
     C                   END
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
     C**  INPUT/AMEND PROCESS
     C*   ~~~~~~~~~~~~~~~~~~~
     C*
     C     INPAMD        BEGSR
     C*
     C**  AT THIS STAGE ASSUME THE DETAIL SCREEN IS INVALID
     C                   SETON                                        42
     C*
     C**  ATTEMPT TO VALIDATE THE SCREEN UNTIL THE DETAILS ARE VALID
     C*   OR CMD/3 IS PRESSED OR CMD/12 IS PRESSED
     C*
     C     *IN42         DOUEQ     '0'                                          B001
     C     *INKC         OREQ      '1'
     C     *INKL         OREQ      '1'
     C                   EXSR      VALID
     C                   END                                                    E001
     C*
     C  NKC
     CANNKL              EXSR      UPDATE
     C*
     C                   ENDSR
     C*
     C*
     C*-------------------------------------------------------------------
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C**  VALIDATION PROCESS
     C*   ~~~~~~~~~~~~~~~~~~
     C*
     C     VALID         BEGSR
     C*
     C**  RESET DISPLAY INDICATORS PRIOR TO DISPLAY OF DETAIL SCREEN
     C*
     C                   SETOFF                                       2122
     C                   SETOFF                                       4344
     C                   MOVEA     '0000000'     *IN(23)
     C                   MOVEA     '0000000'     *IN(30)
     C                   MOVEA     '00'          *IN(37)
     C                   MOVE      *ON           *IN54
     C*
     C**  CHECK FOR CMD/3
     C   KC              GOTO      ENDVAL                                       ** GO ENDVAL **
     C*
     C**  CHECK FOR CMD/12
     C     *INKL         IFEQ      '1'                                          B001
     C**       BLANK OUT THE SCREEN FIELDS AND
     C**       RESET INDICATORS PRIOR TO DISPLAY OF INITIAL SCREEN
     C**       FOR NEXT TRANSACTION
     C                   EXSR      SETINI
     C                   GOTO      ENDVAL                                       ** GO ENDVAL **
     C                   END                                                    E001
     C*
     C**  SET ON INDICATOR 84                                             062531
     C                   SETON                                        84                       06253
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
      *                                                                                       CSD031
      ** 'Accept to Zone' should be 'Y' or 'N'                                                CSD031
      *                                                                                       CSD031
     C     #1AACC        IFNE      *BLANKS
     C     #1AACC        ANDNE     'Y'
     C     #1AACC        ANDNE     'N'
     C                   MOVEL     'SCC0015'     MSGID
     C                   MOVEL     'SDUSRMSG'    MSGF
     C                   EXSR      SRRTTX
     C                   MOVE      *ON           *IN37
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN84
     C                   MOVEL     MSGTXT        SERMSG
     C                   ENDIF
      * If Accept to Zone is blank, default to N                                              CSD031
     C     #1AACC        IFEQ      *BLANK
     C                   MOVE      'N'           #1AACC
     C                   ENDIF
      *                                                                                       CSD031
      ** Effective date may only be entered if 'Accept to Zone' is 'N'.                       CSD031
      *                                                                                       CSD031
     C     #1AACC        IFNE      'N'
     C     #2EACC        ANDNE     *BLANK
     C                   MOVEL     'CSD0001'     MSGID
     C                   MOVEL     'SDUSRMSG'    MSGF
     C                   EXSR      SRRTTX
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN84
     C                   MOVEL     MSGTXT        SERMSG
     C                   ENDIF
      *                                                                                       CSD031
      ** effective date is invalid                                                            CSD031
      *                                                                                       CSD031
     C     #1AACC        IFEQ      'N'
     C     #2EACC        ANDNE     *BLANK
      *                                                                                       CSD031
     C                   TESTN                   #2EACC               80
     C                   MOVE      *ZERO         ZDATE
     C                   MOVE      #2EACC        ZDATE
     C                   EXSR      ZDATE1
     C     ZERR          IFNE      *BLANKS
     C     *IN80         OREQ      *OFF
     C                   MOVEL     'ASM0045'     MSGID
     C                   MOVEL     'SDUSRMSG'    MSGF
     C                   EXSR      SRRTTX
     C                   MOVE      *ON           *IN38
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN54
     C                   MOVE      *OFF          *IN84
     C                   MOVEL     MSGTXT        SERMSG
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
      ** *INU1=*OFF                                                                           CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   MOVE      SGRPC         ZZ010
     C*****ZZ010         CHAIN     SDARCGL1                           47                    MD058854
     C     *IN47         IFEQ      *OFF
     C                   MOVEL     'CSD0002'     MSGID
     C                   MOVEL     'SDUSRMSG'    MSGF
     C                   EXSR      SRRTTX
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN54
     C                   SETOFF                                       84
     C                   MOVEL     MSGTXT        SERMSG
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
     C                   ENDIF
     C*
     C**  MOVE COMMISSION INDICATORS AND ACCOUNTS TO TABLE FIELDS
     C                   MOVEA     SSCOMI        COMI
     C                   MOVEA     SSCOMA        COMA
     C*
     C**  DO THE FOLLOWING 7 TIMES IN ALL, VALIDATING EACH INDICATOR
     C**  AND ACCOUNT CODE IN TURN.
     C                   DO        7             X                 2 0          ** BEGIN DO3 **
     C*
     C                   SETOFF                                       535459
     C*
     C**    INDICATORS MUST BE 'Y' OR 'N'
     C     COMI(X)       IFNE      'Y'
     C     COMI(X)       ANDNE     'N'
     C                   SETON                                        4353
     C                   END
     C*
     C**    IF INDICATOR IS 'Y' AN ACCOUNT MUST BE ENTERED
     C**    AS NUMERIC AND GREATER THAN ZERO
     C     COMI(X)       IFEQ      'Y'
     C**********           MOVELCOMA,X    XCOMA   50                                          CGL029
     C**********           MOVELXCOMA     XCOMAA  4                                           CGL029
     C                   MOVEL     COMA(X)       XCOMA            11 0
     C                   MOVEL     XCOMA         XCOMAA           10
     C     COMA(X)       COMP      XCOMAA                             5454
     C  N54XCOMA         COMP      0                                    5454
     C   54              SETON                                        44
     C                   END
     C*
     C**    IF INDICATOR IS 'N' AN ACCOUNT MUST NOT BE ENTERED
     C     COMI(X)       IFEQ      'N'
     C     COMA(X)       ANDNE     *BLANKS
     C                   SETON                                        4454
     C                   END
     C*
     C*
     C**    IF INDICATOR IS 'Y' A NUMERIC ACCOUNT CODE IS ENTERED
     C**    IT MUST EXIST ON THE ACCOUNT CODE TABLE
     C*
     C     COMI(X)       IFEQ      'Y'                                          B001
     C     *IN(54)       ANDEQ     '0'
     C*
     C**      ACCESS ACCOUNT CODE TABLE RECORD.
     C                   MOVEA     COMA(X)       ZKEY04
     C*
     C     CSD050        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C                   CALL      'AOGACDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ZKEY04        @ACCD            10
     C     GPACOD        PARM      GPACOD        DSSDY
      *                                                                                       CSD031
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      *ON           *IN44
     C                   MOVE      *ON           *IN54
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   CALL      'AOACODR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C**********           PARM ZKEY04    @ACCD   4                                           CGL029
     C********** SDACOD    PARM SDACOD    DSFDY                                               CGL029
     C                   PARM      ZKEY04        @ACCD            10
     C     SDACOD        PARM      SDACOD        DSSDY
     C*
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                          4454
     C                   END
     C*
     C**  IF ACCOUNT CODE EXISTS, IT MUST BE A 'G'.
     C     ATYP          IFNE      'G'
     C                   SETON                                        4454
     C                   END
     C*                                                                   062531
     C*  TITLE ONLY ACCOUNTS MUST NOT BE ENTERED                          062531
     C*                                                                   062531
     C     TOIN          IFEQ      'Y'                                                         06253
     C                   SETON                                        5444                     06253
     C                   SETOFF                                       84                       06253
     C                   MOVEL     ERMSG(6)      SERMSG                                        06253
     C                   END                                                                   06253
     C*                                                                   062531
     C*  ACCOUNT CODE MUST BE INCOME OR EXPENSE                           062531
     C*                                                                   062531
     C     ACSC          IFNE      'IN'                                                        06253
     C     ACSC          ANDNE     'EX'                                                        06253
     C                   SETON                                        5444                     06253
     C                   SETOFF                                       84                       06253
     C                   MOVEL     ERMSG(7)      SERMSG                                        06253
     C                   END                                                                   06253
     C*
     C*
     C                   END                                                    E001
     C*
     C**      SET INDICATORS IF COMMISSION INDICATORS IN ERROR
     C   53
     CANN23X             COMP      1                                      23
     C   53
     CANN25X             COMP      2                                      25
     C   53
     CANN27X             COMP      3                                      27
     C   53
     CANN29X             COMP      4                                      29
     C   53
     CANN31X             COMP      5                                      31
     C   53
     CANN33X             COMP      6                                      33
     C   53
     CANN35X             COMP      7                                      35
     C*
     C**      SET INDICATORS IF COMMISSION ACCOUNT CODE IN ERROR
     C   54
     CANN24X             COMP      1                                      24
     C   54
     CANN26X             COMP      2                                      26
     C   54
     CANN28X             COMP      3                                      28
     C   54
     CANN30X             COMP      4                                      30
     C   54
     CANN32X             COMP      5                                      32
     C   54
     CANN34X             COMP      6                                      34
     C   54
     CANN36X             COMP      7                                      36
     C*
     C                   END                                                    ** END DO 3 **
     C*
     C**  VALID DETAIL SCREEN
     C  N43
     CANN44              SETOFF                                       42
     C*
     C**  INVALID DETAIL SCREEN - REDISPLAY
     C*
     C   42              DO                                                     B001
     C*
     C                   MOVEA     *BLANKS       ERCD
     C                   Z-ADD     0             S
     C*
     C**    SET UP  ERROR CODES
     C   23              ADD       1             S
     C   23              MOVE      '003'         ERCD(S)
     C   25              ADD       1             S
     C   25              MOVE      '004'         ERCD(S)
     C   27              ADD       1             S
     C   27              MOVE      '005'         ERCD(S)
     C   29              ADD       1             S
     C   29              MOVE      '006'         ERCD(S)
     C   31              ADD       1             S
     C   31              MOVE      '007'         ERCD(S)
     C   33              ADD       1             S
     C   33              MOVE      '008'         ERCD(S)
     C   35              ADD       1             S
     C   35              MOVE      '009'         ERCD(S)
     C   24              ADD       1             S
     C   24              MOVE      '010'         ERCD(S)
     C   26              ADD       1             S
     C   26              MOVE      '011'         ERCD(S)
     C   28              ADD       1             S
     C   28              MOVE      '012'         ERCD(S)
     C   30              ADD       1             S
     C   30              MOVE      '013'         ERCD(S)
     C   32              ADD       1             S
     C   32              MOVE      '014'         ERCD(S)
     C   34              ADD       1             S
     C   34              MOVE      '015'         ERCD(S)
     C   36              ADD       1             S
     C   36              MOVE      '016'         ERCD(S)
     C   37              ADD       1             S
     C   37              MOVE      '017'         ERCD(S)
     C   38              ADD       1             S
     C   38              MOVE      '018'         ERCD(S)
     C*
     C                   MOVE      *BLANKS       SERCD
     C                   MOVEA     ERCD          SERCD
     C*
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'Y'           W0DTL
     C                   ENDIF
      *                                                                                       CSD031
     C                   SETOFF                                       83
     C                   EXSR      SCREEN
     C                   SETON                                        83
     C*
     C     CSD050        IFEQ      'Y'
     C                   MOVE      'N'           W0DTL
     C                   ENDIF
      *                                                                                       CSD031
     C                   END                                                    E001
     C*
     C**  CHECK FOR CMD/12
     C     *INKL         IFEQ      '1'                                          B001
     C**       BLANK OUT THE SCREEN FIELDS AND
     C**       RESET INDICATORS PRIOR TO DISPLAY OF INITIAL SCREEN
     C**       FOR NEXT TRANSACTION
     C                   EXSR      SETINI
     C                   GOTO      ENDVAL                                       ** GO ENDVAL **
     C                   END                                                    E001
     C*
     C     ENDVAL        ENDSR                                                  **  ENDVAL  **
     C*
     C*
     C*-------------------------------------------------------------------
     C/EJECT
     C*-------------------------------------------------------------------
     C*
     C**  UPDATE PROCESS
     C*   ~~~~~~~~~~~~~~
     C*
     C     UPDATE        BEGSR
     C*
     C                   SETOFF                                       46
     C*
     C**  FOR ACTION 'INPUT' TO WRITE A REC THAT DOESN'T
     C**  YET EXIST ON THE GROUP CODE TABLE
     C*
     C   48
     CANN45              DO                                                     B001
     C*
     C**    CHECK THAT REC HASN'T BEEN INSERTED BY ANOTHER WORKSTATION
     C                   EXSR      CHNGCT
     C*
     C  N59              SETON                                        46        CHANGED|
     C*
     C**    IF CHANGED BY SOMEONE ELSE THEN ABORT THE UPDATE,
     C*     RELEASE THE RECORD AND SET UP AN ERROR MESSAGE
     C*     TO BE DISPLAYED ON THE INITIAL SCREEN
     C*
     C     *IN46         IFEQ      '1'                                          B002
     C*
     C                   ROLBK
     C*
     C                   MOVEA     *BLANKS       ERCD
     C                   Z-ADD     1             S
     C                   MOVE      '020'         ERCD(S)
     C                   MOVEA     ERCD          SERCD
     C*
     C                   MOVEL     ERMSG(4)      SERMSG
     C*
     C**    OTHERWISE UPDATE PROCEEDS AS NORMAL
     C*
     C                   ELSE                                                   *002
     C*
     C*
     C**    SET UP AND WRITE THE GROUP CODE REC
     C                   EXSR      UPDGCR
     C*
     C**    UPDATE TABLE HEADER
     C     CSD050        IFNE      'Y'
     C     *INU1         ANDNE     *ON
     C                   EXSR      UPDTHR
     C                   ENDIF
     C*
     C                   END                                                    E002
     C*
     C                   END                                                    E001
     C*
     C**  FOR 'INPUT' OR 'AMEND' OF A REC THAT
     C**  ALREADY EXISTS ON THE GROUP CODE TABLE
     C*
     C   49
     COR 48
     CAN 45              DO                                                     B001
     C*
     C*
     C**    CHECK THAT REC HASN'T BEEN UPDATED BY ANOTHER WORKSTATION
     C                   EXSR      CHNGCT
     C*
     C     LSTC          COMP      LSTCS                              4646      CHANGED|
     C*
     C**    IF CHANGED BY SOMEONE ELSE THEN ABORT THE UPDATE,
     C*     RELEASE THE RECORD AND SET UP AN ERROR MESSAGE
     C*     TO BE DISPLAYED ON THE INITIAL SCREEN
     C*
     C     *IN46         IFEQ      '1'                                          B002
     C*
     C                   ROLBK
     C*
     C                   MOVEA     *BLANKS       ERCD
     C                   Z-ADD     1             S
     C                   MOVE      '020'         ERCD(S)
     C                   MOVEA     ERCD          SERCD
     C*
     C                   MOVEL     ERMSG(4)      SERMSG
     C*
     C**    OTHERWISE UPDATE PROCEEDS AS NORMAL
     C*
     C                   ELSE                                                   *002
     C*
     C**    UPDATE THE GROUP CODE REC
     C                   EXSR      UPDGCR
     C*
     C**    AND UPDATE TABLE HEADER
     C     CSD050        IFNE      'Y'
     C     *INU1         ANDNE     *ON
     C                   EXSR      UPDTHR
     C                   ENDIF
     C*
     C                   END                                                    E002
     C*
     C                   END                                                    E001
     C*
     C**  FOR SUCESSFUL UPDATE OF GROUP CODE RECORD,
     C**  UPDATE TABLE HEADER FILE AND COMMIT ALL UPDATES
     C*
     C     *IN46         IFEQ      '0'                                          B001
     C                   MOVE      'H'           RECI
     C                   MOVEL     '00      '    KEY
     C                   MOVE      '    '        KEY
     C*
     C     CSD050        IFEQ      'N'
     C     CSD050        OREQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C                   OPEN      TABLE3
      *                                                                                       CSD031
     C     KEY           CHAIN     TABLE3                             59
     C                   MOVE      '1'           ICGP
     C                   UPDATE    TABLETAF
     C                   CLOSE     TABLE3
     C                   ENDIF
     C*
     C**  REC UPDATED - END COMMITMENT CYCLE
     C*
     C                   EXSR      COMMIT
     C*
     C                   END                                                    E001
     C*
     C**    BLANK OUT THE SCREEN FIELDS AND
     C**    RESET INDICATORS PRIOR TO DISPLAY OF INITIAL SCREEN
     C**    FOR NEXT TRANSACTION
     C                   EXSR      SETINI
     C   46              SETOFF                                       8384
     C*
     C                   ENDSR
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
     C                   MOVEL     'SD2351R'     DBPGM
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
     C**  ZTNLU1 PROCESS
     C*   ~~~~~~~~~~~~~~
     C*
     C**  TO LOCK THE TRANSACTION NUMBER DATA AREA AND THEN
     C**  UPDATE AND RELEASE THE DATA AREA.
     C*
     C     ZTNLU1        BEGSR
     C*
     C     *DTAARA       DEFINE    MNATN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         NATN              5 0
     C                   MOVE      FNATN         ZZWK05            5 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
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
     C     CSD050        IFEQ      'Y'
     C                   EXSR      SETIND
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDSR
     C*
      *****************************************************************                       CSD031
      *                                                               *                       CSD031
      * SETIND - Initialised Screen Indicators                        *                       CSD031
      *                                                               *                       CSD031
      *****************************************************************                       CSD031
      *                                                                                       CSD031
     C     SETIND        BEGSR
      *                                                                                       CSD031
      **  Condition Indicators accordingly if CSD050 is on                                    CSD031
      *                                                                                       CSD031
     C                   MOVE      'N'           WF11
     C     CSD050        IFEQ      'Y'
      *                                                                                       CSD031
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *OFF          *IN64
      *                                                                                       CSD031
     C     *INU1         IFEQ      *OFF
      *                                                                                       CSD031
     C     WMODE         IFEQ      'CHG'
      *                                                                                       CSD031
      ** Display Initial Screen  (ZONE)                                                       CSD031
      *                                                                                       CSD031
     C     W0DTL         IFEQ      'N'
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *ON           *IN82
     C                   MOVE      *ON           *IN52
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** Display Detail Screen                                                                CSD031
      *                                                                                       CSD031
     C                   MOVE      *ON           *IN64
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN52
     C                   SELECT
     C     ACTCD         WHENEQ    'I'
     C                   MOVE      *ON           *IN70
     C                   MOVE      *OFF          *IN82
     C     ACTCD         WHENEQ    'A'
     C                   MOVE      *ON           *IN70
     C                   MOVE      *ON           *IN82
     C     ACTCD         WHENEQ    'E'
     C                   MOVE      *ON           *IN63
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *ON           *IN82
     C                   ENDSL
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
      ** Display Initial Screen  (GLOBAL)                                                     CSD031
      *                                                                                       CSD031
     C     W0DTL         IFEQ      'N'
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *ON           *IN82
     C                   MOVE      *OFF          *IN52
     C                   MOVE      *ON           *IN63
     C                   MOVE      *OFF          *IN64
     C                   MOVE      *OFF          *IN65
     C                   ELSE
      *                                                                                       CSD031
      ** Display Detail Screen                                                                CSD031
      *                                                                                       CSD031
     C                   MOVE      *ON           *IN64
     C                   MOVE      *OFF          *IN70
     C                   MOVE      *OFF          *IN52
     C                   SELECT
     C     ACTCD         WHENEQ    'I'
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *ON           *IN65
     C                   MOVE      *ON           *IN70
     C                   MOVE      *OFF          *IN82
     C     ACTCD         WHENEQ    'A'
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *ON           *IN65
     C                   MOVE      *ON           *IN70
     C                   MOVE      *OFF          *IN82
     C     ACTCD         WHENEQ    'E'
     C                   MOVE      *ON           *IN63
     C                   MOVE      *OFF          *IN65
     C                   MOVE      *ON           *IN82
     C                   ENDSL
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDSR
      *                                                                                       CSD031
     C*-------------------------------------------------------------------
     C*
     C**  SCREEN READ/DISPLAY PROCESS / WITH HELP FACILITY
     C*   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C     SCREEN        BEGSR
     C*
     C     CSD050        IFEQ      'Y'
     C     *INU1         IFEQ      *ON
     C                   MOVEL     TXT1          ACCTXT
     C                   ELSE
     C                   MOVEL     TXT2          ACCTXT
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
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
     C                   MOVE      SGRPC         KEY
     C                   MOVE      SGRPC         ZZ010
     C*
     C     CSD050        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C*****ZZ010         CHAIN     TABLEVG                            59                    MD058854
     C                   ELSE
     C*****KEY           CHAIN     TABLE2                             59                    MD058854
     C/EXEC SQL                                                                             MD058854
     C+ select * into :TABV4 from TABV4JW0                                                  MD058854
     C+ where ZZ010 = :ZZ010                                                                MD058854
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
                                                                                            MD058854
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C*
     C**  UPDATE GROUP CODE RECORD
     C*   ~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C**  TO SET UP AND WRITE THE GROUP CODE RECORD TABLEV4
     C*
     C     UPDGCR        BEGSR
     C*
     C                   MOVE      *BLANKS       ZTABKY           12
     C                   MOVEL     '81      '    ZTABKY
     C                   MOVE      SGRPC         ZTABKY
     C                   MOVE      ZTABKY        KEY
     C                   MOVE      SGRPC         ZZ010
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
     C                   MOVE      #1AACC        AACC
     C     *INU1         IFEQ      *ON
     C                   MOVE      *ZERO         ZDATE
     C                   MOVE      #2EACC        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   MOVE      'Y'           GPDT
      *                                                                                       CSD031
     C                   ELSE
     C                   MOVE      #1EACC        ZDATE
      *                                                                                       CSD031
     C                   MOVE      DATF          ZDATFM
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        EACC
     C*
     C**  OBTAIN LAST TRANSACTION NUMBER, SET UP STANDARD OUTPUT INFO
     C*
     C                   TIME                    MTIME             6 0
     C                   EXSR      ZTNLU1
     C                   MOVE      'SD'          MDID
     C                   MOVEL     'SD2351R'     PGMN
     C                   MOVE      WSID          WSIDX
     C                   MOVE      USRID         USRIDX
     C*
     C                   MOVE      'D'           RECI
     C                   MOVE      '81'          RECT
     C                   MOVE      SGRPN         GRPN
     C                   MOVE      SSCOMI        DSCOMI
     C*
     C                   MOVE      SMDBA         MDBA
     C                   MOVE      SACMA         ACMA
     C                   MOVE      SDINA         DINA
     C                   MOVE      SINAA         INAA
     C                   MOVE      SMINA         MINA
     C                   MOVE      SDYSA         DYSA
     C                   MOVE      SFIXA         FIXA
     C*
     C                   MOVE      WRUND         LCD
     C                   MOVE      MTIME         TIMV
     C   48
     CANN49              MOVE      'I'           CHTP
     C  N48
     CAN 49              MOVE      'A'           CHTP
     C                   MOVE      NATN          TNLU
     C*
     C                   CLEAR                   @1DBRC
      *                                                                                       CSD031
      ** Move records to GPRECGL0 fields for update                                           CSD031
      *                                                                                       CSD031
     C                   EXSR      SRMOVE
      *                                                                                       CSD031
     C**    IF THE REC AREADY EXISTS THEN UPDATE OTHERWISE WRITE
     C     CSD050        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C     *IN45         IFEQ      *ON
     C**********         UPDATE    TABLEVG                                                  MD058854
     C                   ENDIF
     C                   ELSE
     C***45*****         UPDATE    TABLEV4F                                                 MD058854
     C                   If        *IN45 = *ON                                              MD058854
     C/EXEC SQL                                                                             MD058854
     C+ update      TABV4XTD set                                                            MD058854
     C+   RECI   = :RECI                                                                    MD058854
     C+  ,RECT   = :RECT                                                                    MD058854
     C+  ,GRPN   = :GRPN                                                                    MD058854
     C+  ,MDBI   = :MDBI                                                                    MD058854
     C+  ,ACMI   = :ACMI                                                                    MD058854
     C+  ,DINI   = :DINI                                                                    MD058854
     C+  ,INAI   = :INAI                                                                    MD058854
     C+  ,MINI   = :MINI                                                                    MD058854
     C+  ,DYSI   = :DYSI                                                                    MD058854
     C+  ,FIXI   = :FIXI                                                                    MD058854
     C+  ,MDBAQQ = :MDBA                                                                    MD058854
     C+  ,ACMAQQ = :ACMA                                                                    MD058854
     C+  ,DINAQQ = :DINA                                                                    MD058854
     C+  ,INAAQQ = :INAA                                                                    MD058854
     C+  ,MINAQQ = :MINA                                                                    MD058854
     C+  ,DYSAQQ = :DYSA                                                                    MD058854
     C+  ,FIXAQQ = :FIXA                                                                    MD058854
     C+  ,TIMV   = :TIMV                                                                    MD058854
     C+  ,ZZ007  = :ZZ007                                                                   MD058854
     C+  ,LCD    = :LCD                                                                     MD058854
     C+  ,CHTP   = :CHTP                                                                    MD058854
     C+  ,TNLU   = :TNLU                                                                    MD058854
     C+  ,MDBA   = :MDBA                                                                    MD058854
     C+  ,ACMA   = :ACMA                                                                    MD058854
     C+  ,DINA   = :DINA                                                                    MD058854
     C+  ,INAA   = :INAA                                                                    MD058854
     C+  ,MINA   = :MINA                                                                    MD058854
     C+  ,DYSA   = :DYSA                                                                    MD058854
     C+  ,FIXA   = :FIXA                                                                    MD058854
     C+  ,ZONE   = :ZONE                                                                    MD058854
     C+  ,IUSR   = :IUSR                                                                    MD058854
     C+  ,AUSR   = :AUSR                                                                    MD058854
     C+  ,XUSR   = :XUSR                                                                    MD058854
     C+  ,AACC   = :AACC                                                                    MD058854
     C+  ,EACC   = :EACC                                                                    MD058854
     C+  ,GPDT   = :GPDT                                                                    MD058854
     C+ where ZZ010 = :ZZ010                                                                MD058854
     C/END-EXEC                                                                             MD058854
     C                   Endif                                                              MD058854
     C                   ENDIF
      *                                                                                       CSD031
     C     CSD050        IFEQ      'Y'
     C     *INU1         ANDEQ     *ON
     C     *IN45         IFEQ      *OFF
     C**********         WRITE     TABLEVG                                                  MD058854
     C                   ENDIF
     C                   ELSE
     C**N45*****         WRITE     TABLEV4F                                                 MD058854
     C                   If        *IN45 = *OFF                                             MD058854
     C/EXEC SQL                                                                             MD058854
     C+ insert into TABV4CTD                                                                MD058854
     C+ (                                                                                   MD058854
     C+   RECI                                                                              MD058854
     C+  ,RECT                                                                              MD058854
     C+  ,ZZ010                                                                             MD058854
     C+  ,GRPN                                                                              MD058854
     C+  ,MDBI                                                                              MD058854
     C+  ,ACMI                                                                              MD058854
     C+  ,DINI                                                                              MD058854
     C+  ,INAI                                                                              MD058854
     C+  ,MINI                                                                              MD058854
     C+  ,DYSI                                                                              MD058854
     C+  ,FIXI                                                                              MD058854
     C+  ,MDBAQQ                                                                            MD058854
     C+  ,ACMAQQ                                                                            MD058854
     C+  ,DINAQQ                                                                            MD058854
     C+  ,INAAQQ                                                                            MD058854
     C+  ,MINAQQ                                                                            MD058854
     C+  ,DYSAQQ                                                                            MD058854
     C+  ,FIXAQQ                                                                            MD058854
     C+  ,TIMV                                                                              MD058854
     C+  ,ZZ007                                                                             MD058854
     C+  ,LCD                                                                               MD058854
     C+  ,CHTP                                                                              MD058854
     C+  ,TNLU                                                                              MD058854
     C+  ,MDBA                                                                              MD058854
     C+  ,ACMA                                                                              MD058854
     C+  ,DINA                                                                              MD058854
     C+  ,INAA                                                                              MD058854
     C+  ,MINA                                                                              MD058854
     C+  ,DYSA                                                                              MD058854
     C+  ,FIXA                                                                              MD058854
     C+  ,ZONE                                                                              MD058854
     C+  ,IUSR                                                                              MD058854
     C+  ,AUSR                                                                              MD058854
     C+  ,XUSR                                                                              MD058854
     C+  ,AACC                                                                              MD058854
     C+  ,EACC                                                                              MD058854
     C+  ,GPDT                                                                              MD058854
     C+  ,REMODE                                                                            MD058854
     C+ )                                                                                   MD058854
     C+ Values                                                                              MD058854
     C+ (                                                                                   MD058854
     C+   :RECI                                                                             MD058854
     C+  ,:RECT                                                                             MD058854
     C+  ,:ZZ010                                                                            MD058854
     C+  ,:GRPN                                                                             MD058854
     C+  ,:MDBI                                                                             MD058854
     C+  ,:ACMI                                                                             MD058854
     C+  ,:DINI                                                                             MD058854
     C+  ,:INAI                                                                             MD058854
     C+  ,:MINI                                                                             MD058854
     C+  ,:DYSI                                                                             MD058854
     C+  ,:FIXI                                                                             MD058854
     C+  ,:MDBA                                                                             MD058854
     C+  ,:ACMA                                                                             MD058854
     C+  ,:DINA                                                                             MD058854
     C+  ,:INAA                                                                             MD058854
     C+  ,:MINA                                                                             MD058854
     C+  ,:DYSA                                                                             MD058854
     C+  ,:FIXA                                                                             MD058854
     C+  ,:TIMV                                                                             MD058854
     C+  ,:ZZ007                                                                            MD058854
     C+  ,:LCD                                                                              MD058854
     C+  ,:CHTP                                                                             MD058854
     C+  ,:TNLU                                                                             MD058854
     C+  ,:MDBA                                                                             MD058854
     C+  ,:ACMA                                                                             MD058854
     C+  ,:DINA                                                                             MD058854
     C+  ,:INAA                                                                             MD058854
     C+  ,:MINA                                                                             MD058854
     C+  ,:DYSA                                                                             MD058854
     C+  ,:FIXA                                                                             MD058854
     C+  ,:ZONE                                                                             MD058854
     C+  ,:IUSR                                                                             MD058854
     C+  ,:AUSR                                                                             MD058854
     C+  ,:XUSR                                                                             MD058854
     C+  ,:AACC                                                                             MD058854
     C+  ,:EACC                                                                             MD058854
     C+  ,:GPDT                                                                             MD058854
     C+  ,'C'                                                                               MD058854
     C+ )                                                                                   MD058854
     C/END-EXEC                                                                             MD058854
     C/EXEC SQL                                                                             MD058854
     C+ insert into TABV4XTD                                                                MD058854
     C+ (                                                                                   MD058854
     C+   RECI                                                                              MD058854
     C+  ,RECT                                                                              MD058854
     C+  ,ZZ010                                                                             MD058854
     C+  ,GRPN                                                                              MD058854
     C+  ,MDBI                                                                              MD058854
     C+  ,ACMI                                                                              MD058854
     C+  ,DINI                                                                              MD058854
     C+  ,INAI                                                                              MD058854
     C+  ,MINI                                                                              MD058854
     C+  ,DYSI                                                                              MD058854
     C+  ,FIXI                                                                              MD058854
     C+  ,MDBAQQ                                                                            MD058854
     C+  ,ACMAQQ                                                                            MD058854
     C+  ,DINAQQ                                                                            MD058854
     C+  ,INAAQQ                                                                            MD058854
     C+  ,MINAQQ                                                                            MD058854
     C+  ,DYSAQQ                                                                            MD058854
     C+  ,FIXAQQ                                                                            MD058854
     C+  ,TIMV                                                                              MD058854
     C+  ,ZZ007                                                                             MD058854
     C+  ,LCD                                                                               MD058854
     C+  ,CHTP                                                                              MD058854
     C+  ,TNLU                                                                              MD058854
     C+  ,MDBA                                                                              MD058854
     C+  ,ACMA                                                                              MD058854
     C+  ,DINA                                                                              MD058854
     C+  ,INAA                                                                              MD058854
     C+  ,MINA                                                                              MD058854
     C+  ,DYSA                                                                              MD058854
     C+  ,FIXA                                                                              MD058854
     C+  ,ZONE                                                                              MD058854
     C+  ,IUSR                                                                              MD058854
     C+  ,AUSR                                                                              MD058854
     C+  ,XUSR                                                                              MD058854
     C+  ,AACC                                                                              MD058854
     C+  ,EACC                                                                              MD058854
     C+  ,GPDT                                                                              MD058854
     C+  ,REMODE                                                                            MD058854
     C+ )                                                                                   MD058854
     C+ Values                                                                              MD058854
     C+ (                                                                                   MD058854
     C+   :RECI                                                                             MD058854
     C+  ,:RECT                                                                             MD058854
     C+  ,:ZZ010                                                                            MD058854
     C+  ,:GRPN                                                                             MD058854
     C+  ,:MDBI                                                                             MD058854
     C+  ,:ACMI                                                                             MD058854
     C+  ,:DINI                                                                             MD058854
     C+  ,:INAI                                                                             MD058854
     C+  ,:MINI                                                                             MD058854
     C+  ,:DYSI                                                                             MD058854
     C+  ,:FIXI                                                                             MD058854
     C+  ,:MDBA                                                                             MD058854
     C+  ,:ACMA                                                                             MD058854
     C+  ,:DINA                                                                             MD058854
     C+  ,:INAA                                                                             MD058854
     C+  ,:MINA                                                                             MD058854
     C+  ,:DYSA                                                                             MD058854
     C+  ,:FIXA                                                                             MD058854
     C+  ,:TIMV                                                                             MD058854
     C+  ,:ZZ007                                                                            MD058854
     C+  ,:LCD                                                                              MD058854
     C+  ,:CHTP                                                                             MD058854
     C+  ,:TNLU                                                                             MD058854
     C+  ,:MDBA                                                                             MD058854
     C+  ,:ACMA                                                                             MD058854
     C+  ,:DINA                                                                             MD058854
     C+  ,:INAA                                                                             MD058854
     C+  ,:MINA                                                                             MD058854
     C+  ,:DYSA                                                                             MD058854
     C+  ,:FIXA                                                                             MD058854
     C+  ,:ZONE                                                                             MD058854
     C+  ,:IUSR                                                                             MD058854
     C+  ,:AUSR                                                                             MD058854
     C+  ,:XUSR                                                                             MD058854
     C+  ,:AACC                                                                             MD058854
     C+  ,:EACC                                                                             MD058854
     C+  ,:GPDT                                                                             MD058854
     C+  ,'C'                                                                               MD058854
     C+ )                                                                                   MD058854
     C/END-EXEC                                                                             MD058854
     C                   Endif                                                              MD058854
     C                   ENDIF
     C*
     C     CSD050        IFEQ      'Y'
     C                   EXSR      SRDTAQ
     C                   ENDIF
      *                                                                                       CSD031
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C*
     C**  UPDATE TABLE HEADER RECORD
     C*   ~~~~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C**  TO SET UP AND WRITE THE TABLE HEADER RECORD TABLETX
     C*
     C     UPDTHR        BEGSR
     C*
     C                   MOVEL     '81      '    KEY
     C                   MOVE      '    '        KEY
     C*
     C     CSD050        IFEQ      'N'
     C     CSD050        OREQ      'Y'
     C     *INU1         ANDEQ     *OFF
     C                   OPEN      TABLE3
     C     KEY           CHAIN     TABLE3                             59
     C*
     C     *IN59         IFEQ      '1'
     C                   MOVE      'TABLETX'     WBFILE                         ***************
     C                   MOVEL     KEY           WBKEY                          * DB ERROR 02 *
     C                   Z-ADD     2             WBASE                          ***************
     C                   EXSR      *PSSR
     C                   END
     C*
     C   48
     CANN49              ADD       1             NINS                           + 1 TO INSERTS
     C  N48
     CAN 49              ADD       1             NAMD                           + 1 TO AMENDS
     C*
     C                   UPDATE    TABLETXF
     C                   CLOSE     TABLE3
     C                   ENDIF
     C*
     C                   ENDSR
     C*
     C*-------------------------------------------------------------------
     C*
     C**  COMMIT ALL FILE UPDATES
     C*   ~~~~~~~~~~~~~~~~~~~~~~~
     C*
     C     COMMIT        BEGSR
     C*
     C                   MOVE      ACTCD         DSSAC
     C                   MOVE      SGRPC         DSSGC
     C                   MOVE      SGRPN         DSSGN
     C                   MOVE      SMDBI         DSSI1
     C                   MOVE      SMDBA         DSSA1
     C                   MOVE      SACMI         DSSI2
     C                   MOVE      SACMA         DSSA2
     C                   MOVE      SDINI         DSSI3
     C                   MOVE      SDINA         DSSA3
     C                   MOVE      SINAI         DSSI4
     C                   MOVE      SINAA         DSSA4
     C                   MOVE      SMINI         DSSI5
     C                   MOVE      SMINA         DSSA5
     C                   MOVE      SDYSI         DSSI6
     C                   MOVE      SDYSA         DSSA6
     C                   MOVE      SFIXI         DSSI7
     C                   MOVE      SFIXA         DSSA7
     C*
     C                   MOVE      *BLANKS       LOTSCN
     C                   MOVEL     DSSCN         LOTSCN
     C*
     C     CMTTXT        COMMIT
     C*
     C                   ENDSR
     C*
     C/EJECT
     C*-------------------------------------------------------------------
      *****************************************************************                       CSD031
      * SRMOVE - Move records to GPRECGL0 fields                      *                       CSD031
      *****************************************************************                       CSD031
     C     SRMOVE        BEGSR
      *                                                                                       CSD031
     C                   MOVE      'D'           GRECI
     C                   MOVE      '81'          GRECT
     C                   MOVE      SGRPC         GZZ010
     C                   MOVEL     SGRPN         GGRPN
      *                                                                                       CSD031
     C                   MOVE      SMDBI         GMDBI
     C                   MOVE      SACMI         GACMI
     C                   MOVE      SDINI         GDINI
     C                   MOVE      SINAI         GINAI
     C                   MOVE      SMINI         GMINI
     C                   MOVE      SDYSI         GDYSI
     C                   MOVE      SFIXI         GFIXI
      *                                                                                       CSD031
     C                   MOVE      SMDBA         GMDBA
     C                   MOVE      SACMA         GACMA
     C                   MOVE      SDINA         GDINA
     C                   MOVE      SINAA         GINAA
     C                   MOVE      SMINA         GMINA
     C                   MOVE      SDYSA         GDYSA
     C                   MOVE      SFIXA         GFIXA
      *                                                                                       CSD031
     C                   MOVE      LCD           GLCD
     C                   MOVE      TIMV          GTIMV
     C                   MOVE      CHTP          GCHTP
     C                   MOVE      TNLU          GTNLU
      *                                                                                       CSD031
     C                   MOVE      EACC          GEACC
     C                   MOVE      AACC          GAACC
     C                   MOVE      GPDT          GGPDT
      *                                                                                       CSD031
     C                   ENDSR
      *****************************************************************                       CSD031
      * SRACCP - Acceptance List screen                                                       CSD031
      *****************************************************************                       CSD031
     C     SRACCP        BEGSR
     C                   MOVE      'Y'           WF11              1
     C                   MOVE      'Y'           WF11              1
     C                   MOVE      'N'           WF12              1
     C                   Z-ADD     13            ##SFPG            3 0          SFLPAG
     C                   Z-ADD     1             ##SFRC
     C                   MOVE      'ACC'         WMODE             3
     C                   MOVEA     CMDT(1)       CMDMSG
     C                   MOVE      *OFF          *IN88
     C                   MOVE      *BLANKS       SERMSG
     C                   MOVE      *BLANKS       ERCD
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
     C                   MOVE      'Y'           WF12
      *                                                                                       CSD031
      ** Enable F12=For Acceptance                                                            CSD031
      *                                                                                       CSD031
     C                   MOVE      *OFF          *IN52
     C                   GOTO      SREXIT
     C                   ENDIF
      *                                                                                       CSD031
      ** Display next SFL page (27=ROLLUP key)                                                CSD031
      *                                                                                       CSD031
     C   27              CAS                     BBLDSF
      *                                                                                       CSD031
      ** Process screen input                                                                 CSD031
      *                                                                                       CSD031
     C                   CAS                     DBPRSF
     C                   ENDCS
      *                                                                                       CSD031
     C                   ENDDO                                                  OD W0RSF
     C                   ENDDO                                                  OD *HIVAL
      *                                                                                       CSD031
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
      *                                                                                       CSD031
      ** PUTOVR unless conditioned fields change                                              CSD031
      *                                                                                       CSD031
     C                   SETON                                        86
     C     *IN81         IFNE      CAIN81
     C                   SETOFF                                       86
     C                   END
     C                   MOVE      *IN81         CAIN81            1
      *                                                                                       CSD031
      ** Set cursor by *SET CURSOR data                                                       CSD031
      *                                                                                       CSD031
     C                   WRITE     #MSGCTL
     C                   WRITE     #CMDTXT1
     C                   EXFMT     #SFLCTL
     C     *INKL         IFEQ      *ON
     C                   MOVE      *OFF          *IN21
     C                   MOVE      *OFF          *IN22
     C                   MOVE      'Y'           WF12
     C                   MOVE      *OFF          *IN55
     C                   GOTO      CAEXIT
     C                   ENDIF
      *                                                                                       CSD031
      ** Maintain subfile position where possible                                             CSD031
      ** If help requested, display help text                                                 CSD031
      *                                                                                       CSD031
     C                   END
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
     C                   MOVEL     'Y'           ZAFSMS            1      99    *
     C                   MOVE      *OFF          *IN83
     C                   MOVE      *OFF          *IN92
      *                                                                                       CSD031
     CSR   CAEXIT        ENDSR
      *****************************************************************                       CSD031
      * ZXEXPG - Cancel and exit program                                                      CSD031
      *****************************************************************                       CSD031
     CSR   ZXEXPG        BEGSR
     C                   MOVE      'Y'           WF03              1
     C                   SETON                                        LR
     C                   RETURN
     CSR   ZXEXIT        ENDSR
      *****************************************************************                       CSD031
      * BBLDSF - Load subfile page                                                            CSD031
      *****************************************************************                       CSD031
     CSR   BBLDSF        BEGSR
     C   27              DO
     C**N82*****         READP     SDARCGR1                               90    *           MD058854
     C**N82*****         READ      SDARCGR1                               90    *           MD058854
     C                   END
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
     C                   END
     C     W0SPG         IFGT      ##SPG
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
     C                   ELSE
     C                   Z-ADD     W0SPG         ##SPG
     C                   END
      *                                                                                       CSD031
      ** Compute lines required based on pages                                                CSD031
      *                                                                                       CSD031
     C     ##SPG         MULT      ##SFPG        ##SFLN            9 0
     C     ##SFLN        IFGT      999
     C                   Z-ADD     999           ##SFLN
     C                   END
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
     C                   ADD       1             ##RROK               81        *
      *                                                                                       CSD031
      ** If SFLRCD invalid, note that errors present                                          CSD031
      *                                                                                       CSD031
     C   98
     CANN99              SETON                                        99        *
     C                   WRITE     #SFLRCD
     C     BB020         TAG
      *                                                                                       CSD031
      ** Increment scan check count                                                           CSD031
      *                                                                                       CSD031
     C                   ADD       1             ##RRRD
     C**********         READ      SDARCGR1                               82    *82=EOF     MD058854
     C                   END                                                    OD 1 - ##SFPG
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
     C                   END                                                    FI ##RR = *ZERO
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
     C                   END
     C                   ADD       1             ##SFRC
     C                   Z-ADD     ##RR          ##RRMX
     C                   END
     C                   Z-ADD     0             ##RROK
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
      ** Convert Effective Date to screen format                                              CSD031
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
     C******LOVAL        SETLL     SDARCGR1                                                 MD055854
     C**********         READ      SDARCGR1                             8782    *82=EOF     MD055854
      *                                                                                       CSD031
      ** Load subfile page                                                                    CSD031
      *                                                                                       CSD031
     C                   Z-ADD     0             ##RROK            5 0
      *                                                                                       CSD031
     C                   MOVE      *OFF          *IN55
      *                                                                                       CSD031
     C                   EXSR      BBLDSF
     CSR   BAEXIT        ENDSR
      *****************************************************************                       CSD031
      * ZASNMS - Send message to program message queue                                        CSD031
      *****************************************************************                       CSD031
     CSR   ZASNMS        BEGSR
     C     ZAPGMQ        IFEQ      *BLANK
     C                   MOVEL     ##PGM         ZAPGMQ
     C                   END
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message ID
     C                   PARM                    ZAMSGF           10            Message file
     C                   PARM                    ZAMSDA          132            Message data
     C                   PARM                    ZAMSTP            7            Message type
      * Clear all fields for default mechanism next time                                      CSD031
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
      *                                                                                       CSD031
     C                   READC     #SFLRCD                                60
     C     *IN60         DOWEQ     '0'
      *                                                                                       CSD031
     C     #1SEL         IFNE      ' '
     C     #1SEL         ANDNE     'D'
     C     #1SEL         ANDNE     'E'
     C     #1SEL         ANDNE     'X'
     C                   MOVE      *ON           *IN55
     C                   MOVEL     ERMSG(1)      SERMSG
     C                   SETON                                        9984
     C                   UPDATE    #SFLRCD
     C                   GOTO      END1
     C                   ENDIF
      *                                                                                       CSD031
     C     #1SEL         IFEQ      'D'
     C                   MOVE      #1GRPC        WKEY             10
     C*****WKEY*         CHAIN     SDARCGL0                           90                    MD058854
     C     *IN90         IFEQ      *OFF
     C**********         DELETE    SDARCGR0                                                 MD058854
     C                   EXSR      SRCOMT
     C                   ENDIF
     C                   MOVE      'Y'           W0RSF
     C                   ENDIF
      *                                                                                       CSD031
     C     #1SEL         IFEQ      'E'
     C                   MOVE      #1GRPC        WKEY             10
     C*****WKEY*         CHAIN     SDARCGR1                           90                    MD058854
     C     *IN90         IFEQ      *OFF
     C                   MOVE      *OFF          *IN80
     C                   EXSR      DETLS1
     C                   MOVE      *ON           *IN60
     C                   MOVE      'Y'           W0RSF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD031
     C     #1SEL         IFEQ      'X'
     C                   EXSR      SRSVAC
     C                   MOVE      'Y'           W0RSF
     C                   ENDIF
      *                                                                                       CSD031
      * Process subfile record                                                                CSD031
     C                   MOVE      #1SEL         W1SEL             1
     C                   MOVE      *OFF          *IN55
     C                   MOVE      *BLANK        #1SEL
     C                   MOVE      *BLANK        SERMSG
     C                   UPDATE    #SFLRCD
     C                   READC     #SFLRCD                                60
     C                   ENDDO
      *                                                                                       CSD031
     C     END1          ENDSR
     C*                                                                                       CSD031
      *================================================================                       CSD031
      /EJECT                                                                                  CSD031
      *================================================================                       CSD031
     CSR   SRDTAQ        BEGSR
      *                                                                                       CSD031
      ** Setup details and send message to data queue                                         CSD031
      *                                                                                       CSD031
     C                   MOVEL     'GPRECGPD'    WPFNAM
     C                   MOVEL     SGRPC         WKEYS
     C                   MOVEL     @1DBRC        WDATA
     C                   MOVEL     WDTQ          PDQMSG
     C     'SD'          CAT       'ACCPDTQ'     PDQNAM
      *                                                                                       CSD031
     C     *LOVAL        SETLL     GPZONEL0
     C                   READ      GPZONEL0                               90
     C     *IN90         DOWEQ     *OFF
     C********** ZOMSYS    CAT  PGMB      PGMNAM 16                                    CSD031 CSC043
     C     ZOMSYS        CAT       PGMB          PGMNAM           17
     C     ZOMSYS        CAT       'DPLIB'       PDQLIB
     C                   CALL      PGMNAM
     C                   PARM                    PDQNAM           10
     C                   PARM                    PDQLIB           10
     C                   PARM                    PDQMSG
     C                   READ      GPZONEL0                               90
     C                   ENDDO
     CSR                 ENDSR
      *================================================================                       CSD031
     C/EJECT                                                                                  CSD031
      *================================================================                       CSD031
     CSR   DETLS1        BEGSR
      *                                                                                       CSD031
     C                   MOVE      #1SEL         ACTCD
     C                   MOVE      #1GRPC        SGRPC
     C                   MOVEL     #1GRPN        SGRPN
     C                   SUBST     #1CHTP:1      ACTCD
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
     C     EACC          IFEQ      *ZERO
     C                   MOVE      *BLANKS       #2EACC
     C                   ELSE
     C                   CALL      'ZDATE2'
     C                   PARM                    EACC
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    DATEB
     C                   MOVE      ZDATE         #2EACC
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      'N'           WDETL             1
     C     WDETL         DOWEQ     'N'
     C                   EXFMT     SD2350F2
     C     *INKC         IFEQ      *ON
     C     *INKL         OREQ      *ON
     C                   MOVE      'Y'           WDETL
     C                   ENDIF
     C                   ENDDO
      *                                                                                       CSD031
     CSR                 ENDSR
      *================================================================                       CSD031
     C/EJECT                                                                                  CSD031
      *================================================================                       CSD031
     CSR   SRSVAC        BEGSR
      *                                                                                       CSD031
     C                   MOVEL     '81      '    KEY
     C                   MOVE      '    '        KEY
     C                   MOVE      #1GRPC        KEY
     C*****KEY**         CHAIN     TABLE2                             71                    MD058854
     C     *IN71         IFEQ      *OFF
     C                   MOVE      #1GRPC        ZZ010
     C                   MOVEL     #1GRPN        GRPN
      *                                                                                       CSD031
     C                   MOVE      'Y'           GPDT
     C                   MOVE      'Y'           AACC
     C                   Z-ADD     BJRDNB        EACC
      *                                                                                       CSD031
     C                   SUBST     #1CHTP:1      CHTP
     C**********         UPDATE    TABLEV4F                                                 MD058854
     C                   EXSR      SRCOMT
      *                                                                                       CSD031
     C                   ELSE
      *                                                                                       CSD031
     C                   MOVE      'NNNNNNN'     SSCOMI
     C                   MOVE      SSCOMI        DSCOMI
     C                   MOVE      *BLANKS       SSCOMA
     C                   MOVE      #1GRPC        ZZ010
     C                   MOVEL     #1GRPN        GRPN
      *                                                                                       CSD031
     C                   MOVE      'Y'           GPDT
     C                   MOVE      'Y'           AACC
     C                   Z-ADD     BJRDNB        EACC
      *                                                                                       CSD031
     C                   SUBST     #1CHTP:1      CHTP
     C**********         WRITE     TABLEV4F                                                 MD058854
     C                   EXSR      SRCOMT
     C                   ENDIF
      *                                                                                       CSD031
     C                   MOVE      #1GRPC        ZZ010
     C*****ZZ010         CHAIN     SDARCGL0                           72                    MD058854
     C     *IN72         IFEQ      *OFF
     C**********         DELETE    SDARCGR0                                                 MD058854
     C                   EXSR      SRCOMT
     C                   ENDIF
      *                                                                                       CSD031
     CSR                 ENDSR
      *================================================================                       CSD031
     C/EJECT                                                                                  CSD031
      *================================================================                       CSD031
     CSR   ZDATE1        BEGSR
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
     CSR                 ENDSR
      *================================================================                       CSD031
     C/EJECT                                                                                  CSD031
     C*-------------------------------------------------------------------                    CSD031
     C*                                                                                       CSD031
     CSR   SRCOMT        BEGSR
      *================================================================                       CSD031
      * COMMITMENT AND ROLLBACK                                                               CSD031
      *================================================================                       CSD031
      *                                                                                       CSD031
     C     *IN90         IFEQ      *ON
      * Error: ROLLBACK any DBF changes                                                       CSD031
     C                   ROLBK
     C                   ELSE
      * Otherwise COMMIT any DBF changes                                                      CSD031
     C                   COMMIT
     C                   END
     C                   MOVE      *OFF          *IN90
     CSR                 ENDSR
      *================================================================                       CSD031
     C/EJECT                                                                                  CSD031
      *================================================================                       CSD031
     C*                                                                                       CSD031
     C     SRRTTX        BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    MSGID             7
     C                   PARM                    MSGF             10
     C                   PARM      *BLANKS       MSGTXT           80
     C                   ENDSR
      *================================================================                       CSD031
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
** CMDT                                                                                       CSD031
D=Delete  E=Enquire  X=Accept  F3=Exit  F12=Previous                                          CSD031
