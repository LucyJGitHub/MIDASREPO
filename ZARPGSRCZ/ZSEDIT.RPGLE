     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Edit Screen Field     MODULE')
      *****************************************************************
      *                                                               *
      *   Module ZSEDIT  - Insert a decimal point and remove leading  *
      *                    zeros from signed numeric field            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 243868             Date 22Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 238603             Date 28Aug06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001    Create   Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  243868 - Amount and CR sign are truncated in Account Enquiry *
      *           Prompt. Reverse fix 238603.                         *
      *  238603 - Z2 is not initialized correctly and led field       *
      *           ZOUT21 to have a blank on the rightmost position.   *
      *  CTI001 - Midas/TI Interface (Phase 1)                        *
      *                                                               *
     D****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D************   The converted ZSEDITZ1 starts here  *************
     D ZS2             S              1    DIM(21)
     D************   The converted ZSEDITZ1 ends here    *************
     D*
     D*
     D************   The converted ZSEDITZ2 starts here  *************
     D                 DS
     D  WORK15                 1     15  0
     D  ZS1                    1     15  0 DIM(15)
     D************   The converted ZSEDITZ2 ends here    *************
     D*
     C     *ENTRY        PLIST
     C                   PARM                    ZFLD15           15 0          I:NUMERIC FIELD
     C                   PARM                    ZDECS             1 0          I:NO OF DECIMALS
     C                   PARM                    ZECODE            1            I:EDIT CODE
     C                   PARM                    ZOUT21           21            O:FUNCTION FIELD
     C*
     C                   EXSR      ZSEDIT
     C*
     C                   RETURN
     C*
     C************   The converted ZSEDITZ3 starts here  *************
     C********************************************************************
     C**                                                                 *
     C** ZSEDIT subroutine to insert a decimal point and sign into a     *
     C** numeric field and to blank out leading zeros (optionaly         *
     C** inserting commas).                                              *
     C**     Input fields:   ZFLD15 15/0                                 *
     C**                     ZDECS  1/0                                  *
     C**                     ZECODE 1/  ('J', 'L' or blank)              *
     C**                                                                 *
     C**     Arrays:         ZS1    15/1/0                               *
     C**                     ZS2    21/1/                                *
     C**                                                                 *
     C**     Output fields:  ZOUT21 21                                   *
     C**                                                                 *
     CSR   ZSEDIT        BEGSR                                                  **  ZSEDIT   *
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT21           21
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C*******************Z-ADD     20            Z2                2 0                        238603
     C**********         Z-ADD     21            Z2                2 0                 238603 243868
     C                   Z-ADD     20            Z2                2 0                        243868
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(21)
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        WORK15
     C*
     C*       CHECK TO SEE IF THERE ARE ANY DECIMAL PLACES
     C*
     C     ZDECS         CABEQ     0             ZS10
     C*
     C*       SET UP DECIMALS
     C*
     C                   Z-ADD     *ZEROS        ZCNT              1 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
     C*
     C*       PUT IN DECIMAL PLACE
     C*
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
     C*
     C     ZS10          TAG                                                    ** ZS10 TAG **
     C*
     C*       SET UP INTEGERS
     C*
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
     C*
     C* If edit code is 'J', insert a ',' before each group of three
     C* digits - not if beginning of array reached.
     C*
     C     Z2            IFGT      *ZEROS
     C     ZECODE        ANDEQ     'J'
     C                   ADD       1             CNT3
     C     CNT3          IFEQ      3
     C                   MOVE      ','           ZS2(Z2)
     C                   SUB       1             Z2
     C                   Z-ADD     *ZEROS        CNT3
     C                   END
     C                   END
     C*
     C                   END
     C*
     C*       PUT IN LEADING BLANKS
     C*
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     22            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      22
     C                   SUB       2             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   ELSE
     C*
     C     ZS2(Z2)       IFEQ      '.'
     C                   SUB       1             Z2
     C                   MOVE      '0'           ZS2(Z2)
     C                   END
     C                   END
     C*
     C*       SET UP OUTPUT FIELD
     C*
     C                   MOVEA     ZS2           ZOUT21
     C*
     CSR                 ENDSR
     C*****************************************************************
     C************   The converted ZSEDITZ3 ends here    *************
     C*
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
