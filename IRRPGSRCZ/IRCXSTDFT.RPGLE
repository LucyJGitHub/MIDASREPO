     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy swap extra sett. inst. reqd dft')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS module                                       *
      *                                                               *
      *  IRCXSTDFT - Cross Ccy Swaps Extra Settlement Instructions    *
      *              Required Defaults                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL018             Date 03Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CIR003  *CREATE    Date 12Sep00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *                                                               *
      *****************************************************************
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D PPREX           S              1    DIM(3)
     D Idx             S              2  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   Z-ADD     1             Idx
      *
     C     Idx           DOUGT     3
      *
     C     PPREX(Idx)    IFEQ      *BLANKS
     C                   MOVE      'Y'           PPREX(Idx)
     C                   ENDIF
      *
     C                   ADD       1             Idx
      *
     C                   ENDDO
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Routine                                      *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PPREX
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
