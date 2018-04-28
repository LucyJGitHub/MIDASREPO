     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Up-Front Fee Value Date')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRVUPVD01 - Validate Up-Front Fee Value Date                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
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
      *  Last Amend No. 218649             Date 10Jul03               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  218649 - The system does not allow the entry of Up-Front Fee *
      *           Value Date that is equal to the Maturity Date.      *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
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
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D/COPY QWINDSRC,IRSIRSGDTA
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D BJDFIN          S              1A
     D BJLCCY          S              3A
     D BJSLCD          S              3A
     D PZCcy           S              3A
     D PZLoc           S              3A
     D PErrFlag        S              1A
     D PZInd           S              1A
     D PZDate          S              6A
     D PZDayNo         S              5P 0
     D WUFVD           S              5P 0
     D PWPSCY          S              3A
     D PWPNLOC         S              3A
     D PWRNLOC         S              3A
     D PWRSCY          S              3A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *
      ** Validate Up-Front Fee Value date
      *
     C                   EXSR      SRValUfVd
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKUFVD = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ENDIF
 
     C                   IF        OKUFVD <> 'N'
     C                   Z-ADD     WUFVD         #1UPVD
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValUfVd - Validation for Up-Front Fee Value Date           *
      *                                                               *
      *****************************************************************
     C     SRValUfVd     BEGSR
 
     C                   Z-ADD     *ZERO         WUFVD
 
     C                   IF        SUFVD = *BLANKS
 
     C                   IF        SUFEE <> *BLANKS OR
     C                             SUFPR <> *BLANKS
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKUFVD = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SUFVD'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00011'
     C                   ENDIF
 
     C                   GOTO      ESRValUfVd
     C                   ENDIF
 
     C                   TESTN                   SUFVD                01
 
     C                   IF        *IN01
 
     C                   MOVE      SUFVD         PZDate
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZdate
     C                   PARM      *ZEROS        PZDayno
     C                   PARM                    BJDFIN
     C                   PARM                    PErrFlag
 
     C                   ENDIF
      *
      ** Must be a valid date
      *
     C     PErrFlag      IFEQ      '1'
     C     *IN01         OREQ      '0'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKUFVD = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SUFVD'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00012'
     C                   GOTO      ESRValUfVd
     C                   ENDIF
      *
      ** Must be greater than or equal to deal date AND
      ***less*than*maturity*date.**************************************                       218649
      ** less than or equal to the maturity date.                                             218649
      *
     C     PZDayno       IFLT      #1DDAT
     C*****PZDayno       ORGE      #1MDAT                                                     218649
     C     PZDayno       ORGT      #1MDAT                                                     218649
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      OKUFVD = 'N'
     C                   EVAL      FldNamXAr(IDx) = 'SUFVD'
     C                   EVAL      MsgIdXAr(IDx) = 'RS00013'
     C                   GOTO      ESRValUfVd
     C                   ENDIF
      *
      ** Warning: Must be less than or equal to deal value date.
      *
     C     PZDayno       IFGT      #1VDAT
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      OKUFVD = 'W'
     C                   EVAL      WFldNmXAr(Widx) = 'SUFVD'
     C                   EVAL      WMsgIdXAr(Widx) = 'RS00014'
     C                   ENDIF
 
     C                   Z-ADD     PZDayno       WUFVD
      *
      ** Check if the Up-Front Fee value date is a holiday
      *
     C     WUFVD         IFEQ      *ZEROS
     C                   GOTO      ESRValUfVd
     C                   ENDIF
 
     C     SUFPR         IFEQ      'P'
 
     C     #1USEN        IFEQ      01
     C     #1USEN        OREQ      02
     C     #1USEN        OREQ      07
     C     #1USEN        OREQ      08
     C     #1USEN        OREQ      12
 
     C                   Z-ADD     WUFVD         PZDayno
     C                   MOVEL     PWPSCY        PZCcy
     C                   MOVEL     PWPNLOC       PZLoc
     C                   EXSR      SRHol
 
     C     PZind         IFEQ      'H'
      *
      ** Warning: Holiday in Our currency
      *
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      OKUFVD = 'W'
     C                   EVAL      WFldNmXAr(Widx) = 'SUFVD'
     C                   EVAL      WMsgIdXAr(Widx) = 'RS00015'
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     WUFVD         PZDayno
     C                   MOVEL     BJLCCY        PZCcy
     C                   MOVEL     BJSLCD        PZLoc
     C                   EXSR      SRHol
 
     C     PZind         IFEQ      'H'
      *
      ** Warning: Holiday in local currency
      *
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      OKUFVD = 'W'
     C                   EVAL      WFldNmXAr(Widx) = 'SUFVD'
     C                   EVAL      WMsgIdXAr(Widx) = 'RS00016'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     SUFPR         IFEQ      'R'
     C     #1TSEN        IFEQ      01
     C     #1TSEN        OREQ      02
     C     #1TSEN        OREQ      07
     C     #1TSEN        OREQ      08
     C     #1TSEN        OREQ      12
 
     C                   Z-ADD     WUFVD         PZDayno
     C                   MOVEL     PWRSCY        PZCcy
     C                   MOVEL     PWRNLOC       PZLoc
     C                   EXSR      SRHol
 
     C     PZind         IFEQ      'H'
      *
      ** Warning: Holiday in Their currency
      *
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      OKUFVD = 'W'
     C                   EVAL      WFldNmXAr(Widx) = 'SUFVD'
     C                   EVAL      WMsgIdXAr(Widx) = 'RS00017'
     C                   ENDIF
 
     C                   ELSE
 
     C                   MOVE      BJLCCY        PZCcy
     C                   Z-ADD     WUFVD         PZDayno
     C                   MOVE      BJSLCD        PZLoc
     C                   EXSR      SRHol
 
     C     PZind         IFEQ      'H'
      *
      ** Warning: Holiday in local currency
      *
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      OKUFVD = 'W'
     C                   EVAL      WFldNmXAr(Widx) = 'SUFVD'
     C                   EVAL      WMsgIdXAr(Widx) = 'RS00016'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C     ESRValUfVd    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRHol - Check if value date is a holiday                     *
      *                                                               *
      *****************************************************************
     C     SRHol         BEGSR
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDayno
     C                   PARM                    PZccy
     C                   PARM                    PZLoc
     C                   PARM                    PZInd
 
     C     ESrHol        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Settlement currency
      ** Receivers currency
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
      *
      ** Nostro Locations
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDLCCY - Location code
     C                   PARM                    BJLCCY
      *
      ** SDSLCD - System location code
     C                   PARM                    BJSLCD
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
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
(c) Misys International Banking Systems Ltd. 2002
