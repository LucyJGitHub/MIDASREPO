     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate Value Date')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVVDAT - Midas FT Nostro Transfer Validate Value Date       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP212 - FT Nostro Transfer API                              *
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
 
      ** Transfer Details in screen format
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)
 
      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)
 
      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D PRTCD           S              7
     D POPTN           S              7
     D WDATE1          S              6  0
     D WDATE2          S              2  0
     D WDATE3          S              6  0
     D WDATE4          S              4  0
     D WDATE5          S              2  0
     D WDATE6          S              2  0
 
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE
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
 
     C                   MOVE      *BLANK        ReturnCode
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      *
      ** VALIDATION
 
      ** Value Date must be entered
     C                   IF        NTVDAT = *BLANK
      *
     C                   EVAL      OKVDAT = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTVDAT    '
     C                   EVAL      MsgIdXAr(Idx) = '5047434'
     C                   GOTO      EMAIN
      *
     C                   ENDIF
 
      ** Must be a valid date
     C                   MOVE      *BLANKS       ZDATE
     C                   MOVE      NTVDAT        ZDATE
     C                   EXSR      ZDATE1
     C                   IF        *IN99 = *ON
      *
     C                   EVAL      OKVDAT = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTVDAT    '
     C                   EVAL      MsgIdXAr(Idx) = '5047435'
     C                   GOTO      EMAIN
      *
     C                   ENDIF
 
      ** Do next validation only if currency is valid
     C                   IF        OKCCY <> 'Y'
     C                   GOTO      EMAIN
     C                   ENDIF
 
      ** Check if value date is holiday in the local currency.
      ** Send warning if it is.
     C                   EVAL      ZCCY = NVCCY
     C                   EVAL      ZLOC = *BLANKS
      *
     C                   EXSR      ZCHKH
      *
     C                   IF        ZIND = 'H'
     C                   ADD       1             WIdx
     C                   EVAL      WFldNmXAr(WIdx) = 'NTVDAT    '
     C                   EVAL      WMsgIdXAr(WIdx) = '5047436'
     C                   ENDIF
 
      ** Move value to valid file
     C                   EVAL      NVVDAT = ZDAYNO
     C                   MOVE      NTVDAT        NVVDAT1
     C                   MOVE      NVVDAT1       WDATE1
     C                   EXSR      DAFDT
     C                   MOVE      WDATE2        NVVDAT2
     C                   MOVE      WDATE3        NVVDAT3
 
      * RETURN
 
     C     EMAIN         TAG
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * DAFDT - Subroutine to obtain DAF date formats 'CC' & 'YYMMDD' *
      *****************************************************************
     C     DAFDT         BEGSR
 
     C                   MOVE      WDATE1        WDATE2
     C                   MOVEL     WDATE1        WDATE4
 
     C                   IF        *IN98 = *ON
     C                   MOVE      WDATE4        WDATE3
     C                   MOVEL     WDATE2        WDATE3
     C                   ELSE
     C                   MOVE      WDATE4        WDATE5
     C                   MOVEL     WDATE4        WDATE6
     C                   MOVEL     WDATE5        WDATE4
     C                   MOVE      WDATE6        WDATE4
     C                   MOVE      WDATE4        WDATE3
     C                   MOVEL     WDATE2        WDATE3
     C                   ENDIF
 
     C                   IF        WDATE2 < 72
     C                   MOVE      '20'          WDATE2
     C                   ELSE
     C                   MOVE      '19'          WDATE2
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      * OK Flags
     C                   PARM                    OKTrnDets
      *
      * Validation Fields
     C                   PARM                    ValidNoTr
      *
      * Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        BJDFIN = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
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
     C/COPY ZSRSRC,ZDATE1Z2LE
      ********************************************************************
     C/COPY ZSRSRC,ZCHKHLE
      ********************************************************************
     C/COPY ZSRSRC,ZACCHLE
      *****************************************************************
      /EJECT
      ********************************************************************
** CPY@   **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2014
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
