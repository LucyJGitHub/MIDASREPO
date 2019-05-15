     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Depot movement second display')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Module                                    *
      *                                                               *
      *  SEDPMV2DP - SE Depot Movement Second Display                 *
      *                                                               *
      *  Function:  This module displays the second screen for Depot  *
      *             Movement                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CSE012  *CREATE    Date 16Aug99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE012 - SE Depot Movement Narratives                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEDPMV2DF CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
      *****************************************************************
      *                                                               *
      * FUNCTION OF INDICATORS                                        *
      *                                                               *
      *  30 - Protect Narrative Fields                                *
      *                                                               *
      *  71 - Enable F07                                              *
      *  72 - Enable F08                                              *
      *  74 - Enbale F14                                              *
      *  75 - Enable F15                                              *
      *                                                               *
      *  99 - READ indicator                                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **------------------------------------------------------------------------
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **------------------------------------------------------------------------
 
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      ** Main processing
      *
      ** Reset Error Indicators
      *
     C                   Move      *Blanks       MsgIdArr
      *
     C     DDACTN        IFEQ      'E'
     C     @EDTFD        ORNE      'Y'
     C                   MOVE      *ON           *IN30
     C                   ELSE
     C                   MOVE      *OFF          *IN30
     C                   ENDIF
      *
      ** Enable function Keys
      *
     C     @EINKG        IFEQ      'Y'
     C                   Move      *On           *IN71
     C                   Else
     C                   Move      *Off          *IN71
     C                   ENDIF
      *
     C     @EINKH        IFEQ      'Y'
     C                   Move      *On           *IN72
     C                   Else
     C                   Move      *Off          *IN72
     C                   ENDIF
      *
     C     @EINKN        IFEQ      'Y'
     C                   Move      *On           *IN74
     C                   Else
     C                   Move      *Off          *IN74
     C                   ENDIF
      *
     C     @EINKP        IFEQ      'Y'
     C                   Move      *On           *IN75
     C                   Else
     C                   Move      *Off          *IN75
     C                   ENDIF
      *
      ** Write New Screen
      *
      /COPY ZACPYSRC,MSGHNDDSP1
     C                   Write     SEDMV2C0
     C                   Write     SEDMV2F1
      *
     C     WriteOnly     IFNE      'Y'
     C                   Read      SEDMV2F1                               99
     C                   Endif
      *
     C                   Movel     *INKC         @INKC
     C                   Movel     *INKG         @INKG
     C                   Movel     *INKH         @INKH
     C                   Movel     *INKL         @INKL
     C                   Movel     *INKN         @INKN
     C                   Movel     *INKP         @INKP
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Input Parameters
      ** Return Code
      ** Action Code
      ** Security Shortname
      ** Reference
      ** Narrative 2
      ** Narrative 3
      ** Narrative 4
      ** Narrative 5
      *
     C                   PARM                    RetrnCod          6
     C                   PARM                    DDACTN            1
     C                   PARM                    DDDPSS           10
     C                   PARM                    DDDPRN            6
     C                   PARM                    Narr2            35
     C                   PARM                    Narr3            35
     C                   PARM                    Narr4            35
     C                   PARM                    Narr5
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key & Detail Fields
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KN = Command Key 14 = Settlement Details
      ** KP = Command Key 15 = Browse
      *
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
      *
      ** Output Parameters
      ** Function Keys
      *
     C                   PARM                    @INKC             1
     C                   PARM                    @INKG             1
     C                   PARM                    @INKH             1
     C                   PARM                    @INKL             1
     C                   PARM                    @INKN             1
     C                   PARM                    @INKP             1
     C                   PARM                    WriteOnly
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEDPMV2DP'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsUser        ##USR
     C                   MOVEL     PsJobName     ##JOB
     C                   MOVEL     BJMRDT        ##MRDT
     C*                  MOVEL     TIME          ##TME
      *
      ** Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
 
      **------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
