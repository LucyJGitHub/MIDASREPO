     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Edit Field Format')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUEFFMT - Edit Field Format                                *
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
 
     D                 DS
     D  FFMT                   1      6
     D  DIG                    1      3
     D  COM                    4      4
     D  DEC                    5      5
 
 
     C* FIELD FORMAT
 
     C                   MOVEL     *BLANK        FFMT
     C* ALPHABETIC
     C     I#TYPE        IFEQ      'A'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      I#DIG         ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DIG
     C* NUMERIC
     C                   ELSE
     C                   MOVE      I#DIG         ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DIG
     C                   MOVE      I#DEC         ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        DEC
     C                   MOVE      ','           COM
     C                   END
 
     C                   MOVEL     FFMT          O#FFMT
 
     C                   SETON                                        LR
 
     C**********************************************************************
     C     ZEDIT         BEGSR
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   ENDSR
     C********************************************************************
     C     INIT          BEGSR
 
     C* PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    I#TYPE            1
     C                   PARM                    I#DIG             4 0
     C                   PARM                    I#DEC             2 0
 
     C                   PARM                    O#FFMT            6
     C                   ENDSR
     C********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
     C**********************************************************************
