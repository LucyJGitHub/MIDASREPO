     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Guarantees Extract')                                *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM039**-*GL*Guarantees*Extract*******************************                       LUC109
      *  XX000039 - GL Guarantees Extract                             *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Guarantees Extract                                 *
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. MD054523           Date 21Oct19               *
      *  Prev Amend No. LUC109             Date 20Sep16               *
      *                 159964             Date 22Aug99               *
      *                 MMI043             Date 10Dec98               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054523 - Abu Dhabi Branch - Wrong file FESEC HOR.          *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  159964 - PGM/GLM032A cannot allocate object LF/SDCUSTL0 due  *
      *           to SCC0406.                                         *
      *         - Seton job switches U7/U8 for error processing       *
      *  MMI043 - Guarantees Extract                                  *
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
     FGTEESBR   IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FCLOANL9   IF   E           K DISK    INFSR(*PSSR)
     FFESEC     O    E             DISK    INFSR(*PSSR)
     F***GLM039AU  O    E             PRINTER INFDS(SPOOL)                                    LUC109
     FXX000039AUO    E             PRINTER INFDS(SPOOL)                                       LUC109
     F                                     INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - LF/GTEESBR    File I/O                                 *
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
      *  #ERR   - Error Reporting                                     *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      * COMPILE TIME ARRAYS                                           *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D @ERR            S             35    DIM(3) CTDATA PERRCD(1)
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
     D  F1LOAN                21     26  0
     D  F1SEQN                27     29  0
     D  F1STDT                30     37
     D  F1ENDT                38     45
     D  F1RVDT                46     53
     D  F1CCYC                54     56
     D  F1UNAM                57     75
     D  F1FILL                76     78
      *
      ** Detail Record 2
      *
     D DET002          DS
     D  F2PROG                 1      3
     D  F2NMIT                 4      8  0
     D  F2COLC                 9     11
     D  F2NARR                12     46
     D  F2GVBY                47     52  0
     D  F2FILL                53     78
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
     D* DATESTAMP
     D @@FCLN          DS
     D  @@FLI                  1      1
     D  @@FCT                  2      4  0
     D  @@FCN                  5      6  0
     D* ERROR DATA STRUCTURE
     D REPAMT          DS
     D  REPCCY                 1      3
     D  REPVAL                 4     18  0
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
      *
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
     C*
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       F1FILL
     C                   MOVE      *BLANKS       F2FILL
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      '001'         F1PROG
     C                   MOVE      '002'         F2PROG
     C*
     C* SET UP HEADER FIELDS
     C*
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FESEC'       FEXFL
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
     C                   WRITE     FESECF
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
     C                   WRITE     FESECF
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
     C                   WRITE     FESECF
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
     C     FBRCD         SETLL     GTEESBR
     C     FBRCD         READE     GTEESBR                                21
      *
      *
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        DATA
     C                   WRITE     FESECF
     C                   ADD       1             COUNT
      *
      *
     C                   EXSR      #S202
      *
      *  Write Detail Record 2
     C                   MOVE      DET002        DATA
     C                   WRITE     FESECF
     C                   ADD       1             COUNT
      *
      *
      *  Read Next record
     C     FBRCD         READE     GTEESBR                                21
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
      *
      * Determine whether guarantee is for a loan or facility
     C                   MOVE      FCLN          @@FCLN
     C*****@@FLI         IFEQ      'F'                                          Facility    MD054523
      *                                                                                     MD054523
      ** CLE148 sets position 1 *EQ *Blk for field FCLN in Pf/GTEESGT                       MD054523
      *                                                                                     MD054523
     C     @@FLI         IFEQ      *BLANK                                                   MD054523
      * Facility Type
     C                   Z-ADD     @@FCT         F1FACT
      * Facility Number
     C                   Z-ADD     @@FCN         F1FACN
      * Initialize Loan
     C                   Z-ADD     *ZERO         F1LOAN
     C                   ELSE                                                   Loan
     C*
      * Loan reference
     C                   MOVE      FCLN          F1LOAN
     C     F1LOAN        CHAIN     CLOANL9                            31
     C     *IN31         IFEQ      *OFF
      * Facility Type
     C                   Z-ADD     FTYP          F1FACT
      * Facility Number
     C                   Z-ADD     FSEQ          F1FACN
     C                   ELSE
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     FCLN          REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(1)       REPMSG
     C                   MOVEL     FCLN          REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   EXSR      #ERR
      * Initialize Facility Type
     C                   Z-ADD     *ZERO         F1FACT
      * Initialize Facility Number
     C                   Z-ADD     *ZERO         F1FACN
     C                   ENDIF
     C*
     C                   ENDIF
      * Sequence Number
     C                   Z-ADD     GUSN          F1SEQN
      * Start Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    STTD
     C*                    PARM           F1STDT
     C                   PARM      *ZERO         W1STDT            8 0
     C                   MOVE      W1STDT        F1STDT
      * End Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    EDDT
     C*                    PARM           F1ENDT
     C                   PARM      *ZERO         W1ENDT            8 0
     C                   MOVE      W1ENDT        F1ENDT
      * Review Date
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    RVDT
     C*                    PARM           F1RVDT
     C                   PARM      *ZERO         W1RVDT            8 0
     C                   MOVE      W1RVDT        F1RVDT
      * Currency
     C                   MOVE      CCY           F1CCYC
      * Unit Amount
     C                   Z-ADD     UAMT          @@AMT
     C                   MOVE      'N'           IERROR            1
     C**********         CALL      'GLM041'                                                   LUC109
     C                   CALL      'XX000041'                                                 LUC109
     C                   PARM                    F1CCYC
     C                   PARM                    @@AMT            15 0
     C                   PARM                    F1UNAM
     C                   PARM                    IERROR
      *
     C     IERROR        IFEQ      'Y'                                          Ended in error
     C                   MOVE      *BLANKS       REPPRG
     C                   MOVE      *BLANKS       REPMSG
     C                   MOVE      *BLANKS       REPKEY
     C                   MOVE      *BLANKS       REPDTA
     C                   MOVEL     FCLN          REPACN
     C                   MOVEL     '#S201'       REPPRG
     C                   MOVEL     @ERR(2)       REPMSG
     C                   MOVEL     '*NONE'       REPKEY
     C                   MOVE      CCY           REPCCY
     C                   Z-ADD     UAMT          REPVAL
     C                   MOVEL     REPAMT        REPDTA
     C                   EXSR      #ERR
     C                   ENDIF
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
      * Number of Items
     C                   Z-ADD     NOUN          F2NMIT
      *
      * Collateral Code
     C                   MOVE      COLC          F2COLC
      *
      * Narrative
     C                   MOVE      NARR          F2NARR
      *
      * Given by
     C                   Z-ADD     GBCN          F2GVBY
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
     C                   WRITE     FESECF
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
     C**********         MOVEL     'GLM039'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000039'    DBPGM                          Set program idLUC109
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
      *    CALLED BY - #S200                                          *
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
      /EJECT
      *****************************************************************
      ***
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
**  @ERR
CLOANL9 RECORD NOT FOUND
XX000041 UNABLE TO CONVERT AMOUNT
