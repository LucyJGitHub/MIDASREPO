     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer - ext screen 5')          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACUD5DP - Additional Customer Details - Ext Screen 5       *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL132  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      ** Midas SD Additional Customer Details - Screen 5
     FSDACUD5DDFCF   E             WORKSTN INFSR(*PSSR)
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
 
     D AcPrim        E DS                  EXTNAME(SDACUDPD)
     D AcExt5        E DS                  EXTNAME(SDACU5DPD)
     D OKAcExt5      E DS                  EXTNAME(SDEACU5PD)
 
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
     D @EKYFD          S              1
     D @EDTFD          S              1
     D @EINKG          S              1
     D @EINKH          S              1
     D @INKC           S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKL           S              1
 
     D PRtCd           S              7A
     D POptn           S              7A
     D C               S              2P 0
     D E               S              2P 0
 
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
 
     C                   MOVEA     OKAcExt5      @EI
 
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
 
      ** Set up the Customer Number to be used by the message handler.
 
     C                   EVAL      TranRef = DDCUST
     C*                  EVAL      ActionCode = 'I'
 
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
 
 
     C                   WRITE     SDACUDM0
     C                   WRITE     SDACUDD5
     C                   WRITE     SDACUDF1
 
     C                   EXFMT     SDACUDD5
 
      ** Clear message subfile.
 
      ** Set screen error indicators off.
 
     C                   MOVEA     @Z0           *IN(10)
 
      ** Set return keys.
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKG         @INKG
     C                   MOVE      *INKH         @INKH
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
      ** Enabled Detail Fields
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
 
     C                   PARM                    RetCodeIn
     C                   PARM                    AcPrim
     C                   PARM                    AcExt5
     C                   PARM                    OKAcExt5
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EDTFD
 
      ** Output Parameters :
 
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM                    @INKC
     C                   PARM                    @INKG
     C                   PARM                    @INKH
     C                   PARM                    @INKL
 
      ** Initialize program name.
 
     C                   MOVEL     'SDACUD5DP'   DBPgm
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
 
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
(c) Finastra International Limited 2013
