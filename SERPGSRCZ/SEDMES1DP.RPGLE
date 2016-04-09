     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extension - Display')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMES1DP - Depot Movement WI/WO extension - Display   *
      *                                                               *
      *  Function:  This module displays the Depot Movement Extension *
      *             maintenance screen (only for WI/WO)               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP087             Date 03Aug05               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to changes in file SEDMWIPD          *
      *           and SEEDMWIPD)                                      *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEDMES1DF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      * Note: Whenever possible, the indicators and their functions   *
      *       are the same as in SE1807. If not, the old indicator is *
      *       given in parentheses, to help in program maintenance.   *
      *                                                               *
      *       09  Protect fields                                      *
      *(xx) 10-31 Field Error - highlight screen fields               *
      *       43  Security Customer's Classification not 'C' nor 'E'  *
      *           and CSE028 off and CSW003 on                        *
      *(28)   44  Security Customer's Classification = 'E'            *
      *           and CSW003 on                                       *
      *(20)   46  Always on if CSW003 on (movement type is never      *
      *                                   'RP', 'RR', 'PD' or 'PL')   *
      *           Always off if CSW003 off                            *
      *       47  CSW201 on                                           *
      *       52  CSE029 on                                           *
      *       53  CSW202 on                                           *
      *(69)   97  *On or *Off = SFLEND on Message Subfile             *
      *       99  Multi Purpose                                       *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **---------------------------------------------------------------
 
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
 
     D @EI             S             22A
 
      ** SEDPMV Transaction Details in screen format
     D DPMVScrFld    E DS                  EXTNAME(SEDMWIPD)
 
      ** SEDPMV Transaction Details OK indicators
     D DPMVOkFlags   E DS                  EXTNAME(SEEDMWIPD)
     D   Scr1OkFlags          35     56A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ subroutine is executed at program activation.              ¦
      ** +------------------------------------------------------------+
      *
      ** Main processing
      *
     C                   EXSR      MAIN
      *
      ** Return
      *
     C                   IF        @INKC = '1'
     C                   SETON                                        LR
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      ** Set screen error indicators according to status of 'OK' flags
      *
     C     ' YNW':'0011' XLATE     Scr1OkFlags   @EI
     C                   MOVEA     @EI           *IN(10)
 
      **---------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **---------------------------------------------------------------
 
      ** SCREEN SETUP
      ** Fields Protection
      *                                                               >><<==
     C     DDACTN        COMP      'E'                                    09
      *
      ** Other screen indicators (see description at the top of this module)
      *
     C                   SETOFF                                       4344
      *
     C                   IF        CSW003 = 'Y' AND CSE028 <> 'Y' AND
     C                             PCLAS <> 'C' AND PCLAS <> 'E'
     C                   SETON                                        43
     C                   ENDIF
      *
     C                   IF        CSW003 = 'Y' AND PCLAS = 'E'
     C                   SETON                                        44
     C                   ENDIF
      *
     C     CSW003        COMP      'Y'                                    46
     C     CSW201        COMP      'Y'                                    47
     C     CSE029        COMP      'Y'                                    52
     C     CSW202        COMP      'Y'                                    53
      *
      ** SCREEN WRITE/READ: Message subfile control and keys+details formats
      *
     C                   WRITE     SEDMESD1CM
     C                   WRITE     SEDMESD1F0
      *
      ** Read keys+details screen if write only not requested
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SEDMESD1F0                             99
     C                   ENDIF
      *
      ** Set return keys
      *
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKL = *INKL
     C                   EVAL      @INKN = *INKN
      *
     C                   ENDSR
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeIn
      ** Transaction Details in screen format
     C                   PARM                    DPMVScrFld
      ** Additional screen fields (destination of settlement)
     C                   PARM                    DDROUS
     C                   PARM                    DDROTS
      ** Transaction Details OK indicators
     C                   PARM                    DPMVOkFlags
      ** Write only indicator
     C                   PARM                    WriteOnly         1
      ** Run Date
     C                   PARM                    BJMRDT            7
      ** Security Customer classification
     C                   PARM                    PCLAS             1
      ** Features status
     C                   PARM                    CSE028            1
     C                   PARM                    CSE029            1
     C                   PARM                    CSW003            1
     C                   PARM                    CSW201            1
     C                   PARM                    CSW202            1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** OUTPUT PARAMETERS:
      ** Function Keys
     C                   PARM                    @INKC             1            F3
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKN             1            F14
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Program message queue name
      *
     C                   EVAL      MSPGMQ = '*'
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   EVAL      ModuleID     = 'SE'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
      *
      ** Set up the movement reference and action code
      ** to be used by the message handler
      ** Doesn't matter, as messages are sent to screen
      *
     C                   EVAL      TranRef = 'Nothing'
     C                   EVAL      ActionCode = '?'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   EVAL      #MsgFile     = 'SEUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2003
