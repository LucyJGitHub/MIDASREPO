     H DEBUG TRUNCNBR(*YES)
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Modulus-10 Check for 10 Characters Fields')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GLVGMD10 - Modulus-10 Check for 10 Characters Fields         *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems Ltd. 2018  *
      *                                                               *
      *  Note: The input field (P@Fld10) is supposed to be numeric.   *
      *        The calling program/module should have done this va-   *
      *        liation.                                               *
      *                                                               *
      *  Last Amend No. CRE114   *CREATE   Date 19Feb18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE114 - Modulus 10 for Retail Account Number (FOB006)       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of F-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Defines the input field as an array of 9 digits and
      ** a control byte
      *
     D P@Fld10         DS            10
     D   InputArr                     1S 0 Dim(9)
     D   InputCB                      1S 0

      ** Defines the weight to be applied to each digit of the input field
      *
     D                 DS             9
     D   WghtArrIni                   9A   INZ('212121212')
     D   WeightArr                    1S 0 Dim(9)
     D                                     Overlay(WghtArrIni)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** Defines a comparator string to be used for numeric testing
      *
     D WDigits         C                   '0123456789'

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Defines: - an array used to compute the check sum
      **          - a field to contain the unit number of the check sum
      **          - the calculated check digit (2 digits because 10 - 0 = 10)
      **          - the array index that will be used
      *
     D ChkSumArr       S              1S 0 DIM(18)
     D ChkSumUnit      S              1S 0
     D CheckDigit      S              2S 0
     D X               S              2S 0

      ** +--------------------------------------+
      ** ¦ End of Manually included D-specs     ¦
      ** ¦ ================================     ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of I-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Clears the return code
      *
     C                   Move      *Blanks       RetCodeOut

      ** Ensures that the input array contains only numeric characters
      ** (Error and end module if not)
      *
     C     WDigits       Check     P@Fld10       X

     C                   If        %Found
     C                   Eval      RetCodeOut = 'REL0022'
     C                   GoTo      #EndMod
     C                   EndIf

      ** Sets up the check sum array:
      **  . Each input digit is multiplied by its corresponding weight
      **  . The array element indexed by X will contain the ten number
      **    of the result
      **  . The array element indexed by X+9  will contain the unit
      **    number of the result
      *
     C                   Do        9             X
     C                   Eval      ChkSumArr(X) = (InputArr(X) * WeightArr(X))
     C                                                        / 10
     C                   Eval      ChkSumArr(X+9) = (InputArr(X) * WeightArr(X))
     C                                            - (10 * ChkSumArr(X))
     C                   EndDo

      ** Calculates the unit number of the check sum
      *
     C                   XFoot     ChkSumArr     ChkSumUnit

      ** Finds the check digit
      *
     C                   Eval      CheckDigit = 10 - ChkSumUnit

      ** Compares the calculated check digit with the inputed one and
      ** sets up an error if different
      *
     C                   If        InputCB <> CheckDigit
     C                   Eval      RetCodeOut = 'REL0022'
     C                   EndIf

      ** Return to the Caller
      *
     C     #EndMod       Tag
      *    -------
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *Entry        Plist
      ** Return Code
     C                   Parm                    RetCodeOut
      ** 10 Character Long Input Field
     C                   Parm                    P@Fld10
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C     @INZSR        ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**CTDATA CPY@
(C) Copyright Finsastra International Ltd. 2018
