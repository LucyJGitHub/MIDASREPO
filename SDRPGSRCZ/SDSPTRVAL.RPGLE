     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate Details Validation')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRVAL - Spot rate details Validation                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23931           Date 11May09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8205            Date 23Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 240652             Date 27Jun06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 02Nov00               *
      *                 CAP057  *CREATE    Date 02Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23931 - Int earned upto threshold figure incorrect on CCY *
      *  CER048 - German Features - Taxes                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  240652 - If CEU002 is ON, the multiply/divide indicator on   *
      *           screen for 'Out' ccy is Out/Euro m/d indicator.     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  204923 - Rate Fix Days Adjustment (OIS) - (Recompile)        *
      *  CSD006 - Market Data Feed                                    *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSPTRV001
 
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
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDSPTRPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDESPTRPD)
 
      ** External DS for Dealing Details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
 
      ** Data structure for general ledger
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD1       E                     EXTFLD(QQACCD)                                     CGL029
 
      **  Externally described DS for Currency Access Object
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     D ValidSPTR     E DS                  EXTNAME(SDVSPTRPD)
      * Valid Transaction Details layout
     D  QQSPAE1      E                     EXTFLD(QQSPAE)                                     CGL029
     D  QQFTAE1      E                     EXTFLD(QQFTAE)                                     CGL029
     D  QQSWAE1      E                     EXTFLD(QQSWAE)                                     CGL029
     D  QQTAC41      E                     EXTFLD(QQTAC4)                                     CGL029
     D  QQTAC51      E                     EXTFLD(QQTAC5)                                     CGL029
     D  QQCSCD1      E                     EXTFLD(QQCSCD)                                     CGL029
      *                                                                                       CER048
      ** Data Structure for AOSARDR0                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Use working variables as some validations change value of
      ** AVSPRT
     D PrvSPRT         S                   LIKE(AVSPRT)
     D NewSPRT         S                   LIKE(AVSPRT)
     D CER048          S              1A                                                      CER048
     D WTaxMPnt        S              9P 7                                                    CER048
     D CGL165          S              1A                                                      CGL165
     D W0SPRTOK        S              1A                                                      CGL165
     D WTaxCRat        S             13P 8                                                    CGL165
      *                                                                                       CER048
      ** Parameters to the AOSARDR0 call                                                      CER048
      *                                                                                       CER048
     D PRtcd           S              7A                                                      CER048
     D POptn           S              7A                                                      CER048
     D PSard           S              6A                                                      CER048
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSPTRV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDSPTRV003
 
      ** Initialise program
     C                   EXSR      INIPGM
      *
      ** Validate Spot Rate
      *
      /COPY WNCPYSRC,SDSPTRV004
     C                   EXSR      VCSPRT
      /COPY WNCPYSRC,SDSPTRV005
      *
 
 
      *
      ** Validate Multiply Divide Indicator
      *
      /COPY WNCPYSRC,SDSPTRV006
     C                   EXSR      VCMDIN
      /COPY WNCPYSRC,SDSPTRV007
      *
 
      *
      ** Validate Time Stamp
      *
      /COPY WNCPYSRC,SDSPTRV008
     C                   EXSR      VCTMST
      /COPY WNCPYSRC,SDSPTRV009
 
      *
      ** Validate Base Limit Currency (Hidden)
      *
      /COPY WNCPYSRC,SDSPTRV010
     C                   EXSR      VCBLCY
      /COPY WNCPYSRC,SDSPTRV011
 
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
      ** Validate tax conversion rate margin points                                           CER048
      *                                                                                       CER048
     C                   EXSR      SRVTaxCMrPt                                                CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CGL165 = 'Y'                                               CGL165
      *                                                                                       CGL165
      ** Validate tax conversion rate                                                         CGL165
      *                                                                                       CGL165
     C                   EXSR      SRVTaxCRate                                                CGL165
     C                   ENDIF                                                                CGL165
      *                                                                                       CGL165
     C                   EXSR      CvtToFile
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSPTRV012
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** INIPGM Initialise Program
      *****************************************************************
     C     INIPGM        BEGSR
     C                   EVAL      #1INER = 0
     C                   EVAL      #1INMD = *BLANK
 
      ** Retrieve value of reciprocal flag for the currency
     C                   EXSR      GETRECIP
 
     C     CEU002        IFEQ      'Y'
      ** Some validation modules need to know the previous value of
      ** spot rate.
      ** Need to 'recalculate' the previous spot rate on file
      ** like it has been displayed on the screen before being changed
     C                   EXSR      FMEURT
     C                   ELSE
     C                   EVAL      SprtFrDEU = AVSPRT
     C                   EVAL      MdinFrDEU = AVMDIN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      ** CvtToFile Convert to file
      *****************************************************************
     C     CvtToFile     BEGSR
     C     *LIKE         DEFINE    NewSPRT       SpotRate
     C     *LIKE         DEFINE    DDMDIN        MultDiv
      ** Can be called only if no errors
     C                   IF        Idx = 0
     C                   CALLB     'SDSPTRDLC'
     C                   PARM                    RetCodeIn
     C                   PARM                    CcyLim
     C                   PARM                    DDCYCD
     C                   PARM                    DDMDIN
     C                   PARM                    DDSPRT
     C                   PARM                    #1ERLC
     C                   ENDIF
      ** Can be called only if no errors
     C                   IF        Idx = 0
     C                   IF        CEU002 = 'N'
     C                   Z-ADD     AVINER        #1INER
     C                   MOVEL     AVINMD        #1INMD
     C                   ELSE
      ** Assume spot rate on screen is OUT/EUR.
      ** Recalculate it against base
     C                   CALLB     'SDSPTR3EU'
     C                   PARM                    RetCodeIn
     C                   PARM      NewSPRT       SpotRate
     C                   PARM      DDMDIN        MultDiv
     C                   PARM                    #1INER
     C                   PARM                    #1INMD
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      AVDFTS = NewMdfTmsp                          CSD006
     C                   EVAL      AVSPRT = NewSPRT
     C     Recip         IFNE      'Y'                                                        240652
     C                   EVAL      AVMDIN = DDMDIN
     C                   ENDIF                                                                240652
     C                   EVAL      AVDTFR = DDDTFR
 
     C                   Z-ADD     #1ERLC        AVERLC
     C     Recip         IFEQ      'Y'
     C                   Z-ADD     AVSPRT        AVINER
     C**********         MOVEL     AVMDIN        AVINMD                                       240652
     C                   MOVEL     DDMDIN        AVINMD                                       240652
     C                   Z-ADD     #1INER        AVSPRT
      *                                                                                       240652
      ** Do not change multiply/divide indicator for 'Out' ccy'                               240652
      *                                                                                       240652
     C**********         MOVEL     #1INMD        AVMDIN                                       240652
     C                   ENDIF
 
      * Ensure that Cons. Euro is maintained at Euro rate
     C     DDCYCD        IFEQ      BKEURO
     C                   Z-ADD     AVSPRT        WEUSPR
     C                   MOVEL     AVMDIN        WEUMDI
     C                   ENDIF
     C     DDCYCD        IFEQ      BKEUCP
     C                   Z-ADD     WEUSPR        AVSPRT
     C                   MOVEL     WEUMDI        AVMDIN
     C                   ENDIF
 
      *                                                                                       CER048
      ** Move tax conversion rate margin points to valid file if 'OK'                         CER048
      *                                                                                       CER048
     C                   IF        (CER048 = 'Y') AND                                         CER048
     C                             (DDTCMPOK = 'Y')                                           CER048
     C                   EVAL      AVTCMP = WTaxMPnt                                          CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      *                                                                                       CER048
      ** Move tax conversion rate to valid file if 'OK'                                       CGL165
      *                                                                                       CGL165
     C                   IF        (CGL165 = 'Y') AND                                         CGL165
     C                             (DDTXCROK = 'Y')                                           CGL165
     C                   EVAL      AVTXCR = WTaxCRat                                          CGL165
     C                   ENDIF                                                                CGL165
      *                                                                                       CGL165
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSPRT Validate spot rate
      *****************************************************************
     C     VCSPRT        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Spot Rate
      *
     C                   CALLB     'SDVSPRT'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDDTFR
     C                   PARM                    DDCYCD
     C                   PARM                    DDSPRT
     C                   PARM      SprtFrDEU     PrvSPRT
     C                   PARM                    DDMDIN
     C                   PARM      MdinFrDEU     PrvMDIN
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDSPRTOK
     C                   PARM                    AVTLEX
     C                   PARM                    NewSPRT
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
      * Save the Spot Rate flag for CGL165 processing
     C                   IF        CGL165 = 'Y'
     C                   EVAL      W0SPRTOK = DDSPRTOK
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCMDIN : validate multiply divide indicator
      *****************************************************************
     C     VCMDIN        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Multiply Divide indicator
      *
     C                   CALLB     'SDVMDIN'
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDMDIN
     C                   PARM      MdinFrDEU     PrvMDIN
     C                   PARM                    DDCYCD
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDMDINOK
      *
      ** Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                    CSD006
      *****************************************************************         CSD006
      ** VCTMST Validate time stamp                                             CSD006
      *****************************************************************         CSD006
     C     VCTMST        BEGSR                                                  CSD006
                                                                                CSD006
      * Reset variables updated by validation                                   CSD006
                                                                                CSD006
     C                   EXSR      RESETERRS                                    CSD006
      *                                                                         CSD006
      ** Validate Time Stamp                                                    CSD006
      *                                                                         CSD006
     C                   CALLB     'SEVPRTM01'                                  CSD006
     C                   PARM      *BLANK        RetCodeIn                      CSD006
     C                   PARM                    DDDFTS                         CSD006
     C                   PARM                    DDDTFR                         CSD006
     C                   PARM                    FldNamXAr                      CSD006
     C                   PARM                    MsgIdXar                       CSD006
     C                   PARM                    MsgDtaXAr                      CSD006
     C                   PARM                    DDDTFROK          1            CSD006
     C                   PARM                    DDDFTSOK                       CSD006
     C                   PARM                    NewMdfTmsp       14 0          CSD006
      *                                                                         CSD006
      ** Update error info with that returned from the validation module        CSD006
                                                                                CSD006
     C                   EXSR      UPDATERRS                                    CSD006
      *                                                                         CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCBLCY Validate Base Limit Currency
      *****************************************************************
     C     VCBLCY        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Base Limit Currency
      *
     C                   CALLB     'SDVBLCY'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCYCD
     C                   PARM                    CcyLim
     C                   PARM                    DDSPRT
     C                   PARM      SprtFrDEU     PrvSPRT
     C                   PARM                    DDMDIN
     C                   PARM      MdinFrDEU     PrvMDIN
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSPRTOK
     C                   PARM      'N'           WUBCLC            1
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMEURT - FORMATING SPECIFIC TO EURO RATE
      *****************************************************************
     C     FMEURT        BEGSR
     C     *LIKE         DEFINE    AVSPRT        SprtFrDEU
     C     *LIKE         DEFINE    DDSPRT        SprtFrDEUA
     C     *LIKE         DEFINE    AVCYCD        PrvCycd
     C     *LIKE         DEFINE    AVMDIN        PrvMDIN
     C     *LIKE         DEFINE    AVINER        PrvIner
     C     *LIKE         DEFINE    AVINMD        PrvInmd
     C     *LIKE         DEFINE    AVDLCI        PrvDlci
     C     *LIKE         DEFINE    AVSWCY        PrvSwcy
     C     *LIKE         DEFINE    AVMDIN        MdinFrDEU
     C     *LIKE         DEFINE    AVMDIN        #SMDI2
     C     *LIKE         DEFINE    DDSPRT        #SPRA2
     C     *LIKE         DEFINE    DLSW          DLSW2
     C     *LIKE         DEFINE    DLSW          DDDLSW
     C     *LIKE         DEFINE    DLSW          DDDSW2
 
     C                   CALLB     'SDSPTRDEU'                          90
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM      AVCYCD        PrvCycd
     C                   PARM      AVMDIN        PrvMDIN
     C                   PARM      AVSPRT        PrvSPRT
     C                   PARM      AVINER        PrvIner
     C                   PARM      AVINMD        PrvInmd
     C                   PARM      AVDLCI        PrvDlci
     C                   PARM      AVSWCY        PrvSwcy
     C                   PARM      *BLANK        SprtFrDEUA
     C                   PARM      *BLANK        DLSW              6
     C                   PARM      *BLANK        MdinFrDEU
     C                   PARM      *BLANK        #SPRA2
     C                   PARM      *BLANK        DLSW2
     C                   PARM      *BLANK        #SMDI2
 
     C                   IF        RetCodeIn <> *BLANK OR *IN90
     C                   MOVEL     'SDSPTRDEU'   DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     PrvCycd       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM      SprtFrDEUA    ZFIELD           16
     C                   PARM      8             ZADEC             1 0
     C                   PARM      5             ZADIG             2 0
     C                   IF        ZALIGNok = 'N'
     C                   MOVEL     'ZALIGN'      DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      ZFIELD        SprtFrDEU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Transaction Details
     C                   PARM                    TrnDets
 
      * OUTPUTS
 
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Transaction details layout (DS) from/to caller
      ** IS USED ALSO AS INPUT PARAMETER (MUST HOLD PREVIOUS RECORD)
     C                   PARM                    ValidSPTR
 
      *
     C     *LIKE         DEFINE    AVINER        #1INER
     C     *LIKE         DEFINE    AVINMD        #1INMD
     C     *LIKE         DEFINE    AVERLC        #1ERLC
     C     *LIKE         DEFINE    BNCYCD        CcyLim
     C     *LIKE         DEFINE    A6SPRT        WEUSPR                     6103
     C     *LIKE         DEFINE    A6MDIN        WEUMDI                     6103
     C     *LIKE         DEFINE    A6CYCD        @CYCD                      6103
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Retrieve base currency limit
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      *BLANK        @RTCD             7            B:Return code
     C                   PARM      '*FIRST'      @OPTN             7            I:Option
     C*****SDDEAL        PARM      *BLANK        DSFDY                          O:FormaT      CGL029
     C     SDDEAL        PARM      *BLANK        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      CcyLim = BNCYCD
 
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   ENDIF
 
      ** Access general ledger for Euro currency name
      *
     C     CEU002        IFEQ      'Y'
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Set up store of Euro rate details for a change of Cons. Euro
 
     C     CEU002        IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BKEURO        @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     A6SPRT        WEUSPR
     C                   MOVEL     A6MDIN        WEUMDI
     C                   ENDIF
      *                                                                                       CER048
      ** Check if the feature CER048 is installed                                             CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER048
     C                             (PRtcd <> '*NRF   ')                                       CER048
      *                                                                                       CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 909                                                CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
 
      *                                                                                       CGL165
      ** Check if the feature CGL165 is installed                                             CGL165
      *                                                                                       CGL165
     C                   CALLB     'AOSARDR0'                                                 CGL165
     C                   PARM      *BLANKS       PRtcd                                        CGL165
     C                   PARM      '*VERIFY'     POptn                                        CGL165
     C                   PARM      'CGL165'      PSard                                        CGL165
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL165
      *                                                                                       CGL165
     C                   IF        PRtcd = *BLANKS                                            CGL165
     C                   EVAL      CGL165 = 'Y'                                               CGL165
     C                   ELSE                                                                 CGL165
      *                                                                                       CGL165
     C                   EVAL      CGL165 = 'N'                                               CGL165
     C                   ENDIF                                                                CGL165
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSPTRV013
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GETRECIP - Retrieve Value of the Reciprocal Flag for Currency *
      *****************************************************************
     C     GETRECIP      BEGSR
 
     C                   CALLB     'SDSPTR1EU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCYCD
     C                   PARM                    Recip             1
 
     C                   IF        RetCodeIn <> *BLANK  OR *IN90
     C                   MOVEL     'SDSPTR1EU'   DBFILE
     C                   MOVEL     '907'         DBASE
     C                   MOVEL     DDCYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************                       CER048
      *                                                               *                       CER048
      *  SRVTaxCMrPt - Validate Tax Conversion Rate Margin Points     *                       CER048
      *                                                               *                       CER048
      *  Called by: Main                                              *                       CER048
      *                                                               *                       CER048
      *  Calls: RESETERRS, UPDATERRS                                  *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
      *                                                                                       CER048
     C     SRVTaxCMrPt   BEGSR                                                                CER048
      *                                                                                       CER048
      ** Reset variables updated by validation                                                CER048
      *                                                                                       CER048
     C                   EXSR      RESETERRS                                                  CER048
      *                                                                                       CER048
      ** Validate tax conversion rate margin points                                           CER048
      *                                                                                       CER048
     C                   CALLB     'SDVTCMP'                                                  CER048
      *                                                                                       CER048
      ** Inputs                                                                               CER048
      *                                                                                       CER048
     C                   PARM                    RetCodeIn                                    CER048
     C                   PARM                    DDCYCD                                     BUG23931
     C                   PARM                    DDTCMP                                       CER048
     C                   PARM                    DDMDIN                                       CER048
     C                   PARM                    DDSPRT                                       CER048
      *                                                                                       CER048
      ** Outputs                                                                              CER048
      *                                                                                       CER048
     C                   PARM                    WTaxMPnt                                     CER048
     C                   PARM                    FldNamXAr                                    CER048
     C                   PARM                    MsgIdXAr                                     CER048
     C                   PARM                    MsgDtaXAr                                    CER048
     C                   PARM                    WFldNmXAr                                  BUG23931
     C                   PARM                    WMsgIDXAr                                  BUG23931
     C                   PARM                    WMsgDtXAr                                  BUG23931
     C                   PARM                    DDTCMPOK                                     CER048
      *                                                                                       CER048
      ** Update error info with that returned from the validation                             CER048
      *                                                                                       CER048
     C                   EXSR      UPDATERRS                                                  CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *                                                                                       CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CGL165
      *                                                               *                       CGL165
      *  SRVTaxCRate - Validate Tax Conversion Rate                   *                       CGL165
      *                                                               *                       CGL165
      *  Called by: Main                                              *                       CGL165
      *                                                               *                       CGL165
      *  Calls: RESETERRS, UPDATERRS                                  *                       CGL165
      *                                                               *                       CGL165
      *****************************************************************                       CGL165
      *                                                                                       CGL165
     C     SRVTaxCRate   BEGSR                                                                CGL165
      *                                                                                       CGL165
      ** Reset variables updated by validation                                                CGL165
      *                                                                                       CGL165
     C                   EXSR      RESETERRS                                                  CGL165
      *                                                                                       CGL165
      ** Validate tax conversion rate                                                         CGL165
      *                                                                                       CGL165
     C                   CALLB     'SDVTXCR'                                                  CGL165
      *                                                                                       CGL165
      ** Inputs                                                                               CGL165
      *                                                                                       CGL165
     C                   PARM                    RetCodeIn                                    CGL165
     C                   PARM                    DDTXCR                                       CGL165
     C                   PARM                    DDSPRT                                       CGL165
     C                   PARM                    NewSPRT                                      CGL165
     C                   PARM                    W0SPRTOK                                     CGL165
      *                                                                                       CGL165
      ** Outputs                                                                              CGL165
      *                                                                                       CGL165
     C                   PARM                    WTaxCRat                                     CGL165
     C                   PARM                    FldNamXAr                                    CGL165
     C                   PARM                    MsgIdXAr                                     CGL165
     C                   PARM                    MsgDtaXAr                                    CGL165
     C                   PARM                    WFldNmXAr                                    CGL165
     C                   PARM                    WMsgIDXAr                                    CGL165
     C                   PARM                    WMsgDtXAr                                    CGL165
     C                   PARM                    DDTXCROK                                     CGL165
      *                                                                                       CGL165
      ** Update error info with that returned from the validation                             CGL165
      *                                                                                       CGL165
     C                   EXSR      UPDATERRS                                                  CGL165
      *                                                                                       CGL165
     C                   ENDSR                                                                CGL165
      *                                                                                       CGL165
      *****************************************************************                       CGL165
      /EJECT                                                                                  CGL165
      *****************************************************************                       CGL165
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SDSPTRVAL'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
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
(c) Finastra International Limited 2001
