     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Date of Last Visit')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Additional Details Validation *
      *                                                               *
      *  SDVDOLV - Validate Date of Last Visit                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *    /COPY, Customer Additional Details amendments must not be  *
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
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Run Date
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Midas Work Date
     D  WUWMDT         S              5  0 Inz(*Zeros)
      ** Run Day number
     D  WURDNB         S              5  0 Inz(*Zeros)
      ** Date format flag
     D  WUDFF          S              1    Inz(*Blanks)
      ** Work Converted Date
     D  WUWCDT         S              6  0 Inz(*Zeros)
      ** Work Alpha Date
     D  WUWADT         S              7    Inz(*Blanks)
      ** Work Screen Date
     D  WUWSDT         S              6  0 Inz(*Zeros)
      ** Work File Date
     D  WUWFDT         S              5  0 Inz(*Zeros)
      ** Midas Run Date
     D  WUMRDT         S              7    Inz(*Blanks)
      ** Set Up Complete
     D  WUSUC          S              1    Inz(*Blanks)
      ** Multi-branching Indicator
     D  WUMBIN         S              1    Inz(*Blanks)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Index for arrays of error message ids etc
     D WQ0014          S              7A
     D WQ0015          S              6P 0
     D WQ0016          S              1A
     D WQ0017          S              5P 0
     D W0RTN           S              7A
     D W0CLPG          S             10A
     D DDDOLV          S              6A
     D DDDOLVOK        S              1A
     D ADDOLV          S              5P 0
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
 
      ** Check Date of Last visit is valid
     C     DDDOLV        IFNE      *BLANK
     C                   MOVEL     DDDOLV        WUWSDT
      ** Convert Date to Midas Day Number
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM      W0RTN         WQ0014
     C     WUWSDT        PARM      WUWSDT        WQ0015
     C     WUDFF         PARM      WUDFF         WQ0016
     C     WUWFDT        PARM      *ZERO         WQ0017
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'ZDATE1'      W0CLPG
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDDOLVOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDOLV   '
     C                   EVAL      MsgIdXAr(Idx) = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx)= W0CLPG                                  MD000091
     C                   EVAL      BLen = %Len(%Trim(W0CLPG))                              MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(W0CLPG)                  MD000091
 
     C                   END
      ** Date of last visit is not Valid
     C     W0RTN         IFEQ      '*ERROR*'
     C                   EVAL      DDDOLVOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDOLV   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1963'
 
     C                   ELSE
     C                   Z-ADD     WUWFDT        ADDOLV
     C                   END
 
     C                   ELSE
     C                   Z-ADD     *ZERO         ADDOLV
     C                   END
 
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
     C                   PARM                    DDDOLV
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Date of Visit-      OK
     C                   PARM                    DDDOLVOK
     C                   PARM                    ADDOLV
 
      ** Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
 
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
