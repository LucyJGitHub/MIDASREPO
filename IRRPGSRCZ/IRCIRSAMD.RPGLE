     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy IRS amend processing')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSAMD - Cross Currency Interest Rate Swaps Amend Checking*
      *                                                               *
      *  Function:  This module compares the fields of an amended     *
      *             deal against those currently on file.             *
      *             It checks whether all fields changed are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL039             Date 22Aug05               *
      *                 CDL038             Date 10May05               *
      *                 CAS008             Date 16Jun04               *
      *                 BUG7210            Date 16May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6876            Date 27Apr05               *
      *                 BUG6472            Date 20Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 218641             Date 10Jun03               *
      *                 CAS004             Date 26Jun02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 07Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184363             Date 23Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP003  *CREATE    Date 22Jun98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL039 - Amendable Deal Sub Types & Classes                  *
      *  CDL038 - Extended Deal Sub Type
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  BUG7210- Use ZCMPAMTS to compare brokerage                   *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG6876- Use ZCMPAMTS to compare screen amount fields        *
      *  BUG6472- Added sign field for short term rate (Recompile)    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  218641 - Adjust Yield Curve field position in the definition *
      *           file (Recompile)                                    *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date. (Recompiled)                 *
      *  184363 - Do not allow the Spread/Rate to be amended, when    *
      *           Int. Pay Freq. is 'C'.                              *
      *  CIR005 - FRA/IRS Business Day Conventions (Recompiled)       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(IRCIRSPD)
 
      * (Current) Deal in Screen Format
     D DealScnFmt    E DS                  EXTNAME(IRCIRSPD)
     D                                     PREFIX(@)
 
      * (Current) Deal in File Format
     D DealFilFmt    E DS                  EXTNAME(DEALSDG)
 
     D @M              S              2  0 DIM(12) CTDATA PERRCD(12)
     D*
     D RUNDAT          DS
     D  @MBIN                 13     13
     D*
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
     D**  Data structure for Portfolio Management ICD File
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
     D*
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL039
     D R_LCD         E                     EXTFLD(LCD)                                        CDL039
      ** EXTERNAL DS FOR SAR DETAILS                                                          CDL039
                                                                                              CDL039
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D*
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D OKFlagsDS       DS
     D  SAccdOK                       1A
     D  SDlnoOK                       1A
     D  SDTypOK                       1A
     D  SDlstOK                       1A
     D  SDDatOK                       1A
     D  SBrcaOK                       1A
     D  SBrkcOK                       1A
     D  SBageOK                       1A
     D  SLnkDnOK                      1A
     D  SCnumOK                       1A
     D  SVDatOK                       1A
     D  SMDatOK                       1A
     D  SCdasOK                       1A
     D  SBokCOK                       1A
     D  STaxiOK                       1A
     D  SPrfCOK                       1A
     D  SOrBrOK                       1A
     D  SVDEIOK                       1A
     D  SMDEIOK                       1A
     D  SPDEIOK                       1A
     D  SUCucyOK                      1A
     D  SUPamtOK                      1A
     D  SUFfiOK                       1A
     D  SUBcxrOK                      1A
     D  SuBrttOK                      1A
     D  SuRtSpOK                      1A
     D  SuSpInOK                      1A
     D  SuFrfdOK                      1A
     D  SuNICDOK                      1A
     D  SuICFrOK                      1A
     D  SuICFDOK                      1A
     D  SuEINROK                      1A
     D  SuNIPDOK                      1A
     D  SuIPFrOK                      1A
     D  SuIPFDOK                      1A
     D  SuIcbsOK                      1A
     D  StCucyOK                      1A
     D  StPamtOK                      1A
     D  StFfiOK                       1A
     D  StBcxrOK                      1A
     D  StBrttOK                      1A
     D  StRtSpOK                      1A
     D  StSpInOK                      1A
     D  StFrfdOK                      1A
     D  StNICDOK                      1A
     D  StICFrOK                      1A
     D  StICFDOK                      1A
     D  StEINROK                      1A
     D  StNIPDOK                      1A
     D  StIPFrOK                      1A
     D  StIPFDOK                      1A
     D  StIcbsOK                      1A
     D  SCAInOK                       1A                                                      CDL038
     D  SOYLCOK                       1A                                                      CDL038
     D  STYLCOK                       1A                                                      CDL038
     D  SOFYCOK                       1A                                                      CDL038
     D  STFYCOK                       1A                                                      CDL038
     D  SFCCUOK                       1A                                                      CDL038
     D  SFACTOK                       1A                                                      CDL038
     D  SFCNOOK                       1A                                                      CDL038
     D  SOFCCOK                       1A                                                      CDL038
     D  STFCCOK                       1A                                                      CDL038
     D  SC1P1OK                       1A                                                      CDL038
     D  SC2P1OK                       1A                                                      CDL038
     D  SC3P1OK                       1A                                                      CDL038
     D  SC4P1OK                       1A                                                      CDL038
     D  SC5P1OK                       1A                                                      CDL038
     D  SC6P1OK                       1A                                                      CDL038
     D  SC7P1OK                       1A                                                      CDL038
     D  SC8P1OK                       1A                                                      CDL038
     D  SC9P1OK                       1A                                                      CDL038
     D  SC0P1OK                       1A                                                      CDL038
     D  SPDC1OK                       1A                                                      CDL038
     D  SAMC1OK                       1A                                                      CDL038
     D  SC1R1OK                       1A                                                      CDL038
     D  SC2R1OK                       1A                                                      CDL038
     D  SC3R1OK                       1A                                                      CDL038
     D  SC4R1OK                       1A                                                      CDL038
     D  SC5R1OK                       1A                                                      CDL038
     D  SC6R1OK                       1A                                                      CDL038
     D  SC7R1OK                       1A                                                      CDL038
     D  SC8R1OK                       1A                                                      CDL038
     D  SC9R1OK                       1A                                                      CDL038
     D  SC0R1OK                       1A                                                      CDL038
     D  SC1P2OK                       1A                                                      CDL038
     D  SC2P2OK                       1A                                                      CDL038
     D  SC3P2OK                       1A                                                      CDL038
     D  SC4P2OK                       1A                                                      CDL038
     D  SC5P2OK                       1A                                                      CDL038
     D  SC6P2OK                       1A                                                      CDL038
     D  SC7P2OK                       1A                                                      CDL038
     D  SC8P2OK                       1A                                                      CDL038
     D  SC9P2OK                       1A                                                      CDL038
     D  SC0P2OK                       1A                                                      CDL038
     D  SPDC2OK                       1A                                                      CDL038
     D  SAMC2OK                       1A                                                      CDL038
     D  SC1R2OK                       1A                                                      CDL038
     D  SC2R2OK                       1A                                                      CDL038
     D  SC3R2OK                       1A                                                      CDL038
     D  SC4R2OK                       1A                                                      CDL038
     D  SC5R2OK                       1A                                                      CDL038
     D  SC6R2OK                       1A                                                      CDL038
     D  SC7R2OK                       1A                                                      CDL038
     D  SC8R2OK                       1A                                                      CDL038
     D  SC9R2OK                       1A                                                      CDL038
     D  SC0R2OK                       1A                                                      CDL038
     D  SUFVDOK                       1A                                                      CDL038
     D  SUFEEOK                       1A                                                      CDL038
     D  SUFPROK                       1A                                                      CDL038
     D  SBOVDOK                       1A                                                      CDL038
     D  SBUYAOK                       1A                                                      CDL038
     D  SBOPROK                       1A                                                      CDL038
     D  SONPCDOK                      1A                                                      CDL038
     D  SOIPMOK                       1A                                                      CDL038
     D  STNPCDOK                      1A                                                      CDL038
     D  STIPMOK                       1A                                                      CDL038
     D  SCLASOK                       1A                                                      CDL038
     D**SRSetMOK**********************1A                                                      CDL038
     D**SPSetMOK**********************1A                                                      CDL038
     D**SURAccOK**********************1A                                                      CDL038
     D**SROBrOK***********************1A                                                      CDL038
     D**S@RAccOK**********************1A                                                      CDL038
     D**SUPAccOK**********************1A                                                      CDL038
     D**SPOBrOK***********************1A                                                      CDL038
     D**S@PAccOK**********************1A                                                      CDL038
     D**SCpPBkOK**********************1A                                                      CDL038
     D**SCpRBkOK**********************1A                                                      CDL038
     D**SFAcOOK***********************1A                                                      CDL038
     D**SSPiOK************************1A                                                      CDL038
 
      ** Flag to indicate if Exchange Indicators are valid
     D  SExInOK                       1A
 
      ** Flag to indicate Base Currency Equivalent fields are within
      ** 10% of each other
     D  SBCcyEqOK                     1A
 
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
 
      ** Overall Transaction status, to be passed back to calling program
     D AmendOK         S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ****Convert*the dates on the current live deal
      ****from*YYYYMMDD format to Midas day number format
      *******
     C*******            EXSR      CONVDATES
      *
      **  Compare fields with amended values.
     C
     C                   EXSR      COMPFLDS
 
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * COMPFLDS  - Compare certain fields on the current deal with   *
      *             those amended                                     *
      *                                                               *
      * CALLS             - None                                      *
      *                                                               *
      * CALLED BY  MAIN                                               *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
 
     C*-----------------------------------------*
     C* Deal Type                               *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SDTYP         IFNE      @SDTYP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0398'
     C                   EVAL      sDTYPok         = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal SubType                            *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C** unless CDL039 is ON                                                                  CDL039
     C*
     C     SDLST         IFNE      @SDLST
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDLST'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0062'
     C                   EVAL      SDLSTok         = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Deal Date                               *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SDDAT         IFNE      @SDDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0382'
     C                   EVAL      sDDATok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Branch Code                             *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SBRCA         IFNE      @SBRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0063'
     C                   EVAL      sBRCAok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Broker Code                             *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SBRKC         IFNE      @SBRKC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRKC'
     C                   EVAL      MsgIDArr(Idx)   = 'FDM0147'
     C                   EVAL      sBRKCok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Brokerage                               *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C*****SBAGE         IFNE      @SBAGE                                                    BUG7210
     C                   CALLB     'ZCMPAMTS'                                                BUG7210
     C                   PARM      SBAGE         ZCMPAMT1         25                         BUG7210
     C                   PARM      @SBAGE        ZCMPAMT2         25                         BUG7210
     C                   PARM      'N'           ZCMPAMTDif        1                         BUG7210
                                                                                             BUG7210
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG7210
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBAGE'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0064'
     C                   EVAL      sBAGEok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Customer                                *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C** Access customer file for shortname, in case this has been input
     C                   MOVE      *BLANKS       CustSName        10
     C                   MOVEL     @SCNUM        @CLKEY
     C*
     C                   CALLB     'AOCUSTR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CLKEY           10
     C                   PARM      '       '     @KYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCSSN        CustSName
     C                   END
 
     C     SCNUM         IFNE      @SCNUM
     C     SCNUM         ANDNE     CustSName
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCNUM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0387'
     C                   EVAL      sCNUMok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Value Date                              *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SVDAT         IFNE      @SVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0386'
     C                   EVAL      sVDATok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Account Sequence Number                 *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SCDAS         IFNE      @SCDAS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCDAS'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0490'
     C                   EVAL      sCDASok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Book Code                               *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SBOKC         IFNE      @SBOKC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBOKC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0060'
     C                   EVAL      sBOKCok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Profit Centre                           *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C** Only validate this field if Profit Centre ICD flag on.
     C*
     C     BKPRCU        IFEQ      'Y'
     C*
     C** This field is not amendable unless 'Profit Centre Amendable'
     C** ICD flag is on.
     C*
     C     SPRFC         IFNE      @SPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      sPRFCok        = 'N'
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Our Currency                            *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SUCUCY        IFNE      @SUCUCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUCUCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0370'
     C                   EVAL      sUCUCYok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Our Principal Amount                    *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C*****SUPAMT        IFNE      @SUPAMT                                                   BUG6876
     C                   CALLB     'ZCMPAMTS'                                                BUG6876
     C                   PARM      SUPAMT        ZCMPAMT1         25                         BUG6876
     C                   PARM      @SUPAMT       ZCMPAMT2         25                         BUG6876
     C                   PARM      'N'           ZCMPAMTDif        1                         BUG6876
                                                                                             BUG6876
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6876
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUPAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0372'
     C                   EVAL      sUPAMTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Our Federal Funds Indicator             *
     C*-----------------------------------------*
     C** This field is NOT AMENDABLE.
     C*
     C     SUFFI         IFNE      @SUFFI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUFFI '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0396'
     C                   EVAL      sUFFIok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Our Base Currency Rate                  *
     C*-----------------------------------------*
     C*
     C**  This field was not amendable in DL1603, however for APIs
     C** this presents a problem because if not entered the value
     C** defaults to base currency equivalent. A subsequent amend
     C** would be invalid if front office user did not know
     C** the calculated value of original insert and left the field
     C** blank. If blank field is allowed here the update program
     C** will re-calculate the value based on current BCE which
     C** may have changed, effectively allowing the field to be
     C** amended anyway.
     C** Make field AMENDABLE for now until a better solution can be
     C** found.
     C*
     C***This*field*is*NOT*AMENDABLE.
     C*
     C*****SUBCXR        IFNE      @SUBCXR
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'SUBCXR'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMM0392'
     C*******            EVAL      sUBCXRok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Our Base Rate Code                      *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SUBRTT        IFNE      @SUBRTT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUBRTT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0376'
     C                   EVAL      sUBRTTok        = 'N'
     C                   ENDIF
     C*                                                                                       184363
     C*-----------------------------------------*                                             184363
     C* Our Spread/Rate                         *                                             184363
     C*-----------------------------------------*                                             184363
     C*                                                                                       184363
     C                   CALLB     'ZCMPAMTS'                                                BUG6876
     C                   PARM      SURTSP        ZCMPAMT1                                    BUG6876
     C                   PARM      @SURTSP       ZCMPAMT2                                    BUG6876
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6876
      *                                                                                      BUG6876
     C** This field is NOT AMENDABLE, if Int. Payment Frq. is changed to 'C'                  184363
     C*                                                                                       184363
     C*****SURTSP        IFNE      @SURTSP                                            184363 BUG6876
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6876
     C     SUIPFR        ANDEQ     'C'                                                        184363
     C                   ADD       1             Idx                                          184363
     C                   EVAL      FldNameArr(Idx) = 'SURTSP'                                 184363
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0377'                                184363
     C                   EVAL      SuRtSpOK        = 'N'                                      184363
     C                   ENDIF                                                                184363
     C*
     C*-----------------------------------------*
     C* Our Rate Fix Days                       *
     C*-----------------------------------------*
     C*******
     C***This field is NOT AMENDABLE.
     C*******
     C*****SUFRFD        IFNE      @SUFRFD
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'SUFRFD'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0107'
     C*******            EVAL      sUFRFDok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Our Rate Change Date                    *
     C*-----------------------------------------*
     C*
     C***This*field is NOT AMENDABLE.
     C*******
     C*****SUNICD        IFNE      @SUNICD
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'SUNICD'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0108'
     C*******            EVAL      sUNICDok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Our Rate Change Frequency               *
     C*-----------------------------------------*
     C*
     C***This field is NOT AMENDABLE.
     C*******
     C*****SUICFR        IFNE      @SUICFR
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'SUICFR'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0109'
     C*******            EVAL      sUICFRok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Our Rate Change Day in Month            *
     C*-----------------------------------------*
     C*
     C***This*field is NOT AMENDABLE.
     C*******
     C*****SUICFD        IFNE      @SUICFD
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'SUICFD'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0110'
     C*******            EVAL      sUICFDok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Our Short Term Rate                     *
     C*-----------------------------------------*
     C*
     C***This*field is NOT AMENDABLE.
     C*******
     C*****SUEINR        IFNE      @SUEINR
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'SUEINR'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0111'
     C*******            EVAL      sUEINRok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Our Interest Calculation Basis          *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     SUICBS        IFNE      @SUICBS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SUICBS'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0485'
     C                   EVAL      sUICBSok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Their Currency                          *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     STCUCY        IFNE      @STCUCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STCUCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0370'
     C                   EVAL      sTCUCYok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Their Principal Amount                  *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C*****STPAMT        IFNE      @STPAMT                                                   BUG6876
     C                   CALLB     'ZCMPAMTS'                                                BUG6876
     C                   PARM      STPAMT        ZCMPAMT1                                    BUG6876
     C                   PARM      @STPAMT       ZCMPAMT2                                    BUG6876
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6876
                                                                                             BUG6876
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6876
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STPAMT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0372'
     C                   EVAL      sTPAMTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Their Federal Funds Indicator           *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     STFFI         IFNE      @STFFI
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STFFI '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0396'
     C                   EVAL      sTFFIok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*
     C* Their Base Currency Rate                *
     C*-----------------------------------------*
     C*
     C**  This field was not amendable in DL1602, however for APIs
     C** this presents a problem because if not entered the value
     C** defaults to base currency equivalent. A subsequent amend
     C** would be invalid if front office user did not know
     C** the calculated value of original insert and left the field
     C** blank. If blank field is allowed here the update program
     C** will re-calculate the value based on current BCE which
     C** may have changed, effectively allowing the field to be
     C** amended anyway.
     C** Make field AMENDABLE for now until a better solution can be
     C** found.
     C*
     C***This*field*is*NOT*AMENDABLE.
     C*
     C*****STBCXR        IFNE      @STBCXR
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'STBCXR'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMM0392'
     C*******            EVAL      sTBCXRok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Their Base Rate Code                    *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     STBRTT        IFNE      @STBRTT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STBRTT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0376'
     C                   EVAL      sTBRTTok        = 'N'
     C                   ENDIF
     C*
     C*-----------------------------------------*                                             184363
     C* Thier Spread/Rate                       *                                             184363
     C*-----------------------------------------*                                             184363
     C*                                                                                       184363
     C                   CALLB     'ZCMPAMTS'                                                BUG6876
     C                   PARM      STRTSP        ZCMPAMT1                                    BUG6876
     C                   PARM      @STRTSP       ZCMPAMT2                                    BUG6876
     C                   PARM      'N'           ZCMPAMTDif                                  BUG6876
      *                                                                                      BUG6876
     C** This field is NOT AMENDABLE, if Int. Payment Frq. is changed to 'C'                  184363
     C*                                                                                       184363
     C*****STRTSP        IFNE      @STRTSP                                            184363 BUG6876
     C     ZCMPAMTDif    IFEQ      'Y'                                                       BUG6876
     C     STIPFR        ANDEQ     'C'                                                        184363
     C                   ADD       1             Idx                                          184363
     C                   EVAL      FldNameArr(Idx) = 'STRTSP'                                 184363
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0377'                                184363
     C                   EVAL      StRtSpOK        = 'N'                                      184363
     C                   ENDIF                                                                184363
     C*                                                                                       184363
     C*-----------------------------------------*
     C* Their Rate Fix Days                     *
     C*-----------------------------------------*
     C********
     C***This*field is NOT AMENDABLE.
     C*******
     C*****STFRFD        IFNE      @STFRFD
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'STFRFD'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0107'
     C*******            EVAL      sTFRFDok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Their Rate Change Date                  *
     C*-----------------------------------------*
     C*
     C***This field is NOT AMENDABLE.
     C*******
     C*****STNICD        IFNE      @STNICD
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'STNICD'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0108'
     C*******            EVAL      sTNICDok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Their Rate Change Frequency             *
     C*-----------------------------------------*
     C*
     C***This field is NOT AMENDABLE.
     C*******
     C*****STICFR        IFNE      @STICFR
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'STICFR'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0109'
     C*******            EVAL      sTICFRok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Their Rate Change Day in Month          *
     C*-----------------------------------------*
     C*
     C***This*field is NOT AMENDABLE.
     C*******
     C*****STICFD        IFNE      @STICFD
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'STICFD'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0110'
     C*******            EVAL      sTICFDok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Their Short Term Rate                   *
     C*-----------------------------------------*
     C*
     C***This*field is NOT AMENDABLE.
     C*******
     C*****STEINR        IFNE      @STEINR
     C*******            ADD       1             Idx
     C*******            EVAL      FldNameArr(Idx) = 'STEINR'
     C*******            EVAL      MsgIDArr(Idx)   = 'MMA0111'
     C*******            EVAL      sTEINRok        = 'N'
     C*******            ENDIF
     C*
     C*-----------------------------------------*
     C* Their Interest Calculation Basis        *
     C*-----------------------------------------*
     C*
     C** This field is NOT AMENDABLE.
     C*
     C     STICBS        IFNE      @STICBS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STICBS'
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0485'
     C                   EVAL      sTICBSok        = 'N'
     C                   ENDIF
     C*-----------------------------------------*                                             CDL038
     C* Class                                   *                                             CDL038
     C*-----------------------------------------*                                             CDL038
     C*                                                                                       CDL038
     C** This field is amendable only if the deal is complete                                 CDL038
     C** and if CDL039 is ON                                                                  CDL039
     C*                                                                                       CDL038
     C     FIDSTS        IFNE      'C'                                                        CDL038
     C     SCLAS         ANDNE     @SCLAS                                                     CDL038
     C     CDL039        ANDEQ     'N'                                                        CDL039
     C                   ADD       1             Idx                                          CDL038
     C                   EVAL      FldNameArr(Idx) = 'SCLAS'                                  CDL038
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0258'                                CDL038
     C                   EVAL      sCLASok         = 'N'                                      CDL038
     C                   ENDIF                                                                CDL038
     C*
     C*-----------------------------------------------------------------*
     C* The following fields are currently UNCONDITIONALLY AMENDABLE    *
     C* so no checking is done here.                                    *
     C*-----------------------------------------------------------------*
     C*
     C** SLNKDN - Linked Reference Number
     C** SMDAT  - Maturity Date
     C** STAXI  - Taxable Indicator
     C** SORBR  - Originating Branch
     C** SVDEI  - Value Date Exchange Indicator
     C** SMDEI  - Maturity Date Exchange Indicator
     C** SPDEI  - Principal Change Date Exchange Indicator
     C** SURTSP - Our Rate/Spread
     C** SUSPIN - Our Spread Indicator
     C** SUNIPD - Our Interest Payment Date
     C** SUIPFR - Our Interest Payment Frequency
     C** SUIPFD - Our Interest Payment Day in Month
     C** SUBCXR - Our Base Currency Rate ** See note above **
     C** STRTSP - Their Rate/Spread
     C** STSPIN - Their Spread Indicator
     C** STNIPD - Their Interest Payment Date
     C** STIPFR - Their Interest Payment Frequency
     C** STIPFD - Their Interest Payment Day in Month
     C** STBCXR - Their  Base Currency Rate ** See note above **
     C** + all Settlement Fields
     C*
     C     COMPTRANS9    ENDSR
      *****************************************************************
      /EJECT                                                              AU
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
      * Deal Type
     C     sDTYPok       IFEQ      'N'
     C                   MOVEL     @SDTYP        SDTYP
     C                   END
      *
      * Deal SubType
     C     sDLSTok       IFEQ      'N'
     C                   MOVEL     @SDLST        SDLST
     C                   END
      *
      * Deal Date
     C     sDDATok       IFEQ      'N'
     C                   MOVEL     @SDDAT        SDDAT
     C                   END
      *
      * Branch Code
     C     sBRCAok       IFEQ      'N'
     C                   MOVEL     @SBRCA        SBRCA
     C                   END
      *
      * Broker Code
     C     sBRKCok       IFEQ      'N'
     C                   MOVEL     @SBRKC        SBRKC
     C                   END
      *
      * Brokerage
     C     sBAGEok       IFEQ      'N'
     C                   MOVEL     @SBAGE        SBAGE
     C                   END
      *
      * Customer
     C     sCNUMok       IFEQ      'N'
     C                   MOVEL     @SCNUM        SCNUM
     C                   END
      *
      * Value Date
     C     sVDATok       IFEQ      'N'
     C                   MOVEL     @SVDAT        SVDAT
     C                   END
      *
      * Account Sequence Number
     C     sCDASok       IFEQ      'N'
     C                   MOVEL     @SCDAS        SCDAS
     C                   END
      *
      * Book Code
     C     sBOKCok       IFEQ      'N'
     C                   MOVEL     @SBOKC        SBOKC
     C                   END
      *
      * Profit Centre
     C     sPRFCok       IFEQ      'N'
     C                   MOVEL     @SPRFC        SPRFC
     C                   END
      *
      * Our Currency
     C     sUCUCYok      IFEQ      'N'
     C                   MOVEL     @SUCUCY       SUCUCY
     C                   END
      *
      * Our Principal Deal Amount
     C     sUPAMTok      IFEQ      'N'
     C                   MOVEL     @SUPAMT       SUPAMT
     C                   END
      *
      * Our Federal Funds Indicator
     C     sUFFIok       IFEQ      'N'
     C                   MOVEL     @SUFFI        SUFFI
     C                   END
      *
      * Our Base Currency Rate
     C     sUBCXRok      IFEQ      'N'
     C                   MOVEL     @SUBCXR       SUBCXR
     C                   END
      *
     C* Our Base Rate Code
     C     sUBRTTok      IFEQ      'N'
     C                   MOVEL     @SUBRTT       SUBRTT
     C                   END
      *
     C* Our Spread/Rate                                                                      184363
     C     SuRtSpOK      IFEQ      'N'                                                       184363
     C                   MOVEL     @SURTSP       SURTSP                                      184363
     C                   END                                                                 184363
      *                                                                                      184363
     C* Our Rate Fix Days
     C     sUFRFDok      IFEQ      'N'
     C                   MOVEL     @SUFRFD       SUFRFD
     C                   END
      *
     C* Our Rate Change Date
     C     sUNICDok      IFEQ      'N'
     C                   MOVEL     @SUNICD       SUNICD
     C                   END
      *
     C* Our Rate Change Frequency
     C     sUICFRok      IFEQ      'N'
     C                   MOVEL     @SUICFR       SUICFR
     C                   END
      *
     C* Our Rate Change Day in Month
     C     sUICFDok      IFEQ      'N'
     C                   MOVEL     @SUICFD       SUICFD
     C                   END
      *
     C* Our Short Term Rate
     C     sUEINRok      IFEQ      'N'
     C                   MOVEL     @SUEINR       SUEINR
     C                   END
      *
     C* Our Interest Calculation Basis
     C     sUICBSok      IFEQ      'N'
     C                   MOVEL     @SUICBS       SUICBS
     C                   END
      *
      * Their Currency
     C     sTCUCYok      IFEQ      'N'
     C                   MOVEL     @STCUCY       STCUCY
     C                   END
      *
      * Their Principal Deal Amount
     C     sTPAMTok      IFEQ      'N'
     C                   MOVEL     @STPAMT       STPAMT
     C                   END
      *
      * Their Federal Funds Indicator
     C     sTFFIok       IFEQ      'N'
     C                   MOVEL     @STFFI        STFFI
     C                   END
      *
      * Their Base Currency Rate
     C     sTBCXRok      IFEQ      'N'
     C                   MOVEL     @STBCXR       STBCXR
     C                   END
      *
     C* Their Base Rate Code
     C     sTBRTTok      IFEQ      'N'
     C                   MOVEL     @STBRTT       STBRTT
     C                   END
      *
     C* Their Spread/Rate                                                                    184363
     C     StRtSpOK      IFEQ      'N'                                                       184363
     C                   MOVEL     @STRTSP       STRTSP                                      184363
     C                   END                                                                 184363
      *                                                                                      184363
     C* Their Rate Fix Days
     C     sTFRFDok      IFEQ      'N'
     C                   MOVEL     @STFRFD       STFRFD
     C                   END
      *
     C* Their Rate Change Date
     C     sTNICDok      IFEQ      'N'
     C                   MOVEL     @STNICD       STNICD
     C                   END
      *
     C* Their Rate Change Frequency
     C     sTICFRok      IFEQ      'N'
     C                   MOVEL     @STICFR       STICFR
     C                   END
      *
     C* Their Rate Change Day in Month
     C     sTICFDok      IFEQ      'N'
     C                   MOVEL     @STICFD       STICFD
     C                   END
      *
     C* Their Short Term Rate
     C     sTEINRok      IFEQ      'N'
     C                   MOVEL     @STEINR       STEINR
     C                   END
      *
     C* Their Interest Calculation Basis
     C     sTICBSok      IFEQ      'N'
     C                   MOVEL     @STICBS       STICBS
     C                   END
      *                                                                                       CDL038
      * Class                                                                                 CDL038
     C     sCLASok       IFEQ      'N'                                                        CDL038
     C                   MOVEL     @SCLAS        SCLAS                                        CDL038
     C                   END                                                                  CDL038
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************   AU
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
      *
      * Current Deal in Screen Format
     C                   PARM                    DealScnFmt
      *
      * Current Deal in file format
     C                   PARM                    DealFilFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
 
      ** Initialise program name
      *
     C                   MOVEL     'IRCIRSAMD'   DBPGM
 
     C**  GET RUNDAT to access MULTI-BRANCHING flag.
     C**
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      **
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      **
      ** Access Dealing ICD file via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C*
     C** Access Portfolio Management ICD details if PM swithed on.
     C*
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   END
      *                                                                                       CDL039
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF CDL039 IS INSTALLED                          CDL039
      *                                                                                       CDL039
     C                   CALL      'AOSARDR0'                                                 CDL039
     C                   PARM      *BLANKS       @RTCD                                        CDL039
     C                   PARM      '*VERIFY'     @OPTN                                        CDL039
     C                   PARM      'CDL039'      @SARD             6                          CDL039
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL039
      *                                                                                       CDL039
     C     @RTCD         IFEQ      *BLANK                                                     CDL039
     C                   MOVEL     'Y'           CDL039            1                          CDL039
     C                   ELSE                                                                 CDL039
     C                   MOVEL     'N'           CDL039                                       CDL039
     C                   END                                                                  CDL039
     C*
     C                   ENDSR
 
      *****************************************************************
     C*
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** @M  USED BY SR. MM1004 - DAYS IN A MONTH
312831303130313130313031
