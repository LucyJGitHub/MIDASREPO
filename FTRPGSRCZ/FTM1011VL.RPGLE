     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT FTM1011VL101 header record')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTM1011VL - Validate MT101 header record                     *
      *                                                               *
      *  Function: This Program Validates FT MT101 Records for        *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10602           Date 16Feb06               *
      *                 221761             Date 01Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 CSD009             Date 10Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 17Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10602 - MidasPlus Error occurred  (Recompiled)            *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  CFT006 - Swift Messages MT101/MT102                          *
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
     D/COPY ZACPYSRC,STDDECLARE
 
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
     D GenOkFlag       S              1    Export
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
     D OKFlagHS      E DS                  EXTNAME(FTE101HPD)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D  @@Arr          S              1    DIM(4)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
     D #I              S              2  0
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Reset the OkFlagHS to be 'Y' each time it is called.
     C                   Reset                   OkFlagHs
 
     C                   Eval      FldNameArr  =  *Blanks
     C                   Eval      MsgIDArr    =  *Blanks
     C                   Eval      MsgDtaArr   =  *Blanks
     C                   Eval      Idx         =  *Zeros
     C                   Eval      WFldNamArr  =  *Blanks
     C                   Eval      WMsgIDArr   =  *Blanks
     C                   Eval      WMsgDtaArr  =  *Blanks
     C                   Eval      WIdx        =  *Zeros
 
      /COPY WNCPYSRC,FT101HV001
 
      * Get Default Values only on insert
     C                   Exsr      @@Default
 
      /COPY WNCPYSRC,FT101HV002
 
      /COPY WNCPYSRC,FT101HV003
 
     C                   Exsr      @@Prompt
 
      /COPY WNCPYSRC,FT101HV004
 
      * Call Validation Modules in Sequence if action code <> 'E'
     C                   If         ActionCode = 'I' OR  ActionCode = 'A' OR
     C                              ActionCode = 'X'
 
      * Validate Senders reference
      /COPY WNCPYSRC,FT101HV005
 
     C                   Exsr      V#SndR
 
      /COPY WNCPYSRC,FT101HV006
 
      * Validate Field Customer Reference
      /COPY WNCPYSRC,FT101HV007
 
     C                   Exsr      V#CRef
 
      /COPY WNCPYSRC,FT101HV008
 
      * Validate RFT Type
      /COPY WNCPYSRC,FT101HV008
 
     C                   Exsr      V#Rft
 
      /COPY WNCPYSRC,FT101HV010
 
      * Validate Transfer sub-type
      /COPY WNCPYSRC,FT101HV011
 
     C                   Exsr      V#SubT
 
      /COPY WNCPYSRC,FT101HV001
 
      * Validate Fields Booking Branch
      /COPY WNCPYSRC,FT101HV012
 
     C                   Exsr      V#BBch
 
      /COPY WNCPYSRC,FT101HV013
 
      * Validate Fields Originating Branch
      /COPY WNCPYSRC,FT101HV001
 
     C                   Exsr      V#OBch
 
      /COPY WNCPYSRC,FT101HV014
 
      * Validate Field Book Code
      /COPY WNCPYSRC,FT101HV015
 
     C                   Exsr      V#BCde
 
      /COPY WNCPYSRC,FT101HV016
 
      * Validate Field Profit Centre
      /COPY WNCPYSRC,FT101HV017
 
     C                   Exsr      V#Pctr
 
      /COPY WNCPYSRC,FT101HV018
 
      * Validate Swift Priority Indicator
      /COPY WNCPYSRC,FT101HV019
 
     C                   Exsr      V#SPty
 
      /COPY WNCPYSRC,FT101HV020
 
      * Validate Field Instructing Party
      /COPY WNCPYSRC,FT101HV021
 
     C                   Exsr      V#IPty
 
      /COPY WNCPYSRC,FT101HV022
 
      * Validate Field Ordering Customer
      /COPY WNCPYSRC,FT101HV023
 
     C                   Exsr      V#OCust
 
      /COPY WNCPYSRC,FT101HV024
 
      * Validate Destination
     C                   Exsr      V#Dst
 
      * Validate Field Account Servicing Institution
      /COPY WNCPYSRC,FT101HV025
 
     C                   Exsr      V#ASrv
 
      /COPY WNCPYSRC,FT101HV026
 
      * Validate Debit Value Date : Change
      /COPY WNCPYSRC,FT101HV027
 
     C                   Exsr      V#DVDte
 
      /COPY WNCPYSRC,FT101HV028
 
      * Validate Field Requested Execution Date : Change
      /COPY WNCPYSRC,FT101HV029
 
     C                   Exsr      V#RqXDte
 
      /COPY WNCPYSRC,FT101HV030
 
      * Validate Field Handling Charge : Change
      /COPY WNCPYSRC,FT101HV031
 
     C                   Exsr      V#HChg
 
      /COPY WNCPYSRC,FT101HV032
 
      * Validate Field Handling Charge Currency
      /COPY WNCPYSRC,FT101HV033
 
     C                   Exsr      V#HCcy
 
      /COPY WNCPYSRC,FT101HV034
 
      * Validate Charges to the debit of
      /COPY WNCPYSRC,FT101HV035
 
     C                   Exsr      V#ChgD
 
      /COPY WNCPYSRC,FT101HV036
 
      * Validate Sending Institution
 
     C                   Exsr      V#SndI
 
      * Validate Authorisation Characters
 
     C                   Exsr      V#Autx
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   If        Idx = 0 and
     C                             WIdx = 0
     C                   Exsr      SetupValid
     C                   Endif
     C                   Endif
 
      /COPY WNCPYSRC,FT101HV037
 
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRft  - Validate RFT Type
      *****************************************************************
     C     V#Rft         BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'PTYP'                             CAP084
     C                   Eval      DDSName = 'PPTYP'                            CAP084
     C                   CALLB     'FTVRFTY01'   P#List
     C                   Eval      OkPTYP = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** V#Bcde - Validate BOOK CODE
      *****************************************************************
     C     V#Bcde        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'BOKC'                             CAP084
     C                   Eval      DDSName = 'PBOKC'                            CAP084
     C                   CALLB     'FTVBKCD01'   P#List
     C                   Eval      OkBOKC = GenOkFlag
 
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** V#Pctr - Validate Profit Centre
      *****************************************************************
     C     V#Pctr        Begsr
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'PRFC'                             CAP084
     C                   Eval      DDSName = 'PPRFC'                            CAP084
     C                   CALLB     'FTVPFCE01'   P#List
     C                   Eval      OkPRFC = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** V#Subt - Validate RFT Sub-Type
      *****************************************************************
     C     V#SubT        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'PYST'                             CAP084
     C                   Eval      DDSName = 'PPYST'                            CAP084
     C                   CALLB     'FTVSTST01'   P#List
     C                   Eval      OkPYST = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** V#BBch - Validate Booking Branch
      *****************************************************************
     C     V#BBch        Begsr
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C**************     Eval      DDSName = 'BRCA'                             CAP084
     C                   Eval      DDSName = 'PBRCA'                            CAP084
     C                   CALLB     'FTVBKOR01'   P#List
     C                   Eval      OkBRCA = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** V#OBch - Validate Originating Branch
      *****************************************************************
     C     V#OBch        Begsr
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C****************** Eval      DDSName = 'ORBR'                             CAP084
     C                   Eval      DDSName = 'PORBR'                            CAP084
     C                   CALLB     'FTVORBH01'   P#List
     C                   Eval      OkORBR = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** V#Cref - Validate Customer Reference
      *****************************************************************
     C     V#CRef        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'CUSREF'                           CAP084
     C                   Eval      DDSName = 'PCUSTRF'                          CAP084
     C                   CALLB     'FTVCSRF01'   P#List
     C                   Eval      OkCTRF = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** V#IPty - Validate Instructing Party
      *****************************************************************
     C     V#IPty        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'HINPTY'                           CAP084
     C                   Eval      DDSName = 'PHINPTY'                          CAP084
     C                   CALLB     'FTVHDPY01'   P#List
     C                   Eval      OkINPY = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
 
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** V#OCust - Validate Ordering Customer
      *****************************************************************
     C     V#OCust       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'HOCUS1'                           CAP084
     C                   Eval      DDSName = 'PHOCUS1'                          CAP084
     C                   CALLB     'FTVHDCS01'   P#List2
     C                   Eval      OkHOC1 = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
     C/EJECT
      *****************************************************************
      ** V#ASrv  - Validate Account Servicing Institution
      *****************************************************************
     C     V#ASrv        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C****************** Eval      DDSName = 'HACSV1'                           CAP084
     C                   Eval      DDSName = 'PHACSV1'                          CAP084
     C                   CALLB     'FTVHDAC01'
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
      *  Screen fields
     C                   Parm                    HdrRcdIn
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   Parm                    OKFlagHs
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      ** V#RqDte - Validate Requested Execution Date
      *****************************************************************
     C     V#RqXDte      BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'EXDATE'                           CAP084
     C                   Eval      DDSName = 'PEXDATE'                          CAP084
     C                   CALLB     'FTVEXDT01'   P#List
     C                   Eval      OkEXDT = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Debit Value Date
      *****************************************************************
     C     V#DVDte       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C****************** Eval      DDSName = 'DBTVDT'                           CAP084
     C                   Eval      DDSName = 'PDBTVDT'                          CAP084
     C                   CALLB     'FTVDBVL01'   P#List
     C                   Eval      OkDRVD = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Field Handling Charge Amount
      *****************************************************************
     C     V#HChg        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'HANDCG'                           CAP084
     C                   Eval      DDSName = 'PHANDCG'                          CAP084
     C                   CALLB     'FTVCHAM01'   P#List
     C                   Eval      OkHDCH = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Validate Field Handling Charge Currency
      *****************************************************************
     C     V#HCcy        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'HANDCY'                           CAP084
     C                   Eval      DDSName = 'PHANDCY'                          CAP084
     C                   CALLB     'FTVCHCY01'   P#List
     C                   Eval      OkHDCY = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Validate Swift Priority Indicator
      *****************************************************************
     C     V#SPty        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'SWPRIO'                           CAP084
     C                   Eval      DDSName = 'PSWPRIO'                          CAP084
     C                   CALLB     'FTVSFIN01'   P#List
     C                   Eval      OkSWPY = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Validate Charges to the debit of
      *****************************************************************
     C     V#ChgD        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'HANDAC'                           CAP084
     C                   Eval      DDSName = 'PHANDAC'                          CAP084
     C                   CALLB     'FTVCHDB01'   P#List
     C                   Eval      OkHDAC = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * Validate Senders Reference
      *****************************************************************
     C     V#SndR        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C****************** Eval      DDSName = 'SNDREF'                           CAP084
     C                   Eval      DDSName = 'PSNDREF'                          CAP084
     C                   CALLB     'FTVSERF01'   P#List
     C                   Eval      OkSDRF = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      * Validate Senders Institution
      *****************************************************************
     C     V#SndI        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'SINST'                            CAP084
     C                   Eval      DDSName = 'PSINST'                           CAP084
     C                   CALLB     'FTVSEIS01'   P#List
     C                   Eval      OkSINT = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      * Validate Authorisation Text
      *****************************************************************
     C     V#Autx        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'AUTHTX'                           CAP084
     C                   Eval      DDSName = 'PAUTHTX'                          CAP084
     C                   CALLB     'FTVAUTX01'   P#List
     C                   Eval      OkAUTH = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      * Validate Destination
      *****************************************************************
     C     V#Dst         BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C*******************Eval      DDSName = 'RFTDST'                           CAP084
     C                   Eval      DDSName = 'PRFTDST'                          CAP084
     C                   CALLB     'FTVDNAD01'   P#List
     C                   Eval      OkDST  = GenOkFlag
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      * SETUPVALID - Set up additional fields that are needed on the  *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
     C                   ENDSR
      *****************************************************************
      * @@Default - Default the values when an RFT is inserted.
      *****************************************************************
     C     @@Default     Begsr
 
      * Default the Sender ID to the Swift Reference for the book branch
      * Get Sender ID from branch file
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       P@RTCD            7
     C                   Parm      '*KEY   '     P@OPTN            7
     C     PBRCA         Parm      PBRCA         P@BRCA            3
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   If        ActionCode = 'I'  AND
     C                             PSTID = *Blanks
     C                   Eval      PSTID = A8BTID
     C                   Endif
 
     C**********         Call      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
 
     C                   Parm      *BLANKS       P@RTCD
     C                   Parm      '*FIRST '     P@OPTN
     C*****SDGELR        Parm      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * Database error
      *
     C                   If        P@RTCD <> *Blanks
     C                   Movel     'SDGELRPD'    DBFILE
     C                   Movel     '008'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
 
      * Default the Originating Branch to the Booking branch if not entered.
     C                   If        PORBR = *Blanks
     C                   Eval      PORBR = PBRCA
     C                   Endif
 
      * Default the Profit Centre
      * If profit centre is not entered and BKPRCU = 'Y', default
      * to the profit centre matrix
     C                   If        BKPRCU ='Y' and
     C                             PPRFC = *Blanks
 
     C                   CALLB     'AOPRFMR0'
     C                   Parm      *Blanks       RTCD1             1
     C                   Parm      *Blanks       P@BOKC            2
     C                   Parm      *Blanks       P#TRTP            5
     C                   Parm      *Blanks       P#SUTP            2
     C                   Parm      PBRCA         P#BRCA            3
     C                   Parm      *Blanks       P#DEPT            3
     C                   Parm      *Blanks       P#USER           10
     C                   Parm      *Blanks       P#ACOF            2
     C                   Parm      *Blanks       P#CUST            6
     C     PPRFC         Parm      *Blanks       P#PRFC            4
 
     C                   Endif
 
      ** Access Bank Details
      *
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       P@RTCD
     C                   Parm      '*FIRST '     P@OPTN
     C     SDBANK        Parm      SDBANK        DSFDY
 
      * Database Error
      *
     C                   If        P@RTCD <> *Blanks
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '007'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
 
      * Requested Execution Date.  If not entered, default to todays date
      * Requires Conversion to DD/MM/YY
 
 
     C                   CallB     'ZDATE2'
     C                   Parm                    BJRDNB
     C                   Parm                    BJDFIN
     C                   Parm                    DateOut           6 0
     C                   Parm                    Filler            7
 
     C                   If        PEXDATE = *Blanks
     C                   Movel     DateOut       PEXDATE
     C                   Endif
 
      * Swift Priority Indicator.
     C                   If        PSWPRIO = *Blank
     C                   Eval      PSWPRIO = 'N'
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * @@Prompt Prompt fields                                        *
      *****************************************************************
     C     @@Prompt      Begsr
 
      * Prompt Sub-Type
     C                   Movea     PPYST         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0250S'
     C                   Parm                    P@RTCD
     C                   Parm      *Blanks       PPYST
     C                   Endif
 
      * Prompt Originating Branch
     C                   Movea     PORBR         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0061S'
     C                   Parm                    P@RTCD
     C                   Parm      *Blanks       PORBR
     C                   Endif
 
      * Prompt Book Code
     C                   Movea     PBOKC         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0310S'
     C                   Parm                    P@RTCD
     C                   Parm      *Blanks       PBOKC
     C                   Endif
 
      * Prompt Profit Centre
     C                   Movea     PPRFC         @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0480S'
     C                   Parm                    P@RTCD
     C                   Parm      *Blanks       PPRFC
     C                   Endif
 
      * Prompt Currency
     C                   Movea     PHANDCY       @@Arr
     C     '?'           Lookup    @@Arr                                  96
     C                   If        *In96 = *On
     C                   Call      'SD0020S'
     C                   Parm                    P@RTCD
     C                   Parm      *Blanks       PHANDCY
     C                   Endif
 
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RtnCodeIn         7
      * Response mode (1A), from source system common header (A or S)
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    ActionCode        1
 
      * Header information (DS) from source system
     C                   PARM                    HdrRcdIn
 
      * OK Flags Data Structure
     C                   PARM                    OkFlagHS
 
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
 
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   Eval      #MsgFile = 'FTUSRMSG'
 
     C     P#List        PLIST
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
      *  Screen fields
     C                   Parm                    HdrRcdIn
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
     C     P#List2       PLIST
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   Parm                    OkFlagHs
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   Eval      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *Blanks
     C                   Eval      WMsgDtXAr = *Blanks
 
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
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   Endif
      *
      * Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   Endif
      *
      * Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIdx = #I - 1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
