     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Details by Country of Tax Input')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCCTXSIN - SD Customer Details by Country of Tax Input      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG23223           Date 04Mar09               *
      *                 BUG22578A          Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236137             Date 21Sep05               *
      *                 234227             Date 27Jun05               *
      *                 233004             Date 12Apr05               *
      *                 232543             Date 28Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT073: upgrade ACU3, ACU4, CUAH and CCTX to CUSD    *
      *  BUG23223 - Incorrect '@Scrn' value set during Update run     *
      *  BUG22578A - Amend screen flow for German Taxes               *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  236137 - Change Control for CGL031 (Recompile)               *
      *  234227 - Add function to delete record/s if the Joint Account*
      *           Type has been changed from 'Y' to 'N'.              *
      *  233004 - Addtl Cust and Non-a/c Holder by Country of Tax     *
      *  232543 - Fix to CGL032
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Customer Details by Country of Tax - Retrieve
     F***SDACTXL1**IF*A*E           K DISK                                                    232543
     FSDACTXL1  IF   E           K DISK                                                       232543
 
      *****************************************************************
      /EJECT
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
 
      ** The following /COPY line includes the definitions of data
      ** structure used to pass data to window program
 
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
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Current Details in File Format
     D CrDlFilFmt    E DS                  EXTNAME(SDACTXPD)
 
      ** New Details in File Format
     D NwDlFilFmt    E DS                  EXTNAME(SDVCCTXPD)
     D                                     Prefix(NF)
 
      ** Current Details in Screen Format
     D CrDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
 
      ** New Details in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(SDCCTXPD)
     D                                     Prefix(NS)
 
      ** Error indicator file
     D OkFlags       E DS                  EXTNAME(SDECCTXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Entry Parameter
     D PAction         S              1A
     D PCustNo         S              6A
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D PRespMode       S              1A   INZ('S')
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** Parameter Variables
     D PINKC           S              1A
     D PINKJ           S              1A                                                      234227
     D PINKL           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D***PModeOfOp       S              6A                                                    232543
     D PModeOfOp       S              6A   INZ('*SIN  ')                                      232543
     D PMode           S              7A                                                      CER059
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PUpSfl          S              1A
     D PRedisp         S              1A
     D PCtrySel        S              2A
     D PProtect        S              1A
     D PRepair         S              1A
 
      ** Work Variables
     D Ix              S              3P 0
     D WScrn           S              1
      *                                                                                    BUG22578A
      ** Output *ENTRY Parameters                                                          BUG22578A
      *                                                                                    BUG22578A
     D PExit           S              1A                                                   BUG22578A
     D PCancel         S              1A                                                   BUG22578A
 
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
      * Main Procedure                                                    *
      *********************************************************************
 
      ** Read next browse subfile record
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      ** Update subfile record
 
     C                   IF        WScrn = 'A'
     C                   EXSR      SRUpSflR
     C                   ENDIF
 
      ** Build browse subfile record
 
     C                   IF        WScrn = 'M'
 
      ** Initialize error indicators as 'OK'
 
     C                   EXSR      SRResetErr
 
     C                   EXSR      SRBldBrw
     C                   ENDIF
 
      **  Do file updates
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = '1'
     C                   ENDIF
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldBrw - Build Browse Subfile                               *
      *                                                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
 
      ** Build browse subfile
 
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
                                                                                              234227
      ** Action code                                                                          234227
     C                   PARM                    PAction                                      234227
 
      ** Protect Indicator
     C                   PARM                    PProtect
 
      ** Repair Mode Indicator
     C                   PARM                    PRepair
 
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
     C                   PARM      '0'           PINKJ                                        234227
     C                   PARM      '0'           PINKL
 
      ** Country Code Selected
     C                   PARM      *BLANK        PCtrySel
 
      ** New Details in Screen Format
     C                   PARM      *BLANK        NwDlScnFmt
 
     C                   SELECT
 
      ** If F3, end program
 
     C                   WHEN      PINKC = '1'
     C                   IF        PAction = 'D'                                              234227
     C                   EVAL      ReturnCode = '*RESHOW'                                     234227
     C                   ENDIF                                                                234227
      *                                                                                    BUG22578A
      ** Set Exit Flag for SIN                                                             BUG22578A
      *                                                                                    BUG22578A
     C                   EVAL      PExit = '1'                                             BUG22578A
     C                   EXSR      SREndP
 
      ** If F10, delete records                                                               234227
                                                                                              234227
     C                   WHEN      PINKJ = '1'                                                234227
     C                   EVAL      WScrn = 'U'                                                234227
                                                                                              234227
      *                                                                                    BUG22578A
      ** Set Cancel Flag for SIN                                                           BUG22578A
      *                                                                                    BUG22578A
     C                   WHEN      PINKL = '1'                                             BUG22578A
     C                   EVAL      PCancel = '1'                                           BUG22578A
     C                   EVAL      *INLR = *ON                                             BUG22578A
     C                   RETURN                                                            BUG22578A
      *                                                                                    BUG22578A
      ** If No record, rebuild subfile
 
     C                   WHEN      NwDlScnFmt = *BLANKS AND
     C                             PRedisp <> 'Y'
     C                   EVAL      WScrn = 'M'
 
      ** Otherwise, read subfile
 
     C                   OTHER
     C                   EVAL      WScrn = 'R'
     C                   ENDSL
 
     C                   EVAL      PRedisp = 'N'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdNBrw - Read next browse subfile record                    *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
 
     C                   CALLB     'SDCCTXBRW'
 
      ** Input Parameters
      ** ================
 
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
 
      ** Build subfile
     C                   PARM      *BLANK        PBdSfl
 
      ** Read subfile record
     C                   PARM      'Y'           PRdSfl
 
      ** Update subfile record
     C                   PARM      *BLANK        PUpSfl
 
      ** Redisplay Indicator
     C                   PARM                    PRedisp
 
      ** Customer Number
     C                   PARM                    PCustNo
                                                                                              234227
      ** Action code                                                                          234227
     C                   PARM                    PAction                                      234227
 
      ** Protect Indicator
     C                   PARM                    PProtect
 
      ** Repair Mode Indicator
     C                   PARM                    PRepair
 
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
     C                   PARM      '0'           PINKJ                                        234227
     C                   PARM      '0'           PINKL
 
      ** Country Code Selected
     C                   PARM      *BLANK        PCtrySel
 
      ** New Details in Screen Format
     C                   PARM      *BLANK        NwDlScnFmt
      *                                                                                     BUG23223
      ** Validate details only when action code is 'I' or 'A'                               BUG23223
      *                                                                                     BUG23223
     C                   IF        PAction = 'I' OR PAction = 'A'                           BUG23223
 
      ** If detail read from subfile
 
     C                   IF        PCtrySel <> *BLANK
 
      ** Retrieve details
 
     C                   EXSR      SRRetrieve
 
      ** Validate details
 
     C                   EXSR      SRValidate
 
     C                   ELSE
 
     C                   IF        Idx <> 0                                                   233004
     C                   EVAL      WScrn = 'M'
     C                   ELSE                                                                 233004
     C                   EVAL      WScrn = 'T'                                                233004
     C                   ENDIF                                                                233004
 
     C                   ENDIF
      *                                                                                     BUG23223
     C                   ELSE                                                               BUG23223
      *                                                                                     BUG23223
     C                   EVAL      WScrn = 'T'                                              BUG23223
      *                                                                                     BUG23223
     C                   ENDIF                                                              BUG23223
 
     C                   ENDSR
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
     C                   PARM                    PRepair
 
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
     C                   PARM      '0'           PINKJ                                        234227
     C                   PARM      '0'           PINKL
 
      ** Country Code Selected
     C                   PARM      *BLANK        PCtrySel
 
      ** New Details in Screen Format
     C                   PARM                    NwDlScnFmt
 
     C                   EVAL      WScrn = 'R'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve - Retrieve Detail                                  *
      *                                                               *
      *****************************************************************
     C     SRRetrieve    BEGSR
 
     C     KEY1          KLIST
     C                   KFLD                    PCustNo
     C                   KFLD                    PCtrySel
 
     C     KEY1          CHAIN     SDACTXL1                           01
 
     C                   IF        *IN01 = *ON
     C                   EVAL      DBKEY  =  PCustNo + PCtrySel
     C                   EVAL      DBFILE =  'SDACTXPD'
     C                   EVAL      DBASE  =  002
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Details                                 *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
      ** Validate Details
      ** ================
 
      ** Clear Record in File Format
     C                   CLEAR                   NwDlFilFmt
     C                   EVAL      NwDLFilFmt = CrDlFilFmt
 
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
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
 
     C     EVAL@M        ENDSR
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
                                                                                              234227
      ** Action Code                                                                          234227
     C                   PARM                    PAction                                      234227
                                                                                              234227
      ** Customer Number                                                                      234227
     C                   PARM                    PCustNo                                      234227
 
      ** New Details in File Format
     C                   PARM                    NwDlFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.  Otherwise, commit the updates
 
     C                   IF        PRTCD <> *BLANK AND
     C                             PRTCD <> '*RECUPD'
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   IF        PRTCD = '*RECUPD'
     C                   ROLBK
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C
     C                   IF        PRTCD = '*RECUPD'
 
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'MMM1023'
     C
     C                   ENDIF
 
     C                   IF        PAction = 'D'                                              234227
     C                   EVAL      WScrn = 'T'                                                234227
     C                   ELSE                                                                 234227
     C                   EVAL      WScrn = 'A'
     C                   ENDIF                                                                234227
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndP - End program                                          *
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
 
      ** Reset error fields
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   Z-ADD     *ZERO         Idx
 
      ** Initialise screen fields error indicators
 
     C                   EVAL      OkFlags = *ALL'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Processing                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
 
      ** Return code
     C                   PARM                    ReturnCode
 
      ** Action code
     C                   PARM                    PAction
 
      ** Customer Number
     C                   PARM                    PCustNo
      *                                                                                    BUG22578A
      ** F3 = Exit                                                                         BUG22578A
      *                                                                                    BUG22578A
     C                   PARM                    PExit                                     BUG22578A
      *                                                                                    BUG22578A
      ** F12 = Previous                                                                    BUG22578A
      *                                                                                    BUG22578A
     C                   PARM                    PCancel                                   BUG22578A
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY  =  POPTN
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PAction = 'E' or
     C                             PAction = 'D'
     C                   EVAL      PProtect = 'Y'
     C                   ELSE
     C                   EVAL      PProtect = 'N'
     C                   ENDIF
 
     C                   EVAL      WScrn = 'M'
 
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
(c) Misys International Banking Systems Ltd. 2004
