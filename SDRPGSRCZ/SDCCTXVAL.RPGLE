     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Val')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCCTXVAL - Customer Details by Country of Tax Validation    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR855391           Date 27Oct11               *
      *                 CSD091             Date 04Jun11               *
      *                 AR740196           Date 03Apr11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26250           Date 30Sep09               *
      *                 BUG22559           Date 11Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 236137             Date 21Sep05               *
      *  Prev Amend No. 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *  Prev Amend No. CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR855391 - CUSD Overridable Errors not found in EN System    *
      *  CSD091 - Overrideable Errors Configurability Enabler Phase 2 *
      *  AR740196  - Cannot enquire on deal for non-resident using    *
      *              Deals Enquiry (Child:AR740197)                   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26250 - Customer Details By Country of Tax Maintenance    *
      *             Error. All cert. fields for all status should be  *
      *             optional.                                         *
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
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
 
      ** New Details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)
 
      ** Valid Customer Details                                                             AR740196
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)                               AR740196
     D                                     PREFIX(A_)                                       AR740196
      ** Valid Additional Customer Details                                                  AR740196
     D ValidCuad     E DS                  EXTNAME(SDVCUADPD)                               AR740196
     D                                     PREFIX(B_)                                       AR740196
                                                                                            AR740196
      ** Screen Error Indicator
     D OKFlags       E DS                  EXTNAME(SDECCTXPD)
      *                                                                                       CER048
      ** Data Structure for SAR Details                                                       CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      *                                                                                       CER048
      ** Short Data Structure                                                                 CER048
      *                                                                                       CER048
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER048
                                                                                            BUG26250
      ** Long Data Structure                                                                BUG26250
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG26250
                                                                                            BUG26250
      ** Customer Details                                                                   BUG26250
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                BUG26250
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Work Index
     D Ix              S              3P 0
 
     ***Index*for*arrays*of*warning*message*ids*etc*                                 CSD091 AR855391
     D*WIdx*****       S              3P 0                                           CSD091 AR855391
                                                                                     CSD091 AR855391
      ** Mode of Operation
     D PModeOfOp       S              6A
 
      ** Response Mode
     D PRespMode       S              1A
 
      ** Date Format Indicator
     D BJDFIN          S              1A
 
      ** Rundate
     D BJRDNB          S              5P 0
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D PCalledF        S              1A                                                      CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
     D PKEY1           S             10A                                                    BUG26250
     D PKYST           S              7A                                                    BUG26250
     D WResi           S              1A                                                    BUG26250
 
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
 
      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************
 
     C                   IF        PModeOfOp =  '*VU '                                      AR740196
     C                   EVAL      BBCOLC  = A_CUCOLC                                       AR740196
     C                   ENDIF                                                              AR740196
                                                                                            AR740196
      ** Validate Tax Status
 
     C                   EXSR      SRTAX
 
      ** Check if customer is resident or non resident                                      BUG26250
                                                                                            BUG26250
     C                   EXSR      SRRESI                                                   BUG26250
                                                                                            BUG26250
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
     C                   EVAL      *INLR = *ON                                                232543
                                                                                              232543
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRTAX - Validate European Tax Status                          *
      *                                                               *
      *****************************************************************
     C     SRTAX         BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Tax Status
 
     C                   CALLB     'SDVTXST01'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    RetCodeOut
                                                                                              232543
     C                   PARM                    PModeOfOp                                    232543
 
      ** New Detail in Screen Format
     C                   PARM                    NwDLScnFmt
 
     C                   PARM                    ValidCusd                                  AR740196
     C                   PARM                    ValidCuad                                  AR740196
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Screen Error Indicator
     C                   PARM                    OKFlags
 
      ** New Details in File Format
     C                   PARM                    NwDlFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                     BUG26250
      *                                                               *                     BUG26250
      * SRRESI - Check if customer is a resident or non resident      *                     BUG26250
      *                                                               *                     BUG26250
      *****************************************************************                     BUG26250
     C     SRRESI        BEGSR                                                              BUG26250
                                                                                            BUG26250
     C                   EVAL      WResi = 'N'                                              BUG26250
                                                                                            BUG26250
     C                   IF        PModeOfOp <> '*VU '                                      AR740196
     C                   CALL      'AOCUSTR1'                                               BUG26250
     C                   PARM      *BLANKS       PRTCD                                      BUG26250
     C                   PARM      '*KEY   '     POPTN                                      BUG26250
     C                   PARM      DDCUST        PKEY1                                      BUG26250
     C                   PARM                    PKYST                                      BUG26250
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG26250
     C                   ENDIF                                                              AR740196
      *                                                                                     BUG26250
      ** If country of location is equal to country of tax code, customer is                BUG26250
      ** a resident                                                                         BUG26250
      *                                                                                     BUG26250
     C                   IF        PRTCD = *BLANKS                                          BUG26250
     C                   IF        BBCOLC = DDCTTX                                          BUG26250
     C                   EVAL      WResi  = 'Y'                                             BUG26250
     C                   ENDIF                                                              BUG26250
     C                   ENDIF                                                              BUG26250
      *                                                                                     BUG26250
     C                   ENDSR                                                              BUG26250
                                                                                            BUG26250
      *****************************************************************                     BUG26250
     C/EJECT                                                                                BUG26250
      *****************************************************************
      *                                                               *
      * SRCERT - Validate Certificate Reference                       *
      *                                                               *
      *****************************************************************
     C     SRCERT        BEGSR
 
     C                   EVAL      OKCERF = 'Y'
     C                   EVAL      CTCERF = DDCERF
 
      ** Free Format Certificate must be input if Tax Status is 'S'
 
     C                   IF        DDCERF = *BLANKS AND
     C**********                   DDETXS = 'S'                                             BUG26250
     C                             DDETXS = 'S' AND WResi = 'N'                             BUG26250
 
     C**********         ADD       1             Idx                                          CSD091
     C**********         EVAL      FldNameArr(Idx) = 'DDCERF'                                 CSD091
     C**********         EVAL      MsgIDArr(Idx) = 'USR4783'                                  CSD091
     C**********         EVAL      OKCERF = 'N'                                               CSD091
 
     C**********         EVAL      WIdx = WIdx + 1                                   CSD091 AR855391
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDCERF'                        CSD091 AR855391
     C**********         EVAL      WMsgIDXAr(WIdx) = 'USR4783'                       CSD091 AR855391
     C**********         EVAL      OKCERF = 'W'                                      CSD091 AR855391
                                                                                              CSD091
     C                   ADD       1             Idx                                        AR855391
     C                   EVAL      FldNameArr(Idx) = 'DDCERF'                               AR855391
     C                   EVAL      MsgIDArr(Idx) = 'USR4783'                                AR855391
     C                   EVAL      OKCERF = 'N'                                             AR855391
     C**********         ELSE                                                                 232543
     C**********         EVAL      OKCERF = 'Y'                                               232543
     C**********         EVAL      CTCERF = DDCERF                                            232543
     C                   ENDIF
 
      ***Certifacte*of*Reference*should*be*blank*if*Status*is*not*'S'********                 232543
      ***********************************************************************                 232543
     C**********         IF        DDETXS <> 'S' AND DDCERF <> *Blanks                        232543
     C**********         ADD       1             Idx                                          232543
     C**********         EVAL      FldNameArr(Idx) = 'DDCERF'                                 232543
     C**********         EVAL      MsgIdArr(Idx) = 'USR4792'                                  232543
     C**********         EVAL      OKCERF = 'N'                                               232543
     C**********         ENDIF                                                                232543
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
      *                                                               *
      * SRCEEX - Validate Certificate Expiry Date                     *
      *                                                               *
      *****************************************************************
     C     SRCEEX        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Certificate Expiry Date
 
     C                   CALLB     'SDVCEXP01'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
     C                   PARM                    PModeOfOp                                  AR740196
      ** New Detail in Screen Format
     C                   PARM                    NwDLScnFmt
 
      ** Date Format Indicator
     C                   PARM                    BJDFIN
 
      ** Rundate
     C                   PARM                    BJRDNB
 
     C                   PARM                    ValidCusd                                  AR740196
     C                   PARM                    ValidCuad                                  AR740196
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Screen Error Indicator
     C                   PARM                    OKFlags
 
      ** New Details in File Format
     C                   PARM                    NwDlFilFmt
 
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
 
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
     C                   EVAL      OKCSTS = 'Y'                                               236137
                                                                                              236137
      **  Customer Tax Status is mandatory                                                    236137
                                                                                              236137
     C                   IF        DDCSTS = *BLANKS                                           236137
     C                   ADD       1             Idx                                          236137
     C                   EVAL      FldNameArr(Idx) = 'DDCSTS'                                 236137
     C                   EVAL      MsgIDArr(Idx) = 'USR4920'                                  236137
     C                   EVAL      OKCSTS = 'N'                                               236137
                                                                                              236137
     C                   ELSE                                                                 236137
                                                                                              236137
      **  Customer Tax Status must be 'A' or 'N' or 'C'                                       236137
                                                                                              236137
     C                   IF        DDCSTS <> 'A' AND                                          236137
     C                             DDCSTS <> 'N' AND                                          236137
     C                             DDCSTS <> 'C'                                              236137
     C**********         EVAL      Idx = Idx + 1                                       236137 CSD091
     C**********         EVAL      FldNameArr(Idx) = 'DDCSTS'                          236137 CSD091
     C**********         EVAL      MsgIDArr(Idx) = 'USR4921'                           236137 CSD091
     C**********         EVAL      OKCSTS = 'N'                                        236137 CSD091
                                                                                              CSD091
     C**********         EVAL      WIdx = WIdx + 1                                   CSD091 AR855391
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDCSTS'                        CSD091 AR855391
     C**********         EVAL      WMsgIDXAr(WIdx) = 'USR4921'                       CSD091 AR855391
     C**********         EVAL      OKCSTS = 'W'                                      CSD091 AR855391
                                                                                            AR855391
     C                   EVAL      Idx = Idx + 1                                            AR855391
     C                   EVAL      FldNameArr(Idx) = 'DDCSTS'                               AR855391
     C                   EVAL      MsgIDArr(Idx) = 'USR4921'                                AR855391
     C                   EVAL      OKCSTS = 'N'                                             AR855391
     C                   ELSE                                                                 236137
     C                   EVAL      CTCSTS = DDCSTS                                            236137
     C                   ENDIF                                                                236137
     C                   ENDIF                                                                236137
                                                                                              236137
     C                   ENDSR                                                                236137
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *             from each validation module.                      *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *             from each validation module.                      *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             Ix
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             Ix
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C     Ix            SUB       1             Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRCrtp - Validate Certificate Type                            *                       CER048
      *                                                               *                       CER048
      * Called By - Main Processing                                   *                       CER048
      *                                                               *                       CER048
      * Calls - RESETERRS, UPDATERRS                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCrtp        BEGSR                                                                CER048
      *                                                                                       CER048
     C                   EXSR      RESETERRS                                                  CER048
     C                   CALLB     'SDVCRTP01'                                                CER048
     C                   PARM                    RetCodeOut                                   CER048
     C                   PARM                    NwDLScnFmt                                   CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIDXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    OkFlags                                      CER048
     C                   PARM                    NwDlFilFmt                                   CER048
      *                                                                                       CER048
      ** Update Error Info with that returned from Validation Module                          CER048
      *                                                                                       CER048
     C                   EXSR      UPDATERRS                                                  CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRCadt - Validate Certificate Approval Date                   *                       CER048
      *                                                               *                       CER048
      * Called By - Main Processing                                   *                       CER048
      *                                                               *                       CER048
      * Calls - RESETERRS, UPDATERRS                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCadt        BEGSR                                                                CER048
      *                                                                                       CER048
     C                   EXSR      RESETERRS                                                  CER048
     C                   EVAL      PCalledF = 'A'                                             CER048
      *                                                                                       CER048
     C                   CALLB     'SDVSIDT01'                                                CER048
     C                   PARM                    RetCodeOut                                   CER048
     C                   PARM                    NwDLScnFmt                                   CER048
     C                   PARM                    PCalledF                                     CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    BJRDNB                                       CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIDXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    OkFlags                                      CER048
     C                   PARM                    NwDlFilFmt                                   CER048
      *                                                                                       CER048
     C                   EXSR      UPDATERRS                                                  CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      * SRCvdt - Validate Certificate Value Date                      *                       CER048
      *                                                               *                       CER048
      * Called By - Main Processing                                   *                       CER048
      *                                                               *                       CER048
      * Calls - RESETERRS, UPDATERRS                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRCvdt        BEGSR                                                                CER048
      *                                                                                       CER048
     C                   EXSR      RESETERRS                                                  CER048
     C                   EVAL      PCalledF = 'V'                                             CER048
     C                   CALLB     'SDVSIDT01'                                                CER048
     C                   PARM                    RetCodeOut                                   CER048
     C                   PARM                    NwDLScnFmt                                   CER048
     C                   PARM                    PCalledF                                     CER048
     C                   PARM                    BJDFIN                                       CER048
     C                   PARM                    BJRDNB                                       CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIDXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    OkFlags                                      CER048
     C                   PARM                    NwDlFilFmt                                   CER048
      *                                                                                       CER048
     C                   EXSR      UPDATERRS                                                  CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeIn
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PModeOfOp
 
      ** Response mode
     C                   PARM                    PRespMode
 
      ** New Details in Screen Format
     C                   PARM                    NwDLScnFmt
 
      ** Date Format Indicator
     C                   PARM                    BJDFIN
 
      ** Rundate
     C                   PARM                    BJRDNB
 
     C                   PARM                    ValidCusd                                  AR740196
     C                   PARM                    ValidCuad                                  AR740196
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Screen Error Indicator
     C                   PARM                    OkFlags
 
      ** New Details in File Format
     C                   PARM                    NwDlFilFmt
 
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
      *                                                                                       CER048
     C                   IN        LDA                                                        CER048
     C                   EVAL      DBKey = 'CER048'                                           CER048
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER048
     C                   EVAL      DBase = 001                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
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
