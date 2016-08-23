     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Update of Global File GZRSACMTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP003004 - GP Update of Global File GZRSACMTPD               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CAP203  *CREATE    Date 02Feb10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR      -  Program exception error routine                *
      *  *INZSR     -  Initialisation Subroutine                      *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.           *
      *                                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FGZRSACMTL0UF A E           K DISK
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data Structure for Midas GZ Account Movements File
     D GRSACMT       E DS                  EXTNAME(GZRSACMTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D MODE            S              1A
     D BRCH            S              3A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main processing                                        *
      *                                                               *
      *****************************************************************
      *
      ** Global File Updates
      *
     C     MODE          IFEQ      'D'
     C     BRCH          SETLL     GZRSACMTL0
     C     BRCH          READE     GZRSACMTL0
 
     C                   DOW       %FOUND(GZRSACMTL0) AND
     C                             NOT %EOF(GZRSACMTL0)
     C                   DELETE    RSACMTPO
     C     BRCH          READE     GZRSACMTL0
     C                   ENDDO
 
     C                   ENDIF
 
     C     MODE          IFEQ      'I'
     C                   WRITE     RSACMTPO
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  *INZSR - Initial Subroutine                                 *
      *                                                              *
      *  Called by: Implicitly on program activation                 *
      *                                                              *
      *  Calls: None                                                 *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    MODE
     C                   PARM                    BRCH
     C                   PARM                    GRSACMT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
