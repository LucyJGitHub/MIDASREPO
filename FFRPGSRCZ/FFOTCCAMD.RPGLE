     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC amend function')
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
      *                 CAP084             Date 23Mar03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002             Date 14Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007             Date 13Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 25Oct99               *
      * Midas DBA 3.01 Patch E ---------------------------------------*
      *                 170520             Date 19Nov99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jul98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  CAS002 - Hedge Strategy/Linkage (Recompile)                  *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *  CPB001 - 'Private Banking' Module                            *
      *  170520 - Recompile over changed TRANSD file                  *
      *  CPL002 - Midas-Plato Interface (Recomipled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of FF inputs into modular structure to   *
      *           use as APIs.                                        *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
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
 
 
     D NewTranScn    E DS                  EXTNAME(FFOTCCPD)
      * NEW TRANSACTION IN SCREEN FORMAT
 
     D CurTranScn    E DS                  EXTNAME(FFOTCCPD)
     D                                     PREFIX(@)
      * CURRENT TRANSACTION IN SCREEN FORMAT
 
     D CurTranFil    E DS                  EXTNAME(TRANSD)
      * CURRENT TRANSACTION IN FILE FORMAT
 
 
     D OKTransDet    E DS                  EXTNAME(FFEOTCCPD)
      ** EXTERNAL DATA STRUCTURE FOR TRANSACTION DETAILS OK FLAGS
 
     D NewCuStScn    E DS                  EXTNAME(FFCSETPD)
      ** NEW CUSTOMER SETTLEMENT DETAILS IN SCREEN FORMAT
 
     D CurCuStScn    E DS                  EXTNAME(FFCSETPD)
     D                                     PREFIX(@)
      ** CURRENT CUSTOMER SETTLEMENT DETAILS IN SCREEN FORMAT
 
     D OKCustSet     E DS                  EXTNAME(FFECSETPD)
      ** EXTERNAL DATA STRUCTURE FOR CUSTOMER SETTLEMENT FLAGS
 
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    CPB001
      ** EXTERNAL DS FOR Portfolio Management DETAILS                           CPB001
                                                                                CPB001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
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
 
      ** Flag for Enhanced OTCs feature
     D CFF001          S              1A
 
      ** CFF007 enhancement                                                                   CFF007
     D CFF007          S              1A                                                      CFF007
                                                                                              CFF007
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
 
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
 
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
 
      *  If any errors were found and reset of fields in error required,
      *  do this
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
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
      ** This field is NOT AMENDABLE.
 
     C     SISPT         IFNE      @SISPT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SISPT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0532'
     C                   EVAL      OKISPT          = 'N'
     C                   ENDIF
 
 
      *-----------------------------------------*
      * Purchase or Sale                        *
      *-----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     STRTY         IFNE      @STRTY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STRTY'
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
 
     C     SNUCO         IFNE      @SNUCO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SNUCO'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0535'
     C                   EVAL      OKNUCO          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** O.T.C Type                             *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        SISTT  <> @SISTT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SISTT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0680'
     C                   EVAL      OKISTT         = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Put/Call                               *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        SPCAL  <> @SPCAL
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPCAL'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0540'
     C                   EVAL      OKPCAL         = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Strike Price                           *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        SSTRP  <> @SSTRP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SSTRP'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0541'
     C                   EVAL      OKSTRP          = 'N'
     C                   ENDIF
      **--------------------------------------------*
      ** Style - American/European Option indicator *
      **--------------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        SAEIN  <> @SAEIN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SAEIN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0681'
     C                   EVAL      OKAEIN         = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Portfolio Reference                    *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SPTFR         IFNE      @SPTFR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPTFR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0542'
     C                   EVAL      OKPTFR         = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Contingent (delivery) amount           *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SCTAM         IFNE      @SCTAM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCTAM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0682'
     C                   EVAL      OKCTAM          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Delivery Currency                      *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SDCCY         IFNE      @SDCCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SDCCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0683'
     C                   EVAL      OKDCCY          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Other Amount                           *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SCCAM         IFNE      @SCCAM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCAM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0684'
     C                   EVAL      OKCCAM          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Counter Currency                       *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SCTCY         IFNE      @SCTCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCTCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0685'
     C                   EVAL      OKCTCY          = 'N'
     C                   ENDIF
      *-----------------------------------------*
      * Contract Price                          *
      *-----------------------------------------*
      ** This field is amendable only if the number of contracts = the
      ** number of open contracts AND the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C     SCOPR         IFNE      @SCOPR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCOPR'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0543'
     C                   EVAL      OKCOPR          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Premium Currency                       *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SISCY         IFNE      @SISCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SISCY'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0686'
     C                   EVAL      OKISCY          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Premium Up Front                       *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SPUPF         IFNE      @SPUPF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPUPF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0687'
     C                   EVAL      OKPUPF          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Quotation                              *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C*****SQOTC         IFNE      @SQOTC                                       CAP084
     C                   CALLB     'ZCMPAMTS'                                   CAP084
     C                   PARM      SQOTC         ZCMPAMT1         25            CAP084
     C                   PARM      @SQOTC        ZCMPAMT2         25            CAP084
     C                   PARM      'N'           ZCMPAMTDif        1            CAP084
                                                                                CAP084
     C     ZCMPAMTDif    IFEQ      'Y'                                          CAP084
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SQOTC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0688'
     C                   EVAL      OKQOTC          = 'N'
     C                   ENDIF
      *-----------------------------------------*
      * Transaction Date                        *
      *-----------------------------------------*
      ** This field is amendable only if the number of contracts = the
      ** number of open contracts AND the End of Centre Processed
      ** indicator = 'N'.
 
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C     STRSD         IFNE      @STRSD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STRSD'
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
 
     C     CFF001        IFEQ      'Y'                                                        CFF007
     C     CFF007        OREQ      'Y'                                                        CFF007
     C                   IF        NOT(EqOpnCont = 'Y' AND ECPI = 'N')
 
     C     SVALD         IFNE      @SVALD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SVALD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0689'
     C                   EVAL      OKVALD          = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CFF007
      **----------------------------------------*
      ** Expiry Date                            *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SFTDT         IFNE      @SFTDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SFTDT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0690'
     C                   EVAL      OKFTDT          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Expiry Time                            *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SFTTM         IFNE      @SFTTM
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SFTTM'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0691'
     C                   EVAL      OKFTTM          = 'N'
     C                   ENDIF
      *-----------------------------------------*
      * Customer                                *
      *-----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        SCUSC  <> @SCUSC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCUSC '
     C                   EVAL      MsgIDArr(Idx)   = 'MMM0387'
     C                   EVAL      OKCUSC         = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Book Code                              *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C                   IF        SBOKC <> @SBOKC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBOKC '
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0060'
     C                   EVAL      OKBOKC         = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Booking Branch                         *
      **----------------------------------------*
      ** Booking branch code validation only when MULTI-BRANCHING
      ** indicator is on.
 
     C     BGMBIN        IFEQ      'Y'
     C                   IF        SBRCD <> @SBRCD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRCD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0063'
     C                   EVAL      OKBRCD          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Originating Branch                     *
      **----------------------------------------*
      ** Only validate this field if Originating Branch ICD flag on.
 
     C     BKOBRU        IFEQ      'Y'
 
      ** This field is not amendable unless MULTI-BRANCHING
      ** indicator is on.
 
     C     SPRFC         IFNE      @SPRFC
     C     BGMBIN        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0548'
     C                   EVAL      OKPRFC          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Settlement Date                        *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SSETD         IFNE      @SSETD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SSETD'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0678'
     C                   EVAL      OKSETD          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Commodity Reference                    *
      **----------------------------------------*
      ** This field is NOT AMENDABLE.
 
     C     SCMRF         IFNE      @SCMRF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCMRF'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0692'
     C                   EVAL      OKCMRF          = 'N'
     C                   ENDIF
      **----------------------------------------*
      ** Profit Centre                          *
      **----------------------------------------*
      ** Only validate this field if Profit Centre ICD flag on.
 
     C     BKPRCU        IFEQ      'Y'
 
      ** This field is not amendable unless 'Profit Centre Amendable'
      ** ICD flag is on.
 
     C     SPRFC         IFNE      @SPRFC
     C     BKPRCA        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SPRFC'
     C                   EVAL      MsgIDArr(Idx)   = 'FXM4002'
     C                   EVAL      OKPRFC          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** PM Instrument Type                     *
      **----------------------------------------*
     ****This*field*can*only*be*amended*if*Enhanced*OTC*switchable*feature      CPB001
     ****is*on.                                                                 CPB001
     ******                                                                     CPB001
     C*****CFF001        IFNE      'Y'                                          CPB001
     C*****SINNR         IFNE      @SINNR                                       CPB001
     C*****              ADD       1             Idx                            CPB001
     C*****              EVAL      FldNameArr(Idx) = 'SINNR'                    CPB001
     C*****              EVAL      MsgIDArr(Idx)   = 'MMA0693'                  CPB001
     C*****              EVAL      OKINNR          = 'N'                        CPB001
     C*****              ENDIF                                                  CPB001
     C*****              ENDIF                                                  CPB001
                                                                                CPB001
      ** This field can only be amended if Private banking Module or PM Module  CPB001
      *  and Customer support                                                   CPB001
                                                                                CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C     BGPFMG        ANDNE     'Y'                                          CPB001
     C     BGN4ST        ORNE      'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     FCPORS        ANDEQ     'B'                                          CPB001
     C     SINNR         IFNE      @SINNR                                       CPB001
     C                   ADD       1             Idx                            CPB001
     C                   EVAL      FldNameArr(Idx) = 'SINNR'                    CPB001
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0719'                  CPB001
     C                   EVAL      OKINNR          = 'N'                        CPB001
     C                   ENDIF                                                  CPB001
     C                   ENDIF                                                  CPB001
 
      **----------------------------------------*
      ** Transaction Position Profit Centre     *
      **----------------------------------------*
 
     C                   IF        STPRC <> @STPRC
 
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'STPRC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0711'
     C                   EVAL      OKTPRC          = 'N'
 
     C                   ENDIF
 
      **----------------------------------------*
      ** Customer Commission Code               *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCCMC         IFNE      @SCCMC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCMC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0557'
     C                   EVAL      OKCCMC          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Customer Commission Code - Same Day    *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCCMS         IFNE      @SCCMS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCMS'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0558'
     C                   EVAL      OKCCMS          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Customer Commission Amount             *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCCMA         IFNE      @SCCMA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCMA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0559'
     C                   EVAL      OKCCMA          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Customer Charge Code                   *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCCHC         IFNE      @SCCHC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCHC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0560'
     C                   EVAL      OKCCHC          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Customer Charge Amount                 *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCCHA         IFNE      @SCCHA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCHA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0561'
     C                   EVAL      OKCCHA          = 'N'
     C                   ENDIF
     C                   ENDIF
      **----------------------------------------*
      ** Customer Settlement Type               *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCSLT         IFNE      @SCSLT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCSLT'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0563'
     C                   EVAL      OKCSLT          = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      **----------------------------------------*
      ** Customer Settlement Branch             *
      **----------------------------------------*
      *  Only amend this field if MULTI-BRANCHING is on or
      ** if the End of Centre Processed indicator = 'n'.
      *
     C     ECPI          IFNE      'N'
     C     BGMBIN        OREQ      'N'
     C     SBRSC         IFNE      @SBRSC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SBRSC'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0564'
     C                   EVAL      OKBRSC          = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      **----------------------------------------*
      ** Customer Settlement Account            *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCSLA         IFNE      @SCSLA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCSLA'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0565'
     C                   EVAL      OKCSLA          = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      **----------------------------------------*
      ** Customer Counterparty Nostro           *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCCPN         IFNE      @SCCPN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCCPN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0566'
     C                   EVAL      OKCCPN          = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      **----------------------------------------*
      ** Customer For the Account Of            *
      **----------------------------------------*
      *  Only validate this field if the End of Centre Processed
      ** indicator = 'N'.
 
     C     ECPI          IFNE      'N'
     C     SCFAO         IFNE      @SCFAO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'SCFAO'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA0567'
     C                   EVAL      OKCFAO          = 'N'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      *-----------------------------------------------------------------*
      * The following fields are currently UNCONDITIONALLY AMENDABLE    *
      * so no checking is done here.                                    *
      *-----------------------------------------------------------------*
 
      ** SLNKR  - Linked Reference Number
      ** STNAR  - Narrative
      ** STBLO  - To be left open
      ** SCMAR  - Customer Initial Margin
      ** SBPRC  - Book Positions Profit Centre
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETFLDS - Reset fields in Error                             *
      *                                                               *
      *****************************************************************
 
     C     ResetFlds     BEGSR
      *
      * Reset fields in error to 'current' values
      *
     C     AmendOK       IFEQ      'N'
     C                   MOVE      CurCuStScn    NewCuStScn
     C                   MOVE      CurTranScn    NewTranScn
     C                   ENDIF
     C                   ENDSR
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
 
      *    If 'No. of Contracts' = 'No. of Open Contracts'
      *                            (for Customer, + Broker if involved      )
 
     C     NUCO          IFEQ      NOCO
     C*****BOCO*         IFEQ      0                                                          CSD027
     C     BOCO          IFEQ      *BLANKS                                                    CSD027
     C                   Eval      EqOpnCont='Y'
     C                   ELSE
     C
     C     NUCO          IFEQ      NOBO
     C                   Eval      EqOpnCont='Y'
     C                   END
     C
     C                   END
     C                   END
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *ENTRY        PLIST
      * Outputs
      * -------
      * Return Code
     C                   PARM                    ReturnCode
      * Transaction Details OK flags(DS) from/to caller
     C                   PARM                    OKTransDet
      * Customer Settlement OK flags(DS) from/to caller
     C                   PARM                    OKCustSet
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Amendments OK
     C                   PARM                    AmendOk
      * Inputs
      * ------
      * New transaction in Screen Format
     C                   PARM                    NewTranScn
      * New Customer Settlement deatils in screen format
     C                   PARM                    NewCuStScn
      * Current transaction in Screen Format
     C                   PARM                    CurTranScn
      * Current Customer Settlement Details in Screen Format
     C                   PARM                    CurCuStScn
      * Current transaction in file format
     C                   PARM                    CurTranFil
      * ICD
     C                   PARM                    SDBANK
     C                   PARM                    SDMMOD
     C                   PARM                    SDGELR
      ** O.T.C. instrument switchable field
     C                   PARM                    CFF001
      ** Portfolio Management Details                                           CPB001
     C                   PARM                    SDPORT                         CPB001
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs
      ** CFF007 Enhancement                                                                   CFF007
     C                   PARM                    CFF007                                       CFF007
 
 
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
