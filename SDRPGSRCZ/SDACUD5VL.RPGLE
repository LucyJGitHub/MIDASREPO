     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer ext scr 5 validn')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD5VL - Transactions Details 5 Validation                *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD048703           Date 23Nov17               *
      *  Prev Amend No. CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 MD026629           Date 09May14               *
      *                 MD026540           Date 12May14               *
      *                 CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD048703 - Cannot amend Base II Past Due Customer field      *
      *  CGL157 - CRS Reporting                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD026629 - Unusual behavior of Withholding tax and           *
      *             Additional TIN for Customers                      *
      *  MD026540 - Validate Country of TIN againsts Country of       *
      *             Domicile passed                                   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Hook to enable non-core files to be included
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
 
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
 
     D PTNC            DS                                                                     CGL157
     D  DPTNC1                 1      2                                                       CGL157
     D  DPTNC2                 3      4                                                       CGL157
     D  DPTNC3                 5      6                                                       CGL157
     D  DPTNC4                 7      8                                                       CGL157
     D  DPTNC5                 9     10                                                       CGL157
     D  DPTNC6                11     12                                                       CGL157
     D  DPTNC7                13     14                                                       CGL157
     D  DPTNC8                15     16                                                       CGL157
     D  DPTNC9                17     18                                                       CGL157
     D  DPTNC0                19     20                                                       CGL157
                                                                                              CGL157
     D PFDATE          DS                                                                     CGL157
     D  DPEFF1                 1      6                                                       CGL157
     D  DPEFF2                 7     12                                                       CGL157
     D  DPEFF3                13     18                                                       CGL157
     D  DPEFF4                19     24                                                       CGL157
     D  DPEFF5                25     30                                                       CGL157
     D  DPEFF6                31     36                                                       CGL157
     D  DPEFF7                37     42                                                       CGL157
     D  DPEFF8                43     48                                                       CGL157
     D  DPEFF9                49     54                                                       CGL157
     D  DPEFF0                55     60                                                       CGL157
                                                                                              CGL157
     D PXDATE          DS                                                                     CGL157
     D  DPEXP1                 1      6                                                       CGL157
     D  DPEXP2                 7     12                                                       CGL157
     D  DPEXP3                13     18                                                       CGL157
     D  DPEXP4                19     24                                                       CGL157
     D  DPEXP5                25     30                                                       CGL157
     D  DPEXP6                31     36                                                       CGL157
     D  DPEXP7                37     42                                                       CGL157
     D  DPEXP8                43     48                                                       CGL157
     D  DPEXP9                49     54                                                       CGL157
     D  DPEXP0                55     60                                                       CGL157

      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCUADPD)
     D                                     PREFIX(A)
     D TrnDets5      E DS                  EXTNAME(SDACU5DPD)
      ** Transaction Details in screen format                                                 CGL157
     D WTrnDets      E DS                  EXTNAME(SDCUADPD)                                  CGL157
     D                                     PREFIX(V_)                                         CGL157
     D WTrnDets5     E DS                  EXTNAME(SDACU5DPD)                                 CGL157
     D                                     PREFIX(W_)                                         CGL157
 
     D TranWrk         DS
     D***TranWFill                  1316                                                    MD048703
     D  TranWFill                  1425                                                     MD048703
     D  TranWDets5                         LIKE(TrnDets5)
 
      ** Transaction Details OK indicators
     D OKTrnDets5    E DS                  EXTNAME(SDEACU5PD)
     D                                     PREFIX(DD)
 
      ** Valid Transaction Details layout
     D ValidCust     E DS                  EXTNAME(SDVCUADPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Country Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Midas SD Midas modules Data Structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D ValPair         DS                  QUALIFIED DIM(4)
     D  DDATIN                       25A
     D  DDATNC                        2A
 
     D ArrCnt          S              1  0 INZ(1)
     D ArrCntIn        S              1  0 INZ(1)
     D ArrCntRsq       S              1  0 INZ(1)
     D WTINSetIn       S             27A   DIM(4) INZ(*blanks)
     D WTINSetRsq      S             27A   DIM(4) INZ(*blanks)
     D WTINFld         S             10A   INZ(*blanks)
     D WOKDetArr       S              2A   DIM(4) INZ(*blanks)
     D WDATINOK        S              1A   INZ(*blanks)
     D WDATNCOK        S              1A   INZ(*blanks)
     D WDATIN          S             25A   INZ(*blanks)
     D WDATNC          S              2A   INZ(*blanks)
     D WDupTC          S              1  0 INZ(0)
     D WDCnt           S              1  0 INZ(0)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PEFFDT          S              5P 0 Dim(10)                                            CGL157
     D PEXPDT          S              5P 0 Dim(10)                                            CGL157
     D DDOKCOLC        S              1A                                                      CGL157
     D DDOKTINO        S              1A                                                      CGL157
     D N               S              2S 0                                                    CGL157
                                                                                              CGL157
      ** Parameter for *Entry
     D RespMode        S              1A
 
      ** Customer Numbder
     D DDCUST          S              6A
      ** Country of Domicile (Location) from buffer                                         MD026540
     D DDCOLC          S              2A                                                    MD026540
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D CGL032          S              1A
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D PDate           S              8A
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
     I
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EVAL      OKTrnDets5 = *blanks                                       CGL157
     C                   MOVE      TrnDets       WTrnDets                                     CGL157
     C                   MOVE      TrnDets5      WTrnDets5                                    CGL157
                                                                                              CGL157
      ** Validate TIN                                                                         CGL157
     C                   EXSR      SRVcTin1                                                   CGL157
                                                                                              CGL157
      ** Validate Country of TIN                                                              CGL157
     C                   EXSR      SRRTVCUS                                                   CGL157
     C                   EXSR      SRVcCTIN                                                   CGL157
                                                                                              CGL157
      ** Validate Effective date and Expiry date                                              CGL157
     C                   EXSR      SRVcEfEx                                                   CGL157
                                                                                              CGL157
     C                   MOVE      WTrnDets5     TrnDets5                                     CGL157
     C                   MOVE      WTrnDets      TrnDets                                      CGL157
                                                                                              CGL157
      ** Re-structuring below in order to call validation programs for TIN/Country/Dates      CGL157
                                                                                              CGL157
     C**********         EVAL      TranWrk = TrnDets                                          CGL157
     C**********         EVAL      TrnDets5 = TranWDets5                                      CGL157
 
     C**********         EXSR      SRRTVCUS                                                   CGL157
     C**********         EXSR      SRVMGGAP                                                   CGL157
     C
     C**********         EVAL      OKTrnDets5 = *blanks                                       CGL157
     C**********         EVAL      WOKDetArr = *blanks                                        CGL157
     C**********         EVAL      ValPair = WTINSetRsq                                       CGL157
     C**********         EVAL      ArrCnt = 1                                                 CGL157
 
     C**********         DO        4             ArrCnt                                       CGL157
      ** Setup Work Var for SR                                                                CGL157
     C**********         EVAL      WDATINOK = *Blanks                                         CGL157
     C**********         EVAL      WDATNCOK = *Blanks                                         CGL157
     C**********         EVAL      WDATIN = ValPair(ArrCnt).DDATIN                            CGL157
     C**********         EVAL      WDATNC = ValPair(ArrCnt).DDATNC                            CGL157
      ** Validate Inputs                                                                      CGL157
     C**********         IF        WDATIN <> *blanks OR WDATNC <> *blanks                     CGL157
     C**********         EXSR      SRVCTINO                                                   CGL157
     C**********         EXSR      SRVCATNC                                                   CGL157
     C**********         ENDIF                                                                CGL157
      ** Keep Validation Flags                                                                CGL157
     C**********         EVAL      WOKDetArr(ArrCnt) = WDATINOK + WDATNCOK                    CGL157
 
     C**********         ENDDO                                                                CGL157
 
      ** Move Validation Flags Set for Output                                                 CGL157
     C**********         MOVEA     WOKDetArr     OKTrnDets5                                   CGL157
 
     C**********         EVAL      TranWDets5 = TrnDets5                                      CGL157
     C**********         EVAL      TrnDets = TranWrk                                          CGL157
 
      ** Return to Caller
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL157
      ** SRVcTin1 - Validate TIN                                                              CGL157
      *****************************************************************                       CGL157
     C     SRVcTin1      BEGSR                                                                CGL157
                                                                                              CGL157
      ** Reset variables updated by each module                                               CGL157
                                                                                              CGL157
     C                   EXSR      SRResetErrs                                                CGL157
                                                                                              CGL157
      ** Validate TIN                                                                         CGL157
                                                                                              CGL157
     C                   CALLB     'SDVTIN1'                                                  CGL157
      ** INPUTS                                                                               CGL157
      ** Return Code                                                                          CGL157
     C                   PARM                    RetCodeOut                                   CGL157
      ** TIN                                                                                  CGL157
     C                   PARM                    ADDTINO                                      CGL157
      ** TIN2                                                                                 CGL157
     C                   PARM      ADDTIN2       DDTIN2                                       CGL157
      ** TIN3                                                                                 CGL157
     C                   PARM      ADDTIN3       DDTIN3                                       CGL157
      ** TIN4                                                                                 CGL157
     C                   PARM      ADDTIN4       DDTIN4                                       CGL157
      ** TIN5                                                                                 CGL157
     C                   PARM      ADDTIN5       DDTIN5                                       CGL157
      ** TIN6                                                                                 CGL157
     C                   PARM      ADDTIN6       DDTIN6                                       CGL157
      ** TIN7                                                                                 CGL157
     C                   PARM      ADDTIN7       DDTIN7                                       CGL157
      ** TIN8                                                                                 CGL157
     C                   PARM      ADDTIN8       DDTIN8                                       CGL157
      ** TIN9                                                                                 CGL157
     C                   PARM      ADDTIN9       DDTIN9                                       CGL157
      ** TIN10                                                                                CGL157
     C                   PARM      ADDTIN0       DDTIN0                                       CGL157
      ** Country of TIN 2                                                                     CGL157
     C                   PARM      ADDTNC2       DDTNC2                                       CGL157
      ** Country of TIN 3                                                                     CGL157
     C                   PARM      ADDTNC3       DDTNC3                                       CGL157
      ** Country of TIN 4                                                                     CGL157
     C                   PARM      ADDTNC4       DDTNC4                                       CGL157
      ** Country of TIN 5                                                                     CGL157
     C                   PARM      ADDTNC5       DDTNC5                                       CGL157
      ** Country of TIN 6                                                                     CGL157
     C                   PARM      ADDTNC6       DDTNC6                                       CGL157
      ** Country of TIN 7                                                                     CGL157
     C                   PARM      ADDTNC7       DDTNC7                                       CGL157
      ** Country of TIN 8                                                                     CGL157
     C                   PARM      ADDTNC8       DDTNC8                                       CGL157
      ** Country of TIN 9                                                                     CGL157
     C                   PARM      ADDTNC9       DDTNC9                                       CGL157
      ** Country of TIN 10                                                                    CGL157
     C                   PARM      ADDTNC0       DDTNC0                                       CGL157
      ** OUTPUTS                                                                              CGL157
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL157
     C                   PARM                    FldNamXAr                                    CGL157
     C                   PARM                    MsgIDXAr                                     CGL157
     C                   PARM                    MsgDtaXAr                                    CGL157
      ** TIN - OK                                                                             CGL157
     C                   PARM                    DDOKTINO                                     CGL157
      ** TIN 2 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN2                                     CGL157
      ** TIN 3 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN3                                     CGL157
      ** TIN 4 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN4                                     CGL157
      ** TIN 5 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN5                                     CGL157
      ** TIN 6 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN6                                     CGL157
      ** TIN 7 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN7                                     CGL157
      ** TIN 8 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN8                                     CGL157
      ** TIN 9 - OK                                                                           CGL157
     C                   PARM                    DDOKTIN9                                     CGL157
      ** TIN 10 - OK                                                                          CGL157
     C                   PARM                    DDOKTIN0                                     CGL157
                                                                                              CGL157
     C                   EVAL      N = 1                                                      CGL157
     C                   DOW       FldNamXAr(N) <> *Blanks                                    CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN2'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN2'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN3'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN3'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN4'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN4'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN5'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN5'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN6'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN6'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN7'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN7'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN8'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN8'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN9'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN9'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDTIN0'                                    CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNN0'                                    CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      N = N + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
                                                                                              CGL157
      ** Update error info with that returned from the validation module                      CGL157
                                                                                              CGL157
     C                   EXSR      SRUpdatErrs                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      ** SRVcCTIN - Validate Country of TIN                                                   CGL157
      *****************************************************************                       CGL157
     C     SRVcCTIN      BEGSR                                                                CGL157
                                                                                              CGL157
      ** Reset variables updated by each module                                               CGL157
                                                                                              CGL157
     C                   EXSR      SRResetErrs                                                CGL157
                                                                                              CGL157
      ** Validate Country of TIN                                                              CGL157
                                                                                              CGL157
     C                   CALLB     'SDVCTIN'                                                  CGL157
      ** INPUTS                                                                               CGL157
      ** Return Code                                                                          CGL157
     C                   PARM                    RetCodeOut                                   CGL157
      ** TIN2                                                                                 CGL157
     C                   PARM      ADDTIN2       DDTIN2                                       CGL157
      ** TIN3                                                                                 CGL157
     C                   PARM      ADDTIN3       DDTIN3                                       CGL157
      ** TIN4                                                                                 CGL157
     C                   PARM      ADDTIN4       DDTIN4                                       CGL157
      ** TIN5                                                                                 CGL157
     C                   PARM      ADDTIN5       DDTIN5                                       CGL157
      ** TIN6                                                                                 CGL157
     C                   PARM      ADDTIN6       DDTIN6                                       CGL157
      ** TIN7                                                                                 CGL157
     C                   PARM      ADDTIN7       DDTIN7                                       CGL157
      ** TIN8                                                                                 CGL157
     C                   PARM      ADDTIN8       DDTIN8                                       CGL157
      ** TIN9                                                                                 CGL157
     C                   PARM      ADDTIN9       DDTIN9                                       CGL157
      ** TIN0                                                                                 CGL157
     C                   PARM      ADDTIN0       DDTIN0                                       CGL157
      ** Country of Domicile                                                                  CGL157
     C                   PARM                    BBCOLC                                       CGL157
      ** Country of TIN 2                                                                     CGL157
     C                   PARM      ADDTNC2       DDTNC2                                       CGL157
      ** Country of TIN 3                                                                     CGL157
     C                   PARM      ADDTNC3       DDTNC3                                       CGL157
      ** Country of TIN 4                                                                     CGL157
     C                   PARM      ADDTNC4       DDTNC4                                       CGL157
      ** Country of TIN 5                                                                     CGL157
     C                   PARM      ADDTNC5       DDTNC5                                       CGL157
      ** Country of TIN 6                                                                     CGL157
     C                   PARM      ADDTNC6       DDTNC6                                       CGL157
      ** Country of TIN 7                                                                     CGL157
     C                   PARM      ADDTNC7       DDTNC7                                       CGL157
      ** Country of TIN 8                                                                     CGL157
     C                   PARM      ADDTNC8       DDTNC8                                       CGL157
      ** Country of TIN 9                                                                     CGL157
     C                   PARM      ADDTNC9       DDTNC9                                       CGL157
      ** Country of TIN 10                                                                    CGL157
     C                   PARM      ADDTNC0       DDTNC0                                       CGL157
                                                                                              CGL157
      ** OUTPUTS                                                                              CGL157
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL157
     C                   PARM                    FldNamXAr                                    CGL157
     C                   PARM                    MsgIDXAr                                     CGL157
     C                   PARM                    MsgDtaXAr                                    CGL157
      ** Country of Domicile - OK                                                             CGL157
     C                   PARM                    DDOKCOLC                                     CGL157
      ** Country of TIN 2 - OK                                                                CGL157
     C                   PARM                    DDOKTNC2                                     CGL157
      ** Country of TIN 3 - OK                                                                CGL157
     C                   PARM                    DDOKTNC3                                     CGL157
      ** Country of TIN 4 - OK                                                                CGL157
     C                   PARM                    DDOKTNC4                                     CGL157
      ** Country of TIN 5 - OK                                                                CGL157
     C                   PARM                    DDOKTNC5                                     CGL157
      ** Country of TIN 6 - OK                                                                CGL157
     C                   PARM                    DDOKTNC6                                     CGL157
      ** Country of TIN 7 - OK                                                                CGL157
     C                   PARM                    DDOKTNC7                                     CGL157
      ** Country of TIN 8 - OK                                                                CGL157
     C                   PARM                    DDOKTNC8                                     CGL157
      ** Country of TIN 9 - OK                                                                CGL157
     C                   PARM                    DDOKTNC9                                     CGL157
      ** Country of TIN 10 - OK                                                               CGL157
     C                   PARM                    DDOKTNC0                                     CGL157
                                                                                              CGL157
     C                   EVAL      N = 1                                                      CGL157
     C                   DOW       FldNamXAr(N) <> *Blanks                                    CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN2'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC2 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN3'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC3 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN4'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC4 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN5'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC5 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN6'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC6 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN7'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC7 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN8'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC8 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN9'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC9 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   IF        FldNamXAr(N) = 'DDCTIN0'                                   CGL157
     C                   EVAL      FldNamXAr(N) = 'DDTNC0 '                                   CGL157
     C                   ENDIF                                                                CGL157
                                                                                              CGL157
     C                   EVAL      N = N + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
                                                                                              CGL157
      ** Update error info with that returned from the validation module                      CGL157
                                                                                              CGL157
     C                   EXSR      SRUpdatErrs                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
                                                                                              CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      ** SRVcEfex - Validate Effective and Expiry Date                                        CGL157
      *****************************************************************                       CGL157
     C     SRVcEfex      BEGSR                                                                CGL157
                                                                                              CGL157
      ** Reset variables updated by each module                                               CGL157
                                                                                              CGL157
     C                   EXSR      SRResetErrs                                                CGL157
                                                                                              CGL157
     C                   EVAL      DPTNC1 = ADDISCT                                           CGL157
     C                   EVAL      DPTNC2 = ADDTNC2                                           CGL157
     C                   EVAL      DPTNC3 = ADDTNC3                                           CGL157
     C                   EVAL      DPTNC4 = ADDTNC4                                           CGL157
     C                   EVAL      DPTNC5 = ADDTNC5                                           CGL157
     C                   EVAL      DPTNC6 = ADDTNC6                                           CGL157
     C                   EVAL      DPTNC7 = ADDTNC7                                           CGL157
     C                   EVAL      DPTNC8 = ADDTNC8                                           CGL157
     C                   EVAL      DPTNC9 = ADDTNC9                                           CGL157
     C                   EVAL      DPTNC0 = ADDTNC0                                           CGL157
     C                   EVAL      DPEFF1 = ADDEFF1                                           CGL157
     C                   EVAL      DPEFF2 = ADDEFF2                                           CGL157
     C                   EVAL      DPEFF3 = ADDEFF3                                           CGL157
     C                   EVAL      DPEFF4 = ADDEFF4                                           CGL157
     C                   EVAL      DPEFF5 = ADDEFF5                                           CGL157
     C                   EVAL      DPEFF6 = ADDEFF6                                           CGL157
     C                   EVAL      DPEFF7 = ADDEFF7                                           CGL157
     C                   EVAL      DPEFF8 = ADDEFF8                                           CGL157
     C                   EVAL      DPEFF9 = ADDEFF9                                           CGL157
     C                   EVAL      DPEFF0 = ADDEFF0                                           CGL157
     C                   EVAL      DPEXP1 = ADDEXP1                                           CGL157
     C                   EVAL      DPEXP2 = ADDEXP2                                           CGL157
     C                   EVAL      DPEXP3 = ADDEXP3                                           CGL157
     C                   EVAL      DPEXP4 = ADDEXP4                                           CGL157
     C                   EVAL      DPEXP5 = ADDEXP5                                           CGL157
     C                   EVAL      DPEXP6 = ADDEXP6                                           CGL157
     C                   EVAL      DPEXP7 = ADDEXP7                                           CGL157
     C                   EVAL      DPEXP8 = ADDEXP8                                           CGL157
     C                   EVAL      DPEXP9 = ADDEXP9                                           CGL157
     C                   EVAL      DPEXP0 = ADDEXP0                                           CGL157
                                                                                              CGL157
      ** Validate Effective and Expiry Date                                                   CGL157
                                                                                              CGL157
     C                   CALLB     'SDVEFEX'                                                  CGL157
      ** INPUTS                                                                               CGL157
      ** Return Code                                                                          CGL157
     C                   PARM                    RetCodeOut                                   CGL157
      ** Country of TIN                                                                       CGL157
     C                   PARM                    PTNC                                         CGL157
      ** Effective Date                                                                       CGL157
     C                   PARM                    PFDATE                                       CGL157
      ** Expiry Date                                                                          CGL157
     C                   PARM                    PXDATE                                       CGL157
                                                                                              CGL157
      ** OUTPUTS                                                                              CGL157
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL157
     C                   PARM                    FldNamXAr                                    CGL157
     C                   PARM                    MsgIDXAr                                     CGL157
     C                   PARM                    MsgDtaXAr                                    CGL157
      ** Effective Date 1 - OK                                                                CGL157
     C                   PARM                    DDOKEFF1                                     CGL157
      ** Effective Date 2 - OK                                                                CGL157
     C                   PARM                    DDOKEFF2                                     CGL157
      ** Effective Date 3 - OK                                                                CGL157
     C                   PARM                    DDOKEFF3                                     CGL157
      ** Effective Date 4 - OK                                                                CGL157
     C                   PARM                    DDOKEFF4                                     CGL157
      ** Effective Date 5 - OK                                                                CGL157
     C                   PARM                    DDOKEFF5                                     CGL157
      ** Effective Date 6 - OK                                                                CGL157
     C                   PARM                    DDOKEFF6                                     CGL157
      ** Effective Date 7 - OK                                                                CGL157
     C                   PARM                    DDOKEFF7                                     CGL157
      ** Effective Date 8 - OK                                                                CGL157
     C                   PARM                    DDOKEFF8                                     CGL157
      ** Effective Date 9 - OK                                                                CGL157
     C                   PARM                    DDOKEFF9                                     CGL157
      ** Effective Date 10 - OK                                                               CGL157
     C                   PARM                    DDOKEFF0                                     CGL157
      ** Expiry Date 1 - OK                                                                   CGL157
      ** Expiry Date 1 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP1                                     CGL157
      ** Expiry Date 2 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP2                                     CGL157
      ** Expiry Date 3 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP3                                     CGL157
      ** Expiry Date 4 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP4                                     CGL157
      ** Expiry Date 5 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP5                                     CGL157
      ** Expiry Date 6 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP6                                     CGL157
      ** Expiry Date 7 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP7                                     CGL157
      ** Expiry Date 8 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP8                                     CGL157
      ** Expiry Date 9 - OK                                                                   CGL157
     C                   PARM                    DDOKEXP9                                     CGL157
      ** Expiry Date 10 - OK                                                                  CGL157
     C                   PARM                    DDOKEXP0                                     CGL157
      ** Effective date 1-5                                                                   CGL157
     C                   PARM                    PEFFDT                                       CGL157
      ** Expiry date 1-5                                                                      CGL157
     C                   PARM                    PEXPDT                                       CGL157
                                                                                              CGL157
     C                   EVAL      ADEFF1 = PEFFDT(1)                                         CGL157
     C                   EVAL      ADEFF2 = PEFFDT(2)                                         CGL157
     C                   EVAL      ADEFF3 = PEFFDT(3)                                         CGL157
     C                   EVAL      ADEFF4 = PEFFDT(4)                                         CGL157
     C                   EVAL      ADEFF5 = PEFFDT(5)                                         CGL157
     C                   EVAL      ADEFF6 = PEFFDT(6)                                         CGL157
     C                   EVAL      ADEFF7 = PEFFDT(7)                                         CGL157
     C                   EVAL      ADEFF8 = PEFFDT(8)                                         CGL157
     C                   EVAL      ADEFF9 = PEFFDT(9)                                         CGL157
     C                   EVAL      ADEFF0 = PEFFDT(10)                                        CGL157
     C                   EVAL      ADEXP1 = PEXPDT(1)                                         CGL157
     C                   EVAL      ADEXP2 = PEXPDT(2)                                         CGL157
     C                   EVAL      ADEXP3 = PEXPDT(3)                                         CGL157
     C                   EVAL      ADEXP4 = PEXPDT(4)                                         CGL157
     C                   EVAL      ADEXP5 = PEXPDT(5)                                         CGL157
     C                   EVAL      ADEXP6 = PEXPDT(6)                                         CGL157
     C                   EVAL      ADEXP7 = PEXPDT(7)                                         CGL157
     C                   EVAL      ADEXP8 = PEXPDT(8)                                         CGL157
     C                   EVAL      ADEXP9 = PEXPDT(9)                                         CGL157
     C                   EVAL      ADEXP0 = PEXPDT(10)                                        CGL157
                                                                                              CGL157
      ** Update error info with that returned from the validation module                      CGL157
                                                                                              CGL157
     C                   EXSR      SRUpdatErrs                                                CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
      /EJECT                                                                                  CGL157

      *****************************************************************
      * SRMngGap - Manage Gaps in Fields                              *
      *****************************************************************
     C     SRVMGGAP      BEGSR
     C
     C                   MOVEA     TrnDets5      WTINSetIn
     C                   EVAL      ArrCntIn = 1
     C                   EVAL      ArrCntRsq = 1
     C                   EVAL      WTINSetRsq = *blanks
 
      ** Resequence items to prevent gaps
     C                   DO        4             ArrCntIn
     C                   IF        WTINSetIn(ArrCntIn) <> *blanks
     C                   EVAL      WTINSetRsq(ArrCntRsq) = WTINSetIn(ArrCntIn)
     C                   EVAL      ArrCntRsq += 1
     C                   ENDIF
     C                   ENDDO
 
      ** Move the gapless set back to the display format
     C                   MOVEA     WTINSetRsq    TrnDets5
 
      ** Move the details to file format
     C                   EVAL      ADTIN2 = DDTIN2
     C                   EVAL      ADTNC2 = DDTNC2
     C                   EVAL      ADTIN3 = DDTIN3
     C                   EVAL      ADTNC3 = DDTNC3
     C                   EVAL      ADTIN4 = DDTIN4
     C                   EVAL      ADTNC4 = DDTNC4
     C                   EVAL      ADTIN5 = DDTIN5
     C                   EVAL      ADTNC5 = DDTNC5
     C                   EVAL      ADTIN6 = DDTIN6                                            CGL157
     C                   EVAL      ADTNC6 = DDTNC6                                            CGL157
     C                   EVAL      ADTIN7 = DDTIN7                                            CGL157
     C                   EVAL      ADTNC7 = DDTNC7                                            CGL157
     C                   EVAL      ADTIN8 = DDTIN8                                            CGL157
     C                   EVAL      ADTNC8 = DDTNC8                                            CGL157
     C                   EVAL      ADTIN9 = DDTIN9                                            CGL157
     C                   EVAL      ADTNC9 = DDTNC9                                            CGL157
     C                   EVAL      ADTIN0 = DDTIN0                                            CGL157
     C                   EVAL      ADTNC0 = DDTNC0                                            CGL157
     C
     C     SRVMGGAPE     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCTINO - Validate Tax Identification Number                 *
      *****************************************************************
     C     SRVCTINO      BEGSR
 
      ** Reset variables updated by each module
     C                   EXSR      SRRESETERRS
     C**********         EVAL      WTINFld = 'DDTIN' + %char(ArrCnt+1)                      MD026629
     C                   EVAL      WTINFld = 'DDTNN' + %char(ArrCnt+1)                      MD026629
 
      ** Tax Identification Number cannot be blank when country is specified
     C                   IF        WDATIN = *blanks and WDATNC <> *blanks
     C                   MOVE      'N'           WDATINOK
     C                   ADD       1             Idx
     C                   MOVEL     WTINFld       FldNamXAr(Idx)
     C                   MOVEL     'USS0453'     MsgIdXAr(Idx)
     C                   ENDIF
     C                   EVAL      WTINFld = ''
 
      ** No further validation needed as the field is free format
 
      ** Update error info with that returned from the validation module
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCATNC - Validate Tax Country                               *
      *****************************************************************
     C     SRVCATNC      BEGSR
 
 
      ** Reset variables updated by each module
     C                   EXSR      SRRESETERRS
     C                   EVAL      WDupTC = 0
     C                   EVAL      WDCnt = 1
     C                   EVAL      WTINFld = 'DDTNC' + %char(ArrCnt+1)
      ** Country of TIN must be a valid Midas Country
     C                   EXSR      SRVCHKTC
 
      ** Country of Tax required to pair with TIN input
     C                   IF        WDATNC = *blanks and WDATIN <> *blanks
     C                   MOVE      'N'           WDATNCOK
     C                   ADD       1             Idx
     C                   MOVEL     WTINFld       FldNamXAr(Idx)
     C                   MOVEL     'USS0451'     MsgIdXAr(Idx)
     C                   ENDIF
 
      ** Check if TIN for this country is already specified for the customer
     C                   DOW       ArrCnt > 1 and WDCnt < ArrCnt
     C                   IF        ValPair(WDCnt).DDATNC = WDATNC
     C                   EVAL      WDupTC += 1
     C                   ENDIF
     C                   EVAL      WDCnt += 1
     C                   ENDDO
 
      ** Check if TIN Country is already the Main TIN's Country
      **   using Country of Domicile instead of Issuing Country
     C**********         IF        WDATNC = BBCOLC                                          MD026540
     C                   IF        WDATNC = DDCOLC                                          MD026540
     C                             OR WDupTC <> 0
     C                   MOVE      'N'           WDATNCOK
     C                   ADD       1             Idx
     C                   MOVEL     WTINFld       FldNamXAr(Idx)
     C                   MOVEL     'USS0452'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   EXSR      SRUPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVCHKTC - Valid If Country Is A Valid Midas Country          *
      *****************************************************************
     C     SRVCHKTC      BEGSR
 
      ** Reset variables updated by each module
     C                   EXSR      SRRESETERRS
      ** Validate TIN Country
     C                   CALLB     'SDVATNC'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** TIN Country to Validate (2A)
     C                   PARM                    WDATNC
      ** TIN Country Field Name (10A)
     C                   PARM                    WTINFld
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** TIN Country - OK
     C                   PARM                    WDATNCOK
 
     C
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRESETERRS - Reset error information that is received back   *
      *    from each validation module.                               *
      *****************************************************************
     C     SRRESETERRS   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      WFldNmXAr = *Blanks
     C                   EVAL      WMsgIDXAr = *Blanks
     C                   EVAL      WMsgDtXAr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDATERRS - Update error information with that received back*
      *    from each validation module.                               *
      *****************************************************************
     C     SRUPDATERRS   BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I                 3 0
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *Blanks       LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRTVCUS - Retrieve Main Customer Details for the Country of  *
      *                        Domicile                               *
      *                                                               *
      *****************************************************************
     C     SRRTVCUS      BEGSR
 
     C*****DDCUST        CHAIN     @BBREBG                                                    CGL157
     C     DDCUST        CHAIN     @BBREBG                                                    CGL157
     C     SRRTVCUSE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
     C                   PARM                    RespMode
 
      ** Transaction Details
     C                   PARM                    TrnDets
 
      ** Customer Number
     C                   PARM                    DDCUST
     C                   PARM                    DDCOLC                                     MD026540
 
      ** Outputs
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets5
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidCust
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = POptn
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      DBPGM = 'SDACUD5VL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      **  Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2013
