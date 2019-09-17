     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Daily Movements Extract')                           *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM035*-*GL*Daily*Movements*Extract***************************                       LUC109
      *  XX000035 - GL Daily Movements Extract                        *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109CC1          Date 12Sep19               *
      *  Prev Amend No. LUC109             Date 20Sep16               *
      *                 205623             Date 10May02               *
      *                 202763             Date 27Feb02               *
      *                 200569             Date 26Nov01               *
      *                 MUI006             Date 08Nov01               *
      *                 198407             Date 30Oct01               *
      *                 LUC010             Date 22Aug01               *
      *                 196749             Date 10Aug01               *
      *                 170598             Date 01Aug01               *
      *                 188302             Date 08Jan01               *
      *                 182092             Date 01Sep00               *
      *                 168973             Date 04Nov99               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 29Jun99               *
      *                 MMI043  CC0007     Date 21May99               *
      *                 MMI043             Date 12May99               *
      *                 MMI043             Date 04Dec98               *
      *                                                               *
      * --------------------------------------------------------------*
      *                                                               *
      *  LUC109CC1 - New York Amendments                              *
      *         - Add year-end reference date.                        *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  205623 - Wrong rounding if the algebric sum of the postings  *
      *           to a foreign in/ex account is zero. Fix is to check *
      *           for discrepancies even if no transfer postings have *
      *           been found.                                         *
      *  202763 - Wrong rounding in base currency conversion - remove *
      *           part of 170598.                                     *
      *  200569 - Reset fields C9811 and C9807 at each cycle.         *
      *  MUI006 - Participations Sold: report Loan Number of Original *
      *           Loan.                                               *
      *  198407 - Deal Number missing for TI and AA module            *
      *  LUC010 - Changes to Head Office Extracts                     *
      *  196749 - FIX TO 170598.                                      *
      *  170598 - Increase tolerance on rounding patch to 0,30;       *
      *           increase accuracy of currency conversions.          *
      *  188302 - Do not write to EODCLWK.  These records are no      *
      *           longer used and when copied into EODCLPD they cause *
      *           a large imbalance.                                  *
      *  182092 - For Parts Purchased and Parts Sold use Original     *
      *           Borrower for 'Associated Customer Number'.          *
      *  168973 - GIB extract file: total credit and debit amounts do *
      *           not match although the file balances.               *
      *  MMI043 - GIB extract file: total credit and debit movements  *
      *           do not match.                                       *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Move ASOC to FCNUM2 whenever ASOC fld is not blank. *
      *  MMI043 - CC0007/Change Control 7: extract OOB.               *
      *           Only exclude postings with 1767 if int. cap.        *
      *           Add Extension File processing                       *
      *           Change conditioning on SR/COM908                    *
      *           Emergency fix - Change conditioning from 'not       *
      *           cleared' to not 'future valued'.                    *
      *  MMI043 - Daily Movements Extract                             *
      *                                                               *
      *****************************************************************
      *
      * An attempt to clarify the processing of this program:
      * ----------------------------------------------------
      * (1)Records are read from the EODPOPL file (recs from EODPOPD
      *                                              and  EODCLPD)
      *  - EODCLPD is a clearing postings file. It is created in this
      *    program only. EODPOPD records are output to this file if
      *    the value date is greater than todays run date. ( This will
      *    happen at end of month if the following day(s) are non-
      *    working days).
      *
      * (2)If a posting record is an Income and Expense record:
      *
      *  - if not a transfer record
      *    output sub-record 1 (S210 cycle 1)
      *    output sub-record 2 (S220 cycle 1)
      *
      *  - if not a transfer record and not base currency
      *    output sub-record 1 (S225 cycle 1) with reversed amount
      *    output sub-record 2 (S226 cycle 1)
      *    This effectively outputs the transfer posting.
      *
      *  - if not a transfer record and not base currency
      *    output sub-record 1 (S210 cycle 2). The base ccy equivalent
      *       of the posting is accumulated for this Account, and
      *       compared with the total base ccy equivalent of the
      *       transfers for this Account, and any difference is
      *       used to update the last record output for this Account.
      *    output sub-record 2 (S220 cycle 2)
      *
      *  - Transfer records are not processed, other than to total
      *    the base currency equivalent of the postings to check
      *    for rounding differences.
      *
      * (3)If a posting record is NOT an Income and Expense record:
      *
      *  - output sub-record 1 (S230)
      *    output sub-record 2 (S240)
      *
      * (4)If a posting has a future Value Date:
      *
      *  - output the posting record to EODCLPD.
      *
      *  - if not a transfer record
      *    output sub-record 1 (S210 cycle 1)
      *    output sub-record 2 (S220 cycle 1)
      *
      * (5)If processing an EODCLPD posting record:
      *
      *  - if not a transfer record and not base currency
      *    output sub-record 1 (S225 cycle 1) with reversed amount
      *    output sub-record 2 (S226 cycle 1)
      *    This effectively outputs the transfer posting.
      *
      *  - if not a transfer record and not base currency
      *    output sub-record 1 (S210 cycle 2). The base ccy equivalent
      *       of the posting is accumulated for this Account, and
      *       compared with the total base ccy equivalent of the
      *       transfers for this Account, and any difference is
      *       used to update the last record output for this Account.
      *    output sub-record 2 (S220 cycle 2)
      *
      * (6)Transfer records are not processed, other than to total
      *    the base currency equivalent of the postings to check
      *    for rounding differences.
      *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDTIINPD  IF   E             DISK    INFSR(*PSSR)                         198407
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     FEODPOPL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(UREFDS)
     FSDACRCL9  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FACCOL     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCOLF)
     F****CLOANV4 IF  E           K        DISK         KINFSR *PSSR      CC0007
     FCLOANV5   IF   E           K DISK    INFSR(*PSSR)                         CC0007
     FCLOANV6   IF   E           K DISK    INFSR(*PSSR)                         CC0007
     FFCLTYMV0  IF   E           K DISK    INFSR(*PSSR)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     FSDPCACPD  IF   E           K DISK    INFSR(*PSSR)
     FREIAC     IF   E           K DISK
     FREINT     IF   E           K DISK
     FACCNTPO   UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FACCNTBL   UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*CCNTBL O   E                    DISK         KINFSR *PSSR      UC
     F*FEGIB   O   E                    DISK         KINFSR *PSSR
     FFEGIB     UF A E             DISK    INFSR(*PSSR)                         CHG001
     FSDACODV1  IF   E           K DISK    INFSR(*PSSR)                         CC0007
      *  Account Codes Extension File                                     CC0007
      *                                                                   CC0007
     F*ODCLWK*O***E                    DISK         KINFSR *PSSR A  CHG001188302
     F************EODCLP0                           KRENAMEEODCLP1        188302
      *                                                                   LUC010
     FFCLTYY0   IF   E           K DISK    INFSR(*PSSR)                         LUC010
      ** Facilities Extension File                                        LUC010
      *                                                                   LUC010
     F***GLM035AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000035AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   40 - PF/SDBRCHL1   File I/O                                 *
      *   41 - PF/EODPOPL    File I/O                                 *
      *   42 - PF/ACCNTPO    File I/O                                 *
      *   43 - PF/ACCNTPO    File I/O                                 *
      *   45 - REIAC Retrieval                                        *
      *   46 - REINT Retrieval                                        *
      *   50 - General I/O                                            *
      *                                                               *
      *   88      Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  S100 - Initial Processing                                    *
      *                                                               *
      *  S200 - Main Processing                                       *
      *         S210 - Income/Expense Sub-record 1                    *
      *         S220 - Income/Expense Sub-record 2                    *
      *         S225 - Income/Expense Sub record 1 for transfer       *
      *         S226 - Income/Expense Sub-record 2 for transfer       *
      *         S230 - Non Income/Expense Sub-record 1                *
      *         S240 - Non Income/Expense Sub-record 2                *
      *         S250 - Trailer                                        *
      *         S260 - Temporary file update                          *
      *                                                               *
      *  S300 - Program termination                                   *
      *                                                               *
      *  COM901 Common Routine/Initialisation                         *
      *  COM902 Common Routine/Date derivation                        *
      *  COM903 Common Routine/BSPL derivation                        *
      *  COM904 Common Routine/Currency conversion                    *
      *  COM905 Common Routine/Rate type derivation                   *
      *  COM906 Common Routine/Trailer output                         *
      *  COM907 Common Routine/Convert Midas Amount to 15(3).         *
      *  COM908 Common Routine/Future Value Date Processing           *
      *  COM909 Common Routine/Update ACCNTBL & ACCNTPO               *
      *  COM910 Common Routine/Check Difference                       *
      *  COM911 Common Routine/Accumulate rounding for Transfers.     *
      *                                                               *
      *  *PSSR  Abnormal termination                                  *
      *                                                               *
      *****************************************************************
      *
     D SVALKK          C                   CONST('HOR_NY_Amendments')                      LUC109CC1
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D***********         @ERR    1  12 35                                CC0007
     D @ERR            S             35    DIM(13) CTDATA PERRCD(1)                              CC0
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY
     D CLR             S             20    DIM(2) CTDATA PERRCD(1)              CLRPFM ACCNTPO/BL
      *
     D                 DS
     D  YYMD                   1      8  0
     D  YYYY                   1      4  0
     D  MM                     5      6  0
     D  DD                     7      8  0
      *
      ***File*information*for*printer*file*GLM035AU********************                       LUC109
      ** File information for printer file XX000035AU                                         LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      **
     D UREFDS          DS
     D  URFMT                261    270
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
     D DTLRC1          DS
     D  FPROG1                 1      3
     D  FPLIN1                 4      4
     D  FACCT1                 5      8  0
     D  FCCYC1                 9     11
     D  FPOSA1                12     30
     D  FOCCY1                31     33
     D  FOAMT1                34     52
     D  FSRCM1                53     55
     D  FDEAL1                56     70
     D  FILL03                71     78
     D  REFDT1                71     78                                                    LUC109CC1
      *
      ** Detail Record 2
      *
     D DTLRC2          DS
     D  FPROG2                 1      3
     D  FACCN2                 4     21
     D  FCNUM2                22     27  0
     D  FSDAT2                28     35
     D  FMDAT2                36     43
     D  FCSDT2                44     51
     D  FCMDT2                52     59
     D  FRTYP2                60     60
     D  FBSPL2                61     64  0
     D  C9811                 69     72                                         LUC010
     D  C9807                 73     73                                         LUC010
     D  FILL04                74     78                                         LUC010
     D************************************** 65  78 FILL04                LUC010
      *
      ** Trailer Record
      *
     D TRAILR          DS
     D  FCONT                  1      6  0
     D  FTOTCR                 7     25
     D  FTOTDR                26     44
     D  FILL05                45     78
      *
     D ACNUM           DS
     D  ABRCH                  1      3
     D  ACUST                  4      9  0
     D  ACCYC                 10     12
     D  AACOD                 13     16  0
     D  AACSQ                 17     18  0
      *
     D SVANUM          DS
     D  SVBRCA                 1      3
     D  SVCNUM                 4      9  0
     D  SVCCY                 10     12
     D  SVACOD                13     16  0
     D  SVACSQ                17     18  0
      *
     D BCNUM           DS
     D  BBRCH                  1      3
     D  BCUST                  4      9  0
     D  BCCYC                 10     12
     D  BACOD                 13     16  0
     D  BACSQ                 17     18  0
      *
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
      *
     D DLREF           DS
     D  @@MODL                 1      1
     D  @@TREF                 2      7
      *
     D PSTSRC          DS
     D  @@PFIX                 1      4
     D  @@DASH                 5      5
     D  @@SRC1                 5      7
     D  @@SRC2                 6      7
      *
     D OTTP            DS
     D  @@DTYP                 1      2
     D  @@OTTP                 3      7
      *
     D OTST            DS
     D  @@DLST                 1      2
     D  @@OTST                 3     10
      *
     D SPOS            DS
     D  @@SPOS                 1      2
     D  @@SRCP                 3      7
     D  @@SMOD                 6      7
     D  @@SPBN                 1      3                                         198407
      *
     D OTRF            DS
     D  @@OREF                 1      6
     D  @@OTRF                 7     15
      *                                                                   198407
     D PNAR            DS                                                       198407
     D  @@PNAR                 1     30                                         198407
     D  @@TIDN                 1     10                                         198407
      *
     D                 DS
     D  DMY                    1      6  0
     D  @@D                    1      2  0
     D  @@M                    3      4  0
     D  @@Y                    5      6  0
      *
     D                 DS
     D  YMD                    1      8  0
     D  @CC                    1      2  0
     D  @YY                    3      4  0
     D  @MM                    5      6  0
     D  @DD                    7      8  0
     D                 DS
     D  DSAC                   1     18
     D  DSAC1                  1      6  0
     D  DSAC2                  7      9
     D  DSAC3                 10     13  0
     D  DSAC4                 14     15  0
     D  DSAC5                 16     18
      *
     D                 DS
     D  DSREIN                 1     12
     D  DSREK1                 1      2  0
     D  DSREK2                 3      7  0
     D  DSREK3                 8     10
     D  DSREK4                11     12
     D                 DS                                                                  LUC109CC1
     D  BJMRDT                 1      7                                                    LUC109CC1
     D  BJMON                  3      5                                                    LUC109CC1
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
      ***/C*PY*ZSRSRC,ZDATE9Z1                                                                LUC109
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 LUC109
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 LUC109
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 LUC109
      **  Data Structure for AOSVALR0 string                                               LUC109CC1
     DSVAL1            DS           200                                                    LUC109CC1
     DSVAL11                   1      1                                                    LUC109CC1
     IDEALSDCF                                                                  S01158
     I              CCY                         CCYD                            S01158
     IDEALSDDF                                                                  S01158
     I              CCY                         CCYD                            S01158
     IDEALSDEF                                                                  S01158
     I              CCY                         CCYD                            S01158
     ICLOANCLF                                                                  S01158
     I              CCY                         CCYL                            S01158
     IACCNTABF                                                                  S01158
     I              CCY                         CCYA                            S01158
     IAPOSTPDF                                                                  S01158
     I              CNUM                        EOCNUM                          S01158
     IEODCLP0                                                                   S01158
     I              CNUM                        EOCNUM                          S01158
     IREIACDF
     I              CNUM                        CNUM$3
     I              BRCA                        BRCA$3
     I              ACSQ                        ACSQ$3
     I              ACOD                        ACOD$3
     I              CCY                         CCY$3
      *
      ***/C*PY*ZSRSRC,ZDATE9Z2                                                                LUC109
      ***/C*PY*ZSRSRC,ZDAT10Z1                                                                LUC109
      *
      *****************************************************************
      *
     C                   EXSR      S100                                         Housekeeping
      *
     C                   EXSR      S200                                         Main process
      *
     C                   EXSR      S300                                         Termination
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
     C     S100          BEGSR                                                  Initialisation
      *
      ** Data definition
      *
     C     *LIKE         DEFINE    RCDT          @@TYPE                         Transaction typ
     C     *LIKE         DEFINE    DLNO          @@DLNO                         Deal number
     C     *LIKE         DEFINE    VDAT          @@SDAT                         Start date
     C     *LIKE         DEFINE    MDAT          @@EDAT                         End date
     C*          *LIKE     DEFN PSTA      @@CRDT           Credit
     C*          *LIKE     DEFN PSTA      @@DBIT           Debit
     C     *LIKE         DEFINE    A6NBDP        @@BCDP                         Base ccy dp
     C     *LIKE         DEFINE    PODBIT        @@PTOT                         Postings total
     C     *LIKE         DEFINE    ACOD          WTPFGA
     C     *LIKE         DEFINE    ACOD          WTFNIC
     C     *LIKE         DEFINE    ACOD          WTFNAA
     C     *LIKE         DEFINE    ACOD          WTFMAC
     C     *LIKE         DEFINE    ACOD          EOACOD
     C     *LIKE         DEFINE    ATYP          EOATYP
     C     *LIKE         DEFINE    BRCA          EOBRCA
     C     *LIKE         DEFINE    ACSQ          EOACSQ
     C     *LIKE         DEFINE    DRIS          EODRIS
     C     *LIKE         DEFINE    CRIS          EOCRIS
     C     *LIKE         DEFINE    DRIB          EODRIB
     C     *LIKE         DEFINE    CRIB          EOCRIB
     C     *LIKE         DEFINE    CNUM          KRENUM
     C     *LIKE         DEFINE    CCY           KRECCY
     C     *LIKE         DEFINE    ACOD          KRECOD
     C     *LIKE         DEFINE    ACSQ          KRESQ
     C     *LIKE         DEFINE    BRCA          KREBRC
     C     *DTAARA       DEFINE    LDA           WLDA            256            Data area
      *
     C     @@KLEN        KLIST                                                  CLOAN key
     C                   KFLD                    @@DLNO                         Transaction ref
     C                   KFLD                    @@TYPE                         Transaction typ
      *
     C     @@KFCP        KLIST                                                  FCLTY key
     C*                    KFLD           CNUM             Customer
     C                   KFLD                    EOCNUM                         Customer
     C                   KFLD                    FACT                           Facility type
     C                   KFLD                    FCNO                           Facility no
     C*                    KFLD           RCTP             Record type
      *
     C     @@KFCL        KLIST                                                  FCLTY key
     C                   KFLD                    FCUS                           Customer
     C                   KFLD                    FTYP                           Facility type
     C                   KFLD                    FSEQ                           Facility no
     C*                    KFLD           RCTP             Record type
      *
     C     @@KACC        KLIST                                                  ACCNT key
     C                   KFLD                    ACUST                          Customer
     C                   KFLD                    ACCYC                          Currency code
     C                   KFLD                    AACOD                          Account code
     C                   KFLD                    AACSQ                          Account seq
     C                   KFLD                    ABRCH                          Branch code
      *
     C     @@KBAL        KLIST                                                  ACCNTPO
     C                   KFLD                    POBRCA                         Branch code
     C                   KFLD                    POCYCD                         Currency code
     C                   KFLD                    POCNUM                         Customer
     C                   KFLD                    POACOD                         Account code
     C                   KFLD                    POACSQ                         Account seq
      *
     C     @@KBLL        KLIST                                                  ACCNTBL
     C                   KFLD                    BLCNUM                         Branch code
     C                   KFLD                    BLCYCD                         Currency code
     C                   KFLD                    BLACOD                         Customer
     C                   KFLD                    BLACSQ                         Account code
     C                   KFLD                    BLBRCA                         Account seq
      *
     C     @@KBAC        KLIST                                                  ACCNT key
     C                   KFLD                    ACUST                          Customer
     C                   KFLD                    ACCYC                          Currency code
     C                   KFLD                    AACOD                          Account code
     C                   KFLD                    AACSQ                          Account seq
     C                   KFLD                    ABRCH                          Branch code
      *
     C     @@KPTR        KLIST                                                  File pointer
     C                   KFLD                    BBRCH                          Branch code
     C                   KFLD                    BCCYC                          Currency code
     C                   KFLD                    BCUST                          Customer
     C                   KFLD                    BACOD                          Account code
     C                   KFLD                    BACSQ                          Account seq
      *
     C     @@KBPL        KLIST
     C                   KFLD                    XXRSNO            1
     C                   KFLD                    XXACCD            4
     C                   KFLD                    XXDRCR            1
      *
     C     KREIAC        KLIST
     C                   KFLD                    KRENUM
     C                   KFLD                    KRECCY
     C                   KFLD                    KRECOD
     C                   KFLD                    KRESQ
     C                   KFLD                    KREBRC
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
      ** Open files
      *
     C                   CALL      'QCMDEXC'                                    CLRPFM
     C                   PARM                    CLR(1)
     C                   PARM      20            UCMDP            15 5
      *
     C                   OPEN      ACCNTPO
      *
     C                   CALL      'QCMDEXC'                                    CLRPFM
     C                   PARM                    CLR(2)
     C                   PARM      20            UCMDP
      *
     C                   OPEN      ACCNTBL
      *
      ** Initial housekeeping
      *
     C                   MOVE      '9'           XXRSNO                         Set number
     C                   MOVE      'A'           @@TYPE                         Transaction typ
     C                   Z-ADD     *ZEROS        @@BCYA           15 0          Base ccy amt
     C                   Z-ADD     *ZEROS        @@RAWA           15 0          Amount to formt
     C                   MOVE      *BLANKS       @@OAMT           19            Original amount
     C                   MOVE      *BLANKS       DBFILE                         Data base file
     C                   MOVE      *BLANKS       DBKEY                          Key
     C                   MOVE      *BLANKS       DBPGM                          Program
     C                   Z-ADD     *ZEROS        DBASE                          Number
     C                   Z-ADD     *ZEROS        IX                3 0          Index
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *BLANKS       @@OT              2            Original trans
      *
     C                   READ      SDBANKPD                               50    Bank details
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   READ      SDPCACPD                               50    Bank details
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(11)      REPMSG
     C                   EXSR      #ERR
     C                   ELSE
     C                   MOVE      FTPFGA        WTPFGA
     C                   MOVE      FTFNIC        WTFNIC
     C                   MOVE      FTFNAA        WTFNAA
     C                   MOVE      FTFMAC        WTFMAC
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               50    Bank Extension
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(4)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
      ** Determine branch used for bank/company code
      *
     C     BJSLCD        CHAIN     SDINTFPD                           50        Bank Extension
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     BJSLCD        REPKEY
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(5)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
      ** Determine Bank/company code for header
      *
     C     S9BRCH        CHAIN     SDBRCHL1                           50        Branch
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     S9BRCH        REPKEY
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(6)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               50    Gl ICD
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(7)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C     BJCYCD        CHAIN     SDCURRL0                           50
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ERRDET
     C                   MOVEL     BJCYCD        REPKEY
     C                   MOVEL     'S100 '       REPPRG
     C                   MOVEL     @ERR(8)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @@BCDP                         Base ccy dp
      *                                                                   198407
      * Read Midas/TI Interface ICD                                       198407
      *                                                                   198407
     C                   READ      SDTIINPD                               50                   19840
     C                   MOVE      TILRBN        LRBN              3                           19840
     C                   MOVE      TIURBN        URBN              3                           19840
      *
     C                   MOVE      *BLANKS       FILL01                         Data filler 1
     C                   MOVE      *BLANKS       FILL02                         Data filler 2
     C                   IF        NY_Amend <> 'Y'                                         LUC109CC1
     C                   MOVE      *BLANKS       FILL03                         Data filler 3
     C                   ENDIF                                                             LUC109CC1
     C                   MOVE      *BLANKS       FILL04                         Data filler 4
     C                   MOVE      *BLANKS       FILL05                         Data filler 5
      *
      ** Header fields
      *
     C                   MOVE      A8CMCD        FBKCD                          Company code
     C                   MOVE      BJSLCD        FGPCD                          System location
     C                   MOVEL     'FEGIB'       FEXFL                          File name
      *
     C                   MOVE      UDATE         @SYDT                          System date
      *
     C     @@YYT         IFGT      50                                           Year 2000
     C                   MOVE      '19'          @@YY
     C                   ELSE
     C                   MOVE      '20'          @@YY
     C                   ENDIF
      *
     C                   MOVE      DATST         FSYSD                          System date
      *
      ** Last Accounting Date
      *
     C                   MOVE      MLACT         FLACD                          Last working dy
     C*                    CALL 'GLM053'
     C*                    PARM           BKAPDT           Profit date
     C*                    PARM           FLACD            Last a/c date
     C*                    PARM *ZERO     WFLACD  80
     C*                    MOVE WFLACD    FLACD
      *
     C                   MOVE      MMDAT         FLWDM                          Last working dy
      *
      ** Next Working Day
      *
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD                         Next working dy
     C*                    PARM           FNWKD
     C                   PARM      *ZERO         WFNWKD            8 0
     C                   MOVE      WFNWKD        FNWKD
      *
      **  Write Header Record
      *
     C                   MOVE      '00'          DMRECC                         Record code
     C                   MOVE      HEADER        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Header record
     C                   Z-ADD     1             COUNT             6 0          Increment count
      *
     C                   Z-ADD     *ZERO         ERRCNT            6 0
      * Write Error Report Header
     C                   WRITE     ERRHDR
      * Find last day of month
      * ... get first day of next month and convert to day number
     C                   MOVE      MMDAT         YYMD
     C                   Z-ADD     01            DD
     C                   ADD       1             MM
     C     MM            IFGT      12
     C                   Z-ADD     1             MM
     C                   ADD       1             YYYY
     C                   ENDIF
     C                   MOVE      YYMD          ZZDTIN
     C                   EXSR      ZDAT10
     C                   Z-ADD     ZZMDNO        ZDAYNO
      * ... get previous day i.e. end of this month
     C     ZDAYNO        SUB       1             WENMTH            5 0
      *
      *                                                                                    LUC109CC1
      * Get previous year-end date in YYYYMMDD format                                      LUC109CC1
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C                   MOVE      *OFF          *IN98                                     LUC109CC1
     C                   Z-ADD     BJPEYD        ZDAYNO                                    LUC109CC1
     C                   EXSR      ZDATE2                                                  LUC109CC1
     C                   Z-ADD     ZDATE         DMY                                       LUC109CC1
     C                   Z-ADD     @@D           @DD                                       LUC109CC1
     C                   Z-ADD     @@M           @MM                                       LUC109CC1
     C                   Z-ADD     @@Y           @YY                                       LUC109CC1
     C                   MOVE      '20'          @CC                                       LUC109CC1
     C                   MOVE      YMD           PRVYRE            8                       LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S200   -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S210                                                  *
      *                                                               *
      *****************************************************************
      *
     C     S200          BEGSR
      *
      ** Read all Branches
      *
     C     *LOVAL        SETLL     SDBRCHL1                                     Set pointer
     C                   READ      SDBRCHL1                               40    Primary read
      *
     C     *IN40         DOWEQ     *OFF                                         Until eof
      *
     C                   MOVE      A8BRCD        FBRCD                          Branch code
      *
      ** Write Branch Header Record
      *
     C                   MOVE      '02'          DMRECC                         Record code
     C                   MOVE      BRCHHD        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Branch header
     C                   ADD       1             COUNT                          Increment count
      *
      ** Generate Detail Records
      *
     C     FBRCD         SETLL     EODPOPL                                      Set pointer
     C     FBRCD         READE     EODPOPL                                41    Primary read
     C                   MOVE      CCY           EOCCY             3
      * Save Account details                                              CHG001
     C                   MOVE      BRCA          SVBRCA                                        CHG00
     C*                    MOVE CNUM      SVCNUM                          CHG001
     C                   MOVE      EOCNUM        SVCNUM                                        CHG00
     C                   MOVE      CCY           SVCCY                                         CHG00
     C                   MOVE      ACOD          SVACOD                                        CHG00
     C                   MOVE      ACSQ          SVACSQ                                        CHG00
     C                   Z-ADD     *ZERO         @@@TTL           15 0                         CHG00
     C                   Z-ADD     *ZERO         @@@BTT           15 0                         CHG00
      *
     C     *IN41         DOWEQ     *OFF                                         Until eof
      *                                                                   200569
     C                   RESET                   C9811                                         20056
     C                   RESET                   C9807                                         20056
      *
     C                   EXSR      COM908                                       Future VDAT /Ex
      *
     C                   EXSR      COM910                                       Check Differenc
      *
     C                   EXSR      COM901                                       Check if Inc/Ex
      *
     C     @@SKIP        IFEQ      'N'                                          Ignore posting
      *
      * For Parts Purchaced and Parts Sold use Facility Customer as         182092
      * associated customer number                                          182092
      *                                                                     182092
     C     @@SMOD        IFEQ      'LE'                                         Lending          182
      *                                                                     182092
     C                   MOVE      @@TREF        @@DLNO                         Deal number      182
      *                                                                     182092
     C     @@KLEN        CHAIN     CLOANV5                            50        Get record       182
      *                                                                     182092
      *  If record not on live loans file, check matured loans file         182092
      *                                                                     182092
     C     *IN50         IFEQ      *ON                                                           182
     C                   MOVE      *OFF          *IN50                                           182
     C     @@KLEN        CHAIN     CLOANV6                            50        Get record       182
     C                   ENDIF                                                                   182
      *                                                                     182092
     C     *IN50         IFEQ      *OFF                                         Found            182
      *                                                                     182092
     C     PTYP          IFEQ      64                                                            182
     C     PTYP          OREQ      65                                                            182
     C     PTYP          OREQ      66                                                            182
     C     PTYP          OREQ      67                                                            182
     C                   Z-ADD     FCUS          @@FCUS            6 0          Facility Customer182
     C                   ENDIF                                                                   182
      *                                                                     182092
     C                   ENDIF                                                                   182
      *                                                                     182092
     C                   ENDIF                                                                   182
      *                                                                     182092
      *                                                                     182092
      *                                                                     182092
     C     FPLIN1        IFEQ      'Y'                                          Inc/Exp
      *
     C     1             DO        2             @@CYCL                         Two cycles
     C                   EXSR      S210                                         Record 1
     C                   EXSR      S220                                         Record 2
     C                   EXSR      S225                                         Record 1 xfr
     C                   EXSR      S226                                         Record 2 xfr
     C                   ENDDO     1                                            Increment cycle
      *
     C                   ELSE
      *
     C                   EXSR      S230                                         Record 1
     C                   EXSR      S240                                         Record 2
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     FBRCD         READE     EODPOPL                                41    Get next record
     C                   MOVE      CCY           EOCCY             3
      *
     C                   ENDDO
      *
     C                   EXSR      COM910                                       Check Differenc
      *
      ** Write Branch Trailer Record
      *
     C                   MOVE      '09'          DMRECC                         Record code
     C                   MOVE      *BLANKS       DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Branch trailer
     C                   ADD       1             COUNT                          Increment count
      *
     C                   READ      SDBRCHL1                               40    Get next
      *
     C                   ENDDO
      *
     C                   EXSR      S250                                         Trailer
     C                   EXSR      S260                                         Balances
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S210  -  Generate Detail Record 1 for income/expense         *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     S210          BEGSR
      *
     C                   SELECT
      *
      * Cycle 1
      * -------
     C     @@CYCL        WHENEQ    1                                            First cycle
      *
     C                   MOVE      '05'          DMRECC                         Record code
     C                   MOVE      '001'         FPROG1                         Detail rec 1
     C                   Z-ADD     ACOD          FACCT1                         Account type
     C                   MOVE      CCY           FCCYC1                         Currency code
      *
     C     DRCR          IFEQ      *ZERO
     C                   Z-SUB     PSTA          @@RAWA                         Debit postings
     C                   ELSE
     C                   Z-ADD     PSTA          @@RAWA                         Credit postings
     C                   ENDIF
      *
     C**********         CALL      'GLM041'                                     Format amount LUC109
     C                   CALL      'XX000041'                                   Format amount LUC109
     C                   PARM                    CCY                            Currency code
     C                   PARM                    @@RAWA                         Raw amount
     C                   PARM                    FPOSA1                         Formatted amt
     C                   PARM                    @@EROR            1            Error indicator
      *
     C     @@EROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S210'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     @@RAWA        REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       FPOSA1
     C                   ENDIF
      *
     C***********@@CLPD    IFNE 'Y'                        Not EODCLPD recCC0007
     C     @@FUTR        IFNE      'Y'                                          Not Future VALDCC000
      *                                                                   168973
     C     EOCCY         IFNE      BJCYCD                                                      16897
     C                   Z-ADD     A6NBDP        ZCDP7             1 0                         CHG00
     C                   ELSE                                                                  16897
     C                   Z-ADD     @@BCDP        ZCDP7                                         16897
     C                   ENDIF                                                                 16897
      *                                                                   168973
     C                   Z-ADD     PSTA          ZAMTI7           15 0                         CHG00
     C                   EXSR      COM907
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       ZAMTO7        @@DBIT           18 0          Debit postings
     C                   ELSE
     C                   ADD       ZAMTO7        @@CRDT           18 0          Credit postings
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     FPOSA1        @@OAMT                         Original amount
      *
     C                   MOVE      *BLANKS       FOCCY1                         Orig ccy code
     C                   MOVE      *BLANKS       FOAMT1                         Orig ccy amt
     C                   MOVEL(P)  @@SMOD        FSRCM1                         Source module
      *
     C                   SELECT
      *
     C     @@SMOD        WHENEQ    'DL'                                         Dealing
     C     @@SMOD        OREQ      'LE'                                         Lending
     C                   MOVEL(P)  @@TREF        FDEAL1                         Deal number
      *
     C     @@SMOD        WHENEQ    'FT'                                         Funds tfr
     C     @@SMOD        OREQ      'ST'                                         Securities
     C     @@SMOD        OREQ      'AA'                                         Amount Accrual 19840
     C                   MOVEL(P)  OTRF          FDEAL1                         Deal number
     C                   MOVEL     OTRF          @@DLNO                         Deal number
      *
     C     @@DLNO        IFEQ      *ZEROS                                       Book position
     C                   MOVE      *BLANKS       FDEAL1                         Deal number
     C                   ENDIF
      *
     C     GETP          WHENEQ    *BLANKS                                      Journ. Entries 19840
     C     @@SPBN        ANDGE     LRBN                                                        19840
     C     @@SPBN        ANDLE     URBN                                                        19840
     C                   MOVEL(P)  @@TIDN        FDEAL1                                        19840
     C                   MOVEL(P)  'TI'          FSRCM1                         Source module  19840
      *
     C                   OTHER                                                  Otherwise
     C                   MOVE      *BLANKS       FDEAL1                         Deal number
      *
     C                   ENDSL
      *                                                                   MUI006
      * For Parts Sold, use Original Loan Number as Loan Number           MUI006
      * (Loan details already accessed in S200 routine)                   MUI006
      *                                                                   MUI006
     C     @@SMOD        IFEQ      'LE'                                                        MUI00
     C     PTYP          IFEQ      66                                                          MUI00
     C     PTYP          OREQ      67                                                          MUI00
     C                   MOVEL(P)  OLNO          FDEAL1                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                                    LUC109CC1
      * Set Reference Date                                                                 LUC109CC1
      *                                                                                    LUC109CC1
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C                   MOVE      *BLANKS       REFDT1                                    LUC109CC1
     C     VALD          IFLE      BJPEYD                                                  LUC109CC1
     C     BJMON         ANDEQ     'JAN'                                                   LUC109CC1
     C                   MOVE      PRVYRE        REFDT1                                    LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *
     C                   MOVE      DTLRC1        DMDATA                         Variable data
     C***********@@CLPD    IFNE 'Y'                        Not EODCLPD rec
     C     @@FUTR        IFNE      'Y'                                          Not Future VALD
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
     C                   ENDIF
      *
      * Cycle 2
      * -------
     C     @@CYCL        WHENEQ    2                                            Second cycle
     C     GETP          ANDNE     'X'
     C     EOCCY         ANDNE     BJCYCD
     C     @@FUTR        ANDNE     'Y'                                          Not Future VDAT
      *
     C                   MOVEL     CCY           FOCCY1                         Orig ccy code
     C                   MOVE      @@OAMT        FOAMT1                         Original amount
     C                   MOVE      BJCYCD        FCCYC1                         Currency code
      *
     C     DRCR          IFEQ      *ZERO
     C                   Z-SUB     @@BCYA        @@RAWA                         Debit postings
     C                   ELSE
     C                   Z-ADD     @@BCYA        @@RAWA                         Credit postings
     C                   ENDIF
      *
     C**********         CALL      'GLM041'                                     Format amount LUC109
     C                   CALL      'XX000041'                                   Format amount LUC109
     C                   PARM                    BJCYCD                         Currency code
     C                   PARM                    @@RAWA                         Raw amount
     C                   PARM                    FPOSA1                         Formatted amt
     C                   PARM                    @@EROR            1            Error indicator
      *
     C     @@EROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S210'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      BJCYCD        REPCCY
     C                   Z-ADD     @@RAWA        REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       FPOSA1
     C                   ENDIF
      *
     C                   Z-ADD     @@BCDP        ZCDP7             1 0                         CHG00
     C                   Z-ADD     @@BCYA        ZAMTI7           15 0                         CHG00
     C                   EXSR      COM907
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       ZAMTO7        @@DBIT                         Debit postings
     C                   ELSE
     C                   ADD       ZAMTO7        @@CRDT                         Credit postings
     C                   ENDIF
      *                                                                   CHG001
      * Accumulate Base Currency Equivalent for the account               CHG001
      * in order to determine whether rounding differnces occur           CHG001
      * and save details of the posting in case correction required       CHG001
     C                   ADD       @@RAWA        @@@TTL           15 0                         CHG00
     C                   Z-ADD     @@RAWA        @@@AMT           15 0                         CHG00
     C     COUNT         ADD       1             @@@REC            6 0                         CHG00
     C***********          MOVE DRCR      @@@DC   10                      CHG001
      *
     C                   MOVE      DTLRC1        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
      *
     C                   EXSR      COM909
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S220  -  Generate Detail Record 2 for income/expense         *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     S220          BEGSR
      *
     C                   MOVE      '05'          DMRECC                         Record code
      *
      * Cycle 1
      * -------
     C     @@CYCL        IFEQ      1                                            First cycle
      *
     C                   MOVE      '002'         FPROG2                         Detail rec 2
     C                   MOVEL     ACNUM         FACCN2                         Account number
      *
     C     DBCNUM        IFEQ      *ZEROS                                       Dealt borrower
     C                   Z-ADD     EOCNUM        FCNUM2                         Customer number
     C                   ELSE
     C                   Z-ADD     DBCNUM        FCNUM2                         Borrower
     C                   ENDIF
     C***********SPOS      IFEQ '  GE-IC'                                 MMI043
     C***********SPOS      OREQ ' GE-IER'                                 MMI043
     C***********ASOC      ANDNE*ZERO                                     MMI043
     C     ASOC          IFNE      *ZERO                                                       MMI04
      *
      * If Parts Purchaced or Parts Sold and Module is Lending then move    182092
      * Facility Customer into customer number.                             182092
     C     @@SMOD        IFEQ      'LE'                                                          182
      *                                                                     182092
     C     PTYP          IFEQ      64                                                            182
     C     PTYP          OREQ      65                                                            182
     C     PTYP          OREQ      66                                                            182
     C     PTYP          OREQ      67                                                            182
     C                   Z-ADD     @@FCUS        FCNUM2                                          182
     C                   ELSE                                                                    182
     C                   Z-ADD     ASOC          FCNUM2
     C                   ENDIF                                                                   182
      *                                                                     182092
     C                   ELSE                                                                    182
     C                   Z-ADD     ASOC          FCNUM2                                          182
     C                   ENDIF                                                                   182
      *
     C                   ENDIF
      *
     C                   EXSR      COM902                                       Get dates
     C                   EXSR      COM905                                       Rate type
     C                   EXSR      COM903                                       Get BSPL
      *
     C                   MOVE      DTLRC2        DMDATA                         Variable data
     C***********@@CLPD    IFNE 'Y'                        Not EODCLPD rec
     C     @@FUTR        IFNE      'Y'                                          Not Future VALD
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Cycle 2
      * -------
     C     @@CYCL        IFEQ      2                                            2ND cycle
     C     GETP          ANDNE     'X'
     C     EOCCY         ANDNE     BJCYCD
     C     @@FUTR        ANDNE     'Y'                                          Not Future VDAT
      *
     C                   MOVEL     BJCYCD        ACCYC                          BASE CCY    er
     C                   MOVEL     ACNUM         FACCN2                         Account number
      *
     C                   MOVE      DTLRC2        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S225  -  Generate Detail Record 1 for income/expense         *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     S225          BEGSR
      *
      * Cycle 1
      * -------
      *
      * Write extra posting record instead of the transfer record
      * with reversed amount if non base currency.
      *
     C     @@CYCL        IFEQ      1                                            First cycle
     C     CCY           ANDNE     BJCYCD
     C     @@FUTR        ANDNE     'Y'                                          Not Future VDAT
      *
     C     DRCR          IFEQ      *ZERO
     C                   Z-ADD     PSTA          @@RAWA                         Debit postings
     C                   ELSE
     C                   Z-SUB     PSTA          @@RAWA                         Credit postings
     C                   ENDIF
      *
     C**********         CALL      'GLM041'                                     Format amount LUC109
     C                   CALL      'XX000041'                                   Format amount LUC109
     C                   PARM                    CCY                            Currency code
     C                   PARM                    @@RAWA                         Raw amount
     C                   PARM                    FPOSA1                         Formatted amt
     C                   PARM                    @@EROR            1            Error indicator
      *
     C     @@EROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S210'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     @@RAWA        REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       FPOSA1
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZCDP7             1 0                         CHG00
     C                   Z-ADD     PSTA          ZAMTI7           15 0                         CHG00
     C                   EXSR      COM907
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       ZAMTO7        @@CRDT           18 0          Debit postings
     C                   ELSE
     C                   ADD       ZAMTO7        @@DBIT           18 0          Credit postings
     C                   ENDIF
      *
     C                   MOVE      DTLRC1        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
      *
      * Accumulate hash totals and accumulate for rounding
     C*          CCY       CHAINSDCURRL0             50                   CHG001
     C*          *IN50     IFEQ *ON                                       CHG001
     C*                    CLEAR@A6REA4
     C*                    CLEARERRDET
     C*                    MOVELBJCYCD    REPKEY
     C*                    MOVEL'S225  '  REPPRG
     C*                    MOVEL@ERR,8    REPMSG
     C*                    EXSR #ERR
     C*                    ENDIF                                          CHG001
      *
     C*                    Z-ADDA6NBDP    ZCDP7   10                      CHG001
     C*                    Z-ADDPSTA      ZAMTI7 150                      CHG001
     C*                    EXSR COM907
     C*          DRCR      IFEQ *ZERO                      Debit
     C*                    ADD  ZAMTO7    @@CRDT           Creditpostings
     C*                    ELSE
     C*                    ADD  ZAMTO7    @@DBIT           Debit  postings
     C*                    ENDIF
      *                                                                   CHG001
     C*                    MOVE CCY       ZCCYI   3                       CHG001
     C*                    MOVE BJCYCD    ZCCYO   3                       CHG001
     C*                    Z-ADDA6NBDP    ZCDPI   10                      CHG001
     C*                    Z-ADD@@BCDP    ZCDPO   10                      CHG001
     C*                    Z-ADDA6SPRT    ZEXCH  138                      CHG001
     C*                    MOVE A6MDIN    ZMD     1                       CHG001
     C*                    Z-ADDPSTA      ZAMTCI 150                      CHG001
     C*                    Z-ADD*ZEROS    ZAMTCO 150                      CHG001
      *                                                                   CHG001
     C*                    EXSR COM904                     Base ccy equiv CHG001
      *                                                                   CHG001
     C*          DRCR      IFEQ *ZERO                                     CHG001
     C*                    Z-SUBZAMTCO    @@@BCT 150                      CHG001
     C*                    ELSE                                           CHG001
     C*                    Z-ADDZAMTCO    @@@BCT                          CHG001
     C*                    ENDIF                                          CHG001
     C*                    ADD  @@@BCT    @@@BTT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S226  -  Generate Detail Record 2 for income/expense         *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     S226          BEGSR
      *
      * Cycle 1
      * -------
      *
      * Write extra posting record instead of the transfer record
      *
     C     @@CYCL        IFEQ      1                                            First cycle
     C     EOCCY         ANDNE     BJCYCD                                       Not Base Ccy
     C     @@FUTR        ANDNE     'Y'                                          Not Future VDAT
      *
     C                   MOVE      DTLRC2        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S230  -  Generate Detail Record 1 for non income/expense     *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     S230          BEGSR
      *
     C     @@FUTR        IFNE      'Y'                                                          CC00
      *                                                                    CC000
     C                   MOVE      '05'          DMRECC                         Record code
     C                   MOVE      '001'         FPROG1                         Detail rec 1
     C                   Z-ADD     ACOD          FACCT1                         Account type
     C                   MOVE      CCY           FCCYC1                         Currency code
      *
     C     DRCR          IFEQ      *ZERO
     C                   Z-SUB     PSTA          @@RAWA                         Debit postings
     C                   ELSE
     C                   Z-ADD     PSTA          @@RAWA                         Credit postings
     C                   ENDIF
      *
     C**********         CALL      'GLM041'                                     Format amount LUC109
     C                   CALL      'XX000041'                                   Format amount LUC109
     C                   PARM                    CCY                            Currency code
     C                   PARM                    @@RAWA                         Raw amount
     C                   PARM                    FPOSA1                         Formatted amt
     C                   PARM                    @@EROR            1            Error indicator
      *
     C     @@EROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S230'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     @@RAWA        REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       FPOSA1
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       FOCCY1                         Orig ccy code
     C                   MOVE      *BLANKS       FOAMT1                         Orig ccy amt
     C                   MOVEL(P)  @@SMOD        FSRCM1                         Source module
      *
     C     SPOS          IFEQ      '  GE-XF'                                    Defaults
     C     SPOS          OREQ      '  GE-SR'                                    Defaults
     C     SPOS          OREQ      '  GE-FR'                                    Defaults
     C     SPOS          OREQ      '  GE-XB'                                    Defaults
     C     SPOS          OREQ      *BLANKS                                      Defaults
     C                   MOVEL(P)  'GL'          FSRCM1                         Source module
     C                   ENDIF
      *
     C     SPOS          IFEQ      '  GE-IC'                                    Defaults
     C     SPOS          OREQ      ' GE-IER'                                    Defaults
     C                   MOVEL(P)  'RE'          FSRCM1                         Source module
     C                   ENDIF
      *
     C                   SELECT
      *
     C     @@SMOD        WHENEQ    'DL'                                         Dealing
     C     @@SMOD        OREQ      'LE'                                         Lending
     C                   MOVEL(P)  @@TREF        FDEAL1                         Deal number
      *
     C     @@SMOD        WHENEQ    'FT'                                         Funds tfr
     C     @@SMOD        OREQ      'ST'                                         Securities
     C     @@SMOD        OREQ      'AA'                                         Amount Accrual 19840
     C                   MOVEL(P)  OTRF          FDEAL1                         Deal number
     C                   MOVEL     OTRF          @@DLNO                         Deal number
      *
     C     @@DLNO        IFEQ      *ZEROS                                       Book position
     C                   MOVE      *BLANKS       FDEAL1                         Deal number
     C                   ENDIF
      *
     C     GETP          WHENEQ    *BLANKS                                      Journ. Entries 19840
     C     @@SPBN        ANDGE     LRBN                                                        19840
     C     @@SPBN        ANDLE     URBN                                                        19840
     C                   MOVEL(P)  @@TIDN        FDEAL1                                        19840
     C                   MOVEL(P)  'TI'          FSRCM1                         Source module  19840
      *
     C                   OTHER                                                  Otherwise
     C                   MOVE      *BLANKS       FDEAL1                         Deal number
      *
     C                   ENDSL
      *                                                                   MUI006
      * For Parts Sold, use Original Loan Number as Loan Number           MUI006
      * (Loan details already accessed in S200 routine)                   MUI006
      *                                                                   MUI006
     C     @@SMOD        IFEQ      'LE'                                                        MUI00
     C     PTYP          IFEQ      66                                                          MUI00
     C     PTYP          OREQ      67                                                          MUI00
     C                   MOVEL(P)  OLNO          FDEAL1                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   ENDIF                                                                 MUI00
      *
     C     EOCCY         IFNE      BJCYCD
     C                   Z-ADD     A6NBDP        ZCDP7             1 0                         CHG00
     C                   ELSE
     C                   Z-ADD     @@BCDP        ZCDP7
     C                   ENDIF
     C                   Z-ADD     PSTA          ZAMTI7           15 0                         CHG00
     C                   EXSR      COM907
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       ZAMTO7        @@DBIT                         Debit postings
     C                   ELSE
     C                   ADD       ZAMTO7        @@CRDT                         Credit postings
     C                   ENDIF
     C*          DRCR      IFEQ *ZERO                      Debit
     C*                    ADD  PSTA      @@DBIT           Debit postings
     C*                    ELSE
     C*                    ADD  PSTA      @@CRDT           Credit postings
     C*                    ENDIF
      *                                                                                    LUC109CC1
      * Set Reference Date                                                                 LUC109CC1
      *                                                                                    LUC109CC1
     C                   IF        NY_Amend = 'Y'                                          LUC109CC1
     C                   MOVE      *BLANKS       REFDT1                                    LUC109CC1
     C     VALD          IFLE      BJPEYD                                                  LUC109CC1
     C     BJMON         ANDEQ     'JAN'                                                   LUC109CC1
     C                   MOVE      PRVYRE        REFDT1                                    LUC109CC1
     C                   ENDIF                                                             LUC109CC1
     C                   ENDIF                                                             LUC109CC1
      *
     C                   MOVE      DTLRC1        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
      *
     C                   ENDIF                                                                  CC00
      *                                                                    CC000
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S240  -  Generate Detail Record 2 for non income/expense     *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     S240          BEGSR
      *
     C     @@FUTR        IFNE      'Y'                                                          CC00
      *                                                                    CC000
     C                   MOVE      '05'          DMRECC                         Record code
     C                   MOVE      '002'         FPROG2                         Detail rec 2
     C                   MOVEL     ACNUM         FACCN2                         Account number
     C***                  Z-ADDCNUM      FCNUM2           Customer number
     C                   Z-ADD     EOCNUM        FCNUM2                         Customer number
     C***********SPOS      IFEQ '  GE-IC'                                 MMI043
     C***********SPOS      OREQ ' GE-IER'                                 MMI043
     C***********ASOC      ANDNE*ZERO                                     MMI043
     C     ASOC          IFNE      *ZERO                                                       MMI04
      *
      * If Parts Purchaced or Parts Sold and Module is Lending then move    182092
      * Facility Customer into customer number.                             182092
     C     @@SMOD        IFEQ      'LE'                                                          182
      *                                                                     182092
     C     PTYP          IFEQ      64                                                            182
     C     PTYP          OREQ      65                                                            182
     C     PTYP          OREQ      66                                                            182
     C     PTYP          OREQ      67                                                            182
     C                   Z-ADD     @@FCUS        FCNUM2                                          182
     C                   ELSE                                                                    182
     C                   Z-ADD     ASOC          FCNUM2
     C                   ENDIF                                                                   182
      *                                                                     182092
     C                   ELSE                                                                    182
     C                   Z-ADD     ASOC          FCNUM2                                          182
     C                   ENDIF                                                                   182
      *                                                                     182092
     C                   ENDIF
      *
     C                   EXSR      COM902                                       Get dates
     C                   EXSR      COM905                                       Rate type
     C                   EXSR      COM903                                       Get BSPL
      *
     C                   MOVE      DTLRC2        DMDATA                         Variable data
     C                   WRITE     FEGIBF                                       Detail record 1
     C                   ADD       1             COUNT                          Increment count
      *
     C                   ENDIF                                                                  CC00
      *                                                                    CC000
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S250  Generate trailer record                                *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     S250          BEGSR
      *
      ** Write Trailer Record
      *
     C                   ADD       1             COUNT
     C                   Z-ADD     COUNT         FCONT
      *
     C                   Z-ADD     @@CRDT        @@RAWB                         Total credit
      *
     C**********         CALL      'GLM041A'                                    Format amount LUC109
     C                   CALL      'XX00041A'                                   Format amount LUC109
     C                   PARM      *BLANKS       BJCYCD                         Currency code
     C                   PARM                    @@RAWB                         Raw amount
     C                   PARM                    FTOTCR                         Formatted amt
     C                   PARM                    @@EROR            1            Error indicator
     C                   PARM      3             @@DECP            1 0          Decimal Places
      *
     C     @@EROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S250'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      BJCYCD        REPCCY
     C                   Z-ADD     @@RAWB        REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       FTOTCR
     C                   ENDIF
      *
     C                   Z-SUB     @@DBIT        @@RAWB           18 0          Total debit
      *
     C**********         CALL      'GLM041A'                                    Format amount LUC109
     C                   CALL      'XX00041A'                                   Format amount LUC109
     C                   PARM      *BLANKS       BJCYCD                         Currency code
     C                   PARM                    @@RAWB                         Raw amount
     C                   PARM                    FTOTDR                         Formatted amt
     C                   PARM                    @@EROR            1            Error indicator
     C                   PARM      3             @@DECP            1 0          Decimal Places
      *
     C     @@EROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S250'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      BJCYCD        REPCCY
     C                   Z-ADD     @@RAWB        REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       FTOTDR
     C                   ENDIF
      *
     C                   MOVE      '99'          DMRECC
     C                   MOVE      TRAILR        DMDATA
     C                   WRITE     FEGIBF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  S260  Update balances                                        *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     S260          BEGSR
      *
     C     *LOVAL        SETLL     ACCNTPO                                      Set pointer
     C                   MOVE      *OFF          *IN42                          Reset indicator
      *
     C                   READ      ACCNTPO                                42    Primary read
      *
      ** Read and update balances
      *
     C     *IN42         DOWEQ     *OFF                                         Until eof
      *
     C                   Z-ADD     *ZEROS        @@PTOT                         Postings total
     C                   Z-ADD     POCNUM        BCUST                          Customer
     C                   MOVE      POCYCD        BCCYC                          Currency code
     C                   Z-ADD     POACOD        BACOD                          Account code
     C                   Z-ADD     POACSQ        BACSQ                          Account seq
     C                   MOVE      POBRCA        BBRCH                          Branch code
      *
     C     POCNUM        IFNE      *LOVAL                                       Detail record
      *
     C                   MOVE      *OFF          *IN43                          Reset indicator
      *
     C     *IN43         DOWEQ     *OFF                                         Until eof
      *
     C     PODRCR        IFEQ      *ZERO                                        Debit
     C*                    ADD  POPSTA    @@PTOT           Increment
     C                   SUB       POPSTA        @@PTOT                         Increment
     C                   ELSE
     C*                    SUB  POPSTA    @@PTOT           Decrement
     C                   ADD       POPSTA        @@PTOT                         Decrement
     C                   ENDIF
      *
     C     @@KBAL        READE     ACCNTPO                                43    Get bal rec
      *
     C                   ENDDO
      *
     C                   EXSR      COM906                                       Update balances
      *
     C                   ENDIF
      *
     C     @@KPTR        SETGT     ACCNTPO                                      Set pointer
     C                   READ      ACCNTPO                                42    Get next
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM901 - Common routine to determine if posting is for an    *
      *           income or expenditure account                       *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM901        BEGSR
      *
     C                   MOVE      'N'           @@SKIP            1            Ignore posting
     C                   Z-ADD     *ZERO         @@CYCL            1 0          Cycle
      *
     C     ACSC          IFEQ      'IN'                                         Income
     C     ACOD          ANDNE     WTPFGA
     C     ACOD          ANDNE     WTFNIC
     C     ACOD          ANDNE     WTFNAA
     C     ACOD          ANDNE     WTFMAC
     C     ACSC          OREQ      'EX'                                         Expense
     C     ACOD          ANDNE     WTPFGA
     C     ACOD          ANDNE     WTFNIC
     C     ACOD          ANDNE     WTFNAA
     C     ACOD          ANDNE     WTFMAC
     C                   MOVE      'Y'           FPLIN1                         P&L Code
     C                   ELSE
     C                   MOVE      'N'           FPLIN1                         BS Code
     C                   ENDIF
      *
     C     FPLIN1        IFEQ      'Y'                                          P&L Code
      *
     C     @@SRCP        IFEQ      'GE-XF'                                      Source
     C     @@FUTR        ANDNE     'Y'                                          Future VDAT
     C                   MOVE      'Y'           @@SKIP                         Ignore posting
     C                   EXSR      COM911
     C                   ENDIF
     C     @@SRCP        IFEQ      'GE-PC'                                      Source
     C     GETP          ANDEQ     'X'                                          TRANSFER IND
     C     @@FUTR        ANDNE     'Y'                                          Future VDAT
     C                   MOVE      'Y'           @@SKIP                         Ignore posting
     C                   EXSR      COM911
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     @@SKIP        IFEQ      'N'                                          Do not skip
      *
     C     CCY           IFNE      BJCYCD                                       Not in base
     C     CCY           CHAIN     SDCURRL0                           50
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   @A6REA4
     C                   CLEAR                   ERRDET
     C                   MOVEL     CCY           REPKEY
     C                   MOVEL     'COM901'      REPPRG
     C                   MOVEL     @ERR(8)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   MOVE      CCY           ZCCYI             3            Currency code
     C                   MOVE      BJCYCD        ZCCYO             3            Base currency
     C                   Z-ADD     A6NBDP        ZCDPI             1 0          Currency dp
     C                   Z-ADD     @@BCDP        ZCDPO             1 0          Base ccy dp
     C                   Z-ADD     A6SPRT        ZEXCH            13 8          Spot rate
     C                   MOVE      A6MDIN        ZMD               1            Mult/div ind
     C                   Z-ADD     PSTA          ZAMTCI           15 0          Posting amount
     C                   Z-ADD     *ZEROS        ZAMTCO           15 0          Converted amoun
      *
     C                   EXSR      COM904                                       Convert amount
     C                   Z-ADD     ZAMTCO        @@BCYA                         Base ccy amt
      *
     C                   ENDIF
      *
      ** Concatenate account details
      *
     C                   MOVE      BRCA          ABRCH                          Branch code
     C                   Z-ADD     EOCNUM        ACUST                          Customer number
     C                   MOVE      CCY           ACCYC                          Currency code
     C                   Z-ADD     ACOD          AACOD                          Account code
     C                   Z-ADD     ACSQ          AACSQ                          A/c sequence
      *
      ** Retrieve account number
      *
     C     @@KACC        CHAIN     ACCNT                              50        Retrieve a/c
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ACCNTABF
     C                   CLEAR                   ERRDET
     C                   MOVE      ACUST         DSAC1
     C                   MOVE      ACCYC         DSAC2
     C                   MOVE      AACOD         DSAC3
     C                   MOVE      AACSQ         DSAC4
     C                   MOVE      ABRCH         DSAC5
     C                   MOVEL     DSAC          REPACN
     C                   MOVEL     'COM901'      REPPRG
     C                   MOVEL     @ERR(9)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   MOVE      ACOD          XXACCD                         Account code
     C                   MOVE      ACOD          EOACOD                         Account code
     C                   MOVE      ATYP          EOATYP                         Account code
     C                   MOVE      ACSQ          EOACSQ                         Account code
     C                   MOVE      BRCA          EOBRCA                         Account code
     C                   Z-ADD     DRIS          EODRIS                         Account code
     C                   Z-ADD     CRIS          EOCRIS                         Account code
     C                   Z-ADD     DRIB          EODRIB                         Account code
     C                   Z-ADD     CRIB          EOCRIB                         Account code
     C                   Z-ADD     LDBL          @@BAL            15 0          Ledger balance
      *
      ** Output temporary postings
      *
     C                   Z-ADD     EOCNUM        POCNUM                         Customer
     C                   MOVE      CCY           POCYCD                         Currency
     C                   Z-ADD     ACOD          POACOD                         A/c code
     C                   Z-ADD     ACSQ          POACSQ                         A/c seq
     C                   MOVE      BRCA          POBRCA                         Branch
     C                   Z-ADD     PSTD          POPSTD                         Posting date
     C                   Z-ADD     PSTA          POPSTA                         Posting amt
     C                   Z-ADD     DRCR          PODRCR                         DR/CR Ind
      *
     C     @@CLPD        IFNE      'Y'                                          EODCLPD FMT
     C     DRCR          IFEQ      *ZERO
     C                   Z-ADD     PSTA          PODBIT                         Debit
     C                   Z-ADD     *ZEROS        POCRDT                         Credit
     C                   ELSE
     C                   Z-ADD     *ZEROS        PODBIT                         Debit
     C                   Z-ADD     PSTA          POCRDT                         Credit
     C                   ENDIF
      *
     C                   WRITE     ACCNTPOF                                     Output postings
     C                   ENDIF
      * output extra posting if not base currency.
     C     FPLIN1        IFEQ      'Y'
     C     CCY           ANDNE     BJCYCD
     C     @@FUTR        ANDNE     'Y'                                          Future VDAT
     C     DRCR          IFEQ      *ZERO
     C                   Z-ADD     PSTA          POCRDT                         Debit
     C                   Z-ADD     *ZEROS        PODBIT                         Credit
     C                   ELSE
     C                   Z-ADD     *ZEROS        POCRDT                         Debit
     C                   Z-ADD     PSTA          PODBIT                         Credit
     C                   ENDIF
      *
     C     DRCR          IFEQ      0
     C                   Z-ADD     1             PODRCR
     C                   ELSE
     C                   Z-ADD     0             PODRCR
     C                   ENDIF
     C                   WRITE     ACCNTPOF                                     Output postings
     C                   Z-ADD     DRCR          PODRCR
     C                   ENDIF
      *******
     C                   Z-ADD     *LOVAL        POCNUM                         Customer
     C                   Z-ADD     *LOVAL        POACOD                         A/c code
     C                   Z-ADD     *LOVAL        POACSQ                         A/c seq
      *
     C     @@KBAL        CHAIN     ACCNTPO                            50        Get bal rec
      *
     C                   Z-ADD     *ZEROS        POPSTA                         Posting amt
     C                   MOVE      *LOVAL        PODRCR                         DR/CR
      *
     C     *IN50         IFEQ      *OFF                                         Found
      *
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       PSTA          PODBIT                         Accumulate
     C                   ELSE
     C                   ADD       PSTA          POCRDT                         Credit
     C                   ENDIF
      *
     C                   UPDATE    ACCNTPOF
      *
     C                   ELSE
      *
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   Z-ADD     PSTA          PODBIT                         Accumulate
     C                   Z-ADD     *ZEROS        POCRDT                         Credit
     C                   ELSE
     C                   Z-ADD     *ZEROS        PODBIT                         Debit
     C                   Z-ADD     PSTA          POCRDT                         Credit
     C                   ENDIF
      *
     C                   WRITE     ACCNTPOF
      *
     C                   ENDIF
      * update for extra posting
      *
     C     FPLIN1        IFEQ      'Y'
     C     CCY           ANDNE     BJCYCD
     C     @@FUTR        ANDNE     'Y'                                          Future VDAT
     C     @@KBAL        CHAIN     ACCNTPO                            50        Get bal rec
      *
     C                   Z-ADD     *ZEROS        POPSTA                         Posting amt
     C                   MOVE      *LOVAL        PODRCR                         DR/CR
      *
     C     *IN50         IFEQ      *OFF                                         Found
      *
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       PSTA          POCRDT                         Accumulate
     C                   ELSE
     C                   ADD       PSTA          PODBIT                         Credit
     C                   ENDIF
      *
     C                   UPDATE    ACCNTPOF
      *
     C                   ELSE
      *
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   Z-ADD     PSTA          POCRDT                         Accumulate
     C                   Z-ADD     *ZEROS        PODBIT                         Credit
     C                   ELSE
     C                   Z-ADD     *ZEROS        POCRDT                         Debit
     C                   Z-ADD     PSTA          PODBIT                         Credit
     C                   ENDIF
      *
     C                   WRITE     ACCNTPOF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                   CHG001
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM902 - Common routine to retrive the original transaction  *
      *                                                               *
      *  Called By: S220                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM902        BEGSR
      *
     C                   MOVE      *BLANKS       FCSDT2                         Start date
     C                   MOVE      *BLANKS       FCMDT2                         End date
     C                   MOVE      *BLANKS       @@OT                           Original trans
     C                   MOVE      *BLANKS       FSDAT2                         Start date
     C                   MOVE      *BLANKS       FMDAT2                         End date
     C                   Z-ADD     *ZEROS        @@SDAT                         Start date
     C                   Z-ADD     *ZEROS        @@EDAT                         End date
     C                   MOVE      *ON           *IN50                          Error
      *
     C                   SELECT                                                 On module
      *
     C     @@SMOD        WHENEQ    'DL'                                         Dealing
      *
      ** Retrieve using deal reference
      *
     C     @@TREF        IFNE      *BLANKS                                      Deal ref
      *
     C                   MOVE      @@TREF        @@DLNO                         Deal number
      *
     C     @@DLNO        IFNE      *ZEROS                                       Deal ref
     C     @@DLNO        CHAIN     DEALS                              50        Retrieve deal
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN50         IFEQ      *ON                                          Not found
      *
     C     @@OREF        IFNE      *BLANKS                                      Original ref
      *
     C                   MOVE      @@OREF        @@DLNO                         Original ref
      *
     C     @@DLNO        IFNE      *ZEROS                                       Deal ref
     C     @@DLNO        CHAIN     DEALS                              50        Retrieve deal
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN50         IFEQ      *OFF                                         Found
      *
     C                   MOVEL(P)  'D'           @@OT                           Dealing
     C                   MOVE      RCDT          @@OT                           Type
      *
     C                   Z-ADD     VDAT          @@SDAT                         Start date
     C                   Z-ADD     MDAT          @@EDAT                         End date
      *
     C     RCDT          IFEQ      'B'                                          DEALSDB
     C                   Z-ADD     VDAT          @@EDAT                         End date
     C                   ENDIF
      *
     C     RCDT          IFEQ      'C'                                          DEALSDC
     C     MDAT          ANDEQ     *ZEROS                                       Maturity date
     C     PSTD          ADD       NOTD          @@EDAT                         End date
     C                   ENDIF
      *
     C     RCDT          IFEQ      'E'                                          DEALSDE
     C                   Z-ADD     PMDT          @@EDAT                         End date
     C                   ENDIF
      *                                                                    LUC010
     C                   MOVE      PRFC          C9811                                          LUC0
      *
     C                   ENDIF
      *
      ** Securities trading
      *
     C     @@SMOD        WHENEQ    'ST'                                         Securities
      *
     C     OTST          CHAIN     SECTY                              50        Retrieve deal
      *
     C     *IN50         IFEQ      *OFF                                         Found
     C                   MOVE      'ST'          @@OT                           Securities
     C                   Z-ADD     ITLD          @@SDAT                         Start date
     C                   Z-ADD     MATY          @@EDAT                         End date
     C                   ENDIF
      *
      ** Lending
      *
     C     @@SMOD        WHENEQ    'LE'                                         Lending
      *
     C                   MOVE      @@TREF        @@DLNO                         Deal number
      *                                                                    CC000
     C***********@@KLEN    CHAINCLOANV4              50    Get record      CC000
     C     @@KLEN        CHAIN     CLOANV5                            50        Get record      CC00
      *                                                                    CC000
      *  If record not on live loans file, check matured loans file        CC000
      *                                                                    CC000
     C     *IN50         IFEQ      *ON                                                          CC00
     C                   MOVE      *OFF          *IN50                                          CC00
     C     @@KLEN        CHAIN     CLOANV6                            50        Get record      KEV0
     C                   ENDIF                                                                  CC00
      *
     C     *IN50         IFEQ      *OFF                                         Found
     C                   MOVE      'LE'          @@OT                           Lending
     C                   Z-ADD     VDAT          @@SDAT                         Start date
     C                   Z-ADD     MDAT          @@EDAT                         End date
      *                                                                    LUC010
     C                   MOVE      PRFC          C9811                                          LUC0
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Retrieve account number
      *
     C     *IN50         IFEQ      *ON                                          Not found
      *
     C                   Z-ADD     DACO          @@SDAT                         Start date
     C                   Z-ADD     *ZEROS        @@EDAT                         End date
     C                   MOVE      'GL'          @@OT                           General ledger
      *
     C     ATYP          IFEQ      'R'                                          Retail
     C                   MOVE      'RE'          @@OT                           Original trans
     C                   ENDIF
      *
     C     @@SMOD        IFEQ      'IC'                                         Retail
     C                   MOVE      'RE'          @@OT                           Original trans
     C                   ENDIF
      *
     C     @@SMOD        IFEQ      'ER'                                         Retail
     C                   MOVE      'RE'          @@OT                           Original trans
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Date conversion
      *
     C     @@SDAT        IFNE      *ZEROS                                       Start date
      *
     C                   MOVE      *OFF          *IN98                          DDMMYY
     C                   Z-ADD     @@SDAT        ZDAYNO                         Parameter
     C                   EXSR      ZDATE2                                       Convert date
     C                   Z-ADD     ZDATE         DMY                            Converted date
     C                   Z-ADD     @@D           @DD                            Day
     C                   Z-ADD     @@M           @MM                            Month
     C                   Z-ADD     @@Y           @YY                            Year
      *
     C     @@Y           IFGT      50                                           Year 2000
     C                   MOVE      '19'          @CC
     C                   ELSE
     C                   MOVE      '20'          @CC
     C                   ENDIF
      *
     C                   MOVE      YMD           FSDAT2                         Start date
      *
     C                   ENDIF
      *
     C     @@EDAT        IFNE      *ZEROS                                       Start date
      *
     C                   MOVE      *OFF          *IN98                          DDMMYY
     C                   Z-ADD     @@EDAT        ZDAYNO                         Parameter
     C                   EXSR      ZDATE2                                       Convert date
     C                   Z-ADD     ZDATE         DMY                            Converted date
     C                   Z-ADD     @@D           @DD                            Day
     C                   Z-ADD     @@M           @MM                            Month
     C                   Z-ADD     @@Y           @YY                            Year
      *
     C     @@Y           IFGT      50                                           Year 2000
     C                   MOVE      '19'          @CC
     C                   ELSE
     C                   MOVE      '20'          @CC
     C                   ENDIF
      *
     C                   MOVE      YMD           FMDAT2                         End date
      *
     C                   ENDIF
      *
      ** Credit line
      *
     C                   MOVE      *BLANKS       FCSDT2                         Start date
     C                   MOVE      *BLANKS       FCMDT2                         End date
     C                   MOVE      *ON           *IN50                          Error
     C*                    MOVE 'B'       RCTP             Record type
      *
     C     @@SMOD        IFEQ      'LE'                                         Lending
      *
     C                   MOVE      @@TREF        @@DLNO                         Deal number
     C***********@@KLEN    CHAINCLOANV4              50    Get record      CC000
     C     @@KLEN        CHAIN     CLOANV5                            50        Get record      CC00
      *                                                                    CC000
      *  If record not on live loans file, check matured loans file        CC000
      *                                                                    CC000
     C     *IN50         IFEQ      *ON                                                          CC00
     C                   MOVE      *OFF          *IN50                                          CC00
     C     @@KLEN        CHAIN     CLOANV6                            50        Get record      CC00
     C                   ENDIF                                                                  CC00
      *
     C     *IN50         IFEQ      *OFF                                         Found
     C     @@KFCL        CHAIN     FCLTYMV0                           50        Facility
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN50         IFEQ      *ON                                          Not found
      *
     C     @@KACC        CHAIN     ACCNT                              50        Retrieve a/c
      *
     C     *IN50         IFEQ      *OFF                                         Found
     C     ATYP          ANDEQ     'R'                                          Retail
     C     @@KFCP        CHAIN     FCLTYMV0                           50        Facility
     C                   ELSE
     C                   MOVE      *ON           *IN50
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Date conversion
      *
     C     *IN50         IFEQ      *OFF                                         Found
      *
     C*          STDT      IFNE *ZEROS                     Start date
     C     DTAP          IFNE      *ZEROS                                       Start date
      *
     C                   MOVE      *OFF          *IN98                          DDMMYY
     C*                    Z-ADDSTDT      ZDAYNO           Parameter
     C                   Z-ADD     DTAP          ZDAYNO                         Parameter
     C                   EXSR      ZDATE2                                       Convert date
     C                   Z-ADD     ZDATE         DMY                            Converted date
     C                   Z-ADD     @@D           @DD                            Day
     C                   Z-ADD     @@M           @MM                            Month
     C                   Z-ADD     @@Y           @YY                            Year
      *
     C     @@Y           IFGT      50                                           Year 2000
     C                   MOVE      '19'          @CC
     C                   ELSE
     C                   MOVE      '20'          @CC
     C                   ENDIF
      *
     C                   MOVE      YMD           FCSDT2                         Start date
      *
     C                   ENDIF
      *
     C*          EDDT      IFNE *ZEROS                     Start date
     C     DTEX          IFNE      *ZEROS                                       Start date
      *
     C                   MOVE      *OFF          *IN98                          DDMMYY
     C*                    Z-ADDEDDT      ZDAYNO           Parameter
     C                   Z-ADD     DTEX          ZDAYNO                         Parameter
     C                   EXSR      ZDATE2                                       Convert date
     C                   Z-ADD     ZDATE         DMY                            Converted date
     C                   Z-ADD     @@D           @DD                            Day
     C                   Z-ADD     @@M           @MM                            Month
     C                   Z-ADD     @@Y           @YY                            Year
      *
     C     @@Y           IFGT      50                                           Year 2000
     C                   MOVE      '19'          @CC
     C                   ELSE
     C                   MOVE      '20'          @CC
     C                   ENDIF
      *
     C                   MOVE      YMD           FCMDT2                         End date
      *
     C                   ENDIF
      *
      ** Retrieve Multiyear transaction                                    LUC010
     C     @@KFCL        CHAIN     FCLTYY0                            52        Facility Ext    LUC0
      *                                                                    LUC010
     C     *IN52         IFEQ      *OFF                                         Found           LUC0
     C                   MOVE      LMYTR         C9807                                          LUC0
     C                   ENDIF                                                                  LUC0
      *                                                                    LUC010
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM903 - Common routine to derive the BSPL code              *
      *                                                               *
      *  Called By: S210                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM903        BEGSR
      *
      ** Balance < 0
      *
     C     @@BAL         IFLT      *ZERO
      *
     C                   MOVE      '0'           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   MOVE      ' '           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
     C                   ENDIF
      *
      ** Account Reporting Details Not Found
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL2
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL2
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Balance > 0
      *
     C     @@BAL         IFGT      *ZERO
      *
     C                   MOVE      '1'           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   MOVE      ' '           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
     C                   ENDIF
      *
      ** Account Reporting Details Not Found
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   Z-ADD     *ZERO         FBSPL2
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL2
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Balance = 0
      *
     C     @@BAL         IFEQ      *ZERO
      *
     C                   MOVE      '0'           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   MOVE      '1'           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
     C                   ENDIF
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   MOVE      ' '           XXDRCR
     C     @@KBPL        CHAIN     SDACRCL9                           50        Account Reports
     C                   ENDIF
      *
      ** Account Reporting Details Not Found
      *
     C     *IN50         IFEQ      *ON                                          Not Found
     C                   CLEAR                   SDACRCD0
     C                   Z-ADD     *ZERO         FBSPL2
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     'COM903'      REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     XXRSNO        REPKEY
     C                   MOVE      XXACCD        REPKEY
     C                   EXSR      #ERR
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM904 - Common routine to convert to original currency      *
      *           Based on ZCONV                                      *
      *                                                               *
      *  Called By: S210                                              *
      *                                                               *
      *    INPUT  - ZAMTCI (15,0) AMOUNT INPUT                        *
      *             ZEXCH  (13,8) EXCHANGE RATE                       *
      *             ZMD    (1)    MULTIPLY/DIVIDE INDICATOR           *
      *             ZCCYI  (3)    CURRENCY INPUT                      *
      *             ZCCYO  (3)    CURRENCY TO BE CONVERTED TO         *
      *             POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED *
      *                           IN THE PROGRAM SOURCE               *
      *             ZCDPI  (1,0)  (FROM) CURRENCY DECIMAL PLACES      *
      *             ZCDPO  (1,0)  (TO) CURRENCY DECIMAL PLACES        *
      *                                                               *
      *   OUTPUT -  ZAMTCO (15,0) AMOUNT OUTPUT                       *
      *                                                               *
      *****************************************************************
      *
     C     COM904        BEGSR
      *
     C     ZEXCH         IFEQ      0
     C                   Z-ADD     0             ZAMTCO
     C                   GOTO      EZCONV
     C                   ENDIF
      *
     C     ZCDPI         IFEQ      ZCDPO                                                       S0111
      *
     C     ZMD           IFEQ      'D'
     C********   ZAMTCI    DIV  ZEXCH     ZAMTCO    H                     170598
     C********   ZAMTCI    DIV  ZEXCH     WORK   154H               170598202763
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO                                        20276
     C                   ELSE
     C********   ZAMTCI    MULT ZEXCH     ZAMTCO    H                     170598
     C********   ZAMTCI    MULT ZEXCH     WORK      H               170598202763
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO                                        20276
     C                   ENDIF
      *
     C                   ELSE
      *
     C     ZCDPO         SUB       ZCDPI         ZPX               1 0
     C                   ADD       4             ZPX
      *
     C     POWER(ZPX)    IFLT      1
     C     ZAMTCI        MULT      POWER(ZPX)    Z15#3            15 3
      *
     C     ZMD           IFEQ      'D'
     C*******    Z15#3     DIV  ZEXCH     ZAMTCO    H                     170598
     C*******    Z15#3     DIV  ZEXCH     WORK      H               170598202763
     C     Z15#3         DIV(H)    ZEXCH         ZAMTCO                                        20276
     C                   ELSE
     C*******    Z15#3     MULT ZEXCH     ZAMTCO    H                     170598
     C*******    Z15#3     MULT ZEXCH     WORK      H                     170598
     C     Z15#3         MULT(H)   ZEXCH         ZAMTCO                                  17059820276
     C                   ENDIF
      *
     C                   ELSE
      *
     C*******    ZAMTCI    MULT POWER,ZPX ZAMTCI                          170598
     C*******    ZAMTCI    MULT POWER,ZPX Z15#3                     170598202763
     C     ZAMTCI        MULT      POWER(ZPX)    ZAMTCI                                        20276
      *
     C     ZMD           IFEQ      'D'
     C*******    ZAMTCI    DIV  ZEXCH     ZAMTCO    H                     170598
     C*******    Z15#3     DIV  ZEXCH     WORK      H               170598202763
     C     ZAMTCI        DIV(H)    ZEXCH         ZAMTCO                                        20276
     C                   ELSE
     C*******    ZAMTCI    MULT ZEXCH     ZAMTCO    H                     170598
     C*******    Z15#3     DIV  ZEXCH     WORK      H               170598196749
     C*******    Z15#3     MULT ZEXCH     WORK      H               196749202763
     C     ZAMTCI        MULT(H)   ZEXCH         ZAMTCO                                        20276
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C*******              Z-ADDWORK      ZAMTCO    H               170598202763
      *
     C     EZCONV        ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM905 - Common routine to derive the Rate Type              *
      *                                                               *
      *  Called By: S210                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM905        BEGSR
      *
     C                   MOVE      *BLANKS       FRTYP2                         Rate type
      *
     C                   SELECT
      *
     C     @@OT          WHENEQ    'DC'                                         DEALSDC
     C     BRTT          IFNE      *ZEROS                                       Base type
     C                   MOVE      'V'           FRTYP2                         Variable
     C                   ELSE
     C                   MOVE      'F'           FRTYP2                         Fixed
     C                   ENDIF
      *
     C     @@OT          WHENEQ    'DD'                                         DEALSDD
     C                   MOVE      'F'           FRTYP2                         Fixed
      *
     C     @@OT          WHENEQ    'DG'                                         FRA
     C     DTYP          ANDEQ     'FR'
     C     UBRTT         IFNE      *ZEROS                                       Base type
     C                   MOVE      'V'           FRTYP2                         Variable
     C                   ELSE
     C                   MOVE      'F'           FRTYP2                         Fixed
     C                   ENDIF
      *
     C     @@OT          WHENEQ    'DG'                                         IRS
     C     DTYP          ANDNE     'FR'
     C     UBRTT         IFNE      *ZEROS                                       Base type
     C                   MOVE      'V'           FRTYP2                         Variable
     C                   ELSE
     C                   MOVE      'F'           FRTYP2                         Fixed
     C                   ENDIF
      *
     C     @@OT          WHENEQ    'LE'                                         Lending
     C     BRTT          IFNE      *ZEROS                                       Base type
     C                   MOVE      'V'           FRTYP2                         Variable
     C                   ELSE
     C                   MOVE      'F'           FRTYP2                         Fixed
     C                   ENDIF
      *
     C     @@OT          WHENEQ    'RE'                                         Retail
      *
     C                   MOVE      'F'           FRTYP2
      *
     C     EOATYP        IFEQ      'R'
      *
     C     EODRIB        IFNE      0
     C                   MOVE      'V'           FRTYP2
     C                   ENDIF
      *
     C     EODRIB        IFEQ      0
     C     EOCRIB        ANDNE     0                                                        nt
     C                   MOVE      'V'           FRTYP2
     C                   ENDIF
      *
     C     EODRIS        IFNE      0
     C     EODRIB        ANDEQ     0                                                        nt
     C                   MOVE      'F'           FRTYP2
     C                   ENDIF
      *
     C     EODRIS        IFEQ      0
     C     EOCRIS        IFNE      0                                                        nt
     C     EOCRIB        ANDEQ     0                                                        nt
     C                   MOVE      'F'           FRTYP2
     C                   ENDIF
     C                   ENDIF
      *
     C     EODRIS        IFEQ      0
     C     EOCRIS        ANDEQ     0                                                        nt
      * ... get REIAC record
     C                   MOVE      EOCNUM        KRENUM
     C                   MOVE      EOCCY         KRECCY
     C                   MOVE      EOACOD        KRECOD
     C                   MOVE      EOACSQ        KRESQ
     C                   MOVE      EOBRCA        KREBRC
     C     KREIAC        CHAIN     REIAC                              45
      * ... get REINT record
     C     *IN45         IFEQ      *OFF
      *
     C     DICT          IFNE      0
     C                   MOVE      DICT          DSREK1
     C                   MOVE      DCST          DSREK2
     C                   MOVE      CCY$3         DSREK3
     C                   MOVEL     'D '          DSREK4
     C     DSREIN        CHAIN     REINT                              46
     C     *IN46         IFEQ      *OFF
     C     BRT           IFNE      0
     C                   MOVE      'V'           FRTYP2
     C                   ELSE
     C                   MOVE      'F'           FRTYP2
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C     CICT          IFNE      0
     C                   MOVE      CICT          DSREK1
     C                   MOVE      CCST          DSREK2
     C                   MOVE      CCY$3         DSREK3
     C                   MOVEL     'D '          DSREK4
     C     DSREIN        CHAIN     REINT                              46
     C     *IN46         IFEQ      *OFF
     C     BRT           IFNE      0
     C                   MOVE      'V'           FRTYP2
     C                   ELSE
     C                   MOVE      'F'           FRTYP2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM906 - Common routine to update the trailer record         *
      *                                                               *
      *  Called By: S260                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM906        BEGSR
      *
      ** Retrieve Opening & Closing balances from ACCNT/ACCOL
      *
     C                   Z-ADD     POCNUM        ACUST                          Customer
     C                   MOVE      POCYCD        ACCYC                          Currency code
     C                   Z-ADD     POACOD        AACOD                          Account code
     C                   Z-ADD     POACSQ        AACSQ                          Account seq
     C                   MOVE      POBRCA        ABRCH                          Branch code
      *
     C     @@KBAC        CHAIN     ACCNT                              50        Get account
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ACCNTABF
     C                   CLEAR                   ERRDET
     C                   MOVE      ACUST         DSAC1
     C                   MOVE      ACCYC         DSAC2
     C                   MOVE      AACOD         DSAC3
     C                   MOVE      AACSQ         DSAC4
     C                   MOVE      ABRCH         DSAC5
     C                   MOVEL     DSAC          REPACN
     C                   MOVEL     'COM906'      REPPRG
     C                   MOVEL     @ERR(9)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   Z-ADD     POCNUM        BLCNUM                         Customer
     C                   MOVE      POCYCD        BLCYCD                         Currency
     C                   Z-ADD     POACOD        BLACOD                         A/c code
     C                   Z-ADD     POACSQ        BLACSQ                         A/c seq
     C                   MOVE      POBRCA        BLBRCA                         Branch
      * Check if record exists already on ACCNTBL
     C     @@KBLL        CHAIN     ACCNTBL                            51
     C     *IN51         IFEQ      *ON
     C                   Z-ADD     POPSTD        BLPSTD                         Balance date
     C                   Z-ADD     @@PTOT        BLPSTA                         Posting total
     C                   Z-ADD     LDBL          BLCLOS                         Closing bal
      *
     C     @@KBAC        CHAIN     ACCOL                              50        Get account
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ACCNTABF
     C                   CLEAR                   ERRDET
     C                   MOVE      ACUST         DSAC1
     C                   MOVE      ACCYC         DSAC2
     C                   MOVE      AACOD         DSAC3
     C                   MOVE      AACSQ         DSAC4
     C                   MOVE      ABRCH         DSAC5
     C                   MOVEL     DSAC          REPACN
     C                   MOVEL     'COM906'      REPPRG
     C                   MOVEL     @ERR(10)      REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   Z-ADD     LDBL          BLOPEN                         Opening bal
     C*          BLPSTA    ADD  BLOPEN    BLDIFF           Difference
     C     BLOPEN        SUB       BLPSTA        BLDIFF                         Difference
     C     BLDIFF        SUB       BLCLOS        BLDIFF                         Difference
     C                   WRITE     ACCNTBLF
      *
     C                   ELSE
     C                   ADD       @@PTOT        BLPSTA                         Posting total
     C     BLOPEN        SUB       BLPSTA        BLDIFF                         Difference
     C     BLDIFF        SUB       BLCLOS        BLDIFF                         Difference
     C                   UPDATE    ACCNTBLF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM907 - Common routine to convert Midas amount to 15(3).    *
      *                                                               *
      *    INPUT  - ZAMTI7 (15,0) AMOUNT INPUT                        *
      *             POWER   -     COMPILE TIME ARRAY MUST BE INCLUDED *
      *                           IN THE PROGRAM SOURCE               *
      *             ZCDP7  (1,0)  (FROM) CURRENCY DECIMAL PLACES      *
      *                                                               *
      *   OUTPUT -  ZAMTO7 (15,0) AMOUNT OUTPUT                       *
      *                                                               *
      *****************************************************************
      *
     C     COM907        BEGSR
      *
     C                   Z-ADD     0             ZAMTO7           15 0
     C                   Z-ADD     0             ZEROO7           15 0
      *
     C     ZAMTI7        IFNE      0
      *
     C     ZCDP7         IFEQ      0
     C     ZAMTI7        MULT      1000          ZAMTI7
     C                   MOVE      ZAMTI7        ZAMTO7
     C                   ENDIF
      *
     C     ZCDP7         IFEQ      1
     C     ZAMTI7        MULT      100           ZAMTI7
     C                   MOVE      ZAMTI7        ZAMTO7
     C                   ENDIF
      *
     C     ZCDP7         IFEQ      2
     C     ZAMTI7        MULT      10            ZAMTI7
     C                   MOVE      ZAMTI7        ZAMTO7
     C                   ENDIF
      *
     C     ZCDP7         IFEQ      3
     C                   MOVE      ZAMTI7        ZAMTO7
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  COM908 - Common routine to determine if posting has a future *
      *           value date, and which format we are reading from    *
      *           EODPOPL. Income & Expense only. Non-Base Currency.  *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM908        BEGSR
      *
     C                   MOVE      'N'           @@FUTR            1            Future posting
     C                   MOVE      'N'           @@CLPD            1            Clearing File
      *
     C***********ACSC      IFEQ 'IN'                       Income           CC00
     C***********ACOD      ANDNEWTPFGA                                      CC00
     C***********ACOD      ANDNEWTFNIC                                      CC00
     C***********ACOD      ANDNEWTFNAA                                      CC00
     C***********ACOD      ANDNEWTFMAC                                      CC00
     C***********ACSC      OREQ 'EX'                       Expense          CC00
     C***********ACOD      ANDNEWTPFGA                                      CC00
     C***********ACOD      ANDNEWTFNIC                                      CC00
     C***********ACOD      ANDNEWTFNAA                                      CC00
     C***********ACOD      ANDNEWTFMAC                                      CC00
      *
      *  Check if A/C code is flagged for extraction on Ext. File.          CC00
      *                                                                     CC00
     C                   MOVE      ACOD          WMACCD            4                             CC0
     C     WMACCD        CHAIN     SDACODV1                           30                         CC0
     C     *IN30         IFEQ      *ON                                                           CC0
     C                   CLEAR                   ERRDET                                          CC0
     C                   MOVEL     ACOD          REPKEY                                          CC0
     C                   MOVEL     'CM908'       REPPRG                                          CC0
     C                   MOVEL     @ERR(13)      REPMSG                                          CC0
     C                   EXSR      #ERR                                                          CC0
     C                   EXSR      *PSSR                                                         CC0
     C                   ENDIF                                                                   CC0
      *                                                                     CC00
      * If Account code 1767, reset flag so included if Int. Cap.           CC00
     C     *IN30         IFEQ      *OFF                                                          CC0
     C     MACCD         ANDEQ     '1767'                                                        CC0
     C                   MOVE      *BLANKS       INTCAP                                          CC0
     C                   MOVEL     PNAR          INTCAP            7                             CC0
      *                                                                     CC00
     C     INTCAP        IFEQ      'INT.CAP'                                                     CC0
     C                   MOVE      'N'           MEXTF                                           CC0
     C                   ENDIF                                                                   CC0
      *                                                                     CC00
     C                   ENDIF                                                                   CC0
      *                                                                     CC00
     C     ACSC          IFEQ      'IN'                                         Income           CC0
     C     ACOD          ANDNE     WTPFGA                                                        CC0
     C     ACOD          ANDNE     WTFNIC                                                        CC0
     C     ACOD          ANDNE     WTFNAA                                                        CC0
     C     ACOD          ANDNE     WTFMAC                                                        CC0
     C     ACSC          OREQ      'EX'                                         Expense          CC0
     C     ACOD          ANDNE     WTPFGA                                                        CC0
     C     ACOD          ANDNE     WTFNIC                                                        CC0
     C     ACOD          ANDNE     WTFNAA                                                        CC0
     C     ACOD          ANDNE     WTFMAC                                                        CC0
     C     MEXTF         OREQ      'Y'                                                           CC0
      *                                                                     CC00
     C     EOCCY         IFNE      BJCYCD                                                   ng
     C*          VALD      ANDGTBJRDNB                                 ng
     C     VALD          ANDGT     WENMTH                                                   ng
     C                   MOVE      'Y'           @@FUTR            1            Future posting
     C                   MOVE      EOCNUM        CNUM
     C**********           WRITEEODCLP1                                   188302
     C                   END
      *
     C     URFMT         IFEQ      'EODCLP0'                                                ng
     C                   MOVE      'Y'           @@CLPD            1            Clearing File
     C                   END
      *
     C                   ENDIF                                                                   CC0
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  COM909-Write ACCNTBL and ACCNTPO records                     *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *****************************************************************
      *
     C     COM909        BEGSR
      *
      ** Write ACCNTPO record
      *
      *  Concatenate account details
      *
     C                   MOVE      FCCYC1        ACCYC                          Currency code
      *
      ** Retrieve account number
      *
     C     @@KACC        CHAIN     ACCNT                              50        Retrieve a/c
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   CLEAR                   ACCNTABF
     C                   CLEAR                   ERRDET
     C                   MOVE      ACUST         DSAC1
     C                   MOVE      ACCYC         DSAC2
     C                   MOVE      AACOD         DSAC3
     C                   MOVE      AACSQ         DSAC4
     C                   MOVE      ABRCH         DSAC5
     C                   MOVEL     DSAC          REPACN
     C                   MOVEL     'COM909'      REPPRG
     C                   MOVEL     @ERR(9)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   MOVE      ACOD          XXACCD                         Account code
     C                   Z-ADD     LDBL          @@BAL            15 0          Ledger balance
      *
      ** Output temporary postings
      *
     C                   Z-ADD     ACUST         POCNUM                         Customer
     C                   MOVE      FCCYC1        POCYCD                         Currency
     C                   Z-ADD     AACOD         POACOD                         A/c code
     C                   Z-ADD     AACSQ         POACSQ                         A/c seq
     C                   MOVE      ABRCH         POBRCA                         Branch
     C                   Z-ADD     PSTD          POPSTD                         Posting date
     C                   Z-ADD     @@BCYA        POPSTA                         Posting amt
     C                   Z-ADD     DRCR          PODRCR                         DR/CR Ind
      *
     C     DRCR          IFEQ      *ZERO
     C                   Z-ADD     @@BCYA        PODBIT                         Debit
     C                   Z-ADD     *ZEROS        POCRDT                         Credit
     C                   ELSE
     C                   Z-ADD     *ZEROS        PODBIT                         Debit
     C                   Z-ADD     @@BCYA        POCRDT                         Credit
     C                   ENDIF
      *
     C                   WRITE     ACCNTPOF                                     Output postings
      *
     C                   Z-ADD     *LOVAL        POCNUM                         Customer
     C                   Z-ADD     *LOVAL        POACOD                         A/c code
     C                   Z-ADD     *LOVAL        POACSQ                         A/c seq
      *
     C     @@KBAL        CHAIN     ACCNTPO                            50        Get bal rec
      *
     C                   Z-ADD     *ZEROS        POPSTA                         Posting amt
     C                   MOVE      *LOVAL        PODRCR                         DR/CR
      *
     C     *IN50         IFEQ      *OFF                                         Found
      *
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   ADD       @@BCYA        PODBIT                         Accumulate
     C                   ELSE
     C                   ADD       @@BCYA        POCRDT                         Credit
     C                   ENDIF
      *
     C                   UPDATE    ACCNTPOF
      *
     C                   ELSE
      *
     C     DRCR          IFEQ      *ZERO                                        Debit
     C                   Z-ADD     @@BCYA        PODBIT                         Accumulate
     C                   Z-ADD     *ZEROS        POCRDT                         Credit
     C                   ELSE
     C                   Z-ADD     *ZEROS        PODBIT                         Debit
     C                   Z-ADD     @@BCYA        POCRDT                         Credit
     C                   ENDIF
      *
     C                   WRITE     ACCNTPOF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *    S300      - Program termination                            *
      *                                                               *
      *    CALLED BY - S200 , *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     S300          BEGSR
      *
     C     *IN88         IFEQ      *ON                                          Database error
     C                   WRITE     HEADAU                                       Report header
     C                   WRITE     DBERROR                                      Report error
     C                   ELSE
      *
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
      *  COM910 - Check rounding differences and update FEGIB file,   *
      *           if change in account.                               *
      *                                                               *
      *  Called By: S200                                              *
      *                                                               *
      *****************************************************************
      *
     C     COM910        BEGSR
      *
      * Change in Account or EOF?
      *
     C     BRCA          IFNE      SVBRCA                                                      CHG00
     C     EOCNUM        ORNE      SVCNUM                                                      CHG00
     C     CCY           ORNE      SVCCY                                                       CHG00
     C     ACOD          ORNE      SVACOD                                                      CHG00
     C     ACSQ          ORNE      SVACSQ                                                      CHG00
     C     *IN41         OREQ      *ON
     C*
     C********** @@@BTT    IFNE 0                                   CHG001205623
      * Determine whether there is a difference between base currency     CHG001
      * equivalent for the GE-XF record and the total for the detail      CHG001
      * records for the account                                           CHG001
     C*          @@@BTT    SUB  @@@TTL    @@@DIF 150                      CHG001
     C                   Z-SUB     @@@TTL        @@@TTL                         Reverse sign
     C     @@@TTL        SUB       @@@BTT        @@@DIF           15 0                         CHG00
      * Print error if rounding too big, and dont do rounding.
     C***********@@@DIF    IFLT -10                                       170598
     C***********@@@DIF    ORGT 10                                        170598
     C     @@@DIF        IFLT      -30                                                         17059
     C     @@@DIF        ORGT      30                                                          17059
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     SVANUM        REPACN
     C                   MOVEL     'COM910'      REPPRG
     C                   MOVEL     @ERR(12)      REPMSG
     C                   EXSR      #ERR
     C                   ENDIF
      *                                                                   CHG001
      * Where a difference occurs update the most recent detail records   CHG001
      * by the diffence                                                   CHG001
     C     @@@DIF        IFNE      *ZERO                                                       CHG00
      * If rounding error, dont do it.
     C***********@@@DIF    ANDGT-10                                       170598
     C***********@@@DIF    ANDLT10                                        170598
     C     @@@DIF        ANDGT     -30                                                         17059
     C     @@@DIF        ANDLT     30                                                          17059
      *                                                                   CHG001
     C                   ADD       @@@DIF        @@@AMT                                        CHG00
     C*                    SUB  @@@DIF    @@@AMT                          CHG001
     C     @@@REC        CHAIN     FEGIBF                             51                       CHG00
     C     *IN51         IFEQ      *OFF                                                        CHG00
     C                   MOVE      DMDATA        DTLRC1                                        CHG00
      *                                                                   CHG001
     C**********         CALL      'GLM041'                               Format amount CHG00 LUC109
     C                   CALL      'XX000041'                                   Format amount LUC109
     C                   PARM                    BJCYCD                         Currency code  CHG00
     C                   PARM                    @@@AMT                         Raw amount     CHG00
     C                   PARM                    FPOSA1                         Formatted amt  CHG00
     C                   PARM                    @@EROR            1            Error indicatorCHG00
      *                                                                   CHG001
     C     @@EROR        IFEQ      'Y'                                          Ended in error CHG00
     C                   MOVE      *BLANKS       REPPRG                                        CHG00
     C                   MOVE      *BLANKS       REPMSG                                        CHG00
     C                   MOVE      *BLANKS       REPKEY                                        CHG00
     C                   MOVE      *BLANKS       REPDTA                                        CHG00
     C                   MOVE      *BLANKS       REPACN                                        CHG00
     C                   MOVEL     ACNUM         REPACN                                        CHG00
     C                   MOVEL     'COM910'      REPPRG                                        CHG00
     C                   MOVEL     @ERR(1)       REPMSG                                        CHG00
     C                   MOVEL     '*NONE'       REPKEY                                        CHG00
     C                   MOVE      BJCYCD        REPCCY                                        CHG00
     C                   Z-ADD     @@@AMT        REPVAL                                        CHG00
     C                   MOVEL     REPAMT        REPDTA                                        CHG00
     C                   EXSR      #ERR                                                        CHG00
     C                   MOVE      *BLANKS       FPOSA1                                        CHG00
     C                   ENDIF                                                                 CHG00
      *                                                                   CHG001
     C                   MOVE      DTLRC1        DMDATA                                        CHG00
     C                   UPDATE    FEGIBF                                                      CHG00
      *                                                                   CHG001
      * Adjust totals by the difference                                   CHG001
     C                   Z-ADD     @@BCDP        ZCDP7             1 0                         CHG00
     C                   Z-ADD     @@@DIF        ZAMTI7           15 0                         CHG00
     C                   EXSR      COM907
     C***********@@@DC     IFEQ *ZERO                                     CHG001
     C     DRCR          IFEQ      *ZERO                                                       MMI04
     C*                    SUB  @@@DIF    @@DBIT                          CHG001
     C                   SUB       ZAMTO7        @@DBIT                                        CHG00
     C                   ELSE                                                                  CHG00
     C*                    ADD  @@@DIF    @@CRDT                          CHG001
     C                   ADD       ZAMTO7        @@CRDT                                        CHG00
     C                   ENDIF                                                                 CHG00
      *
      * update accntpo and accntbl records.
      *
     C                   Z-ADD     SVCNUM        POCNUM                         Customer
     C                   MOVE      SVCCY         POCYCD                         Currency
     C                   Z-ADD     SVACOD        POACOD                         A/c code
     C                   Z-ADD     SVACSQ        POACSQ                         A/c seq
     C                   MOVE      SVBRCA        POBRCA                         Branch
     C     @@KBAL        CHAIN     ACCNTPO                            50        Get bal rec
     C     *IN50         IFEQ      *ON
     C                   Z-ADD     99999         POPSTD                         Posting date
     C     @@@DIF        IFGE      *ZERO                                                       CHG00
     C*                    Z-ADD@@@DIF    PODBIT           Debit
     C*                    Z-ADD@@@DIF    POPSTA           Posting amt
     C                   Z-SUB     @@@DIF        PODBIT                         Debit
     C                   Z-SUB     @@@DIF        POPSTA                         Posting amt
     C                   Z-ADD     0             PODRCR                         DR/CR Ind
     C                   ELSE
     C*                    Z-SUB@@@DIF    POCRDT           Credit
     C*                    Z-SUB@@@DIF    POPSTA           Posting amt
     C                   Z-ADD     @@@DIF        POCRDT                         Credit
     C                   Z-ADD     @@@DIF        POPSTA                         Posting amt
     C                   Z-ADD     1             PODRCR                         DR/CR Ind
     C                   ENDIF
     C                   WRITE     ACCNTPOF                                     Output postings
      *
     C                   ELSE
     C*                    Z-ADD@@@DIF    POPSTA           Posting amt
     C     PODRCR        IFEQ      0
     C*                    ADD  @@@DIF    PODBIT           Debit
     C                   SUB       @@@DIF        PODBIT                         Debit
     C                   SUB       @@@DIF        POPSTA                         Posting amt
     C                   ELSE
     C                   ADD       @@@DIF        POCRDT                         Credit
     C                   ADD       @@@DIF        POPSTA                         Posting amt
     C                   ENDIF
     C                   UPDATE    ACCNTPOF                                     Output postings
     C                   ENDIF
      *
      * Update ACCNTBL
     C                   Z-ADD     POCNUM        BLCNUM                         Customer
     C                   MOVE      POCYCD        BLCYCD                         Currency
     C                   Z-ADD     POACOD        BLACOD                         A/c code
     C                   Z-ADD     POACSQ        BLACSQ                         A/c seq
     C                   MOVE      POBRCA        BLBRCA                         Branch
     C     @@KBLL        CHAIN     ACCNTBL                            51
     C     *IN51         IFEQ      *OFF
     C*                    ADD  @@@DIF    BLPSTA           Balance date
     C                   SUB       @@@DIF        BLPSTA                         Balance date
     C*          BLPSTA    ADD  BLOPEN    BLDIFF           Difference
     C     BLOPEN        SUB       BLPSTA        BLDIFF                         Difference
     C     BLDIFF        SUB       BLCLOS        BLDIFF                         Difference
     C                   UPDATE    ACCNTBLF
     C                   ENDIF
      *
     C                   ENDIF                                                                 CHG00
     C                   ENDIF                                                                 CHG00
     C***********          ENDIF                                    CHG001205623
      *
      * Reset Account detail and totals                                   CHG001
      *
     C                   MOVE      BRCA          SVBRCA                                        CHG00
     C*                    MOVE CNUM      SVCNUM                          CHG001
     C                   MOVE      EOCNUM        SVCNUM                                        CHG00
     C                   MOVE      CCY           SVCCY                                         CHG00
     C                   MOVE      ACOD          SVACOD                                        CHG00
     C                   MOVE      ACSQ          SVACSQ                                        CHG00
     C                   Z-ADD     *ZERO         @@@TTL           15 0                         CHG00
     C                   Z-ADD     *ZERO         @@@REC            6 0                         CHG00
     C                   Z-ADD     *ZERO         @@@BTT           15 0                         CHG00
     C                   ENDIF                                                                 CHG00
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  COM911 - Total up base currency equivalents of transfer      *
      *           amounts to check for rounding errors.               *
      *                                                               *
      *  Called By: S200                                              *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     COM911        BEGSR
      *
     C     CCY           IFNE      BJCYCD                                                      CHG00
      *
     C     CCY           CHAIN     SDCURRL0                           50                       CHG00
     C     *IN50         IFEQ      *ON                                                         CHG00
     C                   CLEAR                   @A6REA4
     C                   CLEAR                   ERRDET
     C                   MOVEL     CCY           REPKEY
     C                   MOVEL     'COM911'      REPPRG
     C                   MOVEL     @ERR(8)       REPMSG
     C                   EXSR      #ERR
     C                   ENDIF                                                                 CHG00
      *
     C                   MOVE      CCY           ZCCYI             3                           CHG00
     C                   MOVE      BJCYCD        ZCCYO             3                           CHG00
     C                   Z-ADD     A6NBDP        ZCDPI             1 0                         CHG00
     C                   Z-ADD     @@BCDP        ZCDPO             1 0                         CHG00
     C                   Z-ADD     A6SPRT        ZEXCH            13 8                         CHG00
     C                   MOVE      A6MDIN        ZMD               1                           CHG00
     C                   Z-ADD     PSTA          ZAMTCI           15 0                         CHG00
     C                   Z-ADD     *ZEROS        ZAMTCO           15 0                         CHG00
      *                                                                   CHG001
     C                   EXSR      COM904                                       Base ccy equiv CHG00
      *                                                                   CHG001
     C     DRCR          IFEQ      *ZERO                                                       CHG00
     C                   Z-SUB     ZAMTCO        @@@BCT           15 0                         CHG00
     C                   ELSE                                                                  CHG00
     C                   Z-ADD     ZAMTCO        @@@BCT                                        CHG00
     C                   ENDIF                                                                 CHG00
     C                   ADD       @@@BCT        @@@BTT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
     C********************************************************************
     C**
     C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
     C**
     C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
     C**
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
     C**
     C**   CLEAR LEAP YEAR WORK FIELD.
     C                   MOVE      'N'           ZLEAP             1
     C**
     C**   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
     C**
     C**   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
     C**
     C**   DETERMINE DAY OF MONTH.
     C**
     C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
     C**
     C**   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
     C**
     C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
     C**
     C**   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C**
     C**   FORMAT ALPHA DATE, DDMMMYY.
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
     C**
     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
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
     C**********         MOVEL     'GLM035'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000035'    DBPGM                          Set program idLUC109
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
     C                   EXSR      S300                                         Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
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
      ***/C*PY*ZSRSRC,ZDAT10Z2                                                                LUC109
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 LUC109
      /EJECT
      ***
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
**  @ERR
XX000041 UNABLE TO CONVERT AMOUNT
SDACRCL9 RECORD NOT FOUND
SDBANKPD RECORD NOT FOUND
SDGELRPP RECORD NOT FOUND
SDINTFPD RECORD NOT FOUND
SDBRCHL1 RECORD NOT FOUND
SDGELRPD RECORD NOT FOUND
SDCURRL0 RECORD NOT FOUND
ACCNT    RECORD NOT FOUND
ACCOL    RECORD NOT FOUND
SDPCACPD RECORD NOT FOUND
ERROR IN ROUNDING-CHECK A/C POSTINGS
SDACODV1 RECORD NOT FOUND                                                     CC
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**  POWER - Array of powers for currency conversion
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  CLR - Clear the temprary file
CLRPFM FILE(ACCNTPO)
CLRPFM FILE(ACCNTBL)
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
