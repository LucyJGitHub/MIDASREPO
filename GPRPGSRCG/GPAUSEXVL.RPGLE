     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Select Expression Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUSEXVL - Select Expression Validation                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     D ZSN             S              1    DIM(30) ASCEND
     D INVC            S              1    DIM(1) CTDATA PERRCD(1)
 
     D PSDS           SDS
     D  ERROR            *STATUS
     D  WKSID                244    253
     D  USRID                254    263
 
     C     *ENTRY        PLIST
     C                   PARM                    RETC              6
     C                   PARM                    I#EDTS            4 0
     C                   PARM                    I#SCMP            2
     C                   PARM                    I#SCPV           30
 
     C                   MOVEA     I#SCPV        ZSN
 
     C* VALIDATE
 
     C                   EXSR      VALIDATE
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * VALIDATE
      *****************************************************************
     C     VALIDATE      BEGSR
 
     C* LOOP THROUGH CHARACTERS
 
     C                   Z-ADD     30            X                 2 0
     C     *IN99         DOUEQ     '1'
     C     ZSN(X)        COMP      *BLANK                             9999      *
     C  N99X             COMP      1                                      99    *
     C  N99              SUB       1             X
     C                   END
 
     C* ALPHAMERIC FIELD TOO BIG
 
     C     X             IFGT      I#EDTS
     C                   MOVEL     'INVSIZ'      RETC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
 
     C** CHECK FOR INVALID CHARACTERS
 
     C                   Z-ADD     1             X
     C     INVC(1)       LOOKUP    ZSN(X)                                 99    *
     C  N99'"'           LOOKUP    ZSN(X)                                 99    *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'INVCHR'      RETC
     C                   SETON                                        LR
     C                   RETURN
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * *PSSR processing
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
     C**********************************************************************
** INVC
'
