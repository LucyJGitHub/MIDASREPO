     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*XBI *  OVRDBF FILE(UPP02P) TOFILE(UPP02BPD)                         *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Compare screen handling - 92 source')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000540B - Compare screen handling                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSM005             Date 18Aug05               *
      *                 CPK016             Date 16Apr03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CUP001 *CREATE     Date 23Dec98               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSM005 - Rewrite of UP0540B and moved to global layer.       *
      *  CPK016 - UPP02PB renamed to UPP02BPD.                        *
      *  CUP001 - Introduction of BRIDGE                              *
      *                                                               *
     F*****************************************************************
     FUPP02P    IP   E             DISK
     FQRPG      O  A F   92        DISK
     FUP000540DFCF   E             WORKSTN
      *
     D                 DS
     D  CMRECD                 1     86
     D  FFRECD                 7     86
     D                 DS
     D  DATA                   1     92
     D  SRCSEQ                 1      6  2
     D  SRCDAT                 7     12  0
     D  SRCDTA                13     92
     D                 DS
     D  XXCSEQ                 1      6  0
     D  X1CSEQ                 1      4  0
     D  X2CSEQ                 5      6  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    RTRN              1
     C                   PARM                    EERELN            5 0
     C                   PARM                    LIBST            10
     C                   PARM                    NEWF             10
     C                   PARM                    NEWM             10
     C                   PARM                    S                 1
     C                   PARM                    OVCSEQ            1
     C     *IN10         IFEQ      '0'
     C                   MOVEL     '1'           *IN10
     C                   Z-ADD     *ZEROS        CPT
     C                   END
     C                   Z-ADD     CMCSEQ        SRCSEQ
     C                   Z-ADD     CMCDAT        SRCDAT
     C                   MOVEL     FFRECD        SRCDTA
     C     *IN11         IFEQ      '0'
     C     CMTYPA        IFEQ      CMSUGA
     C     CMTYPA        IFEQ      'N'
     C     CMSUGA        IFEQ      'N'
     C                   MOVEL     '1'           *IN11
     C                   ADD       1             CPT               5 0
     C                   Z-ADD     CMRELN        EERELN
     C                   END
     C                   END
     C                   END
     C                   END
     C     CMCSEQ        IFEQ      *ZEROS
     C                   Z-ADD     *ZEROS        XXCSEQ
     C     SVCSEQ        MULT      100           XXCSEQ            6 0
     C                   ADD       1             XXCSEQ
     C     X2CSEQ        IFEQ      *ZEROS
     C                   Z-ADD     99            X2CSEQ
     C                   MOVE      'O'           OVCSEQ
     C                   END
     C     XXCSEQ        DIV       100           BBCSEQ            6 2
     C                   Z-ADD     BBCSEQ        CMCSEQ
     C                   Z-ADD     BBCSEQ        SRCSEQ
     C                   END
      *
     C     CMSUGA        IFEQ      'F'
     C     CMSUGA        OREQ      'O'
     C     CMSUGA        OREQ      'A'
     C                   Z-ADD     CMCSEQ        SVCSEQ            6 2
     C                   EXCEPT    UPD
     C                   END
     CLR                 MOVEL     'Y'           RESP
     CLR   CPT           IFGT      *ZEROS
     CLR                 EXFMT     UP054R1
     CLR                 WRITE     DUMMY
     CLR   RESP          IFEQ      'N'
     CLR                 MOVEL     'N'           RTRN
     CLR                 ELSE
     CLR                 MOVEL     'P'           S
     CLR                 END
     CLR                 ELSE
     CLR                 EXFMT     UP054R2
     CLR                 WRITE     DUMMY
     CLR   RESP          IFEQ      'N'
     CLR                 MOVEL     'N'           RTRN
     CLR                 ELSE
     CLR                 MOVEL     'C'           S
     CLR                 END
     CLR                 END
      *
     OQRPG      EADD         UPD
     O                       DATA                92
