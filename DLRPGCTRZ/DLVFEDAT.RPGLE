     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate End Date')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVFEDAT - Validate End Date                                 *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             End Date.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13729           Date 12Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 12Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG13729 - No "warning / error message" upon input of        *
      *             dealing fee which end date exceeds the due date   *
      *             of the deal                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     IGNORE(DEALSDGF)
     FSDFEEL0   IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Screen input fields
     D DDEDAT          S              6A
     D DDDLNO          S              6A
     D WWDLNO          S              6  0
     D BJDFIN          S              1A
     D BJRDNB          S              5P 0
 
      ** Working Variables
     D PErrorFlag      S              1A
     D DDFIND          S              1A
     D DDFCOD          S              2A
     D WWFCOD          S              2A
 
      ** Ok indicators
     D PDayEDAT        S              5P 0
     D POkEDAT         S              1A
 
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
 
      ** Validate End Date
 
     C                   EXSR      SrVEDate
 
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
 
     C                   EVAL      POkEDAT = 'Y'
     C                   EVAL      ErrorFound = 'N'
     C                   MOVEL     DDDLNO        WWDLNO
     C                   MOVEL     DDFCOD        WWFCOD
 
     C     WWDLNO        CHAIN     DEALS
 
     C                   IF        %FOUND(DEALS)
     C     WWFCOD        CHAIN     SDFEEL0                            01
     C                   ENDIF
 
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
      *  SrVEdate - Validation routine for End Date                   *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVEDate      BEGSR
 
      ** End date is mandatory if pay on indicator is S, E or N
     C                   IF        DDEDAT = *BLANKS
     C                   IF        DDFIND = 'S' OR
     C                             DDFIND = 'N' OR
     C                             DDFIND = 'E'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDEDAT'
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0040'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkEDAT = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDEDAT <> *BLANKS
      ** Test if date is numeric and valid
 
     C                   TESTN                   DDEDAT               0102
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDEDAT
     C                   PARM      *ZEROS        PDayEDAT
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       PErrorFlag
     C                   ENDIF
 
     C                   IF        PErrorFlag = 'Y' OR
     C                             *IN01 = *OFF     AND
     C                             *IN02 = *OFF
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDEDAT'
 
      ** Invalid date format or not numeric
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0013'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkEDAT = 'N'
     C                   ENDIF
 
     C**********         IF        ErrorFound <> 'Y' AND                                    BUG13729
     C**********                   PDayEDAT < VDAT   AND                                    BUG13729
     C**********                   PDayEDAT > MDAT AND                                      BUG13729
     C**********                   *IN01 = '0'                                              BUG13729
     C                   IF        (ErrorFound <> 'Y' AND PDayEDAT < VDAT                   BUG13729
     C                             AND *IN01 = '1') OR                                      BUG13729
     C                             (ErrorFound <> 'Y' AND PDayEDAT > MDAT                   BUG13729
     C                             AND *IN01 = '1')                                         BUG13729
     C                   IF        AUADJY <> 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'DDEDAT'
      ** Warning : End date is less than the value date or greater than the
      ** maturity date of deal.
     C                   EVAL      MsgIdWArr(WIdx)  = 'DLF0018'
     C                   ELSE
     C                   IF        DDFIND = 'E' OR DDFIND = 'N'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDEDAT'
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0019'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkEDAT = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PDayEDAT = *ZEROS
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
 
      ** Start Date
      ** Date Format Indicator
      ** Rundate
      ** Deal Number
 
     C                   PARM                    DDEDAT
     C                   PARM                    BJDFIN
     C                   PARM                    DDFIND
     C                   PARM                    DDDLNO
     C                   PARM                    DDFCOD
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamWArr
     C                   PARM                    MsgIDWArr
     C                   PARM                    MsgDtaWArr
 
      ** Start Date day number format
      ** Start Date Ok Indicator
 
     C                   PARM                    PDayEDAT
     C                   PARM                    POkEDAT
 
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
