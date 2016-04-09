     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate field is numeric')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZA0840 - Validate whether field is numeric                   *
      *                                                               *
      *  Function:This module will take as input a 16A field,         *
      *           a 1N number of integers and a 1N number of decimal  *
      *           places. Ignoring the leading and trailing blanks    *
      *           it will ensure that the field contains only numeric *
      *           characters and a decimal point, and that it has no  *
      *           embedded blanks, or more than one decimal point.    *
      *           It will also check that the number of figures before*
      *           and after the decimal point do not exceed the input *
      *           parameters. The module will output the number as    *
      *           a 16A field and a 15N field, along with an error    *
      *           code. The alpha field will be right aligned with    *
      *           the leading zeros blanked, and trailing blanks zero *
      *           filled. The number returned will be 15 long with 0  *
      *           decimal places. The error code will contain 0 if    *
      *           there was no error, 1 if there was a non-numeric    *
      *           character found, and 2 if the number of decimal     *
      *           places are wrong.                                   *
      *                                                               *
      *             This was originally a section of code which was   *
      *             repeated in each of the MM deals input programs   *
      *             (subroutine ZA0840)                               *
      *             (and possibly elsewhere). Code has been added     *
      *             around it to turn it into a compilable module     *
      *                                                               *
      *           N.B. Under some circumstances, e.g. when words      *
      *           rather than numbers are input, this module can      *
      *           blank out the input field to be validated.          *
      *           Therefore, this module should be called with a COPY *
      *           of the field to be validated, rather than the field *
      *           itself.                                             *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002  *CREATE    Date 02Sep97               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
     D @F              S              1    DIM(16)
      **  Input array
     D @G              S              1    DIM(16)
      **  Output array
     D @H              S             15  0 DIM(15) CTDATA PERRCD(1)
      **  Array of powers of ten
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error code
     D @@ERCD          S              1  0
      ** Decimal separator
     D BNDCSP          S              1A
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
      *
      *****************************************************************
      *                                                               *
      *                                                               *
      *  Input  : @@ALPH - 16A field containing the field to validate *
      *           @@IDP  - number of decimal places                   *
      *           @@IINT - number of integers                         *
      *           @@MTID - Millions/Thousands id (Y = function on)    *
      *                                                               *
      *  Output : @@ALPH - 16A field for display                      *
      *           @@AMT  - 15N field for calculation                  *
      *           @@ERCD - 1N error code                              *
      *                                                               *
      *  Uses   : @F     - array of 16 elements 1 character long      *
      *           @G     - array of 16 elements 1 character long      *
      *           @@CADP - calculated number of decimal places        *
      *           @@CINT - calculated number of integers              *
      *           @@PIDP - position of dp in input array              *
      *           @@PODP - position of dp in output array             *
      *           @@C    - index for array @F                         *
      *           @@D    - index for array @G                         *
      *           @@WK7  - workfield used for converting array element*
      *                    to a 1N number.                            *
      *           @H     - array containing powers of 10              *
      *           @@E    - index to array @H                          *
      *           @@WK5  - work field                                 *
      *           @@ALP1 - feild used to right align 0 decimal places *
      *           @@MIEA - maximum input elements allowed             *
      *           @@FEL  - first integer element of array @F          *
      *           @@MTF  - millions or thousands (M or T) flag        *
      *           @@S    - counter                                    *
      *           @@S1   - number of decimals after the decimal place *
      *           @@S2   - counter                                    *
      *           @@MRTS - tests decimal elements for M or T          *
     C*****************************************************************
     C*
     C** initialize the fields and the arrays
     C                   Z-ADD     0             IN81              1 0
     C                   Z-ADD     0             IN82              1 0
     C                   MOVE      'N'           @@MTF             1
     C                   MOVE      'N'           @@MRT             1
     C                   MOVE      ' '           @@MRTS            1
     C                   Z-ADD     0             @@ERCD            1 0
     C                   Z-ADD     0             @@AMT            15 0
     C                   MOVEA     *BLANKS       @G
     C                   MOVEA     @@ALPH        @F
     C                   MOVE      *BLANKS       @@ALPH           16
     C                   Z-ADD     0             @@WK7             1 0
     C                   Z-ADD     0             @@CADP            3 0
     C                   Z-ADD     0             @@CINT            3 0
     C                   Z-ADD     0             @@PIDP            3 0
     C                   Z-ADD     0             @@PODP            3 0
     C                   Z-ADD     0             @@C               2 0
     C                   Z-ADD     0             @@D               2 0
     C                   Z-ADD     0             @@E               2 0
     C                   Z-ADD     0             @@K               2 0
     C*
     C** define the input fields
     C     *LIKE         DEFINE    @@CADP        @@IDP
     C     *LIKE         DEFINE    @@CINT        @@IINT
     C*
     C** first check that the number input will not produce a number
     C** output with more than 15 figures.
     C     @@IDP         ADD       @@IINT        @@WK2             2 0
     C     @@WK2         IFGT      15
     C                   Z-ADD     2             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C** Remove trailing zeros if decimal point present
     C                   Z-ADD     1             @@S
     C     BNDCSP        LOOKUP    @F(@@S)                                99    *
     C     *IN99         IFEQ      '1'
     C                   ADD       @@IDP         @@S
     C                   Z-ADD     16            @@C
     C     @@C           DOWGT     @@S
     C     @F(@@C)       IFNE      '0'
     C     @F(@@C)       ANDNE     ' '
     C                   Z-ADD     0             @@C
     C                   ELSE
     C                   MOVE      ' '           @F(@@C)
     C                   SUB       1             @@C
     C                   END
     C                   END
     C                   END
     C*
     C** work through input array, ignoring leading zeros and blanks,
     C** also blanking the leading zeros in the input array.
     C                   Z-ADD     0             IN83              1 0
     C                   Z-ADD     1             @@C
     C     @@C           DOWLE     16
     C     IN83          ANDEQ     0
     C     @F(@@C)       IFNE      ' '
     C     @F(@@C)       ANDNE     '0'
     C                   Z-ADD     1             IN83
     C                   SUB       1             @@C
     C                   END
     C                   ADD       1             @@C
     C                   END
      * If first integer is a zero subtract 1 from @@C to provide
      * correct first integer element of the array.
     C     @@C           IFNE      1
     C                   SUB       1             @@C
     C     @F(@@C)       IFNE      '0'
     C                   ADD       1             @@C
     C                   END
     C                   END
     C                   Z-ADD     @@C           @@FEL             2 0
     C*
     C** check the integer part of the number for valid characters.
     C     @@C           DOWLE     16
     C     @F(@@C)       ANDNE     BNDCSP
     C     @F(@@C)       ANDNE     ' '
     C*
     C** check for non numeric characters
      ** If @@MTID = Y ,allow M or T - for millions and thousands
      ** processing.
     C     @F(@@C)       IFGT      '9'
     C     @F(@@C)       ORLT      '0'
     C     @F(@@C)       IFEQ      'M'
     C     @@MTID        ANDNE     'Y'
     C     @F(@@C)       OREQ      'T'
     C     @@MTID        ANDNE     'Y'
     C     @F(@@C)       ORNE      'M'
     C     @F(@@C)       ANDNE     'T'
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C                   ELSE
     C*
     C     @F(@@C)       IFNE      'M'
     C     @F(@@C)       ANDNE     'T'
     C                   ADD       1             @@CINT
     C                   END
     C*
     C** check number of integers is not greater than that required
     C     @@CINT        IFGT      @@IINT
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     2             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C** multiply the output amount by 10 then add the number in
     C** the input array element being processed.
     C     @F(@@C)       IFNE      'M'
     C     @F(@@C)       ANDNE     'T'
     C     @@AMT         MULT      10            @@AMT
     C                   MOVE      @F(@@C)       @@WK7
     C     @@AMT         ADD       @@WK7         @@AMT
     C                   END
     C                   END
      *
      ** MT or TM etc not allowed.
      *
     C     @@MTF         IFEQ      'Y'
     C     @F(@@C)       IFEQ      'M'
     C     @F(@@C)       OREQ      'T'
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C                   END
      *
     C     @F(@@C)       IFEQ      'M'
     C                   MOVE      'Y'           @@MTF
     C     @@C           SUB       1             @@K
      * If M entered alone add 1 @@amt.
     C     @@AMT         IFEQ      0
     C     @F(@@K)       ANDNE     '0'
     C                   Z-ADD     1             @@AMT
     C                   END
     C     @@AMT         MULT      1000000       @@AMT
     C                   Z-ADD     6             @@MIEA            2 0
     C                   END
      *
     C     @F(@@C)       IFEQ      'T'
     C                   MOVE      'Y'           @@MTF
     C     @@C           SUB       1             @@K
      * If T entered alone add 1 @@amt.
     C     @@AMT         IFEQ      0
     C     @F(@@K)       ANDNE     '0'
     C                   Z-ADD     1             @@AMT
     C                   END
     C     @@AMT         MULT      1000          @@AMT
     C                   Z-ADD     3             @@MIEA
     C                   END
     C*
     C** increase array index
     C                   ADD       1             @@C
     C                   END
     C*
     C** set up position of decimal point in input array
     C                   Z-ADD     @@C           @@PIDP
     C*
     C** if the character pointed to is a decimal point add 1 to the
     C** index
     C     @@C           IFLE      16
     C     @F(@@C)       ANDEQ     BNDCSP
     C                   ADD       1             @@C
     C                   Z-ADD     1             IN82
     C                   END
      * Set Maximum input elements allowed to the correct figure.
     C     @@MTF         IFEQ      'Y'
     C     @@C           SUB       @@FEL         @@FEL
     C     @@FEL         ADD       @@MIEA        @@MIEA
     C                   ELSE
     C     @@C           SUB       @@FEL         @@MIEA
     C                   END
      *
      ** Read through array checking to see if there is an M or T.
     C                   Z-ADD     @@C           @@S               2 0
     C                   Z-ADD     @@C           @@S1              2 0
     C     @@S           DOWLE     16
     C     @F(@@S)       IFEQ      'M'
     C     @F(@@S)       OREQ      'T'
     C                   MOVEA     @F(@@S)       @@MRTS
     C                   MOVE      'Y'           @@MRT
     C                   Z-ADD     @@S           @@S2              2 0
     C                   END
     C                   ADD       1             @@S
     C                   END
      * Calculate the number of decimals after the decimal point.
     C     @@S2          SUB       @@S1          @@S1
      * In thousands - only 3 decimal places allowed.
     C     @@MRTS        IFEQ      'T'
     C     @@S1          IFGT      3
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C                   END
      * In millions  - only 6 decimal places allowed.
     C     @@MRTS        IFEQ      'M'
     C     @@S1          IFGT      6
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C                   END
     C*
     C** now validate the decimal part of the number
     C     @@C           DOWLE     16
     C*
     C** if a blank is found set on the blank input indicator
     C     @F(@@C)       IFEQ      ' '
     C                   Z-ADD     1             IN81
     C                   END
     C*
     C** if the figure is numeric, check that the number of decimal
     C** places does not exceed that specified, and that no blanks
     C** have been entered.
     C     @F(@@C)       IFGE      '0'
     C     @F(@@C)       ANDLE     '9'
     C     @F(@@C)       OREQ      'T'
     C     @@MTID        ANDEQ     'Y'
     C     @F(@@C)       OREQ      'M'
     C     @@MTID        ANDEQ     'Y'
      *
     C     @@MRT         IFNE      'Y'
     C                   ADD       1             @@CADP
     C                   END
     C*
     C     @@CADP        IFGT      @@IDP
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     2             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C     IN81          IFEQ      1
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C** update output amount
     C     @F(@@C)       IFNE      'M'
     C     @F(@@C)       ANDNE     'T'
     C     @@AMT         MULT      10            @@AMT
     C                   MOVE      @F(@@C)       @@WK7
     C                   ADD       @@WK7         @@AMT
     C                   END
      * MT or TM etc not allowed.
     C     @@MTF         IFEQ      'Y'
     C     @F(@@C)       IFEQ      'M'
     C     @F(@@C)       OREQ      'T'
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C                   END
      *
     C     @F(@@C)       IFEQ      'M'
     C                   MOVE      'Y'           @@MTF
      * Multiply @@amt by the correct factor and add the number
      * digits to @@MIEA.
     C     @@S1          IFEQ      1
     C     @@AMT         MULT      1000000       @@AMT
     C                   ADD       6             @@MIEA
     C                   END
     C     @@S1          IFEQ      2
     C     @@AMT         MULT      100000        @@AMT
     C                   ADD       5             @@MIEA
     C                   END
     C     @@S1          IFEQ      3
     C     @@AMT         MULT      10000         @@AMT
     C                   ADD       4             @@MIEA
     C                   END
     C     @@S1          IFEQ      4
     C     @@AMT         MULT      1000          @@AMT
     C                   ADD       3             @@MIEA
     C                   END
     C     @@S1          IFEQ      5
     C     @@AMT         MULT      100           @@AMT
     C                   ADD       2             @@MIEA
     C                   END
     C     @@S1          IFEQ      6
     C     @@AMT         MULT      10            @@AMT
     C                   ADD       1             @@MIEA
     C                   END
      *
     C                   END
      *
     C     @F(@@C)       IFEQ      'T'
     C                   MOVE      'Y'           @@MTF
      * Multiply @@amt by the correct factor and add the number
      * digits to @@MIEA.
     C     @@S1          IFEQ      1
     C     @@AMT         MULT      1000          @@AMT
     C                   ADD       3             @@MIEA
     C                   END
     C     @@S1          IFEQ      2
     C     @@AMT         MULT      100           @@AMT
     C                   ADD       2             @@MIEA
     C                   END
     C     @@S1          IFEQ      3
     C     @@AMT         MULT      10            @@AMT
     C                   ADD       1             @@MIEA
     C                   END
      *
     C                   END
     C*
     C                   ELSE
     C*
     C** if the character is not numeric and not a blank then it is
     C** invalid
     C     @F(@@C)       IFNE      ' '
     C                   Z-ADD     0             @@AMT
     C                   Z-ADD     1             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C                   END
     C*
     C** increase index
     C                   ADD       1             @@C
     C*
     C                   END
      * Check that the number of elements input does not exceed allowed
     C     @@MIEA        ADD       @@IDP         @@MIEA
     C     @@MIEA        IFGT      14
     C                   Z-ADD     2             @@ERCD
     C                   GOTO      Exit
     C                   END
     C*
     C** correct the output number for any decimal places not input
     C** in the alpha field.
     C     @@IDP         SUB       @@CADP        @@E
     C*
     C** increase the index by one to get correct array entry
      ** If @@IDP = 0 add 1 to @@E to prevent array index error.
     C     @@MRT         IFEQ      'N'
     C     @@IDP         OREQ      0
     C                   ADD       1             @@E
     C                   END
     C     @@AMT         MULT      @H(@@E)       @@AMT
      *
     C     @@MRT         IFEQ      'Y'
     C     @@IDP         ANDEQ     0
     C     @@AMT         DIV       10            @@AMT
     C                   END
     C*
     C** now format the output alpha field, first calculate where
     C** the decimal point goes
     C     16            SUB       @@IDP         @@PODP
     C     @@PODP        SUB       1             @@PIDP
     C*
     C** if there are no decimal points set the position to 17
     C     @@IDP         IFEQ      0
     C                   Z-ADD     17            @@PODP
     C                   END
     C*
     C** move the output number into the input array
     C                   MOVEA     *BLANKS       @F
     C                   MOVE      @@AMT         @@AMTA           15
     C                   MOVEA     @@AMTA        @F
     C*
     C** set up indexes
     C                   Z-ADD     1             @@C
     C                   Z-ADD     1             @@D
     C                   Z-ADD     0             IN80              1 0
     C*
     C** now fill up the output array
     C     @@D           DOWLE     16
     C*
     C** insert decimal point if the position is found
     C     @@D           IFEQ      @@PODP
     C                   MOVE      BNDCSP        @G(@@D)
     C                   ADD       1             @@D
     C                   END
     C*
     C** insert the zero before the decimal point
     C     IN80          IFEQ      0
     C     @@D           ANDEQ     @@PIDP
     C     @F(@@C)       ANDEQ     '0'
     C                   Z-ADD     1             IN80
     C                   MOVE      '0'           @G(@@D)
     C                   END
     C*
     C** blank leading zeros
     C     IN80          IFEQ      0
     C     @F(@@C)       ANDEQ     '0'
     C                   MOVE      ' '           @G(@@D)
     C                   END
     C*
     C** move a normal character
     C     @F(@@C)       IFGE      '1'
     C     @F(@@C)       ANDLE     '9'
     C                   MOVE      @F(@@C)       @G(@@D)
     C                   Z-ADD     1             IN80
     C                   END
     C*
     C** non blanked zero
     C     @F(@@C)       IFEQ      '0'
     C     IN80          ANDEQ     1
     C                   MOVE      '0'           @G(@@D)
     C                   END
     C*
     C                   ADD       1             @@C
     C                   ADD       1             @@D
     C                   END
     C*
     C*
     C** put output array into output amount
     C                   MOVEA     @G            @@ALPH
     C*
     C** align figure with zero decimal places.
     C     @@IDP         IFEQ      0
     C                   MOVE      *BLANKS       @@ALP1           17
     C                   MOVE      @@ALPH        @@ALP1
     C                   MOVEL     @@ALP1        @@ALPH
     C                   END
 
      ** If an error was found, set the return code appropriately
     C     Exit          TAG                                                    *** Exit ***
 
     C     @@Ercd        IFEQ      1
     C     @@Ercd        OREQ      2
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
      * N.B. @@ALPH should be a COPY of the field to be checked, see header
      *   for more details.
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@Ercd
     C                   PARM                    @@Amt
     C                   PARM                    BNDCSP
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** array of powers of 10 from 0 to 8  @@H
000000000000001
000000000000010
000000000000100
000000000001000
000000000010000
000000000100000
000000001000000
000000010000000
000000100000000
000001000000000
000010000000000
000100000000000
001000000000000
010000000000000
100000000000000
