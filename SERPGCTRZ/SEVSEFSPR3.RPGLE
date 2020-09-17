     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Fiscal Price')                       *
      *****************************************************************
      *                                                               *
      *  SEVSEFSPR3 - Validate Fiscal Price (Depot Movements)         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
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
      *                 235009             Date 08Aug05               *
      *                 234599             Date 21Jun05               *
      *                 234577             Date 29Jun05               *
      *                 234440             Date 21Jun05               *
      *                 236711             Date 20Jun05               *
      *                 236710             Date 14Jun05               *
      *                 236702             Date 13Jun05               *
      *                 236708             Date 13Jun05               *
      *                 233698             Date 25May05               *
      *                 233778             Date 27May05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
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
      *  235009 - Input of fiscal price is overriden by system        *
      *           default.  Do defaulting only if fiscal price is     *
      *           not entered.                                        *
      *  234599 - Forward Valued Trades with Wrong Fiscal Price       *
      *  234577 - In correct condition on Fiscal Price Validation     *
      *  234440 - Change Control 1 Part 4 - For Switzerland only,     *
      *           bonds at at a discount will have their fiscal price *
      *           calculated on a yield curve.                        *
      *  236711 - Fiscal Price not defaulting                         *
      *  236710 - Fiscal Price for funds should check current prices  *
      *           files first then historic prices.                   *
      *  236702 - Need to default the price again if the original     *
      *           purchase date has changed and the price has not.    *
      *  236708 - If Original purchase date is before effective date  *
      *           use effective date for bonds                        *
      *  233698 - Change Control for CGL031                           *
      *  233778 - Validation of Original Purchase Date                *
      *  CGL031 - Taxation for Savings Income                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FPRICT     IF   E           K DISK    INFSR(*pssr)
     FSECEO     IF   E           K DISK    INFSR(*pssr)
     F                                     RENAME(SNDEVDF:SNDEVDO)
     F***CPOSC**   IF   E           K DISK    INFSR(*pssr)                             233698 234440
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
 
      ** Security Details
     D SecurDtls     E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC_)
     D   CDDS                183    230                                                       234440
     D   CRDS                231    242                                                       234440
 
      ** Client Details data structure
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** External DS for Branch Details                                                       236708
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  236708
                                                                                              236708
      ** External DS for Location Details                                                     236708
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  236708
                                                                                              236708
      ** External DS for Securities Clients                                                   236708
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  236708
                                                                                              236708
      ** Externally described DS for investment types
     D SDINV         E DS                  EXTNAME(INVTPD)
 
      ** EU Tax Customer Position                                                             234440
     D ETCPOSND      E DS                  EXTNAME(ETCPOSND)                                  234440
     D ET_RECI       E                     EXTFLD(RECI)                                       234440
                                                                                              234440
      ** Second DS for Access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
     D BJDFIN          S              1A
     D DPMVType        S              2
     D DDDPBN          S              6
     D DDDPBA          S              3                                                       233698
 
      ** Other Inputs
      ** ------------
     D Proctype        S              1A
     D ZNOML           S             15P 0
     D SCUMEX          S              1A
     D WRKFSPI         S             15P 9
     D NomCcyDec       S              1P 0
     D ZPRCIN          S             15P 8
     D ZPRCOT          S             15P 8
     D ZYLDOK          S              1A
     D ZFDATE          S              5P 0
     D*WCust****       S              6S 0                                            233698 CSD027A
     D WCust           S              6A                                                     CSD027A
 
      ** Screen Fields
 
     D DDFSPR          S             16A
     D OPDT            S              5P 0
     D DDOPDT          S              6A                                                      236702
     D WrkOPDT         S              5P 0                                                    236708
 
      ** Working Fields
 
     D PRCMAT          S              3  0
     D PTYP            S              2A
     D PDAT            S              5  0
     D*PCST*****       S              6  0                                                   CSD027A
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
     D*ZDAYNO***       S              5  0                                             236702 234440
     D*ErrorFlag       S              1                                                236702 234440
     D WkPrcMat        S             15  8
     D FSPP            S             15P 8
     D PRtcd           S              7A
     D POptn           S              7A
     D WkPPRC          S             15P 8
     D OldFSPR         S             15P 8                                                    236702
     D*P_Cust***       S              6S 0                                            234440 CSD027A
     D P_Cust          S              6A                                                     CSD027A
     D P_PTFR          S              4                                                       234440
     D P_Date          S                   LIKE(CSDA)                                         234440
 
      ** Output(s) fields
      ** ----------------
 
     D DDFSPROk        S              1A
     D FSPR            S             15P 8
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
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
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
     C                   Z-ADD     0             FSPR
     C                   Z-ADD     0             FSPP
     C                   Z-ADD     OPDT          WrkOPDT                                      236708
     C                   EXSR      SROpdt                                                     236708
 
      ** Retrieve Beneficiary Details for WalkOut
 
     C**********         IF        DPMVType = 'WO' AND DDDPBN <> *BLANKS                      233778
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
     C                   MOVE      '101'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   IF        PRtcd = '*NRF   '                                          233778
     C                   CLEAR                   SDSECS                                       233778
     C                   ENDIF                                                                233778
     C                   END
 
      ** Retrieve Security Investment Type
 
     C                   CALL      'AOINVTR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    SEC_SITP
     C                   PARM                    SEC_NMCY
     C     SDINV         PARM      SDINV         DSFDY
 
     C                   IF        PRtcd <> *BLANKS
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     SEC_NMCY      DBKEY
     C                   MOVE      SEC_SITP      DBKEY
     C                   MOVEL     'INVTPD'      DBFILE
     C                   MOVE      '102'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Validation carried out if DDFSPR is not blank
 
     C**********         IF        DDFSPR <> *BLANKS                                          234440
     C**********         MOVEL     DDOPDT        ZDATEI                                236702 234440
     C**********         CALLB     'ZDATE1'                                            236702 234440
     C**********         PARM                    ZDATEI                                236702 234440
     C**********         PARM      *ZEROS        ZDAYNO                                236702 234440
     C**********         PARM                    BJDFIN                                236702 234440
     C**********         PARM                    ErrorFlag                             236702 234440
     C**********         ENDIF                                                         236711 234440
     C**********         IF        ZDAYNO <> OPDT                                      236702 234440
     C**********                   AND DDFSPR <> *BLANKS                               236711 234440
     C**********                   OR DDFSPR = *BLANKS                                 236711 234440
     C**********         Z-ADD     FSPR          OldFSPR                               236702 234440
     C     DDFSPR        IFEQ      *BLANK                                                     235009
     C     DDDPBN        IFNE      ##DPBN                                                     234440
     C     SEC_SESN      ORNE      ##SESN                                                     234440
     C     ZNOML         ORNE      ##NOML                                                     234440
     C     OPDT          ORNE      ##OPDT                                                     234440
     C     DDFSPR        OREQ      *BLANK                                                     234440
     c                   EXSR      SRFSPRD                                                    234440
     C                   MOVEL     DDDPBN        ##DPBN            6                          234440
     C                   MOVEL     SEC_SESN      ##SESN           12                          234440
     C                   MOVEL     ZNOML         ##NOML           15 0                        234440
     C                   MOVEL     OPDT          ##OPDT            5 0                        234440
     C                   ENDIF                                                                236702
     C                   ENDIF                                                                235009
                                                                                              236702
     C                   IF        DDFSPR <> *BLANKS                                          236711
     C                   EXSR      SRFSPRV
                                                                                              236702
     C                   ENDIF                                                                236702
     C**********         ENDIF                                                                236702
                                                                                              236702
      ** Need to redefault the fiscal price if the original purchased                         236702
      ** date has changed.                                                                    236702
                                                                                              236702
     C**********         IF        OldFSPR = FSPR and ZDAYNO <> OPDT                          236702
     C**********         EXSR      SRFSPRD                                                    236702
     C**********         ENDIF                                                                236702
 
     C**********         ELSE                                                                 236711
 
      ** Else, default computed Fiscal Price.
 
     C**********         EXSR      SRFSPRD                                                    236711
 
     C**********         ENDIF                                                                236711
 
      ** Convert to Percentage Format
 
     C                   EXSR      SRCONVP
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDFSPRok = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRFSPRV - Validate Fiscal Price                               *
      *****************************************************************
     C     SRFSPRV       BEGSR
 
      **  If Walkout, input on this field is allowed for 'D' and 'S'
      **  custody customer.
 
     C**********         IF        DPMVType = 'WO' AND DDDPBN <> *BLANKS                      233778
     C                   IF        DDDPBN <> *BLANKS                                          233778
 
     C                   IF        BFCLAS <> 'D' AND BFCLAS <> 'S'
     C                   MOVE      'N'           DDFSPRok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0912'     MsgIdXAr(Idx)
     C                   GOTO      EFSPRV
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check valid number entered
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDFSPR        ZFIELD
 
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
     C                   GOTO      EFSPRV
     C                   ENDIF
 
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
 
     C                   MOVE      ZOUT21        DDFSPR
 
     C                   IF        PROT = '7'
     C                             OR PROT = '4' AND SEC_SETX = 'Y'                           234675
     C                             OR (PROT <> '2' AND PROT <> '4'
     C************                   AND PROT <> '7' AND SEC_ISSP < 100)                      234577
     C                               AND PROT <> '7' )                                        234577
 
     C                   IF        FSPR = 0
     C                   MOVE      'N'           DDFSPRok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0914'     MsgIdXAr(Idx)
     C                   Z-ADD     *ZEROS        FSPR
     C                   MOVE      ZOUT21        DDFSPR
     C                   GOTO      EFSPRV
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        FSPR <> 0
     C                   MOVE      'N'           DDFSPRok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0911'     MsgIdXAr(Idx)
     C                   Z-ADD     *ZEROS        FSPR
     C                   MOVE      ZOUT21        DDFSPR
     C                   GOTO      EFSPRV
     C                   ENDIF
 
     C                   ENDIF
 
     C     EFSPRV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRFSPRD - Default Fiscal Price                                *
      *****************************************************************
     C     SRFSPRD       BEGSR
 
      ** No Default for Non-discretionary and Non-safe custody customer
      ** for walkout.
 
     C**********         IF        DPMVType = 'WO' AND DDDPBN <> *BLANKS                      233778
     C                   IF        DDDPBN <> *BLANKS                                          233778
     C                   IF        BFCLAS <> 'D' AND BFCLAS <> 'S'
     C                   MOVE      *BLANKS       DDFSPR
     C                   GOTO      EndDft
     C                   END
     C                   END
 
     C                   IF        DPMVType = 'WI'                                            233698
                                                                                              233698
      ** Default price for funds
 
     C                   IF        PROT = '7'                                                 236710
     C                             OR PROT = '4' AND SEC_SETX = 'Y'                           234675
     C                   MOVEL     'V '          PTYP                                         236710
     C                   Z-ADD     WrkOPDT       PDAT                                         236710
     C**********         Z-ADD     0             PCST                                 236710 CSD027A
     C                   Eval      PCST = *Blanks                                            CSD027A
                                                                                              236710
     C     KEYPT         SETGT     PRICT                                                      234599
     C     KEYPTP        READPE    PRICT                                  33                  234599
     C*****KEYPT         SETLL     PRICT                                               236710 234599
     C*****KEYPTP        READE     PRICT                                  33           234440 234599
     C*****KEYPTP        READE     PRICT                                               236710 234440
                                                                                              236710
     C                   IF        *IN33 = *OFF AND RECI = 'D'                                236710
     C                   Z-ADD     PEXI          FSPR                                         236710
     C                   ELSE                                                                 236710
                                                                                              236710
     C                   MOVEL     'PR'          PTYP
     C**********         Z-ADD     OPDT          PDAT                                         236708
     C                   Z-ADD     WrkOPDT       PDAT                                         236708
 
     C     KEYSC         SETLL     SNDEVDO
     C     KEYSCP        READE     SNDEVDO                                33
 
     C                   IF        *IN33 = *OFF AND RECI = 'D'
     C                             AND PROT = '7'
     C                             OR *IN33 = *OFF AND RECI = 'D'                             234675
     C                             AND PROT = '4' AND SEC_SETX = 'Y'                          234675
     C                   Z-ADD     SNFP          FSPR
     C                   ENDIF
     C                   ENDIF                                                                236710
     C                   ENDIF                                                                236710
 
      ** Default price for bonds
 
     C                   MOVEL     'V '          PTYP
     C                   Z-ADD     0             PDAT
     C**********         Z-ADD     0             PCST                                        CSD027A
     C                   Eval      PCST = *Blanks                                            CSD027A
     C                   Z-ADD     0             WkPPRC
 
     C     KEYPT         SETLL     PRICT
     C     KEYPTP        READE     PRICT                                  33
 
     C                   IF        *IN33 = *OFF AND RECI = 'D'
     C                   Z-ADD     PPRC          WkPPRC
     C                   ENDIF
 
     C                   IF        PROT <> '2' AND PROT <> '4'
     C                             AND PROT <> '7' AND SEC_ISSP < 100
     C                             AND SEC_ISSP <> 0 AND SEC_ISSD <> 0
 
     C                   Z-ADD     100           WkPrcMat
 
     C*****DVCNCD        IFNE      'CH'                                                234440 234440
      ** Calculate default fiscal price based on a Straight Line.                             236137
     C     EWTXCB        IFEQ      'B'                                                        236137
     C                   CALLB     'ZAINTPL2'
     C                   PARM                    SEC_ISSD
     C**********         PARM                    OPDT                                         236708
     C                   PARM                    WrkOPDT                                      236708
     C                   PARM                    SEC_MATY
     C                   PARM                    SEC_ISSP
     C                   PARM                    WkPrcMat
     C                   PARM                    FSPR
                                                                                              236137
      ** Use Actuarial interpolation.                                                         236137
     C                   ELSE                                                                 234440
     C                   CALL      'ZAACTUAR'                                                 234440
     C                   PARM      *BLANK        WRTCD            10                          234440
     C                   PARM                    SEC_ISSD                                     234440
     C                   PARM                    SEC_ISSP                                     234440
     C                   PARM                    SEC_MATY                                     234440
     C                   PARM                    WkPrcMat                                     234440
     C                   PARM                    SEC_DYBS                                     234440
     C                   PARM                    SEC_DVBS                                     234440
     C                   PARM                    CDDS             48                          234440
     C                   PARM                    CRDS             12                          234440
     C                   PARM                    SEC_LCPN                                   BUG11164
     C                   PARM                    WrkOPDT                                      234440
     C                   PARM                    FSPR                                         234440
     C                   ENDIF                                                                234440
 
     C                   ENDIF
 
     C                   IF        PROT <> '2' AND PROT <> '4'
     C                             AND PROT <> '7'
 
     C                   IF        SEC_ISSP = 0 OR SEC_ISSD = 0
     C                             OR SEC_ISSP >= 100
 
     C**********         Z-ADD     WkPPRC        FSPR                                         233698
     C                   Z-ADD     100           FSPR                                         233698
 
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                233698
                                                                                              233698
     C                   IF        DPMVType = 'WO'                                            233698
                                                                                              233698
     C                   MOVEL     DDDPBN        WCust                                        233698
     C*****KEYCP         CHAIN     CPOSC                              34               233698 234440
     C                   EVAL      P_Date = 0                                                 234440
     C                   EVAL      P_Cust = WCust                                             234440
                                                                                              234440
     C                   CALL      'SEETCPRTV'                                                234440
     C                   PARM                    RetCodeIn                                    234440
     C                   PARM                    DDDPBA                                       234440
     C                   PARM                    P_Cust                                       234440
     C                   PARM                    SEC_SESN                                     234440
     C                   PARM                    P_PTFR                                       234440
     C                   PARM                    SEC_MKTI                                     234440
     C                   PARM                    P_Date                                       234440
     C                   PARM                    ETCPOSND                                     234440
                                                                                              233698
     C**********         IF        *IN34 = *OFF                                        233698 234440
     C                   IF        RetCodeIn = *BLANKS                                        234440
     C                   Z-ADD     AVFP          FSPR                                         233698
                                                                                              233698
     C                   ELSE                                                                 233698
     C                   IF        PROT = '7'                                                 233698
     C                             OR PROT = '4' AND SEC_SETX = 'Y'                           234675
     C                   Z-ADD     0             FSPR                                         233698
     C                   ENDIF                                                                233698
                                                                                              233698
     C                   IF        PROT <> '2' AND PROT <> '4'                                233698
     C                             AND PROT <> '7'                                            233698
     C                   Z-ADD     100           FSPR                                         233698
     C                   ENDIF                                                                233698
                                                                                              233698
     C                   ENDIF                                                                233698
                                                                                              233698
     C                   ENDIF                                                                233698
 
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
 
     C                   END
 
     C     EndDft        ENDSR
      *****************************************************************
      * SRCONVP - Convert to Percentage Format                        *
      *****************************************************************
     C     SRCONVP       BEGSR
 
      ** If Trade basis discount or yield convert to percentage price
      ** for checking
 
     C                   IF        DDFSPRok <> 'N'
     C                   IF        SEC_STBS = 'D' or SEC_STBS = 'Y'
     C                   MOVE      FSPR          ZPRCIN
     C**************     MOVE      OPDT          ZFDATE                                       236708
     C                   MOVE      WrkOPDT       ZFDATE                                       236708
 
     C                   CALLB     'ZPRCI'
     C                   PARM                    ZPRCIN
     C                   PARM                    ZFDATE
     C                   PARM                    SecurDtls
     C                   PARM                    NomCcyDec
     C                   PARM                    ProcType
     C                   PARM                    ZNOML
     C                   PARM                    WRKFSPI
     C                   PARM                    SCUMEX
     C                   PARM                    BJDFIN
     C                   PARM                    ZYLDOk
     C                   PARM                    ZPRCOT
 
     C                   MOVE      ZPRCOT        FSPP
     C                   ELSE                                                                 234440
     C                   MOVE      FSPR          FSPP                                         234440
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       236708
      * SROpdt  - Access Effective Date                               *                       236708
      *****************************************************************                       236708
     C     SROpdt        BEGSR                                                                236708
                                                                                              236708
      ** Access branch details                                                                236708
     C                   MOVEL     DDDPBA        @BRCH             3                          236708
     C                   CALLB     'AOBRCHR0'                                                 236708
     C                   PARM      *BLANKS       PRTCD                                        236708
     C                   PARM      '*KEY   '     POPTN                                        236708
     C                   PARM                    @BRCH                                        236708
     C     SDBRCH        PARM      SDBRCH        DSFDY                                        236708
                                                                                              236708
     C     PRTCD         IFNE      *BLANKS                                                    236708
     C**********         EVAL      DBKEY = DDDPBA                                      236708 234599
     C**********         EVAL      DBFILE = 'SDBRCHPD'                                 236708 234599
     C**********         EVAL      DBASE = 3                                           236708 234599
     C**********         EXSR      *PSSR                                               236708 234599
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
     C                   IF        EWEDT1 > WrkOPDT                                           236708
     C                   Z-ADD     EWEDT1        WrkOPDT                                      236708
     C                   ENDIF                                                                236708
                                                                                              236708
     C                   ENDSR                                                                236708
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
     C                   PARM                    DDFSPR
 
      ** INPUTS
 
     C                   PARM                    SecurDtls
     C                   PARM                    OPDT
     C                   PARM                    BJDFIN
     C                   PARM                    WRKFSPI
     C                   PARM                    SCUMEX
     C                   PARM                    ZNOML
     C                   PARM                    NomCcyDec
     C                   PARM                    DPMVType
     C                   PARM                    DDDPBN
     C                   PARM                    DDDPBA                                       233698
     C                   PARM                    DDOPDT                                       236702
     C                   PARM                    P_PTFR                                       234440
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
     C                   PARM                    DDFSPROk
     C                   PARM                    FSPR
     C                   PARM                    FSPP
 
     C     KEYPT         KLIST
     C                   KFLD                    PTYP
     C                   KFLD                    SEC_SESN
     C                   KFLD                    PDAT
     C                   KFLD                    PCST
 
     C     KEYPTP        KLIST
     C                   KFLD                    PTYP
     C                   KFLD                    SEC_SESN
 
     C     KEYSC         KLIST
     C                   KFLD                    SEC_SESN
     C                   KFLD                    PTYP
     C                   KFLD                    PDAT
 
     C     KEYSCP        KLIST
     C                   KFLD                    SEC_SESN
     C                   KFLD                    PTYP
                                                                                              233698
     C     KEYCP         KLIST                                                                233698
     C                   KFLD                    DDDPBA                                       233698
     C                   KFLD                    WCust                                        233698
     C                   KFLD                    SEC_SESN                                     233698
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
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
