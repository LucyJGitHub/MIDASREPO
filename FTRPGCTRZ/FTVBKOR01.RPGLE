     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Booking and Originating branch')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVBKOR01 - Validate Booking Branch                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 224336             Date 13Apr04               *
      *                 221761             Date 13Apr04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 25Jun03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185107             Date 17Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177985             Date 18Apr00               *
      *                 CFT006  *CREATE    Date 10Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  224336 - Remove nuisance warning message                     *
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAP084 - Creation of wrappers for use with front end.        *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  177985 - GEMS error fix number - must have TID address attach*
      *           to booking branch                                   *
      *  CFT006 - Funds Transfer : MT101 messages                     *
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
     D GenOkFlag       S              1    Import
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Header record datastructure
     D HdrRcdIn      E DS                  EXTNAME(FT101HSPD)
 
      * External DS for General Ledger details
     D SDUSER        E DS                  EXTNAME(MUSER)
 
      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D D@FMT         E DS                  EXTNAME(SDMMODPD)
 
     D*P@FMT         E DS                  EXTNAME(DSFDY)
 
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
     D WIdx            S              3P 0
 
     D P@RTCDU         S              7
     D P@USRP          S             10
     D P@RTCDB         S              7
     D P@OPTN          S              7
     D P@BRCA          S              3
     D #ERR            S              1  0
 
     D RespMode        S              1
     D DDSName         S             10
 
     D P@RTCDA         S              7
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
 
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
 
      ** Initialization
     C                   Eval      RetCodeIn  = *BlankS
     C                   Eval      Idx        = 0
     C                   Eval      WIdx       = 0
 
     C                   Eval      GenOkFlag = 'Y'
 
 
 
      * Booking Branch Validation
     C                   If        BGMBIN = 'N'
     C                   Eval      P@BRCA = *Blanks
     C                   Eval      WIdx            =   Idx+1
     C                   Eval      RetCodeIn       =   'Error'
     C                   Eval      WMsgIdXAr(WIdx) =   'RFV0223'
     C                   Eval      WFldNmXAr(WIdx) =   DDSName
     C                   Eval      GenOkFlag = 'W'
     C                   Endif
 
      * Booking Branch Validation
      * If branch is not yet defined set to default Booking Branch
     C                   If        PBRCA = *Blanks
                                                                                CAP084
      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   MOVEL     USER          P@USRP                         CAP084
     C                   ELSE                                                   CAP084
     C                   MOVEL     PSUser        P@USRP                         CAP084
     C                   ENDIF                                                  CAP084
                                                                                CAP084
     C                   Call      'AOUSERR0'
     C                   Parm      *Blanks       P@RTCDU
     C                   Parm      '*KEY   '     P@OPTN
     C***********        Parm      PSUser        P@USRP                         CAP084
     C                   Parm                    P@USRP                         CAP084
     C     SDUSER        Parm      SDUSER        DSFDY
 
     C                   If        P@RTCDU <> *Blanks
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0108'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Else
     C                   Eval      PBRCA = DBRN
     C                   Endif
 
     C                   Endif
 
      * Read SDBRCHPD to validate screen branch code
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       P@RTCDB
     C                   Parm      '*KEY   '     P@OPTN
     C                   Parm      PBRCA         P@BRCA
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
      * If return code is not blank - process for an error
     C                   If        P@RTCDB <> *Blanks
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0027'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Else
 
                                                                                177985
      * If branch code is found check that sender id exists                     177985
     C                   If        A8BTID = *Blanks                             177985
     C                   Eval      Idx            =   Idx+1                     177985
     C                   Eval      RetCodeIn      =   'Error'                   177985
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0379'                 177985
     C                   Eval      FldNamXAr(Idx) =   DDSName                   177985
     C                   Eval      GenOkFlag = 'N'                              177985
     C                   Else                                                   177985
      *  Originating Branch Validation =============================>>
 
     C                   If        BGMBIN = 'N' or BKOBRU = 'N' or
     C                             PORBR = *Blanks
     C                   Eval      PORBR = PBRCA
     C* There should be no need to issue a warning message as this is the norm anyway...      224336
     C*******************Eval      WIdx            =   Idx+1                                  224336
     C*******************Eval      RetCodeIn       =   'Error'                                224336
     C*******************Eval      WMsgIdXAr(WIdx) =   'RFV0224'                              224336
     C*******************Eval      WFldNmXAr(WIdx) =   DDSName                                224336
     C*******************Eval      GenOkFlag = 'W'                                            224336
     C                   Endif
 
     C                   Endif
     C                   Endif                                                  177985
 
      * Check user is authorised to perform action code on Booking branch
      * Only do the User/Branch/Action check if the program is running in
      * Synchronous mode.
 
     C     RespMode      IFEQ      'S'
 
     C                   CALL      'ZVACTBU'
     C                   Parm                    ActionCode
     C                   Parm                    PBRCA
     C                   Parm                    #ERR
 
      * User not authorised to any action codes for this item and branch
     C                   If        #ERR = 1
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0025'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Endif
 
      * User not authorised to action code for this item & branch
     C                   If        #ERR = 2
     C                   Eval      Idx            =   Idx+1
     C                   Eval      RetCodeIn      =   'Error'
     C                   Eval      MsgIdXAr(Idx)  =   'RFV0026'
     C                   Eval      FldNamXAr(Idx) =   DDSName
     C                   Eval      GenOkFlag = 'N'
     C                   Endif
 
     C                   Endif
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        PLIST
      * INPUTS
     C                   Parm                    RetCodeIn
     C                   Parm                    RespMode
     C                   Parm                    ActionCode
 
      *  Screen fields
     C                   Parm                    HdrRcdIn
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
     C                   Parm                    DDSName
 
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CallB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      *BLANKS       P@RTCDA
     C                   Parm      '*FIRST '     P@OPTN
     C*****SDGELR        Parm      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C                   If        P@RTCDA <> *Blanks
     C                   Eval      Dbfile = 'SDGELRPD'
     C                   Eval      Dbase  = 1
     C                   Eval      DBKey =  P@OPTN
     C                   Exsr      *PSSR
     C                   Endif
 
      ** Access Module Details
     C                   CallB     'AOMMODR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY'        @OPTN
     C     D@FMT         Parm                    D@FMT
 
     C                   If        @RTCD <> *Blanks
     C                   Eval      Dbfile = 'SDMMODPD'
     C                   Eval      Dbase  = 2
     C                   Eval      DBKey =  P@OPTN
     C                   Exsr      *PSSR
     C                   Endif
      *
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
(c) Finastra International Limited 2001
