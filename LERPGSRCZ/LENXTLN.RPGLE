     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Calculate Next Loan Number')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LENXTLN - LE Calculate Next Loan Number                      *
      *                                                               *
      *  Function : This program receives an alpha loan number and    *
      *             calculates the next higher loan number            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1021136          Date 24Apr13               *
      *  Prev Amend No. AR1077185B         Date 18Jan13               *
      *                 AR1077185          Date 11Jan13               *
      *                 AR1070602A         Date 23Dec12               *
      *                 CLE148  *CREATE    Date 23Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1021136 - CLE148: Loan with reference '000000' can be      *
      *              created. Recalculate for next loan reference if  *
      *              NextLoan is '000000'. (Child: AR1021140)         *
      *  AR1077185B - Loan reference is being incorrectly updated     *
      *              during loan reversal (Reopen)                    *
      *  AR1077185 - Loan reference generated is alphanumeric when    *
      *              LoanAlphaAllow = 'N'.                            *
      *  AR1070602A - A serious Midas error has occurred appeared upon*
      *              click of confirm complete (Reopen)               *
      *  CLE148 - Alpha Loan Reference                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Error                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * CalcChkDgt - Calculate CheckDigit for given Loan#             *
      * InitSr     - Initialization routine for CalcChkDgt            *
      * *INZSR     - Initialise                                       *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      ** LDA Layout
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
      ** Array for the six characters in Loan Number
     D LoanArr         S              1A   DIM(6)
      *
      * Weightings for all digits/characters
     D VLD             S              1A   DIM(36) PERRCD(36) CTDATA
      *
      ** Weightings for positions in Loan Number
     D WAC2            S              3  0 DIM(6)
      *
      ** Arrays for valid characters in the 6 positions of loan number
     D Allow1          S              1A   DIM(36) ASCEND
     D Allow2          S              1A   DIM(36) ASCEND
     D Allow3          S              1A   DIM(36) ASCEND
     D Allow4          S              1A   DIM(36) ASCEND
     D Allow5          S              1A   DIM(36) ASCEND
     D Allow6          S              1A   DIM(36) ASCEND
      *
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
      *
      ** Constant for System Value Prefix
     D WSysValPfx      C                   'LoanAlphaAllow'
      *
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
      *
     D @RUN            S              1
 
      ** Loan Number
     D Loan            S              6A
     D LoanNum         S              6  0                                                 AR1077185
 
      ** Last Loan Number in range
     D LastLoan        S              6A
 
      ** Next Loan Number
     D NextLoan        S              6A
     D NextLoanN       S              6  0                                                 AR1077185
 
      ** RETURN Code for this program
     D RtnCode         S              7A
 
      ** Validity Flags
     D Valid           S              6A
 
      ** Check Digit
     D CheckDigit      S              1A
 
      ** Index for Valid character array, VAL
     D IX              S              2S 0
 
      ** Index for the six characters of Loan#
     D Digit           S              1S 0
     D Digita          S              1A
 
      ** Maximum character values for each position in the loan number
     D Max1            S              1A
     D Max2            S              1A
     D Max3            S              1A
     D Max4            S              1A
     D Max5            S              1A
     D Max6            S              1A
 
      ** Minimum character values for each position in the loan number
     D Min1            S              1A
     D Min2            S              1A
     D Min3            S              1A
     D Min4            S              1A
     D Min5            S              1A
     D Min6            S              1A
 
     DWLonAlphaAllow   S            200A
     DWLonAlphaChksum  S            200A
 
      ** Parameters for calling AOSVALR0 (System Value Access Object)
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
 
     D WM              S              3  0
     D WM1             S              3  0
     D WI3             S              3  0
     D W#X             S              3  0
     D WPJ             S              3  0
     D WSJ             S              3  0
     D #WK1            S              3  0
     D #WK2            S              3  0
     D WJ              S              1  0
     D @data           S              2A
     D WTest           S              1A                                                   AR1077185
 
      ** Parameters for calling LELOANISO (Validate Loan Number)
     D PLoan           S              6A
     D PValid          S              6A
     D PCheckDigit     S              1A
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** If there are no available loan numbers, the RETURN code field
      ** will have been set to '*MAX   '.  In this case, exit the program.
 
     C                   IF        RtnCode = '*MAX   '
 
     C                   RETURN
 
     C                   ENDIF
 
     C                   EVAL      *IN88 = *ON
 
      ** Perform this routine while the new loan number is invalid.
 
     C     *IN88         DOWEQ     *ON
 
      ** Split Loan Number into its individual six characters
 
     C                   MOVEA     Loan          LoanArr
 
      ** Increment the 6th character.
 
      ** If check digit processing is NOT being used,
 
     C                   IF        WLonAlphaChksum = 'N'
 
      ** If 6th character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(6) <> Max6
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(6)    LOOKUP    Allow6(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(6) = Allow6(IX + 1)
 
      ** If 6th character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 6th character to its minimum value.
 
     C                   EVAL      LoanArr(6) = Min6
 
      ** and increment the 5th character.
 
      ** If 5th character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(5) <> Max5
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(5)    LOOKUP    Allow5(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(5) = Allow5(IX + 1)
 
      ** If 5th character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 5th character to its minimum value.
 
     C                   EVAL      LoanArr(5) = Min5
 
      **  and increment the 4th character.
 
      ** If 4th character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(4) <> Max4
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(4)    LOOKUP    Allow4(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(4) = Allow4(IX + 1)
 
      ** If 4th character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 4th character to its minimum value
 
     C                   EVAL      LoanArr(4) = Min4
 
      ** and increment the 3rd character.
 
      ** If 3rd character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(3) <> Max3
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(3)    LOOKUP    Allow3(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(3) = Allow3(IX + 1)
 
      ** If 3rd character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 3rd character to its minimum value.
 
     C                   EVAL      LoanArr(3) = Min3
 
      **  and increment the 2nd character.
 
      ** If 2nd character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(2) <> Max2
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(2)    LOOKUP    Allow2(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(2) = Allow2(IX + 1)
 
      ** If 2nd character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 2nd character to its minimum value.
 
     C                   EVAL      LoanArr(2) = Min2
 
      ** and increment the 1st character.
 
      ** If 1st character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(1) <> Max1
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(1)    LOOKUP    Allow1(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(1) = Allow1(IX + 1)
 
      ** If 1st character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 1st character to its minimum value.
 
     C                   EVAL      LoanArr(1) = Min1
 
      ** Set the RETURN code to '*MAX'.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If check digit processing IS being used,
 
     C                   ELSE
 
      ** If 5th character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(5) <> Max5
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(5)    LOOKUP    Allow5(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(5) = Allow5(IX + 1)
 
      ** If 5th character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 5th character to its minimum value.
 
     C                   EVAL      LoanArr(5) = Min5
 
      ** and increment the 4th character.
 
      ** If 4th character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(4) <> Max4
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(4)    LOOKUP    Allow4(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(4) = Allow4(IX + 1)
 
      ** If 4th character of loan number is already at its maximum value,
 
     C                   ELSE
 
      ** set the 4th character to its minimum value
 
     C                   EVAL      LoanArr(4) = Min4
 
      ** and increment the 3rd character.
 
      ** If 3rd character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(3) <> Max3
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(3)    LOOKUP    Allow3(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(3) = Allow3(IX + 1)
 
      ** If 3rd character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 3rd character to its minimum value.
 
     C                   EVAL      LoanArr(3) = Min3
 
      ** and increment the 2nd character.
 
      ** If 2nd character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(2) <> Max2
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(2)    LOOKUP    Allow2(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(2) = Allow2(IX + 1)
 
      ** If 2nd character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 2nd character to its minimum value.
 
     C                   EVAL      LoanArr(2) = Min2
 
      ** and increment the 1st character.
 
      ** If 1st character of loan number is not at its maximum value,
 
     C                   IF        LoanArr(1) <> Max1
 
      ** look up the character in the array of valid characters.
 
     C                   EVAL      IX = 1
     C     LoanArr(1)    LOOKUP    Allow1(IX)                             22
 
      ** and replace it with the next higher character.
 
     C                   EVAL      LoanArr(1) = Allow1(IX + 1)
 
      ** If 1st character of loan number is already at its maximum
      ** value,
 
     C                   ELSE
 
      ** set the 1st character to its minimum value.
 
     C                   EVAL      LoanArr(1) = Min1
 
      ** Set the RETURN code to '*MAX'.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ENDIF
 
      ** Place next loan nunber in RETURN field
 
     C                   IF        WLonAlphaAllow = 'N'                                   AR1077185B
     C                   EXSR      SrLoanN                                                AR1077185B
     C                   ELSE                                                             AR1077185B
     C                   MOVEA     LoanArr       NextLoan
     C                   ENDIF                                                            AR1077185B
 
      ** If generated loan number is greater than the upper limit of
      ** the range,
 
     C                   IF        NextLoan > LastLoan Or NextLoan = '999999'
     C                             OR NextLoan = '000000'                                  AR1021136
      *                                                                                    AR1021136
     C                   IF        NextLoan <> '000000'                                    AR1021136
 
      ** set off indicator 88 to exit loop.
 
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      RtnCode = '*MAX   '
      *                                                                                    AR1021136
     C                   ENDIF                                                             AR1021136
 
      ** If generated loan number is okay,
 
     C                   ELSE
 
     C                   IF        WLonAlphaAllow = 'Y'                                   AR1070602A
      ** call program 'LELOANISO' to validate the number.
 
     C                   EVAL      PLoan = NextLoan
     C                   EVAL      PValid = *BLANKS
     C                   CALL(E)   'LELOANISO'   P_LELOANISO
 
      ** If Error
 
     C                   IF        %ERROR OR (*INU7 = *ON AND *INU8 = *ON)
     C                   EVAL      DBFILE = 'LELOANISO'
     C                   EVAL      DBASE = 914
     C                   EVAL      DBKEY = PLoan
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                            AR1070602A
 
     C                   ENDIF
 
      ** If new loan number is invalid, set indicator 88 on.
 
     C**********         IF        PValid = '      '                                       AR1021136
     C                   IF        PValid = '      ' AND NextLoan <> '000000'              AR1021136
     C                   EVAL      *IN88 = *OFF
     C                   ELSE
     C                   EVAL      *IN88 = *ON
     C                   EVAL      Loan = NextLoan
     C                   EVAL      NextLoan = '      '
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Normal end processing.  Do not set on *INLR.
 
     C                   RETURN
 
      *****************************************************************                   AR1077185B
      /EJECT                                                                              AR1077185B
      *****************************************************************                   AR1077185B
      *                                                               *                   AR1077185B
      * SRLoanN - Calculate Next Loan Number (Numeric)                *                   AR1077185B
      *                                                               *                   AR1077185B
      * Called by: Main                                               *                   AR1077185B
      *                                                               *                   AR1077185B
      * Calls: None                                                   *                   AR1077185B
      *                                                               *                   AR1077185B
      *****************************************************************                   AR1077185B
     C     SRLoanN       BEGSR                                                            AR1077185B
     C                   EVAL      LoanNum = 0                                            AR1077185B
     C                   EVAL      NextLoanN = 0                                          AR1077185B
                                                                                          AR1077185B
     ** Validate that loan number is numeric                                              AR1077185B
                                                                                          AR1077185B
     C                   TESTN                   Loan                 98                  AR1077185B
     C                   MOVE      Loan          WTest                                    AR1077185B
     C                   TESTZ                   WTest                    99              AR1077185B
                                                                                          AR1077185B
     C                   IF        *IN98 = *ON AND *IN99 = *ON                            AR1077185B
     C                   MOVE      Loan          LoanNum                                  AR1077185B
     C                   EVAL      NextLoanN = LoanNum + 1                                AR1077185B
     C                   MOVE      NextLoanN     NextLoan                                 AR1077185B
     C                   ELSE                                                             AR1077185B
     C                   EVAL      DBASE = 3                                              AR1077185B
     C                   EVAL      DBKEY = Loan                                           AR1077185B
     C                   EVAL      DBPGM = 'LENXTLN'                                      AR1077185B
     C                   EXSR      *PSSR                                                  AR1077185B
     C                   ENDIF                                                            AR1077185B
                                                                                          AR1077185B
     C                   RETURN                                                           AR1077185B
     C                   ENDSR                                                            AR1077185B
      *****************************************************************
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
 
     C     *ENTRY        PLIST
 
      ** Loan number (Input)
     C                   PARM                    Loan
      ** Last Loan number in range (Input)
     C                   PARM                    LastLoan
      ** Next Loan number (Output)
     C                   PARM                    NextLoan
      ** RETURN Code
     C                   PARM                    RtnCode
 
 
     C                   EVAL      Valid = *BLANKS
     C                   EVAL      CheckDigit = *BLANKS
 
      ** Parameter list for calling AOSVALR0
 
     C     P_AOSVALR0    PLIST
      ** RETURN Code (Output)
     C                   PARM                    PRetCode
      ** System Value to be retrieved (Input)
     C                   PARM                    PSysValK1
      ** Value RETURNed (Output)
     C                   PARM                    PSysVal1
     C                   PARM                    PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM                    PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM                    PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM                    PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM                    PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM                    PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM                    PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM                    PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM                    PSysValK10
     C                   PARM                    PSysVal10
 
      ** Parameter list for calling LELOANISO
 
     C     P_LELOANISO   PLIST
      ** Loan Number (Input)
     C                   PARM                    PLoan
      ** Validity Flags (Output)
     C                   PARM                    PValid
      ** Check Digit (Output)
     C                   PARM                    PCheckDigit
     C                   PARM                    @data
 
      ** Retrieve System Value 'LoanAlphaAllow' & 'LoanAlphaChecksum'
 
     C                   EVAL      PRetCode = *BLANKS
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'
     C                   EVAL      PSysVal1 = *BLANKS
     C                   EVAL      PSysValK2 = 'LoanAlphaChecksum'
     C                   EVAL      PSysVal2 = *BLANKS
     C                   CALL(E)   'AOSVALR0'    P_AOSVALR0
 
      ** If Error retrieving the System values
 
     C                   IF        %ERROR Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOSVALR0'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'
     C                   EVAL      DBPGM = PsProcPgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      WLonAlphaAllow = PSysVal1
     C                   EVAL      WLonAlphaChksum = PSysVal2
 
     C**********         IF        WLonAlphaAllow = 'N'                         AR1077185 AR1077185B
     C**********         EVAL      LoanNum = 0                                  AR1077185 AR1077185B
     C**********         EVAL      NextLoanN = 0                                AR1077185 AR1077185B
      **********                                                                AR1077185 AR1077185B
     ***Validate*that*loan*number*is*numeric*                                   AR1077185 AR1077185B
      **********                                                                AR1077185 AR1077185B
     C**********         TESTN                   Loan                 98        AR1077185 AR1077185B
     C**********         MOVE      Loan          WTest                          AR1077185 AR1077185B
     C**********         TESTZ                   WTest                    99    AR1077185 AR1077185B
      **********                                                                AR1077185 AR1077185B
     C**********         IF        *IN98 = *ON AND *IN99 = *ON                  AR1077185 AR1077185B
     C**********         MOVE      Loan          LoanNum                        AR1077185 AR1077185B
     C**********         EVAL      NextLoanN = LoanNum + 1                      AR1077185 AR1077185B
     C**********         MOVE      NextLoanN     NextLoan                       AR1077185 AR1077185B
     C**********         ELSE                                                   AR1077185 AR1077185B
     C**********         EVAL      DBASE = 3                                    AR1077185 AR1077185B
     C**********         EVAL      DBKEY = Loan                                 AR1077185 AR1077185B
     C**********         EVAL      DBPGM = 'LENXTLN'                            AR1077185 AR1077185B
     C**********         EXSR      *PSSR                                        AR1077185 AR1077185B
     C**********         ENDIF                                                  AR1077185 AR1077185B
      **********                                                                AR1077185 AR1077185B
     C**********         RETURN                                                 AR1077185 AR1077185B
     C**********         ENDIF                                                  AR1077185 AR1077185B
      **********                                                                AR1077185 AR1077185B
      ** Initialise variables,
 
      ** load arrays with valid values for each digit.
 
     C                   FOR       Digit = 1 TO 6
 
     C                   MOVE      Digit         Digita
 
     C                   EVAL      PRetCode = *BLANKS
     C                   EVAL      PSysValK1 = WSysValPfx + Digita
     C                   EVAL      PSysVal1 = *BLANKS
     C                   CALL(E)   'AOSVALR0'    P_AOSVALR0
 
      ** If Error retrieving the System value
 
     C                   IF        %ERROR Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOSVALR0'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = PSysValK1
     C                   EVAL      DBPGM = PsProcPgm
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** place the character in the array for the position of the loan
      ** number.
 
     C                   SELECT
     C                   WHEN      Digit = 1
     C                   MOVEA     PSysVal1      Allow1
     C                   WHEN      Digit = 2
     C                   MOVEA     PSysVal1      Allow2
     C                   WHEN      Digit = 3
     C                   MOVEA     PSysVal1      Allow3
     C                   WHEN      Digit = 4
     C                   MOVEA     PSysVal1      Allow4
     C                   WHEN      Digit = 5
     C                   MOVEA     PSysVal1      Allow5
     C                   WHEN      Digit = 6
     C                   MOVEA     PSysVal1      Allow6
     C                   ENDSL
 
     C                   ENDFOR
 
      ** Determine the maximum value of the each of the 6 character
      ** positions.
 
     C                   EVAL      IX = 1
     C     ' '           LOOKUP    Allow1(IX)                             22
     C                   IF        *IN22 = *ON
     C                   EVAL      Max1 = Allow1(IX - 1)
     C                   ELSE
     C                   EVAL      Max1 = '9'
     C                   ENDIF
 
     C                   EVAL      IX = 1
     C     ' '           LOOKUP    Allow2(IX)                             22
     C                   IF        *IN22 = *ON
     C                   EVAL      Max2 = Allow2(IX - 1)
     C                   ELSE
     C                   EVAL      Max2 = '9'
     C                   ENDIF
 
     C                   EVAL      IX = 1
     C     ' '           LOOKUP    Allow3(IX)                             22
     C                   IF        *IN22 = *ON
     C                   EVAL      Max3 = Allow3(IX - 1)
     C                   ELSE
     C                   EVAL      Max3 = '9'
     C                   ENDIF
 
     C                   EVAL      IX = 1
     C     ' '           LOOKUP    Allow4(IX)                             22
     C                   IF        *IN22 = *ON
     C                   EVAL      Max4 = Allow4(IX - 1)
     C                   ELSE
     C                   EVAL      Max4 = '9'
     C                   ENDIF
 
     C                   EVAL      IX = 1
     C     ' '           LOOKUP    Allow5(IX)                             22
     C                   IF        *IN22 = *ON
     C                   EVAL      Max5 = Allow5(IX - 1)
     C                   ELSE
     C                   EVAL      Max5 = '9'
     C                   ENDIF
 
     C                   EVAL      IX = 1
     C     ' '           LOOKUP    Allow6(IX)                             22
     C                   IF        *IN22 = *ON
     C                   EVAL      Max6 = Allow6(IX - 1)
     C                   ELSE
     C                   EVAL      Max6 = '9'
     C                   ENDIF
 
      ** Determine the minimum value of the each of the 6 character
      ** positions.
 
     C                   EVAL      Min1 = Allow1(1)
     C                   EVAL      Min2 = Allow2(1)
     C                   EVAL      Min3 = Allow3(1)
     C                   EVAL      Min4 = Allow4(1)
     C                   EVAL      Min5 = Allow5(1)
     C                   EVAL      Min6 = Allow6(1)
 
      ** Check whether BEGIN loan number is itself valid.  If it is not,
      ** replace it with the next higher value that is valid.
 
      ** Split Loan Number into its individual six characters
 
     C                   MOVEA     Loan          LoanArr
 
      ** Check whether the first character is valid.
 
     C     LoanArr(1)    LOOKUP    Allow1(1)                          78  77
 
      ** If character is not found, and is therefore not valid,
 
     C                   IF        *IN77 = *OFF
 
      ** if there is a higher character that is allowed,
 
     C                   IF        *IN78 = *ON
 
      ** replace the character with the next allowed value and set
      ** remaining characters to the minimum allowed value.
 
     C                   EVAL      LoanArr(1) = Allow1(1)
     C                   EVAL      LoanArr(2) = Allow2(1)
     C                   EVAL      LoanArr(3) = Allow3(1)
     C                   EVAL      LoanArr(4) = Allow4(1)
     C                   EVAL      LoanArr(5) = Allow5(1)
     C                   EVAL      LoanArr(6) = Allow6(1)
 
      ** If check digit processing IS being used,
 
     C                   IF        WLonAlphaChksum = 'Y'
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ENDIF
 
      ** if there is NOT a higher character that is allowed,
 
     C                   ELSE
 
      ** set the RETURN code to '*MAX' to indicate that there is no
      ** possible higher value.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
 
      ** If the first character is valid,
 
     C                   ELSE
 
      ** Check whether the second character is valid.
 
     C     LoanArr(2)    LOOKUP    Allow2(1)                          78  77
 
      ** If character is not found, and is therefore not valid,
 
     C                   IF        *IN77 = *OFF
 
      ** if there is a higher character that is allowed,
 
     C                   IF        *IN78 = *ON
 
      ** replace the character with the next allowed value and set
      ** remaining characters to the minimum allowed value.
 
     C                   EVAL      LoanArr(2) = Allow2(1)
     C                   EVAL      LoanArr(3) = Allow3(1)
     C                   EVAL      LoanArr(4) = Allow4(1)
     C                   EVAL      LoanArr(5) = Allow5(1)
     C                   EVAL      LoanArr(6) = Allow6(1)
 
      ** If check digit processing IS being used,
 
     C                   IF        WLonAlphaChksum = 'Y'
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ENDIF
 
      ** if there is NOT a higher character that is allowed,
 
     C                   ELSE
 
      ** set the RETURN code to '*MAX' to indicate that there is no
      ** possible higher value.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
 
      ** If the second character is valid,
 
     C                   ELSE
 
      ** Check whether the third character is valid.
 
     C     LoanArr(3)    LOOKUP    Allow3(1)                          78  77
 
      ** If character is not found, and is therefore not valid,
 
     C                   IF        *IN77 = *OFF
 
      ** if there is a higher character that is allowed,
 
     C                   IF        *IN78 = *ON
 
      ** replace the character with the next allowed value and set
      ** remaining characters to the minimum allowed value.
 
     C                   EVAL      LoanArr(3) = Allow3(1)
     C                   EVAL      LoanArr(4) = Allow4(1)
     C                   EVAL      LoanArr(5) = Allow5(1)
     C                   EVAL      LoanArr(6) = Allow6(1)
 
      ** If check digit processing IS being used,
 
     C                   IF        WLonAlphaChksum = 'Y'
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ENDIF
 
      ** if there is NOT a higher character that is allowed,
 
     C                   ELSE
 
      ** set the RETURN code to '*MAX' to indicate that there is no
      ** possible higher value.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
 
      ** If the third character is valid,
 
     C                   ELSE
 
      ** Check whether the forth character is valid.
 
     C     LoanArr(4)    LOOKUP    Allow4(1)                          78  77
 
      ** If character is not found, and is therefore not valid,
 
     C                   IF        *IN77 = *OFF
 
      ** if there is a higher character that is allowed,
 
     C                   IF        *IN78 = *ON
 
      ** replace the character with the next allowed value and set
      ** remaining characters to the minimum allowed value.
 
     C                   EVAL      LoanArr(4) = Allow4(1)
     C                   EVAL      LoanArr(5) = Allow5(1)
     C                   EVAL      LoanArr(6) = Allow6(1)
 
      ** If check digit processing IS being used,
 
     C                   IF        WLonAlphaChksum = 'Y'
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ENDIF
 
      ** if there is NOT a higher character that is allowed,
 
     C                   ELSE
 
      ** set the RETURN code to '*MAX' to indicate that there is no
      ** possible higher value.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
 
      ** If the forth character is valid,
 
     C                   ELSE
 
      ** Check whether the fifth character is valid.
 
     C     LoanArr(5)    LOOKUP    Allow5(1)                          78  77
 
      ** If character is not found, and is therefore not valid,
 
     C                   IF        *IN77 = *OFF
 
      ** if there is a higher character that is allowed,
 
     C                   IF        *IN78 = *ON
 
      ** replace the character with the next allowed value and set
      ** remaining characters to the minimum allowed value.
 
     C                   EVAL      LoanArr(5) = Allow5(1)
     C                   EVAL      LoanArr(6) = Allow6(1)
 
      ** If check digit processing IS being used,
 
     C                   IF        WLonAlphaChksum = 'Y'
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ENDIF
 
      ** if there is NOT a higher character that is allowed,
 
     C                   ELSE
 
      ** set the RETURN code to '*MAX' to indicate that there is no
      ** possible higher value.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
 
      ** If the fifth character is valid,
 
     C                   ELSE
 
      ** Check whether the sixth character is valid.
 
      ** If check digit processing IS being used,
 
     C                   IF        WLonAlphaChksum = 'Y'
 
      ** Calculate the check digit for the 6th character.
 
     C                   EXSR      CalcChkDgt
 
     C                   EVAL      LoanArr(6) = CheckDigit
 
     C                   ELSE
 
     C     LoanArr(6)    LOOKUP    Allow6(1)                          78  77
 
      ** If character is not found, and is therefore not valid,
 
     C                   IF        *IN77 = *OFF
 
      ** if there is a higher character that is allowed,
 
     C                   IF        *IN78 = *ON
 
      ** replace the character with the next allowed value.
 
     C                   EVAL      LoanArr(6) = Allow5(1)
 
      ** if there is NOT a higher character that is allowed,
 
     C                   ELSE
 
      ** set the RETURN code to '*MAX' to indicate that there is no
      ** possible higher value.
 
     C                   EVAL      RtnCode = '*MAX   '
 
     C                   ENDIF
 
      ** If the sixth character is valid,
 
     C                   ELSE
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Update the loan number with the new value.
 
     C                   MOVEA     LoanArr       Loan
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcChkDgt - Calculates the Check Digit for a Loan#           *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: InitSr                                                 *
      *                                                               *
      *****************************************************************
     C     CalcChkDgt    BEGSR
 
     C                   EXSR      InitSr
 
      ** Put values into array
     C                   FOR       WI3 = 1 TO 6
     C                   EVAL      W#X = %Lookup(LoanArr(WI3):VLD)
     C                   EVAL      WAC2(WI3) = W#X - 1
     C                   ENDFOR
 
      ** Calculate modulus of first five digits
     C                   EVAL      WPJ = WM
 
      ** Loop through first five characters of loan number
     C                   FOR       WJ = 1 TO 5
 
      ** #WK2 is  Pj mod(M1)
     C     WPJ           DIV       WM1           #WK1
     C                   MVR                     #WK2
 
      ** Sj=Pj mod(M1)+value(character j of loan number)
     C                   EVAL       WSJ = #WK2 + WAC2(WJ)
 
      ** Calculate #WK2 as Sj mod(M)
     C     WSJ           DIV       WM            #WK1
     C                   MVR                     #WK2
     C                   IF        #WK2 = 0
     C                   EVAL      #WK2 = WM
     C                   ENDIF
 
      ** Pj+1 = Sj mod(M) * 2
     C                   EVAL      WPJ = #WK2 * 2
 
     C                   ENDFOR
 
      ** Work out what the last digit should be
     C     WPJ           DIV       WM1           #WK1
     C                   MVR                     #WK2
     C                   EVAL      #WK1 = WM1 - #WK2
     C                   IF        #WK1 = 36
     C                   EVAL      #WK1 = 0
     C                   ENDIF
     C                   EVAL      CheckDigit = VLD(#WK1+1)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * InitSr - Initialization routine for CalcChkDgt                *
      *                                                               *
      * Called by: CalcChkDgt                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     InitSr        BEGSR
 
     C                   EVAL      WI3   = 0
     C                   EVAL      W#X   = 0
     C                   EVAL      WPJ   = 0
     C                   EVAL      WSJ   = 0
     C                   EVAL      #WK1  = 0
     C                   EVAL      #WK2  = 0
     C                   EVAL      WJ    = 0
 
     C                   EVAL      WM1 = 37
     C                   EVAL      WM  = 36
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
 
      ** Compile-Time Array Data
** VLD
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
