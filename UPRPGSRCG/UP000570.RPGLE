     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare write source - 112 source')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000570 - Compare write source                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSM005  *REWRITE   Date 18Aug05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CUP001 *CREATE     Date 23Dec98               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSM005 - Rewrite of UP0570 and moved to global layer.        *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
     F*****************************************************************
     FOBJSRC    O  A F  112        DISK
      *
     D                 DS
     D  XXRECD                 1    106
     D  FFRECD                 7    106
     D                 DS
     D  DATA                   1    112
     D  SRCSEQ                 1      6  2
     D  SRCDAT                 7     12  0
     D  SRCDTA                13    112
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMRECD          106
     C                   PARM                    CMRELN            5 0
     C                   MOVE      CMRECD        XXRECD
     C                   Z-ADD     CMRELN        SRCSEQ
     C                   Z-ADD     *ZEROS        SRCDAT
     C                   MOVEL     FFRECD        SRCDTA
     C                   EXCEPT    UPD
     C                   MOVEL     '1'           *INLR
      *
     OOBJSRC    EADD         UPD
     O                       DATA               112
