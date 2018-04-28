     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Calculate interest double precision')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1024 - Calculate interest double precision                 *
      *                                                               *
      *  Function:  This module uses a form of double-precision       *
      *             arithmetic to calculate an interest amount.       *
      *             It is a converted version of the subroutine       *
      *             MM1024, which was hard coded in MM0026 and MM0027 *
      *             (at least)                                        *
      *                                                               *
      *  Component of:                                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD026986           Date 16May14               *
      *  Prev Amend No. CDL093             Date 07Apr14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP076             Date 03Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 191870             Date 28Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 140931             Date 17Aug98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026986 - remove changes made by CDL093                     *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Add new parameter to ZINTDY (INT6DY)                *
      *  191870 - Calculation Basis 6 error.                          *
      *  140931 - Purch/sale price not correct if multi-period deal.  *
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
 
     D**********ZZBEG9          S              5P 0                                  CDL093 MD026986
     D**********ZZEND9          S              5P 0                                  CDL093 MD026986
     D**********ZZStartDate     S              8S 0                                  CDL093 MD026986
     D**********ZZEndDate       S              8S 0                                  CDL093 MD026986
     D**********@@Rtn           S              1A                                    CDL093 MD026986
     D**********#29Feb          S              1A                                    CDL093 MD026986
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
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Adjusted number of interest days                                                     191870
     D INT6DY          S             15P 7                                                    191870
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
 
     C*****************************************************************
     C*   MM1024 - CALCULATE INTEREST DOUBLE PRECISION                *
     C*                                                               *
     C*  CALLED BY    -                                               *
     C*                                                               *
     C*  CALLS        -   ZINTDY CALCULATE NO. OF INTEREST DAYS       *   056095
     C*                                                               *
     C*  FIELDS INPUT ZZBEG  - START DATE OF PERIOD                   *   056095
     C*               ZZEND  - END DATE OF PERIOD                     *   056095
     C*               ZZCALC - INTEREST CALCULATION METHOD            *   056095
     C*               @@AMT  - PRINCIPAL AMOUNT  15N                  *
     C*               @@RATE - INTEREST RATE 11,7                     *
     C*                                                               *
     C*  FIELDS OUTPUT @@W154 - INTEREST 15,4                         *
     C*                                                               *
     C*  WORK FIELDS   @@W155 - 15,5
     C*                                                               *
     C*****************************************************************
     C*
     C*   CALCULATE NUMBER OF INTEREST DAYS
     ***********                                                                     CDL093 MD026986
      ***Save*Start and End date for use when calc method is 9                       CDL093 MD026986
     ***********                                                                     CDL093 MD026986
     C**********         Eval      ZZBEG9 = ZZBEG                                    CDL093 MD026986
     C**********         Eval      ZZEND9 = ZZEND                                    CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C                   CALLB     'ZINTDY'                                                    05609
      ** Outgoing return code (10A, returned to caller)
     C                   PARM                    RetCodeOut
      ** Number of interest days (5,0P, returned to caller)
     C                   PARM                    ZZINDY
      ** Beginning date (5,0P, from caller)
     C                   PARM                    ZZBEG
      ** Ending date (5,0P, from caller)
     C                   PARM                    ZZEND
      ** Calculation method (1A, from caller)
     C                   PARM                    ZZCALC
     C                   PARM                    INT6DY                                       191870
     C*
      **********                                                                     CDL093 MD026986
      ***ZZCALC*= 9 (MM Interest method Actual/Actual - AFB)                         CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         If        ZZCALC= '9'                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         CALLB     'ZDATE9'                                          CDL093 MD026986
     C**********         PARM                    ZZBEG9                              CDL093 MD026986
     C**********         Parm                    ZZStartDate                         CDL093 MD026986
     C**********         Parm                    @@Rtn                               CDL093 MD026986
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
     C**********         Eval      @@W155 = 36600                                    CDL093 MD026986
     C**********         Else                                                        CDL093 MD026986
     C**********         Eval      @@W155 = 36500                                    CDL093 MD026986
     C**********         Endif                                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C**********         ENDIF                                                       CDL093 MD026986
      **********                                                                     CDL093 MD026986
     C     ZZCALC        IFEQ      '2'                                          *** B 1        05609
     C     ZZCALC        OREQ      '3'                                                         05609
     C     ZZCALC        OREQ      '5'                                                         05609
     C     @@AMT         DIV       36000         @@W155           15 5
     C                   END                                                    *** E 1
     C*
     C     ZZCALC        IFEQ      '1'                                          *** B 1        05609
     C     ZZCALC        OREQ      '4'                                                         05609
     C     @@AMT         DIV       36500         @@W155
     C                   END                                                     *** E 1
     C*
     C     ZZCALC        IFEQ      '6'                                           *** B 1       05609
     C     @@AMT         DIV       36600         @@W155
     C                   END                                                     *** E 1
     C*
     C                   MULT      @@RATE        @@W155
      *                                                                                       191870
     C     ZZCALC        IFEQ      '6'                                                        191870
     C*****ZZCALC*****   OREQ      '9'                                               CDL093 MD026986
     C*****#29Feb*****   ANDEQ     'Y'                                               CDL093 MD026986
     C     @@W155        MULT(H)   INT6DY        @@W154                                       191870
     C                   ELSE                                                                 191870
     C     @@W155        MULT(H)   ZZINDY        @@W154           15 4                         05609
     C                   END                                                                  191870
     C*
     C                   GOTO      M10249
     C                   Z-ADD     0             @@AMT            15 0
     C                   Z-ADD     0             @@RATE
     C*
     C     M10249        TAG                                                    *** M10249 ***
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
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
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ** Number of interest days (5,0P, returned to caller)
     C                   PARM                    ZZINDY            5 0
      ** Interest to 2 extra d.p.s                                              140931
     C                   PARM                    @@W154           15 4          140931
      ** Beginning date (5,0P, from caller)
     C                   PARM                    ZZBEG             5 0
      ** Ending date (5,0P, from caller)
     C                   PARM                    ZZEND             5 0
      ** Calculation method (1A, from caller)
     C                   PARM                    ZZCALC            1
      ** Intereset rate
     C                   PARM                    @@RATE           11 7
      ** Amount
     C                   PARM                    @@AMT
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
