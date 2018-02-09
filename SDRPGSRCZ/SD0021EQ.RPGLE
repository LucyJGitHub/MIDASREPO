     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas to Equation Validation input')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0021EQ - Midas to Equation Validation input                *
      *                                                               *
      *  Function:  This program checks Currency Number in equation   *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG14620 *CREATE   Date 21Aug07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG14620 - Migration program does not work.                  *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR  - Initialisation Subroutine                          *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Equation Currency File
     FC801LF    IF   E           K DISK    INFSR(*PSSR)
      *****************************************************************
     D*
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D/COPY ZACPYSRC,PSDS
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ***************************************************************************
      /EJECT
      ***************************************************************************
     ** +--- Start of Main Processing ----------------------------------+
     ** ¦                                                               ¦
     ** ¦ Initial processing is performed automaticaLly: the *INZSR is  ¦
     ** ¦ executed at program activation.                               ¦
     ** ¦                                                               ¦
     ** +---------------------------------------------------------------+
 
     ********************************************************************
     **             MAIN PROCEDURE                                      *
     ********************************************************************
      *
 
      *
     C     KEYEQCURR     CHAIN     C801LF
     C                   IF        %FOUND(C801LF)
     C                   IF        C8CCYN <> W21CCYDN
     C                   EVAL      W21CCYDN = C8CCYN
     C                   EVAL      RETCODE = '*ERROR'
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   RETURN
      ***************************************************************************
      /EJECT
      ***************************************************************************
     C     *PSSR         BEGSR
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      ***************************************************************************
      /EJECT
      ***************************************************************************
     C     *INZSR        BEGSR
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    RETCODE          10
     C                   PARM                    W21CCYD           3
     C                   PARM                    W21CCYDN          3
      *
      *
     C     KEYEQCURR     KLIST
     C                   KFLD                    W21CCYD
     C     *DTAARA       DEFINE                  LDA
      *
      *
     C                   ENDSR
      ***************************************************************************
      /EJECT
      ***************************************************************************
** CPY@
(c) Finastra International Limited 2004
