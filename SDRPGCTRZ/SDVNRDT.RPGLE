     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Next Revaluation Date')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Next Revaluation Date*
      *                                                               *
      *  SDVNRDT - Validate Next Revaluation Date                     *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Future and Options Details amendments must *
      *    not be applied to this source.                             *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
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
     ** ¦ =====================================¦
      * +-------------------------------------- +
 
      ** Data structure for Rundate
     DRUNDAT           DS
     DMRDT                     1      7
     DRDNB                     8     10P 0
     DSUC                     11     11
     DDFF                     12     12
     DMBIN                    13     13
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Run day number
     DWURDNB           S              5  0
      ** Define work field Date format flag
     DWUDFF            S              1
      ** Define work field Return Code
     DW0RTN            S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDNRDT          S              6A
     D DDNRDTOK        S              1A
     D FONRDT          S              5S 0
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
 
      ** Validate Next Revaluation Date,
      ** Next Revaluation Date Screen field is Not Zero
     C                   IF        DDNRDT <> *BLANK
     C                   MOVE      DDNRDT        WUWSDT
      ** Check Screen Date - Rundate
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM                    WUDFF
     C     FONRDT        PARM      *ZERO         FONRDT
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDNRDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNRDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZDATE1'                                MD000091
     C                   EVAL      MsgDtaTmp = 'ZDATE1'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
 
      ** Return code is Old Table Error
     C                   IF        W0RTN = '*ERROR*'
      ** Send message 'Next Reval Date Invalid'
     C                   EVAL      DDNRDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNRDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1190'
 
     C                   ELSE
      ** Next revaluation date LT WRK.Run day number
     C                   IF        FONRDT < WURDNB
      ** Send message 'Invalid date (F&O Clients)'
     C                   EVAL      DDNRDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNRDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0308'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Send message 'Next Reval Date Required'
     C                   EVAL      DDNRDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNRDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1216'
 
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
      ** Next Revaluation Date
     C                   PARM                    DDNRDT
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Next Revaluation Date - OK
     C                   PARM                    DDNRDTOK
      ** Return value of Next Revaluation Date
     C                   PARM                    FONRDT
      ** Get Rundate - Rundate
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      RDNB          WURDNB
      ** Get Date Format Flag from Rundate
     C                   MOVE      DFF           WUDFF
 
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
(c) Finastra International Limited 2006
