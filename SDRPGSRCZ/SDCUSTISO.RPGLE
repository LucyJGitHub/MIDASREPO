     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Customer ISO7064 37,36 check')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSTISO - Customer ISO7064 37,36 Check                     *
      *                                                               *
      *  Function : This program calculates the check digit for a     *
      *             customer number according to ISO7064 37,36 check  *
      *             and validates that the customer number entered    *
      *             in the customer maintenance function meets user   *
      *             defined criteria                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 249076             Date 03Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG12345           Date 27Oct06               *
      *                 BUG11828           Date 13Aug06               *
      *                 CSD027  *CREATE    Date 11Jan06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  249076 - Enhance error message S270004 to show character     *
      *           and position that is not allowed in SDSVALPD.       *
      *  BUG12345 - U7 turns on upon call of SDCUSTISO                *
      *  BUG11828 - If CSD031 is on, System Values are defined        *
      *             centrally.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
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
      * Weightings for positions in Customer Number
     D WAC2            S              3  0 DIM(6)
                                                                                            BUG11828
      ** Switchable Feature Details Data Structure                                          BUG11828
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                BUG11828
                                                                                            BUG11828
      ** Short Access Object Data Structure                                                 BUG11828
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG11828
                                                                                            BUG11828
     D @idxs           DS                                                                     249076
     D  IdxA                   1      1                                                       249076
     D  IdxB                   2      2                                                       249076
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
      ** Validity Flags
     D Valid           S              6A
      *
      ** Check Digit
     D CheckDigit      S              1A
      *
      ** Index for looping through the six characters of Customer#
     D WIdx1           S              1S 0
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
                                                                                            BUG11828
      ** Access Object Parameters                                                           BUG11828
     D PRtcd           S              7A                                                    BUG11828
     D POptn           S              7A                                                    BUG11828
     D PSARD           S              6A                                                    BUG11828
                                                                                            BUG11828
      ** Switchable Features                                                                BUG11828
     D CSD031          S              1A                                                    BUG11828
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
     C                   EVAL      *INU7 = *OFF                                             BUG12345
     C                   EVAL      *INU8 = *OFF                                             BUG12345
                                                                                            BUG12345
      * Retrieve System Value 'CustAlphaAllow' & 'CustAlphaChecksum'
     C                   Eval      PRetCode = *BLANKS
     C                   Eval      PSysValK1 = 'CustAlphaAllow'
     C                   Eval      PSysVal1 = *BLANKS
     C                   Eval      PSysValK2 = 'CustAlphaChecksum'
     C                   Eval      PSysVal2 = *BLANKS
     C**********         Call(E)   'AOSVALR0'    P_AOSVALR0                                 BUG11828
                                                                                            BUG11828
     C                   IF        CSD031 = 'Y'                                             BUG11828
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                 BUG11828
     C                   ELSE                                                               BUG11828
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C                   ENDIF                                                              BUG11828
      *
      * If Error retrieving the System values
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
     C                   If        WCusAlphaAllow = 'N'
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'AOSVALR0'
     C                   Eval      DBASE = 2
     C                   Eval      DBKEY = 'CustAlphaAllow'
     C                   Eval      DBPGM = PsProcPgm
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
      * Split Customer Number into its individual six characters
     C                   MoveA     Cust          CustArr
      *
      * Loop through all characters of Customer#
     C                   For       WIdx1 = 1 TO 6
      *
      * Check if character is valid (0-9 A-Z)
     C                   If        %LookUp(CustArr(WIdx1):VLD) = 0
      * If invalid, then
     C                   Eval      %Subst(Valid:WIdx1:1) = 'Y'
     C                   EndIf
      *
     C                   EndFor
      *
      * If any invalid characters are found, return back to the caller
     C                   If        Valid <> *BLANKS
     C                   Eval      *INLR = *ON
     C                   Return
     C                   EndIf
      *
      * If 6th char is not a CheckDigit, only then check 6th char for CustAlphaAllow** in AOSVALR0
     C                   If        WCusAlphaChksum = 'N'
     C                   Eval      PSysValK6 = WSysValPfx + CustArr(6) + '6'
     C                   Eval      PSysVal6 = *BLANKS
     C                   EndIf
      *
      * Check if characters are valid (CustAlphaAllow** in AOSVALR0)
     C                   Eval      PRetCode = *BLANKS
     C                   Eval      PSysValK1 = WSysValPfx + CustArr(1) + '1'
     C                   Eval      PSysVal1 = *BLANKS
     C                   Eval      PSysValK2 = WSysValPfx + CustArr(2) + '2'
     C                   Eval      PSysVal2 = *BLANKS
     C                   Eval      PSysValK3 = WSysValPfx + CustArr(3) + '3'
     C                   Eval      PSysVal3 = *BLANKS
     C                   Eval      PSysValK4 = WSysValPfx + CustArr(4) + '4'
     C                   Eval      PSysVal4 = *BLANKS
     C                   Eval      PSysValK5 = WSysValPfx + CustArr(5) + '5'
     C                   Eval      PSysVal5 = *BLANKS
     C**********         Call(E)   'AOSVALR0'    P_AOSVALR0                                 BUG11828
                                                                                            BUG11828
     C                   IF        CSD031 = 'Y'                                             BUG11828
     C                   CALL (E)  'GPAOSVALR0'  P_AOSVALR0                                 BUG11828
     C                   ELSE                                                               BUG11828
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                 BUG11828
     C                   ENDIF                                                              BUG11828
      *
      * If Error retrieving the System values
     C                   If        %Error Or PRetCode <> *BLANKS
     C                             Or (*INU7 = *ON And *INU8 = *ON)
     C     *LOCK         In        LDA
     C                   Eval      DBFILE = 'AOSVALR0'
     C                   Eval      DBASE = 3
     C                   Eval      DBKEY = 'CustAlphaAllow**'
     C                   Eval      DBPGM = PsProcPgm
     C                   Out       LDA
     C                   ExSr      *PSSR
     C                   EndIf
      *
      * If invalid, then
     C                   move      *blanks       @idxs                                        249076
     C                   If        PSysVal1 <> 'A'
     C                   Eval      IdxA = '1'                                                 249076
     C                   Eval      IdxB = CustArr(1)                                          249076
     C                   Eval      %Subst(Valid:1:1) = 'Y'
     C                   EndIf
     C                   If        PSysVal2 <> 'A'
     C                   Eval      IdxA = '2'                                                 249076
     C                   Eval      IdxB = CustArr(2)                                          249076
     C                   Eval      %Subst(Valid:2:1) = 'Y'
     C                   EndIf
     C                   If        PSysVal3 <> 'A'
     C                   Eval      IdxA = '3'                                                 249076
     C                   Eval      IdxB = CustArr(3)                                          249076
     C                   Eval      %Subst(Valid:3:1) = 'Y'
     C                   EndIf
     C                   If        PSysVal4 <> 'A'
     C                   Eval      IdxA = '4'                                                 249076
     C                   Eval      IdxB = CustArr(4)                                          249076
     C                   Eval      %Subst(Valid:4:1) = 'Y'
     C                   EndIf
     C                   If        PSysVal5 <> 'A'
     C                   Eval      IdxA = '5'                                                 249076
     C                   Eval      IdxB = CustArr(5)                                          249076
     C                   Eval      %Subst(Valid:5:1) = 'Y'
     C                   EndIf
     C                   If        WCusAlphaChksum = 'N' And PSysVal6 <> 'A'
     C                   Eval      IdxA = '6'                                                 249076
     C                   Eval      IdxB = CustArr(6)                                          249076
     C                   Eval      %Subst(Valid:6:1) = 'Y'
     C                   EndIf
     C                   move      *blanks       @data                                        249076
     C                   Eval      @data = @idxs                                              249076
      *
      * Handle the CheckDigit
     C                   If        WCusAlphaChksum = 'Y' AND Valid = *BLANKS
     C                   ExSr      CalcChkDgt
      *
      * If CheckDigit is not correct
     C                   If        CheckDigit <> CustArr(6)
     C                   Eval      %Subst(Valid:6:1) = 'Y'
     C                   EndIf
      *
     C                   EndIf
      *
      ** Normal end processing
      *
     C                   Eval      *INLR = *ON
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
      ** Validity Flag (Output)
     C                   Parm                    Valid
      ** Check Digit (Output)
     C                   Parm                    CheckDigit
     C                   Parm                    @data             2                          249076
      *
      ** Parameter list for calling AOSVALR0
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
     C                   Eval      Valid = *BLANKS
     C                   Eval      CheckDigit = *BLANKS
                                                                                            BUG11828
      ** Check if CSD031 is on.                                                             BUG11828
                                                                                            BUG11828
     C                   CALL      'AOSARDR0'                                               BUG11828
     C                   PARM      *BLANKS       PRtCd                                      BUG11828
     C                   PARM      '*VERIFY'     POptn                                      BUG11828
     C                   PARM      'CSD031'      PSARD                                      BUG11828
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd = *BLANKS                                          BUG11828
     C                   EVAL      CSD031 = 'Y'                                             BUG11828
     C                   ELSE                                                               BUG11828
                                                                                            BUG11828
     C                   IF        PRtCd <> '*NRF   '                                       BUG11828
     C     *LOCK         IN        LDA                                                      BUG11828
     C                   EVAL      DBFile = 'SCSARDPD'                                      BUG11828
     C                   EVAL      DBKey = POptn                                            BUG11828
     C                   EVAL      DBase = 101                                              BUG11828
     C                   OUT       LDA                                                      BUG11828
     C                   EXSR      *PSSR                                                    BUG11828
     C                   ENDIF                                                              BUG11828
                                                                                            BUG11828
     C                   ENDIF                                                              BUG11828
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
