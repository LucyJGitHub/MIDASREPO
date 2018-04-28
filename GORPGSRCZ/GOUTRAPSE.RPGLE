     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Update Work TRAP - SECURITIES TRADING')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOUTRAPSE - Update Work TRAP - SECURITIES TRADING            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 247017             Date 11Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247017 - Add missing transaction reference key field         *
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
     I******************************************T_CNUM        L1M6                            247017
     I******************************************T_PTFR        L1M5                            247017
     I******************************************T_BRCA        L1M4                            247017
     I******************************************T_BOOK        L1M3                            247017
     I******************************************T_SESN        L1M2                            247017
     I******************************************T_MKTI        L1M1                            247017
     I                                          T_CNUM        L1M7                            247017
     I                                          T_PTFR        L1M6                            247017
     I                                          T_BRCA        L1M5                            247017
     I                                          T_BOOK        L1M4                            247017
     I                                          T_SESN        L1M3                            247017
     I                                          T_MKTI        L1M2                            247017
     I                                          T_TREF        L1M1                            247017
     IGPTRAPD0      02
     I******************************************T_CNUM        L1M6                            247017
     I******************************************T_PTFR        L1M5                            247017
     I******************************************T_BRCA        L1M4                            247017
     I******************************************T_BOOK        L1M3                            247017
     I******************************************T_SESN        L1M2                            247017
     I******************************************T_MKTI        L1M1                            247017
     I                                          T_CNUM        L1M7                            247017
     I                                          T_PTFR        L1M6                            247017
     I                                          T_BRCA        L1M5                            247017
     I                                          T_BOOK        L1M4                            247017
     I                                          T_SESN        L1M3                            247017
     I                                          T_MKTI        L1M2                            247017
     I                                          T_TREF        L1M1                            247017
 
 
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
(c) Misys International Banking Systems Ltd. 2003
