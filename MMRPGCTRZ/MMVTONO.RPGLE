     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate totals')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVTONO - MM Repo Header Control Nominal and Totals          *
      *            validation                                         *
      *                                                               *
      *  Function: This Program Validates the Control Nominal         *
      *            and value totals                                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006             Date 1June99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE006 - Repurchase Agreements.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     D ValidRepo     E DS                  EXTNAME(MMVRPDHPD)
      * Valid Repo Delivery Details
 
     D TranIn        E DS                  EXTNAME(MMRPDHPD)
     D                                     PREFIX(IK:2)
     D QQACCN1       E                     EXTFLD(QQACCN)                                     CGL029
      * Incoming Transaction
 
     D**  Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     WMsg1       S                   LIKE(#MsgID)
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
     ** Deal Amount
     D DealAmt         S             15S 0
      ** Main Loan Ccy
     D LoanCcy         S              3
 
      * Parameters for ZALIGN
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZALIGNok        S              1A
 
     D   ZFLD15        S             15  0
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for customer details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for Securities ICD Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   WarnFound
     C                   RESET                   ErrorFound
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   WMsg1
     C                   RESET                   IFCNTN
     C                   RESET                   W#TOTV           13 0
      *
      ** Access securities trading details
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
     C*
      *
      ** Send error message if control nominal is blank
      *
     C                   IF        IKCNTN = *BLANKS
     C                   MOVE      'MMA0761'     MSG1
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
 
      *
      ** Send error message if control nominal is not equal to the sum of
      ** all the nominals of securities delivered
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      IKCNTN        ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD
     C                   PARM      4             ZADEC
     C                   PARM      11            ZADIG
      *
      ** Send error message if Control Nominal is not in a Valid Format
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'MMA0777'     MSG4
     C                   MOVE      'Y'           ErrorFound        1
     C                   ELSE
     C                   MOVE      ZFIELD        IFCNTN
     C
     C** Re-Format Control nominal for screen dsiplay
     C
     C                   MOVE      ZFIELD        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      4             ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVE      ZOUT21        IKCNTN
     C
     C** Re-Format Total nominal for screen dsiplay
     C
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      IFTOTN        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      4             ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVE      ZOUT21        IKTOTN
     C
     C
     C                   IF        IFCNTN <> IFTOTN
     C                   MOVE      'MMA0762'     MSG2
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
     C                   ENDIF
      *
      ** Total of Values must lie within Repo Cash Tolerance limits
      ** of deal amount
      *
     C
     C     DealAmt       MULT      BVRCTU        W#TOTV           13 0
     C     W#TOTV        DIV       100           HiTotVal         13 0
     C     HiTotVal      ADD       DealAmt       HiTotVal
     C
     C                   Z-ADD     0             W#TOTV
     C     DealAmt       MULT      BVRCTL        W#TOTV
     C     W#TOTV        DIV       100           LoTotVal         13 0
     C     DealAmt       SUB       LoTotVal      LoTotVal
     C
     C                   IF        IFTOTV < LoTotVal or IFTOTV > HiTotVal
     C                   MOVE      'MMA0763'     MSG3
     C                   MOVE      'Y'           ErrorFound        1
     C                   ENDIF
 
     C** Access no of decimal places of Loan Ccy to format value price
     C** and interest
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      LoanCcy       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C
     C                   MOVE      A6NBDP        ZADEC
     C                   MOVE      IFTOTV        ZFLD15
     C
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM                    ZOUT21           21
     C
     C                   MOVE      *BLANKS       IKTOTV
     C                   MOVE      ZOUT21        IKTOTV
      *
      *
     C                   IF        ErrorFound = 'W'
     C                   EVAL      ReturnCode = 'Warning'
     C                   ENDIF
      *
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      ReturnCode = 'Error'
     C                   ENDIF
      *
     C                   RETURN
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    WMSG1
      * Receive Screen Format Input
     C                   PARM                    TranIn
      * Receive Loan Currency
     C                   PARM                    LoanCcy
      * Receive Deal Amount
     C                   PARM                    DealAmt
      * Receive File Format Input
     C                   PARM                    ValidRepo
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMEXCR'      DBPGM
     C                   OUT       LDA
     C                   ENDSR
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
