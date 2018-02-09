     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-a/c Holder by Country of Tax - Val')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNATXVAL - SD Non-a/c Holder by Country of Tax - Validation *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR742751           Date 07Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22559           Date 11Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR742751 - Database Control Error encountered in Non Acct    *
      *             Holder Mnt (Child : AR742756)                     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22559 - CUSD Country of Taxes date fields are populating  *
      *             after validation (Recompile)                      *
      *  CER048 - German Features - Taxes                             *
      *  236137 - Change Control for CGL031                           *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCCTXV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
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
 
      ** Current Subfile Details
     D NwSflFmt      E DS                  Extname(SDNATXPD)
 
      ** New Details in File Format
     D NwFilFmt      E DS                  Extname(SDVNATXPD)
 
      ** Customer Details OK indicators
     D OkFlags       E DS                  Extname(SDENATXPD)
 
      ** Valid Customer Details                                                             AR742751
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)                               AR742751
     D                                     PREFIX(A_)                                       AR742751
      ** Valid Additional Customer Details                                                  AR742751
     D ValidCuad     E DS                  EXTNAME(SDVCUADPD)                               AR742751
     D                                     PREFIX(B_)                                       AR742751
                                                                                            AR742751
      ** Screen format of SDCCTXSIN
      ** to be used in validation modules
     D CCTXScrnFmt   E DS                  Extname(SDCCTXPD)
     D                                     Prefix(@)
 
      ** New File Details in CCTX Format
      ** to be used in validation modules
     D CCTXFileFmt   E DS                  Extname(SDVCCTXPD)
 
      ** CCTX Error Flag format
      ** to be used in validation modules
     D CCTXOkFlags   E DS                  Extname(SDECCTXPD)
     D                                     Prefix(@)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)
 
      **  Certificate Expiry and Status Cross Validation Field
     D DDCERT                        20A
 
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
                                                                                              CER048
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Mode of Operation
     D PModeOfOp       S              6A
 
      ** Response Mode
     D PRespMode       S              1A
 
      ** Work fields for bank data
     D WKDFIN          S                   Like(BJDFIN)
     D WKRDNB          S                   Like(BJRDNB)
     D WKCYCD          S                   Like(BJCYCD)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D I               S              3P 0
     D CER048          S              1A                                                      CER048
     D PReturnCd       S              6A                                                      CER048
      *                                                                                       CER048
      ** Parameters for access object programs                                                CER048
      *                                                                                       CER048
     D PRtCd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
     D PCalledF        S              1A                                                      CER048
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCCTXV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Format SDCCTXBRW screen and error indicators for use
      ** in validation modules
 
     C                   EXSR      SRFmtCCTXscrn
 
      ** Validate Tax Status
 
     C                   EXSR      SRTAX
 
      ** Validate Certificate Reference
 
     C                   EXSR      SRCERT
 
      ** Validate Certificate of Expiry Date
 
     C                   EXSR      SRCEEX
 
      ** Validate Customer Tax Status                                                         236137
                                                                                              236137
     C                   EXSR      SRCSTS                                                     236137
                                                                                              236137
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
      ** Validate Certificate Type                                                            CER048
      *                                                                                       CER048
     C                   EXSR      SRCrtp                                                     CER048
      *                                                                                       CER048
      ** Validate Certificate Approval Date                                                   CER048
      *                                                                                       CER048
     C                   EXSR      SRCadt                                                     CER048
      *                                                                                       CER048
      ** Validate Certificate Value Date                                                      CER048
      *                                                                                       CER048
     C                   EXSR      SRCvdt                                                     CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Format SDVNATXPD file format with validated fields
 
     C                   EXSR      SRFmtNATXfile
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFmtCCTXscrn - Format CCTX screen format                    *
      *****************************************************************
     C     SRFmtCCTXscrn BEGSR
 
     C                   EVAL      @DDETXS = DDETXS
     C                   EVAL      @DDCERF = DDCERF
     C                   EVAL      @DDCEEX = DDCEEX
     C                   EVAL      @DDCSTS = DDNSTS                                           236137
      *                                                                                       CER048
     C                   IF        CER048  = 'Y'                                              CER048
      *                                                                                       CER048
     C                   EVAL      @DDCRTP = DDCRTP                                           CER048
     C                   EVAL      @DDCADT = DDCADT                                           CER048
     C                   EVAL      @DDCVDT = DDCVDT                                           CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFmtNATXfile - Format NATX file format                      *
      *****************************************************************
     C     SRFmtNATXfile BEGSR
 
     C                   EVAL      OKCEEX = @OKCEEX
      *                                                                                       CER048
     C                   IF        CER048  = 'Y'                                              CER048
     C                   EVAL      OKCRTP = @OKCRTP                                           CER048
     C                   EVAL      OKCADT = @OKCADT                                           CER048
     C                   EVAL      OKCVDT = @OKCVDT                                           CER048
     C                   ENDIF                                                                CER048
 
     C                   IF        Idx < 1
     C                   EVAL      NTCERF = DDCERF
     C                   EVAL      NTCEEX = CTCEEX
      *                                                                                       CER048
     C                   IF        CER048  = 'Y'                                              CER048
      *                                                                                       CER048
     C                   EVAL      NTCRTP = CTCRTP                                            CER048
     C                   EVAL      NTCADT = CTCADT                                            CER048
     C                   EVAL      NTCVDT = CTCVDT                                            CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRTAX - Validate European Tax Status                         *
      *****************************************************************
     C     SRTAX         BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRResetEr
 
      ** Validate Tax Status
 
     C                   CALLB     'SDVTXST02'
 
      * Input Parameters :
 
      ** Return Code
      ** Mode Of Operation                                                                    232543
      ** Screen details in screen format
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PModeOfOp                                    232543
     C                   PARM                    NwSflFmt
 
      * Output Parameters :
 
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Error Flags
      ** New Details in File Format
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    OkFlags
     C                   PARM                    NwFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdErr
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRCERT - Validate Certificate Reference                      *
      *****************************************************************
     C     SRCERT        BEGSR
 
     C                   EVAL      OKCERF = 'Y'
 
      ***Certifact**of Reference should be blank if Status is not 'S'                         232543
      **********                                                                              232543
     C**********         IF        DDETXS <> 'S' AND DDCERF <> *Blanks                        232543
     C**********         EVAL      Idx = Idx + 1                                              232543
     C**********         EVAL      FldNameArr(Idx) = 'DDCERF'                                 232543
     C**********         EVAL      MsgIdArr(Idx) = 'USR4792'                                  232543
     C**********         EVAL      OKCERF = 'N'                                               232543
     C**********         ENDIF                                                                232543
 
      ** Free Format Certificate must be input if Tax Status is 'S'.
 
     C                   IF        DDCERF = *Blanks
     C                             And DDETXS = 'S'
 
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDCERF'
     C                   EVAL      MsgIDArr(Idx) = 'USR4783'
     C                   EVAL      OKCERF = 'N'
 
     C**********         ELSE                                                                 232543
     C**********         EVAL      OKCERF = 'Y'                                               232543
     C                   ENDIF
                                                                                              232543
      ** Certificate must be input if Expiry Date has been entered.                           232543
                                                                                              232543
     C                   IF        DDCERF = *Blanks                                           232543
     C                             And DDCEEX <> *Blanks                                      232543
     C                   EVAL      Idx = Idx + 1                                              232543
     C                   EVAL      FldNameArr(Idx) = 'DDCERF'                                 232543
     C                   EVAL      MsgIDArr(Idx) = 'USR4800'                                  232543
     C                   EVAL      OKCERF = 'N'                                               232543
     C                   ENDIF                                                                232543
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRCEEX - Validate Certificate Expiry Date                    *
      *****************************************************************
     C     SRCEEX        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      SRResetEr
 
      ** Validate Certificate Expiry Date
 
     C                   CALLB     'SDVCEXP01'
 
      * Input Parameters :
 
      ** Return Code
      ** Screen details in CCTX screen format
      ** Date Format Indicator
      ** Current Date
     C                   PARM                    RetCodeIn
     C                   PARM                    PModeOfOp                                  AR742751
     C                   PARM                    CCTXScrnFmt
     C                   PARM                    BJDFIN
     C                   PARM                    BJRDNB
     C                   PARM                    ValidCusd                                  AR742751
     C                   PARM                    ValidCuad                                  AR742751
 
      * Output Parameters :
 
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Error Flags in CCTX error format
      ** New Details in CCTX File Format
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    CCTXOkFlags
     C                   PARM                    CCTXFileFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdErr
 
     C                   ENDSR
      *****************************************************************                       236137
     C/EJECT                                                                                  236137
      *****************************************************************                       236137
      *                                                               *                       236137
      * SRCSTS - Validate Customer Tax Status                         *                       236137
      *                                                               *                       236137
      *****************************************************************                       236137
     C     SRCSTS        BEGSR                                                                236137
                                                                                              236137
     C                   EVAL      oknsts = 'Y'                                               236137
     C                   EVAL      NTNSTS = DDNSTS                                            236137
                                                                                              236137
      **  Customer Tax Status is mandatory                                                    236137
                                                                                              236137
     C                   IF        DDNSTS = *BLANKS                                           236137
     C                   ADD       1             Idx                                          236137
     C                   EVAL      FldNameArr(Idx) = 'DDNSTS'                                 236137
     C                   EVAL      MsgIDArr(Idx) = 'USR4920'                                  236137
     C                   EVAL      oknsts = 'N'                                               236137
                                                                                              236137
     C                   ELSE                                                                 236137
                                                                                              236137
      **  Customer Tax Status must be 'A' or 'N' or 'C'                                       236137
                                                                                              232543
     C                   IF        DDNSTS <> 'A' AND                                          232543
     C                             DDNSTS <> 'N' AND                                          232543
     C                             DDNSTS <> 'C'                                              232543
     C                   EVAL      Idx = Idx + 1                                              232543
     C                   EVAL      FldNameArr(Idx) = 'DDNSTS'                                 232543
     C                   EVAL      MsgIDArr(Idx) = 'USR4921'                                  232543
     C                   EVAL      oknsts = 'N'                                               232543
     C                   ELSE                                                                 232543
     C                   EVAL      NTNSTS = DDNSTS                                            232543
     C                   ENDIF                                                                232543
     C                   ENDIF                                                                232543
                                                                                              232543
     C                   ENDSR                                                                232543
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *                       CER048
      * SRCrtp - Validate Certificate Type                            *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCrtp        BEGSR                                                                CER048
      *                                                                                       CER048
      ** Reset variables                                                                      CER048
      *                                                                                       CER048
     C                   EXSR      SRResetEr                                                  CER048
     C                   CALLB     'SDVCRTP01'                                                CER048
     C                   PARM                    PReturnCd                                    CER048
     C                   PARM                    CCTXScrnFmt                                  CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIDXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    CCTXOkFlags                                  CER048
     C                   PARM                    CCTXFileFmt                                  CER048
      *                                                                                       CER048
      ** Update error info with that returned from validation module                          CER048
      *                                                                                       CER048
     C                   EXSR      SRUpdErr                                                   CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
     C/EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRCadt - Validate Certificate Approval Date                   *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCadt        BEGSR                                                                CER048
      *                                                                                       CER048
      ** Reset variables                                                                      CER048
      *                                                                                       CER048
     C                   EXSR      SRResetEr                                                  CER048
     C                   EVAL      PCalledF = 'A'                                             CER048
     C                   CALLB     'SDVSIDT01'                                                CER048
     C                   PARM                    PReturnCd                                    CER048
     C                   PARM                    CCTXScrnFmt                                  CER048
     C                   PARM                    PCalledF                                     CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    BJRDNB                                       CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIDXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    CCTXOkFlags                                  CER048
     C                   PARM                    CCTXFileFmt                                  CER048
      *                                                                                       CER048
      ** Update error info with that returned from validation module                          CER048
      *                                                                                       CER048
     C                   EXSR      SRUpdErr                                                   CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
     C/EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRCvdt - Validate Certificate Value Date                      *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCvdt        BEGSR                                                                CER048
      *                                                                                       CER048
      ** Reset variables                                                                      CER048
      *                                                                                       CER048
     C                   EXSR      SRResetEr                                                  CER048
     C                   EVAL      PCalledF = 'V'                                             CER048
     C                   CALLB     'SDVSIDT01'                                                CER048
     C                   PARM                    PReturnCd                                    CER048
     C                   PARM                    CCTXScrnFmt                                  CER048
     C                   PARM                    PCalledF                                     CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    BJRDNB                                       CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIDXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    CCTXOkFlags                                  CER048
     C                   PARM                    CCTXFileFmt                                  CER048
      *                                                                                       CER048
      ** Update error info with that returned from validation module                          CER048
      *                                                                                       CER048
     C                   EXSR      SRUpdErr                                                   CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
     C/EJECT                                                                                  CER048
      *****************************************************************                       CER048
      * SRResetEr - Reset error information that is received back     *
      *             from each validation module.                      *
      *****************************************************************
     C     SRResetEr     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdErr - Update error information with that received back   *
      *            from each validation module.                       *
      *****************************************************************
     C     SRUpdErr      BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   EVAL      I = 1
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   EVAL      I = 1
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C                   EVAL      Idx = I - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      *  Input Paramters :
 
      ** Return Code
      ** Mode of Operation
      ** Response mode
      ** New Details in Subfile Format
     C                   PARM      *Blanks       RetCodeIn
     C                   PARM                    PModeOfOp
     C                   PARM                    PRespMode
     C                   PARM                    NwSflFmt
 
      * Output Parameters :
 
      ** Error Flags
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Error message index
      ** New Details in File Format
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    NwFilFmt
 
      ** Access BanK Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *Blanks
     C     *Lock         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = @OPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *                                                                                       CER048
      ** Check if CER048 is installed                                                         CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtCd <> *BLANKS AND                                       CER048
     C                             PRtCd <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   MOVE      '904'         DBASE                                        CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
