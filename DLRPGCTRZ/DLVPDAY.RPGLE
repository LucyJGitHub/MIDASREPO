     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Validate Payment Day in Month')               *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLVPDAY - Validate Payment Day in Month                      *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Payment Day in Month.                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS011             Date 16May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
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
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
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
     D DDPDAY          S              2A
     D DDFREQ          S              1A
     D DDNPYD          S              6A
     D DDEDAT          S              6A
     D DDFCCY          S              3A
     **  Valids file fields
     D DLPEND          S              5  0
     D DLNPYD          S              5  0
 
      ** Ok indicators
     D POkPDAY         S              1A
     D POkNPYD         S              1A
     D POkEDAT         S              1A
     D POkFCCY         S              1A
     D BJDFIN          S              1A
     ** Work fields
     D ZCCY            S                   LIKE(DDFCCY)
     D ZFREQ           S                   LIKE(DDFREQ)
     D ZMDAY           S              2  0
     D WWPDAY          S              2  0
     D ZDAYNO          S              5  0
     D ZLOC            S              3A                                                    AR702741
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
 
      ** Validate Payment Day in Month
 
     C                   EXSR      SrVPday
 
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
 
     C                   EVAL      POkPDAY = 'Y'
     C                   EVAL      WWPDAY = 0
 
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
      *  SrVPday - Validation routine for Payment Day in Month        *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrVPday       BEGSR
 
     C                   IF        DDPDAY  <> *BLANKS
     C                   IF        DDFREQ = *BLANK
 
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDPDAY'
 
      ** Payment Day in Month should be blank when Payment Frequency is not entered.
 
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0025'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkPDAY = 'N'
     C                   ENDIF
 
     C                   TESTN                   DDPDAY               51
     C                   MOVEL     DDPDAY        WWPDAY
 
     C                   IF        ErrorFound <> 'Y'
     C                   IF        *IN51 = '1'  AND WWPDAY < 1
     C                             OR *IN51 = '1' AND WWPDAY > 31
     C                             OR *IN51 = '0'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDPDAY'
      ** Days in month must be in the range 1 to 31
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0026'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkPDAY = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        POkNPYD = 'Y' AND DDFREQ <> *BLANK
     C     BJDFIN        IFEQ      'D'
     C                   EVAL      DDPDAY = %SUBST(DDNPYD:1:2)
     C                   ELSE
     C                   EVAL      DDPDAY = %SUBST(DDNPYD:3:2)
     C                   ENDIF
     C                   MOVEL     DDPDAY        WWPDAY
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        POkPDAY = 'Y' AND POkNPYD = 'Y'
     C                             AND POkEDAT = 'Y' AND DDFREQ <> *BLANK
     C                             AND POkFCCY = 'Y'
     C                   EVAL      ZDAYNO = DLNPYD
     C                   EVAL      ZFREQ = DDFREQ
     C                   MOVEL     DDPDAY        ZMDAY
     C                   EVAL      ZCCY = DDFCCY
 
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM      SDGELR        SDGELR
 
      ** Frequency entered will cause the Next Payment Date to increment past the End Date
     C     ZDAYNO        IFGT      DLPEND
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'DDPDAY'
     C                   EVAL      MsgIdXArr(XIdx)  = 'DLF0041'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      POkPDAY = 'N'
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
 
      ** Payment Day in Month
      ** Payment Frequency
      ** Next Payment Date
      ** End Date
      ** Fee Currency
      ** End Date (File Format)
      ** Next Payment Date (File format)
      ** Next Payment Date ok indicator
      ** End Date ok indicator
      ** Fee Currency Ok indicator
      ** Date format indicator
 
     C                   PARM                    DDPDAY
     C                   PARM                    DDFREQ
     C                   PARM                    DDNPYD
     C                   PARM                    DDEDAT
     C                   PARM                    DDFCCY
     C                   PARM                    DLPEND
     C                   PARM                    DLNPYD
     C                   PARM                    POkNPYD
     C                   PARM                    POkEDAT
     C                   PARM                    POkFCCY
     C                   PARM                    BJDFIN
 
      ** Returned parameters
      ** -------------------
 
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Payment Day in Month Ok indicator
      ** Payment Day in Month
 
     C                   PARM                    POkPDAY
     C                   PARM                    WWPDAY
 
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
 
     C**********         CALLB     'AOGELRR0'                                                 CAS011
     C                   CALLB     'AOGELRR1'                                                 CAS011
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
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
