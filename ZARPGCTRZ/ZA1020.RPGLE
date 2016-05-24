     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Convert Amount to Display')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA1020 - Convert (15,0) amount to (21A) displayable field,   *
      *           edited according to the number of decimal places    *
      *           for the currency. Commas are inserted as well.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD037890           Date 25May16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002  *CREATE    Date 01Aug97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD037890 - Display negative amounts correctly.               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
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

      ** Include the ZA standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @D              S              1    DIM(15)
      **  Array for amount input.

     D @E              S              1    DIM(21)
      **  Array for display amount.

     D @C              S              1    DIM(21)

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C                   EXSR      ZA1020
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*     ZA1020 -  Convert Amount to Display                      *
     C*     INPUT:   @@IAMT - Input amount.                          *
     C*              @@CRET - Number of characters to return.        *
     C*              @@CDP  - Currency decimal places.               *
     C*     OUTPUT:  @@ADSP - Amount to display.                     *
     C****************************************************************
     C     ZA1020        BEGSR
     C**  Define and initialise fields used.
     C                   Z-ADD     @@IAMT        @@IAMT           15 0
     C**********         MOVEL     @@IAMT        @@AMDS           15                        MD037890
     C                   MOVEL     *BLANKS       @@AMDS           15                        MD037890
     C                   MOVE      '0'           *IN60                                      MD037890
     C                   Z-ADD     @@CRET        @@CRET            2 0
     C                   Z-ADD     @@CDP         @@CDP             1 0
     C                   MOVE      *BLANKS       @@ADSP           21
     C                   Z-ADD     *ZEROS        @@C               2 0
     C                   Z-ADD     *ZEROS        @@D               2 0
     C                   Z-ADD     *ZEROS        @@E               2 0
     C                   Z-ADD     *ZEROS        @@F               2 0
     C                   Z-ADD     *ZEROS        @@G               2 0
     C                   Z-ADD     *ZEROS        @@H               2 0
     C                   Z-ADD     *ZEROS        @@MAX             2 0
     C                   Z-ADD     *ZEROS        @@CNT1            2 0
     C                   Z-ADD     *ZEROS        @@CNT2            2 0
     C                   Z-ADD     *ZEROS        @@RES             2 0
     C                   Z-ADD     *ZEROS        @@CMOV            2 0
     C                   Z-ADD     *ZEROS        @@DIFF            2 0
     C                   Z-ADD     *ZEROS        @@REMD            1 0
     C                   Z-ADD     *ZEROS        @@MRET            2 0
     C**  Initialise arrays.
     C                   MOVEA     *BLANKS       @C
     C                   MOVEA     *BLANKS       @D
     C                   MOVEA     *BLANKS       @E
     C**  Take modulus of input amount.
     C     @@IAMT        IFLT      *ZERO                                        B1
     C                   Z-SUB     @@IAMT        @@IAMT                         *1
     C                   MOVE      '1'           *IN60                                      MD037890
     C                   END                                                    E1
     C                   MOVEL     @@IAMT        @@AMDS                                     MD037890
     C**  Move input amount to @D.
     C                   MOVEA     @@AMDS        @D
     C**  Move decimal portion of amount to @E.
     C                   Z-ADD     15            @@C
     C                   Z-ADD     21            @@D
     C     21            SUB       @@CDP         @@MAX
     C     @@D           DOWGT     @@MAX                                        B1
     C                   MOVE      @D(@@C)       @E(@@D)                        *1
     C                   SUB       1             @@C                            *1
     C                   SUB       1             @@D                            *1
     C                   END                                                    E1
     C**  Move decimal separator to @E.
     C     @@CDP         IFNE      0                                            B1
     C                   MOVE      BNDCSP        @E(@@D)                        *1
     C                   SUB       1             @@D                            *1
     C                   END                                                    E1
     C**  Find position of last character to be moved.
     C                   Z-ADD     1             @@E
     C     @@E           DOWLT     15                                           B1
     C     @D(@@E)       ANDEQ     '0'                                          *1
     C                   ADD       1             @@E                            *1
     C                   END                                                    E1
     C**  Move integer portion of amount to @E.
     C                   Z-ADD     0             @@CNT1
     C                   Z-ADD     0             @@CNT2
     C     @@C           DOWGT     @@E                                          B1
     C                   MOVE      @D(@@C)       @E(@@D)                        *1
     C                   ADD       1             @@CNT1                         *1
     C                   SUB       1             @@C                            *1
     C                   SUB       1             @@D                            *1
     C**  Insert thousand separators.
     C     @@CNT1        DIV       3             @@RES                          *1
     C                   MVR                     @@REMD                         *1
     C     @@REMD        IFEQ      0                                            B*2
     C     @@CNT2        ANDLT     5                                            **2
     C                   MOVE      BNTHSP        @E(@@D)                        **2
     C                   ADD       1             @@CNT2                         **2
     C                   Z-ADD     @@D           @@F                            **2
     C                   SUB       1             @@D                            **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C**  Move last character.
     C                   MOVE      @D(@@C)       @E(@@D)
     C**  Calculate the number of characters that must be returned.
     C     22            SUB       @@D           @@CMOV
     C     @@CMOV        SUB       @@CNT2        @@MRET
     C**  If number of characters to be returned is greater than the
     C**  number that must be returned.
     C     @@MRET        IFGT      @@CRET                                       B1
     C**  Output the required no. of characters, but all '*'.
     C     22            SUB       @@CRET        @@G                            *1
     C                   MOVEA     *BLANKS       @E                             *1
     C                   MOVEA     *ALL'*'       @E(@@G)                        *1
     C                   GOTO      ZA1028                                       *1
     C                   END                                                    E1
     C**  If number of characters moved is greater than number to be
     C**  returned, drop thousand separators until satisfied.
     C     @@CMOV        SUB       @@CRET        @@DIFF
     C     @@DIFF        IFGT      0                                            B1
     C                   DO        @@DIFF                                       B*2
     C                   Z-ADD     1             @@G                            **2
     C                   Z-ADD     2             @@H                            **2
     C     @@G           DOWLE     21                                           B**3
     C                   MOVE      @E(@@G)       @C(@@H)                        ***3
     C                   ADD       1             @@G                            ***3
     C                   ADD       1             @@H                            ***3
     C     @@G           IFEQ      @@F                                          B***4
     C                   ADD       1             @@G                            ****4
     C                   END                                                    E***4
     C                   END                                                    E**3
     C                   MOVEA     @C            @E                             **2
     C                   ADD       4             @@F                            **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C**  Tag ZA1028.
     C     ZA1028        TAG                                                    **ZA1028**
     C**  Move @E to display field.
     C                   MOVEA     @E            @@ADSP
     C     *IN60         IFEQ      '1'                                                      MD037890
     C                   MOVE      @@ADSP        WADSP            20                        MD037890
     C                   MOVE      *BLANKS       @@ADSP                                     MD037890
     C                   MOVE      '-'           @@ADSP                                     MD037890
     C                   MOVEL     WADSP         @@ADSP                                     MD037890
     C                   ENDIF                                                              MD037890
     C     ZA1029        ENDSR                                                  **ZA1029**
     C****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@IAMT           15 0
     C                   PARM                    @@CRET            2 0
     C                   PARM                    @@CDP             1 0
     C                   PARM                    BNDCSP            1
     C                   PARM                    BNTHSP            1
     C                   PARM                    @@ADSP           21
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
