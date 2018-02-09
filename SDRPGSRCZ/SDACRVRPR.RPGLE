     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Repair')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDACRVRPR - SD Account Review Repair                         *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD ACRV by Front Office ID
     FSDACRVL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDACRVD0:ACRVFOID)
 
      ** Midas SD Invalid ACRV by Timestamp and FOID - Retrieve
     FSDIACRVL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDIACRVD0:SDIACRVX0)
 
      ** Midas SD Invalid ACRV by Timestamp and FOID - Update
     FSDIACRVL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** API Invalid Log File from Support Database
 
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN
     F                                     COMMIT
 
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** ================
      ** Standard D-specs
      ** ================
 
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
     D NwArScnFmt    E DS                  EXTNAME(SDACRFPD)
 
      ** Valid Details for Update
     D NwArFilFmt    E DS                  EXTNAME(SDVACRVPD)
 
      ** Current Details in File Format
     D CrArFilFmt    E DS                  EXTNAME(SDACRVPD)
 
      ** Current Detail in Screen Format
     D CrArScnFmt    E DS                  EXTNAME(SDACRFPD)
     D                                     PREFIX(Cr)
 
      ** External DS for Custoter Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Error Indicator File
     D OkFlags       E DS                  EXTNAME(SDEACRVPD)
 
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
     D WOPSEL          S              1A
     D WSDSEL          S              5P 0
     D WSQSEL          S              3S 0
     D DDCUSN          S              6A
     D OKACTN          S              1A
     D WDCOMP          S              1A
     D Retcd           S              7A
     D WCUSN           S              6
     D PDetails        S            800
     D WWACDF          S              6
     D WWACTM          S              6
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D PWIdx           S              3P 0
 
      ** Function Keys
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKI           S              1A
     D PINKL           S              1A
 
     D WINKC           S              1A
     D WINKE           S              1A
     D WINKL           S              1A
     D WINKU           S              1A
     D WINKV           S              1A
 
      ** Work Variables
     D E               S              3  0
     D F               S              3  0
     D WScrn           S              1A
     D WkRdNB          S              1A
     D WInitErr        S              1A
 
     ** Parameter for Access Objects
     D PKey1           S             10A
     D PKySt           S              7A
 
     D DDCSSN          S             10
     D DDCRNM          S             20
     D DDCRTN          S             20
 
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
 
      ** Mode of Operation
     D PModeOfOp       S              6A
 
     D KMsgType        S              8A
     D KFrntOffID      S                   LIKE(PFOTranSel)
     D KTimeStamp      S             26Z
 
     D PRespMode       S              1A   INZ('S')
 
      ** Substitution Character
     D SubsChar        S              1A
 
      ** Incoming Data
     D IncDATA         S           2000A
 
      ** Current Data
     D CurDATA         S           2000A
 
     D Format          S             10A   Inz('SDACRFPD')
     D Field           S             10A   Inz('DDACTN')
     D FieldNo         S              5P 0
     D FldOffset       S              5P 0
 
     D CSC011          S              1A
     D WEKYFD          S              1A
     D WEDTFD          S              1A
 
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
      *  SRBldBrw - Browse invalid details                            *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SDACRVRPB                                         *
      *                                                               *
      *****************************************************************
 
     C     SRBldBrw      BEGSR
 
      ** Reset Read Next Browse Subfile Record
 
     C                   EVAL      WkRdNb = *Blanks
 
      ** Build Browse subfile
 
     C                   CALLB     'SDACRVRPB'
 
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
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SDACRVRPB, SRResetErr, SREndP, SRVFrnt            *
      *                                                               *
      *****************************************************************
 
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'SDACRVRPB'
 
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
 
     C                   EVAL      NwArScnFmt = *Blanks
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** Retrieve record details
 
     C     KZATRNKD0     CHAIN     SDIACRVX0                          99
 
      ** Validate front office record interface
 
     C                   EXSR      SRVFrnt
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      DDMAGE = 'M'
     C                   ENDIF
 
      ** Data Substitution - Transaction Details
 
     C                   IF        GHSUBS <> *Blanks
 
     C     GHSUBS        SCAN      NwArScnFmt                             99
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
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SDACRV1DT, SDACRV1DP, SREndP, SrCanM, SRValM      *
      *                                                               *
      *****************************************************************
 
     C     SRScrnM       BEGSR
 
      ** Enable/disable detail fields on main details screen
      ** if changes to the data are allowed
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'A')
 
     C                   IF        DDACTN = 'A' AND
     C                             POpSel = 'U' AND
     C                             WInitErr <> 'Y' OR
     C                             DDACTN = 'I' AND
     C                             POpSel = 'U' AND
     C                             WInitErr <> 'Y'
     C                   EVAL      WEDTFD = 'Y'
     C                   ELSE
     C                   EVAL      WEDTFD = 'N'
     C                   ENDIF
 
     C                   CALLB     'SDACRV1DT'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      DDCUST        WCUSN
     C     SDCUST        PARM      SDCUST        PDetails
 
      ** Write/Read Display Screen - Primary Details
 
     C                   CALLB     'SDACRV1DP'
 
      ** INPUTS :
      ** Return code
      ** Account review details (In Screen format - Primary )
      ** Fields in error
      ** Errors
      ** Warnings
      ** Enabled Key & Detail fields
      ** Enabled Function keys
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      BBCSSN        DDCSSN
     C                   PARM      BBCRNM        DDCRNM
     C                   PARM      BBCRTN        DDCRTN
     C                   PARM                    NwArScnFmt
     C                   PARM                    WDCOMP
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM      'N'           WEKYFD
     C                   PARM                    WEDTFD
 
      ** OUTPUTS :
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM      *Off          WINKC
     C                   PARM      *Off          WINKE
     C                   PARM      *Off          WINKL
     C                   PARM      *Off          WINKU
     C                   PARM      *Off          WINKV
     C                   PARM      'N'           WriteOnly
 
     C                   MOVE      WINKC         PINKC
     C                   MOVE      WINKL         PINKL
 
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
 
     C     ESRScrnM      ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update File                                       *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls    : SDACRVUPD                                         *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** Update Records
 
     C                   CALLB     'SDACRVUPD'
 
      * Input Parameters :
 
      ** Return Code
      ** New Details in File Format
     C                   PARM      *Blanks       PRTCD
     C                   PARM                    NwArFilFmt
     C                   PARM                    WDCOMP
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** Otherwise commit the updates
 
     C                   IF        PRTCD <> *Blanks
     C                   ROLBK
     C                   IF        PRTCD <> '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ELSE
     C     KZATRNKD0     CHAIN     SDIACRVD0                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    SDIACRVD0
     C                   ENDIF
 
      ** Delete invalid record from the log file.
 
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR
 
     C                   EVAL      KMsgType = 'SDACRV'
     C                   EVAL      KFrntOffID = PFOTRANSEL
     C                   MOVE      PTMESTPSEL    KTimeStamp
 
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
      *  SRVFrnt - Validation for Front Office Record Interface       *
      *                                                               *
      *  Called by: SRRdNBrw                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRVFrnt       BEGSR
 
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
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
 
     C     PFOTranSel    CHAIN     ACRVFOID                           02
 
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
     C                   EVAL      WDCOMP = ARCOMP
     C                   ENDIF
 
     C     EVFRNT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCanM - Cancel on Main Details Screen                       *
      *                                                               *
      *  Called by: SRScrnM                                           *
      *                                                               *
      *  Calls    : None                                              *
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
      *  Called by: SRRdNBrw                                          *
      *                                                               *
      *  Calls    : None                                              *
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
 
      ** Read error messages for deal
 
     C     KZATRNKD1     SETLL     ZATRNERRD0
     C     KZATRNKD1     READE     ZATRNERRD0                             99
 
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
     C     KZATRNKD1     READE     ZATRNERRD0                             99
     C                   ENDDO
 
     C                   MOVEA     WkEI          OkFlags
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValM - Validate input to main details screen               *
      *                                                               *
      *  Called by: SRRdNBrw                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRValM        BEGSR
 
      ** Initialize error indicators and clear details in file format
 
     C                   Z-ADD     *Zeros        Idx
     C                   MOVE      *All'Y'       OkFlags
     C                   CLEAR                   NwArFilFmt
 
      ** Save Current Format from Retrieve
 
     C                   EVAL      WWACDF = DDACDF
     C                   EVAL      WWACTM = DDACTM
 
      ** Validate record details
 
     C                   CALLB     'SDACRV1VL'
 
      ** Input Parameters :
 
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
      ** New Details in Screen Format
     C                   PARM                    PRespMode
     C                   PARM                    NwArScnFmt
     C                   PARM                    WDCOMP
 
      ** Output Parameters :
 
      ** Error Flags
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** New Details in File Format
     C                   PARM                    OkFlags
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    NwArFilFmt
 
     C                   IF        Idx = 0
     C                   IF        WIdx = PWIdx
     C                   EVAL      AVCUST = DDCUST
     C                   MOVE      DDSEQN        AVSEQN
     C                   EVAL      AVFOID = PFOTranSel
     C                   EVAL      AVLTYP = DDACTN
     C                   EVAL      WScrn = 'U'
     C                   ELSE
 
     C                   IF        WWACDF = *BLANKS AND
     C                             DDACDF <> *BLANKS
     C                   EVAL      WIdx = WIdx - 1
     C                   ENDIF
 
     C                   IF        WWACTM = *BLANKS AND
     C                             DDACTM <> *BLANKS
     C                   EVAL      WIdx = WIdx - 1
     C                   ENDIF
     C                   EVAL      PWIdx = WIdx
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
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
      *  Called by: SRRdNBrw                                          *
      *                                                               *
      *  Calls    : APDTASUBS                                         *
      *                                                               *
      *****************************************************************
 
     C     SRSubsDta     BEGSR
 
     C                   RESET                   ReturnCode
 
     C                   CALLB     'APDTASUBS'
 
      ** Data Substitution
 
     C                   PARM                    ReturnCode
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      NwArScnFmt    IncDATA
     C                   PARM      CrArScnfmt    CurDATA
 
     C                   MOVEL     IncDATA       NwArScnFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - End Program                                         *
      *                                                               *
      *  Called by: SRBldBrw, SRRdnBrw, SRScrnM                       *
      *                                                               *
      *  Calls: None                                                  *
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
      *  Called by: SRRdNBrw                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRResetErr    BEGSR
 
     C                   MOVE      *ALL'Y'       OkFlags
     C                   EVAL      FldNameArr = *Blanks
     C                   EVAL      MsgDtaArr = *Blanks
     C                   EVAL      MsgIdArr = *Blanks
     C                   EVAL      WFldNamArr = *Blanks
     C                   EVAL      WMsgIdArr = *Blanks
     C                   EVAL      WMsgDtaArr = *Blanks
 
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
 
      ** Key Lists
 
     C     KAPILOGL0     KLIST
     C                   KFLD                    KMsgType
     C                   KFLD                    KFrntOffID
     C                   KFLD                    KTimeStamp
 
     C     KZATRNKD0     KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    PTmeStpSel
 
     C     KZATRNKD1     KLIST
     C                   KFLD                    PFOTranSel
     C                   KFLD                    KTimeStamp
 
     C     KZATRNKX0     KLIST
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
(c) Finastra International Limited 2014
