     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - CER076 validation')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHL9VL - Non-A/C Holders CER076 Validation                *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. CAP240   *Create   Date 01Jul21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP240 - SD Non-Account Holders JAVA Conversion              *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS

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

      * Check for Digits field
     D DIGITSDS        DS
     D DIGITS                  1      9    DIM(9)
     D #_DIG           S              1    DIM(10) CTDATA PERRCD(10)

      ** Non-A/C Holder Primary Details in screen format
     D TranInNahl    E DS                  Extname(SDNAHLPD)

      ** Non-A/C Holder Primary Details OK indicators
     D OKNaPrim      E DS                  Extname(SDENAHLPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)

      ** External DS for Midas modules
     D SDMMOD        E DS                  Extname(SDMMODPD)

     D ZMUSER          DS            17
     D  USRBCH                11     13

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D OKEINO          S              1A
     D ValidEino       S             30A
     D Retcd           S              7A
     D Option          S              7A

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D Err             S              2  0
     D I               S              3  0
     D RespMode        S              1

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   EXSR      SRVEino

     C                   RETURN

      ********************************************************************
      * SRVEINO - Routine to validate #0EINO - Economic ID
      ********************************************************************
     C     SRVEINO       BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs
     C                   EVAL      Err = *Zeros
     C                   EVAL      OKEino = 'Y'

      * If country of location is not Germany,
      * Economic ID must not be entered

     C                   IF        DDCOLC <> 'DE' and
     C                             DDEINO <> *blank
     C                   EVAL      OKEino = 'N'
     C                   EVAL      Err = Err + 1
     C                   EVAL      FldNamXAr(Err) = 'DDEINO'
     C                   EVAL      MsgIdXAr(Err)  = 'USR4850'
     C                   ENDIF

      * If country of location is Germany,
      * Economic ID is mandatory for corporate customers
      * (and optional for private individuals)

     C                   IF        DDCOLC = 'DE' and
     C                             DDPIND <> 'Y' and
     C                             DDEINO =  *blank
     C                   EVAL      OKEino = 'N'
     C                   EVAL      Err = Err + 1
     C                   EVAL      FldNamXAr(Err) = 'DDEINO'
     C                   EVAL      MsgIdXAr(Err)  = 'USR4851'
     C                   ENDIF

      * If entered, Economic ID must be 'DE' + 9 digits

     C                   IF        DDEINO <> *blank
     C                   EVAL      DIGITSDS = %SUBST(DDEINO:3:9)
     C                   EXSR      CHK_IF_DIGITS
     C                   IF        %SUBST(DDEINO:1:2) <> 'DE' or
     C                             %SUBST(DDEINO:12:19) <> *blank or
     C                             *IN99 = *OFF
     C                   EVAL      OKEino = 'N'
     C                   EVAL      Err = Err + 1
     C                   EVAL      FldNamXAr(Err) = 'DDEINO'
     C                   EVAL      MsgIdXAr(Err)  = 'USR4852'
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      SRUpdatErrs

     C                   If        OkEINO <> 'N'
     C                   Eval      ValidEino = DDEino
     C                   Endif

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      *  Check if number is all digits
      ********************************************************************
     C     CHK_IF_DIGITS BEGSR

     C                   Z-add     1             Id2               2 0
     C                   DOU       Id2 > 9 OR
     C                             *IN99 = *OFF
     C     DIGITS(Id2)   LOOKUP    #_DIG                                  99
     C                   ADD       1             Id2
     C                   ENDDO
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRResetErrs - Reset error information that is received back  *
      **    from each validation module.                              *
      *****************************************************************
     C     SRResetErrs   BEGSR

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRUpdatErrs - Update error information with that received back*
      **    from each validation module.                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF

      ** Set Error Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF

      ** Set Warning Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** INPUTS

     C                   PARM                    RespMode
     C                   PARM                    DDEINO           30
     C                   PARM                    TranInNAHL

      ** OUTPUTS

     C                   PARM                    OKEINO
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidEino

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
     C                   ENDIF

      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception Errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDNAHL9VL'   Dbpgm
     C                   MOVE      *On           *INU7
     C                   MOVE      *On           *INU8
     C                   MOVE      *On           *INLR

     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2021
**  CTDATA #_DIG
0123456789
