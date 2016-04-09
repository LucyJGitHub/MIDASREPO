     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Edit amount')
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subroutines                                 *
      *                                                               *
      *  ZFRPED - Edit Amount                                         *
      *                                                               *
      *  Function:   This module inserts a decimal point and sign     *
      *              into a numeric field and blank out leading zeros *
      *              (optionaly inserting commas).                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAP076   *CREATE   Date 02May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *                                                               *
      *****************************************************************
      *
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D ZS2             S              1    DIM(22)
      *
     D                 DS
     D  ZWRK15                 1     15  0
     D  ZS1                    1     15  0 DIM(15)
      *
     D                 DS
     D  ZOUT25                 1     25
     D  ZOUT0                  1     21
     D  ZOUT1                  2     23
     D  ZOUT2                  3     24
     D  ZOUT3                  5     25
     C********************************************************************
     C*                                                                  *
     C*  ZFRPED - insert a decimal point and sign into a numeric field   *
     C*           and blank out leading zeros (optionaly inserting       *
     C*           commas).                                               *
     C*      Input fields:   ZFLD15 15/0                                 *
     C*                      ZDECS  1/0                                  *
     C*                      ZECODE 1/  ('A','C','J','L' or blank)       *
     C*                                 ( Default is 'J')                *
     C*      Arrays:         ZS1    15/1/0                               *
     C*                      ZS2    22/1/                                *
     C*                                                                  *
     C*      Output fields:  ZOUT22 22                                   *
     C*      Output fields:  ZOUT25 25  (ALIGNED BY DECIMAL POINT)       *
     C*                                                                  *
     C*           (The last 2 characters will be '  ','CR',or '- ')      *
     C*                                                                  *
     C********************************************************************
 
     C*
     C* Define/Clear fields
     C*
     C                   Z-ADD     ZFLD15        ZFLD15           15 0
     C                   Z-ADD     ZDECS         ZDECS             1 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT22           22
     C                   MOVE      *BLANKS       ZOUT25           25
     C     ZECODE        IFEQ      *BLANKS
     C                   MOVE      'J'           ZECODE
     C                   END
     C*
     C*       SET UP WORK FIELDS
     C*
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
     C*
     C                   Z-ADD     15            Z1                2 0
     C                   Z-ADD     20            Z2                2 0
     C*
     C     15            SUB       ZDECS         ZINTS             2 0
     C*
     C* Check if numeric field is negative
     C*
     C     ZFLD15        IFLT      *ZEROS
     C     ZECODE        IFEQ      'A'
     C     ZECODE        OREQ      'C'
     C                   MOVEA     'CR'          ZS2(21)
     C                   ELSE
     C                   MOVE      '-'           ZS2(21)
     C                   END
     C                   Z-SUB     ZFLD15        ZFLD15
     C                   END
     C*
     C                   Z-ADD     ZFLD15        ZWRK15
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
     C     Z2            ORGT      *ZEROS
     C     ZECODE        ANDEQ     'A'
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
     C     Z2            CABEQ     23            ZS20
     C                   END
     C*
     C*       IF NO INTEGERS PUT IN LEADING ZERO
     C*
     C     ZS20          TAG                                                    ** ZS20 TAG **
     C*
     C     Z2            IFEQ      23
     C     ZFLD15        IFEQ      0
     C     ZDECS         ANDEQ     0
     C                   SUB       3             Z2
     C                   ELSE
     C                   SUB       2             Z2
     C                   ENDIF
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
     C                   MOVEA     ZS2           ZOUT22
     C*
     C     ZDECS         IFEQ      0
     C                   MOVE      ZOUT22        ZOUT0
     C                   ELSE
     C**
     C     ZDECS         IFEQ      1
     C                   MOVE      ZOUT22        ZOUT1
     C                   ELSE
     C**
     C     ZDECS         IFEQ      2
     C                   MOVE      ZOUT22        ZOUT2
     C                   ELSE
     C**
     C                   MOVE      ZOUT22        ZOUT3
     C                   END
     C**
     C                   END
     C**
     C                   END
     C**
     C                   RETURN
      *****************************************************************
     C*
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST                                                  Entry parameter
      *
      * INPUTS
      *
     C                   PARM                    ZFLD15           15 0          I: numreric field
     C                   PARM                    ZDECS             1 0          I: no of decimals
     C                   PARM                    ZECODE            1            I: edit code
      *
      * OUTPUTS
      *
     C                   PARM                    ZOUT22                         O: unaligned amount
     C                   PARM                    ZWRK25           25            O: aligned amount
      *
     C                   MOVEL     ZWRK25        ZOUT25
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
