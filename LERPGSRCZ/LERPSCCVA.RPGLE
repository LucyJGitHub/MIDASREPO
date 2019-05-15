     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayment Schedule convert display amount')   *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LERPSCCVA - LE Repayment Schedule cnvert display amount      *
      *                                                               *
      *  Function: This program converts certain the repayment        *
      *            amount to loan currency for display if input is    *
      *            in facility currency.                              *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE154             Date 02Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG10331           Date 08Feb06               *
      *                 CLE106 *Create     Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG10331 - Recompiled due to changes in LERPS2PD.            *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      ** Midas LE Facility Details file
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(FCLTYFMF)
     F                                     PREFIX(FC_)
 
      ** Midas LE Loan Details file
     FCLOAN     IF   E           K DISK
     F                                     PREFIX(CL_)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
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
 
     D TranInRPSC    E DS                  EXTNAME(LERPSCPD)
     D TranInRPS2    E DS                  EXTNAME(LERPS2PD)
     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK) Prefix(Loam)
     D NwRPSCFilFmt  E DS                  EXTNAME(LEVRPSCPD)
 
      ** Error indicators
     D OKTrRPSC      E DS                  EXTNAME(LEERPSCPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D  ZOUT22         DS            22
     D  ZOUT20                 1     20
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Access object parameters
     D  PRtcd          S              7
     D  POptn          S              7
     D  PCurr          S              3
 
      ** Parameters for ZFRPED
     D  ZFLD15         S             15  0
     D  ZDECS          S              1  0
     D  ZECODE         S              1
     D  ZOUT25         S             25
 
      ** Parameters for ZCONVZ1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13  8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0
 
      ** Parameters for ZALIGN
     D ZALIGNok        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
     D*KLNRF****       S              6  0                                                    CLE148
     D KLNRF           S              6                                                       CLE148
     D*KCNUM****       S              6  0                                                   CSD027A
     D KCNUM           S              6                                                      CSD027A
     D KFACT           S              3  0
     D KFCNO           S              2  0
 
     D LnMDIN          S              1
     D FcMDIN          S              1
     D LnNBDP          S              1  0
     D FcNBDP          S              1  0
     D WrkSPRT         S             13  8
     D WSpotRate       S             13  8
     D WrkNum13        S             13  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Retrieve Loan details
 
     C                   IF        DDLNRF <> *Blanks
     C                   MOVE      DDLNRF        KLNRF
     C     KLNRF         CHAIN     CLOAN
 
     C                   CLEAR                   SDCURR
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CL_CCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      LnNBDP = A6NBDP
     C                   EVAL      LnMDIN = A6MDIN
     C                   EVAL      WrkSPRT = A6SPRT
 
      ** Access Facility details
 
     C                   EVAL      KCNUM = CL_FCUS
     C                   EVAL      KFACT = CL_FTYP
     C                   EVAL      KFCNO = CL_FSEQ
 
     C     KEYLoanFac    CHAIN     FCLTY
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FC_FCCY       PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      FcNBDP = A6NBDP
 
      ** If facility currency is local currency use details of currency
 
     C                   IF        FC_FCCY = BJCYCD
     C                   EVAL      WSpotRate = WrkSPRT
     C                   EVAL      FcMDIN = LnMDIN
     C                   ELSE
 
      ** .. else compute for mult/div indicator and spot rate
 
     C                   IF        A6MDIN = 'M'
     C                   EVAL      FcMDIN = 'D'
     C                   ELSE
     C                   EVAL      FcMDIN = 'M'
     C                   ENDIF
 
     C                   IF        A6MDIN = 'M' And LnMDIN = 'M' Or
     C                             A6MDIN = 'D' And LnMDIN = 'D'
     C     A6SPRT        DIV(H)    WrkSPRT       WSpotRate
     C                   ELSE
     C     A6SPRT        MULT(H)   WrkSPRT       WSpotRate
     C                   ENDIF
     C                   ENDIF
 
      ** Setup details for conversion
 
     C                   IF        CL_FCXR <> *Zeros
     C                   EVAL      ZEXCH = CL_FCXR
     C                   ELSE
     C                   EVAL      ZEXCH = WSpotRate
     C                   ENDIF
 
     C                   IF        FcMDIN = 'D'
     C                   EVAL      ZMD = 'M'
     C                   ELSE
     C                   EVAL      ZMD = 'D'
     C                   ENDIF
 
      ** Format fields for display/writing
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      SRFmtRead
     C                   ELSE
     C                   EXSR      SRFmtVal
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtRead - Format the data from file to screen               *
      *****************************************************************
     C     SRFmtRead     BEGSR
 
      ** If Facility Currency field is not blank then the transaction
      ** retrieved was previously entered using Facility Currency...
      ** Convert these fields and display as transaction data instead.
      ** Also move the data in terms of loan currency to other more
      ** descriptive fields.
 
      ** Move details in loan currency
 
     C                   IF        LoamFRCY <> *Blanks
 
     C                   EVAL      DDLCCY = DDCURR
     C                   EVAL      DDLCPR = DDSAMT
 
      ** Format Facility Currency details to transaction details
 
     C                   EVAL      DDCURR = LoamFRCY
 
     C                   EVAL      ZECODE = 'J'
     C                   EVAL      ZDECS = FcNBDP
     C                   Z-ADD     LoamFRAM      ZFLD15
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT20        DDSAMT
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtVal - Format the amounts for writing to file.            *
      *****************************************************************
     C     SRFmtVal      BEGSR
 
     C                   IF        DDACTN <> 'I' And RPFRCY <> *Blanks
     C                   EVAL      DDCURR = RPFRCY
     C                   ENDIF
 
      ** Format the Loan Currency amount fields for output
      ** if Facility Currency is used
 
     C                   IF        DDCURR = FC_FCCY And FC_FCCY <> CL_CCY
     C                   EXSR      SRConvLCCY
     C                   ELSE
     C                   EVAL      DDLCCY = *Blanks
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRConvLCCY - Convert repayments to loan currency              *
      *****************************************************************
     C     SRConvLCCY    BEGSR
 
     C                   EVAL      ZADIG = 13 - LnNBDP
 
      ** Convert Principal
 
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok
     C                   PARM      DDSAMT        ZFIELD
     C                   PARM      LnNBDP        ZADEC
     C                   PARM                    ZADIG
     C                   MOVE      ZFIELD        WrkNum13
 
     C                   IF        ZALIGNOK = 'Y'
     C                   MOVE      WrkNum13      RPFRAM
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkNum13      ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      CL_CCY        ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'L'
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT20        DDLCPR
 
     C                   ELSE
     C                   MOVE      *Blanks       DDLCPR
     C                   ENDIF
 
     C                   EVAL      DDLCCY = CL_CCY
     C                   EVAL      RPFRCY = DDCURR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZFRPED - ZS Edit Amount                                       *
      *****************************************************************
     C     ZFRPED        BEGSR
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *Blanks       ZOUT22
     C                   PARM      *Blanks       ZOUT25
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Transaction information
     C                   PARM                    TraninRPSC
     C                   PARM                    TraninRPS2
     C                   PARM                    LoamFilFmt
     C                   PARM                    NwRpscFilFmt
     C                   PARM                    OKTrRPSC
 
      **  Key to retrieve Facilty loan Details
 
     C     KEYLoanFac    KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
