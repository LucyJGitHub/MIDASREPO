     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities Clients Support Log Setup')        *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLLOG - Foreign Exchange Deals Support Log Setup         *
      *                                                               *
      *  Function:  This module will write to the standard log file   *
      *             if the support system is active.                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CDL094             Date 11Jun14               *
      *                 AR990243           Date 14Jun12               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 CDL018             Date 03Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompile)                                         *
      *  AR990243 - Additional deliveries for CSW212                  *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRPROC - Detail Processing                                    *
      * SRSINS - Settlement Instructions Input                        *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D FXDLFilFmt    E DS                  EXTNAME(FXDEALPP)

     D FXDLScnFmt    E DS                  EXTNAME(FXFXDLPD)

     D PAYFilFmt     E DS                  EXTNAME(SDESFPPD)

     D RECFilFmt     E DS                  EXTNAME(SDESFRPD)

     D FRIRFilFmt    E DS                  EXTNAME(SDESFFPD)

     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)

     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)

     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)

     D InfDataDS     E DS                  EXTNAME(FXFXIFPD)

     D ExtDataDS     E DS                  EXTNAME(FXFXEXPD)

     D OutCDL099     E DS                  EXTNAME(FXDLEXPD)                                  CDL099
     D                                     PREFIX(@)                                          CDL099
      * FX Deal Extra Data Layout Definition (output)                                         CDL099
                                                                                              CDL099
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D TRANSDTL        S           5800A
     D PDNBRF          S             19A
     D PDNSRF          S             19A
     D PDSTS           S             24A
     D PACTN           S              1A

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

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   EXSR      SRPROC

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRPROC - Detail Processing                                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: FXFXDLCVT, ZASETINCVT                                  *
      *                                                               *
      *****************************************************************

     C     SRPROC        BEGSR

     C                   EVAL      TRANSDTL = *Blanks

     C                   EXSR      SRSINS

     C                   EVAL      DDACTN = PACTN

     C                   CALLB     'FXFXDLCVT'
     C                   PARM                    RetCodeOut
     C                   PARM                    FXDLFilFmt
     C                   PARM                    FXDLScnFmt
     C                   PARM                    PDNBRF
     C                   PARM                    PDNSRF
     C                   PARM                    PDSTS
     C                   PARM                    OutCDL099                                    CDL099

     C                   IF        RetCodeOut <> *Blanks
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ELSE
     C                   CALLB     'ZASETINCVT'
     C                   PARM                    PAYFilFmt
     C                   PARM                    RECFilFmt
     C                   PARM                    FRIRFilFmt
     C                   PARM                    PAYScnFmt
     C                   PARM                    RECScnFmt
     C                   PARM                    FRIRScnFmt
     C                   PARM      DDBCCY        #TRCCY            3                         CSF011A
     C                   PARM      DDSCCY        #TPCCY            3                         CSF011A

     C                   EVAL      TRANSDTL = FXDLScnFmt + RECScnFmt
     C                                        + PAYScnFmt
     C                                        + FRIRScnFmt                                    CSW212
     C                                        + InfDataDS
     C                                        + ExtDataDS
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR/SRSINS - Settlement Instructions Input                     *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRSINS        BEGSR

      ** Move Payment fields from FXDLFilFmt to PAYFilFmt

     C                   EVAL      FLPSTM = FHPSTM
     C                   EVAL      FLPONS = FHPONS
     C                   EVAL      FLPIBN = FHPIBN
     C                   EVAL      FLPIBA = FHPIBA
     C                   EVAL      FLPOBN = FHPOBN
     C                   EVAL      FLPOCN = FHPOCN
     C                   EVAL      FLRCRN = FHRCRN
     C                   EVAL      FLRCRA = FHRCRA
     C                   EVAL      FLRVNO = FHRVNO
     C                   EVAL      FLAWBN = FHAWBN
     C                   EVAL      FLAWBA = FHAWBA
     C                   EVAL      FLBENN = FHBENN
     C                   EVAL      FLBENA = FHBENA
     C                   EVAL      FLDTP1 = FHDTP1
     C                   EVAL      FLDTP2 = FHDTP2
     C                   EVAL      FLDTP3 = FHDTP3
     C                   EVAL      FLDTP4 = FHDTP4
     C                   EVAL      FLDCHG = FHDCHG
     C                   EVAL      FLBTB1 = FHBTB1
     C                   EVAL      FLBTB2 = FHBTB2
     C                   EVAL      FLBTB3 = FHBTB3
     C                   EVAL      FLBTB4 = FHBTB4
     C                   EVAL      FLBTB5 = FHBTB5
     C                   EVAL      FLBTB6 = FHBTB6
     C                   EVAL      FLPOBR = FHPOBR
     C                   EVAL      FLCVMR = FHCVMR
     C                   EVAL      FLPSCY = FHPSCY
     C                   EVAL      FLIC72 = FHIC72

      ** Move Receipt fields from FXDLFilFmt to RECFilFmt

     C                   EVAL      FLRSTM = FHRSTM
     C                   EVAL      FLRONS = FHRONS
     C                   EVAL      FLRIBN = FHRIBN
     C                   EVAL      FLRIBA = FHRIBA
     C                   EVAL      FLROBN = FHROBN
     C                   EVAL      FLROCN = FHROCN
     C                   EVAL      FLROBR = FHROBR
     C                   EVAL      FLRSCY = FHRSCY

      ** Move new fields of FXDLFilFmt to FRIRFilFmt                                          CSW212
                                                                                              CSW212
     C                   EVAL      FLDSR1 = FHDSR1                                            CSW212
     C                   EVAL      FLDSR2 = FHDSR2                                            CSW212
     C                   EVAL      FLDSR3 = FHDSR3                                            CSW212
     C                   EVAL      FLDSR4 = FHDSR4                                            CSW212
     C                   EVAL      FLDSR5 = FHDSR5                                            CSW212
     C                   EVAL      FLDSR6 = FHDSR6                                            CSW212
     C                   EVAL      FLSSR1 = FHSSR1                                            CSW212
     C                   EVAL      FLSSR2 = FHSSR2                                            CSW212
     C                   EVAL      FLSSR3 = FHSSR3                                            CSW212
     C                   EVAL      FLSSR4 = FHSSR4                                            CSW212
     C                   EVAL      FLSSR5 = FHSSR5                                            CSW212
     C                   EVAL      FLSSR6 = FHSSR6                                            CSW212
     C                   EVAL      FLCND1 = FHCND1                                            CSW212
     C                   EVAL      FLCND2 = FHCND2                                            CSW212
     C                   EVAL      FLCND3 = FHCND3                                            CSW212
     C                   EVAL      FLCND4 = FHCND4                                            CSW212
     C                   EVAL      FLCND5 = FHCND5                                            CSW212
     C                   EVAL      FLCND6 = FHCND6                                            CSW212
     C**********         MOVE      FLISDA        FHISDA                              CSW212 AR990243
     C                   MOVE      FHISDA        FLISDA                                     AR990243
     C                   EVAL      FLAGTY = FHAGTY                                            CSW212
     C**********         MOVE      FLAGDT        FHAGDT                              CSW212 AR990243
     C**********         MOVE      FLAGVV        FHAGVV                              CSW212 AR990243
     C**********         MOVE      FLAGVC        FHAGVC                              CSW212 AR990243
     C                   MOVE      FHAGDT        FLAGDT                                     AR990243
     C                   MOVE      FHAGVV        FLAGVV                                     AR990243
     C                   MOVE      FHAGVC        FLAGVC                                     AR990243
                                                                                              CSW212
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

     C     *Entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    PACTN
     C                   PARM                    FXDLFilFmt
     C                   PARM                    TRANSDTL

      ** The following /COPY sets the program, module and procedure
      ** names for database error processing.

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **-------------------------------------------------------------------+
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **-------------------------------------------------------------------+
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
