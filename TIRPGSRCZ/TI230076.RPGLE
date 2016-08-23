     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Data Patch Utility Program')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI230076 - Accounts with duplicate TI number and suffix for  *
      *             customer in a particular branch.                  *
      *                                                               *
      *  (c) Copyright Misys International Banking Systems 2005       *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG6597  *CREATE   Date 10May05               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG6597 - Duplicate TI number and suffix for branch customer.*
      *            Applied fix 230076.                                *
      *                                                               *
      *****************************************************************
      *
     FTI23007PD UF A E           K DISK    PREFIX(S_)
     FTI23007L1 IF   E           K DISK
     FTI23007L2 IF   E           K DISK    RENAME(ACCNTABF:SACCNTAB) PREFIX(S_)
     FTI23007L3 UF   E           K DISK    RENAME(ACCNTABF:UACCNTAB) PREFIX(U_)
     FTI23007P1 O    E             PRINTER OFLIND(*IN80)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   10  - If Off = Audit, On = Update                           *
      *   21  - Read TI23007L1                                        *
      *   22  - Chain                                                 *
      *   30  - Record is a duplicate, print counter                  *
      *   40  - First of the duplicate has been printed               *
      *   80  - Page overflow on TI23007P1                            *
      *   LR  - End of program                                        *
      *                                                               *
      *****************************************************************
      *
      ** Copyright Statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local Data Area for Database Error Details
      *
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Bank details and rundate
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for Access Program
      *
     D SPOOL1          DS
     D  OFFLN                188    189B 0
     D  CURLIN               367    368B 0
      *
      ** RUNDAT data structure to pick up system rundate.
      *
     D RUNDT           DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *                                                                                      CSD027A
     DPCNUM            S              6                                                      CSD027A
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  MAIN   - Main Processing                                     *
      *                                                               *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    MODE              1
      *****************************************************************
     C/TITLE Program Start
      *****************************************************************
      *  P R O G R A M   S T A R T                                    *
      *****************************************************************
      *
      ** Perform initial processing
      *
     C                   EXSR      SRINIT
      *
      ** Process main processing
      *
     C                   EXSR      MAIN
      *
     C                   EXSR      SRTALLY
      *
      ** Copyright Statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** End program.
      *
     C                   SETON                                        LR
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
     C/TITLE SR/INIT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initial processing                                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      **   Get RUND from DTAARA/RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDT
      *
      ** Initialise variables.
      *
     C                   Z-ADD     0             SCTR
     C                   MOVE      *BLANKS       PBRCA             3
     C**********         Z-ADD     0             PCNUM             6 0                       CSD027A
     C                   Eval      PCNUM = *BLANKS                                           CSD027A
     C                   MOVE      *BLANKS       PCCY              3
     C                   Z-ADD     0             PACOD            10 0
     C                   Z-ADD     0             PACSQ             2 0
     C                   MOVE      *BLANKS       PTIAN             6
     C                   MOVE      *BLANKS       PTIAS             3
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN40
      *
      ** Define key
      *
     C     KNXTTI        KLIST
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KTIAN             6
     C                   KFLD                    KTIAS             3
      *
     C     KFACCT        KLIST
     C                   KFLD                    KBRCA
     C**********         KFLD                    KCNUM             6 0                       CSD027A
     C                   KFLD                    KCNUM             6                         CSD027A
     C                   KFLD                    KCCY              3
     C                   KFLD                    KACOD            10 0
     C                   KFLD                    KACSQ             2 0
      *
      ** Write headers for reports.
      *
     C     MODE          IFEQ      'U'
     C     MODE          OREQ      'u'
     C                   MOVE      *ON           *IN10
     C                   ELSE
     C                   MOVE      *OFF          *IN10
     C                   ENDIF
      *
     C                   WRITE     HEADP
      *
     C                   ENDSR
      *
      *****************************************************************
     C/TITLE SR/MAIN
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *  Called By: *NONE                                             *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     MAIN          BEGSR
      *
      ** Process FACHISA records
      *
     C                   READ      ACCNTABF                               21
      *
      ** While not EOF, process records.
      *
     C     *IN21         DOWEQ     '0'
      *
     C     *IN80         IFEQ      '1'
     C                   WRITE     HEADP
     C                   MOVE      '0'           *IN80
     C                   ENDIF
      *
     C     PBRCA         IFEQ      BRCA
     C     PTIAN         ANDEQ     A5TIAN
     C     PTIAS         ANDEQ     A5TIAS
      *
      ** Print the record that have duplicate(s)
      *
     C     *IN40         IFEQ      *OFF
     C                   MOVE      *OFF          *IN30
     C                   MOVE      PBRCA         SBRCA
     C**********         Z-ADD     PCNUM         SCNUM                                       CSD027A
     C                   EVAL      SCNUM = PCNUM                                             CSD027A
     C                   MOVE      PCCY          SCCY
     C                   Z-ADD     PACOD         SACOD
     C                   Z-ADD     PACSQ         SACSQ
     C                   MOVE      PTIAN         STIAN
     C                   MOVE      PTIAS         STIAS
     C                   WRITE     SPACE
     C                   WRITE     DETAIL
     C                   MOVE      *ON           *IN40
     C                   ENDIF
      *
      ** Setup details of the duplicate record(s)
      *
     C     SCTR          ADD       1             SCTR
     C                   MOVE      *ON           *IN30
     C                   MOVE      BRCA          SBRCA
     C*********          Z-ADD     CNUM          SCNUM                                       CSD027A
     C                   Eval      SCNUM = CNUM                                              CSD027A
     C                   MOVE      CCY           SCCY
     C                   Z-ADD     ACOD          SACOD
     C                   Z-ADD     ACSQ          SACSQ
     C                   MOVE      A5TIAN        STIAN
     C                   MOVE      A5TIAS        STIAS
      *
      ** Retrieve the last suffix number and increment by 1
      *
     C                   MOVE      BRCA          KBRCA
     C                   MOVE      A5TIAN        KTIAN
     C                   MOVE      A5TIAS        S_A5TIAS
     C                   MOVE      *OFF          *IN22
      *
     C     *IN22         DOWEQ     *OFF
     C                   MOVE      S_A5TIAS      WTIAS             3 0
     C     WTIAS         ADD       1             WTIAS
     C     WTIAS         IFEQ      0
     C     WTIAS         ADD       1             WTIAS
     C                   ENDIF
     C                   MOVE      WTIAS         KTIAS
     C     KNXTTI        CHAIN     SACCNTAB                           22
      *
     C     *IN22         IFEQ      *ON
     C     KNXTTI        CHAIN     TI23007PD                          22
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Update Mode
      ** Update corresponding record
      *
     C     *IN10         IFEQ      *ON
     C*********          Z-ADD     CNUM          KCNUM                                       CSD027A
     C                   Eval      KCNUM = CNUM                                              CSD027A
     C                   MOVE      CCY           KCCY
     C                   Z-ADD     ACOD          KACOD
     C                   Z-ADD     ACSQ          KACSQ
     C     KFACCT        CHAIN     UACCNTAB                           22
     C                   MOVE      WTIAS         U_A5TIAS
     C                   UPDATE    UACCNTAB
      *
      ** Audit Mode
      ** Insert record into TI23007PD and write record to report
      *
     C                   ELSE
     C                   MOVE      BRCA          S_BRCA
     C                   MOVE      A5TIAN        S_A5TIAN
     C                   MOVE      WTIAS         S_A5TIAS
     C                   WRITE     TI23007PDF
     C                   END
      *
     C                   MOVE      WTIAS         SNTIAS
     C                   WRITE     DETAIL
      *
      ** Record is not duplicate
      *
     C                   ELSE
     C                   MOVE      *OFF          *IN40
     C                   MOVE      *BLANKS       SNTIAS
      *
     C                   END
      *
      ** Save current account details
      *
     C                   MOVE      BRCA          PBRCA
     C*********          Z-ADD     CNUM          PCNUM                                       CSD027A
     C                   Eval      PCNUM = CNUM                                              CSD027A
     C                   MOVE      CCY           PCCY
     C                   Z-ADD     ACOD          PACOD
     C                   Z-ADD     ACSQ          PACSQ
     C                   MOVE      A5TIAN        PTIAN
     C                   MOVE      A5TIAS        PTIAS
      *
      ** Read next record on LF/TI23007L1
      *
     C                   READ      ACCNTABF                               21
      *
     C                   ENDDO
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle error conditions                *
      *                                                               *
      *  Called from:  After abnormal operation occurs                *
      *                                                               *
      *  Calls: Nothing                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   ENDSR
     C*****************************************************************
      *                                                               *
      *  SRTALLY - Subroutine for printing total in report.           *
      *                                                               *
      *  CALLED FROM:  Main Processing                                *
      *                                                               *
      *  CALLS: Nothing                                               *
      *                                                               *
      *****************************************************************
     C     SRTALLY       BEGSR
      *
      ** If no records were processed print '*** NO DETAILS TO REPORT ***'
      *
     C                   WRITE     BLANK
      *
     C     *IN80         IFEQ      *ON
     C                   WRITE     HEADP
     C                   WRITE     BLANK
     C                   ENDIF
      *
     C     SCTR          IFEQ      0
     C                   WRITE     BLANK
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     TOTAL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
** CPY@ **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2005
