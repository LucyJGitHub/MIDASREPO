     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Reporting Information Screen 3 Validate')     *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLRIS3VAL - Midas DL Reporting Information Screen 3 Validate *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW214             Date 25Nov14               *
      *  Prev Amend No. MD023365           Date 12Nov13               *
      *                 MD022508           Date 23Sep13               *
      *                 MD022888           Date 17Sep13               *
      *                 MD022310A          Date 16Sep13               *
      *                 MD022310           Date 13Sep13               *
      *                 MD022069           Date 09Sep13               *
      *                 MD022078           Date 08Sep13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD023365 - Event code not found for UTC sign.                *
      *  MD022508 - Error encountered when RPIF Execution             *
      *             Timestamp date is entered.                        *
      *  MD022888 - Removed error for UTC sign if it is blank and UTC *
      *             time is non-blank.                                *
      *  MD022310A- Execution Timestamp (UTC Sign) value N is allowed *
      *             even if UTC Indicator is equal to all zeroes      *
      *  MD022310 - Execution Timestamp (UTC Sign) value N is allowed *
      *             even if UTC Indicator is equal to all zeroes or   *
      *             not entered.                                      *
      *  MD022069 - Incorrect date format used for comparing dates.   *
      *  MD022078 - RPF0028 error message shown twice.                *
      *  CSW213 - SWIFT Changes 2013                                  *
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
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Named Constant used to determine if a field contains invalid
      ** characters for Telex and S.W.I.F.T.
 
     D ISO             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ-
     D                                      abcdefghijklmnopqrstuvwxyz-
     D                                      1234567890 /+-?:().,'''
 
      ** Named Constant used to determine if an additional
      ** reporting information starts with '/codeword/'
 
     D #CODEW          C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DLRILK        E DS                  EXTNAME(DLRILKPD)
      * RPIF Link file
 
     D DLRIS1Detail  E DS                  EXTNAME(DLRIS1PD)
      ** Fields from Screen 1
 
     D DLRIS2Detail  E DS                  EXTNAME(DLRIS2PD)
      ** Fields from Screen 2
 
     D DLRIS3Detail  E DS                  EXTNAME(DLRIS3PD)
      ** Fields to validate in screen 3
 
     D DLError3      E DS                  EXTNAME(DLERI3PD)
      ** OK flags for screen 3
 
     D DLVRPFileFmt  E DS                  EXTNAME(DLVRPIPD)
      ** Valid Deals layout
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Variable for date
     D @R3DATE         S              8A
 
      ** Field in error
     D FldNamXAr       S             10A
 
      ** Error message ID
     D MsgIDXAr        S                   LIKE(#MsgId)
 
      ** Error message data
     D MsgDtaXAr       S                   LIKE(#MsgData)
 
      ** Field with warning
     D WFldNmXAr       S             10A
 
      ** Warning message ID
     D WMsgIDXAr       S                   LIKE(#MsgId)
 
      ** Warning message data
     D WMsgDtXAr       S                   LIKE(#MsgData)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D WRetCode        S             10A
     D***WarnDesc        S              1A                                                    CSW214
     D WDate1          S              6  0
     D WDate2          S              6  0
     D WDate3          S              6A                                                    MD022069
     D WDate4          S              6A                                                    MD022069
     D UTCTime         S              6A
     D***ReqDesc         S              1A                                                    CSW214
     D***BlankBFR        S              1A                                                    CSW214
     D***BlankBFR2       S              1A                                                    CSW214
     D***FldName         S              6A                                                    CSW214
     D***WCodeWord       S             10A                                                    CSW214
     D***FldChk          S             35A                                                    CSW214
     D***ErrID           S              7A                                                    CSW214
     D***FldChkOK        S              1A                                                    CSW214
     D***Char1           S              1A                                                    CSW214
     D***W               S              2  0                                                  CSW214
     D***WW              S              2  0                                                  CSW214
     D CSW214          S              1A                                                      CSW214
     D PRTCD           S              7A                                                      CSW214
     D I               S              3  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Do Validations in Sequence
 
      *
      ** Validate Execution Timestamp (Date)
      *
     C                   IF        R3TSDT <> *BLANKS
 
     C                   IF        BJDFIN = 'D'
     C     *DMY0         TEST (D)                R3TSDT                 97
     C     *DMY0         TEST (D)                RLVALD                 98                  MD022508
     C                   IF        *IN97 = *OFF                                             MD022069
     C                             AND *IN98 = *OFF                                         MD022508
     C                   EVAL      WDate3 = %CHAR(%DATE(R3TSDT: *DMY0):*YMD0)               MD022069
     C                   EVAL      WDate4 = %CHAR(%DATE(RLVALD: *DMY0):*YMD0)               MD022069
     C                   ENDIF                                                              MD022069
     C                   ELSE
     C     *MDY0         TEST (D)                R3TSDT                 97
     C     *MDY0         TEST (D)                RLVALD                 98                  MD022508
     C                   IF        *IN97 = *OFF                                             MD022069
     C                             AND *IN98 = *OFF                                         MD022508
     C                   EVAL      WDate3 = %CHAR(%DATE(R3TSDT: *MDY0):*YMD0)               MD022069
     C                   EVAL      WDate4 = %CHAR(%DATE(RLVALD: *MDY0):*YMD0)               MD022069
     C                   ENDIF                                                              MD022069
     C                   ENDIF
 
     C                   IF        *IN97 = *ON
 
     C                   EXSR      ResetErrs
     C                   EVAL      R3TSDTOK = 'N'
     C                   EVAL      FldNamXAr = 'R3TSDT'
     C                   EVAL      MsgIDXAr = '5046044'
     C                   EXSR      UpDatErrs
 
     C                   ELSE
 
     C                   IF        *IN98 = *OFF                                             MD022508
     C**********         MOVEL     R3TSDT        WDate1                                     MD022069
     C**********         MOVEL     RLVALD        WDate2                                     MD022069
     C                   MOVEL     WDate3        WDate1                                     MD022069
     C                   MOVEL     WDate4        WDate2                                     MD022069
     C                   IF        WDate1 < WDate2
     C                   EXSR      ResetErrs
     C                   EVAL      R3TSDTOK = 'N'
     C                   EVAL      FldNamXAr = 'R3TSDT'
     C                   EVAL      MsgIDXAr = '5046046'
     C                   EXSR      UpDatErrs
     C                   ENDIF
     C                   ENDIF                                                              MD022508
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R3TSTM <> *BLANKS OR
     C                             R3UTSS <> *BLANKS OR
     C                             R3UTST <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      R3TSDTOK = 'N'
     C                   EVAL      FldNamXAr = 'R3TSDT'
     C                   EVAL      MsgIDXAr = '5046045'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Execution Timestamp (Time)
      *
     C                   IF        R3TSTM <> *BLANKS
 
     C     *HMS0         TEST (T)                R3TSTM                 97
     C                   IF        *IN97 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      R3TSTMOK = 'N'
     C                   EVAL      FldNamXAr = 'R3TSTM'
     C                   EVAL      MsgIDXAr = '5046047'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        R3UTST <> *BLANKS
     C                   EXSR      ResetErrs
     C                   EVAL      R3TSTMOK = 'N'
     C                   EVAL      FldNamXAr = 'R3TSTM'
     C                   EVAL      MsgIDXAr = '5046048'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Execution Timestamp (UTC Sign)
      *
     C                   IF        R3UTSS <> *BLANKS AND
     C                             R3UTSS <> 'N'
     C                   EXSR      ResetErrs
     C                   EVAL      R3UTSSOK = 'N'
     C                   EVAL      FldNamXAr = 'R3UTSS'
     C                   EVAL      MsgIDXAr = '5046049'
     C                   EXSR      UpDatErrs
     C                   ENDIF
      *
     C**********         IF        R3UTSS = *BLANKS AND                                     MD022888
     C**********                   R3UTST <> *BLANKS                                        MD022888
     C**********         EXSR      ResetErrs                                                MD022888
     C**********         EVAL      R3UTSSOK = 'N'                                           MD022888
     C**********         EVAL      FldNamXAr = 'R3UTSS'                                     MD022888
     C**********         EVAL      MsgIDXAr = '5046086'                                     MD022888
     C**********         EXSR      UpDatErrs                                                MD022888
     C**********         ENDIF                                                              MD022888
      *
     C**********         IF        R3UTSS = 'N' AND R3UTST = *BLANKS              MD022310 MD022310A
     C                   IF        R3UTSS = 'N' AND                                        MD022310A
     C                             (R3UTST = *BLANKS OR R3UTST = '0000')                   MD022310A
     C                   EXSR      ResetErrs                                                MD022310
     C                   EVAL      R3UTSSOK = 'N'                                           MD022310
     C                   EVAL      FldNamXAr = 'R3UTSS'                                     MD022310
     C**********         EVAL      MsgIDXAr = 'RPF0064'                            MD022310 MD023365
     C                   EVAL      MsgIDXAr = '5046111'                                     MD023365
     C                   EXSR      UpDatErrs                                                MD022310
     C                   ENDIF                                                              MD022310
      *                                                                                     MD022310
      ** Validate Execution Timestamp (UTC)
      *
     C                   IF        R3UTST <> *BLANKS
 
     C                   MOVEL     R3UTST        UTCTime
     C                   MOVE      '00'          UTCTime
     C     *HMS0         TEST (T)                UTCTime                97
     C                   IF        *IN97 = *ON
     C                   EXSR      ResetErrs
     C                   EVAL      R3UTSTOK = 'N'
     C                   EVAL      FldNamXAr = 'R3UTST'
     C                   EVAL      MsgIDXAr = '5046050'
     C                   EXSR      UpDatErrs
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Validate Clearing Threshold Indicator
      *
     C                   IF        R3CTIN <> *BLANKS AND
     C                             R3CTIN <> 'N' AND
     C                             R3CTIN <> 'Y'
     C                   EXSR      ResetErrs
     C                   EVAL      R3CTINOK = 'N'
     C                   EVAL      FldNamXAr = 'R3CTIN'
     C                   EVAL      MsgIDXAr = '5046039'
     C                   EXSR      UpDatErrs
     C                   ENDIF
      *
      ** Validate Allocation Indicator
      *
     C                   IF        R3ALIN <> *BLANKS AND
     C                             R3ALIN <> 'A' AND
     C                             R3ALIN <> 'P' AND
     C                             R3ALIN <> 'U'
     C                   EXSR      ResetErrs
     C                   EVAL      R3ALINOK = 'N'
     C                   EVAL      FldNamXAr = 'R3ALIN'
     C                   EVAL      MsgIDXAr = '5046041'
     C                   EXSR      UpDatErrs
     C                   ENDIF
      *
      ** Validate Collateralisation Indicator
      *
     C                   IF        R3COIN <> *BLANKS AND
     C                             R3COIN <> 'F' AND
     C                             R3COIN <> 'O' AND
     C                             R3COIN <> 'P' AND
     C                             R3COIN <> 'U'
     C                   EXSR      ResetErrs
     C                   EVAL      R3COINOK = 'N'
     C                   EVAL      FldNamXAr = 'R3COIN'
     C                   EVAL      MsgIDXAr = '5046042'
     C                   EXSR      UpDatErrs
     C                   ENDIF
      *
      ** Validate Non- Standard Flag
      *
     C                   IF        R3NSFG <> *BLANKS AND
     C                             R3NSFG <> 'Y'
     C                   EXSR      ResetErrs
     C                   EVAL      R3NSFGOK = 'N'
     C                   EVAL      FldNamXAr = 'R3NSFG'
     C                   EVAL      MsgIDXAr = '5046051'
     C                   EXSR      UpDatErrs
     C                   ENDIF
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
                                                                                              CSW214
      ** Validate Financial Nature of the Counterparty Indicator                              CSW214
                                                                                              CSW214
     C                   IF        R3FNCI <> *BLANKS AND                                      CSW214
     C                             R3FNCI <> 'F' AND                                          CSW214
     C                             R3FNCI <> 'N'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3FNCIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3FNCI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047309'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Collateral Portfolio Indicator                                              CSW214
                                                                                              CSW214
     C                   IF        R3COPI <> *BLANKS AND                                      CSW214
     C                             R3COPI <> 'N' AND                                          CSW214
     C                             R3COPI <> 'Y'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3COPIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3COPI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047310'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Collateral Portfolio Code                                                   CSW214
                                                                                              CSW214
     C                   IF        R3COPC <> *BLANKS                                          CSW214
                                                                                              CSW214
     C                   IF        R3COPI <> 'Y'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3COPCOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3COPC'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047311'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ELSE                                                                 CSW214
                                                                                              CSW214
     C     ISO           CHECK     R3COPC                                 98                  CSW214
     C                   IF        *IN98 = *ON                                                CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3COPCOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3COPC'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047312'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ELSE                                                                 CSW214
     C                   IF        R3COPI = 'Y'                                               CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3COPCOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3COPC'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047313'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Portfolio Compression Indicator                                             CSW214
                                                                                              CSW214
     C                   IF        R3POCI <> *BLANKS AND                                      CSW214
     C                             R3POCI <> 'Y' AND                                          CSW214
     C                             R3POCI <> 'N'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3POCIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3POCI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047314'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Corporate Sector Indicator                                                  CSW214
                                                                                              CSW214
     C                   IF        R3COSI <> *BLANKS AND                                      CSW214
     C                             R3COSI <> 'A' AND                                          CSW214
     C                             R3COSI <> 'C' AND                                          CSW214
     C                             R3COSI <> 'F' AND                                          CSW214
     C                             R3COSI <> 'I' AND                                          CSW214
     C                             R3COSI <> 'L' AND                                          CSW214
     C                             R3COSI <> 'O' AND                                          CSW214
     C                             R3COSI <> 'R' AND                                          CSW214
     C                             R3COSI <> 'U'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3COSIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3COSI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047315'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Trade with Non-EEA Counterparty Indicator                                   CSW214
                                                                                              CSW214
     C                   IF        R3TNEI <> *BLANKS AND                                      CSW214
     C                             R3TNEI <> 'Y' AND                                          CSW214
     C                             R3TNEI <> 'N'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3TNEIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3TNEI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047316'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Intragroup Trade Indicator                                                  CSW214
                                                                                              CSW214
     C                   IF        R3IGTI <> *BLANKS AND                                      CSW214
     C                             R3IGTI <> 'Y' AND                                          CSW214
     C                             R3IGTI <> 'N'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3IGTIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3IGTI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047317'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
      ** Validate Commercial or Treasury Financial Indicator                                  CSW214
                                                                                              CSW214
     C                   IF        R3CTFI <> *BLANKS AND                                      CSW214
     C                             R3CTFI <> 'Y' AND                                          CSW214
     C                             R3CTFI <> 'N'                                              CSW214
     C                   EXSR      ResetErrs                                                  CSW214
     C                   EVAL      R3CTFIOK = 'N'                                             CSW214
     C                   EVAL      FldNamXAr = 'R3CTFI'                                       CSW214
     C                   EVAL      MsgIDXAr = '5047318'                                       CSW214
     C                   EXSR      UpDatErrs                                                  CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Validate*Additional*Reporting*Information                                            CSW214
      **********                                                                              CSW214
     C*****'OTHR'        SCAN      R2RPJ1                                 94                  CSW214
     C**N94'OTHR'        SCAN      R2RPJ2                                 94                  CSW214
     C**N94'OTHR'        SCAN      R2RPJ3                                 94                  CSW214
     C**N94'OTHR'        SCAN      R2RPJ4                                 94                  CSW214
      **********                                                                              CSW214
     C**********         IF        *IN94 = *ON                                                CSW214
     C**********         EVAL      ReqDesc = 'Y'                                              CSW214
     C**********         EVAL      WarnDesc = 'N'                                             CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*1                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      BlankBFR = 'N'                                             CSW214
     C**********         EVAL      BlankBFR2 = 'N'                                            CSW214
     C**********         EVAL      FldName = 'R3AR01'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR01                                         CSW214
     C**********         EVAL      FldChk = R3AR01                                            CSW214
     C**********         EVAL      ErrID = '5046055'                                          CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR01OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*2                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR02'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR02                                         CSW214
     C**********         EVAL      FldChk = R3AR02                                            CSW214
     C**********         EVAL      ErrID = '5046056'                                          CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR02OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*3                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR03'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR03                                         CSW214
     C**********         EVAL      FldChk = R3AR03                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR03OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*4                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR04'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR04                                         CSW214
     C**********         EVAL      FldChk = R3AR04                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR04OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*5                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR05'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR05                                         CSW214
     C**********         EVAL      FldChk = R3AR05                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR05OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*6                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR06'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR06                                         CSW214
     C**********         EVAL      FldChk = R3AR06                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR06OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*7                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR07'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR07                                         CSW214
     C**********         EVAL      FldChk = R3AR07                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR07OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*8                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR08'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR08                                         CSW214
     C**********         EVAL      FldChk = R3AR08                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR08OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*9                                            CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR09'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR09                                         CSW214
     C**********         EVAL      FldChk = R3AR09                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR09OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*10                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR10'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR10                                         CSW214
     C**********         EVAL      FldChk = R3AR10                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR10OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*11                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR11'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR11                                         CSW214
     C**********         EVAL      FldChk = R3AR11                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR11OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*12                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR12'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR12                                         CSW214
     C**********         EVAL      FldChk = R3AR12                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR12OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*13                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR13'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR13                                         CSW214
     C**********         EVAL      FldChk = R3AR13                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR13OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*14                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR14'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR14                                         CSW214
     C**********         EVAL      FldChk = R3AR14                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR14OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*15                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR15'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR15                                         CSW214
     C**********         EVAL      FldChk = R3AR15                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR15OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*16                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR16'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR16                                         CSW214
     C**********         EVAL      FldChk = R3AR16                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR16OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*17                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR17'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR17                                         CSW214
     C**********         EVAL      FldChk = R3AR17                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR17OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*18                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR18'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR18                                         CSW214
     C**********         EVAL      FldChk = R3AR18                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR18OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*19                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR19'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR19                                         CSW214
     C**********         EVAL      FldChk = R3AR19                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR19OK = FldChkOK                                        CSW214
      **********                                                                              CSW214
      ***Validate*additional*reporting*info*Line*20                                           CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldName = 'R3AR20'                                         CSW214
     C**********         EVAL      WCodeWord = R3AR20                                         CSW214
     C**********         EVAL      FldChk = R3AR20                                            CSW214
     C**********         EXSR      ResetErrs                                                  CSW214
     C**********         EXSR      CodeCheck                                                  CSW214
     C**********         EVAL      R3AR20OK = FldChkOK                                        CSW214
      *
      ** If no errors set up outstanding fields for valid file
      *
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      ** Return to calling program
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
     C*****CodeCheck     BEGSR                                                                CSW214
      **********                                                                              CSW214
     C**********         EVAL      FldChkOK = *BLANKS                                         CSW214
      **********                                                                              CSW214
      ***Send*warning*message*if*a*line*is*blank                                              CSW214
      ***and*at*least*one*of*the*reporting*jurisdictions*is*'OTHR'.                           CSW214
      **********                                                                              CSW214
     C**********         IF        FldChk = *BLANKS                                           CSW214
      **********                                                                              CSW214
     C**********         IF        ReqDesc = 'Y' AND                                          CSW214
     C**********                   WarnDesc = 'N'                                             CSW214
     C**********         EVAL      WFldNmXAr = FldName                                        CSW214
     C**********         EVAL      WMsgIDXAr = '5046057'                                      CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********         EVAL      WarnDesc = 'Y'                                             CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
     C**********         EVAL      BlankBFR = 'Y'                                             CSW214
     C**********         GOTO      ECodeCheck                                                 CSW214
      **********                                                                              CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Check*that*no*embedded*blank*exists.                                                 CSW214
      **********                                                                              CSW214
     C**********         IF        BlankBFR = 'Y'                                             CSW214
     C**********         IF        BlankBFR2 = 'N'                                            CSW214
     C**********         EVAL      FldNamXAr = FldName                                        CSW214
     C**********         EVAL      MsgIDXAr = '5046085'                                       CSW214
     C**********         EVAL      FldChkOK = 'N'                                             CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********         EVAL      BlankBFR2 = 'Y'                                            CSW214
     C**********         ENDIF                                                                CSW214
     C**********         GOTO      ECodeCheck                                                 CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Check*that*first*character*is*'/'                                                    CSW214
      **********                                                                              CSW214
     C**********         EVAL      W = 0                                                      CSW214
     C**********         EVAL      Char1 = WCodeWord                                          CSW214
     C**********         IF        Char1 <> '/'                                               CSW214
     C**********         EVAL      FldNamXAr = FldName                                        CSW214
     C**********         EVAL      MsgIDXAr = ErrID                                           CSW214
     C**********         EVAL      FldChkOK = 'N'                                             CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********                                                                              CSW214
     C**********         ELSE                                                                 CSW214
      **********                                                                              CSW214
      ***Check*existence*of*second*'/'*in*the*first*10*characters                             CSW214
      ***of*the*description*field                                                             CSW214
      **********                                                                              CSW214
     C*****'/'**         SCAN      WCodeWord:2   W                        96                  CSW214
     C**********         IF        *IN96 = *OFF                                               CSW214
     C**********         EVAL      FldNamXAr =  FldName                                       CSW214
     C**********         EVAL      MsgIDXAr = ERRID                                           CSW214
     C**********         EVAL      FldChkOK = 'N'                                             CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Line*1*must*not*start*with*'//'                                                      CSW214
      **********                                                                              CSW214
     C**********         IF        W = 2 AND FldName = 'R3AR01'                               CSW214
     C**********         EVAL      FldNamXAr = FldName                                        CSW214
     C**********         EVAL      MsgIDXAr = ERRID                                           CSW214
     C**********         EVAL      FldChkOK = 'N'                                             CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Check*that*characters*in*between*the*two*/*are*capital*letters.                      CSW214
      **********                                                                              CSW214
     C*****#CODEW        CHECK     WCodeWord:2   WW                       95                  CSW214
     C**********         IF        *IN95 = *ON AND WW < W                                     CSW214
     C**********         EVAL      FldNamXAr = FldName                                        CSW214
     C**********         EVAL      MsgIDXAr = ERRID                                           CSW214
     C**********         EVAL      FldChkOK = 'N'                                             CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
      ***Check*that*field*value*only*contain*SWIFT*characters                                 CSW214
      **********                                                                              CSW214
     C*****ISO**         CHECK     FldChk                                 98                  CSW214
     C**********         IF        *IN98 = *ON                                                CSW214
     C**********         EVAL      FldNamXAr = FldName                                        CSW214
     C**********         EVAL      MsgIDXAr = '5046054'                                       CSW214
     C**********         EVAL      FldChkOK = 'N'                                             CSW214
     C**********         EXSR      UpDatErrs                                                  CSW214
     C**********         ENDIF                                                                CSW214
      **********                                                                              CSW214
     C*****ECodeCheck    ENDSR                                                                CSW214
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     SetupValid    BEGSR
      *
      ** Move validated fields to DLVRPIPD fields
      *
     C                   IF        R3TSDT <> *BLANKS
     C                   IF        BJDFIN = 'D'
     C                   EVAL      @R3DATE = %CHAR(%DATE(R3TSDT: *DMY0):*ISO0)
     C                   ELSE
     C                   EVAL      @R3DATE = %CHAR(%DATE(R3TSDT: *MDY0):*ISO0)
     C                   ENDIF
     C                   MOVEL     @R3DATE       RVGEDT
     C                   ENDIF
     C                   MOVEL     R3TSTM        RVGETM
     C                   EVAL      RVUSGN = R3UTSS
     C                   MOVEL     R3UTST        RVUTCT
     C                   EVAL      RVCGTI = R3CTIN
     C                   EVAL      RVALLI = R3ALIN
     C                   EVAL      RVCLLI = R3COIN
     C                   EVAL      RVNORS = R3NSFG
     C**********         EVAL      RVAR01 = R3AR01                                            CSW214
     C**********         EVAL      RVAR02 = R3AR02                                            CSW214
     C**********         EVAL      RVAR03 = R3AR03                                            CSW214
     C**********         EVAL      RVAR04 = R3AR04                                            CSW214
     C**********         EVAL      RVAR05 = R3AR05                                            CSW214
     C**********         EVAL      RVAR06 = R3AR06                                            CSW214
     C**********         EVAL      RVAR07 = R3AR07                                            CSW214
     C**********         EVAL      RVAR08 = R3AR08                                            CSW214
     C**********         EVAL      RVAR09 = R3AR09                                            CSW214
     C**********         EVAL      RVAR10 = R3AR10                                            CSW214
     C**********         EVAL      RVAR11 = R3AR11                                            CSW214
     C**********         EVAL      RVAR12 = R3AR12                                            CSW214
     C**********         EVAL      RVAR13 = R3AR13                                            CSW214
     C**********         EVAL      RVAR14 = R3AR14                                            CSW214
     C**********         EVAL      RVAR15 = R3AR15                                            CSW214
     C**********         EVAL      RVAR16 = R3AR16                                            CSW214
     C**********         EVAL      RVAR17 = R3AR17                                            CSW214
     C**********         EVAL      RVAR18 = R3AR18                                            CSW214
     C**********         EVAL      RVAR19 = R3AR19                                            CSW214
     C**********         EVAL      RVAR20 = R3AR20                                            CSW214
                                                                                              CSW214
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      RVFNCI = R3FNCI                                            CSW214
     C                   EVAL      RVCOPI = R3COPI                                            CSW214
     C                   EVAL      RVCOPC = R3COPC                                            CSW214
     C                   EVAL      RVPOCI = R3POCI                                            CSW214
     C                   EVAL      RVCOSI = R3COSI                                            CSW214
     C                   EVAL      RVTNEI = R3TNEI                                            CSW214
     C                   EVAL      RVIGTI = R3IGTI                                            CSW214
     C                   EVAL      RVCTFI = R3CTFI                                            CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    WRetCode
     C                   PARM                    DLRILK
     C                   PARM                    DLRIS1Detail
     C                   PARM                    DLRIS2Detail
     C                   PARM                    DLRIS3Detail
     C                   PARM                    DLError3
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    DLVRPFileFmt
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'DLRIS3VAL'
     C                   OUT       LDA
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
                                                                                              CSW214
      ** Check if Swift 2014 Changes is installed.                                            CSW214
                                                                                              CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
                                                                                              CSW214
     C                   IF        PRTCD = 'CSW2014'                                          CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ENDIF                                                                CSW214
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ResetErrs - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UpDatErrs - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UpDatErrs     BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   IF        FldNamXAr <> *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      FldNameArr(I) = FldNamXAr
     C                   EVAL      MsgIdArr(I) = MsgIDXAr
     C                   EVAL      MsgDtaArr(I) = MsgDtaXAr
     C                   END
      *
     C                   Z-ADD     I             Idx
 
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   IF        WFldNmXAr <> *BLANKS
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   EVAL      WFldNamArr(I) = WFldNmXAr
     C                   EVAL      WMsgIDArr(I) = WMsgIDXAr
     C                   EVAL      WMsgDtaArr(I) = WMsgDtXAr
     C                   END
      *
     C                   Z-ADD     I             WIdx
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
