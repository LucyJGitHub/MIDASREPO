     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Global User Security - Update User Flags')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP100004 - Global User Security - Update User Flags          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 26May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
     FGPMBRBS   IF   E           K DISK
     FGPMACBR1  IF   E           K DISK
 
 
     C     *ENTRY        PLIST
     C                   PARM                    USRPRF           10
     C                   PARM                    BRB               1
     C                   PARM                    ACD               1
 
 
      ** KEY TO ACCESS LF/GPMACBR1 (USER'S VALID ACTION CODES BY BRANCH)
 
     C     ACBRKY        KLIST
     C                   KFLD                    USRPK            10
     C                   KFLD                    BRCAK             3
     C                   KFLD                    INDXK            10
 
     C                   MOVE      USRPRF        USRPK
     C                   MOVE      '   '         BRCAK
     C                   MOVE      *BLANKS       INDXK
 
 
      ** USER'S BOOKING BRANCHES
 
     C     USRPK         CHAIN     GPMBRBS                            21
     C  N21RECI          COMP      'D'                                2121
     C     *IN21         IFEQ      '0'
     C     NOBR          IFEQ      0
     C                   MOVE      'N'           BRB
     C                   ELSE
     C                   MOVE      'Y'           BRB
     C                   END
     C                   ELSE
     C                   MOVE      'N'           BRB
     C                   END
 
      ** USER'S ACTION CODES
 
     C     ACBRKY        SETLL     GPMACBR1
      *
     C     READ          TAG
     C                   SETOFF                                       25
      *
     C                   READ      GPMACBR1                               24
     C  N24USRP          COMP      USRPK                              2424
     C  N24RECI          COMP      'D'                                2525
      *
     C     *IN24         IFEQ      '0'
     C     *IN25         IFEQ      '0'
     C                   MOVE      'Y'           ACD
     C                   ELSE
     C                   GOTO      READ
     C                   END
     C                   ELSE
     C                   MOVE      'N'           ACD
     C                   END
 
     C                   SETON                                        LR
