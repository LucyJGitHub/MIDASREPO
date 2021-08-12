     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan details validation - Italian')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  LECLIP6VL - LE Loans Details Validation                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC113 - UCI Italian Returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

     D PScnDtaItl    E DS                  EXTNAME(LECLRXPD)
      ** Transaction Details in screen format

     D OKCLIPItl     E DS                  EXTNAME(LEECLIT1PD)
      ** Transaction Details OK indicators

     D PValidCLIPItl E DS                  EXTNAME(LEVCLIT1PD)
      ** Valid Transaction Details layout

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Long DS for access programs

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency DS

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc

     D WIdx            S              3P 0
      ** Index for arrays of of warning message ids etc

     D I               S              3P 0

     D PRTCD           S              7A
     D POPTN           S              7A
     D PCHR003         S              3A
      ** Parameters for AOCURRR0

     D PCCY            S              3A
     D PBJDFIN         S              1A
      ** Entry Parameters

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
     C                   EXSR      SRInit

     C                   EXSR      SRVldMOOP
     C                   EXSR      SRVldAGCT
     C                   EXSR      SRVldAGCL
     C                   EXSR      SRVldECBD
     C                   EXSR      SRVldSBCR
     C                   EXSR      SRVldINSB
     C                   EXSR      SRVldTPPR
     C                   EXSR      SRVldPEPR
     C                   EXSR      SRVldGLPA
     C                   EXSR      SRVldTPFD
     C                   EXSR      SRVldSBLW
     C                   EXSR      SRVldDPIV
     C                   EXSR      SRVldEDIV
     C                   EXSR      SRVldCATC
     C                   EXSR      SRVldTPAC
     C                   EXSR      SRVldCLRL
     C                   EXSR      SRVldACST
     C                   EXSR      SRVldLNIT
     C                   EXSR      SRVldTEGL
     C                   EXSR      SRVldUNDT
     C                   EXSR      SRVldPSAM
     C                   EXSR      SRVldLEAD
     C                   EXSR      SRVldPTRP                                           LUC139
     C                   EXSR      SRVldCMPC                                           LUC139

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialisation Process                              *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

     C                   CLEAR                   PValidCLIPItl

     C                   EVAL      DDTMOOPOK = 'Y'
     C                   EVAL      DDTAGCTOK = 'Y'
     C                   EVAL      DDTAGCLOK = 'Y'
     C                   EVAL      DDTECBDOK = 'Y'
     C                   EVAL      DDTSBCROK = 'Y'
     C                   EVAL      DDTINSBOK = 'Y'
     C                   EVAL      DDTTPPROK = 'Y'
     C                   EVAL      DDTPEPROK = 'Y'
     C                   EVAL      DDTGLPAOK = 'Y'
     C                   EVAL      DDTTPFDOK = 'Y'
     C                   EVAL      DDTSBLWOK = 'Y'
     C                   EVAL      DDTDPIVOK = 'Y'
     C                   EVAL      DDTEDIVOK = 'Y'
     C                   EVAL      DDTCATCOK = 'Y'
     C                   EVAL      DDTTPACOK = 'Y'
     C                   EVAL      DDTCLRLOK = 'Y'
     C                   EVAL      DDTACSTOK = 'Y'
     C                   EVAL      DDTLNITOK = 'Y'
     C                   EVAL      DDTTEGLOK = 'Y'
     C                   EVAL      DDTUNDTOK = 'Y'
     C                   EVAL      DDTPSAMOK = 'Y'
     C                   EVAL      DDTLEADOK = 'Y'
     C                   EVAL      DDTPTRPOK = 'Y'                                      LUC139
     C                   EVAL      DDTCMPCOK = 'Y'                                      LUC139

     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANK        PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      PCCY          PCHR003
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldMOOP - Validate Motivation of Operation                 *
      *                                                               *
      *****************************************************************
     C     SrVldMOOP     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTMOOP'

      ** Inputs

     C                   PARM                    DDTMOOP
     C                   PARM                    DDTMOOPOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFMOOP

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldAGCT - Validate Agricultural Credit Classification      *
      *                                                               *
      *****************************************************************
     C     SrVldAGCT     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTAGCT'

      ** Inputs

     C                   PARM                    DDTAGCT
     C                   PARM                    DDTAGCTOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFAGCT

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldAGCL - Validate Agricultural Laws Classification        *
      *                                                               *
      *****************************************************************
     C     SrVldAGCL     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTAGCL'

      ** Inputs

     C                   PARM                    DDTAGCL
     C                   PARM                    DDTAGCLOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFAGCL

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldECBD - Validate Economical Branch of Destination        *
      *                                                               *
      *****************************************************************
     C     SrVldECBD     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTECBD'

      ** Inputs

     C                   PARM                    DDTECBD
     C                   PARM                    DDTECBDOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFECBD

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldSBCR - Validate Subsidized Credit Indicator             *
      *                                                               *
      *****************************************************************
     C     SrVldSBCR     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTSBCR'

      ** Inputs

     C                   PARM                    DDTSBCR
     C                   PARM                    DDTSBCROK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFSBCR

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldTPPR - Validate Type of Product                         *
      *                                                               *
      *****************************************************************
     C     SrVldTPPR     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTTPPR'

      ** Inputs

     C                   PARM                    DDTTPPR
     C                   PARM                    DDTTPPROK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFTPPR

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldINSB - Validate Subsidized Interest for Export          *
      *                                                               *
      *****************************************************************
     C     SrVldINSB     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTINSB'

      ** Inputs

     C                   PARM                    DDTINSB
     C                   PARM                    DDTINSBOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFINSB

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldPEPR - Validate Personalization of Operation            *
      *                                                               *
      *****************************************************************
     C     SrVldPEPR     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTPEPR'

      ** Inputs

     C                   PARM                    DDTPEPR
     C                   PARM                    DDTPEPROK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFPEPR

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldGLPA - Validate Partial Operation                       *
      *                                                               *
      *****************************************************************
     C     SrVldGLPA     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTGLPA'

      ** Inputs

     C                   PARM                    DDTGLPA
     C                   PARM                    DDTGLPAOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFGLPA

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldSBLW - Validate Law for Subsidized Credit               *
      *                                                               *
      *****************************************************************
     C     SrVldSBLW     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTSBLW'

      ** Inputs

     C                   PARM                    DDTSBLW
     C                   PARM                    VPFSBCR
     C                   PARM                    DDTSBLWOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFSBLW

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldTPFD - Validate Operation with Third Party Funds        *
      *                                                               *
      *****************************************************************
     C     SrVldTPFD     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTTPFD'

      ** Inputs

     C                   PARM                    DDTTPFD
     C                   PARM                    DDTTPFDOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFTPFD

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldDPIV - Validate Destination Province of Investment      *
      *                                                               *
      *****************************************************************
     C     SrVldDPIV     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTDPIV'

      ** Inputs

     C                   PARM                    DDTDPIV
     C                   PARM                    DDTDPIVOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFDPIV

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldTPAC - Validate Type of Activity                        *
      *                                                               *
      *****************************************************************
     C     SrVldTPAC     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTTPAC'

      ** Inputs

     C                   PARM                    DDTTPAC
     C                   PARM                    DDTTPACOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFTPAC

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldEDIV - Validate Economic Destination of Investment      *
      *                                                               *
      *****************************************************************
     C     SrVldEDIV     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTEDIV'

      ** Inputs

     C                   PARM                    DDTEDIV
     C                   PARM                    DDTEDIVOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFEDIV

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldCLRL - Validate Client Role CR                          *
      *                                                               *
      *****************************************************************
     C     SrVldCLRL     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTCLRL'

      ** Inputs

     C                   PARM                    DDTCLRL
     C                   PARM                    DDTCLRLOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFCLRL

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldLNIT - Validate Line Item of Usura Report               *
      *                                                               *
      *****************************************************************
     C     SrVldLNIT     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTLNIT'

      ** Inputs

     C                   PARM                    DDTLNIT
     C                   PARM                    DDTLNITOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFLNIT

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldACST - Validate Account Status CR                       *
      *                                                               *
      *****************************************************************
     C     SrVldACST     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTACST'

      ** Inputs

     C                   PARM                    DDTACST
     C                   PARM                    DDTACSTOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFACST

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldCATC - Validate Category Code CR                        *
      *                                                               *
      *****************************************************************
     C     SrVldCATC     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTCATC'

      ** Inputs

     C                   PARM                    DDTCATC
     C                   PARM                    DDTCATCOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFCATC

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldTEGL - Validate Effecive Global Rate                    *
      *                                                               *
      *****************************************************************
     C     SrVldTEGL     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTTEGL'

      ** Inputs

     C                   PARM                    DDTTEGL
     C                   PARM                    DDTLNIT
     C                   PARM                    DDTTEGLOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFTEGL

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldUNDT - Validate Scaduto Deal                            *
      *                                                               *
      *****************************************************************
     C     SrVldUNDT     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTUNDT'

      ** Inputs

     C                   PARM                    DDTUNDT
     C                   PARM                    PBJDFIN
     C                   PARM                    DDTUNDTOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFUNDT

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldPSAM - Validate Quota Aggiuntiva Altrui                 *
      *                                                               *
      *****************************************************************
     C     SrVldPSAM     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTPSAM'

      ** Inputs

     C                   PARM                    DDTPSAM
     C                   PARM                    A6NBDP
     C                   PARM                    DDTPSAMOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFPSAM

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVldLEAD - Validate Capofila                                *
      *                                                               *
      *****************************************************************
     C     SrVldLEAD     BEGSR

      ** Reset variables updated by validation

     C                   EXSR      RESETERRS

      ** Validate Field

     C                   CALLB     'LEVTLEAD'

      ** Inputs

     C                   PARM                    DDTLEAD
     C                   PARM                    DDTLEADOK

      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFLEAD

      ** Update error info with that returned from the validation
      ** module

     C                   EXSR      UPDATERRS

     C                   ENDSR
      *****************************************************************                    LUC139
      /EJECT                                                                               LUC139
      *****************************************************************                    LUC139
      *                                                               *                    LUC139
      *  SrVldPTRP - Validate Priority Risk Code Product              *                    LUC139
      *                                                               *                    LUC139
      *****************************************************************                    LUC139
     C     SrVldPTRP     BEGSR                                                             LUC139
                                                                                           LUC139
      ** Reset variables updated by validation                                             LUC139
                                                                                           LUC139
     C                   EXSR      RESETERRS                                               LUC139
                                                                                           LUC139
      ** Validate Field                                                                    LUC139
                                                                                           LUC139
     C                   CALLB     'LEVTPTRP'                                              LUC139
                                                                                           LUC139
      ** Inputs                                                                            LUC139
                                                                                           LUC139
     C                   PARM                    DDTPTRP                                   LUC139
     C                   PARM                    DDTPTRPOK                                 LUC139
                                                                                           LUC139
      ** Outputs                                                                           LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                     LUC139
                                                                                           LUC139
     C                   PARM                    FldNamXAr                                 LUC139
     C                   PARM                    MsgIDXAr                                  LUC139
     C                   PARM                    MsgDtaXAr                                 LUC139
                                                                                           LUC139
      ** Warning fields/message IDs/message data (arrays) from/to                          LUC139
      ** caller                                                                            LUC139
                                                                                           LUC139
     C                   PARM                    WFldNmXAr                                 LUC139
     C                   PARM                    WMsgIDXAr                                 LUC139
     C                   PARM                    WMsgDtXAr                                 LUC139
                                                                                           LUC139
     C                   PARM                    VPFPTRP                                   LUC139
                                                                                           LUC139
      ** Update error info with that returned from the validation                          LUC139
      ** module                                                                            LUC139
                                                                                           LUC139
     C                   EXSR      UPDATERRS                                               LUC139
                                                                                           LUC139
     C                   ENDSR                                                             LUC139
      *****************************************************************                    LUC139
      /EJECT                                                                               LUC139
      *****************************************************************                    LUC139
      *                                                               *                    LUC139
      *  SrVldCMPC - Validate Com. Rate Max. Uncovered Balance        *                    LUC139
      *                                                               *                    LUC139
      *****************************************************************                    LUC139
     C     SrVldCMPC     BEGSR                                                             LUC139
                                                                                           LUC139
      ** Reset variables updated by validation                                             LUC139
                                                                                           LUC139
     C                   EXSR      RESETERRS                                               LUC139
                                                                                           LUC139
      ** Validate Field                                                                    LUC139
                                                                                           LUC139
     C                   CALLB     'LEVTCMPC'                                              LUC139
                                                                                           LUC139
      ** Inputs                                                                            LUC139
                                                                                           LUC139
     C                   PARM                    DDTCMPC                                   LUC139
     C                   PARM                    DDTLNIT                                   LUC139
     C                   PARM                    DDTCMPCOK                                 LUC139
                                                                                           LUC139
      ** Outputs                                                                           LUC139
      ** Error fields/message IDs/message data (arrays) from/to caller                     LUC139
                                                                                           LUC139
     C                   PARM                    FldNamXAr                                 LUC139
     C                   PARM                    MsgIDXAr                                  LUC139
     C                   PARM                    MsgDtaXAr                                 LUC139
                                                                                           LUC139
      ** Warning fields/message IDs/message data (arrays) from/to                          LUC139
      ** caller                                                                            LUC139
                                                                                           LUC139
     C                   PARM                    WFldNmXAr                                 LUC139
     C                   PARM                    WMsgIDXAr                                 LUC139
     C                   PARM                    WMsgDtXAr                                 LUC139
                                                                                           LUC139
     C                   PARM                    VPFCMPC                                   LUC139
                                                                                           LUC139
      ** Update error info with that returned from the validation                          LUC139
      ** module                                                                            LUC139
                                                                                           LUC139
     C                   EXSR      UPDATERRS                                               LUC139
                                                                                           LUC139
     C                   ENDSR                                                             LUC139
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR

     C                   EVAL      RetCodeOut = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module                      *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
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
     C                   IF        *IN99 = *ON
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
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

     C                   PARM                    ReturnCode

      ** Transaction Details

     C                   PARM                    PScnDtaItl

      ** Loan Currency

     C                   PARM                    PCCY

      ** Date Format Indicator

     C                   PARM                    PBJDFIN

      ** Outputs
      ** Transaction Details OK inds

     C                   PARM                    OKCLIPItl

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    Idx

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller

     C                   PARM                    WIdx

      ** Valid Transaction details layout (DS) from/to caller

     C                   PARM                    PValidCLIPItl

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module
      /COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
