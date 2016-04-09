     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Update SSI File Information')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESSIUPD - Update SSI File Information                       *
      *                                                               *
      *  Function:  This module will be called by SESSISIN to update  *
      *             information regarding standard settlement insts.  *
      *                                                               *
      *  Component of: SESSISIN - Standard Settlement Additional      *
      *                           Information                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 25Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE034  -  Standard Settlement Instructions improvements     *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Record not found indicator for CHAIN.           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     -  Initial Processing                             *
      *  SRUpdate   -  Update details to file                         *
      *  SRReturn   -  Return to calling program                      *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Standard Additional Settlements Details
     FSTDADSL2  UF A E           K DISK    COMMIT
 
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
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
 
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
 
      ** DS for Additional Standard Settlement details for update
     D UpdASSIFmt    E DS                  EXTNAME(STDADSED)
 
      ** DS for trade purchase
     D PTradeP       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(UTP:2)
 
      ** DS for trade sale
     D PTradeS       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(UTS:2)
 
      ** DS for depot in
     D PDepotI       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(UDI:2)
 
      ** DS for depot out
     D PDepotO       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(UDO:2)
 
     D KeyList         DS
     D  Branch                        3A
     D**Customer                      6S 0                                                    CSD027
     D  Customer                      6A                                                      CSD027
     D  Book                          2A
     D  Currency                      3A
     D  Market                        2A                                                      CSE034
     D  InvType                       3A
     D  PortRef                       4A
     D  DetType                       1A
 
      ** Indicator pool
     D Indicators      DS                  Based(IndicatorP)
     D RecNotFound            01     01
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S                   LIKE(ReturnCode)
     D*WStdAd***       S           1152A                                                      CSW210
     D WStdAd          S           1382A                                                      CSW210
 
     D IndicatorP      S               *   Inz(%Addr(*IN))
 
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
 
      *********************************************************************
      * Main Procedure                                                    *
      *********************************************************************
 
      ** Initial processing
 
     C                   EXSR      SRInit
 
      ** Update SSI additional details
 
     C                   EXSR      SRUpdate
 
      **  Return
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initial Processing                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Define key list for Additional Standard Settlement file
     C     KAStdSet      KLIST
     C                   KFLD                    Branch
     C                   KFLD                    Customer
     C                   KFLD                    Book
     C                   KFLD                    Currency
     C                   KFLD                    Market                                       CSE034
     C                   KFLD                    InvType
     C                   KFLD                    PortRef
     C                   KFLD                    DetType
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Setup record for insertion/amendment then update  *
      *             to file.                                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Process Trade PURCHASE record
      ** =============================
 
     C                   EVAL      Branch = UTPBCH
     C                   EVAL      Customer = UTPCUST
     C                   EVAL      Book = UTPBK
     C                   EVAL      Currency = UTPCCY
     C                   EVAL      Market = UTPMKT                                            CSE034
     C                   EVAL      InvType = UTPINV
     C                   EVAL      PortRef = UTPPREF
     C                   EVAL      DetType = 'P'
     C                   MOVE      PTradeP       WStdAd
 
     C     *LOVAL        SETLL     STDADSL2
     C     KAStdSet      CHAIN     STDADSL2                           01
 
     C                   IF        WStdAd <> *BLanks
 
     C                   EVAL      UTPRECI = 'D'
     C                   EVAL      UTPTYPE = 'P'
     C                   EVAL      UpdASSIFmt = PTradeP
 
     C                   IF        RecNotFound = True
     C                   WRITE     STDADSD0
     C                   ELSE
     C                   UPDATE    STDADSD0
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        ActionCode = 'A' AND RecNotFound = False
     C                   DELETE    STDADSD0
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Trade SALE record
      ** =========================
 
     C                   EVAL      Branch = UTSBCH
     C                   EVAL      Customer = UTSCUST
     C                   EVAL      Book = UTSBK
     C                   EVAL      Currency = UTSCCY
     C                   EVAL      Market = UTSMKT                                            CSE034
     C                   EVAL      InvType = UTSINV
     C                   EVAL      PortRef = UTSPREF
     C                   EVAL      DetType = 'S'
     C                   MOVE      PTradeS       WStdAd
 
     C     *LOVAL        SETLL     STDADSL2
     C     KAStdSet      CHAIN     STDADSL2                           01
 
     C                   IF        WStdAd  <> *BLanks
 
     C                   EVAL      UTSRECI = 'D'
     C                   EVAL      UTSTYPE = 'S'
     C                   EVAL      UpdASSIFmt = PTradeS
 
     C                   IF        RecNotFound = True
     C                   WRITE     STDADSD0
     C                   ELSE
     C                   UPDATE    STDADSD0
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        ActionCode = 'A' AND RecNotFound = False
     C                   DELETE    STDADSD0
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Depot IN record
      ** =======================
 
     C                   EVAL      Branch = UDIBCH
     C                   EVAL      Customer = UDICUST
     C                   EVAL      Book = UDIBK
     C                   EVAL      Currency = UDICCY
     C                   EVAL      Market = UDIMKT                                            CSE034
     C                   EVAL      InvType = UDIINV
     C                   EVAL      PortRef = UDIPREF
     C                   EVAL      DetType = 'I'
     C                   MOVE      PDepotI       WStdAd
 
     C     *LOVAL        SETLL     STDADSL2
     C     KAStdSet      CHAIN     STDADSL2                           01
 
     C                   IF        WStdAd  <> *BLanks
 
     C                   EVAL      UDIRECI = 'D'
     C                   EVAL      UDITYPE = 'I'
     C                   EVAL      UpdASSIFmt = PDepotI
 
     C                   IF        RecNotFound = True
     C                   WRITE     STDADSD0
     C                   ELSE
     C                   UPDATE    STDADSD0
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        ActionCode = 'A' AND RecNotFound = False
     C                   DELETE    STDADSD0
     C                   ENDIF
 
     C                   ENDIF
 
      ** Process Depot OUT record
      ** ========================
 
     C                   EVAL      Branch = UDOBCH
     C                   EVAL      Customer = UDOCUST
     C                   EVAL      Book = UDOBK
     C                   EVAL      Currency = UDOCCY
     C                   EVAL      Market = UDOMKT                                            CSE034
     C                   EVAL      InvType = UDOINV
     C                   EVAL      PortRef = UDOPREF
     C                   EVAL      DetType = 'O'
     C                   MOVE      PDepotO       WStdAd
 
     C     *LOVAL        SETLL     STDADSL2
     C     KAStdSet      CHAIN     STDADSL2                           01
 
     C                   IF        WStdAd  <> *BLanks
 
     C                   EVAL      UDORECI = 'D'
     C                   EVAL      UDOTYPE = 'O'
     C                   EVAL      UpdASSIFmt = PDepotO
 
     C                   IF        RecNotFound = True
     C                   WRITE     STDADSD0
     C                   ELSE
     C                   UPDATE    STDADSD0
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        ActionCode = 'A' AND RecNotFound = False
     C                   DELETE    STDADSD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return to calling program                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRReturn      BEGSR
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      RetCodeOut = PRetCode
     C                   ELSE
     C                   EVAL      RetCodeOut = *BLANKS
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Receive entry parameters.
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Action Code
      ** DS for file STDADSED (for Trade Purchase)
      ** DS for file STDADSED (for Trade Sale)
      ** DS for file STDADSED (for Depot In)
      ** DS for file STDADSED (for Depot Out)
 
     C                   PARM                    ActionCode
     C                   PARM                    PTradeP
     C                   PARM                    PTradeS
     C                   PARM                    PDepotI
     C                   PARM                    PDepotO
 
      ** Output Parameters
      ** -----------------
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
