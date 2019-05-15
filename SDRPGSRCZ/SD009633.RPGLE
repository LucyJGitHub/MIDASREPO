     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Alpha Loan No. System Value Checker')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009633 - Alpha Loan Number System Value Checker            *
      *                                                               *
      *  Function:  This program will be called when the user         *
      *             attempts to change the condition of the system    *
      *             value LoanAlphaAllow.                             *
      *                                                               *
      *  Called By: System Values Maintenance Screen                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148  *CREATE    Date 23Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Error                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *
      ** LDA Layout
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
      ** Array of error message IDs
     D MsgIDXArr       S                   DIM(99) LIKE(ErrMsgId)
      *
      ** Array of Alpha Codes (0-9 A-Z)
     D WValArr         S              1A   CTDATA DIM(36) PERRCD(36)
      *
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
      *
     D @RUN            S              1
 
      ** Data structure for NewCurrVal string
     D NewCurrVal      S            200
 
      ** Error message id in GBSDUSRMSG
     D ErrMsgId        S              7
 
      ** System value to be processed
     D SystemValue     S             20
 
      ** Processing mode
     D ProcMode        S            190
 
      ** General error indicator
     D GenError        S              1
 
      ** Index for arrays of error message ids etc
     D Idx             S              2P 0
 
     DWLoanAlphaAllow  S            200A
 
      ** Parameters for calling AOSVALR0 (Midas System Value Access Object)
     D PRetCode        S              7A
     D PSysValK1       S             20A
     D PSysVal1        S            200A
     D PSysValK2       S             20A
     D PSysVal2        S            200A
     D PSysValK3       S             20A
     D PSysVal3        S            200A
     D PSysValK4       S             20A
     D PSysVal4        S            200A
     D PSysValK5       S             20A
     D PSysVal5        S            200A
     D PSysValK6       S             20A
     D PSysVal6        S            200A
     D PSysValK7       S             20A
     D PSysVal7        S            200A
     D PSysValK8       S             20A
     D PSysVal8        S            200A
     D PSysValK9       S             20A
     D PSysVal9        S            200A
     D PSysValK10      S             20A
     D PSysVal10       S            200A
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Check if passed SystemValue is valid
 
     C                   IF        SystemValue <> 'LoanAlphaAllow      '
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx      =  1
     C                   EVAL      MsgIDXArr(Idx) = 'S270015'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Retrieve System Value 'LoanAlphaAllow'
 
     C                   EVAL      PRetCode = *BLANKS
     C                   EVAL      PSysValK1 = 'LoanAlphaAllow'
     C                   EVAL      PSysVal1 = *BLANKS
     C                   CALL(E)   'AOSVALR0'    P_AOSVALR0
 
      ** If Error retrieving the System value
 
     C                   IF        %ERROR OR PRetCode <> *BLANKS
     C                             OR (*INU7 = *ON AND *INU8 = *ON)
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx      =  1
     C                   EVAL      MsgIDXArr(Idx) = 'S270016'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WLoanAlphaAllow = PSysVal1
 
      ** If LoanAlphaAllow is being changed from 'Y' to 'N'
 
     C                   IF        WLoanAlphaAllow = 'Y' AND
     C                             %TRIM(NewCurrVal) = 'N'
     C                   EVAL      GenError = 'Y'
     C                   EVAL      Idx      =  1
     C                   EVAL      MsgIDXArr(Idx) = 'S270022'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Normal end processing
 
     C                   EVAL      GenError = *BLANKS
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** System value to be processed (Input)
     C                   PARM                    SystemValue
 
      ** Value entered by user (Input)
     C                   PARM                    NewCurrVal
 
      ** Processing Mode (Input)
     C                   PARM                    ProcMode
 
      ** General Error Indicator (Output)
     C                   PARM                    GenError
 
      ** Error message ID (number of entries) (Output)
     C                   PARM                    Idx
 
      ** Error message ID (array) (Output)
     C                   PARM                    MsgIDXArr
 
      ** Parameter list for calling AOSVALR0
     C     P_AOSVALR0    PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PSysValK1
     C                   PARM                    PSysVal1
     C                   PARM                    PSysValK2
     C                   PARM                    PSysVal2
     C                   PARM                    PSysValK3
     C                   PARM                    PSysVal3
     C                   PARM                    PSysValK4
     C                   PARM                    PSysVal4
     C                   PARM                    PSysValK5
     C                   PARM                    PSysVal5
     C                   PARM                    PSysValK6
     C                   PARM                    PSysVal6
     C                   PARM                    PSysValK7
     C                   PARM                    PSysVal7
     C                   PARM                    PSysValK8
     C                   PARM                    PSysVal8
     C                   PARM                    PSysValK9
     C                   PARM                    PSysVal9
     C                   PARM                    PSysValK10
     C                   PARM                    PSysVal10
 
     C                   EVAL      GenError = *BLANKS
     C                   EVAL      Idx      = 0
     C                   CLEAR                   MsgIDXArr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      GenError = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
 
** WValArr
0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
