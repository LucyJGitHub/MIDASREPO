     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Internal account conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1003 - Midas TI Internal Account Conversion                *
      *                                                               *
      *  Function:  This program converts standing data from Midas    *
      *             format to TI format.                              *
      *                                                               *
      *  Phases:                                                      *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001  *CREATE    Date 26Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CTI001 - Created for Midas/TI Interface                      *
      *                                                               *
      *****************************************************************
     FSDBRCHL5  IF   E           K DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C                   PARM                    A8BICN            6
     C                   PARM                    SCAI47            1
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Set TI account flag depending upon existence of branch account
      *
     C                   MOVE      'N'           SCAI47
     C     A8BICN        CHAIN     SDBRCHL5                           99
     C     *IN99         IFEQ      '1'
     C                   RETURN
     C                   ENDIF
     C                   MOVE      'Y'           SCAI47
      *
     C                   RETURN
      *
**  CPY@
(c) Finastra International Limited 2001
