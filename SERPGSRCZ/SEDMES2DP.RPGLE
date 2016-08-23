     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV WI/WO Extended Settlement - Display')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEDMES2DP - Depot Movement Extended Settlement Display *
      *                                                               *
      *  Function:  This module displays the Depot Movement Extended  *
      *             Settlement maintenance screen (only for WI/WO)    *
      *                                                               *
      *  Note: The screen is made of three individual screens (the    *
      *        last one depending on CSE028) through which the user   *
      *        can scroll using RollUp and RollDown.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR580857           Date 21Jul10               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAP087             Date 03Aug05               *
      *                 CSE045  *CREATE    Date 06Jun03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR580857 - QFIN label is erroneous (Recompile)               *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *           (recompile due to changes in file SEDMWIPD)         *
      *           and SEEDMWIPD)                                      *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEDMES2DF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      * Note: Whenever possible, the indicators and their functions   *
      *       are the same as in SE1808. If not, the old indicator is *
      *       given in parentheses, to help in program maintenance.   *
      *                                                               *
      *       05  Security Customer's Classification is 'C' or 'E'    *
      *           and CSW003 on                                       *
      *       07  CSW003 on and PREDE is 'TP'                         *
      *       08  CSW003 on and PREDE not 'TP'                        *
      *       09  Protect fields                                      *
      *(xx) 10-27 Field Error - highlight screen 1 fields             *
      *(xx) 10-34 Field Error - highlight screen 2 fields             *
      *(xx) 10-30 Field Error - highlight screen 3 fields             *
      *(20)   40  CSW098 on (or date > 16/10/98)                      *
      *       71  CSW003 on and CSE029 on and not 07                  *
      *       72  CSW003 on and CSE029 on and not 08                  *
      *       76  CSE028 on                                           *
      *       78  CSE028 on and ISO15022 = 'Y' and Settlement Message *
      *           Request = 'Y'                                       *
      *(+84)  85  RollUp                                              *
      *(+86)  87  RollDown                                            *
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
 
     D @EI1            S             18A
     D @EI2            S             25A
     D @EI3            S             21A
 
      ** SEDPMV Transaction Details in screen format
     D DPMVScrFld    E DS                  EXTNAME(SEDMWIPD)
 
      ** SEDPMV Transaction Details OK indicators
     D DPMVOkFlags   E DS                  EXTNAME(SEEDMWIPD)
     D***Scr1OkFlags          57     74A                                                      CSW210
     D***Scr2OkFlags          75     99A                                                      CSW210
     D***Scr3OkFlags         100    120A                                                      CSW210
     D   Scr1OkFlags          57     77A                                                      CSW210
     D   Scr2OkFlags          78    101A                                                      CSW210
     D   Scr3OkFlags         102    113A                                                      CSW210
 
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
      ** Compute the number of the first screen to be displayed
      ** (default to 1), depending on the position of the first
      ** field in error
      *
     C                   SELECT
     C                   WHEN      %Scan('N':Scr1OkFlags) > 0 OR
     C                             %Scan('W':Scr1OkFlags) > 0
     C                   Z-ADD     1             ScrnNbr           1 0
      *
     C                   WHEN      %Scan('N':Scr2OkFlags) > 0 OR
     C                             %Scan('W':Scr2OkFlags) > 0
     C                   Z-ADD     2             ScrnNbr
      *
     C                   WHEN      %Scan('N':Scr3OkFlags) > 0 OR
     C                             %Scan('W':Scr3OkFlags) > 0
     C                   Z-ADD     3             ScrnNbr
      *
     C                   OTHER
     C                   Z-ADD     1             ScrnNbr
     C                   ENDSL
 
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
     C                   SETOFF                                       050708
     C                   SETOFF                                       717278
     C                   SETOFF                                       41                      CSW210
      *
     C                   IF        CSW003 = 'Y' AND
     C                             (PCLAS = 'C' OR PCLAS = 'E')
     C                   SETON                                        05
     C                   ENDIF
      *
 B1  C                   IF        CSW003 = 'Y'
      *
 B2  C                   IF        PREDE = 'TP'
     C                   SETON                                        07
     C     CSE029        COMP      'Y'                                    72
 X2  C                   ELSE
     C                   SETON                                        08
     C     CSE029        COMP      'Y'                                    71
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C     CSW098        COMP      'Y'                                    40
     C     CSE028        COMP      'Y'                                    76
      *
     C                   IF        CSE028 = 'Y' AND DS1522 = 'Y' AND
     C                             DSGMES = 'Y'
     C                   SETON                                        78
     C                   ENDIF
      *
     C     CSW210        COMP      'Y'                                    41                  CSW210
      *                                                                                       CSW210
      ** LOOP ON THE SCREENS DISPLAY while the user scrolls among them
      *
 B1  C                   DOU       NOT *IN85 AND NOT *IN87
      *
      ** Depending on the screen to be displayed:
      ** Set screen error indicators according to status of 'OK' flags
      ** Write subfle control and details format
      ** Read details screen if write only not requested
      *
 B2  C                   SELECT
 X2  C                   WHEN      ScrnNbr = 0                                  RollDown on
     C                   EVAL      *INKL = *On                                    1st screen
     C                   LEAVE                                                    in Enquiry
      *
 X2  C                   WHEN      ScrnNbr = 1
     C     ' YNW':'0011' XLATE     Scr1OkFlags   @EI1
     C                   MOVEA     @EI1          *IN(10)
      *
     C                   WRITE     SEDMESD2CM
     C                   WRITE     SEDMESD2F0
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SEDMESD2F0                             99
     C                   ENDIF
      *
 X2  C                   WHEN      ScrnNbr = 2
     C     ' YNW':'0011' XLATE     Scr2OkFlags   @EI2
     C                   MOVEA     @EI2          *IN(10)
      *
     C                   WRITE     SEDMESD2CM
     C                   WRITE     SEDMESD2F1
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SEDMESD2F1                             99
     C                   ENDIF
      *
 X2  C                   WHEN      ScrnNbr = 3
     C     ' YNW':'0011' XLATE     Scr3OkFlags   @EI3
     C                   MOVEA     @EI3          *IN(10)
      *
     C                   WRITE     SEDMESD2CM
     C                   WRITE     SEDMESD2F2
      *
     C                   IF        WriteOnly <> 'Y'
     C                   READ      SEDMESD2F2                             99
     C                   ENDIF
      *
 E2  C                   ENDSL
      *
      ** Compute the number of the next screen to display
      *
     C                   IF        *IN85                                        RollUp
     C                   EVAL      ScrnNbr = ScrnNbr + 1
     C                   ENDIF
      *
     C                   IF        *IN87                                        RollDown
     C                   EVAL      ScrnNbr = ScrnNbr - 1
     C                   ENDIF
      *
 E1  C                   ENDDO
      *
      ** Set return keys
      *
     C                   EVAL      @INKC = *INKC
     C                   EVAL      @INKE = *INKE
     C                   EVAL      @INKL = *INKL
     C                   EVAL      @INKN = *INKN
     C                   EVAL      @INKS = *INKS
     C                   EVAL      @INKT = *INKT
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
      ** Transaction Details OK indicators
     C                   PARM                    DPMVOkFlags
      ** Write only indicator
     C                   PARM                    WriteOnly         1
      ** Run Date
     C                   PARM                    BJMRDT            7
      ** Security Customer classification
     C                   PARM                    PCLAS             1
      ** Receive/Deliver type
     C                   PARM                    PREDE             2
      ** Features status
     C                   PARM                    CSE028            1
     C                   PARM                    CSE029            1
     C                   PARM                    CSW003            1
     C                   PARM                    CSW098            1
     C                   PARM                    CSW210            1                          CSW210
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
     C                   PARM                    @INKE             1            F5
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKN             1            F14
     C                   PARM                    @INKS             1            F18
     C                   PARM                    @INKT             1            F19
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
