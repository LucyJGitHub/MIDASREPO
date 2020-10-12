     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments schedule - retrieve')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCRTV - Repayment schedule - Retrieve                    *
      *                                                               *
      *  Function:  This module retrieves a Repayment schedule from   *
      *             the database. As it does so, it validates the     *
      *             action code, the loan reference, the value date   *
      *             and the sequence                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 MD021356           Date 24Jul13               *
      *                 AR1046444          Date 18Jun13               *
      *                 MD000091           Date 10May13               *
      *                 AR756255           Date 07Nov12               *
      *                 AR582920           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CLE056             Date 17Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241648             Date 31Aug06               *
      *                 240968             Date 10Jul06               *
      *                 BUG11559           Date 30Jun06               *
      *                 CSD027A            Date 09May06               *
      *                 BUG8550            Date 07Oct05               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 BUG8241            Date 23Aug05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG3760            Date 01Aug04               *
      *                 TDA070 (Reopen)    Date 26Mar04               *
      *                 TDA070             Date 26Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CSF002             Date 11Aug03               *
      *                 CAP079  *CREATE    Date 02Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD021356 - Impossible to input repayment schedule for parti- *
      *             cipation sold; pattern fix after AR1069948        *
      *  AR1046444 - Don't allow insert of repayment sched against    *
      *              PDCL loan. (Child: AR1046445)                    *
      *  MD000091 - Event Codes Substitution                          *
      *  AR756255 - Settlement account is incorrectly populated.      *
      *             Use OMDB/OSDB in populating the settlement branch *
      *             (Child: AR756256)                                 *
      *  AR582920 - Repayment Schedule input error - invalid          *
      *             settlement (Child: AR582921)                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CLE056 - Authorisation on Lending Transactions               *
      *  241648 - Allow repayment schedule wtih value date on maturity*
      *           date.                                               *
      *  240968 - If system value CLAuthORED = 'Y', when authorising  *
      *           do not check insert user is different to authorise  *
      *           user if RPSC was amended after original entry date  *
      *  BUG11559 - RPSC: Wrong settlement default.                   *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  CLE106 - Syndications Manager                                *
      *  BUG8241- OME RPG patch for delivery                          *
      *  CSC024 - Open Month End                                      *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs                                       *
      *  TDA070 (Reopen) - Complete account does not have branch      *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CSF002 - Global layer.                                       *
      *         - Replace previous ZBACT* parameters with the new     *
      *           unique code.                                        *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
     FLERPSCL0  IF   E           K DISK    INFSR(*PSSR)
      ***  Repayment schedule by front office id
     F                                     RENAME(LOAMSDKF:LOAMSDKFOI)
      *
     FLELOAML0  IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Repayment schedule file
     F                                     RENAME(LOAMSDKF:LOAMSDKRS)
     F                                     PREFIX(LO_)
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
     F                                     PREFIX(CL_)
      *                                                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
      **  Compliance Watch Hit List File                                                     BUG3760
      *
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
     D*PSysVal1        C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
     D CLAuthORED      C                   Const('CLAuthORED')                                240968
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for General Ledger details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *                                                                                      BUG3760
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                 BUG3760
      ***  SAR Details                                                                       BUG3760
      *
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      *** Data Structure for Watch List Checking Details                                     BUG3760
      *                                                                                      BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
      ** Midas SD Watch List Configuration Data File                                         BUG3760
      *                                                                                      BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
      ** 24X7 status data area                                                               BUG3760
      *                                                                                      BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
      ** SD data area                                                                        BUG3760
      *                                                                                      BUG3760
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D PRcvParm      E DS                  EXTNAME(SDESSRPD)                                  TDA070
     D***WComplete             15     15                                              TDA070 CSF011A
     D**WComplete             16     16                                             CSF011A AR582920
      ***  Screen Receive Instructions                                                        TDA070
      *                                                                                       TDA070
     D PPayParm      E DS                  EXTNAME(SDESSPPD)                                 BUG8529
      ***  Screen Pay Instructions                                                           BUG8529
      *                                                                                      BUG8529
     D ZMUSER          DS            17
     D  BRC                   11     13
     D  DEPT                  14     16
      *
     D CRpScFilFmt   E DS                  EXTNAME(LOAMSDK)
     D                                     PREFIX(LO_)
      ***  Repayment in File Format
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
                                                                                             BUG3760
     D CSC011          S              1                                                      BUG3760
     D CCF001          S              1                                                      BUG3760
     D CSD015          S              1                                                      BUG3760
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D PRetCode        S              7A                                                      CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
     D CLE056          S              1A                                                      CLE056
      *                                                                                       CLE148
     D RTNCDE          S              7A                                                      CLE148
     D SVALK1          S             20A                                                      CLE148
     D SVAL1           S            200A                                                      CLE148
     D SVALK2          S             20A                                                      CLE148
     D SVAL2           S            200A                                                      CLE148
     D SVALK3          S             20A                                                      CLE148
     D SVAL3           S            200A                                                      CLE148
     D SVALK4          S             20A                                                      CLE148
     D SVAL4           S            200A                                                      CLE148
     D SVALK5          S             20A                                                      CLE148
     D SVAL5           S            200A                                                      CLE148
     D SVALK6          S             20A                                                      CLE148
     D SVAL6           S            200A                                                      CLE148
     D SVALK7          S             20A                                                      CLE148
     D SVAL7           S            200A                                                      CLE148
     D SVALK8          S             20A                                                      CLE148
     D SVAL8           S            200A                                                      CLE148
     D SVALK9          S             20A                                                      CLE148
     D SVAL9           S            200A                                                      CLE148
     D SVALK0          S             20A                                                      CLE148
     D SVAL10          S            200A                                                      CLE148
      *
     D wLoanAlpha      S              1A                                                      CLE148
     D PLNRF           S              6A                                                      CLE148
     D PValid          S              6A                                                      CLE148
     D PChkDigit       S              1A                                                      CLE148
     D PData           S              2A                                                      CLE148

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) PREFIX(CL_)                     MD021356
      *                                                                                     MD021356
      ** Loan in File Format CL                                                             MD021356
      *                                                                                     MD021356
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT

      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *inzsr is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *                                                                                      BUG8550
      ***  Get ZMUSER to access default branch.                                              BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                      BUG8550

      ** Check whether user is a web browser user, if so overwrite                            CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       USER             10                          CAP084
      *                                                                                       CAP084
     C                   IF        USER <> *BLANKS                                            CAP084
     C                   EVAL      PSUSER = USER                                              CAP084
     C                   ENDIF                                                                CAP084
      *
      ***  Initialisation
      *
     C                   EXSR      INIT
                                                                                             BUG8241
      ** If the mode is not 'Front Office Transaction Interface'                             BUG8241
      ** Do authorisations are required                                                      BUG8241
                                                                                             BUG8241
     C                   IF        ModeofOp = *BLANKS                                        BUG8241
     C                   EVAL      LO_AUTH = *BLANKS                                         BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
      *
      ***  If the mode is 'FRONT OFFICE TRANSACTION INTERFACE'
      ***  do (EXTRA) validation for front office transaction interface
      *
     C     ModeofOp      IFEQ      '*FRONT'
      *
     C                   EXSR      VFRNT
      *
      ***  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C     OKSEQN        OREQ      'N'
     C     OKVDAT        OREQ      'N'
     C                   RETURN
     C                   END
     C                   END
      *
      ***  Validate action code, value date, loan number and sequence
      *
     C                   EXSR      VAL
      *
      ***  Carry out no further validation if errors occurred
      *    ==================================================
      *
     C     OKACTN        IFEQ      'N'
     C     OKLNRF        OREQ      'N'
     C     OKSEQN        OREQ      'N'
     C     OKVDAT        OREQ      'N'
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EXSR      ACSSEC
     C                   END
      *
      ***  Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - Validation for front office transaction interface
      *****************************************************************
     C     VFRNT         BEGSR
      *
      ***  Error if action code is not 'I', 'A', 'R' or 'X'
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0603'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  Error if front office transaction ID is blank
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0604'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  Access Repayment with front office transaction ID
      *
     C     FOTRID        CHAIN(N)  LOAMSDKFOI                         99
      *
      ***  If insert
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Front office transaction ID can't be present already
      *
     C     *IN99         IFEQ      '0'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0605'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C                   ELSE
      *
      ***  If not insert, front office transaction ID must be present
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LEL0606'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(FOTRID)                    MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
      ***  If not insert, update Midas loan number, the sequence
      ***  and value date
      *
     C                   MOVEL     LNRF          DDLNRF
     C                   MOVEL     LASN          DDSEQN
      *
     C                   MOVE      VDAT          ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     DDVDAT
      *
     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - Validation of action code, loan number, sequence
      *       and value date
      *****************************************************************
     C     VAL           BEGSR
      *
      ***  Validate Action code
      *
      ***  Action code must be I, E, A, X or R
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'E'
     C     DDACTN        ANDNE     'A'
     C     DDACTN        ANDNE     'X'
     C     DDACTN        ANDNE     'R'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LES0021'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C*****DDLNRF        IFNE      *BLANKS                                                    CSC024
      *
      ***  Validate loan Number
      *
      ***  Loan number must be numeric
      *
     C                   If        wLoanAlpha = 'N'                                           CLE148
      *                                                                                       CLE148
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVEL     DDLNRF        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM      *BLANKS       ZRVAL            16
      *
     C     @RTCD         IFNE      *BLANKS
     C     DDLNRF        OREQ      *BLANKS                                                    CSC024
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0030'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   EVAL      PLNRF = DDLNRF                                             CLE148
     C                   EVAL      PValid = *BLANKS                                           CLE148
     C                   EVAL      PChkDigit = *BLANK                                         CLE148
     C                   EVAL      PData = *BLANKS                                            CLE148
      *                                                                                       CLE148
     C                   CALL(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   IF        PValid <> *BLANKS                                          CLE148
     C                   EVAL      Ix = Ix + 1                                                CLE148
     C                   EVAL      OKLNRF = 'N'                                               CLE148
     C                   EVAL      FldNameArr(Ix) = 'DDLNRF'                                  CLE148
     C                   EVAL      MsgIdArr(Ix) = '5045549'                                   CLE148
     C                   GOTO      EVAL                                                       CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C                   ENDIF                                                                CLE148
      *
      ***  Loan must exist on loans file as live
      *
     C                   MOVE      DDLNRF        K@LNRF
     C                   MOVE      'A'           K@RCDT
      *
     C     K@LOAN        CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0025'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *                                                                                       TDA070
     C                   IF        DDACTN = 'I'                                               TDA070
     C                   IF        CL_RSTM <> 0                                               TDA070
     C                   MOVEL     CL_RSTM       DDRSTM                                       TDA070
     C                   ENDIF                                                                TDA070
      *                                                                                     AR756255
     C     CL_PTYP       IFEQ      66                                                       AR756255
     C     CL_PTYP       OREQ      67                                                       AR756255
     C     CL_PTYP       OREQ      69                                                       AR756255
     C     CL_PTYP       OREQ      72                                                       AR756255
     C                   MOVEL     CL_OSDB       WWSETB            3                        AR756255
     C                   ELSE                                                               AR756255
     C                   MOVEL     CL_OMDB       WWSETB                                     AR756255
     C                   ENDIF                                                              AR756255
      *                                                                                     AR756255
     C                   IF        CL_RONS <> *BLANKS AND                                     TDA070
     C**********                   CL_BRCA <> *BLANKS                                TDA070 AR756255
     C                             WWSETB <> *BLANKS                                        AR756255
     C**********         IF        WComplete <> *BLANKS                              TDA070 AR582920
     C                   IF        CL_RSTM = 05                                             AR582920
     C                   MOVE      CL_RONS       DDRONX                                       TDA070
     C**********         MOVEL     CL_BRCA       DDRONX                              TDA070 AR756255
     C                   MOVEL     WWSETB        DDRONX                                     AR756255
     C                   ELSE                                                                 TDA070
     C                   EVAL      DDRONX = CL_RONS                                           TDA070
     C                   ENDIF                                                                TDA070
     C                   ENDIF                                                                TDA070
     C**********         IF        CL_ROCN <> 0                                        TDA070 CSD027
     C**********         IF        CL_ROCN <> *BLANKS                                CSD027 BUG11559
     C                   IF        CL_ROCN <> *BLANKS AND                                   BUG11559
     C                             CL_ROCN <> '000000'                                      BUG11559
     C                   MOVEL     CL_ROCN       DDROCN                                       TDA070
     C                   ENDIF                                                                TDA070
     C**********         IF        CL_ROBN <> 0                                        TDA070 CSD027
     C**********         IF        CL_ROBN <> *BLANKS                                CSD027 BUG11559
     C                   IF        CL_ROBN <> *BLANKS AND                                   BUG11559
     C                             CL_ROBN <> '000000'                                      BUG11559
     C                   MOVEL     CL_ROBN       DDROBN                                       TDA070
     C                   ENDIF                                                                TDA070
     C                   IF        CL_RIBN <> *BLANKS                                         TDA070
     C                   EVAL      DDRIBN = CL_RIBN                                           TDA070
     C                   ENDIF                                                                TDA070
      *                                                                                      BUG8529
      * Setup the pay settle fields                                                          BUG8529
     C                   EVAL      DDPSCY = CL_PSCY                                          BUG8529
     C                   IF        CL_PSTM <> 0                                              BUG8529
     C                   MOVEL     CL_PSTM       DDPSTM                                      BUG8529
     C                   ENDIF                                                               BUG8529
     C                   EVAL      DDPONX = CL_PONS                                          BUG8529
     C                   EVAL      DDRVNO = CL_RVNO                                          BUG8529
     C                   EVAL      DDCVMR = CL_CVMR                                          BUG8529
     C**********         IF        CL_POCN <> 0                                      BUG8529 CSD027A
     C                   IF        CL_POCN <> *Blanks                                        CSD027A
     C                   MOVEL     CL_POCN       DDPOCN                                      BUG8529
     C                   ENDIF                                                               BUG8529
     C**********         IF        CL_POBN <> 0                                      BUG8529 CSD027A
     C                   IF        CL_POBN <> *Blanks                                        CSD027A
     C                   MOVEL     CL_POBN       DDPOBN                                      BUG8529
     C                   ENDIF                                                               BUG8529
     C                   EVAL      DDRCRN = CL_RCRN                                          BUG8529
     C                   EVAL      DDRCRA = CL_RCRA                                          BUG8529
     C                   EVAL      DDPIBN = CL_PIBN                                          BUG8529
     C                   EVAL      DDPIBA = CL_PIBA                                          BUG8529
     C                   EVAL      DDAWBN = CL_AWBN                                          BUG8529
     C                   EVAL      DDAWBA = CL_AWBA                                          BUG8529
     C                   EVAL      DDBENN = CL_BENN                                          BUG8529
     C                   EVAL      DDBENA = CL_BENA                                          BUG8529
     C                   EVAL      DDDTP1 = CL_DTP1                                          BUG8529
     C                   EVAL      DDDTP2 = CL_DTP2                                          BUG8529
     C                   EVAL      DDDTP3 = CL_DTP3                                          BUG8529
     C                   EVAL      DDDTP4 = CL_DTP4                                          BUG8529
     C                   EVAL      DDIC72 = CL_ICCY                                          BUG8529
     C                   EVAL      DDBTB1 = CL_BTB1                                          BUG8529
     C                   EVAL      DDBTB2 = CL_BTB2                                          BUG8529
     C                   EVAL      DDBTB3 = CL_BTB3                                          BUG8529
     C                   EVAL      DDBTB4 = CL_BTB4                                          BUG8529
     C                   EVAL      DDBTB5 = CL_BTB5                                          BUG8529
     C                   EVAL      DDBTB6 = CL_BTB6                                          BUG8529
     C                   ENDIF                                                                TDA070
      *
      ***  Loan should not have status of Reversed or Matured
      *
     C     CL_RECI       IFEQ      'R'
     C     CL_RECI       OREQ      'M'
      *
     C     CL_RECI       IFNE      'M'
     C     CL_RATF       ORNE      'Y'
     C     CLE005        ORNE      'Y'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0025'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Processing type of loan should not be 63, 65, 68, and 70
      *
     C     CL_PTYP       IFEQ      63
     C     CL_PTYP       OREQ      65
     C     CL_PTYP       OREQ      67
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0026'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Loan should not be a guarantee or risk loan
      *
     C     CLE005        IFEQ      'N'
     C     CL_PTYP       IFEQ      68
     C     CL_PTYP       OREQ      69
     C     CL_PTYP       OREQ      71
     C     CL_PTYP       OREQ      72
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0041'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAP084
      ** When CLE028 is installed, Repayment schedules are not allowed                        CAP084
      ** for flat rate personal loans                                                         CAP084
      *                                                                                       CAP084
     C     CLE028        IFEQ      'Y'                                                        CAP084
     C     CL_PTYP       ANDEQ     80                                                         CAP084
     C                   MOVE      'N'           OKLNRF                                       CAP084
     C                   ADD       1             Ix                                           CAP084
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               CAP084
     C                   MOVEL     'LES0308'     MsgIdArr(Ix)                                 CAP084
     C                   GOTO      EVAL                                                       CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                    AR1046444
      ** Loan must not be PDCL.                                                            AR1046444
      *                                                                                    AR1046444
     C                   MOVEL     CL_LTYP       LTYP1             1                       AR1046444
     C     LTYP1         IFEQ      'X'                                                     AR1046444
     C     LTYP1         OREQ      'Y'                                                     AR1046444
     C     LTYP1         OREQ      'Z'                                                     AR1046444
     C                   MOVE      'N'           OKLNRF                                    AR1046444
     C                   ADD       1             Ix                                        AR1046444
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                            AR1046444
     C                   MOVEL     '5045934'     MsgIdArr(Ix)                              AR1046444
     C                   GOTO      EVAL                                                    AR1046444
     C                   ENDIF                                                             AR1046444
      *
      ***  Allow action 'X' if CLE002 = Y and Repayment Schedule Auth = Y
      *
     C     DDACTN        IFEQ      'X'
     C     CLE002        IFNE      'Y'
     C     BPREAU        ORNE      'Y'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'LES0037'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *
     C**********         ENDIF                                                                CSC024
      *
      ***  Validate Sequence Number
      *
      ***  Sequence number should be blank if action is Insert
      *
     C     DDSEQN        IFEQ      '000'
     C                   MOVE      *BLANKS       DDSEQN
     C                   ENDIF
      *
     C     DDSEQN        IFEQ      *BLANKS
     C     DDACTN        ANDNE     'I'
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
     C                   MOVEL     'LES0107'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Sequence number should not be blank if action is not Insert
      *
     C     DDSEQN        IFNE      *BLANKS
     C     DDACTN        ANDEQ     'I'
                                                                                              CSC024
      ***Allow*entry*for*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
                                                                                              CSC024
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
     C                   MOVEL     'LES0108'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ENDIF
      *
      ***  Sequence number should be numeric
      *
     C     DDSEQN        IFNE      *BLANKS
     C                   MOVEL     DDSEQN        WFLD4N            3 0
     C                   MOVEL     WFLD4N        WFLD3A            3
     C     DDSEQN        IFNE      WFLD3A
     C                   MOVE      'N'           OKSEQN
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN'      FldNameArr(Ix)
     C                   MOVEL     'LES0031'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
     C                   ENDIF
      *
      ***  Validate Value Date
      *
     C                   MOVE      *BLANK        WVERR             1
      *
      ***  Value date should not be blanks
      *
     C     DDVDAT        IFEQ      *BLANKS
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0105'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Value date should be numeric and in valid date format
      *
     C                   MOVEL     DDVDAT        WFLD7N            6 0
     C                   MOVEL     WFLD7N        WFLD6A            6
     C     DDVDAT        IFNE      WFLD6A
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0105'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   MOVE      DDVDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C     ZERR          IFNE      *BLANKS
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0105'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   Z-ADD     ZDAYNO        WVDAYN            5 0
      *
      ***  If action is Insert
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Value date should not be earlier than start date and not later
      ***  than maturity date
      *
     C     WVDAYN        IFLE      CL_VDAT
     C     CL_LPFI       ANDEQ     *BLANKS                                                    CLE106
     C     WVDAYN        ORLE      CL_VDAT                                                    CLE106
     C     CL_LPFI       ANDEQ     'A'                                                        CLE106
     C     WVDAYN        ORLT      CL_VDAT                                                    CLE106
     C     CL_MDAT       ORGT      *ZERO
     C*****WVDAYN        ANDGE     CL_MDAT                                                    241648
     C     WVDAYN        ANDGT     CL_MDAT                                                    241648
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0106'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  Extra validation for value date
      *
      ***  Calculate Back value limit
      *
     C     BJRDNB        SUB       BJBVPD        WBKLIM            5 0
      *
     C     CLE003        IFEQ      'N'
      *
     C     CL_SLID       IFLT      WBKLIM
     C     WVDAYN        ANDLT     CL_SLID
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0111'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C     WVDAYN        IFLT      WBKLIM
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0111'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If CLE014 is on, value date must not be between multi-currency
      ***  rollover date and the working date after it.
      *
     C     CLE014        IFEQ      'Y'
     C     CL_RLDT       ANDNE     *ZERO
      *
     C                   MOVE      'B'           K@RCDT
     C     K@LOAN        CHAIN(N)  CLOANCKF                           99
      *
     C     *IN99         IFEQ      *OFF
     C     CL_NCCY       ANDNE     *BLANKS
     C     CL_NCCY       ANDNE     CL_CCY
      *
     C                   Z-ADD     CL_RLDT       ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      *BLANKS       ZLOC
     C                   Z-ADD     1             ZNRDYS
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
     C     WVDAYN        IFGT      CL_RLDT
     C     WVDAYN        ANDLT     ZDYNBR
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0138'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ** Back-valued repayment schedule is prohibited if rollover
      ** details exists
      *
     C     CL_RLDT       IFLT      BJRDNB
     C     WVDAYN        ANDLT     BJRDNB
     C     WVDAYN        ANDGT     CL_RLDT
     C                   MOVE      'N'           OKVDAT
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'LES0139'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDACTN        IFNE      'I'
      *
      ***  Other Validation
      *
      ***  Access loan amendment record
      *
     C                   MOVE      DDLNRF        K@LNRF
     C                   MOVE      WVDAYN        K@VDAT
     C                   MOVE      DDSEQN        K@LASN
      *
     C     K@LOAM        CHAIN(N)  LELOAML0                           99
      *
      ***  Error if loan amendment not found
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0176'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  If not RE, invalid loan amendment type
      *
     C     LO_AMTP       IFNE      'RE'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0176'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  If action is Authorise, record must exist with status of
      ***  'C' Complete or 'R' Reauthorisation required
      *
     C     DDACTN        IFEQ      'X'
     C     LO_ASTS       ANDNE     'C'
     C     LO_ASTS       ANDNE     'R'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0022'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'R'
     C     LO_XASQ       ANDNE     0
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0022'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   ENDIF
      *
      ***  If action is Authorise, authorising user must not be the
      ***  same as the Inserting/Amending user
      ***  Unless CLE056 is enabled and not day of input and not last amender                 CLE056
      *
     C     DDACTN        IFEQ      'X'
      * If system value CLAuthORED = 'Y' and last amend date is later than                    240968
      * original entry date then allow authorise user to be same as insert user               240968
      *                                                                                       240968
     C     ATHORED       IFEQ      'Y'                                                        240968
     C     LO_LCD        ANDGT     LO_ORED                                                    240968
     C     LO_CHTP       ANDEQ     'A'                                                        240968
     C     BJRDNB        ANDGT     LO_ORED                                                    240968
     C     PSUser        IFEQ      LO_AUSR                                                    240968
     C                   MOVE      'N'           OKLNRF                                       240968
     C                   ADD       1             Ix                                           240968
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                               240968
     C                   MOVEL     'LES0023'     MsgIdArr(Ix)                                 240968
     C                   GOTO      EVAL                                                       240968
     C                   END                                                                  240968
      *                                                                                       240968
     C                   ELSE                                                                 240968
     C     LO_AUSR       IFEQ      PsUser
     C     LO_IUSR       OREQ      PsUser
      *                                                                                       CLE056
     C                   If        (CLE056 = 'N') or                                          CLE056
     C                             (CLE056 = 'Y' and LO_ORED = BJRDNB                         CLE056
     C                                           and PSUser = LO_IUSR) or                     CLE056
     C                             (CLE056 = 'Y' and LO_LCD = BJRDNB and                      CLE056
     C                              LO_CHTP = 'A' and PSUser = LO_AUSR)                       CLE056
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0023'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   EndIf                                                                CLE056
     C                   ENDIF
     C                   ENDIF                                                                240968
     C                   ENDIF
      *
      ***  If Reversed record found, display as enquiry
      *
     C     LO_AMTP       IFEQ      'RE'
     C     LO_RECI       ANDEQ     'R'
     C     DDACTN        ANDNE     'E'
     C                   MOVE      'E'           DDACTN
      *
      ***  Return error message if on Batch mode
      *
     C     PMODE         IFEQ      '0'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     'LES0022'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                      BUG3760
      ** If Watch List Checking Applied                                                      BUG3760
      *                                                                                      BUG3760
     C     CSD015        IFEQ      'Y'                                                       BUG3760
     C     W1EWLC        ANDEQ     'Y'                                                       BUG3760
     C     CLE002        ANDEQ     'Y'                                                       BUG3760
     C     BPREAU        ANDEQ     'Y'                                                       BUG3760
     C     DDACTN        ANDEQ     'X'                                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WKIDEN           40                         BUG3760
     C                   MOVEL     *BLANKS       WLNRF             6                         BUG3760
     C                   MOVEL     *BLANKS       WVDAT             5                         BUG3760
     C                   MOVEL     *BLANKS       WLASN             3                         BUG3760
     C                   MOVEL     *BLANKS       KFUNT                                       BUG3760
     C                   MOVEL     *BLANKS       KIDEN                                       BUG3760
     C                   MOVEL     *BLANKS       KBRCH                                       BUG3760
     C                   MOVE      *OFF          *IN39                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVE      LNRF          WLNRF                                       BUG3760
     C                   MOVE      VDAT          WVDAT                                       BUG3760
     C                   MOVE      LASN          WLASN                                       BUG3760
     C     WLNRF         CAT       WVDAT:0       WKIDEN                                      BUG3760
     C                   CAT       WLASN:0       WKIDEN                                      BUG3760
      *                                                                                      BUG3760
      ** If 24X7 is not installed or the suport system is off.                               BUG3760
      *                                                                                      BUG3760
     C     CSC011        IFNE      'Y'                                                       BUG3760
     C     S1MAIN        OREQ      LIBR                                                      BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'LOAMSDK'     KFUNT                                       BUG3760
     C                   MOVEL     WKIDEN        KIDEN                                       BUG3760
     C                   MOVEL     BRCA          KBRCH                                       BUG3760
     C     CWHTKY        CHAIN     SDCWHTL1                           39                     BUG3760
      *                                                                                      BUG3760
      ** If record found, diplay error message 'Trade details being                          BUG3760
      ** reviewed by Compliance Officer'                                                     BUG3760
      *                                                                                      BUG3760
     C     *IN39         IFEQ      *OFF                                                      BUG3760
     C     W3TREL        ANDNE     'Y'                                                       BUG3760
     C                   MOVEA     '1111'        *IN(31)                                     BUG3760
     C                   MOVE      'N'           OKLNRF                                      BUG3760
     C                   ADD       1             Ix                                          BUG3760
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)                              BUG3760
     C                   MOVEL     'LEL0564'     MsgIdArr(Ix)                                BUG3760
     C                   GOTO      EVAL                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSEC - Access security checking
      *****************************************************************
     C     ACSSEC        BEGSR
      *
      ***  Validate User Authority on Action/Branch
      *
     C                   MOVE      *BLANK        WAERR             1
      *
      ***  For single branch system, check if user is authorised to the
      ***  action
      *
     C                   Z-ADD     *ZERO         @ERR
     C     BGMBIN        IFEQ      'N'
     C     PMODE         IFEQ      '0'
     C                   CALL      'ZBACTU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM                    @USER
     C**********         PARM                    @ZMGRP                                       CSF002
     C**********         PARM                    @ZICDE                                       CSF002
     C                   PARM                    @UNQCDE                                      CSF002
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVACTU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM                    @ERR
     C                   ENDIF
     C     @ERR          IFNE      0
     C                   MOVEL     'LES0302'     SaveMsgIdArr      7
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C                   ENDIF
      *
      ***  For multibranching system, and action codes A/E/R, branch code
      ***  must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'I'
     C                   MOVE      DDACTN        @ZACTN
     C                   MOVE      CL_BRCA       @ZBR
     C     PMODE         IFEQ      '0'
     C                   CALL      'ZBACTBU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM                    @ZBR
     C                   PARM                    @USER            10
     C**********         PARM                    @ZMGRP            4 0                        CSF002
     C**********         PARM                    @ZICDE            4                          CSF002
     C                   PARM                    @UNQCDE          10                          CSF002
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @ZBR              3
     C                   PARM                    @ERR              1 0
     C                   ENDIF
     C     @ERR          IFEQ      1
     C                   MOVEL     'LES0303'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   MOVEL     'LES0304'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C                   ENDIF
      *
      ***  For multibranching system, and action codes A/R, originating
      ***  branch must be valid for user
      *
     C     BGMBIN        IFEQ      'Y'
     C     DDACTN        ANDNE     'E'
     C     BKOBUV        ANDEQ     'Y'
     C     BKOBRU        ANDEQ     'Y'
     C     PMODE         IFEQ      '0'
     C                   CALL      'ZBOBU'
     C                   PARM      CL_ORBR       @ZOBRX
     C                   PARM                    @USER
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVOBU'
     C                   PARM      CL_ORBR       @ZOBRX            3
     C                   PARM                    @ERR
     C                   ENDIF
     C     @ERR          IFEQ      1
     C                   MOVEL     'LES0305'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   MOVEL     'LES0306'     SaveMsgIdArr
     C                   MOVE      'Y'           WAERR
     C                   ENDIF
     C                   ENDIF
      *
     C     WAERR         IFEQ      'Y'
     C                   MOVE      'N'           OKLNRF
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF'      FldNameArr(Ix)
     C                   MOVEL     SaveMsgIdArr  MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
      *
      ***  Clear outputs
      *
     C                   CLEAR                   CRpScFilFmt
     C                   CLEAR                   WrkLnDetails                               MD021356
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKLNRF
     C                   MOVEL     'Y'           OKVDAT
     C                   MOVEL     'Y'           OKSEQN
      *
     C                   Z-ADD     *ZERO         Ix
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *    ======
      ***  Return code
     C                   PARM                    RetCodeIn
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      *
      ***  Response mode
     C                   PARM                    RespMode          1
      *
      ***  Action Code
     C                   PARM                    DDACTN            1
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  (Midas) loan Number
     C                   PARM                    DDLNRF            6
      *
      ***  (Midas) Sequence no.
     C                   PARM                    DDSEQN            3
      *
      ***  (Midas) Value date
     C                   PARM                    DDVDAT            6
      *
      ***  OUTPUTS
      *    =======
      ***  (Current) Repayment in file format
     C                   PARM                    CRpScFilFmt
      *
      ***  OK - Action code
     C                   PARM                    OKACTN            1
      *
      ***  OK - loan Number
     C                   PARM                    OKLNRF            1
      *
      ***  OK - Sequence no.
     C                   PARM                    OKSEQN            1
      *
      ***  OK - Value date
     C                   PARM                    OKVDAT            1
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Ix
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
     C                   PARM                    WrkLnDetails                               MD021356
      *
      ***  Initialise program name
      *
     C                   MOVEL     'LERPSCRTV'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access General Ledger details
      ***
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Retrieve Lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '004'         DBASE                          * DBERR 004 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Check features are installed
      *
     C                   MOVE      'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CLE002'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
     C                   MOVE      'N'           CLE003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE003'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE003
     C                   END
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVE      'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *                                                                                       CAP084
     C                   MOVE      'N'           CLE028            1                          CAP084
     C                   CALLB     'AOSARDR0'                                                 CAP084
     C                   PARM      *BLANK        @RTCD                                        CAP084
     C                   PARM      '*VERIFY'     @OPTN                                        CAP084
     C                   PARM      'CLE028'      @SARD                                        CAP084
      *                                                                                       CAP084
     C     @RTCD         IFEQ      *BLANKS                                                    CAP084
     C                   MOVE      'Y'           CLE028                                       CAP084
     C                   END                                                                  CAP084
      *
      ** Check if Compliance Watch Enhancement (CSD015) is on                                BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3760
     C                   PARM      'CSD015'      @SARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        @RTCD <> *BLANKS AND                                      BUG3760
     C                             @RTCD <> '*NRF   '                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 55                                                BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        @RTCD = *BLANKS                                           BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check if function code is being monitored by compliance watch.                      BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
     C                                                                                       BUG3760
     C                   CALLB     'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*KEY   '     @OPTN                                       BUG3760
     C                   PARM      'LENDING'     @FUNC             8                         BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        (@RTCD <> *BLANKS)                                        BUG3760
     C                             AND (@RTCD <> '*NRF')                                     BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBASE = 56                                                BUG3760
     C                   EVAL      DBKEY = @FUNC                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access compliance watch configuration                                               BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*FIRST '     @OPTN                                       BUG3760
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        (@RTCD <> *BLANKS)                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBASE  = 57                                               BUG3760
     C                   EVAL      DBKEY = @OPTN                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check if Concord Interface Development (CCF001) is on                               BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3760
     C                   PARM      'CCF001'      @SARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        (@RTCD <> *BLANKS) and                                    BUG3760
     C                             (@RTCD <> '*NRF   ')                                      BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CCF001'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 58                                                BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        @RTCD = *BLANKS                                           BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Determine if 24x7 Midas Availability active?                                        BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       @RTCD                                       BUG3760
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3760
     C                   PARM      'CSC011'      @SARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        @RTCD = *BLANKS                                           BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        (@RTCD <> *BLANKS) and                                    BUG3760
     C                             (@RTCD <> '*NRF   ')                                      BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CSC011'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 59                                                BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 5                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
     C                   ENDIF                                                                240968
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C**********         PARM      *BLANKS       P@OP02                                CSC024 240968
     C                   PARM      CLAuthORED    P@OP02                                       240968
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 6                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C**********         ENDIF                                                         CSC024 240968
     C                   MOVEL     P@VL02        ATHORED           1                          240968
                                                                                              CLE056
      ** Check if Authorisation on Lending Transactions (CLE056) is on                        CLE056
                                                                                              CLE056
     C                   EVAL      CLE056 = 'N'                                               CLE056
     C                   CALLB     'AOSARDR0'                                                 CLE056
     C                   PARM      *BLANKS       @RTCD                                        CLE056
     C                   PARM      '*VERIFY'     @OPTN                                        CLE056
     C                   PARM      'CLE056'      @SARD                                        CLE056
                                                                                              CLE056
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CLE056
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE056
     C                   EVAL      DBKey  = 'CLE056'                                          CLE056
     C                   EVAL      DBase  = 8                                                 CLE056
     C                   EXSR      *PSSR                                                      CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CLE056
     C                   IF        @RTCD = *BLANKS                                            CLE056
     C                   EVAL      CLE056 = 'Y'                                               CLE056
     C                   ENDIF                                                                CLE056
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       @RTCD                                        CSD083
     C                   PARM      '*VERIFY'     @OPTN                                        CSD083
     C                   PARM      'CSD083'      @SARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        @RTCD <> *BLANKS AND                                       CSD083
     C                             @RTCD <> '*NRF    '                                        CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 9                                                  CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        @RTCD = *Blanks                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CLE148
      ** Check System Value: LoanAlphaAllow                                                   CLE148
      *                                                                                       CLE148
     C                   EVAL      SVALK1 = 'LoanAlphaAllow'                                  CLE148
      *                                                                                       CLE148
     C                   CALL      'AOSVALR0'                                                 CLE148
     C                   PARM                    RTNCDE                                       CLE148
     C                   PARM                    SVALK1                                       CLE148
     C                   PARM                    SVAL1                                        CLE148
     C                   PARM                    SVALK2                                       CLE148
     C                   PARM                    SVAL2                                        CLE148
     C                   PARM                    SVALK3                                       CLE148
     C                   PARM                    SVAL3                                        CLE148
     C                   PARM                    SVALK4                                       CLE148
     C                   PARM                    SVAL4                                        CLE148
     C                   PARM                    SVALK5                                       CLE148
     C                   PARM                    SVAL5                                        CLE148
     C                   PARM                    SVALK6                                       CLE148
     C                   PARM                    SVAL6                                        CLE148
     C                   PARM                    SVALK7                                       CLE148
     C                   PARM                    SVAL7                                        CLE148
     C                   PARM                    SVALK8                                       CLE148
     C                   PARM                    SVAL8                                        CLE148
     C                   PARM                    SVALK9                                       CLE148
     C                   PARM                    SVAL9                                        CLE148
     C                   PARM                    SVALK0                                       CLE148
     C                   PARM                    SVAL10                                       CLE148
      *                                                                                       CLE148
      ** If the system value is not found then issue a database error                         CLE148
      *                                                                                       CLE148
     C                   IF        RTNCDE <> *BLANKS                                          CLE148
     C                   EVAL      DBFile = 'SDSVALPD'                                        CLE148
     C                   EVAL      DBKey  = '*FIRST  '                                        CLE148
     C                   EVAL      DBase  = 7                                                 CLE148
     C                   EXSR      *PSSR                                                      CLE148
      *                                                                                       CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     SVAL1         wLoanAlpha                                   CLE148
     C                   ENDIF                                                                CLE148
      *                                                                                       CLE148
     C     P_LELOANISO   PLIST                                                                CLE148
      *                                                                                       CLE148
      ** Loan Number (Input)                                                                  CLE148
      *                                                                                       CLE148
     C                   PARM                    PLNRF                                        CLE148
      *                                                                                       CLE148
      ** Validity Flags (Output)                                                              CLE148
      *                                                                                       CLE148
     C                   PARM                    PValid                                       CLE148
      *                                                                                       CLE148
      ** Check Digit (Output)                                                                 CLE148
      *                                                                                       CLE148
     C                   PARM                    PChkDigit                                    CLE148
     C                   PARM                    PData                                        CLE148
      *
      ***  Key list for LOAMS
      *
     C     K@LOAM        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@VDAT            5 0
     C                   KFLD                    K@LASN            3 0
      *
      ***  Key list for CLOAN
      *
     C     K@LOAN        KLIST
     C**********         KFLD                    K@LNRF            6 0                        CLE148
     C                   KFLD                    K@LNRF            6                          CLE148
     C                   KFLD                    K@RCDT            1
                                                                                             BUG3760
      *                                                                                      BUG3760
      **  Used fo Compliance Watch                                                           BUG3760
      *                                                                                      BUG3760
     C     CWHTKY        KLIST                                                               BUG3760
     C                   KFLD                    KFUNT             8                         BUG3760
     C                   KFLD                    KIDEN            40                         BUG3760
     C                   KFLD                    KBRCH             3                         BUG3760
      *
      ***  Get ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RTCD
     C                   PARM                    PMODE             1
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
