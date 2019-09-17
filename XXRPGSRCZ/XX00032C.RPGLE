     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Engagement Transaction Extract from Midas')            *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM032C*-*Engagement*Transaction*Extract*from*Midas***********                       LUC109
      *  XX00032C - Engagement Transaction Extract from Midas         *                       LUC109
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Engagement Transaction Extract from Midas          *
      *                                                               *
      ***CALLED*BY**GLCM032*-*ENGAGEMENTS*EXTRACT**********************                       LUC109
      *  CALLED BY  XX000032 - ENGAGEMENTS EXTRACT                    *                       LUC109
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1998********************************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109CC1          Date 12Sep19               *
      *  Prev Amend No. LUC109             Date 20Sep16               *
      *                 MUI010             Date 10Mar04               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 07Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109CC1 - New York Amendments                              *
      *         - Omit transactions with zero account codes.          *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MUI010 - HOR Changes: add field C9802 (Facility Customer).   *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Customer Detail Changes Extract                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
      ** Engagement Transaction Extract work File
     FWKFECRF   IF   E           K DISK    INFSR(*PSSR)
      *
      ** Bank Details
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
      *
      ** Bank Extension Details
     FSDGELRPP  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Interface Bank Details
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Branch Code Details
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** General Ledger ICD
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
      *
      ** Reconciliation detail
     FGLRECOPP  IF A E             DISK    INFSR(*PSSR)
      *
      ** Reconciliation Totals
     FGLRECOV0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRECOPF:RECTOT)
      *
      ** Currency File
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Engagement Transaction Extract File
     FFECRF     O    E             DISK    INFSR(*PSSR)
      *
      ** Engagement Transaction Extract Audit Report
     F***GLM032AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000032AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - Controls the loop of SDBRCHL1                          *
      *   21 - Retreival of Work File Details                         *
      *                                                               *
      *  90-99    Used by Standard Subroutines                        *
      *                                                               *
      *  88       Database Error                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *  #S200  - Main Processing                                     *
      *  #S210  - Detail Processing                                   *
      *  #S300  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
     D SVALKK          C                   CONST('HOR_NY_Amendments')                      LUC109CC1
      * Compile Time Arrays                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
      *
      ***File*information*for*printer*file*GLM032AU********************                       LUC109
      ** File information for printer file XX000032AU                                         LUC109
      *
     D SPOOL           DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
      *
      **
     D UREFDS          DS
     D  URFMT                261    270
      *
      *
      ** Data structure for data-base error processing
      *
     D DBERR           DS           256    INZ
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      ** Header Record
      *
     D HEADER          DS                  INZ
     D  FBKCD                  1      3
     D  FGPCD                  4      6
     D  FEXFL                  7     11    INZ('FECRF')
     D  FSYSD                 12     19
     D  FLACD                 20     27
     D  FLWDM                 28     35
     D  FNWKD                 36     43
     D  FILL01                44     78
      *
      ** Branch Header Record
      *
     D BRCHHD          DS                  INZ
     D  FBRCD                  1      3
     D  FILL02                 4     78
      *
      ** Detail Record format and Layouts
     D DET001          DS            78    INZ
     D  FPROG1                 1      3    INZ('001')
     D  C9003                  4      6
     D  C0120                  7      9
     D  C9149                 10     12
     D  C9150                 13     27
     D  C9151                 28     45
     D  C5125                 46     51
     D  C0150                 52     54
     D  C9112                 55     73
      *
      ** Detail record format 2
     D DET002          DS            78    INZ
     D  FPROG2                 1      3    INZ('002')
     D  C9113                  4     22
     D  C0051                 23     30
     D  C0052                 31     38
     D  C9019                 39     41
     D  C9020                 42     43
     D  C9021                 44     51
     D  C9022                 52     59
     D  C9153                 60     63
     D  C9154                 64     67
     D  C0110                 68     69
     D  C9802                 70     75                                         MUI010
      *
      ** Detail record format 3
     D DET003          DS            78    INZ
     D  FPROG3                 1      3    INZ('003')
     D  C0301                  4     22
     D  C0441                 23     30
     D  C0581                 31     32
     D  C0582                 33     33
     D  C0584                 34     34
     D  C0637                 35     35
     D  C0638                 36     36
     D  C9140                 37     42
     D  C9141                 43     44
     D  C0814                 45     45
     D  C5064                 46     46
     D  C5653                 47     52
     D  C9343                 53     56
     D  C9344                 57     60
      *
      ** Trailer Record
     D TRAILR          DS                  INZ
     D  FCONT                  1      6  0
     D  FILL06                 7     78
      * DateStamp
     D DATST           DS
     D  @@YY                   1      2
     D  @@YYT                  3      4  0
     D  @SYDT                  3      8
     D                 DS
     D  @@ACB1                 1     18
     D  @@ACB2                 1     18  3
     D                 DS
     D  WKACNM                 1     18
     D  WKACCY                10     12
      **  Data Structure for AOSVALR0 string                                               LUC109CC1
     DSVAL1            DS           200                                                    LUC109CC1
     DSVAL11                   1      1                                                    LUC109CC1
     IGLRECOPF                                                                  S01158
     I              RECID                       DRECID                          S01158
     I              C9151                       DC9151                          S01158
     I              C9150                       DC9150                          S01158
     I              C0301                       DC0301                          S01158
     IRECTOT                                                                    S01158
     I              RECID                       TRECID                          S01158
     I              C9151                       TC9151                          S01158
     I              C9150                       TC9150                          S01158
     I              C0301                       TC0301                          S01158
      *****************************************************************
      *
     C                   EXSR      #S200                                        Main process
      *
     C                   EXSR      #S300                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  Initialisation
      *
      ** Initialise Database Error data structure
     C     *DTAARA       DEFINE    LDA           WLDA            256
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     WLDA          DBERR
     C                   OUT       WLDA
      *
      ** Key list/parameter list definition
     C     @@KEY         KLIST
     C                   KFLD                    XXRSNO            1
     C                   KFLD                    XXACCD            4
     C                   KFLD                    XXDRCR            1
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
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN98
     C                   MOVE      '9'           XXRSNO
      *
     C                   READ      SDBANKPD                               98    Bank details
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL(P)  'SDBANKPD'    DBFILE                         * DB ERR  001 *
     C                   MOVE(P)   *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPP                               98    Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL(P)  'SDGELRPP'    DBFILE                         * DB ERR  002 *
     C                   MOVEL(P)  *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Determine which Branch is used for bank/company code
     C     BJSLCD        CHAIN     SDINTFPD                           98        Bank Extension
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     3             DBASE                          ***************
     C                   MOVEL(P)  'SDINTFPD'    DBFILE                         * DB ERR  003 *
     C                   MOVEL(P)  *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine Bank/company code for header
     C     S9BRCH        CHAIN     SDBRCHL1                           98        Branch
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     4             DBASE                          ***************
     C                   MOVEL(P)  'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVE(P)   *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               98    Gl ICD
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     5             DBASE                          ***************
     C                   MOVEL(P)  'SDGELRPD'    DBFILE                         * DB ERR  006 *
     C                   MOVE(P)   *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Audit report Header fields
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
      *
      ** System Date
     C                   MOVE      UDATE         @SYDT
     C     @@YYT         IFGT      50
     C                   MOVE      '19'          @@YY
     C                   ELSE
     C                   MOVE      '20'          @@YY
     C                   ENDIF
     C                   MOVE      DATST         FSYSD
      *
      ** Last Accounting Date
     C                   MOVE      MLACT         FLACD
     C*                    CALL 'GLM053'
     C*                    PARM           BKAPDT
     C*                    PARM           FLACD
     C*                    PARM *ZERO     WFLACD  80
     C*                    MOVE WFLACD    FLACD
      *
      ** Last Working Day of Month
     C                   MOVE      MMDAT         FLWDM
      *
      ** Next Working Day
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD
     C*                    PARM           FNWKD
     C                   PARM      *ZERO         WFNWKD            8 0
     C                   MOVE      WFNWKD        FNWKD
      *
      ** Write Header Record
     C                   MOVE      '00'          RECC
     C                   MOVEL(P)  HEADER        DATA
      *
     C                   WRITE     FECRFF
      *
      ** Increment The Record Count
     C                   Z-ADD     1             COUNT             6 0
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #S200  -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls:     #S210    -   Generate Detail Records              *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      ** Read all Branches
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               20
      *
      ** Continue Reading Branch file until end-of-file
     C     *IN20         DOWEQ     *OFF
      *
      ** Branch Code
     C                   MOVEL(P)  A8BRCD        FBRCD
      *
      ** Write Branch Header Record
     C                   MOVE      '02'          RECC
     C                   MOVEL(P)  BRCHHD        DATA
     C                   WRITE     FECRFF
      *
      ** Increment record Count
     C                   ADD       1             COUNT
      *
     C                   MOVE      A8CMCD        FBKCD
      *
      **  Generate Detail Records
     C                   EXSR      #S210
      *
      *
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FECRFF
     C                   ADD       1             COUNT
      *
      *  Read Next record
     C                   READ      SDBRCHL1                               20
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S210  -  Generate Detail Records                            *
      *                                                               *
      *            Breaks the work file down from three records and   *
      *            creates a work file record.                        *
      *                                                               *
      *  Called By:  #S200 - Main process                             *
      *  Calls:      None                                             *
      *                                                               *
      *****************************************************************
      *
     C     #S210         BEGSR
      *
      * Read all Customer Details for the Branch
     C     FBRCD         SETLL     WKFECRF
     C     FBRCD         READE     WKFECRF                                21
      *
      ** Process all customer records until end of file
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
      *                                                                                    LUC109CC1
      ** Omit transactions with either G/L Code is zero                                    LUC109CC1
     C     WKLGLC        IFNE      *ZEROS                                                  LUC109CC1
     C     WKLGCC        ANDNE     *ZEROS                                                  LUC109CC1
     C     NY_Amend      ANDEQ     'Y'                                                     LUC109CC1
     C     NY_Amend      ORNE      'Y'                                                     LUC109CC1
      ** Write Detail Records - Write first record sequence
      *
      **   Contains     Companys code
     C                   MOVEL     WKCMCD        C9003
      **                Branch code
     C                   MOVEL     WKBRCD        C0120
      **                Module Code
     C                   MOVEL     WKMDCD        C9149
      **                Deal Number
     C                   MOVEL     WKDLNO        C9150
      **                Account Number for Contingent Liabilities
     C                   MOVEL     WKCACC        C9151
      **                Anagraphic code
     C                   MOVEL     WKCUST        C5125
      **                Currency code
     C                   MOVEL     WKCCYC        C0150
      **                Charges debited in the month
     C                   MOVEL     WKCRDB        C9112
      *
     C                   MOVE      '05'          RECC
     C                   MOVEL(P)  DET001        DATA
     C                   WRITE     FECRFF
      *
      ** Write second record sequence
      **   Contains     Commisions debited in the month
     C                   MOVEL     WKCMDB        C9113
      **                Issuing Date
     C                   MOVEL     WKISSD        C0051
      **                Expiry Date
     C                   MOVEL     WKEXPD        C0052
      **                Facility Type
     C                   MOVEL     WKFTYP        C9019
      **                Facility Number
     C                   MOVEL     WKFSEQ        C9020
      **                Creedit Line starting date
     C                   MOVEL     WKCSDE        C9021
      **                Credit Line expiry date
     C                   MOVEL     WKCEDE        C9022
      **                Local G/L code - Contingent
     C                   MOVEL     WKLGLC        C9153
      **                Local G/L code - Contingent Contra
     C                   MOVEL     WKLGCC        C9154
      **                Country Code
     C                   MOVEL     WKCCCL        C0110
      **                Facility Customer                                 MUI010
     C                   MOVEL     WKFCUS        C9802                                         MUI01
      *
     C                   MOVE      '05'          RECC
     C                   MOVEL(P)  DET002        DATA
     C                   WRITE     FECRFF
      *
      ** Write third record sequence
      **   Contains     Accounting Balance
     C                   MOVEL(P)  WKACCB        C0301
      **                Yearly Commission Percentage
     C                   MOVEL(P)  WKYCOP        C0441
      **                Type of Liability
     C                   MOVEL(P)  WKLIBT        C0581
      **                Released/Requested to
     C                   MOVEL(P)  WKRRQT        C0582
      **                Consortium Transaction
     C                   MOVEL(P)  WKCTRN        C0584
      **                Underlying Transaction
     C                   MOVEL(P)  WKTUDT        C0637
      **                Export Transaction
     C                   MOVEL(P)  WKLETR        C0638
      **                Confirming Banks Customer Number
     C                   MOVEL(P)  WKPCNB        C9140
      **                Beneficiary Country Code
     C                   MOVEL(P)  WKBNCC        C9141
      **                Credit Type
     C                   MOVEL(P)  WKCDTP        C0814
      **                Maturity Code
     C                   MOVEL(P)  WKMATC        C5064
      **                Consortium Customer Number
     C                   MOVEL(P)  WKCTAN        C5653
      **                BSPL code
     C                   MOVEL(P)  WKBSPA        C9343
      **                BSPL Code - Contra
     C                   MOVEL(P)  WKBSPB        C9344
      *
     C                   MOVE      '05'          RECC
     C                   MOVEL(P)  DET003        DATA
     C                   WRITE     FECRFF
      *
      ** Increment record Count
     C                   ADD       3             COUNT
      *
      * Maintain Account Balances for reconciliation
     C     WKCACC        IFNE      *BLANKS
     C                   MOVE      WKCACC        WKACNM
     C                   EXSR      #RECO
     C                   ENDIF
      ** reset record formats
     C                   RESET                   DET001
     C                   RESET                   DET002
     C                   RESET                   DET003
      *
     C                   ENDIF                                                             LUC109CC1
      *                                                                                    LUC109CC1
      ** Read Next record
     C     FBRCD         READE     WKFECRF                                21
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #RECO  -  Maintain Account Balances for Reconciliation       *
      *                                                               *
      *  Called By: #S200                                             *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
     C     #RECO         BEGSR
     C*
     C                   MOVEL     WKACCB        WKSIGN            1
     C                   MOVE      WKACCB        WKACBL           18
     C* Account Balance Blanks
     C     WKACBL        IFEQ      *BLANKS
     C                   Z-ADD     *ZERO         @@ACBL           18 3
     C                   ELSE
     C                   MOVE      WKACBL        @@ACB1
     C                   Z-ADD     @@ACB2        @@ACBL
     C                   ENDIF
     C*
     C* Account Balance not zero
     C     @@ACBL        IFNE      *ZERO
      * Access currency to determine no. of decimal places
     C     WKACCY        CHAIN     SDCURRL0                           98
      *
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   Z-ADD     10            DBASE                          ***************
     C                   MOVEL(P)  'SDCURRL0'    DBFILE                         * DB ERR  006 *
     C                   MOVEL(P)  WKACCY        DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     A6NBDP        IFEQ      1
     C                   MULT      10            @@ACBL
     C                   ENDIF
      *
     C     A6NBDP        IFEQ      2
     C                   MULT      100           @@ACBL
     C                   ENDIF
      *
     C     A6NBDP        IFEQ      3
     C                   MULT      1000          @@ACBL
     C                   ENDIF
      *
     C                   ENDIF
     C*
     C* Account Balance Negative - remember signs have been reversed.
     C     WKSIGN        IFEQ      '+'
     C                   Z-SUB     @@ACBL        @@ACBL
     C                   ENDIF
      *
      * Write Account Balance Detail Information
      *
     C                   MOVE      'D'           DRECID
     C                   MOVEL     WKACNM        DC9151
     C                   MOVEL     WKDLNO        DC9150
     C                   Z-ADD     @@ACBL        DC0301
      *
     C                   WRITE     GLRECOPF
      *
      * Access Account Balance Total Information
      *
     C     WKACNM        CHAIN     RECTOT                             30
      *
      * Write Account Balance Total Information
     C     *IN30         IFEQ      *ON
     C                   MOVE      'T'           DRECID
     C                   MOVEL     WKACNM        DC9151
     C                   MOVE      *BLANKS       DC9150
     C                   Z-ADD     @@ACBL        DC0301
      *
     C                   WRITE     GLRECOPF
      *
     C                   ELSE
      *
      * Update Account Balance Total Information
     C                   ADD       @@ACBL        TC0301
      *
     C                   UPDATE    RECTOT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine  :  #S300                                         *
      *                                                               *
      *  Function    : Program termination er details built via S220  *
      *                 (if Daily) or Via S230 if monthly to the      *
      *                 Itialian customer details transmision file    *
      *                 FECRF                                         *
      *                                                               *
      *                 It builds in sequence the three Customer      *
      *                                                               *
      *  Called by   :  Main Process                                  *
      *                 Controls the flow of the program              *
      *                                                               *
      *  Calls       :  None                                          *
      *                                                               *
      *****************************************************************
      *
     C     #S300         BEGSR
      *
      ** Check switches to determine if Database error detected
     C     *IN88         IFEQ      *ON                                          Database error
      *
      ** Print audit report & stop run
     C                   WRITE     HEADAU                                       Report header
     C                   WRITE     DBERROR                                      Report error
      *
     C                   ELSE
      *
      ** Write Trailer Record
     C                   ADD       1             COUNT
     C                   Z-ADD     COUNT         FCONT
     C                   MOVE      '99'          RECC
     C                   MOVE      TRAILR        DATA
     C                   WRITE     FECRFF
      *
     C                   ENDIF
      *
      ** Exit the program
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
     C**********         MOVEL     'GLM032C'     DBPGM                          Set program idLUC109
     C                   MOVEL     'XX00032C'    DBPGM                          Set program idLUC109
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
     C                   EXSR      #S300                                        Stop run
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  Subroutine  :  Dummy                                         *
      *                                                               *
      *  Function    : Dummy read of GLRECOPP for compile purposes    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     DUMMY         BEGSR
      *
     C                   READ      GLRECOPP                               60
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ***
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
