     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Compounding Frequency Validation Module')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVCFRQ01 - Compounding Frequency Validation Module          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 228390             Date 14Jul04               *
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  None                                                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation                                  *
      *  SRINIT     - Initialisation Processing                       *
      *  SRVCOMFRQ  - Validate Compounding Frequency                  *
      *  *PSSR      - DB Error Processing                             *
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARR1
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
 
      ** External DS for Yield Curve Details
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Yield Curve input field
     D P#0YCFQ         S              1
 
      ** Yield Curve error indicator
     D PYCFQOK         S              1
 
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
 
      ** Initialisation Processing
 
     C                   EXSR      SRINIT
 
      ** Validate Compounding Frequency
 
     C                   EXSR      SRVCOMFRQ
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT  - Initialisation Processing                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** Initialize error work fields and arrays
 
     C                   EVAL      RetCodeIn =  *BLANK
     C                   EVAL      FldNamXar2 =  *BLANK
     C                   EVAL      MsgIdXar2 =  *BLANK
     C                   EVAL      MsgDtaXar2 =  *BLANK
     C                   EVAL      MsgDtaXar2 =  *BLANK
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCOMFRQ - Validate Compounding Frequency                    *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRVCOMFRQ     BEGSR
 
      ** Error if compounding frequency is not 'D' - Daily, 'Q' - Quarterly
      ** 'Y' - Yearly and 'X' - Semi-Annually
 
     C**********         IF        FSYLDT = 'Z'                                               228390
     C                   IF        FSYLDT = 'S'                                               228390
     C                   IF        (P#0YCFQ <> 'D') AND (P#0YCFQ <> 'Q') AND
     C                             (P#0YCFQ <> 'Y') AND (P#0YCFQ <> 'X')
     C                   EVAL      PYCFQOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr2(Idx) = '#0YCFQ    '
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9202'
     C                   ENDIF
     C                   ELSE
                                                                                              228390
     C                   IF        FSYLDT = 'Z'                                               228390
     C                   IF        (P#0YCFQ <> 'C') AND (P#0YCFQ <> 'Q') AND                  228390
     C                             (P#0YCFQ <> 'Y') AND (P#0YCFQ <> 'X') AND                  228390
     C                             (P#0YCFQ <> 'D')                                           228390
     C                   EVAL      PYCFQOK = 'N'                                              228390
     C                   EVAL      Idx = Idx + 1                                              228390
     C                   EVAL      FldNamXAr2(Idx) = '#0YCFQ    '                             228390
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9202'                                 228390
     C                   ENDIF                                                                228390
     C                   ELSE                                                                 228390
 
      ** Error if yield curve type is not 'Z' and compounding frequency is
      ** not blank
 
     C                   IF        P#0YCFQ <> *BLANK
     C                   EVAL      PYCFQOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr2(Idx) = '#0YCFQ    '
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9204'
     C                   ENDIF
     C                   ENDIF                                                                228390
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By : Called automatically upon module execution        *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    P#0YCFQ
     C                   PARM                    FldNamXar2
     C                   PARM                    MsgIdXar2
     C                   PARM                    MsgDtaXar2
     C                   PARM                    SDYLDC
     C                   PARM                    PYCFQOK
 
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
(c) Misys International Banking Systems Ltd. 2001
