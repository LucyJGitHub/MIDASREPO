     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Pooling Housekeeping')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      ***GLJ114*-*Midas*GL*Account*Pooling Housekeeping****************         JMI108
      *  XXJ124 - Midas GL Account Pooling Housekeeping               *         JMI108
      *                                                               *
      *  Function:  This program will read the Pooling Account        *
      *********details*file*SDPLACPP*until*EOF. Deletes each***********         JMI108
      *        details file XXPLACPP until EOF. Deletes each          *         JMI108
      *        record with a RECI o f'*'.                             *
      *                                                               *
      ***Called*By:*GLCJ114*-*Account*Pooling Housekeeping*************         JMI108
      *  Called By: XXCJ124 - Account Pooling Housekeeping            *         JMI108
      *                                                               *
      ***(c)*Misys*International*Banking*Systems*Ltd.*2007*************         JMI108
      *  (c) Finastra International Limited 2018                      *         JMI108
      *                                                               *
      *  Last Amend No. JMI108             Date 31May18               *
      *  Prev Amend No. TFJ011  *CREATE    Date 24Jan07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI108 - Account Balance Pooling. Upgrade to FBM 2.1         *
      *  TFJ011 - Midas GL Account Pooling Housekeeping               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F***SDPLACPP  UF   E             DISK    INFSR(*PSSR)                      JMI108
     FXXPLACPP  UF   E             DISK    INFSR(*PSSR)                         JMI108
     F                                     USROPN

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

      *****************************************************************
      /EJECT
      *****************************************************************

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C     *DTAARA       DEFINE                  LDA

     C****               Open      SDPLACPP                                     JMI108
     C**** 1             SetLL     SDPLACPP                                     JMI108
     C****               Read(e)   SDPLACD0                                     JMI108
     C                   Open      XXPLACPP                                     JMI108
     C     1             SetLL     XXPLACPP                                     JMI108
     C                   Read(e)   XXPLACD0                                     JMI108

     C                   If        %error
     C     *LOCK         In        LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C****************** Eval      DBFILE =  'SDPLACPP'                         JMI108
     C                   Eval      DBFILE =  'XXPLACPP'                         JMI108
     C                   Eval      DBKEY  =  'RRN   '
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  001
     C                   Eval      DBMOD  =  PSProcMod
     C                   OUT       LDA
     C                   ExSr      *PSSR
     C                   EndIf

     C****************** DoW       not %EOF(SDPLACPP)                           JMI108
     C                   DoW       not %EOF(XXPLACPP)                           JMI108
     C                   If        JRECI = '*'
     C****************** Delete    SDPLACD0                                     JMI108
     C                   Delete    XXPLACD0                                     JMI108
     C                   EndIf
     C****************** Read(e)   SDPLACD0                                     JMI108
     C                   Read(e)   XXPLACD0                                     JMI108
     C                   EndDo

     C****************** Close     SDPLACPP                                     JMI108
     C                   Close     XXPLACPP                                     JMI108
     C                   Eval      *INLR = *ON
     C                   Return

      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using ExSr.          *
      *          This subroutine Dumps the program just once.         *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BegSr

     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
     C                   Dump
     C                   EndIf

     C****************** If        %open(SDPLACPP)                              JMI108
     C****************** Close     SDPLACPP                                     JMI108
     C                   If        %open(XXPLACPP)                              JMI108
     C                   Close     XXPLACPP                                     JMI108
     C                   EndIf

     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return

     C                   EndSr
