     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate Related pay reference')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTVRLPR  - Validate Related Pay Reference                    *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD055002 *CREATE   Date 31Jan20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055002 - Created the module                                *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **********************************************************************
      /EJECT
      **********************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.

     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs

     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.

     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Incoming Transaction

     D TranInThir    E DS                  EXTNAME(FTOPY4PD)

      ** Flags to indicate whether transaction fields are valid

     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)

      ** Validation Work Fields

     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D/COPY FTCPYSRC,SFTVALCSLE

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc

     D Idx             S              3P 0

     D Length          S              2S 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **********************************************************************
      /EJECT
      **********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialization

     C                   Eval      RetCodeIn = *BlankS
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      Idx = 0

      ** Validate only if pay ref is not empty

     C                   IF        SRLPR <> *BLANKS
     C                   Exsr      VRLPR
     C                   ENDIF

      ** If an error was found, set the return code appropriately

     C                   If        OKRLPR = 'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   End

      ** RETURN

     C                   RETURN
      **********************************************************************
      /EJECT
     C**********************************************************************
     C* VRLPR   -  Validation of Related Payment Reference                 *
     C**********************************************************************
     C     VRLPR         BEGSR

      ** If related pay ref contains double slashes '//'

     C                   IF        %SCAN('//' : SRLPR) > 0
     C                   MOVE      'N'           OKRLPR
     C                   ADD       1             Idx
     C                   MOVEL     'SRLPR'       FldNamXAr(Idx)
     C                   MOVEL     'MMA1433'     MsgIdXAr(Idx)
     C                   ENDIF

      ** If related pay ref starts or ends with '/'

     C                   EVAL      Length = %LEN(%TRIM(SRLPR))
     C                   IF        %SCAN('/' : SRLPR) = 1  OR
     C                             %SUBST(SRLPR:Length:1) = '/'
     C                   MOVE      'N'           OKRLPR
     C                   ADD       1             Idx
     C                   MOVEL     'SRLPR'       FldNamXAr(Idx)
     C                   MOVEL     'MMA1432'     MsgIdXAr(Idx)

     C                   ENDIF

     C                   ENDSR
     C**********************************************************************
     C* END OF VALIDATION                                                  *
     C**********************************************************************
     C/EJECT
      **********************************************************************
      * *INZSR - Program Initialisation routine                            *
      **********************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** INPUTS

      **  Return Code
     C                   Parm                    RetCodeIn

      **  Screen fields

     C                   Parm                    TranInThir

      ** OUTPUTS

      **  Error fields/message IDs/message data (arrays) from/to caller

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      **  OK Flags

     C                   Parm                    OKFlagsDS

      **  Validation Work Fields

     C                   Parm                    Val@Fields

      ** ===================================================================
      ** Program, module and procedure names for database error processing.
      ** ===================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      **********************************************************************
      /EJECT
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
**  CPY@
(c) Finastra International Limited 2020
