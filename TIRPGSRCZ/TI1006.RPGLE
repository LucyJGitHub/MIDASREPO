     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Branch conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1006 - Midas TI Branch Conversion                          *
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
      *
     FSDBRCHL1  IF   E           K DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C                   PARM                    A8BRCD            3            Midas Branch
     C                   PARM                    A8TIBR            4            TI Branch
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Chain upon Midas Branch into SDBRCHL1
      *
     C     A8BRCD        CHAIN     SDBRCHL1                           99
      *
     C                   RETURN
      *
**  CPY@
(c) Finastra International Limited 2001
