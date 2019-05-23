     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS country details')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCRSN2DP - Midas SD CRS country details                     *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CSD102             Date 08Jan19               *
      *  Prev Amend No. MD036274           Date 21Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD036274 - Local TIN validation changes (Recompile)          *
      *  CGL157 - CRS Reporting (Recompile)                           *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Midas SD CRS Country Details
     FSDCRSN2DDFCF   E             WORKSTN INFSR(*PSSR)
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

     D OKCRSCtry     E DS                  EXTNAME(SDECRSNPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D @INKC           S              1A
     D @INKL           S              1A

     D PRtCd           S              7A
     D POptn           S              7A
     D DFCTRY          S              2A
     D QRYFLD          S              2A
     D Prtn            S              7A
     D DDNAHO          S             10A

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

      ** Set screen error indicator according to status of 'OK' flag.
     C     DDCTRYOK      COMP      'N'                                    62

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

     C                   EVAL      DDNAHL = DDNAHO

      ** Write message subfile, key details and footer screen.

     C                   TIME                    DDTIME

     C                   WRITE     SDCRN2M0
     C                   WRITE     SDCRN2D1
     C                   WRITE     SDCRN2F1
     C                   WRITE     SDCRN2D2
     C                   EXFMT     SDCRN2D2

     C                   MOVEL     DDCTRY        QRYFLD
     C                   IF        QRYFLD = '? '
     C                             OR QRYFLD = ' ?'
     C                   CALL      'SD0180S'
     C                   PARM                    Prtn
     C                   PARM                    DDCTRY
     C                   ENDIF

      ** Set screen error indicators off.

     C                   SETOFF                                       62

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
      ** CRS Country Details - Screen Format
      ** Fields in Error
      ** Errors
      ** Warnings

     C                   PARM                    RetCodeIn
     C                   PARM                    DDNAHO
     C                   PARM                    OKCRSCtry
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Output Parameters :

     C                   PARM                    @INKC
     C                   PARM                    @INKL
     C                   PARM                    DDCTRY

      ** Initialize program name.

     C                   MOVEL     'SDCRSN2DP'   DBPgm

      ** Move user and workstation ID to screen fields.

     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID

     C                   MOVE      *ON           *IN94
     C                   MOVE      *ON           *IN97
     C                   MOVEL     '*'           DDPGMQ

      ** Access bank details.

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        PRtCd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   MOVEL     '101'         DBase
     C                   MOVEL     POptn         DBKey
     C                   EXSR      *PSSR
     C                   ENDIF

      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY SDCPYSRC,MSGHNDDATA

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
