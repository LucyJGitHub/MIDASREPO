     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Yield Rate/Disc. Factor Module')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDVYRAT01 - Validate Yield Rate/Discount Factor Module       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD030900           Date 26Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030900 - Allow negative yield rate                         *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  None                                                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation                                  *
      *  SRINIT     - Initialisation Processing                       *
      *  SRVYLDRTE  - Validate Yield Rate                             *
      *  *PSSR      - DB Error Processing                             *
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARR1
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

      ** Yield Curve Details
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      ** Yield Rate
     D PerYRte         S             14

      ** Yield Rate (Numeric)
     D PerNYRte        S             13P 9

      ** OK Flag of Yield Rates
     D PYRteOK         S              1

      ** Other work fields/index/parameters
     D A               S              4  0
     D WElementN       S              2
     D WErrFld         S             10
     D PPrvRate        S             13P 9
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
     D PZFIELD         S             16
     D PZALIGNOK       S              1
                                                                                            MD030900
      **                                                                                    MD030900
     DCharRate         S             14                                                     MD030900
     DGetRate          S             14                                                     MD030900

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Initialisation Processing

     C                   EXSR      SRINIT

      ** Validate Yield Rate

     C                   EXSR      SRVYLDRTE

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT  - Initialisation Processing                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR

      ** Initialize error work fields and arrays

     C                   EVAL      RetCodeIn =  *BLANK
     C                   EVAL      FldNamXar2 =  *BLANK
     C                   EVAL      MsgIdXar2 =  *BLANK
     C                   EVAL      MsgDtaXar2 =  *BLANK
     C                   EVAL      Idx = *ZERO
     C                   EVAL      WIdx = *ZERO

     C                   EVAL      PerNYRte = *ZEROS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVYLDRTE - Validate Yield Rate                               *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * ZALIGN      - Align Numeric Screen Fields                     *
      *                                                               *
      *****************************************************************

     C     SRVYLDRTE     BEGSR

      ** Yield Rate should not be blank

     C                   IF        PerYRte = *BLANK
     C                   EVAL      PYRteOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0YRAT    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9215'
     C                   ELSE
     C                   EVAL      PZFIELD = *BLANK
      *                                                                                     MD030900
      ** Check Negative Sign, if found check position.                                      MD030900
      *                                                                                     MD030900
     C                   MOVE      'N'           NEGINT            1                        MD030900
     C     '-'           SCAN      PerYRte       NEGPOS            2 0    46                MD030900
     C     *IN46         IFEQ      '1'                                                      MD030900
     C                   MOVE      'Y'           NEGINT                                     MD030900
     C                   MOVE      PerYRte       WPerYRte         14                        MD030900
     C                   MOVE      *BLANKS       LeftPos          14                        MD030900
     C                   MOVE      *BLANKS       RightPos         14                        MD030900
     C                   Z-ADD     0             CHARPOSL          2 0                      MD030900
     C                   Z-ADD     0             CHARPOSR          2 0                      MD030900
      *                                                                                     MD030900
      ** If Negative position is in first char of the field, process the rate               MD030900
      ** value                                                                              MD030900
      *                                                                                     MD030900
     C                   SELECT                                                             MD030900
     C     NEGPOS        WHENEQ    1                                                        MD030900
     C                   EVAL      GetRate = %SUBST(PerYRte:NEGPOS+1)                       MD030900
     C                   MOVE      *BLANKS       PerYRte                                    MD030900
     C                   MOVE      GetRate       PerYRte                                    MD030900
      *                                                                                     MD030900
      ** If Negative position is in last char of the field, process the rate                MD030900
      ** value                                                                              MD030900
      *                                                                                     MD030900
     C     NEGPOS        WHENEQ    14                                                       MD030900
     C                   EVAL      GetRate = %SUBST(PerYRte:1:NEGPOS-1)                     MD030900
     C                   MOVE      *BLANKS       PerYRte                                    MD030900
     C                   MOVE      GetRate       PerYRte                                    MD030900
      *                                                                                     MD030900
      ** If Negative position is in middle of the field, check the left and                 MD030900
      ** right side of the negative sign if it has a value                                  MD030900
      *                                                                                     MD030900
     C     NEGPOS        WHENGT    1                                                        MD030900
     C     NEGPOS        ANDLT     14                                                       MD030900
     C                   EVAL      LeftPos  = %SUBST(PerYRte:1:NEGPOS-1)                    MD030900
     C                   EVAL      RightPos = %SUBST(PerYRte:NEGPOS+1)                      MD030900
     C                   EVAL      CHARPOSL =%CHECK (' ': LeftPos)                          MD030900
     C                   EVAL      CHARPOSR =%CHECK (' ': RightPos)                         MD030900
      *                                                                                     MD030900
     C     CHARPOSL      IFGT      0                                                        MD030900
     C     CHARPOSR      ANDGT     0                                                        MD030900
     C                   MOVE      WPerYRte      PerYRte                                    MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C     CHARPOSL      IFEQ      0                                                        MD030900
     C     CHARPOSR      ANDGT     0                                                        MD030900
     C                   EVAL      GetRate = %SUBST(PerYRte:NEGPOS+1)                       MD030900
     C                   MOVE      *BLANKS       PerYRte                                    MD030900
     C                   MOVE      GetRate       PerYRte                                    MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C     CHARPOSL      IFGT      0                                                        MD030900
     C     CHARPOSR      ANDEQ     0                                                        MD030900
     C                   EVAL      GetRate = %SUBST(PerYRte:1:NEGPOS-1)                     MD030900
     C                   MOVE      *BLANKS       PerYRte                                    MD030900
     C                   MOVE      GetRate       PerYRte                                    MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C                   ENDSL                                                              MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZALIGNOK
     C                   PARM      PerYRte       PZFIELD
     C                   PARM      9             PZADEC
     C                   PARM      4             PZADIG

      ** Valid entry

     C                   IF        PZALIGNOK = 'Y'
     C                   MOVE      PZFIELD       PerNYRte
      *                                                                                     MD030900
     C     NEGINT        IFEQ      'Y'                                                      MD030900
     C                   Z-SUB     PerNYRte      PerNYRte                                   MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900

      ** Edit rate field

     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFIELD
     C                   PARM                    PZADEC

     C                   MOVE      PZFIELD       PerYRTe
      *                                                                                     MD030900
     C     NEGINT        IFEQ      'Y'                                                      MD030900
     C                   MOVE      PerYRTe       TPerYRTe         13                        MD030900
     C     '-'           CAT       TPerYRTe      NegRate          14                        MD030900
     C                   MOVE      NegRate       PerYRTe                                    MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900

      ** Error if Zero

     C                   IF        PerNYRte = *ZERO
     C                   EVAL      PYRteOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0YRAT    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9216'
     C                   ENDIF
     C                   ELSE

      ** Error calling ZALIGN

      *                                                                                     MD030900
     C     NEGINT        IFEQ      'Y'                                                      MD030900
     C                   MOVE      WPerYRte      PerYRte                                    MD030900
     C                   ENDIF                                                              MD030900
      *                                                                                     MD030900
     C                   EVAL      PYRteOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0YRAT    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9216'
     C                   ENDIF
     C                   ENDIF

      ** Do extra validation on rates if yield type is 'D'

     C                   IF        (PYRteOK = 'Y') AND (FSYLDT = 'D')
     C                   IF        PerNYRte >= 1.0
     C                   EVAL      PYRteOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0YRAT    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9217'
     C                   ELSE
     C                   IF        (PPrvRate <> *ZERO) AND
     C                             (PerNYRte > PPrvRate)
     C                   EVAL      PYRteOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WErrFld = '#0YRAT    '
     C                   EXSR      SRSETERRFLD
     C                   EVAL      FldNamXAr2(Idx) = WErrFld
     C                   EVAL      MsgIdXAr2(Idx) = 'USR9218'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETERRFLD - Set up error field                              *
      *                                                               *
      * Called By : SRVYLDRTE subroutine                              *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************

     C     SRSETERRFLD   BEGSR

      ** Add Element number

     C                   MOVE      A             WElementN
     C                   EVAL      WErrFld = %Trim(WErrFld) + WElementN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called By : Called automatically upon module execution        *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    A
     C                   PARM                    PerYRte
     C                   PARM                    PerNYRte
     C                   PARM                    PPrvRate
     C                   PARM                    SDYLDC
     C                   PARM                    FldNamXAr2
     C                   PARM                    MsgIDXAr2
     C                   PARM                    MsgDtaXAr2
     C                   PARM                    PYRteOK

      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
