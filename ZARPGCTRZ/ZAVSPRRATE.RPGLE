     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate spread/rate')
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZAVSPRRATE - Validate spread/rate                            *
      *                                                               *
      *  Function:  This module validates a spread/rate field         *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 208051             Date 22Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  208051 - Allow entry of a -ve interest amount. Use new       *
      *           program ZA0841.                                     *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** MM Interest rates
     FFDINTRLL  IF   E           K DISK    INFSR(*pssr)
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** ZDATE1 routine name
     D ZDATE1          C                   CONST('ZDATE1')
 
      ** ZA0840 routine name
     D ZA0840          C                   CONST('ZA0840')
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Warning message ID
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Standard deals file version of spread/rate field
     D IKINTR          S             11P 7
 
      ** Spread/rate
     D DDSPRT          S             12A
 
      ** Deal type
     D DDTYPE          S              2A
 
      ** Base rate code
     D DDBSRC          S              2A
 
      ** Base rate OK flag
     D BaseRateOK      S              1A
 
      ** Deal date (Midas day number)
     D @DDA1           S              5P 0
 
      ** Value date (Midas day number)
     D @VDA1           S                   LIKE(@DDA1)
 
      ** Maturity date (Midas day number)
     D @MDA1           S                   LIKE(@DDA1)
 
      ** Base rate
     D @RATE           S             11P 7
 
      ** Loan/deposits interest rate tolerance
     D BNLDIT          S              3P 1
 
      ** Deal currency
     D DDCCY           S              3A
 
      ** Decimal separator
     D BNDCSP          S              1A
 
 
      ** End of parameters
      ** =================
 
      ** Parameter list for ZA0840
      ** =========================
      ** Return code for numeric validation module call
     D @Rtcde          S             10A
      ** Alpha field for numeric validation
     D @@ALPH          S             16A
      ** Number of decimal places field for numeric validation
     D @@IDP           S              2  0
      ** Number of integers field for numeric validation
     D @@IINT          S              2  0
      ** Millions/Thousands id (Y=function on)
     D @@MTID          S              1A
      ** Amount calculation field
     D @@AMT           S             15  0
      ** Error return code for ZA0840 module
     D @@ERCD          S              1  0
 
      ** Numeric version of spread/rate
     D @SPRD           S             11P 7
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C*
     C**  If the spread/rate is blank, this is an error.
     C**  Unless base rate code is entered
     C*
     C     DDSPRT        IFEQ      *BLANKS
     C     DDBSRC        ANDEQ     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0419'     MsgID1
     C*
     C**  Check it is a valid figure with 7 decimal places max.
     C*
     C                   ELSE
     C                   Z-ADD     7             @@IDP
     C                   Z-ADD     4             @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDSPRT        @@ALPH
     C                   MOVE      'N'           @@MTID
 
      * Only for Call Deposit/Loans allow entry of -ve interest amounts.                      208051
     C**********         CALLB     'ZA0840'                                                   208051
     C                   CALLB     'ZA0841'                                                   208051
     C                   PARM                    @Rtcde
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM                    @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
 
     C     @@ERCD        IFNE      0
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0422'     MsgID1
     C*
     C                   ELSE
     C                   MOVE      @@AMT         @SPRD
     C                   MOVE      @@ALPH        DDSPRT
     C                   END
     C                   END
     C*
     C**  If the spread/rate is valid, determine the effective rate and
     C**  place it in the Standard Deal format.
     C                   IF        ErrorFound = 'N' AND BaseRateOK <> 'N'
     C     DDBSRC        IFNE      *BLANKS
     C     @SPRD         ADD       @RATE         IKINTR
     C                   ELSE
     C                   Z-ADD     @SPRD         IKINTR
     C                   END
      *
      ** If the 'loan/deposits interest rate tolerance' field,
      ** PF/SDDEALPD, is not equal to 0
      *
     C     BNLDIT        IFNE      0
      *
      ** Calculate deal time span, and set up key to access interest
      ** rates file, LF/FDINTRLL
      *
     C     UTEST2        KLIST
     C                   KFLD                    DDCCY
     C                   KFLD                    UTPRD2            1
     C                   KFLD                    UPRD2             2 0
      *
     C                   EXSR      #TSPN
      *
      ** Access LF/FDINTRLL
      *
     C     UTEST2        CHAIN     FDINTRLL                           65
      *
      ** If record found on file
      *
     C     *IN65         IFEQ      '0'
      *
     C     DDTYPE        IFEQ      'IT'
     C     DDTYPE        OREQ      'TD'
     C     DDTYPE        OREQ      'CI'
     C     DDTYPE        OREQ      'CD'
     C     DDTYPE        OREQ      'DT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
      ***If*deal*type*is*'IT',*'TD',*'CI',*or*'CD',*use*borrow*rate****         CDL006
      ** If deal type is IT, TD, CI, CD, DT, LT, or FT, use borrow rate         CDL006
      ** to calculate interest rate range limits,
      *
     C                   Z-ADD     HWBRRT        URANGE           11 7
     C                   END
     C*
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
      *
      ***If*deal*type*is*'IP',*'TI',*'DL',*or*'CL',*use*lend***rate****         CDL006
      ** If deal type is IP, TI, DL, CL, FL, DP, or LP, use lend rate           CDL006
      ** to calculate interest rate range limits,
      *
     C                   Z-ADD     HWLDRT        URANGE
     C                   END
      *
      ** Multiply range workfield by 'Loans Deposit  Interest rates
      ** Tolerance' field, and divide by 100 to give limit percentage
      *
     C     URANGE        MULT(H)   BNLDIT        UTEMPL           15 9
     C     UTEMPL        DIV(H)    100           UPRCNT           11 7
      *
      ** Add percentage to range workfield to calculate upper limit
      ** Subtract percentage to range workfield to calculate lower
      ** limit
      *
     C     URANGE        ADD       UPRCNT        UUPLMT           11 7
     C     URANGE        SUB       UPRCNT        ULOLMT           11 7
     C*
     C                   ELSE
      *
      ** If record not found on LF/FDINTRLL, set uppper and lower
      ** limits to 0
      *
     C                   Z-ADD     0             UUPLMT
     C                   Z-ADD     0             ULOLMT
     C                   END
      *
      ** If the effective interest rate is above the upper limit
      ** or below the lower limit, output warning message
      *
     C     IKINTR        IFLT      ULOLMT
     C     IKINTR        ORGT      UUPLMT
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM2549'     WMsgId1
     C                   END
     C                   END
     C                   END
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *     #TSPN  -  Determine time span of deal                    *
      *                                                              *
      *                                                              *
      *               Note that this version of the subroutine is    *
      *               modified from the version that exists in       *
      *               MM0089 where it was copied from.               *
      *               The original version took the screen date      *
      *               date fields and converted them into Midas day  *
      *               number format.  This module receives the dates *
      *               dates in Midas day number format as parameters *
      *               so those versions are used in this subroutine. *
      ****************************************************************
     C     #TSPN         BEGSR
      *
      ** Calculate day after deal date and day after value date
      *
     C     @VDA1         ADD       1             @VDAP             5 0
     C     @DDA1         ADD       1             @DDAP             5 0
      *
      ** Calculate the difference between the maturity and value date
      *
     C     @MDA1         SUB       @VDA1         @DIFF             6 0
      *
      ** If the maturity date is less than 10 days after value date
      *
     C     @DIFF         IFLE      10
     C                   MOVE      'W'           UTPRD2
     C                   Z-ADD     1             UPRD2
     C                   END
      *
      ** If the maturity date equals 0, or is the day after value
      ** date, and the value date equals deal date
      *
     C     @MDA1         IFEQ      0
     C     @MDA1         OREQ      @VDAP
     C     @VDA1         ANDEQ     @DDA1
     C                   MOVE      'D'           UTPRD2
     C                   Z-ADD     1             UPRD2
     C                   END
      *
      ** If the maturity date is the day after value date and the
      ** value date is the day after deal date
      *
     C     @MDA1         IFEQ      @VDAP
     C     @VDA1         ANDEQ     @DDAP
     C                   MOVE      'D'           UTPRD2
     C                   Z-ADD     2             UPRD2
     C                   END
      *
      ** If the maturity date is the day after value date and the
      ** value date is more than one day  after the deal date
      *
     C     @MDA1         IFEQ      @VDAP
     C     @VDA1         ANDGT     @DDAP
     C                   MOVE      'D'           UTPRD2
     C                   Z-ADD     3             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 10 days after value date
      *
     C     @DIFF         IFGT      10
     C                   MOVE      'W'           UTPRD2
     C                   Z-ADD     2             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 17 days after value date
      *
     C     @DIFF         IFGT      17
     C                   MOVE      'W'           UTPRD2
     C                   Z-ADD     3             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 25 days after value date
      *
     C     @DIFF         IFGT      25
     C                   MOVE      'M'           UTPRD2
     C                   Z-ADD     1             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 46 days after value date
      *
     C     @DIFF         IFGT      46
     C                   MOVE      'M'           UTPRD2
     C                   Z-ADD     2             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 77 days after value date
      *
     C     @DIFF         IFGT      77
     C                   MOVE      'M'           UTPRD2
     C                   Z-ADD     3             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 165 days after value date
      *
     C     @DIFF         IFGT      165
     C                   MOVE      'M'           UTPRD2
     C                   Z-ADD     6             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 255 days after value date
      *
     C     @DIFF         IFGT      255
     C                   MOVE      'M'           UTPRD2
     C                   Z-ADD     9             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 317 days after value date
      *
     C     @DIFF         IFGT      317
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     1             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 548 days after value date
      *
     C     @DIFF         IFGT      548
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     2             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 913 days after value date
      *
     C     @DIFF         IFGT      913
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     3             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 1278 days after value date
      *
     C     @DIFF         IFGT      1278
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     4             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 1643 days after value date
      *
     C     @DIFF         IFGT      1643
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     5             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 2008 days after value date
      *
     C     @DIFF         IFGT      2008
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     6             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 2373 days after value date
      *
     C     @DIFF         IFGT      2373
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     7             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 2738 days after value date
      *
     C     @DIFF         IFGT      2738
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     8             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 3103 days after value date
      *
     C     @DIFF         IFGT      3103
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     9             UPRD2
     C                   END
      *
      ** If the maturity date is greater than 3468 days after value date
      *
     C     @DIFF         IFGT      3468
     C                   MOVE      'Y'           UTPRD2
     C                   Z-ADD     10            UPRD2
     C                   END
     C                   ENDSR
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
      ** Incoming return code (10A)
     C                   PARM                    ReturnCode
      ** Message ID (10A)
     C                   PARM                    MsgID1
      ** Warning message ID (10A)
     C                   PARM                    WMsgID1
      ** Standard deals file version of derived rate (11,7P, from/to caller)
     C                   PARM                    IKINTR
      ** Standard deals file version of spread/rate (11,7P, from/to caller)
     C                   PARM                    @SPRD
      ** Spread/rate (12A, from transaction)
     C                   PARM                    DDSPRT
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Base rate code (2A, from transaction)
     C                   PARM                    DDBSRC
      ** Base rate OK flag (1A, from caller)
     C                   PARM                    BaseRateOK
      ** Deal date in Midas day number format (5,0P, from caller)
     C                   PARM                    @DDA1
      ** Value date in Midas day number format (5,0P, from caller)
     C                   PARM                    @VDA1
      ** Maturity date in Midas day number format (5,0P, from caller)
     C                   PARM                    @MDA1
      ** Base rate (11,7P, from caller)
     C                   PARM                    @RATE
      ** Loan/deposits interest rate tolerance (3,1P, from SDDEALPD)
     C                   PARM                    BNLDIT
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Decimal separator (1A, from SDDEALPD via caller)
     C                   PARM                    BNDCSP
 
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
(c) Finastra International Limited 2001
