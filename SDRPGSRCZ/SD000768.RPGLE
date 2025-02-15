     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Exchange of Info Detailed Report-Prompt')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000768 - Exchange of Information Detailed Reprot - Prompt  *
      *                                                               *
      *  Function:  This module provides the input screen for         *
      *             the user  selection input of Exchange of Info     *
      *             Detailed Report                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CGL032 - Automatic Exchange of Information                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
      ** Midas SD Country of Tax Codes - Rtv Idx
     FSDCTTXL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Exchange of Info display file
     FSD000768DFCF   E             WORKSTN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function  of Indicators                                      *
      *                                                               *
      *  01        End of File indicator                              *
      *  10-60     Field Error - highlight screen fields              *
      *  25        Subfile control                                    *
      *  25        Subfile end                                        *
      *  90-99     Used by standard subroutine                        *
      *  KC        F3 pressed = Exit                                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** � Automatically included D-specs       �
      ** � ==============================       �
      ** +--------------------------------------+
 
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
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** � End of automatically included D-specs�
      ** � =====================================�
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** � Manually included D-specs            �
      ** � =========================            �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
      ** +--------------------------------------+
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Externally described DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
      ** Output DS
     D POutFlds        DS           100
     D  PTAXY                  1      4A
     D  PTAXM                  5      6A
     D  PCTRT                  7      8A
     D  PCNCD                  9     10A
 
      ** +--------------------------------------+
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+
 
      ** Work Fields
     D WScrn           S              1A
 
     D PMsgId          S              7A
     D PMsgF           S             10A
     D PMsgD           S             45A
 
 
      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A
 
     D PSequence       S              5A
     D PLevel          S              1A
     D PEntity         S              3A
     D PAct            S              1A
     D PCmd            S              1A
     D WTaxYr#         S              4  0
     D WTaxYr@         S              4
     D WTaxMo#         S              2  0
     D WTaxMo@         S              2
 
      ** +--------------------------------------+
      ** � End of D-specs                       �
      ** � ==============                       �
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** �                                                            �
      ** � *INZSR is executed at program activation.                  �
      ** �                                                            �
      ** +------------------------------------------------------------+
 
      ** Initialise.
 
     C                   EXSR      SRInit
 
      ** Process inputs.
 
     C                   EXSR      SRProc
 
      ** Return.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process inputs                                      *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
      ** Before sending the messages to the program message queue,
      ** clear the program message queue.
 
     C                   CALLB     'ZAMSGCLRPG'
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
      ** Do while SCREEN : Read details.
 
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRDisp
     C                   IF        *INKC = *ON
     C                   EVAL      WScrn = 'E'
     C                   ELSE
     C                   EXSR      SRVal
     C                   ENDIF
     C                   ENDDO
 
      ** Do file update.
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      ** Terminate program.
 
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise variables                                *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   CLEAR                   POutFlds
     C                   CLEAR                   STAXY
     C                   CLEAR                   STAXM
     C                   CLEAR                   SCTRT
     C                   CLEAR                   SCNCD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal - Validate details                                     *
      *                                                               *
      *****************************************************************
     C     SRVal         BEGSR
 
      ** Validate details entered.
 
     C                   EXSR      SRValTxYr
     C                   EXSR      SRValTxMo
     C                   EXSR      SRValTxCtry
     C                   EXSR      SRValRcvCtry
 
      ** If no errors, update output parameter field.
 
     C                   IF        *IN10 = *OFF AND *IN11 = *OFF AND
     C                             *IN12 = *OFF AND *IN13 = *OFF
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update output parameter fields                    *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
     C                   EVAL      PTAXY = STAXY
     C                   EVAL      PTAXM = STAXM
     C                   EVAL      PCTRT = SCTRT
     C                   EVAL      PCNCD = SCNCD
 
     C                   EVAL      WScrn = 'E'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send Message to Screen                              *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
 
      ** Call screen message handler.
 
     C                   CALLB     'ZAMSGTOSCN'
     C                   PARM                    PMsgF
     C                   PARM                    PMsgId
     C                   PARM                    PMsgD
     C                   PARM                    PSProcPgm
     C                   PARM                    PSProcMod
     C                   PARM                    PSProcName
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisp - Display screen                                      *
      *                                                               *
      *****************************************************************
     C     SRDisp        BEGSR
 
      ** Write message subfile, details and footer screens.
 
     C                   TIME                    STIME
     C                   WRITE     SD000768C1
     C                   WRITE     SD000768F1                                               AR656294
     C                   WRITE     SD000768F0
     C**********         WRITE     SD000768F1                                               AR656294
 
      ** Read details screen.
 
     C                   READ      SD000768F0                             01
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Set screen error indicators off.
 
     C                   MOVEA     '0000'        *IN(10)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTxYr - Validate Tax Year                                *
      *                                                               *
      *****************************************************************
     C     SRValTxYr     BEGSR
 
      ** Tax Year is Mandatory
 
     C                   IF        STAXY = *BLANKS
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'USR4718'
     C                   EXSR      SRSndM
     C                   ELSE
 
      ** Tax Year must be numeric
 
     C                   MOVE      STAXY         WTaxYr#
     C                   MOVE      WTaxYr#       WTaxYr@
     C                   IF        WtaxYr@ <> STAXY
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'USR4719'
     C                   EXSR      SRSndM
     C                   ELSE
 
      ** Tax Year must be from 2000 - 2099
 
     C                   IF        WTaxYr# < 2000 or WTaxYr# > 2099
 
     C                   EVAL      *IN10 = *ON
     C                   EVAL      PMsgId = 'USR4719'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTxMo - Validate Tax Month                               *
      *                                                               *
      *****************************************************************
     C     SRValTxMo     BEGSR
 
     C                   IF        STAXM <> *BLANKS
 
      ** Tax Month must be numeric
 
     C                   MOVE      STAXM         WTaxMo#
     C                   MOVE      WTaxMo#       WTaxMo@
 
     C                   IF        STAXM <> WTaxMo@
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'USR4747'
     C                   EXSR      SRSndM
     C                   ELSE
 
      ** Must be a valid month from 01 to 12.
     C
     C                   IF        WTaxMo# < 1 or WTaxMo# > 12
     C                   EVAL      *IN11 = *ON
     C                   EVAL      PMsgId = 'USR4747'
     C                   EXSR      SRSndM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRValTxCtry   BEGSR
 
 
      ** Country of Tax is mandatory.
 
     C                   IF        SCTRT = *BLANKS
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'USR4720'
     C                   EXSR      SRSndM
 
      ** Check if Country of Tax is valid.
 
     C                   ELSE
 
     C     SCTRT         CHAIN     SDCTTXL1
     C                   IF        Not %Found(SDCTTXL1)
     C                   EVAL      *IN12 = *ON
     C                   EVAL      PMsgId = 'USR4721'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRcvCtry -  Validate Receiving Country                   *
      *                                                               *
      *****************************************************************
     C     SRValRcvCtry  BEGSR
 
 
      ** Check if Receiving Country is valid.
 
     C                   IF        SCNCD <> *BLANKS
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      SCNCD         PCncd
     C     SDCTRY        PARM      SDCTRY        DSFDY
     C                   IF        PRTCD <> *BLANKS
 
      ** Receiving Country must be a valid Country Code.
 
     C                   EVAL      *IN13 = *ON
     C                   EVAL      PMsgId = 'USR4748'
     C                   EXSR      SRSndM
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSequence
     C                   PARM                    PLevel
     C                   PARM                    PEntity
     C                   PARM                    POutFlds
     C                   PARM                    PAct
     C                   PARM                    PCmd
 
      ** Access bank details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WScrn = 'P'
 
     C                   EVAL      PMsgf = 'GBSDUSRMSG'
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SWSID = PsJobName
 
      ** Message subfile control and program queue initialisation.
 
     C                   MOVE      *ON           *IN25
     C                   MOVEL     '*'           SPGM
 
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
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2004
