     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Foreign Exchange Transaction Extract')              *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM034**-*GL*Foreign*Exchange*Transaction*Extract*************                       LUC109
      *  XX000034  - GL Foreign Exchange Transaction Extract          *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Foreign Exchange Transaction Extract               *
      *                                                               *
      *                                                               *
      ***CALLED*BY**GLCM034*-*Foreign*Exchange*Transaction*Extract*****                       LUC109
      *  CALLED BY  XXC000034 - Foreign Exchange Transaction Extract  *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 21Sep16               *
      *  Prev Amend No. CM000xxxxx - ND    Date 24Sep14               *
      *                 CM00036425 - ND    Date 10Feb14               *
      *                 LUC013             Date 15May08               *
      *                 MUI011             Date 24May04               *
      *                 MUI009             Date 03Jun04               *
      *                 MUI008             Date 12Dec02               *
      *                 206327             Date 05Jun02               *
      *                 203973             Date 20Mar02               *
      *                 202688             Date 07Feb02               *
      *                 199924             Date 26Nov01               *
      *                 196659             Date 08AUG01               *
      *                 195842             Date 17JuL01               *
      *                 EFIXGS             Date 22Jun01               *
      *                 MUI005             Date 05APR01               *
      *                 174511             Date 03Feb00               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 16Aug99               *
      *                 MMI043             Date 20Apr99               *
      *                 CHG002             Date 02Feb99               *
      *                 MMI043   *create   Date 08Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  CM00062206 - Add netting agreement flag R306                 *
      *  CM00036425 - Add Murex Transaction Id to output record xx    *
      *  LUC013 - Invoke FTL0035 instead of FT0035.                   *
      *  MUI011 - ALMS - Add fields C9830 and C9868.                  *
      *  MUI009 - R4 Upgrade: use core Midas revaluation rules.       *
      *           Also, simplify processing by handling FX Options in *
      *           same way as FX deals.                               *
      *  MUI008 - Process FT Cheques                                  *
      *  206327 - Do not revalue transactions maturing beforing       *
      *           next working day                                    *
      *  203973 - Ordering Customer not extracted.                    *
      *           Also, include FT transactions entered in current    *
      *           but expired before current month.                   *
      *  202688 - First leg of swaps reported as live even if already *
      *           matured.                                            *
      *           Error within fix 199924 causing zero revaluation    *
      *           on FT transactions.                                 *
      *  199924 - Field C1178 (Revaluation Amount - Sale Currency)    *
      *           for Funds Transfer needs to be zeroised only if     *
      *           Pay Date has passed.                                *
      *           Also, do not output C1177 and C1178 if Pay and      *
      *           Settlement Currencies are the same.                 *
      *           Also, correct and simplify FT revaluation by        *
      *           making it same as FX one (deleted following sub-    *
      *           routines: FTRAT, FT02, FT03).                       *
      *  196659 - FOR OP DEALS ONLY USE PUVLO.                        *
      *  195842 - Do not process reversed Deals.                     *
      *  EFIXGS - Process all FT transactions.                        *
      *  MUI005 - Change to Head Office Reporting to iclude Funds     *
      *           Transfer transactions in the IMC extract.           *
      *  174511 - For option deals, update of maturity code (C5064)   *
      *           should be based in Option to date field.            *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043   - Problem in Profit/Loss amount.                    *
      *  MMI043   - Amendments for IMCXXXX update failure.            *
      *  CHG002   - Addition of 2 new fields on sub-record 4 -        *
      *             Deal type & Sub-type                              *
      *  MMI043   - Foreign Exchange Transaction Extract              *
      *                                                               *
      *****************************************************************
      *
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDDEALPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FDEALBR    IF   E           K DISK    INFSR(*PSSR)
     FDEALSBY0  IF   E           K DISK    INFSR(*PSSR)                                       LUC109
     FSDACRCL9  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FDEALSG    IF   E           K DISK    INFSR(*PSSR)
     FFWDRTE    IF   F  611     3AIDISK    INFSR(*PSSR)
     F                                     KEYLOC(2)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     FINPAYBB   IF   E           K DISK    INFSR(*PSSR)                         MUI005
     FOTPAYBB   IF   E           K DISK    INFSR(*PSSR)                         MUI005
     F**ACNUMA  IF  E           K        DISK         KINFSR *PSSR  MUI005203973
     FCQCODBB   IF   E           K DISK    INFSR(*PSSR)                         MUI008
     FCQPACBB   IF   E           K DISK    INFSR(*PSSR)                         MUI008
     F***GZFXDLL1  IF   E           K DISK                                         CM00036425 LUC109
     FFEIMC     O    E             DISK    INFSR(*PSSR)
     F***GLM034AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000034AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/DEALBR     File I/O                                 *
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
      *  #BSPL  - Determine BSPL Details                              *
      *  #FWDVL - Determine Forward Valuation                         *
      *  #RATES - Determine Forward Rates                             *
      *  #ACKEY - Determine Account Codes                             *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
     D @ERR            S             35    DIM(3) CTDATA PERRCD(1)
     D DFW             S              5  0 DIM(25)
     D DAT             S              5  0 DIM(26) ASCEND
     D RAT             S             13  8 DIM(26)
     D RFW             S             13  8 DIM(25)
      *
      ***File*information*for*printer*file*GLM037AU********************                       LUC109
      ** File information for printer file XX000034AU                                         LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      *
     D W0DTA           DS           256                                         MUI005
     D*                                                                   MUI005
     D** CALLING PARAMETER DATA STRUCTURE FOR FT0035                      MUI005
     D*                                                                   MUI005
     D  I#PT1                  1      1                                         MUI005
     D  I#PTY1                 2     36                                         MUI005
     D  I#PT2                 37     37                                         MUI005
     D  I#PTY2                38     72                                         MUI005
     D  I#CCY                 73     75                                         MUI005
     D  O#CUST                76     81                                         MUI005
      *                                                                   MUI005
      *  SEND MESSAGE DATA STRUCTURE                                      MUI005
      *                                                                   MUI005
     D DBDTA           DS                                                       MUI005
     D  W0PGM                  1     10                                         MUI005
     D  W0FILE                11     20                                         MUI005
     D  W0KEY                 21     50                                         MUI005
     D  W0ERNB                51     55  0                                      MUI005
     D  W0NARR                56    135                                         MUI005
     D  W0STK                136    145                                         MUI005
     D  W0PREF               146    175                                         MUI005
      *                                                                   MUI005
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
     D  F1MODL                10     12
     D  F1DEAL                13     27
     D  F1CUST                28     33  0
     D  F1PCCY                34     36
     D  F1DDAT                37     44
     D  F1VDAT                45     52
     D  F1SCCY                53     55
     D  F1PAMT                56     74
     D********                               75  78 F1FILL                MUI011
     D  F1BOKC                75     76                                         MUI011
     D  F1CLSS                77     77                                         MUI011
     D  F1FILL                78     78                                         MUI011
      *
      ** Detail Record 2
      *
     D DET002          DS
     D  F2PROG                 1      3
     D  F2SAMT                 4     22
     D  F2SPFF                23     23
     D  F2TRTP                24     24
     D  F2LKRF                25     30  0
     D  F2RTEX                31     43  8
     D  F2BCCY                44     46
     D  F2NGVL                47     65
     D  F2FILL                66     78
      *
      ** Detail Record 3
      *
     D DET003          DS
     D  F3PROG                 1      3
     D  F3PSVL                 4     22
     D  F3VLAT                23     26  0
     D  F3FPAT                27     30  0
     D  F3FSAT                31     34  0
     D  F3FPPA                35     38  0
     D  F3FPSA                39     42  0
     D  F3SMCY                43     45
     D  F3TSWM                46     64
     D  F3FILL                65     78
      *
      ** Detail Record 4
      *
     D DET004          DS
     D  F4PROG                 1      3
     D  F4ASWM                 4     22
     D  F4USMA                23     26  0
     D  F4MTCD                27     27
     D  F4SODN                28     33  0
     D  F4BSP1                34     37  0
     D  F4BSP2                38     41  0
     D  F4BSP3                42     45  0
     D  F4BSP4                46     49  0
     D  F4BSP5                50     53  0
     D  F4BSP6                54     57  0
     D  F4DTYP                58     60                                         CHG002
     D  F4DLST                61     63                                         CHG002
     D**********                             58  78 F4FILL                CHG002
     D  F4FILL                64     78                                         CHG002
      *
      ** Detail Record 5                                                  CM00036425
      *                                                                   CM00036425
     D DET005          DS                                                       CM00036425
     D  F5PROG                 1      3                                         CM00036425
     D  F5MXTN                 4     28                                         CM00036425
     D******                                 29  78 F5FILL                CM00062206
     D  F5R306                29     29                                         CM00062206
     D  F5FILL                30     78                                         CM00062206
      *
     D FTDET1          DS
     D  U1PROG                 1      3
     D  U1BKCD                 4      6
     D  U1BRCD                 7      9
     D  U1MODL                10     12
     D  U1DEAL                13     27
     D  U1CUST                28     33  0
     D  U1PCCY                34     36
     D  U1DDAT                37     44
     D  U1VDAT                45     52
     D  U1SCCY                53     55
     D  U1PAMT                56     74
     D********                               75  78 U1FILL                MUI011
     D  U1BOKC                75     76                                         MUI011
     D  U1CLSS                77     77                                         MUI011
     D  U1FILL                78     78                                         MUI011
      *
      ** Detail Record 2
      *
     D FTDET2          DS
     D  U2PROG                 1      3
     D  U2SAMT                 4     22
     D  U2SFLG                23     23
     D  U2TYPE                24     24
     D  U2LKRF                25     30  0
     D  U2RTEX                31     43  8
     D  U2BCCY                44     46
     D  U2NGVL                47     65
     D  U2FILL                66     78
      *
      ** Detail Record 3
      *
     D FTDET3          DS
     D  U3PROG                 1      3
     D  U3PVBC                 4     22
     D  U3VATC                23     26  0
     D  U3FPAT                27     30  0
     D  U3FSAT                31     34  0
     D  U3FPPA                35     38  0
     D  U3FPSA                39     42  0
     D  U3SMCY                43     45
     D  U3TSWM                46     64
     D  U3FILL                65     78
      *
      ** Detail Record 4
      *
     D FTDET4          DS
     D  U4PROG                 1      3
     D  U4ASWM                 4     22
     D  U4USMA                23     26  0
     D  U4MCDE                27     27
     D  U4SODN                28     33  0
     D  U4BSP1                34     37  0
     D  U4BSP2                38     41  0
     D  U4BSP3                42     45  0
     D  U4BSP4                46     49  0
     D  U4BSP5                50     53  0
     D  U4BSP6                54     57  0
     D  U4PYTP                58     60                                         CHG002
     D  U4PYST                61     63                                         CHG002
     D  U4FILL                64     78                                         CHG002
      *
      ** Detail Record 5                                                  CM00036425
      *                                                                   CM00036425
     D FTDET5          DS                                                       CM00036425
     D  U5PROG                 1      3                                         CM00036425
     D  U5FILL                 4     78                                         CM00036425
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
     D  @ACFL1                 1      2
     D  @ACFL2                 3      3
     D  @ACFL3                 4      5
     D  @ACFIL                 6      8
     D  @ACFL4                 9     10
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
      *
     IOTPAYDDF
      ** RENAME FILE RATE AS IT IS ALREADY DEFINED IN PGM
     I              RATE                        ZRATE
      *
     IINPAYDDF
      ** RENAME FILE RATE AS IT IS ALREADY DEFINED IN PGM
     I              RATE                        ZRATE
      *                                                                   MUI008
     ICQCOCDDF                                                                  MUI008
     I              RATE                        ZRATE                           MUI008
     I              CDRO                        XXCDRO                                         LUC01
      *                                                                   MUI008
     ICQCODDDF                                                                                LUC109
     I              RCCO                        XXRCCO                                        LUC109
     ICQPACDDF                                                                                LUC109
     I              SNCO                        XXSNCO                                        LUC109
     ICQPADDDF                                                                  MUI008
     I              RATE                        ZRATE                           MUI008
     I              CDRO                        XXCDRO                                         LUC01
      *
     IFWDRTE    NS  50    1 CD
      **  Forward Rates File - DETAIL Record
      *
     I                                  1    1  RECI
     I                                  2    4  CCY
     I                             P    5   79  DFW
     I                             P   80  254  RFW
     I                             P  255  257 0LCD
     I                                258  258  CHTP
     I                             P  259  261 0TNLU
      *
      **  Catchall for deleted records
      *
     IFWDRTE    NS
      *
      *
      ** Rename duplicate fields
      *
     IDEALSDGF
     I              DLNO                        XXDLNO
     I              DTYP                        XXDTYP
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
      *
      ** Key list for chain to FWDRTFE
     C     UEKEY1        KLIST
     C                   KFLD                    UECCY             3
     C                   KFLD                    UEDFW            75
      *
      ***Key*list*for*chain*to*GZFXDLL1********************CM00036425**                       LUC109
     C*****MXKEY         KLIST                                                     CM00036425 LUC109
     C**********         KFLD                    WZONE                             CM00036425 LUC109
     C**********         KFLD                    CHDLNO                            CM00036425 LUC109
      *                                                    CM00036425
     C                   MOVEL     'LONDON'      WZONE            10            CM00036425
      *                                                    CM00036425
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
      *
     C                   READ      SDDEALPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '008'         DBASE                          ***************
     C                   MOVEL     'SDDEALPD'    DBFILE                         * DB ERR  008 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
      *
      * Access Currency File
     C     BJCYCD        CHAIN     SDCURRL0                           98
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '010'         DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DB ERR  010 *
     C                   MOVEL     BJCYCD        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        BCCDP             1 0
      *                                                                   CEU011
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       F1FILL
     C                   MOVE      *BLANKS       F2FILL
     C                   MOVE      *BLANKS       F3FILL
     C                   MOVE      *BLANKS       F4FILL
     C                   MOVE      *BLANKS       F5FILL                         CM00036425
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         F1PROG
     C                   MOVE      '002'         F2PROG
     C                   MOVE      '003'         F3PROG
     C                   MOVE      '004'         F4PROG
     C                   MOVE      '005'         F5PROG                         CM00036425
     C                   MOVE      'FX '         F1MODL
     C                   MOVE      *BLANKS       @ACFIL
     C                   MOVE      '001'         U1PROG
     C                   MOVE      '002'         U2PROG
     C                   MOVE      '003'         U3PROG
     C                   MOVE      '004'         U4PROG
     C                   MOVE      '005'         U5PROG                         CM00036425
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FEIMC'       FEXFL
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
     C                   WRITE     FEIMCF
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
     C                   WRITE     FEIMCF
     C                   ADD       1             COUNT
      *
     C                   MOVE      A8CMCD        F1BKCD
     C                   MOVE      FBRCD         F1BRCD
     C                   MOVE      '05'          RECC                                      A
     C                   MOVE      A8CMCD        U1BKCD                                        MUI00
     C                   MOVE      FBRCD         U1BRCD                                        MUI00
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FEIMCF
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
      * Read all Deals for the branch
      *
     C     FBRCD         SETLL     DEALBR
     C     FBRCD         READE     DEALBR                                 21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *                                                                   195842
      * Only read deals which are not reversed.                           195842
      *                                                                   195842
     C     RECI          IFNE      'R'                                                         19584
      *                                                                   MUI009
      * For FX Options use 'Option To Date' as Value Date                 MUI009
      *                                                                   MUI009
     C     DTYP          IFEQ      'OP'                                                        MUI00
     C                   Z-ADD     OTDT          VDAT                                          MUI00
     C                   ENDIF                                                                 MUI00
      *
      * Only read deals which were live this month
      *
     C     VDAT          IFGT      MPEMB
     C     OTDT          ORGT      MPEMB                                                       MMI04
      *
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        DATA
     C                   WRITE     FEIMCF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S202
      *
      *  Write Detail Record 2
     C                   MOVE      DET002        DATA
     C                   WRITE     FEIMCF
     C                   ADD       1             COUNT
      *
     C                   EXSR      #S203
      *
      *  Write Detail Record 3
     C                   MOVE      DET003        DATA
     C                   WRITE     FEIMCF
     C                   ADD       1             COUNT
      *
     C                   EXSR      #S204
      *
      *  Write Detail Record 4
     C                   MOVE      DET004        DATA
     C                   WRITE     FEIMCF
     C                   ADD       1             COUNT
      *                                                    CM00036425
     C                   EXSR      #S205                                        CM00036425
      *                                                    CM00036425
      *  Write Detail Record 5                             CM00036425
     C                   MOVE      DET005        DATA                           CM00036425
     C                   WRITE     FEIMCF                                       CM00036425
     C                   ADD       1             COUNT                          CM00036425
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                               195842
      *  Read Next record
     C     FBRCD         READE     DEALBR                                 21
      *
      *
     C                   ENDDO
      *
      * Read all Outgoing Payments for the branch.                        MUI005
      *                                                                   MUI005
     C     FBRCD         SETLL     OTPAYBB                                                     MUI00
     C     FBRCD         READE     OTPAYBB                                21                   MUI00
      *                                                                   MUI005
      *                                                                   MUI005
     C     *IN21         DOWEQ     *OFF                                         Until eof      MUI00
      *                                                                   MUI005
      * Only process Foreign Exchange Transactions.                       MUI005
      *                                                                   MUI005
     C***********PCCY      IFNE SMCY                                MUI005EFIXGS
      *                                                                   MUI005
      * Only read Outgoing Payments which were live this month            MUI005
      *                                                                   MUI005
     C     PVDT          IFGT      MPEMB                                                       MUI00
     C     OEDT          ORGT      MPEMB                                                       20397
     C     SLDT          ORGT      MPEMB                                                       20397
      *                                                                   MUI005
     C                   EXSR      #FT01                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 1                                            MUI005
     C                   MOVE      FTDET1        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
      *                                                                   MUI005
     C                   EXSR      #FT02                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 2                                            MUI005
     C                   MOVE      FTDET2        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
     C                   EXSR      #FT03                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 3                                            MUI005
     C                   MOVE      FTDET3        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
     C                   EXSR      #FT04                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 4                                            MUI005
     C                   MOVE      FTDET4        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   CM00036425
     C                   EXSR      #FT05                                                       CM000
      *                                                                   CM00036425
      *  Write Detail Record 5                                            CM00036425
     C                   MOVE      FTDET5        DATA                                          CM000
     C                   WRITE     FEIMCF                                                      CM000
     C                   ADD       1             COUNT                                         CM000
      *                                                                   CM00036425
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C***********          ENDIF                                    MUI005EFIXGS
      *                                                                   MUI005
      *  Read Next record                                                 MUI005
     C     FBRCD         READE     OTPAYBB                                21                   MUI00
      *                                                                   MUI005
      *                                                                   MUI005
     C                   ENDDO                                                                 MUI00
      *                                                                   MUI005
      *                                                                   MUI005
      * Read all Incoming Payments for the branch                         MUI005
      *                                                                   MUI005
     C     FBRCD         SETLL     INPAYBB                                                     MUI00
     C     FBRCD         READE     INPAYBB                                21                   MUI00
      *                                                                   MUI005
      *                                                                   MUI005
     C     *IN21         DOWEQ     *OFF                                         Until eof      MUI00
      *                                                                   MUI005
      * Only process Foreign Exchange Transactions.                       MUI005
      *                                                                   MUI005
     C***********PCCY      IFNE SMCY                                MUI005EFIXGS
      *                                                                   MUI005
      * Only read Incoming Payments which were live this month            MUI005
      *                                                                   MUI005
     C     SLDT          IFGT      MPEMB                                                       MUI00
     C     OEDT          ORGT      MPEMB                                                       20397
     C     PVDT          ORGT      MPEMB                                                       20397
      *                                                                   MUI005
     C                   EXSR      #FT01                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 1                                            MUI005
     C                   MOVE      FTDET1        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
      *                                                                   MUI005
     C                   EXSR      #FT02                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 2                                            MUI005
     C                   MOVE      FTDET2        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
     C                   EXSR      #FT03                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 3                                            MUI005
     C                   MOVE      FTDET3        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
     C                   EXSR      #FT04                                                       MUI00
      *                                                                   MUI005
      *  Write Detail Record 4                                            MUI005
     C                   MOVE      FTDET4        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI005
      *  Write Detail Record 5                                            CM00036425
     C                   MOVE      FTDET5        DATA                                          CM000
     C                   WRITE     FEIMCF                                                      CM000
     C                   ADD       1             COUNT                                         CM000
      *                                                                   CM00036425
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C***********          ENDIF                                    MUI005EFIXGS
      *                                                                   MUI005
      *  Read Next record                                                 MUI005
     C     FBRCD         READE     INPAYBB                                21                   MUI00
      *                                                                   MUI005
      *                                                                   MUI005
     C                   ENDDO                                                                 MUI00
      *                                                                   MUI008
      * Read all Cheques to be Collected for the branch.                  MUI008
      *                                                                   MUI008
     C     FBRCD         SETLL     CQCODBB                                                     MUI00
     C     FBRCD         READE     CQCODBB                                21                   MUI00
      *                                                                   MUI008
     C     *IN21         DOWEQ     *OFF                                                        MUI00
      *                                                                   MUI008
      * Only output Credit side (one record per credit item)              MUI008
      *                                                                   MUI008
     C     CQSQ          IFNE      *ZERO                                                       MUI00
      *                                                                   MUI008
      * Only process Cheques which were live this month                   MUI008
      *                                                                   MUI008
     C     CRVD          IFGT      MPEMB                                                       MUI00
     C     OEDT          ORGT      MPEMB                                                       MUI00
     C     SLDT          ORGT      MPEMB                                                       MUI00
      *                                                                   MUI008
      * Move CC fields into corresponding IN fields                       MUI008
      *                                                                   MUI008
     C                   MOVE      CQSQ          PREF                                          MUI00
     C                   Z-ADD     CQAM          SMAM                                          MUI00
     C                   Z-ADD     CRVD          PVDT                                          MUI00
     C                   MOVE      CRCY          PCCY                                          MUI00
     C                   Z-ADD     CCYAM         PYAM                                          MUI00
     C                   Z-ADD     PBCQ          SBCQ                                          MUI00
      *                                                                   MUI008
     C                   EXSR      #FT01                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 1                                            MUI008
     C                   MOVE      FTDET1        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
      *                                                                   MUI008
     C                   EXSR      #FT02                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 2                                            MUI008
     C                   MOVE      FTDET2        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
     C                   EXSR      #FT03                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 3                                            MUI008
     C                   MOVE      FTDET3        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
     C                   EXSR      #FT04                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 4                                            MUI008
     C                   MOVE      FTDET4        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
      *  Write Detail Record 5                                            CM00036425
     C                   MOVE      FTDET5        DATA                                          CM000
     C                   WRITE     FEIMCF                                                      CM000
     C                   ADD       1             COUNT                                         CM000
      *                                                                   CM00036425
     C                   ENDIF                                                                 MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI008
      *  Read Next record                                                 MUI008
     C     FBRCD         READE     CQCODBB                                21                   MUI00
      *                                                                   MUI008
      *                                                                   MUI008
     C                   ENDDO                                                                 MUI00
      *                                                                   MUI008
      * Read all Cheques to be Paid for the branch.                       MUI008
      *                                                                   MUI008
     C     FBRCD         SETLL     CQPACBB                                                     MUI00
     C     FBRCD         READE     CQPACBB                                21                   MUI00
      *                                                                   MUI008
     C     *IN21         DOWEQ     *OFF                                                        MUI00
      *                                                                   MUI008
      * Only output Credit side (one record per credit item)              MUI008
      *                                                                   MUI008
     C     CQSQ          IFNE      *ZERO                                                       MUI00
      *                                                                   MUI008
      * Only process Cheques which were live this month                   MUI008
      *                                                                   MUI008
     C     DRVD          IFGT      MPEMB                                                       MUI00
     C     OEDT          ORGT      MPEMB                                                       MUI00
     C     PVDT          ORGT      MPEMB                                                       MUI00
      *                                                                   MUI008
      * Move CC fields into corresponding IN fields                       MUI008
      *                                                                   MUI008
     C                   MOVE      CQSQ          PREF                                          MUI00
     C                   Z-ADD     CQAM          PYAM                                          MUI00
     C                   Z-ADD     DRVD          SLDT                                          MUI00
     C                   MOVE      DRCY          SMCY                                          MUI00
     C                   Z-ADD     PDDRAM        SMAM                                          MUI00
      *                                                                   MUI008
     C                   EXSR      #FT01                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 1                                            MUI008
     C                   MOVE      FTDET1        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
      *                                                                   MUI008
     C                   EXSR      #FT02                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 2                                            MUI008
     C                   MOVE      FTDET2        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
     C                   EXSR      #FT03                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 3                                            MUI008
     C                   MOVE      FTDET3        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
     C                   EXSR      #FT04                                                       MUI00
      *                                                                   MUI008
      *  Write Detail Record 4                                            MUI008
     C                   MOVE      FTDET4        DATA                                          MUI00
     C                   WRITE     FEIMCF                                                      MUI00
     C                   ADD       1             COUNT                                         MUI00
      *                                                                   MUI008
      *  Write Detail Record 5                                            CM00036425
     C                   MOVE      FTDET5        DATA                                          CM000
     C                   WRITE     FEIMCF                                                      CM000
     C                   ADD       1             COUNT                                         CM000
      *                                                                   CM00036425
     C                   ENDIF                                                                 MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI008
      *  Read Next record                                                 MUI008
     C     FBRCD         READE     CQPACBB                                21                   MUI00
      *                                                                   MUI008
      *                                                                   MUI008
     C                   ENDDO                                                                 MUI00
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S201  -  Set up Detail records 1                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #S201         BEGSR
      *
      * Deal Number
     C                   MOVEL     DLNO          F1DEAL
      * Customer Number
     C                   Z-ADD     CNUM          F1CUST
      * Purchase Currency
     C                   MOVE      PUCY          F1PCCY
      * Deal Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    DDAT
     C*                    PARM           F1DDAT
     C                   PARM      *ZERO         W1DDAT            8 0
     C                   MOVE      W1DDAT        F1DDAT
      * Value Date
     C********** DTYP      IFEQ 'OP'                                MMI043MUI009
     C**********           Z-ADDOTDT      EDAT    50                MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
     C**********           Z-ADDVDAT      EDAT                      MMI043MUI009
     C**********           END                                      MMI043MUI009
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C**********           PARM           VDAT                            MMI043
     C**********           PARM           EDAT                      MMI043MUI009
     C                   PARM                    VDAT                                          MUI00
     C                   PARM      *ZERO         W1VDAT            8 0
     C                   MOVE      W1VDAT        F1VDAT
      * Sale Currency
     C                   MOVE      SLCY          F1SCCY
      * Purchase Amount
     C     PUCY          IFNE      *BLANKS
     C                   Z-ADD     PUAM          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F1PCCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F1PAMT
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      PUCY          REPCCY
     C                   Z-ADD     PUAM          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F1PAMT
     C                   ELSE
      *
     C                   MOVEL     '+'           F1PAMT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *BLANKS       F1PAMT
     C                   ENDIF
      * Book Code                                                         MUI011
     C                   MOVE      BOKC          F1BOKC                                        MUI01
      * CLS Indicator                                                     MUI011
     C                   MOVE      'N'           F1CLSS                                        MUI01
     C     CLSS          IFEQ      'Y'                                                         MUI01
     C                   MOVE      CLSS          F1CLSS                                        MUI01
     C                   ENDIF                                                                 MUI01
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S202  -  Set up Detail records 2                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #FWDVL #ERR                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S202         BEGSR
      *
      * Sale Amount
     C     SLCY          IFNE      *BLANKS
     C                   Z-ADD     SLAM          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F1SCCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F2SAMT
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S202'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      SLCY          REPCCY
     C                   Z-ADD     SLAM          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F2SAMT
     C                   ELSE
     C                   MOVEL     '-'           F2SAMT
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F2SAMT
     C                   ENDIF
      *
      * Spot/Forward Flag
     C                   Z-ADD     3             NODAYS            2 0
     C**********         CALL      'GLM043'                                                   LUC109
     C                   CALL      'XX000043'                                                 LUC109
     C                   PARM                    DDAT
     C                   PARM                    NODAYS
     C                   PARM                    BJCYCD
     C                   PARM      *BLANKS       @LOC              3            Locn-optionl
     C                   PARM                    @@VDAT            5 0
     C     VDAT          IFLE      @@VDAT
     C                   MOVE      '1'           F2SPFF
     C                   ELSE
     C                   MOVE      '2'           F2SPFF
     C                   ENDIF
      *
      * Type Of Transaction
     C     DTYP          IFEQ      'SW'
      *
     C     LNKDN         CHAIN     DEALSG                             30
      *
     C     *IN30         IFEQ      *OFF
     C     XXDTYP        ANDEQ     'RX'
      *
     C                   MOVE      '2'           F2TRTP
      *
     C                   ELSE
      *
     C                   MOVE      '1'           F2TRTP
      *
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      '0'           F2TRTP
     C                   ENDIF
      *
      * Link Reference Number
     C                   Z-ADD     LNKDN         F2LKRF
      *
      * Rate of Exchange
     C                   Z-ADD     EXRT          F2RTEX
      *
      * Base Currency Code
     C                   MOVE      BJCYCD        F2BCCY
      *
      * Determine PURCHASE FORWARD VALUE
     C                   EXSR      #FWDVL
      *
      * PURCHASE FORWARD VALUE IN Base Currency
      *                                                                   MMI043
     C********** DTYP      IFEQ 'OP'                                MMI043MUI009
     C********** OTDT      IFLE MLACD                               MMI043206327
     C********** OTDT      IFLT BJDNWD                              206327MUI009
     C********** OTDT      ANDGTMPEMB                               MMI043MUI009
     C********** WCCY      OREQ BJCYCD                              MMI043MUI009
     C**********           Z-ADD0         PUVL                      MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
     C***********BCEQ      SUB  @FWVL     PUVLV  150                MMI043196659
     C***********BCEQ      SUB  @FWVL2    PUVLO  150                MMI043196659
     C***********PUVLO     COMP PUVLV                565555         MMI043196659
     C***55******          Z-ADDPUVLO     PUVL                      MMI043196659
     C***56******          Z-ADDPUVLV     PUVL                      MMI043196659
     C********** BCEQ      SUB  @FWVL2    PUVL   150                196659MUI009
     C**********           END                                      MMI043MUI009
      **********                                                    MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
      **********                                                    MMI043MUI009
     C***********VDAT      IFLE MLACD                                     206327
     C     VDAT          IFLT      BJDNWD                                                      20632
     C***********VDAT      ANDGTMPEMB                                     202688
     C                   Z-ADD     0             PUVL
     C                   ELSE
     C     BCEQ          SUB       @FWVL         PUVL             15 0
     C                   ENDIF
     C**********           END                                      MMI043MUI009
      *                                                                   MMI043
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F2BCCY
     C                   PARM                    PUVL
     C                   PARM                    F2NGVL
     C                   PARM                    IERROR
      *
     C     PUVL          IFLT      0                                            Ended in error
     C                   MOVEL     '-'           F2NGVL
     C                   ELSE
     C                   MOVEL     '+'           F2NGVL
     C                   ENDIF
     C*
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S203  -  Set up Detail records 3                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ACKEY #ERR                                       *
      *                                                               *
      *****************************************************************
      *
     C     #S203         BEGSR
      *
      * SALE     Value in Base Currency
     C                   EXSR      #SFDVL
      *                                                                   MMI043
      * SALE FORWARD VALUE IN Base Currency
      *                                                                   MMI043
     C********** DTYP      IFEQ 'OP'                                MMI043MUI009
     C***********OTDT      IFLE MLACD                               MMI043206327
     C********** OTDT      IFLT BJDNWD                              206327MUI009
     C********** OTDT      ANDGTMPEMB                               MMI043MUI009
     C********** WCCY      OREQ BJCYCD                              MMI043MUI009
     C**********           Z-ADD0         SUVL                      MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
     C********** BCEQ      SUB  @SFVL     SUVLV  150                MMI043MUI009
     C********** BCEQ      SUB  @SFVL2    SUVLO  150                MMI043MUI009
     C********** SUVLO     COMP SUVLV                565555         MMI043MUI009
     C***55*****           Z-ADDSUVLO     SUVL                      MMI043MUI009
     C***56*****           Z-ADDSUVLV     SUVL                      MMI043MUI009
     C**********           END                                      MMI043MUI009
      **********                                                    MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
      **********                                                    MMI043MUI009
     C***********VDAT      IFLE MLACD                                     206327
     C     VDAT          IFLT      BJDNWD                                                      20632
     C***********VDAT      ANDGTMPEMB                                     202688
     C                   Z-ADD     0             SUVL
     C                   ELSE
     C     BCEQ          SUB       @SFVL         SUVL             15 0
     C                   ENDIF
     C**********           END                                      MMI043MUI009
      *                                                                   MMI043
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F2BCCY
     C                   PARM                    SUVL
     C                   PARM                    F3PSVL
     C                   PARM                    IERROR
      *
     C     SUVL          IFLT      0                                            Ended in error
     C                   MOVEL     '+'           F3PSVL
     C                   ELSE
     C                   MOVEL     '-'           F3PSVL
     C                   ENDIF
      *
      * Valuation Account Type Code
     C     BNFRPL        IFNE      *BLANKS
     C                   MOVE      BNFRPL        F3VLAT
     C                   ELSE
     C                   Z-ADD     *ZERO         F3VLAT
     C                   ENDIF
      *                          \
      * Set up Standard part of account Key
     C                   MOVE      DTYP          @ACFL1
     C     DTYP          IFEQ      'OT'
     C                   MOVE      'OP'          @ACFL1
     C                   ENDIF
     C                   MOVE      DLST          @ACFL3
     C                   MOVE      'D'           @ACFL2
      *
      * Access appropriate Account Key for Purchase details
     C     PUCY          IFEQ      BJCYCD
     C                   MOVE      'BB'          @ACFL4
     C                   ELSE
     C                   MOVE      'FB'          @ACFL4
     C                   ENDIF
     C                   EXSR      #ACKEY
      *
      * Forward Purchases Account Type Code
     C                   Z-ADD     @@ACC1        F3FPAT
      *
      * Forward Position Purchases Account Type Code
     C                   Z-ADD     @@ACC2        F3FPPA
      *
      * Access appropriate Account Key for Sale details
     C     SLCY          IFEQ      BJCYCD
     C                   MOVE      'BC'          @ACFL4
     C                   ELSE
     C                   MOVE      'FC'          @ACFL4
     C                   ENDIF
     C                   EXSR      #ACKEY
      *
      * Forward Position Sales Account Type Code
     C                   Z-ADD     @@ACC1        F3FPSA
      *
      * Forward Sales Account Type Code
     C                   Z-ADD     @@ACC2        F3FSAT
      *
      * Swap Margin Currency Code
     C                   MOVE      SPLC          F3SMCY
      *
      * Total Swap Margin
     C     SPLC          IFNE      *BLANKS
     C                   Z-ADD     SPLA          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F3SMCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F3TSWM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S203'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      SPLC          REPCCY
     C                   Z-ADD     SPLA          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   MOVE      *BLANKS       F3TSWM
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F3TSWM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S204  -  Set up Detail records 4                            *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ACKEY #BSPL #ERR                                 *
      *                                                               *
      *****************************************************************
      *
     C     #S204         BEGSR
      *
      * Accrued Swap Margin
     C     SPLC          IFNE      *BLANKS
     C                   Z-ADD     SPPD          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F3SMCY
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F4ASWM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#S204'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      SPLC          REPCCY
     C                   Z-ADD     SPPD          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      *BLANKS       F4ASWM
     C                   ENDIF
      *
      * Only of deal type is swap                                      ?
     C     DTYP          IFEQ      'SW'
      *
      * Access appropriate Account Key
     C     SPLA          IFLT      *ZERO
     C                   MOVE      ' L'          @ACFL4
     C                   ELSE
     C                   MOVE      ' H'          @ACFL4
     C                   ENDIF
     C                   EXSR      #ACKEY
      *
      * Unrealised Swap Margin Profit or Loss Account Type Code        ?
     C     SPLA          IFGE      *ZERO
     C                   Z-ADD     @@ACC2        F4USMA
     C                   ELSE
     C                   Z-ADD     @@ACC1        F4USMA
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         F4USMA
     C                   ENDIF
      *
      * Maturity Code
     C     VDAT          IFLE      MLACD
     C***********VDAT      ANDGTMPEMB                                     202688
     C                   MOVE      '0'           F4MTCD
     C                   ELSE
     C                   MOVE      '1'           F4MTCD
     C                   ENDIF
      ***********                                                   174511MUI009
      **For*Option deals, maturity code should be updated           174511MUI009
      ***based*on Option to Date field.                             174511MUI009
     C***********DTYP      IFEQ 'OP'                                174511MUI009
     C***********OTDT      IFLE MLACD                               174511MUI009
     C***********OTDT      ANDGTMPEMB                               174511MUI009
     C***********          MOVE '0'       F4MTCD                    174511MUI009
     C***********          ELSE                                     174511MUI009
     C***********          MOVE '1'       F4MTCD                    174511MUI009
     C***********          ENDIF                                    174511MUI009
     C***********          ENDIF                                    174511MUI009
      *
      * Swap Option Deal Number
     C                   Z-ADD     SODN          F4SODN
      *
      * BSPL Code 1
     C                   Z-SUB     1             @@BAL            15 0
     C                   MOVE      F3VLAT        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP1
      *
      * BSPL Code 2
     C                   Z-SUB     1             @@BAL
     C                   MOVE      F3FPAT        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP2
      *
      * BSPL Code 3
     C                   Z-ADD     1             @@BAL
     C                   MOVE      F3FSAT        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP3
      *
      * BSPL Code 4
     C                   Z-ADD     1             @@BAL
     C                   MOVE      F3FPPA        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP4
      *
      * BSPL Code 5
     C                   Z-SUB     1             @@BAL
     C                   MOVE      F3FPSA        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP5
      *
      * BSPL Code 6
     C                   Z-ADD     SPLA          @@BAL
     C                   MOVE      F4USMA        XXACCD
     C                   EXSR      #BSPL
     C                   Z-ADD     FBSPL         F4BSP6
      *                                                                   CHG002
      * Deal Type, Subtype                                                CHG002
     C                   MOVEL     DTYP          F4DTYP                                        CHG00
     C                   MOVEL     DLST          F4DLST                                        CHG00
      *
     C                   ENDSR
      *****************************************************************   CM00036425
      *                                                               *   CM00036425
      *  #S205  -  Set up Detail records 5                            *   CM00036425
      *                                                               *   CM00036425
      *  Called By: #S200                                             *   CM00036425
      *  Calls:                                                       *   CM00036425
      *                                                               *   CM00036425
      *****************************************************************   CM00036425
      *                                                                   CM00036425
     C     #S205         BEGSR                                                                 CM000
      *                                                                   CM00036425
      * F5MXTN = Murex transaction ID                                     CM00036425
      * F5R306 = R306  Netting Agreement                                  CM00062206
      *                                                                   CM00036425
     C                   MOVE      *BLANK        F5MXTN                                        CM000
     C                   MOVE      *BLANK        F5R306                                        CM000
      *                                                                   CM00036425
     C**********         MOVE      DLNO          CHDLNO            6                    CM000 LUC109
     C*****MXKEY         CHAIN     GZFXDLL1                           91                      LUC109
     C**N91*****         MOVE      MXTRNO        F5MXTN                                       LUC109
     C**N91*****         MOVE      R306          F5R306                                       LUC109
     C                   Z-ADD     DLNO          CHDLNO            6 0                        LUC109
     C     CHDLNO        CHAIN     DEALSBY0                           91                      LUC109
     C     *IN91         IFEQ      '0'                                                        LUC109
     C                   MOVE      MXTRNO        F5MXTN                                       LUC109
     C                   MOVE      MXNTAF        F5R306                                       LUC109
     C                   ENDIF                                                                LUC109
      *                                                                   CM00036425
     C                   ENDSR                                                                 CM000
      *                                                                   CM00036425
      *****************************************************************   MUI005
      *                                                               *   MUI005
      *  #FT01 - Set up detail record 1 FT.                               MUI005
      *                                                               *   MUI005
      *  Called By: #PROC                                             *   MUI005
      *  Calls:     #PSSR                                             *   MUI005
      *                                                               *   MUI005
      *****************************************************************   MUI005
      *                                                                   MUI005
     C     #FT01         BEGSR                                                                 MUI00
      *                                                                   MUI005
