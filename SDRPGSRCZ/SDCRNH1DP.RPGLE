     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - CRS Detail')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCRNH1DP - Non-Account Holder - CRS Detail                  *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD036356           Date 02Nov15               *
      *  Prev Amend No. CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036356 - Multiple NAHO FATCA fields does not default values*
      *            from Main NAHO/CRS Details                         *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** Midas SD Non-Account Holder - CRS Validation
     FSDCRNH1DDFCF   E             WORKSTN INFSR(*PSSR)
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
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
      /COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      /COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      /COPY ZACPYSRC,MSGHNDDCL
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

     D SDCRNH        E DS                  EXTNAME(SDCRNSPD)
     D OKCRNH        E DS                  EXTNAME(SDECRNHPD)

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
     D @EINKF          S              1
     D @EINKH          S              1
     D @INKC           S              1
     D @INKH           S              1
     D @INKL           S              1
     D @INKT           S              1                                                     MD036356

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

     C                   MOVEA     OKCRNH        @EI

      ** Set screen error indicator according to status of 'OK' flag.

     C                   Z-ADD     1             C
     C                   Z-ADD     10            E

     C     C             DOUGT     60

     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     *ON           *IN(E)
     C                   ENDIF

     C                   ADD       1             C
     C                   ADD       1             E

     C                   ENDDO

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      /COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------

      ** Enable function keys.

     C                   IF        DDACTR = 'E'
     C                   EVAL      *IN71 = '1'
     C                   ELSE
     C                   EVAL      *IN71 = '0'
     C                   ENDIF

      ** Write message subfile, key details and footer screen.

     C                   TIME                    DDTIME

     C                   WRITE     SDCRNHM0
     C                   WRITE     SDCRNHD1
     C                   WRITE     SDCRNHF1

      ** Read details screen, if not write only

     C     WriteOnly     IFNE      'Y'
     C                   READ      SDCRNHD1                               99
     C                   ENDIF

      ** Set screen error indicators off.

     C                   MOVEA     @Z0           *IN(10)

      ** Set return keys.

     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
     C                   MOVE      *INKT         @INKT                                      MD036356

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
     C                   PARM                    SDCRNH
     C                   PARM                    OKCRNH
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
     C                   PARM                    @INKT                                      MD036356
     C                   PARM                    WriteOnly

      ** Initialize program name.

     C                   MOVEL     'SDCRNH1DP'   DBPgm

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
      ** SRERR - Exception Errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDCRNH1DP'   Dbpgm
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
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Finastra International Limited 2015
