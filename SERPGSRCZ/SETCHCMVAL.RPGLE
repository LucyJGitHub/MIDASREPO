     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade charges and commissions Validation')    *
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETCHCMVAL - Trade Charges & Commissions Validation          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 AR941082           Date 27Mar12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 205126             Date 24Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 31Aug99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 156689             Date 18Mar99               *
      *                 CAP003  *CREATE    Date 28Jan98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR941082 - Allow Charge Code 7 defaulted value when Stamp    *
      *             Tax feature is enabled                            *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  205126 - If private banking on (BGN4ST passed as paramater), *
      *           bypass some customer commission validation so that  *
      *           entry will be allowed in the (Code and Amount)      *
      *           Customer Commission even if the classification      *
      *           (Security Customer details) of the trade            *
      *           counterparty is not 'S' or 'D'.                     *
      *  CPB001 - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT changed                             *
      *  156689 - ZASIGN To Recognize '.' or ',' as decimal separator *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FSECGT     IF   E           K DISK
     FPMPORTPD  IF   E           K DISK
     FPMPORTLL  IF   E           K DISK    RENAME(PMPORTP0:PMPORTZ0)            CPB001
 
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
 
      ** Trade charges & commissions in screen format
     D TrChCm        E DS                  EXTNAME(SETRCCPD)
 
     D OKTrChCm      E DS                  EXTNAME(SEETRCCPD)
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
                                                                                            AR941082
      ** Parameters for AOSARDR0                                                            AR941082
     D PRTCD           S              7A                                                    AR941082
     D POPTN           S              7A                                                    AR941082
     D PSARD           S              6A                                                    AR941082
                                                                                            AR941082
     D CER049          S              1A                                                    AR941082
                                                                                            AR941082
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
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   MOVEL     *BLANK        TBCC
     C                   Z-ADD     0             TBCA
     C                   MOVEL     *BLANK        TCCC
     C                   Z-ADD     0             TCCA
     C                   MOVEL     *BLANK        TCC1
     C                   Z-ADD     0             TCA1
     C                   MOVEL     *BLANK        TCC2
     C                   Z-ADD     0             TCA2
     C                   MOVEL     *BLANK        TCC3
     C                   Z-ADD     0             TCA3
     C                   MOVEL     *BLANK        TCC4
     C                   Z-ADD     0             TCA4
     C                   MOVEL     *BLANK        TCC5
     C                   Z-ADD     0             TCA5
     C                   MOVEL     *BLANK        TCC6
     C                   Z-ADD     0             TCA6
     C                   MOVEL     *BLANK        TCC7
     C                   Z-ADD     0             TCA7
     C                   Z-ADD     0             TAXA
     C                   Z-ADD     0             BCMR
     C                   Z-ADD     0             CCMR
     C                   Z-ADD     0             TXRB
     C                   MOVEL     *BLANK        PTFR
     C                   Z-ADD     0             SPXR
     C                   MOVEL     *BLANK        SPMD
 
      ** Clear output screen fields
 
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
      *
      * All charge codes are in nominal currency
      *
     C                   MOVE      NMCY          @C_CCY
      *
      * Validate Broker Commission Code & Amount
      *
     C                   EXSR      V_BROKCM
      *
      * Validate Customer Commission Code & Amount
      *
     C                   EXSR      V_CUSTCM
      *
      * Validate Charge Code 1 & Amount 1
      *
     C                   EXSR      V_CHRG1
      *
      * Validate Charge Code 2 & Amount 2
      *
     C                   EXSR      V_CHRG2
      *
      * Validate Charge Code 3 & Amount 3
      *
     C                   EXSR      V_CHRG3
      *
      * Validate Charge Code 4 & Amount 4
      *
     C                   EXSR      V_CHRG4
      *
      * Validate Charge Code 5 & Amount 5
      *
     C                   EXSR      V_CHRG5
      *
      * Validate AUTOCHARGE Codes and Amounts
      *
     C     BVACOP        IFEQ      'Y'
      *
      * Validate Charge Code 6 & Amount 6
      *
     C                   EXSR      V_CHRG6
      *
      * Validate Charge Code 7 & Amount 7
      *
     C                   EXSR      V_CHRG7
      *
      * Validate Tax Amount
      *
     C     DDTAXA        IFNE      *BLANKS
     C                   EXSR      V_TAXA
     C                   END
      *
      * Validate Broker Commission Rebate
      *
     C     DDBCMR        IFNE      *BLANKS
     C                   EXSR      V_BROKCMR
     C                   END
      *
      * Validate Customer Commission Rebate
      *
     C     DDCCMR        IFNE      *BLANKS
     C                   EXSR      V_CUSTCMR
     C                   END
      *
      * Validate Tax Rebate
      *
     C     DDTXRB        IFNE      *BLANKS
     C                   EXSR      V_TAXREB
     C                   END
     C                   END
      *
      ** Adjust sign of charge amounts
      *
     C                   EXSR      ADJCHGSGN
      *
      * Validate Portfolio Reference if portfolio management is installed
      * and if not bank portfolios and if customer is a PM customer
      * Or if Private Banking Module is present                                 CPB001
      * (Bank portfolio reference is validated as part of book validation)
      *
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
     C     CustPM        ANDEQ     'Y'
     C     CustPB        OREQ      'Y'                                          CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C                   EXSR      V_PTFR
     C                   END
      *
      * Calculate Portfolio Exchange Rate
      * if bank portfolios or if customer is a PM customer
      *
     C     BGPFMG        IFEQ      'Y'
     C     ddPTFRok      ANDNE     'N'
     C     FCPORS        IFEQ      'B'
     C     CustPM        OREQ      'Y'
     C                   EXSR      C_PTFRXR
     C                   END
     C                   END
      *
      ** Return
      *
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * V_BROKCM Validate Broker Commission Code & Amount             *
      *                                                               *
      *****************************************************************
     C     V_BROKCM      BEGSR
      *
     C                   MOVEL     DDTBCC        TBCC
      *
      * Broker commission code
      *    .. must be a valid code on SECGT
      *
     C     DDTBCC        IFNE      *BLANKS
     C                   MOVEL     DDTBCC        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTBCC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0606'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTBCCok
     C                   ELSE
     C                   MOVE      REBA          TBCC_REBA         1
     C                   END
     C                   END
      *
      * Broker commission code
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTBCA        IFNE      *BLANKS
     C     DDTBCC        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTBCC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0607'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTBCCok
     C                   END
      *
      * Broker commission amount
      *    .. mandatory if Broker Commission Code entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTBCA        IFEQ      *BLANKS
     C     DDTBCC        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTBCA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0608'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTBCAok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTBCA        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTBCA        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTBCA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0609'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTBCAok
     C                   ELSE
     C                   MOVE      ZOUT15        TBCA
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TBCA          TBCA
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CUSTCM Validate Customer Commission Code & Amount           *
      *                                                               *
      *****************************************************************
     C     V_CUSTCM      BEGSR
      *
     C                   MOVEL     DDTCCC        TCCC
      *
      * Customer commission code
      *    .. prohibited if client is not safe custody or discretionary
      *
     C     DDTCCC        IFNE      *BLANKS
 
     C     BGN4ST        IFNE      'Y'                                                        205126
     C     CustClass     IFNE      'S'
     C     CustClass     ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCCC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0610'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCCCok
     C                   END
     C                   END                                                                  205126
      *
      *    .. must be a valid code on SECGT
      *
     C                   MOVEL     DDTCCC        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCCC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0611'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCCCok
     C                   ELSE
     C                   MOVE      REBA          TCCC_REBA         1
     C                   END
     C                   END
      *
      * Customer commission code
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCCA        IFNE      *BLANKS
     C     DDTCCC        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCCC'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0612'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCCCok
     C                   END
      *
      * Customer commission amount
      *    .. mandatory if Customer Commission Code entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTCCA        IFEQ      *BLANKS
     C     DDTCCC        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCCA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0613'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCCAok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTCCA        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCCA        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCCA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0614'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCCAok
     C                   ELSE
     C                   MOVE      ZOUT15        TCCA
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCCA          TCCA
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG1 Validate Charge Code 1 & Amount 1                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG1       BEGSR
      *
     C                   MOVEL     DDTCC1        TCC1
      *
      * Charge code 1
      *    .. must be a valid code on SECGT
      *
     C     DDTCC1        IFNE      *BLANKS
     C                   MOVEL     DDTCC1        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC1'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0615'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC1ok
     C                   END
     C                   END
      *
      * Charge code 1
      *   .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCA1        IFNE      *BLANKS
     C     DDTCC1        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC1'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0616'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC1ok
     C                   END
      *
      * Charge amount 1
      *    .. mandatory if Charge Code 1 entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTCA1        IFEQ      *BLANKS
     C     DDTCC1        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA1'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0617'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA1ok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTCA1        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA1        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA1'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0618'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA1ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA1
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA1          TCA1
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG2 Validate Charge Code 2 & Amount 2                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG2       BEGSR
      *
     C                   MOVEL     DDTCC2        TCC2
      *
      * Charge code 2
      *    .. must be a valid code on SECGT
      *
     C     DDTCC2        IFNE      *BLANKS
     C                   MOVEL     DDTCC2        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC2'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0619'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC2ok
     C                   END
     C                   END
      *
      * Charge code 2
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCA2        IFNE      *BLANKS
     C     DDTCC2        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC2'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0620'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC2ok
     C                   END
      *
      * Charge amount 2
      *    .. mandatory if Charge Code 2 entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTCA2        IFEQ      *BLANKS
     C     DDTCC2        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA2'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0621'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA2ok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTCA2        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA2        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA2'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0622'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA2ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA2
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA2          TCA2
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG3 Validate Charge Code 3 & Amount 3                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG3       BEGSR
      *
     C                   MOVEL     DDTCC3        TCC3
      *
      * Charge code 3
      *    .. must be a valid code on SECGT
      *
     C     DDTCC3        IFNE      *BLANKS
     C                   MOVEL     DDTCC3        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC3'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0623'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC3ok
     C                   END
     C                   END
      *
      * Charge code 3
      *   .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCA3        IFNE      *BLANKS
     C     DDTCC3        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC3'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0624'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC3ok
     C                   END
      *
      * Charge amount 3
      *    .. mandatory if Charge Code 3 entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTCA3        IFEQ      *BLANKS
     C     DDTCC3        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA3'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0625'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA3ok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTCA3        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA3        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA3'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0626'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA3ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA3
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA3          TCA3
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG4 Validate Charge Code 4 & Amount 4                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG4       BEGSR
      *
     C                   MOVEL     DDTCC4        TCC4
      *
      * Charge code 4
      *    .. must be a valid code on SECGT
      *
     C     DDTCC4        IFNE      *BLANKS
     C                   MOVEL     DDTCC4        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC4'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0627'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC4ok
     C                   END
     C                   END
      *
      * Charge code 4
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCC4        IFEQ      *BLANKS
     C     DDTCA4        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC4'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0628'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC4ok
     C                   END
      *
      * Charge amount 4
      *    .. mandatory if Charge Code 4 entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTCC4        IFNE      *BLANKS
     C     DDTCA4        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA4'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0629'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA4ok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTCA4        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA4        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA4'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0630'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA4ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA4
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA4          TCA4
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG5 Validate Charge Code 5 & Amount 5                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG5       BEGSR
      *
     C                   MOVEL     DDTCC5        TCC5
      *
      * Charge Code 5
      *    .. must be a valid code on SECGT
      *
     C     DDTCC5        IFNE      *BLANKS
     C                   MOVEL     DDTCC5        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC5'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0631'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC5ok
     C                   END
     C                   END
      *
      * Charge Code 5
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCC5        IFEQ      *BLANKS
     C     DDTCA5        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC5'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0632'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC5ok
     C                   END
      *
      * Charge amount 5
      *    .. Code is mandatory if Charge amount 5 entered
      *
     C     BVACOP        IFNE      'Y'
     C     DDTCC5        IFNE      *BLANKS                                                     06742
     C     DDTCA5        ANDEQ     *BLANKS                                                     06742
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA5'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0633'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA5ok
     C                   END
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C     DDTCA5        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA5        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA5'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0634'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA5ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA5
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA5          TCA5
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG6 Validate Charge Code 6 & Amount 6                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG6       BEGSR
      *
     C                   MOVEL     DDTCC6        TCC6
      *
      * Charge Code 6
      *    .. must be a valid code on SECGT
      *
     C     DDTCC6        IFNE      *BLANKS
     C                   MOVEL     DDTCC6        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC6'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0635'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC6ok
     C                   END
     C                   END
      *
      * Charge Code 6
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCA6        IFNE      *BLANKS
     C     DDTCC6        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC6'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0636'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC6ok
     C                   END
      *
      * Charge Amount 6
      *    .. if entered, must be a valid amount
      *
     C     DDTCA6        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA6        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA6'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0637'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA6ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA6
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA6          TCA6
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CHRG7 Validate Charge Code 7 & Amount 7                     *
      *                                                               *
      *****************************************************************
     C     V_CHRG7       BEGSR
      *
     C                   MOVEL     DDTCC7        TCC7
      *
      * Charge Code 7
      *    .. must be a valid code on SECGT
      *
     C     DDTCC7        IFNE      *BLANKS
     C                   MOVEL     DDTCC7        @C_CCOM
     C     KLSECGT       CHAIN     SECGT                              44
     C     *IN44         IFEQ      '1'
     C     CER049        ANDEQ     'N'                                                      AR941082
     C     *IN44         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     CER049        ANDEQ     'N'                                                      AR941082
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC7'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0638'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC7ok
     C                   END
     C                   END
      *
      * Charge Code 7
      *    .. MANDATORY IF AMOUNT ENTERED
      *
     C     DDTCA7        IFNE      *BLANKS
     C     DDTCC7        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCC7'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0639'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCC7ok
     C                   END
      *
      * Charge Amount 7
      *    .. if entered, must be a valid amount
      *
     C     DDTCA7        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTCA7        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTCA7'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0640'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTCA7ok
     C                   ELSE
     C                   MOVE      ZOUT15        TCA7
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TCA7          TCA7
     C                   END
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_TAXA Validate Tax Amount                                    *
      *                                                               *
      *****************************************************************
     C     V_TAXA        BEGSR
      *
      * Tax Amount
      *    no entry is allowed if counterparty has no tax code
      *
     C     CustTAXC      IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAXA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0641'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTAXAok
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTAXA        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTAXA'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0642'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTAXAok
     C                   ELSE
     C                   MOVE      ZOUT15        TAXA
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TAXA          TAXA
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_BROKCMR Validate Broker Commission Rebate                   *
      *                                                               *
      *****************************************************************
     C     V_BROKCMR     BEGSR
      *
      * Broker commission amount rebate
      *    .. prohibited if broker commission code blank
      *
     C     DDTBCC        IFEQ      *BLANKS
     C     TBCC_REBA     ORNE      'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCMR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0643'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddBCMRok
     C                   END
      *
      *   .. if entered, must be a valid amount
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDBCMR        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDBCMR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0644'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddBCMRok
     C                   ELSE
     C                   MOVE      ZOUT15        BCMR
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     BCMR          BCMR
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_CUSTCMR Validate Customer Commission Rebate                 *
      *                                                               *
      *****************************************************************
     C     V_CUSTCMR     BEGSR
      *
      * Customer commission amount rebate
      *    .. prohibited if customer commission code blank
      *
     C     DDTCCC        IFEQ      *BLANKS
     C     TCCC_REBA     ORNE      'Y'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCCMR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0645'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddCCMRok
     C                   END
      *
      *   .. if entered, must be a valid amount
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDCCMR        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCCMR'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0646'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddCCMRok
     C                   ELSE
     C                   MOVE      ZOUT15        CCMR
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     CCMR          CCMR
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_TAXREB Validate Tax Rebate                                  *
      *                                                               *
      *****************************************************************
     C     V_TAXREB      BEGSR
      *
      * Tax Rebate
      *    no entry is allowed if counterparty has no tax code
      *
     C     CustTAXC      IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXRB'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0647'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTXRBok
     C                   END
      *
      *    .. if entered, must be a valid amount
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     DDTXRB        ZFLD17
     C                   EXSR      ZASIGN
     C     ZAsignOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDTXRB'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0648'     MsgidXAr(Idx)
     C                   MOVE      'N'           ddTXRBok
     C                   ELSE
     C                   MOVE      ZOUT15        TXRB
     C     ZFSIGN        IFEQ      '-'
     C                   Z-SUB     TXRB          TXRB
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ADJCHGSGN Adjust sign of charge amounts                      *
      *                                                               *
      *****************************************************************
      *
     C     ADJCHGSGN     BEGSR
      *
      * Dependent upon type of client and trade
      *
     C     CustClass     IFEQ      'M'
     C     DDTDTP        ANDEQ     'TS'
     C     CustClass     OREQ      'S'
     C     DDTDTP        ANDEQ     'TP'
     C     CustClass     OREQ      'D'
     C     DDTDTP        ANDEQ     'TP'
     C                   Z-SUB     TBCA          TBCA
     C                   Z-SUB     TCCA          TCCA
     C                   Z-SUB     TCA1          TCA1
     C                   Z-SUB     TCA2          TCA2
     C                   Z-SUB     TCA3          TCA3
     C                   Z-SUB     TCA4          TCA4
     C                   Z-SUB     TCA5          TCA5
     C                   Z-SUB     TCA6          TCA6
     C                   Z-SUB     TCA7          TCA7
     C                   Z-SUB     TAXA          TAXA
     C                   Z-SUB     BCMR          BCMR
     C                   Z-SUB     CCMR          CCMR
     C                   Z-SUB     TXRB          TXRB
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * V_PTFR Validate Portfolio Reference                           *
      *                                                               *
      *****************************************************************
     C     V_PTFR        BEGSR
 
     C                   MOVE      CustNum       PNCNUM
      *
      *  If portfolio is ICD 'non' portfolio,
      *  portfolio currency is customer base currency
      *
     C     DDPTFR        IFEQ      FCR997
     C     *BLANK        ANDNE     FCR997
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      CustPMCSBY    PNPTCY
     C                   Z-ADD     CustPMBYDP    PNPCDP
      *
      *  Else, check that portfolio is valid
      *
     C                   ELSE
      *                                                                         CPB001
      *  Default portfolio reference if this one is blank                       CPB001
      *                                                                         CPB001
     C     DDPTFR        IFEQ      *BLANKS                                      CPB001
     C     PNCNUM        SETLL     PMPORTLL                                     CPB001
     C     PNCNUM        READE     PMPORTLL                               44    CPB001
     C     *IN44         IFEQ      *OFF                                         CPB001
     C                   MOVEL     PNPTFR        DDPTFR                         CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
                                                                                CPB001
     C     PORTKY        CHAIN     PMPORTPD                           44
     C  N44PNRECI        COMP      'D'                                4444
      *
      *  Error if portfolio not found or not live
      *
     C     *IN44         IFEQ      '1'                                          B3
     C                   ADD       1             Idx
     C                   MOVEL     'DDPTFR'      FldNamXAr(Idx)
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     'MMA1111'     MsgidXAr(Idx)                  CPB001
     C                   ELSE                                                   CPB001
     C                   MOVEL     'MMA0649'     MsgidXAr(Idx)
     C                   ENDIF                                                  CPB001
     C                   MOVE      'N'           ddPTFRok
     C                   GOTO      EV_PTFR
     C                   END                                                    E3
      *
      *  Warning error if portfolio is flagged for closure
      *
     C     PNDPCL        IFGT      0                                            B4
     C                   ADD       1             WIx
     C                   MOVEL     'DDPTFR'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0651'     WMsgidXAr(WIx)
     C                   MOVE      'W'           ddPTFRok
     C                   END                                                    E4
     C                   END                                                    E2
 
      * Update file portfolio reference and portfolio details
 
     C     ddPTFRok      IFNE      'N'
     C     DDPTFR        IFEQ      FCR997
     C     *BLANK        ANDNE     FCR997
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        PTFR
     C                   ELSE
     C                   MOVE      DDPTFR        PTFR
     C                   END
     C                   MOVEL     PNCNUM        PortCust
     C                   MOVEL     DDPTFR        PortRef
     C                   MOVEL     PNPTCY        PortCcy
     C                   MOVEL     PNPCDP        PortDecp
     C                   END
 
     C     EV_PTFR       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * C_PTFRXR Calculate Portfolio Cross Rate                       *
      *                                                               *
      *****************************************************************
     C     C_PTFRXR      BEGSR
 
     C                   CALLB     'SETPTXRCAL'
 
      * INPUTS
 
      ** Trade details
      *  Settlement Currency
      *  Trade date
     C                   PARM                    DDSETC            3
     C                   PARM                    TDDT              5 0
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** Run date
     C                   PARM                    BJRDNB            5 0
 
      * OUTPUTS
 
      * Trade portfolio exchange rate
      * Trade portfolio exchange rate M/D ind
      * Trade portfolio exchange rate in screen format
      * Trade portfolio exchange rate M/D ind in screen format
     C                   PARM      *ZERO         SPXR             13 8
     C                   PARM      *BLANK        SPMD              1
     C                   PARM      *BLANK        DDSPXR           14
     C                   PARM      *BLANK        DDSPMD            1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZASIGN - Validate & Right Align a Signed Numeric Field        *
      *                                                               *
      *****************************************************************
     C     ZASIGN        BEGSR
 
     C     13            SUB       NomCcyDec     ZSDIG
     C                   Z-ADD     NomCcyDec     ZSDEC
 
     C                   CALLB     'ZASIGN'
     C                   PARM                    ZASIGNok          1
     C                   PARM                    ZFLD17           17
     C                   PARM                    ZSDIG             2 0
     C                   PARM                    ZSDEC             1 0
     C                   PARM                    ZSDCSP            1            156689
     C                   PARM                    ZOUT15           15
     C                   PARM                    ZFSIGN            1
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Trade details
      ** Trade Type
      ** Settlement Currency
      ** Trade date
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    TDDT              5 0
      *
      ** Trade Charges & Commissions
     C                   PARM                    TrChCm
      *
      ** Nominal Currency Details
     C                   PARM                    NMCY              3
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** ICD
      ** Run date
      ** PM installed
      ** Autocharge Option
      ** Bank Portfolios installed
      ** 9997 Portfolios
      ** PB installed                                                           CPB001
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BGPFMG            1
     C                   PARM                    BVACOP            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BGN4ST            1            CPB001
 
      * OUTPUTS
 
      * Broker commission
      * Customer commission
      * Charges 1 - 7
      * Tax
      * Broker commission rebate
      * Customer commission rebate
      * Tax on rebate
      * Portfolio ref
      * Portfolio exchange rate & M/D ind
     C                   PARM                    TBCC              2
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCC              2
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCC1              2
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCC2              2
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCC3              2
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCC4              2
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCC5              2
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCC6              2
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCC7              2
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    BCMR             13 0
     C                   PARM                    CCMR             13 0
     C                   PARM                    TXRB             13 0
     C                   PARM                    PTFR              4
     C                   PARM                    SPXR             13 8
     C                   PARM                    SPMD              1
      *
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      ** Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
 
     C     KLSECGT       KLIST
     C                   KFLD                    @C_CCY            3
     C                   KFLD                    @C_CCOM           2
 
     C     PORTKY        KLIST                                                                 S0148
     C                   KFLD                    PNCNUM                                        S0148
     C                   KFLD                    DDPTFR                                        S0148
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Check if switchable feature CER049 is on.                                          AR941082
                                                                                            AR941082
     C                   CALL      'AOSARDR0'                                               AR941082
     C                   PARM      *BLANKS       PRTCD                                      AR941082
     C                   PARM      '*VERIFY'     POPTN                                      AR941082
     C                   PARM      'CER049'      PSARD                                      AR941082
                                                                                            AR941082
      ** Check for Database error                                                           AR941082
                                                                                            AR941082
     C                   IF        PRTCD <> *BLANKS AND                                     AR941082
     C                             PRTCD <> '*NRF   '                                       AR941082
     C                   EVAL      DBKEY  = 'CER049'                                        AR941082
     C                   EVAL      DBFILE = 'SCSARDPD'                                      AR941082
     C                   EVAL      DBASE  = 1                                               AR941082
     C                   EXSR      *PSSR                                                    AR941082
     C                   ENDIF                                                              AR941082
                                                                                            AR941082
     C                   IF        PRTCD = *BLANKS                                          AR941082
     C                   EVAL      CER049 = 'Y'                                             AR941082
     C                   ELSE                                                               AR941082
     C                   EVAL      CER049 = 'N'                                             AR941082
     C                   ENDIF                                                              AR941082
                                                                                            AR941082
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
