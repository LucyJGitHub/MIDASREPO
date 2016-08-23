     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Senders Charges/Ccy-Detail')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVSECH03 - Validate Senders Charges and Currency            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 CSW207             Date 07Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CAP084             Date 16Jul03               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      *                 184060             Date 22Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT008  *CREATE    Date 03Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - Swift 2007 Changes (Recompiled)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CFT008 - Funds Transfer addition of MT102 messages           *
      *                                                               *
      *****************************************************************
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Header record in screen format
     D HdrRcdIn      E DS                  EXTNAME(FT102HSPD) PREFIX(H)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT102DSPD)
 
      ** External data structure for Bank details ICD
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Bank details ICD
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                          220004
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     220004
                                                                                              220004
      * OK Flags for second screen
     D OKFlagDS2     E DS                  EXTNAME(FTE102S2PD)
 
      * OK Flags for First screen
     D OKFlagDs1     E DS                  EXTNAME(FTE102S1PD)
 
      * OK Flags for second screen - header
     D OKFlagHS2     E DS                  EXTNAME(FTE102H2PD)
 
      * OK Flags for First screen - Header
     D OKFlagHs1     E DS                  EXTNAME(FTE102H1PD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIx             S              3P 0
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *
      ** Initialise fields
      *
     C                   EVAL      RetCodeIn  = *Blanks
     C                   EVAL      Idx        = 0
     C                   EVAL      WIx        = 0
     C                   EVAL      OKSchg     = 'Y'
     C                   EVAL      OKSccy     = 'Y'
      *
      ** Initialise defaulted fields so that if zero is entered then default
      ** fields will also be zero
      *
     C                   EVAL      PSpyCcy    = *Blanks
     C                   EVAL      PSndOcg    = *Blanks
     C                   EVAL      PStrCCy    = *Blanks
     C                   EVAL      PSndCtf    = *Blanks
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      PSNDOCG2   = *BLANKS                                       CSW201
     C                   EVAL      PSNDCTF2   = *BLANKS                                       CSW201
     C                   EVAL      PSNDOCG3   = *BLANKS                                       CSW201
     C                   EVAL      PSNDCTF3   = *BLANKS                                       CSW201
     C                   EVAL      PSNDOCG4   = *BLANKS                                       CSW201
     C                   EVAL      PSNDCTF4   = *BLANKS                                       CSW201
     C                   EVAL      PSNDOCG5   = *BLANKS                                       CSW201
     C                   EVAL      PSNDCTF5   = *BLANKS                                       CSW201
     C                   ENDIF                                                                CSW201
      *
      ** Validate (N.B. this field cannot be entered for proc. type 'BI',
      ** unless the details of charges are 'BEN')
      *
     C                   EXSR      Validate
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate - Validate field                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: SDCURRPD                                               *
      *                                                               *
      *****************************************************************
      *
     C     Validate      BEGSR
      *
     C                   IF        HPCctChg = *BLANKS AND PCCyChg = *BLANKS
      *
      ** Reset defaulted fields
      *
     C                   EVAL      PSpyCcy = *Blanks
     C                   EVAL      PStrCcy = *Blanks
     C                   EVAL      PSndocg = *Blanks
     C                   EVAL      PSndCtf = *Blanks
     C                   IF        PSndChg <> *Blanks
     C                   EVAL      OkSChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0266'
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   IF        PSndCcy <> *Blanks
     C                   EVAL      OkSCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0267'
     C                   EVAL      RetCodeIn = 'Error'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ELSE
      *
      ** If transfer type is equal to 'BI' and details of charges are
      ** 'SHA' or 'OUR' then enter is prohibited, for 'BEN it is mandatory.
      ** If 'BO' is transfer type then field is mandatory for 'BEN' only.
      *
     C                   SELECT
     C                   WHEN      HPCctTyp = 'BI'
     C                   SELECT
     C                   WHEN      HPCctChg = 'OUR' OR PCCyChg = 'OUR' OR
     C                             HPCctChg = 'SHA' OR PCCyChg = 'SHA'
      *
      ** Reset defaulted fields
      *
     C                   EVAL      PSpyCcy = *Blanks
     C                   EVAL      PStrCcy = *Blanks
     C                   EVAL      PSndocg = *Blanks
     C                   EVAL      PSndCtf = *Blanks
      *                                                                                       CSW201
      ** If SWIFt 2001 and details of charges is SHA, entry is optional.                      CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
     C                   IF        (HPCctChg = 'SHA' OR PCCyChg = 'SHA')                      CSW201
      *                                                                                       CSW201
     C                   IF        PSNDCCY <> *BLANKS                                         CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C     PSNDCCY       PARM      PSNDCCY       @CCY                                         CSW201
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
      *                                                                                       CSW201
     C                   IF        @RTCD <> *BLANKS                                           CSW201
     C                   EVAL      OKSCCY = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C**********         EVAL      FldNamXAr(Idx) = DDSName                            CSW201 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0233'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCHG <> *BLANKS                                         CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY = *BLANKS AND OKSCCY <> 'N'                        CSW201
     C                   MOVE      'N'           OKSCCY                                       CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCCY'     FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0528'     MsgIdXAr(Idx)                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY <> *BLANKS AND OKSCCY <> 'N'                       CSW201
     C                   MOVE (P)  PSNDCHG       ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   MOVE      'N'           OKSCHG                                       CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     DDsName       FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0234'     MsgIdXAr(Idx)                                CSW201
     C                   ELSE                                                                 CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
     C                   MOVE      ZFIELD        PSNDCHG                                      CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY <> *BLANKS AND OKSCCY <> 'N'                       CSW201
     C                   EVAL      OKSCHG = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG'                                 CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0527'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EXSR      SRSCHG                                                     CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY5 <> *BLANKS AND OKSCCY5 = 'Y' AND                  CSW201
     C                             PSNDCHG5 <> *BLANKS AND OKSCHG5 = 'Y'                      CSW201
     C                   IF        PSNDCCY = *BLANKS AND PSNDCHG = *BLANKS                    CSW201
     C                   EVAL      OKSCHG = 'N'                                               CSW201
     C                   EVAL      OKSCCY = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG'                                 CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Details of charges is OUR, hence prohibited.                                         CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   IF        PSndChg <> *BLANKS OR PSNDCHG2 <> *BLANKS OR               CSW201
     C                             PSNDCHG3 <> *BLANKS OR PSNDCHG4 <> *BLANKS OR              CSW201
     C                             PSNDCHG5 <> *BLANKS                                        CSW201
     C                   EVAL      OkSChg = 'N'                                               CSW201
     C                   EVAL      OkSChg2 = 'N'                                              CSW201
     C                   EVAL      OkSChg3 = 'N'                                              CSW201
     C                   EVAL      OkSChg4 = 'N'                                              CSW201
     C                   EVAL      OkSChg5 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0508'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        PSndCcy <> *BLANKS OR PSNDCCY2 <> *BLANKS OR               CSW201
     C                             PSNDCCY3 <> *BLANKS OR PSNDCCY4 <> *BLANKS OR              CSW201
     C                             PSNDCCY5 <> *BLANKS                                        CSW201
     C                   EVAL      OkSCcy = 'N'                                               CSW201
     C                   EVAL      OkSCcy2 = 'N'                                              CSW201
     C                   EVAL      OkSCcy3 = 'N'                                              CSW201
     C                   EVAL      OkSCcy4 = 'N'                                              CSW201
     C                   EVAL      OkSCcy5 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C**********         EVAL      FldNamXAr(Idx) = DDSName                            CSW201 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0509'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** SWIFT 2001 is not installed.                                                         CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
      *
     C                   IF        PSndChg <> *Blanks
     C                   EVAL      OkSChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0231'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   IF        PSndCcy <> *Blanks
     C                   EVAL      OkSCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0263'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF                                                                CSW201
      *
      ** Otherwise the field is mandatory
      *
     C                   WHEN      HPCctChg = 'BEN' OR PCCyChg = 'BEN'
      *
     C                   IF        PSndChg = *Blanks
     C                   EVAL      OkSChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0264'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   IF        PSndCCy = *Blanks
     C                   EVAL      OkSCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0265'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @Rtcd             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PSndCcy       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      OkSCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0233'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** The Amount must be in a valid format for this currency
      *
     C                   MOVE (P)  PSndChg       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKSChg
     C                   ADD       1             Idx
     C                   MOVEL     DDsName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0234'     MsgIdXAr(Idx)
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZField           16
     C                   PARM      A6NBDP        ZADecp            2 0
      *
     C                   MOVE      ZFIELD        PSndChg
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EXSR      SRSCHG                                                     CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Case where transfer type is 'BO'
      *
     C                   WHEN      HPCctTyp = 'BO'
     C                   SELECT
      *
      ** If 'BEN' then mandatory
      *
     C                   WHEN      HPCctChg = 'BEN' OR PCCyChg = 'BEN'
      *
     C                   IF        PSndChg = *Blanks
     C                   EVAL      OkSChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0264'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   IF        PSndCCy = *Blanks
     C                   EVAL      OkSCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0265'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @Rtcd             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PSndCcy       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      OkSCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0233'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** The Amount must be in a valid format for this currency
      *
     C                   MOVE (P)  PSndChg       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKSChg
     C                   ADD       1             Idx
     C                   MOVEL     DDsName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0234'     MsgIdXAr(Idx)
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZField           16
     C                   PARM      A6NBDP        ZADecp            2 0
      *
     C                   MOVE      ZFIELD        PSndChg
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EXSR      SRSCHG                                                     CSW201
     C                   ENDIF
     C                   ENDIF
      *
      ** Other
      *
     C                   WHEN      HPCctChg = 'OUR' OR PCCyChg = 'OUR' OR
     C                             HPCctChg = 'SHA' OR PCCyChg = 'SHA'
      *
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** If CSW201 is on, entry to Sender's charges is prohibited if                          CSW201
      ** details of charges is OUR                                                            CSW201
      *                                                                                       CSW201
     C                   IF        (HPCctChg = 'OUR' OR PCCyChg = 'OUR')                      CSW201
      *                                                                                       CSW201
     C                   IF        PSndChg <> *BLANKS OR PSNDCHG2 <> *BLANKS OR               CSW201
     C                             PSNDCHG3 <> *BLANKS OR PSNDCHG4 <> *BLANKS OR              CSW201
     C                             PSNDCHG5 <> *BLANKS                                        CSW201
     C                   EVAL      OkSChg = 'N'                                               CSW201
     C                   EVAL      OkSChg2 = 'N'                                              CSW201
     C                   EVAL      OkSChg3 = 'N'                                              CSW201
     C                   EVAL      OkSChg4 = 'N'                                              CSW201
     C                   EVAL      OkSChg5 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0508'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        PSndCcy <> *BLANKS OR PSNDCCY2 <> *BLANKS OR               CSW201
     C                             PSNDCCY3 <> *BLANKS OR PSNDCCY4 <> *BLANKS OR              CSW201
     C                             PSNDCCY5 <> *BLANKS                                        CSW201
     C                   EVAL      OkSCcy = 'N'                                               CSW201
     C                   EVAL      OkSCcy2 = 'N'                                              CSW201
     C                   EVAL      OkSCcy3 = 'N'                                              CSW201
     C                   EVAL      OkSCcy4 = 'N'                                              CSW201
     C                   EVAL      OkSCcy5 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C**********         EVAL      FldNamXAr(Idx) = DDSName                            CSW201 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0509'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Details of charges is SHA, hence, optional.                                          CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   IF        PSNDCCY <> *BLANKS                                         CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C     PSNDCCY       PARM      PSNDCCY       @CCY                                         CSW201
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
      *                                                                                       CSW201
     C                   IF        @RTCD <> *BLANKS                                           CSW201
     C                   EVAL      OKSCCY = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C**********         EVAL      FldNamXAr(Idx) = DDSName                            CSW201 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0233'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCHG <> *BLANKS                                         CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY = *BLANKS AND OKSCCY <> 'N'                        CSW201
     C                   MOVE      'N'           OKSCCY                                       CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCCY'     FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0528'     MsgIdXAr(Idx)                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY <> *BLANKS AND OKSCCY <> 'N'                       CSW201
     C                   MOVE (P)  PSNDCHG       ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   MOVE      'N'           OKSCHG                                       CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     DDsName       FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0234'     MsgIdXAr(Idx)                                CSW201
     C                   ELSE                                                                 CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
     C                   MOVE      ZFIELD        PSNDCHG                                      CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY <> *BLANKS AND OKSCCY <> 'N'                       CSW201
     C                   EVAL      OKSCHG = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG'                                 CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0527'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EXSR      SRSCHG                                                     CSW201
     C                   IF        PSNDCCY5 <> *BLANKS AND OKSCCY5 = 'Y' AND                  CSW201
     C                             PSNDCHG5 <> *BLANKS AND OKSCHG5 = 'Y'                      CSW201
     C                   IF        PSNDCCY = *BLANKS AND PSNDCHG = *BLANKS                    CSW201
     C                   EVAL      OKSCHG = 'N'                                               CSW201
     C                   EVAL      OKSCCY = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG'                                 CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** SWIFT 2001 is off.                                                                   CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   IF        PSndChg <> *Blanks
     C                   IF        PSndCcy = *Blanks
     C                   EVAL      OkSCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0235'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @Rtcd             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PSndCcy       @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      OkSCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0233'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** The Amount must be in a valid format for this currency
      *
     C                   MOVE (P)  PSndChg       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkSChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0234'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZField           16
     C                   PARM      A6NBDP        ZADecp            2 0
      *
     C                   MOVE      ZFIELD        PSndChg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        PSndCcy <> *Blanks
     C                   EVAL      OkSChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0268'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *
     C                   ENDSL
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************                       CSW201
      /EJECT                                                                                  CSW201
      *****************************************************************                       CSW201
      *                                                               *                       CSW201
      * SRSCHG - Compute other sender's charges                       *                       CSW201
      *                                                               *                       CSW201
      *****************************************************************                       CSW201
     C     SRSCHG        BEGSR                                                                CSW201
      *                                                                                       CSW201
      ** Sender's charges 2                                                                   CSW201
      *                                                                                       CSW201
     C                   IF        PSNDCCY2 <> *BLANKS                                        CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C     PSNDCCY2      PARM      PSNDCCY2      @CCY                                         CSW201
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
      *                                                                                       CSW201
      ** Currency must be valid on the system                                                 CSW201
     C                   IF        @RTCD <> *BLANKS                                           CSW201
     C                   EVAL      OKSCCY2 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY2'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0514'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCHG2 <> *BLANKS                                        CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY2 = *BLANKS AND OKSCCY2 <> 'N'                      CSW201
     C                   MOVE      'N'           OKSCCY2                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCCY2'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0528'     MsgIdXAr(Idx)                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY2 <> *BLANKS AND OKSCCY2 <> 'N'                     CSW201
      *                                                                                       CSW201
      ** The Amount must be in a valid format for this currency                               CSW201
     C                   MOVE (P)  PSNDCHG2      ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
                                                                                              CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   MOVE      'N'           OKSCHG2                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCHG2'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0515'     MsgIdXAr(Idx)                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
     C                   MOVE      ZFIELD        PSNDCHG2                                     CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY2 <> *BLANKS AND OKSCCY2 <> 'N'                     CSW201
     C                   EVAL      OKSCHG2 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG2'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0516'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Sender's charges 3                                                                   CSW201
      *                                                                                       CSW201
     C                   IF        PSNDCCY3 <> *BLANKS                                        CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C     PSNDCCY3      PARM      PSNDCCY3      @CCY                                         CSW201
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
      *                                                                                       CSW201
      ** Currency must be valid on the system                                                 CSW201
     C                   IF        @RTCD <> *BLANKS                                           CSW201
     C                   EVAL      OKSCCY3 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY3'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0517'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCHG3 <> *BLANKS                                        CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY3 = *BLANKS AND OKSCCY3 <> 'N'                      CSW201
     C                   MOVE      'N'           OKSCCY3                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCCY3'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0528'     MsgIdXAr(Idx)                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY3 <> *BLANKS AND OKSCCY3 <> 'N'                     CSW201
      *                                                                                       CSW201
      ** The Amount must be in a valid format for this currency                               CSW201
     C                   MOVE (P)  PSNDCHG3      ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
                                                                                              CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
                                                                                              CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   MOVE      'N'           OKSCHG3                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCHG3'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0518'     MsgIdXAr(Idx)                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
                                                                                              CSW201
     C                   MOVE      ZFIELD        PSNDCHG3                                     CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY3 <> *BLANKS AND OKSCCY3 <> 'N'                     CSW201
     C                   EVAL      OKSCHG3 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG3'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0519'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY3 <> *BLANKS AND OKSCCY3 = 'Y' AND                  CSW201
     C                             PSNDCHG3 <> *BLANKS AND OKSCHG3 = 'Y' AND                  CSW201
     C                             PSNDCCY2 = *BLANKS AND OKSCCY2 = 'Y' AND                   CSW201
     C                             PSNDCHG2 = *BLANKS AND OKSCHG2 = 'Y'                       CSW201
     C                   EVAL      OKSCHG2 = 'N'                                              CSW201
     C                   EVAL      OKSCCY2 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG2'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Sender's Charge 4                                                                    CSW201
      *                                                                                       CSW201
     C                   IF        PSNDCCY4 <> *BLANKS                                        CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C     PSNDCCY4      PARM      PSNDCCY4      @CCY                                         CSW201
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
      *                                                                                       CSW201
      ** Currency must be valid on the system                                                 CSW201
     C                   IF        @RTCD <> *BLANKS                                           CSW201
     C                   EVAL      OKSCCY4 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY4'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0521'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCHG4 <> *BLANKS                                        CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY4 = *BLANKS AND OKSCCY4 <> 'N'                      CSW201
     C                   MOVE      'N'           OKSCCY4                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCCY4'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0528'     MsgIdXAr(Idx)                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY4 <> *BLANKS AND OKSCCY4 <> 'N'                     CSW201
      *                                                                                       CSW201
      ** The Amount must be in a valid format for this currency                               CSW201
     C                   MOVE (P)  PSNDCHG4      ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
                                                                                              CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
                                                                                              CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   MOVE      'N'           OKSCHG4                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCHG4'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0522'     MsgIdXAr(Idx)                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
                                                                                              CSW201
     C                   MOVE      ZFIELD        PSNDCHG4                                     CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY4 <> *BLANKS AND OKSCCY4 <> 'N'                     CSW201
     C                   EVAL      OKSCHG4 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG4'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0523'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY4 <> *BLANKS AND OKSCCY4 = 'Y' AND                  CSW201
     C                             PSNDCHG4 <> *BLANKS AND OKSCHG4 = 'Y'                      CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY2 = *BLANKS AND PSNDCHG2 = *BLANKS                  CSW201
     C                   EVAL      OKSCHG2 = 'N'                                              CSW201
     C                   EVAL      OKSCCY2 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG2'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY3 = *BLANKS AND PSNDCHG3 = *BLANKS                  CSW201
     C                   EVAL      OKSCHG3 = 'N'                                              CSW201
     C                   EVAL      OKSCCY3 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG3'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Sender's Charge 5                                                                    CSW201
      *                                                                                       CSW201
     C                   IF        PSNDCCY5 <> *BLANKS                                        CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C     PSNDCCY5      PARM      PSNDCCY5      @CCY                                         CSW201
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
      *                                                                                       CSW201
      ** Currency must be valid on the system                                                 CSW201
     C                   IF        @RTCD <> *BLANKS                                           CSW201
     C                   EVAL      OKSCCY5 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCCY5'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0524'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCHG5 <> *BLANKS                                        CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY5 = *BLANKS AND OKSCCY5 <> 'N'                      CSW201
     C                   MOVE      'N'           OKSCCY5                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCCY5'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0528'     MsgIdXAr(Idx)                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY5 <> *BLANKS AND OKSCCY5 <> 'N'                     CSW201
      *                                                                                       CSW201
      ** The Amount must be in a valid format for this currency                               CSW201
     C                   MOVE (P)  PSNDCHG5      ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
                                                                                              CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
                                                                                              CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   MOVE      'N'           OKSCHG5                                      CSW201
     C                   ADD       1             Idx                                          CSW201
     C                   MOVEL     'PSNDCHG5'    FldNamXAr(Idx)                               CSW201
     C                   MOVEL     'RFV0525'     MsgIdXAr(Idx)                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
                                                                                              CSW201
     C                   MOVE      ZFIELD        PSNDCHG5                                     CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY5 <> *BLANKS AND OKSCCY5 <> 'N'                     CSW201
     C                   EVAL      OKSCHG5 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG5'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0526'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY5 <> *BLANKS AND OKSCCY5 = 'Y' AND                  CSW201
     C                             PSNDCHG5 <> *BLANKS AND OKSCHG5 = 'Y'                      CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY2 = *BLANKS AND PSNDCHG2 = *BLANKS                  CSW201
     C                   EVAL      OKSCHG2 = 'N'                                              CSW201
     C                   EVAL      OKSCCY2 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG2'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY3 = *BLANKS AND PSNDCHG3 = *BLANKS                  CSW201
     C                   EVAL      OKSCHG3 = 'N'                                              CSW201
     C                   EVAL      OKSCCY3 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG3'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        PSNDCCY4 = *BLANKS AND PSNDCHG4 = *BLANKS                  CSW201
     C                   EVAL      OKSCHG4 = 'N'                                              CSW201
     C                   EVAL      OKSCCY4 = 'N'                                              CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = 'PSNDCHG4'                                CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0520'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDSR                                                                CSW201
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *Entry        PLIST
      *
      ** INPUTS
      *
     C                   PARM                    RetCodeIn
     C                   PARM                    RespMode          1
     C                   PARM                    ActionCode        1
      *
      ** Screen fields
      *
     C                   PARM                    HdrRcdIn
     C                   PARM                    DtlRcdIn
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDSName          10
     C                   PARM                    OKFlagDs1
     C                   PARM                    OKFlagDs2
     C                   PARM                    OKFlagHs1
     C                   PARM                    OKFlagHs2
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV102HSIN'
     C                   EVAL      DBase = 1
     C                   EVAL      DBMod = 'FTVSECH03'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSW201
      ** Check if SWIFT 2001 is installed                                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR                                                  *** InzEnd ***
      *
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
