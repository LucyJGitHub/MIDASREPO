     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Calculate next customer number')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNXTCUS - Calculate next customer number                    *
      *                                                               *
      *  Function : This program receives an alpha customer number    *
      *             and calculates the next higher customer number    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG12497  *CREATE    Date 20Nov06              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *           Parameter change only.                              *
      *  BG12497 - Conversion Of Customer Number to Alpha             *
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
      * CalcChkDgt - Calculate CheckDigit for given Customer#         *
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
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Array for the six characters in Customer Number
     D CustArr         S              1A   DIM(6)
      *
      * Weightings for all digits/characters
     D VLD             S              1A   DIM(36) PERRCD(36) CTDATA
      *
      * Valid characters
     D VAL             S              1A   DIM(36) PERRCD(36) CTDATA
      *
      * Weightings for positions in Customer Number
     D WAC2            S              3  0 DIM(6)
      *
      ** Arrays for valid characters in the 6 positions of the customer number
     D Allow1          S              1A   DIM(36) ASCEND
     D Allow2          S              1A   DIM(36) ASCEND
     D Allow3          S              1A   DIM(36) ASCEND
     D Allow4          S              1A   DIM(36) ASCEND
     D Allow5          S              1A   DIM(36) ASCEND
     D Allow6          S              1A   DIM(36) ASCEND
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Constant for System Value Prefix
     D WSysValPfx      C                   'CustAlphaAllow'
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
      *
      ** Customer Number
     D Cust            S              6A
      *
      ** Last Customer Number in range
     D LastCust        S              6A
      *
      ** Next Customer Number
     D NextCust        S              6A
      *
      ** Return Code for this program
     D RtnCode         S              7A
      *
      ** Validity Flags
     D Valid           S              6A
      *
      ** Check Digit
     D CheckDigit      S              1A
      *
      ** Index for Valid character array, VAL
     D IX              S              2S 0
      ** Index for the six characters of Customer#
     D Digit           S              1S 0
     D Digita          S              1A
      ** Indices for arrays of valid characters for each position in the customer number
     D In1             S              2S 0
     D In2             S              2S 0
     D In3             S              2S 0
     D In4             S              2S 0
     D In5             S              2S 0
     D In6             S              2S 0
      ** Maximum character values for each position in the customer number
     D Max1            S              1A
     D Max2            S              1A
     D Max3            S              1A
     D Max4            S              1A
     D Max5            S              1A
     D Max6            S              1A
      ** Minimum character values for each position in the customer number
     D Min1            S              1A
     D Min2            S              1A
     D Min3            S              1A
     D Min4            S              1A
     D Min5            S              1A
     D Min6            S              1A
      *
     DWCusAlphaAllow   S            200A
     DWCusAlphaChksum  S            200A
      *
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)
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
      *
     D WM              S              3  0
     D WM1             S              3  0
     D WI3             S              3  0
     D W#X             S              3  0
     D WPJ             S              3  0
     D WSJ             S              3  0
     D #WK1            S              3  0
     D #WK2            S              3  0
     D WJ              S              1  0
      *
      *  Parameters for calling SDCUSTISO (Validate Customer Number)
      *
     D PCust           S              6A
     D PValid          S              6A
     D PCheckDigit     S              1A
      *
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      *  If there are no available customer numbers, the return code field
      *  will have been set to '*MAX   '.  In this case, exit the program.
      *
     C                   If        RtnCode = '*MAX   '
      *
     C                   Return
      *
     C                   EndIf
      *
     C                   Eval      *IN88 = *ON
      *
      * Perform this routine while the new customer number is invalid.
      *
     C     *IN88         DOWEQ     *ON
      *
      * Split Customer Number into its individual six characters
      *
     C                   MoveA     Cust          CustArr
      *
      *  Increment the 6th character.
      *
      *  If check digit processing is NOT being used,
      *
     C                   If        WCusAlphaChksum = 'N'
      *
      * If 6th character of customer number is not at its maximum value,
      *
     C                   If        CustArr(6) <> Max6
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(6)    Lookup    Allow6(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(6) = Allow6(IX + 1)
      *
      * If 6th character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 6th character to its minimum value.
      *
     C                   Eval      CustArr(6) = Min6
      *
      *  and increment the 5th character.
      *
      * If 5th character of customer number is not at its maximum value,
      *
     C                   If        CustArr(5) <> Max5
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(5)    Lookup    Allow5(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(5) = Allow5(IX + 1)
      *
      * If 5th character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 5th character to its minimum value.
      *
     C                   Eval      CustArr(5) = Min5
      *
      *  and increment the 4th character.
      *
      * If 4th character of customer number is not at its maximum value,
      *
     C                   If        CustArr(4) <> Max4
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(4)    Lookup    Allow4(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(4) = Allow4(IX + 1)
      *
      * If 4th character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 4th character to its minimum value
      *
     C                   Eval      CustArr(4) = Min4
      *
      *  and increment the 3rd character.
      *
      * If 3rd character of customer number is not at its maximum value,
      *
     C                   If        CustArr(3) <> Max3
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(3)    Lookup    Allow3(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(3) = Allow3(IX + 1)
      *
      * If 3rd character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 3rd character to its minimum value.
      *
     C                   Eval      CustArr(3) = Min3
      *
      *  and increment the 2nd character.
      *
      * If 2nd character of customer number is not at its maximum value,
      *
     C                   If        CustArr(2) <> Max2
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(2)    Lookup    Allow2(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(2) = Allow2(IX + 1)
      *
      * If 2nd character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 2nd character to its minimum value.
      *
     C                   Eval      CustArr(2) = Min2
      *
      *  and increment the 1st character.
      *
      * If 1st character of customer number is not at its maximum value,
      *
     C                   If        CustArr(1) <> Max1
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(1)    Lookup    Allow1(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(1) = Allow1(IX + 1)
      *
      * If 1st character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 1st character to its minimum value.
      *
     C                   Eval      CustArr(1) = Min1
      *
      * Set the return code to '*MAX'.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      *  If check digit processing IS being used,
      *
     C                   Else
      *
      * If 5th character of customer number is not at its maximum value,
      *
     C                   If        CustArr(5) <> Max5
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(5)    Lookup    Allow5(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(5) = Allow5(IX + 1)
      *
      * If 5th character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 5th character to its minimum value.
      *
     C                   Eval      CustArr(5) = Min5
      *
      *  and increment the 4th character.
      *
      * If 4th character of customer number is not at its maximum value,
      *
     C                   If        CustArr(4) <> Max4
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(4)    Lookup    Allow4(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(4) = Allow4(IX + 1)
      *
      * If 4th character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 4th character to its minimum value
      *
     C                   Eval      CustArr(4) = Min4
      *
      *  and increment the 3rd character.
      *
      * If 3rd character of customer number is not at its maximum value,
      *
     C                   If        CustArr(3) <> Max3
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(3)    Lookup    Allow3(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(3) = Allow3(IX + 1)
      *
      * If 3rd character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 3rd character to its minimum value.
      *
     C                   Eval      CustArr(3) = Min3
      *
      *  and increment the 2nd character.
      *
      * If 2nd character of customer number is not at its maximum value,
      *
     C                   If        CustArr(2) <> Max2
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(2)    Lookup    Allow2(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(2) = Allow2(IX + 1)
      *
      * If 2nd character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 2nd character to its minimum value.
      *
     C                   Eval      CustArr(2) = Min2
      *
      *  and increment the 1st character.
      *
      * If 1st character of customer number is not at its maximum value,
      *
     C                   If        CustArr(1) <> Max1
      *
      * look up the character in the array of valid characters.
      *
     C                   Eval      IX = 1
     C     CustArr(1)    Lookup    Allow1(IX)                             22
      *
      * and replace it with the next higher character.
      *
     C                   Eval      CustArr(1) = Allow1(IX + 1)
      *
      * If 1st character of customer number is already at its maximum value,
      *
     C                   Else
      *
      * set the 1st character to its minimum value.
      *
     C                   Eval      CustArr(1) = Min1
      *
      * Set the return code to '*MAX'.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   EndIf
      *
      * Place next customer nunber in return field
      *
     C                   MoveA     CustArr       NextCust
      *
      * If generated customer number is greater than the upper limit of the range,
      *
     C                   If        NextCust > LastCust Or NextCust = '999999'
      *
      * set off indicator 88 to exit loop.
      *
     C                   Eval      *IN88 = *OFF
     C                   Eval      RtnCode = '*MAX   '
      *
      *  If generated customer number is okay,
      *
     C                   Else
      *
      *  call program 'SDCUSTISO' to validate the number.
      *
     C                   Eval      PCust = NextCust
     C                   Eval      PValid = *BLANKS
     C                   Call(E)   'SDCUSTISO'   P_SDCUSTISO
      *
      *  If Error
      *
     C                   If        %Error Or (*INU7 = *ON And *INU8 = *ON)
     C                   Eval      DBFILE = 'SDCUSTISO'
     C                   Eval      DBASE = 914
     C                   Eval      DBKEY = PCust
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   EndIf
      *
      *  If new customer number is invalid, set indicator 88 on.
      *
     C                   If        PValid = '      '
     C                   Eval      *IN88 = *OFF
     C                   Else
     C                   Eval      *IN88 = *ON
     C                   Eval      Cust = NextCust
     C                   Eval      NextCust = '      '
      *
     C                   Endif
      *
     C                   EndDo
      *
      ** Normal end processing.  Do not set on *INLR.
      *
     C                   Return
      *
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PList
      *
      ** Customer number (Input)
     C                   Parm                    Cust
      ** Last Customer number in range (Input)
     C                   Parm                    LastCust
      ** Next Customer number (Output)
     C                   Parm                    NextCust
      ** Return Code
     C                   Parm                    RtnCode
      *
      *
     C                   Eval      Valid = *BLANKS
     C                   Eval      CheckDigit = *BLANKS
      *
      ** Parameter list for calling AOSVALR0
      *
     C     P_AOSVALR0    PList
      * Return Code (Output)
     C                   Parm                    PRetCode
      * System Value to be retrieved (Input)
     C                   Parm                    PSysValK1
      * Value returned (Output)
     C                   Parm                    PSysVal1
     C                   Parm                    PSysValK2
     C                   Parm                    PSysVal2
     C                   Parm                    PSysValK3
     C                   Parm                    PSysVal3
     C                   Parm                    PSysValK4
     C                   Parm                    PSysVal4
     C                   Parm                    PSysValK5
     C                   Parm                    PSysVal5
     C                   Parm                    PSysValK6
     C                   Parm                    PSysVal6
     C                   Parm                    PSysValK7
     C                   Parm                    PSysVal7
     C                   Parm                    PSysValK8
     C                   Parm                    PSysVal8
     C                   Parm                    PSysValK9
     C                   Parm                    PSysVal9
     C                   Parm                    PSysValK10
     C                   Parm                    PSysVal10
      *
      *  Parameter list for calling SDCUSTISO
      *
     C     P_SDCUSTISO   PList
      ** Customer Number (Input)
     C                   Parm                    PCust
      ** Validity Flags (Output)
     C                   Parm                    PValid
      ** Check Digit (Output)
     C                   Parm                    PCheckDigit
     C                   Parm                    @data             2                          249076
      *
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaChecksum'
      *
     C                   Eval      PRetCode = *BLANKS
     C                   Eval      PSysValK1 = 'CustAlphaAllow'
     C                   Eval      PSysVal1 = *BLANKS
     C                   Eval      PSysValK2 = 'CustAlphaChecksum'
     C                   Eval      PSysVal2 = *BLANKS
     C                   Call(E)   'AOSVALR0'    P_AOSVALR0
      *
      * If Error retrieving the System values
      *
     C                   If        %Error Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'AOSVALR0'
     C                   Eval      DBASE = 1
     C                   Eval      DBKEY = 'CustAlpha(Allow/Chksum)'
     C                   Eval      DBPGM = PsProcPgm
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
     C                   Eval      WCusAlphaAllow = PSysVal1
     C                   Eval      WCusAlphaChksum = PSysVal2
      *
      *  Initialise variables,
      *
     C                   Eval      In1 = 1
     C                   Eval      In2 = 1
     C                   Eval      In3 = 1
     C                   Eval      In4 = 1
     C                   Eval      In5 = 1
     C                   Eval      In6 = 1
      *
      *  load arrays with valid values for each digit.
      *
     C                   For       Digit = 1 to 6
      *
     C                   Move      Digit         Digita
      *
     C                   For       IX = 1 to 36
      *
     C                   Eval      PRetCode = *BLANKS
     C                   Eval      PSysValK1 = WSysValPfx + VAL(IX) + Digita
     C                   Eval      PSysVal1 = *BLANKS
     C                   Call(E)   'AOSVALR0'    P_AOSVALR0
      *
      * If Error retrieving the System value
      *
     C                   If        %Error Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'AOSVALR0'
     C                   Eval      DBASE = 2
     C                   Eval      DBKEY = PSysValK1
     C                   Eval      DBPGM = PsProcPgm
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
      *  If the character is allowed,
      *
     C                   If        PSysVal1 = 'A'
      *
      *  place the character in the array for the position of the customer number.
      *
     C                   Select
     C                   When      Digit = 1
     C                   Eval      Allow1(In1) = VAL(IX)
     C                   Eval      In1 = In1 + 1
     C                   When      Digit = 2
     C                   Eval      Allow2(In2) = VAL(IX)
     C                   Eval      In2 = In2 + 1
     C                   When      Digit = 3
     C                   Eval      Allow3(In3) = VAL(IX)
     C                   Eval      In3 = In3 + 1
     C                   When      Digit = 4
     C                   Eval      Allow4(In4) = VAL(IX)
     C                   Eval      In4 = In4 + 1
     C                   When      Digit = 5
     C                   Eval      Allow5(In5) = VAL(IX)
     C                   Eval      In5 = In5 + 1
     C                   When      Digit = 6
     C                   Eval      Allow6(In6) = VAL(IX)
     C                   Eval      In6 = In6 + 1
     C                   EndSl
      *
     C                   EndIf
      *
     C                   EndFor
      *
     C                   EndFor
      *
      *  Determine the maximum value of the each of the 6 character positions.
      *
     C                   Eval      IX = 1
     C     ' '           Lookup    Allow1(IX)                             22
     C                   If        *IN22 = *ON
     C                   Eval      Max1 = Allow1(IX - 1)
     C                   Else
     C                   Eval      Max1 = '9'
     C                   EndIf
     C                   Eval      IX = 1
     C     ' '           Lookup    Allow2(IX)                             22
     C                   If        *IN22 = *ON
     C                   Eval      Max2 = Allow2(IX - 1)
     C                   Else
     C                   Eval      Max2 = '9'
     C                   EndIf
     C                   Eval      IX = 1
     C     ' '           Lookup    Allow3(IX)                             22
     C                   If        *IN22 = *ON
     C                   Eval      Max3 = Allow3(IX - 1)
     C                   Else
     C                   Eval      Max3 = '9'
     C                   EndIf
     C                   Eval      IX = 1
     C     ' '           Lookup    Allow4(IX)                             22
     C                   If        *IN22 = *ON
     C                   Eval      Max4 = Allow4(IX - 1)
     C                   Else
     C                   Eval      Max4 = '9'
     C                   EndIf
     C                   Eval      IX = 1
     C     ' '           Lookup    Allow5(IX)                             22
     C                   If        *IN22 = *ON
     C                   Eval      Max5 = Allow5(IX - 1)
     C                   Else
     C                   Eval      Max5 = '9'
     C                   EndIf
     C                   Eval      IX = 1
     C     ' '           Lookup    Allow6(IX)                             22
     C                   If        *IN22 = *ON
     C                   Eval      Max6 = Allow6(IX - 1)
     C                   Else
     C                   Eval      Max6 = '9'
     C                   EndIf
      *
      *  Determine the minimum value of the each of the 6 character positions.
      *
     C                   Eval      Min1 = Allow1(1)
     C                   Eval      Min2 = Allow2(1)
     C                   Eval      Min3 = Allow3(1)
     C                   Eval      Min4 = Allow4(1)
     C                   Eval      Min5 = Allow5(1)
     C                   Eval      Min6 = Allow6(1)
      *
      *  Check whether BEGIN customer number is itself valid.  If it is not, replace it with
      *  the next higher value that is valid.
      *
      * Split Customer Number into its individual six characters
      *
     C                   MoveA     Cust          CustArr
      *
      *  Check whether the first character is valid.
      *
     C                   Z-ADD     1             IN1
     C     CustArr(1)    Lookup    Allow1(IN1)                        78  77
      *
      *  If character is not found, and is therefore not valid,
      *
     C                   If        *IN77 = *OFF
      *
      *  if there is a higher character that is allowed,
      *
     C                   If        *IN78 = *ON
      *
      *  replace the character with the next allowed value and set remaining
      *  characters to the minimum allowed value.
      *
     C                   Eval      CustArr(1) = Allow1(IN1)
     C                   Eval      CustArr(2) = Allow2(1)
     C                   Eval      CustArr(3) = Allow3(1)
     C                   Eval      CustArr(4) = Allow4(1)
     C                   Eval      CustArr(5) = Allow5(1)
     C                   Eval      CustArr(6) = Allow6(1)
      *
      *  If check digit processing IS being used,
      *
     C                   If        WCusAlphaChksum = 'Y'
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   EndIf
      *
      *  if there is NOT a higher character that is allowed,
      *
     C                   Else
      *
      *  set the return code to '*MAX' to indicate that there is no possible higher value.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
      *  If the first character is valid,
      *
     C                   Else
      *
      *  Check whether the second character is valid.
      *
     C                   Z-ADD     1             IN2
     C     CustArr(2)    Lookup    Allow2(IN2)                        78  77
      *
      *  If character is not found, and is therefore not valid,
      *
     C                   If        *IN77 = *OFF
      *
      *  if there is a higher character that is allowed,
      *
     C                   If        *IN78 = *ON
      *
      *  replace the character with the next allowed value and set remaining
      *  characters to the minimum allowed value.
      *
     C                   Eval      CustArr(2) = Allow2(IN2)
     C                   Eval      CustArr(3) = Allow3(1)
     C                   Eval      CustArr(4) = Allow4(1)
     C                   Eval      CustArr(5) = Allow5(1)
     C                   Eval      CustArr(6) = Allow6(1)
      *
      *  If check digit processing IS being used,
      *
     C                   If        WCusAlphaChksum = 'Y'
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   EndIf
      *
      *  if there is NOT a higher character that is allowed,
      *
     C                   Else
      *
      *  set the return code to '*MAX' to indicate that there is no possible higher value.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
      *  If the second character is valid,
      *
     C                   Else
      *
      *  Check whether the third character is valid.
      *
     C                   Z-ADD     1             IN3
     C     CustArr(3)    Lookup    Allow3(IN3)                        78  77
      *
      *  If character is not found, and is therefore not valid,
      *
     C                   If        *IN77 = *OFF
      *
      *  if there is a higher character that is allowed,
      *
     C                   If        *IN78 = *ON
      *
      *  replace the character with the next allowed value and set remaining
      *  characters to the minimum allowed value.
      *
     C                   Eval      CustArr(3) = Allow3(IN3)
     C                   Eval      CustArr(4) = Allow4(1)
     C                   Eval      CustArr(5) = Allow5(1)
     C                   Eval      CustArr(6) = Allow6(1)
      *
      *  If check digit processing IS being used,
      *
     C                   If        WCusAlphaChksum = 'Y'
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   EndIf
      *
      *  if there is NOT a higher character that is allowed,
      *
     C                   Else
      *
      *  set the return code to '*MAX' to indicate that there is no possible higher value.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
      *  If the third character is valid,
      *
     C                   Else
      *
      *  Check whether the forth character is valid.
      *
     C                   Z-ADD     1             IN4
     C     CustArr(4)    Lookup    Allow4(IN4)                        78  77
      *
      *  If character is not found, and is therefore not valid,
      *
     C                   If        *IN77 = *OFF
      *
      *  if there is a higher character that is allowed,
      *
     C                   If        *IN78 = *ON
      *
      *  replace the character with the next allowed value and set remaining
      *  characters to the minimum allowed value.
      *
     C                   Eval      CustArr(4) = Allow4(IN4)
     C                   Eval      CustArr(5) = Allow5(1)
     C                   Eval      CustArr(6) = Allow6(1)
      *
      *  If check digit processing IS being used,
      *
     C                   If        WCusAlphaChksum = 'Y'
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   EndIf
      *
      *  if there is NOT a higher character that is allowed,
      *
     C                   Else
      *
      *  set the return code to '*MAX' to indicate that there is no possible higher value.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
      *  If the forth character is valid,
      *
     C                   Else
      *
      *  Check whether the fifth character is valid.
      *
     C                   Z-ADD     1             IN5
     C     CustArr(5)    Lookup    Allow5(IN5)                        78  77
      *
      *  If character is not found, and is therefore not valid,
      *
     C                   If        *IN77 = *OFF
      *
      *  if there is a higher character that is allowed,
      *
     C                   If        *IN78 = *ON
      *
      *  replace the character with the next allowed value and set remaining
      *  characters to the minimum allowed value.
      *
     C                   Eval      CustArr(5) = Allow5(IN5)
     C                   Eval      CustArr(6) = Allow6(1)
      *
      *  If check digit processing IS being used,
      *
     C                   If        WCusAlphaChksum = 'Y'
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   EndIf
      *
      *  if there is NOT a higher character that is allowed,
      *
     C                   Else
      *
      *  set the return code to '*MAX' to indicate that there is no possible higher value.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
      *  If the fifth character is valid,
      *
     C                   Else
      *
      *  Check whether the sixth character is valid.
      *
      *  If check digit processing IS being used,
      *
     C                   If        WCusAlphaChksum = 'Y'
      *
      *  Calculate the check digit for the 6th character.
      *
     C                   ExSr      CalcChkDgt
      *
     C                   Eval      CustArr(6) = CheckDigit
      *
     C                   Else
      *
     C                   Z-ADD     1             IN6
     C     CustArr(6)    Lookup    Allow6(IN6)                        78  77
      *
      *  If character is not found, and is therefore not valid,
      *
     C                   If        *IN77 = *OFF
      *
      *  if there is a higher character that is allowed,
      *
     C                   If        *IN78 = *ON
      *
      *  replace the character with the next allowed value.
      *
     C                   Eval      CustArr(6) = Allow5(IN6)
      *
      *  if there is NOT a higher character that is allowed,
      *
     C                   Else
      *
      *  set the return code to '*MAX' to indicate that there is no possible higher value.
      *
     C                   Eval      RtnCode = '*MAX   '
      *
     C                   EndIf
      *
      *  If the sixth character is valid,
      *
     C                   Else
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndIf
      *
      *  Update the customer number with the new value.
      *
     C                   MoveA     CustArr       Cust
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcChkDgt - Calculates the Check Digit for a Customer#       *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: InitSr                                                 *
      *                                                               *
      *****************************************************************
      *
     C     CalcChkDgt    BEGSR
      *
     C                   ExSr      InitSr
      *
      * Put values into array
     C                   For       WI3 = 1 TO 6
     C                   Eval      W#X = %Lookup(CustArr(WI3):VLD)
     C                   Eval      WAC2(WI3) = W#X - 1
     C                   EndFor
      *
      * Calculate modulus of first five digits
     C                   Eval      WPJ = WM
      *
      * Loop through first five characters of customer number
     C                   For       WJ = 1 To 5
      *
      * #WK2 is  Pj mod(M1)
     C     WPJ           Div       WM1           #WK1
     C                   Mvr                     #WK2
      *
      * Sj=Pj mod(M1)+value(character j of customer number)
     C                   Eval       WSJ = #WK2 + WAC2(WJ)
      *
      * Calculate #WK2 as Sj mod(M)
     C     WSJ           Div       WM            #WK1
     C                   Mvr                     #WK2
     C                   If        #WK2 = 0
     C                   Eval      #WK2 = WM
     C                   Endif
      *
      * Pj+1 = Sj mod(M) * 2
     C                   Eval      WPJ = #WK2 * 2
      *
     C                   EndFor
      *
      * Work out what the last digit should be
     C     WPJ           Div       WM1           #WK1
     C                   Mvr                     #WK2
     C                   Eval      #WK1 = WM1 - #WK2
     C                   If        #WK1 = 36
     C                   Eval      #WK1 = 0
     C                   EndIf
     C                   Eval      CheckDigit = VLD(#WK1+1)
      *
     C                   ENDSR
      *
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
      *
     C     InitSr        BEGSR
      *
     C                   Eval      WI3   = 0
     C                   Eval      W#X   = 0
     C                   Eval      WPJ   = 0
     C                   Eval      WSJ   = 0
     C                   Eval      #WK1  = 0
     C                   Eval      #WK2  = 0
     C                   Eval      WJ    = 0
      *
     C                   Eval      WM1 = 37
     C                   Eval      WM  = 36
      *
     C                   ENDSR
      *
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
      *
     C                   Dump
      *
     C                   If        @RUN = *BLANK
     C                   Eval      @RUN = 'Y'
      *
     C                   Call      'DBERRCTL'
      *
     C                   EndIf
      *
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      *INLR = *ON
     C                   Return
      *
     C                   ENDSR
      *
      * Compile-Time Array Data
** VLD
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
** VAL
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
