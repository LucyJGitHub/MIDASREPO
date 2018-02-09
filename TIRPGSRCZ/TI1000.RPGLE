     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Customer mnemonic and location conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1000 - Midas TI Customer Mnemonic and Location Conversion  *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CTI001  *CREATE    Date 26Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CTI001 - Created for Midas/TI Interface                      *
      *                                                               *
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
     D                 DS
     D  CUSSHT                 1     10
     D  GZCUS                  1      6
     D  GZCLC                  8     10
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C     CUSSHT        PARM                    BBCSSN           10            Cust. Shortname
     C                   PARM      GZCUS         GFCUS             6            TI Cus.Mnemonic
     C                   PARM      GZCLC         GFCLC             3            TI Cus.Location
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
(c) Finastra International Limited 2001
