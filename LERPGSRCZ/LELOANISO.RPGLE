     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Loan ISO7064 37,36 check')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LELOANISO - Loan ISO7064 37,36 Check                         *
      *                                                               *
      *  Function : This program calculates the check digit for a     *
      *             loan reference according to ISO7064 37,36 check   *
      *             and validates that the loan reference entered     *
      *             meets user defined criteria                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1019833          Date 25Mar13               *
      *  Prev Amend No. AR1071068          Date 10Jan13               *
      *                 CLE148  *CREATE    Date 23Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1019833 - Performance issue. Put call of AOSVAL to *INZSR  *
      *              and prevent setting on of *INLR for normal end   *
      *              of the program. (Child: AR1064795)               *
      *  AR1071068 - Skip check-digit validation for existing loans.  *
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
      *
      ** Midas Le Loans File by Loan Reference                                             AR1071068
     FLECLIPL2  IF   E           K DISK    INFSR(*PSSR)                                    AR1071068
     F                                     RENAME(CLOANCKF:CLOANCKLN)                      AR1071068
     F                                     RENAME(CLOANCLF:CLOANCLLN)                      AR1071068
 
      ** +--------------------------------------+
      ** ! D-specs                              !
      ** ! =======                              !
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
      ** ! Arrays and Data Structures           !
      ** ! ==========================           !
      ** +--------------------------------------+
      *
      ** Array for the six characters in Loan Reference
     D LoanArr         S              1A   DIM(6)
      *
      * Weightings for all digits/characters
     D VLD             S              1A   DIM(36) PERRCD(36) CTDATA
     D VLD1            S              1A   DIM(36)
     D VLD2            S              1A   DIM(36)
     D VLD3            S              1A   DIM(36)
     D VLD4            S              1A   DIM(36)
     D VLD5            S              1A   DIM(36)
     D VLD6            S              1A   DIM(36)
 
      ** Weightings for positions in Loan Reference
     D WAC2            S              3  0 DIM(6)
 
      ** Switchable Feature Details Data Structure
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D @idxs           DS
     D  IdxA                   1      1
     D  IdxB                   2      2
      *
      ** +--------------------------------------+
      ** ! Named constants                      !
      ** ! ===============                      !
      ** +--------------------------------------+
      *
      ** Constant for System Value Prefix
     D WSysValPfx      C                   'LoanAlphaAllow'
      *
      ** +--------------------------------------+
      ** ! Declared variables                   !
      ** ! ==================                   !
      ** +--------------------------------------+
      *
     D @RUN            S              1
 
      ** Loan Reference
     D Loan            S              6A
 
      ** Validity Flags
     D Valid           S              6A
 
      ** Check Digit
     D CheckDigit      S              1A
 
      ** Index for looping through the six characters of Loan#
     D WIdx1           S              1S 0
 
     DWLonAlphaAllow   S            200A
     DWLonAlphaChksum  S            200A
 
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
     D NewLoan         S              1A                                                   AR1071068
 
      ** Access Object Parameters
     D PRtcd           S              7A
     D POptn           S              7A
     D PSARD           S              6A
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** !                                                                !
      ** ! Initial processing is performed automatically: the *INZSR is   !
      ** ! executed at program activation.                                !
      ** !                                                                !
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
                                                                                           AR1019833
     C                   Eval      Valid = *BLANKS                                         AR1019833
     C                   Eval      CheckDigit = *BLANKS                                    AR1019833
 
      ***Retrieve System Value 'LoanAlphaAllow' & 'LoanAlphaChecksum'                      AR1019833
      **********                                                                           AR1019833
     C**********         EVAL      PRetCode = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK1 = 'LoanAlphaAllow'                            AR1019833
     C**********         EVAL      PSysVal1 = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK2 = 'LoanAlphaChecksum'                         AR1019833
     C**********         EVAL      PSysVal2 = *BLANKS                                      AR1019833
      **********                                                                           AR1019833
     C**********         CALL (E)  'AOSVALR0'    P_AOSVALR0                                AR1019833
      **********                                                                           AR1019833
      ***If*Error retrieving the System values                                             AR1019833
      **********                                                                           AR1019833
     C**********         IF        %ERROR OR PRetCode <> *BLANKS                           AR1019833
     C**********                   OR (*INU7 = *ON And *INU8 = *ON)                        AR1019833
     C******LOCK         IN        LDA                                                     AR1019833
     C**********         EVAL      DBFILE = 'AOSVALR0'                                     AR1019833
     C**********         EVAL      DBASE = 1                                               AR1019833
     C**********         EVAL      DBKEY = 'LoanAlpha(Allow/Chksum)'                       AR1019833
     C**********         EVAL      DBPGM = PsProcPgm                                       AR1019833
     C**********         OUT       LDA                                                     AR1019833
     C**********         EXSR      *PSSR                                                   AR1019833
     C**********         ENDIF                                                             AR1019833
      **********                                                                           AR1019833
     C**********         EVAL      WLonAlphaAllow = PSysVal1                               AR1019833
     C**********         EVAL      WLonAlphaChksum = PSysVal2                              AR1019833
      **********                                                                           AR1019833
     C**********         IF        WLonAlphaAllow = 'N'                                    AR1019833
     C******LOCK         IN        LDA                                                     AR1019833
     C**********         EVAL      DBFILE = 'AOSVALR0'                                     AR1019833
     C**********         EVAL      DBASE = 2                                               AR1019833
     C**********         EVAL      DBKEY = 'LoanAlphaAllow'                                AR1019833
     C**********         EVAL      DBPGM = PsProcPgm                                       AR1019833
     C**********         OUT       LDA                                                     AR1019833
     C**********         EXSR      *PSSR                                                   AR1019833
     C**********         ENDIF                                                             AR1019833
 
      ** Split Loan Number into its individual six characters
 
     C                   MOVEA     Loan          LoanArr
 
      ** Loop through all characters of Loan#
 
     C                   FOR       WIdx1 = 1 TO 6
 
      ** Check if character is valid (0-9 A-Z)
 
     C                   IF        %LOOKUP(LoanArr(WIdx1):VLD) = 0
 
      ** If invalid, then
 
     C                   EVAL      %SUBST(Valid:WIdx1:1) = 'Y'
     C                   ENDIF
 
     C                   ENDFOR
 
      ** If any invalid characters are found, RETURN back to the caller
 
     C                   IF        Valid <> *BLANKS
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** If 6th char is not a CheckDigit, only then check 6th char for LoanAlphaAllow* in AOSVALR0
 
     C**********         IF        WLonAlphaChksum = 'N'                                   AR1019833
     C**********         EVAL      PSysValK6 = WSysValPfx + '6'                            AR1019833
     C**********         EVAL      PSysVal6 = *BLANKS                                      AR1019833
     C**********         ENDIF                                                             AR1019833
      **********                                                                           AR1019833
      ***Check*if characters are valid (LoanAlphaAllow* in AOSVALR0)                       AR1019833
      **********                                                                           AR1019833
     C**********         EVAL      PRetCode = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK1 = WSysValPfx + '1'                            AR1019833
     C**********         EVAL      PSysVal1 = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK2 = WSysValPfx + '2'                            AR1019833
     C**********         EVAL      PSysVal2 = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK3 = WSysValPfx + '3'                            AR1019833
     C**********         EVAL      PSysVal3 = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK4 = WSysValPfx + '4'                            AR1019833
     C**********         EVAL      PSysVal4 = *BLANKS                                      AR1019833
     C**********         EVAL      PSysValK5 = WSysValPfx + '5'                            AR1019833
     C**********         EVAL      PSysVal5 = *BLANKS                                      AR1019833
      **********                                                                           AR1019833
     C**********         CALL (E)  'AOSVALR0'    P_AOSVALR0                                AR1019833
      **********                                                                           AR1019833
      ***If*Error retrieving the System values                                             AR1019833
      **********                                                                           AR1019833
     C**********         IF        %ERROR OR PRetCode <> *BLANKS                           AR1019833
     C**********                   OR (*INU7 = *ON And *INU8 = *ON)                        AR1019833
     C******LOCK         IN        LDA                                                     AR1019833
     C**********         EVAL      DBFILE = 'AOSVALR0'                                     AR1019833
     C**********         EVAL      DBASE = 3                                               AR1019833
     C**********         EVAL      DBKEY = 'LoanAlphaAllow*'                               AR1019833
     C**********         EVAL      DBPGM = PsProcPgm                                       AR1019833
     C**********         OUT       LDA                                                     AR1019833
     C**********         EXSR      *PSSR                                                   AR1019833
     C**********         ENDIF                                                             AR1019833
 
      ** If invalid, then
 
     C
     C                   EVAL      @idxs = *BLANKS
     C**********         MOVEA     PSysVal1      VLD1                                      AR1019833
 
     C                   IF        %LOOKUP(LoanArr(1):VLD1) = 0
     C                   EVAL      IdxA = '1'
     C                   EVAL      IdxB = LoanArr(1)
     C                   EVAL      %SUBST(Valid:1:1) = 'Y'
     C                   ENDIF
 
     C**********         MOVEA     PSysVal2      VLD2                                      AR1019833
     C                   IF        %LOOKUP(LoanArr(2):VLD2) = 0
     C                   EVAL      IdxA = '2'
     C                   EVAL      IdxB = LoanArr(2)
     C                   EVAL      %SUBST(Valid:2:1) = 'Y'
     C                   ENDIF
 
     C**********         MOVEA     PSysVal3      VLD3                                      AR1019833
     C                   IF        %LOOKUP(LoanArr(3):VLD3) = 0
     C                   EVAL      IdxA = '3'
     C                   EVAL      IdxB = LoanArr(3)
     C                   EVAL      %SUBST(Valid:3:1) = 'Y'
     C                   ENDIF
 
     C**********         MOVEA     PSysVal4      VLD4                                      AR1019833
     C                   IF        %LOOKUP(LoanArr(4):VLD4) = 0
     C                   EVAL      IdxA = '4'
     C                   EVAL      IdxB = LoanArr(4)
     C                   EVAL      %SUBST(Valid:4:1) = 'Y'
     C                   ENDIF
 
     C**********         MOVEA     PSysVal5      VLD5                                      AR1019833
     C                   IF        %LOOKUP(LoanArr(5):VLD5) = 0
     C                   EVAL      IdxA = '5'
     C                   EVAL      IdxB = LoanArr(5)
     C                   EVAL      %SUBST(Valid:5:1) = 'Y'
     C                   ENDIF
 
     C**********         MOVEA     PSysVal6      VLD6                                      AR1019833
     C                   IF        WLonAlphaChksum = 'N' And
     C                             %LOOKUP(LoanArr(6):VLD6) = 0
     C                   EVAL      IdxA = '6'
     C                   EVAL      IdxB = LoanArr(6)
     C                   EVAL      %SUBST(Valid:6:1) = 'Y'
     C                   ENDIF
 
     C                   MOVE      *BLANKS       @data
     C                   EVAL      @data = @idxs
 
      *                                                                                    AR1071068
      ** Check if loan reference is existing in loans file                                 AR1071068
      *                                                                                    AR1071068
     C                   EVAL      NewLoan = 'N'                                           AR1071068
     C     Loan          CHAIN(N)  CLOANCLLN                          99                   AR1071068
     C     Loan          CHAIN(N)  CLOANCKLN                          99                   AR1071068
                                                                                           AR1071068
     C                   IF        *IN99 = '1'                                             AR1071068
     C                   EVAL      NewLoan = 'Y'                                           AR1071068
     C                   ENDIF                                                             AR1071068
 
      ** Handle the CheckDigit
 
     C                   IF        WLonAlphaChksum = 'Y' AND Valid = *BLANKS
     C                             AND NewLoan = 'Y'                                       AR1071068
     C                   EXSR      CalcChkDgt
 
      ** If CheckDigit is not correct
 
     C                   IF        CheckDigit <> LoanArr(6)
     C                   EVAL      %SUBST(Valid:6:1) = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Normal end processing
 
     C**********         EVAL      *INLR = *ON                                             AR1019833
 
     C                   RETURN
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
 
      ** Validity Flag (Output)
     C                   PARM                    Valid
 
      ** Check Digit (Output)
     C                   PARM                    CheckDigit
     C                   PARM                    @data
 
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
 
     C**********         EVAL      Valid = *BLANKS                                         AR1019833
     C**********         EVAL      CheckDigit = *BLANKS                                    AR1019833
                                                                                           AR1019833
      ** Retrieve System Value 'LoanAlphaAllow' & 'LoanAlphaChecksum'                      AR1019833
                                                                                           AR1019833
     C                   Eval      PRetCode = *BLANKS                                      AR1019833
     C                   Eval      PSysValK1 = 'LoanAlphaAllow'                            AR1019833
     C                   Eval      PSysVal1 = *BLANKS                                      AR1019833
     C                   Eval      PSysValK2 = 'LoanAlphaChecksum'                         AR1019833
     C                   Eval      PSysVal2 = *BLANKS                                      AR1019833
                                                                                           AR1019833
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                AR1019833
                                                                                           AR1019833
      ** If Error retrieving the System values                                             AR1019833
                                                                                           AR1019833
     C                   If        %Error Or PRetCode <> *BLANKS                           AR1019833
     C                             Or (*INU7 = *ON And *INU8 = *ON)                        AR1019833
     C     *LOCK         In        LDA                                                     AR1019833
     C                   Eval      DBFILE = 'AOSVALR0'                                     AR1019833
     C                   Eval      DBASE = 1                                               AR1019833
     C                   Eval      DBKEY = 'LoanAlpha(Allow/Chksum)'                       AR1019833
     C                   Eval      DBPGM = PsProcPgm                                       AR1019833
     C                   Out       LDA                                                     AR1019833
     C                   ExSr      *PSSR                                                   AR1019833
     C                   EndIf                                                             AR1019833
                                                                                           AR1019833
     C                   Eval      WLonAlphaAllow = PSysVal1                               AR1019833
     C                   Eval      WLonAlphaChksum = PSysVal2                              AR1019833
                                                                                           AR1019833
     C                   If        WLonAlphaAllow = 'N'                                    AR1019833
     C     *LOCK         In        LDA                                                     AR1019833
     C                   Eval      DBFILE = 'AOSVALR0'                                     AR1019833
     C                   Eval      DBASE = 2                                               AR1019833
     C                   Eval      DBKEY = 'LoanAlphaAllow'                                AR1019833
     C                   Eval      DBPGM = PsProcPgm                                       AR1019833
     C                   Out       LDA                                                     AR1019833
     C                   ExSr      *PSSR                                                   AR1019833
     C                   EndIf                                                             AR1019833
                                                                                           AR1019833
      ** If 6th char is not a CheckDigit, only then check 6th char for                     AR1019833
      ** LoanAlphaAllow* in AOSVALR0                                                       AR1019833
                                                                                           AR1019833
     C                   If        WLonAlphaChksum = 'N'                                   AR1019833
     C                   Eval      PSysValK6 = WSysValPfx + '6'                            AR1019833
     C                   Eval      PSysVal6 = *BLANKS                                      AR1019833
     C                   EndIf                                                             AR1019833
                                                                                           AR1019833
      ** Check if characters are valid (LoanAlphaAllow* in AOSVALR0)                       AR1019833
                                                                                           AR1019833
     C                   Eval      PRetCode = *BLANKS                                      AR1019833
     C                   Eval      PSysValK1 = WSysValPfx + '1'                            AR1019833
     C                   Eval      PSysVal1 = *BLANKS                                      AR1019833
     C                   Eval      PSysValK2 = WSysValPfx + '2'                            AR1019833
     C                   Eval      PSysVal2 = *BLANKS                                      AR1019833
     C                   Eval      PSysValK3 = WSysValPfx + '3'                            AR1019833
     C                   Eval      PSysVal3 = *BLANKS                                      AR1019833
     C                   Eval      PSysValK4 = WSysValPfx + '4'                            AR1019833
     C                   Eval      PSysVal4 = *BLANKS                                      AR1019833
     C                   Eval      PSysValK5 = WSysValPfx + '5'                            AR1019833
     C                   Eval      PSysVal5 = *BLANKS                                      AR1019833
                                                                                           AR1019833
     C                   CALL (E)  'AOSVALR0'    P_AOSVALR0                                AR1019833
                                                                                           AR1019833
      ** If Error retrieving the System values                                             AR1019833
                                                                                           AR1019833
     C                   If        %Error Or PRetCode <> *BLANKS                           AR1019833
     C                             Or (*INU7 = *ON And *INU8 = *ON)                        AR1019833
     C     *LOCK         In        LDA                                                     AR1019833
     C                   Eval      DBFILE = 'AOSVALR0'                                     AR1019833
     C                   Eval      DBASE = 3                                               AR1019833
     C                   Eval      DBKEY = 'LoanAlphaAllow*'                               AR1019833
     C                   Eval      DBPGM = PsProcPgm                                       AR1019833
     C                   Out       LDA                                                     AR1019833
     C                   ExSr      *PSSR                                                   AR1019833
     C                   EndIf                                                             AR1019833
                                                                                           AR1019833
     C                   MoveA     PSysVal1      VLD1                                      AR1019833
     C                   MoveA     PSysVal2      VLD2                                      AR1019833
     C                   MoveA     PSysVal3      VLD3                                      AR1019833
     C                   MoveA     PSysVal4      VLD4                                      AR1019833
     C                   MoveA     PSysVal5      VLD5                                      AR1019833
     C                   MoveA     PSysVal6      VLD6                                      AR1019833
 
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
 
     C                   For       WI3 = 1 TO 6
     C                   EVAL      W#X = %LOOKUP(LoanArr(WI3):VLD)
     C                   EVAL      WAC2(WI3) = W#X - 1
     C                   ENDFOR
 
      ** Calculate modulus of first five digits
 
     C                   EVAL      WPJ = WM
 
      ** Loop through first five characters of Loan Reference
 
     C                   FOR       WJ = 1 TO 5
 
      ** #WK2 is  Pj mod(M1)
 
     C     WPJ           DIV       WM1           #WK1
     C                   MVR                     #WK2
 
      ** Sj=Pj mod(M1)+value(character j of Loan Reference)
 
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
 
     C                   IF        @RUN = *BLANKS
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      * Compile-Time Array Data
** VLD
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
