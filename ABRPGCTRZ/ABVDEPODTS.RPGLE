     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate deposit details')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVDEPODTS - Validate Deposit Details                        *
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
      *  Prev Amend No. CAP076             Date 03Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156689             Date 08Mar99               *
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** Deposit Int.Calc.Method
     D JUICM2          S              1S 0
 
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
 
     C                   MOVE      *BLANK        JUDRDF
     C                   Z-ADD     *ZERO         JUICM2
     C                   Z-ADD     *ZERO         JUIRT2
     C                   Z-ADD     *ZERO         JUINA2
     C                   Z-ADD     *ZERO         JUFDBA
     C                   Z-ADD     *ZERO         JUFDA2
 
      *
      * DEPOSIT ROUND DOWN INDICATOR VALIDATION
      *
     C     DDL1CSOK      IFNE      'N'
     C                   EXSR      DRDFV
     C                   END
      *
      * DEPOSIT INTEREST CALCULATION METHOD VALIDATION
      *
     C     DDL1CSOK      IFNE      'N'
     C                   EXSR      DPCMV
     C                   END
      *
      * DEPOSIT INTEREST RATE VALIDATION
      *
     C     DDL1CSOK      IFNE      'N'
     C                   EXSR      DPIRV
     C                   END
      *
      * DEPOSIT INTEREST AMOUNT CALCULATION
      *
     C     DDL1DTOK      IFNE      'N'
     C     DDL1CSOK      ANDNE     'N'
     C     DDL1SAOK      ANDNE     'N'
     C     DDDRDFOK      ANDNE     'N'
     C     DDDPCMOK      ANDNE     'N'
     C     DDDPIROK      ANDNE     'N'
     C                   EXSR      DIACAL
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDRDFOK      IFEQ      'N'
     C     DDDPCMOK      OREQ      'N'
     C     DDDPIROK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
     C*****************************************************************
     C* DRDFV - DEPOSIT ROUND DOWN INDICATOR VALIDATION
     C*****************************************************************
     C     DRDFV         BEGSR
      *
      * If round down indicator on sell currency or branch is 'N'
      * then deposit round down indicator on deal will be 'N'
      *
     C     SelCyRDFC     IFEQ      'N'
     C     BkgBrRDFC     OREQ      'N'
     C                   MOVE      'N'           DDDRDF
     C                   END
      *
      ** The deposit round-down indicator must be Y or N
      *
     C     DDDRDF        IFNE      'Y'
     C     DDDRDF        ANDNE     'N'
     C                   MOVE      'N'           DDDRDFOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDRDF'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0501'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * Update deposit round down indicator on deal
      *
     C                   MOVE      DDDRDF        JUDRDF
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* DPCMV - DEPOSIT CALCULATION METHOD VALIDATION
     C*****************************************************************
     C     DPCMV         BEGSR
      *
      * Default deposit calculation method to that of 1st leg sell currency
      *
     C     DDDPCM        IFEQ      ' '
     C                   MOVE      SelCyDICB     DDDPCM
     C                   END
      *
      * Deposit calculation method must be 1 to 6
      *
     C     DDDPCM        IFNE      '1'
     C     DDDPCM        ANDNE     '2'
     C     DDDPCM        ANDNE     '3'
     C     DDDPCM        ANDNE     '4'
     C     DDDPCM        ANDNE     '5'
     C     DDDPCM        ANDNE     '6'
     C                   MOVE      'N'           DDDPCMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPCM'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0108'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * Update deposit calculation method on deal
      *
     C                   MOVE      DDDPCM        JUICM2
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* DPIRV - DEPOSIT INTEREST RATE VALIDATION
     C*****************************************************************
     C     DPIRV         BEGSR
      *
      * Deposit interest rate can't be blank
      *
     C     DDDPIR        IFEQ      *BLANK
     C                   MOVE      'N'           DDDPIROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPIR'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0209'     MsgIdXAr(Idx)
     C                   GOTO      EDPIRV
     C                   END
      *
      * Deposit interest rate must be a valid (signed) rate
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDDPIR        ZFLD17
     C     11            SUB       7             ZSDIG
     C                   Z-ADD     7             ZSDEC
 
     C                   EXSR      ZASIGN
      *
      * It is an invalid rate
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVE      'N'           DDDPIROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDPIR'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0210'     MsgIdXAr(Idx)
     C                   GOTO      EDPIRV
     C                   END
      *
      * Update deposit interest rate on deal
      *
     C                   MOVE      ZOUT15        JUIRT2
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     JUIRT2        JUIRT2
     C                   ENDIF
      *
      ** Edit Deposit interest rate (signed) for display
      *
     C                   Z-ADD     *ZERO         @@AMTW
     C                   MOVE      JUIRT2        @@AMTW
     C                   Z-ADD     7             W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDDPIR
      *
     C     EDPIRV        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C* DIACAL - DEPOSIT INTEREST AMOUNT CALCULATION
     C*****************************************************************
     C     DIACAL        BEGSR
      *
      * Calculate deposit interest
      *
     C                   CALLB     'MM1030'
      *                  ~~~~~~~~~~~~~~~~
     C                   PARM                    JUNDAT
     C                   PARM                    JUFDAT
     C                   PARM                    DDDPCM
     C                   PARM                    JUNDA2
     C                   PARM                    JUIRT2
     C                   PARM                    DDDRDF
     C                   PARM      *ZERO         @@INTR           15 0
     C                   Z-ADD     @@INTR        JUINA2
      *
      * Edit deposit interest for display
      *
     C                   Z-ADD     @@INTR        @@AMTW
     C                   Z-ADD     SelCyNBDP     W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        DDDPIA
      *
      * The 2nd.leg buy amount is the 1st leg sell amt + deposit int. amt
      *
     C     JUNDA2        ADD       JUINA2        JUFDBA
     C                   Z-ADD     JUFDBA        JUFDA2
      *
      * Edit the 2nd leg buy amount for display
      *
     C                   Z-ADD     JUFDBA        @@AMTW
     C                   Z-ADD     SelCyNBDP     W@DECP
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTP        DDL2BA
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
      ** Deposit Round Down Indicator
      ** Deposit Interest Calculation Method
      ** Deposit Interest Rate
     C                   PARM                    DDDRDF            1
     C                   PARM                    DDDPCM            1
     C                   PARM                    DDDPIR           13
      *
      ** Deal File fields:
      ** Deal Near Date
      ** Deal Far Date
      ** Deal Second Ccy Near Date Amount
     C                   PARM                    JUNDAT            5 0
     C                   PARM                    JUFDAT            5 0
     C                   PARM                    JUNDA2           15 0
      *
      ** 1st Leg Value Date - OK
      ** 1st Leg Sell Currency - OK
      ** 1st Leg Sell Amount - OK
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL1CSOK          1
     C                   PARM                    DDL1SAOK          1
      *
      ** Booking branch round down indicator
      ** Sell currency round down indicator
      ** Sell currency int. calc. method
      ** Sell number of decimal places
     C                   PARM                    BkgBrRDFC         1
     C                   PARM                    SelCyRDFC         1
     C                   PARM                    SelCyDICB         1
     C                   PARM                    SelCyNBDP         1 0
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
      ** Deposit Round Down Indicator - OK
      ** Deposit Interest Calculation Method - OK
      ** Deposit Interest Rate - OK
     C                   PARM                    DDDRDFOK          1
     C                   PARM                    DDDPCMOK          1
     C                   PARM                    DDDPIROK          1
      *
      ** 2nd Leg Buy Amount
      ** Deposit Interest Amount
     C                   PARM                    DDL2BA           16
     C                   PARM                    DDDPIA           17
      *
      * Deposit round-down int indicator
      * Deal Second Ccy Interest Calc.Method
      * Deal Second Ccy Interest Rate
      * Deal Second Ccy Interest Amount
      * Deal Far Date Buy Amount
      * Deal Second Ccy Far Date Amount
      *
     C                   PARM                    JUDRDF            1
     C                   PARM                    JUICM2
     C                   PARM                    JUIRT2           11 7
     C                   PARM                    JUINA2           15 0
     C                   PARM                    JUFDBA           15 0
     C                   PARM                    JUFDA2           15 0
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
(c) Finastra International Limited 2001
