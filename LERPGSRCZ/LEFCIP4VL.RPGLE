     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facilities Validate - Italian')               *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEFCIP4VL - LE Facilities Validate - Italian                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *           Pool Operazione and SAPE Percentage have been       *
      *           removed from FM2.1 screen source as these are not   *
      *           being displayed at DBA3.                            *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
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
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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

     D NwScnDtaItl   E DS                  Extname(LEFCRXPD)
      ** Transaction Details in screen format

     D OKFCIPItl     E DS                  Extname(LEEFCIT1PD)
      ** Transaction Details OK indicators

     D ValidFCIPItl  E DS                  Extname(LEVFCIT1PD)
      ** Valid Transaction Details layout

     D SDCURR        E DS                  Extname(SDCURRPD)

     D DSFDY         E DS                  Extname(DSFDY)
      **  Short DS for access programs

     D DSSDY         E DS                  Extname(DSSDY)
      **  Long DS for access programs

     D ZMUSER          DS            17
     D  USRBCH                11     13

     D DataItal        DS          1024
     D  DataCCY                1      3
     D  DataBNDCSP             4      5

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D I               S              3P 0

     D Idx             S              3P 0
      ** Index for arrays of of error message ids etc

     D WIdx            S              3P 0
      ** Index for arrays of of warning message ids etc

     D WWEXPO          S             13P 0
     D WWSAPE          S              6S 3 INZ(0)
     D Pcurr           S              3A
     D Prtcd           S              7A
     D Poptn           S              7A

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

     C                   Movel     DataCCY       Pcurr

     C                   Callb     'AOCURRR0'
     C                   Parm      *BLANK        Prtcd
     C                   Parm      '*KEY   '     Poptn
     C                   Parm                    Pcurr
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   If        Prtcd <> *Blanks
     C                   Movel     Pcurr         DBKEY
     C                   Movel     'SDCURRPD'    DBFILE
     C                   Movel     '001'         DBASE
     C                   Exsr      *PSSR
     C                   Endif

     C                   Exsr      SrInit

      ** Validate Stand-by Credit Line Indicator

     C                   Exsr      SrVSBCL

      ** Validate Operation in Pool

     C**********         Exsr      SrVOPPL

      ** Validate Facility Exposure

     C                   Exsr      SrVEXPO

      ** Validate Operating Entity

     C                   Exsr      SrVDECD

      ** Validate Cover SACE

     C                   Exsr      SrVSACO

      ** Validate Percentage SACE

     C**********         Exsr      SrVSAPE

      ** If no errors set up outstanding fields for valid file

     C                   If        Idx = 0
     C                   Exsr      SrSetup
     C                   Endif

     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVSBCL - Validate Stand-by Credit Line Indicator            *
      *                                                               *
      *****************************************************************
     C     SrVSBCL       Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'LEVSBCL'
     C                   Parm                    ReturnCode

     C                   Parm                    LITSBCL

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Parm                    LITSBCLOK

     C                   Exsr      SrUpdaterrs

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVOPPL - Validate Operation in Pool                         *
      *                                                               *
      *****************************************************************
     C     SrVOPPL       Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'LEVOPPL'
     C                   Parm                    ReturnCode

     C                   Parm                    LITOPPL

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Parm                    LITOPPLOK

     C                   Exsr      SrUpdaterrs

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVEXPO - Validate Facility Exposure                         *
      *                                                               *
      *****************************************************************
     C     SrVEXPO       Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'LEVEXPO'
     C                   Parm                    ReturnCode

     C                   Parm                    LITEXPO
     C                   Parm                    WWEXPO
     C                   Parm                    A6NBDP

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Parm                    LITEXPOOK

     C                   Exsr      SrUpdaterrs

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVDECD - Validate Operating Entity                          *
      *                                                               *
      *****************************************************************
     C     SrVDECD       Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'LEVDECD'
     C                   Parm                    ReturnCode

     C                   Parm                    LITDECD

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Parm                    LITDECDOK

     C                   Exsr      SrUpdaterrs

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVSACO - Validate Cover SACE                                *
      *                                                               *
      *****************************************************************
     C     SrVSACO       Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'LEVSACO'
     C                   Parm                    ReturnCode

     C                   Parm                    LITSACO

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Parm                    LITSACOOK

     C                   Exsr      SrUpdaterrs

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVSAPE - Validate Percentage SACE                           *
      *                                                               *
      *****************************************************************
     C     SrVSAPE       Begsr

     C                   Exsr      SrResetErrs

     C                   CallB     'LEVSAPE'
     C                   Parm                    ReturnCode

     C                   Parm                    LITSAPE
     C                   Parm                    WWSAPE
     C                   Parm                    LITSACO
     C                   Parm                    DataBNDCSP

     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr

     C                   Parm                    LITSAPEOK

     C                   Exsr      SrUpdaterrs

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetup - Set up additional fields that are needed on the    *
      *            Valid file record                                  *
      *                                                               *
      *****************************************************************
     C     SrSetup       Begsr

     C                   Move      LITSBCL       VPRSBCL
     C                   Move      LITOPPL       VPROPPL
     C                   Move      WWEXPO        VPREXPO
     C                   Move      LITDECD       VPRDECD
     C                   Move      LITSACO       VPRSACO
     C                   Move      WWSAPE        VPRSAPE

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetErrs - Reset error information that is received       *
      *                back from each validation module               *
      *                                                               *
      *****************************************************************
     C     SrResetErrs   Begsr

     C                   Eval      ReturnCode = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   Eval      FldNamXAr = *BLANK
     C                   Eval      MsgIDXAr  = *BLANK
     C                   Eval      MsgDtaXAr = *BLANK
     C                   Eval      WFldNmXAr = *BLANK
     C                   Eval      WMsgIDXAr = *BLANK
     C                   Eval      WMsgDtXAr = *BLANK

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdaterrs - Update error information with that received    *
      *                back from each validation module               *
      *                                                               *
      *****************************************************************
     C     SrUpdaterrs   Begsr

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-Add     1             I
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   If        *IN99
     C                   MoveA     FldNamXAr     FlDNameArr(I)
     C                   MoveA     MsgIDXAr      MsgIdArr(I)
     C                   MoveA     MsgDtaXAr     MsgDtaArr(I)
     C                   Endif

      ** Set Error Index

     C                   Z-Add     1             I
     C     *Blank        Lookup    FldNameArr(I)                          99
     C     I             Sub       1             Idx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-Add     1             I
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   If        *IN99
     C                   MoveA     WFldNmXAr     WFldNamArr(I)
     C                   MoveA     WMsgIDXAr     WMsgIDArr(I)
     C                   MoveA     WMsgDtXAr     WMsgDtaArr(I)
     C                   Endif

      ** Set Warning Index

     C                   Z-Add     1             I
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
     C     SrInit        Begsr

     C                   Clear                   ValidFCIPItl

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *Inzsr        Begsr

     C     *Entry        Plist

     C                   Parm                    DataItal
     C                   Parm                    NwScnDtaItl
     C                   Parm                    OkFCIPItl

     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx

     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx

     C                   Parm                    ValidFCIPItl

      **---------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
