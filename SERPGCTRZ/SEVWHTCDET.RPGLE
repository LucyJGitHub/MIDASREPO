     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate withholding tax customer details')   *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVWHTCDET - This module validates the withholding tax       *
      *               customer details.                               *
      *                                                               *
      *  Component of: SETRADSIN                                      *
      *                SETRADCTL                                      *
      *                SETRADRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CSD079             Date 05Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023  *CREATE    Date 12Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD079 - Enhanced Customer Maintenance API (Recompile)       *
      *  CSE023 - Treaty Withholding Tax                              *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Withholding tax customers details - retrieve
     FSDWTCSL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Withholding tax treaty details - retrieve
     FSDWHTTL5  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the SE standard declares
      /COPY SECPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of warning error message ids, etc.
     D WIx             S              3P 0
      *
      ** Work parameters
     D DDTDTP          S              2A
     D DDSESN          S             10A
     D CustNum         S              6A
     D PSITP           S              3A
     D PCOLC           S              2A
     D PCRTT           S              2A
     D PDRBW           S              2A
      *
     D WSITP           S              3A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise work variables.
      *
     C                   EVAL      WIx = 0
      *
      ** Validate customer withholding tax detail
      *
     C                   EXSR      SRVWHTax
      *
      ** End procedure
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVWHTax - Validation customer withholding tax detail        *
      *                                                               *
      *****************************************************************
     C     SRVWHTax      BEGSR
      *
      ** Check withholding tax customer details for the customer and
      ** country of tax combination.
      *
     C     KCustCntry    CHAIN     SDWTCSL1                           01
 
     C                   SELECT
      *
      ** Trade Purchase
     C                   WHEN      DDTDTP = 'TP'
      *
      ** Customer and country of tax combination exist on withholding tax
      ** customer details and backup withholding indicator is 'Y'.
      *
     C                   IF        *IN01 = *ON OR WHBCWA = 'Y'
      *
      ** Issue warning, 'This is a sale for a customer for whom backup
      ** withholding applies.'
     C                   ADD       1             WIx
     C                   MOVEL     '*ANY   '     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0424'     WMsgIDxAr(WIx)
      *
      ** Get default basket for backup withholding, DBerror if not
      ** found.
     C     KWHTax        CHAIN     SDWHTTL5                           02
     C                   IF        *IN02 = *ON
     C                   EVAL      WSITP = PSITP
     C                   EVAL      PSITP = *BLANKS
     C     KWHTax        CHAIN     SDWHTTL5                           02
     C                   EVAL      PSITP = WSITP
     C                   ENDIF
 
     C                   IF        *IN02 = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  = PCRTT + PSITP + PCOLC
     C                   EVAL      DBFILE = 'SDWHTTPD'
     C                   EVAL      DBASE  = 01
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PDRBW = WTDRBW
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Trade Sale
     C                   OTHER
      *                  =====
 
     C                   IF        *IN01 = *ON OR WHBCWA = 'Y'
      *
      ** Issue warning, 'This is a purchase for a customer for whom backup
      ** withholding applies.'
     C                   ADD       1             WIx
     C                   MOVEL     '*ANY   '     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0425'     WMsgIDxAr(WIx)
     C                   ENDIF
      *
      ** If trade sale (TS) and customer + country of treaty combination
      ** is not found in withholding tax customer details or documentaion
      ** received indicator is 'N'.  Issue warning, 'Purchase is being
      ** made for a customer without the necessary documentation'.
      *
     C                   IF        *IN01 = *ON OR WHDCRC = 'N'
     C                   ADD       1             WIx
     C                   MOVEL     '*ANY   '     WFldNmXAr(WIx)
     C                   MOVEL     'SEA0426'     WMsgIDxAr(WIx)
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *
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
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Trade type
     C                   PARM                    DDTDTP
      *
      ** Security shortname
     C                   PARM                    DDSESN
      *
      ** Customer number
     C                   PARM                    CustNum
      *
      ** Investment type from PF/SECTYD
     C                   PARM                    PSITP
      *
      ** Country of location from PF/SDCUSTPD
     C                   PARM                    PCOLC
      *
      ** Country of treaty from PF/SECTYD
     C                   PARM                    PCRTT
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Default basket for backup withholding
     C                   PARM                    PDRBW
      *
      ** Key list for withholding tax customer details
     C     KCustCntry    KLIST
     C                   KFLD                    CustNum
     C                   KFLD                    PCRTT
      *
      ** Key list for withholding tax treaty details
     C     KWHTax        KLIST
     C                   KFLD                    PCRTT
     C                   KFLD                    PSITP
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
