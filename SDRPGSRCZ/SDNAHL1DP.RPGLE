     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Non-Account Holder - Prompt Screen')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDNAHL1DP - Non-account Holder Display - Key Screen          *
      *                                                               *
      *  Function:  This module displays the KEY details screen       *
      *             of the Non-account holder details screen          *
      *             input function.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 232543             Date 31Mar05               *
      *                 CGL032  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL032 - Automatic Exchange of Information.                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDNAHL1DDFCF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      **                                                               *
      ** ID F  C  H  L    FUNCTION OF INDICATORS                       *
      **                                                               *
      **     10-59 Field Error - highlight screen fields               *
      **       71  Condition function key F7 (read previous)           *
      **       72  Condition function key F8 (read next)               *
      **       97  Subfile end                                         *
      **       99  Read error                                          *
      ********************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ AutomatiCALLy included D-specs       ¦
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
 
     D NaPrim        E DS                  EXTNAME(SDNAHLPD)
     D OKNaPrim      E DS                  EXTNAME(SDENAHLPD)
 
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
 
      ** Entry Parameter Fields
     D @EKYFD          S              1
     D @EDTFD          S              1
     D @EINKG          S              1
     D @EINKH          S              1
     D @INKC           S              1
     D @INKG           S              1
     D @INKH           S              1
     D @INKL           S              1
 
     D RetCode         S              7
     D Opt             S              7
     D C               S              2  0
     D E               S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the             ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Main processing
 
     C                   EXSR      SRMain
 
      ** Return
 
     C     @INKC         IFEQ      *On
     C                   EVAL      *InLR = *On
     C                   END
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRMain - Main processing
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   MOVEA     OKNaPrim      @EI
 
      ** Set screen error indicator accdg to status of 'OK' flag
 
     C                   Z-ADD     1             C
     C                   Z-ADD     10            E
 
     C     C             DOUGT     60
 
     C     @EI(C)        IFEQ      'N'
     C     @EI(C)        OREQ      'W'
     C                   MOVEL     *On           *IN(E)
     C                   ENDIF
 
     C                   ADD       1             C
     C                   ADD       1             E
 
     C                   ENDDO
 
      ** Set up the Non-A/C Holder Reference to be used by the message handler
 
     C                   EVAL      TranRef = DDNAHO
     C                   EVAL      ActionCode = 'I'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
      ** Enable function keys
 
     C     @EINKG        COMP      'Y'                                    71
     C     @EINKH        COMP      'Y'                                    72
 
      ** Write message subfile, key details and footer screen
 
     C                   TIME                    DDTIME
 
     C                   WRITE     SDNAHLKS0
     C                   WRITE     SDNAHLKD1
     C                   WRITE     SDNAHLKF1
 
     C                   READ      SDNAHLKD1                              99
 
      ** Clear message subfile
 
      ** Set screen error indicator off
 
     C                   MOVEA     @Z0           *In(10)
 
      ** Set return keys
 
     C                   MOVE      *InKC         @INKC
     C                   MOVE      *InKG         @INKG
     C                   MOVE      *InKH         @INKH
     C                   MOVE      *InKL         @INKL
 
     C                   ENDSR
      ****************************************************************
 
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Initial Processing
      *****************************************************************
     C     *Inzsr        BEGSR
 
      ** Parameters
 
     C     *Entry        PLIST
 
      ** Input Parameters :
 
      ** Return code
      ** Non-A/C Holder (IN SCREEN FORMAT - Key)
      ** Fields in Error
      ** Errors
      ** Warnings
      ** Enabled Key Fields
      ** Enabled Detail Fields
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
 
     C                   PARM                    RetCodeIn
     C                   PARM                    NaPrim
     C                   PARM                    OKNaPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
 
      ** Output Parameters :
 
      ** Function Keys
      ** Write screen with no read indicator
 
     C                   PARM                    @INKC
     C                   PARM                    @INKG
     C                   PARM                    @INKH
     C                   PARM                    @INKL
     C                   PARM                    WriteOnly
 
 
      ** Initialize program name
 
     C                   MOVEL     'SDNAHL1DP'   Dbpgm
 
      ** Move user and workstation ID to screen fields.
 
     C                   MOVEL     PsUser        Dduser
     C                   MOVEL     PsJobName     Ddwid
 
     C                   MOVE      *On           *In97
     C                   MOVEL     '*'           Ddpgmq
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       RetCode
     C                   PARM      '*FIRST '     Opt
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '901'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
     C                   ENDIF
 
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
 
     C                   MOVEL     'SDNAHL1DP'   Dbpgm
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
**  CPY@
(c) Finastra International Limited 2004
** @Z0
000000000000000000000000000000000000000000000000000000000000
