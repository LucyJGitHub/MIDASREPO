     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Convert settlement details to name & add.')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCWLFMT - Convert Settlement Details to Customer            *
      *             Name and Address                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 BUG15105A          Date 25Oct07               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 03Sep01               *
      *                 CGL020             Date 12Dec02               *
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15105A - Missing Process for SWIFT 2007 (Reopen)          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198 - Cannot save new Details for CUSD (Recompile)       *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRNostro - Get Nostro Details                                *
      *  SRRetail - Get Account Details                               *
      *  SRSwift - Get Customer of SWIFT account                      *
      *  SRIBAN - Get IBAN Account Details                            *
      *  SRCustomer - Get Customer Details                            *
      *  SROUT - Fill up Output Field with Name and address           *
      *  SROUT2 - Fill up Output Field with Counterparty Details      *
      *  SROUT3 - Fill up Output field with Input fields              *
      *                                                               *
      *  *PSSR  - Error processing                                    *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customers by SWIFT ID
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
 
      ** Counterparty Nostros by SWIFT ID
     FSDCNSTL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External DS for Customer Details
 
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** External DS for Nostro Details
 
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
      ** External DS for Account Details
                                                                                              CGL020
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  CGL020
      ** External DS for Location Codes                                                       CGL020
                                                                                              CGL020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL020
     D  WLCD         E                     EXTFLD(LCD)                                        CGL020
      ** External DS for Switchable Feature                                                   CGL020
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Short DS for Access Object Programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for Access Object Program
 
     D WArrInp         S              1    DIM(35)
      ** Input field array
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
                                                                                              CGL020
     D/COPY ZACPYSRC,STD_D_SPEC                                                               CGL020
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D PINPUT1         S             35
     D PINPUT2         S             35
     D PINPUT3         S             35
     D PINPUT4         S             35
     D PINPUT5         S             35
     D PINPUT6         S             35
     D PINCCY          S              3
     D POUTPUT1        S            216
     D POUTPUT2        S              6
 
      ** Parameters for access object
     D PRTCD           S              7
     D POPTN           S              7
     D PRETCD          S              7
      ** Access Object Nostro
     D PCUST           S              6
     D PCYCD           S              3
     D***PACCN           S              4                                                     CGL029
     D PACCN           S             10                                                       CGL029
     D PACSN           S              2
     D PNONB           S              2
     D PBRCD           S              3
     D PCSSN           S             10
     D PPNOI           S              1
      ** Access Object Retail
     D PRETL           S             10
     D PCNUM           S              6
     D PCUCD           S              3
     D***PACCD           S              4                                                     CGL029
     D PACCD           S             10                                                       CGL029
     D PACSQ           S              2
     D PBRCA           S              3
      ** Access Object Customer
     D PKEY1           S             10
     D PKYST           S              7
                                                                                              CGL020
      ** Key For CGL020                                                                       CGL020
     D CGL020          S              1                                                       CGL020
     D PRtnCde         S              7                                                       CGL020
     D PSard           S              6                                                       CGL020
     D POption         S              7                                                       CGL020
     D PKey            S              3                                                       CGL020
 
     D WRun            S              1
     D Ws1             S              2  0
     D Wx1             S              2  0
     D WInput          S             35A
     D WSwiftID        S             12A
     D WSwiftIn        S             12A
     D WSwiftBr        S              3A
     D WSlash          S              1A
     D WINPUT1         S             35                                                    BUG15105A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ I-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      POUTPUT1 = *BLANKS
     C                   EVAL      POUTPUT2 = *BLANKS
 
      ** Get Customer Details for Customer/Customer Shortname
 
     C                   EVAL      PKEY1 = WInput
     C                   EXSR      SRCustomer
 
     C                   IF        POUTPUT1 = *BLANKS
 
      ** Check type of account
 
     C     ' '           SCAN      WInput        Ws1
 
     C                   SELECT
      ** Nostro Account
     C                   WHEN      Ws1 = 6 OR
     C                             Ws1 = 3
     C                   EXSR      SRNostro
      ** Retail Account
     C                   WHEN      Ws1 = 11
     C                   EXSR      SRRetail
      ** SWIFT Account
     C                   WHEN      Ws1 = 9 OR
     C                             Ws1 = 12
     C                   EXSR      SRSwift
      ** General Ledger Account
     C                   OTHER
     C                   EVAL      PKEY1 = %SUBST(WInput:1:6)
     C                   EXSR      SRCustomer
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** IBAN account
 
     C                   IF        POUTPUT1 = *BLANKS
     C                   EXSR      SRIBAN
     C                   ENDIF
 
      ** Free Format
 
     C                   IF        POUTPUT1 = *BLANKS
     C                   EXSR      SROUT3
     C                   ENDIF
                                                                                              CGL020
      ** Format Return Code and Output Data for AML                                           CGL020
                                                                                              CGL020
     C                   IF        CGL020 = 'Y' AND                                           CGL020
     C                             PRETCD = '*AML'                                            CGL020
     C                   EXSR      SRAML                                                      CGL020
     C                   ENDIF                                                                CGL020
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
                                                                                              CGL020
      *****************************************************************                       CGL020
      /EJECT                                                                                  CGL020
      *****************************************************************                       CGL020
      *                                                               *                       CGL020
      *  SRAML - Format Return Code and Output Data                   *                       CGL020
      *                                                               *                       CGL020
      *****************************************************************                       CGL020
     C     SRAML         BEGSR                                                                CGL020
                                                                                              CGL020
     C                   EVAL      POUTPUT2 = *BLANKS                                         CGL020
                                                                                              CGL020
      ** Format return code and output based on customer details                              CGL020
                                                                                              CGL020
     C                   IF        BBCUST <> *BLANKS                                          CGL020
     C                   IF        BBCSID <> *BLANKS                                          CGL020
     C                   EVAL      PRETCD = '*BIC'                                            CGL020
     C                   EVAL      POUTPUT1 = BBCSID                                          CGL020
     C                   ELSE                                                                 CGL020
     C                   EVAL      PRETCD = '*CUST'                                           CGL020
     C                   EVAL      POUTPUT1 = BBCUST                                          CGL020
     C                   ENDIF                                                                CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   IF        AWCPNC <> *BLANKS                                          CGL020
     C                   IF        AWSWID <> *BLANKS                                          CGL020
     C                   EVAL      PRETCD = '*BIC'                                            CGL020
     C                   EVAL      POUTPUT1 = AWSWID                                          CGL020
     C                   ELSE                                                                 CGL020
     C                   IF        AWCSN2 <> *BLANKS                                          CGL020
     C                   CALL      'AOLOCNR0'                                                 CGL020
     C                   PARM      *BLANKS       PRtnCde                                      CGL020
     C                   PARM      *BLANKS       POption                                      CGL020
     C                   PARM      AWCSN2        PKey                                         CGL020
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   IF        PRtnCde = *BLANKS                                          CGL020
     C                   EVAL      POUTPUT1 = AWCPNC                                          CGL020
     C                   EVAL      PRETCD = '*CPART1'                                         CGL020
     C                   ELSE                                                                 CGL020
     C                   EVAL      POUTPUT1 = AWCPNC                                          CGL020
     C                   EVAL      PRETCD = '*CPARTY'                                         CGL020
     C                   ENDIF                                                                CGL020
     C                   ENDIF                                                                CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   ENDSR                                                                CGL020
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNostro - Get Nostro Details                                *
      *                                                               *
      *****************************************************************
     C     SRNostro      BEGSR
 
      ** Get Nostro details
 
     C                   IF        Ws1 = 6
     C                   EVAL      PCYCD = %SUBST(WInput:1:3)
     C                   EVAL      PNONB = %SUBST(WInput:4:2)
     C                   ELSE
     C                   EVAL      PCYCD = PINCCY
     C                   EVAL      PNONB = WInput
     C                   ENDIF
 
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      *BLANKS       PCUST
     C                   PARM                    PCYCD
     C                   PARM      *BLANKS       PACCN
     C                   PARM      *BLANKS       PACSN
     C                   PARM                    PNONB
     C                   PARM      *BLANKS       PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      *BLANKS       DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PKEY1 = A7CUST
     C                   EXSR      SRCustomer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetail - Get Account Details                               *
      *                                                               *
      *****************************************************************
     C     SRRetail      BEGSR
 
     C                   EVAL      PRETL = WInput
 
      ** Get Account details
 
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PRETL
     C                   PARM      *BLANKS       PCNUM
     C                   PARM      *BLANKS       PCUCD
     C                   PARM      *BLANKS       PACCD
     C                   PARM      *BLANKS       PACSQ
     C                   PARM      *BLANKS       PBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     CNUM          PKEY1
     C                   EXSR      SRCustomer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSwift - Get Customer of SWIFT account                      *
      *                                                               *
      *****************************************************************
     C     SRSwift       BEGSR
 
     C                   EVAL      WSwiftIn = WInput
     C                   EVAL      WSwiftID = %SUBST(WInput:1:8)
     C                   EVAL      WSwiftBr = %SUBST(WInput:9:3)
 
      ** Check SWIFT ID in Customers file
 
     C     WSwiftIn      CHAIN     SDCUSTL7
 
     C                   IF        %FOUND(SDCUSTL7)
     C                   EXSR      SROUT
     C                   ENDIF
 
     C                   IF        NOT %FOUND(SDCUSTL7) AND
     C                             WSwiftBr = *BLANKS
     C                   MOVE      'XXX '        WSwiftID
     C     WSwiftID      CHAIN     SDCUSTL7
 
     C                   IF        %FOUND(SDCUSTL7)
     C                   EXSR      SROUT
     C                   ENDIF
     C                   ENDIF
 
      ** If not found in Customers File, Check in Counterparty Nostro File
 
     C                   IF        NOT %FOUND(SDCUSTL7)
 
     C                   EVAL      WSwiftIn = WInput
     C                   EVAL      WSwiftID = %SUBST(WInput:1:8)
     C                   EVAL      WSwiftBr = %SUBST(WInput:9:3)
 
     C     WSwiftIn      CHAIN     SDCNSTL2
 
     C                   IF        %FOUND(SDCNSTL2)
     C                   EXSR      SROUT2
     C                   ENDIF
 
     C                   IF        NOT %FOUND(SDCNSTL2) AND
     C                             WSwiftBr = *BLANKS
     C                   MOVE      'XXX '        WSwiftID
     C     WSwiftID      CHAIN     SDCNSTL2
 
     C                   IF        %FOUND(SDCNSTL2)
     C                   EXSR      SROUT2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIBAN - Get IBAN Account Details                            *
      *                                                               *
      *****************************************************************
     C     SRIBAN        BEGSR
 
     C                   CALL      'AOIBANR4'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PIBAN            34
     C     SDACCT        PARM      *BLANKS       DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      PKEY1 = *BLANKS
     C                   MOVEL     CNUM          PKEY1
     C                   EXSR      SRCustomer
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustomer - Get Customer Details                            *
      *                                                               *
      *****************************************************************
     C     SRCustomer    BEGSR
 
      ** Get Customer Details
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C                   PARM      *BLANK        PKYST
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EXSR      SROUT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROUT - Fill up Output Field with Name and address           *
      *                                                               *
      *****************************************************************
     C     SROUT         BEGSR
 
     C                   EVAL      POUTPUT1 = BBCNA1
 
     C                   IF        BBCNA2 <> *BLANKS
     C     BBCNA1        CAT       BBCNA2:1      POUTPUT1
     C                   ENDIF
     C                   IF        BBCNA3 <> *BLANKS
     C     POUTPUT1      CAT       BBCNA3:1      POUTPUT1
     C                   ENDIF
     C                   IF        BBCNA4 <> *BLANKS
     C     POUTPUT1      CAT       BBCNA4:1      POUTPUT1
     C                   ENDIF
 
     C                   EVAL      POUTPUT2 = BBCUST
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROUT2 - Fill up Output Field with Counterparty Details      *
      *                                                               *
      *****************************************************************
     C     SROUT2        BEGSR
 
     C     AWCPNM        CAT       AWCNTN:1      POUTPUT1
 
     C                   EVAL      POUTPUT2 = '*CPART'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROUT3 - Fill up Output field with Input fields              *
      *                                                               *
      *****************************************************************
     C     SROUT3        BEGSR
 
     C                   EVAL      POUTPUT1 = PINPUT1
 
     C                   IF        PINPUT2 <> *BLANKS
     C     PINPUT1       CAT       PINPUT2:1     POUTPUT1
     C                   ENDIF
     C                   IF        PINPUT3 <> *BLANKS
     C     POUTPUT1      CAT       PINPUT3:1     POUTPUT1
     C                   ENDIF
     C                   IF        PINPUT4 <> *BLANKS
     C     POUTPUT1      CAT       PINPUT4:1     POUTPUT1
     C                   ENDIF
     C                   IF        PINPUT5 <> *BLANKS
     C     POUTPUT1      CAT       PINPUT5:1     POUTPUT1
     C                   ENDIF
     C                   IF        PINPUT6 <> *BLANKS
     C     POUTPUT1      CAT       PINPUT6:1     POUTPUT1
     C                   ENDIF
 
     C                   EVAL      POUTPUT2 = '*FREE'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR     - Program Initialisation routine                  *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRETCD
     C                   PARM                    PINPUT1
     C                   PARM                    PINPUT2
     C                   PARM                    PINPUT3
     C                   PARM                    PINPUT4
     C                   PARM                    PINPUT5
     C                   PARM                    PINPUT6
     C                   PARM                    PINCCY
     C                   PARM                    POUTPUT1
     C                   PARM                    POUTPUT2
                                                                                              CGL020
      ** Check if Compliance Watch - AML interface (CGL020) is installed                      CGL020
                                                                                              CGL020
     C                   EVAL      CGL020 = 'N'                                               CGL020
                                                                                              CGL020
     C                   CALL      'AOSARDR0'                                                 CGL020
     C                   PARM      *BLANKS       PRtnCde                                      CGL020
     C                   PARM      '*VERIFY'     POption                                      CGL020
     C                   PARM      'CGL020'      PSard                                        CGL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL020
                                                                                              CGL020
      ** Database error                                                                       CGL020
                                                                                              CGL020
     C                   IF        PRtnCde <> *BLANKS AND                                     CGL020
     C                             PRtnCde <> '*NRF'                                          CGL020
     C     *LOCK         IN        LDA                                                        CGL020
     C                   EVAL      DBKEY = 'CGL020'                                           CGL020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL020
     C                   EVAL      DBASE = 1                                                  CGL020
     C                   OUT       LDA                                                        CGL020
     C                   EXSR      *PSSR                                                      CGL020
     C                   ENDIF                                                                CGL020
                                                                                              CGL020
     C                   IF        PRtnCde = *BLANKS                                          CGL020
     C                   EVAL      CGL020 = 'Y'                                               CGL020
     C                   ENDIF                                                                CGL020
 
      ** Format Input field
 
     C**********         MOVEA     PINPUT1       WArrInp                                   BUG15105A
     C**********         Z-ADD     1             Wx1                                       BUG15105A
     C**********         EVAL      WSlash = 'Y'                                            BUG15105A
 
     C**********         DOW       WSlash = 'Y' AND                                        BUG15105A
     C**********                   Wx1 <= 35                                               BUG15105A
     C**********         IF        WArrInp(Wx1) = '/'                                      BUG15105A
     C**********         EVAL      Wx1 = Wx1 + 1                                           BUG15105A
     C**********         ELSE                                                              BUG15105A
     C**********         EVAL      WSlash = 'N'                                            BUG15105A
     C**********         EVAL      WInput = %SUBST(PINPUT1:Wx1)                            BUG15105A
     C**********         ENDIF                                                             BUG15105A
 
     C**********         ENDDO                                                             BUG15105A
 
     C                   If        %Subst(PINPUT1:1:1) = '/'                               BUG15105A
     C                   If        PINPUT2 = *Blanks                                       BUG15105A
     C                   Eval      WInput = %SUBST(PINPUT1:2:34)                           BUG15105A
     C                   Else                                                              BUG15105A
     C                   Eval      WInput = PINPUT2                                        BUG15105A
     C                   EndIf                                                             BUG15105A
     C                   Else                                                              BUG15105A
     C                   Eval      WInput = PINPUT1                                        BUG15105A
     C                   EndIf                                                             BUG15105A
                                                                                           BUG15105A
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR    - Program exception error routine                   *
      *             Called automatically if a program error occurs,   *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      PRETCD = '*ERROR'
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
