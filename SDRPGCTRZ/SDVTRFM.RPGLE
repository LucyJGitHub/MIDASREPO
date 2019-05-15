     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate TI Transfer Method')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Trade Innovation Interface    *
      *                                 details data                  *
      *                                                               *
      *  SDVTRFM - Validate TI Transfer Method                        *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, TI Interface Details amendments must not be         *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
      ** DS for Access Object incoming Data
     D SDTICS        E DS                  EXTNAME(SDTICSPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D D1TRFM          DS
     D CHAR1                   1      1
     D CHAR2                   2      2
 
      ** Transfer Methods
     D WWTRFM          S              2    DIM(13) CTDATA PERRCD(13)
      ** Alphanumeric
     D ALPHAN          S              1    DIM(36) CTDATA PERRCD(36)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDTRFM          S              2A
     D DDCUSN          S              6A
     D DDBNBI          S              1A
     D DDTRFMOK        S              1A
 
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
     C                   Z-ADD     0             WIdx
 
      ** Validation
      ** Check TI Transfer Method is Blank
     C                   IF        DDTRFM = *BLANK
 
     C                   CALL      'AOTICSR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDCUSN
     C     SDTICS        PARM      SDTICS        DSFDY
     C                   IF         TCTRFM =   ' '
     C
     C                   IF         DDBNBI = 'Y'
     C                   EVAL       DDTRFM = 'SW'
     C                   ELSE
     C                   EVAL       DDTRFM = 'MT'
     C                   ENDIF
     C                   ELSE
      ** Setup message data for message
     C                   EVAL      DDTRFMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTRFM'
     C                   EVAL      MsgIdXAr(Idx) = 'USR3543'
     C                   GOTO      EMAIN
     C                   ENDIF
 
     C                   ELSE
 
      ** CASE: IF TRANSFER METHOD NOT BLANK
     C                   EVAL      D1TRFM = DDTRFM
     C                   EVAL      *IN74 = '0'
     C                   EVAL      *IN75 = '0'
     C     CHAR1         LOOKUP    ALPHAN                                 74
     C                   IF        *IN74 = '1'
     C     CHAR2         LOOKUP    ALPHAN                                 75
     C                   IF        *IN75 = '1'
     C     DDTRFM        LOOKUP    WWTRFM                                 73
     C                   IF        *IN73 = '0'
 
      ** Send warning message : 'TI Transfer Method does not match one of
      ** the basic TI transfer methods.'
     C                   EVAL      DDTRFMOK = 'W'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNmXAr(WIdx) = 'DDTRFM'
     C                   EVAL      WMsgIdXAr(WIdx) = 'USR9831'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN74 = '0'  OR
     C                             *IN75 = '0'
 
      ** 'TI Transfer Method input must be 2-character alphanumeric.'
     C                   EVAL      DDTRFMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTRFM'
     C                   EVAL      MsgIdXAr(Idx) = 'USR9837'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Other parms
      ** Field(s) requiring validation
     C                   PARM                    DDTRFM
      ** Customer Number
     C                   PARM                    DDCUSN
      ** Bank/Non Bank-ID
     C                   PARM                    DDBNBI
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      ** Transfer Method -      OK
     C                   PARM                    DDTRFMOK
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      *Compile time array:-
 
** CPY@     :Copyright notice for inclusion in all programs
(c) Finastra International Limited 2006
** WWTRFM
ACBOBPCCCHDDGWMTNDPOSWTTTX
** ALPHAN - CAPITAL LETTERS, NUMBERS 0 TO 9
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
