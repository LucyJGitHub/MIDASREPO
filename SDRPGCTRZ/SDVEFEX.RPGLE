     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Effective and Expiry Date')          *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVEFEX - Validate Effective and Expiry Date                 *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *

      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Country of TIN
     D CtxArr          S              2    DIM(10)
     D EffArr          S              6    DIM(10)
     D ExpArr          S              6    DIM(10)
     D VEffArr         S              5P 0 DIM(10)
     D VExpArr         S              5P 0 DIM(10)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

     D PCountryTIN     DS
     D  DDCTIN1                1      2
     D  DDCTIN2                3      4
     D  DDCTIN3                5      6
     D  DDCTIN4                7      8
     D  DDCTIN5                9     10
     D  DDCTN6                11     12
     D  DDCTN7                13     14
     D  DDCTN8                15     16
     D  DDCTN9                17     18
     D  DDCTN0                19     20

     D PEffectDate     DS
     D  DDEFF1                 1      6
     D  DDEFF2                 7     12
     D  DDEFF3                13     18
     D  DDEFF4                19     24
     D  DDEFF5                25     30
     D  DDEFF6                31     36
     D  DDEFF7                37     42
     D  DDEFF8                43     48
     D  DDEFF9                49     54
     D  DDEFF0                55     60

     D PExpiryDate     DS
     D  DDEXP1                 1      6
     D  DDEXP2                 7     12
     D  DDEXP3                13     18
     D  DDEXP4                19     24
     D  DDEXP5                25     30
     D  DDEXP6                31     36
     D  DDEXP7                37     42
     D  DDEXP8                43     48
     D  DDEXP9                49     54
     D  DDEXP0                55     60

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

     D WRUN            S              1
     D WDATEN          S              6  0
     D WDATEA          S              6

     D DDOKEFF1        S              1
     D DDOKEFF2        S              1
     D DDOKEFF3        S              1
     D DDOKEFF4        S              1
     D DDOKEFF5        S              1
     D DDOKEFF6        S              1
     D DDOKEFF7        S              1
     D DDOKEFF8        S              1
     D DDOKEFF9        S              1
     D DDOKEFF0        S              1
     D DDOKEXP1        S              1
     D DDOKEXP2        S              1
     D DDOKEXP3        S              1
     D DDOKEXP4        S              1
     D DDOKEXP5        S              1
     D DDOKEXP6        S              1
     D DDOKEXP7        S              1
     D DDOKEXP8        S              1
     D DDOKEXP9        S              1
     D DDOKEXP0        S              1
     D Z               S              3P 0
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S              2
     D ZDAYNO          S              5  0
     D ErrorFlag       S              1

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Initialization
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      Idx = 0

      ** Validation
     C                   EXSR      SRVEFEX

      ** If an error was found, set the return code appropriately
     C                   IF        DDOKEFF1 = 'N' OR
     C                             DDOKEFF2 = 'N' OR
     C                             DDOKEFF3 = 'N' OR
     C                             DDOKEFF4 = 'N' OR
     C                             DDOKEFF5 = 'N' OR
     C                             DDOKEFF6 = 'N' OR
     C                             DDOKEFF7 = 'N' OR
     C                             DDOKEFF8 = 'N' OR
     C                             DDOKEFF9 = 'N' OR
     C                             DDOKEFF0 = 'N' OR
     C                             DDOKEXP1 = 'N' OR
     C                             DDOKEXP2 = 'N' OR
     C                             DDOKEXP3 = 'N' OR
     C                             DDOKEXP4 = 'N' OR
     C                             DDOKEXP5 = 'N' OR
     C                             DDOKEXP6 = 'N' OR
     C                             DDOKEXP7 = 'N' OR
     C                             DDOKEXP8 = 'N' OR
     C                             DDOKEXP9 = 'N' OR
     C                             DDOKEXP0 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVEFEX - Validate Effective Date and Expiry Date             *
      *                                                               *
      *****************************************************************

     C     SRVEFEX       BEGSR

      ** Store all Country codes
     C                   EVAL      CtxArr(1) = DDCTIN1
     C                   EVAL      CtxArr(2) = DDCTIN2
     C                   EVAL      CtxArr(3) = DDCTIN3
     C                   EVAL      CtxArr(4) = DDCTIN4
     C                   EVAL      CtxArr(5) = DDCTIN5
     C                   EVAL      CtxArr(6) = DDCTN6
     C                   EVAL      CtxArr(7) = DDCTN7
     C                   EVAL      CtxArr(8) = DDCTN8
     C                   EVAL      CtxArr(9) = DDCTN9
     C                   EVAL      CtxArr(10) = DDCTN0

      ** Store all Effective date
     C                   EVAL      EffArr(1) = DDEFF1
     C                   EVAL      EffArr(2) = DDEFF2
     C                   EVAL      EffArr(3) = DDEFF3
     C                   EVAL      EffArr(4) = DDEFF4
     C                   EVAL      EffArr(5) = DDEFF5
     C                   EVAL      EffArr(6) = DDEFF6
     C                   EVAL      EffArr(7) = DDEFF7
     C                   EVAL      EffArr(8) = DDEFF8
     C                   EVAL      EffArr(9) = DDEFF9
     C                   EVAL      EffArr(10) = DDEFF0

      ** Store all Expiry date
     C                   EVAL      ExpArr(1) = DDEXP1
     C                   EVAL      ExpArr(2) = DDEXP2
     C                   EVAL      ExpArr(3) = DDEXP3
     C                   EVAL      ExpArr(4) = DDEXP4
     C                   EVAL      ExpArr(5) = DDEXP5
     C                   EVAL      ExpArr(6) = DDEXP6
     C                   EVAL      ExpArr(7) = DDEXP7
     C                   EVAL      ExpArr(8) = DDEXP8
     C                   EVAL      ExpArr(9) = DDEXP9
     C                   EVAL      ExpArr(10) = DDEXP0

     C                   EVAL      Z = 1

     C     Z             DOWLT     11

     C                   IF        CtxArr(Z) = *Blanks
     C                             AND EffArr(Z) <> *Blanks
     C                   ADD       1             Idx
     C                   MOVEL     'USS0608'     MsgIDXAr(Idx)

     C                   SELECT
     C                   WHEN      Z = 1
     C                   EVAL      DDOKEFF1 = 'N'
     C                   MOVEL     'DDEFF1'      FldNamXAr(Idx)
     C                   WHEN      Z = 2
     C                   EVAL      DDOKEFF2 = 'N'
     C                   MOVEL     'DDEFF2'      FldNamXAr(Idx)
     C                   WHEN      Z = 3
     C                   EVAL      DDOKEFF3 = 'N'
     C                   MOVEL     'DDEFF3'      FldNamXAr(Idx)
     C                   WHEN      Z = 4
     C                   EVAL      DDOKEFF4 = 'N'
     C                   MOVEL     'DDEFF4'      FldNamXAr(Idx)
     C                   WHEN      Z = 5
     C                   EVAL      DDOKEFF5 = 'N'
     C                   MOVEL     'DDEFF5'      FldNamXAr(Idx)
     C                   WHEN      Z = 6
     C                   EVAL      DDOKEFF6 = 'N'
     C                   MOVEL     'DDEFF6'      FldNamXAr(Idx)
     C                   WHEN      Z = 7
     C                   EVAL      DDOKEFF7 = 'N'
     C                   MOVEL     'DDEFF7'      FldNamXAr(Idx)
     C                   WHEN      Z = 8
     C                   EVAL      DDOKEFF8 = 'N'
     C                   MOVEL     'DDEFF8'      FldNamXAr(Idx)
     C                   WHEN      Z = 9
     C                   EVAL      DDOKEFF9 = 'N'
     C                   MOVEL     'DDEFF9'      FldNamXAr(Idx)
     C                   WHEN      Z = 10
     C                   EVAL      DDOKEFF0 = 'N'
     C                   MOVEL     'DDEFF0'      FldNamXAr(Idx)
     C                   ENDSL

     C                   GOTO      ENDVAL
     C                   ENDIF

     C                   Z-ADD     0             VEffArr(Z)
     C                   IF        EffArr(Z) <> *Blanks
     C                   MOVE      EffArr(Z)     WDATEA
     C                   TESTN                   EffArr(Z)            95
     C                   CALLB     'ZDATE1'
     C                   PARM                    WDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   IF        ErrorFlag = 'Y' or
     C                             *IN95 = *OFF
     C                   ADD       1             Idx
     C                   MOVEL     'USS0607'     MsgIDXAr(Idx)

     C                   SELECT
     C                   WHEN      Z = 1
     C                   EVAL      DDOKEFF1 = 'N'
     C                   MOVEL     'DDEFF1'      FldNamXAr(Idx)
     C                   WHEN      Z = 2
     C                   EVAL      DDOKEFF2 = 'N'
     C                   MOVEL     'DDEFF2'      FldNamXAr(Idx)
     C                   WHEN      Z = 3
     C                   EVAL      DDOKEFF3 = 'N'
     C                   MOVEL     'DDEFF3'      FldNamXAr(Idx)
     C                   WHEN      Z = 4
     C                   EVAL      DDOKEFF4 = 'N'
     C                   MOVEL     'DDEFF4'      FldNamXAr(Idx)
     C                   WHEN      Z = 5
     C                   EVAL      DDOKEFF5 = 'N'
     C                   MOVEL     'DDEFF5'      FldNamXAr(Idx)
     C                   WHEN      Z = 6
     C                   EVAL      DDOKEFF6 = 'N'
     C                   MOVEL     'DDEFF6'      FldNamXAr(Idx)
     C                   WHEN      Z = 7
     C                   EVAL      DDOKEFF7 = 'N'
     C                   MOVEL     'DDEFF7'      FldNamXAr(Idx)
     C                   WHEN      Z = 8
     C                   EVAL      DDOKEFF8 = 'N'
     C                   MOVEL     'DDEFF8'      FldNamXAr(Idx)
     C                   WHEN      Z = 9
     C                   EVAL      DDOKEFF9 = 'N'
     C                   MOVEL     'DDEFF9'      FldNamXAr(Idx)
     C                   WHEN      Z = 10
     C                   EVAL      DDOKEFF0 = 'N'
     C                   MOVEL     'DDEFF0'      FldNamXAr(Idx)
     C                   ENDSL

     C                   GOTO      ENDVAL
     C                   ELSE
     C                   Z-ADD     ZDAYNO        VEffArr(Z)
     C                   ENDIF
     C                   ENDIF

     C                   IF        CtxArr(Z) = *Blanks
     C                             AND ExpArr(Z) <> *Blanks
     C                   ADD       1             Idx
     C                   MOVEL     'USS0608'     MsgIDXAr(Idx)

     C                   SELECT
     C                   WHEN      Z = 1
     C                   EVAL      DDOKEXP1 = 'N'
     C                   MOVEL     'DDEXP1'      FldNamXAr(Idx)
     C                   WHEN      Z = 2
     C                   EVAL      DDOKEXP2 = 'N'
     C                   MOVEL     'DDEXP2'      FldNamXAr(Idx)
     C                   WHEN      Z = 3
     C                   EVAL      DDOKEXP3 = 'N'
     C                   MOVEL     'DDEXP3'      FldNamXAr(Idx)
     C                   WHEN      Z = 4
     C                   EVAL      DDOKEXP4 = 'N'
     C                   MOVEL     'DDEXP4'      FldNamXAr(Idx)
     C                   WHEN      Z = 5
     C                   EVAL      DDOKEXP5 = 'N'
     C                   MOVEL     'DDEXP5'      FldNamXAr(Idx)
     C                   WHEN      Z = 6
     C                   EVAL      DDOKEXP6 = 'N'
     C                   MOVEL     'DDEXP6'      FldNamXAr(Idx)
     C                   WHEN      Z = 7
     C                   EVAL      DDOKEXP7 = 'N'
     C                   MOVEL     'DDEXP7'      FldNamXAr(Idx)
     C                   WHEN      Z = 8
     C                   EVAL      DDOKEXP8 = 'N'
     C                   MOVEL     'DDEXP8'      FldNamXAr(Idx)
     C                   WHEN      Z = 9
     C                   EVAL      DDOKEXP9 = 'N'
     C                   MOVEL     'DDEXP9'      FldNamXAr(Idx)
     C                   WHEN      Z = 10
     C                   EVAL      DDOKEXP0 = 'N'
     C                   MOVEL     'DDEXP0'      FldNamXAr(Idx)
     C                   ENDSL

     C                   GOTO      ENDVAL
     C                   ENDIF

     C                   Z-ADD     0             VExpArr(Z)
     C                   IF        ExpArr(Z) <> *Blanks
     C                   MOVE      ExpArr(Z)     WDATEA
     C                   TESTN                   ExpArr(Z)            95
     C                   CALLB     'ZDATE1'
     C                   PARM                    WDATEA
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
     C                   IF        ErrorFlag = 'Y' or
     C                             *IN95 = *OFF
     C                   ADD       1             Idx
     C                   MOVEL     'USS0607'     MsgIDXAr(Idx)

     C                   SELECT
     C                   WHEN      Z = 1
     C                   EVAL      DDOKEXP1 = 'N'
     C                   MOVEL     'DDEXP1'      FldNamXAr(Idx)
     C                   WHEN      Z = 2
     C                   EVAL      DDOKEXP2 = 'N'
     C                   MOVEL     'DDEXP2'      FldNamXAr(Idx)
     C                   WHEN      Z = 3
     C                   EVAL      DDOKEXP3 = 'N'
     C                   MOVEL     'DDEXP3'      FldNamXAr(Idx)
     C                   WHEN      Z = 4
     C                   EVAL      DDOKEXP4 = 'N'
     C                   MOVEL     'DDEXP4'      FldNamXAr(Idx)
     C                   WHEN      Z = 5
     C                   EVAL      DDOKEXP5 = 'N'
     C                   MOVEL     'DDEXP5'      FldNamXAr(Idx)
     C                   WHEN      Z = 6
     C                   EVAL      DDOKEXP6 = 'N'
     C                   MOVEL     'DDEXP6'      FldNamXAr(Idx)
     C                   WHEN      Z = 7
     C                   EVAL      DDOKEXP7 = 'N'
     C                   MOVEL     'DDEXP7'      FldNamXAr(Idx)
     C                   WHEN      Z = 8
     C                   EVAL      DDOKEXP8 = 'N'
     C                   MOVEL     'DDEXP8'      FldNamXAr(Idx)
     C                   WHEN      Z = 9
     C                   EVAL      DDOKEXP9 = 'N'
     C                   MOVEL     'DDEXP9'      FldNamXAr(Idx)
     C                   WHEN      Z = 10
     C                   EVAL      DDOKEXP0 = 'N'
     C                   MOVEL     'DDEXP0'      FldNamXAr(Idx)
     C                   ENDSL

     C                   GOTO      ENDVAL
     C                   ELSE
     C                   Z-ADD     ZDAYNO        VExpArr(Z)
     C                   ENDIF
     C                   ENDIF

     C                   IF        VEffArr(Z) >= VExpArr(Z)
     C                             AND VEffArr(Z) <> 0
     C                             AND VExpArr(Z) <> 0
     C                   ADD       1             Idx
     C                   MOVEL     'USS0609'     MsgIDXAr(Idx)

     C                   SELECT
     C                   WHEN      Z = 1
     C                   EVAL      DDOKEXP1 = 'N'
     C                   MOVEL     'DDEXP1'      FldNamXAr(Idx)
     C                   WHEN      Z = 2
     C                   EVAL      DDOKEXP2 = 'N'
     C                   MOVEL     'DDEXP2'      FldNamXAr(Idx)
     C                   WHEN      Z = 3
     C                   EVAL      DDOKEXP3 = 'N'
     C                   MOVEL     'DDEXP3'      FldNamXAr(Idx)
     C                   WHEN      Z = 4
     C                   EVAL      DDOKEXP4 = 'N'
     C                   MOVEL     'DDEXP4'      FldNamXAr(Idx)
     C                   WHEN      Z = 5
     C                   EVAL      DDOKEXP5 = 'N'
     C                   MOVEL     'DDEXP5'      FldNamXAr(Idx)
     C                   WHEN      Z = 6
     C                   EVAL      DDOKEXP6 = 'N'
     C                   MOVEL     'DDEXP6'      FldNamXAr(Idx)
     C                   WHEN      Z = 7
     C                   EVAL      DDOKEXP7 = 'N'
     C                   MOVEL     'DDEXP7'      FldNamXAr(Idx)
     C                   WHEN      Z = 8
     C                   EVAL      DDOKEXP8 = 'N'
     C                   MOVEL     'DDEXP8'      FldNamXAr(Idx)
     C                   WHEN      Z = 9
     C                   EVAL      DDOKEXP9 = 'N'
     C                   MOVEL     'DDEXP9'      FldNamXAr(Idx)
     C                   WHEN      Z = 10
     C                   EVAL      DDOKEXP0 = 'N'
     C                   MOVEL     'DDEXP0'      FldNamXAr(Idx)
     C                   ENDSL
     C                   ENDIF

     C                   ADD       1             Z
     C                   ENDDO

     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Country of TIN, Effective Date, Expiry Date
     C                   PARM                    PCountryTIN
     C                   PARM                    PEffectDate
     C                   PARM                    PExpiryDate
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Effective Date 1 - OK
     C                   PARM                    DDOKEFF1
      ** Effective Date 2 - OK
     C                   PARM                    DDOKEFF2
      ** Effective Date 3 - OK
     C                   PARM                    DDOKEFF3
      ** Effective Date 4 - OK
     C                   PARM                    DDOKEFF4
      ** Effective Date 5 - OK
     C                   PARM                    DDOKEFF5
      ** Effective Date 6 - OK
     C                   PARM                    DDOKEFF6
      ** Effective Date 7 - OK
     C                   PARM                    DDOKEFF7
      ** Effective Date 8 - OK
     C                   PARM                    DDOKEFF8
      ** Effective Date 9 - OK
     C                   PARM                    DDOKEFF9
      ** Effective Date 10 - OK
     C                   PARM                    DDOKEFF0
      ** Expiry Date 1 - OK
     C                   PARM                    DDOKEXP1
      ** Expiry Date 2 - OK
     C                   PARM                    DDOKEXP2
      ** Expiry Date 3 - OK
     C                   PARM                    DDOKEXP3
      ** Expiry Date 4 - OK
     C                   PARM                    DDOKEXP4
      ** Expiry Date 5 - OK
     C                   PARM                    DDOKEXP5
      ** Expiry Date 6 - OK
     C                   PARM                    DDOKEXP6
      ** Expiry Date 7 - OK
     C                   PARM                    DDOKEXP7
      ** Expiry Date 8 - OK
     C                   PARM                    DDOKEXP8
      ** Expiry Date 9 - OK
     C                   PARM                    DDOKEXP9
      ** Expiry Date 10 - OK
     C                   PARM                    DDOKEXP0
      ** Effective Date 1-10
     C                   PARM                    VEffArr
      ** Expiry Date 1-10
     C                   PARM                    VExpArr

     C/COPY ZACPYSRC,DBFIELDS

      ** Call Access Program for Bank Details
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SDVEFEX'
     C                   EVAL      DBASE  = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *Blanks
     C                   EVAL      WRUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2015
