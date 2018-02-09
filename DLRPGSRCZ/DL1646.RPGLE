      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Interest Due Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1646 - OIS Interest Due Retrieval                          *
      *                                                               *
      *  Function:  This utility retrieves the previously calculated  *
      *             value of interest due for an OIS deal and returns *
      *             it to the calling program.                        *
      *                                                               *
      *  Called By: DL0279  - Deals File Update Phase1(COB Settlement)*
      *             DL1650  - OIS Input Cycle Settlement              *
      *             DL1642  - OIS Deal Rate Fixing                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1646 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *         - Recompiled only.  Applied fix 220258.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
     FDLDOISL1  IF   E           K DISK
      ** Logical file built over DLDOISPD - Deals OIS Details file
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   70  - End Of File Indicator DLDOISL1                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROC - Perform Detail Processing                           *
      *  SRENDP - Terminate the Program                               *
      *  *INZSR - Initial processing                                  *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
      /EJECT
      ****************************************************************
      *                M A I N   P R O C E S S I N G                 *
      ****************************************************************
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Perform Termination Processing.
      *
     C                   EXSR      SRENDP
      *
      /EJECT
      *****************************************************************
      *         E N D   O F   M A I N   P R O C E S S I N G           *
      *****************************************************************
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Perform Detail Processing                           *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** Find most recent record for Deal Number and Side
      *
     C                   MOVE      PDLNO         KDLNO
     C                   MOVE      POTCD         KOTCD
      *
     C     OISKY1        SETLL     DLDOISL1
     C                   READ      DLDOISL1                               70
      *
      ** If record isn't a settlement record go back to calling program
      *
     C     L1RTYP        IFNE      'SETTLE'
     C                   EXSR      SRENDP
     C                   ENDIF
      *
     C                   Z-ADD     L1AMNT        PAMNT
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDP - Terminate the Program                               *
      *                                                               *
      *  Called By : Main Processing                                  *
      *              SRPROC                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRENDP        BEGSR
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR    - Initial Processing                               *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDLNO             6 0
     C                   PARM                    POTCD             1
     C                   PARM                    PAMNT            13 0
     C                   PARM                    PRTCD             1
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1646'      DBPGM
     C                   Z-ADD     0             DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
      *
      ** Initialise entry parameters
      *
     C                   MOVE      *BLANKS       PRTCD
     C                   Z-ADD     0             PAMNT
      *
      **  Set up key lists for OIS Deals Interest Rate File
      *
     C     OISKY1        KLIST
     C                   KFLD                    KDLNO             6 0
     C                   KFLD                    KOTCD             1
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
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   MOVE      'X'           PRTCD
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
**  CPY@
(c) Finastra International Limited 2001
