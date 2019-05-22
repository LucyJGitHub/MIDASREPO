     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals Display')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDDSP - Internal Funding Deals Display                   *
      *                                                               *
      *  Function:  This module will process the Internal Funding     *
      *             Deals screen details.                             *
      *                                                               *
      *  Component of: ABFUNDSIN - Internal Funding Deals Maintenance *
      *                ABFUNDRPR - Internal Funding Deals Repair      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Error in display file                           *
      *    02 - 10    Free to use                                     *
      *    11         Protect Action Code and Deal Number             *
      *    12         Display deal status                             *
      *    13         Protect detail fields                           *
      *    14         Free to use                                     *
      *    15         Free to use                                     *
      *    16         Booking Branch used                             *
      *    17         Originating Branch used                         *
      *    18         Profit Centre used                              *
      *    19         Previous/Next Screen Key on                     *
      *    20         Free to use                                     *
      *    21         Confirm Delete Key on                           *
      *    22         Selection Key on                                *
      *    23         Called as linked enquiry                        *
      *    24         Extended Deal Sub Type not installed            *                       CDL038
      *    25 - 29    Free to use                                     *                       CDL038
      *    30 - 63    Fields error indicator                          *                       CDL038
      *****24 - 29    Free to use                                     *                       CDL038
      *****30 - 57    Fields error indicator                          *                       CDL038
      *    58 - 89    Free to use                                     *
      *    90 - 99    Used by system                                  *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProc - Process display of detail screen                    *
      *  SRRtvTxt - Retrieve Text                                     *
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
 
      ** Internal Funding screen 1
     FABFUNDDSDFCF   E             WORKSTN INFSR(*PSSR)
 
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
 
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
 
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
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL038
      ** EXTERNAL DS FOR SWITCHABLE FEATURE DETAILS                                           CDL038
                                                                                              CDL038
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL038
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                                   CDL038
                                                                                              CDL038
     D WInzIndArr      S              1    DIM(60) CTDATA PERRCD(60)
 
     D WErrIndArr      S              1    DIM(60)
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WCtr1           S              2  0
     D WCtr2           S              2  0
 
     D PKeyFld         S              1A
     D PDetFld         S              1A
     D PLnkFlag        S              1A
     D PSInsDl         S              6A
     D PAGMBIN         S              1A
     D PBJMRDT         S              7A
     D PBKOBRU         S              1A
     D PBKPRCU         S              1A
     D PDDSTS          S              7A
     D PMsgDNb         S              7A
     D PMsgNm          S             10A
     D PMsgTxt         S             80A
 
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
 
     D CAS004          S              1A                                                      CAS004
                                                                                              CAS004
     D CDL019          S              1A                                                      CDL019
                                                                                              CDL019
     D CDL020          S              1A                                                      CDL020
                                                                                              CDL020
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
 
      ** Process
 
     C                   EXSR      SRProc
 
      * Return
 
     C                   IF        PINKC = *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRProc - Process Display of Detail Screen                    *
      *****************************************************************
     C     SRProc        BEGSR
 
      ** Move 'OK' flags into array for checking
 
     C                   MOVEA     OkFlags       WErrIndArr
 
      ** Set screen error indicators according to status of 'OK' flags
 
 
     C                   Z-ADD     1             WCtr1
     C                   Z-ADD     30            WCtr2
 
     C                   DOU       WCtr1 > 60
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
 
      ** Enable key fields (Action code and Deal number)
 
     C                   IF        PKeyFld = 'Y'
     C                   EVAL      *IN11 = '0'
     C                   ELSE
     C                   EVAL      *IN11 = '1'
     C                   ENDIF
 
      ** Enable detail fields (All fields except action code and deal number)
 
     C                   IF        PDetFld = 'Y'
     C                   EVAL      *IN13 = '0'
     C                   ELSE
     C                   EVAL      *IN13 = '1'
     C                   ENDIF
 
      ** Enable function keys
 
     C                   IF        PEINKG = 'Y'
     C                   EVAL      *IN19 = '1'
     C                   ELSE
     C                   EVAL      *IN19 = '0'
     C                   ENDIF
     C                   IF        PEINKH = 'Y'
     C                   EVAL      *IN19 = '1'
     C                   ELSE
     C                   EVAL      *IN19 = '0'
     C                   ENDIF
     C                   IF        PEINKJ = 'Y'
     C                   EVAL      *IN21 = '1'
     C                   ELSE
     C                   EVAL      *IN21 = '0'
     C                   ENDIF
     C                   IF        PEINKP = 'Y'
     C                   EVAL      *IN22 = '1'
     C                   ELSE
     C                   EVAL      *IN22 = '0'
     C                   ENDIF
 
      ** Deal status
 
     C                   EVAL      *IN12 = '0'
 
     C                   IF        PDDSTS = 'DELETED'
     C                   EVAL      PMSGDNB = 'ABM0567'
     C                   ELSE
 
     C                   IF        PDDSTS = 'MATURED'
     C                   EVAL      PMSGDNB = 'ABM0568'
     C                   ELSE
     C                   EVAL      PMSGDNB = *BLANK
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        PMSGDNB <> *BLANK
     C                   EVAL      *IN12 = '1'
     C                   EXSR      SRRtvTxt
     C                   MOVEL     PMSGTXT       #1STS
     C                   ENDIF
 
      ** Check if called as linked enquiry
 
     C                   IF        PLnkFlag = 'Y'
     C                   EVAL      *IN23 = '1'
     C                   EVAL      *IN11 = '1'
     C                   ELSE
     C                   EVAL      *IN23 = '0'
     C                   ENDIF
 
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      *IN65 = *ON                                                CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      *IN65 = *OFF                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
 
     C                   IF        CDL019 = 'Y'                                               CDL019
     C                   EVAL      *IN66 = *ON                                                CDL019
     C                   ELSE                                                                 CDL019
     C                   EVAL      *IN66 = *OFF                                               CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL019
     C                   IF        CDL020 = 'Y'                                               CDL020
     C                   EVAL      *IN67 = *ON                                                CDL020
     C                   ELSE                                                                 CDL020
     C                   EVAL      *IN67 = *OFF                                               CDL020
     C                   ENDIF                                                                CDL020
                                                                                              CDL020
      ** Write message subfile, details and footer screen
 
     C                   TIME                    #1TIME
     C                   WRITE     ABFUNDDSF2
     C                   WRITE     ABFUNDDSC1
     C                   WRITE     ABFUNDDSF1
 
      ** Read details screen,
      ** If not write only
 
     C                   IF        WriteOnly <> 'Y'
     C                   READ      ABFUNDDSF1                             01
     C                   ENDIF
 
      ** Clear message subfile
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off
 
     C                   MOVEA     WInzIndArr    *IN(30)
 
      ** Set return keys
 
     C                   EVAL      PINKC = *INKC
     C                   EVAL      PINKG = *INKG
     C                   EVAL      PINKH = *INKH
     C                   EVAL      PINKJ = *INKJ
     C                   EVAL      PINKL = *INKL
     C                   EVAL      PINKP = *INKP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve Text                                      *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMSGDNB
     C                   PARM      'GBDRSMM   '  PMSGNM
     C                   PARM      *BLANK        PMSGTXT
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
 
      /COPY ZACPYSRC,MSGHNDDSP2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing                                  *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Program parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Deal in screen format
      ** Deal Status
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    NwDlScnFmt
     C                   PARM                    PDDSTS
     C                   PARM                    #1PCD1
     C                   PARM                    #1PCD2
 
      ** Fields in error
 
     C                   PARM                    OkFlags
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
 
     C                   PARM                    PKeyFld
     C                   PARM                    PDetFld
 
      ** Enabled function keys
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KJ = Command key 10 = Confirm Delete
      ** KP = Command key 15 = Browse
 
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Succesful insert deal
 
     C                   PARM                    PSInsDl
 
      ** Linked maintenance flag
 
     C                   PARM                    PLnkFlag
 
      ** Write screen with no read indicator
 
     C                   PARM                    WriteOnly
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    PBJMRDT
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    PBKOBRU
     C                   PARM                    PBKPRCU
 
      ** RUNDAT
      ** ======
 
     C                   PARM                    PAGMBIN
                                                                                              CAS004
     C                   PARM                    CAS004                                       CAS004
                                                                                              CDL019
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL020
     C                   PARM                    CDL020                                       CDL020
 
      ** Output parameters
      ** =================
      ** Function keys
 
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
 
      ** Set Screen protect/non-display indicators
      ** =========================================
      ** Single-branching (protect booking branch)
 
     C                   IF        PAGMBIN = 'Y'
     C                   EVAL      *IN16 = '1'
     C                   ELSE
     C                   EVAL      *IN16 = '0'
     C                   ENDIF
 
      ** Originating Branches not used
 
     C                   IF        PBKOBRU = 'Y' AND PAGMBIN = 'Y'
     C                   EVAL      *IN17 = '1'
     C                   ELSE
     C                   EVAL      *IN17 = '0'
     C                   ENDIF
 
      ** Profit Centres not used (protect profit centre)
 
     C                   IF        PBKPRCU = 'Y'
     C                   EVAL      *IN18 = '1'
     C                   ELSE
     C                   EVAL      *IN18 = '0'
     C                   ENDIF
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1USER = PsUser
     C                   EVAL      #1WID  = PsJobName
     C                   EVAL      #1DATE = PBJMRDT
 
      ** Initialise the fixed parameters for ZAMSGHNDLE.
 
     C                   EVAL      ModuleID     = 'AB'
     C                   EVAL      APRPRLOCN    = 'S'
     C                   EVAL      APCNFVALFO   = 'N'
     C                   EVAL      APRespMode   = 'S'
 
      ** Set up the prime and secondary message files for
      ** finding message IDs.
 
     C                   EVAL      #MsgFile     = 'ABUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Message subfile control
 
     C                   EVAL      *IN97 =  '1'
     C                   EVAL      #1PGMQ = '*'
                                                                                              CDL038
      ** Access SAR details file to determine if CDL038 is switched on                        CDL038
      ** (Extended Deal Sub Type)                                                             CDL038
                                                                                              CDL038
     C                   Call      'AOSARDR0'                                                 CDL038
     C                   Parm      *Blanks       @RTCD             7                          CDL038
     C                   Parm      '*VERIFY'     @OPTN             7                          CDL038
     C                   Parm      'CDL038'      @SARD             6                          CDL038
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL038
      *                                                                                       CDL038
     C                   IF        @RTCD = *BLANKS                                            CDL038
     C                   EVAL      *IN24 = *OFF                                               CDL038
     C                   ELSE                                                                 CDL038
     C                   EVAL      *IN24 = *ON                                                CDL038
     C                   ENDIF                                                                CDL038
 
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
 
      ********************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2001
** WInzIndArr
000000000000000000000000000000000000000000000000000000000000
