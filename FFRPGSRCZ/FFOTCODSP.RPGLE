     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Non-Currency OTC Display')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFOTCODSP - Futures and Options non-currency OTCs Display    *
      *                                                               *
      *  Function:  This module displays the main details screen      *
      *             of the over-the-counter non-currency options      *
      *             display function.                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG9185             Date 08Nov05               *
      *  Prev Amend No. CAAA03             Date 22Mar04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFFOTCODSDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-63 Field Error - highlight screen fields               *
      *                                                               *
      *       02  Position cursor on action code (if it is blank)     *
      *       03  Protect transaction key fields                      *
      *           (action code & transaction number)                  *
      *       04  Protect transaction detail fields                   *
      *       72  Enable CF07                                         *
      *       72  Enable CF08                                         *
      *       73  Enable CF10                                         *
      *       75  Enable CF15                                         *
      *       79  Highlight transaction status                        *
      *                                                               *
      *       96  Subfile control                                     *
      *       97  Subfile end                                         *
      ********************************************************************
      /EJECT
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
 
      ** Include the FF standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for FF-specific
      ** variables.
     D/COPY FFCPYSRC,DECLAREVAR
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D WInzIndArr      S              1    DIM(54) CTDATA PERRCD(54)
     D @NAR            S             40    DIM(1) CTDATA PERRCD(1)
 
     D WErrIndArr      S              1    DIM(54)
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for midas module details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External data structure for non-currency OTC format definition
     D NwScnFmt      E DS                  EXTNAME(FFOTCOPD)
     D                                     PREFIX(#1:1)
 
      ** External data structure for non-currency OTC OK flags
     D OkFlags       E DS                  EXTNAME(FFEOTCOPD)
 
      ** External data structure for customer settlements format definition
     D NwSetScnFmt   E DS                  EXTNAME(FFCSETPD)
     D                                     PREFIX(#1:1)
 
      ** External data structure for customer settlements OK flags
     D SetOkFlags    E DS                  EXTNAME(FFECSETPD)
 
     D                 DS
     D  #3FOTX                 1     40
     D  FFSIDN                10     15
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCtr1           S              2  0
     D WCtr2           S              2  0
 
      ** Screen Mode ('1' for transaction screen & '2' for plato screen)
     D PScnMode        S              1A
 
     D PSIDN           S              6A
 
      ** Enabled key and detail fields
     D PEKYFD          S              1A
     D PEDTFD          S              1A
 
      ** Function keys to activate
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
 
      ** Function keys activated
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Flag for Enhanced OTCs feature and FF enhancement
     D CFF001          S              1A
     D CFF007          S              1A
 
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
 
      ** Main processing
 
     C                   EXSR      SRMain
 
      ** Return
 
     C     PINKC         IFEQ      '1'
     C                   SETON                                        LR
     C                   ENDIF
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMain - Main processing
      *****************************************************************
     C     SRMain        BEGSR
 
      ** Move 'OK' flags into array (for checking)
 
     C                   MOVEA     OkFlags       WErrIndArr
     C                   MOVEA     SetOkFlags    WErrIndArr(44)
 
      ** Set screen error indicators according to status of 'OK' flags
 
     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     10            WCtr2
 
     C     WCtr1         DO        54
     C                   IF        WErrIndArr(WCtr1) = 'N' OR
     C                             WErrIndArr(WCtr1) = 'W'
     C                   EVAL      *IN(WCtr2) = '1'
     C                   ENDIF
 
     C                   EVAL      WCtr1 = WCtr1 + 1
     C                   EVAL      WCtr2 = WCtr2 + 1
     C                   ENDDO
 
      ** Set up the transaction reference and action code to be used
      ** by the message handler.
 
     C                   EVAL      TranRef = #1TNBR
     C                   EVAL      ActionCode = #1ACTN
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Position cursor on action code if it is blank
 
     C                   IF        #1ACTN = *BLANK
     C                   EVAL      *IN02 = True
     C                   ELSE
     C                   EVAL      *IN02 = False
     C                   ENDIF
 
      ** Midas Plato Screen - do not display Underlying Instrument Details
      ** if processing type is '6'
 
     C                   IF        #1ISPT = '6'
     C                   EVAL      *IN85 = True
     C                   ELSE
     C                   EVAL      *IN85 = False
     C                   ENDIF
 
      ** Enable key fields (Action Code & Transaction number)
 
     C                   IF        PEKYFD  = 'Y'
     C                   EVAL      *IN03 = False
     C                   ELSE
     C                   EVAL      *IN03 = True
     C                   ENDIF
 
      ** Enable detail fields (All fields except action code
      ** and transaction number)
 
     C                   IF        PEDTFD = 'Y'
     C                   EVAL      *IN04 = False
     C                   ELSE
     C                   EVAL      *IN04 = True
     C                   ENDIF
 
      ** Enable function keys
 
     C                   IF        PEINKG = 'Y' and PScnMode = '1'
     C                   EVAL      *IN72 = True
     C                   ELSE
     C                   EVAL      *IN72 = False
     C                   ENDIF
     C                   IF        PEINKH = 'Y' and PScnMode = '1'
     C                   EVAL      *IN72 = True
     C                   ELSE
     C                   EVAL      *IN72 = False
     C                   ENDIF
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN73 = True
     C                   ELSE
     C                   EVAL      *IN73 = False
     C                   ENDIF
     C                   IF        PEINKP = 'Y' and PScnMode = '1'
     C                   EVAL      *IN74 = True
     C                   ELSE
     C                   EVAL      *IN74 = False
     C                   ENDIF
 
      ** Transaction status
 
     C                   IF        #3STS = *BLANKS
     C                   EVAL      *IN79 = False
     C                   ELSE
     C                   EVAL      *IN79 = True
     C                   ENDIF
 
      ** Text = Successful insert
 
     C                   EVAL      #3FOTX = *BLANKS
     C                   IF        PSIDN <> *BLANKS
     C                   EVAL      #3FOTX = @NAR(1)
     C                   EVAL      FFSIDN = PSIDN
     C                   EVAL      PSIDN = *BLANKS
     C                   ENDIF
 
      ** Write message subfile, details and footer screen
 
     C                   TIME                    #1TIME
     C                   WRITE     FFOTCODSF3
     C                   WRITE     FFOTCODSC1
     C                   IF        PScnMode = '1'
     C                   WRITE     FFOTCODSF1
     C                   ELSE
     C                   EXSR      SRSetScn2
     C                   WRITE     FFOTCODSF2
     C                   ENDIF
 
      ** Read details screen,
      ** If not write only
 
     C                   IF        WriteOnly <> 'Y'
     C                   IF        PScnMode = '1'
     C                   READ      FFOTCODSF1                             01
     C                   ELSE
     C                   READ      FFOTCODSF2                             01
     C                   EXSR      SRRetScn2
     C                   ENDIF
     C                   ENDIF
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MOVEA     WInzIndArr    *IN(10)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * SRSetScn2 - Set fields for Screen 2
      *****************************************************************
 
     C     SRSetScn2     BEGSR
 
     C                   EVAL      #2MIIT = #1MIIT
     C                   EVAL      #2MITM = #1MITM
     C                   EVAL      #2MITD = #1MITD
     C                   EVAL      #2MICP = #1MICP
     C                   EVAL      #2MICF = #1MICF
     C                   EVAL      #2MIPC = #1MIPC
     C                   EVAL      #2MSPT = #1MSPT
     C                   EVAL      #2MIVT = #1MIVT
     C                   EVAL      #2MIPM = #1MIPM
     C                   EVAL      #2MIPG = #1MIPG
     C                   EVAL      #2MIRG = #1MIRG
     C                   EVAL      #2MICR = #1MICR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRetScn2 - Return Screen 2 format to parameter format
      *****************************************************************
 
     C     SRRetScn2     BEGSR
 
     C                   EVAL      #1MIIT = #2MIIT
     C                   EVAL      #1MITM = #2MITM
     C                   EVAL      #1MITD = #2MITD
     C                   EVAL      #1MICP = #2MICP
     C                   EVAL      #1MICF = #2MICF
     C                   EVAL      #1MIPC = #2MIPC
     C                   EVAL      #1MSPT = #2MSPT
     C                   EVAL      #1MIVT = #2MIVT
     C                   EVAL      #1MIPM = #2MIPM
     C                   EVAL      #1MIPG = #2MIPG
     C                   EVAL      #1MIRG = #2MIRG
     C                   EVAL      #1MICR = #2MICR
 
     C                   ENDSR
      *****************************************************************
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     C/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Transaction (in screen format)
 
     C                   PARM                    NwScnFmt
     C                   PARM                    NwSetScnFmt
 
      ** Premium
      ** Transaction status
 
     C                   PARM                    #1PREM
     C                   PARM                    #3STS
 
      ** Fields in error
 
     C                   PARM                    OKFlags
     C                   PARM                    SetOKFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
      ** KG = Command key 07 = Read prevoius
      ** KH = Command key 08 = Read next
      ** KJ = Command key 10 = Confirm delete
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PEKYFD
     C                   PARM                    PEDTFD
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Successful insert transaction
 
     C                   PARM                    PSIDN
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Standing Data
      ** =============
 
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDMMOD
 
      ** CFF001 and CFF007 enhancements
 
     C                   PARM                    CFF001
     C                   PARM                    CFF007
 
      ** Screen Mode
      ** ===========
 
     C                   PARM                    PScnMode
 
      ** Output Parameters
      ** =================
      ** Function Keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Set Screen protect/non-display indicators
      ** =========================================
      ** Single-branching (protect booking branch)
 
     C                   IF        BJSBRC <> *BLANK
     C                   EVAL      *IN80 = True
     C                   ENDIF
 
      ** Originating Branches not used
 
     C                   IF        BKOBRU <> 'Y' or BJSBRC <> *BLANK
     C                   EVAL      *IN81 = True
     C                   ENDIF
 
      ** Portfolio Management not installed (protect portfolio/PM ins.type)
 
     C                   IF        BGPFMG <> 'Y'
     C                   EVAL      *IN82 = True
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY determines whether the Profit-Centre Accounting
      ** feature is on.  CAC003 is set to 'Y' if CAC003 is on and the
      ** Analytical Accounting module is on (BGN0ST = 'Y').
     C/COPY FFCPYSRC,CAC003CHEK
      **--------------------------------------------------------------------------------------------
 
      ** Profit Centres not used or CAC003 installed (protect profit centre)
 
     C                   IF        BKPRCU <> 'Y' or CAC003 = 'Y'
     C                   EVAL      *IN83 = True
     C                   ENDIF
 
      ** CAC003 not installed (protect book/transaction profit centres)
 
     C                   IF        CAC003 <> 'Y'
     C                   EVAL      *IN84 = True
     C                   ENDIF
 
      ** Private Banking Module not installed (protect portfolio/PM ins.type)
 
     C                   IF        BGN4ST <> 'Y'
     C                   EVAL      *IN86 = True
     C                   ENDIF
 
      ** Switchable feature CFF001 is not installed
 
     C                   IF        CFF001 <> 'Y'
     C                   MOVE      '1'           *IN87
     C                   ENDIF
 
      ** Switchable feature CFF007 is not installed
 
     C                   IF        CFF007 <> 'Y'
     C                   MOVE      '1'           *IN88
     C                   ENDIF
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WSID = PsJobName
     C                   EVAL      #1DATE = BJMRDT
 
      ** Message subfile control
 
     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #1PGMQ = '*'
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for FF *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     C/COPY FFCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
      /EJECT
      ********************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** WInzIndArr
000000000000000000000000000000000000000000000000000000
** @NAR
Tran No. 999999 successfully processed.
