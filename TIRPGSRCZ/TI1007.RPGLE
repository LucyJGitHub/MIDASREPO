     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Account status conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1007 - Midas TI Account Status Conversion                  *
      *                                                               *
      *  Function:  This program converts standing data from Midas    *
      *             format to TI format.                              *
      *                                                               *
      *  Phases:                                                      *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CTI001  *CREATE    Date 03Oct97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      *
     FSDACODL1  IF   E           K DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
                                                                                              CGL029
     D A5ACCD          S             10A                                                      CGL029
      *
      ** Array containing Copyright statement
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C**********         PARM                    A5ACCD            4                          CGL029
     C                   PARM                    A5ACCD                                       CGL029
     C                   PARM                    A5TIAT            2
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Chain on Account Code into SDACODL1
      *
     C     A5ACCD        CHAIN     SDACODL1                           99
      *
     C                   RETURN
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
