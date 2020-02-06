     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Repair')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXRPR - SD Customer Details by Country of Tax Input      *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243769             Date 27Jul06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 234227             Date 27Jun05               *
      *                 232543             Date 28Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  CER048 - German Features - Taxes                             *
      *  243769 - to supplement fix 234227                            *
      *  236137 - Change Control for CGL031                           *
      *  234227 - Add function to delete record/s if the Joint Account*
      *           Type has been changed from 'Y' to 'N'.              *
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
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD CCTX by Front Office ID
     FSDACTXL8  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Invalid CCTX by Timestamp and FOID - Retrieve
     FSDICCTXL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDICCTXD0:SDICCTXX0)
 
      ** Midas SD Invalid CCTX by Timestamp and FOID - Update
     FSDICCTXL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
 
      ** Valid Details for Update
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)
 
      ** Current Details in File Format
     D CrDlFilFmt    E DS                  EXTNAME(SDACTXPD)
 
      ** Current Detail in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
     D                                     PREFIX(Cr)
 
      ** Error Indicator File
     D OkFlags       E DS                  EXTNAME(SDECCTXPD)
 
      ** Second DS for Access Programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status data area
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
     D WkEi            S              1    DIM(60)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSard           S              6A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PCtrySel        S              2A
     D PCustno         S              6A
     D PProtect        S              1A
     D PRepair         S              1A
     D PRedisp         S              1A
     D PUpSfl          S              1A
     D PAction         S              1A                                                      234227
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Function Keys
     D PINKC           S              1A
     D PINKJ           S              1A                                                      234227
     D PINKL           S              1A
 
      ** Work Variables
     D E               S              3  0
     D F               S              3  0
     D WScrn           S              1A
     D WkRdNB          S              1A
 
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
 
      ** FO Transaction ID selected
     D PFOTranSel      S             20A
 
      ** Timestamp
     D PTmeStpSel      S             26Z
 
      ** Mode of Operation
     D***PModeOfOp       S              6A                                                    232543
     D PModeOfOp       S              6A   INZ('*RPR  ')                                      232543
     D PMode           S              7A                                                      CER059
 
     D KMsgType        S              8A
     D KFrntOffID      S                   LIKE(PFOTranSel)
     D KTimeStamp      S                   LIKE(PTmeStpSel)
 
      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   INZ('S')
 
      ** Substitution Characted
     D SubsChar        S              1A
 
      ** Incoming Data
     D IncDATA         S           2000A
 
      ** Current Data
     D CurDATA         S           2000A
 
      ** Fields for getting the starting field number from file (parameters
      ** to ZAGETFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('SDCCTXPD')
     D Field           S             10A   INZ('DDACTN')
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
 
      ** Update subfile record
 
     C                   IF        WScrn = 'A'
     C                   EXSR      SRUpSflR
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
      *                                                               *
      * SRBldBrw - Browse invalid details                             *
      *                                                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
 
      ** Reset Read Next Browse Subfile Record
 
     C                   EVAL      WkRdNb = *Blanks
 
      ** Build Browse subfile
 
     C                   CALLB     'SDCCTXRPB'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build sub-file
     C                   PARM      'Y'           PBdSfl
 
      ** Read subfile record
     C                   PARM      *BLANK        PRdSfl
 
      ** Error in update of previous record
     C                   PARM                    PErrUp
 
      ** Single Branch Code
     C                   PARM                    BJSBRC
 
      ** Midas Run Date
     C                   PARM                    BJMRDT
     C                   PARM                    CSC011
 
      ** Output Parameters
      ** =================
 
      ** Error Message
     C                   PARM      *BLANK        PErrMs
 
      ** Option Selected
     C                   PARM                    POpSel
 
      ** FO Transaction ID selected
     C                   PARM                    PFOTranSel
 
      ** Timestamp of Transaction selected
     C                   PARM                    PTmeStpSel
 
      ** Command keys
     C                   PARM      '0'           PINKC
 
      ** If error set on external switches
 
     C                   IF        PErrMs <> *Blanks
     C                   EVAL      *INU6 = *On
     C                   ENDIF
 
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
 
     C                   IF        PINKC = *On or PErrMs <> *Blanks
     C                   EXSR      SREndP
     C                   GOTO      ESRScrnB
     C                   ELSE
 
      ** Read next browse subfile record
 
     C                   EVAL      WkRdNb = 'Y'
     C                   EVAL      WScrn =  'R'
     C                   ENDIF
 
     C     ESRScrnB      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdNBrw - Read next browse subfile record                    *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'SDCCTXRPB'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build sub-file
     C                   PARM      *BLANK        PBdSfl
 
      ** Read subfile record
     C                   PARM      'Y'           PRdSfl
 
      ** Error in update of previous record
     C                   PARM                    PErrUp
 
      ** Single Branch Code
     C                   PARM                    BJSBRC
 
      ** Midas Run Date
     C                   PARM                    BJMRDT
     C                   PARM                    CSC011
 
      ** Output parameters
      ** =================
 
      ** Error message
     C                   PARM      *BLANK        PErrMs
 
      ** Option selected
     C                   PARM      *BLANK        POpSel
 
      ** FO Transaction ID selected
     C                   PARM      *BLANK        PFOTranSel
 
      ** Timestamp of Transaction selected
     C                   PARM                    PTmeStpSel
 
      ** Command keys
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
 
     C     ZATRNKX0      CHAIN     SDICCTXX0                          99
 
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
      *                                                               *
      * SRUpSflR - Update subfile record                              *
      *                                                               *
      *****************************************************************
     C     SRUpSflR      BEGSR
 
      ** Error found in validation
 
     C                   CALLB     'SDCCTXBRW'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build subfile
     C                   PARM      *BLANK        PBdSfl
 
      ** Read subfile record
     C                   PARM      *BLANK        PRdSfl
 
      ** Update subfile record
     C                   PARM      'Y'           PUpSfl
 
      ** Redisplay Indicator
     C                   PARM                    PRedisp
 
      ** Customer Number
     C                   PARM                    PCustNo
                                                                                              234227
      ** Action code                                                                          234227
     C                   PARM                    PAction                                      234227
 
      ** Action Code
     C                   PARM                    PProtect
 
      ** Repair Mode Indicator
     C                   PARM      'Y'           PRepair
 
      ** New Details in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Rundate
     C                   PARM                    BJMRDT
 
      ** Date Format Indicator
     C                   PARM                    BJDFIN
 
      ** Screen Error Indicator
     C                   PARM                    OkFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters
      ** =================
 
      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ                                        234227
     C                   PARM      '0'           PINKL
 
      ** Country Code Selected
     C                   PARM      *BLANK        PCtrySel
 
      ** New Details in Screen Format
     C                   PARM                    NwDlScnFmt
 
     C                   EVAL      WScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrnM- Process Screen: Main Details                         *
      *                                                               *
      *****************************************************************
     C     SRScrnM       BEGSR
 
      ** Enable/disable detail fields on main details screen
      ** if changes to the data are allowed
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'A')
 
     C                   IF        OKACTN <> 'Y' OR
     C                             OKCUST <> 'Y'
     C                   EVAL      PProtect = 'Y'
     C                   ELSE
     C                   EVAL      PProtect = 'N'
     C                   ENDIF
 
      ** Write/Read Display screen
 
     C                   CALLB     'SDCCTXBRW'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build subfile
     C                   PARM      'Y'           PBdSfl
 
      ** Read subfile record
     C                   PARM      *BLANK        PRdSfl
 
      ** Update subfile record
     C                   PARM      *BLANK        PUpSfl
 
      ** Redisplay Indicator
     C                   PARM                    PRedisp
 
      ** Customer Number
     C                   PARM                    PCustNo
                                                                                              243769
      ** Action code                                                                          243769
     C                   PARM                    PAction                                      243769
 
      ** Protect Indicator
     C                   PARM                    PProtect
 
      ** Repair Mode Indicator
     C                   PARM      'Y'           PRepair
 
      ** Current Details in Screen Format
     C                   PARM                    CrDlScnFmt
 
      ** Rundate
     C                   PARM                    BJMRDT
 
      ** Date Format Indicator
     C                   PARM                    BJDFIN
 
      ** Screen Error Indicator
     C                   PARM                    OkFlags
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Output Parameters
      ** =================
 
      ** Command Keys
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ                                        243769
     C                   PARM      '0'           PINKL
 
      ** Country Code Selected
     C                   PARM      *BLANK        PCtrySel
 
      ** New Details in Screen Format
     C                   PARM      *BLANK        NwDlScnFmt
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** Reset Redisplay Indicator
 
     C                   EVAL      PRedisp = 'N'
 
     C                   SELECT
 
      ** CK/3 - End Program
 
     C                   WHEN      PINKC = *On
     C                   EXSR      SREndP
 
      ** CK/12 - Cancel on Main details screen
 
     C                   WHEN      PINKL = *On
     C                   EXSR      SRCanM
 
      ** Validate input to main details screen only if option
      ** selected is amend, action code of transaction is not enquire
      ** and key fields are not in error (key fields = action code,
      ** & deal number).  Else, read records from the subfile or
      ** return to browse screen.
 
     C                   OTHER
 
     C                   IF        POpSel = 'U' AND
     C                             PCtrySel <> *BLANK
 
     C                   EXSR      SRValidate
 
     C                   ELSE
 
     C                   EXSR      SRCanM
 
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update File                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Update Records
 
     C                   CALLB     'SDCCTXUPD'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        PRTCD
                                                                                              CER059
      ** Mode                                                                                 CER059
     C                   PARM      *BLANK        PMode                                        CER059
                                                                                              243769
      ** Action Code                                                                          243769
     C                   PARM                    PAction                                      243769
                                                                                              243769
      ** Customer Number                                                                      243769
     C                   PARM                    PCustNo                                      243769
 
      ** New Details in File Format
     C                   PARM                    NwDlFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise delete the invalid MM Deal actioned & commit the updates
 
     C                   IF        PRTCD <> *Blanks
     C                   ROLBK
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C     ZATRNKD0      CHAIN     SDICCTXD0                          99
     C                   IF        *IN99 = *Off
     C                   DELETE    SDICCTXD0
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDCCTX'
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
      *                                                               *
      * SRVFrnt - Validation for Front Office Record Interface        *
      *                                                               *
      *****************************************************************
     C     SRVFrnt       BEGSR
 
     C                   EVAL      Idx = 0
 
      ** Error if Front Office Transaction ID is blank
 
     C                   IF        PFOTranSel = *BLANK
     C                   EVAL      OKACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0101'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C     EVFRNT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve - Retrieve Detail                                  *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C                   EVAL      CrDDACTN = DDACTN
     C                   EVAL      CrDDCUST = DDCUST
     C                   EVAL      CrDDCTTX = DDCTTX
     C                   EVAL      CrDDETXS = DDETXS
     C                   EVAL      CrDDCERF = DDCERF
     C                   EVAL      CrDDCEEX = DDCEEX
     C                   EVAL      CrDDCSTS = DDCSTS                                          236137
 
     C                   EVAL      PCustNo = DDCUST
      *                                                                                       CER048
      ** Populate Certificate type,Approval date,Value date                                   CER048
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
      *                                                               *
      * SRCanM - Cancel on Main Details Screen                        *
      *                                                               *
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
      *                                                               *
      * SRSndM - Send a message to main details screen                *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
     C                   Z-ADD     Idx           E
 
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
 
     C                   IF        OKACTN = 'N'
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
 
     C                   DOW       *IN99 = *Off and
     C                             ABFIELDID > FldOffSet
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
     C                   IF        *IN98 = *Off
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
      *                                                               *
      * SRValidate - Validate Details                                 *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Initialize error indicators and clear details in file format
 
     C                   Z-ADD     *ZERO         Idx
     C                   MOVE      *ALL'Y'       OkFlags
     C                   CLEAR                   NwDlFilFmt
 
     C                   EVAL      CTCUST = DDCUST
     C                   EVAL      CTCTTX = DDCTTX
 
      ** Validate record details
 
     C                   CALLB     'SDCCTXVAL'
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PModeOfOp
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    PRespMode
 
      ** New Details in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Date Format Indicator
     C                   PARM                    BJDFIN
 
      ** Rundate
     C                   PARM                    BJRDNB
 
      ** Output Parameters
      ** =================
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      ** Screen error indicators
     C                   PARM                    OkFlags
 
      ** New Details in File Format
     C                   PARM                    NwDlFilFmt
 
     C                   IF        Idx <> 0
     C                   EVAL      PRedisp = 'Y'
     C                   EVAL      WScrn = 'A'
     C                   ELSE
     C                   EVAL      CTFRNT = PFOTranSel
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubsDta  - Transaction Details Data Substitution            *
      *                                                               *
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
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 002
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
     C                   EVAL      CER048 = 'N'                                               CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
      ** Database error                                                                       CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
      *                                                                                       CER048
     C                   IN        LDA                                                        CER048
     C                   EVAL      DBKey = 'CER048'                                           CER048
     C                   EVAL      DBFile = 'SCSARDPD'                                        CER048
     C                   EVAL      DBase = 003                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
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
 
     C                   IF        ReturnCode = *blank
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
