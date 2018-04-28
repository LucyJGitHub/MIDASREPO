     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Collateralised Lending Fields')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Date Module Customer Details Validation     *
      *                                                               *
      *  SDVCOLL  - Validate Collateralised Lending Fields            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG3644            Date 12Jul04               *
      *  Prev Amend No. CFX001             Date 20Oct03               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CFX001 - FX Margin Trading                                   *
      *  CLE025 - Multi-Option Facilities                             *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
      ** Data structure for access objects, short DS                                          CFX001
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CFX001
                                                                                              CFX001
      ** Data structure for Margin Schedule Type details                                      CFX001
     D SDMAST        E DS                  EXTNAME(SDMASTPD)                                  CFX001
                                                                                              CFX001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D PRetCode        S              7                                                       CFX001
     D POption         S              7                                                       CFX001
     D CLE025          S              1                                                       CFX001
     D CFX001          S              1                                                       CFX001
     D DDFCMF          S              1
     D DDINOF          S              1
     D DDMSTF          S              3
     D DDIOPC          S              1
     D DDFCMFOK        S              1
     D DDINOFOK        S              1
     D DDMSTFOK        S              1
     D DDIOPCOK        S              1
 
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
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = 0
 
     C                   IF        CLE025 = 'Y'
     C                             OR  CFX001 = 'Y'                                           CFX001
 
      ** Facility Mandatory
 
     C                   EXSR      VFCMF
 
      ** Include Offsets
 
     C                   EXSR      VINOF
 
      ** Include Offsets in Pre-deal Check
 
     C                   EXSR      VIOPC
 
      ** Margin Schedule Type
 
     C                   EXSR      VMSTF
     C                   ENDIF
 
      ** If an error was found, set the return code appropriately
 
     C                   IF        DDFCMFOK = 'N'  OR  DDINOFOK = 'N'
     C                             OR  DDIOPCOK = 'N'  OR  DDMSTFOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Facility Mandatory flag
      *****************************************************************
 
     C     VFCMF         BEGSR
 
      ** Default to 'N' when left blank
 
     C                   IF        DDFCMF = *BLANK
     C                   EVAL      DDFCMF = 'N'
 
      ** Must be 'Y' or 'N' when entered
 
     C                   ELSE
 
     C                   IF        DDFCMF <> 'Y'  AND  DDFCMF <> 'N'
     C                   EVAL      DDFCMFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDFCMF'
     C                   EVAL      MsgIdXAr(Idx) = 'USR4020'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Validate Include Offsets flag
      *****************************************************************
 
     C     VINOF         BEGSR
 
      ** Default to valid Facility Mandatory when left blank
 
     C                   IF        DDINOF = *BLANK  AND  DDFCMFOK <> 'N'
     C                   EVAL      DDINOF = DDFCMF
 
      ** Must be 'Y' or 'N' when entered
 
     C                   ELSE
 
     C                   IF        DDINOF <> *BLANK  AND  DDINOF <> 'Y'  AND
     C                             DDINOF <> 'N'
     C                   EVAL      DDINOFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDINOF'
     C                   EVAL      MsgIdXAr(Idx) = 'USR4021'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Validate Include Offsets in Pre-deal Check flag
      *****************************************************************
 
     C     VIOPC         BEGSR
 
      ** Default to 'N' when left blank
 
     C                   IF        DDIOPC = *BLANK
     C                   EVAL      DDIOPC = 'N'
 
      ** Must be 'Y' or 'N' when entered
 
     C                   ELSE
 
     C                   IF        DDIOPC <> 'Y'  AND  DDIOPC <> 'N'
     C                   EVAL      DDIOPCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDIOPC'
     C                   EVAL      MsgIdXAr(Idx) = 'USR4040'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Validate FX Margin Type
      *****************************************************************
 
     C     VMSTF         BEGSR
 
      ** Check if Margin Schedule Type is valid (must exist in the system)
 
     C                   IF        DDMSTF <> *BLANKS
 
     C                   CALLB     'AOMASTR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    DDMSTF
     C     SDMAST        PARM      SDMAST        DSFDY
 
     C                   SELECT
     C                   WHEN      PRetCode <> *BLANKS    AND
     C                             PRetCode <> '*NRF   '  AND
     C                             PRetCode <> '*NOSEL '
     C                   EVAL      DBFILE = 'SDMASTPD'
     C                   EVAL      DBKEY  = DDMSTF
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
 
     C                   WHEN      PRetCode = '*NRF   '
     C                   EVAL      DDMSTFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMSTF'
     C                   EVAL      MsgIdXAr(Idx) = 'USR4026'
 
     C                   WHEN      PRetCode = '*NOSEL '
     C                   EVAL      DDMSTF = *BLANKS
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return code
      ** Facility Mandatory
      ** Include Offsets
      ** FX Margin Type
      ** Include Offsets in Pre-deal check
 
     C                   PARM                    RetCodeIn
     C                   PARM                    DDFCMF
     C                   PARM                    DDINOF
     C                   PARM                    DDMSTF
     C                   PARM                    DDIOPC
                                                                                              CFX001
      ** Switchable features                                                                  CFX001
                                                                                              CFX001
     C                   PARM                    CLE025                                       CFX001
     C                   PARM                    CFX001                                       CFX001
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Facility Mandatory OK flag
      ** Include Offsets OK flag
      ** FX Margin Type OK flag
      ** Include Offsets in Pre-deal Check OK flag
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDFCMFOK
     C                   PARM                    DDINOFOK
     C                   PARM                    DDMSTFOK
     C                   PARM                    DDIOPCOK
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
