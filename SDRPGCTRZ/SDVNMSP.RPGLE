     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Namespace')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVNMSP - Validate Namespace                                 *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW216             Date 14Mar16               *
      *                 CSW214  *CREATE    Date 25Nov14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW216 - SWIFT Changes 2016                                  *
      *  CSW214 - SWIFT Changes 2014                                  *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D WExd            S             10A
     D I               S              3P 0
     D**DDIBEI**        S             20A                                                     CSW216
     D DDIBEI          S             30A                                                      CSW216
     D OKDDIBEI        S              1A
     D CSW214          S              1A                                                      CSW216
     D CSW216          S              1A                                                      CSW216
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Idx = 0
 
     C                   EVAL      OKDDIBEI = 'Y'
      *
      ** Validation
      *
     C     CSW216        IFEQ      'N'                                                        CSW216
     C                   EXSR      SRNMSP2                                                    CSW216
     C                   ENDIF                                                                CSW216
      *                                                                                       CSW216
     C     CSW214        IFEQ      'N'                                                        CSW216
     C     OKDDIBEI      ANDEQ     'Y'                                                        CSW216
     C                   EXSR      SRNMSP
     C                   ENDIF                                                                CSW216
      *
      ** If an error was found, set the return code appropriately
      *
     C                   IF        OKDDIBEI = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SRNMSP - Validate Namespace
      *****************************************************************
     C     SRNMSP        BEGSR
 
     C                   IF        DDIBEI <> *BLANKS
      *
      ** Check if Namespace field value exceeds 10A
      *
     C                   EVAL      WExd = %SUBST(DDIBEI:11:10)
 
     C                   IF        WExd <> *BLANKS
     C                   EVAL      OKDDIBEI = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDIBEI'
     C                   EVAL      MsgIDXAr(Idx)  = '5047323'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CSW216
     C/EJECT                                                                                  CSW216
      *****************************************************************                       CSW216
      ** SRNMSP2 - Validate Namespace for SWIFT2016                                           CSW216
      *****************************************************************                       CSW216
     C     SRNMSP2       BEGSR                                                                CSW216
                                                                                              CSW216
     C                   IF        DDIBEI <> *BLANKS                                          CSW216
                                                                                              CSW216
      ** Check if Namespace field value exceeds 20A                                           CSW216
                                                                                              CSW216
     C                   EVAL      WExd = %SUBST(DDIBEI:21:10)                                CSW216
                                                                                              CSW216
     C                   IF        WExd <> *BLANKS                                            CSW216
     C                   EVAL      OKDDIBEI = 'N'                                             CSW216
     C                   EVAL      Idx = Idx + 1                                              CSW216
     C                   EVAL      FldNamXAr(Idx) = 'DDIBEI'                                  CSW216
     C                   EVAL      MsgIDXAr(Idx) = '5048670'                                  CSW216
     C                   ENDIF                                                                CSW216
     C                   ENDIF                                                                CSW216
                                                                                              CSW216
     C                   ENDSR                                                                CSW216
                                                                                              CSW216
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Namespace (20A)
      *
     C                   PARM                    DDIBEI
      *
      ** OUTPUTS
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Other parms
      *
      ** Party Capacity Indicator - OK
      *
     C                   PARM                    OKDDIBEI
      ** SWIFT2014 Flag                                                                       CSW216
     C                   PARM                    CSW214                                       CSW216
      ** SWIFT2016 Flag                                                                       CSW216
     C                   PARM                    CSW216                                       CSW216
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
(c) Finastra International Limited 2014
