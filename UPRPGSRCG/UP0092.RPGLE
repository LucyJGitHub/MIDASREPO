     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*S*D ***RPGBASEMOD****************************************************                       CPK019
/*STD *  RPGBASEBND                                                   *                       CPK019
/*EXI *  TEXT('Midas UP Prog to update UPDLVCPD for shared files')    *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0092 - Report on missing shared format files               *
      *                                                               *
      *  Function:  This module ensures priorities are correct for    *
      *             shared files and that all files are delivered.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD030871           Date 01Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK019             Date 17Jun04               *
      *                 CUP025             Date 08Dec03               *
      *                 CPK016             Date 28Aug03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CUP007             Date 14Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CUP006             Date 17Dec99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CPK010             Date 21Oct99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPK009  *CREATE    Date 01Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030871 - SQLTBL not considered in changing the priority    *
      *             in bridge driving file                            *
      *  CPK019 - Post Bridge build delivery packaging.               *
      *  CUP025 - MidasPlus Bridge changes.                           *
      *  CPK016 - Handle SQL types of format sharing.                 *
      *  CUP007 - Recompiled over changed UP0092P1                    *
      *  CUP006 - Fix to allow printer file to be reused and turned   *
      *           into a module.                                      *
      *  CPK010 - Error found at DBA R3.00 alpha site                 *
      *  CPK009 - Packaging change for DBA R3.00                      *
      *                                                               *
      *****************************************************************
     F/EJECT
     FUPSFMTPD  IF   E           K DISK
     F*
     FUPDLVCL0  UF   E           K DISK
     F*
     FUP0092P1  O    E             PRINTER OFLIND(*IN37)
     F                                     USROPN
     F*
     F*****************************************************************
     F*                                                               *
     F*  F U N C T I O N   O F   I N D I C A T O R S                  *
     F*                                                               *
     F*    99  - Error in Chain to Facility File                      *
     F*                                                               *
     F*****************************************************************
      /EJECT
     D PSDS           SDS
      *
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
     D MODULE          S             10
      *
      ** Set up copyright parameter
     C*                  MOVEA     CPY@          CPY2@            80
     C/TITLE
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      * Perform Initialisation.
     C                   EXSR      INIT
      *
      * Perform Update File  Processing.
     C                   EXSR      MAIN
      *
      ***  End Program.
      ** If any records, call UPC0092 to send message to screen.
     C     COUNT         IFGT      0
     C                   EVAL      MODULE = 'UP0092'                                          CUP006
     C**********         CALL      'UPC0092'                                                  CUP006
     C**********         CALLB     'UPC0092'                                           CUP006 CPK019
     C                   CALL      'UPC0092'                                                  CPK019
     C                   PARM                    MODULE
      ** Close Printer file
     C                   CLOSE     UP0092P1
     C                   ENDIF
      *
     C                   MOVE      '0'           *IN92                                        CUP006
      *                                                                                       CUP006
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  INIT   - SUBROUTINE TO DO INITIAL PROCESSING.                *
      *                                                               *
      *  Called By: NONE                                              *
      *                                                               *
      *  Calls:     NONE                                              *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Reset error count
     C*****************  Z-ADD     0             COUNT             2 0
     C                   Z-ADD     0             COUNT             3 0                        CUP006
      *                                                                                       CUP006
     C                   MOVE      '1'           *IN92                                        CUP006
      *
     C                   ENDSR
      *****************************************************************
      /TITLE SR/INIT
      *****************************************************************
      *                                                               *
      *  MAIN   - SUBROUTINE TO DO MAIN PROCESSING.                   *
      *                                                               *
      *  Called By: NONE                                              *
      *                                                               *
      *  Calls:     NTFND                                             *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
      *
     C     *LOVAL        SETLL     UPSFMTPD
     C                   READ      UPSFMTPD                             6990
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN90         DOWEQ     '0'
      ** Check if file shared is being delivered.
     C     FSFSHD        CHAIN     UPDLVCL0                           9169
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN91         IFEQ      '0'
     C*****AUMBTP        ANDEQ     'PF'                                                       CPK016
     C     AUMBTP        ANDEQ     'PF'                                                       CPK019
     C     *IN91         OREQ      '0'                                                        CPK019
     C     AUMBTP        ANDEQ     'SQLVIEW'                                                  CPK019
     C     *IN91         OREQ      '0'                                                      MD030871
     C     AUMBTP        ANDEQ     'SQLTBL'                                                 MD030871
      *
      ***If*file*is*being*delivered,*make*the*priority*4.*
     C*****AUIPTY        IFNE      4                                                          CUP025
     C*****              Z-ADD     4             AUIPTY                                       CUP025
      * Set priority on driving file to that on shared format file.                           CUP025
     C                   Z-ADD     FSIPTY        AUIPTY                                       CUP025
     C                   UPDATE    @DLVCL0                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C*****              ENDIF                                                                CUP025
      *
      ** If the files sharing the delivered file's format are not
      ** being delivered as well, EXSR NTFND to write report.
      *
     C***********FSFILE    CHAINUPDLVCL0             9269                                     CUP006
     C     FSFILE        CHAIN     UPDLVCL0                           8969                    CUP006
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C************IN92     IFEQ '1'                                                           CUP006
     C     *IN89         IFEQ      '1'                                                        CUP006
     C                   ADD       1             COUNT
     C                   EXSR      NTFND
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read the next record and reset fields.
     C                   READ      UPSFMTPD                             6990
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      *ZERO         AUIPTY
     C                   MOVE      '0'           *IN91
     C                   ENDDO
      *
      ** When EOF reached, if there are any undelivered files, write trailer.
     C     COUNT         IFGT      0
     C                   WRITE     TRAILPY                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  NTFND  - SUBROUTINE TO DO PRINT FILES NOT FOUND IN DELIVERY  *
      *                                                               *
      *  Called By: MAIN PROCESSING                                   *
      *                                                               *
      *  Calls:     NONE                                              *
      *                                                               *
      *****************************************************************
     C     NTFND         BEGSR
      *
      ** If the first time writing to report or new page, write header.
     C     COUNT         IFEQ      1
      ** Open Printer file
     C                   OPEN      UP0092P1                             69
     C                   WRITE     HEADPY                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * If overflow on then write header
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADPY                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   WRITE     DETAIL                               69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: *ALL                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
