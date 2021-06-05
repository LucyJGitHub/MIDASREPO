     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Bills and Document Extract Post Merge')             *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM033C*-*GL*Bills*and*Document*Extract*Post*Merge************                       LUC109
      *  XX00033C - GL Bills and Document Extract Post Merge          *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Bills and Documents Extract                        *
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
      *                 MMI043             Date 17Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Credito Italiano Extracts                           *
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
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FWKFEPTF0  IF   F  320     3AIDISK    INFSR(*PSSR)
     F                                     KEYLOC(10)
     FFEPTF     O    E             DISK    INFSR(*PSSR)
     F*GLRECOPPO   E                    DISK         KINFSR *PSSR
     F*GLRECOV0UF  E           K        DISK         KINFSR *PSSR
     F*            GLRECOPF                          KRENAMERECTOT
     F*SDCURRL0IF  E           K        DISK         KINFSR *PSSR
     F***GLM033AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000033AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/WKFEPTF0   File I/O                                 *
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
      *  #RECO  - Maintain Account Balances for reconciliation        *
      *  #ERR   - Error Reporting                                     *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
      *
      ***File*information*for*printer*file*GLM033AU********************                       LUC109
      ** File information for printer file XX000033AU                                         LUC109
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
     D* DATA FIELD
     D DATFLD          DS
     D  @@DTA1                 1      2
     D  @@DTA2                 3     80
     D                 DS
     D  @@ACB1                 1     18
     D  @@ACB2                 1     18  3
     I*                   @ERR    1   1 35
      *
     IWKFEPTF0  NS
      **  FEPTF WORK FILE
      *
     I                                  1   80  WKFLD1
     I                                 81  160  WKFLD2
     I                                 86  100  WKTRAN
     I                                101  118  WKACNM
     I                                110  112  WKACCY
     I                                161  240  WKFLD3
     I                                241  320  WKFLD4
     I                                276  276  WKSIGN
     I                                277  294  WKACBL
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
      ** Initial housekeeping
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@PSSR            1            *PSSR Control
     C                   MOVE      *OFF          *IN98
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
      *                                                                   CEU011
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       FILL04
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FEPTF'       FEXFL
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
     C                   WRITE     FEPTFF
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
     C                   WRITE     FEPTFF
     C                   ADD       1             COUNT
      *
     C                   MOVE      '05'          RECC
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FEPTFF
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
      *  Calls:     #RECO                                             *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all WKFEPTF0 records for the branch
      *
     C     FBRCD         SETLL     WKFEPTF0
     C     FBRCD         READE     WKFEPTF0                               21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
      *
      *  Write Detail Record 1
     C                   MOVE      WKFLD1        DATFLD
     C                   MOVE      @@DTA2        DATA
     C                   WRITE     FEPTFF
     C                   ADD       1             COUNT
      *
      *
      *  Write Detail Record 2
     C                   MOVE      WKFLD2        DATFLD
     C                   MOVE      @@DTA2        DATA
     C                   WRITE     FEPTFF
     C                   ADD       1             COUNT
      *
      *
      *  Write Detail Record 3
     C                   MOVE      WKFLD3        DATFLD
     C                   MOVE      @@DTA2        DATA
     C                   WRITE     FEPTFF
     C                   ADD       1             COUNT
      *
      *
      *  Write Detail Record 4
     C                   MOVE      WKFLD4        DATFLD
     C                   MOVE      @@DTA2        DATA
     C                   WRITE     FEPTFF
     C                   ADD       1             COUNT
      *
      * Maintain Account Balances for reconciliation
     C*          WKACNM    IFNE *BLANKS
     C*                    EXSR #RECO
     C*                    ENDIF
      *
      *  Read Next record
     C     FBRCD         READE     WKFEPTF0                               21
      *
      *
     C                   ENDDO
      *
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
     C*          #RECO     BEGSR
     C*
     C* Account Balance Blanks
     C*          WKACBL    IFEQ *BLANKS
     C*                    Z-ADD*ZERO     @@ACBL 183
     C*                    ELSE
     C*                    MOVE WKACBL    @@ACB1
     C*                    Z-ADD@@ACB2    @@ACBL
     C*                    ENDIF
     C*
     C* Account Balance not zero
     C*          @@ACBL    IFNE *ZERO
      * Access currency to determine no. of decimal places
     C*          WKACCY    CHAINSDCURRL0             50
      *
     C*          *IN50     IFEQ *ON                        Ended in error
     C*                    MOVE *BLANKS   REPPRG
     C*                    MOVE *BLANKS   REPMSG
     C*                    MOVE *BLANKS   REPKEY
     C*                    MOVE *BLANKS   REPDTA
     C*                    MOVELWKACNM    REPACN
     C*                    MOVEL'#RECO'   REPPRG
     C*                    MOVEL@ERR,1    REPMSG
     C*                    MOVELWKACCY    REPKEY
     C*                    EXSR #ERR
     C*                    Z-ADD*ZERO     A6NBDP           Decimal places
     C*                    ENDIF
      *
     C*          A6NBDP    IFEQ 1
     C*                    MULT 10        @@ACBL
     C*                    ENDIF
      *
     C*          A6NBDP    IFEQ 2
     C*                    MULT 100       @@ACBL
     C*                    ENDIF
      *
     C*          A6NBDP    IFEQ 3
     C*                    MULT 1000      @@ACBL
     C*                    ENDIF
      *
     C*                    ENDIF
     C*
     C* Account Balance Negative - remember sign has been reversed.
     C*          WKSIGN    IFEQ '+'
     C*                    Z-SUB@@ACBL    @@ACBL
     C*                    ENDIF
      *
      * Write Account Balance Detail Information
      *
     C*                    MOVE 'D'       RECID
     C*                    MOVE WKACNM    C9151
     C*                    MOVE WKTRAN    C9150
     C*                    Z-ADD@@ACBL    C0301
      *
     C*                    WRITEGLRECOPF
      *
      * Access Account Balance Total Information
      *
     C*          WKACNM    CHAINRECTOT               30
      *
      * Write Account Balance Total Information
     C*          *IN30     IFEQ *ON
     C*                    MOVE 'T'       RECID
     C*                    MOVE WKACNM    C9151
     C*                    MOVE *BLANKS   C9150
     C*                    Z-ADD@@ACBL    C0301
      *
     C*                    WRITEGLRECOPF
      *
     C*                    ELSE
      *
      * Update Account Balance Total Information
     C*                    ADD  @@ACBL    C0301
      *
     C*                    UPDATRECTOT
      *
     C*                    ENDIF
      *
     C*                    ENDSR
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
     C                   WRITE     FEPTFF
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
     C**********         MOVEL     'GLM033C'     DBPGM                          Set program idLUC109
     C                   MOVEL     'XX00033C'    DBPGM                          Set program idLUC109
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
      *****************************************************************
      *                                                               *
      *    #ERR      - Error Reporting                                *
      *                                                               *
      *    CALLED BY - #RECO                                          *
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
(c) Finastra International Limited 2016
