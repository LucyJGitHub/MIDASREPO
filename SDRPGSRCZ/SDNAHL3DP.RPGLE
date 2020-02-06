     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - TIN Validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNAHL3DP - Non-Account Holder - TIN Validation              *
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

      ** Midas SD Non-Account Holder - TIN Validation
     FSDNAHL3DDFCF   E             WORKSTN INFSR(*PSSR)
     F

      ** Table of Field Numbers & Names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
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

     D @Z0             S              1    DIM(60) CTDATA PERRCD(60)
     D @EI             S              1    DIM(60)

     D SDNAHL        E DS                  EXTNAME(SDNAHLPD)
     D OKNahl        E DS                  EXTNAME(SDENAHLPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D @EKYFD          S              1
     D @EDTFD          S              1
     D @EINKG          S              1
     D @EINKH          S              1
     D @INKC           S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKL           S              1

     D C               S              2P 0
     D E               S              2P 0
     D Retcd           S              7
     D Option          S              7

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      ****************************************************************
      /EJECT
      ****************************************************************
      ** +--- Start of Main processing ------------------------------+
      ** ¦                                                           ¦
      ** ¦ Initial processing is performed automatically: *INZSR is  ¦
      ** ¦ executed at program activation.                           ¦
      ** ¦                                                           ¦
      ** +-----------------------------------------------------------+

      ** Main Processing

     C                   EXSR      SRMain

     C     @INKC         IFEQ      *ON
     C                   EVAL      *INLR = *ON
     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRMain - Main processing
      *****************************************************************
     C     SRMain        BEGSR

     C     OKTIN2        COMP      'N'                                    10
     C     OKCTIN2       COMP      'N'                                    11
     C     OKTIN3        COMP      'N'                                    12
     C     OKCTIN3       COMP      'N'                                    13
     C     OKTIN4        COMP      'N'                                    14
     C     OKCTIN4       COMP      'N'                                    15
     C     OKTIN5        COMP      'N'                                    16
     C     OKCTIN5       COMP      'N'                                    17
     C     OKTIN6        COMP      'N'                                    18
     C     OKCTN6        COMP      'N'                                    19
     C     OKTIN7        COMP      'N'                                    20
     C     OKCTN7        COMP      'N'                                    21
     C     OKTIN8        COMP      'N'                                    22
     C     OKCTN8        COMP      'N'                                    23
     C     OKTIN9        COMP      'N'                                    24
     C     OKCTN9        COMP      'N'                                    25
     C     OKTIN0        COMP      'N'                                    26
     C     OKCTN0        COMP      'N'                                    27
     C     OKEFF1        COMP      'N'                                    28
     C     OKEFF2        COMP      'N'                                    29
     C     OKEFF3        COMP      'N'                                    30
     C     OKEFF4        COMP      'N'                                    31
     C     OKEFF5        COMP      'N'                                    32
     C     OKEFF6        COMP      'N'                                    33
     C     OKEFF7        COMP      'N'                                    34
     C     OKEFF8        COMP      'N'                                    35
     C     OKEFF9        COMP      'N'                                    36
     C     OKEFF0        COMP      'N'                                    37
     C     OKEXP1        COMP      'N'                                    38
     C     OKEXP2        COMP      'N'                                    39
     C     OKEXP3        COMP      'N'                                    40
     C     OKEXP4        COMP      'N'                                    41
     C     OKEXP5        COMP      'N'                                    42
     C     OKEXP6        COMP      'N'                                    43
     C     OKEXP7        COMP      'N'                                    44
     C     OKEXP8        COMP      'N'                                    45
     C     OKEXP9        COMP      'N'                                    46
     C     OKEXP0        COMP      'N'                                    47

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Enable function keys.

     C                   IF        DDACTN = 'E'
     C                   EVAL      *IN71 = '1'
     C                   ELSE
     C                   EVAL      *IN71 = '0'
     C                   ENDIF

      ** Write message subfile, key details and footer screen.

     C                   TIME                    DDTIME

     C                   WRITE     SDNAHOM0
     C                   WRITE     SDNAHOD1
     C                   WRITE     SDNAHOF1

      ** Read details screen, if not write only

     C     WriteOnly     IFNE      'Y'
     C                   READ      SDNAHOD1                               99
     C                   ENDIF

      ** Set screen error indicators off.

     C                   MOVEA     @Z0           *IN(10)

      ** Set return keys.

     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL

     C                   ENDSR

      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2

      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR

      ** Entry Parameters

     C     *ENTRY        PLIST

      ** Input Parameters :

      ** Return Code
      ** Additional Customer Details - Screen Format
      ** Fields in Error
      ** Errors
      ** Warnings
      ** Enabled Key Fields
      ** Enabled Detail Field

     C                   PARM                    RetCodeIn
     C                   PARM                    SDNAHL
     C                   PARM                    OKNahl
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Output Parameters :

      ** Function Keys
      ** Write screen with no read indicator

     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    WriteOnly

      ** Initialize program name.

     C                   MOVEL     'SDNAHL3DP'   DBPgm

      ** Access Bank details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
     C                   ENDIF

      ** Move user and workstation ID to screen fields.

     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID

     C                   MOVE      *ON           *IN94
     C                   MOVEL     '*'           DDPGMQ

      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY SDCPYSRC,MSGHNDDATA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDNAHL3DP'   Dbpgm
     C                   MOVE      *On           *InU7
     C                   MOVE      *On           *InU8
     C                   MOVE      *On           *InLR

     C                   DUMP

      **  Terminte the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Finastra International Limited 2015
