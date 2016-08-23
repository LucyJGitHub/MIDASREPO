     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA ACNO Modulus 11 Check')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZAMOD11VAL - ZA ACNO Modulus 11 Check                        *
      *                                                               *
      *  Function:  This module validates a 10-digit field as passing *
      *             modulus 11 checking.                              *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CGL062  *Create    Date 20Jul06               *
      *  Prev Amend No.                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL062 - Modulus 11 Check on Retail Account Number           *
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
 
      ** Sum of Weightings Array
     D SUM             S              3S 0 DIM(10)
 
      ** Check Digit Array
     D CHECKD          S              1S 0 DIM(11) CTDATA PERRCD(11)
 
      **  DS for check digit processing on retail a/c number
     DDSACNO           DS
     D SRTNO1                  1      1  0
     D SRTNO2                  2      2  0
     D SRTNO3                  3      3  0
     D SRTNO4                  4      4  0
     D SRTNO5                  5      5  0
     D SRTNO6                  6      6  0
     D SRTNO7                  7      7  0
     D SRTNO8                  8      8  0
     D SRTNO9                  9      9  0
     D SRTNO10                10     10  0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** MIDAS Retail Account Number
     D @ACNO           S             10A
 
      ** MIDAS Retail Account Number OK flag
     D @AcNoOK         S              1A
 
      ** End of parameters
      ** =================
 
      ** Total of the weighted values
     D TOTAL           S              3S 0
 
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
 
      ** Initialise fields
 
     C                   Eval      @AcNoOK = 'N'
     C                   Eval      TOTAL   = *Zero
     C                   Eval      SUM     = *Zero
     C                   Eval      DSACNO  = @AcNo
 
      *****************************************************************
      *    Check digit validation for Czech clearing system
      *
      *      Apply weighting  (ignoring digit 7)
      *          digit        1  2  3  4  5  6  7  8  9  10
      *          weighting    6  3  7  9 10  5  -  4  2  1
      *
      *****************************************************************
 
     C                   Eval      SUM(1)  = SRTNO1  * 6
     C                   Eval      SUM(2)  = SRTNO2  * 3
     C                   Eval      SUM(3)  = SRTNO3  * 7
     C                   Eval      SUM(4)  = SRTNO4  * 9
     C                   Eval      SUM(5)  = SRTNO5  * 10
     C                   Eval      SUM(6)  = SRTNO6  * 5
     C                   Eval      SUM(8)  = SRTNO8  * 4
     C                   Eval      SUM(9)  = SRTNO9  * 2
     C                   Eval      SUM(10) = SRTNO10 * 1
 
      **  Sum the resulting products
 
     C                   Xfoot     SUM           TOTAL
 
      **  Divide the total by 11
 
     C     TOTAL         Div       11            TOTAL
     C                   Mvr                     REM               2 0
 
      **  If the remainder is 0 set to 11 for check against table
 
     C                   If        REM = *Zero
     C                   Eval      REM = 11
     C                   EndIf
 
      *****************************************************************
      *
      *      Use remainder to lookup for check digit (position 7 of
      *      account number)
      *          remainder      1  2  3  4  5  6  7  8  9 10  0
      *          check digit    4  8  1  5  9  2  6  x  3  7  0
      *      NB. a remainder of 8 is invalid
      *
      *****************************************************************
 
     C                   If        (REM = 8 or SRTNO7 <> CHECKD(REM))
     C                   Eval      @AcNoOK = 'N'
     C                   Else
     C                   Eval      @AcNoOK = 'Y'
     C                   EndIf
 
     C                   Return
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
 
     C     *entry        PLIST
      ** Return code (10A)
     C                   PARM                    ReturnCode
      ** MIDAS Retail Account Number (10A)
     C                   PARM                    @ACNO
      ** MIDAS Retail Account Number OK Flag (1A)
     C                   PARM                    @AcNoOK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
**   CHECKD - CHECK DIGIT
48159260370
