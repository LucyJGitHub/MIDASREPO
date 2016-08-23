     H NOMAIN
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RP PB prototyped procedures.')
      *****************************************************************
      *                                                               *
      *  Private Banking Module                                       *
      *                                                               *
      *  RPFORMAT - Formatting procedures                             *
      *                                                               *
      *  Function:    This module is a NOMAIN module. It contains     *
      *           prototyped procedures that perform formatting       *
      *           functions for procedures in other modules.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CPB002  *CREATE    Date 01Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           Midas/TOF interface.                                *
      *                                                               *
      *****************************************************************
 
      ** +------------------------------------------------*
      ** ¦ Pull in prototypes for prototyped procedures   ¦
      ** +------------------------------------------------*
 
      /COPY RPCPYSRC,RPFMTPPC
 
      ** +--------------------------------------+
      ** ¦ Define subprocedure RPPrCenter       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     P RPPrCenter      B                   Export
     D RPPrCenter      PI           132A
     D   InString                   132A
     D   Length                       3P 0
 
      ** +--------------------------------------+
      ** ¦ Local declarations                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D BeginPos        S              3S 0
     D OutString       S            132A
 
     C                   Eval      BeginPos = (Length-%Len(%Trim(InString)))/2
     C                                        + 1
     C     BeginPos      Ifle      0                                            Begin BeginPos
     C                   Eval      BeginPos = 1
 
     C                   Endif                                                  End BeginPos
 
     C                   Eval      %Subst(OutString:BeginPos) = %Trim(InString)
     C                   Return    OutString
 
     P RPPrCenter      E
