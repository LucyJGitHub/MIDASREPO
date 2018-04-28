     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI SWIFT address conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1005 - Midas TI SWIFT Address Conversion                   *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CTI001  *CREATE    Date 26AUG97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI001 - Created for Midas/TI Interface                      *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D                 DS
     D  W#CSID                 1     12
     D  W#SABA                 1      4
     D  W#SACO                 5      6
     D  W#SALO                 7      8
     D  W#SABR                10     12
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C     W#CSID        PARM                    TICSID           12            Cust. SWIFT ID
     C                   PARM      W#SABA        TISABA            4            SWIFT Bank
     C                   PARM      W#SACO        TISACO            2            SWIFT Country
     C                   PARM      W#SALO        TISALO            2            SWIFT Location
     C                   PARM      W#SABR        TISABR            3            SWIFT Branch
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Return parameters
      *
     C                   RETURN
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
