     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Display Additional SSI for SWIFT')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESSIDSP - Display Additional SSI for SWIFT                  *
      *                                                               *
      *  Function:  This module will be called by SESSISIN to know    *
      *             if trades, depots or both will have their         *
      *             extended settlements displayed or maintained.     *
      *                                                               *
      *  Component of: SESSISIN - Standard Settlement Additional      *
      *                           Information                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01.01 ----------------------------------------*
      *  Prev Amend No. CSW202             Date 20May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE034             Date 30Apr02               *
      *                 203368             Date 26Feb02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028  *CREATE    Date 06Jun01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSE034 - Standard Settlement Instruction improvements        *
      *  203368 - Field 'To be used for Depot Movement' erroneously   *
      *           defaulted to 'N' even if value exist on file.       *
      *  CSE028  -  Standing Settlement Instructions Enhancement      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Record not found                                *
      *                                                               *
      *    20         Error on ISO15022 message                       *
      *    21         Error on 'To be used for Depot Movement'        *
      *    22         Error on 'Purchase'                             *
      *    23         Error on 'Sale'                                 *
      *    24         Error on 'Depot IN'                             *
      *    25         Error on 'Depot OUT'                            *
      *                                                               *
      *    50         Display customer (if off, display book)         *
      *    51         Display ISO15022 message field                  *
      *    52         Protect fields                                  *
      *    53         Display portfolio reference                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit     -  Initial Processing                             *
      *  SRSetScnFld-  Set-up display fields                          *
      *  SRDisplay  -  Display additional SSI for swift               *
      *  SRValidate -  Validate screen fields                         *
      *  SRTrade    -  SR to call 'SETSSIDSP'                         *
      *  SRDepot    -  SR to call 'SEDSSIDSP'                         *
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
 
     FSESSIDSDF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
 
     D/COPY ZACPYSRC,MSGHNDDCL
 
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
 
     D/COPY ZACPYSRC,APICTLARR
 
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
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  DspCustomer           50     50
     D  DspISOInd             51     51
     D  PrtFlds               52     52
     D  DspPortF              53     53
 
     D WInzIndArr      S              1    DIM(6) CTDATA PERRCD(6)
     D WInzOkFlag      S              1    DIM(6) CTDATA PERRCD(6)
 
     D WErrIndArr      S              1    DIM(6)
 
      ** OK Flags
     D OkFlags         DS             6
     D  ISOIOK                 1      1
     D  ToDpMvOK               2      2
     D  PuchOK                 3      3
     D  SaleOk                 4      4
     D  DepIOK                 5      5
     D  DepOOK                 6      6
 
      ** DS for additional settlement details screen definition
     D PSetDetS        DS             6
     D  ISOMsg                 1      1
     D  ForDpM                 2      2
     D  TradeP                 3      3
     D  TradeS                 4      4
     D  DepotI                 5      5
     D  DepotO                 6      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Entry Parameter
     D PBranch         S              3A
     D PCustomer       S              6A
     D*PCustNum*       S              6S 0                                                    CSD027
     D PCustKey        S             10A
     D PKeySts         S              7A
     D PBook           S              2A
     D PCcy            S              3A
     D PMktCtr         S              2A                                                      CSE034
     D PInvType        S              3A
     D PPorRef         S              4A
     D PDescrptn       S             20A
     D PBJMRDT         S              7A
     D PBGPFMG         S              1A
     D PBGN4ST         S              1A
 
     D PMode           S              1A
     D POType          S              1A
     D PRetCode        S                   LIKE(ReturnCode)
     D PCBInd          S              1A
 
     D PCSE029         S              1A
     D PBFCLAS         S              1A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WCtr1           S              3P 0
     D WCtr2           S              3P 0
                                                                                              CSW202
     D CSW202          S              1A                                                      CSW202
     D PRtCd           S              7A                                                      CSW202
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
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
 
      ** Do while screen: Main Details
 
     C                   DOW       PMode = 'D'
     C                   EXSR      SRDisplay
     C                   ENDDO
 
      ** Do while update
 
     C                   DOW       PMode = 'U'
     C                   EXSR      SRUpdate
     C                   ENDDO
 
      **  Return
 
     C                   IF        PMode = 'R'
     C                   EXSR      SRReturn
     C                   ENDIF
 
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
 
      ** Condition display/non-display of customer or book field,
      ** only one field should appear
 
     C                   IF        PCBInd = 'C'
     C                   EVAL      DspCustomer = True
     C                   ELSE
     C                   EVAL      DspCustomer = False
     C                   ENDIF
 
      ** Condition display/non-diplay of "Portfolio" field
 
     C                   IF        PBGPFMG = 'Y' OR PBGN4ST = 'Y'
     C                   EVAL      DspPortF = True
     C                   ELSE
     C                   EVAL      DspPortF = False
     C                   ENDIF
 
     C                   EVAL      #1BRCH = PBranch
     C                   EVAL      #1CUST = PCustomer
     C                   EVAL      #1BOOK = PBook
     C                   EVAL      #1DESC = PDescrptn
     C                   EVAL      #1CCY  = PCcy
     C                   EVAL      #1MKCT = PMktCtr                                           CSE034
     C                   EVAL      #1INVT = PInvType
     C                   EVAL      #1PORF = PPorRef
     C                   EVAL      PRetCode = *BLANKS
 
     C                   EXSR      SRSetScnFld
 
     C                   EVAL      PMode = 'D'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetScnFld - Set-up display fields                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRSetScnFld   BEGSR
                                                                                              CSW202
      ** Do not display 'ISO15022 message' field if CSW202 is installed                       CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
                                                                                              CSW202
     C                   EVAL      DspISOInd = False                                          CSW202
     C                   EVAL      #1ISOM = *BLANKS                                           CSW202
                                                                                              CSW202
     C                   ELSE                                                                 CSW202
 
      ** Condition display/non-diplay of 'ISO15022 messsage'
 
     C                   IF        PCSE029 = 'Y' AND PBFCLAS = 'M' OR
     C                             PCSE029 = 'Y' AND PBFCLAS = 'S' OR
     C                             PCSE029 = 'Y' AND PBFCLAS = 'D'
 
     C                   EVAL      DspISOInd = True
 
     C                   IF        ISOMsg = *BLANKS
     C                   EVAL      #1ISOM = 'Y'
     C                   ELSE
     C                   EVAL      #1ISOM = ISOMsg
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      DspISOInd = False
     C                   EVAL      #1ISOM = *BLANKS
 
     C                   ENDIF
 
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        ActionCode = 'E'
     C                   EVAL      PrtFlds = True
     C                   ELSE
     C                   EVAL      PrtFlds = False
     C                   ENDIF
 
     C                   IF        ForDpM = *BLANKS                                           203368
     C                   EVAL      #1EXST = 'N'
     C                   ELSE                                                                 203368
     C                   EVAL      #1EXST = ForDpM                                            203368
     C                   ENDIF                                                                203368
     C                   EVAL      #1TRDP = 'N'
     C                   EVAL      #1TRDS = 'N'
     C                   EVAL      #1DPTI = 'N'
     C                   EVAL      #1DPTO = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display additional SSI for swift                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRDisplay     BEGSR
 
      ** Move 'OK' flags into array for checking
 
     C                   MOVEA     OkFlags       WErrIndArr
 
      ** Set screen error indicators according to status of 'OK' flags
 
 
     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     20            WCtr2
 
     C                   DOU       WCtr1 > 6
     C                   IF        WErrIndArr(WCtr1) = 'N' OR
     C                             WErrIndArr(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   ENDIF
 
     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1
     C                   ENDDO
 
      ** The following /COPY line includes processing for the error and
      ** warning messages.
 
      /COPY ZACPYSRC,MSGHNDDSP1
 
      ** Write message subfile, details and footer screen
 
     C                   WRITE     SESSIDSF2
     C                   WRITE     SESSIDSC1
     C                   WRITE     SESSIDSF1
 
      ** Read details screen
 
     C                   READ      SESSIDSF1
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Reset error fields
 
     C                   EVAL      Idx = 0
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
 
      ** Set screen error indicators off
 
     C                   MOVEA     WInzIndArr    *IN(20)
     C                   MOVEA     WInzOkFlag    OkFlags
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = *ON
     C                   EVAL      PRetCode = 'SE10000'
     C                   EVAL      PMode = 'R'
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = *ON
     C                   EVAL      PRetCode = 'SE10001'
     C                   EVAL      PMode = 'R'
 
      ** F5 Pressed
 
     C                   WHEN      *INKE = *ON
     C                   EXSR      SRSetScnFld
 
     C                   OTHER
 
      ** Validate inputs
 
     C                   EXSR      SRValidate
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValidate - Validate screen fields                          *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** If CSE029 is installed set ISO15022 message flag to 'Y' otherwise to 'N'             CSW202
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   IF        PCSE029 = 'Y'                                              CSW202
     C                   EVAL      #1ISOM = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      #1ISOM = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
      ** Valid value for all input fields are 'Y' or 'N'
 
      ** Validate 'ISO15022 message'
 
     C                   IF        DspISOInd = True
 
     C                   IF        #1ISOM = *BLANK
     C                   EVAL      #1ISOM = 'N'
     C                   ENDIF
 
     C                   IF        #1ISOM <> 'Y' AND #1ISOM <> 'N'
     C                   EVAL      ISOIOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1ISOM'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate 'To be used for depot movement'
 
     C                   IF        #1EXST = *BLANK
     C                   EVAL      #1EXST = 'N'
     C                   ENDIF
 
     C                   IF        #1EXST <> 'Y' AND #1EXST <> 'N'
     C                   EVAL      ToDpMvOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1EXST'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF
 
      ** Validate 'To be used for trade purchase'
 
     C                   IF        #1TRDP = *BLANK
     C                   EVAL      #1TRDP = 'N'
     C                   ENDIF
 
     C                   IF        #1TRDP <> 'Y' AND #1TRDP <> 'N'
     C                   EVAL      PuchOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1TRDP'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF
 
      ** Validate 'To be used for trade sale'
 
     C                   IF        #1TRDS = *BLANK
     C                   EVAL      #1TRDS = 'N'
     C                   ENDIF
 
     C                   IF        #1TRDS <> 'Y' AND #1TRDS <> 'N'
     C                   EVAL      SaleOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1TRDS'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF
 
      ** Validate 'To be used for depot in'
 
     C                   IF        #1DPTI = *BLANK
     C                   EVAL      #1DPTI = 'N'
     C                   ENDIF
 
     C                   IF        #1DPTI <> 'Y' AND #1DPTI <> 'N'
     C                   EVAL      DepIOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1DPTI'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF
 
      ** Validate 'To be used for depot out'
 
     C                   IF        #1DPTO = *BLANK
     C                   EVAL      #1DPTO = 'N'
     C                   ENDIF
 
     C                   IF        #1DPTO <> 'Y' AND #1DPTO <> 'N'
     C                   EVAL      DepOOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '#1DPTO'
     C                   EVAL      MsgIdArr(Idx) = 'FXM0102'
     C                   ENDIF
 
 
     C                   IF        Idx = 0
     C                   EVAL      PMode = 'U'
     C                   ELSE
     C                   EVAL      PMode = 'D'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update additional standard settlement instructions*
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      ISOMsg = #1ISOM
     C                   EVAL      ForDpm = #1EXST
     C                   EVAL      TradeP = #1TRDP
     C                   EVAL      TradeS = #1TRDS
     C                   EVAL      DepotI = #1DPTI
     C                   EVAL      DepotO = #1DPTO
     C                   EVAL      PMode = 'R'
 
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
 
     C                   EVAL      RetCodeOut = PRetCode
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
 
     C/COPY ZACPYSRC,MSGHNDDSP2
 
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
      ** Branch
      ** Customer
      ** Book Code
      ** Currency
      ** Market Centre                                                                        CSE034
      ** Investment Type
      ** Portfolio Reference
      ** Customer/Book description
      ** Customer Classification
      ** CSE029 SAR
      ** Customer/Book indicator
 
     C                   PARM                    ActionCode
     C                   PARM                    PBranch
     C                   PARM                    PCustomer
     C                   PARM                    PBook
     C                   PARM                    PCcy
     C                   PARM                    PMktCtr                                      CSE034
     C                   PARM                    PInvType
     C                   PARM                    PPorRef
     C                   PARM                    PDescrptn
     C                   PARM                    PBFCLAS
     C                   PARM                    PCSE029
     C                   PARM                    PCBInd
 
      ** SDBANKPD
      ** ========
      ** Rundate
 
     C                   PARM                    PBJMRDT
 
      ** SDMMODPD
      ** ========
      ** Portfolio Management
      ** Private Banking
 
     C                   PARM                    PBGPFMG
     C                   PARM                    PBGN4ST
 
      ** Input-Output Parameters
      ** -----------------------
      ** Data Structure for additional settlement details screen definition
 
     C                   PARM                    PSetDetS
 
      ** Output Parameters
      ** -----------------
      ** Return code
 
     C                   PARM                    RetCodeOut
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WID  = PsJobName
     C                   EVAL      #1DATE = PBJMRDT
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Set up the prime and secondary message files for
      ** finding message IDs.
 
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Message subfile control
 
     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #1PGMQ = '*'
                                                                                              CSW202
      ** Check if CSW202 is switched on                                                       CSW202
                                                                                              CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRtCd                                        CSW202
                                                                                              CSW202
     C                   IF        PRtCd = 'CSW2002'                                          CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ENDIF                                                                CSW202
 
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
** WInzIndArr
000000
** WInzOkFlag
YYYYYY
