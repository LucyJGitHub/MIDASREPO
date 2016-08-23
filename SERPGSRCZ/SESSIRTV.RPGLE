     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Retrieve SSI File Information')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESSIRTV - Retrieve SSI File Information                     *
      *                                                               *
      *  Function:  This module will be called by SESSISIN to get     *
      *             information from an existing standard settlement. *
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
      *                 CSE034             Date 22Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         No indicators used                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     -  Initial Processing                             *
      *  SRRetrieve -  Retrieve existing details                      *
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
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The following /COPY includes the MM standard declares:
 
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
 
      ** DS for trade purchase
     D PTradeP       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TP:2)
 
      ** DS for trade sale
     D PTradeS       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(TS:2)
 
      ** DS for depot in
     D PDepotI       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DI:2)
 
      ** DS for depot out
     D PDepotO       E DS                  EXTNAME(STDADSED)
     D                                     Prefix(DO:2)
 
      ** DS for customer/book standard settlement instruction
      **  to be passed to SESSIR0
     D PCBStd        E DS                  EXTNAME(STDSED)
     D                                     Prefix(ST)
     D                                     OCCURS(2)
 
      ** Data structure for standard additional settlement details
      ** for customer/book to be passed to SESSIR0
     D PCBStdAd      E DS                  EXTNAME(STDADSED)
     D                                     Prefix(AD:2)
     D                                     OCCURS(8)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Entry Parameter
     D PBranch         S              3A
     D PCustomer       S              6A
     D PKeySts         S              7A
     D PBook           S              2A
     D PCcy            S              3A
     D PMktCtr         S              2A                                                      CSE034
     D PInvType        S              3A
     D PPorRef         S              4A
 
     D POType          S              1A
     D PRetCode        S                   LIKE(ReturnCode)
     D PCBInd          S              1A
 
     D WCtr1           S              3P 0
 
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
 
      ** Retrieve existing details
 
     C                   EXSR      SRRetrieve
 
      **  Return
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
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
 
     C                   EVAL      WCtr1 = 0
     C                   EVAL      RetCodeOut = *BLANKS
 
     C                   CLEAR                   PCBStd
     C                   CLEAR                   PCBStdAd
     C                   CLEAR                   PTradeP
     C                   CLEAR                   PTradeS
     C                   CLEAR                   PDepotI
     C                   CLEAR                   PDepotO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRetrieve - Retrieve existing details                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C*******************CALL      'SESSIR0'                                                  CSE034
     C                   CALLB     'SESSIR0'                                                  CSE034
 
      ** Input Parameters
      ** ================
      ** Operation Type
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
 
     C                   PARM      'T'           POType
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
 
      ** Output Parameters
      ** =================
      ** Standard Settlement Instructions DS (Book/Customer)
      ** Standard Additional Settlement Details DS (Book/Customer)
      ** Return Code
 
     C                   PARM                    PCBStd
     C                   PARM                    PCBStdAd
     C                   PARM      *BLANKS       PRetCode
 
      ** Setup output parameters based on customer or book processing.
     C                   SELECT
 
      ** Customer
     C                   WHEN      PCBInd = 'C'
 
     C                   EVAL      WCtr1 = 5
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PTradeP = PCBStdAd
     C                   ENDDO
     C                   EVAL      WCtr1 = 6
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PTradeS = PCBStdAd
     C                   ENDDO
     C                   EVAL      WCtr1 = 7
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PDepotI = PCBStdAd
     C                   ENDDO
     C                   EVAL      WCtr1 = 8
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PDepotO = PCBStdAd
     C                   ENDDO
 
      ** Book
     C                   WHEN      PCBInd = 'B'
 
     C                   EVAL      WCtr1 = 1
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PTradeP = PCBStdAd
     C                   ENDDO
     C                   EVAL      WCtr1 = 2
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PTradeS = PCBStdAd
     C                   ENDDO
     C                   EVAL      WCtr1 = 3
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PDepotI = PCBStdAd
     C                   ENDDO
     C                   EVAL      WCtr1 = 4
     C                   DO
     C     WCtr1         OCCUR     PCBStdAd
     C                   EVAL      PDepotO = PCBStdAd
     C                   ENDDO
 
     C                   ENDSL
 
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
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book Indicator
 
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PCBInd
 
      ** Output Parameters
      ** -----------------
      ** Data Structure for Trade Purchase
      ** Data Structure for Trade Sale
      ** Data Structure for Depot In
      ** Data Structure for Depot Out
      ** Return code
 
     C                   PARM                    PTradeP
     C                   PARM                    PTradeS
     C                   PARM                    PDepotI
     C                   PARM                    PDepotO
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
