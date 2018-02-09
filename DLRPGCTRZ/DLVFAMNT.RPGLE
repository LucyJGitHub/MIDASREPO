     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate Fee Amount and Sign')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVFAMNT - Validate Fee Amount and Sign                      *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Fee Amount and Sign.                              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     D DDFAMT          S             14A
     D DDFSGN          S              1A
 
      ** system input
     D A6NBDP          S              1S 0
 
      ** Ok indicators
     D POkFAMT         S              1A
     D POkFSGN         S              1A
 
      ** Working Variables
     D PzAlignOk       S              1A
     D PzADig          S              2P 0
     D PzADec          S              1P 0
     D PzField         S             16A
 
     D WrkFAMT         S             13P 0
 
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
 
      ** Validate Fee Amount
 
     C                   EXSR      SrVFAmt
 
      ** Validate Fee Amount Sign
 
     C                   EXSR      SrVFAmtS
 
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
 
     C                   EVAL      POkFAMT = 'Y'
     C                   EVAL      POkFSGN = 'Y'
     C                   EVAL      WrkFAMT = *ZERO
 
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
      *  SrVFAmt  - Validation routine for Fee Amount                 *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVFAmt       BEGSR
 
     C                   EVAL      PzField = DDFAMT
     C                   EVAL      PzADec  = A6NBDP
     C                   EVAL      PzADig  = 13 - A6NBDP
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PzAlignOk
     C                   PARM                    PzField
     C                   PARM                    PzADec
     C                   PARM                    PzADig
 
     C                   IF        PzAlignOk = 'N'
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDFAMT'
 
      ** Fee Amount is invalid. Please see second level text.
      ** Fee Amount is not a valid numeric with number of decimal places
      ** equal to the fee currency.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0009'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkFAMT = 'N'
 
     C                   ELSE
     C                   MOVE      PzField       WrkFAMT
     C                   CALLB     'ZEDIT'
     C                   PARM                    PzField
     C                   PARM      A6NBDP        PzADec
 
     C                   IF        WrkFAMT = *ZERO
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDFAMT'
 
      ** Fee Amount must be greater than zero.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0010'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkFAMT = 'N'
 
     C                   IF        DDFAMT <> *BLANKS
     C                   MOVE      PzField       DDFAMT
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      PzField       DDFAMT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVFAmtS - Validation routine for Fee Amount Sign            *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVFAmtS      BEGSR
 
     C                   IF        DDFSGN <> '+' AND
     C                             DDFSGN <> '-' AND
     C                             DDFSGN <> *BLANK
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = DDFSGN
 
      ** Fee Amount Sign must be '+', '-' or blank.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0011'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkFSGN = 'N'
 
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
 
      ** Fee Amount
      ** Fee Amount Sign
      ** Currency Number of Decimal Places
 
     C                   PARM                    DDFAMT
     C                   PARM                    DDFSGN
     C                   PARM                    A6NBDP
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Fee Amount Ok Indicator
      ** Fee Amount Sign Ok Indicator
     **  Work Amount
 
     C                   PARM                    POkFAMT
     C                   PARM                    POkFSGN
     C                   PARM                    WrkFAMT
 
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
