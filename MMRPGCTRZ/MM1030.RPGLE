     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM: MM0089 S/R to calculate interest')           *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1030     - Calculate Interest - Subroutine from MM0089     *
      *                                                               *
      *  Function:  This module receives a number of parameters:      *
      *              - start & end dates, - calculation method        *
      *              - amount, - rate, - round down indicator.        *
      *             From these it calulates the interest which it     *
      *             returns as another parameter.                     *
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
      *  Prev Amend No. MD027087           Date 20May14               *
      *                 MD026986           Date 16May14               *
      *                 CDL093             Date 07Apr14               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 CAP076             Date 03Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191870             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 02Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD027087 - revert back the changes for CDL093                *
      *  MD026986 - remove changes made by CDL093                     *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus                                      *
      *  242286 - Enhance computation of interest for calc basis 6.   *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Add new parameter to ZINTDY (INT6DY)                *
      *  191870 - Calculation basis 6 processing.                     *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** Adjusted number of interest days                                                     191870
     D***INT6DY*       S             15P 7                                             191870 242286
     D INT6DY          S             15P 9                                                    242286
     D**********ZZBEG9          S              5P 0                                  CDL093 MD026986
     D**********ZZEND9          S              5P 0                                  CDL093 MD026986
     D**********ZZStartDate     S              8S 0                                  CDL093 MD026986
     D**********ZZEndDate       S              8S 0                                  CDL093 MD026986
     D**********@@Rtn           S              1A                                    CDL093 MD026986
     D**********#29Feb          S              1A                                    CDL093 MD026986
     D ZZBEG9          S              5P 0                                                  MD027087
     D ZZEND9          S              5P 0                                                  MD027087
     D ZZStartDate     S              8S 0                                                  MD027087
     D ZZEndDate       S              8S 0                                                  MD027087
     D @@Rtn           S              1A                                                    MD027087
     D #29Feb          S              1A                                                    MD027087
                                                                                              191870
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
      *                @@YEAR - (NUMBER OF DAYS IN YEAR) x 100        *
      *                                                               *
      *****************************************************************
 
     C***/COPY WNCPYSRC,MM0089C076
      *
      *   CALCULATE NUMBER OF INTEREST DAYS
      **********
      ***Save*Start and End date for use when calc method is 9                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         Eval      ZZBEG9 = ZZBEG                                    CDL093 MD026986
     C**********         Eval      ZZEND9 = ZZEND                                    CDL093 MD026986
     C                   Eval      ZZBEG9 = ZZBEG                                           MD027087
     C                   Eval      ZZEND9 = ZZEND                                           MD027087
      **********                                                                     CDL093 MD026986
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeIn
     C                   PARM                    ZZINDY
     C                   PARM                    ZZBEG
     C                   PARM                    ZZEND
     C                   PARM                    ZZCALC
     C                   PARM                    INT6DY                                       191870
      *
      ***********                                                                    CDL093 MD026986
      ** ZZCALC = 9 (MM Interest method Actual/Actual - AFB)                         CDL093 MD026986
      ***********                                                                    CDL093 MD026986
     C***********        If        ZZCALC= '9'                                       CDL093 MD026986
      ***********                                                                    CDL093 MD026986
     C***********        CALLB     'ZDATE9'                                          CDL093 MD026986
     C***********        PARM                    ZZBEG9                              CDL093 MD026986
     C***********        Parm                    ZZStartDate                         CDL093 MD026986
     C***********        Parm                    @@Rtn                               CDL093 MD026986
      **********                                                                     CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         CALLB     'ZDATE9'                                          CDL093 MD026986
     C**********         PARM                    ZZEND9                              CDL093 MD026986
     C**********         Parm                    ZZEndDate                           CDL093 MD026986
     C**********         Parm                    @@Rtn                               CDL093 MD026986
      **********                                                                     CDL093 MD026986
      ***Check*if the period contains a Feb 29                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         CallB     'ZFEB29CHK'                                       CDL093 MD026986
     C**********         Parm                    ZZStartDate                         CDL093 MD026986
     C**********         Parm                    ZZEndDate                           CDL093 MD026986
     C**********         Parm                    #29Feb                              CDL093 MD026986
     C**********         If        #29Feb = 'Y'                                      CDL093 MD026986
     C**********         Eval      @@YEAR = 36600                                    CDL093 MD026986
     C**********         Else                                                        CDL093 MD026986
     C**********         Eval      @@YEAR = 36500                                    CDL093 MD026986
     C**********         Endif                                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         ENDIF                                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
      ** ZZCALC = 9 (MM Interest method Actual/Actual - AFB)                                MD027087
      *                                                                                     MD027087
     C                   If        ZZCALC= '9'                                              MD027087
      *                                                                                     MD027087
     C                   CALLB     'ZDATE9'                                                 MD027087
     C                   PARM                    ZZBEG9                                     MD027087
     C                   Parm                    ZZStartDate                                MD027087
     C                   Parm                    @@Rtn                                      MD027087
      *                                                                                     MD027087
      *                                                                                     MD027087
     C                   CALLB     'ZDATE9'                                                 MD027087
     C                   PARM                    ZZEND9                                     MD027087
     C                   Parm                    ZZEndDate                                  MD027087
     C                   Parm                    @@Rtn                                      MD027087
      *                                                                                     MD027087
      *  Check if the period contains a Feb 29                                              MD027087
      *                                                                                     MD027087
     C                   CallB     'ZFEB29CHK'                                              MD027087
     C                   Parm                    ZZStartDate                                MD027087
     C                   Parm                    ZZEndDate                                  MD027087
     C                   Parm                    #29Feb                                     MD027087
     C                   If        #29Feb = 'Y'                                             MD027087
     C                   Eval      @@YEAR = 36600                                           MD027087
     C                   Else                                                               MD027087
     C                   Eval      @@YEAR = 36500                                           MD027087
     C                   Endif                                                              MD027087
      *                                                                                     MD027087
     C                   ENDIF                                                              MD027087
      *                                                                                     MD027087
     C     ZZCALC        IFEQ      '2'
     C     ZZCALC        OREQ      '3'
     C     ZZCALC        OREQ      '5'
     C     ZZCALC        OREQ      '0'                                                       CER016A
     C                   Z-ADD     36000         @@YEAR            5 0
     C                   END
      *
     C     ZZCALC        IFEQ      '1'
     C     ZZCALC        OREQ      '4'
     C                   Z-ADD     36500         @@YEAR
     C                   END
      *
     C     ZZCALC        IFEQ      '6'
     C                   Z-ADD     36600         @@YEAR
     C                   END
      *                                                                                       191870
     C     ZZCALC        IFEQ      '6'                                                        191870
     C*****ZZCALC*****   OREQ      '9'                                               CDL093 MD026986
     C*****#29Feb*****   ANDEQ     'Y'                                               CDL093 MD026986
     C     ZZCALC        OREQ      '9'                                                      MD027087
     C     #29Feb        ANDEQ     'Y'                                                      MD027087
     C     INT6DY        MULT      @@RATE        @@W157                                       191870
     C                   ELSE                                                                 191870
      *
     C*****ZZINDY        MULT      @@RATE        @@W157           15 7                        242286
     C     ZZINDY        MULT      @@RATE        @@W157           15 9                        242286
     C                   END                                                                  191870
     C     @@W157        MULT(H)   @@AMT         @@W210           21 0
      *
     C**  ROUND DOWN IF ROUND DOWN INDICATOR IS 'Y'
      *
     C     @@RDFC        IFEQ      'Y'
     C     @@W210        DIV       @@YEAR        @@INTR
     C                   ELSE
     C     @@W210        DIV(H)    @@YEAR        @@INTR           15 0
     C                   END
     C***/COPY WNCPYSRC,MM0089C077
     C*
 
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
(c) Finastra International Limited 2001
