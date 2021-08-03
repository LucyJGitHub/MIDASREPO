     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Balance Sheet Extract')                             *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM037**-*GL*Balance*Sheet*Extract****************************                       LUC109
      *  XX000037 - GL Balance Sheet Extract                          *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Balance sheet Extract                              *
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. 159964             Date 22Aug99               *
      *                 MMI043             Date 13May99               *
      *                 MMI043             Date 04Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Amendments to Add/Subtract Posting Amount (from     *
      *           PF/EODCLPD) to Ledger Balance.                      *
      *  MMI043 - Balance Sheet Extract                               *
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
     FACCBR     IF   E           K DISK    INFSR(*PSSR)
     FSDACRCL9  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FGLRECOV0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRECOPF:RECTOT)
     FGLRECOV1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRECOPF:RECDT)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     FEODCLV0   IF   E           K DISK    INFSR(*PSSR)
     FFESIT     O    E             DISK    INFSR(*PSSR)
     F***GLM037AU  O    E             PRINTER INFDS(SPOOL1)                                   LUC109
     FXX000037AUO    E             PRINTER INFDS(SPOOL1)                                      LUC109
     F                                     INFSR(*PSSR)
     F***GLM037P1  O    E             PRINTER INFDS(SPOOL2)                                   LUC109
     FXX000037P1O    E             PRINTER INFDS(SPOOL2)                                      LUC109
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - PF/SDBRCHL1   File I/O                                 *
      *   21 - PF/ACCBR      File I/O                                 *
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
      *  #RECO  - Account Balance Reconcilliation                     *
      *  #UNREC - Un-reconcilled items                                *
      *  #ERR   - Error Reporting                                     *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @ERR            S             35    DIM(3) CTDATA PERRCD(1)
     D ZS2             S              1    DIM(22)
      *
      *
      ***File*information*for*printer*file*GLM037AU********************                       LUC109
      ** File information for printer file XX000037AU                                         LUC109
      *
     D SPOOL1          DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      ***File*information*for*printer*file*GLM037P1********************                       LUC109
      ** File information for printer file XX000037P1                                         LUC109
      *
     D SPOOL2          DS
     D  WWOFL2               188    189B 0
     D  WWPTL2               367    368B 0
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
      ** Detail Record
      *
     D DETAIL          DS
     D  FPROG                  1      3
     D  F1BKCD                 4      6
     D  F1BRCD                 7      9
     D  FCCYC                 10     12
     D  FACCT                 13     16  0
     D  FACCN                 17     34
     D  FACCB                 35     53
     D  FBSPL                 54     57  0
     D  FRECO                 58     58
     D  FILL03                59     78
      *
      ** Trailer Record
      *
     D TRAILR          DS
     D  FCONT                  1      6  0
     D  FILL04                 7     78
      *
      ** Account Number
      *
     D ACNUM           DS
     D  ABRCH                  1      3
     D  ACUST                  4      9  0
     D  ACCYC                 10     12
     D  AACOD                 13     16  0
     D  AACSQ                 17     18  0
     D* DATESTAMP
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
     D                 DS
     D  ZWRK15                 1     15  0
     D  ZS1                    1     15  0
     D                                     DIM(15)
     D                 DS
     D  ZOUT25                 1     25
     D  ZOUT0                  1     21
     D  ZOUT1                  2     23
     D  ZOUT2                  3     24
     D  ZOUT3                  5     25
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
     C     *LIKE         DEFINE    LDBL          WLDBL
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
      ** Key list definition for EODCLV0
      *
     C     WAKEY         KLIST
     C                   KFLD                    WBRCA             3
     C                   KFLD                    WCNUM             6 0
     C                   KFLD                    WCCY              3
     C                   KFLD                    WACOD             4 0
     C                   KFLD                    WACSQ             2 0
      *
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
     C                   MOVE      *BLANKS       FILL03
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         FPROG
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FESIT'       FEXFL
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
     C                   WRITE     FESITF
     C                   Z-ADD     1             COUNT             6 0
      *
     C                   Z-ADD     *ZERO         ERRCNT            6 0
      * Write Error Report Header
     C                   WRITE     ERRHDR
      *
     C                   MOVE      'J'           ZECODE                         Edit code
     C                   Z-ADD     *ZERO         RECCNT            6 0
      * Write reconcilliation Report Header
     C                   WRITE     RECHDR
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
     C                   WRITE     FESITF
     C                   ADD       1             COUNT
      *
     C                   MOVE      A8CMCD        F1BKCD
     C                   MOVE      FBRCD         F1BRCD
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FESITF
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
      *  Calls:     #BSPL #ERR #RECO                                  *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all Accounts for the branch
      *
     C     FBRCD         SETLL     ACCBR
     C     FBRCD         READE     ACCBR                                  21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      * Only process non-zero records
     C     LDBL          IFNE      *ZERO
      * Currency Code
     C                   MOVE      CCY           FCCYC
      * Account Type
     C                   Z-ADD     ACOD          FACCT
      * Set Up Account Number
     C                   MOVE      BRCA          ABRCH
     C                   Z-ADD     CNUM          ACUST
     C                   MOVE      CCY           ACCYC
     C                   Z-ADD     ACOD          AACOD
     C                   Z-ADD     ACSQ          AACSQ
     C                   MOVEL     ACNUM         FACCN
      *
      ** Add/Subtract Posting Amount to Ledger Balance
      *
     C                   MOVE      ABRCH         WBRCA
     C                   Z-ADD     ACUST         WCNUM
     C                   MOVE      ACCYC         WCCY
     C                   Z-ADD     AACOD         WACOD
     C                   Z-ADD     AACSQ         WACSQ
     C                   Z-ADD     LDBL          WLBAL            15 0
      *
     C     WAKEY         SETLL     EODCLV0
     C     WAKEY         READE     EODCLV0                                22
     C     *IN22         DOWEQ     '0'
     C     DRCR          IFEQ      0
     C     WLBAL         SUB       PSTA          WLBAL
     C                   ELSE
     C     WLBAL         ADD       PSTA          WLBAL
     C                   ENDIF
     C     WAKEY         READE     EODCLV0                                22
     C                   ENDDO
      * Set Up Account Balance
     C**********           Z-SUBLDBL      WLDBL
     C                   Z-SUB     WLBAL         WLDBL
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    CCY
     C                   PARM                    WLDBL
     C                   PARM                    FACCB
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#S200'       REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     LDBL          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   ENDIF
      *
      * Set Up BSPL Code
      *
     C                   MOVE      ACOD          XXACCD
     C                   EXSR      #BSPL
      *
      * Perform Account Reconcilliation
      *
     C                   EXSR      #RECO
      *
      *
      *  Write Detail Record
     C                   MOVE      '05'          RECC
     C                   MOVE      DETAIL        DATA
     C                   WRITE     FESITF
     C                   ADD       1             COUNT
      *
     C                   ENDIF
      *
      *
      *  Read Next record
     C     FBRCD         READE     ACCBR                                  21
      *
      *
     C                   ENDDO
      *
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #BSPL  -  Determine BSPL Details                             *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #BSPL         BEGSR
      *
      *
      * Ledger Balance < 0
      *
     C     LDBL          IFLT      *ZERO
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
     C                   Z-ADD     *ZERO         FBSPL
     C                   ELSE
     C                   MOVE      G6RSCD        FBSPL
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Ledger Balance > 0
      *
     C     LDBL          IFGT      *ZERO
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
      * Ledger Balance = 0
      *
     C     LDBL          IFEQ      *ZERO
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
      * Error Reporting
     C     *IN22         IFEQ      *ON
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#BSPL'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     XXRSNO        REPKEY
     C                   MOVE      XXACCD        REPKEY
     C                   EXSR      #ERR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #RECO  -  Account Balance Reconcilliation                    *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:     #UNREC                                            *
      *                                                               *
      *****************************************************************
      *
     C     #RECO         BEGSR
      *
      * Access Account Balance Totals file
     C     ACNUM         CHAIN     GLRECOV0                           23
      *
      * No record found
     C     *IN23         IFEQ      *ON
     C                   MOVE      '0'           FRECO
     C                   ELSE
      *
      * Account Balance matches Totals
     C     LDBL          IFEQ      C0301
     C                   MOVE      '1'           FRECO
     C                   ELSE
      *
      * Generate Unreconcilled items report
     C                   MOVE      '2'           FRECO
     C                   EXSR      #UNREC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #UNREC -  Unreconcilled Items                                *
      *                                                               *
      *  Called By: #RECO                                             *
      *  Calls:     #ERR                                              *
      *                                                               *
      *****************************************************************
      *
     C     #UNREC        BEGSR
      * Access currency to determine no. of decimal places
     C     CCY           CHAIN     SDCURRL0                           50
      *
     C     *IN50         IFEQ      *ON                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     ACNUM         REPACN
     C                   MOVEL     '#UNREC'      REPPRG
     C                   MOVEL     @ERR(3)       REPMSG
     C                   MOVEL     CCY           REPKEY
     C                   EXSR      #ERR
     C                   Z-ADD     *ZERO         A6NBDP                         Decimal places
     C                   ENDIF
     C                   Z-ADD     A6NBDP        ZDECS                          Decimal places
      *
      * Write Header Record
     C     WWOFL2        SUB       WWPTL2        WWLIN2            2 0
      *
     C     WWLIN2        IFLT      8
     C                   WRITE     RECHDR
     C                   ENDIF
      *
     C                   MOVE      ABRCH         RECBRC
     C                   MOVE      ACUST         RECCUS
     C                   MOVE      ACCYC         RECCCY
     C                   MOVE      AACOD         RECACC
     C                   MOVE      AACSQ         RECACS
      *
     C                   Z-ADD     LDBL          ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        RECBAL                         Balance
      *
     C                   Z-ADD     C0301         ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        RECBLT                         Balance
      *
      * Write Sub-Header Record
     C                   WRITE     RECSUB
      *
      * Access Account Balance Detail file
     C     ACNUM         SETLL     GLRECOV1
     C     ACNUM         READE     GLRECOV1                               24
      * No record found
     C     *IN24         DOWEQ     *OFF
      *
      * Write Header Record
     C     WWOFL2        SUB       WWPTL2        WWLIN2            2 0
      *
     C     WWLIN2        IFLT      5
     C                   WRITE     RECHDR
     C                   ENDIF
      *
     C                   ADD       1             RECCNT
      *
     C                   MOVE      C9150         RECTRN
      *
     C                   Z-ADD     C0301         ZFLD15                         Raw value
     C                   EXSR      ZFRPED                                       Format amount
     C                   MOVE(P)   ZOUT22        RECDTL                         Balance
      *
      * Write Sub-Header Record
     C                   WRITE     RECDET
      *
      * Read Next Record
     C     ACNUM         READE     GLRECOV1                               24
     C                   ENDDO
      *
      * Write Total Record
     C                   WRITE     RECTTL
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
     C                   WRITE     FESITF
      *
     C     WWOFL2        SUB       WWPTL2        WWLIN2
      *
     C     WWLIN2        IFLT      5
     C                   WRITE     RECHDR
     C                   ENDIF
     C     ERRCNT        IFGT      *ZERO
     C                   WRITE     EOR
     C                   ELSE
     C                   WRITE     NODET
     C                   ENDIF
      *
     C     RECCNT        IFGT      *ZERO
     C                   WRITE     RECEOR
     C                   ELSE
     C                   WRITE     RECNOD
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
     C**********         MOVEL     'GLM037'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000037'    DBPGM                          Set program idLUC109
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
      *    CALLED BY - #S200 #BSPL                                    *
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
     C**                                                                 *
     C** ZFRPED subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('A','C','J','L' or blank)       *
     C**                                ( Default is 'J')                *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    22/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT22 22                                   *
     C**     Output fields:  ZOUT25 25  (ALIGNED BY DECIMAL POINT)       *
     C**          (The last 2 characters will be '  ','CR',or '- ')      *
     C**
     C     ZFRPED        BEGSR                                                  **  ZFRPED   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT22           22
     C                   MOVE      *BLANKS       ZOUT25           25
     C     ZECODE        IFEQ      *BLANKS
     C                   MOVE      'J'           ZECODE
     C                   END
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C     ZECODE        IFEQ      'A'
     C     ZECODE        OREQ      'C'
     C                   MOVEA     'CR'          ZS2(21)
     C                   ELSE
     C                   MOVE      '-'           ZS2(21)
     C                   END
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        ZWRK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C     Z2            ORGT      *ZEROS
     C     ZECODE        ANDEQ     'A'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     23            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      23
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT22
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZOUT22        ZOUT0
     C                   ELSE
     C**
     C     ZDECS         IFEQ      1
     C                   MOVE      ZOUT22        ZOUT1
     C                   ELSE
     C**
     C     ZDECS         IFEQ      2
     C                   MOVE      ZOUT22        ZOUT2
     C                   ELSE
     C**
     C                   MOVE      ZOUT22        ZOUT3
     C                   END
     C**
     C                   END
     C**
     C                   END
     C**
     C                   ENDSR
     C*
     C********************************************************************
      *****************************************************************
      ***
**  CPY@
(c) Finastra International Limited 2016
**  @ERR
SDACRCL9 RECORD NOT FOUND
XX000041 UNABLE TO CONVERT AMOUNT
SDCURRL0 RECORD NOT FOUND
