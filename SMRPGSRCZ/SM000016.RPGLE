     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Change Funds Transfer address fields')        *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000016 - Midas SM Change Funds Transfer address fields     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CFT120             Date 28Sep12               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      *                 BUG27975           Date 04Aug10               *
      *                 BUG27884           Date 08Jul10               *
      *                 CUP038             Date 29Nov07               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15105C          Date 06Nov07               *
      *                 BUG15105A          Date 25Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CPK023             Date 22Dec05               *
      *                 CGL034             Date 13Sep04               *
      *                 CGL029  *CREATE    Date 01Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  BUG27975 - Some fields are already handled by normal account *
      *             code conversion.                                  *
      *  BUG27884 - Applied CUP038                                    *
      *  CUP038 - Additional files and fields need exception          *
      *           handling.                                           *
      *  BUG15105C - Missing Process for SWIFT 2007 (Reopen)          *
      *  BUG15105A - Missing Process for SWIFT 2007 (Reopen)          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK023 - Still leaves padding in for some fields.            *
      *  CGL034 - Perform conversion from external table.             *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FINPAY     UF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Incoming Payments Details
      *
     FOTPAY     UF   E           K DISK    INFSR(*PSSR)
      ** Midas FT Outgoing Payments Details
      *
     FCQCOD     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CQCOCDDF)
      ** Midas FT Cheques for Collection Debit Details
      *
     FCQPAC     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CQPADDDF)
      ** Midas FT Cheques to be Paid Credit Details
      *
     F*CQCOCDL1*UF   E           K DISK    INFSR(*PSSR)                              CUP038 BUG27975
      ***Midas*FT*Cheques*for*Collection*credits*                                    CUP038 BUG27975
      *
     F*CQPADDL1*UF   E           K DISK    INFSR(*PSSR)                              CUP038 BUG27975
      ***Midas*FT*Cheques*to*be*Paid*Debit*Details*                                  CUP038 BUG27975
      *
     FFTVIPAYL0 UF   E           K DISK    INFSR(*PSSR)                                       CUP038
      *  Midas FT Valid incoming payments                                                     CUP038
      *
     FFTVOPAYL0 UF   E           K DISK    INFSR(*PSSR)                                       CUP038
      *  Midas FT Valid outgoing payments details                                             CUP038
      *
     FSMCNLGPD  O    E             DISK    INFSR(*PSSR)
      ** Midas SM Change Narrative Log
      *
      ** Local Data Area for Database Error Details
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      *
      **  Data structure for Account Details.                                              BUG15105A
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                BUG15105A
      **  First DS for access programs, long data structure.                               BUG15105A
     D DSSDY         E DS                  EXTNAME(DSSDY)                                  BUG15105A
      ** Program Status Data Structure
     D*/COPY ZACPYSRC,PSDS
      *
      ** Full Account Data Structure
     D                 DS
     D WFulAcc                 1     18
     D  WFuCu                  1      6
     D  WFuCc                  7      9
     D  WFuAc                 10     13
     D  WFuAs                 14     15
     D  WFuBr                 16     18
      *
      ** Partial Account Data Structure
     D                 DS
     D WParAcc                 1     15
     D  WPaCu                  1      6
     D  WPaAc                  7     10
     D  WPaAs                 11     12
     D  WPaBr                 13     15
      *
      **Data*Structure*for*12*long*field*                                            CUP038 BUG27975
     D**********       DS                                                            CUP038 BUG27975
     D*W12******               1     12                                              CUP038 BUG27975
     D**WNost12*               1      2                                              CUP038 BUG27975
     D**WPaCu12*               1      6                                              CUP038 BUG27975
     D**WRetl12*               1     10                                              CUP038 BUG27975
     D**WPaAc12*               7     10                                              CUP038 BUG27975
     D**WPaAs12*              11     12                                              CUP038 BUG27975
      *
      **Data*Structure*for*18*long*field*                                            CUP038 BUG27975
     D**********       DS                                                            CUP038 BUG27975
     D*W18******               1     18                                              CUP038 BUG27975
     D**WNost18*               1      2                                              CUP038 BUG27975
     D**WPaCu18*               1      6                                              CUP038 BUG27975
     D**WRetl18*               1     10                                              CUP038 BUG27975
     D**WNblk18*               3     18                                              CUP038 BUG27975
     D**WPaAc18*               7     16                                              CUP038 BUG27975
     D**WRblk18*              11     18                                              CUP038 BUG27975
     D**WPaAs18*              17     18                                              CUP038 BUG27975
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
     D PRtCd           S              7A
      *
      ** Working Variables
     D WType           S              1A
     D WNarr           S             35A
     D*WPad*****       S              6A                                                      CPK023
     D WChg            S              1A
     D WUpd            S              1A
     D WDBNm           S             10A
     D WTRef           S             30A
     D WFld            S             10A
     D WFrNar          S             35A
     D WToNar          S             35A
     D TmpWNarr        S             35A                                                   BUG15105A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Incoming Payments
     C                   EXSR      SRInPay
      *
      ** Outgoing Payments
     C                   EXSR      SROtPay
      *
      ** Cheques for Collection
     C                   EXSR      SRCqCoD
      *
      ** Cheques to be Paid
     C                   EXSR      SRCqPaC
      *
      **Cheques*for*Collection*credits*                                              CUP038 BUG27975
     C**********         EXSR      SRCqCoC                                           CUP038 BUG27975
      *
      **Cheques*to*be*Paid*debit*                                                    CUP038 BUG27975
     C**********         EXSR      SRCqPaD                                           CUP038 BUG27975
      *
      * Valid incoming payments                                                               CUP038
     C                   EXSR      SRFTVIPAY                                                  CUP038
      *
      * Valid outgoing payments                                                               CUP038
     C                   EXSR      SRFTVOPAY                                                  CUP038
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInPay - Handles Incoming Payments.                         *
      *                                                               *
      *****************************************************************
     C     SRInPay       BEGSR
      *
     C                   EVAL      WDBNm = 'INPAYDD'
      *
     C     *LOVAL        SETLL     INPAY
     C                   READ      INPAY
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WUpd = 'N'
     C                   EVAL      WTRef = PREF
      *
      ** Sender
     C                   EVAL      WType = SNTP
     C                   EVAL      WNarr = SND1
     C                   EVAL      WFld = 'SND1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = SND1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      SND1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
      ** Beneficiary Customer
     C                   EVAL      WType = BNCT
     C                   EVAL      WNarr = BNC1
     C                   EVAL      WFld = 'BNC1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = BNC1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      BNC1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
      ** Ordering Bank                                                                      BUG27975
     C                   EVAL      WType = ORBT                                             BUG27975
     C                   EVAL      WNarr = ORB1                                             BUG27975
     C                   EVAL      WFld = 'ORB1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = ORB1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      ORB1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Sender's Correspondent                                                             BUG27975
     C                   EVAL      WType = SNCT                                             BUG27975
     C                   EVAL      WNarr = SNC1                                             BUG27975
     C                   EVAL      WFld = 'SNC1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = SNC1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      SNC1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Ordering Customer                                                                  BUG27975
     C                   EVAL      WType = ORCT                                             BUG27975
     C                   EVAL      WNarr = ORC1                                             BUG27975
     C                   EVAL      WFld = 'ORC1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = ORC1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      ORC1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Intermediary Bank                                                                  BUG27975
     C                   EVAL      WType = INBT                                             BUG27975
     C                   EVAL      WNarr = INB1                                             BUG27975
     C                   EVAL      WFld = 'INB1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = INB1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      INB1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Receiver's Correspondent                                                           BUG27975
     C                   EVAL      WType = INRCRT                                           BUG27975
     C                   EVAL      WNarr = INRCO1                                           BUG27975
     C                   EVAL      WFld = 'INRCO1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = INRCO1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      INRCO1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Account With Bank                                                                  BUG27975
     C                   EVAL      WType = INACBT                                           BUG27975
     C                   EVAL      WNarr = INACB1                                           BUG27975
     C                   EVAL      WFld = 'INACB1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = INACB1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      INACB1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      **Charges*to*DR*Of*                                                            CUP038 BUG27975
     C**********         EVAL      WType = CDRT                                      CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(CDRO:1:12)                           CUP038 BUG27975
     C**********         EVAL      WFld = 'CDRO'                                     CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      CDRO = W18                                        CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C                   IF        WUpd = 'Y'
     C                   UPDATE    INPAYDDF
     C                   ENDIF
      *
     C                   READ      INPAY
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROtPay - Handles Outgoing Payments.                         *
      *                                                               *
      *****************************************************************
     C     SROtPay       BEGSR
      *
     C                   EVAL      WDBNm = 'OTPAYDD'
      *
     C     *LOVAL        SETLL     OTPAY
     C                   READ      OTPAY
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WUpd = 'N'
     C                   EVAL      WTRef = PREF
      *
      ** Destination
     C                   EVAL      WType = DSTT
     C                   EVAL      WNarr = DST1
     C                   EVAL      WFld = 'DST1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = DST1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      DST1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
      ** Ordering Customer
     C                   EVAL      WType = ORCT
     C                   EVAL      WNarr = ORC1
     C                   EVAL      WFld = 'ORC1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = ORC1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      ORC1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
      ** Receiver's Correspondent                                                           BUG27975
     C                   EVAL      WType = RCRT                                             BUG27975
     C                   EVAL      WNarr = RCO1                                             BUG27975
     C                   EVAL      WFld = 'RCO1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = RCO1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      RCO1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Account With Bank                                                                  BUG27975
     C                   EVAL      WType = ACBT                                             BUG27975
     C                   EVAL      WNarr = ACB1                                             BUG27975
     C                   EVAL      WFld = 'ACB1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = ACB1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      ACB1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Beneficiary                                                                        BUG27975
     C                   EVAL      WType = BNCT                                             BUG27975
     C                   EVAL      WNarr = BNC1                                             BUG27975
     C                   EVAL      WFld = 'BNC1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = BNC1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      BNC1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Intermediary Bank                                                                  BUG27975
     C                   EVAL      WType = INBT                                             BUG27975
     C                   EVAL      WNarr = INB1                                             BUG27975
     C                   EVAL      WFld = 'INB1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = INB1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      INB1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Ordering Bank                                                                      BUG27975
     C                   EVAL      WType = OPORBT                                           BUG27975
     C                   EVAL      WNarr = OPORB1                                           BUG27975
     C                   EVAL      WFld = 'OPORB1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OPORB1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OPORB1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      **Charges*to*DR*Of*                                                            CUP038 BUG27975
     C**********         EVAL      WType = CDRT                                      CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(CDRO:1:12)                           CUP038 BUG27975
     C**********         EVAL      WFld = 'CDRO'                                     CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      CDRO = W18                                        CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
      **Ordering*Bank*                                                               CUP038 BUG27975
     C**********         EVAL      WType = ORBT                                      CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(ORBK:1:12)                           CUP038 BUG27975
     C**********         EVAL      WFld = 'ORBK'                                     CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      ORBK = W18                                        CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C                   IF        WUpd = 'Y'
     C                   UPDATE    OTPAYDDF
     C                   ENDIF
      *
     C                   READ      OTPAY
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCqCoD - Handles Cheques for Collection.                    *
      *                                                               *
      *****************************************************************
     C     SRCqCoD       BEGSR
      *
     C                   EVAL      WDBNm = 'CQCODDD'
      *
     C     *LOVAL        SETLL     CQCOD
     C                   READ      CQCOD
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WUpd = 'N'
     C                   EVAL      WTRef = PREF
      *
      ** Collect Bank
      *
     C                   EVAL      WType = COBT
     C                   EVAL      WNarr = COB1
     C                   EVAL      WFld = 'COB1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = COB1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      COB1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
     C                   IF        WUpd = 'Y'
     C                   UPDATE    CQCODDDF
     C                   ENDIF
      *
     C                   READ      CQCOD
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCqPaC - Handles Cheques to be Paid.                        *
      *                                                               *
      *****************************************************************
     C     SRCqPaC       BEGSR
      *
     C                   EVAL      WDBNm = 'CQPACDD'
      *
     C     *LOVAL        SETLL     CQPAC
     C                   READ      CQPAC
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WUpd = 'N'
     C                   EVAL      WTRef = PREF
      *
      ** Remitting Bank
     C                   EVAL      WType = RBKT
     C                   EVAL      WNarr = RBK1
     C                   EVAL      WFld = 'RBK1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = RBK1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      RBK1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
      ** Drawer Address
     C                   EVAL      WType = DRWT
     C                   EVAL      WNarr = DRW1
     C                   EVAL      WFld = 'DRW1'
      *
     C                   EXSR      SRChgNar
      *
     C                   IF        WChg = 'Y'
     C                   EVAL      WFrNar = DRW1
     C                   EVAL      WToNar = WNarr
     C                   EXSR      SRChgLog
      *
     C                   EVAL      DRW1 = WNarr
     C                   EVAL      WUpd = 'Y'
     C                   ENDIF
      *
      ** Receiver's Correspondent                                                           BUG27975
     C                   EVAL      WType = RCRT                                             BUG27975
     C                   EVAL      WNarr = RCO1                                             BUG27975
     C                   EVAL      WFld = 'RCO1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = RCO1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      RCO1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      ** Account With Bank                                                                  BUG27975
     C                   EVAL      WType = ACBT                                             BUG27975
     C                   EVAL      WNarr = ACB1                                             BUG27975
     C                   EVAL      WFld = 'ACB1'                                            BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = ACB1                                            BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      ACB1 = WNarr                                             BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
     C                   IF        WUpd = 'Y'
     C                   UPDATE    CQPACDDF
     C                   ENDIF
      *
     C                   READ      CQPAC
     C                   ENDDO
      *
     C                   ENDSR
      *EJECT****                                                                     CUP038 BUG27975
      *****************************************************************              CUP038 BUG27975
      **********                                                      *              CUP038 BUG27975
      ***SRCqCoC*-*Handles*Cheques*for*Collection*credits*            *              CUP038 BUG27975
      **********                                                      *              CUP038 BUG27975
      *****************************************************************              CUP038 BUG27975
     C*****SRCqCoC       BEGSR                                                       CUP038 BUG27975
      *
     C**********         EVAL      WDBNm = 'CQCOCDD'                                 CUP038 BUG27975
      *
     C******LOVAL        SETLL     CQCOCDL1                                          CUP038 BUG27975
     C**********         READ      CQCOCDL1                                          CUP038 BUG27975
      *
     C**********         DOW       NOT %EOF                                          CUP038 BUG27975
      *
     C**********         EVAL      WUpd = 'N'                                        CUP038 BUG27975
     C**********         EVAL      WTRef = PREF                                      CUP038 BUG27975
      *
      **Charges*to*DR*Of*                                                            CUP038 BUG27975
     C**********         EVAL      WType = CDRT                                      CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(CDRO:1:12)                           CUP038 BUG27975
     C**********         EVAL      WFld = 'CDRO'                                     CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      CDRO = W18                                        CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C**********         IF        WUpd = 'Y'                                        CUP038 BUG27975
     C**********         UPDATE    CQCOCDDF                                          CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C**********         READ      CQCOCDL1                                          CUP038 BUG27975
     C**********         ENDDO                                                       CUP038 BUG27975
      *
     C**********         ENDSR                                                       CUP038 BUG27975
      *EJECT****                                                                     CUP038 BUG27975
      *****************************************************************              CUP038 BUG27975
      **********                                                      *              CUP038 BUG27975
      ***SRCqPaD*-*Handles*Cheques*to*be*Paid*Debit*                  *              CUP038 BUG27975
      **********                                                      *              CUP038 BUG27975
      *****************************************************************              CUP038 BUG27975
     C*****SRCqPaD       BEGSR                                                       CUP038 BUG27975
      *
     C**********         EVAL      WDBNm = 'CQPADDD'                                 CUP038 BUG27975
      *
     C******LOVAL        SETLL     CQPADDL1                                          CUP038 BUG27975
     C**********         READ      CQPADDL1                                          CUP038 BUG27975
      *
     C**********         DOW       NOT %EOF                                          CUP038 BUG27975
      *
     C**********         EVAL      WUpd = 'N'                                        CUP038 BUG27975
     C**********         EVAL      WTRef = PREF                                      CUP038 BUG27975
      *
      **Charges*to*DR*Of*                                                            CUP038 BUG27975
     C**********         EVAL      WType = CDRT                                      CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(CDRO:1:12)                           CUP038 BUG27975
     C**********         EVAL      WFld = 'CDRO'                                     CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      CDRO = W18                                        CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C**********         IF        WUpd = 'Y'                                        CUP038 BUG27975
     C**********         UPDATE    CQPADDDF                                          CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C**********         READ      CQPADDL1                                          CUP038 BUG27975
     C**********         ENDDO                                                       CUP038 BUG27975
      *
     C**********         ENDSR                                                       CUP038 BUG27975
      /EJECT                                                                                  CUP038
      *****************************************************************                       CUP038
      *                                                               *                       CUP038
      *  SRFTVIPAY - Handles valid incoming payments                  *                       CUP038
      *                                                               *                       CUP038
      *****************************************************************                       CUP038
     C     SRFTVIPAY     BEGSR                                                                CUP038
      *
     C                   EVAL      WDBNm = 'FTVIPAYPD'                                        CUP038
      *
     C     *LOVAL        SETLL     FTVIPAYL0                                                  CUP038
     C                   READ      FTVIPAYL0                                                  CUP038
      *
     C                   DOW       NOT %EOF                                                   CUP038
      *
     C                   EVAL      WUpd = 'N'                                                 CUP038
     C                   EVAL      WTRef = IPPREF                                             CUP038
      *
      * Sender                                                                              BUG27975
     C                   EVAL      WType = IPSNTP                                           BUG27975
     C                   EVAL      WNarr = IPSND1                                           BUG27975
     C                   EVAL      WFld = 'IPSND1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPSND1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPSND1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Beneficiary                                                                         BUG27975
     C                   EVAL      WType = IPBNCT                                           BUG27975
     C                   EVAL      WNarr = IPBNC1                                           BUG27975
     C                   EVAL      WFld = 'IPBNC1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPBNC1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPBNC1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Ordering Bank                                                                       BUG27975
     C                   EVAL      WType = IPORBT                                           BUG27975
     C                   EVAL      WNarr = IPORB1                                           BUG27975
     C                   EVAL      WFld = 'IPORB1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPORB1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPORB1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Sender's Correspondent                                                              BUG27975
     C                   EVAL      WType = IPSNCT                                           BUG27975
     C                   EVAL      WNarr = IPSNC1                                           BUG27975
     C                   EVAL      WFld = 'IPSNC1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPSNC1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPSNC1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Ordering Customer                                                                   BUG27975
     C                   EVAL      WType = IPORCT                                           BUG27975
     C                   EVAL      WNarr = IPORC1                                           BUG27975
     C                   EVAL      WFld = 'IPORC1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPORC1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPORC1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Intermediary Bank                                                                   BUG27975
     C                   EVAL      WType = IPINBT                                           BUG27975
     C                   EVAL      WNarr = IPINB1                                           BUG27975
     C                   EVAL      WFld = 'IPINB1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPINB1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPINB1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Receiver's Correspondent                                                            BUG27975
     C                   EVAL      WType = IPINRCRT                                         BUG27975
     C                   EVAL      WNarr = IPINRCO1                                         BUG27975
     C                   EVAL      WFld = 'IPINRCO1'                                        BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPINRCO1                                        BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPINRCO1 = WNarr                                         BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Account With Bank                                                                   BUG27975
     C                   EVAL      WType = IPINACBT                                         BUG27975
     C                   EVAL      WNarr = IPINACB1                                         BUG27975
     C                   EVAL      WFld = 'IPINACB1'                                        BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = IPINACB1                                        BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      IPINACB1 = WNarr                                         BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      **Charges*to*DR*Of*                                                            CUP038 BUG27975
     C**********         EVAL      WType = IPCDRT                                    CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(IPCDRO:1:12)                         CUP038 BUG27975
     C**********         EVAL      WFld = 'IPCDRO'                                   CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      IPCDRO = W18                                      CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C                   IF        WUpd = 'Y'                                                 CUP038
     C                   UPDATE    FTVIPAYD0                                                  CUP038
     C                   ENDIF                                                                CUP038
      *
     C                   READ      FTVIPAYL0                                                  CUP038
     C                   ENDDO                                                                CUP038
      *
     C                   ENDSR                                                                CUP038
      /EJECT                                                                                  CUP038
      *****************************************************************                       CUP038
      *                                                               *                       CUP038
      *  SRFTVOPAY - Handles valid outgoing payments                  *                       CUP038
      *                                                               *                       CUP038
      *****************************************************************                       CUP038
     C     SRFTVOPAY     BEGSR                                                                CUP038
      *
     C                   EVAL      WDBNm = 'FTVOPAYPD'                                        CUP038
      *
     C     *LOVAL        SETLL     FTVOPAYL0                                                  CUP038
     C                   READ      FTVOPAYL0                                                  CUP038
      *
     C                   DOW       NOT %EOF                                                   CUP038
      *
     C                   EVAL      WUpd = 'N'                                                 CUP038
     C                   EVAL      WTRef = OTPREF                                             CUP038
      *
      * Destination                                                                         BUG27975
     C                   EVAL      WType = OTDSTT                                           BUG27975
     C                   EVAL      WNarr = OTDST1                                           BUG27975
     C                   EVAL      WFld = 'OTDST1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTDST1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTDST1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Ordering Customer                                                                   BUG27975
     C                   EVAL      WType = OTORCT                                           BUG27975
     C                   EVAL      WNarr = OTORC1                                           BUG27975
     C                   EVAL      WFld = 'OTORC1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTORC1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTORC1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Receiver's Correspondent                                                            BUG27975
     C                   EVAL      WType = OTRCRT                                           BUG27975
     C                   EVAL      WNarr = OTRCO1                                           BUG27975
     C                   EVAL      WFld = 'OTRCO1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTRCO1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTRCO1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Account With Bank                                                                   BUG27975
     C                   EVAL      WType = OTACBT                                           BUG27975
     C                   EVAL      WNarr = OTACB1                                           BUG27975
     C                   EVAL      WFld = 'OTACB1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTACB1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTACB1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Beneficiary Customer                                                                BUG27975
     C                   EVAL      WType = OTBNCT                                           BUG27975
     C                   EVAL      WNarr = OTBNC1                                           BUG27975
     C                   EVAL      WFld = 'OTBNC1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTBNC1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTBNC1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Intermediary Bank                                                                   BUG27975
     C                   EVAL      WType = OTINBT                                           BUG27975
     C                   EVAL      WNarr = OTINB1                                           BUG27975
     C                   EVAL      WFld = 'OTINB1'                                          BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTINB1                                          BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTINB1 = WNarr                                           BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      * Ordering Bank                                                                       BUG27975
     C                   EVAL      WType = OTOPORBT                                         BUG27975
     C                   EVAL      WNarr = OTOPORB1                                         BUG27975
     C                   EVAL      WFld = 'OTOPORB1'                                        BUG27975
      *
     C                   EXSR      SRChgNar                                                 BUG27975
      *
     C                   IF        WChg = 'Y'                                               BUG27975
     C                   EVAL      WFrNar = OTOPORB1                                        BUG27975
     C                   EVAL      WToNar = WNarr                                           BUG27975
     C                   EXSR      SRChgLog                                                 BUG27975
      *
     C                   EVAL      OTOPORB1 = WNarr                                         BUG27975
     C                   EVAL      WUpd = 'Y'                                               BUG27975
     C                   ENDIF                                                              BUG27975
      *
      **Charges*to*DR*Of*                                                            CUP038 BUG27975
     C**********         EVAL      WType = OTCDRT                                    CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(OTCDRO:1:12)                         CUP038 BUG27975
     C**********         EVAL      WFld = 'OTCDRO'                                   CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      OTCDRO = W18                                      CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
      **Ordering*Bank*                                                               CUP038 BUG27975
     C**********         EVAL      WType = OTORBT                                    CUP038 BUG27975
     C**********         EVAL      W12 = %SUBST(OTORBK:1:12)                         CUP038 BUG27975
     C**********         EVAL      WFld = 'OTORBK'                                   CUP038 BUG27975
      *
     C**********         EXSR      SRChg12Field                                      CUP038 BUG27975
      *
     C**********         IF        WChg = 'Y'                                        CUP038 BUG27975
     C**********         EVAL      WFrNar = W12                                      CUP038 BUG27975
     C**********         EVAL      WToNar = W18                                      CUP038 BUG27975
     C**********         EXSR      SRChgLog                                          CUP038 BUG27975
      *
     C**********         EVAL      OTORBK = W18                                      CUP038 BUG27975
     C**********         EVAL      WUpd = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C                   IF        WUpd = 'Y'                                                 CUP038
     C                   UPDATE    FTVOPAYD0                                                  CUP038
     C                   ENDIF                                                                CUP038
      *
     C                   READ      FTVOPAYL0                                                  CUP038
     C                   ENDDO                                                                CUP038
      *
     C                   ENDSR                                                                CUP038
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChgNar - Changes the narrative if necessary.               *
      *                                                               *
      *****************************************************************
     C     SRChgNar      BEGSR
      *
     C                   EVAL      WChg = 'N'
      *
      ** Full Account
      *
     C                   IF        WType = 'G'
     C                   MOVE      *BLANKS       WFulAcc
     C                   MOVEL     WNarr         WFulAcc
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WFuAc                                        CGL034
     C                   Parm                    WFuAcn           10                          CGL034
     C**********         EVAL      WNarr = WFuCu + WFuCc + WPad +                             CGL034
     C**********                           WFuAc + WFuAs + WFuBr                              CGL034
     C                   EVAL      WNarr = WFuCu + WFuCc +                                    CGL034
     C                                     WFuAcn + WFuAs + WFuBr                             CGL034
     C                   EVAL      WChg = 'Y'
     C                   ENDIF
      *
      ** Partial Account
     C                   IF        WType = 'P'
     C                   IF        %SUBST(WNarr:1:1) = '/'                                 BUG15105A
     C                   EVAL      TmpWNarr = WNarr                                        BUG15105A
     C                   EVAL      WNarr = %SUBST(TmpWNarr:2:34)                           BUG15105A
     C                   ENDIF                                                             BUG15105A
     C                   MOVE      *BLANKS       WParAcc
     C                   MOVEL     WNarr         WParAcc
     C                   Call      'SM00AC10'                                                 CGL034
     C                   Parm                    WPaAc                                        CGL034
     C                   Parm                    WPaAcn           10                          CGL034
     C**********         EVAL      WNarr = WPaCu + WPad + WPaAc +                             CGL034
     C**********                           WPaAs + WPaBr                                      CGL034
     C**********         EVAL      WNarr = WPaCu + WPad + WPaAcn +                     CGL034 CPK023
     C**********                           WPaAs + WPaBr                               CGL034 CPK023
     C                   EVAL      WNarr = WPaCu + WPaAcn + WPaAs + WPaBr                     CPK023
     C                   EVAL      WChg = 'Y'
     C                   ENDIF
      *
      * IBAN                                                                               BUG15105A
     C                   IF        WType = 'I'                                             BUG15105A
     C                   EVAL      PIBAN = WNarr                                           BUG15105A
     C                   IF        %SUBST(WNarr:1:1) = '/'                                 BUG15105A
     C                   EVAL      PIBAN = %SUBST(WNarr:2:34)                              BUG15105A
     C                   ENDIF                                                             BUG15105A
      * Access IBAN Details.                                                               BUG15105A
     C                   CALL      'AOIBANR4'                                              BUG15105A
     C                   PARM      *blanks       PRtcd             7                       BUG15105A
     C                   PARM      '*KEY   '     POptn             7                       BUG15105A
     C**********         Parm      *blanks       PCust             6             BUG15105A BUG15105C
     C                   PARM                    PIBAN            34                       BUG15105A
     C     ACCNT         PARM      ACCNT         DSSDY                                     BUG15105A
      *
     C                   IF        PRtcd = *Blanks                                         BUG15105A
     C                   MOVE      CNUM          WPacu                                     BUG15105A
     C                   MOVE      ACNO          WPaAcn                                    BUG15105A
     C                   MOVE      ACSQ          WPaAs                                     BUG15105A
     C                   EVAL      WPaBr = BRCA                                            BUG15105A
     C                   EVAL      WNarr = *Blanks                                         BUG15105A
     C                   EVAL      WNarr = WPaCu + WPaAcn + WPaAs + WPaBr                  BUG15105A
     C                   ENDIF                                                             BUG15105A
      *
     C                   ENDIF                                                             BUG15105A
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************              CUP038 BUG27975
      **********                                                      *              CUP038 BUG27975
      ***SRChg12Field*-*Change*the*contents*of*the*12*long*field*     *              CUP038 BUG27975
      **********                                                      *              CUP038 BUG27975
      *****************************************************************              CUP038 BUG27975
     C*****SRChg12Field  BEGSR                                                       CUP038 BUG27975
      *
     C**********         EVAL      WChg = 'N'                                        CUP038 BUG27975
      *
      **If*contents*are*Partial*account*                                             CUP038 BUG27975
     C**********         IF        WType = 'P'                                       CUP038 BUG27975
     C**********         Call      'SM00AC10'                                        CUP038 BUG27975
     C**********         Parm                    WPaAc12                             CUP038 BUG27975
     C**********         Parm                    WPaAc18                             CUP038 BUG27975
     C**********         EVAL      WPaCu18 = WPaCu12                                 CUP038 BUG27975
     C**********         EVAL      WPaAs18 = WPaAs12                                 CUP038 BUG27975
     C**********         EVAL      WChg = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
      **Retail*Account*                                                              CUP038 BUG27975
     C**********         IF        WType = 'R'                                       CUP038 BUG27975
     C**********         EVAL      WRetl18 = WRetl12                                 CUP038 BUG27975
     C**********         EVAL      WRblk18 = *blanks                                 CUP038 BUG27975
     C**********         EVAL      WChg = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
      **Nostro**                                                                     CUP038 BUG27975
     C**********         IF        WType = 'N'                                       CUP038 BUG27975
     C**********         EVAL      WNost18 = WNost12                                 CUP038 BUG27975
     C**********         EVAL      WNblk18 = *blanks                                 CUP038 BUG27975
     C**********         EVAL      WChg = 'Y'                                        CUP038 BUG27975
     C**********         ENDIF                                                       CUP038 BUG27975
      *
     C*****SRChg12FieldE ENDSR                                                       CUP038 BUG27975
      *
      /EJECT                                                                         CUP038 BUG27975
      *****************************************************************
      *                                                               *
      *  SRChgLog - Logs narrative changes.                           *
      *                                                               *
      *****************************************************************
     C     SRChgLog      BEGSR
      *
     C                   EVAL      SMDBNM = WDBNm
     C                   EVAL      SMTREF = WTRef
     C                   EVAL      SMNTYP = WType
     C                   EVAL      SMFLDN = WFld
     C                   EVAL      SMFRNR = WFrNar
     C                   EVAL      SMTONR = WToNar
      *
     C                   WRITE     SMCNLGD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
      *
     C**********         EVAL      WPad = '000000'                                            CPK023
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      PRtCd = '*ERROR '
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
