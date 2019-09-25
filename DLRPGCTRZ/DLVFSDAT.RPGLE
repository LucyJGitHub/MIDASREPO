     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate Start Date')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVFSDAT - Validate Start Date                               *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Start Date.                                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 12Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
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
     D DDSDAT          S              6A
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
     D PDaySDAT        S              5P 0
     D POkSDAT         S              1A

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

      ** Validate Start Date

     C                   EXSR      SrVSDate

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

     C                   EVAL      POkSDAT = 'Y'
     C                   MOVEL     DDDLNO        WWDLNO
     C                   MOVEL     DDFCOD        WWFCOD
     C     WWDLNO        CHAIN     DEALS
     C                   IF        %FOUND(DEALS)
     C     WWFCOD        CHAIN     SDFEEL0
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
      *  SrVSdate - Validation routine for Start Date                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SrVSDate      BEGSR

     C                   IF        DDSDAT = *BLANKS

     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDSDAT'

      ** Start Date is mandatory.

     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0012'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkSDAT = 'N'

     C                   ELSE

      ** Test if date is numeric and valid

     C                   TESTN                   DDSDAT               0102
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDSDAT
     C                   PARM      *ZEROS        PDaySDAT
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       PErrorFlag
     C                   ENDIF

     C                   IF        PErrorFlag = 'Y' OR
     C                             *IN01 = *OFF     AND
     C                             *IN02 = *OFF
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDSDAT'

      ** Invalid date format or not numeric

     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0013'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkSDAT = 'N'
     C                   ENDIF

     C                   ENDIF

     C                   IF        ErrorFound <> 'Y' AND
     C                             PDaySDAT < VDAT   AND
     C                             PDaySDAT > MDAT
     C                   IF        AUADJY <> 'Y'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      FldNamWArr(WIdx) = 'DDSDAT'
      ** Warning : Start date is less than the value date or greater than the
      ** Warning : Start date is less than the value date or greater than the
     C                   EVAL      MsgIdWArr(WIdx)  = 'DLF0014'
     C                   ELSE
     C                   IF        DDFIND = 'E' OR DDFIND = 'N'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDSDAT'
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0017'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkSDAT = 'N'
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

      ** Start Date
      ** Date Format Indicator
      ** Rundate
      ** Deal Number

     C                   PARM                    DDSDAT
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

     C                   PARM                    PDaySDAT
     C                   PARM                    POkSDAT

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
(c) Finastra International Limited 2004
