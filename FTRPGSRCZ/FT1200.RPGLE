     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FT Get Customer/Branch for INPAYDQD/OTPAYDQD')   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  FT1200 - Midas FT Get Customer/Branch for INPAYDQD/OTPAYDQD  *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058914   *CREATE Date 06Oct21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058914 - FT payments customer information on listviews is  *
      *             blank. Create program to retrieve customer and    *
      *             branch for INPAYDQD/OTPAYDQD.                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      ** DS for Incoming payments extension detail
      *
     D INPAYDQ       E DS                  EXTNAME(INPAYDQD)
      *
      ** DS for Outgoing payments extension detail
      *
     D OTPAYDQ       E DS                  EXTNAME(OTPAYDQD)
      *
      ** DS for Account Master Details
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB)
     D ZZBRCA        E                     EXTFLD(BRCA)
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
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@STR           S             35A
     D P@STR2          S             35A
     D P@STR3          S             35A
     D WNSTR           S             35A
     D P@TYP           S             10A
     D P@RETL          S             10A
     D P@KEY           S              7A
      *
      ** Working Variables
      *
     D WCUSTOMER       S             10A
     D WCUSTNUMB       S              6A
     D WCUSTBRCH       S              3A
     D W@CCY           S              3A
     D W@BRC           S              3A
     D W@SLASH         S              1A
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
     C                   EVAL      WCUSTNUMB = *BLANKS
     C                   EVAL      WCUSTBRCH = *BLANKS
      *
      ** Incoming Payments Extension
      *
     C                   SELECT
     C                   WHEN      P@INOT = 'I'
     C                   EXSR      SRINPAY
      *
      ** Outgoing Payments Extension
      *
     C                   WHEN      P@INOT = 'O'
     C                   EXSR      SROTPAY
     C                   ENDSL
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInPay - Handles Incoming Payments Extension File           *
      *                                                               *
      *****************************************************************
     C     SRINPAY       BEGSR
      *
     C                   EVAL      P@STR = BNC1
      *
     C                   IF        %SUBST(BNC1:1:1) = '/'
     C                   IF        BNC2 <> *BLANKS
     C                   EVAL      P@STR = BNC2
     C                   ELSE
     C                   EVAL      WNSTR= *BLANKS
     C                   EVAL      WNSTR= %SUBST(BNC1:2:34)
     C                   EVAL      P@STR = WNSTR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        P@STR <> *BLANKS
      *
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM                    P@STR
     C                   PARM                    DSSDY
      *
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCUSTOMER = CNUM
     C                   ELSE
      *
     C                   EVAL      W@CCY = PCCY
     C                   EVAL      W@BRC = BRCA
      *
      ** Format Full GL Account
      ** Format Partial Account
      ** Format Nostro Account
      *
     C                   SELECT
     C                   WHEN      %LEN(%TRIM(P@STR)) = 24
     C                   EVAL      P@STR = %SUBST(P@STR:22:3)
     C                             + %SUBST(P@STR:1:21)
     C                   WHEN      %LEN(%TRIM(P@STR)) = 21
     C                   EVAL      P@STR = %SUBST(P@STR:19:3) +
     C                             %SUBST(P@STR:1:6) + W@CCY +
     C                             %SUBST(P@STR:7:12)
     C                   WHEN      %LEN(%TRIM(P@STR)) = 18
     C                   EVAL      P@STR = W@BRC +
     C                             %SUBST(P@STR:1:6) + W@CCY +
     C                             %SUBST(P@STR:7:12)
     C                   WHEN      %LEN(%TRIM(P@STR)) = 2
     C                   EVAL      P@STR = W@CCY + %SUBST(P@Str:1:2)
      *
     C                   ENDSL
      *
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      *BLANKS       P@TYP
     C                   PARM                    P@STR
     C                   PARM                    DSSDY
      *
      ** Get the Customer and Branch
      *
     C                   SELECT
      *
     C                   WHEN      P@TYP = '*RETAIL' OR
     C                             P@TYP = '*LEDGER'
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCUSTOMER = CNUM
      *
     C                   WHEN      P@TYP = '*SWIFT'
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCUSTOMER = BBCUST
      *
     C                   WHEN      P@TYP = '*NOSTRO'
     C                   EVAL      SDNOST = DSSDY
     C                   EVAL      WCUSTOMER = A7CUST
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@RETL
     C                   PARM                    A7CUST
     C                   PARM                    A7CYCD
     C                   PARM                    A7ACCD
     C                   PARM                    A7ACSN
     C                   PARM                    A7BRCD
     C     ACCNT         PARM                    DSSDY
      *
     C                   WHEN      P@TYP = '*CUSTNO' OR
     C                             P@TYP = '*SHNAME'
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCUSTOMER = BBCUST
      *
     C                   WHEN      P@TYP = '*NRF   '
     C                   EVAL      WCUSTOMER = *BLANKS
      *
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF         WCUSTOMER <> *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM                    WCUSTOMER
     C                   PARM      *BLANKS       P@KEY
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   ENDIF
      *
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WCUSTNUMB = BBCUST
     C                   EVAL      WCUSTBRCH = BBBRCD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROtPay - Handles Outgoing Payments Extension File           *
      *                                                               *
      *****************************************************************
     C     SROTPAY       BEGSR
      *
     C                   EVAL      WCUSTOMER = *BLANKS
     C                   EVAL      W@ATYP = ' '
     C                   EVAL      W@SLASH = 'N'
     C                   EVAL      P@STR = ORC1
     C                   EVAL      P@STR2 = ORC2
     C                   EVAL      P@STR3 = ORC3
      *
     C                   IF        %SUBST(P@STR:1:1) = '/'
     C                   EVAL      W@SLASH = 'Y'
     C                   IF        P@STR2 <> *BLANKS
     C                   EVAL      P@STR = P@STR2
     C                   ELSE
     C                   EVAL      P@STR= %SUBST(P@STR:2:34)
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        (W@SLASH = 'Y' AND P@STR3 <> *BLANKS)
     C                             OR (W@SLASH = 'N' AND P@Str2 <> *BLANKS)
     C                   EVAL      W@ATYP = 'A'
     C                   ENDIF
      *
     C                   IF        P@STR <> *BLANKS AND
     C                             W@ATYP <> 'A'
      *
      ** Check if IBAN
      *
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM                    P@STR
     C                   PARM                    DSSDY
      *
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCUSTOMER = CNUM
      *
     C                   ELSE
      *
      ** Format Full GL Account
      ** Format Partial Account
      ** Format Nostro Account
      *
     C                   EVAL      W@CCY = SMCY
     C                   EVAL      W@BRC = BRCA
      *
     C                   SELECT
     C                   WHEN      %LEN(%TRIM(P@STR)) = 24
     C                   EVAL      P@STR = %SUBST(P@STR:22:3)
     C                             + %SUBST(P@STR:1:21)
     C                   WHEN      %LEN(%TRIM(P@STR)) = 21
     C                   EVAL      P@STR = %SUBST(P@STR:19:3) +
     C                             %SUBST(P@STR:1:6) + W@CCY +
     C                             %SUBST(P@STR:7:12)
     C                   WHEN      %LEN(%TRIM(P@STR)) = 18
     C                   EVAL      P@STR = W@BRC +
     C                             %SUBST(P@STR:1:6) + W@CCY +
     C                             %SUBST(P@STR:7:12)
     C                   WHEN      %LEN(%TRIM(P@STR)) = 2
     C                   EVAL      P@STR = W@CCY + %SUBST(P@Str:1:2)
     C                   ENDSL
      *
     C                   CALL      'AOACCTV1'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      *BLANKS       P@TYP
     C                   PARM                    P@STR
     C                   PARM                    DSSDY
      *
      ** Get the Customer and Branch
      *
     C                   SELECT
      *
     C                   WHEN      P@TYP = '*RETAIL' OR
     C                             P@TYP = '*LEDGER'
     C                   EVAL      ACCNT = DSSDY
     C                   EVAL      WCUSTOMER = CNUM
      *
     C                   WHEN      P@TYP = '*NOSTRO'
     C                   EVAL      SDNOST = DSSDY
     C                   EVAL      WCUSTOMER = A7CUST
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@RETL
     C                   PARM                    A7CUST
     C                   PARM                    A7CYCD
     C                   PARM                    A7ACCD
     C                   PARM                    A7ACSN
     C                   PARM                    A7BRCD
     C     ACCNT         PARM                    DSSDY
      *
     C                   WHEN      P@TYP = '*CUSTNO' OR
     C                             P@TYP = '*SHNAME'
      *
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCUSTOMER = BBCUST
      *
     C                   WHEN      P@TYP = '*SWIFT '
     C                   EVAL      SDCUST = DSSDY
     C                   EVAL      WCUSTNUMB = BBCUST
     C                   EVAL      WCUSTBRCH = BBBRCD
      *
     C                   WHEN      P@TYP = '*NRF   '
     C                   EVAL      WCUSTOMER = *BLANKS
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   IF         WCUSTOMER <> *BLANKS
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM                    WCUSTOMER
     C                   PARM      *BLANKS       P@KEY
     C     SDCUST        PARM      SDCUST        DSSDY
     C                   ENDIF
      *
     C                   IF        P@RTCD = *BLANKS
     C                   EVAL      WCUSTNUMB = BBCUST
     C                   EVAL      WCUSTBRCH = BBBRCD
     C                   ENDIF
     C                   ENDIF
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
     C                   PARM                    P@RTCD
      * INPUTS
     C                   PARM                    P@INOT            1            I/O
     C                   PARM                    BNC1             35            Beneficiary - 1
     C                   PARM                    BNC2             35            Beneficiary - 2
     C                   PARM                    ORC1             35            Ordering - 1
     C                   PARM                    ORC2             35            Ordering - 1
     C                   PARM                    ORC3             35            Ordering - 1
     C                   PARM                    BRCA              3            Booking branch
     C                   PARM                    PCCY              3            Payment currency
     C                   PARM                    SMCY              3            Settle currency
      * OUTPUTS
     C                   PARM                    WCUSTNUMB                      Customer Number
     C                   PARM                    WCUSTBRCH                      Customer Branch
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
     C                   EVAL      P@RTCD = '*ERROR '
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
      *
