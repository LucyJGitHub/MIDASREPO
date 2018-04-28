     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate Fee Code')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVFCODE - Validate Fee Code                                 *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Fee Code.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 12Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FFDDTSTL0  IF   E           K DISK    INFSR(*PSSR)
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** External DS for Fee Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short data structure for access objects
 
     D DealsDtlC     E DS                  EXTNAME(DEALSDC)
     D                                     PREFIX(C_)
     D DealsDtlD     E DS                  EXTNAME(DEALSDD)
     D                                     PREFIX(D_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Screen input fields
     D DDFCOD          S              2A
 
      ** Work Variable
     D PRtCd           S              7A
     D POptn           S              7A
     D WWDTYP          S                   LIKE(C_DTYP)
     D WWDLST          S                   LIKE(C_DLST)
     D WkADJY          S                   LIKE(AUADJY)
 
      ** Ok indicators
     D OKFCOD          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EXSR      SrInit
 
      ** Validate Fee Code
 
     C                   EXSR      SrVFCode
 
      ** Set return code and return to the calling program.
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   - Initialisation                                    *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
     C                   EVAL      OKFCOD = 'Y'
     C                   IF        C_RCDT <> *BLANK
     C                   EVAL      WWDTYP = C_DTYP
     C                   EVAL      WWDLST = C_DLST
     C                   ELSE
     C                   EVAL      WWDTYP = D_DTYP
     C                   EVAL      WWDLST = D_DLST
     C                   ENDIF
 
     C     DTSTKY        CHAIN     FDDTSTL0                           01
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVFCode - Validation routine for Fee Code                   *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVFCode      BEGSR
 
      ** Fee code is mandatory
     C                   IF        DDFCOD = *BLANKS
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDFCOD'
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0039'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKFCOD = 'N'
     C                   ENDIF
 
      ** Fee code is entered
     C                   IF        DDFCOD <> *BLANKS
 
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    DDFCOD
     C     SDFEE         PARM      SDFEE         DSFDY
 
     C                   IF        Prtcd <> *BLANKS
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDFCOD'
 
      ** Fee code does not exist.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0008'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKFCOD = 'N'
     C                   ELSE
     C                   EVAL      WkADJY = AUADJY
 
     C                   IF        FSACAI <> 'Y' AND AUADJY = 'Y'
     C                             AND *IN01 = '0'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDFCOD'
 
      ** When the Adjustment to Yield is 'Y', the Amortised Cost Accounting
      ** indicator of Deal type/Sub-type should also be 'Y'
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0038'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      OKFCOD = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code Error Indicator
 
     C                   PARM                    ReturnCode
 
      ** Received Parameters
      ** -------------------
 
      ** Fee Code
 
     C                   PARM                    DDFCOD
      * Deals Detail (DEALSDC)
     C                   PARM                    DealsDtlC
      * Deals Detail (DEALSDD)
     C                   PARM                    DealsDtlD
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Fee Code Ok Indicator
      ** Adjustment to Yield
 
     C                   PARM                    OKFCOD
     C                   PARM                    WkADJY
 
     C     DTSTKY        KLIST
     C                   KFLD                    WWDTYP
     C                   KFLD                    WWDLST
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
