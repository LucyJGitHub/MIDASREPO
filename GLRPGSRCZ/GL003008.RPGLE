     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL RSACMTPD Replication Program (I/C)')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  GL003008 -Midas RSACMTPD Replication Program (I/C)           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CAP203  *CREATE    Date 02Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP203 - Teller Related APIs - Account Movements             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data structure for Midas GL Account movements
     D RSACMT        E DS                  EXTNAME(RSACMTPD)
 
     D PARM1           DS
     D  PFLNAME                1     10
     D  MBRNAME               21     30
     D  TRGEVENT              31     31
     D  BOFF                  49     52B 0
     D  BLEN                  53     56B 0
     D  AOFF                  65     68B 0
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A
 
     D PARM2           DS
     D  LENG                   1      4B 0
 
      ** +--------------------------------------+
      ** ¦  Declared variables                  ¦
      ** ¦  ==================                  ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D OFFSET          S              5  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C     AOFF          ADD       1             OFFSET
     C     ALEN          SUBST     PARM1:OFFSET  RSACMT
 
     C                   CALL      'GP003008'
     C                   PARM                    RSACMT
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANK
 
     C                   MOVE      'Y'           @RUN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
