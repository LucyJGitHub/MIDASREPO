     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate subfile header records')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMRPDL2VL - MM Repo Header Validation                        *
      *                                                               *
      *  Function: This Program Validates Repo Header Details         *
      *            Entered via the repurchase agreements subfile.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
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
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D DDDPAD          S              6A
      ** Blank Field Passed to SEDPMVVAL
 
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
 
      ** Loan/Deposit Ccy
     D LoanCcy         S              3
 
      ** Branch
     D Branch          S              3
 
      ** Deal Amount
     D DealAmt         S             15S 0
 
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
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long Data Structure for Access Programs
 
     D ValidRepo     E DS                  EXTNAME(MMVRPDHPD)
      * Valid Repo Delivery Details
 
     D TranIn        E DS                  EXTNAME(MMRPDHPD)
     D                                     PREFIX(IK:2)
     D QQACCN1       E                     EXTFLD(QQACCN)                                     CGL029
      * Incoming Transaction
 
     D OKFlagsDS     E DS                  EXTNAME(MMERPDHPD)
      * Error Indicator flags
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The maximum size of the appended error arrays
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
 
     D XArrayMax       C                   CONST(20)
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
     C
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
     C
      ** Validate Control Nominal
     C                   CALLB     'MMVTONO'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    WMSG1
     C                   PARM                    TranIn
     C                   PARM                    LoanCcy
     C                   PARM                    DealAmt
     C                   PARM                    ValidRepo
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKCNTN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKCNTN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
     C*
     C** Do not check Repo tolernace limits if F9 has been pressed
     C     @INKI         IFNE      '1'
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKCNTN'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     WMSG1         IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'IKCNTN'
     C                   EVAL      WMsgIDArr(WIdx) = WMSG1
     C                   ENDIF
     C                   ENDIF
     C
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKCNTN'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C
      ** Use the return code's value to set the field's OK flag
     C                   IF        MSG1 <> *Blanks or MSG2 <> *Blanks
     C                             or MSG4 <> *Blanks
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKCNTN
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C*
     C** Do not check Repo tolernace limits if F9 has been pressed
     C     @INKI         IFNE      '1'
     C************       IF        MSG3 <> *Blanks
     C                   IF        MSG3 <> *Blanks or WMSG1 <> *Blanks
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKTOTV
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      RESETERRS
     C
      ** Validate Fee Details
     C                   CALLB     'MMVFEAM'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    TranIn
     C                   PARM                    ValidRepo
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKFEAM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKFECY'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKFECY'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKFECY'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C
      ** Use the return code's value to set the field's OK flag
     C                   IF        MSG2 <> *Blanks
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKFECY
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
     C
     C                   IF        MSG1 <> *Blanks or MSG3 <> *Blanks
     C                             or MSG4 <> *Blanks
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKFEAM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF
     C
     C                   EXSR      RESETERRS
     C
      ** Validate Settlement Method
     C                   CALLB     'MMVSEMH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    TranIn
     C                   PARM                    ValidRepo
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKFESM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKFESM'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKFESM
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C
     C                   EXSR      RESETERRS
     C
      ** Validate Settlement Method
     C                   CALLB     'MMVSEAC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    TranIn
     C                   PARM                    Branch
     C                   PARM                    ValidRepo
     C
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACCN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACCN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACCN'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'IKACCN'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    OKACCN
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C**                 MOVE      *ON           *INLR
     C                   RETURN
 
     C********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset Error processing indicators                    *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg3
     C                   RESET                   Msg4
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
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
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    LoanCcy
     C                   PARM                    Branch
     C                   PARM                    DealAmt
      * Receive Datastructure for Error indicatirs flags
     C                   PARM                    OKFlagsDS
      * Receive Datastructure for Field Name Array
     C                   PARM                    FldNameArr
      * Receive Datastructure for Message ID Array
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
      * Transaction information (DS) from source system
     C                   PARM                    ValidRepo
     C                   PARM                    @INKI             1
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMRPDL2VL'   DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