x     * Module Code                                                       MUI005
     C                   MOVEL     'FX'          U1MODL                                        MUI00
      * Deal Number                                                       MUI005
     C                   MOVEL     PREF          U1DEAL                                        MUI00
      * Purchace Currency Code                                            MUI005
     C                   MOVE      SMCY          U1PCCY                                        MUI00
      * Deal Date                                                         MUI005
     C**********         CALL      'GLM053'                                             MUI00 LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    OEDT                                          MUI00
     C*                    PARM           U1DDAT                          MUI005
     C                   PARM      *ZERO         W1DDAT            8 0                         MUI00
     C                   MOVE      W1DDAT        U1DDAT                                        MUI00
      **********                                                    MUI005203973
      **IF*the*payment type is Outgoing Payment.                    MUI005203973
      **********                                                    MUI005203973
     C********** PYTP      IFEQ 'OP'                                MUI005203973
     C**********           MOVE PVDT      VDAT                      MUI005203973
      **Value*Date                                                  MUI005203973
     C**********           CALL 'GLM053'                            MUI005203973
     C**********           PARM           VDAT                      MUI005203973
     C**********           PARM           U1DDAT                    MUI005203973
     C**********           PARM *ZERO     W1DDAT  80                MUI005203973
     C**********           MOVE W1DDAT    U1VDAT                    MUI005203973
      **Customer Number                                             MUI005203973
     C********** ORCT      IFEQ 'R'                                 MUI005203973
     C**********           MOVELORC1      ACNO                      MUI005203973
     C********** ACNO      CHAINACNUMA               85             MUI005203973
     C**********           MOVE CNUM      U1CUST                    MUI005203973
     C**********           ENDIF                                    MUI005203973
      **********                                                    MUI005203973
     C********** ORCT      IFEQ 'A'                                 MUI005203973
     C**********           MOVELORCT      I#PT1                     MUI005203973
     C**********           MOVELORC1      I#PTY1                    MUI005203973
     C**********           MOVELSMCY      I#CCY                     MUI005203973
     C********** ORBK      IFNE *ZEROS                              MUI005203973
     C**********           MOVE *BLANKS   WORBKC 15                 MUI005203973
     C**********           MOVELORBK      WFLDO  12                 MUI005203973
     C********** WFLDO     CAT  ORBB      WORBKC                    MUI005203973
     C**********           MOVELORBT      I#PT2                     MUI005203973
     C**********           MOVELWORBKC    I#PTY2                    MUI005203973
     C**********           END                                      MUI005203973
      **********                                                    MUI005203973
     C********** ORCT      IFEQ 'P'                                 MUI005203973
     C**********           MOVE *BLANKS   WFLD1  15                 MUI005203973
     C**********           MOVELORC1      WFLD1                     MUI005203973
     C**********           MOVE BJSBRC    WFLD1                     MUI005203973
     C**********           MOVELWFLD1     I#PTY1                    MUI005203973
     C**********           END                                      MUI005203973
     C**********           MOVELSMCY      I#CCY                     MUI005203973
      **********                                                    MUI005203973
     C**********           MOVELSMCY      I#CCY                     MUI005203973
     C**********           CALL 'FT0035'               9090         MUI005203973
     C**********           PARM *BLANKS   @RTRN                     MUI005203973
     C**********           PARM           W0DTA                     MUI005203973
     C**********           PARM           W0MSG 256                 MUI005203973
     C********** *IN90     IFEQ '1'                                 MUI005203973
     C********** @RTRN     ORNE *BLANKS                             MUI005203973
     C**********           MOVEL'FT0035  'W0FILE           ************005203973
     C**********           MOVEL'*CALL   'W0KEY            * DBERR 34U*005203973
     C**********           Z-ADD34        W0ERNB           ************005203973
     C**********           EXSR *PSSR                               MUI005203973
     C**********           ELSE                                     MUI005203973
     C**********           MOVELO#CUST    WDCUS2  6                 MUI005203973
     C**********           END                                      MUI005203973
     C**********                                                    MUI005203973
     C**********                                                    MUI005203973
     C**********           CALL 'FT0035'               9090         MUI005203973
     C**********           PARM *BLANKS   @RTRN   7                 MUI005203973
     C**********           PARM           W0DTA                     MUI005203973
     C**********           PARM           W0MSG 256                 MUI005203973
     C**********           MOVELO#CUST    U1CUST                    MUI005203973
     C**********           END                                      MUI005203973
      **********                                                    MUI005203973
     C**********           ELSE                                     MUI005203973
      **********                                                    MUI005203973
      **IF*the*payment type is Incoming Payment.                    MUI005203973
      **********                                                    MUI005203973
     C**********           MOVE PVDT      VDAT                      MUI005203973
      **Value*Date                                                  MUI005203973
     C**********           CALL 'GLM053'                            MUI005203973
     C**********           PARM           VDAT                      MUI005203973
     C**********           PARM           U1DDAT                    MUI005203973
     C**********           PARM *ZERO     W1DDAT  80                MUI005203973
     C**********           MOVE W1DDAT    U1VDAT                    MUI005203973
      **Customer Number                                             MUI005203973
     C********** BNCT      IFEQ 'R'                                 MUI005203973
     C**********           MOVELBNC1      ACNO                      MUI005203973
     C********** ACNO      CHAINACNUMA               85             MUI005203973
     C**********           MOVE CNUM      U1CUST                    MUI005203973
     C**********           ENDIF                                    MUI005203973
      **********                                                    MUI005203973
     C********** BNCT      IFEQ 'A'                                 MUI005203973
     C**********           MOVELBNCT      I#PT1                     MUI005203973
     C**********           MOVELBNC1      I#PTY1                    MUI005203973
     C**********           MOVELSMCY      I#CCY                     MUI005203973
     C**********                                                    MUI005203973
     C********** ACBB      IFNE *ZEROS                              MUI005203973
     C**********           MOVE *BLANKS   WORBKC 15                 MUI005203973
     C********** ACBK      CAT  ACBB      WORBKC                    MUI005203973
     C**********           MOVELACBT      I#PT2                     MUI005203973
     C**********           MOVELWORBKC    I#PTY2                    MUI005203973
     C**********           END                                      MUI005203973
     C**********                                                    MUI005203973
     C**********           CALL 'FT0035'               9090         MUI005203973
     C**********           PARM *BLANKS   @RTRN   7                 MUI005203973
     C**********           PARM           W0DTA                     MUI005203973
     C**********           PARM           W0MSG 256                 MUI005203973
     C**********           MOVELO#CUST    U1CUST                    MUI005203973
     C**********           END                                      MUI005203973
     C**********           END                                      MUI005203973
      *                                                                   203973
      * Value Date                                                        203973
      *                                                                   203973
     C                   MOVE      PVDT          VDAT                                          20397
     C**********         CALL      'GLM053'                                             20397 LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    VDAT                                          20397
     C                   PARM      *ZERO         W1DDAT            8 0                         20397
     C                   MOVE      W1DDAT        U1VDAT                                        20397
      *                                                                   203973
      * Customer Number                                                   203973
      *                                                                   203973
     C                   CLEAR                   W0DTA                                         20397
      *                                                                   203973
     C     PYTP          IFEQ      'OP'                                                        20397
     C                   MOVEL     ORCT          I#PT1                                         20397
     C                   MOVEL     ORC1          I#PTY1                                        20397
     C                   MOVEL     SMCY          I#CCY                                         20397
     C     ORBK          IFNE      *ZEROS                                                      20397
     C                   MOVE      *BLANKS       WORBKC           15                           20397
     C                   MOVEL     ORBK          WFLDO            12                           20397
     C     WFLDO         CAT       ORBB          WORBKC                                        20397
     C                   MOVEL     ORBT          I#PT2                                         20397
     C                   MOVEL     WORBKC        I#PTY2                                        20397
     C                   END                                                                   20397
      *                                                                   203973
     C                   ELSE                                                                  20397
     C                   MOVEL     BNCT          I#PT1                                         20397
     C                   MOVEL     BNC1          I#PTY1                                        20397
     C                   MOVEL     PCCY          I#CCY                                         20397
     C     ACBB          IFNE      *ZEROS                                                      20397
     C                   MOVE      *BLANKS       WORBKC           15                           20397
     C     ACBK          CAT       ACBB          WORBKC                                        20397
     C                   MOVEL     ACBT          I#PT2                                         20397
     C                   MOVEL     WORBKC        I#PTY2                                        20397
     C                   END                                                                   20397
     C                   END                                                                   20397
     C*                                                                   MUI008
     C     PYTP          IFEQ      'CC'                                                        MUI00
     C                   CLEAR                   W0DTA                                         MUI00
     C                   MOVEL     CRPT          I#PT1                                         MUI00
     C                   MOVEL     CRPY          I#PTY1                                        MUI00
     C                   MOVEL     CRCY          I#CCY                                         MUI00
     C                   ENDIF                                                                 MUI00
     C*                                                                   MUI008
     C     PYTP          IFEQ      'CP'                                                        MUI00
     C                   CLEAR                   W0DTA                                         MUI00
     C                   MOVEL     DRPT          I#PT1                                         MUI00
     C                   MOVEL     DRPY          I#PTY1                                        MUI00
     C                   MOVEL     DRCY          I#CCY                                         MUI00
     C                   ENDIF                                                                 MUI00
     C*                                                                   203973
     C*******              CALL 'FT0035'               9090               203973         LUC013
     C                   CALL      'XXFT0035'                           9090
     C                   PARM      *BLANKS       @RTRN             7                           20397
     C                   PARM                    W0DTA                                         20397
     C                   PARM                    W0MSG           256                           20397
     C                   MOVEL     O#CUST        U1CUST                                        20397
      *                                                                   MUI005
      * Sale Currency                                                     MUI005
     C                   MOVE      PCCY          U1SCCY                                        MUI00
      *                                                                   MUI005
      * Puchase Amount                                                    MUI005
      * If Value Date of the Purchace or Sale Currency is already         MUI005
      * matured, then set purchace amount to zero.                        MUI005
      *                                                                   MUI005
     C     BJRDNB        IFGE      SLDT                                                        MUI00
     C                   MOVE      *BLANKS       U1PAMT                                        MUI00
      *                                                                   MUI005
     C                   ELSE                                                                  MUI00
      *                                                                   MUI005
     C     PCCY          IFNE      *BLANKS                                                     MUI00
     C                   Z-ADD     SMAM          @@AMT                                         MUI00
     C                   MOVE      'N'           IERROR            1                           MUI00
     C**********         CALL      'GLM041'                                             MUI00 LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    U1PCCY                                        MUI00
     C                   PARM                    @@AMT            15 0                         MUI00
     C                   PARM                    U1PAMT                                        MUI00
     C                   PARM                    IERROR                                        MUI00
      *                                                                   MUI005
     C     IERROR        IFEQ      'Y'                                          Ended in error MUI00
     C                   MOVE      *BLANKS       REPPRG                                        MUI00
     C                   MOVE      *BLANKS       REPMSG                                        MUI00
     C                   MOVE      *BLANKS       REPKEY                                        MUI00
     C                   MOVE      *BLANKS       REPDTA                                        MUI00
     C                   MOVE      *BLANKS       REPACN                                        MUI00
     C                   MOVEL     F1DEAL        REPACN                                        MUI00
     C                   MOVEL     '#S201'       REPPRG                                        MUI00
     C                   MOVEL     @ERR(1)       REPMSG                                        MUI00
     C                   MOVEL     '*NONE'       REPKEY                                        MUI00
     C                   MOVE      PUCY          REPCCY                                        MUI00
     C                   Z-ADD     PUAM          REPVAL                                        MUI00
     C                   MOVEL     REPAMT        REPDTA                                        MUI00
     C                   EXSR      #ERR                                                        MUI00
     C                   MOVE      *BLANKS       U1PAMT                                        MUI00
     C                   ELSE                                                                  MUI00
      *                                                                   MUI005
     C                   MOVEL     '+'           U1PAMT                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVE      *BLANKS       U1PAMT                                        MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C                   ENDIF                                                                 MUI00
      * Book Code                                                         MUI011
     C                   MOVE      BOKC          U1BOKC                                        MUI01
      * CLS Indicator                                                     MUI011
     C                   MOVE      'N'           U1CLSS                                        MUI01
      *                                                                   MUI005
     C                   ENDSR                                                                 MUI00
      *****************************************************************   MUI005
      *                                                               *   MUI005
      *  #FT02  -  Set up Detail records 2   FT                       *   MUI005
      *                                                               *   MUI005
      *  Called By: #S200                                             *   MUI005
      *  Calls:     #FWDVL #ERR                                       *   MUI005
      *                                                               *   MUI005
      *****************************************************************   MUI005
      *                                                                   MUI005
     C     #FT02         BEGSR                                                                 MUI00
      *                                                                   MUI005
      * Sale Amount                                                       MUI005
      * If Value Date of the Purchace or Sale Currency is already         MUI005
      * matured, then set sale amount to zero.                            MUI005
      *                                                                   MUI005
     C     BJRDNB        IFGE      PVDT                                                        MUI00
     C                   MOVE      *BLANKS       U2SAMT                                        MUI00
      *                                                                   MUI005
     C                   ELSE                                                                  MUI00
      *                                                                   MUI005
     C     PCCY          IFNE      *BLANKS                                                     MUI00
     C                   MOVE      PYAM          @@AMT                                         MUI00
     C                   MOVE      'N'           IERROR            1                           MUI00
     C**********         CALL      'GLM041'                                             MUI00 LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    U1SCCY                                        MUI00
     C                   PARM                    @@AMT            15 0                         MUI00
     C                   PARM                    U2SAMT                                        MUI00
     C                   PARM                    IERROR                                        MUI00
      *                                                                   MUI005
     C     IERROR        IFEQ      'Y'                                          Ended in error MUI00
     C                   MOVE      *BLANKS       REPPRG                                        MUI00
     C                   MOVE      *BLANKS       REPMSG                                        MUI00
     C                   MOVE      *BLANKS       REPKEY                                        MUI00
     C                   MOVE      *BLANKS       REPDTA                                        MUI00
     C                   MOVE      *BLANKS       REPACN                                        MUI00
     C                   MOVEL     F1DEAL        REPACN                                        MUI00
     C                   MOVEL     '#S201'       REPPRG                                        MUI00
     C                   MOVEL     @ERR(1)       REPMSG                                        MUI00
     C                   MOVEL     '*NONE'       REPKEY                                        MUI00
     C                   MOVE      PUCY          REPCCY                                        MUI00
     C                   Z-ADD     PUAM          REPVAL                                        MUI00
     C                   MOVEL     REPAMT        REPDTA                                        MUI00
     C                   EXSR      #ERR                                                        MUI00
     C                   MOVE      *BLANKS       U2SAMT                                        MUI00
     C                   ELSE                                                                  MUI00
      *                                                                   MUI005
     C                   MOVEL     '-'           U2SAMT                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVE      *BLANKS       U2SAMT                                        MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
      * Type of Transaction                                               MUI005
     C                   MOVE      '0'           U2TYPE                                        MUI00
      *                                                                   MUI005
      * Link Reference Number                                             MUI005
     C                   Z-ADD     *ZERO         U2LKRF                                        MUI00
      *                                                                   MUI005
      * Rate of Exchange                                                  MUI005
     C                   MOVE      ZRATE         U2RTEX                                        MUI00
      *                                                                   MUI005
      * Base Currency Code                                                MUI005
     C                   MOVE      BJCYCD        U2BCCY                                        MUI00
      *                                                                   MUI005
      * Spot/Forward Flag                                                 MUI005
     C                   Z-ADD     3             NODAYS            2 0                         MUI00
     C**********         CALL      'GLM043'                                             MUI00 LUC109
     C                   CALL      'XX000043'                                                 LUC109
     C                   PARM                    SLDT                                          MUI00
     C                   PARM                    NODAYS                                        MUI00
     C                   PARM                    BJCYCD                                        MUI00
     C                   PARM      *BLANKS       @LOC                           Locn-optionl   MUI00
     C                   PARM                    @@VDAT                                        MUI00
     C     PVDT          IFLT      @@VDAT                                                      MUI00
     C                   MOVE      '1'           U2SFLG                                        MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVE      '2'           U2SFLG                                        MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
      * Type Of Transaction                                               MUI005
     C                   MOVE      '0'           U2TYPE                                        MUI00
      *                                                                   MUI005
      * Rate of Exchange                                                  MUI005
     C                   Z-ADD     ZRATE         U2RTEX                                        MUI00
      *                                                                   MUI005
      * DETERMINE PURCHASE FORWARD VALUE                                  MUI005
     C                   EXSR      #UFWDV                                                      MUI00
      *                                                                   MUI005
      * Negative Valuation in Base Currency                               MUI005
      *                                                                   MUI005
     C***********          Z-ADD*ZEROS    PUVLV  150                MUI005202688
     C***********          Z-ADD*ZEROS    PUVLO  150                MUI005202688
      *                                                                   MUI005
      * If Purchace amount is zero then negative valuation must be zero   MUI005
     C     U1PAMT        IFEQ      *BLANKS                                                     MUI00
     C                   MOVE      *BLANKS       U2NGVL                                        MUI00
     C                   ELSE                                                                  MUI00
      *                                                                   MUI005
     C***********SLDT      IFLE MLACD                               MUI005206327
     C     SLDT          IFLT      BJDNWD                                                      20632
     C     SLDT          ANDGT     MPEMB                                                       MUI00
     C     PCCY          OREQ      SMCY                                                        19992
     C                   Z-ADD     0             PUVL                                          MUI00
     C                   ELSE                                                                  MUI00
     C***********SBCQ      SUB  @FWVL     PUVLV                     MUI005199924
     C***********SBCQ      SUB  @FWVL2    PUVLO                     MUI005199924
     C***********PUVLO     COMP PUVLV                565555         MUI005199924
     C***55******          Z-ADDPUVLO     PUVL                      MUI005199924
     C***56******          Z-ADDPUVLV     PUVL                      MUI005199924
     C***********SBCQ      SUB  @FWVL     PUVLV                     199924202688
     C     SBCQ          SUB       @FWVL         PUVL                                          20268
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C                   MOVE      'N'           IERROR            1                           MUI00
     C**********         CALL      'GLM041'                                             MUI00 LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    U2BCCY                                        MUI00
     C                   PARM                    PUVL                                          MUI00
     C                   PARM                    U2NGVL                                        MUI00
     C                   PARM                    IERROR                                        MUI00
      *                                                                   MUI005
     C     PUVL          IFLT      0                                            Ended in error MUI00
     C                   MOVEL     '-'           U2NGVL                                        MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVEL     '+'           U2NGVL                                        MUI00
     C                   ENDIF                                                                 MUI00
     C*                                                                   MUI005
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C                   ENDSR                                                                 MUI00
      *****************************************************************   MUI005
      *                                                               *   MUI005
      *  #FT03  -  Set up Detail records 3 FT                         *   MUI005
      *                                                               *   MUI005
      *  Called By: #S200                                             *   MUI005
      *  Calls:     #ACKEY #ERR                                       *   MUI005
      *                                                               *   MUI005
      *****************************************************************   MUI005
      *                                                                   MUI005
     C     #FT03         BEGSR                                                                 MUI00
      *                                                                   MUI005
      * SALE     Value in Base Currency                                   MUI005
     C                   EXSR      #UFTFV                                                      MUI00
      *                                                                   MUI005
      * Positive Valuation IN Base Currency                               MUI005
      *                                                                   MUI005
      * If Sale amount is zero then negative valuation must be zero       MUI005
     C     U2SAMT        IFEQ      *BLANKS                                                     MUI00
     C                   MOVE      *BLANKS       U3PVBC                                        MUI00
     C                   ELSE                                                                  MUI00
      *                                                                   MUI005
     C***********SLDT      IFLE MLACD                               MUI005199924
     C***********SLDT      ANDGTMPEMB                               MUI005199924
     C***********PVDT      IFLE MLACD                               199924206327
     C     PVDT          IFLT      BJDNWD                                                      20632
     C     PVDT          ANDGT     MPEMB                                                       19992
     C     PCCY          OREQ      SMCY                                                        19992
     C                   Z-ADD     0             SUVL                                          MUI00
     C***********          Z-ADD0         SUVLV                     MUI005199924
     C***********          Z-ADD0         SUVLO                     MUI005199924
     C                   ELSE                                                                  MUI00
     C***********PBCQ      SUB  @SFVL     SUVLV                           MUI005
     C***********PBCQ      SUB  @SFVL2    SUVLO                           MUI005
     C***********SBCQ      SUB  @SFVL     SUVLV                     MUI005199924
     C***********SBCQ      SUB  @SFVL2    SUVLO                     MUI005199924
     C***********SUVLO     COMP SUVLV                565555         MUI005199924
     C***55******          Z-ADDSUVLO     SUVL                      MUI005199924
     C***56******          Z-ADDSUVLV     SUVL                      MUI005199924
     C     SBCQ          SUB       @SFVL         SUVL                                          19992
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
     C                   MOVE      'N'           IERROR            1                           MUI00
     C**********         CALL      'GLM041'                                             MUI00 LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    U2BCCY                                        MUI00
     C                   PARM                    SUVL                                          MUI00
     C                   PARM                    U3PVBC                                        MUI00
     C                   PARM                    IERROR                                        MUI00
      *                                                                   MUI005
     C     SUVL          IFLT      0                                            Ended in error MUI00
     C                   MOVEL     '+'           U3PVBC                                        MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVEL     '-'           U3PVBC                                        MUI00
     C                   ENDIF                                                                 MUI00
     C*                                                                   MUI005
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
      * Valuation Account Type Code                                       MUI005
     C     BNFRPL        IFNE      *BLANKS                                                     MUI00
     C                   MOVE      BNFRPL        U3VATC                                        MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVE      *ZERO         U3VATC                                        MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI005
      * Set up Standard part of account Key                               MUI005
     C                   MOVE      *BLANKS       @ACFL1                                        MUI00
     C                   MOVE      *BLANKS       @ACFL3                                        MUI00
     C                   MOVE      *BLANKS       @ACFL2                                        MUI00
      *                                                                   MUI005
     C                   MOVEL     *BLANKS       @ACFL4                                        MUI00
     C                   MOVE      PYTP          @ACFL1                                        MUI00
     C                   MOVE      PYST          @ACFL3                                        MUI00
     C                   MOVE      'D'           @ACFL2                                        MUI00
      *                                                                   MUI005
     C                   MOVE      'R'           @ACFL4                                        MUI00
     C                   EXSR      #ACKEY                                                      MUI00
      *                                                                   MUI005
      * Forward Purchases Account Type Code                               MUI005
     C                   Z-ADD     @@ACC1        U3FPSA                                        MUI00
      *                                                                   MUI005
      * Forward Position Sales Account Type                               MUI005
     C                   Z-ADD     @@ACC2        U3FSAT                                        MUI00
      *                                                                   MUI005
      * Set up Standard part of account Key                               MUI005
     C                   MOVE      *BLANKS       @ACFL1                                        MUI00
     C                   MOVE      *BLANKS       @ACFL2                                        MUI00
     C                   MOVE      *BLANKS       @ACFL3                                        MUI00
     C                   MOVEL     *BLANKS       @ACFL4                                        MUI00
      *                                                                   MUI005
     C                   MOVE      PYTP          @ACFL1                                        MUI00
     C                   MOVE      PYST          @ACFL3                                        MUI00
     C                   MOVE      'D'           @ACFL2                                        MUI00
      *                                                                   MUI005
     C                   MOVE      'P'           @ACFL4                                        MUI00
      *                                                                   MUI008
     C     PYTP          IFEQ      'CC'                                                        MUI00
     C                   MOVE      'D'           @ACFL4                                        MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI008
     C     PYTP          IFEQ      'CP'                                                        MUI00
     C                   MOVE      'E'           @ACFL4                                        MUI00
     C                   ENDIF                                                                 MUI00
      *                                                                   MUI008
     C                   EXSR      #ACKEY                                                      MUI00
      *                                                                   MUI005
      * Forward Sales Account type                                        MUI005
     C                   Z-ADD     @@ACC1        U3FPAT                                        MUI00
      *                                                                   MUI005
      * Forward Position Purchace Account Type                            MUI005
     C                   Z-ADD     @@ACC2        U3FPPA                                        MUI00
      *                                                                   MUI005
      *                                                                   MUI005
      * Swap Margin Currency Code                                         MUI005
     C                   MOVE      *BLANKS       U3SMCY                                        MUI00
      *                                                                   MUI005
      * Total Swap Margin                                                 MUI005
     C                   MOVE      *BLANKS       U3TSWM                                        MUI00
      *                                                                   MUI005
     C                   ENDSR                                                                 MUI00
      *****************************************************************   MUI005
      *                                                               *   MUI005
      *  #FT04  -  Set up Detail records 4    FT                      *   MUI005
      *                                                               *   MUI005
      *  Called By: #S200                                             *   MUI005
      *  Calls:     #ACKEY #BSPL #ERR                                 *   MUI005
      *                                                               *   MUI005
      *****************************************************************   MUI005
      *                                                                   MUI005
     C     #FT04         BEGSR                                                                 MUI00
      *                                                                   MUI005
      * Accrued Swap Margin                                               MUI005
     C                   MOVE      *BLANKS       U4ASWM                                        MUI00
      *                                                                   MUI005
      * Unrealised Swap Margin Profit or Loss Account Type Code        ?  MUI005
     C                   Z-ADD     *ZERO         U4USMA                                        MUI00
      *                                                                   MUI005
      * Swap Option Deal Number                                           MUI005
     C                   Z-ADD     *ZEROS        U4SODN                                        MUI00
      *                                                                   MUI005
      * BSPL Code 1                                                       MUI005
     C                   Z-ADD     *ZEROS        U4BSP1                                        MUI00
      *                                                                   MUI005
      * BSPL Code 2                                                       MUI005
     C                   Z-ADD     *ZEROS        U4BSP2                                        MUI00
      *                                                                   MUI005
      * BSPL Code 3                                                       MUI005
     C                   Z-ADD     *ZEROS        U4BSP3                                        MUI00
      *                                                                   MUI005
      * BSPL Code 4                                                       MUI005
     C                   Z-ADD     *ZEROS        U4BSP4                                        MUI00
      *                                                                   MUI005
      * BSPL Code 5                                                       MUI005
     C                   Z-ADD     *ZEROS        U4BSP5                                        MUI00
      *                                                                   MUI005
      * BSPL Code 6                                                       MUI005
     C                   Z-ADD     *ZEROS        U4BSP6                                        MUI00
      *                                                                   MUI005
      * Deal Type, Subtype                                                MUI005
     C                   MOVEL     PYTP          U4PYTP                                        MUI00
     C                   MOVEL     PYST          U4PYST                                        MUI00
      *                                                                   MUI005
      *                                                                   MUI005
      * Maturity Code                                                     MUI005
     C     PVDT          IFLE      MLACD                                                       MUI00
     C     PVDT          ANDGT     MPEMB                                                       MUI00
     C                   MOVE      '0'           U4MCDE                                        MUI00
     C                   ELSE                                                                  MUI00
     C                   MOVE      '1'           U4MCDE                                        MUI00
     C                   ENDIF                                                                 MUI00
     C                   ENDSR                                                                 MUI00
      *****************************************************************   CM00036425
      *                                                               *   CM00036425
      *  #FT05  -  Set up Detail records 5    FT                      *   CM00036425
      *                                                               *   CM00036425
      *  Called By: #S200                                             *   CM00036425
      *  Calls:                                                       *   CM00036425
      *                                                               *   CM00036425
      *****************************************************************   CM00036425
      *                                                                   CM00036425
     C     #FT05         BEGSR                                                                 CM000
     C                   ENDSR                                                                 CM000
      *                                                                   CM00036425
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
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#BSPL'       REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     XXRSNO        REPKEY
     C                   MOVE      XXACCD        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #FWDVL -  Determine PURCHASE FORWARD VALUE                   *
      *                                                               *
      *  Called By: #FT02                                             *
      *  Calls:     #RATES   #FVAL                                    *
      *                                                               *
      *****************************************************************
      *
     C     #UFWDV        BEGSR
      *
      * Access Currency File
     C********** PUCY      CHAINSDCURRL0             98
     C     SMCY          CHAIN     SDCURRL0                           98
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '009'         DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DB ERR  009 *
     C***********          MOVELPUCY      DBKEY            ***************
     C                   MOVEL     SMCY          DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
     C************         MOVELPUCY      WCCY    3        ***************
     C                   MOVEL     SMCY          WCCY              3            ***************
     C                   Z-ADD     SLDT          VDAT                                          19992
      *
      *  Determine Forward Rate returning Field Rates
     C*********            EXSR #RT02                               MUI005199924
     C                   EXSR      #RATES                                                      19992
     C*********  DTYP      IFEQ 'OP'                                MUI005199924
     C*********            EXSR #FTRAT                              MUI005199924
     C*********            END                                      MUI005199924
      *
     C     A6NBDP        SUB       BCCDP         K                 1 0
     C     K             ADD       4             K
      *
      **  Indicator 32 no longer attached to the multiply/divide flag
      **  as currencies file is now externally described
      *
     C                   Z-ADD     RATES         WKRATE           12 8
     C********             Z-ADDPUAM      EAMT   130
     C                   Z-ADD     SMAM          EAMT             13 0
      *
     C                   EXSR      #FVAL
     C                   Z-ADD     WKREVA        @FWVL            15 0
     C*********                                                     MUI005199024
     C*********  DTYP      IFEQ 'OP'                                MUI005199024
     C*********            Z-ADDRATE      WKRATE                    MUI005199024
     C*********            Z-ADDSMAM      EAMT                      MUI005199024
     C*********            EXSR #FVAL                               MUI005199024
     C*********            Z-ADDWKREVA    @FWVL2 150                MUI005199024
     C*********            ENDIF                                    MUI005199024
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  #SFDVL -  Determine SALE FORWARD VALUE                       *
      *                                                               *
      *  Called By: #202                                              *
      *  Calls:     #RATES   #FVAL                                    *
      *                                                               *
      *****************************************************************
      *
     C     #SFDVL        BEGSR
      *
      * Access Currency File
     C     SLCY          CHAIN     SDCURRL0                           98
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C************         MOVEL'009'     DBASE            ***************MUI005
     C                   MOVEL     '010'         DBASE                          ***************MUI00
     C************         MOVEL'SDCURRPD'DBFILE*************DB*ERR**009**MUI005
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DB ERR  010 *MUI00
     C                   MOVEL     SLCY          DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     SLCY          WCCY              3            ***************
      *
      *  Determine Forward Rate returning Field Rates
     C                   EXSR      #RATES
     C********** DTYP      IFEQ 'OP'                                MMI043MUI009
     C**********           EXSR #RATE                               MMI043MUI009
     C**********           END                                      MMI043MUI009
      *
     C     A6NBDP        SUB       BCCDP         K                 1 0
     C     K             ADD       4             K
      *
      **  Indicator 32 no longer attached to the multiply/divide flag
      **  as currencies file is now externally described
      *
     C                   Z-ADD     RATES         WKRATE           12 8
     C                   Z-ADD     SLAM          EAMT             13 0
      *
     C                   EXSR      #FVAL
     C                   Z-ADD     WKREVA        @SFVL            15 0
      ***********                                                   MMI043MUI009
     C***********DTYP      IFEQ 'OP'                                MMI043MUI009
     C***********          Z-ADDRATE      WKRATE                    MMI043MUI009
     C***********          Z-ADDSLAM      EAMT   130                MMI043MUI009
     C***********          EXSR #FVAL                               MMI043MUI009
     C***********          Z-ADDWKREVA    @SFVL2 150                MMI043MUI009
     C***********          ENDIF                                    MMI043MUI009
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #RATES -  Determine Rates                                    *
      *                                                               *
      *  Called By: #FWDVL                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #RATES        BEGSR
      *
     C                   Z-ADD     0             DAT
     C                   Z-ADD     0             RAT
     C                   Z-ADD     *ZERO         RFW
      *
      * Access Forward rate file using Purchase/SALE Currency
     C     WCCY          CHAIN     FWDRTE                             31
      ***********                                                         MUI009
      ****Put*run*date*in*first*element.*******************************   MUI009
      ***********                                                         MUI009
     C***********          Z-ADDBJRDNB    DAT,1                           MUI009
      *                                                                   MUI009
      **  Put spot date in first element.                                 MUI009
      *                                                                   MUI009
     C**********         CALL      'GLM043'                                             MUI00 LUC109
     C                   CALL      'XX000043'                                                 LUC109
     C                   PARM                    BJRDNB                                        MUI00
     C                   PARM      A6SPDY        NODAYS                                        MUI00
     C                   PARM                    WCCY                                          MUI00
     C                   PARM      *BLANKS       @LOC              3            Locn-optionl   MUI00
     C                   PARM                    @SPOT             5 0                         MUI00
      *                                                                   MUI009
     C                   Z-ADD     @SPOT         DAT(1)                                        MUI00
      *                                                                   MUI009
     C                   Z-ADD     2             N                 2 0
     C                   Z-ADD     1             Y                 2 0
     C                   MOVE      'N'           IEND              1
      *                                                                   MMI043
      **  Element 1 of rate array contains spot rate.                     MMI043
      *                                                                   MMI043
     C                   MOVEA     RFW           RAT(2)                                        MMI04
     C                   Z-ADD     A6SPRT        RAT(1)                                        MMI04
     C                   Z-ADD     *ZERO         RATES            12 8                         MMI04
      *                                                                   MMI043
      ** CASE I: There is no defined forward rates for CCY                MMI043
      *                                                                   MMI043
     C     *IN31         IFEQ      '1'                                                         MMI04
     C                   Z-ADD     A6SPRT        RATES                                         MMI04
     C                   MOVE      'Y'           IEND                                          MMI04
     C                   ENDIF                                                                 MMI04
      *                                                                   MMI043
      ***CASE*II:*Is*the*start*date*less*than*the*run*date?*********MMI043MUI009
      ** CASE II: Is the start date less than the spot date?              MUI009
      *                                                                   MMI043
     C     VDAT          IFLT      DAT(1)                                                      MMI04
     C                   Z-ADD     RAT(1)        RATES                                         MMI04
     C                   MOVE      'Y'           IEND                                          MMI04
     C                   ENDIF                                                                 MMI04
      *                                                                   MUI009
      *
      **  Loop to calculate remaining dates.
      *
     C     Y             DOWLT     26
     C     IEND          ANDNE     'Y'
     C     DFW(Y)        IFEQ      0
     C                   MOVE      'Y'           IEND
     C                   ELSE
     C********** DFW,Y     ADD  BJRDNB    DAT,N                           MUI009
     C     DFW(Y)        ADD       @SPOT         DAT(N)                                        MUI00
      *                                                                   MMI043
      ** CASE III: Start date matches a date in the array                 MMI043
      *                                                                   MMI043
     C     VDAT          IFEQ      DAT(N)                                                      MMI04
     C                   Z-ADD     RAT(N)        RATES                                         MMI04
     C                   ENDIF                                                                 MMI04
      *                                                                   MMI043
      ** CASE IV: Start date is between two dates in the array            MMI043
      *                                                                   MMI043
     C     VDAT          IFLT      DAT(N)                                                      MMI04
     C     VDAT          ANDGT     DAT(Y)                                                      MMI04
     C     RAT(N)        SUB       RAT(Y)        WKR1             12 8                         MMI04
     C     VDAT          SUB       DAT(Y)        WKD1              5 0                         MMI04
     C     DAT(N)        SUB       DAT(Y)        WKD2              5 0                         MMI04
     C     WKR1          MULT      WKD1          RATES                                         MMI04
     C     RATES         DIV       WKD2          RATES                                         MMI04
     C     RATES         ADD       RAT(Y)        RATES                                         MMI04
     C                   ENDIF                                                                 MMI04
      *                                                                   MMI043
     C     RATES         IFEQ      *ZERO                                                       MMI04
     C     N             ADD       1             N
     C     Y             ADD       1             Y
     C                   ELSE                                                                  MMI04
     C                   MOVE      'Y'           IEND                                          MMI04
     C                   ENDIF                                                                 MMI04
     C                   ENDIF
     C                   ENDDO
      *
     C     N             SUB       1             LAST              2 0
      *                                                                   MMI043
      *****************************************************************   MMI043
      ****Element*1*of*rate*array*contains*spot*rate.******************   MMI043
      *****************************************************************   MMI043
     C***********          MOVEARFW       RAT,2                           MMI043
     C***********          Z-ADDA6SPRT    RAT,1                           MMI043
     C***********          Z-ADD*ZERO     RATES  128                      MMI043
      *****************************************************************   MMI043
      ****Is*the*start*date*less*than*the*run*date?********************   MMI043
      *****************************************************************   MMI043
     C***********VDAT      IFLT DAT,1                                     MMI043
      *****************************************************************   MMI043
     C***********          Z-ADDRAT,1     RATES                           MMI043
      *****************************************************************   MMI043
     C***********          ENDIF                                          MMI043
      *
      **  Compare start date with dates in array.
      ** CASE V: Start date is greater than the last forward date         MMI043
      *                                                                   MMI043
     C     RATES         IFEQ      *ZERO
     C***********          Z-ADD1         N       20                      MMI043
     C***********VDAT      LOKUPDAT,N                35                   MMI043
     C                   Z-ADD     1             X                 2 0                         MMI04
     C     VDAT          LOOKUP    DAT(X)                             35                       MMI04
     C     *IN35         IFEQ      *OFF
     C                   Z-ADD     RAT(LAST)     RATES
     C                   ENDIF
     C                   ENDIF
      *
      ****Check*if*N-1*TH*date*matches*start*date**********************   MMI043
     C***********N         SUB  1         M       20                      MMI043
     C***********RATES     IFEQ *ZERO                                     MMI043
     C***********VDAT      IFEQ DAT,M                                     MMI043
     C***********          Z-ADDRAT,M     RATES                           MMI043
     C***********          ENDIF                                          MMI043
     C***********          ENDIF                                          MMI043
      *****************************************************************   MMI043
      ****Third*case*-*start*date*is*between*two*dates*in**************   MMI043
      ****the*array.***************************************************   MMI043
      *****************************************************************   MMI043
     C***********RATES     IFEQ *ZERO                                     MMI043
     C***********RAT,N     SUB  RAT,M     WKR1   128                      MMI043
      *****************************************************************   MMI043
     C***********VDAT      SUB  DAT,M     WKD1    50                      MMI043
     C***********DAT,N     SUB  DAT,M     WKD2    50                      MMI043
     C***********WKR1      MULT WKD1      RATES                           MMI043
     C***********RATES     DIV  WKD2      RATES                           MMI043
     C***********RATES     ADD  RAT,M     RATES                           MMI043
     C***********          ENDIF                                          MMI043
      *                                                                   MMI043
      **  If no rates set up in file, use spot rate.                      MMI043
      *                                                                   MMI043
     C     RATES         IFEQ      *ZERO                                                       MMI04
     C                   Z-ADD     RAT(1)        RATES                                         MMI04
     C                   ENDIF                                                                 MMI04
      *                                                                   MMI043
     C                   ENDSR
      ************************************************************* MMI043MUI009
      **********                                                    MMI043MUI009
      ***#RATE*- Determine Rate on Option Date                      MMI043MUI009
      **********                                                    MMI043MUI009
      ***Called*By: #FWDVL  #SFDVL                                  MMI043MUI009
      ***Calls:*                                                    MMI043MUI009
      **********                                                    MMI043MUI009
      ************************************************************* MMI043MUI009
      **********                                                    MMI043MUI009
     C********** #RATE     BEGSR                                    MMI043MUI009
      **********                                                    MMI043MUI009
     C**********           Z-ADD0         DAT                       MMI043MUI009
     C**********           Z-ADD0         RAT                       MMI043MUI009
     C**********           Z-ADD*ZERO     RFW                       MMI043MUI009
      **********                                                    MMI043MUI009
      ***Access*Forward rate file using Purchase/SALE Currency      MMI043MUI009
      **********                                                    MMI043MUI009
     C********** WCCY      CHAINFWDRTE               31             MMI043MUI009
      **********                                                    MMI043MUI009
      ***Put*run date in first element.                             MMI043MUI009
      **********                                                    MMI043MUI009
     C**********           Z-ADDBJRDNB    DAT,1                     MMI043MUI009
     C**********           Z-ADD2         N       20                MMI043MUI009
     C**********           Z-ADD1         Y       20                MMI043MUI009
     C**********           MOVE 'N'       IEND    1                 MMI043MUI009
      **********                                                    MMI043MUI009
      ***Element 1 of rate array contains spot rate.                MMI043MUI009
      **********                                                    MMI043MUI009
     C**********           MOVEARFW       RAT,2                     MMI043MUI009
     C**********           Z-ADDA6SPRT    RAT,1                     MMI043MUI009
     C**********           Z-ADD*ZERO     RATE   128                MMI043MUI009
      **********                                                    MMI043MUI009
      ***CASE*I: There is no defined forward rates for CCY          MMI043MUI009
      **********                                                    MMI043MUI009
     C********** *IN31     IFEQ '1'                                 MMI043MUI009
     C**********           Z-ADDA6SPRT    RATE                      MMI043MUI009
     C**********           MOVE 'Y'       IEND                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      **********                                                    MMI043MUI009
      ***CASE*II: Is the start date less than the run date?         MMI043MUI009
      **********                                                    MMI043MUI009
     C********** OTDT      IFLT DAT,1                               MMI043MUI009
     C**********           Z-ADDRAT,1     RATE                      MMI043MUI009
     C**********           MOVE 'Y'       IEND                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      **********                                                    MMI043MUI009
      ****Loop*to calculate remaining dates.                        MMI043MUI009
      **********                                                    MMI043MUI009
     C********** Y         DOWLT26                                  MMI043MUI009
     C********** IEND      ANDNE'Y'                                 MMI043MUI009
     C********** DFW,Y     IFEQ 0                                   MMI043MUI009
     C**********           MOVE 'Y'       IEND                      MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
     C********** DFW,Y     ADD  BJRDNB    DAT,N                     MMI043MUI009
      **********                                                    MMI043MUI009
      ***CASE*III: Start date matches a date in the array           MMI043MUI009
      **********                                                    MMI043MUI009
     C********** OTDT      IFEQ DAT,N                               MMI043MUI009
     C**********           Z-ADDRAT,N     RATE                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      **********                                                    MMI043MUI009
      ***CASE*IV: Start date is between two dates in the array      MMI043MUI009
      **********                                                    MMI043MUI009
     C********** OTDT      IFLT DAT,N                               MMI043MUI009
     C********** OTDT      ANDGTDAT,Y                               MMI043MUI009
     C********** RAT,N     SUB  RAT,Y     WKR1   128                MMI043MUI009
     C********** OTDT      SUB  DAT,Y     WKD1    50                MMI043MUI009
     C********** DAT,N     SUB  DAT,Y     WKD2    50                MMI043MUI009
     C********** WKR1      MULT WKD1      RATE                      MMI043MUI009
     C********** RATE      DIV  WKD2      RATE                      MMI043MUI009
     C********** RATE      ADD  RAT,Y     RATE                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      **********                                                    MMI043MUI009
     C********** RATE      IFEQ *ZERO                               MMI043MUI009
     C********** N         ADD  1         N                         MMI043MUI009
     C********** Y         ADD  1         Y                         MMI043MUI009
     C**********           ELSE                                     MMI043MUI009
     C**********           MOVE 'Y'       IEND                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
     C**********           ENDDO                                    MMI043MUI009
      **********                                                    MMI043MUI009
     C********** N         SUB  1         LAST    20                MMI043MUI009
      **********                                                    MMI043MUI009
      ***CASE*V: Start date is greater than the last forward date   MMI043MUI009
      **********                                                    MMI043MUI009
     C********** RATE      IFEQ *ZERO                               MMI043MUI009
     C**********           Z-ADD1         X       20                MMI043MUI009
     C********** VDAT      LOKUPDAT,X                35             MMI043MUI009
     C********** *IN35     IFEQ *OFF                                MMI043MUI009
     C**********           Z-ADDRAT,LAST  RATE                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      **********                                                    MMI043MUI009
      ***If*no*rates set up in file, use spot rate.                 MMI043MUI009
      **********                                                    MMI043MUI009
     C********** RATES     IFEQ *ZERO                               MMI043MUI009
     C**********           Z-ADDRAT,1     RATE                      MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      **********                                                    MMI043MUI009
     C**********           ENDSR                                    MMI043MUI009
      *****************************************************************
      *                                                               *
      *  #FVAL  - Subroutine to calculate revalued equivalent for     *
      *           report                                              *
      *                                                               *
      *  Called By:  #FWDVL                                           *
      *                                                               *
      *  Calls    :  None                                             *
      *
      *****************************************************************
     C     #FVAL         BEGSR                                                              *
      *
     C     A6MDIN        IFEQ      'D'
      *
     C     K             IFNE      1
     C     K             ANDNE     2
     C     WKRATE        MULT      POWER(K)      WK159            15 9
     C     EAMT          DIV(H)    WK159         WKREVA           13 0
     C                   END
     C     K             IFEQ      1
     C     WKRATE        MULT      100           RATE1            12 6
     C     RATE1         MULT      POWER(K)      WK129            12 9
     C     EAMT          DIV(H)    WK129         WK152            15 2
     C     WK152         MULT(H)   100           WKREVA
     C                   END
      *
     C     K             IFEQ      2
     C     WKRATE        MULT      10            RATE2            12 7
     C     RATE2         MULT      POWER(K)      WK129
     C     EAMT          DIV(H)    WK129         WK151            15 1
     C     WK151         MULT(H)   10            WKREVA
     C                   END
      *
     C                   ELSE
      *
     C     K             IFNE      6
     C     K             ANDNE     7
     C     WKRATE        DIV       POWER(K)      WK159
     C     EAMT          MULT(H)   WK159         WKREVA
     C                   END
     C     K             IFEQ      7
     C     WKRATE        MULT      100           RATE1
     C     RATE1         DIV       POWER(K)      WK129
      *
      **  Use half-adjust instead of truncate, to ensure calculated
      **  amount is correct to the nearest unit.
      *
     C     EAMT          MULT(H)   WK129         WKREVA
     C     WKREVA        DIV(H)    100           WKREVA
     C                   END
      *
     C     K             IFEQ      6
     C     WKRATE        MULT      10            RATE2
     C     RATE2         DIV       POWER(K)      WK129
      *
      **  Use half-adjust instead of truncate, to ensure calculated
      **  amount is correct to the nearest unit.
      *
     C     EAMT          MULT(H)   WK129         WKREVA
     C     WKREVA        DIV(H)    10            WKREVA
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #ACKEY -  Determine Account Codes                            *
      *                                                               *
      *  Called By: #203 #204                                         *
      *  Calls:     #ERR                                              *
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
     C                   ELSE
      *
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVE      *BLANKS       REPACN
     C                   MOVEL     F1DEAL        REPACN
     C                   MOVEL     '#ACKEY'      REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     @@ACK         REPKEY
     C                   EXSR      #ERR
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
     C                   WRITE     FEIMCF
      *
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ELSE
     C                   WRITE     NODET
     C                   ENDIF
      *
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
     C**********         MOVEL     'GLM034'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000034'    DBPGM                          Set program idLUC109
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
      *    CALLED BY - #S201                                          *
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
      *                                                               *
      *  #FWDVL -  Determine PURCHASE FORWARD VALUE                   *
      *                                                               *
      *  Called By: #202                                              *
      *  Calls:     #RATES   #FVAL                                    *
      *                                                               *
      *****************************************************************
      *
     C     #FWDVL        BEGSR
      *
      * Access Currency File
     C     PUCY          CHAIN     SDCURRL0                           98
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '009'         DBASE                          ***************
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DB ERR  009 *
     C                   MOVEL     PUCY          DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     PUCY          WCCY              3            ***************
      *
      *  Determine Forward Rate returning Field Rates
     C                   EXSR      #RATES
     C********** DTYP      IFEQ 'OP'                                MMI043MUI009
     C**********           EXSR #RATE                               MMI043MUI009
     C**********           END                                      MMI043MUI009
      *
     C     A6NBDP        SUB       BCCDP         K                 1 0
     C     K             ADD       4             K
      *
      **  Indicator 32 no longer attached to the multiply/divide flag
      **  as currencies file is now externally described
      *
     C                   Z-ADD     RATES         WKRATE           12 8
     C                   Z-ADD     PUAM          EAMT             13 0
      *
     C                   EXSR      #FVAL
     C                   Z-ADD     WKREVA        @FWVL            15 0
      **********                                                    MMI043MUI009
     C********** DTYP      IFEQ 'OP'                                MMI043MUI009
     C**********           Z-ADDRATE      WKRATE                    MMI043MUI009
     C**********           Z-ADDPUAM      EAMT                      MMI043MUI009
     C**********           EXSR #FVAL                               MMI043MUI009
     C**********           Z-ADDWKREVA    @FWVL2 150                MMI043MUI009
     C**********           ENDIF                                    MMI043MUI009
      *
     C                   ENDSR
      *****************************************************************   MUI005
      *                                                               *   MUI005
      *  #UFTFV -  Determine SALE FORWARD VALUE                       *   MUI005
      *                                                               *   MUI005
      *  Called By: #FT03                                             *   MUI005
      *  Calls:     #RATES   #FVAL                                    *   MUI005
      *                                                               *   MUI005
      *****************************************************************   MUI005
      *                                                                   MUI005
     C     #UFTFV        BEGSR                                                                 MUI00
      *                                                                   MUI005
      * Access Currency File                                              MUI005
     C*********  SMCY      CHAINSDCURRL0             98                   MUI005
     C     PCCY          CHAIN     SDCURRL0                           98                       MUI00
      *                                                                   MUI005
     C     *IN98         IFEQ      *ON                                          Ended in error MUI00
     C                   MOVEL     '012'         DBASE                          ***************MUI00
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DB ERR  012 *MUI00
     C*********            MOVELSMCY      DBKEY            ***************MUI005
     C                   MOVEL     PCCY          DBKEY                          ***************MUI00
     C                   EXSR      *PSSR                                                       MUI00
     C                   ENDIF                                                                 MUI00
     C*********            MOVELSMCY      WCCY    3                       MUI005
     C                   MOVEL     PCCY          WCCY              3                           MUI00
     C                   Z-ADD     PVDT          VDAT                                          19992
      *                                                                   MUI005
      *  Determine Forward Rate returning Field Rates                     MUI005
     C*********            EXSR #RT03                               MUI005199924
     C                   EXSR      #RATES                                                      19992
     C*********  DTYP      IFEQ 'OP'                                MUI005199924
     C*********            EXSR #FTRAT                              MUI005199924
     C*********            END                                      MUI005199924
      *                                                                   MUI005
     C     A6NBDP        SUB       BCCDP         K                 1 0                         MUI00
     C     K             ADD       4             K                                             MUI00
      *                                                                   MUI005
      **  Indicator 32 no longer attached to the multiply/divide flag     MUI005
      **  as currencies file is now externally described                  MUI005
      *                                                                   MUI005
     C                   Z-ADD     RATES         WKRATE           12 8                         MUI00
     C*********            Z-ADDSMAM      EAMT   130                      MUI005
     C                   Z-ADD     PYAM          EAMT             13 0                         MUI00
      *                                                                   MUI005
     C                   EXSR      #FVAL                                                       MUI00
     C                   Z-ADD     WKREVA        @SFVL            15 0                         MUI00
     C*********                                                     MUI005199924
     C*********  DTYP      IFEQ 'OP'                                MUI005199924
     C*********            Z-ADDRATE      WKRATE                    MUI005199924
     C*********            Z-ADDSMAM      EAMT   130                MUI005199924
     C*********            EXSR #FVAL                               MUI005199924
     C*********            Z-ADDWKREVA    @SFVL2 150                MUI005199924
     C*********            ENDIF                                    MUI005199924
      *                                                                   MUI005
     C                   ENDSR                                                                 MUI00
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2016
**   POWER - POWERS OF 10 FOR CURRENCY CONVERSIONS
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  @ERR
XX000041 UNABLE TO CONVERT AMOUNT
SDACRCL9 RECORD NOT FOUND
ACKEY RECORD NOT FOUND
