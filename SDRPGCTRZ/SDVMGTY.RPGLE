     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Margin Type')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVMGTY  - Validate Margin Type                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP034  *CREATE    Date 01Apr99               *
      *                                    Date DDMmmYY               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      ** Zoned decimal definition for output parameter DS field
     D CUMTSC          S              2S 0
 
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
 
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   MOVE      *ZEROS        CUMTSC
 
      ** comments
 
      *
      ** VALIDATION
      *
     C                   EXSR      MTSCV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDMTSCOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION - Margin Type
      *****************************************************************
     C     MTSCV         BEGSR
 
      * If switchable feature Customer Margins is ON
     C     CDL001        IFEQ      'Y'
 
      * If bank/non-bank indicator is non-bank
     C     DDBNBI        IFEQ      'N'
 
      * Margin type must be entered
     C     DDMTSC        IFEQ      *BLANK
     C                   MOVE      'N'           DDMTSCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTSC'      FldNamXAr(Idx)
     C                   MOVEL     'USR2850'     MsgIdXAr(Idx)
 
     C                   ELSE
 
      * check if numeric
     C                   MOVE      *BLANK        WKMTSC
     C                   MOVEL     DDMTSC        WKMTSC
     C                   CALL      'ZALIGN'
      ** Return Code (7A)
      ** Screen Field (16A)
      ** Number of Decimals (1,0)
      ** Number of Digits (2,0)
      ** File Field (16A)
     C                   PARM                    @RTCD             7
     C                   PARM                    WKMTSC           16
     C                   PARM      *ZERO         DECNUM            1 0
     C                   PARM      2             DIGNUM            2 0
     C                   PARM      *BLANK        WKMTSCF          16
 
      * error if not numeric
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'N'           DDMTSCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTSC'      FldNamXAr(Idx)
     C                   MOVEL     'USR2851'     MsgIdXAr(Idx)
 
     C                   ELSE
 
     C                   MOVE      WKMTSCF       CUMTSC
 
      * if numeric, must be 1 - 99
     C     CUMTSC        IFLT      1
     C     CUMTSC        ORGT      99
     C                   MOVE      'N'           DDMTSCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTSC'      FldNamXAr(Idx)
     C                   MOVEL     'USR2851'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C     DDMTSC        IFEQ      *BLANK
     C                   Z-ADD     0             CUMTSC
     C                   ELSE
     C                   MOVE      'N'           DDMTSCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMTSC'      FldNamXAr(Idx)
     C                   MOVEL     'USR2852'     MsgIdXAr(Idx)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     0             CUMTSC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Customer Margins Switchable Feature (1A)
      ** Bank/Non-bank Indicator (1A)
      ** Margin Type Alpha (2A)
      *
     C                   PARM                    CDL001            1
     C                   PARM                    DDBNBI            1
     C                   PARM                    DDMTSC            2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Margin Type - OK
     C                   PARM                    DDMTSCOK          1
      *
      ** Margin Type Numeric (2,0)
      *
     C                   PARM                    CUMTSC            2 0
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
(c) Finastra International Limited 2001
