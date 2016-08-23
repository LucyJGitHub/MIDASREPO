     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Interest amount')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTINTAMT  - Validate Trade Interest Amount.                *
      *                                                               *
      *  Function - Performs the Validation and Computation for the   *
      *             Interest Amount (Purchased) with the set of input *
      *             parameters received.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11193           Date 02May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAP084             Date 10Jul03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 156689             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 28Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAP084 - Use ZCMPAMTS to compare Nominal                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  156689 - ZASIGN To Recognize '.' or ',' as decimal separator *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Inputs
      *
     D DDACIN          S              1A
     D DDDADJ          S              5A
     D DDACTD          S              1A
     D DDITRA          S             15A
 
     D NOML            S             11P 0
     D TDVD            S              5P 0
     D DADJ            S              3P 0
     D TDCR            S             11P 7
     D ZCPOVR          S              1A
 
     D DADJN           S              1A
     D NomCcyDec       S              1P 0
     D PROT            S              1A
 
     D BJDFIN          S              1A
      *
      ** Output
      ** ------
 
      ** OK indicators
     D ddDADJok        S              1A
     D ddACTDok        S              1A
     D ddITRAok        S              1A
 
      ** Interest Amount
     D ITRA            S             13P 0
      ** Interest Adjustment
     D TINA            S             13P 0
      ** Expected Interest Amount
     D EXPT_ITRA       S             13P 0
      ** Actual Calculated Interest Amount
     D ACTC_ITRA       S             13P 0
 
      ** Working Variables
      ** -----------------
 
     D  ZDADJ          S              3P 0
     D  ZACIN          S              1A
     D  ZADIN          S              1A
     D  ZITRA          S             13P 0
     D  ZFLD15         S             15P 0
     D  ZTINA          S             13P 0
     D  ZDECS          S              1P 0
     D  ZECODE         S              1A
     D  ZOUT21         S             21A
     D  ZFLD17         S             17A
     D  ZSDIG          S              2P 0
     D  ZSDEC          S              1P 0
     D  ZSDCSP         S              1A                                        156689
     D  ZOUT15         S             15A
     D  ZFSIGN         S              1A
     D  ZAsignOK       S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
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
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C                   Z-ADD     *ZERO         ITRA
     C                   Z-ADD     *ZERO         TINA
      *
      ** Calculate Expected Interest
      *
     C                   EXSR      CAL_EXPIN
      *
      ** Calculate Actual Interest
      *
     C                   EXSR      CAL_ACTIN
      *
      ** DEFAULT
      *
     C     Default       IFEQ      'Y'
     C     DDITRA        ANDEQ     *BLANKS
     C                   EXSR      ITRAD
     C                   ENDIF
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      ITRAV
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     ddITRAok      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Interest Adjustment = Input Interest - Expected Interest
      *
     C     ITRA          SUB       EXPT_ITRA     TINA
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * ITRAV - VALIDATION
      *****************************************************************
     C     ITRAV         BEGSR
      *
      ** If the Interest amount is entered manually
      ** the 'Days Adjustment' field must be blank.
      *
     C*****DDITRA        IFNE      EACTC_ITRA                                                 CAP084
     C                   CALLB     'ZCMPAMTS'                                                 CAP084
     C                   PARM      DDITRA        ZCMPAMT1         25                          CAP084
     C                   PARM      EACTC_ITRA    ZCMPAMT2         25                          CAP084
     C                   PARM      'N'           ZCMPAMTDif        1                          CAP084
                                                                                              CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C     DDDADJ        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDDADJ'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0520'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDDadjOk
     C                   MOVE      'N'           DDITRAOk
     C                   GOTO      EITRAV
     C                   ENDIF
      *
      ** If the Interest amount is entered manually
      ** the 'Actual/Difference Indicator' must be blank.
      *
     C*****DDITRA        IFNE      EACTC_ITRA                                                 CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                                        CAP084
     C     DDACTD        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDACTD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0520'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDActdOk
     C                   MOVE      'N'           DDITRAOk
     C                   GOTO      EITRAV
     C                   ENDIF
 
      ** Validate the Interest Amount
      ** ----------------------------
 
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDITRA        ZFLD17
     C     13            SUB       NomCcyDec     ZSDIG
     C                   Z-ADD     NomCcyDec     ZSDEC
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP                         156689
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
      *
      ** Error
      *
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDITRA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0519'     MsgidXAr(Idx)
     C                   MOVE      'N'           DDItrAOk
     C                   GOTO      EITRAV
     C                   END
 
      ** Update trade purchased interest
 
     C                   MOVE      ZOUT15        ITRA
      *
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     ITRA          ITRA
     C                   END
      *
      ** If trade has been done flat, or security is schuldschein
      ** purchased interest is zero
      *
     C     DDACIN        IFEQ      'F'
     C     PROT          OREQ      '6'
     C                   Z-ADD     0             ITRA
     C                   END
 
      ** Edit purchased interest for output
 
     C                   MOVE      ITRA          ZFLD15
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANK        ZECODE
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        DDITRA
 
     C     EITRAV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ITRAD - DEFAULTING
      *****************************************************************
     C     ITRAD         BEGSR
      *
      ** If no interest amount was entered
      ** Set it to the trade's actual calculated interest amount (edited)
      *
     C                   MOVE      EACTC_ITRA    DDITRA
     C                   Z-ADD     ACTC_ITRA     ITRA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CAL_EXPIN - Calculate Expected Interest                       *
      *****************************************************************
     C     CAL_EXPIN     BEGSR
      *
      ** Determine the trade's expected interest amount
      ** (only use security days adj if trade days adj defined)
      *
     C                   MOVE      DDACIN        ZACIN
 
     C     DADJ          IFNE      *ZERO
     C                   Z-ADD     IADJ          ZDADJ
     C                   ELSE
     C                   Z-ADD     0             ZDADJ
     C                   END
 
     C                   MOVE      *BLANK        ZADIN
 
     C                   CALLB     'ZPCINT'
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    NOML
     C                   PARM                    ZACIN
     C                   PARM                    ZDADJ
     C                   PARM                    ZADIN
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR
     C                   PARM                    BJDFIN
     C                   PARM      TDVD          ECD               5 0
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
 
     C                   MOVE      ZITRA         EXPT_ITRA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CAL_ACTIN - Calculate Actual Interest                         *
      *****************************************************************
     C     CAL_ACTIN     BEGSR
      *
      ** If trade has been done flat, or the security is schuldschein
      ** the trade's interest will be zero
      *
     C     DDACIN        IFEQ      'F'
     C     PROT          OREQ      '6'
 
     C                   Z-ADD     *ZERO         ACTC_ITRA
 
     C                   ELSE
      *
      ** Determine the trade's actual calculated interest amount
      *
     C                   Z-ADD     DADJ          ZDADJ
     C                   MOVE      DDACTD        ZADIN
 
     C                   CALLB     'ZPCINT'
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    NOML
     C                   PARM                    ZACIN
     C                   PARM                    ZDADJ
     C                   PARM                    ZADIN
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR
     C                   PARM                    BJDFIN
     C                   PARM      TDVD          ECD
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
 
     C                   MOVE      ZITRA         ACTC_ITRA
     C                   END
      *
      ** Edit the trade's actual calculated interest amount
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ACTC_ITRA     ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      NomCcyDec     ZDECS
     C                   PARM      *BLANK        ZECODE
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        EACTC_ITRA       15
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Screen Fields
      ** -------------
 
      ** Accrued indicator  (1A)
      ** Days Adjustment  (5A)
      ** Actual/Difference Indicator (1A)
      ** Interest Amount (15A)
     C                   PARM                    DDACIN
     C                   PARM                    DDDADJ
     C                   PARM                    DDACTD
     C                   PARM                    DDITRA
 
      ** Trade Details
      ** -------------
      ** Nominal  (11P 0)
      ** Value Date (5P 0)
      ** Days Adjustment <actual> (3P 0)
      ** Coupon rate (for trade) (11P 7)
      ** Overide Indicator  (1A)
 
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DADJ
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR
 
      ** Security Details
      ** ----------------
      ** Interest days adjustment
      ** Nominal currency decimal places   (1P 0)
      ** Processing type   (1A)
 
     C                   PARM                    SECTY
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
 
      *
      ** System details
      ** --------------
      ** Date format  (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Indicators
      ** -------------
 
      ** Days Adjustment OK indicator  (1A)
      ** Actual/Difference Ind OK indicator  (1A)
      ** Interest Amount OK Indicator (1A)
 
     C                   PARM                    ddDADJok
     C                   PARM                    ddACTDok
     C                   PARM                    ddITRAok
 
      ** Interest Amount
      ** Interest Adjustment
      ** Expected Interest Amount
     C                   PARM                    ITRA
     C                   PARM                    TINA
     C                   PARM                    EXPT_ITRA
 
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
