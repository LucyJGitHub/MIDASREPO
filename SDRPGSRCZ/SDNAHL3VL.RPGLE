     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - TIN Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHL3VL - Non-A/C Holders TIN Details Validation           *
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

     D PCTIN           DS
     D  DPCTIN1                1      2
     D  DPCTIN2                3      4
     D  DPCTIN3                5      6
     D  DPCTIN4                7      8
     D  DPCTIN5                9     10
     D  DPCTIN6               11     12
     D  DPCTIN7               13     14
     D  DPCTIN8               15     16
     D  DPCTIN9               17     18
     D  DPCTIN0               19     20

     D PFDATE          DS
     D  DPEFF1                 1      6
     D  DPEFF2                 7     12
     D  DPEFF3                13     18
     D  DPEFF4                19     24
     D  DPEFF5                25     30
     D  DPEFF6                31     36
     D  DPEFF7                37     42
     D  DPEFF8                43     48
     D  DPEFF9                49     54
     D  DPEFF0                55     60

     D PXDATE          DS
     D  DPEXP1                 1      6
     D  DPEXP2                 7     12
     D  DPEXP3                13     18
     D  DPEXP4                19     24
     D  DPEXP5                25     30
     D  DPEXP6                31     36
     D  DPEXP7                37     42
     D  DPEXP8                43     48
     D  DPEXP9                49     54
     D  DPEXP0                55     60

      ** Non-A/C Holder Primary Details in screen format
     D NaPrim        E DS                  Extname(SDNAHLPD)

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

     D ZMUSER          DS            17
     D  USRBCH                11     13

      ** Valid Non-A/C Holder Details layout
     D ValidNaho     E DS                  Extname(SDVNAHLPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PEFFDT          S              5P 0 Dim(10)
     D PEXPDT          S              5P 0 Dim(10)

     D Retcd           S              7A

     D Option          S              7A

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

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

      ** Validate TIN
      ** Validate Country of TIN
      ** Validate Effective date and expiry date

     C                   EXSR      SRVcTin1
     C                   EXSR      SRVcCTIN
     C                   EXSR      SRVcEfEx

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRVcTin1 - Validate TIN
      *****************************************************************
     C     SRVcTin1      BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

      ** Validate TIN

     C                   CALLB     'SDVTIN1'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** TIN
     C                   PARM                    DDTINO
      ** TIN2
     C     NATIN2        PARM                    DDTIN2
      ** TIN3
     C     NATIN3        PARM                    DDTIN3
      ** TIN4
     C     NATIN4        PARM                    DDTIN4
      ** TIN5
     C     NATIN5        PARM                    DDTIN5
      ** TIN6
     C     NATIN6        PARM                    DDTIN6
      ** TIN7
     C     NATIN7        PARM                    DDTIN7
      ** TIN8
     C     NATIN8        PARM                    DDTIN8
      ** TIN9
     C     NATIN9        PARM                    DDTIN9
      ** TIN10
     C     NATIN0        PARM                    DDTIN0
      ** Country of TIN 2
     C                   PARM                    DDCTIN2
      ** Country of TIN 3
     C                   PARM                    DDCTIN3
      ** Country of TIN 4
     C                   PARM                    DDCTIN4
      ** Country of TIN 5
     C                   PARM                    DDCTIN5
      ** Country of TIN 6
     C                   PARM                    DDCTN6
      ** Country of TIN 7
     C                   PARM                    DDCTN7
      ** Country of TIN 8
     C                   PARM                    DDCTN8
      ** Country of TIN 9
     C                   PARM                    DDCTN9
      ** Country of TIN 10
     C                   PARM                    DDCTN0
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** TIN - OK
     C                   PARM                    OKTINO
      ** TIN 2 - OK
     C                   PARM                    OKTIN2
      ** TIN 3 - OK
     C                   PARM                    OKTIN3
      ** TIN 4 - OK
     C                   PARM                    OKTIN4
      ** TIN 5 - OK
     C                   PARM                    OKTIN5
      ** TIN 6 - OK
     C                   PARM                    OKTIN6
      ** TIN 7 - OK
     C                   PARM                    OKTIN7
      ** TIN 8 - OK
     C                   PARM                    OKTIN8
      ** TIN 9 - OK
     C                   PARM                    OKTIN9
      ** TIN 10 - OK
     C                   PARM                    OKTIN0

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcCTIN - Validate Country of TIN
      *****************************************************************
     C     SRVcCTIN      BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

      ** Validate Country of TIN

     C                   CALLB     'SDVCTIN'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** TIN2
     C                   PARM                    DDTIN2
      ** TIN3
     C                   PARM                    DDTIN3
      ** TIN4
     C                   PARM                    DDTIN4
      ** TIN5
     C                   PARM                    DDTIN5
      ** TIN6
     C                   PARM                    DDTIN6
      ** TIN7
     C                   PARM                    DDTIN7
      ** TIN8
     C                   PARM                    DDTIN8
      ** TIN9
     C                   PARM                    DDTIN9
      ** TIN0
     C                   PARM                    DDTIN0
      ** Country of Domicile
     C                   PARM                    DDCOLC
      ** Country of TIN 2
     C     NACTIN2       PARM                    DDCTIN2
      ** Country of TIN 3
     C     NACTIN3       PARM                    DDCTIN3
      ** Country of TIN 4
     C     NACTIN4       PARM                    DDCTIN4
      ** Country of TIN 5
     C     NACTIN5       PARM                    DDCTIN5
      ** Country of TIN 6
     C     NACTN6        PARM                    DDCTN6
      ** Country of TIN 7
     C     NACTN7        PARM                    DDCTN7
      ** Country of TIN 8
     C     NACTN8        PARM                    DDCTN8
      ** Country of TIN 9
     C     NACTN9        PARM                    DDCTN9
      ** Country of TIN 10
     C     NACTN0        PARM                    DDCTN0

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Country of Domicile - OK
     C                   PARM                    OKCOLC
      ** Country of TIN 2 - OK
     C                   PARM                    OKCTIN2
      ** Country of TIN 3 - OK
     C                   PARM                    OKCTIN3
      ** Country of TIN 4 - OK
     C                   PARM                    OKCTIN4
      ** Country of TIN 5 - OK
     C                   PARM                    OKCTIN5
      ** Country of TIN 6 - OK
     C                   PARM                    OKCTN6
      ** Country of TIN 7 - OK
     C                   PARM                    OKCTN7
      ** Country of TIN 8 - OK
     C                   PARM                    OKCTN8
      ** Country of TIN 9 - OK
     C                   PARM                    OKCTN9
      ** Country of TIN 10 - OK
     C                   PARM                    OKCTN0

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcEfex - Validate Effective and Expiry Date
      *****************************************************************
     C     SRVcEfex      BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

     C                   EVAL      DPCTIN1 = DDCOLC
     C                   EVAL      DPCTIN2 = DDCTIN2
     C                   EVAL      DPCTIN3 = DDCTIN3
     C                   EVAL      DPCTIN4 = DDCTIN4
     C                   EVAL      DPCTIN5 = DDCTIN5
     C                   EVAL      DPCTIN6 = DDCTN6
     C                   EVAL      DPCTIN7 = DDCTN7
     C                   EVAL      DPCTIN8 = DDCTN8
     C                   EVAL      DPCTIN9 = DDCTN9
     C                   EVAL      DPCTIN0 = DDCTN0
     C                   EVAL      DPEFF1 = DDEFF1
     C                   EVAL      DPEFF2 = DDEFF2
     C                   EVAL      DPEFF3 = DDEFF3
     C                   EVAL      DPEFF4 = DDEFF4
     C                   EVAL      DPEFF5 = DDEFF5
     C                   EVAL      DPEFF6 = DDEFF6
     C                   EVAL      DPEFF7 = DDEFF7
     C                   EVAL      DPEFF8 = DDEFF8
     C                   EVAL      DPEFF9 = DDEFF9
     C                   EVAL      DPEFF0 = DDEFF0
     C                   EVAL      DPEXP1 = DDEXP1
     C                   EVAL      DPEXP2 = DDEXP2
     C                   EVAL      DPEXP3 = DDEXP3
     C                   EVAL      DPEXP4 = DDEXP4
     C                   EVAL      DPEXP5 = DDEXP5
     C                   EVAL      DPEXP6 = DDEXP6
     C                   EVAL      DPEXP7 = DDEXP7
     C                   EVAL      DPEXP8 = DDEXP8
     C                   EVAL      DPEXP9 = DDEXP9
     C                   EVAL      DPEXP0 = DDEXP0

      ** Validate Effective and Expiry Date

     C                   CALLB     'SDVEFEX'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Country of TIN
     C                   PARM                    PCTIN
      ** Effective Date
     C                   PARM                    PFDATE
      ** Expiry Date
     C                   PARM                    PXDATE

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Effective Date 1 - OK
     C                   PARM                    OKEFF1
      ** Effective Date 2 - OK
     C                   PARM                    OKEFF2
      ** Effective Date 3 - OK
     C                   PARM                    OKEFF3
      ** Effective Date 4 - OK
     C                   PARM                    OKEFF4
      ** Effective Date 5 - OK
     C                   PARM                    OKEFF5
      ** Effective Date 6 - OK
     C                   PARM                    OKEFF6
      ** Effective Date 7 - OK
     C                   PARM                    OKEFF7
      ** Effective Date 8 - OK
     C                   PARM                    OKEFF8
      ** Effective Date 9 - OK
     C                   PARM                    OKEFF9
      ** Effective Date 10 - OK
     C                   PARM                    OKEFF0
      ** Expiry Date 1 - OK
     C                   PARM                    OKEXP1
      ** Expiry Date 2 - OK
     C                   PARM                    OKEXP2
      ** Expiry Date 3 - OK
     C                   PARM                    OKEXP3
      ** Expiry Date 4 - OK
     C                   PARM                    OKEXP4
      ** Expiry Date 5 - OK
     C                   PARM                    OKEXP5
      ** Expiry Date 6 - OK
     C                   PARM                    OKEXP6
      ** Expiry Date 7 - OK
     C                   PARM                    OKEXP7
      ** Expiry Date 8 - OK
     C                   PARM                    OKEXP8
      ** Expiry Date 9 - OK
     C                   PARM                    OKEXP9
      ** Expiry Date 10 - OK
     C                   PARM                    OKEXP0
      ** Effective date 1-10
     C                   PARM                    PEFFDT
      ** Expiry date 1-10
     C                   PARM                    PEXPDT

     C                   EVAL      NAEFF1 = PEFFDT(1)
     C                   EVAL      NAEFF2 = PEFFDT(2)
     C                   EVAL      NAEFF3 = PEFFDT(3)
     C                   EVAL      NAEFF4 = PEFFDT(4)
     C                   EVAL      NAEFF5 = PEFFDT(5)
     C                   EVAL      NAEFF6 = PEFFDT(6)
     C                   EVAL      NAEFF7 = PEFFDT(7)
     C                   EVAL      NAEFF8 = PEFFDT(8)
     C                   EVAL      NAEFF9 = PEFFDT(9)
     C                   EVAL      NAEFF0 = PEFFDT(10)
     C                   EVAL      NAEXP1 = PEXPDT(1)
     C                   EVAL      NAEXP2 = PEXPDT(2)
     C                   EVAL      NAEXP3 = PEXPDT(3)
     C                   EVAL      NAEXP4 = PEXPDT(4)
     C                   EVAL      NAEXP5 = PEXPDT(5)
     C                   EVAL      NAEXP6 = PEXPDT(6)
     C                   EVAL      NAEXP7 = PEXPDT(7)
     C                   EVAL      NAEXP8 = PEXPDT(8)
     C                   EVAL      NAEXP9 = PEXPDT(9)
     C                   EVAL      NAEXP0 = PEXPDT(10)

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRResetErrs - Reset error information that is received back  *
      **    from each validation module.                              *
      *****************************************************************
     C     SRResetErrs   BEGSR

     C                   EVAL      RetCodeOut = *Blanks

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
      ** Response mode
      ** Non-A/C Holder Details

     C                   PARM                    RespMode
     C                   PARM                    NaPrim

      ** OUTPUTS
      ** Non-A/C Holder Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid Non-A/C Holder details layout (DS) from/to caller

     C                   PARM                    OKNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    ValidNaho

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '001'         Dbase
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

     C                   MOVEL     'SDNAHL3VL'   Dbpgm
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
(c) Finastra International Limited 2015
