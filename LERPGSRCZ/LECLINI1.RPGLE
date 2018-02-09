     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 2005')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Create transaction classes')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  LECLINI1 - Create transaction classes                        *
      *             (Lending initialisation program)                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CLE042  *CREATE    Date 06Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE042 - Extended Loan Sub Type                              *
      *                                                               *
      *****************************************************************
 
     FSDTCLDPD  IP   E             DISK
 
     FSDTCLSL0  IF A E           K DISK
 
     FQSYSPRT   O    F  132        PRINTER USROPN
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
 
      * Add transaction class
 
     C     LECLAS        CHAIN     SDTCLSD0                           99
     C   99              MOVEL     LECLAS        TCCLAS
     C   99              EXSR      ADD_CLASS
 
     C                   ADD       1             Count             3 0
 
     CLR                 EXSR      FINISH
      /SPACE 5
      ********************************************************************
     C     FINISH        BEGSR
     C                   OPEN      QSYSPRT
 
      * Report error or completion
 
     C     Count         IFNE      1
     C                   EXCEPT    ERR
     C                   SETON                                        U8
     C                   ELSE
     C                   EXCEPT    FIN
     C                   ENDIF
 
     C                   CLOSE     QSYSPRT
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     ADD_CLASS     BEGSR
     C                   EVAL      TCCDSC = '* NAME REQUIRED *'
     C                   EVAL      TCLCD  = BJRDNB
     C                   EVAL      TCTYLC = 'I'
     C                   WRITE     SDTCLSD0
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      ********************************************************************
     OQSYSPRT   E            ERR         1
     O                                           26 'PROGRAM ERROR - SDTCLDPD'
     O          E            FIN         1
     O                                           26 'PROGRAM COMPLETED NORMALLY'
