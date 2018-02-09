     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Original Purchase Date')             *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVOPDT - Validate Original Purchase Date                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236004             Date 15Sep05               *
      *                 235216             Date 06Sep05               *
      *                 234675             Date 05Jul05               *
      *                 235660             Date 23Aug05               *
      *                 234552             Date 29Jun05               *
      *                 234440             Date 26Jun05               *
      *                 236705             Date 18Jun05               *
      *                 236703             Date 15Jun05               *
      *                 233698             Date 25May05               *
      *                 233778             Date 27May05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  236004 - retrieve Effective date from SDCTTXPD.              *
      *  235216 - When Original Purchase Date is blank and Joint      *
      *           Account Type is 'N' or blank,  a default value      *
      *           (from In Date) for Original Purchase Date appears   *
      *           on screen and which will also update Average        *
      *           Purchase Date calculated on PF/ECTPOSND.            *
      *  234675 - Change control for processing type 4 and Dividend   *
      *           Eu-tax calculation                                  *
      *  235660 - OPDT cannot be before 1st July 2005.                *
      *  234552 - OPDT can be in to future.                           *
      *  234440 - Position Management (Access ETCPOSND)               *
      *  236705 - original purchase date should default to average    *
      *           purchase date                                       *
      *  236703 - original purchase date should not be greater than   *
      *           trade date of the walk in                           *
      *  233698 - Change Control for CGL031                           *
      *  233778 - Validation of Original Purchase Date                *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK
      *****************************************************************                233698 236705
     F***SETRADL3***IF   E           K DISK    PREFIX(T_)                              233698 236705
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
                                                                                              234440
      ** EU Tax Customer Position                                                             234440
     D ETCPOSND      E DS                  EXTNAME(ETCPOSND)                                  234440
 
      ** Client Details data structure
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Externally described DS for investment types
     D SDINV         E DS                  EXTNAME(INVTPD)
     D I_RECI        E                     EXTFLD(RECI)                                       234440
                                                                                              236004
      ** Bank details data structure                                                          236004
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  236004
     D                                     PREFIX(L_)                                         236004
                                                                                              236004
      ** Country of Tax Codes data structure                                                  236004
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  236004
                                                                                              236004
 
      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Additional Customer Details                                          235216
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                  235216
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Input Parameters
     D DDOPDT          S              6
     D DDMVType        S              2
     D DDDPSS          S             10
     D DDDPBN          S              6
     D DDDPBA          S              3                                                       233698
     D BJRDNB          S              5  0
     D BJDFIN          S              1
     D DMTD            S              5P 0                                                    236703
     D DDPTFR          S              4                                                       234440
     D DPNA            S             11P 0                                                    236705
 
      ** Output Parameters
     D DDOPDTOk        S              1A
     D OPDT            S              5P 0
 
      ** Working Variables
     D WkOPDT          S              5  0
     D ZALIGNok        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZDATEI          S              6
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7
     D ErrorFlag       S              1
     D PRtcd           S              7A
     D POptn           S              7A
     D*WCust****       S              6S 0                                            233698 CSD027A
     D WCust           S              6A                                                     CSD027A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
     I***TRADSDF*******81                                                              233698 236705
     I***HSTTRDF*******81                                                              233698 236705
     I***DPTMVDF*******82                                                              233698 236705
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
     C                   Z-ADD     0             Idx
 
      ** Clear output trade fields
 
     C                   Z-ADD     0             OPDT
 
      ** Validation
 
     C                   EXSR      SROPDTV
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOPDTOk = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SROPDTV - Validation routine for Original Purchase Date       *
      *                                                               *
      *****************************************************************
 
     C     SROPDTV       BEGSR
 
      ** Validate if Security Customer is Live
 
     C     DDDPSS        CHAIN     SECTYDF                            44
     C                   IF        *IN44 = *ON
     C                   MOVEL     DDDPSS        DBKEY
     C                   MOVEL     'SECTYD'      DBFILE
     C                   MOVE      '101'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Validate if Security Investment Type exist in INVTP
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    SITP
     C                   PARM                    NMCY
     C     SDINV         PARM      SDINV         DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     NMCY          DBKEY
     C                   MOVE      SITP          DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   MOVE      '102'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Original Purchase Date must be blank for Commodities and
      ** Equities
 
     C                   IF        PROT = '2' AND DDOPDT <> *BLANKS OR PROT ='4'
     C                             AND DDOPDT <> *BLANKS
     C                             AND SETX <> 'Y'                                            234675
     C                   MOVE      'N'           DDOPDTok
     C                   ADD       1             Idx
     C                   MOVEL     'DDOPDT'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0904'     MsgIdXAr(Idx)
     C                   GOTO      EOPDTV
     C                   END
 
      **  If Walkout, input on this field is allowed for 'D' and 'S'
      **  custody customer and Commodities or Equities
 
     C**********         IF        DDMVType = 'WO' AND DDDPBN <> *BLANKS                      233778
     C                   IF        DDDPBN <> *BLANKS                                          233778
 
     C                   CALL      'AOSECSR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    DDDPBN
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C                             AND PRtCd <> '*NRF   '                                     233778
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     DDDPBN        DBKEY
     C                   MOVEL     'SDSECSPD'    DBFILE
     C                   MOVE      '103'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        PRtcd = *BLANKS                                            233778
     C                   IF        BFCLAS = 'D' OR BFCLAS = 'S'
 
      ** For Depot Walkout, Default LCPN to OPDT
 
     C**********         IF        PROT <> '2' AND PROT <> '4'                                234675
     C                   IF        SETX = 'Y'                                                 234675
     C                             AND DDOPDT = *BLANKS
     C**********         Z-ADD     LCPN          OPDT                                         233698
                                                                                              233698
     C                   MOVEL     DDDPBA        WBrca                                        233698
     C                   MOVEL     DDDPSS        WSesn                                        233698
     C                   MOVEL     DDDPBN        WCust                                        233698
     C*****BJRDNB        SUB       1             WDate                                 233698 236705
      **********                                                                       233698 236705
     C*****KEYTR1        SETLL     SETRADL3                                            233698 236705
     C*****KEYTR2        READE     SETRADL3                               70           233698 236705
      **********                                                                       233698 236705
     C******IN70         IFEQ      '1'                                                 233698 236705
     C**********         Z-ADD     BJRDNB        OPDT                                  233698 236705
     C**********         ELSE                                                          233698 236705
     C******IN81         IFEQ      '1'                                                 233698 236705
     C**********         Z-ADD     T_TDVD        OPDT                                  233698 236705
     C**********         ENDIF                                                         233698 236705
     C******IN82         IFEQ      '1'                                                 233698 236705
     C**********         Z-ADD     T_OPDT        OPDT                                  233698 236705
     C**********         ENDIF                                                         233698 236705
     C**********         ENDIF                                                         233698 236705
      **********                                                                       233698 236705
     C                   EXSR      Default                                                    236705
     C                   Z-ADD     WrkAPDT       OPDT                                         236705
     C                   IF        OPDT = 0                                                   235216
     C                   MOVEL     WCust         @PCUST                                       235216
     C                   CALL      'AOACUSR0'                                                 235216
     C                   PARM      *BLANKS       PRTCD                                        235216
     C                   PARM      '*KEY   '     POPTN                                        235216
     C                   PARM                    @PCUST            6                          235216
     C     SDACUS        PARM      SDACUS        DSSDY                                        235216
     C                   IF        PRTCD = *BLANKS                                            235216
     C                   IF        E5JATP = 'N' OR E5JATP = *BLANK                            235216
     C                   Z-ADD     DPMD          OPDT                                         235216
     C                   ENDIF                                                                235216
     C                   ENDIF                                                                235216
     C                   ENDIF                                                                235216
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DDOPDT <> *BLANKS
     C                   MOVE      'N'           DDOPDTok
     C                   ADD       1             Idx
     C                   MOVEL     'DDOPDT'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0912'     MsgIdXAr(Idx)
     C                   GOTO      EOPDTV
     C                   ENDIF
 
     C                   ENDIF
     C                   ELSE                                                                 233778
     C                   CLEAR                   SDSECS                                       233778
     C                   ENDIF                                                                233778
 
     C                   ENDIF
                                                                                              233698
      **  If Walkin, input on this field is mandatory if not processing                       233698
      **  types 2 and 4                                                                       233698
                                                                                              233698
     C                   IF        DDMVType = 'WI'                                            233698
     C**********         IF        PROT <> '2' AND PROT <> '4'                         233698 234675
     C**********         IF        DDOPDT = *BLANKS                                    233698 234440
     C                   IF        SETX = 'Y'                                                 234675
     C                   IF        DDOPDT = *BLANKS AND OPDT = 0                              234440
     C                             AND  E5JATP <> 'N' AND E5JATP <> *BLANK                    235216
     C                   MOVE      'N'           DDOPDTok                                     233698
     C                   ADD       1             Idx                                          233698
     C                   MOVEL     'DDOPDT'      FldNamXAr(Idx)                               233698
     C                   MOVEL     'SEA0915'     MsgIdXAr(Idx)                                233698
     C                   GOTO      EOPDTV                                                     233698
     C                   ENDIF                                                                233698
     C                   ENDIF                                                                233698
     C                   ENDIF                                                                233698
 
      ** Convert to Screen format
 
     C                   IF        OPDT <> 0
 
     C                   Z-ADD     *ZEROS        ZDAYNO
     C                   Z-ADD     OPDT          ZDAYNO
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   MOVEL     ZDATE         DDOPDT
 
     C                   ENDIF
 
     C                   IF        DDOPDT <> *BLANKS
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDOPDT        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
     C                   PARM      6             ZADIG
 
     C                   IF        ZALIGNOk = 'Y'
 
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
 
     C                   IF        ZALIGNok = 'N' OR ErrorFlag = 'Y'
     C                   MOVE      'N'           DDOPDTok
     C                   ADD       1             Idx
     C                   MOVEL     'DDOPDT'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0905'     MsgIdXAr(Idx)
     C                   GOTO      EOPDTV
     C                   END
 
      ** It must not be greater than run date
 
     C                   Z-ADD     ZDAYNO        WkOPDT
     C************       IF        WkOPDT > BJRDNB                                            234552
     C************       MOVE      'N'           DDOPDTok                                     234552
     C************       ADD       1             Idx                                          234552
     C************       MOVEL     'DDOPDT'      FldNamXAr(Idx)                               234552
     C************       MOVEL     'SEA0905'     MsgIdXAr(Idx)                                234552
     C************       GOTO      EOPDTV                                                     234552
     C************       END                                                                  234552
                                                                                              236703
     C************       IF        DDMVType = 'WI'                                     236703 234552
     C************       IF        WkOPDT > DMTD                                       236703 234552
     C************       MOVE      'N'           DDOPDTok                              236703 234552
     C************       ADD       1             Idx                                   236703 234552
     C************       MOVEL     'DDOPDT'      FldNamXAr(Idx)                        236703 234552
     C************       MOVEL     'SEA0916'     MsgIdXAr(Idx)                         236703 234552
     C************       GOTO      EOPDTV                                              236703 234552
     C************       ENDIF                                                         236703 234552
     C************       ENDIF                                                         236703 234552
      *                                                                                       235660
      **If*Security*is*taxable*then*'Original*Purchase*Date'*must*be*>=01-07-2005**    235660 236004
      **Date*01-07-2005*is*12236*in*Midas date*************************************    235660 236004
      * If Security is taxable then 'Original Purchase Date' must be >=Effective date         236004
      *   for the Country of Tax on SDCTTXPD.                                                 236004
      *   Retrieve the Effective Date, EWEDT1, from SDCTTXPD.                                 236004
     C                   Exsr      RtvEffDate                                                 236004
      *                                                                                       235660
     C**********         IF        WkOPDT < 12236 And SETX='Y'                         235660 236004
     C                   IF        WkOPDT < EWEDT1 And SETX='Y'                               236004
     C                   MOVE      'N'           DDOPDTok                                     235660
     C                   ADD       1             Idx                                          235660
     C                   MOVEL     'DDOPDT'      FldNamXAr(Idx)                               235660
     C                   MOVEL     'SEA0920'     MsgIdXAr(Idx)                                235660
     C                   GOTO      EOPDTV                                                     235660
     C                   END                                                                  235660
 
      * Update trade details
 
     C                   MOVEL     ZDAYNO        OPDT
 
     C                   END
 
     C                   IF        OPDT = 0
     C                   MOVE      *BLANKS       DDOPDT
     C                   END
 
     C     EOPDTV        ENDSR
      *****************************************************************
     C/EJECT                                                                                  236705
      *****************************************************************                       236705
      * Default - Default the original purchased date                 *                       236705
      *****************************************************************                       236705
     C     Default       BEGSR                                                                236705
                                                                                              236705
     C*************      CALLB     'SEVAPDT'                                           236705 234440
      *************                                                                    236705 234440
      ***Input*Fields                                                                  236705 234440
      *************                                                                    236705 234440
     C*************      PARM                    WBrca                                 236705 234440
     C*************      PARM                    WCust                                 236705 234440
     C*************      PARM                    WSesn                                 236705 234440
     C*************      PARM      DDMVType      WType                                 236705 234440
     C*************      PARM      DPNA          WAmt                                  236705 234440
     C*************      PARM      DPMD          WDate                                 236705 234440
      *************                                                                    236705 234440
      ***OUTPUTS***                                                                    236705 234440
      *************                                                                    236705 234440
      ***Average*Purchase*Date                                                         236705 234440
      *************                                                                    236705 234440
     C*************      PARM                    WrkAPDT                               236705 234440
                                                                                              236705
     C                   CALL      'SEETCPRTV'                                                234440
     C                   PARM                    RetCodeIn                                    234440
     C                   PARM                    DDDPBA                                       234440
     C                   PARM                    DDDPBN                                       234440
     C                   PARM                    DDDPSS                                       234440
     C                   PARM                    DDPTFR                                       234440
     C                   PARM                    MKTI                                         234440
     C                   PARM                    DPMD                                         234440
     C                   PARM                    ETCPOSND                                     234440
                                                                                              234440
     C                   EVAL      WrkAPDT = APDT                                             234440
                                                                                              234440
     C                   ENDSR                                                                236705
      *****************************************************************                       236004
     C/EJECT                                                                                  236004
      *****************************************************************                       236004
      *  RtvEffDate - Retrieve Effective Date for Country of Tax.     *                       236004
      *****************************************************************                       236004
     C     RtvEffDate    BEGSR                                                                236004
      *                                                                                       236004
      *  Retrieve Bank Details                                                                236004
     C                   CALL      'AOBANKR0'                                                 236004
     C                   PARM      *BLANKS       P@RTCD                                       236004
     C                   PARM      '*FIRST  '    P@OPTN                                       236004
     C     SDBANK        PARM      SDBANK        DSFDY                                        236004
      *                                                                                       236004
      ** Database Error.                                                                      236004
     C     @RTCD         IFNE      *BLANKS                                                    236004
     C                   MOVEL (P) '*FIRST '     DBKEY                                        236004
     C                   MOVEL (P) 'SDBANKPD'    DBFILE                                       236004
     C                   MOVEL (P) '104'         DBASE                                        236004
     C                   EXSR      *PSSR                                                      236004
     C                   ENDIF                                                                236004
      *                                                                                       236004
      *                                                                                       236004
      ** Retrieve Effective date for Country of Tax.                                          236004
     C                   CALL      'AOCTTXR0'                                                 236004
     C                   PARM      *BLANKS       P@RTCD            7                          236004
     C                   PARM      '*KEY    '    P@OPTN            7                          236004
     C                   PARM      L_BJCNCD      P@CTRT            2                          236004
     C                   PARM      *BLANKS       P@CTRR            2                          236004
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        236004
      *                                                                                       236004
      ** Database Error                                                                       236004
     C     P@RTCD        IFNE      *BLANKS                                                    236004
     C     *LOCK         IN        LDA                                                        236004
     C                   MOVEL (P) 'SDCTTXL1'    DBFILE                                       236004
     C                   MOVEL (P) L_BJCNCD      DBKEY                                        236004
     C                   MOVEL (P) '105'         DBASE                                        236004
     C                   EXSR      *PSSR                                                      236004
     C                   ENDIF                                                                236004
      *                                                                                       236004
     C                   ENDSR                                                                236004
      *****************************************************************                       236705
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Input Fields
 
     C                   PARM                    DDOPDT
     C                   PARM                    DDMVType
     C                   PARM                    DDDPSS
     C                   PARM                    DDDPBN
     C                   PARM                    DDDPBA                                       233698
 
      ** ICD
      ** run date, date format
 
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    DMTD                                         236703
     C                   PARM                    DPMD                                         236705
     C                   PARM                    DPNA                                         236705
     C                   PARM                    DDPTFR                                       234440
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Original Purchase Date - Ok
 
     C                   PARM                    DDOPDTOk
 
      ** Original Purchase Date
 
     C                   PARM                    OPDT
                                                                                              233698
      ** Define key list for file                                                             233698
                                                                                              233698
     C     KEYTR1        KLIST                                                                233698
     C                   KFLD                    WBrca             3                          233698
     C                   KFLD                    WSesn            10                          233698
     C                   KFLD                    WCust                                        233698
     C                   KFLD                    WDate             5 0                        233698
                                                                                              233698
     C     KEYTR2        KLIST                                                                233698
     C                   KFLD                    WBrca             3                          233698
     C                   KFLD                    WSesn            10                          233698
     C                   KFLD                    WCust                                        233698
                                                                                              236705
     C     *LIKE         DEFINE    DDMVType      WType                                        236705
     C     *LIKE         DEFINE    OPDT          WDate                                        236705
     C     *LIKE         DEFINE    OPDT          DPMD                                         236705
     C     *LIKE         DEFINE    DPNA          WAmt                                         236705
     C     *LIKE         DEFINE    OPDT          WrkAPDT                                      236705
                                                                                              236705
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
