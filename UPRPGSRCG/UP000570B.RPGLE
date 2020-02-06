     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*XBI *  OVRDBF FILE(OBJSRC) TOFILE(OBJSRCB)                          *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare write source - 92 source')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000570B - Compare write source                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSM005             Date 18Aug05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP001 *C *CREATE  Date 23Dec98               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSM005 - Rewrite of UP0570B and moved to global layer.       *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
     F*****************************************************************
     FOBJSRC    O  A F   92        DISK
      *
     D                 DS
     D  XXRECD                 1     86
     D  FFRECD                 7     86
     D                 DS
     D  DATA                   1     92
     D  SRCSEQ                 1      6  2
     D  SRCDAT                 7     12  0
     D  SRCDTA                13     92
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMRECD           86
     C                   PARM                    CMRELN            5 0
     C                   MOVE      CMRECD        XXRECD
     C                   Z-ADD     CMRELN        SRCSEQ
     C                   Z-ADD     *ZEROS        SRCDAT
     C                   MOVEL     FFRECD        SRCDTA
     C                   EXCEPT    UPD
     C                   MOVEL     '1'           *INLR
      *
     OOBJSRC    EADD         UPD
     O                       DATA                92
