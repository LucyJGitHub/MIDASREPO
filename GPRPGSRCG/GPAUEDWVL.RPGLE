     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Edit Word Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUEDWVL - Edit Word Validation                             *
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
 
     FGPAUFDL3  IF   E           K DISK    INFSR(*PSSR)
 
     D #_EDTW          S              1    DIM(26) ASCEND
 
     D                 DS
     D #_SNAM                  1     10    DIM(10)
     D W#SNAM                  1     10
 
     D InvCom          S              1    DIM(1) CTDATA PERRCD(1)
 
 
      * Initialize outputs
 
     C                   MOVEL     *BLANK        O#VERR
     C                   Z-ADD     I#DIG         O#EDTS
 
     C* DEFAULT EDIT WORD IF A DATE
 
     C     I#EDTW        IFEQ      *BLANK
     C     I#DIG         ANDEQ     5
     C     I#TYPE        IFEQ      'S'
     C     I#TYPE        OREQ      'P'
     C                   EXSR      DEFLT_EDTW_DAT
     C                   END
     C                   END
 
     C* DEFAULT EDIT WORD IF A SIGNED OR PACKED NUMERIC FIELD
 
     C     I#EDTW        IFEQ      *BLANK
     C     I#DIG         ANDLE     17
     C     I#TYPE        IFEQ      'S'
     C     I#TYPE        OREQ      'P'
     C                   EXSR      DEFLT_EDTW_NUM
     C                   END
     C                   END
 
     C* IGNORE IF EDIT WORD IS BLANK OR '*NONE'
 
     C     I#EDTW        IFEQ      *BLANK
     C     I#EDTW        OREQ      '*NONE'
     C                   GOTO      END_VAL
     C                   END
 
     C* EDIT WORD CAN'T BE DEFINED FOR AN ALPHAMERIC FIELD
 
     C     I#TYPE        IFEQ      'A'
     C                   EVAL      O#VERR = 'ALPHAMERIC'
     C                   GOTO      END_VAL
     C                   END
 
     C* EDIT WORD CAN'T BE DEFINED FOR A NUMERIC FIELD > 17 BYTES
 
     C     I#DIG         IFGT      17
     C                   EVAL      O#VERR = 'NUMERIC'
     C                   GOTO      END_VAL
     C                   END
 
     C* '*DATE' IS ALLOWED TO CONVERT DAY NUMBERS TO DATES
 
     C     I#EDTW        IFEQ      '*DATE'
     C                   EXSR      VAL_DATE
     C                   GOTO      END_VAL
     C                   END
 
     C* '*BASE' IS ALLOWED TO EDIT WITH BASE CCY DEC.PLACES
 
     C     I#EDTW        IFEQ      '*BASE'
     C                   EXSR      VAL_BASE
     C                   GOTO      END_VAL
     C                   END
 
      * IF START CHARACTER IS '
      * THEN IT CONTAINS A TEMPLATE
      * OTHERWISE EDIT WORD CONTAINS A FIELD
 
     C                   MOVEA     I#EDTW        #_EDTW
     C     #_EDTW(1)     IFEQ      InvCom(1)
     C                   EXSR      VAL_TEMPLATE
     C                   ELSE
     C                   EXSR      VAL_FIELD
     C                   ENDIF
 
     C     END_VAL       TAG
 
     C* KEEP EDIT SIZE BELOW 100 BYTES
 
     C     O#EDTS        IFGT      100
     C                   Z-ADD     100           O#EDTS
     C                   END
 
     C                   SETON                                        LR
 
      /SPACE 5
      ********************************************************************
      * VALIDATE DATE EDITING
      ********************************************************************
     C     VAL_DATE      BEGSR
 
      * DAY NUMBER CONVERSION REQUIRES THE FIELD TO BE 5 DIGITS AND NUMERIC
 
     C     I#DIG         IFNE      5
     C     I#TYPE        ORNE      'S'
     C     I#TYPE        ANDNE     'P'
     C                   EVAL      O#VERR = 'DAYNUMBER'
     C                   GOTO      END_DATE
     C                   END
 
      * SET EDIT SIZE
 
     C                   Z-ADD     7             O#EDTS
 
     C     END_DATE      ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * VALIDATE BASE CURRENCY EDITING
      ********************************************************************
     C     VAL_BASE      BEGSR
 
      * BASE CCY EDITING REQUIRES THE FIELD TO BE AT LEAST 11 DIGITS AND NUMERIC
 
     C     I#DIG         IFLT      11
     C     I#TYPE        ORNE      'S'
     C     I#TYPE        ANDNE     'P'
     C                   EVAL      O#VERR = 'BASECCY'
     C                   GOTO      END_BASE
     C                   END
 
      * SET EDIT SIZE (number of digits + (5 x ',') + '.' + '-')
 
     C     I#DIG         ADD       7             O#EDTS
 
     C     END_BASE      ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * VALIDATE TEMPLATE EDITING
      ********************************************************************
     C     VAL_TEMPLATE  BEGSR
 
      * START CHARACTER IS '
 
     C                   Z-ADD     2             X                 3 0
     C     InvCom(1)     LOOKUP    #_EDTW(X)                              99
 
     C* MISSING ' AT END
 
     C     *IN99         IFEQ      *OFF
     C                   EVAL      O#VERR = 'MISSING'
     C                   GOTO      END_TEMPLATE
     C                   END
 
     C* ERROR IF CHARACTERS ARE DEFINED AFTER THE SECOND '
 
     C                   ADD       1             X
     C     X             IFLE      26
     C     *BLANK        LOOKUP    #_EDTW(X)                          99
     C     *IN99         IFEQ      *ON
     C                   EVAL      O#VERR = 'CHARACTERS_T'
     C                   GOTO      END_TEMPLATE
     C                   END
     C                   END
 
     C* VALID CHARACTERS ARE BLANK, '0' ',' '.' AND '-'
 
     C                   Z-ADD     2             X                 3 0
     C     InvCom(1)     LOOKUP    #_EDTW(X)                              99
     C     X             DOWGT     2
     C                   SUB       1             X
     C     #_EDTW(X)     IFNE      ' '
     C     #_EDTW(X)     ANDNE     '0'
     C     #_EDTW(X)     ANDNE     ','
     C     #_EDTW(X)     ANDNE     '.'
     C     #_EDTW(X)     ANDNE     '-'
     C                   EVAL      O#VERR = 'INVCHARACTER'
     C                   GOTO      END_TEMPLATE
     C                   END
     C                   ENDDO
 
     C* ONE '0' ONLY IS ALLOWED
 
     C                   Z-ADD     1             X
     C     '0'           LOOKUP    #_EDTW(X)                              99
     C     *IN99         IFEQ      *ON
     C                   ADD       1             X
     C     X             IFLE      26
     C     '0'           LOOKUP    #_EDTW(X)                              99
     C     *IN99         IFEQ      *ON
     C                   EVAL      O#VERR = 'ONE0ONLY'
     C                   GOTO      END_TEMPLATE
     C                   END
     C                   END
     C                   END
 
      * SET EDIT SIZE FROM EDIT WORD
 
     C                   Z-ADD     *ZERO         O#EDTS
     C                   Z-ADD     2             X
     C                   Z-ADD     *ZERO         Y                 3 0
     C     #_EDTW(X)     DOWNE     InvCom(1)
     C     #_EDTW(X)     IFEQ      *BLANK
     C     #_EDTW(X)     OREQ      '0'
     C                   ADD       1             Y
     C                   ENDIF
     C                   ADD       1             X
     C                   ADD       1             O#EDTS
     C                   ENDDO
 
     C* ERROR IF EDIT WORD DOES NOT MATCH FIELD SIZE
 
     C     Y             IFNE      I#DIG
     C                   EVAL      O#VERR = 'FIELDSIZE'
     C                   GOTO      END_TEMPLATE
     C                   END
 
     C     END_TEMPLATE  ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * VALIDATE FIELD EDITING
      ********************************************************************
     C     VAL_FIELD     BEGSR
 
      * LOAD UP FIELD NAME
 
     C                   Z-ADD     1             X
     C     X             DOWLE     10
     C     #_EDTW(X)     ANDNE     *BLANK
     C                   MOVEA     #_EDTW(X)     #_SNAM(X)
     C                   ADD       1             X
     C                   ENDDO
 
     C* ERROR IF CHARACTERS ARE DEFINED AFTER THE FIELD
 
     C     *BLANK        LOOKUP    #_EDTW(X)                          99
     C     *IN99         IFEQ      '1'
     C                   EVAL      O#VERR = 'CHARACTERS_F'
     C                   GOTO      END_FIELD
     C                   END
 
     C* FIELD SELECT
 
     C     #_SNAM(1)     IFEQ      '?'
     C                   CALL      'GPAU0014'                           9999    *
     C                   PARM      *BLANK        RETC              6
     C                   PARM      'ALL'         I#RECD_TYPE       3
     C                   PARM                    I#FILE
     C                   PARM                    I#RCID
     C                   PARM      *BLANK        AFSNAM
     C                   MOVEL     AFSNAM        W#SNAM
     C                   ENDIF
 
     C* ERROR IF FIELD NOT PRESENT
 
     C     GPAUFDK       CHAIN     GPAUFDD0                           99
     C     *IN99         IFEQ      '1'
     C                   EVAL      O#VERR = 'INVALIDFIELD'
     C                   GOTO      END_FIELD
     C                   END
 
      * SET EDIT SIZE (number of digits + (5 x ',') + '.' + '-')
 
     C     I#DIG         ADD       7             O#EDTS
 
     C     END_FIELD     TAG
     C                   MOVEL     W#SNAM        I#EDTW
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DEFAULT EDIT WORD IF A NUMERIC FIELD
      ********************************************************************
     C     DEFLT_EDTW_NUMBEGSR
 
     C                   CALLB     'GPAUEDWDF'
     C                   PARM      *BLANK        I#RTCD            7
     C                   PARM      *BLANK        I#ERMS           50
      * INPUT
     C                   PARM                    I#TYPE            1
     C                   PARM                    I#DIG             4 0
     C                   PARM      I#DEC         I#NBDP            1 0
      * OUTPUT
     C                   PARM      *BLANK        #OEDTW           26
      * Edit word
     C                   MOVEL     #OEDTW        I#EDTW
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * DEFAULT EDIT WORD IF A DATE
      ********************************************************************
     C     DEFLT_EDTW_DATBEGSR
 
     C                   MOVE      I#FDES        W_FDES           31
     C     ' date '      SCAN      W_FDES                                 99
     C  N99' Date '      SCAN      W_FDES                                 99
     C  N99' dte '       SCAN      W_FDES                                 99
 
     C     *IN99         IFEQ      *ON
     C                   MOVEL     '*DATE'       I#EDTW
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Initial processing
      ********************************************************************
     C     INIT          BEGSR
 
     C* PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    I#FILE           10
     C                   PARM                    I#RCID           15
     C                   PARM                    I#EDTW           26
     C                   PARM                    I#TYPE            1
     C                   PARM                    I#DIG             4 0
     C                   PARM                    I#DEC             2 0
     C                   PARM                    I#FDES           30
     C                   PARM                    O#VERR           50
     C                   PARM                    O#EDTS            4 0
 
     C* KEY LIST
 
     C     GPAUFDK       KLIST
     C                   KFLD                    I#FILE
     C                   KFLD                    I#RCID
     C                   KFLD                    W#SNAM           10
     C                   ENDSR
     C********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   MOVEL     '*CANCL'      RETURN            6
     C                   ENDSR     RETURN
     C**********************************************************************
** InvCom
'
