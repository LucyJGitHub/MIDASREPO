     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate PCA profit centres')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVPCAPRFC - Validate PCA profit centres                     *
      *                                                               *
      *  Function:  This module validates the two profit centres      *
      *             required by the Profit-Centre Accounting module   *
      *             (the book and transaction position profit centres)*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 179732             Date 08Jun00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 21Oct98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  179732 - Addition of account officer to the call to AOPRFMR0.*
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFOPCC     IF   E           K DISK                                         S01117
     FFOPCK     IF   E           K DISK                                         S01117
 
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
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
 
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** External data structure for customer details file                                    179732
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  179732
                                                                                              179732
     D @DSFDY        E DS                  EXTNAME(DSFDY)
      *  FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** External data structure for access programs (long)                                   179732
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     179732
                                                                                              179732
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Transaction broker
     D*BOCO*****       S              6S 0                                                    CSD027
     D BOCO            S              6A                                                      CSD027
      ** Transaction customer
     D*CUSC*****       S              6S 0                                                    CSD027
     D CUSC            S              6A                                                      CSD027
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires ERR_ARRAYS and STD_D_SPEC.
     C/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Book position profit centre              |
      ** +------------------------------------------+
 
      * Default Book Position Profit Centre
 
     C                   EXSR      DEF_BPRFC
 
      * Validate Book Position Profit Centre
 
     C                   EXSR      VAL_BPRFC
 
      ** +------------------------------------------+-----------------------------------------------
      ** | Transaction profit centre                |
      ** +------------------------------------------+
 
      * Transaction profit centre only required for customer trades
 
     C     CUSC          IFNE      *ZERO
 
      * Default Transaction Profit Centre
 
     C                   EXSR      DEF_TPRFC
 
      * Validate Transaction Profit Centre
 
     C                   EXSR      VAL_TPRFC
 
     C                   ELSE
     C                   MOVE      *BLANK        STPRC
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      **********************************************************************
      *
      * VAL_BPRFC - Validate Book Position Profit Centre
      *
      **********************************************************************
     C     VAL_BPRFC     BEGSR
      *
      * Book profit centre cannot be blank
      *
     C     SBPRC         IFEQ      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx +1
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0707'
     C                   EVAL      FldNamXArr(XIdx) = 'SBPRC'
     C                   EVAL      OKBPRC = 'N'
 
     C                   ELSE
     C                   MOVE      SBPRC         @PCCD
     C                   EXSR      VPRFC
      *
      * Invalid book profit centre
      *
     C                   IF        @RTCD <> *blanks
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx +1
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0708'
     C                   EVAL      FldNamXArr(XIdx) = 'SBPRC'
     C                   EVAL      OKBPRC = 'N'
     C                   ELSE
     C                   MOVE      @PCCD         SBPRC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
     C/EJECT
      **********************************************************************
      *
      * VAL_TPRFC - Validate Transaction Profit Centre
      *
      **********************************************************************
     C     VAL_TPRFC     BEGSR
      *
      * Transaction profit centre cannot be blank
      *
     C     STPRC         IFEQ      *BLANKS
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx +1
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0709'
     C                   EVAL      FldNamXArr(XIdx) = 'STPRC'
     C                   EVAL      OKTPRC = 'N'
 
     C                   ELSE
     C                   MOVE      STPRC         @PCCD
     C                   EXSR      VPRFC
      *
      * Invalid transaction profit centre
      *
     C                   IF        @RTCD <> *blanks
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx +1
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0710'
     C                   EVAL      FldNamXArr(XIdx) = 'STPRC'
     C                   EVAL      OKTPRC = 'N'
     C                   ELSE
     C                   MOVE      @PCCD         STPRC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *
      * DEF_BPRFC - Default Book Position Profit Centre
      *
      **********************************************************************
     C     DEF_BPRFC     BEGSR
      *
      **   1. If reconcile trade/book position profit centre = 'N'
      *
     C     BXTBRC        IFEQ      'N'
      *
      **   - Profit Centre Default used = 'Y'
      **     and no book position profit centre defined
      *
     C     BKPCDU        IFEQ      'Y'
     C     SBPRC         ANDEQ     *BLANKS
     C                   MOVEL     BOCO          @CUST
     C                   EXSR      AOPRFM
     C                   MOVE      @PRFC         SBPRC
     C                   END
      *
     C                   ELSE
      *
      **   Determine if a book position profit centre exists for trade.
      *
     C                   MOVE      SBRCD         KBRCAF
     C                   MOVE      SBOKC         KBOKCF
     C                   MOVE      SISTT         KISTTF
     C*
     C     KFPCK         CHAIN     FOPCK                              71
      *
      **   2. If a new book position
      *
     C     *IN71         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      **   - Profit Centre Default used = 'Y'
      **     and no book position profit centre defined
      *
     C     BKPCDU        IFEQ      'Y'
     C     SBPRC         ANDEQ     *BLANKS
     C                   MOVEL     BOCO          @CUST
     C                   EXSR      AOPRFM
     C                   MOVE      @PRFC         SBPRC
     C                   END
      *
     C                   ELSE
      *
      **   3. If an existing book position
      **      use this book position profit centre
      *
     C                   MOVE      PCBK          SBPRC
      *
     C                   END
     C                   END
      *
     C                   ENDSR
      **********************************************************************
     C/EJECT
      **********************************************************************
      *
      * DEF_TPRFC - Default Transaction Profit Centre
      *
      **********************************************************************
     C     DEF_TPRFC     BEGSR
      *
      ** Determine if a customer position profit centre exists
      ** for the customer
      *
     C                   MOVE      SBRCD         KBRCAO
     C                   MOVE      CUSC          KCBCDO
     C                   MOVE      SISTT         KISTTO
      *
     C     KFPCC         CHAIN     FOPCC                              71
      *
      **   1. If a new customer position
      *
     C     *IN71         IFEQ      '1'
     C     RECI          ORNE      'D'
      *
      **   - Profit Centre Default used = 'Y'
      **     and no transaction profit centre defined
      *
     C     BKPCDU        IFEQ      'Y'
     C     STPRC         ANDEQ     *BLANKS
     C                   MOVEL     CUSC          @CUST
     C                   EXSR      AOPRFM
     C                   MOVE      @PRFC         STPRC
     C                   ENDIF
      *
     C                   ELSE
      *
      **   3. If an existing customer position
      **      use its profit centre as the transaction profit centre
      *
     C                   MOVE      PCCB          STPRC
     C                   ENDIF
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
      ********************************************************************
      **                                                                 *
      ** VPRFC -  Validate  Profit Centre                                *
      **                                                                 *
      ********************************************************************
     C     VPRFC         BEGSR
      *
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @PCCD             4
     C     SDPRFC        PARM      SDPRFC        @DSFDY
      *
     C                   ENDSR
     C********************************************************************
     C/EJECT
      ********************************************************************
      **                                                                 *
      **   AOPRFM SR. -  Initialise  Profit Centre (Insert) AO routine   *
      **   ~~~~~~~~~                                                     *
      ********************************************************************
     C     AOPRFM        BEGSR
      *                                                                                       179732
      * Call to Customer Access object to retrieve the Account officer for                    179732
      * the customer.                                                                         179732
     C                   CALLB     'AOCUSTR0'                                                 179732
     C                   PARM      *BLANKS       @RTCD             7                          179732
     C                   PARM      '*KEY   '     @OPTN             7                          179732
     C                   PARM      @CUST         @KEY1            10                          179732
     C                   PARM      *BLANKS       @KYST             7                          179732
     C     SDCUST        PARM      SDCUST        DSSDY                                        179732
      *                                                                                       179732
      *Move accocunt officer into parameter field                                             179732
     C                   MOVE      BBACOC        @ACOC                                        179732
      *                                                                                       179732
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       @RTCD1            1
     C                   PARM      SBOKC         @BKCD             2
     C                   PARM      *BLANKS       @TRTY             5
     C                   PARM      *BLANKS       @SBTY             2
     C                   PARM      SBRCD         @BRCD             3
     C                   PARM      DPPT          @DPCD             3
     C                   PARM      USRID         @USID            10
     C*******************PARM      *BLANKS       @ACOC             2                          179732
     C                   PARM                    @ACOC             2                          179732
     C                   PARM                    @CUST             6
     C                   PARM      *BLANK        @PRFC             4
      *
      * Invalid profit centre
      *
     C     @RTCD1        IFEQ      '2'
     C                   MOVEL     *BLANKS       @PRFC
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** OK flags for book and transaction positions profit centres
     C                   PARM                    OKBPRC            1
     C                   PARM                    OKTPRC            1
      ** Inputs to this procedure
      ** ------------------------
      ** Book positions profit centre
     C                   PARM                    SBPRC             4
      ** Transaction positions profit centre
     C                   PARM                    STPRC             4
      ** Book code
     C                   PARM                    SBOKC             2
      ** Branch codes
     C                   PARM                    SBRCD             3
      ** Instrument Type
     C                   PARM                    SISTT             5
      ** Transaction broker
     C                   PARM                    BOCO
      ** Transaction customer
     C                   PARM                    CUSC
      ** Department (from ZMUSER)
     C                   PARM                    DPPT              3
      ** User (from ZMUSER)
     C                   PARM                    USRID            10
      ** ICD
      ** Profit centres defaults used
     C                   PARM                    BKPCDU            1
      ** Reconcile trade/book position profit centre
     C                   PARM                    BXTBRC            1
 
      *
      **   LF/FOPCK
      *
     C     KFPCK         KLIST
     C                   KFLD                    KBRCAF            3
     C                   KFLD                    KBOKCF            2
     C                   KFLD                    KISTTF            5
      *
      **   LF/FOPCC
      *
     C     KFPCC         KLIST
     C                   KFLD                    KBRCAO            3
     C**********         KFLD                    KCBCDO            6 0                        CSD027
     C                   KFLD                    KCBCDO            6                          CSD027
     C                   KFLD                    KISTTO            5
 
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
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
