     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Contingent account conversion')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1002 - Midas TI Contingent Account Conversion              *
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
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001  *CREATE    Date 26Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CTI001 - Created for Midas/TI Interface                      *
      *                                                               *
      *****************************************************************
     FSDACODL1  IF   E           K DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
                                                                                              CGL029
     D A5ACCD          S             10A                                                      CGL029
      *
      ** Array containing Copyright statement
      *
      *
      ** Parameters passed in
      *
     C     *ENTRY        PLIST
     C**********         PARM                    A5ACCD            4                          CGL029
     C                   PARM                    A5ACCD                                       CGL029
     C                   PARM                    SCAI46            1
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Chain on Account Code into SDACODL1
      *
     C     A5ACCD        CHAIN     SDACODL1                           99
      *
      ** Set customer status depending upon Account Section
      *
     C                   MOVE      'N'           SCAI46
     C     A5ACSC        IFEQ      'CN'
     C     *IN99         ANDEQ     *OFF
     C                   MOVE      'Y'           SCAI46
     C                   ENDIF
      *
     C                   RETURN
      *
**  CPY@
(c) Finastra International Limited 2001
