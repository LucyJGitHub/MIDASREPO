     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Validate CLS settlement')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVCLSSETL - Validate CLS Settlement                         *
      *                                                               *
      *  Component of: FXFXDLSIN                                      *
      *                FXFXDLCTL                                      *
      *                FXFXDLRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR919816           Date 05Nov14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 248819             Date 29Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL037             Date 01Mar05               *
      *                 CDL035             Date 28Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 193750             Date 29May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190876             Date 08Mar01               *
      *                 189507             Date 02Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR919816 - Program fails with dec. data error if customer    *
      *             number input is invalid. Added validation that    *
      *             checks if cust. no. input is ok by checking if    *
      *             BBCUST is non-blank. (Child: AR919817)            *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      * 248819 - Get error message FXM2006 even when CDL037 is OFF    *
      *          message should be warning.                           *
      *        - Field CDL037 is not initialised correctly due to     *
      *          typo error.                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL037 - Prevent Trade input after cutoff time.              *
      *           Change FXM2006 from Warning to Error message.       *
      *           Check next eligible date for Buy and Sell currency. *
      *  CDL035 - Validate Trade input date against CLS Cust Eff Date *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  193750 - If customer field is left blank, and 'Y' entered    *
      *           in CLS Settlement field, a database error occurs.   *
      *  190876 - Reject Meridian interface deals with warnings.      *
      *           New warning if Counterparty is not a CLS Customer.  *
      *  189507 - Change setup of CLS fields in Customer details      *
      *           and FX deals input                                  *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the FX standard declares
      */COPY*FXCPYSRC,STDDECLARE***                                                           209009
      /COPY ZACPYSRC,STDDECLARE                                                               209009
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Time data structure
     D                 DS
     D  Whhmmss                1      6  0
     D  Whhmm                  1      4  0
 
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCUSTDFAC    E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** Externally described DS for SAR details                                              CDL035
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL035
                                                                                              CDL035
      ** DS for access objects - Short data structure                                         CDL035
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL035
                                                                                              CDL035
      ** DS for access objects - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access objects - Very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Index for arrays of warning error message ids, etc.
     D WIx             S              3P 0
 
      ** CLS settlement
     D DDCLSS          S              1A
     D DDCLSSOK        S              1A
 
      ** Buy currency
     D DDBCCY          S              3A
 
      ** Sell currency
     D DDSCCY          S              3A
 
      ** Booking branch
     D DDBRSN          S              3A
 
      ** Customer
     D DDCUST          S             10A
 
      ** Profit centre
     D DDNBUY          S              1A
     D DDNSEL          S              1A
 
      ** Deal date                                                                            CDL035
     D F3DDDN          S              5P 0                                                    CDL035
                                                                                              CDL035
      ** Value date
     D F3VDDN          S              5P 0
 
      ** CLS settlement
     D F3CLSS          S              1A
 
      ** Work parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PSARD           S              6A                                                      CDL035
     D Pkey1           S             10A
     D PKyST           S              7A
     D PCcy            S              3A
     D PBrCd           S              3A
     D FWDNB           S              5P 0
     D FWDNBB          S              5P 0                                                    CDL037
     D FWDNBS          S              5P 0                                                    CDL037
     D PEffDat         S              2  0
     D W#DDN1          S              5P 0                                                    CDL035
     D W#DDN2          S              5P 0                                                    CDL035
 
      ** Standing data
     D BJRDNB          S              5P 0
     D BJLCCY          S              3A
     D BJSLCD          S              3A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Initialise work variables.
 
     C                   EVAL      IDx = 0
     C                   EVAL      WIx = 0
     C                   EVAL      DDCLSSOK = 'Y'
 
      ** Validate CLS settlement
 
     C                   EXSR      SRValCLS
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        DDCLSSOK = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        DDCLSSOK <> 'N'
     C                   EVAL      F3CLSS = DDCLSS
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALCLS - Validation for CLS settlement                     *
      *                                                               *
      *****************************************************************
 
     C     SRValCLS      BEGSR
 
      ** Error: if CLSS is not Y or N or blank
 
     C                   IF        DDCLSS <> 'Y' AND
     C                             DDCLSS <> 'N' AND
     C                             DDCLSS <> *BLANK
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2019'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   IF        DDCUST <> *BLANKS
 
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDCUST        PKey1
     C                   PARM      *BLANKS       PKyST
     C     SDCUST        PARM      SDCUST        DSLDY
 
      ** If CLSS was left blank, determine default value for it
 
     C                   IF        PRtCd = *BLANKS AND DDCLSS = *BLANK
      ** If CDL035 is on                                                                      CDL035
     C                   IF        CDL035 = 'Y'                                               CDL035
     C                   EVAL      W#DDN1 = F3DDDN                                            CDL035
     C                   EVAL      W#DDN2 = F3DDDN                                            CDL035
     C                   ELSE                                                                 CDL035
     C                   EVAL      W#DDN1 = BJRDNB                                            CDL035
     C                   EVAL      W#DDN2 = F3VDDN                                            CDL035
     C                   ENDIF                                                                CDL035
                                                                                              CDL035
     C                   EXSR      SRDftCLS
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validations: if deal was set to settle via CLS,
 
     C                   IF        DDCLSS = 'Y'
 
      ** Error: deal cannot be settled via CLS if defined to do FX Netting
 
     C                   IF        DDNBUY = 'Y' OR DDNSEL = 'Y'
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2000'     MsgIdXAr(IDx)
     C                   GOTO      EValCLS
     C                   ENDIF
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDBCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *BLANKS
 
      ** Error: Buy currency is not CLS-supported
 
     C                   IF        A6CLSC <> 'Y'
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2001'     MsgIdXAr(IDx)
     C                   ENDIF
 
      ** Error: Effective date for Buy currency hasn't been reached
 
     C                   IF        A6CLSC = 'Y' AND F3VDDN < A6EFDT
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2002'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDSCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *BLANKS
 
      ** Error: Sell currency is not CLS-supported
 
     C                   IF        A6CLSC <> 'Y'
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2003'     MsgIdXAr(IDx)
     C                   ENDIF
 
      ** Error: Effective date of Sell currency hasn't been reached
 
     C                   IF        A6CLSC = 'Y' AND F3VDDN < A6EFDT
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2004'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   ENDIF
 
      ** Error: Customer Effective date hasn't been reached
 
     C**********         IF        F3VDDN < BBEFDT AND DDCUST <> *BLANKS                      193750
     C**********         IF        DDCUST <> *BLANKS AND F3VDDN < BBEFDT             193750 AR919816
     C                   IF        DDCUST <> *BLANKS AND BBCUST <> *BLANK                   AR919816
     C                             AND F3VDDN < BBEFDT                                      AR919816
     C                   MOVE      'N'           DDCLSSOK
     C                   ADD       1             IDx
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)
     C                   MOVEL     'FXM2005'     MsgIdXAr(IDx)
     C                   ENDIF
 
     C                   IF        DDBRSN <> *BLANKS
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDBRSN        PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtCd = *BLANKS
     C                   Z-ADD     A8EDAT        PEffDat
 
      ** If CDL037 is ON                                                                      CDL037
      ** Check next eligible date for Buy Currency                                            CDL037
     C                   IF        CDL037 = 'Y'                                               CDL037
                                                                                              CDL037
     C                   CALLB     'ZFWDT'                                                    CDL037
     C                   PARM                    BJRDNB                                       CDL037
     C                   PARM                    PEffDat                                      CDL037
     C                   PARM                    FWDNBB                                       CDL037
     C                   PARM                    DDBCCY                                       CDL037
     C                   PARM                    BJSLCD                                       CDL037
                                                                                              CDL037
      ** Check next eligible date for Sell Currency                                           CDL037
     C                   Z-ADD     A8EDAT        PEffDat                                      CDL037
     C                   CALLB     'ZFWDT'                                                    CDL037
     C                   PARM                    BJRDNB                                       CDL037
     C                   PARM                    PEffDat                                      CDL037
     C                   PARM                    FWDNBS                                       CDL037
     C                   PARM                    DDSCCY                                       CDL037
     C                   PARM                    BJSLCD                                       CDL037
                                                                                              CDL037
     C                   ENDIF                                                                CDL037
                                                                                              CDL037
     C                   CALLB     'ZFWDT'
     C                   PARM                    BJRDNB
     C                   PARM                    PEffDat
     C                   PARM                    FWDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
 
      ** Consider CLS cutoff time only if Value date = Eligible date
      ** Warning: Input date/time of the deal is after the cutoff date/time
 
     C                   TIME                    Whhmmss
                                                                                              CDL037
      ** If CDL037 is ON, change message FXM2006 to be an Error message                       CDL037
     C                   IF        CDL037 = 'Y'                                               CDL037
                                                                                              CDL037
     C                   IF        (F3VDDN < FWDNBB) OR (F3VDDN < FWDNBS) OR                  CDL037
     C                             (F3VDDN = FWDNBB AND Whhmm > A8COTI)  OR                   CDL037
     C                             (F3VDDN = FWDNBS AND Whhmm > A8COTI)                       CDL037
     C                   MOVE      'N'           DDCLSSOK                                     CDL037
     C                   ADD       1             IDx                                          CDL037
     C                   MOVEL     'DDCLSS'      FldNamXAr(IDx)                               CDL037
     C                   MOVEL     'FXM2006'     MsgIdXAr(IDx)                                CDL037
     C                   EVAL      DDCLSS = 'N'                                               CDL037
     C                   ENDIF                                                                CDL037
                                                                                              CDL037
     C                   ELSE                                                                 CDL037
                                                                                              CDL037
     C                   IF        (F3VDDN < FWDNB  OR
     C                             (F3VDDN = FWDNB AND Whhmm > A8COTI))
     C                   MOVE      'W'           DDCLSSOK
     C                   ADD       1             WIx
     C                   MOVEL     'DDCLSS'      WFldNmXAr(WIx)
     C                   MOVEL     'FXM2006'     WMsgIdXAr(WIx)
     C                   ENDIF
     C                   ENDIF                                                                CDL037
 
     C                   ENDIF
 
     C                   ENDIF
                                                                                              190876
      ** Warning: Counterparty is not a CLS Customer                                          190876
                                                                                              190876
     C                   IF        DDCUST <> *Blanks AND BBCLSS <> 'Y'                        190876
     C                   MOVE      'W'           DDCLSSOK                                     190876
     C                   ADD       1             WIx                                          190876
     C                   MOVEL     'DDCUST'      WFldNmXAr(WIx)                               190876
     C                   MOVEL     'FXM3042'     WMsgIdXAr(WIx)                               190876
     C                   ENDIF                                                                190876
 
     C                   ENDIF
 
     C     EValCLS       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDftCLS - Determine default value for CLS Settlement field  *
      *                                                               *
      *****************************************************************
 
     C     SRDftCLS      BEGSR
 
     C                   EVAL      DDCLSS = 'N'
 
     C**********         IF        BBCLSS = 'Y' AND BJRDNB >= BBEFDT AND                      CDL035
     C**********                   DDBCCY <> *BLANKS                                          CDL035
     C                   IF        BBCLSS = 'Y' AND W#DDN1 >= BBEFDT AND                      CDL035
     C                             DDBCCY <> *BLANKS                                          CDL035
 
      ** Buy currency must be CLS-supported and Effective date reached
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDBCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C***********        IF        PRtCd = *BLANKS AND A6CLSC = 'Y' AND                       CDL035
     C***********                  F3VDDN >= A6EFDT AND DDSCCY <> *BLANKS                     CDL035
     C                   IF        PRtCd = *BLANKS AND A6CLSC = 'Y' AND                       CDL035
     C                             W#DDN2 >= A6EFDT AND DDSCCY <> *BLANKS                     CDL035
 
      ** Sell currency must be CLS-supported and Effective date reached
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDSCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C***********        IF        PRtCd = *BLANKS AND A6CLSC = 'Y' AND                       CDL035
     C***********                  F3VDDN >= A6EFDT AND DDBRSN <> *BLANKS                     CDL035
     C                   IF        PRtCd = *BLANKS AND A6CLSC = 'Y' AND                       CDL035
     C                             W#DDN2 >= A6EFDT AND DDBRSN <> *BLANKS                     CDL035
 
      ** Eligible date for CLS deals must have been reached
      ** ..... and Default CLS by Customer = Y                                                189507
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDBRSN        PBrCd
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Compute Rundate + Eligible date (from Branch details)
 
     C                   IF        PRtCd = *BLANKS
     C                             AND A8DCLC = 'Y'                                           189507
     C                   Z-ADD     A8EDAT        PEffDat
                                                                                              CDL037
      ** If CDL037 is ON                                                                      CDL037
      ** Check next eligible date for Buy Currency                                            CDL037
     C                   IF        CDL037 = 'Y'                                               CDL037
                                                                                              CDL037
     C                   CALLB     'ZFWDT'                                                    CDL037
     C                   PARM                    BJRDNB                                       CDL037
     C                   PARM                    PEffDat                                      CDL037
     C                   PARM                    FWDNBB                                       CDL037
     C                   PARM                    DDBCCY                                       CDL037
     C                   PARM                    BJSLCD                                       CDL037
                                                                                              CDL037
      ** Check next eligible date for Sell Currency                                           CDL037
     C                   Z-ADD     A8EDAT        PEffDat                                      CDL037
     C                   CALLB     'ZFWDT'                                                    CDL037
     C                   PARM                    BJRDNB                                       CDL037
     C                   PARM                    PEffDat                                      CDL037
     C                   PARM                    FWDNBS                                       CDL037
     C                   PARM                    DDSCCY                                       CDL037
     C                   PARM                    BJSLCD                                       CDL037
                                                                                              CDL037
     C                   ENDIF                                                                CDL037
                                                                                              CDL037
     C                   CALLB     'ZFWDT'
     C                   PARM                    BJRDNB
     C                   PARM                    PEffDat
     C                   PARM                    FWDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
 
      ** If all validations passed and Value date > Eligible date,
      ** default CLSS to 'Y'
 
     C                   IF        CDL037 = 'Y'                                               CDL037
                                                                                              CDL037
     C                   IF        F3VDDN > FWDNBB AND F3VDDN > FWDNBS                        CDL037
     C                   EVAL      DDCLSS = 'Y'                                               CDL037
     C                   ENDIF                                                                CDL037
                                                                                              CDL037
     C                   ELSE                                                                 CDL037
                                                                                              CDL037
     C                   IF        F3VDDN > FWDNB
     C                   EVAL      DDCLSS = 'Y'
     C                   ENDIF
 
     C                   ENDIF                                                                CDL037
 
      ** If all validations passed and Value date = Eligible date,
      ** default CLSS to 'Y' only if Cutoff time hadn't been reached
 
     C                   IF        CDL037 = 'Y'                                               CDL037
                                                                                              CDL037
     C                   IF        F3VDDN = FWDNBB OR F3VDDN = FWDNBS                         CDL037
     C                   TIME                    Whhmmss                                      CDL037
     C                   IF        Whhmm <= A8COTI                                            CDL037
     C                   EVAL      DDCLSS = 'Y'                                               CDL037
     C                   ENDIF                                                                CDL037
     C                   ENDIF                                                                CDL037
                                                                                              CDL037
     C                   ELSE                                                                 CDL037
                                                                                              CDL037
     C                   IF        F3VDDN = FWDNB
     C                   TIME                    Whhmmss
     C                   IF        Whhmm <= A8COTI
     C                   EVAL      DDCLSS = 'Y'
     C                   ENDIF
     C                   ENDIF
                                                                                              CDL037
     C                   ENDIF                                                                CDL037
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     EDftCLS       ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCLSS
     C                   PARM                    DDBRSN
     C                   PARM                    DDCUST
     C                   PARM                    DDBCCY
     C                   PARM                    DDSCCY
     C                   PARM                    F3VDDN
     C                   PARM                    DDNBUY
     C                   PARM                    DDNSEL
     C                   PARM                    F3DDDN                                       CDL035
 
      ** STANDING DATA
      ** =============
     C                   PARM                    BJRDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
 
     C                   PARM                    F3CLSS
 
     C                   PARM                    DDCLSSOK
 
      ** Check if switchable feature CDL035 is switched on                                    CDL035
     C                   CALL      'AOSARDR0'                                                 CDL035
     C                   PARM      *BLANKS       PRtCd                                        CDL035
     C                   PARM      '*VERIFY'     POptn                                        CDL035
     C                   PARM      'CDL035'      PSARD                                        CDL035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL035
      *                                                                                       CDL035
     C                   MOVE      'N'           CDL035            1                          CDL035
     C**** @RTCD         IFEQ      *BLANKS                                              CDL035248819
     C     PRtCd         IFEQ      *BLANKS                                                    248819
     C                   MOVE      'Y'           CDL035                                       CDL035
     C                   ENDIF                                                                CDL035
                                                                                              CDL035
      ** Check if switchable feature CDL037 is switched on                                    CDL037
     C                   CALL      'AOSARDR0'                                                 CDL037
     C                   PARM      *BLANKS       PRtCd                                        CDL037
     C                   PARM      '*VERIFY'     POptn                                        CDL037
     C                   PARM      'CDL037'      PSARD                                        CDL037
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL037
      *                                                                                       CDL037
     C                   MOVE      'N'           CDL037            1                          CDL037
     C**** @RTCD         IFEQ      *BLANKS                                              CDL037248819
     C     PRtCd         IFEQ      *BLANKS                                                    248819
     C                   MOVE      'Y'           CDL037                                       CDL037
     C                   ENDIF                                                                CDL037
                                                                                              CDL037
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
