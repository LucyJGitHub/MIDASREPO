     H DEBUG
     H CCSID(*GRAPH:*SRC)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Utility Update Program for CGCORRPD')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU02000 - Midas SM Utility Update Program for CGCORRPD      *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056543  *CREATE  Date 15Sep20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD to readable  *
      *             unicode equivalent.                               *
      *                                                               *
      *****************************************************************
      *
     FSMCORXPD  IF   E             DISK
     FCGCORRL0  UF A E           K DISK
      *
     FSMU02000P1O    E             PRINTER OFLIND(*IN95)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   95    - Page overflow on SMU02000P1                         *
      *   LR    - End of Program                                      *
      *   U7,U8 - Database error occured.                             *
      *                                                               *
      *****************************************************************
     F/SPACE 3
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank Details

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short data structure


     D LDA             DS           256
      ** Define LDA
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0

     D RUNDT           DS
      ** RUNDAT data structure to pick up system rundate.
     D RUNA                    1      7
     D RUND                    8     10P 0
     D SSF                    11     11
     D DATF                   12     12
     D MBIN                   13     13

     D WRUN            S              1

      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT - Initial Processing                                  *
      *  SRMAIN - Main Processing                                     *
      *  SRPRINT - Generate reports                                   *
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
      ** Perform main routine
      *
     C                   EXSR      SRMAIN

     C     TOTAL1        IFEQ      0
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
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Databese Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Get RUND from DTAARA/RUNDAT.
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDT
      *
      ** Define program for error handling
      *
     C                   EVAL      DBPGM = 'SMU02000'
      *
     C                   EVAL      TOTAL1 = 0
     C                   EVAL      WRUN = ' '
      *
     C                   ENDSR
      *
      *****************************************************************
     C/TITLE SR/SRMAIN
      *****************************************************************
      *                                                               *
      *  SRMAIN - Main Routine                                        *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRMAIN        BEGSR
      *
     C                   WRITE     HEADP1
      *
      ** Read the entire Correspondent file
      *
     C     1             SETLL     SMCORXPD
     C                   READ      SMCORXPD
     C                   DOW       NOT %EOF(SMCORXPD)
      *
     C     XXCORR        CHAIN     CGCORRL0                           8081
     C     *IN80         IFEQ      '0'
      *
     C                   EVAL      CDCORR =  XXCORR
     C                   EVAL      CDCORN =  XXCORN
     C                   EVAL      CDADD1 =  XXADD1
     C                   EVAL      CDADD2 =  XXADD2
     C                   EVAL      CDADD3 =  XXADD3
     C                   EVAL      CDADD4 =  XXADD4
     C                   EVAL      CDADD5 =  XXADD5
     C                   EVAL      CDADD6 =  XXADD6
     C                   EVAL      CDADD7 =  XXADD7
     C                   EVAL      CDADD8 =  XXADD8
     C                   UPDATE    @CORRL0                              81
      *
      ** Print report
      *
     C                   ADD       1             TOTAL1
     C                   EVAL      CDCORRP = CDCORR
     C                   EVAL      CDCUSTP = CDCUST
     C                   EVAL      CDCORNP = XXCORN
     C                   EXSR      SRPRINT
      *
     C                   ENDIF
      *
     C                   READ      SMCORXPD
     C                   ENDDO
      *
     C                   ENDSR
      *
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
     C                   WRITE     HEADP1
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
      *  SRPRINT - Report the affected accounts                       *
      *                                                               *
      *  Called By: SRMAIN                                            *
      *  Calls    : *NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRPRINT       BEGSR
      *
     C     *IN95         IFEQ      *ON
     C                   WRITE     HEADP1
     C                   EVAL      *IN95 = *OFF
     C                   ENDIF
      *
     C                   IF        TOTAL1 > 0
     C                   WRITE     DETAILP1
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
** CPY@ **      OBJECT COPYRIGHT
(c) Finastra International Limited 2020
