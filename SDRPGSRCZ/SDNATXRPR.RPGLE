     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-A/c Holder by Country of Tax Rpr')        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNATXRPR - SD Non-a/c Holders by Country of Tax Input       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 233295             Date 29Apr05               *
      *                 232543             Date 14Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Feauters - Taxes                             *
      *  236137 - Change Control for CGL031                           *
      *  233295 - Deletion problems on Non-account Holders.           *
      *  232543 - Fix to CGL032                                       *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL0IF   E           K Disk    Infsr(*PSSR)
 
      ** Midas SD NATX by Front Office ID
     FSDNHTXL3  IF   E           K Disk    Infsr(*PSSR)
     F                                     Rename(SDNHTXD0:NHTXFOID)
 
      ** Midas SD Invalid NATX by Timestamp and FOID - Retrieve
     FSDINATXL0 IF   E           K Disk    Infsr(*PSSR)
     F                                     Rename(SDINATXD0:SDINATXX0)
 
      ** Midas SD Invalid NATX by Timestamp and FOID - Update
     FSDINATXL1 UF   E           K Disk    Infsr(*PSSR)
     F                                     Commit
 
      ** API Invalid Log File from Support Database
 
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
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
 
      ** External DS for bank details
     D SDBANK        E DS                  Extname(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  Extname(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  Extname(DSFDY)
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  Extname(SDNATXPD)
 
      ** Valid Details for Update
     D NwDlFilFmt    E DS                  Extname(SDVNATXPD)
 
      ** Current Details in File Format
     D CrDlFilFmt    E DS                  Extname(SDNHTXPD)
 
      ** Current Detail in Screen Format
     D CrDlScnFmt    E DS                  Extname(SDNATXPD)
     D                                     Prefix(Cr)
 
      ** Error Indicator File
     D OkFlags       E DS                  Extname(SDENATXPD)
 
      ** Second DS for Access Programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
     D WkEi            S              1    Dim(60)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSard           S              6A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PUpSfl          S              1A
     D PProtect        S              1A
     D PRepair         S              1A
     D PRedisp         S              1A
     D PRdNxBr         S              1A
     D PActCde         S              1A                                                      233295
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Function Keys
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKL           S              1A
 
      ** Work Variables
     D E               S              3  0
     D F               S              3  0
     D WScrn           S              1A
     D WkRdNB          S              1A
     D WInitErr        S              1A
 
      ** Build subfle indicator
     D PBdSfl          S              1A
 
      ** Read subfile record
     D PRdSfl          S              1A
 
      ** Error in update of previous deal
     D PErrUp          S              1A
 
      ** Error message
     D PErrMs          S              7A
 
      ** Option Selected
     D POpSel          S              1A
 
      ** Action Selected
      ** EDWIN
     D PAcSel          S              1A
 
      ** FO Transaction ID selected
     D PFOTranSel      S             20A
 
      ** Timestamp
     D PTmeStpSel      S             26Z
 
      ** Mode of Operation
     D***PModeOfOp       S              6A                                                    232543
     D PModeOfOp       S              6A   INZ('*RPR  ')                                      232543
 
     D KMsgType        S              8A
     D KFrntOffID      S                   LIKE(PFOTranSel)
     D KTimeStamp      S                   LIKE(PTmeStpSel)
 
      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   INZ('S')
 
      ** Substitution Character
     D SubsChar        S              1A
 
      ** Incoming Data
     D IncDATA         S           2000A
 
      ** Current Data
     D CurDATA         S           2000A
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   Inz('SDNATXPD')
     D Field           S             10A   Inz('DDACTN')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
     D CSC011          S              1A
     D CER048          S              1A                                                      CER048
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Do screen: Browse Invalid Deals
 
     C                   IF        WScrn = 'B'
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      ** Read Next Browse Subfile record
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      ** Do while screen: Main Details
 
     C                   DOW       WScrn = 'M'
     C                   EXSR      SRScrnM
     C                   ENDDO
 
      ** Do file updates
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *On
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBldBrw - Browse invalid details                             *
      *****************************************************************
     C     SRBldBrw      BEGSR
 
      ** Reset Read Next Browse Subfile Record
 
     C                   EVAL      WkRdNb = *Blanks
 
      ** Build Browse subfile
 
     C                   CALLB     'SDNATXRPB'
 
      * Input Parameters :
 
      ** Return Code
      ** Build sub-file
      ** Read subfile record
      ** Error in update of previous record
      ** Single Branch Code
      ** Midas Run Date
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *Blanks       PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    BJSBRC
     C                   PARM                    BJMRDT
     C                   PARM                    CSC011
 
      * Output Parameters :
 
      ** Error Message
      ** Option Selected
      ** Action selected
      ** FO Transaction ID selected
      ** Timestamp of Transaction selected
      ** Command keys
     C                   PARM      *Blanks       PErrMs
     C                   PARM                    POpSel
     C                   PARM                    PAcSel
     C                   PARM                    PFOTranSel
     C                   PARM                    PTmeStpSel
     C                   PARM      '0'           PINKC
 
      ** If error set on external switches
 
     C                   IF        PErrMs <> *Blanks
     C                   EVAL      *INU6 = *ON
     C                   ENDIF
 
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
 
     C                   IF        PINKC = *On or PErrMs <> *Blanks
     C                   EXSR      SREndP
     C                   ELSE
 
      ** Read next browse subfile record
 
     C                   EVAL      WkRdNb = 'Y'
     C                   EVAL      WScrn =  'R'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRdNBrw - Read next browse subfile record                    *
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'SDNATXRPB'
 
      * Input Parameters :
 
      ** Return Code
      ** Build sub-file
      ** Read subfile record
      ** Error in update of previous record
      ** Single Branch Code
      ** Midas Run Date
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM      *Blanks       PBdSfl
     C                   PARM      'Y'           PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    BJSBRC
     C                   PARM                    BJMRDT
     C                   PARM                    CSC011
 
      * Output parameters :
 
      ** Error message
      ** Option selected
      ** Action selected
      ** FO Transaction ID selected
      ** Timestamp of Transaction selected
      ** Command keys
     C                   PARM      *Blanks       PErrMs
     C                   PARM      *Blanks       POpSel
     C                   PARM      *Blanks       PAcSel
     C                   PARM      *Blanks       PFOTranSel
     C                   PARM                    PTmeStpSel
     C                   PARM      '0'           PINKC
 
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
 
     C                   IF        PINKC = *On
     C                   EXSR      SREndP
     C                   GOTO      ESRRdNBrw
     C                   ENDIF
 
      ** If invalid record read from subfile
 
     C                   IF        POpSel <> *Blanks
 
      ** Blank the main details screen
 
     C                   EVAL      NwDlScnFmt = *Blanks
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** Retrieve record details
 
     C     ZATRNKX0      CHAIN     SDINATXX0                          99
 
      ** Validate front office record interface
 
     C                   EXSR      SRVFrnt
 
     C                   EXSR      SRRetrieve
 
      ** Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *Blanks
 
     C     GHSUBS        SCAN      NwDlScnFmt                             99
     C                   IF        *IN99 = *ON
     C                   EXSR      SRSubsDta
     C                   ENDIF
 
     C                   ENDIF
 
      ** Send the deals error messages to the main details screen
 
     C                   EXSR      SRSndM
 
      ** Go to main details screen
 
     C                   EVAL      WScrn = 'M'
 
      ** Else if no invalid deal read from subfile
 
     C                   ELSE
 
      ** Go to browse screen
 
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C     ESRRdNBrw     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRScrnM- Process Screen: Main Details                         *
      *****************************************************************
     C     SRScrnM       BEGSR
 
      ** Enable/disable detail fields on main details screen
      ** if changes to the data are allowed
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'A')
 
     C                   IF        DDACTN = 'A' AND
     C                             POpSel = 'U' AND
     C                             WInitErr <> 'Y'
     C                   EVAL      PProtect = 'N'
     C                   ELSE
     C                   EVAL      PProtect = 'Y'
     C                   ENDIF
 
      ** Write/Read Display screen
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-A/C Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDNAHO
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *Blanks       PRdSfl
     C                   PARM      *Blanks       PUpSfl
     C                   PARM      'Y'           PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** New Details in Screen Format
      ** Error Flags
      ** Read Next Subfile Record - not used
      ** Country Code Selected
      ** Command Keys
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM      *Blanks       PRdNxBr
     C                   PARM                    DDCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
 
      ** CK/12 - Cancel on Main details screen
 
     C                   WHEN      PINKL = *ON
     C                   EXSR      SRCanM
 
      ** Validate input to main details screen only if option
      ** selected is amend, action code of transaction is not enquire
      ** and key fields are not in error (key fields = action code,
      ** & deal number).  Else, read records from the subfile or
      ** return to browse screen.
 
     C                   OTHER
 
     C                   IF        POpSel = 'U'
 
     C                   IF        WInitErr = 'N'
     C                   EXSR      SRRtvFlDtl
     C                   EXSR      SRValM
     C                   ELSE
     C                   EXSR      SRVFrnt
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ELSE
     C                   EXSR      SRCanM
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdate - Update File                                        *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Update Records
 
     C                   CALLB     'SDNATXUPD'
 
      * Input Parameters :
 
      ** Return Code
      ** Action Code                                                                          233295
      ** New Details in File Format
     C                   PARM      *Blanks       PRTCD
     C                   PARM                    PActCde                                      233295
     C                   PARM                    NwDlFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise commit the updates
 
     C                   IF        PRTCD <> *Blanks
     C                   ROLBK
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C     ZATRNKD0      CHAIN     SDINATXD0                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SDINATXD0
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDNATX'
     C                   EVAL      KFrntOffID = PFOTRANSEL
     C                   EVAL      KTimeStamp = PTMESTPSEL
 
     C     KAPILOGL0     CHAIN     APILOGL0                           99
     C                   IF        *IN99 = *OFF
     C                   DELETE    APILOGL0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   COMMIT
     C                   ENDIF
 
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
 
     C                   IF        PRTCD = '*RECUPD'
     C                   EVAL      PErrUp = 'Y'
     C                   ELSE
     C                   EVAL      PErrUp = 'N'
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WkRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** else, return to the browse screen
 
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRtvFlDtl - Retrieve File Detail                             *
      *****************************************************************
     C     SRRtvFlDtl    BEGSR
      * insert call to sdnatxbrw to readc on subfile
 
     C                   CALLB     'SDNATXBRW'
 
      * Input Parameters :
 
      ** Return Code
      ** Non-A/C Holder
      ** Build subfile
      ** Read subfile record
      ** Update subfile record
      ** Repair Mode Indicator
      ** Protect Fields
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    DDNAHO
     C                   PARM      *Blanks       PBdSfl
     C                   PARM      'Y'           PRdSfl
     C                   PARM      *Blanks       PUpSfl
     C                   PARM      'Y'           PRepair
     C                   PARM                    PProtect
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      * Output Parameters :
 
      ** New Details in Screen Format
      ** Error Flags
      ** Read Next Subfile Record - not used
      ** Country Code Selected
      ** Command Keys
     C                   PARM                    NwDlScnFmt
     C                   PARM                    OkFlags
     C                   PARM      *Blanks       PRdNxBr
     C                   PARM                    DDCTTX
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKE
     C                   PARM      '0'           PINKL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVFrnt - Validation for Front Office Record Interface        *
      *****************************************************************
     C     SRVFrnt       BEGSR
 
     C                   EVAL      Idx = 0
     C                   EVAL      WInitErr = 'N'
 
      ** Error if Front Office Transaction ID is blank
 
     C                   IF        PFOTranSel = *Blanks
     C                   EVAL      OkACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0101'
     C                   EVAL      WInitErr = 'Y'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRetrieve - Retrieve Detail                                  *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C                   EVAL      CrDDACTN = DDACTN
     C                   EVAL      CrDDNAHO = DDNAHO
     C                   EVAL      CrDDCTTX = DDCTTX
     C                   EVAL      CrDDETXS = DDETXS
     C                   EVAL      CrDDCERF = DDCERF
     C                   EVAL      CrDDCEEX = DDCEEX
     C                   EVAL      CrDDNSTS = DDNSTS                                          236137
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EVAL      CrDDCRTP = DDCRTP                                          CER048
     C                   EVAL      CrDDCADT = DDCADT                                          CER048
     C                   EVAL      CrDDCVDT = DDCVDT                                          CER048
     C                   ENDIF                                                                CER048
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanC - Cancel on Confirmation Screen                        *
      *****************************************************************
     C     SRCanC        BEGSR
 
      ** Return to main details screen
 
     C                   EVAL      WScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRExit - Exit From Confirmation Screen                        *
      *****************************************************************
     C     SRExit        BEGSR
 
      ** If no errors in validation
 
     C                   IF        Idx = *Zeros
 
      ** Continue with updates
 
     C                   EVAL      WScrn = 'U'
 
      ** Else, Return to main details screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCanM - Cancel on Main Details Screen                        *
      *****************************************************************
     C     SRCanM        BEGSR
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WkRdNb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** Else, return to the browse screen
 
     C                   EVAL      WScrn = 'B'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSndM - Send a message to main details screen                *
      *****************************************************************
     C     SRSndM        BEGSR
 
     C                   Z-ADD     Idx           E
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C                   IF        OkACTN = 'N'
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = 'APM0110'
     C                   ENDIF
 
      ** Initialize error indicators
 
     C                   MOVEA     OkFlags       WkEI
 
      ** Read error messages for deal
 
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
 
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
 
     C                   DOW       *IN99 = *OFF and
     C                             ABFIELDID > FldOffSet
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
     C                   IF        *IN98 = *OFF
     C                   ADD       1             E
     C                   EVAL      FldNameArr(E) = ABFIELDNAM
     C                   EVAL      MsgIdArr(E) = ABMSGID
     C                   ENDIF
 
     C                   Z-ADD     ABFIELDID     F
     C                   SUB       FldOffset     F
     C                   IF        F < 1 or F > 60
     C                   Z-ADD     1             F
     C                   ENDIF
 
     C                   EVAL      WkEI(F) = 'N'
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     WkEI          OkFlags
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRValM - Validate input to main details screen                *
      *****************************************************************
     C     SRValM        BEGSR
 
      ** Initialize error indicators and clear details in file format
 
     C                   Z-ADD     *Zeros        Idx
     C                   MOVE      *All'Y'       OkFlags
     C                   CLEAR                   NwDlFilFmt
 
      ** Save Current Format from Retrieve
 
     C                   EVAL      NwDlFilFmt = CrDlFilFmt
 
      ** Validate record details
 
     C                   CALLB     'SDNATXVAL'
 
      * Input Parameters :
 
      ** Return Code
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      ** New Details in Screen Format
     C                   PARM      *Blanks       RetCodeOut
     C                   PARM                    PModeOfOp
     C                   PARM                    PRespMode
     C                   PARM                    NwDlScnFmt
 
      * Output Parameters :
 
      ** Error Flags
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** New Details in File Format
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    NwDlFilFmt
 
     C                   IF        Idx = 0
     C                   EVAL      WScrn = 'U'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSubsDta  - Transaction Details Data Substitution            *
      *****************************************************************
     C     SRSubsDta     BEGSR
 
     C                   RESET                   ReturnCode
     C                   CALLB     'APDTASUBS'
 
      ** Data Substitution
 
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      NwDlScnFmt    IncDATA
     C                   PARM      CrDlScnfmt    CurDATA
 
     C                   MOVEL     IncDATA       NwDlScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndP - End Program                                          *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR
 
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgDtaArr = *Blanks
     C                   EVAL      MsgIdArr = *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if switchable feature CSC011 is switched on.
 
     C                   EVAL      CSC011 = 'N'
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database error
 
     C                   IF        (PRtCd <> *BLANKS) and
     C                             (PRtCd <> '*NRF   ')
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 905
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   OPEN      APILOGL0
     C                   IN        SDSTAT
     C                   IN        SC24X7
     C                   ENDIF
      *                                                                                       CER048
      ** Check if CER048 is installed                                                         CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtCd <> *BLANKS AND                                       CER048
     C                             PRtCd <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 906                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
 
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
 
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTmeStpSel
     C                   KFLD                    PFOTranSel
 
      ** Get the field number for the action code field; the screen fields
      ** start from that number.  Subtract one from it to give the value
      ** to subtract from each field's number.
 
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      FldOffset = FieldNo - 1
 
      ** If there was an error default the offset to 13
 
     C                   ELSE
     C                   EVAL      FldOffset = 13
     C                   ENDIF
 
      ** Start on Browse Screen
 
     C                   EVAL      WScrn = 'B'
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ********************************************************************
      *
**  CPY@
(c) Finastra International Limited 2004
