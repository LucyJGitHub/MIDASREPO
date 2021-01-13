     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Populate Customer Number and Branch field')   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000099 - Midas SM Populate Customer and Branch fields      *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1084524 *CREATE  Date 13Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas FT Incoming Payments Details
      *
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas FT Outgoing Payments Details
      *
     FOTPAY     IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas FT Incoming Payments Extension Details
      *
     FINPAYQL0  UF A E           K DISK    INFSR(*PSSR)
      *
      ** Midas FT Outgoing Payments Extension Details
      *
     FOTPAYQL0  UF A E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ External data areas                  ¦
      ** ¦ ===================                  ¦
      ** +--------------------------------------+
      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
      *
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      *
      ** DS for Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Account Master Details
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
      *
      ** DS for Nostro Details
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      ** DS for Customer Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
      *
     D P@Rtcd          S              7A
     D P@Optn          S              7A
     D P@Str           S             35A
     D P@Str2          S             35A
     D P@Str3          S             35A
     D WNStr           S             35A
     D P@Typ           S             10A
     D P@RETL          S             10A
     D P@Key           S              7A
      *
      ** Working Variables
      *
     D WBNCC           S              6A
     D WBNCB           S              3A
     D WORCC           S              6A
     D WORCB           S              3A
     D W@CCY           S              3A
     D W@BRC           S              3A
     D WCustomer       S             10A
     D W@Slash         S              1A
     D W@ATYP          S              1A
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
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Incoming Payments Extension
      *
     C                   EXSR      SRInPay
      *
      ** Outgoing Payments Extension
      *
     C                   EXSR      SROtPay
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInPay - Handles Incoming Payments Extension File           *
      *                                                               *
      *****************************************************************
     C     SRInPay       BEGSR
      *
     C     *LOVAL        SETLL     INPAY
     C                   READ      INPAY
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WBNCC = *Blanks
     C                   EVAL      WBNCB = *Blanks
     C                   EVAL      P@Str = BNC1
      *
     C                   IF        %SUBST(BNC1:1:1) = '/'
     C                   IF        BNC2 <> *BLANKS
     C                   EVAL      P@Str = BNC2
     C                   ELSE
     C                   EVAL      WNStr= *BLANKS
     C                   EVAL      WNStr= %SUBST(BNC1:2:34)
     C                   EVAL      P@Str = WNStr
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        P@Str <> *Blanks
      *
     C                   CALL      'AOIBANR2'
     C                   PARM      *Blanks       P@Rtcd
     C                   PARM                    P@Str
     C                   PARM                    DSSDY
      *
     C                   IF        P@Rtcd = *BLANKS
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCustomer = CNUM
     C                   ELSE
      *
     C                   EVAL      W@CCY = SMCY
     C                   EVAL      W@BRC = ORBR
     C                   IF        PCCY <> *BLANKS
     C                   EVAL      W@CCY = PCCY
     C                   ENDIF
      *
      ** Format Full GL Account
      ** Format Partial Account
      ** Format Nostro Account
      *
     C                   SELECT
     C                   WHEN      %LEN(%TRIM(P@Str)) = 24
     C                   EVAL      P@Str = %SUBST(P@Str:22:3)
     C                             + %SUBST(P@Str:1:21)
     C                   WHEN      %LEN(%TRIM(P@Str)) = 21
     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +
     C                             %SUBST(P@Str:1:6) + W@CCY +
     C                             %SUBST(P@Str:7:12)
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18
     C                   EVAL      P@Str = W@BRC +
     C                             %SUBST(P@Str:1:6) + W@CCY +
     C                             %SUBST(P@Str:7:12)
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2
     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)
      *
     C                   ENDSL
      *
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      *BLANKS       P@Typ
     C                   PARM                    P@Str
     C                   PARM                    DSSDY
      *
      ** Get the Customer and Branch
      *
     C                   SELECT
      *
     C                   WHEN      P@TYP = '*RETAIL' OR
     C                             P@TYP = '*LEDGER'
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCustomer = CNUM
      *
     C                   WHEN      P@TYP = '*SWIFT'
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCustomer = BBCUST
      *
     C                   WHEN      P@TYP = '*NOSTRO'
     C                   EVAL      SDNOST = DSSDY
     C                   EVAL      WCustomer = A7CUST
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY   '     P@Optn
     C                   PARM      *BLANKS       P@RETL
     C                   PARM                    A7CUST
     C                   PARM                    A7CYCD
     C                   PARM                    A7ACCD
     C                   PARM                    A7ACSN
     C                   PARM                    A7BRCD
     C     ACCNT         PARM                    DSSDY
      *
     C                   WHEN      P@Typ = '*CUSTNO' OR
     C                             P@Typ = '*SHNAME'
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCustomer = BBCUST
      *
     C                   WHEN      P@Typ = '*NRF   '
     C                   EVAL      WCustomer = *Blanks
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF         WCustomer <> *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM                    WCustomer
     C                   PARM      *BLANKS       P@Key
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   ENDIF
      *
     C                   IF        P@Rtcd = *BLANKS
     C                   EVAL      WBNCC = BBCUST
     C                   EVAL      WBNCB = BBBRCD
     C                   ENDIF
      *
     C     PREF          CHAIN     INPAYQL0
     C                   IF        %Found
     C                   EVAL      IPBNCC = WBNCC
     C                   EVAL      IPBNCB = WBNCB
     C                   UPDATE    INPAYQD0
     C                   ELSE
     C                   EVAL      IPPREF = PREF
     C                   EVAL      IPBRCA = BRCA
     C                   EVAL      IPBNCC = WBNCC
     C                   EVAL      IPBNCB = WBNCB
     C                   WRITE     INPAYQD0
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
      *  SROtPay - Handles Outgoing Payments Extension File           *
      *                                                               *
      *****************************************************************
     C     SROtPay       BEGSR
      *
     C     *LOVAL        SETLL     OTPAY
     C                   READ      OTPAY
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      W@ATyp = ' '
     C                   EVAL      WCustomer = *Blanks
     C                   EVAL      W@Slash = 'N'
     C                   EVAL      P@Str = ORC1
     C                   EVAL      P@Str2 = ORC2
     C                   EVAL      P@Str3 = ORC3
     C                   EVAL      WORCC = *Blanks
     C                   EVAL      WORCB = *Blanks
      *
     C                   IF        %SUBST(P@Str:1:1) = '/'
     C                   EVAL      W@Slash = 'Y'
     C                   IF        P@Str2 <> *BLANKS
     C                   EVAL      P@Str = P@Str2
     C                   ELSE
     C                   EVAL      P@Str= %SUBST(P@Str:2:34)
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        (W@Slash = 'Y' AND P@Str3 <> *BLANKS)
     C                             OR (W@Slash = 'N' AND P@Str2 <> *BLANKS)
     C                   EVAL      W@ATyp = 'A'
     C                   ENDIF
      *
     C                   IF        P@Str <> *BLANKS AND
     C                             W@ATyp <> 'A'
      *
      ** Check if IBAN
      *
     C                   CALL      'AOIBANR2'
     C                   PARM      *Blanks       P@Rtcd
     C                   PARM                    P@Str
     C                   PARM                    DSSDY
      *
     C                   IF        P@Rtcd = *BLANKS
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCustomer = CNUM
      *
     C                   ELSE
      *
      ** Format Full GL Account
      ** Format Partial Account
      ** Format Nostro Account
      *
     C                   EVAL      W@CCY = SMCY
     C                   EVAL      W@BRC = ORBB
      *
     C                   SELECT
     C                   WHEN      %LEN(%TRIM(P@Str)) = 24
     C                   EVAL      P@Str = %SUBST(P@Str:22:3)
     C                             + %SUBST(P@Str:1:21)
     C                   WHEN      %LEN(%TRIM(P@Str)) = 21
     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +
     C                             %SUBST(P@Str:1:6) + W@CCY +
     C                             %SUBST(P@Str:7:12)
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18
     C                   EVAL      P@Str = W@BRC +
     C                             %SUBST(P@Str:1:6) + W@CCY +
     C                             %SUBST(P@Str:7:12)
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2
     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)
     C                   ENDSL
      *
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      *BLANKS       P@Typ
     C                   PARM                    P@Str
     C                   PARM                    DSSDY
      *
      ** Get the Customer and Branch
      *
     C                   SELECT
      *
     C                   WHEN      P@Typ = '*RETAIL' OR
     C                             P@Typ = '*LEDGER'
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCustomer = CNUM
      *
     C                   WHEN      P@Typ = '*NOSTRO'
     C                   EVAL      SDNOST = DSSDY
     C                   EVAL      WCustomer = A7CUST
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY   '     P@Optn
     C                   PARM      *BLANKS       P@RETL
     C                   PARM                    A7CUST
     C                   PARM                    A7CYCD
     C                   PARM                    A7ACCD
     C                   PARM                    A7ACSN
     C                   PARM                    A7BRCD
     C     ACCNT         PARM                    DSSDY
      *
     C                   WHEN      P@Typ = '*CUSTNO' OR
     C                             P@Typ = '*SHNAME'
      *
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCustomer = BBCUST
      *
     C                   WHEN      P@Typ = '*SWIFT '
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WORCC = BBCUST
     C                   EVAL      WORCB = BBBRCD
      *
     C                   WHEN      P@Typ = '*NRF   '
     C                   EVAL      WCustomer = *Blanks
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   IF         WCustomer <> *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@Rtcd
     C                   PARM      '*KEY'        P@Optn
     C                   PARM                    WCustomer
     C                   PARM      *BLANKS       P@Key
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ENDIF
      *
     C                   IF        P@Rtcd = *Blanks
     C                   EVAL      WORCC = BBCUST
     C                   EVAL      WORCB = BBBRCD
     C                   ENDIF
     C                   ENDIF
      *
     C     PREF          CHAIN     OTPAYQL0
     C                   IF        %Found
     C                   EVAL      OTORCC = WORCC
     C                   EVAL      OTORCB = WORCB
     C                   UPDATE    OTPAYQD0
     C                   ELSE
     C                   EVAL      OTPREF = PREF
     C                   EVAL      OTBRCA = BRCA
     C                   EVAL      OTORCC = WORCC
     C                   EVAL      OTORCB = WORCB
     C                   WRITE     OTPAYQD0
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
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    P@Rtcd
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
     C                   EVAL      P@Rtcd = '*ERROR '
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
