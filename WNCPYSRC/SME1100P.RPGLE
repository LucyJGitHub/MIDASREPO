      *****************************************************************
      * WARNING                                                       *   CFT006
      * =======                                                       *   CFT006
      * THIS COPY MEMBER APPLIES ONLY TO RPG III PROGRAMS.            *   CFT006
      * THIS IMPLIES THAT ALL CHANGES DONE IN THIS SOURCE FILE        *   CFT006
      * SHOULD BE REPORTED IN THE RPG ILE EQUIVALENT ME1100_ILE       *   CFT006
      *                                                               *   CFT006
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SME1100P - ME1100 Present Message Data Structure             *
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 25Jul11               *
      *                 MKFX01             Date 23Jan06               *
      *                 ESL010             Date 22Jul99               *
      *                 PNL002             Date 22Jul04               *
      *                 240929             Date 18Jul06               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 10Feb00               *
      *                 CFT008             Date 06Jan00               *
      *                 CFT006             Date 01Nov99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL009             Date 07JUL99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CRT002             Date 01DEC95               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancement to Midas Plus level.      *
      *             Applied following changes: MKFX01, ESL010, PNL002 *
      *  MKFX01 - Processing of field :24: added.                     *
      *  ESL010 - Processing of Payments from ICBS through Midas      *
      *  PNL002 - Changes to MultiCash interface.                     *
      *  240929 - Field 33B in DS PDATA too small to hold large amt.  *
      *           Amount is truncated when routed from ME1100 data.   *
      *           Change made in MECPYSRC/ME1100_ILE as well.         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG24998 - Bank operation code is missing                    *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT014 - Straight-through processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - FONTIS: dealer's reference field                    *
      *  CFT008 - Funds Transfer/Swift Messages MT102                 *
      *  CFT006 - Funds Transfer/Swift Messages MT101                 *
      *  CGL009 - Midas FONTIS TPP/IAT interface                      *
      *  CRT002 - RBA Interface.                                      *
      *                                                               *
      *****************************************************************
      *
     D PHEAD           DS
      *
      *  Define Parameter - General fields
      *
     D  PHMSGR                 1      8  0
     D  PHPART                 9     11  0
     D  PHMIR                 12     39
     D  PHMOR                 40     67
      *
     D PDATA           DS
      *
      *  Define Parameters for data to be passed back
      *
      *           IMM Control File Fields
      *
     D  PHD                    1    256
     D  PSNDR                  1     20
     D  PMTPY                 21     23
     D  PMPRY                 24     24
     D  PBRCA                 25     27
     D  PNWRK                 28     33
     D  P108                  34     49
     D  P113                  50     53
     D  P115                  54     75
     D  P119                  76     83
      *
      *           Value Date/Ccy/Amount ex Tags 30,31,32,34
      *
     D  PDCA                 257    512
      *
      *           Tag :20: Transaction Reference
      *
     D  P20                  513    768
      *
      *           Tag :21: Related Reference
      *
     D  P21                  769   1024
      *
      *           Tag :50: Ordering Customer
      *
     D  P50                 1025   1280
      *
      *           Tag :52: Ordering Institution    (A,D)
      *
     D  P52                 1281   1536
      *
      *           Tag :53: Senders Correspondent   (A,B,D)
      *
     D  P53                 1537   1792
      *
      *           Tag :54: Receivers Correspondent (A,B,D)
      *
     D  P54                 1793   2048
      *
      *           Tag :56: Intermediary            (A,D)
      *
     D  P56                 2049   2304
      *
      *           Tag :57: Account with Institut'n (A,B,D)
      *
     D  P57                 2305   2560
      *
      *           Tag :58: Beneficiary Institution (A,D)
      *
     D  P58                 2561   2816
      *
      *           Tag :59: Beneficiary Customer
      *
     D  P59                 2817   3072
      *
      *           Tag :70: Details Of Payment
      *
     D  P70                 3073   3328
      *
      *           Tag :71: Details Of Charges      (A)
      *
     D  P71                 3329   3584
      *
      *           Tag :72: Bank To Bank Information
      *
     D  P72                 3585   3840
      *
      *           PSN      Sender Address Information
      *
     D  PSN                 3841   4092
      *                                                                   CRT002
      **  SDCA     Sold Currency Amount                                   CRT002
      *                                                                   CRT002
     D  SDCA                4093   4348                                         CRT002
      *                                                                   CRT002
      **  CASH     Cashier Interface Information                          CRT002
      *                                                                   CRT002
     D  CASH                4349   4604                                         CRT002
      *                                                                   CRT002
      **  PDC2     Settle/Buy Currency Amount                             CRT002
      *                                                                   CRT002
     D  PDC2                4605   4860                                         CRT002
      *                                                                   CFT006
      ** Customer Reference (Header)                                      CFT006
      *                                                                   CFT006
     D  PH21R               4861   4900                                         CFT006
      *                                                                   CFT006
      ** Instructing party                                                CFT006
      *                                                                   CFT006
     D  P50L                4901   4959                                         CFT006
      *                                                                   CFT006
     D  PXX                 4960   5018                                         CFT006
      *                                                                   CFT006
      ** Sending institution (Header)                                     CFT006
      *                                                                   CFT006
     D  PH51A               5019   5077                                         CFT006
      *                                                                   CFT006
      ** Requested Execution Date (Header)                                CFT006
      *                                                                   CFT006
     D  PH30                5078   5107                                         CFT006
      *                                                                   CFT006
      ** Authorisation (Header)                                           CFT006
      *                                                                   CFT006
     D  PH25                5108   5166                                         CFT006
      *                                                                   CFT006
      ** FX Reference                                                     CFT006
      *                                                                   CFT006
     D  P21F                5167   5206                                         CFT006
      *                                                                   CFT006
      ** Regulatory Reporting                                             CFT006
      *                                                                   CFT006
     D  P77B                5207   5335                                         CFT006
      *                                                                   CFT006
      ** Original Currency Amount                                         CFT006
      *                                                                   CFT006
     D**********                           53365377 P33B                  CFT006              240929
     D  FILLER              5336   5377
      *                                                                   CFT006
      * Charges Account                                                   CFT006
      *                                                                   CFT006
     D  P25A                5378   5436                                         CFT006
      *                                                                   CFT006
      ** FX Rate                                                          CFT006
      *                                                                   CFT006
     D  P36                 5437   5472                                         CFT006
      *                                                                   CFT008
      ** Sum Total (Header)                                               CFT008
      *                                                                   CFT008
     D  PH19                5473   5513                                         CFT008
      *                                                                   CFT008
      ** Bank operation code (Header)                                     CFT008
      *                                                                   CFT008
     D  PH23                5514   5553                                         CFT008
      *                                                                   CFT008
      ** Transaction code                                                 CFT008
      *                                                                   CFT008
     D  P26T                5554   5580                                         CFT008
      *                                                                   CFT008
      ** Sender charges                                                   CFT008
      *                                                                   CFT008
     D  P71F                5581   5622                                         CFT008
      *                                                                   CFT008
      ** Receiver charges                                                 CFT008
      *                                                                   CFT008
     D  P71G                5623   5664                                         CFT008
      *                                                                   CFT006
      ** Currency Transaction Amount                                      CFT006
      *                                                                   CFT006
     D  P32B                5665   5706                                         CFT006
      *                                                                   CFT006
      ** Instruction Code                                                 CFT006
      *                                                                   CFT006
     D  P23E                5707   5940                                         CFT006
      *                                                                   CFT006
      ** Tag :20: Transaction Reference (Header)                          CFT006
      *                                                                   CFT006
     D  PH20                5941   6196                                         CFT006
      *                                                                   CFT006
      ** Instructing party (Header)                                       CFT006
      *                                                                   CFT006
     D  PH50L               6197   6255                                         CFT006
      *                                                                   CFT006
      ** Tag :50: Ordering Customer  (Header)                             CFT006
      *                                                                   CFT006
     D  PH50                6256   6511                                         CFT006
      *                                                                   CFT006
      ** Tag :52: Ordering Institution    (A,D) (Header)                  CFT006
      *                                                                   CFT006
     D  PH52                6512   6767                                         CFT006
      *                                                                   CFT008
      ** Transaction code (Header)                                        CFT008
      *                                                                   CFT008
     D  PH26T               6768   6794                                         CFT008
      *                                                                   CFT008
      ** Regulatory Reporting (Header)                                    CFT008
      *                                                                   CFT008
     D  PH77B               6795   6923                                         CFT008
      *                                                                   CFT008
      ** Tag :71: Details Of Charges      (A) (Header)                    CFT008
      *                                                                   CFT008
     D  PH71                6924   7179                                         CFT008
      *                                                                   CFT008
      ** FX Rate (Header)                                                 CFT008
      *                                                                   CFT008
     D  PH36                7180   7215                                         CFT008
      *                                                                   CFT008
      ** Sender charges (Header)                                          CFT008
      *                                                                   CFT008
     D  PH71F               7216   7257                                         CFT008
      *                                                                   CFT008
      ** Receiver charges (Header)                                        CFT008
      *                                                                   CFT008
     D  PH71G               7258   7299                                         CFT008
      *                                                                   CFT008
      ** Tag :53: Senders Correspondent   (A,B,D) (Header)                CFT008
      *                                                                   CFT008
     D  PH53                7300   7555                                         CFT008
      *                                                                   CFT008
      ** Tag :54: Receivers Correspondent (A,B,D) (Header)                CFT008
      *                                                                   CFT008
     D  PH54                7556   7811                                         CFT008
      *                                                                   CFT008
      ** Tag :72: Bank To Bank Information (Header)                       CFT008
      *                                                                   CFT008
     D  PH72                7812   8067                                         CFT008
      *                                                                   CFT008
      ** Value date, currency code, amount (Header)                       CFT008
      *                                                                   CFT008
     D  PH32A               8068   8115                                         CFT008
      *                                                                   CFT014
      ** Third Reimbursement                                              CFT014
      *                                                                   CFT014
     D  P55                 8116   8371                                         CFT014
      *                                                                   CFT014
      ** Bank operation code                                              CFT014
      *                                                                   CFT014
     D**********                           83728399 P23B                             CFT014 BUG24998
     D  P23B                8372   8405                                                           BU
      *                                                                   CFT014
      ** Sender's Charge (Multiple Lines)                                 CFT014
      *                                                                   CFT014
     D**********                           84008633 P71FX                            CFT014 BUG24998
     D  P71FX               8406   8639                                                           BU
      *                                                                                       CSW209
      ** Fin Copy                                                                             CSW209
      *                                                                                       CSW209
     D**********                           86348666 P103                             CSW209 BUG24998
     D  P103                8640   8672                                                           BU
      *                                                                                       CER030
      ** Extended Narrative                                                                   CER030
      *                                                                                       CER030
     D**********                           86348889 PEXN                               CER030 CER059
     D  PEXN                8673   8928
      *
      *                                                                                       240929
      ** Original Currency Amount                                                             240929
      *                                                                                       240929
     D***                                  86738717 P33B                                      240929
     D  P33B                8929   8973
      *                                                                   ESL010
      **  L82      Rate                                                   ESL010
     D*******************                  80008049 L82                   ESL010
     D*******************                  48615116 L82            ESL010 R4UPG
     D  L82                 8050   8098                                         R4UPG
      *                                                                                       PNL002
      ** Rate                                                                                 PNL002
      *                                                                                       PNL002
     D****                                 86618696 P36C                             PNL002 AR856737
     D****                                 87188753 P36C                            AR856737 MD31937
     D  P36C                8974   9009                                                            M
      *                                                                                       PNL002
      ** Destination                                                                          PNL002
      *                                                                                       PNL002
     D****                                 86978952 P51                              PNL002 AR856737
     D****                                 87549009 P51                             AR856737 MD31937
     D  P51                 9010   9265                                                            M
      *                                                                                       PNL002
      ** Charges to debit of account                                                          PNL002
      *                                                                                       PNL002
     D****                                 89538988 P73                              PNL002 AR856737
     D****                                 90109045 P73                             AR856737 MD31937
     D  P73                 9266   9301                                                            M
      *                                                                                       PNL002
      ** Date/Currency/Amount                                                                 PNL002
      *                                                                                       PNL002
     D****                                 89899036 P32A                             PNL002 AR856737
     D  P32A                9302   9349                                                            M
      *                                                                                       PNL002
      ** Central Bank Ref.                                                                    PNL002
      *                                                                                       PNL002
     D****                                 90379071 P80                              PNL002 AR856737
     D****                                 90949128 P80                             AR856737 MD31937
     D  P80                 9350   9384                                                            M
      ** Kind of FX Rate                                                                      MKFX01
      *                                                                                       MKFX01
     D****                                 90729097 P24                              MKFX01 AR856737
     D****                                 91299154 P24                             AR856737 MD31937
     D  P24                 9385   9410                                                            M
      *
      *                  ****************************
      *
     D PDAT2           DS
      *                                                                                       CSW209
      ** Define Parameters for data to be passed back                                         CSW209
      **                                                                                      CSW209
      ** Tag :50: Ordering Customer (Cover)                                                   CSW209
      *                                                                                       CSW209
     D  PB50                   1    256
      *                                                                                       CSW209
      ** Tag :52: Ordering Institution (Cover)                                                CSW209
      *                                                                                       CSW209
     D  PB52                 257    512
      *                                                                                       CSW209
      ** Tag :56: Intermediary Institution (Cover)                                            CSW209
      *                                                                                       CSW209
     D  PB56                 513    768
      *                                                                                       CSW209
      ** Tag :57: Account with Institution (Cover)                                            CSW209
      *                                                                                       CSW209
     D  PB57                 769   1024
      *                                                                                       CSW209
      ** Tag :59: Beneficiary Customer (Cover)                                                CSW209
      *                                                                                       CSW209
     D  PB59                1025   1280
      *                                                                                       CSW209
      ** Tag :70: Remittance Information (Cover)                                              CSW209
      *                                                                                       CSW209
     D  PB70                1281   1536
      *                                                                                       CSW209
      ** Tag :72: Sender to Receiver Information (Cover)                                      CSW209
      *                                                                                       CSW209
     D  PB72                1537   1792
      *                                                                                       CSW209
      ** Instructed Currency/Amount (Cover)                                                   CSW209
      *                                                                                       CSW209
     D  PB33B               1793   1837
      *                                                                                       CSW209
     D DSTRAN          DS
      *
      *  Translation Data structure (multiple occurrences)
      *  Ocurrence No. is shown in table
      *
      *  General Fields
     D**********                              1  24 TRBEG                              CFT014 CGL029
     D  TRBEG                  1     30
     D  TRTAG                  1      5
     D  TRTYPE                 6      6
     D**********                              7  24 TRCODE                                    CGL029
     D  TRCODE                 7     30
     D  TRP103                31     33
      *
      *  Format 1 - transaction reference
      *  will OCUR for SWIFT Tag 20 , 21 , 71a
      *
     D**********                             25  40 TTREF                                     CGL029
     D  TTREF                 31     46
      *
      *  Format 2 - value date/ccy/amount
      *  will OCUR for SWIFT Tag 30 , 32a, 32b
      *
     D**********                             25  48 TVDCA                                     CGL029
     D**********                             25  300TVVDAT                                    CGL029
     D**********                             31  33 TVCCY                                     CGL029
     D**********                             34  48 TVAMT                                     CGL029
     D  TVDCA                 31     54
     D  TVVDAT                31     36  0
     D  TVCCY                 37     39
     D  TVAMT                 40     54
      *
      *  Format 3 - multiple lines
      *  will OCUR for SWIFT Tag 50 , 52 , 53 , 54 , 56, 57
      *                          58 , 59 , 70 , 72
      *
     D**********                             25 234 TMLIN                                     CGL029
     D**********                             25  59 TMLIN1                                    CGL029
     D**********                             60  94 TMLIN2                                    CGL029
     D**********                             95 129 TMLIN3                                    CGL029
     D**********                            130 164 TMLIN4                                    CGL029
     D**********                            165 199 TMLIN5                                    CGL029
     D**********                            200 234 TMLIN6                                    CGL029
     D  TMLIN                 31    240
     D  TMLIN1                31     65
     D  TMLIN2                66    100
     D  TMLIN3               101    135
     D  TMLIN4               136    170
     D  TMLIN5               171    205
     D  TMLIN6               206    240
      *
      **  Format 4 - for CUSER, CTRAN, CSPCD, CPOST, CHOST                CRT002
      **  will OCUR for CASH subfield                                     CRT002
      *                                                                   CRT002
     D**********                             25  52 TUSER                              CRT002 CGL029
     D**********                             53  58 TTRAN                              CRT002 CGL029
     D**********                             59  64 TSPCD                              CRT002 CGL029
     D**********                             65  98 TPOST                              CRT002 CGL029
     D**********                             99 154 THOST                              CRT002 CGL029
     D**********                            155 164 TWKID                              CRT002 CGL029
     D  TUSER                 31     58
     D  TTRAN                 59     64
     D  TSPCD                 65     70
     D  TPOST                 71    104
     D  THOST                105    160
     D  TWKID                161    170
      *                                                                   CFT006
      *  Format 5 - ccy/amount                                            CFT006
      *  will OCUR for SWIFT MT101 MT102                                  CFT006
      *                                                                   CFT006
     D**********                             25  42 TTCA                               CFT006 CGL029
     D**********                             25  27 TTCCY                              CFT006 CGL029
     D**********                             28  42 TTAMT                              CFT006 CGL029
     D  TTCA                  31     48
     D  TTCCY                 31     33
     D  TTAMT                 34     48
      *                                                                   CFT006
      *  Format 6 - ccy/amount                                            CFT006
      *  will OCUR for SWIFT MT101 MT102                                  CFT006
      *                                                                   CFT006
     D**********                             25  41 TSA                                CFT006 CGL029
     D**********                             25  41 TSAMT                              CFT006 CGL029
     D  TSA                   31     47
     D  TSAMT                 31     47
      *                                                                   CRT002
     D DSFONT          DS                                                       CGL009
      *                                                                   CGL009
      *  Translation Data structure (multiple occurrences)                CGL009
      *  Ocurrence No. is shown in table                                  CGL009
      *                                                                   CGL009
      *  General Fields                                                   CGL009
     D  FNTAG                  1      5                                         CGL009
     D  FNTYPE                 6      6                                         CGL009
      *  Format 1 - multiple lines                                        CGL009
      *  will OCUR for FONTIS Tag 72                                      CGL009
      ***Special*case*for*line*1*(65 chars)*/OCMT/*/RATE/*/ORIG**   CGL009175479
      *  Special case for line 1 /OCMT/ /RATE/ /ORIG/ /REF/               175479
     D****************************************7 246 FONT72          CGL009175479
     D****************************************7  71 FN72L1          CGL009175479
     D***************************************72 106 FN72L2          CGL009175479
     D**************************************107 141 FN72L3          CGL009175479
     D**************************************142 176 FN72L4          CGL009175479
     D**************************************177 211 FN72L5          CGL009175479
     D**************************************212 246 FN72L6          CGL009175479
     D  FONT72                 7    256                                         175479
     D  FN72L1                 7    106                                         175479
     D  FN72L2               107    141                                         175479
     D  FN72L3               142    176                                         175479
     D  FN72L4               177    211                                         175479
     D  FN72L5               212    246                                         175479
     D  FN72L6               247    256                                         175479
      *                                                                   CGL009
      *****************************************************************
      * End of /COPY SME1100P                                         *
      *****************************************************************
