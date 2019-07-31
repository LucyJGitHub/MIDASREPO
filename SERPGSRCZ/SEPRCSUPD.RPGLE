     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Market prices database update')               *
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  SEPRCSUPD - SE Market Price Database Update                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD043345           Date 05Jan17               *
      *                 AR1092524          Date 12Mar13               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 244966             Date 30Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11512           Date 19Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10962           Date 22Mar06               *
      *                 BUG8872            Date 21Oct05               *
      *                 229135             Date 27Sep04               *
      *                 224448             Date 10Nov03               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 191396             Date 23Mar01               *
      *                 189506             Date 02Feb01               *
      *                 CSD006             Date 25Oct00               *
      *                 CAP060             Date 25Oct00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 170262             Date 09Nov99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CAP030  *CREATE    Date 10Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD043345 - Security Prices does not have timestamp when      *
      *             inserted                                          *
      *  AR1092524 - Data inserted in Branch, Market & Book were not  *
      *           displayed in the Main list view of Securities       *
      *           Prices.                                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  244966 - Applied fix 237132. Annotated as BUG11512.          *
      *  237132 - SE Price function PRCN problem. When CAP060 is *OFF,*
      *           processing should still be the same as in SE0080    *
      *           (Non-API Prices inast Maintenance).                 *
      *  BUG11512 - Deletion not allowed; applied 232345              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10962 - SE Price Input; value date not updated on amend;  *
      *             applied 232024                                    *
      *  BUG8872 - Fields not updated on record overwrite             *
      *  229135 - Credit risk updated incorrectly.                    *
      *  224448 - Trailer is not correctly updated                    *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation on Savings Income                          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  191396 - 9997 defaulting is only relevant if a customer has  *
      *           been entered; not possible for price type V         *
      *  189506 - Securities Prices API could not update extel fields *
      *  CSD006 - Market Data Feed                                    *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *  170262 - Correct Audit file update                           *
      *  CAP030 - API for SE Price Input                              *
      *                                                               *
      *****************************************************************
     FPRICE     UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(PRICEDF)
     FPRICEA    UF A E             DISK
     F                                     COMMIT

     FSEPRICPD  UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(SEPRICD0)
     F                                     PREFIX(P_)

     F*********SEPRXTPD  UF A E             DISK                                              189506
     F*************************************COMMIT                                             189506

     FEXVALD    UF A E           K DISK    INFSR(EXVLSR)
     F                                     COMMIT

     FSDMDFRL0  UF   E           K DISK    INFSR(*PSSR)                                       CAP060
     F                                     COMMIT                                             CAP060
     FSDMDFIL0  UF   E           K DISK    INFSR(*PSSR)                                       CAP060
     F                                     COMMIT                                             CAP060
     FSDMDFHPD  O    E             DISK    INFSR(*PSSR)                                       CAP060
     F                                     COMMIT                                             CAP060
                                                                                              CSC011
      ** Securities Details file                                                              CSC011
     FSECTY     IF   E           K DISK    INFSR(*PSSR)                                       CSC011
     F                                     PREFIX(SC_)                                        CSC011
     F/COPY WNCPYSRC,SEH00086
                                                                                              CSC011
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** The following /COPY line includes the definitions for error and                      CAP060
      ** warning message arrays.                                                              CAP060
     D/COPY ZACPYSRC,ERR_ARRAYS                                                               CAP060
      *****************************************************************

      ** Timestamp for the transaction                                                        CAP060
     D TimeStamp       S               Z                                                      CAP060
                                                                                              CAP060
     D CHKPRCSFMT    E DS                  EXTNAME(PRICE)                                     CAP060
     D                                     PREFIX(CH)                                         CAP060
      ** Rename fields for Timestamp checking                                                 CAP060
                                                                                              CAP060
     D B_PRICE       E DS                  EXTNAME(PRICE)                                     CAP060
     D                                     PREFIX(B_)                                         CAP060
      **  Externally described DS for 'BEFORE UPDATE'                                         CAP060
                                                                                              CAP060
      **  Externally described data structure for valid Price record                          CAP060
     D SEVPRC        E DS                  EXTNAME(SEVPRCSPD)
     D                                     PREFIX(V_)                                         CAP060

      **  Externally described data structure for Extra Data Price file
     D SEVPRX        E DS                  EXTNAME(SEVPRXTPD)

      **  Externally described data structure for Extel File                                  CAP060
     D SEVEXT        E DS                  EXTNAME(SEVEXVLPD)                                 CAP060

      **  Price details file.
     D PRICED        E DS                  EXTNAME(PRICED)

     D*PRICEX********E DS                  EXTNAME(SEPRXTPD)                                  189506

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * DATA STRUCTURE FOR Midas Module Details

     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      * DATA STRUCTURE FOR SECURITIES TRADING DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                              CSC011
      ** API Message Header Format Definiton                                                  CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** 24x7 Status Data Area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Switchable features Definition file                                                  CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCLCD        E                     EXTFLD(LCD)                                        CSC011

      ** Before image of price details                                                        CAP060
     D WBFRIMG         S            800A                                                      CAP060

     D EXTLFilFmt    E DS                  EXTNAME(EXVALD)                                    CAP060
     D                                     PREFIX(EX)                                         CAP060
                                                                                              CAP060
      ** Dummy message ID and message file fields for use on the calls to                     CAP060
      ** ZAMSGTOOPR                                                                           CAP060
     D DummyMsgID      S                   LIKE(#MsgID)                                       CAP060
     D DummyMsgF       S             10A                                                      CAP060

     D/COPY WNCPYSRC,SEH00087
      ** +--------------------------------------+                               170262
      ** ¦ Manually included D-specs            ¦                               170262
      ** ¦ =========================            ¦                               170262
      ** +--------------------------------------+                               170262
     D RECI2           S                   LIKE(RECI)                                        BUG8872
                                                                                170262
      ** +--------------------------------------+                               170262
      ** ¦ Declared variables                   ¦                               170262
      ** ¦ ==================                   ¦                               170262
      ** +--------------------------------------+                               170262
                                                                                170262
     D Insert          S              1A                                        170262
                                                                                170262
      ** CSD006 indicator
     D CSD006F         S              1A                                                      CSD006
                                                                                              CSD006
      ** Taxation of Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** CAP060 indicator
     D CAP060F         S              1A                                                      CAP060
                                                                                              CAP060
      ** Index for arrays of of error message ids etc                                         CAP060
     D Idx             S              3P 0                                                    CAP060
                                                                                              CAP060
      ** Index for arrays of of warning message ids etc                                       CAP060
     D WIdx            S              3P 0                                                    CAP060
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimeStamp      S             26A                                                      CSC011
     D***PDealNumber     S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNumber     S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRetCode        S              7A                                                      CSC011
     D POption         S              7A                                                      CSC011
     D PKey            S              6A                                                      CSC011

     D CSD010          S              1A                                                      CSD010
                                                                                              CSD010
      ** Hedge Accounting Phase B Switchable Feature                                          CAS006
     D CAS006          S              1A                                                      CAS006
                                                                                              CAS006
     D/COPY WNCPYSRC,SEH00088
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
      *******                                                                                 CAP060
                                                                                              CAP060
      * Check for existing record.
      * ----------Market Data Feed OFF -----------------                                      CAP060
     C                   IF        CAP060F= 'N'                                               CAP060
     C*******            MOVE      ' '           Insert                         170262        CAP060
     C*******            MOVEL     PRPSSN        @PSSN                                        CAP060
     C*******            MOVEL     *BLANKS       @PCNM                                        CAP060
     C*******            MOVEL     ' '           @PMKT                                        CAP060
     C*******            MOVEL     *BLANKS       @PBRA                                        CAP060
     C*******            MOVEL     *BLANKS       @PBOK                                        CAP060
     C*******            MOVEL     PRPPRT        @PPRT                                        CAP060
     C                   MOVE      ' '           Insert                                       CAP060
     C                   MOVEL     V_PRPSSN      @PSSN                                        CAP060
     C                   MOVEL     V_PRPCNM      @PCNM                                     AR1092524
     C                   MOVEL     V_PRPMKT      @PMKT                                     AR1092524
     C                   MOVEL     V_PRPBRA      @PBRA                                     AR1092524
     C                   MOVEL     V_PRPBOK      @PBOK                                     AR1092524
     C**********         MOVEL     *BLANKS       @PCNM                              CAP060 AR1092524
     C**********         MOVEL     ' '           @PMKT                              CAP060 AR1092524
     C**********         MOVEL     *BLANKS       @PBRA                              CAP060 AR1092524
     C**********         MOVEL     *BLANKS       @PBOK                              CAP060 AR1092524
     C                   MOVEL     V_PRPPRT      @PPRT                                        CAP060

     C     BGPFMG        IFEQ      'Y'
     C                   MOVEL     '    '        @PTFR
     C*******************ELSE                                                                 191396
     C*******************MOVEL     '9997'        @PTFR                                        191396
     C                   ENDIF
      *
     C     @PRICK        CHAIN     PRICE                              99
      *                                                                                     BUG11512
     C     V_PRCHTP      IFEQ      'D'                                                      BUG11512
     C     *IN99         ANDEQ     '0'                                                      BUG11512
     C                   EXSR      SrDELET                                                  BUG11512
     C                   ELSE                                                               BUG11512
      *
      * If not found insert new record.
      *
     C     *IN99         IFEQ      '1'
     C                   EXSR      PRCINS
     C                   ELSE
      *                                                                         170262
      * Set indicator for insert over existing record                           170262
      *                                                                         170262
     C     RECI          IFEQ      '*'                                          170262
     C                   MOVE      'Y'           Insert                         170262
      *                                                                                      BUG8872
      ** Save original RECI value, to distinguish if record was overwritten                  BUG8872
      *                                                                                      BUG8872
     C                   EVAL      RECI2 = RECI                                              BUG8872
     C                   ELSE                                                                BUG8872
     C                   EVAL      RECI2 = *BLANK                                            BUG8872
     C                   ENDIF                                                  170262
      *
      * Update existing Price record for Security.
      *
     C                   EXSR      PRCAMD
     C                   ENDIF
     C                   ENDIF                                                              BUG11512

     C                   ENDIF                                                                CAP060
      * ----------Market Data Feed ON  -----------------                                      CAP060
     C                   IF        CAP060F= 'Y'                                               CAP060
     C                   EXSR      CHKOTHUPD                                                  CAP060
                                                                                              CAP060
     C     @@RTCD        IFNE      *BLANKS                                                    CAP060
     C                   GOTO      EXIT                                                       CAP060
     C                   ENDIF                                                                CAP060
     C     V_PRCHTP      CASEQ     'I'           SrINSRT                                      CAP060
     C     V_PRCHTP      CASEQ     'A'           SrAMEND                                      CAP060
     C     V_PRCHTP      CASEQ     'D'           SrDELET                                      CAP060
     C                   ENDCS                                                                CAP060
      *                                                                                       CAP060
     C                   IF        CSD006F= 'Y'                                               CSD006
      * Update Market Data Feed files                                                         CSD006
      *                                                                                       CSD006
     C                   IF        V_PRTLEX ='Y' AND                                          CSD006
     C                             V_PRDTFR  <> *BLANKS                                       CSD006
     C                   EXSR      SrDTAFEED                                                  CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   IF        V_PRDTFR <> *BLANKS                                        CSD006
     C                   EXSR      SrHISUPD                                                   CSD006
     C                   ENDIF                                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   CALLB     'SEPRCSLOG'                                                CSC011
     C                   PARM      *Blanks       ReturnCode                                   CSC011
     C                   PARM                    PRICED                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
     C                   IF        ReturnCode = *Blanks                                       CSC011
                                                                                              CSC011
     C     PSSN          CHAIN     SECTY                              01                      CSC011
     C                   IF        *IN01 = *Off                                               CSC011
     C                   EVAL      APFOTRANID = SC_SPID                                       CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'SEPRCS'                                       CSC011
     C                   EVAL      APRPRLOCN  = V_PRREPA                                      CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       ReturnCode                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTimeStamp                                   CSC011
     C                   PARM                    PDealNumber                                  CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        ReturnCode <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011

      * EXIT FROM PROGRAM                                                                     CAP060
     C     EXIT          TAG                                                                  CAP060
                                                                                              CAP060
     C                   RETURN                                                               CAP060
     C                   ENDIF                                                                CAP060
      *
      * Exit from program.
      *
     C                   RETURN
      ****************************************************************
      *                                                              *
      * PRCINS - Insert a new Price record.                          *
      *                                                              *
      ****************************************************************
     C     PRCINS        BEGSR
      *
      * Initialise Price record.
      *
     C                   CLEAR                   PRICED
      *
      * Record Id.
      *
     C                   MOVE      'D'           RECI
      ***********                                                                             CAP060
      ***********                                                                             CAP060
      **Security*Shortname.                                                                   CAP060
      ***********                                                                             CAP060
     C***********        MOVE      PRPSSN        PSSN                                         CAP060
      ***********                                                                             CAP060
      **Price*type.                                                                           CAP060
      ***********                                                                             CAP060
     C***********        MOVE      PRPPRT        PPRT                                         CAP060
      ***********                                                                             CAP060
      **Price.***                                                                             CAP060
      ***********                                                                             CAP060
     C***********        Z-ADD     PRPPRC        PPRC                                         CAP060
      ***********                                                                             CAP060
      **Narrative.                                                                            CAP060
      ***********                                                                             CAP060
     C***********        MOVE      PRPNTV        PNTV                                         CAP060
      ***********                                                                             CAP060
      **Value*date.                                                                           CAP060
      ***********                                                                             CAP060
     C***********        Z-ADD     PRPVDT        PVDT                                         CAP060
      ***********                                                                             CAP060
      **Price*boundaries warning                                                              CAP060
      ***********                                                                             CAP060
     C***********        MOVEL     PRPBWN        PBWN                                         CAP060
      ***********                                                                             CAP060
      **Price*percentage allowable movement warning                                           CAP060
      ***********                                                                             CAP060
     C***********        MOVEL     PRPPWN        PPWN                                         CAP060
      *                                                                                       CAP060
      * Security Shortname.                                                                   CAP060
      *                                                                                       CAP060
     C                   MOVE      V_PRPSSN      PSSN                                         CAP060
      *                                                                                       CAP060
      * Price type.                                                                           CAP060
      *                                                                                       CAP060
     C                   MOVE      V_PRPPRT      PPRT                                         CAP060
      *                                                                                       CAP060
      ** Customer                                                                          AR1092524
      *                                                                                    AR1092524
     C                   MOVE      V_PRPCNM      PCNM                                      AR1092524
      *                                                                                    AR1092524
      ** Market                                                                            AR1092524
      *                                                                                    AR1092524
     C                   MOVE      V_PRPMKT      PMKT                                      AR1092524
      *                                                                                    AR1092524
      ** Branch                                                                            AR1092524
      *                                                                                    AR1092524
     C                   MOVE      V_PRPBRA      PBRA                                      AR1092524
      *                                                                                    AR1092524
      ** Book                                                                              AR1092524
      *                                                                                    AR1092524
     C                   MOVE      V_PRPBOK      PBOK                                      AR1092524
      *                                                                                       CAP060
      * Price.                                                                                CAP060
      *                                                                                       CAP060
     C                   Z-ADD     V_PRPPRC      PPRC                                         CAP060
      *                                                                                       CAP060
      * Narrative.                                                                            CAP060
      *                                                                                       CAP060
     C                   MOVE      V_PRPNTV      PNTV                                         CAP060
      *                                                                                       CAP060
      * Value date.                                                                           CAP060
      *                                                                                       CAP060
     C                   Z-ADD     V_PRPVDT      PVDT                                         CAP060
      *                                                                                       CAP060
      * Price boundaries warning                                                              CAP060
      *                                                                                       CAP060
     C                   MOVEL     V_PRPBWN      PBWN                                         CAP060
                                                                                              CGL031
      ** Taxation of Savings Income                                                           CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     V_PRPEXI      PEXI                                         CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CAP060
      * Price percentage allowable movement warning                                           CAP060
      *                                                                                       CAP060
     C                   MOVEL     V_PRPPWN      PPWN                                         CAP060
      *
      * Last Change Date.
      *
     C                   MOVE      BJRDNB        LCD
      *
      * Last Change Type.
      *
     C                   MOVE      'I'           CHTP
      *
      * Set Portfolio reference
      *
     C     BGPFMG        IFEQ      'Y'
     C                   MOVEL     '    '        PTFR
     C*******************ELSE                                                                 191396
     C*******************MOVEL     '9997'        PTFR                                         191396
     C                   ENDIF
      *
      * Transaction Number of Last Update.
      *
     C                   Z-ADD     0             TNLU
      *
      * Zeroise numeric fields : Customer No. and Exchange rate
      *
     C**********         Z-ADD     0             PCNM                                         CSD027
     C**********         EVAL      PCNM = *BLANKS                                   CSD027 AR1092524
     C                   Z-ADD     0             NPXR
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   Z-ADD     V_PRBDPR      PRBDPR                                       CSD010
     C                   Z-ADD     V_PROFPR      PROFPR                                       CSD010
     C                   Z-ADD     V_PRCLPR      PRCLPR                                       CSD010
     C                   ELSE                                                                 CSD010
     C                   Z-ADD     0             PRBDPR                                       CSD010
     C                   Z-ADD     0             PROFPR                                       CSD010
     C                   Z-ADD     0             PRCLPR                                       CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        PRFRNT = *BLANKS                                           CSC011
     C     PSSN          CHAIN     SECTY                              01                      CSC011
     C                   IF        *IN01 = *Off                                               CSC011
     C                   EVAL      PRFRNT = SC_SPID                                           CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C**********         IF        CAS006 = 'Y' AND (PPRT = 'V'                        CAS006 229135
     C**********                   OR PPRT = 'DT' OR PPRT = 'DV')                      CAS006 229135
     C                   IF        CAS006 = 'Y' AND (V_PRPPRT = 'V'                           229135
     C                             OR V_PRPPRT = 'DT' OR V_PRPPRT = 'DV')                     229135
     C                   EVAL      PRCRSK = V_PRCRSK                                          CAS006
     C                   EVAL      PRLQPR = V_PRLQPR                                          CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      PRCRSK = *ZERO                                             CAS006
     C                   EVAL      PRLQPR = *ZERO                                             CAS006
     C                   ENDIF                                                                CAS006
     C/COPY WNCPYSRC,SEH00089
                                                                                            MD043345
     C                   CALLB     'ZAGENTMSTM'                                             MD043345
     C                   PARM                    TimeStamp                                  MD043345
                                                                                            MD043345
     C                   EVAL      PRTMST  = TimeStamp                                      MD043345

      * Write new Price record.
      *
     C                   WRITE     PRICEDF
     C/COPY WNCPYSRC,SEH00090
      *
      * Get AUDIT Record.
      *
     C     1             SETLL     PRICEA
     C                   READ      PRICEAF                                98
     C** Update AUDIT Record if found
     C     *IN98         IFEQ      '0'
     C** For Insert, Update Live records inserted today, and No. of live
     C** records
     C                   ADD       1             SINS
     C                   ADD       1             NORE
     C** Update AUDIT record
     C                   UPDATE    PRICEAF
     C                   ENDIF
      *
      * If CAC005 is installed, add the same record in SEPRICPD
      *
     C     CAC005        IFEQ      'Y'
     C                   EXSR      SEPUPD
     C                   END
      *
      * Write the Extra Data Price file
      *
     C                   EXSR      PRCXTF
     C/COPY WNCPYSRC,SEH00091
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PRCAMD - Update existing Price record.                       *
     C*                                                              *
     C****************************************************************
     C     PRCAMD        BEGSR
     C/COPY WNCPYSRC,SEH00092
      *
      * Record Id.
      *
     C                   MOVE      'D'           RECI
      ***********                                                                             CAP060
      **Price.***                                                                             CAP060
      ***********                                                                             CAP060
     C***********        MOVE      PRPPRC        PPRC                                         CAP060
      ***********                                                                             CAP060
      **Narrative.                                                                            CAP060
      ***********                                                                             CAP060
     C***********        MOVE      PRPNTV        PNTV                                         CAP060
      ***********                                                                             CAP060
      **Value*date.                                                                           CAP060
      ***********                                                                             CAP060
     C***********        MOVE      PRPVDT        PVDT                                         CAP060
                                                                                              CAP060
     C* Price.                                                                                CAP060
                                                                                              CAP060
     C                   MOVE      V_PRPPRC      PPRC                                         CAP060
      *                                                                                       CAP060
      * Narrative.                                                                            CAP060
      *                                                                                       CAP060
     C*                  MOVE      V_PRPNTV      PNTV                                         CAP060
     C                   MOVE      V_PRPNTV      PNTV                                       BUG10962
      *                                                                                       CAP060
      * Value date.                                                                           CAP060
      *                                                                                       CAP060
     C*                  MOVE      V_PRPVDT      PVDT                                         CAP060
     C                   MOVE      V_PRPVDT      PVDT                                       BUG10962
                                                                                              CGL031
      ** Taxation of Savings Income                                                           CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     V_PRPEXI      PEXI                                         CGL031
     C                   ENDIF                                                                CGL031
      *
      * Last Change Date.
      *
     C                   MOVE      BJRDNB        LCD
      *                                                                                      BUG8872
      ** Refresh fields only when record used to have RECI = '*'                             BUG8872
      *                                                                                      BUG8872
     C                   IF        RECI2 = '*'                                               BUG8872
     C                   MOVE      V_PRPNTV      PNTV                                        BUG8872
     C                   MOVE      V_PRPVDT      PVDT                                        BUG8872
     C                   ENDIF                                                               BUG8872
      *
      * Last Change Type.
      *
     C     Insert        IFEQ      'Y'                                          170262
     C                   MOVE      'I'           CHTP                           170262
     C                   ELSE                                                   170262
     C                   MOVE      'A'           CHTP
     C                   ENDIF                                                  170262
      *
      * Transaction Number of Last Update.
      *
     C                   Z-ADD     0             TNLU
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   Z-ADD     V_PRBDPR      PRBDPR                                       CSD010
     C                   Z-ADD     V_PROFPR      PROFPR                                       CSD010
     C                   Z-ADD     V_PRCLPR      PRCLPR                                       CSD010
     C                   ELSE                                                                BUG8872
      *                                                                                      BUG8872
      ** Init fields if record was overwritten                                               BUG8872
      *                                                                                      BUG8872
     C                   IF        RECI2 = '*'                                               BUG8872
     C                   EVAL      PRBDPR = *ZERO                                            BUG8872
     C                   EVAL      PROFPR = *ZERO                                            BUG8872
     C                   EVAL      PRCLPR = *ZERO                                            BUG8872
     C                   ENDIF                                                               BUG8872
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C**********         IF        CAS006 = 'Y' AND (PPRT = 'V'                        CAS006 229135
     C**********                   OR PPRT = 'DT' OR PPRT = 'DV')                      CAS006 229135
     C                   IF        CAS006 = 'Y' AND (V_PRPPRT = 'V'                           229135
     C                             OR V_PRPPRT = 'DT' OR V_PRPPRT = 'DV')                     229135
     C                   EVAL      PRCRSK = V_PRCRSK                                          CAS006
     C                   EVAL      PRLQPR = V_PRLQPR                                          CAS006
     C                   ELSE                                                                BUG8872
     C                   IF        RECI2 = '*'                                               BUG8872
     C                   EVAL      PRCRSK = *ZERO                                            BUG8872
     C                   EVAL      PRLQPR = *ZERO                                            BUG8872
     C                   ENDIF                                                               BUG8872
     C                   ENDIF                                                                CAS006
      *                                                                                      BUG8872
      ** Reset fields if record used to have RECI = '*' (Deleted)                            BUG8872
      *                                                                                      BUG8872
     C                   IF        RECI2 = '*'                                               BUG8872
     C                   MOVEL     V_PRPSRC      PSRC                                        BUG8872
     C                   MOVEL     V_PRPBWN      PBWN                                        BUG8872
     C                   MOVEL     V_PRPPWN      PPWN                                        BUG8872
     C                   MOVEL     V_PRPTFR      PTFR                                        BUG8872
     C                   MOVEL     V_PRNPXR      NPXR                                        BUG8872
     C                   MOVEL     V_PRNPMD      NPMD                                        BUG8872
     C                   MOVEL     V_PRDFTS      PRDFTS                                      BUG8872
     C                   MOVEL     V_PRFRNT      PRFRNT                                      BUG8872
     C                   MOVEL     V_PRAFRT      PRAFRT                                      BUG8872
     C                   MOVEL     V_PRREPA      PRREPA                                      BUG8872
     C                   MOVEL     V_PRDTFR      PRDTFR                                      BUG8872
     C                   MOVEL     *BLANKS       PRTLEX                                      BUG8872
      *                                                                                      BUG8872
     C                   ENDIF                                                              MD043345
     C                   CALLB     'ZAGENTMSTM'                                              BUG8872
     C                   PARM                    TimeStamp                                   BUG8872
      *                                                                                      BUG8872
     C                   EVAL      PRTMST  = TimeStamp                                       BUG8872
     C**********         ENDIF                                                      BUG8872 MD043345
     C/COPY WNCPYSRC,SEH00093
      *
      * Update Price record
      *
     C                   UPDATE    PRICEDF
     C/COPY WNCPYSRC,SEH00094
      *
      *
      * Get AUDIT Record.
      *
     C     1             SETLL     PRICEA
     C                   READ      PRICEAf                                98
     C** Update AUDIT Record if found
     C     *IN98         IFEQ      '0'
     C     Insert        IFEQ      'Y'                                          170262
     C/COPY WNCPYSRC,SEH00095
     C** Update for insert over deleted record                                  170262
     C                   ADD       1             SINS                           170262
     C                   ADD       1             NORE                           170262
     C                   ELSE                                                   170262
     C** For Amends, Update No. of Records amended today.
     C                   ADD       1             SAMD
     C                   ENDIF                                                  170262
     C** Update AUDIT record
     C                   UPDATE    PRICEAF
     C                   ENDIF
      *
      * If CAC005 is installed, update record in SEPRICPD
      *
     C     CAC005        IFEQ      'Y'
     C                   EXSR      SEPUPD
     C                   END
      *
      * Write the Extra Data Price details file
      **Do*not*write*the*Extra*Data*Price*details*file*for*an*amend                           189506
      *                                                                                       189506
      * Write the Extra Data Price file                                                       189506
      *                                                                                       189506
     C                   EXSR      PRCXTF                                                     189506
     C/COPY WNCPYSRC,SEH00096
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SEPUPD - Update a record in SEPRICPD if CAC005 on            *
     C*                                                              *
     C****************************************************************
      *
     C     SEPUPD        BEGSR
      *
      * Check for existing record.
      *
     C                   EVAL      P_PSSN=PSSN
     C                   EVAL      P_PCNM=PCNM
     C                   EVAL      P_PMKT=PMKT
     C                   EVAL      P_PBRA=PBRA
     C                   EVAL      P_PBCD=*BLANK
     C                   EVAL      P_PRFC=*BLANK
     C                   EVAL      P_PPRT=PPRT
     C                   EVAL      P_PTFR=PTFR

      *
     C     KSEPRC        CHAIN     SEPRICPD                           97
      *
      * If not found insert new record.
      *
     C     *IN97         IFEQ      '1'

     C                   EVAL      P_RECI=RECI
     C                   EVAL      P_PSSN=PSSN
     C                   EVAL      P_PPRT=PPRT
     C                   EVAL      P_PVDT=PVDT
     C                   EVAL      P_PCNM=PCNM
     C                   EVAL      P_PMKT=PMKT
     C                   EVAL      P_PBRA=PBRA
     C                   EVAL      P_PBOK=PBOK
     C                   EVAL      P_PPRC=PPRC
     C                   EVAL      P_PNTV=PNTV
     C                   EVAL      P_LCD =LCD
     C                   EVAL      P_CHTP=CHTP
     C                   EVAL      P_TNLU=TNLU
     C                   EVAL      P_PSRC=PSRC
     C                   EVAL      P_PBWN=PBWN
     C                   EVAL      P_PPWN=PPWN
     C                   EVAL      P_PTFR=PTFR
     C                   EVAL      P_NPXR=NPXR
     C                   EVAL      P_NPMD=NPMD
     C                   EVAL      P_PBCD='  '
     C                   EVAL      P_PRFC='    '
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        P_PRFRNT = *BLANKS                                         CSC011
     C                   EVAL      P_PRFRNT = SC_SPID                                         CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EVAL      P_PRBDPR = PRBDPR                                          CSD010
     C                   EVAL      P_PROFPR = PROFPR                                          CSD010
     C                   EVAL      P_PRCLPR = PRCLPR                                          CSD010
     C                   ELSE                                                                 CSD010
     C                   Z-ADD     0             PRBDPR                                       CSD010
     C                   Z-ADD     0             PROFPR                                       CSD010
     C                   Z-ADD     0             PRCLPR                                       CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (PPRT = 'V'                               CAS006
     C                             OR PPRT = 'DT' OR PPRT = 'DV')                             CAS006
     C                   EVAL      P_PRCRSK = PRCRSK                                          CAS006
     C                   EVAL      P_PRLQPR = PRLQPR                                          CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      P_PRCRSK = *ZERO                                           CAS006
     C                   EVAL      P_PRLQPR = *ZERO                                           CAS006
     C                   ENDIF                                                                CAS006

     C                   WRITE     SEPRICD0
     C                   ELSE
      *
      * If found update existing record.
      *
     C                   EVAL      P_RECI=RECI                                                189506
     C                   EVAL      P_PVDT=PVDT
     C                   EVAL      P_PPRC=PPRC
     C                   EVAL      P_PNTV=PNTV
     C                   EVAL      P_PSRC=PSRC
     C                   EVAL      P_NPXR=NPXR
     C                   EVAL      P_NPMD=NPMD
     C                   EVAL      P_LCD =LCD
     C                   EVAL      P_CHTP=CHTP
     C                   EVAL      P_TNLU=TNLU
     C                   EVAL      P_PBWN=PBWN
     C                   EVAL      P_PPWN=PPWN
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EVAL      P_PRBDPR = PRBDPR                                          CSD010
     C                   EVAL      P_PROFPR = PROFPR                                          CSD010
     C                   EVAL      P_PRCLPR = PRCLPR                                          CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CSD010
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (PPRT = 'V'                               CAS006
     C                             OR PPRT = 'DT' OR PPRT = 'DV')                             CAS006
     C                   EVAL      P_PRCRSK = PRCRSK                                          CAS006
     C                   EVAL      P_PRLQPR = PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   UPDATE    SEPRICD0
     C                   END
      *
     C                   ENDSR
      ****************************************************************                        CAP060
      /EJECT                                                                                  CAP060
      ****************************************************************                        CSD006
      *                                                              *                        CSD006
      * SrDTAFEED - Update data-feed related files                   *                        CSD006
      *                                                              *                        CSD006
      ****************************************************************                        CSD006
     C     SrDTAFEED     BEGSR                                                                CSD006
                                                                                              CSD006
      ** Update MDF tolerance exceed ind. when data feed request identifier                   CSD006
      ** is not blank and the tolerance exceeded indicator received is set                    CSD006
      ** to 'Y'                                                                               CSD006
                                                                                              CSD006
      * Set up key for chain to Market Data Feed Requested Items Detaisl file.                CSD006
     C                   EVAL      @DFRID = V_PRDTFR                                          CSD006
     C                   EVAL      @DFIT = V_PRPSSN                                           CSD006
                                                                                              CSD006
     C     KDFRQ         CHAIN     SDMDFIL0                                                   CSD006
                                                                                              CSD006
     C                   IF        %FOUND(SDMDFIL0)                                           CSD006
     C                   EVAL      MITOLX = 'Y'                                               CSD006
     C                   UPDATE    SDMDFID0                                                   CSD006
                                                                                              CSD006
     C     V_PRDTFR      CHAIN     SDMDFRL0                                                   CSD006
                                                                                              CSD006
     C                   IF        %FOUND(SDMDFRL0)                                           CSD006
     C                   EVAL      MRTOLX = 'Y'                                               CSD006
     C                   UPDATE    SDMDFRD0                                                   CSD006
     C                   ELSE                                                                 CSD006
     C                   UNLOCK    SDMDFRL0                                                   CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
                                                                                              CSD006
     C                   ELSE                                                                 CSD006
     C                   UNLOCK    SDMDFIL0                                                   CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
     C                   ENDSR                                                                CSD006
      /EJECT                                                                                  CSD006
      ********************************************************************                    CSD006
      *                                                                  *                    CSD006
      * SrHISUPD  - Updates Market Data Feed Rate/Price History File     *                    CSD006
      *                                                                  *                    CSD006
      ********************************************************************                    CSD006
     C     SrHISUPD      BEGSR                                                                CSD006
                                                                                              CSD006
     C                   Z-ADD     BJRDNB        RHPRCD                                       CSD006
     C                   MOVEL     V_PRFRNT      RHTREF                                       CSD006
     C                   MOVEL     V_PRDFTS      RHDFTS                                       CSD006
     C                   MOVEL     V_PRPSSN      RHDITM                                       CSD006
     C                   MOVEL     V_PRDTFR      RHDFRI                                       CSD006
     C                   MOVEL     V_PRTLEX      RHTLEX                                       CSD006
     C                   MOVEL     *BLANK        RHAUDT                                       CSD006
     C                   MOVEL     'PRICED'      RHFILE                                       CSD006
     C                   MOVEL     WBFRIMG       RHBIMG                                       CSD006
     C                   EVAL      CHTP = V_PRCHTP                                            CSD006
     C                   MOVEL     PRICED        RHAIMG                                       CSD006
                                                                                              CSD006
      ** Write to file                                                                        CSD006
                                                                                              CSD006
     C                   WRITE     SDMDFHD0                                                   CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
      /EJECT                                                                                  CSD006
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      * CHKOTHUPD - Check for update by another workstation           *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
     C     CHKOTHUPD     BEGSR                                                                CAP060
                                                                                              CAP060
      ** Retrieve current security details                                                    CAP060
                                                                                              CAP060
     C                   MOVEL     V_PRCHTP      WACODE            1                          CAP060
     C                   MOVEL     V_PRPSSN      WSECNM           10                          CAP060
     C**********         IF        V_PRPCNM <>  *ZEROS                                 CAP060 CSD027
     C                   IF        V_PRPCNM <>  *BLANKS                                       CSD027
     C                   MOVEL     V_PRPCNM      WCUSNM           10                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      *BLANKS       WCUSNM                                       CAP060
     C                   END                                                                  CAP060
     C                   MOVEL     V_PRPMKT      WMARKT            1                          CAP060
     C                   MOVEL     V_PRPBOK      WBOOK             2                          CAP060
     C                   MOVEL     V_PRPRFC      WPROFC            4                          CAP060
     C                   MOVEL     V_PRPPRT      WPRCTP            2                          CAP060
     C                   MOVEL     V_PRPTFR      WPORTRF           4                          CAP060
     C                   MOVEL     V_PRPBRA      WBRNCH            3                          CAP060
     C                   IF        CAC005 = 'Y'                                               CAP060
     C                   MOVEL     V_PRPBCD      WBOOK             2                          CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
                                                                                              CAP060
      ** Determine whether program is running interactively or in batch                       CAP060
      **  ( 0 = batch   1 = interactive)                                                      CAP060
      *                                                                                       CAP060
     C                   CALLB     'ZARTVJOBA'                                                CAP060
     C                   PARM                    @Return           6                          CAP060
     C                   PARM                    @Type             1                          CAP060
      *                                                                                       CAP060
      * Allow access to transaction record by Front-Office ID when in Repair                  CAP060
      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT                    CAP060
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~                    CAP060
      *                 b) action code is Insert - 'I'                                        CAP060
      *                 c) Front-Office Id is NOT Blank                                       CAP060
      *                                                                                       CAP060
     C     @Type         IFEQ      '1'                                                        CAP060
     C     V_PRCHTP      ANDEQ     'I'                                                        CAP060
     C     V_PRFRNT      ANDNE     *BLANKS                                                    CAP060
      *                                                                                       CAP060
     C                   MOVE      '*FRONT'      @@MODE                                       CAP060
      *                                                                                       CAP060
     C                   ELSE                                                                 CAP060
      *                                                                                       CAP060
      * Otherwise, if running in batch use Front-Office ID                                    CAP060
      *            (if insert)                                                                CAP060
      *            else, use Midas Deal Number                                                CAP060
      *                                                                                       CAP060
     C     @Type         IFEQ      '0'                                                        CAP060
     C     V_PRCHTP      ANDEQ     'I'                                                        CAP060
     C                   MOVE      '*FRONT'      @@MODE                                       CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      *BLANKS       @@MODE                                       CAP060
     C                   END                                                                  CAP060
     C                   END                                                                  CAP060
                                                                                              CAP060
     C                   CALLB     'SEPRCSRTV'                                                CAP060
      * INPUTS                                                                                CAP060
     C                   PARM      *BLANK        RetCodeOut                                   CAP060
      *                                                                                       CAP060
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  CAP060
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              CAP060
      *                                                                                       CAP060
     C                   PARM                    @@MODE            6                          CAP060
      *                                                                                       CAP060
     C                   PARM      ' '           @@RSMD            1                          CAP060
     C                   PARM      V_PRFRNT      FOTRID           20                          CAP060
     C                   PARM                    WACODE                                       CAP060
     C                   PARM                    WSECNM                                       CAP060
     C                   PARM                    WCUSNM                                       CAP060
     C                   PARM                    WMARKT                                       CAP060
     C                   PARM                    WBRNCH                                       CAP060
     C                   PARM                    WBOOK                                        CAP060
     C                   PARM                    WPROFC            4                          CAP060
     C                   PARM                    WPRCTP                                       CAP060
     C                   PARM                    WPORTRF                                      CAP060
     C                   PARM                    BVEXOP                                       CAP060
      * OUTPUTS                                                                               CAP060
     C                   PARM                    CHKPRCSFMT                                   CAP060
     C                   PARM                    PBCD              2                          CAP060
     C                   PARM                    PBOK              2                          CAP060
     C                   PARM                    PRFC              4                          CAP060
     C                   PARM                    PCNM                                         CAP060
     C                   PARM                    DDCURP           16                          CAP060
     C                   PARM      *BLANK        DDACTNOK          1                          CAP060
     C                   PARM                    DDSSNOK           1                          CAP060
     C                   PARM                    DDPCNMOK          1                          CAP060
     C                   PARM                    DDPMKTOK          1                          CAP060
     C                   PARM                    DDPBRAOK          1                          CAP060
     C                   PARM                    DDPBOKOK          1                          CAP060
     C                   PARM                    DDPRFCOK          1                          CAP060
     C                   PARM                    DDPRTOK           1                          CAP060
     C                   PARM                    DDPTFROK          1                          CAP060
     C                   PARM      *BLANK        FldNameArr                                   CAP060
     C                   PARM      *BLANK        MsgIdArr                                     CAP060
     C                   PARM      *BLANK        MsgDtaArr                                    CAP060
     C                   PARM      *BLANK        WFldNamArr                                   CAP060
     C                   PARM      *BLANK        WMsgIdArr                                    CAP060
     C                   PARM      *BLANK        WMsgDtaArr                                   CAP060
     C                   PARM      *ZERO         Idx                                          CAP060
     C                   PARM      *ZERO         WIDX                                         CAP060
     C                   PARM                    @CR997            4                          CAP060
      *                                                                                       CAP060
      ** Error if Timestamp is not the same (record has been changed                          CAP060
      **  by another workstation)                                                             CAP060
                                                                                              CAP060
      ** Processing varies according to mode program is running in.                           CAP060
      ** In interacive mode simply check whether the timestamp field                          CAP060
      ** has been updated since the original price details were fetched                       CAP060
      ** by this program.                                                                     CAP060
      ** In batch (API input) check return parameters from Retrieve                           CAP060
      ** module for errors, and send message to system operator.                              CAP060
                                                                                              CAP060
      ** Interactive mode:                                                                    CAP060
                                                                                              CAP060
     C     @TYPE         IFEQ      '1'                                                        CAP060
                                                                                              CAP060
     C     CHPRTMST      IFNE      V_PRTMESTMP                                                CAP060
     C                   MOVEL     '*RECUPD'     @@RTCD                                       CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
      ** Batch mode:                                                                          CAP060
     C                   ELSE                                                                 CAP060
     C                   IF        DDACTNOK = 'N' OR                                          CAP060
     C                             DDSSNOK  = 'N' OR                                          CAP060
     C                             DDPCNMOK = 'N' OR                                          CAP060
     C                             DDPMKTOK = 'N' OR                                          CAP060
     C                             DDPBRAOK = 'N' OR                                          CAP060
     C                             DDPBOKOK = 'N' OR                                          CAP060
     C                             DDPRFCOK = 'N' OR                                          CAP060
     C                             DDPRTOK  = 'N' OR                                          CAP060
     C                             DDPTFROK = 'N'                                             CAP060
     C                   MOVEL     '*RECUPD'     @@RTCD                                       CAP060
     C                   Z-ADD     1             C                 2 0                        CAP060
                                                                                              CAP060
     C     C             DOWLE     ArrayMax                                                   CAP060
     C     FldNameArr(C) ANDNE     *BLANKS                                                    CAP060
     C                   CLEAR                   DBError         132                          CAP060
     C                   CALLB     'ZAMSGTOOPR'                                               CAP060
     C                   PARM                    MsgSndRtn        10                          CAP060
     C                   PARM                    DBError                                      CAP060
     C                   PARM                    DummyMsgID                                   CAP060
     C                   PARM                    DummyMsgF                                    CAP060
     C                   ADD       1             C                                            CAP060
     C                   ENDDO                                                                CAP060
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
      *****************************************************************                       CAP060
      /EJECT                                                                                  CAP060
      ****************************************************************                        CAP060
      *                                                              *                        CAP060
      * SrINSRT- Insert a Transaction  Details                       *                        CAP060
      *                                                              *                        CAP060
      ****************************************************************                        CAP060
     C     SrINSRT       BEGSR                                                                CAP060
                                                                                              CAP060
      ** Access Transaction Details                                                           CAP060
                                                                                              CAP060
     C                   MOVEL     V_PRPSSN      @PSSN                                        CAP060
     C                   MOVEL     V_PRPCNM      @PCNM                                        CAP060
     C                   MOVEL     V_PRPMKT      @PMKT                                        CAP060
     C                   MOVEL     V_PRPBRA      @PBRA                                        CAP060
     C                   MOVEL     V_PRPBOK      @PBOK                                        CAP060
     C                   MOVEL     V_PRPPRT      @PPRT                                        CAP060
     C                   MOVEL     V_PRPTFR      @PTFR                                        CAP060
                                                                                              CAP060
     C     @PRICK        CHAIN     PRICE                                                      CAP060
      *                                                                                       224448
      * Set indicator for insert over existing record                                         224448
      *                                                                                       224448
     C                   MOVE      ' '           Insert                                       224448
     C                   IF        NOT %FOUND(PRICE)                                          224448
     C                   MOVE      'Y'           Insert                                       224448
     C                   ELSE                                                                 224448
     C     RECI          IFEQ      '*'                                                        224448
     C                   MOVE      'Y'           Insert                                       224448
     C/COPY WNCPYSRC,SEH00116
     C                   ENDIF                                                                224448
     C                   ENDIF                                                                224448
                                                                                              CAP060
      ** Initialize Transaction Detail                                                        CAP060
                                                                                              CAP060
     C                   CLEAR                   PRICED                                       CAP060
     C                   Z-ADD     0             PRCRSK                                       CAS006
     C                   Z-ADD     0             PRLQPR                                       CAS006
                                                                                              CAP060
      ** Store Old fields for comparisons                                                     CAP060
     C                   MOVEL(P)  PRICED        WBFRIMG                                      CAP060
                                                                                              CAP060
     C                   MOVE      'D'           RECI                                         CAP060
     C                   MOVEL     V_PRPSSN      PSSN                                         CAP060
     C                   MOVEL     V_PRPPRT      PPRT                                         CAP060
     C                   Z-ADD     V_PRPVDT      PVDT                                         CAP060
     C                   MOVEL     V_PRPCNM      PCNM                                         CAP060
     C                   MOVEL     V_PRPMKT      PMKT                                         CAP060
     C                   MOVEL     V_PRPBRA      PBRA                                         CAP060
     C                   MOVEL     V_PRPBOK      PBOK                                         CAP060
     C                   Z-ADD     V_PRPPRC      PPRC                                         CAP060
     C                   MOVEL     V_PRPNTV      PNTV                                         CAP060
     C                   MOVE      BJRDNB        LCD                                          CAP060
     C                   MOVE      'I'           CHTP                                         CAP060
     C                   MOVEL     V_PRTNLU      TNLU                                         CAP060
     C                   MOVEL     V_PRPSRC      PSRC                                         CAP060
     C                   MOVEL     V_PRPBWN      PBWN                                         CAP060
     C                   MOVEL     V_PRPPWN      PPWN                                         CAP060
     C                   MOVEL     V_PRPTFR      PTFR                                         CAP060
     C                   MOVEL     V_PRNPXR      NPXR                                         CAP060
     C                   MOVEL     V_PRNPMD      NPMD                                         CAP060
     C                   MOVEL     V_PRDFTS      PRDFTS                                       CAP060
     C                   MOVEL     V_PRFRNT      PRFRNT                                       CAP060
     C                   MOVEL     V_PRAFRT      PRAFRT                                       CAP060
     C                   MOVEL     V_PRREPA      PRREPA                                       CAP060
     C                   MOVEL     V_PRDTFR      PRDTFR                                       CAP060
     C                   MOVEL     *BLANKS       PRTLEX                                       CAP060
                                                                                              CGL031
      ** Taxation of Savings Income                                                           CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     V_PRPEXI      PEXI                                         CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   Z-ADD     V_PRBDPR      PRBDPR                                       CSD010
     C                   Z-ADD     V_PROFPR      PROFPR                                       CSD010
     C                   Z-ADD     V_PRCLPR      PRCLPR                                       CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAP060
      ** Clear before image of interest rate details for action insert                        CAP060
                                                                                              CAP060
     C                   MOVE      *BLANKS       WBFRIMG                                      CAP060
      *                                                                                       CAP060
      ** Timestamp                                                                            CAP060
     C                   CALLB     'ZAGENTMSTM'                                               CAP060
     C                   PARM                    TimeStamp                                    CAP060
                                                                                              CAP060
     C                   EVAL      PRTMST  = TimeStamp                                        CAP060
     C                   EVAL      EXVMESTMP = TimeStamp                                      CAP060
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        PRFRNT = *BLANKS                                           CSC011
     C     PSSN          CHAIN     SECTY                              01                      CSC011
     C                   IF        *IN01 = *Off                                               CSC011
     C                   EVAL      PRFRNT = SC_SPID                                           CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C**********         IF        CAS006 = 'Y' AND (PPRT = 'V'                        CAS006 229135
     C**********                   OR PPRT = 'DT' OR PPRT = 'DV')                      CAS006 229135
     C                   IF        CAS006 = 'Y' AND (V_PRPPRT = 'V'                           229135
     C                             OR V_PRPPRT = 'DT' OR V_PRPPRT = 'DV')                     229135
     C                   EVAL      PRCRSK = V_PRCRSK                                          CAS006
     C                   EVAL      PRLQPR = V_PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
     C/COPY WNCPYSRC,SEH00097
                                                                                              CAP060
      ** Write or update new security details                                                 CAP060
      ** May be an update because the security may have been previously deleted by            CAP060
      ** putting a '*' on the RECID                                                           CAP060
                                                                                              CAP060
     C                   IF        NOT %FOUND(PRICE)                                          CAP060
     C                   WRITE     PRICEDF                                                    CAP060
     C                   ELSE                                                                 CAP060
     C                   UPDATE    PRICEDF                                                    CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00098
                                                                                              CAP060
      ** If CAC005 is installed, add the same record to SEPRICPD                              CAP060
     C                   IF        CAC005 = 'Y'                                               CAP060
      *
      * Check for existing record.
      *                                                                                       CAP060
     C                   EVAL      P_PSSN=PSSN                                                CAP060
     C                   EVAL      P_PCNM=PCNM                                                CAP060
     C                   EVAL      P_PMKT=PMKT                                                CAP060
     C                   EVAL      P_PBRA=PBRA                                                CAP060
     C                   EVAL      P_PBCD = V_PRPBCD                                          CAP060
     C                   EVAL      P_PRFC =  V_PRPRFC                                         CAP060
     C                   EVAL      P_PPRT=PPRT                                                CAP060
     C                   EVAL      P_PTFR=PTFR                                                CAP060
                                                                                              CAP060
     C     KSEPRC        CHAIN     SEPRICPD                                                   CAP060
     C                                                                                        CAP060
     C                   EVAL      P_RECI = RECI                                              CAP060
     C                   EVAL      P_PVDT = PVDT                                              CAP060
     C                   EVAL      P_PBOK= PBOK                                               CAP060
     C                   EVAL      P_PPRC = PPRC                                              CAP060
     C                   EVAL      P_PNTV = PNTV                                              CAP060
     C                   EVAL      P_LCD  = LCD                                               CAP060
     C                   EVAL      P_CHTP = CHTP                                              CAP060
     C                   EVAL      P_TNLU = TNLU                                              CAP060
     C                   EVAL      P_PSRC = PSRC                                              CAP060
     C                   EVAL      P_PBWN = PBWN                                              CAP060
     C                   EVAL      P_PPWN = PPWN                                              CAP060
     C                   EVAL      P_NPXR = NPXR                                              CAP060
     C                   EVAL      P_NPMD = NPMD                                              CAP060
     C                   EVAL      P_PRDFTS= PRDFTS                                           CAP060
     C                   EVAL      P_PRFRNT= PRFRNT                                           CAP060
     C                   EVAL      P_PRAFRT= PRAFRT                                           CAP060
     C                   EVAL      P_PRREPA= PRREPA                                           CAP060
     C                   EVAL      P_PRTMST= PRTMST                                           CAP060
     C                   EVAL      P_PRDTFR =PRDTFR                                           CAP060
     C                   EVAL      P_PRTLEX =*BLANKS                                          CAP060
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        P_PRFRNT = *BLANKS                                         CSC011
     C                   EVAL      P_PRFRNT = SC_SPID                                         CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EVAL      P_PRBDPR = PRBDPR                                          CSD010
     C                   EVAL      P_PROFPR = PROFPR                                          CSD010
     C                   EVAL      P_PRCLPR = PRCLPR                                          CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** If record not existing, initialise new fields of Hedge                               CAS006
      ** Accounting                                                                           CAS006
                                                                                              CAS006
     C                   IF        NOT %FOUND(SEPRICPD)                                       CAP060
     C                   EVAL      P_PRCRSK = 0                                               CAS006
     C                   EVAL      P_PRLQPR = 0                                               CAS006
     C                   ENDIF                                                                CAP060
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (PPRT = 'V'                               CAS006
     C                             OR PPRT = 'DT' OR PPRT = 'DV')                             CAS006
     C                   EVAL      P_PRCRSK = PRCRSK                                          CAS006
     C                   EVAL      P_PRLQPR = PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
      *
      *
      * If not found insert new record.
      *
     C                   IF        NOT %FOUND(SEPRICPD)                                       CAP060
     C                   WRITE     SEPRICD0                                                   CAP060
     C                   ELSE                                                                 CAP060
     C                   UPDATE    SEPRICD0                                                   CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
      * Get AUDIT Record.                                                                     CAP060
      *                                                                                       CAP060
     C     1             SETLL     PRICEA                                                     CAP060
     C                   READ      PRICEAF                                98                  CAP060
     C** Update AUDIT Record if found                                                         CAP060
     C     *IN98         IFEQ      '0'                                                        CAP060
     C** For Insert, Update Live records inserted today, and No. of live                      CAP060
     C** records                                                                              CAP060
     C     Insert        IFEQ      'Y'                                                        224448
     C                   ADD       1             SINS                                         CAP060
     C                   ADD       1             NORE                                         CAP060
     C                   ELSE                                                                 224448
     C** For Amends, Update No. of Records amended today.                                     224448
     C                   ADD       1             SAMD                                         224448
     C                   ENDIF                                                                224448
     C** Update AUDIT record                                                                  CAP060
     C                   UPDATE    PRICEAF                                                    CAP060
     C                   ENDIF                                                                CAP060
     C                   MOVE      ' '           Insert                                       224448
      *                                                                                       CAP060
      * If the EXTEL option indicator present, update PF/EXVALD                               CAP060
      *                                                                                       CAP060
     C     BVEXOP        IFEQ      'Y'                                                        CAP060
     C     V_PRPPRT      ANDEQ     'V'                                                        CAP060
     C     PSSN          CHAIN     EXVALDF                            70                      CAP060
      *                                                                                       CAP060
      * If it is a 'live' record.                                                             CAP060
      *                                                                                       CAP060
     C     *IN70         IFEQ      '0'                                                        CAP060
     C     RECI          ANDEQ     'D'                                                        CAP060
     C                   MOVEL     'D'           RECI                                         CAP060
     C                   MOVEL(P)  EXVSESN       SESN                                         CAP060
     C                   Z-ADD     EXVA1P        A1P                                          CAP060
     C                   MOVE      EXVEXAP       EXAP                                         CAP060
     C                   Z-ADD     EXVUPBD       UPBD                                         CAP060
     C                   Z-ADD     EXVLPBD       LPBD                                         CAP060
     C                   Z-ADD     EXVPMOV       PMOV                                         CAP060
     C                   Z-ADD     EXVLCD        LCD                                          CAP060
     C                   MOVE      'A'           CHTP                                         CAP060
     C                   Z-ADD     EXVTNLU       TNLU                                         CAP060
     C                   MOVE      EXVMESTMP     PRTMST                                       CAP060
      * Update PF/EXVALD                                                                      CAP060
     C                   UPDATE    EXVALDF                                                    CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00099
     C                   ENDSR                                                                CAP060
      ****************************************************************                        CAP060
      /EJECT                                                                                  CAP060
      ****************************************************************                        CAP060
      *                                                              *                        CAP060
      * SrAMEND- Amend a security details                            *                        CAP060
      *                                                              *                        CAP060
      ****************************************************************                        CAP060
     C     SrAMEND       BEGSR                                                                CAP060
                                                                                              CAP060
      ** Access security details                                                              CAP060
                                                                                              CAP060
     C                   MOVEL     V_PRPSSN      @PSSN                                        CAP060
     C                   MOVEL     V_PRPCNM      @PCNM                                        CAP060
     C                   MOVEL     V_PRPMKT      @PMKT                                        CAP060
     C                   MOVEL     V_PRPBRA      @PBRA                                        CAP060
     C                   MOVEL     V_PRPBOK      @PBOK                                        CAP060
     C                   MOVEL     V_PRPPRT      @PPRT                                        CAP060
     C                   MOVEL     V_PRPTFR      @PTFR                                        CAP060
                                                                                              CAP060
     C     @PRICK        CHAIN     PRICE                                                      CAP060
                                                                                              CAP060
      ** Database error                                                                       CAP060
                                                                                              CAP060
     C                   IF        NOT %FOUND(PRICE)                                          CAP060
     C                   MOVEL     V_PRPSSN      DBKEY                                        CAP060
     C                   MOVEL     'PRICED'      DBFILE                         ************  CAP060
     C                   MOVEL     '903'         DBASE                          * DBERR 903*  CAP060
     C                   EXSR      SRERR                                        ************  CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00100
                                                                                              CAP060
      ** Save before image of the price details                                               CAP060
                                                                                              CAP060
     C                   MOVEL(P)  PRICED        WBFRIMG                                      CAP060
     C                   MOVE      'D'           RECI                                         CAP060
     C                   MOVEL     V_PRPSSN      PSSN                                         CAP060
     C                   MOVEL     V_PRPPRT      PPRT                                         CAP060
     C                   Z-ADD     V_PRPVDT      PVDT                                         CAP060
     C                   MOVEL     V_PRPCNM      PCNM                                         CAP060
     C                   MOVEL     V_PRPMKT      PMKT                                         CAP060
     C                   MOVEL     V_PRPBRA      PBRA                                         CAP060
     C                   MOVEL     V_PRPBOK      PBOK                                         CAP060
     C                   Z-ADD     V_PRPPRC      PPRC                                         CAP060
     C                   MOVEL     V_PRPNTV      PNTV                                         CAP060
     C                   MOVE      BJRDNB        LCD                                          CAP060
     C                   MOVE      'A'           CHTP                                         CAP060
     C                   MOVEL     V_PRTNLU      TNLU                                         CAP060
     C                   MOVEL     V_PRPSRC      PSRC                                         CAP060
     C                   MOVEL     V_PRPBWN      PBWN                                         CAP060
     C                   MOVEL     V_PRPPWN      PPWN                                         CAP060
     C                   MOVEL     V_PRPTFR      PTFR                                         CAP060
     C                   MOVEL     V_PRNPXR      NPXR                                         CAP060
     C                   MOVEL     V_PRNPMD      NPMD                                         CAP060
     C                   MOVEL     V_PRDFTS      PRDFTS                                       CAP060
     C                   MOVEL     V_PRFRNT      PRFRNT                                       CAP060
     C                   MOVEL     V_PRAFRT      PRAFRT                                       CAP060
     C                   MOVEL     V_PRREPA      PRREPA                                       CAP060
     C                   MOVEL     V_PRDTFR      PRDTFR                                       CAP060
     C                   MOVEL     *BLANKS       PRTLEX                                       CAP060
                                                                                              CGL031
      ** Taxation of Savings Income                                                           CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   Z-ADD     V_PRPEXI      PEXI                                         CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   Z-ADD     V_PRBDPR      PRBDPR                                       CSD010
     C                   Z-ADD     V_PROFPR      PROFPR                                       CSD010
     C                   Z-ADD     V_PRCLPR      PRCLPR                                       CSD010
     C                   ENDIF                                                                CSD010
      *                                                                                       CAP060
      ** Timestamp                                                                            CAP060
     C                   CALLB     'ZAGENTMSTM'                                               CAP060
     C                   PARM                    TimeStamp                                    CAP060
                                                                                              CAP060
     C                   EVAL      PRTMST  = TimeStamp                                        CAP060
     C                   EVAL      EXVMESTMP = TimeStamp                                      CAP060
                                                                                              CAP060
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C**********         IF        CAS006 = 'Y' AND (PPRT = 'V'                        CAS006 229135
     C**********                   OR PPRT = 'DT' OR PPRT = 'DV')                      CAS006 229135
     C                   IF        CAS006 = 'Y' AND (V_PRPPRT = 'V'                           229135
     C                             OR V_PRPPRT = 'DT' OR V_PRPPRT = 'DV')                     229135
     C                   EVAL      PRCRSK = V_PRCRSK                                          CAS006
     C                   EVAL      PRLQPR = V_PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAP060
     C/COPY WNCPYSRC,SEH00101
                                                                                              CAP060
      * Update Price record                                                                   CAP060
     C                   IF        %FOUND(PRICE)                                              CAP060
     C                   UPDATE    PRICEDF                                                    CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
      *                                                                                       CAP060
      * Set indicator for insert over existing record                                         CAP060
      *                                                                                       CAP060
     C     RECI          IFEQ      '*'                                                        CAP060
     C                   MOVE      'Y'           Insert                                       CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00102
      *                                                                                       CAP060
      * Get AUDIT Record.                                                                     CAP060
      *                                                                                       CAP060
     C     1             SETLL     PRICEA                                                     CAP060
     C                   READ      PRICEAf                                98                  CAP060
     C** Update AUDIT Record if found                                                         CAP060
     C     *IN98         IFEQ      '0'                                                        CAP060
     C     Insert        IFEQ      'Y'                                                        CAP060
     C/COPY WNCPYSRC,SEH00103
     C** Update for insert over deleted record                                                CAP060
     C                   ADD       1             SINS                                         CAP060
     C                   ADD       1             NORE                                         CAP060
     C                   ELSE                                                                 CAP060
     C** For Amends, Update No. of Records amended today.                                     CAP060
     C                   ADD       1             SAMD                                         CAP060
     C                   ENDIF                                                                CAP060
     C** Update AUDIT record                                                                  CAP060
     C                   UPDATE    PRICEAF                                                    CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CAP060
      * If CAC005 is installed, update record in SEPRICPD                                     CAP060
      *                                                                                       CAP060
     C     CAC005        IFEQ      'Y'                                                        CAP060
      *                                                                                       CAP060
      * Check for existing record.                                                            CAP060
      *                                                                                       CAP060
     C                   EVAL      P_PSSN=PSSN                                                CAP060
     C                   EVAL      P_PCNM=PCNM                                                CAP060
     C                   EVAL      P_PMKT=PMKT                                                CAP060
     C                   EVAL      P_PBRA=PBRA                                                CAP060
     C                   EVAL      P_PBCD=V_PRPBCD                                            CAP060
     C                   EVAL      P_PRFC=V_PRPRFC                                            CAP060
     C                   EVAL      P_PPRT=V_PRPPRT                                            CAP060
     C                   EVAL      P_PTFR=PTFR                                                CAP060
                                                                                              CAP060
     C     KSEPRC        CHAIN     SEPRICPD                                                   CAP060
                                                                                              CAP060
     C                   IF        %FOUND                                                     CAP060
     C                   EVAL      P_RECI = RECI                                              CAP060
     C                   EVAL      P_PVDT = PVDT                                              CAP060
     C                   EVAL      P_PBOK= PBOK                                               CAP060
     C                   EVAL      P_PPRC = PPRC                                              CAP060
     C                   EVAL      P_PNTV = PNTV                                              CAP060
     C                   EVAL      P_LCD  = LCD                                               CAP060
     C                   EVAL      P_CHTP = CHTP                                              CAP060
     C                   EVAL      P_TNLU = TNLU                                              CAP060
     C                   EVAL      P_PSRC = PSRC                                              CAP060
     C                   EVAL      P_PBWN = PBWN                                              CAP060
     C                   EVAL      P_PPWN = PPWN                                              CAP060
     C                   EVAL      P_NPXR = NPXR                                              CAP060
     C                   EVAL      P_NPMD = NPMD                                              CAP060
     C                   EVAL      P_PRDFTS= PRDFTS                                           CAP060
     C                   EVAL      P_PRFRNT= PRFRNT                                           CAP060
     C                   EVAL      P_PRAFRT= PRAFRT                                           CAP060
     C                   EVAL      P_PRREPA= PRREPA                                           CAP060
     C                   EVAL      P_PRTMST= PRTMST                                           CAP060
     C                   EVAL      P_PRDTFR =PRDTFR                                           CAP060
     C                   EVAL      P_PRTLEX =*BLANKS                                          CAP060
     C/COPY WNCPYSRC,SEH00104
                                                                                              CSD010
      ** If CSD010 is installed, populate Bid Price, Offer Price and                          CSD010
      ** Closing Price Fields                                                                 CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EVAL      P_PRBDPR = PRBDPR                                          CSD010
     C                   EVAL      P_PROFPR = PROFPR                                          CSD010
     C                   EVAL      P_PRCLPR = PRCLPR                                          CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed and Price Type is                           CAS006
      ** 'V', 'DT' or 'DV', move Credit Risk Spread and Liquidity                             CAS006
      ** Premium fields.                                                                      CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND (PPRT = 'V'                               CAS006
     C                             OR PPRT = 'DT' OR PPRT = 'DV')                             CAS006
     C                   EVAL      P_PRCRSK = PRCRSK                                          CAS006
     C                   EVAL      P_PRLQPR = PRLQPR                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSD010
     C/COPY WNCPYSRC,SEH00105
     C                   UPDATE    SEPRICD0                                                   CAP060
     C/COPY WNCPYSRC,SEH00106
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00107
      *                                                                                       CAP060
      * If the EXTEL option indicator present, update PF/EXVALD                               CAP060
      *                                                                                       CAP060
     C     BVEXOP        IFEQ      'Y'                                                        CAP060
     C     V_PRPPRT      ANDEQ     'V'                                                        CAP060
     C     PSSN          CHAIN     EXVALDF                            70                      CAP060
      *                                                                                       CAP060
      * If it is a 'live' record.                                                             CAP060
      *                                                                                       CAP060
     C     *IN70         IFEQ      '0'                                                        CAP060
     C     RECI          ANDEQ     'D'                                                        CAP060
      * Update PF/EXVALD                                                                      CAP060
     C                   MOVEL     'D'           RECI                                         CAP060
     C                   MOVEL(P)  EXVSESN       SESN                                         CAP060
     C                   Z-ADD     EXVA1P        A1P                                          CAP060
     C                   MOVE      EXVEXAP       EXAP                                         CAP060
     C                   Z-ADD     EXVUPBD       UPBD                                         CAP060
     C                   Z-ADD     EXVLPBD       LPBD                                         CAP060
     C                   Z-ADD     EXVPMOV       PMOV                                         CAP060
     C                   Z-ADD     EXVLCD        LCD                                          CAP060
     C                   MOVE      EXVCHTP       CHTP                                         CAP060
     C/COPY WNCPYSRC,SEH00108
     C                   Z-ADD     EXVTNLU       TNLU                                         CAP060
     C                   MOVE      EXVMESTMP     PRTMST                                       CAP060
     C                   UPDATE    EXVALDF                                                    CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00109
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
      ****************************************************************                        CAP060
      /EJECT                                                                                  CAP060
      ****************************************************************                        CAP060
      *                                                              *                        CAP060
      * SrDELET- DELETE A CUSTOMER                                   *                        CAP060
      *                                                              *                        CAP060
      ****************************************************************                        CAP060
     C     SrDELET       BEGSR                                                                CAP060
                                                                                              CAP060
      ** Access security details                                                              CAP060
                                                                                              CAP060
     C                   MOVEL     V_PRPSSN      @PSSN                                        CAP060
     C                   MOVEL     V_PRPCNM      @PCNM                                        CAP060
     C                   MOVEL     V_PRPMKT      @PMKT                                        CAP060
     C                   MOVEL     V_PRPBRA      @PBRA                                        CAP060
     C                   MOVEL     V_PRPBOK      @PBOK                                        CAP060
     C                   MOVEL     V_PRPPRT      @PPRT                                        CAP060
     C                   MOVEL     V_PRPTFR      @PTFR                                        CAP060
                                                                                              CAP060
     C     @PRICK        CHAIN     PRICE                                                      CAP060
                                                                                              CAP060
      ** Database error                                                                       CAP060
                                                                                              CAP060
     C                   IF        NOT %FOUND(PRICE)                                          CAP060
     C                   MOVEL     V_PRPSSN      DBKEY                                        CAP060
     C                   MOVEL     'PRICED'      DBFILE                         ************  CAP060
     C                   MOVEL     '904'         DBASE                          * DBERR 904*  CAP060
     C                   EXSR      SRERR                                        ************  CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
      ** Update 'BEFORE' status                                                               CAP060
                                                                                              CAP060
     C                   MOVEL(P)  PRICED        WBFRIMG                                      CAP060
     C                   MOVE      '*'           RECI                                         CAP060
     C                   MOVE      BJRDNB        LCD                                          CAP060
     C                   MOVE      'D'           CHTP                                         CAP060
     C                   MOVEL     V_PRTNLU      TNLU                                         CAP060
     C                   MOVEL     V_PRDFTS      PRDFTS                                       CAP060
     C                   MOVEL     V_PRFRNT      PRFRNT                                       CAP060
     C                   MOVEL     V_PRAFRT      PRAFRT                                       CAP060
     C                   MOVEL     V_PRREPA      PRREPA                                       CAP060
      *                                                                                       CAP060
      ** Timestamp                                                                            CAP060
     C                   CALLB     'ZAGENTMSTM'                                               CAP060
     C                   PARM                    TimeStamp                                    CAP060
                                                                                              CAP060
     C                   EVAL      PRTMST  = TimeStamp                                        CAP060
     C                   EVAL      EXVMESTMP = TimeStamp                                      CAP060
                                                                                              CAP060
      * Update Price record                                                                   CAP060
     C                   IF        %FOUND                                                     CAP060
     C/COPY WNCPYSRC,SEH00110
     C                   UPDATE    PRICEDF                                                    CAP060
     C/COPY WNCPYSRC,SEH00112
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00117
      *                                                                                       CAP060
      * If CAC005 is installed, update record in SEPRICPD                                     CAP060
      *                                                                                       CAP060
     C                   IF        CAC005 = 'Y'                                               CAP060
      *                                                                                       CAP060
      * Check for existing record.                                                            CAP060
      *                                                                                       CAP060
     C                   EVAL      P_PSSN=PSSN                                                CAP060
     C                   EVAL      P_PCNM=PCNM                                                CAP060
     C                   EVAL      P_PMKT=PMKT                                                CAP060
     C                   EVAL      P_PBRA=PBRA                                                CAP060
     C                   EVAL      P_PBCD=V_PRPBCD                                            CAP060
     C                   EVAL      P_PRFC=V_PRPRFC                                            CAP060
     C                   EVAL      P_PPRT=V_PRPPRT                                            CAP060
     C                   EVAL      P_PTFR=PTFR                                                CAP060
                                                                                              CAP060
     C     KSEPRC        CHAIN     SEPRICPD                                                   CAP060
     C                   EVAL      P_RECI='*'                                                 CAP060
     C                   EVAL      P_LCD=LCD                                                  CAP060
     C                   EVAL      P_CHTP=CHTP                                                CAP060
     C                   EVAL      P_TNLU=TNLU                                                CAP060
     C                   EVAL      P_PRDFTS= V_PRDFTS                                         CAP060
     C                   EVAL      P_PRFRNT= V_PRFRNT                                         CAP060
     C                   EVAL      P_PRAFRT= V_PRAFRT                                         CAP060
     C                   EVAL      P_PRREPA= V_PRREPA                                         CAP060
     C                   EVAL      P_PRTMST= PRTMST                                           CAP060
     C                   IF        %FOUND(SEPRICPD)
     C                   UPDATE    SEPRICD0                                                   CAP060
     C                   ENDIF                                                                CAP060
     C                   ENDIF                                                                CAP060
      * Get AUDIT Record.                                                                     CAP060
     C     1             SETLL     PRICEA                                                     CAP060
     C                   READ      PRICEAf                                98                  CAP060
     C** Update AUDIT Record if found                                                         CAP060
     C     *IN98         IFEQ      '0'                                                        CAP060
     C** Update for insert over deleted record                                                CAP060
     C                   ADD       1             SDEL                                         CAP060
     C                   SUB       1             NORE                                         CAP060
     C** Update AUDIT record                                                                  CAP060
     C                   UPDATE    PRICEAF                                                    CAP060
     C                   ENDIF                                                                CAP060
     C/COPY WNCPYSRC,SEH00118
     C                   ENDSR                                                                CAP060
      ****************************************************************                        CAP060
      /EJECT                                                                                  CAP060
     C****************************************************************                        CAP060
     C*                                                              *
     C* PRCXTF - Write a record in the Price Extra Data File         *
     C*                                                              *
     C****************************************************************
      *
     C     PRCXTF        BEGSR
      *
      * Write the Extra Data Price file
      *
     C*******************CLEAR                   PRICEX                                       189506
     C*******************MOVE      'D'           XTRECI                                       189506
     C*******************MOVE      XTVSESN       XTSESN                                       189506
     C*******************Z-ADD     XTVPVDT       XTPVDT                                       189506
     C*******************Z-ADD     XTVLPBD       XTLPBD                                       189506
     C*******************Z-ADD     XTVUPBD       XTUPBD                                       189506
     C*******************Z-ADD     XTVPMOV       XTPMOV                                       189506
     C*******************WRITE     SEPRXTD0                                                   189506
      *
      * If the EXTEL option indicator present, update PF/EXVALD
      *
     C     BVEXOP        IFEQ      'Y'
     C     V_PRPPRT      ANDEQ     'V'                                                        CAP060
     C     PSSN          CHAIN     EXVALDF                            70
      *
      * If it is a 'live' record.
      *
     C     *IN70         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C*****EXAP**********ANDEQ     ' '                                                        189506
     C*******************MOVEL     'N'           EXAP                                         189506
      * Update PF/EXVALD                                                                      189506
     C                   MOVEL     'D'           RECI                                         189506
     C                   MOVEL(P)  XTVSESN       SESN                                         189506
     C                   Z-ADD     0             A1P                                          189506
     C                   MOVE      XTVEXAP       EXAP                                         189506
     C                   Z-ADD     XTVUPBD       UPBD                                         189506
     C                   Z-ADD     XTVLPBD       LPBD                                         189506
     C                   Z-ADD     XTVPMOV       PMOV                                         189506
     C                   MOVE      BJRDNB        LCD                                          189506
     C                   MOVE      'A'           CHTP                                         189506
     C                   Z-ADD     0             TNLU                                         189506
     C                   MOVE      XTTMESTMP     PRTMST                                       189506
     C                   UPDATE    EXVALDF                                                    189506
     C                   ENDIF                                                                189506
     C                   ENDIF                                                                189506
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * EXVLSR - PF/EXVALD Exception Error Subroutine.                *
      *                                                               *
      * Calls: *PSSR                                                  *
      *                                                               *
      *****************************************************************
     C     EXVLSR        BEGSR
      *
     C                   MOVEL     PSSN          DBKEY
     C                   MOVEL     'EXVALD'      DBFILE
     C                   MOVEL     '902'         DBASE
      *
      *  Perform exception error handling subroutine.
      *
     C                   EXSR      SRERR
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Entry parameters.
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    SEVPRC
     C                   PARM                    SEVEXT                                       CAP060
     C                   PARM                    SEVPRX
     C                   PARM                    CAC005            1
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
     C/COPY WNCPYSRC,SEH00111
      *
      * Key Lists
      *
     C     @PRICK        KLIST
     C                   KFLD                    @PSSN            10
     C**********         KFLD                    @PCNM             6 0                        CSD027
     C                   KFLD                    @PCNM             6                          CSD027
     C                   KFLD                    @PMKT             1
     C                   KFLD                    @PBRA             3
     C                   KFLD                    @PBOK             2
     C                   KFLD                    @PPRT             2
     C                   KFLD                    @PTFR             4

     C     KSEPRC        KLIST
     C                   KFLD                    P_PSSN
     C                   KFLD                    P_PCNM
     C                   KFLD                    P_PMKT
     C                   KFLD                    P_PBRA
     C                   KFLD                    P_PBCD            2
     C                   KFLD                    P_PRFC            4
     C                   KFLD                    P_PPRT
     C                   KFLD                    P_PTFR

     C     KDFRQ         KLIST                                                                CAP060
     C                   KFLD                    @DFRID           32                          CAP060
     C                   KFLD                    @DFIT            20                          CAP060
      *
      * Access bank details.
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** ACCESS MIDAS MODULE DETAILS
      *  (database error handling done in access program)
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** ACCESS SECURITIES TRADING DETAILS
      *
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *                                                                                       CAP060
     C                   CALL      'AOSARDR0'                                                 CAP060
     C                   PARM      *BLANKS       @RTCD                                        CAP060
     C                   PARM      '*VERIFY'     @OPTN                                        CAP060
     C                   PARM      'CAP060'      @SARD             6                          CAP060
      *                                                                                       CAP060
     C     @RTCD         IFEQ      *BLANKS                                                    CAP060
     C                   MOVE      'Y'           CAP060F           1                          CAP060
     C                   ELSE                                                                 CAP060
     C                   MOVE      'N'           CAP060F                                      CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CSD006
     C                   CALL      'AOSARDR0'                                                 CSD006
     C                   PARM      *BLANKS       @RTCD                                        CSD006
     C                   PARM      '*VERIFY'     @OPTN                                        CSD006
     C                   PARM      'CSD006'      @SARD             6                          CSD006
      *                                                                                       CSD006
     C     @RTCD         IFEQ      *BLANKS                                                    CSD006
     C                   MOVE      'Y'           CSD006F           1                          CSD006
     C                   ELSE                                                                 CSD006
     C                   MOVE      'N'           CSD006F                                      CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSC011
      ** Check if 24x7 Midas Availability is installed                                        CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *Blanks       PRetCode                                     CSC011
     C                   PARM      '*VERIFY'     POption                                      CSC011
     C                   PARM      'CSC011'      PKey                                         CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRetCode = *Blanks                                         CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   IF        PRetCode <> '*NRF   '                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBASE  = 905                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011

      ** Access switchable features file - Collateralised Lending (CSD010)                    CSD010
                                                                                              CSD010
     C                   CALL      'AOSARDR0'                                                 CSD010
     C                   PARM      *BLANKS       PRetCode                                     CSD010
     C                   PARM      '*VERIFY'     POption                                      CSD010
     C                   PARM      'CSD010'      PKey                                         CSD010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD010
                                                                                              CSD010
     C                   IF        PRetCode <> *BLANKS AND                                    CSD010
     C                             PRetCode <> '*NRF   '                                      CSD010
     C                   EVAL      DBASE = 906                                                CSD010
     C                   EVAL      DBKEY = 'CSD010'                                           CSD010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD010
     C                   EXSR      *PSSR                                                      CSD010
     C                   ENDIF                                                                CSD010
     C                                                                                        CSD010
     C                   IF        PRetCode = *BLANKS                                         CSD010
     C                   EVAL      CSD010 = 'Y'                                               CSD010
     C                   ELSE                                                                 CSD010
     C                   EVAL      CSD010 = 'N'                                               CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CAS006
      ** Access switchable features file - Hedge Accounting Phase B (CAS006)                  CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PKey                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRetCode <> *BLANKS AND                                    CAS006
     C                             PRetCode <> '*NRF   '                                      CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBASE = 907                                                CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBMOD = 'SEPRCSUPD'                                        CAS006
     C                   EVAL      DBPGM = 'SEPRCSUPD'                                        CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRetCode = *BLANKS                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
      *
     C                   EVAL      RECI2 = *BLANK                                            BUG8872
     C/COPY WNCPYSRC,SEH00113
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'SEPRCSUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
