     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC amend function')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCCAMD - OTC Amend Checking                               *
      *                                                               *
      *  Function:  This module compares the fields of an amended     *
      *             transaction against those currently on file.      *
      *             It checks whether all fields amended (including   *
      *             settlement fields), are amendable and if not      *
      *             returns error messages to the calling process.    *
      *             It can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG6276            Date 18Mar05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  BUG6276- Unable to change settlement method to 05 with       *
      *           validation on settlement branch                     *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** New transaction in screen format
     D NewTranScn    E DS                  EXTNAME(FFOTCOPD)
 
     D CurTranScn    E DS                  EXTNAME(FFOTCOPD)
     D                                     PREFIX(@)
 
      ** Currrent transaction in file format
     D CurTranFil    E DS                  EXTNAME(TRANSD)
 
      ** External data Structure for transaction details OK flags
     D OKTransDet    E DS                  EXTNAME(FFEOTCOPD)
 
      ** New customer settlement details in screen format
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
 
      ** Current customer settlement details in screen format
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
     D                                     PREFIX(@)
 
      ** External data structure for customer settlement flags
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
 
      ** External DS for midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for portfolio management details
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Overall Transaction status, to be passed back to calling program
     D AmendOK         S              1A
 
      ** Field indicating whether number of contracts
      ** = number of open contracts (Y or N)
     D EqOpnCont       S              1A
 
      ** Whether reset of errors is required
     D ResetErrs       S              1A
 
      ** Flag for Enhanced OTCs feature and FF enhancement
     D CFF001          S              1A
     D CFF007          S              1A
 
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
 
      **  Initialise contracts field.
     C                   EXSR      OpnCtr
 
      **  Compare fields with amended values.
 
     C                   EXSR      CompFlds
 
      ** If any errors were found:
      ** Set Amendments OK Indicator to 'N'
 
     C                   IF        Idx > 0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      ** If any errors were found and reset of fields in error required,
      ** do this
 
     C                   IF        Idx > 0 and ResetErrs = 'Y'
     C                   EXSR      ResetFlds
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CompFlds  - Compare certain fields on the current transaction *
      *             with those amended.                               *
      *                                                               *
      *****************************************************************
     C     CompFlds      BEGSR
 
      *-----------------------------------------*
      * Instrument processing type              *
      *-----------------------------------------*
      ** This field is not amendable.
 
     C                   IF        NISPT <> @NISPT
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NISPT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0532'
     C                   EVAL      OKISPT          = 'N'
     C                   ENDIF
 
 
      *-----------------------------------------*
      * Purchase or Sale                        *
      *-----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NTRTY <> @NTRTY
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NTRTY'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM1049'
     C                   EVAL      OKTRTY          = 'N'
     C                   ENDIF
 
      *-----------------------------------------*
      * Number of Contracts                     *
      *-----------------------------------------*
      ** This field is amendable only if the number of contracts = the
      ** number of open contracts AND the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C                   IF        NNUCO <> @NNUCO
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NNUCO'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0535'
     C                   EVAL      OKNUCO          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      **----------------------------------------*
      ** O.T.C Type                             *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NISTT  <> @NISTT
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NISTT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0680'
     C                   EVAL      OKISTT         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Put/Call                               *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NPCAL  <> @NPCAL
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NPCAL'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0540'
     C                   EVAL      OKPCAL         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Strike Price                           *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NSTRP  <> @NSTRP
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NSTRP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0541'
     C                   EVAL      OKSTRP          = 'N'
     C                   ENDIF
 
      **--------------------------------------------*
      ** Style - American/European Option indicator *
      **--------------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NAEIN  <> @NAEIN
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NAEIN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0681'
     C                   EVAL      OKAEIN         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Portfolio Reference                    *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NPTFR  <> @NPTFR
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NPTFR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0542'
     C                   EVAL      OKPTFR         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Contingent (delivery) amount           *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NCTAM  <> @NCTAM
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NCTAM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0682'
     C                   EVAL      OKCTAM          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Delivery Currency                      *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NDCCY  <> @NDCCY
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NDCCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0683'
     C                   EVAL      OKDCCY          = 'N'
     C                   ENDIF
 
      *-----------------------------------------*
      * Contract Price                          *
      *-----------------------------------------*
      ** This field is amendable only if the number of contracts = the
      ** number of open contracts AND the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C                   IF        NCOPR  <> @NCOPR
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NCOPR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0543'
     C                   EVAL      OKCOPR          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      **----------------------------------------*
      ** Premium Currency                       *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NISCY  <> @NISCY
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NISCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0686'
     C                   EVAL      OKISCY          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Premium Up Front                       *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NPUPF  <> @NPUPF
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NPUPF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0687'
     C                   EVAL      OKPUPF          = 'N'
     C                   ENDIF
 
      *-----------------------------------------*
      * Transaction Date                        *
      *-----------------------------------------*
      ** This field is amendable only if the number of contracts = the
      ** number of open contracts AND the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C                   IF        NTRSD  <> @NTRSD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NTRSD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0544'
     C                   EVAL      OKTRSD          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      *-----------------------------------------*
      * Value Date                              *
      *-----------------------------------------*
      ** This field is amendable only if the number of contracts = the
      ** number of open contracts AND the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        CFF001 = 'Y' and CFF007 = 'Y'
 
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C                   IF        NVALD  <> @NVALD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NVALD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0689'
     C                   EVAL      OKVALD          = 'N'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **----------------------------------------*
      ** Expiry Date                            *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NFTDT  <> @NFTDT
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NFTDT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0690'
     C                   EVAL      OKFTDT          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Expiry Time                            *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NFTTM  <> @NFTTM
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NFTTM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0691'
     C                   EVAL      OKFTTM          = 'N'
     C                   ENDIF
 
      *-----------------------------------------*
      * Customer                                *
      *-----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NCUSC  <> @NCUSC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NCUSC '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0387'
     C                   EVAL      OKCUSC         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Book Code                              *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NBOKC <> @NBOKC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NBOKC '
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0060'
     C                   EVAL      OKBOKC         = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Booking Branch                         *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NBRCD <> @NBRCD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NBRCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0063'
     C                   EVAL      OKBRCD          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Originating Branch                     *
      **----------------------------------------*
      ** Only validate this field if Originating Branch ICD flag on.
 
     C                   IF        BGMBIN = 'N'  or
     C                             BKOBRU = 'N'
 
      ** This field is not amendable unless MULTI-BRANCHING
      ** indicator is on.
 
     C                   IF        NORBR <> @NORBR
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NORBR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0548'
     C                   EVAL      OKORBR          = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      **----------------------------------------*
      ** Settlement Date                        *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NSETD <> @NSETD
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NSETD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0678'
     C                   EVAL      OKSETD          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Commodity Reference                    *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NCMRF <> @NCMRF
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NCMRF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0692'
     C                   EVAL      OKCMRF          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Tick Value                             *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NTKVL <> @NTKVL
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NTKVL'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA1225'
     C                   EVAL      OKTKVL          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Minimum Price                          *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NMNPF <> @NMNPF
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMNPF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA1226'
     C                   EVAL      OKMNPF          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Profit Centre                          *
      **----------------------------------------*
      ** Only validate this field if Profit Centre ICD flag on.
 
     C                   IF        BKPRCU = 'Y'
 
      ** This field is not amendable unless 'Profit Centre Amendable'
      ** ICD flag is on.
 
     C                   IF        NPRFC <> @NPRFC and BKPRCA <> 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      OKPRFC          = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      **----------------------------------------*
      ** PM Instrument Type                     *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NINNR <> @NINNR
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NINNR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0719'
     C                   EVAL      OKINNR          = 'N'
     C                   ENDIF
 
      **----------------------------------------*
      ** Transaction Position Profit Centre     *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        NTPRC <> @NTPRC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NTPRC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0711'
     C                   EVAL      OKTPRC          = 'N'
 
     C                   ENDIF
 
      ** Settlement Details
      ** ==================
 
      **----------------------------------------*
      ** Customer Commission Code               *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCCMC <> @SCCMC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCCMC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0557'
     C                   EVAL      OKCCMC          = 'N'
     C                   ENDIF
 
     C                   ENDIF
      **----------------------------------------*
      ** Customer Commission Code - Same Day    *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCCMS <> @SCCMS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCCMS'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0558'
     C                   EVAL      OKCCMS          = 'N'
     C                   ENDIF
 
     C                   ENDIF
      **----------------------------------------*
      ** Customer Commission Amount             *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCCMA <> @SCCMA
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCCMA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0559'
     C                   EVAL      OKCCMA          = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer Charge Code                   *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCCHC <> @SCCHC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCCHC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0560'
     C                   EVAL      OKCCHC          = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer Charge Amount                 *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCCHA <> @SCCHA
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCCHA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0561'
     C                   EVAL      OKCCHA          = 'N'
     C                   ENDIF
 
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer Settlement Type               *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCSLT <> @SCSLT
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCSLT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0563'
     C                   EVAL      OKCSLT          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer Settlement Branch             *
      **----------------------------------------*
      ** Only amend this field if MULTI-BRANCHING is on or
      ** if the End of Centre Processed indicator = 'n'.
 
     C*******************IF        ECPI <> 'N' or BGMBIN = 'Y'                               BUG6276
     C                   IF        ECPI <> 'N' or BGMBIN <> 'Y'                              BUG6276
 
     C                   IF        SBRSC <> @SBRSC
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SBRSC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0564'
     C                   EVAL      OKBRSC          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer Settlement Account            *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCSLA <> @SCSLA
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCSLA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0565'
     C                   EVAL      OKCSLA          = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      **----------------------------------------*
      ** Customer Counterparty Nostro           *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCCPN <> @SCCPN
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCCPN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0566'
     C                   EVAL      OKCCPN          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer For the Account Of            *
      **----------------------------------------*
      ** Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        ECPI <> 'N'
 
     C                   IF        SCFAO <> @SCFAO
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'SCFAO'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0567'
     C                   EVAL      OKCFAO          = 'N'
     C                   ENDIF
     C                   ENDIF
 
      *-----------------------------------------------------------------*
      * The following fields are currently UNCONDITIONALLY AMENDABLE    *
      * so no checking is done here.                                    *
      *-----------------------------------------------------------------*
 
      ** NLNKR  - Linked Reference Number
      ** NTNAR  - Narrative
      ** NTBLO  - To be left open
      ** NBPRC  - Book Positions Profit Centre
 
      ** All fields in the Midas Plato screen is amendable
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETFLDS - Reset fields in Error                             *
      *                                                               *
      *****************************************************************
 
     C     ResetFlds     BEGSR
 
      ** Reset fields in error to 'current' values
 
     C                   IF        AmendOK = 'N'
     C                   EVAL      NewCuStScn = CurCuStScn
     C                   EVAL      NewTranScn = CurTranScn
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OpnCtr  - routine which sets on a flag if the number of       *
      *           contracts is equal to the number of open contracts. *
      *           It is used to ascertain whether the following       *
      *           fields may be amended: contract price, transaction  *
      *           date and number of contracts.                       *
      *                                                               *
      *****************************************************************
 
     C     OpnCtr        BEGSR
 
      ** If 'No. of Contracts' = 'No. of Open Contracts'
      ** (for Customer, + Broker if involved      )
 
     C                   IF        NUCO = NOCO
 
     C**********         IF        BOCO = *ZERO                                               CSD027
     C                   IF        BOCO = *BLANK                                              CSD027
     C                   EVAL      EqOpnCont='Y'
     C                   ELSE
     C
     C                   IF        NUCO = NOBO
     C                   EVAL      EqOpnCont='Y'
     C                   ENDIF
     C
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        ReturnCode
 
      ** New transaction in Screen Format
      ** New Customer Settlement deatils in screen format
      ** Current transaction in Screen Format
      ** Current Customer Settlement Details in Screen Format
      ** Reset of Fields in Error Required (Y/N)
 
     C                   PARM                    NewTranScn
     C                   PARM                    NewCuStScn
     C                   PARM                    CurTranScn
     C                   PARM                    CurCuStScn
     C                   PARM                    ResetErrs
 
      ** Current transaction in file format
 
     C                   PARM                    CurTranFil
 
      ** Standing Data ICD
      ** =================
 
      ** SDBANKPD
      ** Midas modules
      ** General Ledger ICD
 
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
 
      ** Switchable feature
      ** ==================
 
      ** O.T.C. instrument switchable field
      ** Futures and Option Enhancement
      ** Portfolio Management Details
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
     C                   PARM                    SDPORT
 
      ** Output Parameters
      ** =================
      ** Transaction Details OK flags(DS) from/to caller
      ** Customer Settlement OK flags(DS) from/to caller
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    OKTransDet
     C                   PARM                    OKCustSet
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Amendments OK
 
     C                   PARM                    AmendOk
 
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
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
