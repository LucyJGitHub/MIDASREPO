     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Customer status conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1001 - Midas TI Customer Status Conversion                 *
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
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C                   PARM                    MIDATE            5 0          Customer Number
     C                   PARM                    CUSSTS            1            Cust.Status Flg
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Set customer status depending upon date deleted
      *
     C     MIDATE        IFNE      0
     C                   MOVE      'Y'           CUSSTS
     C                   ELSE
     C                   MOVE      'N'           CUSSTS
     C                   ENDIF
      *
     C                   RETURN
      *
**  CPY@
(c) Finastra International Limited 2001
