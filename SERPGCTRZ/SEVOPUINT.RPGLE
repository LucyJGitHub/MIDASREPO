     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Original Purchased Interest')        *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module                              *
      *                                                               *
      *  SEVOPUINT  - Validate Original Purchased Interest            *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Original Purchased Interest field.                *
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
      *                 BUG11193           Date 02May06               *
      *                 CSD027A            Date 05May06               *
      *                 237063             Date 20Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 234916             Date 13Jul05               *
      *                 234440             Date 21Jun05               *
      *                 236754             Date 20Jun05               *
      *                 236702             Date 13Jun05               *
      *                 233698             Date 25May05               *
      *                 233778             Date 27May05               *
      *                 232543             Date 29Mar05               *
      *                 CGL031  *CREATED   Date 05Jul04               *
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
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  234916 - Incorrect set up of Cum/Ex indicator                *
      *  234440 - Change Control 1 Part 4 - For Switzerland only,     *
      *           bonds at at a discount will have their fiscal price *
      *           calculated on a yield curve.                        *
      *  236754 - Defaults for Walk outs should not be restricted to  *
      *           after last coupon date                              *
      *  236702 - Need to default the original purchased interest if  *
      *           the original purchase date has changed and the      *
      *           original purchased interest has not.                *
      *  233698 - Change Control for CGL031                           *
      *  233778 - Validation of Original Purchase Date                *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F***CPOSH**   IF   E           K DISK    INFSR(*pssr)                                    233698
     F***CPOSC**   IF   E           K DISK    INFSR(*pssr)                             233698 234440
 
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
 
      ** Array for manipulating decimal positions                                             236754
     D POWER8          S              8  4 DIM(8) CTDATA PERRCD(1)                            236754
                                                                                              236754
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Security Details
     D SecurDtls     E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC_)
     D CDArr                 183    230
     D CRArr                 231    242
 
      ** Client Details data structure
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Externally described DS for investment types
     D SDINV         E DS                  EXTNAME(INVTPD)
 
      ** Securities Trading Standing Data
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
                                                                                              234440
      ** External DS for Branch Details                                                       234440
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  234440
                                                                                              234440
      ** External DS for Customer Details                                                     234440
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  234440
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035
                                                                                              234440
      ** External DS for Location Code                                                        234440
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                  234440
                                                                                              234440
      ** External DS for Country of Tax Code                                                  234440
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                  234440
                                                                                              234440
      ** EU Tax Customer Position                                                             234440
     D ETCPOSND      E DS                  EXTNAME(ETCPOSND)                                  234440
     D ET_RECI       E                     EXTFLD(RECI)                                       234440
 
      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Screen Fields
     D DDOPIN          S             14A
     D DDACIN          S              1A
     D DDOPDT          S              6A                                                      236702
 
      ** Depot Movement details Input
     D DPSS            S             10A
     D DPNA            S             11P 0
     D OPDT            S              5P 0
     D DPVD            S              5  0
     D OPIN            S             13P 0
     D ACIN            S              1A
     D DPBA            S              3
     D DPMVType        S              2
     D DDDPBN          S              6
 
     ** System Info
     D Default         S              1A
     D Validate        S              1A
     D NomCcyDec       S              1  0
     D BJDFIN          S              1A
 
      ** Output(s) fields
     D DDOPINOk        S              1A
 
      ** Working variable
     D ZITRA           S             13  0
     D TDCR            S             11P 7
     D ZADIN           S              1A
     D ZCPOVR          S              1A
     D ZTINA           S             13  0
     D DADJN           S              1A
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZDATEI          S              6                                                       236702
     D ZDAYNO          S              5  0                                                    236702
     D ErrorFlag       S              1                                                       236702
     D ZADIG           S              2P 0
     D ZADEC           S              1P 0
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZECHAR          S              1
     D ZOUT21          S             21
     D PRtcd           S              7A
     D POptn           S              7A
     D*WkCnum***       S              6  0                                                   CSD027A
     D WkCnum          S              6A                                                     CSD027A
     D*WkAvAmt**       S              8P 0                                                    233440
     D WkAvAmt         S             15P 0                                                    233440
     D*WkOPIN***       S              7P 0                                                    236754
     D WkOPIN          S             30P 4                                                    236754
     D OldOPIN         S             13P 0                                                    236702
     D WrkOPDT         S              5P 0                                                    236702
     D P_Date          S                   Like(CSDA)                                         233440
     D*P_Cust***       S              6S 0                                            233440 CSD027A
     D P_Cust          S              6A                                                     CSD027A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANKS       WFldNmXAr
     C                   MOVE      *BLANKS       WMsgIDXAr
     C                   MOVE      *BLANKS       WMsgDtXAr
     C                   Z-ADD     0             WIx
 
     C                   Z-ADD     0             OPIN
 
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
     C                   ENDIF
     C                   IF        PRtcd = '*NRF   '                                          233778
     C                   CLEAR                   SDSECS                                       233778
     C                   ENDIF                                                                233778
     C                   ENDIF
 
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
                                                                                              234440
      ** Branch details                                                                       234440
                                                                                              234440
     C                   CALL      'AOBRCHR0'                                                 234440
     C                   PARM      *BLANKS       PRTCD                                        234440
     C                   PARM      '*KEY   '     POPTN                                        234440
     C                   PARM      DPBA          @DTDBA            3                          234440
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        234440
                                                                                              234440
      ** Country code details                                                                 234440
                                                                                              234440
     C                   CALL      'AOLOCNR0'                                                 234440
     C                   PARM      *BLANKS       PRTCD                                        234440
     C                   PARM      '*KEY   '     POPTN                                        234440
     C                   PARM      A8LCCD        @DLCCD            3                          234440
     C     SDLOCN        PARM      SDLOCN        DSFDY                                        234440
                                                                                              234440
      ** Customer details                                                                     234440
                                                                                              234440
     C                   MOVEL     *BLANK        @PKEY1                                       234440
     C                   MOVEL     DDDPBN        @PKEY1                                       234440
     C                   CALL      'AOCUSTR0'                                                 234440
     C                   PARM      *BLANK        PRTCD             7                          234440
     C                   PARM      '*KEY   '     POPTN             7                          234440
     C                   PARM                    @PKEY1           10                          234440
     C                   PARM                    @PKYST            7                          234440
     C     SDCUST        PARM      SDCUST        DSSDY                                        234440
                                                                                              234440
      ** Tax basket                                                                           234440
                                                                                              234440
     C                   CALL      'AOCTTXR0'                                                 234440
     C                   PARM      *BLANKS       PRTCD                                        234440
     C                   PARM      '*KEY   '     POPTN                                        234440
     C                   PARM      DVCNCD        @PCTRT            2                          234440
     C                   PARM      BBCOLC        @PCTRR            2                          234440
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        234440
                                                                                              234440
     C                   IF        PRTCD = '*NRF   '                                          234440
     C                   CALL      'AOCTTXR0'                                                 234440
     C                   PARM      *BLANKS       PRTCD                                        234440
     C                   PARM      '*KEY   '     POPTN                                        234440
     C                   PARM      DVCNCD        @PCTRT                                       234440
     C                   PARM      *BLANK        @PCTRR                                       234440
     C     SDCTTX        PARM      SDCTTX        DSFDY                                        234440
     C                   ENDIF                                                                234440
 
      ** Defaulting
 
     C                   IF        Default = 'Y' AND DDOPIN = *BLANKS                         237063
     C                   EXSR      SROPIND                                                    237063
     C                   ENDIF                                                                237063
     C**********         IF        Default = 'Y' AND DDOPIN = *BLANKS                         234440
     C**********                   AND OPDT < SEC_LCPN                                        233698
     C**********                   AND OPDT > SEC_LCPN                                 233698 234440
     C**********                   AND DPMVType = 'WI'                                 236754 234440
     C**********                   OR Default = 'Y' AND DDOPIN = *BLANKS               236754 234440
     C**********                   AND DPMVType = 'WO'                                 236754 234440
     C**********         IF         Default = 'Y'                                      234440 237063
     C*****DDDPBN        IFNE      ##DPBN                                              234440 237063
     C*****DPSS*         ORNE      ##DPSS                                              234440 237063
     C*****DPNA*         ORNE      ##DPNA                                              234440 237063
     C*****OPDT*         ORNE      ##OPDT                                              234440 237063
     C*****DDOPIN        OREQ      *BLANK                                              234440 237063
     C**********         EXSR      SROPIND                                                    237063
     C**********         ENDIF                                                         234440 237063
     C**********         MOVEL     DDDPBN        ##DPBN            6                   234440 237063
     C**********         MOVEL     DPSS          ##DPSS           12                   234440 237063
     C**********         MOVEL     DPNA          ##DPNA           11 0                 234440 237063
     C**********         MOVEL     OPDT          ##OPDT            5 0                 234440 237063
     C**********         ENDIF                                                                237063
 
      ** Validation
 
     C                   IF        Validate = 'Y' AND DDOPIN <> *BLANKS
     C**********         MOVEL     DDOPDT        ZDATEI                                236702 234440
     C**********         CALLB     'ZDATE1'                                            236702 234440
     C**********         PARM                    ZDATEI                                236702 234440
     C**********         PARM      *ZEROS        ZDAYNO                                236702 234440
     C**********         PARM                    BJDFIN                                236702 234440
     C**********         PARM                    ErrorFlag                             236702 234440
     C**********         IF        ZDAYNO <> OPDT                                      236702 234440
     C**********         Z-ADD     OPIN          OldOPIN                               236702 234440
     C**********         ENDIF                                                         236702 234440
                                                                                              236702
     C                   EXSR      SROPINV
                                                                                              236702
      ***Need*to*redefault*the*original*purchased*interest*if*the******                236702 234440
      ***original*purchased*date*has*changed.**************************                236702 234440
      **********                                                                       236702 234440
     C**********         IF        OldOPIN = OPIN and ZDAYNO <> OPDT                   236702 234440
     C**********         EXSR      SROPIND                                             236702 234440
     C**********         ENDIF                                                         236702 234440
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDOPINOk = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SROPINV - Original Purchased Interest Validation              *
      *****************************************************************
     C     SROPINV       BEGSR
 
      **  If Walkout, input on this field is allowed for 'D' and 'S'
      **  custody customer.
 
     C                   IF        DPMVType = 'WO' AND DDOPIN <> *BLANKS
     C                             AND DDDPBN <> *BLANKS
 
     C                   IF        BFCLAS <> 'D' AND BFCLAS <> 'S'
     C                   MOVE      'N'           DDOPINok
     C                   ADD       1             Idx
     C                   MOVEL     'DDFSPR'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0912'     MsgIdXAr(Idx)
     C                   GOTO      EOPINV
     C                   ENDIF
 
     C                   ENDIF
 
      ** DDOPIN should be blank for Commodities, Equities and Funds.
 
     C                   IF        PROT = '2' OR  PROT = '4' OR  PROT = '7'
 
     C                   IF        DDOPIN <> *BLANKS
     C                   MOVE      'N'           DDOPINok
     C                   ADD       1             Idx
     C                   MOVEL     'DDOPIN'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0906'     MsgIdXAr(Idx)
     C                   GOTO      EOPINV
     C                   END
 
     C                   END
 
      ** DDOPIN should be blank for Non-interest bearing bonds.
 
     C                   IF        PROT = '1' OR PROT = '3' OR PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' OR PROT = '9'
 
     C                   IF        SEC_CPNR = 0 AND DDOPIN <> *BLANKS
     C                   MOVE      'N'           DDOPINok
     C                   ADD       1             Idx
     C                   MOVEL     'DDOPIN'      FldNamXAr(Idx)
     C                   MOVEL     'SEA0906'     MsgIdXAr(Idx)
     C                   GOTO      EOPINV
     C                   END
 
     C                   END
 
      ** check valid number entered
 
     C**********         MOVE      *BLANKS       ZFIELD                                       234916
     C**********         MOVE      DDOPIN        ZFIELD                                       234916
     C                   MOVE      *BLANKS       ZFLD17                                       234916
     C                   MOVEL     DDOPIN        ZFLD17                                       234916
     C     13            SUB       NomCcyDec     ZSDIG                                        234916
     C                   Z-ADD     NomCcyDec     ZSDEC                                        234916
     C                   MOVE      *BLANKS       ZSDCSP                                       234916
 
     C**********         Z-ADD     NomCcyDec     ZADEC                                        234916
     C*****13***         SUB       NomCcyDec     ZADIG                                        234916
 
     C**********         CALLB     'ZALIGN'                                                   234916
     C**********         PARM                    ZALIGNok                                     234916
     C**********         PARM                    ZFIELD                                       234916
     C**********         PARM                    ZADEC                                        234916
     C**********         PARM                    ZADIG                                        234916
     C                   CALLB     'ZASIGN'                                                   234916
     C                   PARM                    ZALIGNok          1                          234916
     C                   PARM                    ZFLD17           17                          234916
     C                   PARM                    ZSDIG             2 0                        234916
     C                   PARM                    ZSDEC             1 0                        234916
     C                   PARM                    ZSDCSP            1                          234916
     C                   PARM                    ZOUT15           15                          234916
     C                   PARM                    ZFSIGN            1                          234916
 
     C                   IF        ZALIGNok = 'N'
     C                   ADD       1             Idx
     C**********         MOVEL     'DDDPNA'      FldNamXAr(Idx)                               232543
     C                   MOVEL     'DDOPIN'      FldNamXAr(Idx)                               232543
     C                   MOVEL     'SEA0913'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDOPINOk
     C                   GOTO      EOPINV
     C                   ENDIF
 
      ** Update Transaction
 
     C**********         MOVE      ZFIELD        OPIN                                         234916
     C                   MOVE      ZOUT15        OPIN                                         234916
 
     C     EOPINV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SROPIND - Original Purchased Interest Default                *
      *****************************************************************
     C     SROPIND       BEGSR
 
      ** No Default for Commodities, Equities and Funds
 
     C                   IF        PROT = '2' OR  PROT = '4' OR  PROT = '7'
     C                   MOVE      *BLANK        DDOPIN
     C                   GOTO      EndDft
     C                   END
 
      ** No Default for Non-interest Bearing
 
     C                   IF        PROT = '1' OR PROT = '3' OR PROT = '5'
     C                             OR PROT = '6' OR PROT = '8' OR PROT = '9'
     C                   IF        SEC_CPNR = 0
     C                   MOVE      *BLANK        DDOPIN
     C                   GOTO      EndDft
     C                   END
     C                   END
 
      ** No Default for Depot Walk Out if not discretionary or safe
      ** custody customer
 
     C                   IF        DPMVType = 'WO'
     C                   IF        BFCLAS <> 'D' AND BFCLAS <> 'S'
     C                   MOVE      *BLANK        DDOPIN
     C                   GOTO      EndDft
     C                   END
     C                   END
 
      **  Retrieve Original Purchase Date
 
     C                   Z-ADD     OPDT          DPVD
                                                                                              234440
      ** If original purchase date is prior to efffective date, use effective date            234440
      ** for original purchase interest calculation                                           234440
                                                                                              234440
     C                   IF        EWEDT1 > DPVD                                              234440
     C                             AND DPVD <> 0                                              234440
     C                   Z-ADD     EWEDT1        DPVD                                         234440
     C                   ENDIF                                                                234440
                                                                                              234440
      ** Original Purchased Interest must be blank if purchased date is prior to last coupon  234440
                                                                                              234440
     C                   IF        DPVD < SEC_LCPN                                            234440
     C                             AND DPVD <> 0                                              234440
     C                             AND DPMVType = 'WI'                                        234440
     C                   MOVE      *BLANK        DDOPIN                                       234440
     C                   GOTO      EndDft                                                     234440
     C                   END                                                                  234440
 
      **  Default Accrued Indicator
 
     C**********         MOVEL     'C'           ACIN                                         234916
     C**********         MOVEL     ACIN          DDACIN                                       234916
     C                   MOVEL     DDACIN        ACIN                                         234916
 
      **  Not Update Original Purchased Interest if it is not setupped
 
     C                   IF        DPVD <> 0
 
     C                   Z-ADD     SEC_CPNR      TDCR
     C                   MOVE      *BLANKS       ZADIN
     C                   MOVE      'N'           ZCPOVR
 
     C                   IF        ACIN = 'X'                                                 234916
     C                   EVAL      ZTINA = 0                                                  234916
     C                   MOVE      *BLANKS       ZFLD17                                       234916
     C                   MOVEL     '0'           ZFLD17                                       234916
     C     13            SUB       NomCcyDec     ZSDIG                                        234916
     C                   Z-ADD     NomCcyDec     ZSDEC                                        234916
     C                   MOVE      *BLANKS       ZSDCSP                                       234916
     C                   CALLB     'ZASIGN'                                                   234916
     C                   PARM                    ZALIGNok          1                          234916
     C                   PARM                    ZFLD17           17                          234916
     C                   PARM                    ZSDIG             2 0                        234916
     C                   PARM                    ZSDEC             1 0                        234916
     C                   PARM                    ZSDCSP            1                          234916
     C                   PARM                    ZOUT15           15                          234916
     C                   PARM                    ZFSIGN            1                          234916
                                                                                              234916
     C                   MOVE      ZOUT15        ZITRA                                        234916
                                                                                              234916
     C                   ELSE                                                                 234916
                                                                                              234916
     C                   CALLB     'ZPCINT'
     C                   PARM                    SecurDtls
     C                   PARM                    DADJN
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
     C                   PARM                    DPNA
     C                   PARM                    ACIN
     C                   PARM                    SEC_IADJ
     C                   PARM                    ZADIN
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR
     C                   PARM                    BJDFIN
     C                   PARM                    DPVD
     C                   PARM                    ZITRA
     C                   PARM                    ZTINA
 
     C                   ENDIF                                                                234916
     C                   MOVE      ZITRA         OPIN
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      ZITRA         ZFLD15
 
     C                   ENDIF
 
     C                   IF        DPMVType = 'WO' AND OPDT <> 0
     C                   IF        BFCLAS = 'D' OR BFCLAS = 'S'
 
      ***Access*Securities*Trading*Details*****************************                       233698
      *****************************************************************                       233698
     C**********         CALL      'AOSTRDR0'                                                 233698
     C**********         PARM      *BLANKS       PRTcd                                        233698
     C**********         PARM      '*FIRST  '    POptn                                        233698
     C*****SDSTRD        PARM      SDSTRD        DSSDY                                        233698
      **********                                                                              233698
     C*****PRTcd         IFNE      *BLANK                                                     233698
     C**********         MOVEL     POptn         DBKEY                                        233698
     C**********         MOVEL     'SDSTRDPD'    DBFILE                                       233698
     C**********         MOVEL     '103'         DBASE                                        233698
     C**********         EXSR      *PSSR                                                      233698
     C**********         ENDIF                                                                233698
 
     C                   MOVEL     DDDPBN        WkCnum
     C                   EVAL      P_Cust = WkCnum                                            234440
 
     C*****KEYCP         SETLL     CPOSNDF                                             233698 234440
     C*****KEYCPD        SETLL     CPOSNDF                                             233698 234440
     C*****KEYCPD        READE     CPOSNDF                                99                  234440
 
     C**********         IF        BVTVDV = 'T'                                               233698
     C**********         Z-ADD     CSNT          WkAvAmt                                      233698
     C**********         ENDIF                                                                233698
 
     C**********         IF        BVTVDV = 'V'                                               233698
     C**********         Z-ADD     CSNV          WkAvAmt                                      234440
     C**********         ENDIF                                                                233698
                                                                                              233440
      ** Get Customer Depot Position for Changes to Nominal Amount Today                      233440
                                                                                              233440
     C                   EVAL      P_Date = 0                                                 233440
                                                                                              233440
     C                   CALL      'SEETCPRTV'                                                234440
     C                   PARM                    RetCodeIn                                    234440
     C                   PARM                    DPBA                                         234440
     C                   PARM                    P_Cust                                       234440
     C                   PARM                    SEC_SESN                                     234440
     C                   PARM                    @PTFR                                        234440
     C                   PARM                    SEC_MKTI                                     234440
     C                   PARM                    P_Date                                       234440
     C                   PARM                    ETCPOSND                                     234440
 
     C**********         IF        WkAvAmt = 0                                                234440
     C                   IF        CSNV = 0                                                   234440
     C                   Z-ADD     0             OPIN
     C                   ELSE
     C     DPNA          MULT      CSPI          WkOPIN
     C     WkOPIN        IFLT      0                                                          233698
     C                   Z-SUB     WkOPIN        WkOPIN                                       233698
     C                   ENDIF                                                                233698
     C*****WkOPIN        DIV       WkAvAmt       OPIN                                         236754
     C*****WkOPIN        DIV       WkAvAmt       WkOPIN                                236754 234440
     C     WkOPIN        DIV       CSNV          WkOPIN                                       234440
     C                   EVAL      OPIN = WkOPIN                                              236754
                                                                                              236754
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      OPIN          ZFLD15
 
     C                   END
     C                   END
 
     C                   Z-ADD     NomCcyDec     ZDECS
     C                   MOVE      *BLANKS       ZECODE
     C                   MOVE      *BLANKS       ZECHAR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM                    ZECHAR
     C                   PARM                    ZOUT21
 
     C                   IF        OPIN = *ZERO                                               237063
     C                   MOVE      *BLANKS       DDOPIN                                       237063
     C                   ELSE                                                                 237063
     C                   MOVE      ZOUT21        DDOPIN
     C                   ENDIF                                                                237063
 
     C     EndDft        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code Error Indicator
 
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
      ** Screen inputs
      ** Original Purchased Interest (14A)
      ** Depot Movement Type (2A)
      ** Beneficiary Customer (6A)
      ** Accured Indicator (1A)
 
     C                   PARM                    DDOPIN
     C                   PARM                    DPMVType
     C                   PARM                    DDDPBN
     C                   PARM                    DDACIN
     C                   PARM                    DDOPDT                                       236702
 
      ** Depot Movement details Input
      ** Security (10A)
      ** Nominal (11P 0)
      ** Original Purchased Date (5P 0)
      ** Format Date Indicator (1A)
 
     C                   PARM                    DPSS
     C                   PARM                    DPNA
     C                   PARM                    OPDT
     C                   PARM                    DPBA
     C                   PARM                    BJDFIN
 
      ** Security Details
      ** Nominal currency details
 
     C                   PARM                    SecurDtls
     C                   PARM                    NomCcyDec
 
      ** ICD
      ** System Details
      ** Default (1A)
      ** Validate (1A)
 
     C                   PARM                    Default
     C                   PARM                    Validate
     C                   PARM                    @PTFR             4                          234440
 
      ** Returned parameters
      ** -------------------
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Purchased Interest Ok Indicator (1A)
 
     C                   PARM                    DDOPINOk
     C                   PARM                    OPIN
     C                   PARM                    ACIN
 
     C*****KEYCP         KLIST                                                                233698
     C**********         KFLD                    DPBA                                         233698
     C**********         KFLD                    SEC_SESN                                     233698
     C**********         KFLD                    WkCnum                                       233698
     C**********         KFLD                    OPDT                                         233698
 
     C     KEYCPD        KLIST
     C                   KFLD                    DPBA
     C**********         KFLD                    SEC_SESN                                     233698
     C                   KFLD                    WkCnum
     C                   KFLD                    SEC_SESN                                     233698
                                                                                              233440
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2004
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION                                          233774
00000001                                                                                      233774
00000010                                                                                      233774
00000100                                                                                      233774
00001000                                                                                      233774
00010000                                                                                      233774
00100000                                                                                      233774
01000000                                                                                      233774
10000000                                                                                      233774
