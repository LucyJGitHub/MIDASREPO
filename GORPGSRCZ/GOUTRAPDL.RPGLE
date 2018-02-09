     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Update Work TRAP - DEALING/LENDING')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUTRAPDL - Update Work TRAP - DEALING/LENDING               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032884           Date 09Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOTRAPDD and GOWTRAPPD.          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGOTRAPL0  IP  AE           K DISK
     FGPTRAPL0  IS  AE           K DISK    RENAME(GOTRAPD0:GPTRAPD0)
     FGOWTRAPPD O  A E           K DISK    RENAME(GOTRAPD0:GOWTRAPD0)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     IGOTRAPD0      01
     I                                          T_TREF        L1M1
     IGPTRAPD0      02
     I                                          T_TREF        L1M1
 
 
     C     *INMR         IFEQ      *OFF
     C     *IN01         IFEQ      *ON
     C                   MOVEL     'I'           T_ACTN
     C                   WRITE     GOWTRAPD0
     C                   ELSE
     C                   MOVEL     'D'           T_ACTN
     C                   Z-ADD     0             T_CCID
     C                   WRITE     GOWTRAPD0
     C                   ENDIF
     C                   ELSE
     C   01              MOVEL     'A'           T_ACTN
     C   01              WRITE     GOWTRAPD0
     C                   ENDIF
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
