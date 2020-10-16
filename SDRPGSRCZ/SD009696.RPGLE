     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*XBI****OVRDBF*FILE(FFDCUSTPD)*TOFILE(QADSPFFD)***********************                     MD026264
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD History of Customer Information')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009696 - Midas SD History of Customer Information          *
      *                                                               *
      *  Function:  This program logs the customer details            *
      *             in history of customer information                *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD056982           Date 12Oct20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD050212           Date 02Apr18               *
      *                 MD041578           Date 23Sep16               *
      *                 MD041407           Date 19Sep16               *
      *                 MD041389           Date 19Sep16               *
      *                 MD041066           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157             Date 17Aug15               *
      *                 MD046248           Date 27Oct17               *
      *                 MD030161A          Date 16Sep14               *
      *                 CER071             Date 01Aug16               *
      *                 MD029850           Date 30Sep14               *
      *                 MD027548           Date 19Jun14               *
      *                 MD027577A          Date 17Jun14               *
      *                 MD027513           Date 17Jun14               *
      *                 MD027354           Date 06Jun14               *
      *                 MD027310           Date 06Jun14               *
      *                 MD027309           Date 06Jun14               *
      *                 MD027295           Date 06Jun14               *
      *                 MD026957A          Date 29May14               *
      *                 MD026854           Date 29May14               *
      *                 MD026666           Date 22May14               *
      *                 CGL132             Date 01May13               *
      *                 MD026148           Date 11Apr14               *
      *                 MD026193           Date 07Apr14               *
      *                 MD026264           Date 08Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056982 - Serious Midas Error upon authorize in CUSD, use   *
      *             file SDCRSHL0 for update                          *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD050212 - Replication processing for SDCUSTXC (Recompile)   *
      *  MD041578 - Last Action User is not displayed in the          *
      *             Description Header generated when deleting        *
      *             Additional Customer Details of the Customer.      *
      *  MD041407 - Incorrect User indicated in the user field        *
      *  MD041389 - Additional Miscellaneous Change Entry with no     *
      *             details appear after every amendments made in     *
      *             both Customer Details and Additional Customer     *
      *             Details when CGL157 is off.                       *
      *  MD041066 - Additional Miscellaneous Change Entry with no     *
      *             details appear after every amendments made in     *
      *             both Customer Details and Additional Customer     *
      *             Details.                                          *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030161A - SDC009697 COB component run too long             *
      *              Applied fix MD027315, MD027355                   *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  MD029850 - SDC009697 COB component run too long              *
      *             Applied fix MD028974, MD028321, MD028949 and      *
      *             MD029018                                          *
      *  MD027548 - Inserted Authority Holder Details is not          *
      *             Reflected in Customer History                     *
      *  MD027577A - History of customer information purge issue      *
      *  MD027513 - FATCA info complete flag is blanks                *
      *  MD027354 - Incorrect description of change when overriding   *
      *             US Account Authority Holder                       *
      *  MD027310 - History record for deletion of JACM members is    *
      *             not populated                                     *
      *  MD027309 - Insertion of customer is not logged in history    *
      *             of customer information                           *
      *  MD027295 - SDC009697 COB component run too long              *
      *  MD026957A - History of customer information issues           *
      *  MD026854 - Alternative country of citizenship is missing in  *
      *             history of customer information                   *
      *  MD026666 - Incorrect details reflected in history of         *
      *             customer information                              *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD026148 - Serious midas error appears upon confirm          *
      *             authorise                                         *
      *  MD026193 - History of cust information is not updated        *
      *             (Recompile)                                       *
      *  MD026264 - Serious midas error when complete flag = 'Y'      *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************

     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)

     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)

     FSDFTCSL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL132
                                                                                              CGL132
     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)                                       CGL177
                                                                                              CGL177
     FSDCRSDL2  IF   E           K DISK    INFSR(*PSSR)                                       CGL177
                                                                                              CGL177
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)

     F***SDCUAHL0  IF   E           K DISK    INFSR(*PSSR)                                  MD026148
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026148

     FSDCUSXL1  IF   E           K DISK    INFSR(*PSSR)                                     MD026854
                                                                                            MD026854
     FSDHCIDL0  IF   E           K DISK    INFSR(*PSSR)                                     MD027295
     F                                     RENAME(SDHCIDD0:SDHCIDD1)                        MD027295
     F                                     PREFIX(AA)                                       MD027295
                                                                                            MD027295
      ** History of Customer Info File
     FSDHCINPD  O    E             DISK

      ** History of Customer Info Details File
     FSDHCIDPD  O    E             DISK
                                                                                            MD027295
     FSDHCILPD  O    E             DISK                                                     MD027295

      ** =======
      ** D-specs
      ** =======

     D WWFLDB          S              5S 0 DIM(20)
     D WWIBO           S              5S 0 DIM(20)
     D WWFLDT          S              1    DIM(20)
     D WWFLDD          S              5S 0 DIM(20)
     D WWFTXT          S             50    DIM(20)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D WDTMST          DS
     D  WWYr                   1      4
     D  WWMn                   5      6
     D  WWDy                   7      8

      /COPY ZACPYSRC,PSDS

      /COPY ZACPYSRC,STD_D_SPEC

     D WWBEIMC         DS
     D  WWBEIMP                1      3P 0

     D WWAFIMC         DS
     D  WWAFIMP                1      3P 0

     D WTTMST          DS
     D  WWHH                   1      2
     D  WWMM                   3      4
     D  WWSS                   5      6

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D SDFTCS        E DS                  EXTNAME(SDFTCSPD)                                  CGL132
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)                                  CGL177
     D SDCRSD        E DS                  EXTNAME(SDCRSDPD)                                  CGL177
     D SDJACC        E DS                  EXTNAME(SDJACCPD)
     D SDCUAH        E DS                  EXTNAME(SDCUAHPD)
     D SDFTCSX       E DS                  EXTNAME(SDFTCSPD)                                  CGL132
     D                                     PREFIX(X)                                          CGL132
     D SDFTCSY       E DS                  EXTNAME(SDFTCSPD)                                  CGL132
     D                                     PREFIX(Y)                                          CGL132
     D SDCRSHX       E DS                  EXTNAME(SDCRSHPD)                                  CGL177
     D                                     PREFIX(X)                                          CGL177
     D SDCRSHY       E DS                  EXTNAME(SDCRSHPD)                                  CGL177
     D                                     PREFIX(Y)                                          CGL177
     D SDCRSDX       E DS                  EXTNAME(SDCRSDPD)                                  CGL177
     D                                     PREFIX(X)                                          CGL177
     D SDCRSDY       E DS                  EXTNAME(SDCRSDPD)                                  CGL177
     D                                     PREFIX(Y)                                          CGL177
      ** External data structure for SARD                                                     CGL177
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL177
     D SDCUXC        E DS                  EXTNAME(SDCUSTXC)                                MD026854
                                                                                            MD026666
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                   MD026666
                                                                                            MD026666
     D  PFieldsDesc    DS                                                                   MD026666
     D  PFieldName                   10A   dim( FieldArrSize )                              MD026666
     D  PFieldPosn                   10I 0 dim( FieldArrSize )                              MD026666
     D  PFieldLen                    10I 0 dim( FieldArrSize )                              MD026666
     D  PFieldDigt                   10I 0 dim( FieldArrSize )                              MD026666
     D  PFieldType                    1A   dim( FieldArrSize )                              MD026666
     D  PFieldText                   30A   dim( FieldArrSize )                              MD026666
     D  FieldArrSize   C                   1200                                             MD026666
     D  NFieldPosn     S             10I 0 dim( FieldArrSize )                              MD026666
     D  NFieldLen      S             10I 0 dim( FieldArrSize )                              MD026666
                                                                                            MD026666
     D  SdcustpdArr    DS                                                                   MD026666
     D  SdcustName                   10A   dim( FieldArrSize )                              MD026666
     D  SdcustPosnA                  10I 0 dim( FieldArrSize )                              MD026666
     D  SdcustLenA                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdcustDigt                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdcustType                    1A   dim( FieldArrSize )                              MD026666
     D  SdcustText                   30A   dim( FieldArrSize )                              MD026666
     D  SdcustPosnB    S             10I 0 dim( FieldArrSize )                              MD026666
     D  SdcustLenB     S             10I 0 dim( FieldArrSize )                              MD026666
                                                                                            MD026666
     D  SdacuspdArr    DS                                                                   MD026666
     D  SdacusName                   10A   dim( FieldArrSize )                              MD026666
     D  SdacusPosnA                  10I 0 dim( FieldArrSize )                              MD026666
     D  SdacusLenA                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdacusDigt                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdacusType                    1A   dim( FieldArrSize )                              MD026666
     D  SdacusText                   30A   dim( FieldArrSize )                              MD026666
     D  SdacusPosnB    S             10I 0 dim( FieldArrSize )                              MD026666
     D  SdacusLenB     S             10I 0 dim( FieldArrSize )                              MD026666
                                                                                            MD026666
     D  SdftcspdArr    DS                                                                   MD026666
     D  SdftcsName                   10A   dim( FieldArrSize )                              MD026666
     D  SdftcsPosnA                  10I 0 dim( FieldArrSize )                              MD026666
     D  SdftcsLenA                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdftcsDigt                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdftcsType                    1A   dim( FieldArrSize )                              MD026666
     D  SdftcsText                   30A   dim( FieldArrSize )                              MD026666
     D  SdftcsPosnB    S             10I 0 dim( FieldArrSize )                              MD026666
     D  SdftcsLenB     S             10I 0 dim( FieldArrSize )                              MD026666
                                                                                            MD026666
     D  SdjaccpdArr    DS                                                                   MD026666
     D  SdjaccName                   10A   dim( FieldArrSize )                              MD026666
     D  SdjaccPosnA                  10I 0 dim( FieldArrSize )                              MD026666
     D  SdjaccLenA                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdjaccDigt                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdjaccType                    1A   dim( FieldArrSize )                              MD026666
     D  SdjaccText                   30A   dim( FieldArrSize )                              MD026666
     D  SdjaccPosnB    S             10I 0 dim( FieldArrSize )                              MD026666
     D  SdjaccLenB     S             10I 0 dim( FieldArrSize )                              MD026666
                                                                                            MD026666
     D  SdcuahpdArr    DS                                                                   MD026666
     D  SdcuahName                   10A   dim( FieldArrSize )                              MD026666
     D  SdcuahPosnA                  10I 0 dim( FieldArrSize )                              MD026666
     D  SdcuahLenA                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdcuahDigt                   10I 0 dim( FieldArrSize )                              MD026666
     D  SdcuahType                    1A   dim( FieldArrSize )                              MD026666
     D  SdcuahText                   30A   dim( FieldArrSize )                              MD026666
     D  SdcuahPosnB    S             10I 0 dim( FieldArrSize )                              MD026666
     D  SdcuahLenB     S             10I 0 dim( FieldArrSize )                              MD026666
                                                                                            MD026666
     D  SdcuxcpdArr    DS                                                                   MD026854
     D  SdcuxcName                   10A   dim( FieldArrSize )                              MD026854
     D  SdcuxcPosnA                  10I 0 dim( FieldArrSize )                              MD026854
     D  SdcuxcLenA                   10I 0 dim( FieldArrSize )                              MD026854
     D  SdcuxcDigt                   10I 0 dim( FieldArrSize )                              MD026854
     D  SdcuxcType                    1A   dim( FieldArrSize )                              MD026854
     D  SdcuxcText                   30A   dim( FieldArrSize )                              MD026854
     D  SdcuxcPosnB    S             10I 0 dim( FieldArrSize )                              MD026854
     D  SdcuxcLenB     S             10I 0 dim( FieldArrSize )                              MD026854
                                                                                            MD026854
     D  SdcrshpdArr    DS                                                                     CGL177
     D  SdcrshName                   10A   dim( FieldArrSize )                                CGL177
     D  SdcrshPosnA                  10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrshLenA                   10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrshDigt                   10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrshType                    1A   dim( FieldArrSize )                                CGL177
     D  SdcrshText                   30A   dim( FieldArrSize )                                CGL177
     D  SdcrshPosnB    S             10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrshLenB     S             10I 0 dim( FieldArrSize )                                CGL177
                                                                                              CGL177
     D  SdcrsdpdArr    DS                                                                     CGL177
     D  SdcrsdName                   10A   dim( FieldArrSize )                                CGL177
     D  SdcrsdPosnA                  10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrsdLenA                   10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrsdDigt                   10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrsdType                    1A   dim( FieldArrSize )                                CGL177
     D  SdcrsdText                   30A   dim( FieldArrSize )                                CGL177
     D  SdcrsdPosnB    S             10I 0 dim( FieldArrSize )                                CGL177
     D  SdcrsdLenB     S             10I 0 dim( FieldArrSize )                                CGL177
                                                                                              CGL177
     D PSard           S              6A                                                      CGL177
     D A               S              4S 0                                                    CGL177
     D B               S              4S 0                                                    CGL177
     D WDCRS           S              1A                                                      CGL177
     D CGL157          S              1A                                                      CGL177
     D WCRS8           S              1A                                                      CGL177
     D WCRS10          S              1A                                                      CGL177
     D WCHK1           S              1A                                                      CGL177
     D WCHK2           S              1A                                                      CGL177
     D WCHK3           S              1A                                                    MD041066
     D PFileNames      DS                                                                   MD026666
     D  FileNameArr                  10A   dim(FileArrSize)                                 MD026666
     D  FileArrSize    C                   10                                               MD026666
     D PFieldsNum      S              5I 0                                                  MD026666
     D SdcustFNum      S              5I 0                                                  MD026666
     D SdacusFNum      S              5I 0                                                  MD026666
     D SdftcsFNum      S              5I 0                                                  MD026666
     D SdjaccFNum      S              5I 0                                                  MD026666
     D SdcuahFNum      S              5I 0                                                  MD026666
     D SdcuxcFNum      S              5I 0                                                  MD026854
     D SdcrshFNum      S              5I 0                                                    CGL177
     D SdcrsdFNum      S              5I 0                                                    CGL177
     D PFileName       S             10A                                                    MD026666
     D Idx             S              5I 0                                                  MD026666
     D Index           S              5I 0                                                  MD026666
     D Wpos            S              5S 0                                                  MD026666
     D WImage          S           5000A                                                    MD026666
     D KCustRefNum     S             10A                                                   MD030161A
     D CustRefNum      S             10A                                                   MD030161A
     D PackedToChar    DS             6                                                     MD026666
     D WChar2                         2A   overlay(PackedToChar)                            MD026666
     D WPacked3                       3P 0 overlay(PackedToChar)                            MD026666
     D WChar3                         3A   overlay(PackedToChar)                            MD026666
     D WPacked5                       5P 0 overlay(PackedToChar)                            MD026666
     D WChar4                         4A   overlay(PackedToChar)                            MD026666
     D WPacked6                       6P 0 overlay(PackedToChar)                            MD026666
     D WChar6                         6A   overlay(PackedToChar)                            MD026666
     D WPacked9                       9P 0 overlay(PackedToChar)                            MD026666
                                                                                            MD026666

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D***PDESC           S             60    DIM(8) CTDATA PERRCD(1)                          CGL157
     D PDESC           S             60    DIM(11) CTDATA PERRCD(1)                           CGL157
      ** Override Database Table                                                            MD056982
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)                          MD056982
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)                          MD056982

     D RetCode         S              7A
     D PFileNam        S             10A
     D PCUST           S              6A
     D PBefCUST        S           5000A
     D PAftCUST        S           5000A
     D PBefACUS        S           5000A
     D PAftACUS        S           5000A
     D PBefFTCS        S           5000A                                                      CGL132
     D PAftFTCS        S           5000A                                                      CGL132
     D PBefCRSH        S           5000A                                                      CGL177
     D PAftCRSH        S           5000A                                                      CGL177
     D PBefCRSD        S           5000A                                                      CGL177
     D PAftCRSD        S           5000A                                                      CGL177
     D PBefJACC        S           5000A
     D PAftJACC        S           5000A
     D PBefCUAH        S           5000A
     D PAftCUAH        S           5000A
     D PBefCUXC        S           5000A                                                    MD026854
     D PAftCUXC        S           5000A                                                    MD026854
     D Pos             S              4P 0
     D WFLDLN          S              3P 0
     D X               S              3P 0
     D Y               S              2P 0
     D Z               S              2P 0
     D WWTMST          S             26A
     D WKTMST          S             26Z
     D PDateIn         S              8S 0
     D PMDNO           S              5P 0
     D WWBEIM          S              5A
     D WWAFIM          S              5A
     D WACLAS          S              5A
     D WBCLAS          S              5A
     D PACRV           S              1A
     D PELEC           S              1A                                                      CGL132
     D PFUNC           S             21A
     D WPRIOR          S              1S 0
     D WSJACC          S             17A
     D WPRIOR8         S              1A                                                      CGL132
     D WCJACC          S             17A
     D WSCUAH          S             18A
     D WCCUAH          S             18A
     D KCUST           S              6A                                                    MD027295
     D KFILE           S             10A                                                    MD027295
     D WOTHER1         S              1A                                                    MD027295
     D WFAINFO         S              1A                                                    MD027295
                                                                                            MD027295
     D BefImage        S           5000A                                                    MD027295
     D AftImage        S           5000A                                                    MD027295
     D WWIMAG          S            256A                                                    MD027295
     D WWIMAG2         S            256A                                                    MD027295
     D W               S              3S 0                                                  MD027295
     D WWREFN          S              6A                                                    MD027295
     D WSTORE1         S             10A                                                    MD027295
     D WSTORE2         S             10A                                                    MD027295
     D WCNT            S              2S 0                                                  MD027295
     D WWJARC          S              1A                                                    MD027295
     D WBJACC          S             34A                                                    MD027295
     D WAJACC          S             34A                                                    MD027295
     D WWLLSR          S             10A                                                    MD028949
     D WMsgLen         S             15P 5 INZ(50)                                          MD056982

      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A

      ** Parameter for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A

      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EVAL      WCHK3 = 'N'                                              MD041066
     C                   EVAL      YFAINFC = *BLANKS                                        MD027513
     C                   EVAL      YCRINFO = *BLANKS                                          CGL177
     C                   EVAL      WWJARC = 'N'                                             MD027295
     C                   EVAL      WBJACC = PBefJACC                                        MD027295
     C                   EVAL      WAJACC = PAftJACC                                        MD027295
     C                   EVAL      CustRefNum = *BLANKS                                    MD030161A
     C                   CALL      'QCMDEXC'                                                MD056982
     C                   PARM                    ##OV1                                      MD056982
     C                   PARM                    WMsgLen                                    MD056982
     C                   IF        PBefCUST = *BLANKS AND                                   MD027295
     C                             PAftCUST = *BLANKS AND                                   MD027295
     C                             PBefACUS = *BLANKS AND                                   MD027295
     C                             PAftACUS = *BLANKS AND                                   MD027295
     C                             PBefFTCS = *BLANKS AND                                   MD027295
     C                             PAftFTCS = *BLANKS AND                                   MD027295
     C                             PBefCRSH = *BLANKS AND                                     CGL177
     C                             PAftCRSH = *BLANKS AND                                     CGL177
     C                             PBefCRSD = *BLANKS AND                                     CGL177
     C                             PAftCRSD = *BLANKS AND                                     CGL177
     C                             WBJACC = WAJACC AND                                      MD027295
     C                             PBefCUAH = *BLANKS AND                                   MD027295
     C                             PAftCUAH = *BLANKS AND                                   MD027295
     C                             PBefCUXC = *BLANKS AND                                   MD027295
     C                             PAftCUXC = *BLANKS                                       MD027295
     C                   EVAL      WWJARC = 'Y'                                             MD027295
     C                   ENDIF                                                              MD027295
     C                   EVAL      WPRIOR8 = 'N'                                              CGL132
     C                   EVAL      WOTHER1 = 'N'                                            MD027295
     C                   EVAL      WFAINFO = 'N'                                            MD027295
     C                   EVAL      Y = 1
     C                   IF        PAftACUS <> *Blanks                                        CGL177
     C                   EVAL      WWTMST = %SUBST(PAftACUS:552:26)                           CGL177
     C                   MOVE      WWTMST        WKTMST                                       CGL177
     C                   ELSE                                                                 CGL177
     C                   IF        PAftCUST <> *Blanks                                        CGL177
     C                   EVAL      WWTMST = %SUBST(PAftCUST:870:26)                           CGL177
     C                   MOVE      WWTMST        WKTMST                                       CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        WWTMST = *BLANKS                                           CGL177
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WKTMST
     C                   ENDIF                                                                CGL177
     C                   MOVE      WKTMST        HCTMST

     C                   EVAL      WWTMST = *BLANKS
     C                   MOVE      WKTMST        WWTMST
     C                   EVAL      WWHH = %SUBST(WWTMST:12:2)
     C                   EVAL      WWMM = %SUBST(WWTMST:15:2)
     C                   EVAL      WWSS = %SUBST(WWTMST:18:2)

     C                   EVAL      HCINFC = ' '                                             MD027295
     C                   IF        PAftFTCS <> *BLANKS                                      MD027295
     C**********         MOVE      PAftFTCS      SDFTCSY                           MD027295 MD028321
     C                   MOVEL     PAftFTCS      SDFTCSY                                    MD028321
     C                   EVAL      HCINFC = YFAINFC                                         MD027295
     C                   ENDIF                                                              MD027295
     C                   EVAL      HCCUST = PCust
     C                   EVAL      HCCDAT = BJRDNB
     C                   MOVE      WTTMST        HCCTIM
     C**********         EVAL      HCIEXR = 'N'                                             MD028321
     C**********         EVAL      HCLUSR = PSUSER                                          MD026666
     C**********         EVAL      HCLUSR = USRID                                  MD026666 MD028949

     C**********         IF        PBefCUST = *BLANKS AND                                   MD027295
     C**********                   PAftCUST <> *BLANKS OR                                   MD027295
     C**********                   PBefACUS = *BLANKS AND                                   MD027295
     C**********                   PAftACUS <> *BLANKS OR                                   MD027295
     C**********                   PBefJACC = *BLANKS AND                                   MD027295
     C**********                   PAftJACC <> *BLANKS OR                                   MD027295
     C**********                   PBefCUAH = *BLANKS AND                                   MD027295
     C**********                   PAftCUAH <> *BLANKS                                      MD027295
     C**********                   OR                                              MD026854 MD027295
     C**********                   PBefCUXC = *BLANKS AND                          MD026854 MD027295
     C**********                   PAftCUXC <> *BLANKS                             MD026854 MD027295
     C                   IF        PBefCUST = *BLANKS AND                                   MD027295
     C**********                   PAftCUST <> *BLANKS                             MD027295 MD027310
     C                             PAftCUST <> *BLANKS OR                                   MD027310
     C                             PBefJACC = *BLANKS AND                                   MD027310
     C                             PAftJACC <> *BLANKS OR                                   MD027310
     C                             PBefCUAH = *BLANKS AND                                   MD027310
     C                             PAftCUAH <> *BLANKS                                      MD027310
     C                   EVAL      HCACTN = 'I'
     C**********         IF        PBefCUST = *BLANKS AND                                   MD027295
     C**********                   PAftCUST <> *BLANKS                                      MD027295
     C**********         CLEAR                   SDCUST                                     MD027295
     C**********         MOVEL     SDCUST        PBefCUST                                   MD027295
     C**********         ENDIF                                                              MD027295
     C                   ELSE

     C                   IF        PBefCUST <> *BLANKS AND
     C                             PAftCUST = *BLANKS OR
     C                             PBefACUS <> *BLANKS AND
     C                             PAftACUS = *BLANKS OR
     C                             PBefJACC <> *BLANKS AND
     C                             PAftJACC = *BLANKS OR
     C                             PBefCRSH <> *BLANKS AND                                    CGL177
     C                             PAftCRSH = *BLANKS OR                                      CGL177
     C                             PBefCRSD <> *BLANKS AND                                    CGL177
     C                             PAftCRSD = *BLANKS OR                                      CGL177
     C                             PBefCUAH <> *BLANKS AND
     C                             PAftCUAH = *BLANKS
     C                             OR                                                       MD026854
     C                             PBefCUXC <> *BLANKS AND                                  MD026854
     C                             PAftCUXC = *BLANKS                                       MD026854
     C                   EVAL      HCACTN = 'D'
     C                   ELSE
     C                   EVAL      HCACTN = 'A'
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      HCDESC = PDESC(7)

     C                   IF        PBefJACC <> *BLANKS OR
     C                             PAftJACC <> *BLANKS
     C                   EVAL      HCDESC = PDESC(6)
     C                   IF        PBefJACC <> *BLANKS                                     MD030161A
     C                   EVAL      CustRefNum = %SUBST(PBefJACC:7:6)                       MD030161A
     C                   ELSE                                                              MD030161A
     C                   EVAL      CustRefNum = %SUBST(PAftJACC:7:6)                       MD030161A
     C                   ENDIF                                                             MD030161A
     C                   ENDIF

     C                   IF        PACRV = 'Y'
     C                   EVAL      HCDESC = PDESC(5)
     C                   ENDIF

     C                   IF        PELEC = 'Y'                                                CGL132
     C                             AND PAftCRSH = *Blanks                                     CGL177
     C                             AND PAftCRSD = *Blanks                                     CGL177
     C                   EVAL      HCDESC = PDESC(4)                                          CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PBefFTCS <> *BLANKS AND                                    CGL132
     C                             PAftFTCS <> *BLANKS                                        CGL132
                                                                                              CGL132
     C                   EVAL      SDFTCSX = PBefFTCS                                         CGL132
     C                   EVAL      SDFTCSY = PAftFTCS                                         CGL132
     C                   IF        XFACLAC <> YFACLAC                                         CGL132
     C                             AND XFACLAC <> *Blanks                                  MD030161A
     C                   EVAL      WPRIOR = 1                                                 CGL132
     C                   EVAL      WBCLAS = XFACLAC                                           CGL132
     C                   EVAL      WACLAS = YFACLAC                                           CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        ( XFACISV <> YFACISV                                       CGL132
     C                               or XFATXSV <> YFATXSV                                    CGL132
     C                               or XFACDSV <> YFACDSV                                    CGL132
     C                               or XFATESV <> YFATESV                                    CGL132
     C                               or XFAGCSV <> YFAGCSV                                    CGL132
     C                               or XFACBSV <> YFACBSV                                    CGL132
     C                               or XFAJASV <> YFAJASV                                    CGL132
     C                               or XFAHMSV <> YFAHMSV                                    CGL132
     C                               or XFARPSV <> YFARPSV                                    CGL132
     C                               or XFAIDSV <> YFAIDSV                                    CGL132
     C                               or XFAMCSV <> YFAMCSV                                    CGL132
     C**********                     or XFAAUSV <> YFAAUSV                         MD027354 MD028795
     C                             )                                                          CGL132
     C                               and WPRIOR <> 1                                          CGL132
     C                   EVAL      WPRIOR = 2                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        ( XFACIOV <> YFACIOV                                       CGL132
     C                               or XFATXOV <> YFATXOV                                    CGL132
     C                               or XFACDOV <> YFACDOV                                    CGL132
     C                               or XFATEOV <> YFATEOV                                    CGL132
     C                               or XFAGCOV <> YFAGCOV                                    CGL132
     C                               or XFACBOV <> YFACBOV                                    CGL132
     C                               or XFAJAOV <> YFAJAOV                                    CGL132
     C                               or XFAHMOV <> YFAHMOV                                    CGL132
     C                               or XFARPOV <> YFARPOV                                    CGL132
     C                               or XFAIDOV <> YFAIDOV                                    CGL132
     C                               or XFAMCOV <> YFAMCOV                                    CGL132
     C                               or XFAAUOV <> YFAAUOV                                  MD027354
     C                             )                                                          CGL132
     C                             and WPRIOR <> 1                                            CGL132
     C                             and WPRIOR <> 2                                            CGL132
     C                   EVAL      WPRIOR = 3                                                 CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        WPRIOR = 1                                                 CGL132
     C                   EVAL      HCDESC = PDESC(1)                                          CGL132
     C                   EVAL      %SUBST(HCDESC:30:5) = WBCLAS                               CGL132
     C                   EVAL      %SUBST(HCDESC:41:5) = WACLAS                               CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        WPRIOR = 2                                                 CGL132
     C                   EVAL      HCDESC = PDESC(2)                                          CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        WPRIOR = 3                                                 CGL132
     C                   EVAL      HCDESC = PDESC(3)                                          CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   IF        PBefCRSH <> *BLANKS AND                                    CGL177
     C                             PAftCRSH <> *BLANKS                                        CGL177
                                                                                              CGL177
     C                   EVAL      SDCRSHX = PBefCRSH                                         CGL177
     C                   EVAL      SDCRSHY = PAftCRSH                                         CGL177
                                                                                              CGL177
     C                   IF        ( XFACISV <> YFACISV                                       CGL177
     C                               or XFATXSV <> YFATXSV                                    CGL177
     C                               or XFACDSV <> YFACDSV                                    CGL177
     C                               or XFATESV <> YFATESV                                    CGL177
     C                               or XFAGCSV <> YFAGCSV                                    CGL177
     C                               or XFACBSV <> YFACBSV                                    CGL177
     C                               or XFAJASV <> YFAJASV                                    CGL177
     C                               or XFAHMSV <> YFAHMSV                                    CGL177
     C                               or XFARPSV <> YFARPSV                                    CGL177
     C                               or XFAIDSV <> YFAIDSV                                    CGL177
     C                               or XFAMCSV <> YFAMCSV                                    CGL177
     C                             )                                                          CGL177
     C                               and WPRIOR <> 1                                          CGL177
     C                   EVAL      WPRIOR = 2                                                 CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        WPRIOR = 1                                                 CGL177
     C                   EVAL      HCDESC = PDESC(1)                                          CGL177
     C                   EVAL      %SUBST(HCDESC:30:5) = WBCLAS                               CGL177
     C                   EVAL      %SUBST(HCDESC:41:5) = WACLAS                               CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        WPRIOR = 2                                                 CGL177
     C                   EVAL      HCDESC = PDESC(2)                                          CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        WPRIOR = 3                                                 CGL177
     C                   EVAL      HCDESC = PDESC(3)                                          CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      HCINDT = BJRDNB

     C**********         WRITE     SDHCIND0                                                 MD027295

     C                   EVAL      HDCUST = HCCUST
     C                   EVAL      HDCDAT = HCCDAT
     C                   EVAL      HDCTIM = HCCTIM
     C                   EVAL      HDTMST = HCTMST
     C                   EVAL      HDINDT = BJRDNB

     C                   IF        PBefCUST = *BLANKS AND
     C                             PAftCUST = *BLANKS
     C     PCUST         CHAIN     SDCUSTL1                           9090
     C                   MOVEL     SDCUST        PBefCUST
     C                   MOVEL     SDCUST        PAftCUST
     C                   ENDIF

     C                   IF        PBefACUS = *BLANKS AND
     C                             PAftACUS = *BLANKS
     C     PCUST         CHAIN     SDACUSL1                           9090
     C                   IF        *IN90 = *OFF                                             MD026854
     C                   MOVEL     SDACUS        PBefACUS
     C                   MOVEL     SDACUS        PAftACUS
     C                   ENDIF                                                              MD026854
     C                   ENDIF
                                                                                              CGL132
     C                   IF        PBefFTCS = *BLANKS AND                                     CGL132
     C                             PAftFTCS = *BLANKS                                         CGL132
     C     PCUST         CHAIN     SDFTCSL1                           9090                    CGL132
     C                   IF        *IN90 = *OFF                                             MD026854
     C                   MOVEL     SDFTCS        PBefFTCS                                     CGL132
     C                   MOVEL     SDFTCS        PAftFTCS                                     CGL132
     C                   ENDIF                                                              MD026854
     C                   ENDIF                                                                CGL132

     C                   IF        PBefCRSH = *BLANKS AND                                     CGL177
     C                             PAftCRSH = *BLANKS                                         CGL177
     C     PCUST         CHAIN     SDCRSHL1                           9090                    CGL177
     C                   IF        *IN90 = *OFF                                               CGL177
     C                   MOVEL     SDCRSH        PBefCRSH                                     CGL177
     C                   MOVEL     SDCRSH        PAftCRSH                                     CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        PBefCUXC = *BLANKS AND                                   MD026854
     C                             PAftCUXC = *BLANKS                                       MD026854
     C     PCUST         CHAIN     SDCUSXL1                           9090                  MD026854
     C                   IF        *IN90 = *OFF                                             MD026854
     C                   MOVEL     SDCUXC        PBefCUXC                                   MD026854
     C                   MOVEL     SDCUXC        PAftCUXC                                   MD026854
     C                   ENDIF                                                              MD026854
     C                   ENDIF                                                              MD026854
                                                                                            MD026854
     C**********         IF        PBefCUST <> *BLANKS                                      MD027295
     C                   EVAL      KCUST = HCCUST                                           MD027295
     C                   EVAL      KFILE = 'SDCUSTPD'                                       MD027295
     C                   EVAL      KCustRefNum = *BLANKS                                   MD030161A
     C     KHCIN         CHAIN     SDHCIDL0                                                 MD027295
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                  MD027295
     C                             PACRV = 'Y'                                              MD027295
     C                   EVAL      HDIMAG = PBefCUST
     C                   EVAL      HDFILN = 'SDCUSTPD'
     C**********         EVAL      HDIMGT = 'B'                                             MD027295
     C                   EVAL      WImage = HDIMAG                                          MD026666
     C                   EXSR      SRUpdateImage                                            MD026666
     C                   WRITE     SDHCIDD0
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ELSE                                                               MD027295
     C                   IF        WWJARC = 'Y'                                             MD027295
     C                   EVAL      *INLR = *ON                                              MD027295
     C                   RETURN                                                             MD027295
     C                   ENDIF                                                              MD027295
     C                   ENDIF                                                              MD026854

     C**********         IF        PAftCUST <> *BLANKS                             MD026854 MD027295
     C**********         EVAL      HDIMAG = PAftCUST                                        MD027295
     C**********         EVAL      HDFILN = 'SDCUSTPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'A'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                     MD026854 MD027295

     C**********         IF        PBefACUS <> *BLANKS                             MD026854 MD027295
     C                   EVAL      KFILE = 'SDACUSPD'                                       MD027295
     C                   EVAL      KCustRefNum = *BLANKS                                   MD030161A
     C     KHCIN         CHAIN     SDHCIDL0                                                 MD027295
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                  MD027295
     C                             PACRV = 'Y'                                              MD027295
     C                   EVAL      HDIMAG = PBefACUS
     C                   EVAL      HDFILN = 'SDACUSPD'
     C**********         EVAL      HDIMGT = 'B'                                             MD027295
     C                   EVAL      WImage = HDIMAG                                          MD026666
     C                   EXSR      SRUpdateImage                                            MD026666
     C                   WRITE     SDHCIDD0
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD026854

     C**********         IF        PAftACUS <> *BLANKS                             MD026854 MD027295
     C**********         EVAL      HDIMAG = PAftACUS                                        MD027295
     C**********         EVAL      HDFILN = 'SDACUSPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'A'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                     MD026854 MD027295
                                                                                              CGL132
     C**********         IF        PBefFTCS <> *BLANKS                             MD026854 MD027295
     C                   EVAL      KFILE = 'SDFTCSPD'                                       MD027295
     C                   EVAL      KCustRefNum = *BLANKS                                   MD030161A
     C     KHCIN         CHAIN     SDHCIDL0                                                 MD027295
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                  MD027295
     C                             PACRV = 'Y'                                              MD027295
     C                   EVAL      HDIMAG = PBefFTCS                                          CGL132
     C                   EVAL      HDFILN = 'SDFTCSPD'                                        CGL132
     C**********         EVAL      HDIMGT = 'B'                                      CGL132 MD027295
     C                   EVAL      WImage = HDIMAG                                          MD026666
     C                   EXSR      SRUpdateImage                                            MD026666
     C                   WRITE     SDHCIDD0                                                   CGL132
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD026854
                                                                                              CGL132
     C**********         IF        PAftFTCS <> *BLANKS                             MD026854 MD027295
     C**********         EVAL      HDIMAG = PAftFTCS                                 CGL132 MD027295
     C**********         EVAL      HDFILN = 'SDFTCSPD'                               CGL132 MD027295
     C**********         EVAL      HDIMGT = 'A'                                      CGL132 MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                          CGL132 MD027295
     C**********         ENDIF                                                     MD026854 MD027295

     C**********         IF        PBefCUXC <> *BLANKS                             MD026854 MD027295
     C                   EVAL      KFILE = 'SDCRSHPD'                                         CGL177
     C                   EVAL      KCustRefNum = *BLANKS                                      CGL177
     C     KHCIN         CHAIN     SDHCIDL0                                                   CGL177
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                    CGL177
     C                             PACRV = 'Y'                                                CGL177
     C                   EVAL      HDIMAG = PBefCRSH                                          CGL177
     C                   EVAL      HDFILN = 'SDCRSHPD'                                        CGL177
     C                   WRITE     SDHCIDD0                                                   CGL177
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   EVAL      KCUST = HCCUST                                           MD027295
     C                   EVAL      KFILE = 'SDCUSTXC'                                       MD027295
     C                   EVAL      KCustRefNum = *BLANKS                                   MD030161A
     C     KHCIN         CHAIN     SDHCIDL0                                                 MD027295
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                  MD027295
     C                             PACRV = 'Y'                                              MD027295
     C                   EVAL      WImage = PBefCUXC                                        MD026854
     C                   EVAL      HDFILN = 'SDCUSTXC'                                      MD026854
     C**********         EVAL      HDIMGT = 'B'                                    MD026854 MD027295
     C                   EXSR      SRUpdateImage                                            MD026854
     C                   WRITE     SDHCIDD0                                                 MD026854
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD026854
                                                                                            MD026854
     C**********         IF        PAftCUXC <> *BLANKS                             MD026854 MD027295
     C**********         EVAL      WImage = PAftCUXC                               MD026854 MD027295
     C**********         EVAL      HDFILN = 'SDCUSTXC'                             MD026854 MD027295
     C**********         EVAL      HDIMGT = 'A'                                    MD026854 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026854 MD027295
     C**********         WRITE     SDHCIDD0                                        MD026854 MD027295
     C**********         ENDIF                                                     MD026854 MD027295
                                                                                            MD026854
     C**********         IF        PBefJACC <> *BLANKS OR                                   MD027295
     C**********                   PAftJACC <> *BLANKS                                      MD027295
     C**********         IF        PBefJACC <> *BLANKS                                      MD027295
     C**********         MOVEL     PBefJACC      WSJACC                                     MD027295
     C**********         ELSE                                                               MD027295
     C**********         MOVEL     PAftJACC      WSJACC                                     MD027295
     C**********         ENDIF                                                              MD027295
      **
     C**********         IF        PBefJACC <> *BLANKS                            MD026957A MD027295
     C                   EVAL      KFILE = 'SDJACCPD'                                       MD027295
     C                   EVAL      KCustRefNum = CustRefNum                                MD030161A
     C     KHCIN         CHAIN     SDHCIDL0                                                 MD027295
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                  MD027295
     C                             PACRV = 'Y'                                              MD027295
     C**********         EVAL      HDIMAG = PBefJACC                                        MD027295
     C**********         EVAL      HDFILN = 'SDJACCPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'B'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                    MD026957A MD027295

     C**********         IF        PAftJACC <> *BLANKS                            MD026957A MD027295
     C**********         EVAL      HDIMAG = PAftJACC                                        MD027295
     C**********         EVAL      HDFILN = 'SDJACCPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'A'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                    MD026957A MD027295
     C**********         ENDIF                                                              MD027295

     C     PCUST         SETLL     SDJACCL4
     C     PCUST         READE     SDJACCL4                               80
     C                   IF        *IN80 = '1'                                              MD027295
     C                   EVAL      HDIMAG = *BLANKS                                         MD027295
     C                   EVAL      HDFILN = 'SDJACCPD'                                      MD027295
     C                   EVAL      AftImage = PAftJACC                                      MD027295
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM      'SDJACCPD'    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   EVAL      HDCREF =                                                 MD027295
     C                             %SUBST(AftImage :PFieldPosn (2)                          MD027295
     C                                             :PFieldLen  (2))                         MD027295
                                                                                            MD027295
     C                   WRITE     SDHCIDD0                                                 MD027295
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD027295
     C                   DOW       *IN80 = '0' AND
     C                             JCCUST = PCUST
     C                   IF        SDJACC <> PAftJACC                                       MD027295
     C                   MOVEL     SDJACC        PBefJACC
     C                   MOVEL     SDJACC        PAftJACC

     C**********         MOVEL     PBefJACC      WCJACC                                     MD027295

     C**********         IF        WSJACC <> WCJACC                                         MD027295
     C                   EVAL      HDIMAG = PBefJACC
     C                   IF        SDJACC = PAftJACC                                        MD027295
     C                   EVAL      HDIMAG = *BLANKS                                         MD027295
     C                   ENDIF                                                              MD027295
     C                   EVAL      HDFILN = 'SDJACCPD'
     C**********         EVAL      HDIMGT = 'B'                                             MD027295
     C                   EVAL      WImage = HDIMAG                                          MD026666
     C                   EXSR      SRUpdateImage                                            MD026666
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM      'SDJACCPD'    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   EVAL      HDCREF =                                                 MD027295
     C                             %SUBST(AftImage :PFieldPosn (2)                          MD027295
     C                                             :PFieldLen  (2))                         MD027295
     C                   WRITE     SDHCIDD0
     C                   EVAL      WCHK3 = 'Y'                                              MD041066

     C**********         EVAL      HDIMAG = PAftJACC                                        MD027295
     C**********         EVAL      HDFILN = 'SDJACCPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'A'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C                   ENDIF

     C     PCUST         READE     SDJACCL4                               80
     C                   ENDDO
     C                   ELSE                                                               MD027295
     C                   IF        PBefJACC = *BLANKS AND                                   MD027295
     C                             PAftJACC <> *BLANKS                                      MD027295
     C                   EVAL      HDIMAG = *BLANKS                                         MD027295
     C                   EVAL      HDFILN = 'SDJACCPD'                                      MD027295
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM      'SDJACCPD'    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   EVAL      AftImage = PAftJACC                                      MD027295
     C                   EVAL      HDCREF =                                                 MD027295
     C                             %SUBST(AftImage :PFieldPosn (2)                          MD027295
     C                                             :PFieldLen  (2))                         MD027295
     C                   WRITE     SDHCIDD0                                                 MD027295
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD027295
     C                   ENDIF                                                              MD027295

     C**********         IF        PBefCUAH <> *BLANKS OR                                   MD027295
     C**********                   PAftCUAH <> *BLANKS                                      MD027295
     C**********         IF        PBefCUAH <> *BLANKS                                      MD027295
     C**********         MOVEL     PBefCUAH      WSCUAH                                     MD027295
     C**********         ELSE                                                               MD027295
     C                   IF        PAftCUAH <> *BLANKS                                      MD027295
     C                   MOVEL     PAftCUAH      WSCUAH
     C                   ENDIF
      **
     C**********         IF        PBefCUAH <> *BLANKS                            MD026957A MD027295
     C                   EVAL      KFILE = 'SDCUAHPD'                                       MD027295
     C     KHCIN         CHAIN     SDHCIDL0                                                 MD027295
     C                   IF        NOT %FOUND(SDHCIDL0) OR                                  MD027295
     C                             PACRV = 'Y'                                              MD027295
     C**********         EVAL      HDIMAG = PBefCUAH                                        MD027295
     C**********         EVAL      HDFILN = 'SDCUAHPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'B'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                    MD026957A MD027295

     C**********         IF        PAftCUAH <> *BLANKS                            MD026957A MD027295
     C**********         EVAL      HDIMAG = PAftCUAH                                        MD027295
     C**********         EVAL      HDFILN = 'SDCUAHPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'A'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                    MD026957A MD027295
     C**********         ENDIF                                                              MD027295

     C*****PCUST         SETLL     SDCUAHL0                                                 MD026148
     C*****PCUST         READE     SDCUAHL0                               80                MD026148
     C     PCUST         SETLL     SDCUAHL1                                                 MD026148
     C     PCUST         READE     SDCUAHL1                               80                MD026148
     C                   IF        *IN80 = '1'                                              MD027295
     C                   EVAL      HDIMAG = *BLANKS                                         MD027295
     C                   EVAL      HDFILN = 'SDCUAHPD'                                      MD027295
     C                   EVAL      AftImage = PAftCUAH                                      MD027295
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM      'SDCUAHPD'    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   EVAL      HDCREF =                                                 MD027295
     C                             %SUBST(AftImage :PFieldPosn (2)                          MD027295
     C                                             :PFieldLen  (2))                         MD027295
                                                                                            MD027295
     C                   WRITE     SDHCIDD0                                                 MD027295
     C                   ENDIF                                                              MD027295
     C                   DOW       *IN80 = '0' AND
     C                             CACUST = PCUST
     C                   IF        SDCUAH <> PAftCUAH                                       MD027548
     C                   MOVEL     SDCUAH        PBefCUAH
     C                   MOVEL     SDCUAH        PAftCUAH

     C**********         MOVEL     PBefCUAH      WCCUAH                                     MD027548

     C**********         IF        WSCUAH <> WCCUAH                                         MD027295
     C                   EVAL      HDIMAG = PBefCUAH
     C                   IF        SDCUAH = PAftCUAH                                        MD027295
     C                   EVAL      HDIMAG = *BLANKS                                         MD027295
     C                   ENDIF                                                              MD027295
     C                   EVAL      HDFILN = 'SDCUAHPD'
     C**********         EVAL      HDIMGT = 'B'                                             MD027295
     C                   EVAL      WImage = HDIMAG                                          MD026666
     C                   EXSR      SRUpdateImage                                            MD026666
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM      'SDCUAHPD'    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   EVAL      HDCREF =                                                 MD027295
     C                             %SUBST(AftImage :PFieldPosn (2)                          MD027295
     C                                             :PFieldLen  (2))                         MD027295
     C                   WRITE     SDHCIDD0

     C**********         EVAL      HDIMAG = PAftCUAH                                        MD027295
     C**********         EVAL      HDFILN = 'SDCUAHPD'                                      MD027295
     C**********         EVAL      HDIMGT = 'A'                                             MD027295
     C**********         EVAL      WImage = HDIMAG                                 MD026666 MD027295
     C**********         EXSR      SRUpdateImage                                   MD026666 MD027295
     C**********         WRITE     SDHCIDD0                                                 MD027295
     C**********         ENDIF                                                              MD027295

     C*****PCUST         READE     SDCUAHL0                               80                MD026148
     C                   ENDIF                                                              MD027548
     C     PCUST         READE     SDCUAHL1                               80                MD026148
     C                   ENDDO
     C                   ELSE                                                               MD027295
     C                   IF        PBefCUAH = *BLANKS AND                                   MD027295
     C                             PAftCUAH <> *BLANKS                                      MD027295
     C                   EVAL      HDIMAG = *BLANKS                                         MD027295
     C                   EVAL      HDFILN = 'SDCUAHPD'                                      MD027295
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM      'SDCUAHPD'    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   EVAL      AftImage = PAftCUAH                                      MD027295
     C                   EVAL      HDCREF =                                                 MD027295
     C                             %SUBST(AftImage :PFieldPosn (2)                          MD027295
     C                                             :PFieldLen  (2))                         MD027295
     C                   WRITE     SDHCIDD0                                                 MD027295
     C                   ENDIF                                                              MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   EXSR      SRProcessDtl2                                            MD027295
     C                   CALL      'QCMDEXC'                                                MD056982
     C                   PARM                    ##OV2                                      MD056982
     C                   PARM                    WMsgLen                                    MD056982

     C                   EVAL      *INLR = *ON

     C                   RETURN
                                                                                            MD027295
      *****************************************************************                     MD027295
      *                                                               *                     MD027295
      *  SRProcessDtl2 - Process details                              *                     MD027295
      *                                                               *                     MD027295
      *  Called by: Main Routine                                      *                     MD027295
      *                                                               *                     MD027295
      *  Calls    : SrWriteDtl2, UTRTVFLDD                            *                     MD027295
      *                                                               *                     MD027295
      *****************************************************************                     MD027295
                                                                                            MD027295
     C     SRProcessDtl2 BEGSR                                                              MD027295
                                                                                            MD027295
     C                   EVAL      HLCUST = HCCUST                                          MD027295
     C                   EVAL      HLCDAT = HCCDAT                                          MD027295
     C                   EVAL      HLCTIM = HCCTIM                                          MD027295
     C                   EVAL      HLTMST = HCTMST                                          MD027295
     C                   EVAL      HLCDAT = BJRDNB                                         MD027577A
     C                   EVAL      HLINDT = BJRDNB                                          MD027577
     C                   EVAL      WCRS8 = ' '                                                CGL177
     C                   EVAL      WCRS10 = ' '                                               CGL177
                                                                                            MD027295
     C                   EVAL      PFileNames = *BLANKS                                     MD027295
     C                   EVAL      FileNameArr(1) = 'SDCUSTPD'                              MD027295
     C                   EVAL      FileNameArr(2) = 'SDACUSPD'                              MD027295
     C                   EVAL      FileNameArr(3) = 'SDFTCSPD'                              MD027295
     C                   EVAL      FileNameArr(4) = 'SDJACCPD'                              MD027295
     C                   EVAL      FileNameArr(5) = 'SDCUSTXC'                              MD027295
     C                   EVAL      FileNameArr(6) = 'SDCUAHPD'                              MD027295
     C                   EVAL      FileNameArr(6) = 'SDCRSHPD'                                CGL177
     C                   EVAL      FileNameArr(7) = 'SDCRSDPD'                                CGL177
     C                   EVAL      A = 1                                                      CGL177
     C                   EVAL      Index = 1                                                MD027295
     C                   EVAL      Idx = 0                                                  MD027295
                                                                                            MD027295
     C                   DOW       FileNameArr (Index) <> *BLANKS and                       MD027295
     C                             FileArrSize > Index                                      MD027295
                                                                                            MD027295
     C                   EVAL      PFileName = FileNameArr(Index)                           MD027295
     C                   SELECT                                                             MD027295
     C                   WHEN      PFilename = 'SDCUSTPD'                                   MD027295
     C                   EVAL      BefImage = PBefCUST                                      MD027295
     C                   EVAL      AftImage = PAftCUST                                      MD027295
     C                   WHEN      PFilename = 'SDCUSTXC'                                   MD027295
     C                   EVAL      BefImage = PBefCUXC                                      MD027295
     C                   EVAL      AftImage = PAftCUXC                                      MD027295
     C                   WHEN      PFilename = 'SDACUSPD'                                   MD027295
     C                   EVAL      BefImage = PBefACUS                                      MD027295
     C                   EVAL      AftImage = PAftACUS                                      MD027295
     C                   WHEN      PFilename = 'SDFTCSPD'                                   MD027295
     C                   EVAL      BefImage = PBefFTCS                                      MD027295
     C                   EVAL      AftImage = PAftFTCS                                      MD027295
     C                   WHEN      PFilename = 'SDJACCPD'                                   MD027295
     C                   EVAL      BefImage = PBefJACC                                      MD027295
     C                   EVAL      AftImage = PAftJACC                                      MD027295
     C                   WHEN      PFilename = 'SDCUAHPD'                                   MD027295
     C                   EVAL      BefImage = PBefCUAH                                      MD027295
     C                   EVAL      AftImage = PAftCUAH                                      MD027295
     C                   WHEN      PFilename = 'SDCRSHPD'                                     CGL177
     C                   EVAL      BefImage = PBefCRSH                                        CGL177
     C                   EVAL      AftImage = PAftCRSH                                        CGL177
     C                   WHEN      PFilename = 'SDCRSDPD'                                     CGL177
     C                   EVAL      BefImage = PBefCRSD                                        CGL177
     C                   EVAL      AftImage = PAftCRSD                                        CGL177
     C                   ENDSL                                                              MD027295
                                                                                            MD027295
     C                   EVAL      Index = Index + 1                                        MD027295
                                                                                            MD027295
     C                   IF        BefImage <> AftImage                                     MD027295
                                                                                            MD027295
     C                   CALL      'UTRTVFLDD'                                              MD027295
     C                   PARM      *BLANKS       Prtcd                                      MD027295
     C                   PARM                    PFileName                                  MD027295
     C                   PARM      *BLANKS       PFieldsDesc                                MD027295
     C                   PARM      *ZEROS        PFieldsNum                                 MD027295
                                                                                            MD027295
     C                   IF        Prtcd = *BLANKS                                          MD027295
                                                                                            MD027295
     C                   EVAL      Idx = 0                                                  MD027295
     C                   EVAL      HLCREF = *BLANKS                                         MD027295
                                                                                              CGL177
     C                   IF        PFilename = 'SDCRSDPD'                                     CGL177
     C                             AND AftImage <> *Blanks                                    CGL177
     C                   EVAL      KCUST = %SUBST(AftImage:1:6)                               CGL177
     C                   EVAL      KCustRefNum = %SUBST(AftImage:7:2)                         CGL177
     C                   EVAL      KFile = 'SDCRSDPD'                                         CGL177
     C     KHCIN         CHAIN     SDHCIDL0                                                   CGL177
     C                   IF        NOT %FOUND(SDHCIDL0)                                       CGL177
     C                   EVAL      HDCREF = %SUBST(AftImage:7:2)                              CGL177
     C                   EVAL      HDIMAG = *Blanks                                           CGL177
     C                   EVAL      HDFILN = 'SDCRSDPD'                                        CGL177
     C                   WRITE     SDHCIDD0                                                   CGL177
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                            MD027295
     C                   DO        PFieldsNum                                               MD027295
     C                   EXSR      SRWriteDtl2                                              MD027295
     C                   ENDDO                                                              MD027295
                                                                                              CGL177
     C                   IF        PFilename = 'SDCRSDPD'                                     CGL177
     C                             AND AftImage <> *Blanks                                    CGL177
     C                   EVAL      A = 230                                                    CGL177
     C                   EVAL      B = 229                                                    CGL177
     C                   EVAL      BefImage = %SUBST(BefImage:A:B)                            CGL177
     C                   EVAL      AftImage = %SUBST(AftImage:A:B)                            CGL177
     C                   DOW       BefImage <> *BLANKS                                        CGL177
     C                             OR AftImage <> *BLANKS                                     CGL177
     C                   EVAL      KCUST = %SUBST(AftImage:1:6)                               CGL177
     C                   EVAL      KCustRefNum = %SUBST(AftImage:7:2)                         CGL177
     C                   EVAL      KFile = 'SDCRSDPD'                                         CGL177
     C     KHCIN         CHAIN     SDHCIDL0                                                   CGL177
     C                   IF        NOT %FOUND(SDHCIDL0)                                       CGL177
     C                   EVAL      HDCREF = %SUBST(AftImage:7:2)                              CGL177
     C                   EVAL      HDIMAG = *Blanks                                           CGL177
     C                   EVAL      HDFILN = 'SDCRSDPD'                                        CGL177
     C                   WRITE     SDHCIDD0                                                   CGL177
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                                CGL177
     C**********         DOW       BefImage <> *BLANKS                                        CGL177
     C**********                   OR AftImage <> *BLANKS                                     CGL177
     C                   EVAL      Idx = 0                                                    CGL177
     C                   DO        PFieldsNum                                                 CGL177
     C                   EXSR      SRWriteDtl2                                                CGL177
     C                   ENDDO                                                                CGL177
     C                   EVAL      A = A + 229                                                CGL177
     C                   EVAL      BefImage = %SUBST(BefImage:A:B)                            CGL177
     C                   EVAL      AftImage = %SUBST(AftImage:A:B)                            CGL177
     C                   ENDDO                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                            MD027295
     C                   ENDIF                                                              MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   ENDDO                                                              MD027295
                                                                                            MD027295
     C**********         IF        WOTHER1 = 'N' AND                                 MD027295 CGL177
     C**********                   WFAINFO = 'Y' AND                                 MD027295 CGL177
     C**********                   HCDESC = PDESC(7)                                 MD027295 CGL177
     C**********         EVAL      HCDESC = PDESC(8)                                 MD027295 CGL177
     C**********         EVAL      %SUBST(HCDESC:45:1) = YFAINFC                     MD027295 CGL177
     C**********         ENDIF                                                       MD027295 CGL177
     C                   EVAL      SDFTCSY = PAftFTCS                                       MD029018
     C                   EVAL      SDCRSHY = PAftCRSH                                         CGL177
     C                   EVAL      SDCUXC  = PAftCUXC                                       MD041407
     C                   EVAL      HCINFC = YFAINFC                                         MD027513
     C                   EVAL      HCINF2 = *Blanks                                           CGL177
     C                   IF        CGL157 = 'Y'                                               CGL177
     C                   EVAL      HCINF2 = YCRINFO                                           CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        PACRV = 'Y'                                              MD029018
     C                   EVAL      HCLUSR = USRID                                           MD029018
     C                   ELSE                                                               MD029018
     C                   IF        PAftCUST <> *BLANKS                                      MD041407
     C                             AND PAftCUST <> PBefCUST                                 MD041407
     C                             AND XCLCUS <> *BLANKS                                    MD041407
     C                   EVAL      HCLUSR = XCLCUS                                          MD041407
     C                   ELSE                                                               MD041407
     C                   IF        YFALUSR <> *BLANKS                                       MD041578
     C                   EVAL      HCLUSR = YFALUSR                                         MD029018
     C                   ELSE                                                               MD041578
     C                   EVAL      HCLUSR = USRID                                           MD041578
     C                   ENDIF                                                              MD041578
     C                   ENDIF                                                              MD041407
     C                   ENDIF                                                              MD029018
     C                   EVAL      HCIEXR = YFAEXMA                                         MD029018
     C                   IF        HCIEXR = ' '                                               CGL177
     C                             OR HCIEXR = 'N'                                            CGL177
     C                   IF        YCREXMG <> ' '                                             CGL177
     C                   EVAL      HCIEXR = YCREXMG                                           CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        HCIEXR = ' '                                               CGL177
     C                   EVAL      HCIEXR = 'N'                                               CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      HCCREF = CustRefNum                                     MD030161A
                                                                                           MD030161A
     C                   IF        HCDESC <> 'Miscellaneous change'                           CGL177
     C                             OR (CGL157 = 'N' AND WCHK3 = 'Y' AND              CGL177 MD041389
     C                             HCDESC = 'Miscellaneous change')                  CGL177 MD041389
     C                   WRITE     SDHCIND0                                                 MD027295
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        CGL157 = 'Y'                                               CGL177
     C                   EVAL      WDCRS = ' '                                                CGL177
     C                   IF        WCRS10 = 'Y'                                               CGL177
     C                   EVAL      HCDESC = PDESC(11)                                         CGL177
     C                   EVAL      WDCRS = 'Y'                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        PELEC = 'Y'                                                CGL177
     C                             AND (PBefCRSH <> PAftCRSH                                  CGL177
     C                             OR PBefCRSD <> PAftCRSD)                                   CGL177
     C                   EVAL      HCDESC = PDESC(10)                                         CGL177
     C                   EVAL      WDCRS = 'Y'                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        WCRS8 = 'Y'                                                CGL177
     C                   EVAL      HCDESC = PDESC(9)                                          CGL177
     C                   EVAL      WDCRS = 'Y'                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                              CGL177
     C                   IF        WDCRS = 'Y'                                                CGL177
     C                             OR (HCDESC = 'Miscellaneous change'                      MD041066
     C                             AND WCHK3 = 'Y')                                         MD041066
     C                   WRITE     SDHCIND0                                                   CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
                                                                                            MD027295
     C                   ENDSR                                                              MD027295
                                                                                            MD027295
                                                                                            MD027295
      *****************************************************************                     MD027295
      *                                                               *                     MD027295
      *  SRWriteDtl2 - Write details                                  *                     MD027295
      *                                                               *                     MD027295
      *  Called by: SrProcessDtl2                                     *                     MD027295
      *                                                               *                     MD027295
      *  Calls    : None                                              *                     MD027295
      *                                                               *                     MD027295
      *****************************************************************                     MD027295
                                                                                            MD027295
     C     SRWriteDtl2   BEGSR                                                              MD027295
                                                                                            MD027295
     C                   EVAL      Idx = Idx + 1                                            MD027295
                                                                                            MD027295
     C                   IF        PFieldName (Idx) = 'CDREPT'                                CGL177
     C                   EVAL      WCHK1  =                                                   CGL177
     C                             %SUBST(BefImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx))                         CGL177
     C                   EVAL      WCHK2  =                                                   CGL177
     C                             %SUBST(AftImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx))                         CGL177
     C                   IF        (WCHK1 = 'Y'                                               CGL177
     C                             AND WCHK2 = 'N')                                           CGL177
     C                             OR (WCHK1 = 'N'                                            CGL177
     C                             AND WCHK2 = 'Y')                                           CGL177
     C                   EVAL      WCRS10 = 'Y'                                               CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   IF        PFieldName (Idx) = 'CDCODO'                                CGL177
     C                             OR PFieldName (Idx) = 'CDJACM'                             CGL177
     C                             OR PFieldName (Idx) = 'CDMAIL'                             CGL177
     C                             OR PFieldName (Idx) = 'CDPHON'                             CGL177
     C                             OR PFieldName (Idx) = 'CDRPAY'                             CGL177
     C                             OR PFieldName (Idx) = 'CDTINS'                             CGL177
     C                             OR PFieldName (Idx) = 'CDAUHO'                             CGL177
     C                   IF        %Subst(BefImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx)) <>                      CGL177
     C                             %subst(AftImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx))                         CGL177
     C                   EVAL      WCRS8 = 'Y'                                                CGL177
     C                   ENDIF                                                                CGL177
     C                   ENDIF                                                                CGL177
     C                                                                                        CGL177
     C                   IF        (%subst(BefImage :PFieldPosn (Idx)                       MD027295
     C                                             :PFieldLen  (Idx)) <>                    MD027295
     C                             %subst(AftImage :PFieldPosn (Idx)                        MD027295
     C                                             :PFieldLen  (Idx))) OR                   MD027295
     C                             PFieldName (Idx) = 'JCJANO' OR                           MD027295
     C**********                   PFieldName (Idx) = 'JCCUST'                     MD027295 MD027548
     C                             PFieldName (Idx) = 'JCCUST' OR                           MD027548
     C                             PFieldName (Idx) = 'FALUSR' OR                           MD028949
     C                             PFieldName (Idx) = 'CDCUST' OR                             CGL177
     C                             PFieldName (Idx) = 'CDCTRY' OR                             CGL177
     C                             PFieldName (Idx) = 'CACUST' OR                           MD027548
     C                             PFieldName (Idx) = 'CAAUTH'                              MD027548
                                                                                            MD027295
     C                   IF        PFieldType (Idx) = 'P'                                   MD027295
     C                   IF        %subst(AftImage :PFieldPosn (Idx)                        MD027309
     C                                             :PFieldLen  (Idx))                       MD027309
     C                                              = *BLANKS                               MD027309
     C                   EVAL      HLIMAG =        *BLANKS                                  MD027309
     C                   ELSE                                                               MD027309
                                                                                            MD027309
     C                   SELECT                                                             MD027295
     C                   WHEN      PFieldDigt (Idx) = 3                                     MD027295
     C                   EVAL      Wchar2 =                                                 MD027295
     C                             %subst(AftImage :PFieldPosn (Idx)                        MD027295
     C                                             :PFieldLen  (Idx))                       MD027295
     C                   EVAL      HLIMAG =        %EDITC(WPacked3:'X')                     MD027295
     C                   WHEN      PFieldDigt (Idx) = 5                                     MD027295
     C                   EVAL      Wchar3 =                                                 MD027295
     C                             %subst(AftImage :PFieldPosn (Idx)                        MD027295
     C                                             :PFieldLen  (Idx))                       MD027295
     C                   EVAL      HLIMAG =        %EDITC(WPacked5:'X')                     MD027295
     C                   WHEN      PFieldDigt (Idx) = 6                                     MD027295
     C                   EVAL      Wchar4 =                                                 MD027295
     C                             %subst(AftImage :PFieldPosn (Idx)                        MD027295
     C                                             :PFieldLen  (Idx))                       MD027295
     C                   EVAL      HLIMAG =        %EDITC(WPacked6:'X')                     MD027295
     C                   WHEN      PFieldDigt (Idx) = 9                                     MD027295
     C                   EVAL      Wchar6 =                                                 MD027295
     C                             %subst(AftImage :PFieldPosn (Idx)                        MD027295
     C                                             :PFieldLen  (Idx))                       MD027295
     C                   EVAL      HLIMAG =        %EDITC(WPacked9:'X')                     MD027295
     C                   ENDSL                                                              MD027295
     C                   ENDIF                                                              MD027309
                                                                                            MD027295
     C                   EVAL      HLFILN = PFileName                                       MD027295
     C                   EVAL      HLFLDN = PFieldName (Idx)                                MD027295
     C                   IF        HLFLDN <> 'BBTMST' AND                                   MD027295
     C                             HLFLDN <> 'E5TMST' AND                                   MD027295
     C                             HLFLDN <> 'FATMST' AND                                   MD027295
     C                             HLFLDN <> 'JCTMST' AND                                   MD027295
     C                             HLFLDN <> 'BBLCD' AND                                    MD027295
     C                             HLFLDN <> 'BBTYLC' AND                                   MD027295
     C                             HLFLDN <> 'E5LCD' AND                                    MD027295
     C                             HLFLDN <> 'E5TYLC' AND                                   MD027295
     C                             HLFLDN <> 'XCLCUS' AND                                   MD027295
     C                             HLFLDN <> 'FALUSR' AND                                   MD027295
     C                             HLFLDN <> 'FALDAT' AND                                   MD027295
     C                             HLFLDN <> 'FALCTP' AND                                   MD027295
     C                             HLFLDN <> 'JCCHTP' AND                                   MD027295
     C                             HLFLDN <> 'JCLCDT'                                       MD027295
     C**********         IF        HLFLDN <> 'FAINFC'                              MD027295 MD028974
     C                   IF        HLFLDN <> 'FAINFC' AND                                   MD028974
     C                             HLFLDN <> 'FALUSR'                                       MD028974
     C                   EVAL      WOTHER1 = 'Y'                                            MD027295
     C                   ENDIF                                                              MD027295
     C                   IF        HLFLDN = 'FAINFC'                                        MD027295
     C                   EVAL      WFAINFO = 'Y'                                            MD027295
     C                   ENDIF                                                              MD027295
     C                   EVAL      HLINDT = HCINDT                                          MD027295
     C                   EVAL      HLFLDS = 1                                               MD027295
     C                   WRITE     SDHCILD0                                                 MD027295
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   ELSE                                                               MD027295
     C                   EVAL      WWIMAG = *BLANKS                                         MD027295
     C                   EVAL      WWIMAG  =                                                MD027295
     C                             %SUBST(AftImage :PFieldPosn (Idx)                        MD027295
     C                                             :PFieldLen  (Idx))                       MD027295
     C                   IF        HCACTN = 'D' AND                                         MD027310
     C**********                   PFilename = 'SDJACCPD'                          MD027310 MD027548
     C                             PFilename = 'SDJACCPD' OR                                MD027548
     C                             HCACTN = 'D' AND                                         MD027548
     C                             PFilename = 'SDCUAHPD'                                   MD027548
     C                   EVAL      WWIMAG  =                                                MD027310
     C                             %SUBST(BefImage :PFieldPosn (Idx)                        MD027310
     C                                             :PFieldLen  (Idx))                       MD027310
     C                   ENDIF                                                              MD027310
     C                   IF        HCACTN = 'D' AND                                           CGL177
     C                             PFilename = 'SDCRSDPD'                                     CGL177
     C                   EVAL      WWIMAG  =                                                  CGL177
     C                             %SUBST(BefImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx))                         CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      W = 1                                                    MD027295
     C                   EVAL      HLIMAG = *BLANKS                                         MD027295
     C                   EVAL      HLIMAG = %SUBST(WWIMAG:W:10)                             MD027295
                                                                                            MD027295
     C                   EVAL      HLFILN = PFileName                                       MD027295
     C                   EVAL      HLFLDN = PFieldName (Idx)                                MD027295
     C                   IF        HLFLDN <> 'BBTMST' AND                                   MD027295
     C                             HLFLDN <> 'E5TMST' AND                                   MD027295
     C                             HLFLDN <> 'FATMST' AND                                   MD027295
     C                             HLFLDN <> 'JCTMST' AND                                   MD027295
     C                             HLFLDN <> 'BBLCD' AND                                    MD027295
     C                             HLFLDN <> 'BBTYLC' AND                                   MD027295
     C                             HLFLDN <> 'E5LCD' AND                                    MD027295
     C                             HLFLDN <> 'E5TYLC' AND                                   MD027295
     C                             HLFLDN <> 'XCLCUS' AND                                   MD027295
     C**********                   HLFLDN <> 'FALUSR' AND                          MD027295 MD028949
     C                             HLFLDN <> 'FALDAT' AND                                   MD027295
     C                             HLFLDN <> 'FALCTP' AND                                   MD027295
     C                             HLFLDN <> 'JCCHTP' AND                                   MD027295
     C                             HLFLDN <> 'FALCTP' AND                                   MD027295
     C                             HLFLDN <> 'JCCHTP' AND                                   MD027295
     C                             HLFLDN <> 'CATYLC' AND                                   MD027295
     C                             HLFLDN <> 'CATMST' AND                                   MD027295
     C                             HLFLDN <> 'JCLCDT'                                       MD027295
                                                                                            MD027295
     C                   IF        HLFILN = 'SDJACCPD' AND                                  MD027295
     C**********                   HLFLDN = 'JCCUST'                               MD027295 MD027548
     C                             HLFLDN = 'JCCUST' OR                                     MD027548
     C                             HLFILN = 'SDCUAHPD' AND                                  MD027548
     C                             HLFLDN = 'CAAUTH'                                        MD027548
     C                   EVAL      HLCREF = HLIMAG                                          MD027295
     C                   ENDIF                                                              MD027295
                                                                                              CGL177
     C                   IF        HLFILN = 'SDCRSDPD' AND                                    CGL177
     C                             HLFLDN = 'CDCTRY'                                          CGL177
     C                   EVAL      HLCREF = HLIMAG                                            CGL177
     C                   ENDIF                                                                CGL177
                                                                                            MD027295
     C**********         IF        HLFLDN = 'JCJANO' AND                           MD027295 MD027310
     C**********                   %subst(BefImage :PFieldPosn (Idx)               MD027295 MD027310
     C**********                                   :PFieldLen  (Idx)) <>           MD027295 MD027310
     C**********                   *BLANKS OR                                      MD027295 MD027310
     C**********                   HLFLDN = 'JCCUST' AND                           MD027295 MD027310
     C**********                   %subst(BefImage :PFieldPosn (Idx)               MD027295 MD027310
     C**********                                   :PFieldLen  (Idx)) <>           MD027295 MD027310
     C**********                   *BLANKS                                         MD027295 MD027310
     C                   IF        (HLFLDN = 'JCJANO' AND                                   MD027310
     C                             %subst(BefImage :PFieldPosn (Idx)                        MD027310
     C                                             :PFieldLen  (Idx)) <>                    MD027310
     C                             *BLANKS AND HCACTN <> 'D') OR                            MD027310
     C                             (HLFLDN = 'JCCUST' AND                                   MD027310
     C                             %subst(BefImage :PFieldPosn (Idx)                        MD027310
     C                                             :PFieldLen  (Idx)) <>                    MD027310
     C**********                   *BLANKS AND HCACTN <> 'D')                      MD027310 MD027548
     C                             *BLANKS AND HCACTN <> 'D') OR                            MD027548
     C                             (HLFLDN = 'CACUST' AND                                   MD027548
     C                             %subst(BefImage :PFieldPosn (Idx)                        MD027548
     C                                             :PFieldLen  (Idx)) <>                    MD027548
     C                             *BLANKS AND HCACTN <> 'D') OR                            MD027548
     C                             (HLFLDN = 'CAAUTH' AND                                   MD027548
     C                             %subst(BefImage :PFieldPosn (Idx)                        MD027548
     C                                             :PFieldLen  (Idx)) <>                    MD027548
     C**********                   *BLANKS AND HCACTN <> 'D')                        MD027548 CGL177
     C                             *BLANKS AND HCACTN <> 'D') OR                              CGL177
     C                             (HLFLDN = 'CDCUST' AND                                     CGL177
     C                             %subst(BefImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx)) <>                      CGL177
     C                             *BLANKS AND HCACTN <> 'D') OR                              CGL177
     C                             (HLFLDN = 'CDCTRY' AND                                     CGL177
     C                             %subst(BefImage :PFieldPosn (Idx)                          CGL177
     C                                             :PFieldLen  (Idx)) <>                      CGL177
     C                             *BLANKS AND HCACTN <> 'D')                                 CGL177
     C                   ELSE                                                               MD027295
     C**********         IF        HLFLDN <> 'JCJANO'                              MD027295 MD027548
     C                   IF        HLFLDN <> 'JCJANO' AND                                   MD027548
     C                             HLFLDN <> 'CDCUST' AND                                     CGL177
     C                             HLFLDN <> 'CACUST'                                       MD027548
     C**********         IF        HLFLDN <> 'FAINFC'                              MD027295 MD028974
     C                   IF        HLFLDN <> 'FAINFC' AND                                   MD028974
     C                             HLFLDN <> 'FALUSR'                                       MD028974
     C                   EVAL      WOTHER1 = 'Y'                                            MD027295
     C                   ENDIF                                                              MD027295
     C                   IF        HLFLDN = 'FAINFC'                                        MD027295
     C                   EVAL      WFAINFO = 'Y'                                            MD027295
     C                   ENDIF                                                              MD027295
     C                   IF        HCACTN = 'D' AND                                         MD027310
     C**********                   PFilename = 'SDJACCPD'                          MD027310 MD027548
     C                             PFilename = 'SDJACCPD' OR                                MD027548
     C                             HCACTN = 'D' AND                                         MD027548
     C                             PFilename = 'SDCUAHPD'                                   MD027548
     C                   EVAL      HLIMAG = *BLANKS                                         MD027310
     C                   EVAL      WWIMAG = *BLANKS                                         MD027310
     C                   ENDIF                                                              MD027310
     C                   EVAL      HLFLDS = 1                                               MD027295
     C                   IF        HLFLDN <> 'FALUSR'                                       MD028949
     C                   WRITE     SDHCILD0                                                 MD027295
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ELSE                                                               MD028949
     C                   EVAL      WWLLSR = HLIMAG                                          MD028949
     C                   ENDIF                                                              MD028949
     C**********         IF        HLFLDN = 'JCCUST'                               MD027295 MD027548
     C                   IF        HLFLDN = 'JCCUST' OR                                     MD027548
     C                             HLFLDN = 'CAAUTH'                                        MD027548
     C                             OR HLFLDN = 'CDCTRY'                                       CGL177
     C                   EVAL      HLIMAG = WSTORE1                                         MD027295
     C**********         IF        HCACTN = 'D' AND                                  MD027310 CGL177
     C**********                   PFilename = 'SDJACCPD'                          MD027310 MD027548
     C**********                   PFilename = 'SDJACCPD' OR                         MD027548 CGL177
     C**********                   HCACTN = 'D' AND                                  MD027548 CGL177
     C**********                   PFilename = 'SDCUAHPD'                            MD027548 CGL177
     C                   IF        (HCACTN = 'D' AND                                          CGL177
     C                             PFilename = 'SDJACCPD')                                    CGL177
     C                             OR (HCACTN = 'D' AND                                       CGL177
     C                             PFilename = 'SDCRSDPD')                                    CGL177
     C                             OR (HCACTN = 'D' AND                                       CGL177
     C                             PFilename = 'SDCUAHPD')                                    CGL177
     C                   EVAL      HLIMAG = *BLANKS                                         MD027310
     C                   ENDIF                                                              MD027310
     C                   EVAL      HLFLDN = WSTORE2                                         MD027295
     C                   EVAL      HLFLDS = 1                                               MD027295
     C                   WRITE     SDHCILD0                                                 MD027295
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   ENDIF                                                              MD027295
     C                   ELSE                                                               MD027295
     C                   EVAL      WSTORE1 = HLIMAG                                         MD027295
     C                   EVAL      WSTORE2 = HLFLDN                                         MD027295
     C                   ENDIF                                                              MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   EVAL      W = W + 10                                               MD027295
     C                   EVAL      WWIMAG2 = *BLANKS                                        MD027295
     C                   EVAL      WWIMAG2 = %SUBST(WWIMAG:W:10)                            MD027295
     C                   EVAL      HLIMAG = WWIMAG2                                         MD027295
     C                   DOW       HLIMAG <> *BLANKS                                        MD027295
     C                   EVAL      HLFLDS = HLFLDS + 1                                      MD027295
     C                   WRITE     SDHCILD0                                                 MD027295
     C                   EVAL      WCHK3 = 'Y'                                              MD041066
     C                   EVAL      W = W + 10                                               MD027295
     C                   EVAL      WWIMAG2 = *BLANKS                                        MD027295
     C                   EVAL      WWIMAG2 = %SUBST(WWIMAG:W:10)                            MD027295
     C                   EVAL      HLIMAG = WWIMAG2                                         MD027295
     C                   ENDDO                                                              MD027295
                                                                                            MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   ENDIF                                                              MD027295
                                                                                            MD027295
     C                   ENDSR                                                              MD027295

      *****************************************************************                     MD026666
      /EJECT                                                                                MD026666
      *****************************************************************                     MD026666
      *  SRUpdateImage - Update before and after image                *                     MD026666
      *****************************************************************                     MD026666
     C     SRUpdateImage BEGSR                                                              MD026666
                                                                                            MD026666
     C                   IF        WImage = *BLANKS                                         MD027309
     C                   CLEAR                   HDIMAG                                     MD027309
     C                   ELSE                                                               MD027309
                                                                                            MD027309
     C                   CLEAR                   PFieldsDesc                                MD026666
     C                   CLEAR                   PFieldsNum                                 MD026666
     C                   CLEAR                   NFieldPosn                                 MD026666
     C                   CLEAR                   NFieldLen                                  MD026666
     C                   CLEAR                   HDIMAG                                     MD026666
     C                   EVAL      Idx = 0                                                  MD026666
                                                                                            MD026666
     C                   SELECT                                                             MD026666
                                                                                            MD026666
     C                   WHEN      HDFILN = 'SDCUSTPD'                                      MD026666
     C                   EVAL      PFieldsDesc = SdcustpdArr                                MD026666
     C                   EVAL      PFieldsNum = SdcustFNum                                  MD026666
     C                   EVAL      NFieldPosn = SdcustPosnB                                 MD026666
     C                   EVAL      NFieldLen = SdcustLenB                                   MD026666
                                                                                            MD026666
     C                   WHEN      HDFILN = 'SDACUSPD'                                      MD026666
     C                   EVAL      PFieldsDesc = SdacuspdArr                                MD026666
     C                   EVAL      PFieldsNum = SdacusFNum                                  MD026666
     C                   EVAL      NFieldPosn = SdacusPosnB                                 MD026666
     C                   EVAL      NFieldLen = SdacusLenB                                   MD026666
                                                                                            MD026666
     C                   WHEN      HDFILN = 'SDFTCSPD'                                      MD026666
     C                   EVAL      PFieldsDesc = SdftcspdArr                                MD026666
     C                   EVAL      PFieldsNum = SdftcsFNum                                  MD026666
     C                   EVAL      NFieldPosn = SdftcsPosnB                                 MD026666
     C                   EVAL      NFieldLen = SdftcsLenB                                   MD026666
                                                                                            MD026666
     C                   WHEN      HDFILN = 'SDJACCPD'                                      MD026666
     C                   EVAL      PFieldsDesc = SdjaccpdArr                                MD026666
     C                   EVAL      PFieldsNum = SdjaccFNum                                  MD026666
     C                   EVAL      NFieldPosn = SdjaccPosnB                                 MD026666
     C                   EVAL      NFieldLen = SdjaccLenB                                   MD026666
                                                                                            MD026666
     C                   WHEN      HDFILN = 'SDCUAHPD'                                      MD026666
     C                   EVAL      PFieldsDesc = SdcuahpdArr                                MD026666
     C                   EVAL      PFieldsNum = SdcuahFNum                                  MD026666
     C                   EVAL      NFieldPosn = SdcuahPosnB                                 MD026666
     C                   EVAL      NFieldLen = SdcuahLenB                                   MD026666
                                                                                            MD026854
     C                   WHEN      HDFILN = 'SDCUSTXC'                                      MD026854
     C                   EVAL      PFieldsDesc = SdcuxcpdArr                                MD026854
     C                   EVAL      PFieldsNum = SdcuxcFNum                                  MD026854
     C                   EVAL      NFieldPosn = SdcuxcPosnB                                 MD026854
     C                   EVAL      NFieldLen = SdcuxcLenB                                   MD026854
                                                                                              CGL177
     C                   WHEN      HDFILN = 'SDCRSHPD'                                        CGL177
     C                   EVAL      PFieldsDesc = SdcrshpdArr                                  CGL177
     C                   EVAL      PFieldsNum = SdcrshFNum                                    CGL177
     C                   EVAL      NFieldPosn = SdcrshPosnB                                   CGL177
     C                   EVAL      NFieldLen = SdcrshLenB                                     CGL177
                                                                                              CGL177
     C                   WHEN      HDFILN = 'SDCRSDPD'                                        CGL177
     C                   EVAL      PFieldsDesc = SdcrsdpdArr                                  CGL177
     C                   EVAL      PFieldsNum = SdcrsdFNum                                    CGL177
     C                   EVAL      NFieldPosn = SdcrsdPosnB                                   CGL177
     C                   EVAL      NFieldLen = SdcrsdLenB                                     CGL177
     C                   ENDSL                                                              MD026666
     C                                                                                      MD026666
     C                   DO        PFieldsNum                                               MD026666
     C                   EVAL      Idx = Idx + 1                                            MD026666
     C                   IF        PFieldType (Idx) = 'P'                                   MD026666
     C                   SELECT                                                             MD026666
     C                   WHEN      PFieldDigt (Idx) = 3                                     MD026666
     C                   EVAL      Wchar2 =                                                 MD026666
     C                             %subst(WImage   :PFieldPosn (Idx)                        MD026666
     C                                             :PFieldLen  (Idx))                       MD026666
     C                   EVAL      %subst(HDIMAG   :NFieldPosn (Idx)                        MD026666
     C                                             :NFieldLen  (Idx)) =                     MD026666
     C                                             %EDITC(WPacked3:'X')                     MD026666
     C                   WHEN      PFieldDigt (Idx) = 5                                     MD026666
     C                   EVAL      Wchar3 =                                                 MD026666
     C                             %subst(WImage   :PFieldPosn (Idx)                        MD026666
     C                                             :PFieldLen  (Idx))                       MD026666
     C                   EVAL      %subst(HDIMAG   :NFieldPosn (Idx)                        MD026666
     C                                             :NFieldLen  (Idx)) =                     MD026666
     C                                             %EDITC(WPacked5:'X')                     MD026666
     C                   WHEN      PFieldDigt (Idx) = 6                                     MD026666
     C                   EVAL      Wchar4 =                                                 MD026666
     C                             %subst(WImage   :PFieldPosn (Idx)                        MD026666
     C                                             :PFieldLen  (Idx))                       MD026666
     C                   EVAL      %subst(HDIMAG   :NFieldPosn (Idx)                        MD026666
     C                                             :NFieldLen  (Idx)) =                     MD026666
     C                                             %EDITC(WPacked6:'X')                     MD026666
     C                   WHEN      PFieldDigt (Idx) = 9                                     MD026666
     C                   EVAL      Wchar6 =                                                 MD026666
     C                             %subst(WImage   :PFieldPosn (Idx)                        MD026666
     C                                             :PFieldLen  (Idx))                       MD026666
     C                   EVAL      %subst(HDIMAG   :NFieldPosn (Idx)                        MD026666
     C                                             :NFieldLen  (Idx)) =                     MD026666
     C                                             %EDITC(WPacked9:'X')                     MD026666
     C                   ENDSL                                                              MD026666
                                                                                            MD026666
     C                   ELSE                                                               MD026666
     C                   EVAL      %subst(HDIMAG   :NFieldPosn (Idx)                        MD026666
     C                                             :NFieldLen  (Idx))  =                    MD026666
     C                             %subst(WImage   :PFieldPosn (Idx)                        MD026666
     C                                             :PFieldLen  (Idx))                       MD026666
     C                   ENDIF                                                              MD026666
     C                   ENDDO                                                              MD026666
                                                                                            MD027309
     C                   ENDIF                                                              MD027309
                                                                                            MD026666
     C                   ENDSR                                                              MD026666
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

     C                   PARM                    PCUST
     C                   PARM                    PBefCUST
     C                   PARM                    PAftCUST
     C                   PARM                    PBefACUS
     C                   PARM                    PAftACUS
     C                   PARM                    PBefFTCS                                     CGL132
     C                   PARM                    PAftFTCS                                     CGL132
     C                   PARM                    PBefJACC
     C                   PARM                    PAftJACC
     C                   PARM                    PBefCUAH
     C                   PARM                    PAftCUAH
     C                   PARM                    PBefCUXC                                   MD026854
     C                   PARM                    PAftCUXC                                   MD026854
     C                   PARM                    PACRV
     C                   PARM                    PELEC                                        CGL132
     C                   PARM                    PBefCRSH                                     CGL177
     C                   PARM                    PAftCRSH                                     CGL177
     C                   PARM                    PBefCRSD                                     CGL177
     C                   PARM                    PAftCRSD                                     CGL177
                                                                                            MD027295
     C     KHCIN         KLIST                                                              MD027295
     C                   KFLD                    KCUST                                      MD027295
     C                   KFLD                    KCustRefNum                               MD030161A
     C                   KFLD                    KFILE                                      MD027295

      ** Access Bank Details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRtcd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                            MD026666
      ** Get user ID                                                                        MD026666
     C                   IN        ZMUSER                                                   MD026666
                                                                                            MD026666
     C                   EVAL      PFileNames = *BLANKS                                     MD026666
     C                   EVAL      FileNameArr(1) = 'SDCUSTPD'                              MD026666
     C                   EVAL      FileNameArr(2) = 'SDACUSPD'                              MD026666
     C                   EVAL      FileNameArr(3) = 'SDFTCSPD'                              MD026666
     C                   EVAL      FileNameArr(4) = 'SDJACCPD'                              MD026666
     C                   EVAL      FileNameArr(5) = 'SDCUAHPD'                              MD026666
     C                   EVAL      FileNameArr(6) = 'SDCUSTXC'                              MD026854
     C                   EVAL      FileNameArr(7) = 'SDCRSHPD'                                CGL177
     C                   EVAL      FileNameArr(8) = 'SDCRSDPD'                                CGL177
     C                   EVAL      Index = 1                                                MD026666
                                                                                            MD026666
     C                   DOW       FileNameArr (Index) <> *BLANKS and                       MD026666
     C                             FileArrSize > Index                                      MD026666
                                                                                            MD026666
     C                   EVAL      PFileName = FileNameArr(Index)                           MD026666
                                                                                            MD026666
     C                   CALL      'UTRTVFLDD'                          55                  MD026666
     C                   PARM      *BLANKS       Prtcd                                      MD026666
     C                   PARM                    PFileName                                  MD026666
     C                   PARM      *BLANKS       PFieldsDesc                                MD026666
     C                   PARM      *ZEROS        PFieldsNum                                 MD026666
                                                                                            MD026666
     C                   IF        Prtcd = *BLANKS                                          MD026666
                                                                                            MD026666
     C                   EVAL      Idx = 0                                                  MD026666
     C                   EVAL      WPos = 0                                                 MD026666
     C                   CLEAR                   NFieldPosn                                 MD026666
     C                   CLEAR                   NFieldLen                                  MD026666
                                                                                            MD026666
     C                   DO        PFieldsNum                                               MD026666
     C                   EVAL      Idx = Idx + 1                                            MD026666
     C                   EVAL      NFieldPosn (Idx) = PFieldPosn (Idx)  + Wpos              MD026666
     C                   IF        PFieldType (Idx) = 'P'                                   MD026666
     C                   EVAL      NFieldLen  (Idx) = PFieldDigt (Idx)                      MD026666
     C                   EVAL      WPos = Wpos + PFieldDigt (Idx)                           MD026666
     C                                         - PFieldLen  (Idx)                           MD026666
     C                   ELSE                                                               MD026666
     C                   EVAL      NFieldLen  (Idx) = PFieldLen  (Idx)                      MD026666
     C                   ENDIF                                                              MD026666
     C                   ENDDO                                                              MD026666
                                                                                            MD026666
     C                   SELECT                                                             MD026666
                                                                                            MD026666
     C                   WHEN      PFilename = 'SDCUSTPD'                                   MD026666
     C                   EVAL      SdcustpdArr =  PFieldsDesc                               MD026666
     C                   EVAL      SdcustFNum  =  PFieldsNum                                MD026666
     C                   EVAL      SdcustPosnB =  NFieldPosn                                MD026666
     C                   EVAL      SdcustLenB  =  NFieldLen                                 MD026666
                                                                                            MD026666
     C                   WHEN      PFilename = 'SDACUSPD'                                   MD026666
     C                   EVAL      SdacuspdArr =  PFieldsDesc                               MD026666
     C                   EVAL      SdacusFNum  =  PFieldsNum                                MD026666
     C                   EVAL      SdacusPosnB =  NFieldPosn                                MD026666
     C                   EVAL      SdacusLenB  =  NFieldLen                                 MD026666
                                                                                            MD026666
     C                   WHEN      PFilename = 'SDFTCSPD'                                   MD026666
     C                   EVAL      SdftcspdArr =  PFieldsDesc                               MD026666
     C                   EVAL      SdftcsFNum  =  PFieldsNum                                MD026666
     C                   EVAL      SdftcsPosnB =  NFieldPosn                                MD026666
     C                   EVAL      SdftcsLenB  =  NFieldLen                                 MD026666
                                                                                            MD026666
     C                   WHEN      PFilename = 'SDJACCPD'                                   MD026666
     C                   EVAL      SdjaccpdArr =  PFieldsDesc                               MD026666
     C                   EVAL      SdjaccFNum  =  PFieldsNum                                MD026666
     C                   EVAL      SdjaccPosnB =  NFieldPosn                                MD026666
     C                   EVAL      SdjaccLenB  =  NFieldLen                                 MD026666
                                                                                            MD026666
     C                   WHEN      PFilename = 'SDCUAHPD'                                   MD026666
     C                   EVAL      SdcuahpdArr =  PFieldsDesc                               MD026666
     C                   EVAL      SdcuahFNum  =  PFieldsNum                                MD026666
     C                   EVAL      SdcuahPosnB =  NFieldPosn                                MD026666
     C                   EVAL      SdcuahLenB  =  NFieldLen                                 MD026666
                                                                                            MD026666
     C                   WHEN      PFilename = 'SDCUSTXC'                                   MD026854
     C                   EVAL      SdcuxcpdArr =  PFieldsDesc                               MD026854
     C                   EVAL      SdcuxcFNum  =  PFieldsNum                                MD026854
     C                   EVAL      SdcuxcPosnB =  NFieldPosn                                MD026854
     C                   EVAL      SdcuxcLenB  =  NFieldLen                                 MD026854
                                                                                              CGL177
     C                   WHEN      PFilename = 'SDCRSHPD'                                     CGL177
     C                   EVAL      SdcrshpdArr =  PFieldsDesc                                 CGL177
     C                   EVAL      SdcrshFNum  =  PFieldsNum                                  CGL177
     C                   EVAL      SdcrshPosnB =  NFieldPosn                                  CGL177
     C                   EVAL      SdcrshLenB  =  NFieldLen                                   CGL177
                                                                                              CGL177
     C                   WHEN      PFilename = 'SDCRSDPD'                                     CGL177
     C                   EVAL      SdcrsdpdArr =  PFieldsDesc                                 CGL177
     C                   EVAL      SdcrsdFNum  =  PFieldsNum                                  CGL177
     C                   EVAL      SdcrsdPosnB =  NFieldPosn                                  CGL177
     C                   EVAL      SdcrsdLenB  =  NFieldLen                                   CGL177
                                                                                            MD026854
     C                   ENDSL                                                              MD026666
                                                                                            MD026666
     C                   ENDIF                                                              MD026666
                                                                                            MD026666
     C                   EVAL      Index = Index + 1                                        MD026666
                                                                                            MD026666
     C                   ENDDO                                                              MD026666

      ** Check whether CGL157 is available                                                    CGL177
     C                   CALL      'AOSARDR0'                                                 CGL177
     C                   PARM      *Blanks       PRtcd                                        CGL177
     C                   PARM      '*VERIFY'     POptn                                        CGL177
     C                   PARM      'CGL157'      PSard                                        CGL177
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL177
                                                                                              CGL177
     C                   IF        PRtcd <> *Blanks                                           CGL177
     C                   IF        PRtcd <> '*NRF'                                            CGL177
     C     *LOCK         IN        LDA                                                        CGL177
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL177
     C                   EVAL      DBKEY  = PSard                                             CGL177
     C                   EVAL      DBASE  = 3                                                 CGL177
     C                   EVAL      DBPGM = 'SD009696'                                         CGL177
     C                   OUT       LDA                                                        CGL177
     C                   EXSR      *PSSR                                                      CGL177
     C                   ENDIF                                                                CGL177
     C                   EVAL      CGL157 = 'N'                                               CGL177
     C                   ELSE                                                                 CGL177
     C                   EVAL      CGL157 = 'Y'                                               CGL177
     C                   ENDIF                                                                CGL177

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA PDESC
Classification changed from 'xxxxx' to 'yyyyy'
US indicia changed
US indicia overridden
US indicia electronic search
Account review
Joint Account list changed
Miscellaneous change
FATCA Information Complete flag changed to 'x'
CRS indicia changed
CRS indicia electronic search
CRS Subject to Reporting Change
**CTDATA ##OV1                                                                              MD056982
OVRDBF FILE(SDCRSHL1) TOFILE(SDCRSHL1) SHARE(*NO)                                           MD056982
**CTDATA ##OV2                                                                              MD056982
DLTOVR FILE(SDCRSHL1)                                                                       MD056982