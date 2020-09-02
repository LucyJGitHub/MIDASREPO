     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual repayment convert display amounts')    *
      *****************************************************************
      *                                                               *
      *  Midas - Module name ILE Module                               *
      *                                                               *
      *  LEMAPYCVA - LE Manual repayment convert display amounts      *
      *                                                               *
      *  Function: This Program converts certain Manual repayments    *
      *            fields between loan and facility currency for      *
      *            display.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249232             Date 18Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244955             Date 12Jan07               *
      *                 244552             Date 19Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 BUG9754            Date 03Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106 *Create     Date 01Aug04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Anunalised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249232   Recompile over changes LEMAP2PD. Reinstate 244552.  *
      *  244955   Recompile over changes LEMAP2PD. Reverse 244552.    *
      *  244552 - Recompile over changes LEMAP2PD.                    *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG9754 - Recompiled due to changes in LEMAP2PD.             *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      ** Midas LE Facility Details file
     FFCLTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     Include(FCLTYFMF)
     F                                     Prefix(FC_)
 
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D TranInMAPY    E DS                  EXTNAME(LEMAPYPD)
     D TranInMAP2    E DS                  EXTNAME(LEMAP2PD)
     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK) Prefix(Loam)
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(WrkLn)
     D NwMaPyFilFmt  E DS                  EXTNAME(LEVMAPYPD)
 
      ** Error indicators
     D OKTrMAPY      E DS                  EXTNAME(LEEMAPYPD)
 
      ** Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D  ZOUT22         DS            22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
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
 
     D*KCNUM****       S              6  0                                                   CSD027A
     D KCNUM           S              6A                                                     CSD027A
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
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      ** Retrieve Loan Currency details
 
     C                   CLEAR                   SDCURR
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WrkLnCCY      PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      LnNBDP = A6NBDP
     C                   EVAL      LnMDIN = A6MDIN
     C                   EVAL      WrkSPRT = A6SPRT
 
     C                   IF        DDACTN = 'E'
     C                   EXSR      SRFmtRead
     C                   ELSE
     C                   EXSR      SRFmtVal
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtRead - Format the data from file to screen               *
      *****************************************************************
     C     SRFmtRead     BEGSR
 
      ** Convert the outstanding principal and interest
 
     C                   EXSR      SRConvFCCY
 
      ** If Facility Currency field is not blank then the transaction
      ** retrieved was previously entered using Facility Currency...
      ** Convert these fields and display as transaction data instead.
      ** Also move the data in terms of loan currency to other more
      ** descriptive fields.
 
      ** Move details in loan currency
 
     C                   IF        LoamFRCY <> *Blanks
 
     C                   EVAL      DDLCCY = DDSCCY
 
     C                   IF        DDPSIG = '-'
     C                   EVAL      DDLCPR = DDRPRI + DDPSIG
     C                   ELSE
     C                   EVAL      DDLCPR = DDRPRI
     C                   ENDIF
 
     C                   IF        DDISIG = '-'
     C                   EVAL      DDLCIA = DDRINT + DDISIG
     C                   ELSE
     C                   EVAL      DDLCIA = DDRINT
     C                   ENDIF
 
     C                   IF        DDRSIG = '-'
     C                   EVAL      DDLCTA = DDRTOT + DDRSIG
     C                   ELSE
     C                   EVAL      DDLCTA = DDRTOT
     C                   ENDIF
 
     C                   IF        DDRPIG = '-'
     C                   EVAL      DDLCPN = DDRPEN + DDRPIG
     C                   ELSE
     C                   EVAL      DDLCPN = DDRPEN
     C                   ENDIF
 
      ** Format Facility Currency details to transaction details
 
     C                   EVAL      DDSCCY = LoamFRCY
 
     C                   EVAL      ZECODE = 'J'
     C                   EVAL      ZDECS = FcNBDP
 
     C                   IF        LoamFRAM < 0
     C                   EVAL      DDPSIG = '-'
     C                   Z-SUB     LoamFRAM      ZFLD15
     C                   ELSE
     C                   EVAL      DDPSIG = *Blank
     C                   Z-ADD     LoamFRAM      ZFLD15
     C                   ENDIF
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT20        DDRPRI
 
     C                   IF        LoamFINT < 0
     C                   EVAL      DDISIG = '-'
     C                   Z-SUB     LoamFINT      ZFLD15
     C                   ELSE
     C                   EVAL      DDISIG = *Blank
     C                   Z-ADD     LoamFINT      ZFLD15
     C                   ENDIF
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT20        DDRINT
 
     C                   IF        LoamFTOT < 0
     C                   EVAL      DDRSIG = '-'
     C                   Z-SUB     LoamFTOT      ZFLD15
     C                   ELSE
     C                   EVAL      DDRSIG = *Blank
     C                   Z-ADD     LoamFTOT      ZFLD15
     C                   ENDIF
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT20        DDRTOT
 
     C                   IF        LoamFPEN < 0
     C                   EVAL      DDRPIG = '-'
     C                   Z-SUB     LoamFPEN      ZFLD15
     C                   ELSE
     C                   EVAL      DDRPIG = *Blank
     C                   Z-ADD     LoamFPEN      ZFLD15
     C                   ENDIF
     C                   EXSR      ZFRPED
     C                   MOVE      ZOUT20        DDRPEN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFmtVal - Format the amounts for writing to file.            *
      *****************************************************************
     C     SRFmtVal      BEGSR
 
     C                   IF        DDACTN <> 'I' And MRFRCY <> *Blanks
     C                   EVAL      DDSCCY = MRFRCY
     C                   ENDIF
 
      ** Convert amounts only if loan is valid
 
     C                   IF        DDLNRFOK <> 'N'
 
     C                   EXSR      SRConvFCCY
 
      ** Format the Loan Currency amount fields for output
      ** if Facility Currency is used
 
     C                   IF        DDSCCY = FC_FCCY And FC_FCCY <> WrkLnCCY
     C                   EXSR      SRConvLCCY
     C                   ELSE
     C                   EVAL      DDLCCY = *Blanks
     C                   ENDIF
 
     C                   ENDIF
 
      ** Error if field is neither Loan nor Facility Currency
 
     C                   IF        DDSCCY <> WrkLnCCY And DDSCCY <> FC_FCCY
     C                   EVAL      DDSCCYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDSCCY'
     C                   EVAL      MsgIdArr(Idx) = 'LEM0112'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRConvFCCY - Convert amounts to Facility Currency             *
      *****************************************************************
     C     SRConvFCCY    BEGSR
 
      ** Access Facility details
 
     C                   EVAL      KCNUM = WrkLnFCUS
     C                   EVAL      KFACT = WrkLnFTYP
     C                   EVAL      KFCNO = WrkLnFSEQ
 
     C     KEYLoanFac    CHAIN     FCLTY
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      FC_FCCY       PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   EVAL      FcNBDP = A6NBDP
     C                   EVAL      DDFCCY = FC_FCCY
 
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
 
     C                   IF        WrkLnFCXR <> *Zeros
     C                   EVAL      ZEXCH = WrkLnFCXR
     C                   ELSE
     C                   EVAL      ZEXCH = WSpotRate
     C                   ENDIF
 
     C                   EVAL      ZMD =  FcMDIN
 
      ** convert Principal Amount
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkLnCPAM     ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      WrkLnCCY      ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
      ** format Facility Currency Principal for display
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'J'
     C                   EXSR      ZFRPED
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        DDFCPR
     C                   ELSE
     C                   MOVE      ZOUT20        DDFCPR
     C                   ENDIF
 
      ** Convert Interest Amount
 
     C                   EVAL      ZADIG = 13 - LnNBDP
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok
     C                   PARM      DDINTD        ZFIELD
     C                   PARM      LnNBDP        ZADEC
     C                   PARM                    ZADIG
     C                   MOVE      ZFIELD        WrkNum13
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkNum13      ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      WrkLnCCY      ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
      ** format Facility Currency Outstanding Interest for display
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'J'
     C                   EXSR      ZFRPED
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        DDFCOI
     C                   ELSE
     C                   MOVE      ZOUT20        DDFCOI
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
 
     C                   IF        DDRPRIOK <> 'N' And DDPSIG <> 'N'
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok
     C                   PARM      DDRPRI        ZFIELD
     C                   PARM      LnNBDP        ZADEC
     C                   PARM                    ZADIG
     C                   MOVE      ZFIELD        WrkNum13
 
     C                   IF        DDPSIG = '-'
     C                   EVAL      WrkNum13 = WrkNum13 * (-1)
     C                   ENDIF
 
     C                   MOVE      WrkNum13      MRFRAM
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkNum13      ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      WrkLnCCY      ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   MOVE      ZAMTCO        MRPRAM
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'J'
     C                   EXSR      ZFRPED
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        DDLCPR
     C                   ELSE
     C                   MOVE      ZOUT20        DDLCPR
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      *Blanks       DDLCPR
     C                   ENDIF
 
      ** Convert Interest
 
     C                   IF        DDRINTOK <> 'N' And DDISIG <> 'N'
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok
     C                   PARM      DDRINT        ZFIELD
     C                   PARM      LnNBDP        ZADEC
     C                   PARM                    ZADIG
     C                   MOVE      ZFIELD        WrkNum13
 
     C                   IF        DDISIG = '-'
     C                   EVAL      WrkNum13 = WrkNum13 * (-1)
     C                   ENDIF
 
     C                   MOVE      WrkNum13      MRFINT
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkNum13      ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      WrkLnCCY      ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   MOVE      ZAMTCO        MRINTA
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'J'
     C                   EXSR      ZFRPED
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        DDLCIA
     C                   ELSE
     C                   MOVE      ZOUT20        DDLCIA
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      *Blanks       DDLCIA
     C                   ENDIF
 
      ** Convert Total
 
     C                   IF        DDRTOTOK <> 'N' And DDRSIG <> 'N'
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok
     C                   PARM      DDRTOT        ZFIELD
     C                   PARM      LnNBDP        ZADEC
     C                   PARM                    ZADIG
     C                   MOVE      ZFIELD        WrkNum13
 
     C                   IF        DDRSIG = '-'
     C                   EVAL      WrkNum13 = WrkNum13 * (-1)
     C                   ENDIF
 
     C                   MOVE      WrkNum13      MRFTOT
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkNum13      ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      WrkLnCCY      ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   MOVE      ZAMTCO        MRTAMT
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'J'
     C                   EXSR      ZFRPED
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        DDLCTA
     C                   ELSE
     C                   MOVE      ZOUT20        DDLCTA
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      *Blanks       DDLCTA
     C                   ENDIF
 
      ** Convert Penalty
 
     C                   IF        DDRPENOK <> 'N' And DDRPIG <> 'N'
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZALIGNok
     C                   PARM      DDRPEN        ZFIELD
     C                   PARM      LnNBDP        ZADEC
     C                   PARM                    ZADIG
     C                   MOVE      ZFIELD        WrkNum13
 
     C                   IF        DDRPIG = '-'
     C                   EVAL      WrkNum13 = WrkNum13 * (-1)
     C                   ENDIF
 
     C                   MOVE      WrkNum13      MRFPEN
 
     C                   CALLB     'ZCONVZ1'
     C                   PARM      WrkNum13      ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM      WrkLnCCY      ZCCYI
     C                   PARM      FC_FCCY       ZCCYO
     C                   PARM      LnNBDP        ZCDPI
     C                   PARM      FcNBDP        ZCDPO
     C                   PARM                    ZAMTCO
 
     C                   MOVE      ZAMTCO        MRPNAM
 
     C                   EVAL      ZFLD15 = ZAMTCO
     C                   EVAL      ZDECS = FcNBDP
     C                   EVAL      ZECODE = 'J'
     C                   EXSR      ZFRPED
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        DDLCPN
     C                   ELSE
     C                   MOVE      ZOUT20        DDLCPN
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      *Blanks       DDLCPN
     C                   ENDIF
 
     C                   EVAL      DDLCCY = WrkLnCCY
     C                   EVAL      MRCCY = WrkLnCCY
     C                   EVAL      MRFRCY = DDSCCY
 
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
     C                   PARM                    TraninMapy
     C                   PARM                    TraninMap2
     C                   PARM                    LoamFilFmt
     C                   PARM                    WrkLnDetails
     C                   PARM                    NwMaPyFilFmt
     C                   PARM                    OKTrMAPY
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** Access Bank details via access program
      ** (database error handling done in access program)
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      **  Key to retrieve Facilty loan Details
 
     C     KEYLoanFac    KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACT
     C                   KFLD                    KFCNO
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
