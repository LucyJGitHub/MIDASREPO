     H DEBUG
     H COPYRIGHT('(C) Copyright Finastra International Limited, 1997')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZS Edit Screen Field w/ 9+ decimal places')
      *****************************************************************
      *                                                               *
      *   Module ZSEDITL - Insert a decimal point and remove leading  *
      *                    zeros from signed numeric field            *
      *                                                               *
      *  This module is copied from ZSEDIT. Changes has been made to  *
      *  allow the numeric field to have more than 9 decimal places.  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 238193             Date 23Aug06               *
      *                 BUG6460            Date 18Apr05               *
      *                 220859  *CREATE    Date 11Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  238193 - OIS Compounding report error.  Apply BUG6460.       *
      *  BUG6460 - OIS Compounding report error                       *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places.                             *
      *                                                               *
      *****************************************************************
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D ZS2             S              1    DIM(22)
      *
     D                 DS
     D  WORK19                 1     19  0
     D  ZS1                    1     19  0 DIM(19)
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZFLD19           19 0          I:Numeric Field
     C                   PARM                    ZDECS             2 0          I:No of Decimals
     C                   PARM                    ZECODE            1            I:Edit Code
     C                   PARM                    ZOUT21           22            O:Function Field
      *
     C                   EXSR      ZSEDITL
      *
     C                   RETURN
      *
      ********************************************************************
      **                                                                 *
      ** ZSEDITL subroutine to insert a decimal point and sign into a    *
      ** numeric field and to blank out leading zeros (optionaly         *
      ** inserting commas).                                              *
      **     Input fields:   ZFLD18 19/0                                 *
      **                     ZDECS  2/0                                  *
      **                     ZECODE 1/  ('J', 'L' or blank)              *
      **                                                                 *
      **    Arrays:          ZS1    19/1/0                               *
      **                     ZS2    21/1/                                *
      **                                                                 *
      **     Output fields:  ZOUT21 21                                   *
      **                                                                 *
     CSR   ZSEDITL       BEGSR                                                  **  ZSEDITL  *
      *
      * Define/Clear fields
     C                   Z-ADD     ZFLD19        ZFLD19           19 0
     C                   Z-ADD     ZDECS         ZDECS             2 0
     C                   MOVE      ZECODE        ZECODE            1
     C                   MOVE      *BLANKS       ZOUT22           22
      *
      ** Set up work fields
     C                   Z-ADD     0             ZS1
     C                   MOVE      ' '           ZS2
      *
     C                   Z-ADD     19            Z1                2 0
     C                   Z-ADD     21            Z2                2 0
      *
     C     19            SUB       ZDECS         ZINTS             2 0
      *
      ** Check if numeric field is negative
     C     ZFLD19        IFLT      *ZEROS
     C                   MOVE      '-'           ZS2(22)
     C                   Z-SUB     ZFLD19        ZFLD19
     C                   END
      *
     C                   Z-ADD     ZFLD19        WORK19
      *
      ** Check to see if there are any decimal places
     C     ZDECS         CABEQ     0             ZS10
      *
      ** Set up Decimals
     C                   Z-ADD     *ZEROS        ZCNT              2 0
     C     ZCNT          DOUEQ     ZDECS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z2
     C                   ADD       1             ZCNT
     C                   SUB       1             Z1
     C                   END
      *
      ** Put in Decimal Place
     C                   MOVE      '.'           ZS2(Z2)
     C                   SUB       1             Z2
      *
     C     ZS10          TAG                                                    ** ZS10 TAG **
      *
      ** Set up Integers
     C                   Z-ADD     *ZEROS        CNT3              1 0
     C     Z1            DOUEQ     *ZEROS
     C                   MOVE      ZS1(Z1)       ZS2(Z2)
     C                   SUB       1             Z1
     C                   SUB       1             Z2
      *
      ** If edit code is 'J', insert a ',' before each group of three
      ** digits - not if beginning of array reached.
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
     C                   Z-ADD     1             Z2
     C     ZS2(Z2)       DOWEQ     '0'
     C     ZS2(Z2)       OREQ      ' '
     C     ZS2(Z2)       OREQ      ','
     C                   MOVE      ' '           ZS2(Z2)
     C                   ADD       1             Z2
     C     Z2            CABEQ     22            ZS20
     C                   END
      *
      ** If no integers put in leading zero
     C     ZS20          TAG                                                    ** ZS20 TAG **
      *
     C     Z2            IFEQ      23
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
      ** Set up output field
     C**********         MOVEA     ZS2           ZOUT22                                      BUG6460
     C                   MOVEA     ZS2           ZOUT21                                      BUG6460
      *
     CSR                 ENDSR
     C*****************************************************************
     C*
**  CPY@
(c) Finastra International Limited 2003
