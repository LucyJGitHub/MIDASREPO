     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate OTC type')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVOTCTYP - Validate OTC Type                                *
      *                                                               *
      *  Function:  This module checks the validity of the OTC type   *
      *             on an FF trade .                                  *
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
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG5882            Date 25Feb05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5882- Insert accepts entry of matured instrument          *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas FF Instrument Type
     FINTYP     IF   E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
      ** Midas FF Instrument type field format
     D InstType      E DS                  EXTNAME(INTYP)
      **                                                                        BUG5882
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    BUG5882
      ** Bank Details                                                           BUG5882
     D DSFDY         E DS                  EXTNAME(DSFDY)                       BUG5882
      ** Short data structure for access programs
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** OTC type
     D SISTT           S              5A
 
      ** Instrument type
     D KISTT           S                   LIKE(SISTT)
 
      ** Instrument processing type
     D SISPT           S              1A
 
      ** Flag to indicate that new instrument details must be written
     D NewInst         S              1A   INZ('N') EXPORT
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      ** Reset the flag indicating that new instrument details must be
      ** written
     C                   RESET                   NewInst
 
      ** Clear the instrument type fields
     C                   CLEAR                   InstType
 
      **
      **   OTC type validation
      **
      **   - O.T.C. Type must be defined
     C     SISTT         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISTT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0679'
 
     C                   ELSE
      **
     C                   MOVE      SISTT         KISTT
     C     KISTT         CHAIN     INTYP                              71
      **
      **   - O.T.C. Type exists
     C     *IN71         IFEQ      '0'
      **
      **   - It must be live
     C     RECI          IFNE      'D'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISST'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0412'
 
     C                   ELSE
      **
      **   - Instrument ind. must be 'Y'
     C     ISTI          IFNE      'Y'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISTT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0413'
 
     C                   ELSE
      **
      **   - Instrument Processing Type must equal that from 1st screen
     C                   MOVE      ISPT          WISPT             1
     C     SISPT         IFNE      WISPT
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SISTT'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0414'
 
     C                   ELSE                                                   BUG5882
     C                   IF        SETD < BJRDNB                                BUG5882
     C                   EVAL      ErrorFound = 'Y'                             BUG5882
     C                   EVAL      XIdx = XIdx + 1                              BUG5882
     C                   EVAL      FldNamXArr(XIdx) = 'SISTT'                   BUG5882
     C                   EVAL      MsgIDXArr(XIdx) = 'APM1001'                  BUG5882
     C                   ENDIF                                                  BUG5882
     C                   END
     C                   END
     C                   END
 
     C                   ELSE
 
      ** Also set the the global flag to indicate that new instrument
      ** data must be written.
     C                   EVAL      NewInst = 'Y'
 
     C                   END
     C                   END
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Return record from Instrument type file
     C                   PARM                    InstType
 
      ** Parameters received from caller
      ** -------------------------------
      ** OTC Type (5A, from transaction)
     C                   PARM                    SISTT
      ** Instrument processing type (1A, from transaction)
     C                   PARM                    SISPT
                                                                                BUG5882
      ** Access Bank details via access program                                 BUG5882
     C                   CALLB     'AOBANKR0'                                   BUG5882
     C                   PARM      '*DBERR '     @RTCD             7            BUG5882
     C                   PARM      '*FIRST '     @OPTN             7            BUG5882
     C     SDBANK        PARM      SDBANK        DSFDY                          BUG5882
 
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
(c) Finastra International Limited 2001
