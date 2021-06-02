     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('SDACODPD Extract')                                     *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM201**-*SDACODPD*Extract************************************                       LUC109
      *  XX000201 - SDACODPD Extract                                  *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Extract the complete account codes file            *
      *                                                               *
      *                                                               *
      *  CALLED BY  XXXXXXXX- XXXXXXXXXXXXXXXXXXXXXXXX                *
      *             Frequency: Automatically in Close of Business     *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. nnnnnn             Date ddMmmyy               *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
     FSDBANKL1  IF   E           K DISK    INFSR(*PSSR)
     FSDACODPD  IF   E             DISK
     FSDGELRPP  IF   E             DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FSDINTFPD  IF   E           K DISK    INFSR(*PSSR)
     FFEMID     O    E             DISK
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   20 - LF/SDBRCHL1   File I/O                                 *
      *   21 - PF/SDACODPD   File I/O                                 *
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
      *  #TERM  - Program termination                                 *
      *                                                               *
      *****************************************************************
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
     D  F1ACCD                 4      7
     D  F1ACCN                 8     57
     D  F1ACTY                58     58
     D  F1TOIN                59     59
     D  F1ACSC                60     61
     D  F1ACST                62     62
     D  F1FILL                63     78
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
      ** Initialise Database Error data structure
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     WLDA          DBERR
     C                   OUT       WLDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   Z-ADD     0             DBASE
      *
     C     *LOVAL        SETLL     SDBANKL1
     C                   READ      SDBANKL1                               98    Bank details
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
      *
      * Determine which Branch is used for bank/company code
     C     BJSLCD        CHAIN     SDINTFPD                           98        Bank Extension
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '003'         DBASE                          ***************
     C                   MOVEL     'SDINTFPD'    DBFILE                         * DB ERR  003 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Determine Bank/company code for header
     C     S9BRCH        CHAIN     SDBRCHL1                           98        Branch
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '004'         DBASE                          ***************
     C                   MOVEL     'SDBRCHL1'    DBFILE                         * DB ERR  004 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SDGELRPD                               98    Gl ICD
     C     *IN98         IFEQ      *ON                                          Ended in error
     C                   MOVEL     '006'         DBASE                          ***************
     C                   MOVEL     'SDGELRPD'    DBFILE                         * DB ERR  006 *
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       FILL01
     C                   MOVE      *BLANKS       FILL02
     C                   MOVE      *BLANKS       FILL04
     C                   MOVE      *BLANKS       F1FILL
     C                   MOVE      '001'         F1PROG
     C*
     C* SET UP HEADER FIELDS
     C                   MOVE      A8CMCD        FBKCD
     C                   MOVE      BJSLCD        FGPCD
     C                   MOVEL     'FEMID'       FEXFL
     C*
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
      *
      * Next Working Day
     C**********         CALL      'GLM053'                                                   LUC109
     C                   CALL      'XX000053'                                                 LUC109
     C                   PARM                    BJDNWD
     C*                    PARM           FNWKD
     C                   PARM      *ZERO         WFNWKD            8 0
     C                   MOVE      WFNWKD        FNWKD
      *
      *  Write Header Record
     C                   MOVE      '00'          RECC
     C                   MOVE      HEADER        DATA
     C                   WRITE     FEMIDF
     C                   Z-ADD     1             COUNT             6 0
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
      *
      * Read all Branches
     C     *LOVAL        SETLL     SDBRCHL1
     C                   READ      SDBRCHL1                               20
      *
     C     *IN20         DOWEQ     *OFF                                         Until eof
      * Branch Code
     C                   MOVE      A8BRCD        FBRCD
      *
      *  Write Branch Header Record
     C                   MOVE      '02'          RECC
     C                   MOVE      BRCHHD        DATA
     C                   WRITE     FEMIDF
     C                   ADD       1             COUNT
      *
     C                   MOVE      '05'          RECC
      *
      *   Generate Detail Records
     C                   EXSR      #S200
      *
      *  Generate Detail Records For SYSTEM records if reporting branch
     C     FBRCD         IFEQ      S9BRCH
     C                   MOVE      'SYS'         FBRCD
     C                   EXSR      #S200
     C                   ENDIF
      *  Write Branch Trailer Record
     C                   MOVE      '09'          RECC
     C                   MOVE      *BLANKS       DATA
     C                   WRITE     FEMIDF
     C                   ADD       1             COUNT
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
      *  Calls:     #S201                                             *
      *                                                               *
      *****************************************************************
      *
     C     #S200         BEGSR
      *
      * Read all account codes
      *
     C                   READ      SDACODPD                               21
     C     *IN21         DOWEQ     *OFF                                         Until eof
      *
      *  Format fields
     C                   EXSR      #S201
      *
      *  Write Detail Record 1
     C                   MOVE      DET001        DATA
     C                   WRITE     FEMIDF
     C                   ADD       1             COUNT
      *
      *  Read Next record
     C                   READ      SDACODPD                               21
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  #S201  -  Set up Detail records 1                            *
      *                                                               *
      *  Called By: #S200                                             *
      *                                                               *
      *****************************************************************
      *
     C     #S201         BEGSR
      *
     C                   MOVE      A5ACCD        F1ACCD
     C                   MOVE      A5ACTY        F1ACTY
     C                   MOVEL     A5ACCN        F1ACCN
     C                   MOVE      A5TOIN        F1TOIN
     C                   MOVE      A5ACSC        F1ACSC
     C                   MOVE      A5ACST        F1ACST
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
      *
     C                   MOVE      'Y'           @@PSSR            1            *PSSR Executed
      *
      ** Update local data area
      *
     C     DBPGM         IFEQ      *BLANKS
     C**********         MOVEL     'GLM201'      DBPGM                          Set program idLUC109
     C                   MOVEL     'XX000201'    DBPGM                          Set program idLUC109
     C                   ENDIF
      *
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   MOVE      *ON           *IN89                          Database error
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
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
      *  Write Trailer Record
     C                   ADD       1             COUNT
     C                   Z-ADD     COUNT         FCONT
     C                   MOVE      '99'          RECC
     C                   MOVE      TRAILR        DATA
     C                   WRITE     FEMIDF
      *
     C                   MOVE      *ON           *INLR                          Last record
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
