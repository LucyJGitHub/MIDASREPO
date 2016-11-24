     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Retrieve a record')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer ILE Module                            *
      *                                                               *
      *  FTOPAYR - FT Outgoing Payments retrieve a record             *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD039986           Date 10Aug16               *
      *  Prev Amend No. AR1090283          Date 10Aug16               *
      *                 CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 AR1067499          Date 12Dec12               *
      *                 AR870195           Date 11Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 GBO009             Date 14Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CER001             Date 25Apr05               *
      *                 BUG4196            Date 09Sep04               *
      *                 CFT118 (redeliver) Date 01Sep04               *
      *                 CFT118             Date 24Aug04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CAP084  *CREATE    Date 23Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039986 - Additional codes to upgrade AR1090283.            *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *           (Recompile)                                         *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  AR1067499 - Defaulted values of some OP fields are erroneous *
      *  AR870195 - IBAN account has been used for the settlement 1   *
      *             tab, however upon complete the Customer details   *
      *             were blanked out                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  GBO009 - Funds Transfer Outgoing Payment Reference           *
      *         - Added core hook: FTOPAYZC03.                        *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG4196- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts printing - Upgrade to Midasplus.      *
      *           (Redelivery) Added new field CQIN to the buffer.    *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts printing - Upgrade to Midasplus.      *
      *           Define Print Draft indicator added to buffer.       *
      *  CFT116 - Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:FTOPAYZC01,FTOPAYZD01,FTOPAYZC02   *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *                                                               *
      *****************************************************************
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
                                                                                              CER001
      **---------------------------------------------------------------                       CER001
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------                       CER001
 
      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------
 
     D NewPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * New Payment in Screen Format (Primary screen)
     D NewPmtSc1b    E DS                  EXTNAME(FTOPY1APD)
      ** New Payment in Screen Format (Primary Screen definition 2)
     D NewPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * New Payment in Screen Format (Charges/Commissions screen)
     D NewPmtSc3b    E DS                  EXTNAME(FTOPY5PD)
      ** New Payment in Screen Format (Lvl 2 Screen 3 definition 2)
     D NewPmtScn4    E DS                  EXTNAME(FTOPY6PD)
      ** New Payment in Screen Format (Lvl 2 Screen 4 Chrgs and Comms screen)
     D NewPmtScn5    E DS                  EXTNAME(FTOPY7PD)
      ** New Payment in Screen Format (Lvl 2 Screen 5 Stamp Tax Details)                      CER049
     D NewPmtScn6    E DS                  EXTNAME(FTOPY9PD)                                  CER049
      ** New Payment in Screen Format (Margin Information Screen)
     D NewPmtScnA    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
      ** New Payment in Screen 1 Format (Cover Message)                                       CSW209
     D NewPmtScnC    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
      ** New Payment in Screen 2 Format (Cover Message)                                       CSW209
 
      **--------------------------------------------------------------------------------------------
      ** FILE FORMATS
      **--------------------------------------------------------------------------------------------
 
     D CrPtFilFmt    E DS                  EXTNAME(OTPAYDD)
      * Current Payment in File Format
 
     D CrPtFilFmX    E DS                  EXTNAME(OTPAYXPD)
      ** Current Payment in File Format (Extension)
 
      **--------------------------------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **--------------------------------------------------------------------------------------------
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @NotDelAmt    E                     EXTFLD(@SNDAM)
     D @PayDelAmt    E                     EXTFLD(@SPDAM)
     D @PayAmount    E                     EXTFLD(@SPYAM)
     D @SettleAmt    E                     EXTFLD(@SSMAM)
      *                                                                                       CER030
      ** New DS for Extended Narrative Debit                                                  CER030
      *                                                                                       CER030
     D NewPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
      ** New DS for Extended Narrative Credit                                                 CER030
      *                                                                                       CER030
     D NewPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
 
      * Msg Unique Reference
     D SHMSGR          S              8  0
     D
      * Part Number
     D SHPART          S              3  0
 
     D PRetCodeIn      S             10                                                       CER001
     D PActn           S              1                                                       CER001
     D PFrontID        S             20                                                       CER001
     D PPayRef         S             15                                                       CER001
     D ULX043          S              1                                                       CER001
                                                                                              CER001
     D P_Ref_Ds        DS                                                                     CER001
     D  @@P                    1      1                                                       CER001
     D  @@Date                 2      7                                                       CER001
     D  @@P_Ref                8     11                                                       CER001
     D  @@OP                  12     13                                                       CER001
     D  @@Sett                14     15                                                       CER001
      **--------------------------------------------------------------------------------------------
      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13
 
     D POPAYExFilFmt E DS                  EXTNAME(FTOPX1PD)                                  CER001
     D                                     PREFIX(EX)                                         CER001
     D RegData       E DS                  EXTNAME(FTOPRXPD)                                  CER001
                                                                                              CER001
     D ExtData       E DS                  EXTNAME(FTOPEXPD)                                MD039986
                                                                                            MD039986
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * External DS for Funds Transfer details
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(#)
      * Switchable Features File
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSF011
      ** Second DS for Access Programs, Long Data Structure                                   CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CSF011
      ** External DS for Bank Details                                                         CSF011
     D WNumDetlIn      S           1000A                                                      CSF011
     D WAccntType      S             10A                                                      CSF011
     D WNumDetLn3      S           1000A                                                      CSF011
     D CusIdx          S              4S 0 INZ(1)                                             CSF011
     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
     D CusIdx3         S              4S 0 INZ(1)                                             CSF011
     D AccLength       S              2S 0 INZ(72)                                            CSF011
     D NoOfCusField    S              2S 0 INZ(10)                                            CSF011
     D P@TYP           S             10                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D P@Str2          S             35                                                       CSF011
     D P@Str3          S             35                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D W@ATyp          S              1                                                       CSF011
     D W@CCY           S              3                                                       CSF011
     D W@BRC           S              3                                                       CSF011
     D W@Slash         S              1                                                       CSF011
     D WAccName        S             20                                                      CSF011A
                                                                                              CSF011
     D MT110GEN        S              1                                                       CFT116
     D SMTCN           S              6                                                       CFT116
     D SCHQN           S              6                                                       CFT116
     D SCQIN           S              1                                                       CFT118
     D AAuth           S              1                                                     MD039986
     D/COPY WNCPYSRC,FTOPAYZD01
      **--------------------------------------------------------------------------------------------
 
     C                   CLEAR                   CrPtFilFmt
     C                   CLEAR                   CrPtFilFmX
     C                   Clear                   Val@Fields
 
      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT
 
     C                   Eval      @MBIN = WMBIN
 
 
      * Access SAR details file to determine if CEU006 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End
 
      ** Access SAR details file to see if CFT014 is installed.
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT014'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT014
     C                   Else
     C                   Movel     'N'           @CFT014
     C                   EndIf
 
      * Access SAR details file to determine if CFT009 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT009'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT009           1
     C                   Else
     C                   Movel     'N'           @CFT009
     C                   End
 
      * Access SAR details file to determine if CFT010 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT010'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT010           1
     C                   Else
     C                   Movel     'N'           @CFT010
     C                   End
 
      * Access SAR details file to determine if CFT003 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT003'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003           1
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End
                                                                                              CER001
      * Access SAR details file to determine if ULX043 is on.                                 CER001
                                                                                              CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   Parm      *BLANKS       @RTCD                                        CER001
     C                   Parm      '*VERIFY'     @OPTN                                        CER001
     C                   Parm      'ULX043'      @SARD                                        CER001
     C     SCSARD        Parm      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
      ** An NRF (No Record Found) return code is valid.                                       CER001
      ** Issue database error only for error return codes.                                    CER001
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS                                                    CER001
     C     @RTCD         ANDNE     '*NRF   '                                                  CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   Z-ADD     001           DBASE                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   If        @RTCD = *Blanks                                            CER001
     C                   Movel     'Y'           ULX043                                       CER001
     C                   Else                                                                 CER001
     C                   Movel     'N'           ULX043                                       CER001
     C                   End                                                                  CER001
 
      ** Get the action code from MidasPlus interface
     C                   EVAL      SACTION = DDACTN_In
 
     C     SACTION       IFEQ      *BLANK
     C                   MOVEL     'E'           SACTION
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      '1'           @Level            1
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      FTOPAYRED
     C                   ELSE
     C                   MOVEL     SPREF_In      @PRRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If no error message returned
      * and deal read
      *
     C     @ERRMS        IFEQ      *BLANK
     C     @PRRED        ANDNE     *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @PRRED        SPREF
     C                   EXSR      FTOPAYRTV
      *
      * Convert to screeen format
      *
     C                   EXSR      FTOPAYCVT
 
     C                   ENDIF
 
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   ENDIF
                                                                                              CSF011
      ** Populate Customer Name on Input fields                                               CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
 
     C                   MOVE      TMST          @TimeStamp       26                         BUG4196
     C                   MOVE      OPMSGR        PMSGR             8                          CSD083
     C                   MOVEL     RegData       RegData1          2                          CSF011
     C                   MOVE      RegData       RegData2         18                          CSF011
     C                   MOVEL     NewPmtScn6    NewPmtScn6A       9                        MD039986
     C                   MOVE      NewPmtScn6    NewPmtScn6B      11                        MD039986
     C                   EVAL                    Buffer = NewPmtScn1
     C                                           + NewPmtSc1b + NewPmtSc2a
     C                                           + NewPmtSc2b + NewPmtScn3
     C                                           + NewPmtSc3b + NewPmtScn4
     C                                           + NewPmtScn5
     C                                           + MT110GEN + SMTCN                           CFT116
     C**********                                 + SCHQN                               CFT116 CFT118
     C**********                                 + SCHQN + SCQIN                       CFT118 CFT118
     C                                           + SCHQN + SCQIN + CQIN                       CFT118
     C                                           + NewPmtScnA + NewPmtScnC                    CSW209
     C                                           + NewPmtScn5A                                CER030
     C                                           + NewPmtScn5B                                CER030
     C                                           + @TimeStamp                                BUG4196
     C                                           + PMSGR + OPORB1 + OPORB2                    CSD083
     C                                           + OPORB3 + OPORB4 + OPORB5                   CSD083
     C                                           + OPORBT                                     CSD083
     C**********                                 + NewPmtScn6                        CER049 MD039986
     C**********                                 + RegData                             CER001 CSF011
     C**********                                 + RegData1                          CSF011 MD039986
     C                                           + NewPmtScn6A                              MD039986
 
     C**********         EVAL      Buffer2 =  RegData2                               CSF011 MD039986
     C                   EVAL      Buffer2 = NewPmtScn6B + AAuth                            MD039986
     C                                       + BtnPressed                                   MD039986
     C                                       + RegData + ExtData                            MD039986
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                             CSF011A
      ** Initialise Customer Name on input fields                                            CSF011A
                                                                                             CSF011A
     C                   EVAL      DDD1SN = *BLANKS                                          CSF011A
     C                   EVAL      DDD1NM = *BLANKS                                          CSF011A
     C                   EVAL      DDD1TN = *BLANKS                                          CSF011A
     C                   EVAL      DDD1AN = *BLANKS                                          CSF011A
     C                   EVAL      DDD1SW = *BLANKS                                          CSF011A
     C                   EVAL      DDRCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDRCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDRCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDRCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDRCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDBCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDBCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDBCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDBCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDBCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDTRSN = *BLANKS                                          CSF011A
     C                   EVAL      DDTRNM = *BLANKS                                          CSF011A
     C                   EVAL      DDTRTN = *BLANKS                                          CSF011A
     C                   EVAL      DDTRAN = *BLANKS                                          CSF011A
     C                   EVAL      DDTRSW = *BLANKS                                          CSF011A
     C                   EVAL      DDABSN = *BLANKS                                          CSF011A
     C                   EVAL      DDABNM = *BLANKS                                          CSF011A
     C                   EVAL      DDABTN = *BLANKS                                          CSF011A
     C                   EVAL      DDABAN = *BLANKS                                          CSF011A
     C                   EVAL      DDABSW = *BLANKS                                          CSF011A
     C                   EVAL      DDOCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDOCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDOCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDOCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDOCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDOBSN = *BLANKS                                          CSF011A
     C                   EVAL      DDOBNM = *BLANKS                                          CSF011A
     C                   EVAL      DDOBTN = *BLANKS                                          CSF011A
     C                   EVAL      DDOBAN = *BLANKS                                          CSF011A
     C                   EVAL      DDOBSW = *BLANKS                                          CSF011A
     C                   EVAL      DDSCSN = *BLANKS                                          CSF011A
     C                   EVAL      DDSCNM = *BLANKS                                          CSF011A
     C                   EVAL      DDSCTN = *BLANKS                                          CSF011A
     C                   EVAL      DDSCAN = *BLANKS                                          CSF011A
     C                   EVAL      DDSCSW = *BLANKS                                          CSF011A
     C                   EVAL      DDIBSN = *BLANKS                                          CSF011A
     C                   EVAL      DDIBNM = *BLANKS                                          CSF011A
     C                   EVAL      DDIBTN = *BLANKS                                          CSF011A
     C                   EVAL      DDIBAN = *BLANKS                                          CSF011A
     C                   EVAL      DDIBSW = *BLANKS                                          CSF011A
     C                   EVAL      DDCDSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCDTN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDAN = *BLANKS                                          CSF011A
     C                   EVAL      DDCDSW = *BLANKS                                          CSF011A
                                                                                              CSF011
      ** Customer fields for retrieval of details                                             CSF011
                                                                                              CSF011
     C                   EVAL      W@ATyp = ' '                                             AR870195
     C                   EVAL      %SUBST(WNumDetlIn:1:70)   = SDST1 + SDST2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:70)  = SRCO1 + SRCO2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:141:70) = SBNC1 + SBNC2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:70) = STRI1 + STRI2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:70) = SACB1 + SACB2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:351:70) = SORBK                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:421:70) = SORC1 + SORC2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:491:70) = SSNCO                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:561:70) = SINB1 + SINB2                  CSF011
     C                   EVAL      %SUBST(WNumDetlIn:631:70) = SCDRO                          CSF011
                                                                                              CSF011
      ** Determine third line to identify account type with blank value                       CSF011
                                                                                              CSF011
     C                   EVAL      %SUBST(WNumDetLn3:1:35)   = SDST3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:36:35)  = SRCO3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:71:35)  = SBNC3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:106:35) = STRI3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:141:35) = SACB3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:176:35) = *BLANKS                        CSF011
     C                   EVAL      %SUBST(WNumDetLn3:211:35) = SORC3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:246:35) = *BLANKS                        CSF011
     C                   EVAL      %SUBST(WNumDetLn3:281:35) = SINB3                          CSF011
     C                   EVAL      %SUBST(WNumDetLn3:316:35) = *BLANKS                        CSF011
     C                                                                                        CSF011
      ** Customer fields for retrieval type indicator                                         CSF011
                                                                                              CSF011
     C**********         EVAL      %SUBST(WAccntType:1:10) = @DSTT + @RCRT           CSF011 AR870195
     C**********                   + @BNCT + @TRIT + @ACBT + @ORBT + @ORCT           CSF011 AR870195
     C**********                   + @SNCT + @INBT + @CDRT                           CSF011 AR870195
     C                   EVAL      %SUBST(WAccntType:1:10) = DSTT + RCRT                    MD039986
     C                             + BNCT + OPTRIT + ACBT + OPORBT + ORCT                   MD039986
     C                             + SNCT + INBT + CDRT                                     MD039986
                                                                                              CSF011
     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
                                                                                              CSF011
     C                   EVAL      WCustomer = *BLANKS                                     AR1067499
     C                   EVAL      WAccName  = *BLANKS                                     AR1067499
     C                   EVAL      W@Slash = 'N'                                              CSF011
     C**********         EVAL      W@ATyp = %SUBST(WAccntType:CusIdx:1)              CSF011 AR870195
     C                   EVAL      W@ATyp = %SUBST(WAccntType:CusIdx:1)                     MD039986
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
     C                   EVAL      P@Str2 = %SUBST(WNumDetlIn:CusIdx2+35:35)                  CSF011
     C                   EVAL      P@Str3 = %SUBST(WNumDetLn3:CusIdx3:35)                     CSF011
     C                   IF        %SUBST(P@Str:1:1) = '/'                                    CSF011
     C                   EVAL      W@Slash = 'Y'                                              CSF011
     C                   IF        P@Str2 <> *BLANKS                                          CSF011
     C                   EVAL      P@Str = P@Str2                                             CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      P@Str= %SUBST(P@Str:2:34)                                  CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C**********         IF        W@ATyp = *BLANKS                                  CSF011 AR870195
     C                   IF        W@ATyp = *BLANKS OR W@Atyp = 'A'                         MD039986
     C                   EVAL      W@Atyp = *BLANKS                                         MD039986
     C                   IF        (W@Slash = 'Y' AND P@Str3 <> *BLANKS)                      CSF011
     C                             OR (W@Slash = 'N' AND P@Str2 <> *BLANKS)                   CSF011
     C                   EVAL      W@ATyp = 'A'                                               CSF011
     C                   ENDIF                                                                CSF011
     C**********         ENDIF                                                       CSF011 AR870195
     C                   ENDIF                                                              MD039986
                                                                                              CSF011
     C                   IF        P@Str <> *BLANKS                                           CSF011
     C                             AND W@ATyp <> 'A'                                          CSF011
                                                                                              CSF011
     C                   CALL      'AOIBANR2'                                                 CSF011
     C                   PARM      *Blanks       @RTCD                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
     C                   EVAL      WAccName = AC_ANAM                                        CSF011A
                                                                                              CSF011
     C                   ELSE                                                                 CSF011
                                                                                              CSF011
      ** Format Full GL Account                                                               CSF011
      ** Format Partial Account                                                               CSF011
      ** Format Nostro Account                                                                CSF011
                                                                                              CSF011
     C                   EVAL      W@CCY = SSMCY                                              CSF011
     C                   EVAL      W@BRC = SORBB                                              CSF011
                                                                                              CSF011
     C                   IF        CusIdx = 8 AND SPCCY <> *BLANKS                            CSF011
     C                   EVAL      W@CCY = SPCCY                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        CusIdx = 10                                                CSF011
                                                                                              CFT120
     C                   IF        CFT120 = 'N'                                               CFT120
     C                   EVAL      W@CCY = BJCYCD                                             CSF011
     C                   ELSE                                                                 CFT120
     C                   EVAL      W@CCY = SCDRC                                              CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT120
     C                   EVAL      W@BRC = SCDBR                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 24                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:22:3)                                 CSF011
     C                             + %SUBST(P@Str:1:21)                                       CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 21                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +                               CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                    CSF011
     C                   EVAL      P@Str = W@BRC +                                            CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                     CSF011
     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)                          CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
      ** Retrieve Account Details, Customer Report Name,                                      CSF011
      ** and Town, Account Name and Swift ID                                                  CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
     C                             P@TYP = '*LEDGER'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
     C                   EVAL      WAccName = AC_ANAM                                        CSF011A
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = A7CUST                                         CSF011
     C                   CALL      'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      *BLANKS       P0RETL                                       CSF011
     C                   PARM                    A7CUST                                       CSF011
     C                   PARM                    A7CYCD                                       CSF011
     C                   PARM                    A7ACCD                                       CSF011
     C                   PARM                    A7ACSN                                       CSF011
     C                   PARM                    A7BRCD                                       CSF011
     C     ACCNT         PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD =  *BLANKS                                           CSF011
     C                   EVAL      WAccName = AC_ANAM                                        CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
     C                             P@TYP = '*SHNAME'                                          CSF011
                                                                                              CSF011
     C                   EVAL      SDCUST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   EVAL      WAccName = *BLANKS                                        CSF011A
     C                   WHEN      P@TYP = '*NRF   '                                          CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   EVAL      WAccName = *BLANKS                                        CSF011A
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                      CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
                                                                                             CSF011A
     C                   SELECT                                                              CSF011A
                                                                                             CSF011A
      ** Destination                                                                         CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   EVAL      DDD1SN = BBCSSN                                           CSF011A
     C                   EVAL      DDD1NM = BBCRNM                                           CSF011A
     C                   EVAL      DDD1TN = BBCRTN                                           CSF011A
     C                   EVAL      DDD1AN = WAccName                                         CSF011A
     C                   EVAL      DDD1SW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Receivers correspondent                                                             CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   EVAL      DDRCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDRCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDRCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDRCAN = WAccName                                         CSF011A
     C                   EVAL      DDRCSW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Beneficiary                                                                         CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   EVAL      DDBCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDBCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDBCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDBCAN = WAccName                                         CSF011A
     C                   EVAL      DDBCSW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Third Reimbursement Institution                                                     CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   EVAL      DDTRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDTRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDTRTN = BBCRTN                                           CSF011A
     C                   EVAL      DDTRAN = WAccName                                         CSF011A
     C                   EVAL      DDTRSW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Account with Bank                                                                   CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   EVAL      DDABSN = BBCSSN                                           CSF011A
     C                   EVAL      DDABNM = BBCRNM                                           CSF011A
     C                   EVAL      DDABTN = BBCRTN                                           CSF011A
     C                   EVAL      DDABAN = WAccName                                         CSF011A
     C                   EVAL      DDABSW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C**********         EVAL      DDOCSN = BBCSSN                                 CSF011A AR1067499
     C**********         EVAL      DDOCNM = BBCRNM                                 CSF011A AR1067499
     C**********         EVAL      DDOCTN = BBCRTN                                 CSF011A AR1067499
     C**********         EVAL      DDOCAN = WAccName                               CSF011A AR1067499
     C**********         EVAL      DDOCSW = BBCSID                                 CSF011A AR1067499
     C                   EVAL      DDOBSN = BBCSSN                                         AR1067499
     C                   EVAL      DDOBNM = BBCRNM                                         AR1067499
     C                   EVAL      DDOBTN = BBCRTN                                         AR1067499
     C                   EVAL      DDOBAN = WAccName                                       AR1067499
     C                   EVAL      DDOBSW = BBCSID                                         AR1067499
                                                                                             CSF011A
      ** Ordering Customer                                                                   CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C**********         EVAL      DDOBSN = BBCSSN                                 CSF011A AR1067499
     C**********         EVAL      DDOBNM = BBCRNM                                 CSF011A AR1067499
     C**********         EVAL      DDOBTN = BBCRTN                                 CSF011A AR1067499
     C**********         EVAL      DDOBAN = WAccName                               CSF011A AR1067499
     C**********         EVAL      DDOBSW = BBCSID                                 CSF011A AR1067499
     C                   EVAL      DDOCSN = BBCSSN                                         AR1067499
     C                   EVAL      DDOCNM = BBCRNM                                         AR1067499
     C                   EVAL      DDOCTN = BBCRTN                                         AR1067499
     C                   EVAL      DDOCAN = WAccName                                       AR1067499
     C                   EVAL      DDOCSW = BBCSID                                         AR1067499
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   EVAL      DDSCSN = BBCSSN                                           CSF011A
     C                   EVAL      DDSCNM = BBCRNM                                           CSF011A
     C                   EVAL      DDSCTN = BBCRTN                                           CSF011A
     C                   EVAL      DDSCAN = WAccName                                         CSF011A
     C                   EVAL      DDSCSW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Intermediary Bank                                                                   CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   EVAL      DDIBSN = BBCSSN                                           CSF011A
     C                   EVAL      DDIBNM = BBCRNM                                           CSF011A
     C                   EVAL      DDIBTN = BBCRTN                                           CSF011A
     C                   EVAL      DDIBAN = WAccName                                         CSF011A
     C                   EVAL      DDIBSW = BBCSID                                           CSF011A
                                                                                             CSF011A
      ** Charges to the Debit of Account                                                     CSF011A
                                                                                             CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   EVAL      DDCDSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCDNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCDTN = BBCRTN                                           CSF011A
     C                   EVAL      DDCDAN = WAccName                                         CSF011A
     C                   EVAL      DDCDSW = BBCSID                                           CSF011A
     C                   ENDSL                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Increment counter fields                                                             CSF011
                                                                                              CSF011
     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
     C                   EVAL      CusIdx2 = Cusidx2 + 70                                     CSF011
     C                   EVAL      CusIdx3 = Cusidx3 + 35                                     CSF011
                                                                                              CSF011
     C                   CLEAR                   SDCUST                                      CSF011A
                                                                                             CSF011A
     C                   ENDDO                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    FwdBck            1
     C                   PARM                    SPREF_In         15
     C                   PARM                    DDACTN_In         1
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2        3999                          CSF011
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C                   PARM                    BtnPressed       10                       AR1090283
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C/COPY WNCPYSRC,FTH00481
 
      ** Access Bank details via access program                                               CSF011
                                                                                              CSF011
     C                   CALL      'AOBANKR0'                                                 CSF011
     C                   PARM      '*DBERR '     @RTCD                                        CSF011
     C                   PARM      '*FIRST '     @OPTN                                        CSF011
     C     SDBANK        PARM      SDBANK        DSFDY                                        CSF011
                                                                                              CSF011
      * Access Funds Transfer details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOFTFRR0'
     C                   Parm      '*DBERR'      @RTCD             7
     C                   Parm      '*FIRST'      @OPTN             7
     C     SDFTFR        Parm      SDFTFR        DSFDY
 
     C/COPY WNCPYSRC,FTOPAYZC02
 
      * Access SAR details file to determine if CEU006 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End
 
      ** Access SAR details file to see if CFT014 is installed.
 
     C                   CallB     'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT014'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT014
     C                   Else
     C                   Movel     'N'           @CFT014
     C                   EndIf
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTOPAYM01
 
      ** Access SAR file to determine if CFT120 is switched on                                CFT120
      *                                                                                       CFT120
     C                   MOVEL     'N'           CFT120            1                          CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** If return code <> *NRF, call program exception error routine                         CFT120
      *                                                                                       CFT120
     C                   If        @RTCD <> *BLANKS AND                                       CFT120
     C                             @RTCD <> '*NRF'                                            CFT120
     C     *LOCK         IN        LDA                                                        CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 002                                                CFT120
     C                   OUT       LDA                                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT120
     C                   ENDSR
 
      **********************************************************************
     C     FTOPAYRED     BEGSR
 
     C                   CALLB     'FTOPAYRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut       10
      *
      * Action Code
     C                   PARM                    SACTION
      *
      * Payment REF.
     C                   PARM      SPREF_In      SPREF            15
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Payment REF. READ
     C                   PARM      *BLANK        @PRRED           15
 
     C                   ENDSR
      **********************************************************************
     C     FTOPAYRTV     BEGSR
 
     C                   CALLB     'FTOPAYRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    SACTION
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Payment Reference
     C                   PARM                    SPREF
      * Booking branch
     C                   PARM                    SBRCA             3
      * Level 1/2 indicator
     C                   PARM                    @Level            1
      * @CFT014 workfield
     C                   PARM                    Val@Fields
 
      * OUTPUTS :
      * (Current) Payment in file format
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX
      * OK - Action code
     C                   PARM      *BLANK        OKACTION          1
      * OK - Payment Reference
     C                   PARM      *BLANK        OKPREF            1
      * OK - Booking branch
     C                   PARM                    OKBRCA            1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C/COPY WNCPYSRC,FTOPAYZC03
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CALLB     'FTOPAY3RV'                                                CER001
     C                   PARM                    PRetCodeIn                                   CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PFrontID                                     CER001
     C                   PARM      SPREF         P_Ref_Ds                                     CER001
     C                   PARM                    POPAYExFilFmt                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,FTOPAYZC01
 
     C                   ENDSR
      **********************************************************************
     C     FTOPAYCVT     BEGSR
 
     C                   CALLB     'FTOPAYCVT'
      *
      * INPUTS :
      * Return Code
      * Payment in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX
 
      * OUTPUTS
      * Payment - screen formats
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc3b
     C                   PARM                    NewPmtScn4
     C                   PARM                    NewPmtScn5
     C                   PARM                    NewPmtScnA                                   CSW209
     C                   PARM                    NewPmtScnC                                   CSW209
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    SDFTFR
 
      *  Validation Work Fields
     C                   PARM                    Val@Fields
 
      * Payment Status
     C                   PARM                    DDSTAT           24
      *
      * Msg Unique Reference
     C                   PARM                    SHMSGR
      * Part Number
     C                   PARM                    SHPART
     C                   PARM                    BtnPressed                                AR1090283
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CALLB     'FTOPAY2CT'                                                CER001
     C                   PARM                    PRetCodeIn                                   CER001
     C                   PARM                    POPAYExFilFmt                                CER001
     C                   PARM                    RegData                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
 
     C                   ENDSR
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
      ** The following /COPY contains the standard program status                             CER001
      ** subroutine, including a bound call to the DBERRCTL module.                           CER001
      *                                                                                       CER001
      /COPY ZACPYSRC,PSSR_ILE
      *                                                                                       CER001
      **********************************************************************
