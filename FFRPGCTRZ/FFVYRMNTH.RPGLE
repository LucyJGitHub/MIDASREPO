     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate month/year number')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVYRMNTH - Validate month and year                          *
      *                                                               *
      *  Function:  This module checks the validity of the month and  *
      *             the year on an FF trade .                         *
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
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
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
 
      **   Current Trading date - (MMDDYY or DDMMYY)
     D                 DS
     D  CTD                    1      6
     D  CT1                    1      2
     D  CT2                    3      4
     D  CT3                    5      6
 
      **   Current Year-Month
     D                 DS
     D  CYM                    1      6  0
     D  CCN                    1      2  0
     D  CY                     3      4  0
     D  CM                     5      6  0
 
     **    Work/Screen input  Year-Month
     D                 DS
     D  WYM                    1      6  0
     D  WCN                    1      2  0
     D  WY                     3      4  0
     D  WM                     5      6  0
 
     **    'Furthest Fwd Traded Period'/ Maximum Traded Year-Month
     D                 DS
     D  MTYM                   1      6  0
     D  MTCN                   1      2  0
     D  MTY                    3      4  0
     D  MTM                    5      6  0
 
     **    'Furthest Forward Spot'/ Maximum Spot Year-Month
     D                 DS
     D  MSYM                   1      6  0
     D  MSCN                   1      2  0
     D  MSY                    3      4  0
     D  MSM                    5      6  0
 
      ** OK flags data structure
     D FFEEXTR       E DS                  EXTNAME(FFEEXTRPD)
 
     **    Instrument Months Quoted
     D IMQ             S              1    DIM(12)
 
     **    Months Short Names
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
 
     D InstTypes     E DS                  EXTNAME(INTYPD)
      ** Instrument types
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Month number
     D SMTHN           S              3A
 
      ** Year number
     D SYRNO           S              2A
 
      ** Month index number used to look up month array
     D WMTHN           S              2S 0
 
      ** Year number work fields
     D WYRNO           S                   LIKE(WMTHN)
 
      ** If Market instrument field is not blank , this is the Market
      ** instrument date else this is the run date.
     D CTDATE          S              5P 0
 
      ** Rundate format , if 'M'= MMDDYY else = DDMMYY
     D PDATF           S              1A
 
      ** Work field for TESTN opcode
     D WTSTN3          S              3A   INZ('  0')
 
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
 
      **   Month/year validation
 
      **   Month
     C                   Z-ADD     1             M                 2 0
     C     SMTHN         LOOKUP    ZMNM(M)                                76
 
      **   - if not valid short name
     C     *IN76         IFEQ      '0'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMTHN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0368'
     C                   EVAL      OKMTHN = 'N'
 
 
     C                   ELSE
     C                   Z-ADD     M             WMTHN
     C                   Z-ADD     WMTHN         WM
     C                   END
 
      **   Year
     C                   MOVEL     SYRNO         WTSTN3
     C                   TESTN                   WTSTN3               75
      **   - if not numeric
     C     *IN75         IFEQ      '0'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SYRNO'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0369'
     C                   EVAL      OKYRNO = 'N'
 
 
     C                   ELSE
     C                   MOVE      SYRNO         WYRNO
     C                   Z-ADD     WYRNO         WY
 
      * Midas Calendar began in 1972, so if Year is *LT 72, it must be
      * in the next Century.
 
     C                   Z-ADD     0             WCN
     C     WY            IFLT      72
     C                   Z-ADD     20            WCN
     C                   ELSE
     C                   Z-ADD     19            WCN
     C                   END
 
     C                   END
 
     C     OKISTC        IFNE      'Y'
     C     ErrorFound    OREQ      'Y'
     C                   GOTO      VYMEND
     C                   END
     C/SPACE 2
      **   Year/Month - must represent valid  Traded/Forward Spot month
      **   ( WYM )
      **   1. Determine Current Trading Year-Month
     C                   CALLB     'ZDATE2'
     C                   PARM      CTDATE        ZDAYNO            5 0          Value date
     C                   PARM      PDATF         BJDFIN            1            Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         CTD
 
     C                   MOVE      CT3           CY
 
      * Midas Calendar began in 1972, so if Year is *LT 72, it must be
      * in the next Century.
 
     C                   Z-ADD     0             CCN
     C     CY            IFLT      72
     C                   Z-ADD     20            CCN
     C                   ELSE
     C                   Z-ADD     19            CCN
     C                   END
 
      ** If = 'M' use MMDDYY as the date else use DDMMYY as the date format
     C     PDATF         COMP      'M'                                    98
     C     *IN98         IFEQ      '1'
     C                   MOVE      CT1           CM
     C                   ELSE
     C                   MOVE      CT2           CM
     C                   END
 
      **   - must not be before  Current Year-Month
     C     WYM           IFLT      CYM
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMTHN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0370'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYRNO = 'N'
 
     C                   GOTO      VYMEND
     C                   END
 
      **   2. Determine 'Furthest Traded Fwd Period' / Max. Year-Month
     C                   Z-ADD     CM            MTM
     C                   Z-ADD     CY            MTY
     C                   MOVEA     ISMQ          IMQ
     C                   Z-ADD     0             Q                 2 0
 
     C     Q             DOWLT     TFPD
      **     - traded month
     C     IMQ(MTM)      IFEQ      'Y'
     C                   ADD       1             Q
     C                   END
 
     C     Q             IFNE      TFPD
     C                   ADD       1             MTM
      **     - new year
     C     MTM           IFGT      12
     C                   Z-ADD     1             MTM
     C                   ADD       1             MTY
     C                   END
 
     C                   END
 
     C                   END
 
      * Midas Calendar began in 1972, so if Year is *LT 72, it must be
      * in the next Century.
 
     C                   Z-ADD     0             MTCN
     C     MTY           IFLT      72
     C                   Z-ADD     20            MTCN
     C                   ELSE
     C                   Z-ADD     19            MTCN
     C                   END
 
      **   - must not be after  Maximum Traded Year-Month (Furthest TFPD)
     C     WYM           IFGT      MTYM
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMTHN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0370'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYRNO = 'N'
 
     C                   GOTO      VYMEND
     C                   END
 
      **   3. Quoted Traded Month ?
     C     IMQ(WM)       IFEQ      'Y'
      **     - valid Year-Month
     C                   GOTO      VYMEND
     C                   END
      *
      * If not a quoted month and Fwd Spot Months is zero the date is
      * in error.
     C     FSPM          IFEQ      0
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMTHN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0370'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYRNO = 'N'
 
     C                   GOTO      VYMEND
     C                   END
 
      **   4. Determine 'Furthest Fwd Spot' / Max. Spot Year-Month
 
     C                   Z-ADD     CM            MSM
     C                   Z-ADD     CY            MSY
     C                   Z-ADD     0             Q
 
     C     Q             DOWLT     FSPM
 
     C                   ADD       1             Q
 
     C     Q             IFNE      FSPM
     C                   ADD       1             MSM
      **     - new year
     C     MSM           IFGT      12
     C                   Z-ADD     1             MSM
     C                   ADD       1             MSY
     C                   END
 
     C                   END
 
     C                   END
 
      * Midas Calendar began in 1972, so if Year is *LT 72, it must be
      * in the next Century.
 
     C                   Z-ADD     0             MSCN
     C     MSY           IFLT      72
     C                   Z-ADD     20            MSCN
     C                   ELSE
     C                   Z-ADD     19            MSCN
     C                   END
 
      **   - must not be after  Maximum Spot Year-Month (Furthest FSPM)
     C     WYM           IFGT      MSYM
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SMTHN'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0370'
     C                   EVAL      OKMTHN = 'N'
     C                   EVAL      OKYRNO = 'N'
 
     C                   END
 
     C     VYMEND        TAG
 
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
      ** Outputs to this procedure
      ** -------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Numeric version of month number
     C                   PARM                    WMTHN
      ** Numeric version of year number
     C                   PARM                    WYRNO
 
      ** Input/output
      ** ------------
      ** OK flags (data structure)
     C                   PARM                    FFEEXTR
 
      ** Inputs to this procedure
      ** ------------------------
      ** Month number (3A, from screen)
     C                   PARM                    SMTHN
      ** Year number (2A, from screen)
     C                   PARM                    SYRNO
      ** Instrument date/run date (5,0P from transaction)
     C                   PARM                    CTDATE
      ** Run date format (1A from caller)
     C                   PARM                    PDATF
      ** The instrument types format (data strucure)
     C                   PARM                    InstTypes
 
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
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
