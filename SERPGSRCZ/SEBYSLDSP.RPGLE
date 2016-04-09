     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Buy-Sell Backs Display')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEBYSLDSP - SECURITIES BUY-SELL BACKS DISPLAY                *
      *                                                               *
      *  Function:  This module displays the screen of the            *
      *             securites buy-sell backs input function.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 233708             Date 02Jun05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE006  *CREATE    Date 20May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  233708 - Addition of Fiscal Price fields for CGL031          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE006 - Repurchase Agreements (REPOs) enhancement           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSEBYSLDF  CF   E             WORKSTN
 
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
 
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *     10-30 Field Error - highlight screen fields               *
      *                                                               *                       233708
      *       32  Field Error - Sale Fiscal Price                     *                       233708
      *       33  Field Error - Buy  Fiscal Price                     *                       233708
      *                                                               *
      *       60  Protect Booking Branch (multibranching off)         *
      *       61  Protect Originating Branch                          *
      *       62  Protect Profit Centre                               *
      *       63  Protect all Buy-Sell detail fields                  *
      *                                                               *                       233708
      *       67  CGL031 OFF                                          *                       233708
      *                                                               *
      *       96  Message subfile control                             *
      *       97  Message subfile end                                 *
      *                                                               *
      *       99  READ indicator                                      *
      *                                                               *
      ********************************************************************
      /EJECT
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
 
     D NwBSScnFmt    E DS                  EXTNAME(SEBSTRPD)
     D OKBuySell     E DS                  EXTNAME(SEEBSTRPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank details
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for General Ledger details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CAP004
 
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
      *
      * If security is not interest bearing, never display the Interest
      * fields.  Only display the Interest, Value and Implied Repo Rate
      * fields after enter has been pressed once (i.e. WriteOnly = 'Y').
     C                   IF        PROT = '2' or PROT = '4'
     C                             or PROT = '7'
     C                   MOVE      '1'           *IN65
      *
     C                   IF        WriteOnly = 'Y'
     C                   MOVE      '0'           *IN66
     C                   ELSE
     C                   MOVE      '1'           *IN66
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        WriteOnly = 'Y'
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C                   ELSE
     C                   MOVE      '1'           *IN65
     C                   MOVE      '1'           *IN66
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Main processing
      *
     C                   EXSR      MAIN
      *
      * Return
      *
     C                   IF        @INKC = '1'
     C                   EVAL      *INLR = *On
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN processing
      *****************************************************************
     C     MAIN          BEGSR
      *
      * Move 'OK' flags into array (for checking)
      *
     C                   MOVEA     OKBuySell     @EI
      *
      * Set screen error indicators according to status of 'OK' flags
      *
     C                   Z-ADD     1             C                 2 0
     C                   Z-ADD     10            E                 2 0
      *
     C                   DOU       C > 60
 
     C                   IF        @EI(C) = 'N' or @EI(C) = 'W'
     C                   MOVEL     '1'           *IN(E)
     C                   ENDIF
 
     C                   ADD       1             C
     C                   ADD       1             E
     C                   ENDDO
 
 
      ** Set up the action code to be used by the message handler
     C                   EVAL      ActionCode = 'I'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes processing for the error and
      ** warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP1
      **--------------------------------------------------------------------------------------------
 
 
      * Enable detail fields
      *
     C                   IF        WriteOnly = 'Y'
     C                   EVAL      *IN63 = *On
     C                   ENDIF
      *
      * Write message subfile, details and footer screen
      *
     C                   TIME                    DDTIME
     C                   WRITE     SEBYSLS0
     C                   WRITE     SEBYSLD1
     C                   WRITE     SEBYSLF1
      *
      * Read detail screen (still do this if write only - when screen is
      * displayed for secon time, must wait for Enter to be pressed)
      *
     C                   READ      SEBYSLD1                               99
      *
      * Clear message subfile
      *
     C                   CALL      'ZA0250'
      *
      * Set screen error indicators off
      *
     C                   MOVEA     @Z0           *IN(10)
      *
      * Set return keys
      *
     C                   MOVE      *INKC         @INKC             1
      *
     C                   ENDSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **--------------------------------------------------------------------------------------------
 
      ********************************************************************
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
      * INPUT PARAMETERS :
      * Return code
     C                   PARM                    RetCodeIn
      *
      * Buy-Sell Back (IN SCREEN FORMAT)
     C                   PARM                    NwBSScnFmt
      *
      * Message containing name of submitted job
     C                   PARM                    JobMessage
      *
      * Fields in error
     C                   PARM                    OKBuySell
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * Enabled Detail fields
     C                   PARM                    @EDTFD            1
      *
      * Processing Type of security
     C                   PARM                    PROT              1
      *
      * OUTPUT PARAMETERS :
      * Function Key - F3
     C                   PARM                    @INKC             1
      * Write screen with no read indicator
     C                   PARM                    WriteOnly         1
      * Feature CGL031                                                                        233708
     C                   PARM                    CGL031            1                          233708
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SEBYSLDSP'   DBPGM
      *
      ** Move user and workstation ID to screen fields.
      *
     C                   MOVEL     PsUser        DDUSER
     C                   MOVEL     PsJobName     DDWID
      *
      ** Access Bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '106'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '102'         DBASE
     C                   MOVEL     '*FIRST '     DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Message subfile control
      *
     C                   MOVE      '1'           *IN97
     C                   MOVEL     '*'           DDPGMQ
      *
      * SET SCREEN PROTECT/NON-DISPLAY INDICATORS
      *
      * Single-branching (protect booking branch)
     C     BJSBRC        IFNE      *BLANK
     C                   MOVE      '1'           *IN60
     C                   ENDIF
      *
      * If Originating Branch is not used and Single Branch Code is not
      * blank, protect the Originating Branch
     C                   IF        BKOBRU <> 'Y' and BJSBRC <> *Blanks
     C                   MOVE      '1'           *IN61
     C                   ENDIF
      *
      * If Profit Centres are not used, protect the Profit Centre field
     C                   IF        BKPRCU <> 'Y'
     C                   MOVE      '1'           *IN62
     C                   ENDIF
      *
      * If Originating Used flag is not 'Y', protect & non-dsp. that field
     C                   IF        BKOBRU <> 'Y'
     C                   MOVE      '1'           *IN64
     C                   ENDIF
      *                                                                                       233708
      * If CGL031 is ON                                                                       233708
     C                   IF        CGL031 <> 'Y'                                              233708
     C                   MOVE      '1'           *IN66                                        233708
     C                   ELSE                                                                 233708
     C                   MOVE      '0'           *IN66                                        233708
     C                   ENDIF                                                                233708
      *
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SE *DSP
      ** functions for the message handler, ZAMSGHNDLE.
     D/COPY SECPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
 
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
(c) Misys International Banking Systems Ltd. 2001
** @Z0
000000000000000000000000000000000000000000000000000000000000
