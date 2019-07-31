     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate Bank to Bank Inf')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVBTBI - Midas FT Nostro Transfer Validate Bank to Bank Info*
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
      *  Prev Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     D  WBankInfos           310    449
 
      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)
 
      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)
     D  ValidInfos            77    216
 
      ** Field for character checking
     D FieldCheck      DS            35
     D  FldChk1                1      1
     D  FldChk2                2      2
     D  FldChk3                1     10
 
     D InfoArray       S             35    DIM(4)
     D FldArray        S             10    DIM(4)
     D InfoErr         S              1    DIM(4)
     D MsgArray        S              7    DIM(4)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D X               S              2  0
     D Y               S              1  0
     D Z               S              2  0
     D Slash           S              2  0
     D CSW201          S              1
     D PRTCD           S              7
 
      ** Valid Upper Case Alphabets and Numeric digits codewords
     D APN             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ/-
     D                                     0123456789'
 
      ** Valid Upper Case Characters for SWIFT codewords
     D UPA             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** Valid ISO Characters
     D SWCH            C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ -
     D                                     0123456789/-?:().,+'''
 
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
 
      ** If not entered, return.
     C                   IF        WBankInfos = *BLANKS
     C                   GOTO      EMAIN
     C                   ENDIF
 
     C                   Z-ADD     1             Y
     C                   MOVEA     *BLANKS       InfoErr
     C                   MOVEA     *BLANKS       InfoArray
     C                   MOVE      NTBBI1        InfoArray(1)
     C                   MOVE      NTBBI2        InfoArray(2)
     C                   MOVE      NTBBI3        InfoArray(3)
     C                   MOVE      NTBBI4        InfoArray(4)
     C                   MOVE      'NTBBI1    '  FldArray(1)
     C                   MOVE      'NTBBI2    '  FldArray(2)
     C                   MOVE      'NTBBI3    '  FldArray(3)
     C                   MOVE      'NTBBI4    '  FldArray(4)
     C                   IF        CSW201 = 'Y'
     C                   EVAL      MsgArray(1) = '5047457'
     C                   EVAL      MsgArray(2) = '5047459'
     C                   EVAL      MsgArray(3) = '5047459'
     C                   EVAL      MsgArray(4) = '5047459'
     C                   ELSE
     C                   EVAL      MsgArray(1) = '5047458'
     C                   EVAL      MsgArray(2) = '5047460'
     C                   EVAL      MsgArray(3) = '5047460'
     C                   EVAL      MsgArray(4) = '5047460'
     C                   ENDIF
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      *IN89 = *OFF
 
      ** Check all six fields
     C                   DOW       Y <= 4                                       B001
      *
     C                   IF        InfoArray(Y) = *BLANKS                       B002
      *
     C                   EVAL      *IN89 = *ON
      *
     C                   ELSE                                                   X002
      *
      *** Check for embedded blanks
     C                   IF        *IN88 = *OFF AND
     C                             *IN89 = *ON
     C                   EVAL      *IN88 = *ON
     C                   EVAL      InfoErr(1) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(1)
     C                   EVAL      MsgIdXAr(Idx) = '5047455'
     C                   GOTO      NEXT
     C                   ENDIF
 
     C                   EVAL      FieldCheck = InfoArray(Y)
      *
      *** First position must be a '/'
     C                   IF        FldChk1 <> '/'
     C                   EVAL      InfoErr(Y) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(Y)
     C                   EVAL      MsgIdXAr(Idx) = MsgArray(Y)
     C                   GOTO      NEXT
     C                   ENDIF
      *
      *** First info line cannot have '/' in position 2
     C                   IF        FldChk2 = '/' AND
     C                             Y = 1
     C                   EVAL      InfoErr(Y) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(Y)
     C                   EVAL      MsgIdXAr(Idx) = MsgArray(Y)
     C                   GOTO      NEXT
     C                   ENDIF
      *
      *** 2nd '/' should exist within the first 10 characters
     C     '/'           SCAN      FldChk3:2     Slash
     C                   IF        Slash = 0
     C                   EVAL      InfoErr(Y) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(Y)
     C                   EVAL      MsgIdXAr(Idx) = MsgArray(Y)
     C                   GOTO      NEXT
     C                   ENDIF
      *
      *** Check line for 8a, where 8a represents up to 8
      *** valid characters in between the '/'s
     C                   IF        CSW201 = 'Y'
     C     APN           CHECK     FldChk3:2     Z                        88
     C                   ELSE
     C     UPA           CHECK     FldChk3:2     Z                        88
     C                   ENDIF
      *
     C                   IF        *IN88 = *ON AND
     C                             Z < Slash
     C                   EVAL      InfoErr(Y) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(Y)
     C                   EVAL      MsgIdXAr(Idx) = MsgArray(Y)
     C                   GOTO      NEXT
     C                   ENDIF
      *
      *** Check if characters after the second '/' are valid
      *** ISO characters
     C                   EVAL      X = Slash + 1
     C     SWCH          CHECK     FieldCheck:X                           88
      *
     C                   IF        *IN88 = *ON
     C                   EVAL      InfoErr(Y) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(Y)
     C                   EVAL      MsgIdXAr(Idx) = MsgArray(Y)
     C                   GOTO      NEXT
     C                   ENDIF
      *
      *** '//' followed by *BLANKS is not allowed in lines 2, 3, and 4
     C                   IF        FldChk2 = '/' AND                            B003
     C                             Y <> 1
      *
     C     ' '           CHECK     FieldCheck:3                           88
      *
     C                   IF        *IN88 = *OFF
     C                   EVAL      InfoErr(Y) = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = FldArray(Y)
     C                   EVAL      MsgIdXAr(Idx) = MsgArray(Y)
     C                   GOTO      NEXT
     C                   ENDIF
      *
     C                   ENDIF                                                  E003
      *
     C                   ENDIF                                                  E002
      *
     C     NEXT          TAG
      *
     C                   ADD       1             Y
      *
     C                   ENDDO                                                  E001
 
     C                   IF        InfoErr(1) = 'N'
     C                   EVAL      OKBBI1 = 'N'
     C                   ENDIF
     C                   IF        InfoErr(2) = 'N'
     C                   EVAL      OKBBI2 = 'N'
     C                   ENDIF
     C                   IF        InfoErr(3) = 'N'
     C                   EVAL      OKBBI3 = 'N'
     C                   ENDIF
     C                   IF        InfoErr(4) = 'N'
     C                   EVAL      OKBBI4 = 'N'
     C                   ENDIF
 
     C                   IF        OKBBI1 <> 'N' AND
     C                             OKBBI2 <> 'N' AND
     C                             OKBBI3 <> 'N' AND
     C                             OKBBI4 <> 'N'
     C                   EVAL      ValidInfos = WBankInfos
     C                   ENDIF
 
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
 
      *
      ** Determine if CSW201 is installed
     C                   CALL      'SWIF2001'
     C                   PARM      *BLANKS       PRTCD
      *
     C                   IF        PRTCD = 'CSW201'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
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
