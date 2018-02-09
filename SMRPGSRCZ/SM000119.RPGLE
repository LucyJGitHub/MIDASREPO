     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM STRANF Transaction Number Update')            *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000119 - Midas SM STRANF Transaction Number Update         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD022252 *CREATE   Date 11Sep13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022252 - User couldn't complete Interest Adjustment to IRS *
      *             deal                                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSTRANFL0  UF   E           K DISK
      ** Midas DL STRANF Transactions Update by Trans Id
 
     D DNATN           DS             6
     D  FNATN                  1      6  0
 
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Procedure                                                *
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     STRANFL0
     C                   READ      STRANFL0
 
     C                   DOW       NOT %EOF(STRANFL0)
 
     C                   IF        FLTRNN = *BLANKS
     C                   EXSR      ZTNLU1
     C                   MOVE      FNATN         FLTRNN
     C                   UPDATE    STRANFF
     C                   ENDIF
 
     C                   READ      STRANFL0
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *   ZTNLU1 -  Get Next Transaction Number                       *
      *                                                               *
      *****************************************************************
 
     C     ZTNLU1        BEGSR
 
     C     *DTAARA       DEFINE    AAJTN         DNATN
     C     *LOCK         IN        DNATN
     C                   MOVE      FNATN         ZZWK05            6 0
     C                   ADD       1             ZZWK05
     C                   MOVE      ZZWK05        FNATN
     C                   OUT       DNATN
 
     C                   ENDSR
