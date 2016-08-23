     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Next Statement Date')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Validate Next Statement Date  *
      *                                                               *
      *  SDVNSDT - Validate Next Statement Date                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Customer Future and Options Details amendments must *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      **DS for Rundate,
     DRUNDAT           DS
     DMRDT                     1      7
     DRDNB                     8     10P 0
     DSUC                     11     11
     DDFF                     12     12
     DMBIN                    13     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Run day number
     D WURDNB          S              5  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Multiple Branch Indicator
     D WUMBIN          S              1
      ** Define work field Return Code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work Variables
     D DDNSDT          S              6A
     D DDNSDTOK        S              1A
     D FONSDT          S              5P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
 
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
      ** Validate Next Statement Date
      ** Next Statement Date Screen Field is Not Blank
     C                   IF        DDNSDT <> *BLANK
     C                   MOVE      DDNSDT        WUWSDT
      ** Check Screen Date - Rundate  *
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM                    WUDFF
     C     FONSDT        PARM      *ZERO         FONSDT
 
     C                   IF        *IN90 = *ON
      ** Send message '*Error occurred on CALL...'
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx) = 'ZDATE1'                                MD000091
     C                   EVAL      MsgDtaTmp = 'ZDATE1'                                     MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr + %TRIM(MsgDtaTmp)               MD000091
     C                   ENDIF
      ** Return code is Old Table Error
     C                   IF        W0RTN  = '*ERROR*'
      ** Send message 'Next Stmnt Date Invalid'
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1189'
      ** If no error found,
     C                   ELSE
      ** Next statement date LT WRK.Run day number
     C                   IF        FONSDT < WURDNB
      ** Send message 'Invalid date (F&O Clients)'
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR0308'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
      ** Send message 'Next Statement Date Req'
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDT    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USR1215'
 
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
      ** Next Statement Date
     C                   PARM                    DDNSDT
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Next Statement Date - OK
     C                   PARM                    DDNSDTOK
      ** Next statement date value
     C                   PARM                    FONSDT
 
      ** Get Rundate - Rundate*
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
(c) Misys International Banking Systems Ltd. 2006
