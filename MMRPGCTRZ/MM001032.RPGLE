     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM: S/R to calculate interest int calc 9')       *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM001032   - Calculate Interest - Interest Calc Method 9     *
      *                                                               *
      *  Function:  This module receives a number of parameters:      *
      *              - start & end dates, - calculation method        *
      *              - amount, - rate, - round down indicator.        *
      *             From these it calulates the interest which it     *
      *             returns as another parameter.                     *
      *             This is the same as MM1030 however it only        *
      *             divides by 365 or 366 rather than 36500 and       *
      *             36600. The division by 100 is performed after     *
      *             multiple calls to this program                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL093  *CREATE    Date 07Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL093 - MM Interest calculation type 9.                     *
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
 
      ** Map variable names to indicators to allow use of names instead
      ** of numbers; base the following data structure on a pointer to
      ** the indicator array.
     D Indicators      DS                  BASED(pIndicator)
 
      ** Set the indicator array pointer
     D pIndicator      S               *   INZ(%Addr(*In))
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Start date of period received as a parameter
     D ZZBEG           S              5P 0
      ** End date of period received as a parameter
     D ZZEND           S              5P 0
      ** Interest Calculation Method received as a parameter
     D ZZCALC          S              1A
      ** Principal amount received as a parameter
     D @@AMT           S             15P 0
      ** Interest Rate received as a parameter
     D @@RATE          S             11P 7
      ** Round Down Facility Indicator received as a parameter
     D @@RDFC          S              1A
      ** Calculated Interest output as a parameter
     D @@INTR          S             15P 0
 
      ** Adjusted number of interest days
     D ZZINDY          S              5P 0
 
      ** Adjusted number of interest days
     D INT6DY          S             15P 9
     D ZZBEG9          S              5P 0
     D ZZEND9          S              5P 0
     D ZZStartDate     S              8S 0
     D ZZEndDate       S              8S 0
     D @@Rtn           S              1A
     D #29Feb          S              1A
     D @@YEAR          S              5  0
 
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
 
      *   MM1030 - CALCULATE INTEREST                                 *
      *                                                               *
      *  CALLS        -   ZINTDY CALCULATE NO. OF INTEREST DAYS       *
      *                                                               *
      *  FIELDS INPUT ZZBEG  - START DATE OF PERIOD                   *
      *               ZZEND  - END DATE OF PERIOD                     *
      *               ZZCALC - INTEREST CALCULATION METHOD            *
      *               @@AMT  - PRINCIPAL AMOUNT  15N                  *
      *               @@RATE - INTEREST RATE 11,7                     *
      *               @@RDFC - ROUND DOWN FACILITY IND 1              *
      *                                                               *
      *  FIELDS OUTPUT @@INTR - INTEREST 15,0                         *
      *                                                               *
      *  WORK FIELDS   @@W157 - 15,5                                  *
      *                @@W210 - 21,0                                  *
      *                @@YEAR - (NUMBER OF DAYS IN YEAR)              *
      *                                                               *
      *****************************************************************
 
      *
      *   CALCULATE NUMBER OF INTEREST DAYS
      *
      ** Save Start and End date for use when calc method is 9
      *
     C                   Eval      ZZBEG9 = ZZBEG
     C                   Eval      ZZEND9 = ZZEND
      *
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeIn
     C                   PARM                    ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
     C                   PARM                    INT6DY
      *
      *
      ** ZZCALC = 9 (MM Interest method Actual/Actual - AFB)
      *
     C                   If        ZZCALC= '9'
      *
     C                   CALLB     'ZDATE9'
     C                   PARM                    ZZBEG9
     C                   Parm                    ZZStartDate
     C                   Parm                    @@Rtn
      *
      *
     C                   CALLB     'ZDATE9'
     C                   PARM                    ZZEND9
     C                   Parm                    ZZEndDate
     C                   Parm                    @@Rtn
 
      ** Check if the period contains a Feb 29
 
     C                   CallB     'ZFEB29CHK'
     C                   Parm                    ZZStartDate
     C                   Parm                    ZZEndDate
     C                   Parm                    #29Feb
     C                   If        #29Feb = 'Y'
     C                   Eval      @@YEAR = 366
     C                   Else
     C                   Eval      @@YEAR = 365
     C                   Endif
      *
     C                   ENDIF
      *
     C     ZZCALC        IFEQ      '9'
     C     #29Feb        ANDEQ     'Y'
     C     INT6DY        MULT      @@RATE        @@W157
     C                   ELSE
      *
     C     ZZINDY        MULT      @@RATE        @@W157           15 9
     C                   END
     C     @@W157        MULT(H)   @@AMT         @@W210           21 0
      *
     C**  ROUND DOWN IF ROUND DOWN INDICATOR IS 'Y'
      *
     C     @@RDFC        IFEQ      'Y'
     C     @@W210        DIV       @@YEAR        @@INTR
     C                   ELSE
     C     @@W210        DIV(H)    @@YEAR        @@INTR           15 0
     C                   END
 
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
      *         Input field ZZBEG - Start date of period
     C                   PARM                    ZZBEG
      *         Input field ZZEND - End date of period
     C                   PARM                    ZZEND
      *         Input field ZZCALC - Interest Calculation Method
     C                   PARM                    ZZCALC
      *         Input field @@AMT - Principal amount
     C                   PARM                    @@AMT
      *         Input field @@RATE - Interest Rate
     C                   PARM                    @@RATE
      *         Input field @@RDFC - Round Down Facility Indicator
     C                   PARM                    @@RDFC
      *         Output field @@INTR - Calculated Interest
     C                   PARM                    @@INTR
 
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
(c) Finastra International Limited 2014
