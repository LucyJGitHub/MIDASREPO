     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Country Codes')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVCTRYD - Validate Mailing Countries                        *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
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
      ** Mailing Countries
     D CtxArr          S              2    DIM(5)

      ** External DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

     D @RUN            S              1
     D DDCTR1          S              2
     D DDCTR2          S              2
     D DDCTR3          S              2
     D DDCTR4          S              2
     D DDCTR5          S              2
     D DDOKCTR1        S              1
     D DDOKCTR2        S              1
     D DDOKCTR3        S              1
     D DDOKCTR4        S              1
     D DDOKCTR5        S              1
     D Z               S              3P 0
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S              2

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
     C                   EXSR      SRVCTRY

      ** If an error was found, set the return code appropriately
     C                   IF        DDOKCTR1 = 'N' OR
     C                             DDOKCTR2 = 'N' OR
     C                             DDOKCTR3 = 'N' OR
     C                             DDOKCTR4 = 'N' OR
     C                             DDOKCTR5 = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCTRY - Validate Mailing Countries                          *
      *                                                               *
      *****************************************************************

     C     SRVCTRY       BEGSR

     C                   EVAL      CtxArr(1) = DDCTR1
     C                   EVAL      CtxArr(2) = DDCTR2
     C                   EVAL      CtxArr(3) = DDCTR3
     C                   EVAL      CtxArr(4) = DDCTR4
     C                   EVAL      CtxArr(5) = DDCTR5

      ** Mailing Countries must be unique and a valid country code
     C                   IF        DDCTR1 <> *BLANKS
     C                   EVAL      PKEY1 = DDCTR1
     C                   EXSR      SRAOCTRY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTR1 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR1'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0611'
     C                   ELSE
     C                   EVAL      DDCTR1 = A4CNCD
     C                   EVAL      CtxArr(1) = A4CNCD
     C                   ENDIF
     C                   ELSE
     C                   IF        DDCTR2 <> *BLANKS
     C                             OR DDCTR3 <> *BLANKS
     C                             OR DDCTR4 <> *BLANKS
     C                             OR DDCTR5 <> *BLANKS
     C                   EVAL      DDOKCTR1 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR1'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0614'
     C                   ENDIF

     C                   ENDIF

     C                   IF        DDCTR2 <> *BLANKS
     C                   EVAL      Z = 1
     C                   IF        %LOOKUP(DDCTR2:CtxArr:1:Z) <> 0
     C                             AND DDCTR2 <> '?'
     C                   EVAL      DDOKCTR2 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR2'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0610'
     C                   ENDIF

     C                   EVAL      PKEY1 = DDCTR2
     C                   EXSR      SRAOCTRY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTR2 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR2'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0611'
     C                   ELSE
     C                   EVAL      DDCTR2 = A4CNCD
     C                   EVAL      CtxArr(2) = A4CNCD
     C                   ENDIF
     C                   ELSE
     C                   IF        DDCTR3 <> *BLANKS
     C                             OR DDCTR4 <> *BLANKS
     C                             OR DDCTR5 <> *BLANKS
     C                   EVAL      DDOKCTR2 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR2'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0614'
     C                   ENDIF

     C                   ENDIF

     C                   IF        DDCTR3 <> *BLANKS
     C                   EVAL      Z = 2
     C                   IF        %LOOKUP(DDCTR3:CtxArr:1:Z) <> 0
     C                             AND DDCTR3 <> '?'
     C                   EVAL      DDOKCTR3 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR3'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0610'
     C                   ENDIF

     C                   EVAL      PKEY1 = DDCTR3
     C                   EXSR      SRAOCTRY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTR3 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR3'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0611'
     C                   ELSE
     C                   EVAL      DDCTR3 = A4CNCD
     C                   EVAL      CtxArr(3) = A4CNCD
     C                   ENDIF
     C                   ELSE
     C                   IF        DDCTR4 <> *BLANKS
     C                             OR DDCTR5 <> *BLANKS
     C                   EVAL      DDOKCTR3 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR3'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0614'
     C                   ENDIF

     C                   ENDIF

     C                   IF        DDCTR4 <> *BLANKS
     C                   EVAL      Z = 3
     C                   IF        %LOOKUP(DDCTR4:CtxArr:1:Z) <> 0
     C                             AND DDCTR4 <> '?'
     C                   EVAL      DDOKCTR4 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR4'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0610'
     C                   ENDIF

     C                   EVAL      PKEY1 = DDCTR4
     C                   EXSR      SRAOCTRY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTR4 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR4'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0611'
     C                   ELSE
     C                   EVAL      DDCTR4 = A4CNCD
     C                   EVAL      CtxArr(4) = A4CNCD
     C                   ENDIF
     C                   ELSE
     C                   IF        DDCTR5 <> *BLANKS
     C                   EVAL      DDOKCTR4 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR4'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0614'
     C                   ENDIF

     C                   ENDIF

     C                   IF        DDCTR5 <> *BLANKS
     C                   EVAL      Z = 4
     C                   IF        %LOOKUP(DDCTR5:CtxArr:1:Z) <> 0
     C                             AND DDCTR5 <> '?'
     C                   EVAL      DDOKCTR5 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR5'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0610'
     C                   ENDIF
     C
     C                   EVAL      PKEY1 = DDCTR5
     C                   EXSR      SRAOCTRY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTR5 = 'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNamXAr(Idx) = 'DDCTR5'
     C                   EVAL      MsgIDXAr(Idx)  = 'USS0611'
     C                   ELSE
     C                   EVAL      DDCTR5 = A4CNCD
     C                   EVAL      CtxArr(5) = A4CNCD
     C                   ENDIF

     C                   ENDIF

     C     ENDVAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAOCTRY - Validate Country Code                              *
      *                                                               *
      *****************************************************************

     C     SRAOCTRY      BEGSR

     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM                    PKEY1
     C     SDCTRY        PARM      SDCTRY        DSSDY

     C                   ENDSR
      /EJECT
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
      ** Mailing Country 1
     C                   PARM                    DDCTR1
      ** Mailing Country 2
     C                   PARM                    DDCTR2
      ** Mailing Country 3
     C                   PARM                    DDCTR3
      ** Mailing Country 4
     C                   PARM                    DDCTR4
      ** Mailing Country 5
     C                   PARM                    DDCTR5
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Mailing Country 1 - OK
     C                   PARM                    DDOKCTR1
      ** Mailing Country 2 - OK
     C                   PARM                    DDOKCTR2
      ** Mailing Country 3 - OK
     C                   PARM                    DDOKCTR3
      ** Mailing Country 4 - OK
     C                   PARM                    DDOKCTR4
      ** Mailing Country 5 - OK
     C                   PARM                    DDOKCTR5
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

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

     C                   IF        @RUN = *Blanks
     C                   EVAL      @RUN = 'Y'

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
