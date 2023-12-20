     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Utility Update Program for DEALSDB ')         *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  SMU91003 - Midas SM Utility Update Program for Deal's Repli- *
      *             cation Indicator field in DEALSDB file.           *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD061168  *CREATE  Date 14Dec23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061168 - Matured Deals not showing in FX Deals Screens     *
      *           - Update old FX deals Replication Indicator (field  *
      *             REPI in DEALSDB) to blank in order for the sys-   *
      *             tem to move them in historic files.               *
      *                                                               *
      *****************************************************************
      *
     FDEALALL   UF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
     FSMU91003P1O    E             PRINTER OFLIND(*IN82)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   82    - Page overflow on SMU91003P1                         *
      *   LR    - End of Program                                      *
      *   U7,U8 - Database error occured.                             *
      *                                                               *
      *****************************************************************
     F/SPACE 3
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D WRUN            S              1
     D HUT113          S              1A
      *
      ** Access Object Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRMAIN1 - Main Processing 01                                 *
      *  SRPRT01 - Generate reports 01                                *
      *  *PSSR  - Error Processing                                    *
      *                                                               *
      *****************************************************************
      *
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
      ** Perform main routine for DEALSDB processing if HUT113 is ON.
      *
     C                   IF        HUT113 = 'Y'
     C                   EXSR      SRMAIN1
     C                   ENDIF
      *
      ** Perform No details / Totals printing.
      *
     C                   IF        *IN82 = '1'
     C                   WRITE     HEADP1
     C                   EVAL      *IN82 = '0'
     C                   ENDIF
      *
     C                   IF        TOTAL1 = 0
     C                   WRITE     NODETP1
     C                   ELSE
     C                   WRITE     TOTALP1
     C                   ENDIF
      *
      ** End program.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
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
      ** Initialize work variables.
      *
     C                   EVAL      TOTAL1 = 0
     C                   EVAL      WRUN = ' '
      *
 ** C ** Check if feature HUT113 is installed.
      *
     C                   EVAL      HUT113 = 'N'
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'HUT113'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF'
     C                   EVAL      DBFILE = 'SCSRDXTD'
     C                   EVAL      DBASE = '001'
     C                   EVAL      DBKEY = PSARD
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      HUT113 = 'Y'
     C                   ENDIF
      *
      ** Perform initial printing of report header.
      *
     C                   WRITE     HEADP1
      *
     C                   ENDSR
      *
      *****************************************************************
     C/TITLE SR/SRMAIN1
      *****************************************************************
      *                                                               *
      *  SRMAIN1 - Main Routine                                       *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN1       BEGSR
      *
      ** Update the DEALSDB file for old FX deals.
      *
     C     *LOVAL        SETLL     DEALALL
     C                   READ      DEALALL
     C                   DOW       NOT %EOF(DEALALL)
      *
      ** If Replication Indicator is 'Y' and Record Id is not 'D',
      ** perform update.
      *
     C                   IF        REPI = 'Y' AND RECI <> 'D'
      *
      ** Update Replication Indicator to blank.
      *
     C                   EVAL      REPI = ' '
      *
     C                   UPDATE    DEALSDBF
      *
      ** Perform report printing.
      *
     C                   CLEAR                   DTL01
      *
     C                   ADD       1             TOTAL1
     C                   EVAL      PRECI = RECI
     C                   EVAL      PDLNO = DLNO
     C                   EVAL      PDTYP = DTYP
     C                   EVAL      PDLST = DLST
     C                   EVAL      PREPI = 'Y'
     C                   EVAL      PNREPI = REPI
      *
     C                   EXSR      SRPRT01
      *
     C                   ENDIF
      *
      ** Read next available record.
      *
     C                   READ      DEALALL
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRPSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine.                           *
      *                                                               *
      *  Called By:                                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C     WRUN          IFEQ      *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   IF        *IN82 = '1'
     C                   WRITE     HEADP1
     C                   EVAL      *IN82 = '0'
     C                   ENDIF
      *
     C                   WRITE     DBERROR
      *
      ** Set on indicators to end the program.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
     C/TITLE SR/SRPRINT
      *****************************************************************
      *                                                               *
      *  SRPRT01 - Report the affected record                         *
      *                                                               *
      *  Called By: SRMAIN1                                           *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPRT01       BEGSR
      *
     C                   IF        TOTAL1 > 0
      *
     C                   IF        *IN82 = '1'
     C                   WRITE     HEADP1
     C                   EVAL      *IN82 = '0'
     C                   ENDIF
      *
     C                   WRITE     DTL01
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
** CPY@ **      OBJECT COPYRIGHT
(c) Finastra International Limited 2023
