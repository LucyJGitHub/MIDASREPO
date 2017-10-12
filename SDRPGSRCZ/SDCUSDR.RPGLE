     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer details retrieve')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUSDR   - SD Customer Details retrieve a record            *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD041996           Date 12Oct15               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CER071             Date 01Aug16               *
      *                 AR316373           Date 03Jun15               *
      *                 CER070             Date 19Aug14               *
      *                 CSW214             Date 25Nov14               *
      *                 CGL132             Date 01May13               *
      *                 MD022463           Date 27Sep13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD021813           Date 28Aug13               *
      *                 AR1086546          Date 14Jun13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER049             Date 06Dec10               *
      *                 CSD090             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23518           Date 30Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21091           Date 25Sep08               *
      *                 256564             Date 17Sep08               *
      *                 BUG15872           Date 12Feb08               *
      *                 BUG14929           Date 01Oct07               *
      *                 BUG14485           Date 31Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13525           Date 05Mar07               *
      *                 BG12216            Date 17Oct06               *
      *                 CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD028             Date 22Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5870            Date 14Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5082            Date 13Dec04               *
      *                 BUG4452            Date 05Oct04               *
      *                 BUG4196            Date 08Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 222373             Date 24Oct03               *
      *                 CAP084  *CREATE    Date 08Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041996 - Incorrect mapping for FX Netting                  *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  AR316373 - BOE @ MPlus - BOE cust dtls are not displayed in  *
      *             java wrapped function. Retrieve the details from  *
      *             BYCUSTX0 to be passed to java.                    *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CSW214 - SWIFT Changes 2014 (Recompile)                      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  MD022463 - No screen is displayed to show Bank Directory     *
      *             Plus Detail Screen on Linked Customers during     *
      *             Amend and Enquire                                 *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD021813 - BankFusion_FX Netting:CDL025 Missing Menu Options *
      *  AR1086546 - Upgrade of CDL025 to MP 1.4 (Child: AR1086547).  *
      *              Applied for MD021813                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER049 - Stamp Tax                                           *
      *  CSD090 - Customer Segmentation (Recompile)                   *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG21091 - Error occurs when encoding "SWIFT" in the default *
      *             network                                           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15872 - Parameter mismatch. Applied fix BUG14992          *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *  BUG14929 - Error in Customer Details update                  *
      *  BUG14485 - MidasPlus Definition for CUSD is not in synch     *
      *             with that of API XML definition.                  *
      *             Applied fixes are BUG14228 & 243781               *
      *  BUG13525 - ECSD Mismatch between XML and RPG (Recompile)     *
      *  BG12216 - Global customer reference is lost on writing       *
      *            wholesale customer                                 *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5870- Extension data processing added.                    *
      *           Remove hook SDCUSDM01.                              *
      *           Add hook SDCUSDT01.                                 *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5082- Fix to BUG3362                                      *
      *  BUG4452- Property button displays blank fields for customer  *
      *           details                                             *
      *  BUG4196- Stop changes being overwrite by other users         *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP084 - Java wrapper project                                *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      /COPY WNCPYSRC,SDCUSDT03

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** SCREEN FORMATS
      **--------------------------------------------------------------------------------------------

      * New Customer in Screen Format - Primary Details
     D NewCuPrim     E DS                  EXTNAME(SDCUPRPD)

      * New Customer in Screen Format - Base Rate Tax Details
     D NewCuBrt      E DS                  EXTNAME(SDCUBRPD)

      * New Customer in Screen Format - Private Banking Details
     D NewCuPriv     E DS                  EXTNAME(SDCUPBPD)
                                                                                            BUG15872
     D CuSwft        E DS                  EXTNAME(SDCUSWPD)                                BUG15872

      * New Customer in Screen Format - Secondary Details
     D NewCuSeco     E DS                  EXTNAME(SDCUSEPD)

      * New Customer in Screen Format - Message Details
     D NewCuMsg      E DS                  EXTNAME(SDCUMRPD)

      ** New Customer in Screen Format - MT3xx BEI Details
     D NewCuMT3x     E DS                  EXTNAME(SDCUMTPD)

      ** New Customer in Screen Format - Extension Details                                   BUG5870
     D ExtData       E DS                  EXTNAME(SDCUEXPD)                                 BUG5870
                                                                                             BUG5870
     D NewCuCumi     E DS                  EXTNAME (SDCUMIPD)                                 CSD079
     D                                     PREFIX(MI)                                         CSD079
     D NewCuCuad     E DS                  EXTNAME (SDCUADPD)                                 CSD079
     D                                     PREFIX(AD)                                         CSD079
     D NewCuACU3     E DS                  EXTNAME (SDACU3DPD)                                CER059
     D                                     PREFIX (AD3)                                       CER059
     D NewCuACU4     E DS                  EXTNAME (SDACU4DPD)                                CER059
     D                                     PREFIX (AD4)                                       CER059
     D NewCuCUAH     E DS                  EXTNAME (SDCUAHDPD)                                CER059
     D                                     PREFIX(AH)                                         CER059
     D NewCuCCTX     E DS                  EXTNAME (SDCCTXDPD)                                CER059
     D NewCuSfee     E DS                  EXTNAME (SDSFEEPD)                                 CSD079
     D FE_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuChec     E DS                  EXTNAME (SDCHECPD)                                 CSD079
     D CH_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuCusf     E DS                  EXTNAME (SDCUSFPD)                                 CSD079
     D US_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuCufx     E DS                  EXTNAME (SDCUFXPD)                                 CSD079
     D FX_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuCufd     E DS                  EXTNAME (SDCUFDPD)                                 CSD079
     D FD_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuRwan     E DS                  EXTNAME (SDRWANPD)                                 CSD079
     D                                     PREFIX(RW)                                         CSD079
     D NewCuCufo     E DS                  EXTNAME (SDCUFOPD)                                 CSD079
     D FO_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D FO_DDSMAC     E                     EXTFLD(DDSMAC)                                     CSD079
     D NewCuCupm     E DS                  EXTNAME (SDCUPMPD)                                 CSD079
     D PM_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuTicd     E DS                  EXTNAME (SDTICDPD)                                 CSD079
     D TI_DDACTN     E                     EXTFLD(DDACTN)                                     CSD079
     D NewCuCurx     E DS                  EXTNAME (SDCURXPD)                                 CSD079
     D NewCuCtnm     E DS                  EXTNAME (SDCCTNPD)                              AR1086546
     D                                     PREFIX(T_)                                      AR1086546
      ** Customer dtls Bank directory plus detail                                             CSW213
     D CuSW13        E DS                  EXTNAME(SDSW13PD)                                  CSW213
     D  SW13DDBRCD   E                     EXTFLD(DDBRCD)                                     CSW213
                                                                                              CSD079
                                                                                              CGL132
      ** Customer details extension file                                                      CGL132
     D CuCUXC        E DS                  EXTNAME(SDCUXCPD)                                  CGL132
                                                                                              CGL132
      ** FATCA Customer details extension file                                                CGL132
     D CuFTCR        E DS                  EXTNAME(SDFTCRPD)                                  CGL132
      **-------------------------------------------------------------------------------------
      ** FILE FORMATS
      **-------------------------------------------------------------------------------------

      * Current Customer in File Format
     D CrCuFilFmt    E DS                  EXTNAME(SDCUSTPD)
     D                                     PREFIX(C_)

      * Current Customer in File Format - Base Rate Tax Details
     D CrBrFilFmt    E DS                  EXTNAME(SDCBRTPD)
     D                                     PREFIX(C_)

      * Current Customer in File Format - Private Banking Details
     D CrPBFilFmt    E DS                  EXTNAME(SDVCUPBPD)
     D                                     PREFIX(C_)
      *                                                                                      BUG5082
     D CrTIFilFmt    E DS                  EXTNAME(SDVTICDPD)                                BUG5082
     D                                     PREFIX(C_)                                        BUG5082
                                                                                             BUG5082
      ** Global Customer X-Reference - File Format                                            222373
     D GCustFilFmt   E DS                  EXTNAME(GPCUSTXPD)                                 222373

      ** Marketing Information                                                                CSD079
     D CumiFilFmt    E DS                  EXTNAME(SDCMRKPD)                                  CSD079
                                                                                              CSD079
      ** Additional Customer                                                                  CSD079
     D CuadFilFmt    E DS                  EXTNAME(SDACUSPD)                                  CSD079
                                                                                              CSD079
      ** Service Fees                                                                         CSD079
     D SfeeFilFmt    E DS                  EXTNAME(SDCFCDPD)                                  CSD079

      ** Cheques and Card Details                                                             CSD079
     D ChecFilFmt    E DS                  EXTNAME(SDCHEQPD)                                  CSD079
                                                                                              CSD079
      ** Safe Details                                                                         CSD079
     D CusfFilFmt    E DS                  EXTNAME(SDSAFEPD)                                  CSD079
                                                                                              CSD079
      ** Risk Weighted Assets                                                                 CSD079
     D RwanFilFmt    E DS                  EXTNAME(SDCRWAPD)                                  CSD079
                                                                                              CSD079
      ** Future and Options                                                                   CSD079
     D CufoFilFmt    E DS                  EXTNAME(SDFOCSPD)                                  CSD079
     D Q1SMAC        E                     EXTFLD(QQSMAC)                                     CSD079
     D CufnFilFmt    E DS                  EXTNAME(SDFOX1PD)                                  CSD079
                                                                                              CSD079
      ** Portfolio Management                                                                 CSD079
     D CupmFilFmt    E DS                  EXTNAME(SDPLCSPD)                                  CSD079
                                                                                              CSD079
      ** Lux(European Reporting) in file format                                               CSD079
     D CueuFilFmt    E DS                  EXTNAME(SDCUX2PD)                                  CSD079
                                                                                              CSD079
      ** Lux(IBLC - Extended Information) in file format                                      CSD079
     D CuibfFilFmt   E DS                  EXTNAME(SDCUX1PD)                                  CSD079
                                                                                              CSD079
      ** Currency/Time of Netting Details                                                  AR1086546
     D*CtnmFilFmt    E DS                  EXTNAME(SDCTNMPD)                      AR1086546 MD021813
     D CtnmFilFmt    E DS                  EXTNAME(SDVCTNMPD)                               MD021813
      ** Customer Ext in File Format                                                          CGL132
     D CuXcFilFmt    E DS                  EXTNAME(SDCUSTXC)                                  CGL132
                                                                                              CGL132
      ** FATCA Customer Details in file format                                                CGL132
     D CuFaFilFmt    E DS                  EXTNAME(SDFTCSPD)                                  CGL132
                                                                                              CGL132
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR RETAIL TABLE FILE

      ** SWIFT Details in File Format                                                       BUG14929
     D SwftFilFmt    E DS                  EXTNAME(SDCSSWPD)                                BUG14929
                                                                                            BUG14929
      ** Midas SD BOE Customer Details in File Format                                       AR316373
      *                                                                                     AR316373
     D CusdExFilFmt  E DS                  EXTNAME(BYCUSTX0)                                AR316373
      *                                                                                     AR316373
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      **--------------------------------------------------------------------------------------------

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
     D PTransType      S              4                                                       CSD028
     D***FillerBuf       S           5276A                                           CSW213 MD041996
     D FillerBuf       S           5096A                                                    MD041996
     D***FillerBufEx2    S           8951A                                             CSW213 CGL132
     D FillerBufEx2    S           5980A                                                      CGL132
     D FillerBufEx3    S           9999A                                                      CSW213
     D***FillerBufEx4    S           6898A                                           CSW213 MD041996
     D FillerBufEx4    S           5974A                                                    MD041996
     D NewCuCtnm1      S              8A                                                    MD041996
     D NewCuCtnm2      S            110A                                                    MD041996

      ** Stamp Tax details                                                                    CER049
     DTranStamp        S             31A                                                      CER049
                                                                                              CER049
      **--------------------------------------------------------------------------------------------

     C                   CLEAR                   CrCuFilFmt
     C                   CLEAR                   CrBrFilFmt
     C                   CLEAR                   CrPBFilFmt
     C                   CLEAR                   CuXcFilFmt                                   CGL132
     C                   CLEAR                   CuFaFilFmt                                   CGL132
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
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

     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SDCUSDRED
     C                   ELSE
     C                   MOVEL     DDCUSN_In     @CURED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read
      * and no error message returned
      *
     C     @CURED        IFNE      *BLANK
     C     @ERRMS        ANDEQ     *BLANK
      *
      * Retrieve deal details
      *
     C                   MOVEL     @CURED        DDCUSN
     C                   EXSR      SDCUSDRTV
      *                                                                                     AR316373
      ** Retrieve customer details BOE if LLN007 is ON                                      AR316373
      *                                                                                     AR316373
     C     LLN007        IFEQ      'Y'                                                      AR316373
     C                   EXSR      SDCUSDRTV1                                               AR316373
     C                   ENDIF                                                              AR316373
      *                                                                                     AR316373
      /COPY WNCPYSRC,SDCUSDT02
      *
      * Convert to screeen format
      *
     C     Idx           IFEQ      0
     C                   EXSR      SDCUSDCVT
      *                                                                                     AR316373
      ** Convert to screen format the details if LLN007 is ON                               AR316373
      *                                                                                     AR316373
     C     LLN007        IFEQ      'Y'                                                      AR316373
     C                   EXSR      SDCUSDCVT1                                               AR316373
     C                   ENDIF                                                              AR316373
      *                                                                                     AR316373
     C                   ENDIF

     C                   ENDIF

     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDCUSN'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF

     C                   MOVE      C_BBTMST      @TimeStamp       26                         BUG4196
     C                   EVAL      NewCuCtnm1 = %SUBST(NewCuCtnm:1:8)                       MD041996
     C                   EVAL      NewCuCtnm2 = %SUBST(NewCuCtnm:9)                         MD041996
     C                   EVAL                    Buffer = NewCuPrim
     C**********                                 + NewCuSeco + NewCuMsg                     BUG21091
     C                                           + NewCuSeco                                BUG21091
     C                                           + NewCuMT3x                                BUG21091
     C                                           + NewCuMsg                                 BUG21091
     C                                           + NewCuBrt + NewCuPriv
     C**********                                 + NewCuMT3x                       BUG14485 BUG21091
     C                                           + NewCuCumi                                  CSD079
     C                                           + NewCuCuad                                  CSD079
     C                                           + NewCuACU3                                  CER059
     C                                           + NewCuACU4                                  CER059
     C                                           + NewCuSfee                                  CSD079
     C                                           + NewCuChec                                  CSD079
     C                                           + NewCuCusf                                  CSD079
     C                                           + NewCuCufx                                  CSD079
     C                                           + NewCuCufd                                  CSD079
     C                                           + NewCuCufo                                  CSD079
     C                                           + NewCuCupm                                  CSD079
     C                                           + NewCuTicd                                  CSD079
     C                                           + CuSwft                                   BUG14992
     C                                           + NewCuCurx                                  CSD079
     C                                           + @TimeStamp                                BUG4196
     C                                           + NewCuRwan                                  CSD079
     C                                           + TranStamp                                  CER049
     C                                           + NewCuCtnm1                               MD041996
     C                                           + AuthComp                                   CER059
     C                                           + FillerBuf                                  CSW213
     C**********                                 + NewCuCUAH                           CER059 CSW213
     C**********                                 + NewCuCCTX                           CER059 CSW213
     C**********                                 + NewCuCtnm                      AR1086546 MD041996
     C**********                                 + ExtData                            BUG5870 CSW213
     C                   EVAL      BufferEx2 = CuSW13                                         CSW213
     C                                       + CuCUXC                                         CGL132
     C                                       + CuFTCR                                         CGL132
     C                                       + FillerBufEx2                                   CSW213
                                                                                              CSW213
     C                   EVAL      BufferEx3 = FillerBufEx3                                   CSW213
                                                                                              CSW213
     C                   EVAL      BufferEx4 = NewCuCUAH                                      CSW213
     C                                       + NewCuCCTX                                      CSW213
     C                                       + NewCuCtnm2                                   MD041996
     C                                       + ExtData                                      MD041996
     C                                       + FillerBufEx4                                   CSW213

     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
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
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCUSN_In         6
     C**********         PARM                    Buffer         6000                          CER059
     C                   PARM                    Buffer         9999                          CER059
     C                   PARM                    BufferEx2      9999                          CSW213
     C                   PARM                    BufferEx3      9999                          CSW213
     C                   PARM                    BufferEx4      9999                          CSW213
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1

      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SDUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'Y2USRMSG'
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if S01383 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVEL     'S01383'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   ELSE
     C                   MOVEL     'N'           S01383
     C                   END
      *                                                                                      BUG4452
      ** Access SAR details file to determine if CLE025 is on.                               BUG4452
      *                                                                                      BUG4452
     C                   CALLB     'AOSARDR0'                                                BUG4452
     C                   PARM      *BLANKS       @RTCD                                       BUG4452
     C                   PARM      '*VERIFY'     @OPTN                                       BUG4452
     C                   PARM      'CLE025'      @SARD                                       BUG4452
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG4452
      *                                                                                      BUG4452
      ** Database Error                                                                      BUG4452
      *                                                                                      BUG4452
     C     @RTCD         IFNE      *BLANKS                                                   BUG4452
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG4452
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG4452
     C                   Z-ADD     11            DBASE                                       BUG4452
     C                   MOVEL     'CLE025'      DBKEY                                       BUG4452
     C                   EXSR      *PSSR                                                     BUG4452
     C                   ENDIF                                                               BUG4452
      **                                                                                     BUG4452
     C     @RTCD         IFEQ      *BLANK                                                    BUG4452
     C                   MOVEL     'Y'           CLE025            1                         BUG4452
     C                   ELSE                                                                BUG4452
     C                   MOVEL     'N'           CLE025                                      BUG4452
     C                   ENDIF                                                               BUG4452
      *                                                                                      BUG4452
      ** Access SAR details file to determine if CFX001 is on.                               BUG4452
      *                                                                                      BUG4452
     C                   CALLB     'AOSARDR0'                                                BUG4452
     C                   PARM      *BLANKS       @RTCD                                       BUG4452
     C                   PARM      '*VERIFY'     @OPTN                                       BUG4452
     C                   PARM      'CFX001'      @SARD                                       BUG4452
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG4452
      *                                                                                      BUG4452
      ** Database Error                                                                      BUG4452
      *                                                                                      BUG4452
     C     @RTCD         IFNE      *BLANKS                                                   BUG4452
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG4452
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG4452
     C                   Z-ADD     12            DBASE                                       BUG4452
     C                   MOVEL     'CFX001'      DBKEY                                       BUG4452
     C                   EXSR      *PSSR                                                     BUG4452
     C                   ENDIF                                                               BUG4452
      **                                                                                     BUG4452
     C     @RTCD         IFEQ      *BLANK                                                    BUG4452
     C                   MOVEL     'Y'           CFX001            1                         BUG4452
     C                   ELSE                                                                BUG4452
     C                   MOVEL     'N'           CFX001                                      BUG4452
     C                   ENDIF                                                               BUG4452
      *                                                                                      BG12216
      ** Access SAR details file to determine if CGP001 is on.                               BG12216
      *                                                                                      BG12216
     C                   CALLB     'AOSARDR0'                                                BG12216
     C                   PARM      *BLANKS       @RTCD                                       BG12216
     C                   PARM      '*VERIFY'     @OPTN                                       BG12216
     C                   PARM      'CGP001'      @SARD                                       BG12216
     C     SCSARD        PARM      SCSARD        DSFDY                                       BG12216
      *                                                                                      BG12216
      ** Database Error                                                                      BG12216
      *                                                                                      BG12216
     C     @RTCD         IFNE      *BLANKS                                                   BG12216
     C     @RTCD         ANDNE     '*NRF   '                                                 BG12216
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BG12216
     C                   Z-ADD     13            DBASE                                       BG12216
     C                   MOVEL     'CGP001'      DBKEY                                       BG12216
     C                   EXSR      *PSSR                                                     BG12216
     C                   ENDIF                                                               BG12216
      **                                                                                     BG12216
     C     @RTCD         IFEQ      *BLANK                                                    BG12216
     C                   MOVEL     'Y'           CGP001            1                         BG12216
     C                   ELSE                                                                BG12216
     C                   MOVEL     'N'           CGP001                                      BG12216
     C                   ENDIF                                                               BG12216
      *                                                                                     AR316373
      ** Access SAR details file to determine if LLN007 is on.                              AR316373
      *                                                                                     AR316373
     C                   CALLB     'AOSARDR0'                                               AR316373
     C                   PARM      *BLANKS       @RTCD                                      AR316373
     C                   PARM      '*VERIFY'     @OPTN                                      AR316373
     C                   PARM      'LLN007'      @SARD                                      AR316373
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR316373
      *                                                                                     AR316373
      ** Database Error                                                                     AR316373
      *                                                                                     AR316373
     C     @RTCD         IFNE      *BLANKS                                                  AR316373
     C     @RTCD         ANDNE     '*NRF   '                                                AR316373
     C                   MOVEL     'SCSARDPD'    DBFILE                                     AR316373
     C                   Z-ADD     14            DBASE                                      AR316373
     C                   MOVEL     'LLN007'      DBKEY                                      AR316373
     C                   EXSR      *PSSR                                                    AR316373
     C                   ENDIF                                                              AR316373
      *                                                                                     AR316373
     C     @RTCD         IFEQ      *BLANK                                                   AR316373
     C                   MOVEL     'Y'           LLN007            1                        AR316373
     C                   ELSE                                                               AR316373
     C                   MOVEL     'N'           LLN007                                     AR316373
     C                   ENDIF                                                              AR316373

      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SDCUSDT01

     C                   ENDSR

      **********************************************************************
      /EJECT
      **********************************************************************
     C     SDCUSDRED     BEGSR

     C                   CALLB     'SDCUSDRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut       10
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * CUSTO REF. POINTER
     C                   PARM                    DDCUSN
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
      * CUSTO REF. READ
     C                   PARM      *BLANK        @CURED            6

     C                   ENDSR
      **********************************************************************
     C     SDCUSDRTV     BEGSR

     C                   CALLB     'SDCUSDRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeIn        10
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      *BLANK        ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    C_BBFRNT
      *
      * (Midas) Trade Reference
     C                   PARM                    DDCUSN
      * Base Rate Auth Req                                                                    222373
     C                   PARM                    AUTHRQ            1                          222373
      * Authorisation Mode                                                                    222373
     C                   PARM                    AUTHMD            1                          222373
      *
      *  Base Rate Tax option feature is switched on
     C                   PARM                    S01383
      *  Private Banking Customer module is switched on
     C                   PARM                    BGN4ST
      ** Global Data Layout                                                                   222373
     C                   PARM                    CGP001            1                          222373
      ** KYC: Transaction Type                                                                CSD028
     C                   PARM                    PTransType                                   CSD028
      ** Acceptance Mode                                                                    BUG15872
     C                   PARM                    PAccMde           1                        BUG15872
      ** Update (Y/N)                                                                       BUG15872
     C                   PARM                    PUpdYN            1                        BUG15872
      * OUTPUTS :
      * (Current) Customer in file format
      * Current Customer Base Rate Tax in file format
     C                   PARM                    CrCuFilFmt
     C                   PARM                    CrBrFilFmt
     C                   PARM                    CrPBFilFmt
     C                   PARM                    CrTIFilFmt                                  BUG5082
     C                   PARM                    GCustFilFmt                                  222373
     C                   PARM                    SwftFilFmt                                 BUG14929
     C                   PARM                    CuSW13                                       CSW213
     C                   PARM                    CuXcFilFmt                                   CGL132
     C                   PARM                    CuFaFilFmt                                   CGL132
     C                   PARM                    CumiFilFmt                                   CSD079
     C                   PARM                    CuadFilFmt                                   CSD079
     C                   PARM                    SfeeFilFmt                                   CSD079
     C                   PARM                    ChecFilFmt                                   CSD079
     C                   PARM                    CusfFilFmt                                   CSD079
     C                   PARM                    RwanFilFmt                                   CSD079
     C                   PARM                    CufoFilFmt                                   CSD079
     C                   PARM                    CufnFilFmt                                   CSD079
     C                   PARM                    CupmFilFmt                                   CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
     C                   PARM                    NewCuCUAH                                    CER059
     C                   PARM                    NewCuCCTX                                    CER059
     C                   PARM                    CtnmFilFmt                                AR1086546
     C                   PARM                    NewCuPrim                                    CSW213
     C                   PARM                    NewCuSeco                                    CSW213
     C                   PARM                    NewCuMT3x                                    CSW213
                                                                                              CSD079
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      * OK - Customer Reference
     C                   PARM      *BLANK        DDCUSNOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *                                                                                     BUG23518
      ** Warning fields/message IDs/message data (arrays) from/to caller                    BUG23518
      *                                                                                     BUG23518
     C                   PARM                    WFldNamArr                                 BUG23518
     C                   PARM                    WMsgIDArr                                  BUG23518
     C                   PARM                    WMsgDtaArr                                 BUG23518
      * Array index (3P0) from/to caller                                                    BUG23518
     C                   PARM      *ZEROS        WIdx                                       BUG23518


     C                   ENDSR
      *****************************************************************                     AR316373
     C     SDCUSDRTV1    BEGSR                                                              AR316373
      *                                                                                     AR316373
     C                   CALLB     'SDCUSDRTV1'                                             AR316373
      *                                                                                     AR316373
      ** INPUTS:                                                                            AR316373
      ** Return code                                                                        AR316373
      *                                                                                     AR316373
     C                   PARM      *BLANK        RetCodeIn                                  AR316373
      *                                                                                     AR316373
      ** Action Code                                                                        AR316373
      *                                                                                     AR316373
     C                   PARM                    DDACTN                                     AR316373
      *                                                                                     AR316373
      ** Front Office Transaction ID                                                        AR316373
      *                                                                                     AR316373
     C                   PARM                    C_BBFRNT                                   AR316373
      *                                                                                     AR316373
      ** (Midas) Customer Number                                                            AR316373
      *                                                                                     AR316373
     C                   PARM                    DDCUSN                                     AR316373
      *                                                                                     AR316373
      ** OUTPUT:                                                                            AR316373
      ** Customer Details in File Format                                                    AR316373
      *                                                                                     AR316373
     C                   PARM                    CusdExFilFmt                               AR316373
      *                                                                                     AR316373
     C                   ENDSR                                                              AR316373
      **********************************************************************
     C     SDCUSDCVT     BEGSR

     C                   CALLB     'SDCUSDCVT'

      * INPUTS
      * Return Code
     C                   PARM      *BLANK        ReturnCode       10
      *
      * Customer file format
     C                   PARM                    CrCuFilFmt
      *
      * Base Rate Tax file format
     C                   PARM                    CrBrFilFmt
      *
      * Private Banking format
     C                   PARM                    CrPBFilFmt
                                                                                              CSD079
      ** Marketing Information                                                                CSD079
                                                                                              CSD079
     C                   PARM                    CumiFilFmt                                   CSD079
                                                                                              CSD079
      ** Additional Customer                                                                  CSD079
                                                                                              CSD079
     C                   PARM                    CuadFilFmt                                   CSD079
                                                                                              CSD079
      ** Service Fees                                                                         CSD079
                                                                                              CSD079
     C                   PARM                    SfeeFilFmt                                   CSD079
                                                                                              CSD079
     ** Cheques and Card Details                                                              CSD079
                                                                                              CSD079
     C                   PARM                    ChecFilFmt                                   CSD079
                                                                                              CSD079
      ** Safe Details                                                                         CSD079
                                                                                              CSD079
     C                   PARM                    CusfFilFmt                                   CSD079
                                                                                              CSD079
      ** Risk Weighted Details                                                                CSD079
                                                                                              CSD079
     C                   PARM                    RwanFilFmt                                   CSD079
                                                                                              CSD079
      ** Future and Options                                                                   CSD079
                                                                                              CSD079
     C                   PARM                    CufoFilFmt                                   CSD079
                                                                                              CSD079
      ** Fn Options                                                                           CSD079
                                                                                              CSD079
     C                   PARM                    CufnFilFmt                                   CSD079
                                                                                              CSD079
      ** Portfolio Management                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    CupmFilFmt                                   CSD079
                                                                                              CSD079
      ** TI interface Details                                                                 CSD079
                                                                                              CSD079
     C                   PARM                    CrTIFilFmt                                   CSD079
                                                                                              CSD079
      ** Lux(European Reporting)                                                              CSD079
                                                                                              CSD079
     C                   PARM                    CueuFilFmt                                   CSD079
                                                                                              CSD079
      ** Lux(IBLC - Extended Information)                                                     CSD079
                                                                                              CSD079
     C                   PARM                    CuibfFilFmt                                  CSD079
      *                                                                                       CSD079
      ** Currency/Time of Netting Details                                                  AR1086546
                                                                                           AR1086546
     C                   PARM                    CtnmFilFmt                                AR1086546
      ** Global Customer X-Reference                                                          222373
     C                   PARM                    GCustFilFmt                                  222373
     C                   PARM                    SwftFilFmt                                 BUG15872
     C                   PARM                    CuXcFilFmt                                   CGL132
     C                   PARM                    CuFaFilFmt                                   CGL132
                                                                                             BUG4452
      ** Credit Lines                                                                        BUG4452
     C                   PARM                    CLE025                                      BUG4452
                                                                                             BUG4452
      ** FX Margin Trading                                                                   BUG4452
     C                   PARM                    CFX001                                      BUG4452
      * OUTPUTS
      * Customer - screen formats
     C                   PARM                    NewCuPrim
     C                   PARM                    NewCuSeco
     C                   PARM                    NewCuMT3x
     C                   PARM                    NewCuMsg
     C                   PARM                    NewCuBrt
     C                   PARM                    NewCuPriv
     C                   PARM                    NewCuCumi                                    CSD079
     C                   PARM                    NewCuCuad                                    CSD079
     C                   PARM                    NewCuACU3                                    CER059
     C                   PARM                    NewCuACU4                                    CER059
     C                   PARM                    NewCuSfee                                    CSD079
     C                   PARM                    NewCuCufx                                    CSD079
     C                   PARM                    NewCuCufd                                    CSD079
     C                   PARM                    NewCuChec                                    CSD079
     C                   PARM                    NewCuCusf                                    CSD079
     C                   PARM                    NewCuRwan                                    CSD079
     C                   PARM                    NewCuCufo                                    CSD079
     C                   PARM                    NewCuCupm                                    CSD079
     C                   PARM                    NewCuTicd                                    CSD079
     C                   PARM                    NewCuCurx                                    CSD079
     C                   PARM                    CuSwft                                     BUG15872
     C                   PARM                    NewCuCtnm                                 AR1086546
     C                   PARM                    CuCUXC                                       CGL132
     C                   PARM                    CuFTCR                                       CGL132
     C**********         PARM                    CuSW13                              CSW213 MD022463
      *

     C                   ENDSR
      *****************************************************************                     AR316373
     C     SDCUSDCVT1    BEGSR                                                              AR316373
      *                                                                                     AR316373
     C                   MOVEL     DDCUSN        XXCUSN            6 0                      AR316373
      *                                                                                     AR316373
     C                   CALLB     'SDCUSDCVT1'                                             AR316373
      *                                                                                     AR316373
      ** INPUTS                                                                             AR316373
      ** Return Code                                                                        AR316373
      *                                                                                     AR316373
     C                   PARM      *BLANK        ReturnCode                                 AR316373
      *                                                                                     AR316373
      ** Customer Number                                                                    AR316373
      *                                                                                     AR316373
     C                   PARM                    XXCUSN                                     AR316373
      *                                                                                     AR316373
      ** SD Customer Transaction Details File Format                                        AR316373
      *                                                                                     AR316373
     C                   PARM                    CusdExFilFmt                               AR316373
      *                                                                                     AR316373
      ** Output Parameters                                                                  AR316373
      ** SD Customer Transaction Details in Screen Format                                   AR316373
      *                                                                                     AR316373
     C                   PARM                    ExtData                                    AR316373
      *                                                                                     AR316373
     C                   ENDSR                                                              AR316373
      **********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
