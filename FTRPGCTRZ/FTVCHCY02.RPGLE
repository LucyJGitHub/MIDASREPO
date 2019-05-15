     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Receivers Charges/Ccy-Detail')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVCHCY02 - Validate Receiver's Charges and Currency         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
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
      *                 CFT008  *CREATE    Date 30Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** SWIFT 2001 switchable feature                                                        CSW201
     D CSW201          S              1A                                                      CSW201
                                                                                              CSW201
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
     C                   EVAL      OKRCHG     = 'Y'
     C                   EVAL      OKRCCY     = 'Y'
      *
      ** Initialise defaulted fields so that if zero is entered then default
      ** fields will also be zero
      *
     C                   EVAL      PRPYCCy    = *Blanks
     C                   EVAL      PRCVOCG    = *Blanks
     C                   EVAL      PRTRCCY    = *Blanks
     C                   EVAL      PRCVCTF    = *Blanks
      *
      ** Validate (N.B. this field cannot be entered for proc. type 'BO',
      ** if the details of the charges are 'SHA' or 'BEN')
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
     C                   EVAL      PRtrCcy = *Blanks
     C                   EVAL      PRpyCcy = *Blanks
     C                   EVAL      Prcvocg = *Blanks
     C                   EVAL      Prcvctf = *Blanks
      *
     C                   IF        PRcvChg <> *Blanks
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0272'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   IF        PRcvCcy <> *Blanks
     C                   EVAL      OkRCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0273'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If transfer type is equal to 'BO' and details of charges are
      ** 'SHA' or 'BEN' then entry is prohibited, for 'OUR it is mandatory.
      ** If 'BI' is transfer type then field is mandatory for 'OUR' only.
      *
     C                   SELECT
     C                   WHEN      HPCctTyp = 'BO'
     C                   SELECT
     C                   WHEN      HPCctChg = 'BEN' OR PCCyChg = 'BEN' OR
     C                             HPCctChg = 'SHA' OR PCCyChg = 'SHA'
      *
      ** Reset defaulted fields
      *
     C                   EVAL      PRtrCcy = *Blanks
     C                   EVAL      PRpyCcy = *Blanks
     C                   EVAL      Prcvocg = *Blanks
     C                   EVAL      Prcvctf = *Blanks
      *
     C                   IF        PRcvChg <> *Blanks
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0230'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   IF        PRcvCcy <> *Blanks
     C                   EVAL      OkRCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0269'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
      *
      ** Otherwise the field is mandatory
      *
     C                   WHEN      HPCctChg = 'OUR' OR PCCyChg = 'OUR'
      *                                                                                       CSW201
      ** If CSW201 is on, entry to Receiver's charges and currency                            CSW201
      ** are now optional.                                                                    CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
     C                   SELECT                                                               CSW201
      *                                                                                       CSW201
     C                   WHEN      PRcvChg <> *BLANKS AND                                     CSW201
     C                             PRcvCCy = *BLANKS                                          CSW201
     C                   EVAL      OkRCCy = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C**********         EVAL      MsgIdXAr(Idx) = 'RFV0510'                           CSW201 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
      *                                                                                       CSW201
     C                   WHEN      PRcvChg = *BLANKS AND                                      CSW201
     C                             PRcvCCy <> *BLANKS                                         CSW201
     C                   EVAL      OkRChg = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0511'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
      *                                                                                       CSW201
      ** Currency must be valid on the system                                                 CSW201
      *                                                                                       CSW201
     C                   WHEN      PRcvCcy <> *BLANKS AND                                     CSW201
     C                             PRcvChg <> *BLANKS                                         CSW201
      *                                                                                       CSW201
     C                   CALL      'AOCURRR0'                                                 CSW201
     C                   PARM      *Blanks       @Rtcd                                        CSW201
     C                   PARM      '*KEY'        @OPTN                                        CSW201
     C                   PARM      PRcvCcy       @CCY                                         CSW201
     C*****SDCURR        PARM      SDCURR        DSFDY                                 CSW201 220004
     C     SDCURR        PARM      SDCURR        DSSDY                                 CSW201 220004
      *                                                                                       CSW201
     C                   IF        @Rtcd <> *Blanks                                           CSW201
     C                   EVAL      OkRCCy = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C**********         EVAL      FldNamXAr(Idx) = DDSName                            CSW201 CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0170'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
      ** The Amount must be in a valid format for this currency                               CSW201
      *                                                                                       CSW201
     C                   MOVE (P)  PRcvChg       ZFIELD                                       CSW201
     C                   EVAL      ZADIG = 15 - A6NBDP                                        CSW201
      *                                                                                       CSW201
     C                   CALLB     'ZALIGN'                                                   CSW201
     C                   PARM      'Y'           ZALIGNok                                     CSW201
     C                   PARM                    ZFIELD                                       CSW201
     C                   PARM      A6NBDP        ZADEC                                        CSW201
     C                   PARM                    ZADIG                                        CSW201
      *                                                                                       CSW201
     C                   IF        ZALIGNok = 'N'                                             CSW201
     C                   EVAL      OkRChg = 'N'                                               CSW201
     C                   EVAL      Idx = Idx + 1                                              CSW201
     C                   EVAL      FldNamXAr(Idx) = DDSName                                   CSW201
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0171'                                  CSW201
     C                   EVAL      RetCodeIn = 'Error'                                        CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
     C                   CALLB     'ZAEDITM'                                                  CSW201
     C                   PARM                    ZField                                       CSW201
     C                   PARM      A6NBDP        ZADecp                                       CSW201
      *                                                                                       CSW201
     C                   MOVE      ZFIELD        PRcvChg                                      CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDSL                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
      *
     C                   IF        PRcvChg = *Blanks
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0270'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   IF        PRcvCCy = *Blanks
     C                   EVAL      OkRCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0271'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @Rtcd             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PRcvCcy       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @Rtcd <> *Blanks
     C                   EVAL      OkRCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0170'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** The Amount must be in a valid format for this currency
      *
     C                   MOVE (P)  PRcvChg       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0171'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZField           16
     C                   PARM      A6NBDP        ZADecp            2 0
      *
     C                   MOVE      ZFIELD        PRcvChg
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *
     C                   ENDSL
      *
      ** Case where transfer type is 'BO'
      *
     C                   WHEN      HPCctTyp = 'BI'
     C                   SELECT
      *
      ** If 'OUR', then mandatory
      *
     C                   WHEN      HPCctChg = 'OUR' OR PCCyChg = 'OUR'
      *
     C                   IF        PRcvChg = *Blanks
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0270'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   IF        PRcvCCy = *Blanks
     C                   EVAL      OkRCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0271'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @Rtcd             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PRcvCcy       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      OkRCCy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0170'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** The Amount must be in a valid format for this currency
      *
     C                   MOVE (P)  PRcvChg       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0171'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZField           16
     C                   PARM      A6NBDP        ZADecp            2 0
      *
     C                   MOVE      ZFIELD        PRcvChg
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Other
      *
     C                   WHEN      HPCctChg = 'BEN' OR PCCyChg = 'BEN' OR
     C                             HPCctChg = 'SHA' OR PCCyChg = 'SHA'
      *
     C                   IF        PRcvChg <> *Blanks
     C                   IF        PRcvCcy = *Blanks
     C                   EVAL      OkRCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0169'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** Currency must be valid on the system
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @Rtcd             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PRcvCcy       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      OkRCcy = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = DDSName                                   CAP084
     C                   EVAL      FldNamXAr(Idx) = 'PRCVCCY'                                 CAP084
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0170'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
      ** The Amount must be in a valid format for this currency
      *
     C                   MOVE (P)  PRcvChg       ZFIELD
     C                   EVAL      ZADIG = 15 - A6NBDP
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0171'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZField           16
     C                   PARM      A6NBDP        ZaDecp            2 0
      *
     C                   MOVE      ZFIELD        PRcvChg
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        PRcvCcy <> *Blanks
     C                   EVAL      OkRChg = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = DDSName
     C                   EVAL      MsgIdXAr(Idx) = 'RFV0274'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSL
     C                   ENDIF
      *
      *
     C                   ENDSR
      *
      *
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
     C                   EVAL      DBMod = 'FTVCHCY02'
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
      *                                                                                       CSW201
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
(c) Finastra International Limited 2001
