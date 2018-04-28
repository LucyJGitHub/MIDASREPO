     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Fiscal Price')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading validation module.                *
      *                                                               *
      *  SEVSEFSPR2 - Validate Fiscal Price (Trades)                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 236137             Date 20Sep05               *
      *                 234675             Date 05Jul05               *
      *                 235547             Date 09Aug05               *
      *                 234599             Date 21Jun05               *
      *                 234292             Date 21Jun05               *
      *                 234133             Date 14Jun05               *
      *                 234440             Date 21Jun05               *
      *                 236708             Date 13Jun05               *
      *                 233903             Date 02Jun05               *
      *                 234010             Date 08Jun05               *
      *                 234005             Date 08Jun05               *
      *                 233607             Date 19May05               *
      *                 233562             Date 18May05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  236137 - Change Control for CGL031 Parts 4 & 5.              *
      *           Several changes in the Taxation of Savings Income   *
      *           functionality.                                      *
      *           - Choice of calculation method for fiscal price     *
      *           must take in account Tax Calculation Basis          *
      *           indicator from Country of Tax Codes file SDCTTXPD.  *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           EU tax calculation.                                 *
      *  235547 - Defaulting incorrect first time into program        *
      *  234599 - Forward Valued Trades with Wrong Fiscal Price       *
      *           Incorrectly default Fiscal Price for Share          *
      *  234292 - Error in inputting Bulk Trade for processing.       *
      *  234133 - Bulk Input and Trade Input are blocked by Fiscal    *
      *           Price.                                              *
      *  234440 - Change Control 1 Part 4 - For Switzerland only,     *
      *           bonds at at a discount will have their fiscal price *
      *           calculated on a yield curve.                        *
      *  236708 - If Original purchase date is before effective date  *
      *           use effective date for bonds                        *
      *  233903 - Display a warning message if Fiscal Price is equal  *
      *           to 100.                                             *
      *  234010 - Allow zero Fiscal Price for funds.                  *
      *  234005 - Fiscal Price not defaulting with  historical Fiscal *
      *           Price                                               *
      *  233607 - Fiscal Price doesn't appear on SE Trade screen      *
      *           of Bulk Input                                       *
      *  233562 - Consider issue Price                                *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPRICT     IF   E           K DISK    INFSR(*pssr)
     FSECEO     IF   E           K DISK    INFSR(*PSSR)                                       234005
     F                                     RENAME(SNDEVDF:SNDEVDO)                            234005
     FSDBRCHL0  IF   E           K DISK    INFSR(*pssr)                                       234599
 
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
     D                                     PREFIX(W_)
     D   CDDS                183    230                                                       234440
     D   CRDS                231    242                                                       234440
 
      ** Client Details data structure
     D/COPY SECPYSRC,SE_CUSTDT
 
      ** Externally described DS for investment types
     D INVTP         E DS                  EXTNAME(INVTPD)
                                                                                              236708
      ** External DS for Branch Details                                                       236708
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  236708
                                                                                              236708
      ** External DS for Location Details                                                     236708
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  236708
                                                                                              236708
      ** External DS for Securities Clients                                                   236708
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  236708
                                                                                              236708
      ** First DS for access programs, short data structure                                   236708
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     236708
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
     D BJDFIN          S              1A
     D TDVD            S              5P 0
     D C_TDVD          S                   LIKE(TDVD)                                         235547
     D Default         S              1A
     D Validate        S              1A
 
      ** Other Inputs
     D ZNOML           S             15P 0
     D SCUMEX          S              1A
     D WRKFSPI         S             15P 9
     D NomCcyDec       S              1P 0
     D ZPRCIN          S             15P 8
     D ZPRCOT          S             15P 8
     D ZYLDOK          S              1A
     D ZFDATE          S              5P 0
 
      ** Screen Fields
     D DDFSPR          S             16A
     D DDBRCD          S              3A                                                      236708
 
      ** Work Fields
     D PRCMAT          S              3  0
     D PDAT            S              5  0
     D PTYP            S              2A
     D*PCST******      S              6  0                                                   CSD027A
     D PCST            S              6A                                                     CSD027A
     D ZFLD15          S             15  0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZDATEI          S              6
     D WPrMat          S             15  8
     D PRtcd           S              7A
     D POptn           S              7A
     D WkPPRC          S             15P 8
     D WkPEXI          S             15P 8
     D WrkTDVD         S              5P 0                                                    236708
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Output(s) fields
     D DDFSPROk        S              1A
     D FSPR            S             15P 8
     D FSPP            S             15P 8
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   Z-ADD     0             FSPR
     C                   Z-ADD     TDVD          WrkTDVD                                      236708
     C                   EXSR      SRTDVD                                                     236708
 
     C     KEYPT         KLIST
     C                   KFLD                    PTYP
     C                   KFLD                    W_SESN
     C                   KFLD                    PDAT
     C                   KFLD                    PCST
 
     C     KEYPTP        KLIST
     C                   KFLD                    PTYP
     C                   KFLD                    W_SESN
                                                                                              234005
     C     KEYSC         KLIST                                                                234005
     C                   KFLD                    W_SESN                                       234005
     C                   KFLD                    PTYP                                         234005
     C                   KFLD                    PDAT                                         234005
                                                                                              234005
     C     KEYSCP        KLIST                                                                234005
     C                   KFLD                    W_SESN                                       234005
     C                   KFLD                    PTYP                                         234005
 
      ** Defaulting
 
     C     Default       IFEQ      'Y'
     C     DDFSPR        ANDEQ     *BLANK
     C     Default       OREQ      'Y'                                                        234440
     C*****TDVD*         ANDNE     P_TDVD                                              234440 235547
     C     TDVD          ANDNE     C_TDVD                                                     235547
     C     C_TDVD        ANDNE     *ZEROS                                                     235547
                                                                                              235547
      ** If defaulting as the date has changed, send a message to say                         235547
      ** this is what is happening                                                            235547
                                                                                              235547
     C     DDFSPR        IFNE      *BLANK                                                     235547
     C     TDVD          ANDNE     C_TDVD                                                     235547
     C     C_TDVD        ANDNE     *ZEROS                                                     235547
     C                   MOVE      'N'           DDFSPRok                                     235547
     C                   ADD       1             WIdx                                         235547
     C                   EVAL      WFldNmXAr(WIdx) = 'DDFSPR'                                 235547
     C                   EVAL      WMsgIDXAr(WIdx) = 'SEA0920'                                235547
     C                   ENDIF                                                                235547
     C                   EXSR      SRFSPRD
     C**********         Z-ADD     TDVD          P_TDVD            5 0                 234440 235547
     C                   ENDIF
 
      ** Validation
 
     C     Validate      IFEQ      'Y'
     C                   EXSR      SRFSPRV
     C                   ENDIF
 
      ** Convert to Percentage Format
 
     C                   EXSR      SRFSPRC
 
      ** If an error was found, set the return code appropriately
 
     C     DDFSPROK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * FSPRD - Default Fiscal Price.                                 *
      *****************************************************************
     C     SRFSPRD       BEGSR
 
      ** No Default for Non-discretionary and Non-safe custody customer
 
     C                   IF        CustClass <> 'D' AND CustClass <> 'S'
     C                   MOVE      *BLANKS       DDFSPR
     C                   GOTO      EFSPRD
     C                   END
     C                   IF        PROT = '2' OR PROT = '4'
     C                             AND W_SETX <> 'Y'                                          234675
     C                   MOVE      *BLANKS       DDFSPR
     C                   GOTO      EFSPRD
     C                   END
     C                   MOVEL     'V '          PTYP
     C***********        Z-ADD     TDVD          PDAT                                         236708
     C                   Z-ADD     WrkTDVD       PDAT                                         236708
     C*********          Z-ADD     0             PCST                                        CSD027A
     C                   Eval      PCST = *Blanks                                            CSD027A
     C                   Z-ADD     0             WkPPRC
     C                   Z-ADD     0             WkPEXI
 
      ** Funds
      ** and Shares                                                                           234675
 
     C     KEYPT         SETGT     PRICT                                                      234599
     C     KEYPTP        READPE    PRICT                                  33                  234599
     C*****KEYPT         SETLL     PRICT                                                      234599
     C*****KEYPTP        READE     PRICT                                  33                  234005
     C*****KEYPT         READE     PRICT                                  33           234005 234599
 
     C                   IF        *IN33 = '0' AND RECI = 'D'
     C                   Z-ADD     PPRC          WkPPRC
     C                   Z-ADD     PEXI          WkPEXI
     C     PROT          IFEQ      '7'
     C     PROT          OREQ      '4'                                                        234675
     C     W_SETX        ANDEQ     'Y'                                                        234675
     C                   Z-ADD     WkPEXI        FSPR
     C                   ENDIF
     C**********         ENDIF                                                                234005
     C                   ELSE                                                                 234005
                                                                                              234005
     C                   MOVEL     'PR'          PTYP                                         234005
     C***************    Z-ADD     TDVD          PDAT                                  234005 236708
     C                   Z-ADD     WrkTDVD       PDAT                                         236708
                                                                                              234005
     C     KEYSC         SETLL     SNDEVDO                                                    234005
     C     KEYSCP        READE     SNDEVDO                                33                  234005
                                                                                              234005
     C                   IF        *IN33 = *OFF AND RECI = 'D'                                234005
     C                             AND PROT = '7'                                             234005
     C                             OR *IN33 = *OFF AND RECI = 'D'                             234675
     C                             AND PROT = '4' AND W_SETX = 'Y'                            234675
     C                   Z-ADD     SNFP          FSPR                                         234005
     C                   ENDIF                                                                234005
     C                   ENDIF                                                                234005
 
      ** Coupon Bonds
 
     C                   IF        PROT <> '2' AND PROT <> '4'
     C                             AND PROT <> '7'
     C                   IF        W_ISSP < 100 AND W_ISSP <> 0
     C                             AND W_ISSD <> 0
     C                   Z-ADD     100           WPrMat
 
     C*****DVCNCD        IFNE      'CH'                                                234440 234440
      ** Calculate the fiscal price based on a Straight Line.                                 236137
     C     EWTXCB        IFEQ      'B'                                                        236137
     C                   CALLB     'ZAINTPL2'
     C                   PARM                    W_ISSD
     C**********         PARM                    TDVD                                         236708
     C                   PARM                    WrkTDVD                                      236708
     C                   PARM                    W_MATY
     C                   PARM                    W_ISSP
     C                   PARM                    WPrMat
     C                   PARM                    FSPR
                                                                                              236137
      ** Use Actuarial interpolation.                                                         236137
     C                   ELSE                                                                 234440
     C                   CALL      'ZAACTUAR'                                                 234440
     C                   PARM      *BLANK        WRTCD            10                          234440
     C                   PARM                    W_ISSD                                       234440
     C                   PARM                    W_ISSP                                       234440
     C                   PARM                    W_MATY                                       234440
     C                   PARM                    WPrMat                                       234440
     C                   PARM                    W_DYBS                                       234440
     C                   PARM                    W_DVBS                                       234440
     C                   PARM                    CDDS             48                          234440
     C                   PARM                    CRDS             12                          234440
     C                   PARM                    W_LCPN                                     BUG11164
     C                   PARM                    WrkTDVD                                      234440
     C                   PARM                    FSPR                                         234440
     C                   ENDIF                                                                234440
 
     C                   ELSE
     C**********         Z-ADD     WkPPRC        FSPR                                         233562
     C                   Z-ADD     100           FSPR                                         233562
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   IF        FSPR <> 0
 
     C                   MOVE      FSPR          ZFLD15
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANKS       ZECHAR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   MOVE      ZOUT21        DDFSPR
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       DDFSPR
 
     C                   ENDIF
 
     C     EFSPRD        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FSPRV - Validate Fiscal Price.                                *
      *****************************************************************
     C     SRFSPRV       BEGSR
 
      ** Entry not allowed when customer is not discretionary or not safe-custody
 
     C                   IF        CustClass <> 'D' AND CustClass <> 'S'
     C                             AND DDFSPR <> *BLANKS
     C                   MOVE      'N'           DDFSPRok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0912'     MsgIdXAr(Idx)
     C                   GOTO      EFSPRV
     C                   ENDIF
 
      ** Entry allowed only on bonds and funds
 
     C                   IF        PROT = '2' OR PROT = '4'
     C                             AND W_SETX <> 'Y'                                          234675
     C                   IF        DDFSPR <> *BLANKS                                          234292
     C**********                   AND DDFSPR <> *BLANKS                                      234292
     C                   MOVE      'N'           DDFSPRok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0911'     MsgIdXAr(Idx)
     C                   GOTO      EFSPRV
     C                   ENDIF                                                                234292
     C                   ENDIF
 
      ** Check valid number entered
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDFSPR        ZFIELD
 
     C**********         IF        DDFSPR <> *BLANKS                                          233607
     C                   IF        ZFIELD <> *BLANKS                                          233607
 
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C                   IF        ZAlignOk = 'N'
 
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0354'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDFSPROk
     C                   Z-ADD     *ZEROS        FSPR
     C                   MOVE      ZFIELD        DDFSPR
     C                   GOTO      EFSPRV
 
     C                   ENDIF
     C                   ENDIF                                                                233607
 
     C                   MOVE      ZFIELD        FSPR
     C                   MOVE      FSPR          ZFLD15
     C                   Z-ADD     8             ZADEC
     C                   MOVE      *BLANK        ZECODE
     C                   MOVE      *BLANKS       ZECHAR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZADEC
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
      ** For Market Trade, no Fiscal Price.                                                   234010
                                                                                              234010
     C                   IF        CustClass <> 'D' AND CustClass <> 'S'                      234010
     C**********                   AND PROT = '7'                                      234010 234133
     C                             OR  PROT = '2' OR PROT = '4'                               234599
     C                             AND W_SETX <> 'Y'                                          234675
     C                   MOVE      *BLANKS       DDFSPR                                       234010
     C                   ELSE                                                                 234010
     C                   MOVE      ZOUT21        DDFSPR
     C                   ENDIF                                                                234010
     C**********         IF        PROT = '7'                                                 234010
     C**********                   OR (PROT <> '2' AND PROT <> '4'                            234010
     C                   IF        (PROT <> '2' AND PROT <> '4'                               234010
     C                               AND PROT <> '7' AND W_ISSP < 100)
 
     C                   IF        CustClass = 'S' OR                                         234133
     C                             CustClass = 'D'                                            234133
     C                   IF        FSPR = 0
     C                   MOVE      'N'           DDFSPRok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0914'     MsgIdXAr(Idx)
     C                   Z-ADD     *ZEROS        FSPR
     C                   MOVE      ZOUT21        DDFSPR
     C                   GOTO      EFSPRV
     C                   ENDIF
 
     C                   ENDIF                                                                234133
     C                   ENDIF
     C**********         ENDIF                                                                233607
                                                                                              233903
     C                   IF        FSPR = 100                                                 233903
     C                   MOVE      'W'           DDFSPRok                                     233903
     C                   ADD       1             WIdx                                         233903
     C                   EVAL      WFldNmXAr(WIdx) = 'DDFSPR'                                 233903
     C                   EVAL      WMsgIDXAr(WIdx) = 'SEA0916'                                233903
     C                   ENDIF                                                                233903
 
     C     EFSPRV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FSPRC - Convert to Percentage Format                          *
      *****************************************************************
     C     SRFSPRC       BEGSR
 
      ** If Trade basis is yield convert to percentage price
 
 
     C                   IF        W_STBS = 'Y'
     C                   MOVE      FSPR          ZPRCIN
     C**********         MOVE      TDVD          ZFDATE                                       236708
     C                   MOVE      WrkTDVD       ZFDATE                                       236708
 
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    ZNOML
     C                   PARM                    WRKFSPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPRCOT
 
     C                   MOVE      ZPRCOT        FSPP
     C                   ELSE
     C                   MOVE      FSPR          FSPP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  236708
      *****************************************************************                       236708
      * SRTDVD  - Access Effective Date                               *                       236708
      *****************************************************************                       236708
     C     SRTDVD        BEGSR                                                                236708
                                                                                              236708
      ** Access branch details                                                                236708
     C                   MOVEL     DDBRCD        @BRCH             3                          236708
     C                   CALLB     'AOBRCHR0'                                                 236708
     C                   PARM      *BLANKS       PRTCD             7                          236708
     C                   PARM      '*KEY   '     POPTN             7                          236708
     C                   PARM                    @BRCH                                        236708
     C     SDBRCH        PARM      SDBRCH        DSFDY                                        236708
                                                                                              236708
     C     PRTCD         IFNE      *BLANKS                                                    236708
     C**********         EVAL      DBKEY = DDBRCD                                     236708  234599
     C**********         EVAL      DBFILE = 'SDBRCHPD'                                236708  234599
     C**********         EVAL      DBASE = 3                                          236708  234599
     C**********         EXSR      *PSSR                                              236708  234599
     C     *LOVAL        SETLL     SDBRCHL0                                                   234599
     C                   READ      SDBRCHL0                                                   234599
     C                   ENDIF                                                                236708
                                                                                              236708
     C                   MOVEL     A8LCCD        @LCCD             3                          236708
     C                   CALL      'AOLOCNR0'                                                 236708
     C                   PARM      *BLANKS       PRTCD                                        236708
     C                   PARM      '*KEY   '     POPTN                                        236708
     C                   PARM                    @LCCD                                        236708
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        236708
                                                                                              236708
     C     PRTCD         IFNE      *BLANKS                                                    236708
     C                   EVAL      DBKEY = A8LCCD                                             236708
     C                   EVAL      DBFILE = 'SDLOCNPD'                                        236708
     C                   EVAL      DBASE = 4                                                  236708
     C                   EXSR      *PSSR                                                      236708
     C                   ENDIF                                                                236708
                                                                                              236708
     C                   CALL      'AOCTTXR0'                                                 236708
     C                   PARM      *BLANKS       PRtcd                                        236708
     C                   PARM      '*KEY   '     POptn                                        236708
     C                   PARM      DVCNCD        PCtrt             2                          236708
     C                   PARM      *BLANKS       PCtrr             2                          236708
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236708
                                                                                              236708
     C     PRTCD         IFNE      *BLANKS                                                    236708
     C                   EVAL      DBKEY = DVCNCD                                             236708
     C                   EVAL      DBFILE = 'SDCTTXPD'                                        236708
     C                   EVAL      DBASE = 5                                                  236708
     C                   EXSR      *PSSR                                                      236708
     C                   ENDIF                                                                236708
                                                                                              236708
     C                   IF        EWEDT1 > WrkTDVD                                           236708
     C                   Z-ADD     EWEDT1        WrkTDVD                                      236708
     C                   ENDIF                                                                236708
                                                                                              236708
     C                   ENDSR                                                                236708
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Default & Validate (Y or N)
 
     C                   PARM                    Default
     C                   PARM                    Validate
 
      ** Fiscal Price  (16A)
 
     C                   PARM                    DDFSPR
 
      ** Trade Date (5P 0)
 
     C                   PARM                    TDVD
 
      ** Security Details
 
     C                   PARM                    SECTY
      ** Investment Type Details
     C                   PARM                    INVTP
 
      ** Customer (Counterparty) Details
 
     C                   PARM                    CustDts
     C                   PARM                    BJDFIN
     C                   PARM                    DDBRCD                                       236708
      ** Current File Trade Date                                                              235547
     C                   PARM                    C_TDVD                                       235547
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Price Ok INdicator (1A)
      ** Price (15P 8)
 
     C                   PARM                    DDFsprOk
     C                   PARM                    FSPR
     C                   PARM                    FSPP
      *
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
(c) Misys International Banking Systems Ltd. 2004
