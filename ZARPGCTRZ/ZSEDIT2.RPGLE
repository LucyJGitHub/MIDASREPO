     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Insert Dec Pt & Remove 0s from Numeric')      *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standard Subprograms                           *
      *                                                               *
      *  ZSEDIT  - Insert a Decimal Point and Remove Leading          *
      *            Zeros from Signed Numeric Field                    *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD034090 *CREATE   Date 11Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034090 - Extend field length of ZALIGN, ZEDIT & ZSEDIT     *
      *         - Modelled on ZEDIT2. Numeric input field adjusted    *
      *           from 15 numeric to 63 (max).                        *
      *                                                               *
      *****************************************************************
      *                                                               *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D ZS2             S              1    DIM(85)
      *
     D                 DS
     D  WORK63                 1     63  0
     D  ZS1                    1     63  0 DIM(63)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** I: Numeric field
      ** I: No. of decimals
      ** O: Edit code
      ** O: Function field
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZFLD63           63 0
     C                   PARM                    ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT85           85
      *
     C                   EXSR      ZSEDIT
      *
     C                   RETURN
      *
      *****************************************************************
      **                                                              *
      ** ZSEDIT subroutine to insert a decimal point and sign into a  *
      ** numeric field and to blank out leading zeros (optionaly      *
      ** inserting commas).                                           *
      *****************************************************************
      **     Input fields:   ZFLD63 63/0                              *
      **                     ZDECS  1/0                               *
      **                     ZECODE 1/  ('J', 'L' or blank)           *
      **                                                              *
      **     Arrays:         ZS1    63/1/0                            *
      **                     ZS2    85/1/                             *
      **                                                              *
      **     Output fields:  ZOUT85 85                                *
      **                                                              *
      *****************************************************************
     CSR   ZSEDIT        BEGSR
      *
      * Define/Clear fields
      *
     C                   Z-ADD     ZFLD63        ZFLD63           63 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT85           85
      *
      **      SET UP WORK FIELDS
      *
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
      *
     C                   Z-ADD     63            Z1                2 0
     C                   Z-ADD     84            Z2                2 0
      *
     C     63            SUB       ZDECS         ZINTS             2 0
      *
      ** Check if numeric field is negative
      *
     C     ZFLD63        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(85)
     C                   Z-SUB     ZFLD63        ZFLD63
     C                   END
      *
     C                   Z-ADD     ZFLD63        WORK63
      *
      ** Check to see if there are any decimal places
      *
     C     ZDECS         CABEQ     0             ZS10
      *
      ** Setup decimals
      *
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
      *
      ** Put in decimal place
      *
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
      *
     C     ZS10          TAG
      *
      ** Setup integers
      *
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
      *
      ** If edit code is 'J', insert a ',' before each group of three
      ** digits - not if beginning of array reached.
      *
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
      *
     C                   END
      *
      ** Put in leading blanks
      *
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     86            ZS20
     C                   END
      *
      ** If no integers put in leading zero
      *
     C     ZS20          TAG
      *
     C     Z2            IFEQ      86
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
      *
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
      *
      ** Setup output field
      *
     C                   MOVEA     ZS2           ZOUT85
      *
     CSR                 ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2015
