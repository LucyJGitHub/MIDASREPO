     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot rate retrieve')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  SDSPTRRTV - Spot Rate RETRIEVE                               *
      *              (WITH ACTION CODE VERSUS Transact.NO. VALIDATION)*
      *                                                               *
      *  Function:  This module retrieves a transaction from          *
      *             the database. As it does so, it validates the     *
      *             action code and Transaction number.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. MD000091           Date 03May13               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237370             Date 26Apr06               *
      *                 BUG8550            Date 16Jun06               *
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 BUG6162            Date 02Mar05               *
      *                 BUG4064            Date 30Aug04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006  *CREATE    Date 19Oct00               *
      *                 CAP057  *CREATE    Date 19Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Taxes                              *
      *  MD000091 - Event Codes Substitution                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes                             *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  237370  - Loan all fields from SDVSPTRPD. Certain fields not *
      *            loaded causing program to blank out weekend        *
      *            indicaors for Friday and Saturday                  *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG8205 - Ensure that system will stop validation if an error*
      *            occurred. Apply fix 209061                         *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  BUG6162 - Error in maintenance due to unauthorised currency  *
      *            transaction                                        *
      *  BUG4064 - Spot Trade Account Code blanked out due to wrong   *
      *            data structure used for the passed parameter.      *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCURRL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCURRD0:SDSPRFOI)
      * Transaction File by Front Office Id
 
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(@A6REA4:SPRFMAT)
      * Transaction File by Transaction Number
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG6162
      ** RTV : Authorisation Log - by Key                                                    BUG6162
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details ICD retrieval
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
 
     D*TranFilFmt    E DS                  EXTNAME(SDCURRPD)                                 BUG4064
     D SPTRFilFmt    E DS                  EXTNAME(SDVSPTRPD)                                BUG4064
      ** Transaction Details in File Format
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
      *                                                                                     MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Ix              S              3P 0
     D KAULG           S             26A                                                     BUG6162
     D TmpDta          S             45A                                                    MD000091
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      **************************************************************
      *
      * INITIALIZATION
      *
      *                                                                                      BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      INIT
      *
      * IF THE MODE IS 'FRONT OFFICE TRANSACTION INTERFACE'
      * DO (EXTRA) VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *
     C     ModeofOp      IFEQ      '*FRONT'
     C                   EXSR      VFRNT
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   MOVE      '1'           *INLR                                       BUG8205
     C                   RETURN
     C                   END
     C                   END
      *
      * VALIDATE ACTION CODE & TRANSACTION NUMBER E.G CURRENCY CODE
      *
     C                   EXSR      VAL
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C     OKTRNN        OREQ      'N'
     C                   MOVE      '1'           *INLR                                       BUG8205
     C                   RETURN
     C                   END
      *
      *  *-----------------------------------------------*
      *  * Access Security Checking                      *
      *  *-----------------------------------------------*
      *
     C     RespMode      IFEQ      'S'
     C                   EVAL      ZACTN=DDACTN
      *
      ** If single branching
      ** ACCESS SPOT RATE CHECKING - SINGLE BRANCHING
      *
     C     BJSBRC        IFNE      *BLANK
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSRS
     C                   END
      *
      ** If multibranching
      ** ACCESS SPOT RATE CHECKING - MULTI-BRANCHING
      *
     C     BJSBRC        IFEQ      *BLANK
     C     RESPMODE      ANDEQ     'S'
     C                   EXSR      ACSSRM
     C                   END
     C                   END
      *
      **  Carry out no further validation if errors have occurred.
      *
     C     OKACTN        IFEQ      'N'
     C                   MOVE      '1'           *INLR                                       BUG8205
     C                   RETURN
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'E' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'E'
     C                   EXSR      RTVSPRT
     C                   END
      *
      *  *--------------------------------*
      *  * Validation for Action Code 'A' *
      *  *--------------------------------*
      *
     C     DDACTN        IFEQ      'A'
     C                   EXSR      RTVSPRT
     C                   END
      *
      **  Carry out no further validation if errors occurred.
     C     OKACTN        IFEQ      'N'
     C     OKTRNN        OREQ      'N'
     C                   MOVE      '1'           *INLR                                       BUG8205
     C                   RETURN
     C                   END
 
      * Return
 
     C                   MOVE      '1'           *INLR                                       BUG8205
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * ACSSRS - ACCESS SPOT RATE CHECKING - SINGLE BRANCHING
      *****************************************************************
     C     ACSSRS        BEGSR
      *
      **  Check user's authority for the action.
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    ZACTN             1
     C                   PARM                    ERR               1 0
      *
      **  If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * ACSSRM - ACCESS SPOT RATE CHECKING - MULTI-BRANCHING
      *****************************************************************
     C     ACSSRM        BEGSR
      *
      **  Check user's authority for the action & Booking Branch.
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    ZACTN             1
     C                   PARM      DBRN          ZBR               3
     C                   PARM                    ERR               1 0
      *
      **   If action invalid for user
      *
     C     ERR           IFEQ      1
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'RE71070'     MsgIdArr(Ix)
     C                   ELSE
     C     ERR           IFEQ      2
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   SELECT
     C                   WHEN      DDACTN='E'
     C                   MOVEL     'RE7105B'     MsgIdArr(Ix)
     C                   WHEN      DDACTN='A'
     C                   MOVEL     'RE7103B'     MsgIdArr(Ix)
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
      * RTVSPRT - RETRIEVE Transaction DETAILS IF ACTION CODE 'A', 'E'
      **********************************************************************
     C     RTVSPRT       BEGSR
 
     C                   IF        (DDTRNN <> *BLANK AND SubForTRNN = 0)
     C                             OR ModeofOp <> '*FRONT'
 
      * Access Transaction Details from Transaction file
     C     DDTRNN        CHAIN     SPRFMAT                            99
 
      * Transaction details not found
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'N'           OKTRNN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYCD'      FldNameArr(Ix)
     C                   MOVEL     'USR0071'     MsgIdArr(Ix)
     C                   END
     C                   END
                                                                                             BUG4064
      ** Transaction details found                                                           BUG4064
     C     *IN99         IFEQ      *OFF                                                      BUG4064
     C                   EVAL      AVCYCD  = A6CYCD                                          BUG4064
     C                   EVAL      AVCDFN  = A6CDFN                                          BUG4064
     C                   EVAL      AVECDN  = A6ECDN                                          BUG4064
     C                   EVAL      AVLCD   = A6LCD                                           BUG4064
     C                   EVAL      AVTYLC  = A6TYLC                                          BUG4064
     C                   EVAL      AVCYNM  = A6CYNM                                          BUG4064
     C                   EVAL      AVSPRT  = A6SPRT                                          BUG4064
     C                   EVAL      AVSWCY  = A6SWCY                                          BUG4064
     C                   EVAL      AVNBDP  = A6NBDP                                          BUG4064
     C                   EVAL      AVTXND  = A6TXND                                          BUG4064
     C                   EVAL      AVPRRT  = A6PRRT                                          BUG4064
     C                   EVAL      AVSRC1  = A6SRC1                                          BUG4064
     C                   EVAL      AVSRC2  = A6SRC2                                          BUG4064
     C                   EVAL      AVDLCI  = A6DLCI                                          BUG4064
     C                   EVAL      AVSSNB  = A6SSNB                                          BUG4064
     C                   EVAL      AVERLC  = A6ERLC                                          BUG4064
     C                   EVAL      AVMDIN  = A6MDIN                                          BUG4064
     C                   EVAL      AVMDPR  = A6MDPR                                          BUG4064
     C                   EVAL      AVMDHB  = A6MDHB                                          BUG4064
     C                   EVAL      AVMDEX  = A6MDEX                                          BUG4064
     C                   EVAL      AVNOSN  = A6NOSN                                          BUG4064
     C                   EVAL      AVSPDY  = A6SPDY                                          BUG4064
     C                   EVAL      AVHSRT  = A6HSRT                                          BUG4064
     C                   EVAL      AVLSPR  = A6LSPR                                          BUG4064
     C                   EVAL      AVFXSD  = A6FXSD                                          BUG4064
     C                   EVAL      AVMMSD  = A6MMSD                                          BUG4064
     C                   EVAL      AVNQDP  = A6NQDP                                          BUG4064
     C                   EVAL      AVDICB  = A6DICB                                          BUG4064
     C                   EVAL      AVSCEX  = A6SCEX                                          BUG4064
     C                   EVAL      AVEBDA  = A6EBDA                                          BUG4064
     C                   EVAL      AVHBRT  = A6HBRT                                          BUG4064
     C                   EVAL      AVENC1  = A6ENC1                                          BUG4064
     C                   EVAL      AVENC2  = A6ENC2                                          BUG4064
     C                   EVAL      AVCACD  = A6CACD                                           237370
     C                   EVAL      AVCNMC  = A6CNMC                                           237370
     C                   EVAL      AVWEDH  = A6WEDH                                           237370
     C                   EVAL      AVTUEH  = A6TUEH                                           237370
     C                   EVAL      AVWEDH  = A6WEDH                                           237370
     C                   EVAL      AVTHUH  = A6THUH                                           237370
     C                   EVAL      AVFRIH  = A6FRIH                                           237370
     C                   EVAL      AVSATH  = A6SATH                                           237370
     C                   EVAL      AVSUNH  = A6SUNH                                          BUG4064
     C                   EVAL      AVDPBF  = A6DPBF                                          BUG4064
     C                   EVAL      AVBYSR  = A6BYSR                                          BUG4064
     C                   EVAL      AVBYSS  = A6BYSS                                          BUG4064
     C                   EVAL      AVSLSR  = A6SLSR                                          BUG4064
     C                   EVAL      AVSLSS  = A6SLSS                                          BUG4064
     C                   EVAL      AVRMCM  = A6RMCM                                          BUG4064
     C                   EVAL      AVRECI  = A6RECI                                          BUG4064
     C                   EVAL      AVDPRU  = A6DPRU                                          BUG4064
     C                   EVAL      AVDNOR  = A6DNOR                                          BUG4064
     C                   EVAL      AVNDWR  = A6NDWR                                          BUG4064
     C                   EVAL      AVGMPY  = A6GMPY                                          BUG4064
     C                   EVAL      AVDLCD  = A6DLCD                                          BUG4064
     C                   EVAL      AVRDFC  = A6RDFC                                          BUG4064
     C                   EVAL      AVPMRT  = A6PMRT                                          BUG4064
     C                   EVAL      AVRKSQ  = A6RKSQ                                          BUG4064
     C                   EVAL      AVDFPC  = A6DFPC                                          BUG4064
     C                   EVAL      AVDDPC  = A6DDPC                                          BUG4064
     C                   EVAL      AVTKCC  = A6TKCC                                          BUG4064
     C                   EVAL      AVCQCD  = A6CQCD                                          BUG4064
     C                   EVAL      AVSMLD  = A6SMLD                                          BUG4064
     C                   EVAL      AVISON  = A6ISON                                          BUG4064
     C                   EVAL      AVISFC  = A6ISFC                                          BUG4064
     C                   EVAL      AVMACD  = A6MACD                                          BUG4064
     C                   EVAL      AVFRAC  = A6FRAC                                          BUG4064
     C                   EVAL      AVNUWD  = A6NUWD                                          BUG4064
     C                   EVAL      AVMICD  = A6MICD                                          BUG4064
     C                   EVAL      AVINCY  = A6INCY                                          BUG4064
     C                   EVAL      AVEUER  = A6EUER                                          BUG4064
     C                   EVAL      AVEUMD  = A6EUMD                                          BUG4064
     C                   EVAL      AVTPSD  = A6TPSD                                          BUG4064
     C                   EVAL      AVTPED  = A6TPED                                          BUG4064
     C                   EVAL      AVINER  = A6INER                                          BUG4064
     C                   EVAL      AVINMD  = A6INMD                                          BUG4064
     C                   EVAL      AVDLOC  = A6DLOC                                          BUG4064
     C                   EVAL      AVCYPI  = A6CYPI                                          BUG4064
     C                   EVAL      AVEXWC  = A6EXWC                                          BUG4064
     C                   EVAL      AVPOWC  = A6POWC                                          BUG4064
     C                   EVAL      AVCYD1  = A6CYD1                                          BUG4064
     C                   EVAL      AVCYD2  = A6CYD2                                          BUG4064
     C                   EVAL      AVCYD3  = A6CYD3                                          BUG4064
     C                   EVAL      AVCYLD  = A6CYLD                                          BUG4064
     C                   EVAL      AVCYGR  = A6CYGR                                          BUG4064
     C                   EVAL      AVRENO  = A6RENO                                          BUG4064
     C                   EVAL      AVSWDP  = A6SWDP                                          BUG4064
     C                   EVAL      AVSWDT  = A6SWDT                                          BUG4064
     C                   EVAL      AVCLSC  = A6CLSC                                          BUG4064
     C                   EVAL      AVEFDT  = A6EFDT                                          BUG4064
     C                   EVAL      AVSRDS  = A6SRDS                                          BUG4064
     C                   EVAL      AVDFTS  = A6DFTS                                          BUG4064
     C                   EVAL      AVFOTRANID = A6SRID                                       BUG4064
     C                   EVAL      AVRPRLOCN  = A6SRRP                                       BUG4064
     C                   EVAL      AVTMESTMP  = A6SRTM                                       BUG4064
     C                   EVAL      AVFRDS  = A6FRDS                                          BUG4064
     C                   EVAL      AVFRNT  = A6FRNT                                          BUG4064
     C                   EVAL      AVBODS  = A6BODS                                          BUG4064
     C                   EVAL      AVBOID  = A6BOID                                          BUG4064
     C                   EVAL      AVLEDS  = A6LEDS                                          BUG4064
     C                   EVAL      AVLEID  = A6LEID                                          BUG4064
     C                   EVAL      AVDTFR  = A6DTFR                                          BUG4064
     C                   EVAL      AVTLEX  = A6TLEX                                          BUG4064
     C                   EVAL      AVSETD  = A6SETD                                          BUG4064
     C                   EVAL      AVIRDP  = A6IRDP                                          BUG4064
     C                   EVAL      AVFXDY  = A6FXDY                                          BUG4064
     C                   EVAL      AVSPAE  = A6SPAE                                          BUG4064
     C                   EVAL      AVFTAE  = A6FTAE                                          BUG4064
     C                   EVAL      AVSWAE  = A6SWAE                                          BUG4064
     C                   EVAL      AVTAC4  = A6TAC4                                          BUG4064
     C                   EVAL      AVTAC5  = A6TAC5                                          BUG4064
     C                   EVAL      AVCSCD  = A6CSCD                                          BUG4064
     C                   EVAL      AVTCMP  = A6TCMP                                           CER048
     C                   EVAL      AVTXCR  = A6TXCR                                           CGL165
     C                   END                                                                 BUG4064
 
     C     EndRTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VFRNT - VALIDATION FOR FRONT OFFICE TRANSACTION INTERFACE
      *****************************************************************
     C     VFRNT         BEGSR
      *
      * ERROR IF ACTION CODE IS NOT 'A'
      *
     C     DDACTN        IFNE      'A'
     C
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0200'     MsgIdArr(Ix)
     C                   END
      *
      * ERROR IF FRONT OFFICE TRANSACTION ID IS BLANK
      *
     C     FOTRID        IFEQ      *BLANK
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0201'     MsgIdArr(Ix)
     C                   GOTO      EVFRNT
     C                   END
      *
      * ACCESS TRANSACTION WITH FRONT OFFICE TRANSACTION ID
      *
     C     FOTRID        CHAIN     SDSPRFOI                           99
      *
      * IF NOT INSERT, FRONT OFFICE TRANSACTION ID MUST BE PRESENT
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'APM0204'     MsgIdArr(Ix)
     C**********         MOVEL     FOTRID        MsgDtaArr(Ix)                              MD000091
     C                   EVAL      BLen = %Len(%Trim(FOTRID))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(FOTRID)                   MD000091
     C                   GOTO      EVFRNT
     C                   END
      *
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL - VALIDATION OF ACTION CODE AND TRANSACTION NUMBER
      *****************************************************************
     C     VAL           BEGSR
 
      * Action Code
      *  .. must be 'A','E'
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'E'
     C                   MOVEL     'N'           OKACTN
     C                   ADD       1             Ix
     C                   MOVEL     'DDACTN'      FldNameArr(Ix)
     C                   MOVEL     'SDM0048'     MsgIdArr(Ix)
     C*****MsgDtaArr(Ix) CAT       'A':0         MsgDtaArr(Ix)                              MD000091
     C*****MsgDtaArr(Ix) CAT       'E':0         MsgDtaArr(Ix)                              MD000091
     C                   EVAL      TmpDta = 'A'                                             MD000091
     C                   EVAL      BLen = %Len(%Trim(TmpDta))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = LenStr + %Trim(TmpDta)                   MD000091
     C                   EVAL      TmpDta = 'E'                                             MD000091
     C                   EVAL      BLen = %Len(%Trim(TmpDta))                               MD000091
     C                   EVAL      MsgDtaArr(Ix) = %TRIM(MsgDtaArr(Ix))                     MD000091
     C                                            + LenStr + %TRIM(TmpDta)                  MD000091
     C                   ENDIF
 
      *
      *  Transaction number  required
      *
     C     DDTRNN        IFEQ      *BLANKS
     C     DDTRNN        OREQ      *ZEROS
     C                   MOVEL     'N'           OKTRNN
     C                   ADD       1             Ix
     C                   MOVEL     'DDCYCD'      FldNameArr(Ix)
     C                   MOVEL     'USR0071'     MsgIdArr(Ix)
     C                   GOTO      EVAL
     C                   END
 
     C                   IF        DDACTN = 'A'                                              BUG6162
                                                                                             BUG6162
     C                   EVAL      KAULG = DDTRNN                                            BUG6162
                                                                                             BUG6162
     C     KAULG         CHAIN     SDAULGL0                           99                     BUG6162
                                                                                             BUG6162
      ** If record exists then prevent amendment                                             BUG6162
                                                                                             BUG6162
     C                   IF        *IN99 = *OFF                                              BUG6162
                                                                                             BUG6162
     C                   EVAL      OKACTN = 'N'                                              BUG6162
     C                   ADD       1             Ix                                          BUG6162
     C                   EVAL      FldNameArr(Ix) = 'DDCYCD'                                 BUG6162
     C                   EVAL      MsgIdArr(Ix) = 'USR9265'                                  BUG6162
     C                   ENDIF                                                               BUG6162
                                                                                             BUG6162
     C                   ENDIF                                                               BUG6162
                                                                                             BUG6162
     C     EVAL          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      * CLEAR OUTPUTS
     C**********         CLEAR                   TranFilFmt                                  BUG4064
     C                   CLEAR                   SPTRFilFmt                                  BUG4064
     C                   MOVEL     'Y'           OKACTN
     C                   MOVEL     'Y'           OKTRNN
      ** Check for the existence of the replacement character at the
      ** Transaction Id level.
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      DDTRNN        SubForTRNN        2 0
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * (Midas) Transaction number i.e currency code
     C                   PARM                    DDTRNN            3
      *
      * OUTPUTS
      *
      * Transaction Details in File Format
     C**********         PARM                    TranFilFmt                                  BUG4064
     C                   PARM                    SPTRFilFmt                                  BUG4064
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Transaction Number i.e currency code
     C                   PARM                    OKTRNN            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDSPRTRTV'   DBPGM
      *
      **  GET RUNDAT to access MULTI-BRANCHING flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
 
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
