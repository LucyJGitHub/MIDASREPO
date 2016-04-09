     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate receivers charges and currency')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRECH03 - Validate Receiver's Charges and Currency         *
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
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. 212229             Date 02Apr04               *
      *                 221761             Date 01Apr04               *
      *                 220004             Date 24Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006  *CREATE    Date 01Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  212229 - Receiver's charge currency is not defaulted to      *
      *           Local currency. Call SR/*INZSR to ensure that       *
      *           AOBANKR0 is always called, and not only during      *
      *           program activation.                                 *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  CFT006 - Funds Transfer addition of MT101 messages           *
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
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
     D  PSNDREF_H    E                     EXTFLD(PSNDREF)
 
      * Detail record in screen format
     D DtlRcdIn      E DS                  EXTNAME(FT101DSPD)
 
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
     D OKFlags       E DS                  EXTNAME(FTE101S2PD)
 
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
 
     C                   Eval      RetCodeIn  = *Blanks
     C                   Eval      Idx        = 0
     C                   Eval      WIx        = 0
     C                   Eval      OKRVCH     = 'Y'
     C                   Eval      OKRVCY     = 'Y'
     C                   EXSR      *INZSR                                                     212229
 
      ** Validate (N.B. this field cannot be entered for proc. type 'RO')
     C                   IF        PPTYP = 'RI'
     C                   EXSR      Validate
     C                   ENDIF
 
     C                   Return
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
     C     Validate      BEGSR
      *
      ** If Currency is entered, amount field must also be entered
     C                   IF        PRCHCCY <> *Blanks
      *
     C                   IF        PRCVCHG = *Blanks
     C                   MOVE      'N'           OKRVCH
     C                   ADD       1             Idx
     C                   MOVEL     'PRCVCHG'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0168'     MsgIdXAr(Idx)
     C                   ENDIF
      *
      ** Currency must be valid on the system
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      PRCHCCY       @CCY              3
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
      *
     C                   IF        @RTCD <> *Blanks
     C                   MOVE      'N'           OKRVCY
     C                   ADD       1             Idx
     C                   MOVEL     DDSName       FldNamXAr(Idx)
     C                   MOVEL     'RFV0170'     MsgIdXAr(Idx)
     C                   ELSE
      *
     C                   EVAL      PRCHCCY = A6CYCD
      *
      ** The Amount must be in a valid format for this currency
     C                   MOVE (P)  PRCVCHG       ZFIELD                         ************
     C                   EVAL      ZADIG = 15 - A6NBDP                          ************
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C                   IF        ZALIGNok = 'N'
     C                   MOVE      'N'           OKRVCH
     C                   ADD       1             Idx
     C                   MOVEL     'PRCVCHG'     FldNamXAr(Idx)
     C                   MOVEL     'RFV0171'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Else the Currency has not been entered.  The amount must be blank.
     C                   ELSE
      *
     C                   IF        PRCVCHG <> *Blanks
     C                   EVAL      PRCHCCY  =    BJLCCY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
 
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode          1
     C                   Parm                    ActionCode        1
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
     C                   PARM                    DtlRcdIn
 
      * OUTPUTS
 
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName          10
     C                   PARM                    OKFlags
 
      * Access bank details
     C                   CallB     'AOBANKR0'
     C                   PARM                    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        @RTCD <> *Blanks
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBPgm = 'FTV101HSIN'
     C                   EVAL      DBase = 1
     C                   EVAL      DBMod = 'FTVRECH03'
     C                   EVAL      DBProc = '*INZSR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
