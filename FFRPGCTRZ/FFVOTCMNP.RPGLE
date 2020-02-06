     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate Min. Price Fluct'n non-ccy OTC')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVOTCMNP - Validate Minimum Price Fluctuation               *
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
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
 
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
     D WIdx            S              3P 0
 
      ** Minimum price fluctuation field
     D NMNPF           S             11A
 
      ** Ok field - Minimum price fluctuation
     D OKMNPF          S              1A
 
      ** Work variable for editing numeric fields
     D ITMNPF          S             15P 8
 
      ** Parameter for ZALIGN and ZEDIT function
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
     D PZAlignOk       S              1A
 
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
 
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
 
      ** Validation
 
      ** E.g. If field is Mandatory or any other required validation
 
     C                   IF        NMNPF = *BLANK
 
     C                   EVAL      OKMNPF = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'NMNPF     '
     C                   EVAL      MsgIdXAr(Idx) = 'MMA0409'
     C                   ELSE
 
      ** Minimum price fluctuation value must be valid
      ** amount in premium currency
 
     C                   Z-ADD     8             PZADEC
     C                   Z-ADD     6             PZADIG
     C                   EVAL      PZField = *Blanks
     C                   MOVE      NMNPF         PZField
     C                   EXSR      SRZAlign
 
      ** Invalid Minimum price fluctuation value
 
     C                   IF        PZAlignOk = 'N' or
     C                             PZField = *BLANKS or
     C                             PZField = *ZERO
     C                   EVAL      OKMNPF = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'NMNPF     '
     C                   EVAL      MsgIdXAr(Idx) = 'MMA0410'
 
     C                   ELSE
 
      ** Edit Minimum price fluctuation value for redisplay
 
     C                   MOVE      PZField       ITMNPF
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   MOVE      PZField       NMNPF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Return with error of OK flag is 'N'
 
     C                   IF        OKMNPF = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Input parameters
      ** ----------------
 
      ** Field(s) requiring validation
 
     C                   PARM                    NMNPF
 
      ** Ouput parameters
      ** ----------------
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Numeric (file) version of minimum price fluctuation
      ** Minimum price fluctuation OK flag
 
     C                   PARM                    ITMNPF
     C                   PARM                    OKMNPF
 
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
