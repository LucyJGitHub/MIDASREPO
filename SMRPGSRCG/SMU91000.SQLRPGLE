     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                   *
/*EXI *  TEXT('Midas SM Utility Update Program for SDCUAHPD')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU91000 - Midas SM Utility Update Program for GPGLFCTD      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD057554  *CREATE  Date 08Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057554 - Unable to Release customer on SP23 that has been  *
      *             closed on earlier SP version.                     *
      *             Prevent the deletion of a Non-account Holder      *
      *             if it still attached to a Customer.               *
      *                                                               *
      *****************************************************************
      *
     FSMU91000P1O    E             PRINTER OFLIND(*IN95)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   95    - Page overflow on SMU91000P1                         *
      *   LR    - End of Program                                      *
      *   U7,U8 - Database error occured.                             *
      *                                                               *
      *****************************************************************
     F/SPACE 3
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)

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
      ** SQL update the GPGLFCTD file
      *
     C/Exec SQL
     C+ UPDATE GPGLFCTD SET GFGKY6 = 'DDTE', GFGKY7 = 'PTFR'
     C+   WHERE GFMOD = 'SE' AND GFGPF = 'GZCDEPPD'
     C/End-Exec
      *
      ** Print report
      *
     C                   ADD       1             TOTAL1
     C                   EVAL      GMODE = 'SE'
     C                   EVAL      GFILE = 'GZCDEPPD'
     C                   EVAL      GKEY6 = 'DDTE'
     C                   EVAL      GKEY7 = 'PTFR'
     C                   EXSR      SRPRINT
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
      *  SRPRINT - Report the affected record                         *
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
(c) Finastra International Limited 2021
