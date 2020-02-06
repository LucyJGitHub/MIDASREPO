     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Prices - Cvt File to Scn Fmt')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEPRCSCVT - Securities Prices Details Conversion:            *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a Securites    *
      *             Prices Detail from file to screen format          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 223828             Date 16Dec03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD010             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060  *CREATE    Date 05Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation on Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  223828 - Security Prices shows prefixed sign instead of      *
      *           suffixed                                            *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD010 - Collateralised Lending (Securities and FX Pricing)  *
      *  CAP060 - Conversion of Midas Screen Input Program into full  *
      *           API, including repair program which CAP030 does not *
      *           include                                             *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
 
     FCPOSN     IF   E           K DISK    INFSR(*PSSR)
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
 
      ** Array for manipulating decimal positions
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)
 
     D WSgndNum        S              1    DIM(17)                                            CAS006
                                                                                              CAS006
     D POut21          DS                                                                     CAS006
     D  WNumber                5     20                                                       CAS006
     D  WSign                 21     21                                                       CAS006
                                                                                              CAS006
     D TranFilFmt    E DS                  EXTNAME(PRICED)
      ** Securities Prices Details in File Format
 
     D TrnDets       E DS                  EXTNAME(SEPRCSPD)
     D   DDTSDT                       6    OVERLAY(DDDFTS:3)
     D   DDTSTM                       6    OVERLAY(DDDFTS:9)
      ** Securities Prices Details in Screen Format
 
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D** Security Trading Detail
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      * Midas Module Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D** Currency Details
 
      ** Switchable features Definition file                                                  CAS006
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS006
     D SCA_LCD       E                     EXTFLD(LCD)                                        CAS006
                                                                                              CAS006
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** short data structure for access programs
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** long data structure for access programs
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DateIn          S              8S 0
 
     D* Profit Centre Switchable Feature
     D CAC005          S              1A
 
      ** Collateralised Lending Switchable Feature                                            CSD010
     D CSD010          S              1A                                                      CSD010
     D HBDPR           S                   LIKE(PRBDPR)                                       CSD010
     D HOFPR           S                   LIKE(PROFPR)                                       CSD010
     D HCLPR           S                   LIKE(PRCLPR)                                       CSD010
                                                                                              CSD010
      ** Hedge Accounting Phase B Switchable Feature                                          CAS006
     D CAS006          S              1A                                                      CAS006
                                                                                              CAS006
      ** Parameters used to access SCSARDPD                                                   CAS006
     D PRetCode        S              7A                                                      CAS006
     D POption         S              7A                                                      CAS006
     D PKey            S              6A                                                      CAS006
                                                                                              CAS006
      ** Parameters used for ZSEDIT                                                           CAS006
     D PFld15          S             15  0                                                    CAS006
     D PEChar          S              1                                                       CAS006
                                                                                              CAS006
     D WIx             S              1  0                                                    CAS006
                                                                                              CAS006
      ** Taxation of Savings Income                                                           CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** Parameters and Working variables                                                     CGL031
     D ZFLD15          S             15P 0                                                    CGL031
     D ZDECS           S              1P 0                                                    CGL031
     D ZECHAR          S              1A                                                      CGL031
     D ZOUT21          S             21A                                                      CGL031
                                                                                              CGL031
     D WINTP           S             15P 8                                                    CGL031
                                                                                              CGL031
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      **************************************************************
      /EJECT
      **************************************************************
 
      ** Initialization
 
     C                   EXSR      INIT
 
      ** Set screen fields
 
     C                   EXSR      SCREEN
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SCREEN - SET SCREEN FIELDS
      *****************************************************************
     C     SCREEN        BEGSR
 
      * Recd Status
      * -----------
      * Set up Record Status flag for display
     C                   IF        DDACTN <> 'I' AND
     C                             RECI = '*'
     C                   MOVE      'ACTIONED'    DDSTS
     C                   ELSE
     C                   MOVEL     *BLANK        DDSTS
     C                   ENDIF
 
      * Price
      * -----
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      PPRC          ZFIELD
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDPPRC
     C*
     C* In amend mode, remember current price to not perform warning error
     C* check unless price changes.
     C*
     C                   Z-ADD     PPRC          HPPRC
                                                                                              CSD010
      ** If Collateralised Lending is installed, Convert Price Fields                         CSD010
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
                                                                                              CSD010
      ** Bid Price                                                                            CSD010
                                                                                              CSD010
     C                   EVAL      ZFIELD = *BLANKS                                           CSD010
     C                   MOVE      PRBDPR        ZFIELD                                       CSD010
     C                   Z-ADD     8             ZADEC                                        CSD010
                                                                                              CSD010
     C                   CALLB     'ZEDIT'                                                    CSD010
     C                   PARM                    ZFIELD                                       CSD010
     C                   PARM                    ZADEC                                        CSD010
     C                   MOVE      ZFIELD        DDBDPR                                       CSD010
     C                   Z-ADD     PRBDPR        HBDPR                                        CSD010
                                                                                              CSD010
      ** Offer Price                                                                          CSD010
                                                                                              CSD010
     C                   EVAL      ZFIELD = *BLANKS                                           CSD010
     C                   MOVE      PROFPR        ZFIELD                                       CSD010
                                                                                              CSD010
     C                   CALLB     'ZEDIT'                                                    CSD010
     C                   PARM                    ZFIELD                                       CSD010
     C                   PARM                    ZADEC                                        CSD010
     C                   MOVE      ZFIELD        DDOFPR                                       CSD010
     C                   Z-ADD     PROFPR        HOFPR                                        CSD010
                                                                                              CSD010
      ** Closing Price                                                                        CSD010
                                                                                              CSD010
     C                   EVAL      ZFIELD = *BLANKS                                           CSD010
     C                   MOVE      PRCLPR        ZFIELD                                       CSD010
                                                                                              CSD010
     C                   CALLB     'ZEDIT'                                                    CSD010
     C                   PARM                    ZFIELD                                       CSD010
     C                   PARM                    ZADEC                                        CSD010
     C                   MOVE      ZFIELD        DDCLPR                                       CSD010
     C                   Z-ADD     PRCLPR        HCLPR                                        CSD010
                                                                                              CSD010
     C                   ENDIF                                                                CSD010
                                                                                              CSD010
     C
     C* Current price
     C* -------------
     C                   IF        PPRT = 'V'
     C*
     C* Fetch market price
     C*
     C     PSSN          CHAIN     SECTYDF                            99
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      MKPR          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDCURP
     C                   ELSE
     C*
     C     PPRT          IFEQ      'DT'
     C     PPRT          OREQ      'DV'
     C*
     C* Fetch latest average price
     C*
     C                   MOVE      PPRT          BASIS
     C     BKPHDK        CHAIN     BKPHDDF                            99
     C*
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      LAVP          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDCURP
     C                   ELSE
     C*
     C     PPRT          IFEQ      'CT'
     C     PPRT          OREQ      'CV'
     C*
     C* Fetch nominal security details
     C*
     C     PSSN          CHAIN     SECTYDF                            99
     C*
     C* Fetch nominal currency decimal places
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      NMCY          @CKEY             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C* Fetch Customer position
     C*
     C     CPOSNK        CHAIN     CPOSNDF                            99
     C*
     C                   Z-ADD     *ZEROS        WK15N8           15 8
     C     CSNT          IFNE      *ZEROS
     C     CSPT          DIV       CSNT          WK15N8
     C                   ELSE
     C     CSNV          IFNE      *ZEROS
     C     CSPV          DIV       CSNV          WK15N8
     C                   END
     C                   END
     C     5             SUB       NMDP          DC                1 0
     C                   ADD       A6NBDP        DC
     C                   DIV       POWER8(DC)    WK15N8
      *
      **  If price basis is 'P' then multiply by 100 to display percen-
      **  tage amount
      *
     C     SPBS          IFEQ      'P'
     C                   MULT      100           WK15N8
     C                   END
      *
     C     WK15N8        IFLT      *ZEROS
     C                   Z-SUB     WK15N8        WK15N8
     C                   END
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WK15N8        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDCURP
     C                   END
     C                   END
     C                   END
                                                                                              CGL031
      ** Price Excluding Interest                                                             CGL031
      ** ------------------------                                                             CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
     C                   MOVE      *BLANKS       ZFIELD                                       CGL031
     C                   MOVE      PEXI          ZFIELD                                       CGL031
     C                   Z-ADD     8             ZADEC                                        CGL031
                                                                                              CGL031
     C                   CALLB     'ZEDIT'                                                    CGL031
     C                   PARM                    ZFIELD           16                          CGL031
     C                   PARM                    ZADEC             1 0                        CGL031
     C                   MOVE      ZFIELD        DDPEXI                                       CGL031
                                                                                              CGL031
      ** Interest Price                                                                       CGL031
      ** --------------                                                                       CGL031
                                                                                              CGL031
      ** Calculate the Interest Price                                                         CGL031
                                                                                              CGL031
     C     PPRC          SUB       PEXI          WINTP                                        CGL031
                                                                                              CGL031
     C                   MOVE      WINTP         ZFLD15                                       CGL031
     C                   Z-ADD     8             ZDECS                                        CGL031
                                                                                              CGL031
     C                   CALLB     'ZSEDIT'                                                   CGL031
     C                   PARM                    ZFLD15                                       CGL031
     C                   PARM                    ZDECS                                        CGL031
     C                   PARM                    ZECHAR                                       CGL031
     C                   PARM                    ZOUT21                                       CGL031
                                                                                              CGL031
     C                   MOVE      ZOUT21        DDINTP                                       CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
     C*
     C* Narrative
     C* ---------
     C                   MOVE      PNTV          DDPNTV
     C*
     C* Value date
     C* ----------
     C                   Z-ADD     PVDT          ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVE      ZDATE         DDPVDT
      *
     C     BGPFMG        IFEQ      'Y'
     C     PTFR          ANDNE     *BLANKS
     C     NPXR          IFNE      0
     C                   MOVE      NPMD          DDNPMD
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      NPXR          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        DDNPXR
     C                   ELSE
     C                   MOVE      *BLANKS       DDNPXR
     C                   END
     C                   END
 
      * Data request id
      * ---------------
     C                   Eval      DDDTFR = PRDTFR
 
      * Time stamp
      * ----------
     C     PRDFTS        IFEQ      *ZERO
     C                   EVAL      DDDFTS = *BLANK
     C                   ELSE
      ** Move last 6 digits HHMMSS
     C                   MOVE      PRDFTS        DDTSTM
      ** Move first 8 digits CCYYMMDD
     C                   MOVEL     PRDFTS        DateIn
 
     C                   CALLB     'ZA0770'
     C                   PARM                    RetCodeIn
     C                   PARM                    DateIn
     C                   PARM                    BJDFIN
     C                   PARM                    DateOut           6 0
 
     C                   MOVE      DateOut       DDTSDT
 
     C                   ENDIF
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed:                                            CAS006
      ** If Price Type is 'V', 'DT' or 'DV', convert Credit Risk                              CAS006
      ** Spread and Liquidity Premium Fields.                                                 CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   IF        PPRT = 'V' OR PPRT = 'DT' OR PPRT = 'DV'                   CAS006
                                                                                              CAS006
      ** Price Credit Risk Spread                                                             CAS006
      ** ------------------------                                                             CAS006
                                                                                              CAS006
     C                   MOVE      *BLANKS       PFLD15                                       CAS006
     C                   MOVE      PRCRSK        PFLD15                                       CAS006
     C                   EVAL      ZADEC = 8                                                  CAS006
                                                                                              CAS006
     C                   CALLB     'ZSEDIT'                                                   CAS006
     C                   PARM                    PFld15                                       CAS006
     C                   PARM                    ZADEC                                        CAS006
     C                   PARM                    PEChar                                       CAS006
     C                   PARM                    POut21                                       CAS006
                                                                                              CAS006
     C                   EVAL      WIx = *ZERO                                                CAS006
     C                   EVAL      WIx = %CHECK(' ' : WNumber)                                CAS006
     C                   EVAL      WSgndNum = *BLANKS                                         CAS006
     C**********         MOVEA     WNumber       WSgndNum(2)                           CAS006 223828
     C**********         EVAL      WSgndNum(WIx) = WSign                               CAS006 223828
     C                   MOVEA     WNumber       WSgndNum                                     223828
     C                   EVAL      WSgndNum(17) = WSign                                       223828
     C                   MOVEA     WSgndNum      DDCRSK                                       CAS006
                                                                                              CAS006
      ** Price Liquidity Premium                                                              CAS006
      ** -----------------------                                                              CAS006
                                                                                              CAS006
     C                   MOVE      *BLANKS       PFLD15                                       CAS006
     C                   MOVE      PRLQPR        PFLD15                                       CAS006
     C                   EVAL      ZADEC = 8                                                  CAS006
                                                                                              CAS006
     C                   CALLB     'ZSEDIT'                                                   CAS006
     C                   PARM                    PFld15                                       CAS006
     C                   PARM                    ZADEC                                        CAS006
     C                   PARM                    PEChar                                       CAS006
     C                   PARM                    POut21                                       CAS006
                                                                                              CAS006
     C                   EVAL      WIx = *ZERO                                                CAS006
     C                   EVAL      WIx = %CHECK(' ' : WNumber)                                CAS006
     C                   EVAL      WSgndNum = *BLANKS                                         CAS006
     C**********         MOVEA     WNumber       WSgndNum(2)                           CAS006 223828
     C**********         EVAL      WSgndNum(WIx) = WSign                               CAS006 223828
     C                   MOVEA     WNumber       WSgndNum                                     223828
     C                   EVAL      WSgndNum(17) = WSign                                       223828
     C                   MOVEA     WSgndNum      DDLQPR                                       CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
 
      ** Blank outputs (except for key fields) and EXTEL details and Current price
 
     C                   MOVEL     *BLANK        DDPPRC
     C                   MOVEL     *BLANK        DDPNTV
     C                   MOVEL     *BLANK        DDPVDT
     C                   MOVEL     *BLANK        DDDTFR
     C                   MOVEL     *BLANK        DDDFTS
     C                   MOVEL     *BLANK        DDNPXR
     C                   MOVEL     *BLANK        DDNPMD
     C                   MOVEL     *BLANK        DDSTS
                                                                                              CSD010
     C                   IF        CSD010 = 'Y'                                               CSD010
     C                   EVAL      DDBDPR = *BLANKS                                           CSD010
     C                   EVAL      DDOFPR = *BLANKS                                           CSD010
     C                   EVAL      DDCLPR = *BLANKS                                           CSD010
     C                   ENDIF                                                                CSD010
 
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      DDCRSK = *BLANKS                                           CAS006
     C                   EVAL      DDLQPR = *BLANKS                                           CAS006
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * Input  Parameters
      *
      * Return Code
     C                   PARM                    DDSTS             8
     C                   PARM                    RetCodeIn
      *
      * Securities Prices Transaction Details File Format
      *
     C                   PARM                    TranFilFmt
      *
      * If CAC005 is on, this is the pseudo book ( the book stored on file on PRICED )
      * If CAC005 is off, this is the book the user entered on the screen
      *
     C                   PARM                    KPBOK             2
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * Output Parameters
      *
      * Securities Prices Transaction Details Screen Format
     C                   PARM                    TrnDets
      * Current Price in file format
     C                   PARM                    HPPRC
                                                                                              CSD010
      ** Switchable feature CSD010 parameters                                                 CSD010
     C                   PARM                    HBDPR                                        CSD010
     C                   PARM                    HOFPR                                        CSD010
     C                   PARM                    HCLPR                                        CSD010
     C                   PARM                    CSD010                                       CSD010
 
      ** Initialize program name
 
     C                   MOVEL     'SEPRCSCVT'   DBPGM
     C     *LIKE         DEFINE    PPRC          HPPRC
      *
      * Key Lists
      *
     C     BKPHDK        KLIST
     C                   KFLD                    DDPSSN
     C                   KFLD                    PBRA
     C                   KFLD                    KPBOK
     C                   KFLD                    DDPMKT
     C                   KFLD                    BASIS             1
 
     C     CPOSNK        KLIST
     C                   KFLD                    PBRA
     C                   KFLD                    DDPSSN
     C                   KFLD                    PCNM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Midas Module Details
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
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
     C                   EVAL      DBASE = 901                                                CAS006
     C                   EVAL      DBKEY = 'CAS006'                                           CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBMOD = 'SEPRCSCVT'                                        CAS006
     C                   EVAL      DBPGM = 'SEPRCSCVT'                                        CAS006
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
