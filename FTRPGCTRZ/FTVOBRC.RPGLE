     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate Orig. Branch')       *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVOBRC - Midas FT Nostro Transfer Validate Originating      *
      *            Branch                                             *
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
 
      ** External DS for Branch Codes
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External DS for GL ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D RUNDAT          DS
     D  @MBIN                 13     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D PRTCD           S              7
     D POPTN           S              7
     D PBRCA           S              3
     D ERR             S              1  0
 
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
 
      ** If Multi-branching and Originating Branch Used are 'Y',
 
     C                   IF        @MBIN = 'Y' AND
     C                             BKOBRU = 'Y'
 
      ** If originating branch not entered, default to booking
      ** branch
     C                   IF        NTOBRC = *BLANKS
     C                   EVAL      NTOBRC = NVBRCA
     C                   ENDIF
 
      ** Validate branch code
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      NTOBRC        PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C                   IF        PRTCD <> *BLANKS
      *
     C                   EVAL      OKOBRC = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTOBRC    '
     C                   EVAL      MsgIdXAr(Idx) = '5047427'
     C                   GOTO      EMAIN
      *
     C                   ENDIF
 
      ** If not in enquiry, check authority to originating
      ** branch if required
     C                   IF        BKOBUV = 'Y'
      *
     C                   CALL      'ZVOBU'
     C                   PARM                    PBRCA
     C                   PARM                    ERR
      *
     C                   IF        ERR <> 0
     C
     C                   EVAL      OKOBRC = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'NTOBRC    '
     C                   IF        ERR = 1
     C                   EVAL      MsgIdXAr(Idx) = '5047428'
     C                   ELSE
     C                   EVAL      MsgIdXAr(Idx) = '5047429'
     C                   ENDIF
     C                   GOTO      EMAIN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
 
      ** If multi-branching indicator is 'Y' and originating branch
      ** not used, default to booking branch
     C                   IF        @MBIN = 'Y' AND
     C                             BKOBRU <> 'Y'
     C                   EVAL      NTOBRC = NVBRCA
     C                   ENDIF
 
      ** Move value to valid file
     C                   EVAL      NVORBR = NTOBRC
 
      * RETURN
 
     C     EMAIN         TAG
 
     C                   RETURN
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
 
     C                   CALL      'AOGELRR1'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
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
