     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Price/Discount/Yield')         *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading                                     *
      *                                                               *
      *  SEVTPRCDY - Validate Trade Price/Discount/Yield.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL031             Date 05Jul04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08MAR99               *
      *                 CAP003  *CREATE    Date 12Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE074 - Const. Yld Amort. Upgrade to MidasPlus (Recompile)  *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPRICM     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** WORKING VARIABLES
 
     D APWRK1          S             15P 8
     D APWRK2          S             15P 8
     D CKPRIC          S             15P 8
     D ZALIGNOK        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      ** --------------
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   Z-ADD     0             TPDY
      *
      ** DEFAULTING
      *
     C     Default       IFEQ      'Y'
     C     DDTPDY        ANDEQ     *BLANK
     C                   EXSR      TPDYD
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      TPDYV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTPDYOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      ** Return
      ** ------
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VALIDATION OF PRICE/DISCOUNT/YIELD                           *
      *****************************************************************
     C     TPDYV         BEGSR
      *
      **   .. mandatory if Incomplete Indicator is 'C'
      *
     C     DDINCS        IFEQ      'C'
     C     DDTPDY        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDTPDYOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDTPDY'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0481'     MsgidXAr(Idx)
     C                   GOTO      ETPDYV
     C                   END
      *
      **   .. if entered, must be a valid amount
      *
     C     DDTPDY        IFNE      *BLANKS
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDTPDY        ZFIELD
      *
     C                   CALLB     'ZALIGN'
 
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
     C                   PARM      7             ZADIG
 
     C     ZAlignOk      IFEQ      'Y'
     C                   MOVE      ZFIELD        TPDY
     C                   END
      *
     C     ZALIGNok      IFEQ      'N'
     C     ZAlignOk      OREQ      'Y'
     C     STBS          ANDEQ     'Y'
     C     TPDY          ANDGT     100
     C                   MOVE      'N'           DDTPDYOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDTPDY'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0482'     MsgidXAr(Idx)
     C                   GOTO      ETPDYV
     C                   END
     C                   END
 
      *
      **  Edit price/discount/yield for display
      *
 
     C                   MOVE (P)  *BLANKS       ZFIELD
     C                   MOVE      TPDY          ZFIELD
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      8             ZADEC
 
     C                   MOVE      ZFIELD        DDTPDY
      *
      **   .. if Discount and trade value date = maturity date
      **      price must be 0.
      *
     C     STBS          IFEQ      'D'
     C     TDVD          ANDEQ     MATY
     C     TPDY          ANDNE     0
     C                   MOVE      'N'           DDTPDYOk
     C                   ADD       1             Idx
     C                   MOVEL     'DDTPDY'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0483'     MsgidXAr(Idx)
     C                   GOTO      ETPDYV
     C                   END
      *
      ** .. Must be within 10% of market price
      *
     C     S01496        IFEQ      'Y'
     C                   EXSR      PRICTL1496
     C                   ELSE
     C                   EXSR      PRICTL
     C                   END
 
     C     ETPDYV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PRICTL - Price Tolerance check if S01496 not installed        *
      *                                                               *
      *****************************************************************
     C     PRICTL        BEGSR
      *
      ** GET MARKET PRICE
      *
     C                   MOVEL     SESN          PSSN
     C                   Z-ADD     BJRDNB        PVDT
     C     KPRICM        CHAIN     PRICM                              44
 
     C     *IN44         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     MKPR          PPRC
     C                   END
      *
     C     PPRC          DIV       10            APWRK1
     C     PPRC          ADD       APWRK1        APWRK2
 
     C     TPDY          IFGT      APWRK2
     C                   MOVE      'W'           DDTPDYOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDTPDY'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0484'     WMsgidXAr(WIx)
     C                   ELSE
      *
     C     PPRC          SUB       APWRK1        APWRK2
 
     C     TPDY          IFLT      APWRK2
     C                   MOVE      'W'           DDTPDYOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDTPDY'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0484'     WMsgidXAr(WIx)
     C                   END
 
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * PRICTL1496 - Price Tolerance check if S01496 installed        *
      *                                                               *
      *****************************************************************
     C     PRICTL1496    BEGSR
      *
      ** OBTAIN MARKET PRICE AS AT TRADE VALUE DATE (PUT INTO CKPRIC)
      *
     C                   MOVE      SESN          WWPSSN
     C                   Z-ADD     TDVD          WWTDVD
     C                   EXSR      GETCMKPR
      *
      ** If investment type tolerance is not present, use 10%
      *
     C     PRTO          IFEQ      0
     C                   Z-ADD     10            PRTO
     C                   END
      *
      ** Check that price is within price
      ** tolerance limit of market price as at trade date.
      *
     C     PRTO          DIV       100           APWRK1
     C     CKPRIC        MULT      APWRK1        APWRK1
     C     CKPRIC        ADD       APWRK1        APWRK2
 
     C     TPDY          IFGT      APWRK2
     C                   MOVE      'W'           DDTPDYOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDTPDY'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0484'     WMsgidXAr(WIx)
     C                   ELSE
      *
     C     CKPRIC        SUB       APWRK1        APWRK2
 
     C     TPDY          IFLT      APWRK2
     C                   MOVE      'W'           DDTPDYOk
     C                   ADD       1             WIx
     C                   MOVEL     'DDTPDY'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0484'     WMsgidXAr(WIx)
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      * GETCMKPR - Get Current Market Price
      *
      *****************************************************************
     C     GETCMKPR      BEGSR
      *
      ** KLIST FOR PRICES FILE
      *
     C     KPRICM        KLIST
     C                   KFLD                    WWPSSN           10
     C                   KFLD                    WWTDVD            5 0
      *
      ** DEFAULT PRICE IS THAT FROM THE SECURITY
      *
     C                   Z-ADD     MKPR          CKPRIC
      *
      ** FIND MARKET PRICE WITH CORRECT DATE
      *
     C     KPRICM        SETGT     PRICM
     C                   READP     PRICM                                  44
      *
      ** IF RECORD FOUND USE THIS PRICE
      *
     C     *IN44         IFEQ      '0'
     C     PSSN          ANDEQ     WWPSSN
     C                   Z-ADD     PPRC          CKPRIC
      *
      ** ..OTHERWISE CHECK FOR CURRENT PRICE
      *
     C                   ELSE
     C                   Z-ADD     *HIVAL        WWTDVD
     C     KPRICM        SETGT     PRICM
     C                   READP     PRICM                                  44
      *
      ** IF RECORD FOUND USE THIS PRICE
      *
     C     *IN44         IFEQ      '0'
     C     PSSN          ANDEQ     WWPSSN
     C                   Z-ADD     PPRC          CKPRIC
     C                   END
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** DEFAULTING OF PRICE/DISCOUNT/YIELD                           *
      *****************************************************************
     C     TPDYD         BEGSR
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
      ** Price/Discount/Yield
      ** Complete/Incomplete Indicator
     C                   PARM                    DDTPDY           16
     C                   PARM                    DDINCS            1
      *
      ** Trade Details
      ** -------------
      ** Value Date
     C                   PARM                    TDVD              5 0
      *
      ** Security Details
      ** Investment Type Price Tolerance
     C                   PARM                    SECTY
     C                   PARM                    PRTO              5 3
      *
      ** System Info
      ** -----------
      ** System Run date
      ** SAR S01496 Indicator
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    S01496            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Price/Discount/Yield Indicator
     C                   PARM                    DDTPDYok          1
      *
      ** Price/Discount/Yield
     C                   PARM                    TPDY             15 8
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
