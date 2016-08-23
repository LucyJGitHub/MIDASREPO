     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate Next Payment Date')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVNXPY - Validate Next Payment Date                         *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Next Payment Date.                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
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
     D DLPSTD          S              5  0
     D DLPEND          S              5  0
     D DDNPYD          S              6A
     D BJDFIN          S              1A
 
      ** Working Variables
     D PErrorFlag      S              1A
     D DDFIND          S              1A
 
      ** Ok indicators
     D PDaySDAT        S              5P 0
     D PDayEDAT        S              5P 0
     D PDayNDAT        S              5P 0
     D POkNDAT         S              1A
 
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
 
     C                   EXSR      SrVNDate
 
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
 
     C                   EVAL      POkNDAT = 'Y'
 
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
      *  SrVNdate - Validation routine for Next Date                  *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVNDate      BEGSR
 
     C                   IF        DDNPYD = *BLANKS
     C                   IF        DDFIND = 'N'
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNPYD'
 
      ** Next Payment date is mandatory when Payment On Indicator is 'N'.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0020'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkNDAT = 'N'
     C                   ENDIF
 
     C                   ELSE
     C                   IF        DDFIND <> 'N'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNPYD'
 
      ** Next Payment Date should be blank when Payment On Indicator is not 'N'.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0021'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkNDAT = 'N'
     C                   ELSE
 
      ** Test if date is numeric and valid
 
     C                   TESTN                   DDNPYD               0102
     C                   IF        *IN01 = *ON OR
     C                             *IN02 = *ON
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDNPYD
     C                   PARM      *ZEROS        PDayNDAT
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       PErrorFlag
     C                   ENDIF
 
     C                   IF        PErrorFlag = 'Y' OR
     C                             *IN01 = *OFF     AND
     C                             *IN02 = *OFF
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNPYD'
 
      ** Invalid date format or not numeric
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0013'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkNDAT = 'N'
     C                   ENDIF
 
     C                   IF        ErrorFound <> 'Y'
     C                   IF        PDayNDAT <= DLPSTD OR
     C                             PDayNDAT >= DLPEND
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDNPYD'
      ** Next Payment  Date should be between the Start and End Date.
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0022'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkNDAT = 'N'
     C                   ENDIF
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
 
      ** Next Payment Date
      ** Start Date
      ** End Date
      ** Date Format Indicator
      ** Payment On Indicator
 
     C                   PARM                    DDNPYD
     C                   PARM                    DLPSTD
     C                   PARM                    DLPEND
     C                   PARM                    BJDFIN
     C                   PARM                    DDFIND
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Start Date day number format
      ** Start Date Ok Indicator
 
     C                   PARM                    PDayNDAT
     C                   PARM                    POkNDAT
 
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
