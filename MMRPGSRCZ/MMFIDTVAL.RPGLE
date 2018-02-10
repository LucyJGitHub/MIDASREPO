     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Fiduciary Takings Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market ILE Module                              *
      *                                                               *
      *  MMFIDTVAL - Fiduciary Takings Validation                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD033924           Date 27Mar15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9827            Date 27Jan05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905  *CREATE    Date 25Sep02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD033924 - Cannot Insert Fiduciary Fixed-Term Placing        *
      *             and Call Placing                                  *
      *  BUG9827 - Fiduciary deal changes for Midas Plus              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  209905 - Fiduciary API Enhancement                           *
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
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
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
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
     D DealNoArr       S              6A   DIM(88)
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** External DS for Portfolio Management ICD
 
     D***WFIDTDTL        DS            42                                                     CGL029
     D WFIDTDTL        DS            48                                                       CGL029
     D  SFDLNO                 1      6
     D  SFCNUM                 7     16
     D  SFPTFR                17     20
     D  SFAMNT                21     35
     D***SFACOD                36     39                                                      CGL029
     D***SFACSQ                40     41                                                      CGL029
     D***SFTRAS                42     42                                                      CGL029
     D  SFACOD                36     45                                                       CGL029
     D  SFACSQ                46     47                                                       CGL029
     D  SFTRAS                48     48                                                       CGL029
 
     D***VFIDTDTL        DS            42                                                     CGL029
     D VFIDTDTL        DS            48                                                       CGL029
     D  VSFDLNO                1      6
     D  VSFCNUM                7     16
     D  VSFPTFR               17     20
     D  VSFAMNT               21     35
     D***VSFACOD               36     39                                                      CGL029
     D***VSFACSQ               40     41                                                      CGL029
     D***VSFTRAS               42     42                                                      CGL029
     D  VSFACOD               36     45                                                       CGL029
     D  VSFACSQ               46     47                                                       CGL029
     D  VSFTRAS               48     48                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D I               S              3P 0
     D OKFIDTDTL       S              1A
     D BGPFMG          S              1A
     D OKDealNo        S              1A
     D OKCustNum       S              1A
     D OKPortRef       S              1A
     D OKAmount        S              1A
     D OKAcctCode      S              1A
     D OKAcctSeq       S              1A
     D OKTrust         S              1A
     D PAction         S              1A
     D PBranch         S              3A
     D PCurrency       S              3A
     D PCustNum        S              6A
     D PDealNo         S              6A
     D PDealType       S              2A
     D WTAmount        S             15S 0
     D WPTFRInd        S              1A
     D WKDealNo        S              3A                                                    MD033924
 
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
 
      ** Validate Deal Number
 
     C                   EVAL      WKDealNo = RetCodeIn                                     MD033924
     C                   IF        PAction = 'I'                                             BUG9827
     C                   EXSR      SRDealNo
     C                   Else                                                                BUG9827
     C                   Eval      OKDealNo = 'Y'                                            BUG9827
     C                   EndIf                                                               BUG9827
     C                   IF        OKDealNo = 'Y'
     C                   EVAL      VSFDLNO = SFDLNO
     C                   ENDIF
     C                   IF        WKDealNo = '001'                                         MD033924
     C                   MOVEA     *BLANKS       DealNoARR                                  MD033924
     C                   ENDIF                                                              MD033924
 
      ** Validate Customer Number
 
     C                   EXSR      SRCustNum
     C                   IF        OKCustNum = 'Y'
     C                   EVAL      VSFCNUM = SFCNUM
     C                   ENDIF
 
      ** Validate Portfolio Reference
 
     C                   EXSR      SRPortRef
     C                   IF        OKPortRef = 'Y'
     C                   EVAL      VSFPTFR = SFPTFR
     C                   ENDIF
 
      ** Validate Amount
 
     C                   EXSR      SRAmount
     C                   IF        OKAmount = 'Y'
     C                   EVAL      VSFAMNT = SFAMNT
     C                   ENDIF
 
      ** Validate Account Code
 
     C                   EXSR      SRAcctCode
     C                   IF        OKAcctCode = 'Y'
     C                   EVAL      VSFACOD = SFACOD
     C                   ENDIF
 
      ** Validate Account Sequence
 
     C                   EXSR      SRAcctSeq
     C                   IF        OKAcctSeq = 'Y'
     C                   EVAL      VSFACSQ = SFACSQ
     C                   ENDIF
 
      ** Validate Trust Agreement Status
 
     C                   Exsr      SRTrust
     C                   IF        OKTrust = 'Y'
     C                   EVAL      VSFTRAS = SFTRAS
     C                   ENDIF
 
     C                   IF        OKDealNo = 'N' or OKCustNum = 'N' or
     C                             OKPortRef = 'N' or OKAmount = 'N' or
     C                             OKAcctCode = 'N' or OKAcctseq = 'N' or
     C                             OKTrust = 'N'
     C                   EVAL      OKFIDTDTL = 'N'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRDealNo - Validate Deal Number                               *
      *                                                               *
      *****************************************************************
 
     C     SRDealNo      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVFDLNO'
      ** Inputs
      ** Return Code
      ** Deal Number (Placing)
      ** Work Deal Number
      ** Valid Deal Number Array
     C                   PARM                    RetCodeIn
     C                   PARM                    PDealNo
     C                   PARM                    SFDLNO
     C                   PARM                    DealNoARR
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKDealNo
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRCustNum - Validate Customer Number                          *
      *                                                               *
      *****************************************************************
 
     C     SRCustNum     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Customer Number
 
     C                   CALLB     'MMVFCUST'
      ** Inputs
      ** Return Code
      ** Deal Type
      ** Work Customer Number
     C                   PARM                    RetCodeIn
     C                   PARM                    PDealType
     C                   PARM                    SFCNUM
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKCustNum
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRPortRef - Validate Portfolio Reference                      *
      *                                                               *
      *****************************************************************
 
     C     SRPortRef     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Portfolio Reference
 
     C                   CALLB     'MMVFPREF'
      ** Inputs
      ** Return Code
      ** Portfolio Management Indicator
      ** Work Customer Number
      ** Work Portfolio Reference
      ** Portfolio Management ICD
     C                   PARM                    RetCodeIn
     C                   PARM                    BGPFMG
     C                   PARM                    SFCNUM
     C                   PARM                    SFPTFR
     C                   PARM                    SDPORT
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
      ** Portfolio Reference Work Indicator
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKPortRef
     C                   PARM                    WPTFRInd
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRAmount - Validate Amount                                    *
      *                                                               *
      *****************************************************************
 
     C     SRAmount      BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Amount
 
     C                   CALLB     'MMVFAMNT'
      ** Inputs
      ** Return Code
      ** Currency
      ** Work Amount
     C                   PARM                    RetCodeIn
     C                   PARM                    PCurrency
     C                   PARM                    SFAMNT
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
      ** Fiduciary Takings Amount
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKAmount
     C                   PARM                    WTAmount
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRAcctCode - Validate Account Code                            *
      *                                                               *
      *****************************************************************
 
     C     SRAcctCode    BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Code
 
     C                   CALLB     'MMVFACOD'
      ** Inputs
      ** Return Code
      ** Work Customer Number
      ** Work Account Code
     C                   PARM                    RetCodeIn
     C                   PARM                    SFCNUM
     C                   PARM                    SFACOD
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKAcctCode
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRAcctSeq - Validate Account Code Sequence                    *
      *                                                               *
      *****************************************************************
 
     C     SRAcctSeq     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Account Code Sequence
 
     C                   CALLB     'MMVFACSQ'
      ** Inputs
      ** Return Code
      ** Work Customer Number
      ** Work Account Code
      ** Work Account Code Sequence
      ** Currency
      ** Branch
      ** Work Portfolio Reference
      ** Portfolio Management ICD
      ** Portfolio Management Indicator
      ** Portfolio Reference Work Indicator
     C                   PARM                    RetCodeIn
     C                   PARM                    SFCNUM
     C                   PARM                    SFACOD
     C                   PARM                    SFACSQ
     C                   PARM                    PCurrency
     C                   PARM                    PBranch
     C                   PARM                    SFPTFR
     C                   PARM                    SDPORT
     C                   PARM                    BGPFMG
     C                   PARM                    WPTFRInd
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKAcctSeq
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRTrust - Validate Trust Agreement                            *
      *                                                               *
      *****************************************************************
 
     C     SRTrust       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Trust Agreement
 
     C                   CALLB     'MMVFTRAG'
      ** Inputs
      ** Return Code
      ** Deal Type
      ** Work Trust Agreement
     C                   PARM                    RetCodeIn
     C                   PARM                    PDealType
     C                   PARM                    SFTRAS
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** OK Flag
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OKTrust
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *             from each validation module                       *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeIn = *BLANKS
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *             from each validation module                       *
      *                                                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANKS       LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANKS       LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Return Code
      ** Action Code
      ** Deal Number
      ** Currency Code
      ** Deal Type
      ** Customer Number
      ** Fiduciary Takings Work Array
      ** Portfolio Management Indicator
      ** Portfolio Management ICD
      ** Fiduciary Takings Amount
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PAction
     C                   PARM                    PDealNo
     C                   PARM                    PBranch
     C                   PARM                    PCurrency
     C                   PARM                    PDealType
     C                   PARM                    PCustNum
     C                   PARM                    WFIDTDTL
     C                   PARM                    BGPFMG
     C                   PARM                    SDPORT
     C                   PARM                    WTAmount
 
      ** Outputs
      ** Fiduciary Takings Details OK Indicator
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Warning array index (3P0) from/to caller
      ** Fiduciary Takings Valid Array
      ** Restriction Narrative 1 - 4
 
     C                   PARM                    OKFIDTDTL
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    VFIDTDTL
 
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
