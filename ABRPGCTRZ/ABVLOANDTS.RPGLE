     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate loan details')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVLOANDTS - Validate Loan Details                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAP076             Date 03Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 156689             Date 08Mar99               *
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1030                   *
      *           (new parameter to ZINTDY)                           *
      *  156689 - ZASIGN TO RECOGNIZE '.' OR ',' AS DECIMAL SEPARATOR *
      *  CAP004 - API's Phase 3.                                      *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Loan Int.Calc.Method
     D JUICM1          S              1S 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output deal fields
 
     C                   MOVE      *BLANK        JULRDF
     C                   Z-ADD     *ZERO         JUICM1
     C                   Z-ADD     *ZERO         JUIRT1
     C                   Z-ADD     *ZERO         JUINA1
     C                   Z-ADD     *ZERO         JUFDSA
     C                   Z-ADD     *ZERO         JUFDA1
 
      *
      * LOAN ROUND DOWN INDICATOR VALIDATION
      *
     C     DDL1CBOK      IFNE      'N'
     C                   EXSR      LRDFV
     C                   END
      *
      * LOAN INTEREST CALCULATION METHOD VALIDATION
      *
     C     DDL1CBOK      IFNE      'N'
     C                   EXSR      LOCMV
     C                   END
      *
      * LOAN INTEREST RATE VALIDATION
      *
     C     DDL1CBOK      IFNE      'N'
     C                   EXSR      LOIRV
     C                   END
      *
      * LOAN INTEREST AMOUNT CALCULATION
      *
     C     DDL1DTOK      IFNE      'N'
     C     DDL1CBOK      ANDNE     'N'
     C     DDL1BAOK      ANDNE     'N'
     C     DDLRDFOK      ANDNE     'N'
     C     DDLOCMOK      ANDNE     'N'
     C     DDLOIROK      ANDNE     'N'
     C                   EXSR      LIACAL
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDLRDFOK      IFEQ      'N'
     C     DDLOCMOK      OREQ      'N'
     C     DDLOIROK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* LRDFV - LOAN ROUND DOWN INDICATOR VALIDATION
     C*****************************************************************
     C     LRDFV         BEGSR
      *
      * If round down indicator on buy currency or branch is 'N'
      * then loan round down indicator on deal will be 'N'
      *
     C     BuyCyRDFC     IFEQ      'N'
     C     BkgBrRDFC     OREQ      'N'
     C                   MOVE      'N'           DDLRDF
     C                   END
      *
      ** The loan round-down indicator must be Y or N
      *
     C     DDLRDF        IFNE      'Y'
     C     DDLRDF        ANDNE     'N'
     C                   MOVE      'N'           DDLRDFOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLRDF'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0501'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * Update loan round down indicator on deal
      *
     C                   MOVE      DDLRDF        JULRDF
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* LOCMV - LOAN CALCULATION METHOD VALIDATION
     C*****************************************************************
     C     LOCMV         BEGSR
      *
      * Default loan calculation method to that of 1st leg buy currency
      *
     C     DDLOCM        IFEQ      ' '
     C                   MOVE      BuyCyDICB     DDLOCM
     C                   END
      *
      * Loan calculation method must be 1 to 6
      *
     C     DDLOCM        IFNE      '1'
     C     DDLOCM        ANDNE     '2'
     C     DDLOCM        ANDNE     '3'
     C     DDLOCM        ANDNE     '4'
     C     DDLOCM        ANDNE     '5'
     C     DDLOCM        ANDNE     '6'
     C                   MOVE      'N'           DDLOCMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLOCM'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0107'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * Update loan calculation method on deal
      *
     C                   MOVE      DDLOCM        JUICM1
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* LOIRV - LOAN INTEREST RATE VALIDATION
     C*****************************************************************
     C     LOIRV         BEGSR
      *
      * Loan interest rate can't be blank
      *
     C     DDLOIR        IFEQ      *BLANK
     C                   MOVE      'N'           DDLOIROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLOIR'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0207'     MsgIdXAr(Idx)
     C                   GOTO      ELOIRV
     C                   END
      *
      * Loan interest rate must be a valid rate
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDLOIR        ZFLD17
     C     11            SUB       7             ZSDIG
     C                   Z-ADD     7             ZSDEC
 
     C                   EXSR      ZASIGN
      *
      * It is an invalid rate
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDLOIROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLOIR'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0208'     MsgIdXAr(Idx)
     C                   GOTO      ELOIRV
     C                   END
      *
      * Update loan interest rate on deal
      *
     C                   MOVE      ZOUT15        JUIRT1
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     JUIRT1        JUIRT1
     C                   ENDIF
      *
      ** Edit Loan interest rate (signed) for display
      *
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JUIRT1        @@AMTW
     C                   Z-ADD     7             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDLOIR
      *
     C     ELOIRV        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* LIACAL - LOAN INTEREST AMOUNT CALCULATION
     C*****************************************************************
     C     LIACAL        BEGSR
      *
      * Calculate loan interest
      *
     C                   CALLB     'MM1030'
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    JUNDAT
     C                   PARM                    JUFDAT
     C                   PARM                    DDLOCM
     C                   PARM                    JUNDA1
     C                   PARM                    JUIRT1
     C                   PARM                    DDLRDF
     C                   PARM      *ZERO         @@INTR           15 0
     C                   Z-ADD     @@INTR        JUINA1
      *
      * Edit loan interest for display
      *
     C                   Z-ADD     @@INTR        @@AMTW
     C                   Z-ADD     BuyCyNBDP     W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDLOIA
      *
      * The 2nd.leg sell amount is the 1st leg buy amt + loan int. amt
      *
     C     JUNDA1        ADD       JUINA1        JUFDSA
     C                   Z-ADD     JUFDSA        JUFDA1
      *
      * Edit the 2nd leg sell amount for display
      *
     C                   Z-ADD     JUFDSA        @@AMTW
     C                   Z-ADD     BuyCyNBDP     W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2SA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZASIGN - VALIDATE SIGNED NUMERIC AMOUNT
      *****************************************************************
     C     ZASIGN        BEGSR
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM                    ZSDIG             2 0
     C                   PARM                    ZSDEC             1 0
     C                   PARM      BNDCSP        ZSDCSP            1            156689
     C                   PARM      *BLANK        ZOUT15           15
     C                   PARM      *BLANK        ZFSIGN            1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*********************************************************************
     C* FMTAMT - FORMAT AMOUNT FOR DISPLAY
     C*********************************************************************
     C     FMTAMT        BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           15 0
     C                   PARM                    W@DECP            1 0
     C                   PARM      BNDCSP        @@DCSP            1            156689
     C                   PARM      *BLANK        @@AMTP           16
     C                   PARM      *BLANK        @@AMTD           17
 
     C                   ENDSR
     C*********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Screen fields:
      ** Loan Round Down Indicator
      ** Loan Interest Calculation Method
      ** Loan Interest Rate
     C                   PARM                    DDLRDF            1
     C                   PARM                    DDLOCM            1
     C                   PARM                    DDLOIR           13
      *
      ** Deal File fields:
      ** Deal Near Date
      ** Deal Far Date
      ** Deal First Ccy Near Date Amount
     C                   PARM                    JUNDAT            5 0
     C                   PARM                    JUFDAT            5 0
     C                   PARM                    JUNDA1           15 0
      *
      ** 1st Leg Value Date - OK
      ** 1st Leg Buy Currency - OK
      ** 1st Leg Buy Amount - OK
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CBOK          1
     C                   PARM                    DDL1BAOK          1
      *
      ** Booking branch round down indicator
      ** Buy currency round down indicator
      ** Buy currency int. calc. method
      ** Buy number of decimal places
     C                   PARM                    BkgBrRDFC         1
     C                   PARM                    BuyCyRDFC         1
     C                   PARM                    BuyCyDICB         1
     C                   PARM                    BuyCyNBDP         1 0
      *
      * ICD
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Loan Round Down Indicator - OK
      ** Loan Interest Calculation Method - OK
      ** Loan Interest Rate - OK
     C                   PARM                    DDLRDFOK          1
     C                   PARM                    DDLOCMOK          1
     C                   PARM                    DDLOIROK          1
      *
      ** 2nd Leg Sell Amount
      ** Loan Interest Amount
     C                   PARM                    DDL2SA           16
     C                   PARM                    DDLOIA           17
      *
      * Loan round-down int indicator
      * Deal First Ccy Interest Calc.Method
      * Deal First Ccy Interest Rate
      * Deal First Ccy Interest Amount
      * Deal Far Date Sell Amount
      * Deal First Ccy Far Date Amount
      *
     C                   PARM                    JULRDF            1
     C                   PARM                    JUICM1
     C                   PARM                    JUIRT1           11 7
     C                   PARM                    JUINA1           15 0
     C                   PARM                    JUFDSA           15 0
     C                   PARM                    JUFDA1           15 0
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
