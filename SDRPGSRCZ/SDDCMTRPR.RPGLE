     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Document Management Repair')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDDCMTRPR - SD Document Management Repair                    *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CSD100             Date 17Aug17               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CSD093  *CREATE    Date 01Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD100 - Patronymic and Gender fields for Non-Account Holder *
      *           (Recompile)                                         *      
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD DCMT by Front Office ID
     FSDDCMTL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDCMTD0:DCMTFOID)
 
      ** Midas SD Invalid DCMT by Timestamp and FOID - Retrieve
     FSDIDCMTL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIDCMTD0:SDIDCMTX0)
 
      ** Midas SD Invalid DCMT by Timestamp and FOID - Update
     FSDIDCMTL1 UF   E           K DISK    INFSR(*PSSR)
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
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Non-Account Holder Details
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** External DS for Document Code Details
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for API ICD
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** New Details in Screen Format
     D NwDcScnFmt    E DS                  EXTNAME(SDDCMSPD)
 
      ** Valid Details for Update
     D NwDcFilFmt    E DS                  EXTNAME(SDVDCMTPD)
 
      ** Current Details in File Format
     D CrDcFilFmt    E DS                  EXTNAME(SDDCMTPD)
 
      ** Current Detail in Screen Format
     D CrDcScnfmt    E DS                  EXTNAME(SDDCMSPD)
     D                                     PREFIX(Cr)
 
      ** Error Indicator File
     D OkFlags       E DS                  EXTNAME(SDEDCMTPD)
 
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
     D PUpSfl          S              1A
     D PProtect        S              1A
     D PRepair         S              1A
     D PRedisp         S              1A
     D PRdNxBr         S              1A
     D PCUSN           S             10A
     D PRTYP           S              1A
     D PCODE           S              2A
     D OKACTN          S              1A
     D PRefDet         S              1A
     D PDocmDt         S              1A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Function Keys
     D PEDTFD          S              1A
     D PEINKJ          S              1A
     D PEINKV          S              1A
     D PEKYFD          S              1A
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKI           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKV           S              1A
     D PRMRDT          S              7A
     D PRSBRC          S              3A
 
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
     D PTmeStpSel      S             26A
     D KTimeStamp      S             26Z
 
      ** Mode of Operation
     D PModeOfOp       S              6A
 
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
     D Format          S             10A   Inz('SDDCMSPD')
     D Field           S             10A   Inz('DDACTN')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
     D PINTYP          S              1A
     D PINMOD          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
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
     C                   EXSR      SRRtvDt
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
 
     C                   CALLB     'SDDCMTRPB'
 
      * Input Parameters :
 
      ** Return Code
      ** Build sub-file
      ** Read subfile record
      ** Error in update of previous record
      ** Single Branch Code
      ** Midas Run Date
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'Y'           PBdSfl
     C                   PARM      *BLANKS       PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    PRSBRC
     C                   PARM                    PRMRDT
 
      * Output Parameters :
 
      ** Error Message
      ** Option Selected
      ** Action selected
      ** FO Transaction ID selected
      ** Timestamp of Transaction selected
      ** Command keys
     C                   PARM      *BLANKS       PErrMs
     C                   PARM                    POpSel
     C                   PARM                    PAcSel
     C                   PARM                    PFOTranSel
     C                   PARM                    PTmeStpSel
     C                   PARM      '0'           PINKC
 
      ** If error set on external switches
 
     C                   IF        PErrMs <> *BLANKS
     C                   EVAL      *INU6 = *ON
     C                   ENDIF
 
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
 
     C                   IF        PINKC = *ON OR PErrMs <> *BLANKS
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
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'SDDCMTRPB'
 
      * Input Parameters :
 
      ** Return Code
      ** Build sub-file
      ** Read subfile record
      ** Error in update of previous record
      ** Single Branch Code
      ** Midas Run Date
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      *BLANKS       PBdSfl
     C                   PARM      'Y'           PRdSfl
     C                   PARM                    PErrUp
     C                   PARM                    PRSBRC
     C                   PARM                    PRMRDT
 
      * Output parameters :
 
      ** Error message
      ** Option selected
      ** Action selected
      ** FO Transaction ID selected
      ** Timestamp of Transaction selected
      ** Command keys
     C                   PARM      *BLANKS       PErrMs
     C                   PARM      *BLANKS       POpSel
     C                   PARM      *BLANKS       PAcSel
     C                   PARM      *BLANKS       PFOTranSel
     C                   PARM                    PTmeStpSel
     C                   PARM      '0'           PINKC
 
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
 
     C                   IF        PINKC = *On
     C                   EXSR      SREndP
     C                   GOTO      ESRRdNBrw
     C                   ENDIF
 
      ** If invalid record read from subfile
 
     C                   IF        POpSel <> *BLANKS
 
      ** Blank the main details screen
 
     C                   EVAL      NwDcScnFmt = *Blanks
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** Retrieve record details
 
     C     ZATRNKD0      CHAIN     SDIDCMTX0                          99
 
      ** Validate front office record interface
 
     C                   EXSR      SRVFrnt
 
      ** Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *Blanks
 
     C     GHSUBS        SCAN      NwDcScnFmt                             99
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
      *  SRScrnM- Process Screen: Main Details                        *
      *                                                               *
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
 
     C                   CALLB     'SDDCMTDSP'
 
      * Input Parameters :
 
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NwDcScnFmt
      *
      * FIELDS IN ERROR
     C                   PARM                    OkFlags
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           PEKYFD
     C                   PARM      'Y'           PEDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKV
 
      * Output Parameters :
 
      * FUNCTION KEYS
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKV
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
     C                   PARM                    ISDAFlag          1
     C                   PARM      'N'           PHDTFD            1
     C                   PARM                    CLRSCRN           1
     C                   PARM      'C'           PINTYP            1
     C                   PARM                    PINMOD
 
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
      *                                                               *
      *  SRUpdate - Update File                                       *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** Update Records
 
     C                   CALLB     'SDDCMTUPD'
 
      * Input Parameters :
 
      ** Return Code
      ** New Details in File Format
     C                   PARM      *Blanks       PRTCD
     C                   PARM                    NwDcFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise commit the updates
 
     C                   IF        PRTCD <> *Blanks
     C                   ROLBK
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C     ZATRNKD0      CHAIN     SDIDCMTD0                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SDIDCMTD0
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
      *  SRVFrnt - Validation for Front Office Record Interface       *
      *                                                               *
      *****************************************************************
 
     C     SRVFrnt       BEGSR
 
     C                   EVAL      Idx = 0
     C                   EVAL      WInitErr = 'N'
 
      ** Error if action code is not 'A'
 
     C                   IF        DDACTN <> 'A' AND
     C                             DDACTN <> 'I'
     C                   EVAL      OkACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0133'
     C                   EVAL      WInitErr = 'Y'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
      ** Error if Front Office Transaction ID is blank
 
     C                   IF        PFOTranSel = *Blanks
     C                   EVAL      OkACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0101'
     C                   EVAL      WInitErr = 'Y'
     C                   GOTO      EVFRNT
     C                   ENDIF
 
     C                   IF        DDACTN = 'A'
 
      ** Access record with Front Office Transaction ID
 
     C     PFOTranSel    CHAIN     DCMTFOID                           02
 
      ** Front Office Transaction ID must be present
 
     C                   IF        *IN02 = *ON
     C                   EVAL      OkACTN = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'APM0103'
     C                   EVAL      MsgDtaArr(Idx) = PFOTranSel
     C                   EVAL      WInitErr = 'Y'
     C                   GOTO      EVFRNT
     C                   ENDIF
     C                   ENDIF
 
     C     EVFRNT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvDt - Retrieve Customer and Document Code Details        *
      *                                                               *
      *****************************************************************
 
     C     SRRtvDt       BEGSR
 
     C                   CALLB     'SDDCMTDFT'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      DDREFN        PCUSN
     C                   PARM      DDRTYP        PRTYP
     C                   PARM      DDCODE        PCODE
     C                   PARM                    SDCUST
     C                   PARM                    SDNAHO
     C                   PARM                    SDDOCM
 
     C                   IF        DDRTYP = 'C'
     C                   EVAL      DDCSSN = BBCSSN
     C                   EVAL      DDCRNM = BBCRNM
     C                   EVAL      DDCRTN = BBCRTN
     C                   ELSE
     C                   EVAL      DDCSSN = *BLANKS
     C                   EVAL      DDCRNM = NHNARN
     C                   EVAL      DDCRTN = NHNATW
     C                   ENDIF
 
      ** Document Narrative
     C                   EVAL      DDNARR = ATDCNA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCanC - Cancel on Confirmation Screen                       *
      *                                                               *
      *****************************************************************
     C     SRCanC        BEGSR
 
      ** Return to main details screen
 
     C                   EVAL      WScrn = 'M'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExit - Exit From Confirmation Screen                       *
      *                                                               *
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
      *                                                               *
      *  SRCanM - Cancel on Main Details Screen                       *
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
      *  SRSndM - Send a message to main details screen               *
      *                                                               *
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
     C                   MOVE      PTMESTPSEL    KTimeStamp
 
      ** Read error messages for deal
 
     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD1      READE     ZATRNERRD0                             99
 
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
     C     ZATRNKD1      READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     WkEI          OkFlags
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValM - Validate input to main details screen               *
      *                                                               *
      *****************************************************************
 
     C     SRValM        BEGSR
 
      ** Initialize error indicators and clear details in file format
 
     C                   Z-ADD     *Zeros        Idx
     C                   MOVE      *All'Y'       OkFlags
     C                   CLEAR                   NwDcFilFmt
 
      ** Save Current Format from Retrieve
 
      ** Validate record details
 
     C                   CALLB     'SDDCMTVAL'
 
      * Input Parameters :
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      ** New Details in Screen Format
     C                   PARM                    PRespMode
     C                   PARM                    NwDcScnFmt
 
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
     C                   PARM                    NwDcFilFmt
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
     C                   IF        Idx = 0
     C                   EVAL      DVREFN = DDREFN
     C                   MOVE      DDSEQN        DVSEQN
     C                   EVAL      DVFOID = PFOTranSel
     C                   EVAL      WScrn = 'U'
     C                   ELSE
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSubsDta  - Transaction Details Data Substitution           *
      *                                                               *
      *****************************************************************
 
     C     SRSubsDta     BEGSR
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'APDTASUBS'
 
      ** Data Substitution
 
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      NwDcScnFmt    IncDATA
     C                   PARM      CrDcScnfmt    CurDATA
 
     C                   MOVEL     IncDATA       NwDcScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - End Program                                         *
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
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PRMRDT = BJMRDT
     C                   EVAL      PRSBRC = BJSBRC
     C                   ENDIF
 
      ** Access API ICD Details
 
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DBFILE = 'SDAPIPD '
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
 
     C     ZATRNKD1      KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    KTimeStamp
 
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
 
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2013
